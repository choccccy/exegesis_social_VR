using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace Exegesis.NchoEyes
{
    /// <summary>
    /// Bakes ncho's LED eye map: one texel per LED texel, carrying which chevron it belongs
    /// to, the blink frame at which it goes dark, and its column index along the strip. The
    /// eye shader does all of its logic from this one point-sampled lookup.
    ///
    /// Sources (read as raw PNG bytes, so their import settings don't matter):
    ///   - ncho_eye_glow_mask.png  — which texels are LEDs (R &gt; 0.5). Equal to blink frame 0.
    ///   - ncho_eye_blink_mask.png — the old spritesheet. Frame k (0 open .. 5 closed) is the
    ///     LED region shifted up by 16k rows. White = lit.
    ///
    /// Encoding: each channel stores a small integer n as the byte n * 8 (decode with
    /// round(v * 255 / 8)). Non-LED texels are all zero; every LED texel is non-zero in all
    /// four channels, so no channel is ever a "transparent" zero that a paint tool might eat.
    ///   R = chevron id + 1: 1 tex-left rear, 2 tex-left front, 3 tex-right rear, 4 tex-right front
    ///   G = off frame: first blink frame (1..5) where the LED is dark; 6 = never dark
    ///   B = texel-column index from the chevron's texture-left end + 1
    ///   A = texel-column index from the chevron's texture-right end + 1
    /// Plus a blink-profile block in the top-left corner (see Encode), so gaze Y can shift the
    /// blink window along the strip.
    ///
    /// The UV island is rotated: texture-down is face-forward, so in each texture half the
    /// chevron lower in the texture (larger top-down row) is the FRONT one. See docs/ncho-eyes.md.
    /// </summary>
    public static class NchoEyeLedMapBaker
    {
        public const string GlowMaskPath = "Assets/_exegesis/ncho/ncho_tex/ncho_eye_glow_mask.png";
        public const string BlinkSheetPath = "Assets/_exegesis/ncho/ncho_tex/ncho_eye_blink_mask.png";
        public const string LedMapPath = "Assets/_exegesis/ncho_eyes/ncho_eye_led_map.png";
        public const string ShaderName = "Exegesis/ncho LED Eyes (proto)";

        public const int FrameHeight = 16;
        public const int FrameCount = 6; // 0 = open .. 5 = closed
        public const int ChannelStep = 8;
        public const int LedWidth = 2;   // each LED is 2 texels wide, even-aligned
        public const int ProfileWidth = 32; // blink-profile row length (texel columns per chevron, max)

        public enum Chevron { TexLeftRear = 0, TexLeftFront = 1, TexRightRear = 2, TexRightFront = 3 }

        public struct LedTexel
        {
            public int X, Row; // Row is top-down, as in an image editor
            public Chevron Chevron;
            public int OffFrame;
            public int IndexFromLeft, IndexFromRight;
        }

        /// <summary>Top-down RGBA image, so row numbers match Aseprite and the docs.</summary>
        public sealed class Image
        {
            public readonly int Width, Height;
            readonly Color32[] _pixels; // Unity order: bottom-up

            public Image(int width, int height, Color32[] bottomUpPixels)
            {
                Width = width; Height = height; _pixels = bottomUpPixels;
            }

            public Color32 Get(int x, int row) => _pixels[(Height - 1 - row) * Width + x];

            public static Image Load(string assetPath)
            {
                var tex = new Texture2D(2, 2, TextureFormat.RGBA32, false, true);
                try
                {
                    if (!tex.LoadImage(File.ReadAllBytes(assetPath)))
                        throw new IOException($"Could not decode {assetPath}");
                    return new Image(tex.width, tex.height, tex.GetPixels32());
                }
                finally { Object.DestroyImmediate(tex); }
            }
        }

        public static bool IsLit(Color32 c) => c.a > 127 && c.r > 127;

        public static List<LedTexel> Analyze(Image glow, Image sheet)
        {
            int w = glow.Width, h = glow.Height;
            var isLed = new bool[w, h];
            var leds = new List<Vector2Int>();
            for (int row = 0; row < h; row++)
                for (int x = 0; x < w; x++)
                    if (glow.Get(x, row).r > 127) { isLed[x, row] = true; leds.Add(new Vector2Int(x, row)); }

            // 8-connected components = chevrons.
            var label = new int[w, h];
            var comps = new List<List<Vector2Int>>();
            foreach (var start in leds)
            {
                if (label[start.x, start.y] != 0) continue;
                var comp = new List<Vector2Int>();
                comps.Add(comp);
                var queue = new Queue<Vector2Int>();
                label[start.x, start.y] = comps.Count;
                queue.Enqueue(start);
                while (queue.Count > 0)
                {
                    var p = queue.Dequeue();
                    comp.Add(p);
                    for (int dy = -1; dy <= 1; dy++)
                        for (int dx = -1; dx <= 1; dx++)
                        {
                            int nx = p.x + dx, ny = p.y + dy;
                            if (nx < 0 || ny < 0 || nx >= w || ny >= h) continue;
                            if (!isLed[nx, ny] || label[nx, ny] != 0) continue;
                            label[nx, ny] = comps.Count;
                            queue.Enqueue(new Vector2Int(nx, ny));
                        }
                }
            }
            if (comps.Count != 4)
                throw new System.InvalidOperationException(
                    $"Expected 4 LED chevrons in {GlowMaskPath}, found {comps.Count}.");

            // Assign: texture half by mean x; within a half, front = lower in the texture.
            var chevronOf = new Chevron[comps.Count];
            for (int half = 0; half < 2; half++)
            {
                var inHalf = new List<int>();
                for (int i = 0; i < comps.Count; i++)
                    if ((MeanX(comps[i]) < w * 0.5f) == (half == 0)) inHalf.Add(i);
                if (inHalf.Count != 2)
                    throw new System.InvalidOperationException(
                        $"Expected 2 chevrons in texture half {half}, found {inHalf.Count}.");
                bool firstIsFront = MaxRow(comps[inHalf[0]]) > MaxRow(comps[inHalf[1]]);
                int front = firstIsFront ? inHalf[0] : inHalf[1];
                int rear = firstIsFront ? inHalf[1] : inHalf[0];
                chevronOf[front] = half == 0 ? Chevron.TexLeftFront : Chevron.TexRightFront;
                chevronOf[rear] = half == 0 ? Chevron.TexLeftRear : Chevron.TexRightRear;
            }

            var result = new List<LedTexel>(leds.Count);
            for (int i = 0; i < comps.Count; i++)
            {
                int minCol = int.MaxValue, maxCol = int.MinValue;
                foreach (var p in comps[i]) { minCol = Mathf.Min(minCol, p.x); maxCol = Mathf.Max(maxCol, p.x); }
                foreach (var p in comps[i])
                {
                    int off = FrameCount;
                    for (int k = 1; k < FrameCount; k++)
                    {
                        int r = p.y - FrameHeight * k;
                        if (r < 0 || !IsLit(sheet.Get(p.x, r))) { off = k; break; }
                    }
                    int col = p.x;
                    result.Add(new LedTexel
                    {
                        X = p.x, Row = p.y, Chevron = chevronOf[i], OffFrame = off,
                        IndexFromLeft = col - minCol, IndexFromRight = maxCol - col,
                    });
                }
            }
            return result;
        }

        /// <summary>
        /// The blink is a 1-D profile along each chevron: an LED's off frame depends only on its
        /// column (face-vertical position), never its row. Returns profile[chevron][column from
        /// texture-left]. Throws if the art ever breaks that, since gaze-Y shifting relies on it.
        /// </summary>
        public static int[][] BlinkProfiles(List<LedTexel> leds)
        {
            var prof = new int[4][];
            for (int c = 0; c < 4; c++) prof[c] = new int[ProfileWidth];
            foreach (var l in leds)
            {
                if (l.IndexFromLeft >= ProfileWidth)
                    throw new System.InvalidOperationException($"Chevron {l.Chevron} wider than {ProfileWidth} texel columns.");
                int have = prof[(int)l.Chevron][l.IndexFromLeft];
                if (have != 0 && have != l.OffFrame)
                    throw new System.InvalidOperationException(
                        $"Blink is not per-column: chevron {l.Chevron} column {l.IndexFromLeft} has off frames {have} and {l.OffFrame}.");
                prof[(int)l.Chevron][l.IndexFromLeft] = l.OffFrame;
            }
            return prof;
        }

        /// <summary>
        /// Encodes the analysis into bottom-up RGBA32 pixels (Unity order). Besides the LED
        /// texels, the top-left corner holds the blink profiles: top-down row = chevron id,
        /// x = column from texture-left, G = off frame, R = 0 (so it never reads as an LED),
        /// B = A = 1 (marker).
        /// </summary>
        public static Color32[] Encode(List<LedTexel> leds, int width, int height)
        {
            var px = new Color32[width * height];
            foreach (var l in leds)
            {
                px[(height - 1 - l.Row) * width + l.X] = new Color32(
                    Enc((int)l.Chevron + 1), Enc(l.OffFrame), Enc(l.IndexFromLeft + 1), Enc(l.IndexFromRight + 1));
            }
            var prof = BlinkProfiles(leds);
            for (int c = 0; c < 4; c++)
                for (int col = 0; col < ProfileWidth; col++)
                    px[(height - 1 - c) * width + col] = new Color32(0, Enc(prof[c][col]), Enc(1), Enc(1));
            return px;
        }

        public static int Dec(byte b) => Mathf.RoundToInt(b / (float)ChannelStep);
        static byte Enc(int n) => (byte)Mathf.Clamp(n * ChannelStep, 0, 255);

        static float MeanX(List<Vector2Int> c) { float s = 0; foreach (var p in c) s += p.x; return s / c.Count; }
        static int MaxRow(List<Vector2Int> c) { int m = int.MinValue; foreach (var p in c) m = Mathf.Max(m, p.y); return m; }

        public static Color32[] BakeFromSources(out int width, out int height, out List<LedTexel> leds)
        {
            var glow = Image.Load(GlowMaskPath);
            var sheet = Image.Load(BlinkSheetPath);
            width = glow.Width; height = glow.Height;
            leds = Analyze(glow, sheet);
            return Encode(leds, width, height);
        }

        [MenuItem("Tools/Exegesis/ncho Eyes/Bake LED Map", priority = 300)]
        public static void BakeMenu()
        {
            var px = BakeFromSources(out int w, out int h, out var leds);
            var tex = new Texture2D(w, h, TextureFormat.RGBA32, false, true);
            try
            {
                tex.SetPixels32(px);
                File.WriteAllBytes(LedMapPath, tex.EncodeToPNG());
            }
            finally { Object.DestroyImmediate(tex); }

            AssetDatabase.ImportAsset(LedMapPath, ImportAssetOptions.ForceSynchronousImport);
            ConfigureImporter(LedMapPath);

            var counts = new int[4];
            foreach (var l in leds) counts[(int)l.Chevron]++;
            Debug.Log($"[ncho eyes] Baked {LedMapPath}: {leds.Count} LED texels in 4 chevrons " +
                      $"(texL rear {counts[0]}, texL front {counts[1]}, texR rear {counts[2]}, texR front {counts[3]}).");
        }

        public static void ConfigureImporter(string path)
        {
            var imp = (TextureImporter)AssetImporter.GetAtPath(path);
            imp.textureType = TextureImporterType.Default;
            imp.sRGBTexture = false;
            imp.alphaSource = TextureImporterAlphaSource.FromInput;
            imp.alphaIsTransparency = false;
            imp.mipmapEnabled = false;
            imp.filterMode = FilterMode.Point;
            imp.wrapMode = TextureWrapMode.Clamp;
            imp.npotScale = TextureImporterNPOTScale.None;
            imp.isReadable = false;
            imp.maxTextureSize = 512;
            imp.textureCompression = TextureImporterCompression.Uncompressed;
            imp.SaveAndReimport();
        }
    }
}
