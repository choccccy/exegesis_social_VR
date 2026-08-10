using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using UnityEditor;
using UnityEngine;

namespace Exegesis.RcsThruster
{
    /// <summary>
    /// Play-mode test rig for the RCS system. `Tools > Exegesis > RCS Test Driver`.
    ///
    /// Solves two problems with testing this in the editor:
    ///
    /// 1. VelocityX/Y/Z describe the PLAYER CAPSULE, which VRChat computes from the player
    ///    controller. Av3Emulator does not derive them from an avatar transform being moved
    ///    by a script, so a wiggler produces real world-space motion while the velocity
    ///    parameters sit at zero and the whole linear path stays dead. "Drive from
    ///    transform" measures the avatar's actual motion and writes it into the emulator,
    ///    which makes any movement - wiggler, dragging in the scene view, an animation -
    ///    exercise the real parameter chain.
    /// 2. Watching several animator parameters at once in the Animator window is painful.
    ///    The readout below shows the whole chain in one place: live velocity, its lagged
    ///    copy, and the IMU contacts.
    ///
    /// Talks to Av3Emulator through reflection on purpose - no assembly reference, so this
    /// still compiles if the emulator is absent or renamed. Editor-only, so it can never
    /// ship on the avatar.
    /// </summary>
    internal class RcsTestDriver : EditorWindow
    {
        private const string RuntimeTypeName = "Lyuma.Av3Emulator.Runtime.LyumaAv3Runtime";

        private static readonly string[] WatchedParams =
        {
            // Blend-tree weights first: these are animator-only floats that rely on their
            // DEFAULT values. If the avatar build pipeline drops parameter defaults they
            // arrive as 0, the direct tree writes nothing, and every *_smoothed value
            // stays pinned at zero with no error reported anywhere.
            "RCS_One", "RCS_Lag", "RCS_LagInv",
            "VelocityX", "VelocityY", "VelocityZ",
            "VelocityX_smoothed", "VelocityY_smoothed", "VelocityZ_smoothed",
            "AngularY", "AngularY_smoothed",
            "rcs_imu_xp", "rcs_imu_xn", "rcs_imu_zp", "rcs_imu_zn",
        };

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

        private readonly Dictionary<Transform, Vector3> _prevPos = new Dictionary<Transform, Vector3>();
        private readonly Dictionary<Transform, float> _prevYaw = new Dictionary<Transform, float>();
        private double _prevTime;

        // Differencing state. Sampled on GAME frames, not editor ticks: EditorApplication
        // .update fires irregularly, and dividing a position delta by a jittery interval
        // turns timing noise into velocity noise - which the shader then differentiates
        // again into acceleration, so the thrusters strobe. The measured value is cached
        // between game frames rather than collapsing to zero.
        private float _prevGameTime;
        private Vector3 _measuredLocalVel;
        private float _measuredYawRate;
        private float _measureSmoothing = 0.3f;

        private static Type _runtimeType;
        private static FieldInfo _velocityField;
        private static FieldInfo _angularYField;

        [MenuItem("Tools/Exegesis/RCS Test Driver")]
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

        /// <summary>
        /// Av3Emulator spawns hidden Clone / ShadowClone / MirrorReflection copies. Only the
        /// real avatar should be physically moved, and its motion is what all the runtimes
        /// should then be told about.
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

            // Drive the off→on edge over several ticks so the emulator definitely sees a
            // change and pushes it into the animator.
            if (_pulseTicks > 0)
            {
                _pulseTicks--;
                SetBool(runtimes, "rcs", _pulseTicks != 0 ? false : true);
            }

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
                    // Motion from something else (a scene-view drag, another script), so
                    // it has to be measured. Sample on game frames only, and smooth a
                    // little - a raw per-frame difference is noisy enough that the
                    // shader's derivative of it strobes.
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
        /// noise, and therefore no strobing once the shader differentiates it. Returns
        /// false when the wiggle is off, in which case the caller must measure instead.
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

