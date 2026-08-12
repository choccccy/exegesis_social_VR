using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace Exegesis.RcsThruster
{
    /// <summary>
    /// Play-mode test rig for the RCS system. `Tools > Exegesis > Debug > RCS Test Driver`.
    ///
    /// This window DRIVES the system. It deliberately does not MEASURE it.
    ///
    /// It used to carry a readout of the live material properties, and that readout was
    /// wrong in four different ways in a single evening - it read material slot [0]
    /// instead of the thruster's slot [1], it read the material instance rather than the
    /// MaterialPropertyBlock the animation actually writes to, it resolved the wrong
    /// avatar out of Av3Emulator's clones, and it tried to read animator parameters that
    /// the emulator keeps in a PlayableGraph where Animator.GetFloat cannot see them.
    /// Every one of those failures produced plausible zeros rather than an error, and
    /// hours were spent debugging an avatar that was working fine.
    ///
    /// Measure with the shader's own _DebugView instead - see docs/rcs-thrusters.md.
    /// The GPU reads whatever the renderer really has, so it cannot be fooled by any of
    /// the above.
    ///
    /// What survives here is what was independently verified to work:
    ///   - the physical wiggle, which you can watch move the avatar
    ///   - deriving velocity from that motion, which VRChat's built-ins will not do for
    ///     a transform moved by a script
    ///   - the centre-of-mass helper, which converts a bone into renderer object space
    ///
    /// Talks to Av3Emulator through reflection on purpose - no assembly reference, so
    /// this still compiles if the emulator is absent or renamed. Editor-only, so it can
    /// never ship on the avatar.
    /// </summary>
    internal class RcsTestDriver : EditorWindow
    {
        private const string RuntimeTypeName = "Lyuma.Av3Emulator.Runtime.LyumaAv3Runtime";
        private const string ShaderName = "exegesis/RCSThruster";
        private const string MaterialPath = "Assets/_exegesis/ncho/ncho_tex/thrusters.mat";

        private bool _driveFromTransform = true;
        private float _velocityScale = 1f;
        private Vector3 _manualVelocity;
        private float _manualAngularY;

        // Physical wiggle. Moving the avatar for real is what exercises the PhysBone IMU;
        // deriving velocity from that same motion exercises the linear path. One control
        // drives both halves of the system, which no amount of typing numbers can do.
        private bool _wiggle;
        private Vector3 _wiggleAmplitude = new Vector3(0f, 0f, 0.3f);
        private float _wiggleHz = 0.8f;
        private float _wiggleYawDegrees;
        private bool _wasWiggling;
        private Transform _wiggleTarget;
        private Vector3 _wiggleBasePos;
        private Quaternion _wiggleBaseRot;

        // Differencing state, sampled on GAME frames rather than editor ticks:
        // EditorApplication.update fires irregularly, and dividing a position delta by a
        // jittery interval turns timing noise into velocity noise - which the shader then
        // differentiates again into acceleration, making the thrusters strobe.
        private readonly Dictionary<Transform, Vector3> _prevPos = new Dictionary<Transform, Vector3>();
        private readonly Dictionary<Transform, float> _prevYaw = new Dictionary<Transform, float>();
        private double _prevTime;
        private float _prevGameTime;
        private Vector3 _measuredLocalVel;
        private float _measuredYawRate;
        private float _measureSmoothing = 0.3f;

        private static Type _runtimeType;
        private static FieldInfo _velocityField;
        private static FieldInfo _angularYField;

        [MenuItem("Tools/Exegesis/Debug/RCS Test Driver", false, 100)]
        private static void Open() => GetWindow<RcsTestDriver>("RCS Test");

        private void OnEnable()
        {
            _prevTime = EditorApplication.timeSinceStartup;
            EditorApplication.update += Tick;
        }

        private void OnDisable()
        {
            EditorApplication.update -= Tick;
            RestoreWiggleTarget();
        }

        // ---- emulator plumbing --------------------------------------------------------

        private static bool ResolveEmulator()
        {
            if (_runtimeType != null) return true;

            foreach (var asm in AppDomain.CurrentDomain.GetAssemblies())
            {
                var t = asm.GetType(RuntimeTypeName);
                if (t == null) continue;
                _runtimeType = t;
                _velocityField = t.GetField("Velocity");
                _angularYField = t.GetField("AngularY");
                break;
            }
            return _runtimeType != null && _velocityField != null;
        }

        private static UnityEngine.Object[] FindRuntimes()
        {
            if (!ResolveEmulator()) return Array.Empty<UnityEngine.Object>();
            return UnityEngine.Object.FindObjectsOfType(_runtimeType);
        }

        /// <summary>
        /// Av3Emulator spawns hidden Clone / ShadowClone / MirrorReflection copies. Only
        /// the real avatar should be physically moved, and its motion is what all the
        /// runtimes should then be told about.
        /// </summary>
        private static Component PickPrimary(UnityEngine.Object[] runtimes)
        {
            Component fallback = null;
            foreach (var o in runtimes)
            {
                if (!(o is Component c)) continue;
                fallback = fallback ?? c;
                var n = c.gameObject.name;
                if (n.Contains("Clone") || n.Contains("MirrorReflection")) continue;
                return c;
            }
            return fallback;
        }

        // ---- drive --------------------------------------------------------------------

        private void Tick()
        {
            if (!EditorApplication.isPlaying)
            {
                _prevPos.Clear(); _prevYaw.Clear();
                if (_wasWiggling) RestoreWiggleTarget();
                return;
            }

            double now = EditorApplication.timeSinceStartup;
            float dt = (float)(now - _prevTime);
            _prevTime = now;
            if (dt <= 1e-5f) return;

            var runtimes = FindRuntimes();
            if (runtimes.Length == 0) return;

            var primary = PickPrimary(runtimes);
            if (primary == null) return;

            var tf = primary.transform;
            bool wiggling = ApplyWiggle(tf, now, out var wiggleWorldVel, out var wiggleYawRate);

            Vector3 localVel = _manualVelocity;
            float angularY = _manualAngularY;

            if (_driveFromTransform)
            {
                if (wiggling)
                {
                    // Exact derivative of the motion we just applied. VelocityX/Y/Z are
                    // player-local, so express it in the avatar's own frame.
                    _measuredLocalVel = tf.InverseTransformDirection(wiggleWorldVel);
                    _measuredYawRate = wiggleYawRate;
                    _prevPos.Remove(tf);
                    _prevYaw.Remove(tf);
                }
                else
                {
                    float gameNow = Time.time;
                    float gdt = gameNow - _prevGameTime;
                    if (gdt > 1e-5f)
                    {
                        Vector3 worldVel = Vector3.zero;
                        float yawRate = 0f;
                        if (_prevPos.TryGetValue(tf, out var last))
                            worldVel = (tf.position - last) / gdt;
                        if (_prevYaw.TryGetValue(tf, out var lastYaw))
                            yawRate = Mathf.DeltaAngle(lastYaw, tf.eulerAngles.y) / gdt;

                        _prevPos[tf] = tf.position;
                        _prevYaw[tf] = tf.eulerAngles.y;
                        _prevGameTime = gameNow;

                        float k = 1f - _measureSmoothing;
                        _measuredLocalVel = Vector3.Lerp(_measuredLocalVel,
                            tf.InverseTransformDirection(worldVel), k);
                        _measuredYawRate = Mathf.Lerp(_measuredYawRate, yawRate, k);
                    }
                }

                localVel = _measuredLocalVel * _velocityScale;
                angularY = _measuredYawRate * _velocityScale;
            }

            // Measured from the primary, written to every runtime, so the mirror and
            // shadow copies agree with the avatar you are actually looking at.
            foreach (var obj in runtimes)
            {
                _velocityField.SetValue(obj, localVel);
                _angularYField?.SetValue(obj, angularY);
            }

            Repaint();
        }

        /// <summary>
        /// Drives the wiggle and reports its velocity ANALYTICALLY. Position is
        /// A·sin(wt), so velocity is exactly A·w·cos(wt) - no differencing, no timing
        /// noise, and therefore no strobing once the shader differentiates it.
        /// </summary>
        private bool ApplyWiggle(Transform tf, double now, out Vector3 worldVel, out float yawRate)
        {
            worldVel = Vector3.zero;
            yawRate = 0f;

            if (!_wiggle)
            {
                if (_wasWiggling) RestoreWiggleTarget();
                return false;
            }

            // Capture the rest pose the first frame it turns on, and offset from that,
            // so the avatar never accumulates drift and can always be put back.
            if (!_wasWiggling || _wiggleTarget != tf)
            {
                if (_wasWiggling) RestoreWiggleTarget();
                _wiggleTarget = tf;
                _wiggleBasePos = tf.position;
                _wiggleBaseRot = tf.rotation;
                _wasWiggling = true;
            }

            float omega = _wiggleHz * Mathf.PI * 2f;
            float phase = (float)now * omega;
            float s = Mathf.Sin(phase);
            float c = Mathf.Cos(phase);

            tf.position = _wiggleBasePos + _wiggleAmplitude * s;
            tf.rotation = _wiggleBaseRot * Quaternion.Euler(0f, _wiggleYawDegrees * s, 0f);

            // d/dt of the two lines above.
            worldVel = _wiggleAmplitude * (omega * c);
            yawRate = _wiggleYawDegrees * omega * c;
            return true;
        }

        private void RestoreWiggleTarget()
        {
            if (_wiggleTarget != null)
            {
                _wiggleTarget.position = _wiggleBasePos;
                _wiggleTarget.rotation = _wiggleBaseRot;
            }
            _wiggleTarget = null;
            _wasWiggling = false;
        }

        // ---- gui ----------------------------------------------------------------------

        public void OnGUI()
        {
            // An exception anywhere below leaves the pane completely blank, which reads
            // as "the tool is broken" with no clue why. Surface it instead.
            try { DrawGui(); }
            catch (Exception e)
            {
                EditorGUILayout.HelpBox("RCS test driver hit an error:\n" + e, MessageType.Error);
            }
        }

        private void DrawGui()
        {
            EditorGUILayout.LabelField("RCS test driver", EditorStyles.boldLabel);
            EditorGUILayout.HelpBox(
                "This window drives the system; it does not measure it. To see what the " +
                "thrusters are actually doing, use the shader's _DebugView on thrusters.mat:\n" +
                "  1 Thrust direction    2 Throttle    3 Groups    4 Factors\n" +
                "_DebugView 4 is the one that says WHY a thruster is dark - red is master, " +
                "green is the group gate, blue is allocation.",
                MessageType.Info);

            if (!EditorApplication.isPlaying)
            {
                EditorGUILayout.HelpBox("Enter play mode to drive the avatar.", MessageType.None);
                DrawCoMHelper();
                return;
            }

            if (!ResolveEmulator())
            {
                EditorGUILayout.HelpBox(
                    $"Could not find {RuntimeTypeName}. Is Av3Emulator installed and running?",
                    MessageType.Warning);
                return;
            }

            var runtimes = FindRuntimes();
            var primary = PickPrimary(runtimes);
            EditorGUILayout.LabelField($"Av3 runtimes: {runtimes.Length}",
                primary != null ? $"primary: {primary.gameObject.name}" : "none");

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Physical wiggle", EditorStyles.boldLabel);
            _wiggle = EditorGUILayout.ToggleLeft(
                "Wiggle the avatar (drives PhysBones and the IMU)", _wiggle);
            if (_wiggle)
            {
                EditorGUILayout.HelpBox(
                    "Moves the avatar for real, so the pendulum IMU and every other PhysBone " +
                    "get exercised. With 'drive velocity from transform' on, the same motion " +
                    "also feeds the linear path. Acceleration peaks at the EXTREMES of travel " +
                    "where velocity crosses zero, so expect two pulses per cycle rather than " +
                    "a glow that tracks the movement. The rest pose is restored on switch-off.",
                    MessageType.None);
                _wiggleAmplitude = EditorGUILayout.Vector3Field("Amplitude (m)", _wiggleAmplitude);
                _wiggleHz = EditorGUILayout.Slider("Frequency (Hz)", _wiggleHz, 0.05f, 5f);
                _wiggleYawDegrees = EditorGUILayout.Slider("Yaw sweep (deg)", _wiggleYawDegrees, 0f, 180f);

                float peakVel = _wiggleAmplitude.magnitude * _wiggleHz * Mathf.PI * 2f;
                float peakAcc = peakVel * _wiggleHz * Mathf.PI * 2f;
                EditorGUILayout.LabelField("Peak", $"{peakVel:F2} m/s,  {peakAcc:F1} m/s²");
            }

            EditorGUILayout.Space();
            _driveFromTransform = EditorGUILayout.ToggleLeft(
                "Drive velocity from transform motion", _driveFromTransform);

            if (_driveFromTransform)
            {
                EditorGUILayout.HelpBox(
                    _wiggle
                        ? "Wiggle is on, so velocity is taken from its exact derivative rather " +
                          "than measured. No timing noise, so no strobing."
                        : "VelocityX/Y/Z describe the PLAYER CAPSULE, and the emulator will not " +
                          "derive them from a transform moved by a script. This measures the " +
                          "avatar's real motion and writes it in, so a scene-view drag exercises " +
                          "the same chain VRChat would.",
                    MessageType.None);
                _velocityScale = EditorGUILayout.Slider("Scale", _velocityScale, 0.1f, 10f);
                if (!_wiggle)
                    _measureSmoothing = EditorGUILayout.Slider(
                        "Measurement smoothing", _measureSmoothing, 0f, 0.95f);
            }
            else
            {
                _manualVelocity = EditorGUILayout.Vector3Field("Velocity", _manualVelocity);
                _manualAngularY = EditorGUILayout.Slider("AngularY", _manualAngularY, -400f, 400f);
            }

            DrawCoMHelper();
        }

        // ---- centre of mass helper ------------------------------------------------------

        private SkinnedMeshRenderer _comRenderer;
        private Transform _comTarget;

        /// <summary>
        /// _CoM is in the RENDERER's object space, which is neither world nor the bone's
        /// local space, so it cannot simply be read off the inspector - and a wrong value
        /// silently distorts every lever arm and therefore all rotation allocation.
        /// </summary>
        private void DrawCoMHelper()
        {
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Centre of mass helper", EditorStyles.boldLabel);

            if (_comRenderer == null) _comRenderer = FindThrusterRenderer();

            _comRenderer = (SkinnedMeshRenderer)EditorGUILayout.ObjectField(
                "Renderer", _comRenderer, typeof(SkinnedMeshRenderer), true);
            _comTarget = (Transform)EditorGUILayout.ObjectField(
                "Bone (e.g. Hips)", _comTarget, typeof(Transform), true);

            if (_comRenderer == null || _comTarget == null)
            {
                EditorGUILayout.HelpBox(
                    "Pick the renderer carrying thrusters.mat and the bone you want the centre " +
                    "of mass at, and this converts it into the object space the shader uses.",
                    MessageType.None);
                return;
            }

            var local = _comRenderer.transform.InverseTransformPoint(_comTarget.position);
            EditorGUILayout.LabelField("_CoM", $"({local.x:F3}, {local.y:F3}, {local.z:F3})");

            if (GUILayout.Button("Apply to thrusters.mat"))
            {
                var mat = AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
                if (mat == null || !mat.HasProperty("_CoM"))
                {
                    Debug.LogWarning("[RCS] thrusters.mat not found, or it has no _CoM property.");
                }
                else
                {
                    Undo.RecordObject(mat, "Set RCS centre of mass");
                    mat.SetVector("_CoM", new Vector4(local.x, local.y, local.z, 0f));
                    EditorUtility.SetDirty(mat);
                    AssetDatabase.SaveAssets();
                    Debug.Log($"[RCS] _CoM set to {local}.");
                }
            }
        }

        private static SkinnedMeshRenderer FindThrusterRenderer()
        {
            foreach (var smr in UnityEngine.Object.FindObjectsOfType<SkinnedMeshRenderer>())
                foreach (var m in smr.sharedMaterials)
                    if (m != null && m.shader != null && m.shader.name == ShaderName)
                        return smr;
            return null;
        }
    }
}
