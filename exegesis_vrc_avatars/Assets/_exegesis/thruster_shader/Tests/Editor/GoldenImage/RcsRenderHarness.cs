using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Deterministic offscreen renderer for the RCS thruster shader.
    ///
    /// The test fixture is a plain cube, which is close to ideal for this shader: its
    /// six faces have exactly the six +/-X, +/-Y, +/-Z normals, so each face behaves as
    /// one thruster pointing down one axis. Firing a commanded acceleration and checking
    /// which faces light is a direct test of the allocation maths, through the real
    /// shader, without duplicating that maths in C#.
    ///
    /// Note the camera sits on a diagonal and sees exactly three faces (+X, +Y, -Z).
    /// That is deliberate: the states that should light a HIDDEN face are the sign-
    /// convention pins, and they are supposed to render black.
    ///
    /// Unlike the HUD harness, this does NOT clone the live material. thrusters.mat is
    /// meant to be re-tuned from the headset constantly, and goldens built on it would
    /// fail every time a colour moved. These baselines pin the maths, so the material is
    /// built from the shader with fixed canonical values.
    /// </summary>
    internal static class RcsRenderHarness
    {
        public const int DefaultSize = 512;

        // Diagonal framing: sees the +X, +Y and -Z faces at a readable angle.
        private static readonly Vector3 CameraPos = new Vector3(3.2f, 2.6f, -3.2f);
        private static readonly Vector3 CubeScale = new Vector3(2f, 2f, 2f);
        private const float CameraFov = 45f;
        private const float CameraNear = 0.1f;
        private const float CameraFar = 100f;

        // Dark but not black, so an unlit face is still distinguishable from the void
        // in a failure dump. Additive output adds straight onto this.
        private static readonly Color ClearColor = new Color(0.06f, 0.06f, 0.07f, 1f);

        public static Texture2D Render(Material material, int width = DefaultSize, int height = DefaultSize)
        {
            var cubeMesh = Resources.GetBuiltinResource<Mesh>("Cube.fbx") ?? BuiltinCubeFallback();

            var camGo = new GameObject("RCS_Test_Camera") { hideFlags = HideFlags.HideAndDontSave };
            var cubeGo = new GameObject("RCS_Test_Cube") { hideFlags = HideFlags.HideAndDontSave };
            Camera cam = null;
            RenderTexture rt = null;
            RenderTexture prevActive = RenderTexture.active;

            try
            {
                cubeGo.transform.position = Vector3.zero;
                cubeGo.transform.rotation = Quaternion.identity;
                cubeGo.transform.localScale = CubeScale;
                cubeGo.AddComponent<MeshFilter>().sharedMesh = cubeMesh;
                var mr = cubeGo.AddComponent<MeshRenderer>();
                mr.sharedMaterial = material;
                mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
                mr.receiveShadows = false;
                mr.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
                mr.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;

                camGo.transform.position = CameraPos;
                camGo.transform.LookAt(Vector3.zero, Vector3.up);
                cam = camGo.AddComponent<Camera>();
                cam.orthographic = false;
                cam.fieldOfView = CameraFov;
                cam.nearClipPlane = CameraNear;
                cam.farClipPlane = CameraFar;
                cam.clearFlags = CameraClearFlags.SolidColor;
                cam.backgroundColor = ClearColor;
                cam.cullingMask = ~0;
                cam.allowMSAA = false;
                cam.allowHDR = false;
                cam.ResetProjectionMatrix();

                rt = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32) { antiAliasing = 1 };
                rt.Create();
                cam.targetTexture = rt;

                // Belt and braces: _FlickerAmp is already zeroed in the canonical
                // material, so nothing should read time, but pin time anyway.
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
                // Detach the RT and destroy the camera BEFORE releasing the RT, or Unity
                // logs "Releasing render texture that is set as Camera.targetTexture!"
                // and the Test Framework fails the test over the log line alone.
                if (cam != null) cam.targetTexture = null;
                Object.DestroyImmediate(cubeGo);
                Object.DestroyImmediate(camGo);
                if (rt != null) { rt.Release(); Object.DestroyImmediate(rt); }
            }
        }

        private static Mesh BuiltinCubeFallback()
        {
            var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
            var mesh = go.GetComponent<MeshFilter>().sharedMesh;
            Object.DestroyImmediate(go);
            return mesh;
        }

        // ---- material state builders -------------------------------------------------

        /// <summary>
        /// Canonical tuning for the golden renders. Fixed on purpose so the baselines
        /// track the allocation maths and not whatever thrusters.mat is tuned to today.
        /// </summary>
        private static readonly Dictionary<string, float> CanonicalFloats = new Dictionary<string, float>
        {
            { "_CoreThreshold", 0.35f },
            { "_GlowGamma", 1f },
            { "_AccelGain", 1f },
            { "_AngAccelGain", 4f },   // lever arms on a unit cube are only 0.5
            // Frame-rate compensation OFF for the same reason flicker is off: it reads
            // unity_DeltaTime, which is not deterministic across renders. The production
            // material ships with it ON. These baselines pin the allocation, not timing.
            { "_AccelTimeCorrect", 0f },
            { "_SustainWeight", 0f },
            { "_Deadzone", 0.05f },
            { "_Sharpness", 1f },
            { "_MinThrottle", 0f },
            { "_ImuHeight", 0.5f },
            { "_ImuGain", 1f },
            { "_ImuLinearReject", 0f },
            { "_ImuClamp", 4f },
            { "_FlickerAmp", 0f },     // time-dependent: must be off for determinism
            { "_FlickerSpeed", 0f },
            // Back-face culling is REQUIRED by this rig even though the production
            // material ships double-sided like the Poiyomi prototype did. With Cull Off
            // and ZWrite Off, the cube's three hidden faces would additively render
            // straight through the visible ones - which would light up the states that
            // are supposed to prove a hidden face fired, destroying the sign pin.
            { "_Cull", 2f },           // UnityEngine.Rendering.CullMode.Back
            { "_VelSpace", 0f },
            { "_ThrustDirSource", 0f },
            { "_ThrustDirFlip", 0f },  // 0 = forward
            { "_CapNormalFlip", 0f },
            { "_DebugView", 0f },      // debug views bypass the composite entirely
            // Forced ON so the goldens keep exercising the real gate logic even while
            // the production material has it switched off.
            { "_GroupGateEnabled", 1f },
            { "_RCS_Master", 1f },
        };

        private static readonly Dictionary<string, Vector4> CanonicalVectors = new Dictionary<string, Vector4>
        {
            { "_CoreColor", new Vector4(1.0f, 0.70f, 0.40f, 1f) },
            { "_GlowColor", new Vector4(0.30f, 0.50f, 1.00f, 1f) },
            { "_CoM", Vector4.zero },
            { "_GroupEnable", Vector4.one },
            { "_RCS_Vel", Vector4.zero },
            { "_RCS_VelSmoothed", Vector4.zero },
            { "_RCS_AngVel", Vector4.zero },
            { "_RCS_AngVelSmoothed", Vector4.zero },
            { "_RCS_ImuDeflect", Vector4.zero },
        };

        /// <summary>
        /// Builds a material on the RCS shader with canonical values, then applies the
        /// state's overrides. Caller owns the result. Masks are left at their "white"
        /// defaults so the render measures throttle, not texture content.
        /// </summary>
        public static Material BuildTestMaterial(IDictionary<string, float> floatOverrides = null,
                                                 IDictionary<string, Vector4> vectorOverrides = null)
        {
            var shader = RcsTestConstants.LoadShader();
            if (shader == null) return null;

            var mat = new Material(shader) { hideFlags = HideFlags.HideAndDontSave };

            foreach (var kv in CanonicalFloats) SetIfPresent(mat, kv.Key, kv.Value);
            foreach (var kv in CanonicalVectors) SetVectorIfPresent(mat, kv.Key, kv.Value);

            if (floatOverrides != null)
                foreach (var kv in floatOverrides) SetIfPresent(mat, kv.Key, kv.Value);
            if (vectorOverrides != null)
                foreach (var kv in vectorOverrides) SetVectorIfPresent(mat, kv.Key, kv.Value);

            return mat;
        }

        private static void SetIfPresent(Material mat, string prop, float value)
        {
            if (mat.HasProperty(prop)) mat.SetFloat(prop, value);
        }

        private static void SetVectorIfPresent(Material mat, string prop, Vector4 value)
        {
            if (mat.HasProperty(prop)) mat.SetVector(prop, value);
        }

        // ---- baseline / comparison ---------------------------------------------------

        public static string BaselineDir =>
            "Assets/_exegesis/thruster_shader/Tests/Editor/GoldenImage/Baselines";

        public static string FailureDir =>
            Path.Combine(Path.GetTempPath(), "rcs_golden_failures");

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
            tex.LoadImage(File.ReadAllBytes(path));
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

        /// <summary>
        /// Mean luminance over the frame, used by the assertions that care about
        /// "did anything fire at all" rather than about exact pixels.
        /// </summary>
        public static float MeanLuminance(Texture2D tex)
        {
            var px = tex.GetPixels32();
            double sum = 0;
            for (int i = 0; i < px.Length; i++)
                sum += (0.2126 * px[i].r + 0.7152 * px[i].g + 0.0722 * px[i].b) / 255.0;
            return (float)(sum / px.Length);
        }
    }
}