        public void OnGUI()
        {
            EditorGUILayout.LabelField("RCS test driver", EditorStyles.boldLabel);

            if (!EditorApplication.isPlaying)
            {
                EditorGUILayout.HelpBox("Enter play mode to drive and read the RCS chain.",
                                        MessageType.Info);
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
                    "get exercised. Leave 'drive velocity from transform' on and this same " +
                    "motion also feeds the linear path - both halves of the system from one " +
                    "control. Peak acceleration scales with amplitude x frequency squared. " +
                    "The rest pose is restored when you switch this off.",
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
                        : "Measures the avatar's real motion and writes it into the emulator, so " +
                          "a scene-view drag exercises the same parameter chain VRChat would. " +
                          "Without this, moving the object leaves VelocityX/Y/Z at zero.",
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

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Live chain", EditorStyles.boldLabel);

            // Read the MATERIAL, not the animator.
            //
            // Av3Emulator drives its controllers through Unity's Playable API, so
            // Animator.runtimeAnimatorController is null and animator parameters cannot be
            // read through the Animator at all. The material is immune to that, and it is
            // the better measurement anyway: it shows what the shader actually receives at
            // the end of the whole chain, rather than what one link in the middle holds.
            if (_comRenderer == null) _comRenderer = FindThrusterRenderer(primary);
            if (_comRenderer == null)
            {
                EditorGUILayout.HelpBox(
                    "No renderer using exegesis/RCSThruster found in the scene.",
                    MessageType.Warning);
                return;
            }

            using (new EditorGUILayout.HorizontalScope())
            {
                EditorGUILayout.LabelField("Reading from", RootNameOf(_comRenderer));
                if (GUILayout.Button("Re-detect", GUILayout.Width(80)))
                    _comRenderer = FindThrusterRenderer(primary);
            }
            if (primary != null && _comRenderer.transform.root != primary.transform.root)
                EditorGUILayout.HelpBox(
                    "This renderer is NOT under the primary avatar, so these values describe " +
                    "a clone and may be meaningless. Press Re-detect.",
                    MessageType.Warning);

            // Resolve the RCS material by SLOT INDEX. thrusters.mat is slot [1]; slot [0]
            // is the Poiyomi base material. Renderer.material silently returns slot [0],
            // and GetFloat/GetVector return 0 for properties a material does not declare -
            // so reading the wrong slot yields a panel full of plausible-looking zeros with
            // no error anywhere. That is exactly as misleading as it sounds.
            int slot = -1;
            var sharedMats = _comRenderer.sharedMaterials;
            for (int i = 0; i < sharedMats.Length; i++)
            {
                var sm = sharedMats[i];
                if (sm != null && sm.shader != null && sm.shader.name == "exegesis/RCSThruster")
                { slot = i; break; }
            }

            if (slot < 0)
            {
                EditorGUILayout.HelpBox(
                    "This renderer has no slot using exegesis/RCSThruster.", MessageType.Warning);
                return;
            }

            var mats = Application.isPlaying ? _comRenderer.materials : _comRenderer.sharedMaterials;
            if (slot >= mats.Length) { EditorGUILayout.HelpBox("Material slot out of range.", MessageType.Warning); return; }
            var mat = mats[slot];
            if (mat == null) { EditorGUILayout.HelpBox("Renderer has no material.", MessageType.Warning); return; }

            EditorGUILayout.LabelField("Material slot", $"[{slot}]  {mat.shader.name}");

            Vector4 vel = mat.GetVector("_RCS_Vel");
            Vector4 lag = mat.GetVector("_RCS_VelSmoothed");
            Vector4 ang = mat.GetVector("_RCS_AngVel");
            Vector4 angLag = mat.GetVector("_RCS_AngVelSmoothed");
            Vector4 imu = mat.GetVector("_RCS_ImuDeflect");

            EditorGUILayout.LabelField("_RCS_Vel", Fmt3(vel));
            EditorGUILayout.LabelField("_RCS_VelSmoothed", Fmt3(lag));

            // The row that matters. This difference IS the acceleration the shader acts
            // on; if it stays at zero while _RCS_Vel moves, the smoothing layer is dead
            // and the whole acceleration term is inert.
            var accel = vel - lag;
            var style = new GUIStyle(EditorStyles.label) { fontStyle = FontStyle.Bold };
            EditorGUILayout.LabelField("→ accel (Vel − Smoothed)", Fmt3(accel), style);

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("_RCS_AngVel.y", ang.y.ToString("F4"));
            EditorGUILayout.LabelField("_RCS_AngVelSmoothed.y", angLag.y.ToString("F4"));
            EditorGUILayout.LabelField("→ ang accel", (ang.y - angLag.y).ToString("F4"), style);

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("_RCS_ImuDeflect", $"x {imu.x:F4}   z {imu.z:F4}");

            float master = mat.GetFloat("_RCS_Master");
            EditorGUILayout.LabelField("_RCS_Master", master.ToString("F2"));
            if (master < 0.5f)
                EditorGUILayout.HelpBox(
                    "Master is 0, so every throttle is multiplied by zero and nothing can fire. " +
                    "The material asset ships this at 1, so the rcs_master layer has driven it " +
                    "down - which means the layers ARE reaching the material, and the 'rcs' bool " +
                    "is simply false. Toggle it below.",
                    MessageType.Warning);

            DrawRendererCensus(primary);
            DrawEmulatorBools(runtimes, primary);

            EditorGUILayout.Space();
            EditorGUILayout.HelpBox(
                "_RCS_Vel flat at zero  -> rcs_publish is not reaching the material.\n" +
                "_RCS_Vel moves, Smoothed flat  -> rcs_smooth is dead; acceleration is inert " +
                "and everything you see is the sustain term.\n" +
                "Both move together, accel near zero  -> the lag is too fast to produce a pulse.",
                MessageType.None);

            DrawCoMHelper();
        }

        private static string Fmt3(Vector4 v) => $"({v.x,7:F3}, {v.y,7:F3}, {v.z,7:F3})";

        /// <summary>
        /// Every renderer under the primary avatar carrying the RCS shader, with its own
        /// master and group values. Material animation instances the material PER
        /// RENDERER, so Body and Props each hold their own copy and can legitimately
        /// disagree - which looks impossible if you assume one shared material, and is
        /// the fastest way to spot a renderer the clips are not reaching at all.
        /// </summary>
        private void DrawRendererCensus(Component primary)
        {
            if (primary == null) return;

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("RCS renderers", EditorStyles.boldLabel);

            int found = 0;
            foreach (var r in primary.GetComponentsInChildren<SkinnedMeshRenderer>(true))
            {
                var shared = r.sharedMaterials;
                for (int i = 0; i < shared.Length; i++)
                {
                    var sm = shared[i];
                    if (sm == null || sm.shader == null || sm.shader.name != "exegesis/RCSThruster")
                        continue;

                    found++;
                    var live = Application.isPlaying && i < r.materials.Length ? r.materials[i] : sm;
                    var ge = live.GetVector("_GroupEnable");
                    EditorGUILayout.LabelField(
                        $"{r.gameObject.name} [{i}]",
                        $"master {live.GetFloat("_RCS_Master"):F2}   " +
                        $"grp ({ge.x:F0},{ge.y:F0})   " +
                        $"vel {live.GetVector("_RCS_Vel").z:F3}   " +
                        $"enabled {(r.enabled && r.gameObject.activeInHierarchy ? "yes" : "NO")}");
                }
            }

            if (found == 0)
                EditorGUILayout.HelpBox(
                    "No renderer under the primary avatar uses exegesis/RCSThruster.",
                    MessageType.Warning);
            else
                EditorGUILayout.HelpBox(
                    "Expect BOTH Body and Props here. A renderer missing from this list is " +
                    "not rendering the RCS material in the built avatar at all - which no " +
                    "amount of parameter tuning will fix.",
                    MessageType.None);
        }

        /// <summary>
        /// Expression bools straight off the emulator's own list. Animator parameters are
        /// unreachable here (Playable API), but expression parameters are plain fields, so
        /// 'rcs' can be both read and toggled - which is the quickest way to tell whether
        /// parameter defaults survived the avatar build.
        /// </summary>
        private int _pulseTicks;

        private void DrawEmulatorBools(UnityEngine.Object[] runtimes, Component primary)
        {
            if (_runtimeType == null || primary == null) return;
            var boolsField = _runtimeType.GetField("Bools");
            if (boolsField == null) return;

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Expression bools", EditorStyles.boldLabel);

            // The PRIMARY runtime, not runtimes[0] - those are not the same object, and
            // editing a clone's copy looks like a toggle that refuses to move.
            if (boolsField.GetValue(primary) is System.Collections.IEnumerable list)
            {
                foreach (var entry in list)
                {
                    if (entry == null) continue;
                    var t = entry.GetType();
                    var nameF = t.GetField("name");
                    var valF = t.GetField("value");
                    if (nameF == null || valF == null) continue;

                    var pname = nameF.GetValue(entry) as string;
                    if (string.IsNullOrEmpty(pname) || !pname.StartsWith("rcs")) continue;

                    bool cur = (bool)valF.GetValue(entry);
                    bool next = EditorGUILayout.Toggle(pname, cur);
                    if (next != cur) SetBool(runtimes, pname, next);
                }
            }

            EditorGUILayout.HelpBox(
                "The emulator only pushes an expression parameter into the animator when it " +
                "CHANGES. If the animator started with rcs false while the emulator already " +
                "held it true, nothing ever gets pushed and master stays at 0 forever. Pulsing " +
                "forces the edge.",
                MessageType.None);

            if (GUILayout.Button(_pulseTicks > 0 ? "Pulsing…" : "Pulse rcs (off → on)"))
                _pulseTicks = 12;
        }

        private void SetBool(UnityEngine.Object[] runtimes, string paramName, bool value)
        {
            var boolsField = _runtimeType?.GetField("Bools");
            if (boolsField == null) return;

            foreach (var obj in runtimes)
            {
                if (!(boolsField.GetValue(obj) is System.Collections.IEnumerable list)) continue;
                foreach (var entry in list)
                {
                    if (entry == null) continue;
                    var t = entry.GetType();
                    if (!(t.GetField("name")?.GetValue(entry) is string n) || n != paramName) continue;
                    t.GetField("value")?.SetValue(entry, value);
                }
            }
        }

        // ---- centre of mass helper --------------------------------------------------

        private SkinnedMeshRenderer _comRenderer;
        private Transform _comTarget;

        /// <summary>
        /// _CoM is in the RENDERER's object space, which is neither world nor the bone's
        /// local space, so it cannot simply be read off the inspector - and a wrong value
        /// silently distorts every lever arm and therefore all rotation allocation. This
        /// converts a picked bone into the right space.
        /// </summary>
        private void DrawCoMHelper()
        {
            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Centre of mass helper", EditorStyles.boldLabel);

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
                var mat = AssetDatabase.LoadAssetAtPath<Material>(
                    "Assets/_exegesis/ncho/ncho_tex/thrusters.mat");
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

        private static bool UsesRcs(Renderer r)
        {
            foreach (var m in r.sharedMaterials)
                if (m != null && m.shader != null && m.shader.name == "exegesis/RCSThruster")
                    return true;
            return false;
        }

        /// <summary>
        /// Prefers a renderer under the PRIMARY avatar. Av3Emulator keeps hidden template
        /// and mirror copies, and a scene-wide search happily returns one of those - whose
        /// animator state has nothing to do with the avatar you are looking at, so every
        /// value read from it is misleading rather than merely wrong.
        /// </summary>
        private static SkinnedMeshRenderer FindThrusterRenderer(Component primary)
        {
            if (primary != null)
                foreach (var smr in primary.GetComponentsInChildren<SkinnedMeshRenderer>(true))
                    if (UsesRcs(smr)) return smr;

            foreach (var smr in UnityEngine.Object.FindObjectsOfType<SkinnedMeshRenderer>())
                if (UsesRcs(smr)) return smr;
            return null;
        }

        private static string RootNameOf(Component c)
        {
            return c == null ? "—" : c.transform.root.name;
        }
    }
}
