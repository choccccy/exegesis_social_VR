using System.IO;
using System.Linq;
using NUnit.Framework;
using UnityEditor;
using UnityEngine;
using Baker = Exegesis.NchoEyes.NchoEyeLedMapBaker;

namespace Exegesis.NchoEyes.Tests
{
    /// <summary>
    /// Pins the LED map against its sources. The key property: the old spritesheet blink is
    /// reproducible from the map alone, so the new eyes blink exactly like the old ones.
    /// </summary>
    public class NchoEyeLedMapTests
    {
        Baker.Image _glow, _sheet;

        [OneTimeSetUp]
        public void Load()
        {
            _glow = Baker.Image.Load(Baker.GlowMaskPath);
            _sheet = Baker.Image.Load(Baker.BlinkSheetPath);
        }

        [Test]
        public void FourChevrons_TwoPerHalf_FrontBelowRearInTexture()
        {
            var leds = Baker.Analyze(_glow, _sheet);
            var byChevron = leds.GroupBy(l => l.Chevron).ToDictionary(g => g.Key, g => g.ToList());
            Assert.AreEqual(4, byChevron.Count);

            Assert.That(byChevron[Baker.Chevron.TexLeftFront].Max(l => l.Row),
                Is.GreaterThan(byChevron[Baker.Chevron.TexLeftRear].Max(l => l.Row)));
            Assert.That(byChevron[Baker.Chevron.TexRightFront].Max(l => l.Row),
                Is.GreaterThan(byChevron[Baker.Chevron.TexRightRear].Max(l => l.Row)));

            float mid = _glow.Width * 0.5f;
            Assert.That(byChevron[Baker.Chevron.TexLeftFront].Concat(byChevron[Baker.Chevron.TexLeftRear]).All(l => l.X < mid));
            Assert.That(byChevron[Baker.Chevron.TexRightFront].Concat(byChevron[Baker.Chevron.TexRightRear]).All(l => l.X >= mid));
        }

        [Test]
        public void LedCount_EqualsGlowMaskLitTexels()
        {
            int lit = 0;
            for (int row = 0; row < _glow.Height; row++)
                for (int x = 0; x < _glow.Width; x++)
                    if (_glow.Get(x, row).r > 127) lit++;
            Assert.AreEqual(lit, Baker.Analyze(_glow, _sheet).Count);
        }

        [Test]
        public void EveryLed_IsTwoTexelsWide_EvenAligned()
        {
            var set = Baker.Analyze(_glow, _sheet).Select(l => (l.X, l.Row)).ToHashSet();
            foreach (var (x, row) in set)
                Assert.IsTrue(set.Contains((x ^ 1, row)), $"LED texel ({x},{row}) has no 2-wide partner");
        }

        /// <summary>
        /// Rebuild every frame of the old spritesheet from the map (lit iff offFrame &gt; k) and
        /// compare it to the sheet over its whole frame band. Pixel-exact.
        /// </summary>
        [Test]
        public void SpritesheetFrames_ReproducedExactly()
        {
            var leds = Baker.Analyze(_glow, _sheet);
            var offAt = leds.ToDictionary(l => (l.X, l.Row), l => l.OffFrame);
            int ledTop = leds.Min(l => l.Row) - (leds.Min(l => l.Row) % Baker.FrameHeight);

            for (int k = 0; k < Baker.FrameCount; k++)
            {
                int bandTop = ledTop - Baker.FrameHeight * k;
                for (int row = bandTop; row < bandTop + Baker.FrameHeight; row++)
                    for (int x = 0; x < _sheet.Width; x++)
                    {
                        bool expected = Baker.IsLit(_sheet.Get(x, row));
                        bool actual = offAt.TryGetValue((x, row + Baker.FrameHeight * k), out int off) && off > k;
                        if (expected != actual)
                            Assert.Fail($"Frame {k}: texel ({x},{row}) sheet={expected} map={actual}");
                    }
            }
        }

        /// <summary>
        /// Gaze Y shifts the blink window by reading the per-chevron profile block, so every
        /// LED's own off frame must equal its column's profile entry (blink is per-column).
        /// </summary>
        [Test]
        public void BlinkProfile_MatchesEveryLedsOffFrame()
        {
            var leds = Baker.Analyze(_glow, _sheet);
            var prof = Baker.BlinkProfiles(leds);
            foreach (var l in leds)
                Assert.AreEqual(l.OffFrame, prof[(int)l.Chevron][l.IndexFromLeft],
                    $"LED ({l.X},{l.Row}) {l.Chevron} col {l.IndexFromLeft}");

            var px = Baker.Encode(leds, _glow.Width, _glow.Height);
            var img = new Baker.Image(_glow.Width, _glow.Height, px);
            for (int c = 0; c < 4; c++)
                for (int col = 0; col < Baker.ProfileWidth; col++)
                {
                    var t = img.Get(col, c);
                    Assert.AreEqual(0, t.r, "profile texel must not read as an LED");
                    Assert.AreEqual(prof[c][col], Baker.Dec(t.g));
                }
        }

        /// <summary>The committed map is exactly what a fresh bake produces.</summary>
        [Test]
        public void CommittedMap_MatchesFreshBake()
        {
            Assert.IsTrue(File.Exists(Baker.LedMapPath),
                $"{Baker.LedMapPath} missing — run Tools > Exegesis > ncho Eyes > Bake LED Map");
            var committed = Baker.Image.Load(Baker.LedMapPath);
            var fresh = Baker.BakeFromSources(out int w, out int h, out _);
            Assert.AreEqual(w, committed.Width);
            Assert.AreEqual(h, committed.Height);
            var freshImg = new Baker.Image(w, h, fresh);
            for (int row = 0; row < h; row++)
                for (int x = 0; x < w; x++)
                {
                    Color32 a = committed.Get(x, row), b = freshImg.Get(x, row);
                    if (a.r != b.r || a.g != b.g || a.b != b.b || a.a != b.a)
                        Assert.Fail($"LED map differs at ({x},{row}): committed {a}, fresh {b} — re-bake.");
                }
        }

        [Test]
        public void ProtoShader_CompilesWithoutErrors()
        {
            var shader = Shader.Find(Baker.ShaderName);
            Assert.IsNotNull(shader, $"Shader '{Baker.ShaderName}' not found");
            var errors = ShaderUtil.GetShaderMessages(shader)
                .Where(m => m.severity == UnityEditor.Rendering.ShaderCompilerMessageSeverity.Error)
                .Select(m => $"{m.file}:{m.line} {m.message}").ToArray();
            Assert.IsFalse(ShaderUtil.ShaderHasError(shader), string.Join("\n", errors));
        }

        [Test]
        public void LedMapImporter_IsPointUncompressedLinearNoMips()
        {
            var imp = (TextureImporter)AssetImporter.GetAtPath(Baker.LedMapPath);
            Assert.IsNotNull(imp, "LED map not imported");
            Assert.AreEqual(FilterMode.Point, imp.filterMode);
            Assert.IsFalse(imp.mipmapEnabled);
            Assert.IsFalse(imp.sRGBTexture);
            Assert.AreEqual(TextureImporterCompression.Uncompressed, imp.textureCompression);
        }
    }
}
