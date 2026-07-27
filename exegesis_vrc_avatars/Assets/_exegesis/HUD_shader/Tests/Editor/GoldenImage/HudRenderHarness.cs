using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Exegesis.HudShader.Tests
{
    /// <summary>
    /// Deterministic offscreen renderer for the HUD shader, used by the
    /// golden-image regression tests and the "Capture Baselines" menu item.
    ///
    /// The HUD is a screen-space-projected overlay (content is projected from
    /// _WorldSpaceCameraPos / UNITY_MATRIX_V onto a head-anchored cube). To render
    /// it deterministically we only need a fixed perspective, mono, non-oblique
    /// camera pointed at a cube that fills the frustum — not the whole avatar.
    /// See CLAUDE.md ("HUD shader" notes) for why each of these settings matters.
    /// </summary>
    internal static class HudRenderHarness
    {
        public const int DefaultSize = 512;

        // Fixed camera/geometry framing. Any stable framing works as a regression
        // pin; these values keep the cube filling a 1:1 frustum with room to spare.
        private static readonly Vector3 CameraPos = new Vector3(0f, 0f, -3f);
        private static readonly Vector3 CubeScale = new Vector3(10f, 10f, 10f);
        private const float CameraFov = 60f;
        private const float CameraNear = 0.1f;
        private const float CameraFar = 100f;

        // Solid, opaque clear so the transparent HUD composites against a known bg.
        private static readonly Color ClearColor = new Color(0.25f, 0.25f, 0.25f, 1f);

        /// <summary>
        /// Renders <paramref name="material"/> to a Texture2D (RGBA32). Caller owns
        /// the returned texture (Object.DestroyImmediate when done).
        /// </summary>
        // withBackground renders a few fixed unlit cubes behind the HUD (Geometry queue)
        // so the GrabPass captures scene content — required to exercise the IR/radar
        // screen effects. Leave false for the plain HUD-overlay states (keeps their
        // baselines valid, since they were captured over a solid clear).
        public static Texture2D Render(Material material, int width = DefaultSize, int height = DefaultSize,
                                       bool withBackground = false)
        {
            var cubeMesh = Resources.GetBuiltinResource<Mesh>("Cube.fbx")
                           ?? BuiltinCubeFallback();

            var camGo = new GameObject("HUD_Test_Camera") { hideFlags = HideFlags.HideAndDontSave };
            var cubeGo = new GameObject("HUD_Test_Cube") { hideFlags = HideFlags.HideAndDontSave };
            var bgObjects = new System.Collections.Generic.List<GameObject>();
            var bgMats = new System.Collections.Generic.List<Material>();
            Camera cam = null;
            RenderTexture rt = null;
            RenderTexture prevActive = RenderTexture.active;

            try
            {
                cubeGo.transform.position = Vector3.zero;
                cubeGo.transform.rotation = Quaternion.identity;
                cubeGo.transform.localScale = CubeScale;
                var mf = cubeGo.AddComponent<MeshFilter>();
                mf.sharedMesh = cubeMesh;
                var mr = cubeGo.AddComponent<MeshRenderer>();
                mr.sharedMaterial = material;
                mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
                mr.receiveShadows = false;
                mr.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
                mr.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;

                if (withBackground)
                    CreateBackground(cubeMesh, bgObjects, bgMats);

                camGo.transform.position = CameraPos;
                camGo.transform.rotation = Quaternion.identity; // look down +Z, fixed yaw/pitch
                cam = camGo.AddComponent<Camera>();
                cam.orthographic = false;                 // perspective is REQUIRED (xy/z projection)
                cam.fieldOfView = CameraFov;
                cam.nearClipPlane = CameraNear;
                cam.farClipPlane = CameraFar;
                cam.clearFlags = CameraClearFlags.SolidColor;
                cam.backgroundColor = ClearColor;
                cam.cullingMask = ~0;
                cam.allowMSAA = false;
                cam.allowHDR = false;
                // Scanner states need scene depth: force the camera to generate
                // _CameraDepthTexture (in-game this comes from the world's realtime
                // shadow light). Only for background states so the plain-HUD baselines,
                // which never sample depth into their output, stay unaffected.
                if (withBackground)
                    cam.depthTextureMode |= DepthTextureMode.Depth;
                // Standard, non-oblique projection so isInMirror() stays false and
                // _MirrorMode (MIRROR_DISABLE) does not cull the HUD.
                cam.ResetProjectionMatrix();

                rt = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32)
                {
                    antiAliasing = 1
                };
                rt.Create();
                cam.targetTexture = rt;

                // Belt-and-suspenders time neutralization; animated amplitudes are
                // also zeroed by BuildTestMaterial so output is time-independent.
                Shader.SetGlobalVector("_Time", Vector4.zero);
                Shader.SetGlobalVector("_SinTime", Vector4.zero);
                Shader.SetGlobalVector("_CosTime", new Vector4(1f, 1f, 1f, 1f));

                cam.Render();

                var tex = new Texture2D(width, height, TextureFormat.RGBA32, false, false);
                RenderTexture.active = rt;
                tex.ReadPixels(new Rect(0, 0, width, height), 0, 0);
                tex.Apply();
                return tex;
            }
            finally
            {
                RenderTexture.active = prevActive;
                // Detach the RT from the camera and destroy the camera BEFORE releasing
                // the RT — otherwise Unity logs "Releasing render texture that is set as
                // Camera.targetTexture!", which the Test Framework treats as a failure.
                if (cam != null) cam.targetTexture = null;
                Object.DestroyImmediate(cubeGo);
                Object.DestroyImmediate(camGo);
                foreach (var go in bgObjects) if (go != null) Object.DestroyImmediate(go);
                foreach (var m in bgMats) if (m != null) Object.DestroyImmediate(m);
                if (rt != null) { rt.Release(); Object.DestroyImmediate(rt); }
            }
        }

        // Fixed opaque cubes at varied depths so the depth-driven scanner has real geometry
        // to read. They MUST cast shadows and use a shader with a ShadowCaster pass
        // (Standard), because _CameraDepthTexture is populated only by shadow-caster passes.
        // A shadow-casting directional light forces BiRP to generate the depth texture (the
        // same mechanism a world's realtime light provides in-game). Cube albedo is irrelevant
        // — the scanner reads depth/normal, not color.
        private static void CreateBackground(Mesh cubeMesh, System.Collections.Generic.List<GameObject> outObjs,
                                             System.Collections.Generic.List<Material> outMats)
        {
            var lightGo = new GameObject("HUD_Test_Light") { hideFlags = HideFlags.HideAndDontSave };
            lightGo.transform.rotation = Quaternion.Euler(50f, -30f, 0f);
            var light = lightGo.AddComponent<Light>();
            light.type = LightType.Directional;
            light.shadows = LightShadows.Hard;
            light.intensity = 1f;
            outObjs.Add(lightGo);

            var std = Shader.Find("Standard");
            AddBackgroundCube(cubeMesh, std, new Vector3(-2.2f, 0.5f, 1.0f), new Vector3(1.5f, 1.5f, 1.5f), new Color(0.85f, 0.20f, 0.20f), outObjs, outMats);
            AddBackgroundCube(cubeMesh, std, new Vector3( 1.8f, -0.6f, 2.2f), new Vector3(2.0f, 2.0f, 2.0f), new Color(0.20f, 0.70f, 0.30f), outObjs, outMats);
            AddBackgroundCube(cubeMesh, std, new Vector3( 0.2f, 1.4f, 3.0f), new Vector3(1.2f, 1.2f, 1.2f), new Color(0.25f, 0.40f, 0.90f), outObjs, outMats);
        }

        private static void AddBackgroundCube(Mesh mesh, Shader shader, Vector3 pos, Vector3 scale, Color color,
                                              System.Collections.Generic.List<GameObject> outObjs,
                                              System.Collections.Generic.List<Material> outMats)
        {
            var go = new GameObject("HUD_Test_BG") { hideFlags = HideFlags.HideAndDontSave };
            go.transform.position = pos;
            go.transform.localScale = scale;
            go.AddComponent<MeshFilter>().sharedMesh = mesh;
            var r = go.AddComponent<MeshRenderer>();
            var m = new Material(shader) { hideFlags = HideFlags.HideAndDontSave };
            m.color = color;
            r.sharedMaterial = m;
            r.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.On; // must cast to appear in _CameraDepthTexture
            r.receiveShadows = false;
            r.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
            r.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;
            outObjs.Add(go);
            outMats.Add(m);
        }

        private static Mesh BuiltinCubeFallback()
        {
            // Extremely defensive: if the builtin cube can't be fetched, build one.
            var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
            var mesh = go.GetComponent<MeshFilter>().sharedMesh;
            Object.DestroyImmediate(go);
            return mesh;
        }

        // ---- material state builders -------------------------------------------------

        /// <summary>
        /// Clones the real ncho_HUD material and neutralizes all time-based effects so
        /// renders are deterministic. Per-state overrides are applied on top by the
        /// caller. Caller owns the returned material.
        /// </summary>
        public static Material BuildTestMaterial(IDictionary<string, float> overrides = null)
        {
            var src = HudTestConstants.LoadMaterial();
            if (src == null) return null;

            var mat = new Material(src) { hideFlags = HideFlags.HideAndDontSave };

            // Kill anything that reads _Time so goldens are byte-stable.
            SetIfPresent(mat, "_HUDDriftRadius", 0f);
            SetIfPresent(mat, "_StatusBar0Jitter", 0f);
            SetIfPresent(mat, "_StatusBar1Jitter", 0f);
            SetIfPresent(mat, "_StatusBar2Jitter", 0f);
            SetIfPresent(mat, "_XShake", 0f);
            SetIfPresent(mat, "_YShake", 0f);
            SetIfPresent(mat, "_XWobbleAmount", 0f);
            SetIfPresent(mat, "_YWobbleAmount", 0f);

            if (overrides != null)
                foreach (var kv in overrides)
                    SetIfPresent(mat, kv.Key, kv.Value);

            return mat;
        }

        private static void SetIfPresent(Material mat, string prop, float value)
        {
            if (mat.HasProperty(prop)) mat.SetFloat(prop, value);
        }

        // ---- baseline / comparison ---------------------------------------------------

        public static string BaselineDir =>
            "Assets/_exegesis/HUD_shader/Tests/Editor/GoldenImage/Baselines";

        public static string FailureDir =>
            Path.Combine(Path.GetTempPath(), "hud_golden_failures");

        public static string BaselinePath(string stateName) =>
            Path.Combine(BaselineDir, stateName + ".png");

        public static void WritePng(Texture2D tex, string path)
        {
            var dir = Path.GetDirectoryName(path);
            if (!string.IsNullOrEmpty(dir)) Directory.CreateDirectory(dir);
            File.WriteAllBytes(path, tex.EncodeToPNG());
        }

        public static Texture2D LoadPng(string path)
        {
            if (!File.Exists(path)) return null;
            var tex = new Texture2D(2, 2, TextureFormat.RGBA32, false, false);
            tex.LoadImage(File.ReadAllBytes(path)); // resizes to the PNG's dimensions
            return tex;
        }

        public struct DiffResult
        {
            public bool DimensionsMatch;
            public int DiffPixels;
            public int TotalPixels;
            public int MaxChannelDelta;
            public float DiffFraction => TotalPixels == 0 ? 1f : (float)DiffPixels / TotalPixels;
        }

        /// <summary>
        /// Counts pixels whose per-channel delta exceeds <paramref name="channelTolerance"/>
        /// (0-255). Small tolerance absorbs GPU/driver nondeterminism.
        /// </summary>
        public static DiffResult Compare(Texture2D actual, Texture2D baseline, int channelTolerance = 8)
        {
            var result = new DiffResult();
            if (actual.width != baseline.width || actual.height != baseline.height)
            {
                result.DimensionsMatch = false;
                result.TotalPixels = actual.width * actual.height;
                return result;
            }

            result.DimensionsMatch = true;
            var a = actual.GetPixels32();
            var b = baseline.GetPixels32();
            result.TotalPixels = a.Length;

            for (int i = 0; i < a.Length; i++)
            {
                int dr = Mathf.Abs(a[i].r - b[i].r);
                int dg = Mathf.Abs(a[i].g - b[i].g);
                int db = Mathf.Abs(a[i].b - b[i].b);
                int da = Mathf.Abs(a[i].a - b[i].a);
                int worst = Mathf.Max(Mathf.Max(dr, dg), Mathf.Max(db, da));
                if (worst > result.MaxChannelDelta) result.MaxChannelDelta = worst;
                if (worst > channelTolerance) result.DiffPixels++;
            }
            return result;
        }
    }
}
