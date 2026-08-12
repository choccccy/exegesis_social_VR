using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.RcsThruster
{
    /// <summary>
    /// Builds the RCS layers into ncho_fx.controller.
    ///
    /// This is a script rather than hand-edited YAML because the controller carries dozens of
    /// layers; surgery on that by hand is how GUIDs get mangled. It is also idempotent - it
    /// deletes and rebuilds anything named rcs_* - so it can be re-run after tweaking the
    /// constants below.
    ///
    /// What it creates:
    ///   rcs_smooth     - exponential lag copies of the built-in locomotion params
    ///   rcs_pub_*      - normalised velocity + lag pushed onto the material
    ///   rcs_imu        - pendulum contact readout pushed onto the material
    ///   rcs_master     - the menu on/off toggle
    ///   rcs_group_*    - visibility gates, driven by the accessory slots
    ///
    /// The group layers read the slot ints that NchoSlotSetup owns, so run that tool first
    /// when both are being rebuilt. See docs/accessories.md.
    ///
    /// The shader does the differentiation (live minus lagged) and the whole thrust
    /// allocation, so nothing here needs to do arithmetic beyond a lerp.
    /// </summary>
    internal static class RcsAnimatorSetup
    {
        private const string ControllerPath =
            "Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller";
        private const string GeneratedClipDir =
            "Assets/_exegesis/ncho/ncho_anim/rcs_generated";

        // Renderers carrying thrusters.mat in material slot [1].
        private static readonly string[] RendererPaths = { "Body", "Props" };

        // Full-scale points. Velocity is normalised to +/-1 on the material so the
        // shader's gains stay unitless; AngularY is degrees/sec and runs much larger.
        //
        // Set these WELL above any speed actually reachable. A 1D blend tree clamps
        // outside its thresholds, and both the live and the lagged signal go through the
        // same mapping - so once motion exceeds full scale BOTH pin to 1.0, their
        // difference collapses to zero, and the thrusters cut out entirely at exactly the
        // moment they should be firing hardest. Headroom is free; clipping is not.
        private const float VelMax = 20f;
        private const float AngMax = 400f;

        // Exponential lag: smoothed = Lag*smoothed + (1-Lag)*live, evaluated per frame.
        // Higher Lag = longer memory = a wider, softer acceleration pulse.
        //
        // Note this is per FRAME, not per second - the animator has no delta time to
        // work with. The lag is therefore framerate-dependent, and since the shader
        // derives acceleration as (live - smoothed), so is thruster brightness. This is
        // inherent to the technique and normal for VRChat; retune _AccelGain if the
        // headset's framerate target changes substantially.
        private const float Lag = 0.85f;

        private const string MasterParam = "rcs";

        // Accessory SLOT ints, built by NchoSlotSetup - see docs/accessories.md. 0 = nothing
        // worn on that mount, 1 = first accessory, 2 = second.
        //
        // These replaced four bools (thruster_backpack, arm_backpack, thigh_hard-cases,
        // thigh_thrusters), and this layer is the clearest illustration of why. The back gate
        // used to be an OR across two bools, expressed as two separate transitions because
        // conditions within one transition are ANDed - and every new back accessory would
        // have had to be added to it. "Is anything on the back" is now one condition,
        // back_slot != 0, and a third back accessory needs no change here at all.
        private const string BackSlotParam = "back_slot";
        private const string ThighSlotParam = "thigh_slot";

        // The value of thigh_slot that means the thruster packs specifically, as opposed to
        // the hard-cases (1), which carry no thrusters. Must match the slot table in
        // NchoSlotSetup; SlotParameterTests pins the pair.
        private const int ThighSlotThrusters = 2;

        // Still a plain bool: the wings are not a mount point, they are deployed or stowed.
        private const string WingsParam = "wings_deployed";

        private const string LayerSmooth = "rcs_smooth";
        private const string LayerImu = "rcs_imu";
        private const string LayerMaster = "rcs_master";
        private const string LayerGroupPacks = "rcs_group_packs";
        private const string LayerGroupWings = "rcs_group_wings";
        private const string LayerGroupThighs = "rcs_group_thighs";

        // Teardown matches on PREFIX, not an explicit list. An earlier rename left the
        // old layer orphaned in the controller because its name was no longer in the
        // list that RemoveExistingLayers consults - prefix matching makes renames safe.
        private const string LayerPrefix = "rcs_";


        // Built-in param -> the material vector component it drives.
        private static readonly (string Param, string Prop, float Max)[] Axes =
        {
            ("VelocityX", "_RCS_Vel.x", VelMax),
            ("VelocityY", "_RCS_Vel.y", VelMax),
            ("VelocityZ", "_RCS_Vel.z", VelMax),
            ("AngularY",  "_RCS_AngVel.y", AngMax),
        };

        private static readonly (string Param, string Prop, float Sign)[] ImuAxes =
        {
            ("rcs_imu_xp", "_RCS_ImuDeflect.x",  1f),
            ("rcs_imu_xn", "_RCS_ImuDeflect.x", -1f),
            ("rcs_imu_zp", "_RCS_ImuDeflect.z",  1f),
            ("rcs_imu_zn", "_RCS_ImuDeflect.z", -1f),
        };

        // Priority 2: sits directly under Build ncho Slot Layers, which must be run first.
        [MenuItem("Tools/Exegesis/Build RCS Animator Layers", false, 2)]
        private static void Build()
        {
            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(ControllerPath);
            if (controller == null)
            {
                EditorUtility.DisplayDialog("RCS setup",
                    $"Could not load the FX controller at:\n{ControllerPath}", "OK");
                return;
            }

            // Deliberately NOT wrapped in StartAssetEditing/StopAssetEditing: this
            // creates assets as it goes, and AssetDatabase.CreateAsset inside a batched
            // edit is unreliable.
            RemoveExistingLayers(controller);
            ResetClipDir();
            EnsureParameters(controller);

            BuildSmoothLayer(controller);
            BuildPublishLayers(controller);
            BuildImuLayer(controller);
            BuildMasterLayer(controller);
            BuildGroupPacksLayer(controller);
            BuildGroupWingsLayer(controller);
            BuildGroupThighsLayer(controller);

            EditorUtility.SetDirty(controller);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            VerifyGeneratedClips();

            int rcsLayers = controller.layers.Count(l => l.name != null && l.name.StartsWith(LayerPrefix));
            Debug.Log($"[RCS] Rebuilt {rcsLayers} '{LayerPrefix}*' layers in {ControllerPath}. " +
                      $"Generated clips are in {GeneratedClipDir}.");
        }

        // ---------------------------------------------------------------- diagnostic

        private const string LayerForceVel = "rcs_debug_forcevel";

        /// <summary>
        /// Adds ONE layer that writes a constant _RCS_Vel.z from a plain AnimationClip -
        /// no blend tree, no parameter, nothing to go wrong.
        ///
        /// This exists to split the two remaining explanations for _RCS_Vel never moving
        /// while VelocityZ demonstrably does:
        ///
        ///   census shows vel 0.500  -> plain clips DO reach _RCS_Vel, so the fault is
        ///                              specific to blend-tree motions.
        ///   census shows vel 0.000  -> _RCS_Vel is unreachable by any means, so the
        ///                              fault is the binding or something clobbering it,
        ///                              and blend trees were never the issue.
        ///
        /// A normal rebuild removes it, since teardown matches the rcs_ prefix.
        /// </summary>
        [MenuItem("Tools/Exegesis/Debug/RCS - Add Forced Velocity Layer", false, 101)]
        private static void AddForcedVelocityLayer()
        {
            var c = AssetDatabase.LoadAssetAtPath<AnimatorController>(ControllerPath);
            if (c == null) { Debug.LogError($"[RCS] No controller at {ControllerPath}"); return; }

            // Drop any previous copy so this is repeatable.
            var keep = new List<AnimatorControllerLayer>();
            foreach (var layer in c.layers)
            {
                if (layer.name == LayerForceVel) DestroyStateMachineAssets(layer.stateMachine);
                else keep.Add(layer);
            }
            c.layers = keep.ToArray();

            if (!AssetDatabase.IsValidFolder(GeneratedClipDir))
            {
                var parent = Path.GetDirectoryName(GeneratedClipDir).Replace('\\', '/');
                AssetDatabase.CreateFolder(parent, Path.GetFileName(GeneratedClipDir));
            }

            var state = AddLayerWithState(c, LayerForceVel, "force", out _);
            state.motion = MaterialClip("rcs_debug_forcevel", "_RCS_Vel.z", 0.5f);

            EditorUtility.SetDirty(c);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            Debug.Log("[RCS] Added " + LayerForceVel + " writing _RCS_Vel.z = 0.5 from a plain " +
                      "clip. Enter play mode and read the 'vel' column in the RCS Test Driver. " +
                      "0.500 means blend trees are the problem; 0.000 means _RCS_Vel cannot be " +
                      "reached at all. Re-run Build RCS Animator Layers to remove.");
        }

        private const string LayerTreeProbe = "rcs_debug_treeprobe";

        /// <summary>
        /// Adds ONE layer whose motion is a 1D blend tree with a SINGLE child writing a
        /// constant. A one-child tree plays that child at full weight whatever the blend
        /// parameter does, so the parameter is taken out of the equation entirely.
        ///
        /// This separates the two explanations for the publish layers writing nothing:
        ///
        ///   blue appears (_RCS_Vel.z = 0.7)  -> blend trees DO deliver material
        ///       animation. The publish layers are therefore working and writing ZERO,
        ///       because a 1D tree at parameter 0 between -20 and +20 interpolates its
        ///       -1 and +1 clips to exactly 0. The real fault is VelocityZ never
        ///       reaching the FX controller.
        ///
        ///   no blue                          -> blend-tree motions genuinely do not
        ///       deliver in this build, while plain clips do, and publish has to be
        ///       rebuilt without them.
        ///
        /// Pair it with the plain-clip probe: that one is known to work, so the two
        /// together isolate the blend tree as the only difference.
        /// </summary>
        [MenuItem("Tools/Exegesis/Debug/RCS - Add Blend Tree Probe Layer", false, 102)]
        private static void AddBlendTreeProbeLayer()
        {
            var c = AssetDatabase.LoadAssetAtPath<AnimatorController>(ControllerPath);
            if (c == null) { Debug.LogError($"[RCS] No controller at {ControllerPath}"); return; }

            var keep = new List<AnimatorControllerLayer>();
            foreach (var layer in c.layers)
            {
                if (layer.name == LayerTreeProbe) DestroyStateMachineAssets(layer.stateMachine);
                else keep.Add(layer);
            }
            c.layers = keep.ToArray();

            EnsureClipFolder();

            var state = AddLayerWithState(c, LayerTreeProbe, "probe", out _);
            var tree = NewTree(c, "rcs_debug_treeprobe_tree", BlendTreeType.Simple1D);
            tree.blendParameter = "VelocityZ";
            tree.AddChild(MaterialClip("rcs_debug_treeprobe", "_RCS_Vel.z", 0.7f), 0f);
            state.motion = tree;

            EditorUtility.SetDirty(c);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            Debug.Log("[RCS] Added " + LayerTreeProbe + ": a 1D tree with one child writing " +
                      "_RCS_Vel.z = 0.7 regardless of the blend parameter. Enter play mode with " +
                      "_DebugView 4. Blue means blend trees work and VelocityZ is the problem; " +
                      "no blue means blend trees do not deliver. Re-run Build RCS Animator " +
                      "Layers to remove.");
        }

        private static void EnsureClipFolder()
        {
            if (AssetDatabase.IsValidFolder(GeneratedClipDir)) return;
            var parent = Path.GetDirectoryName(GeneratedClipDir).Replace('\\', '/');
            AssetDatabase.CreateFolder(parent, Path.GetFileName(GeneratedClipDir));
        }

        // ------------------------------------------------------------------ params

        private static void EnsureParameters(AnimatorController c)
        {
            // Weight drivers for the direct blend trees. Never animated, so with Write
            // Defaults OFF across this controller they simply sit at their defaults.
            EnsureFloat(c, "RCS_One", 1f);
            EnsureFloat(c, "RCS_Lag", Lag);
            EnsureFloat(c, "RCS_LagInv", 1f - Lag);

            foreach (var (param, _, _) in Axes)
                EnsureFloat(c, Smoothed(param), 0f);

            foreach (var (param, _, _) in ImuAxes)
                EnsureFloat(c, param, 0f);

            EnsureParameter(c, MasterParam, AnimatorControllerParameterType.Bool);

            // The group layers condition on these, and a transition referencing a parameter
            // the controller does not declare is not a valid animator. Ensuring them means
            // the layers build cleanly whatever order the two setup tools are run in.
            //
            // TYPE matters as much as existence here. An Equals condition on a parameter the
            // controller believes is a Bool never matches, so a leftover Bool named back_slot
            // would leave both group layers permanently in one state with nothing to report
            // it - which is precisely the shape of failure this project keeps losing hours to.
            // EnsureParameter corrects the type and says so.
            EnsureParameter(c, BackSlotParam, AnimatorControllerParameterType.Int);
            EnsureParameter(c, ThighSlotParam, AnimatorControllerParameterType.Int);
            EnsureParameter(c, WingsParam, AnimatorControllerParameterType.Bool);

            // The built-ins are already declared on this controller, but assert rather
            // than assume - a missing one would silently produce a dead layer.
            foreach (var (param, _, _) in Axes)
                if (!HasParameter(c, param))
                    Debug.LogWarning($"[RCS] Built-in parameter '{param}' is not declared on the " +
                                     "controller. VRChat drives it anyway, but add it so the blend " +
                                     "tree can reference it.");
        }

        private static string Smoothed(string param) => param + "_smoothed";

        private static bool HasParameter(AnimatorController c, string name)
        {
            foreach (var p in c.parameters) if (p.name == name) return true;
            return false;
        }

        private static void EnsureFloat(AnimatorController c, string name, float defaultValue)
        {
            // c.parameters hands back an array that has to be written back wholesale;
            // mutating an element in place does not persist to the asset.
            var parameters = c.parameters;
            for (int i = 0; i < parameters.Length; i++)
            {
                if (parameters[i].name != name) continue;
                parameters[i].type = AnimatorControllerParameterType.Float;
                parameters[i].defaultFloat = defaultValue;
                c.parameters = parameters;
                return;
            }
            c.AddParameter(new AnimatorControllerParameter
            {
                name = name,
                type = AnimatorControllerParameterType.Float,
                defaultFloat = defaultValue,
            });
        }

        /// <summary>
        /// Declares a parameter if it is missing, and CORRECTS ITS TYPE if it exists as
        /// something else. Existing defaults are left alone - these are VRChat expression
        /// parameters with saved user values, and this tool has no business resetting them.
        ///
        /// The type correction replaces an earlier EnsureBool that returned early whenever the
        /// name already existed. That was fine while every one of these was a bool, but it
        /// meant retyping a parameter left the OLD type in place and silently inert: no error,
        /// no warning, just conditions that never match. Getting a loud message instead is the
        /// entire value of this function.
        /// </summary>
        private static void EnsureParameter(AnimatorController c, string name,
                                           AnimatorControllerParameterType type)
        {
            var ps = c.parameters;
            for (int i = 0; i < ps.Length; i++)
            {
                if (ps[i].name != name) continue;
                if (ps[i].type == type) return;

                Debug.LogWarning($"[RCS] Parameter '{name}' was declared {ps[i].type}; corrected " +
                                 $"to {type}. Anything else conditioning on it as {ps[i].type} is " +
                                 "now inert - check the hand-built layers.");
                ps[i].type = type;
                c.parameters = ps;
                return;
            }

            c.AddParameter(new AnimatorControllerParameter { name = name, type = type });
        }

        // ------------------------------------------------------------------ layers

        private static void RemoveExistingLayers(AnimatorController c)
        {
            var keep = new List<AnimatorControllerLayer>();
            foreach (var layer in c.layers)
            {
                if (layer.name == null || !layer.name.StartsWith(LayerPrefix))
                {
                    keep.Add(layer);
                    continue;
                }
                // Destroy the sub-assets the old layer owned, or they leak into the file.
                DestroyStateMachineAssets(layer.stateMachine);
            }
            c.layers = keep.ToArray();
        }

        private static void DestroyStateMachineAssets(AnimatorStateMachine sm)
        {
            if (sm == null) return;

            // Transitions are sub-assets in their own right; skipping them leaks a few
            // orphaned objects into the controller file on every rebuild.
            foreach (var t in sm.anyStateTransitions) Object.DestroyImmediate(t, true);
            foreach (var t in sm.entryTransitions) Object.DestroyImmediate(t, true);

            foreach (var child in sm.states)
            {
                if (child.state == null) continue;
                foreach (var t in child.state.transitions) Object.DestroyImmediate(t, true);
                DestroyMotionAssets(child.state.motion);
                Object.DestroyImmediate(child.state, true);
            }
            foreach (var child in sm.stateMachines)
                DestroyStateMachineAssets(child.stateMachine);
            Object.DestroyImmediate(sm, true);
        }

        private static void DestroyMotionAssets(Motion motion)
        {
            // Only blend trees are sub-assets of the controller; clips are real files.
            if (!(motion is BlendTree tree)) return;
            foreach (var child in tree.children) DestroyMotionAssets(child.motion);
            Object.DestroyImmediate(tree, true);
        }

        private static AnimatorState AddLayerWithState(AnimatorController c, string layerName,
                                                       string stateName, out AnimatorStateMachine sm)
        {
            c.AddLayer(layerName);
            var layers = c.layers;
            var layer = layers[layers.Length - 1];
            layer.defaultWeight = 1f;
            layer.blendingMode = AnimatorLayerBlendingMode.Override;
            c.layers = layers;

            sm = layer.stateMachine;
            var state = sm.AddState(stateName);
            // Match the rest of this controller: every state is Write Defaults OFF.
            state.writeDefaultValues = false;
            sm.defaultState = state;
            return state;
        }

        private static BlendTree NewTree(AnimatorController c, string name, BlendTreeType type)
        {
            var tree = new BlendTree
            {
                name = name,
                blendType = type,
                useAutomaticThresholds = false,
                hideFlags = HideFlags.HideInHierarchy,
            };
            AssetDatabase.AddObjectToAsset(tree, c);

            if (type == BlendTreeType.Direct)
            {
                // Load-bearing for the whole design: with normalisation OFF a Direct tree
                // SUMS its children, which is what lets one tree drive several different
                // properties at once (publish) and lets two children targeting the same
                // property form a lerp (smooth) or a signed pair (imu). It defaults to
                // off, but this is too important to leave to a default. No public
                // scripting property exposes it, hence SerializedObject.
                var so = new SerializedObject(tree);
                var prop = so.FindProperty("m_NormalizedBlendValues");
                if (prop != null)
                {
                    prop.boolValue = false;
                    so.ApplyModifiedPropertiesWithoutUndo();
                }
                else
                {
                    Debug.LogWarning("[RCS] Could not find m_NormalizedBlendValues on the blend " +
                                     "tree; verify in the Animator window that Normalize Blend " +
                                     "Values is unchecked on the rcs_* trees.");
                }
            }

            return tree;
        }

        /// <summary>
        /// Adds a child to a Direct blend tree and binds its weight to a parameter.
        /// The children array is a struct copy, so it has to be written back wholesale.
        /// </summary>
        private static void AddDirectChild(BlendTree parent, Motion motion, string weightParam)
        {
            parent.AddChild(motion);
            var children = parent.children;
            children[children.Length - 1].directBlendParameter = weightParam;
            parent.children = children;
        }

        // rcs_smooth: one direct tree evaluating smoothed = Lag*smoothed + LagInv*live
        // for each axis. Feeding a parameter back into itself through a blend tree is
        // the standard VRChat float-smoothing pattern; it works because animation clips
        // can drive Animator parameters, not just component properties.
        private static void BuildSmoothLayer(AnimatorController c)
        {
            var state = AddLayerWithState(c, LayerSmooth, "smooth", out _);
            var root = NewTree(c, "rcs_smooth_root", BlendTreeType.Direct);
            state.motion = root;

            foreach (var (param, _, max) in Axes)
            {
                var target = Smoothed(param);
                var lo = ParamClip($"rcs_{target}_lo", target, -max);
                var hi = ParamClip($"rcs_{target}_hi", target, max);

                // Feedback term: read the smoothed value, write it back scaled by Lag.
                var feedback = NewTree(c, $"rcs_{target}_feedback", BlendTreeType.Simple1D);
                feedback.blendParameter = target;
                feedback.AddChild(lo, -max);
                feedback.AddChild(hi, max);
                AddDirectChild(root, feedback, "RCS_Lag");

                // Target term: read the live value, write it scaled by 1-Lag.
                var live = NewTree(c, $"rcs_{target}_live", BlendTreeType.Simple1D);
                live.blendParameter = param;
                live.AddChild(lo, -max);
                live.AddChild(hi, max);
                AddDirectChild(root, live, "RCS_LagInv");
            }
        }

        // Publish: normalise each axis to +/-1 and push it at the material, ONE LAYER
        // PER AXIS, each holding a plain 1D blend tree.
        //
        // This used to be a single Direct blend tree holding all eight children, which
        // is tidier but depends on a weight parameter (RCS_One) arriving with its
        // default of 1. It did not: measured on the live material, master and the group
        // gates were correct while _RCS_Vel stayed at 0.000 through any amount of
        // motion. Every layer built from a state machine worked; both layers built from
        // Direct trees were dead. A 1D tree reads its blend parameter directly, so there
        // is no weight left to arrive as zero. The extra layers cost nothing - the
        // VRCFury optimiser merges them straight back.
        private static void BuildPublishLayers(AnimatorController c)
        {
            foreach (var (param, prop, max) in PublishAxes())
            {
                var state = AddLayerWithState(c, PublishLayerName(prop), "publish", out _);

                var lo = MaterialClip($"rcs_pub{prop}_lo", prop, -1f);
                var hi = MaterialClip($"rcs_pub{prop}_hi", prop, 1f);

                var tree = NewTree(c, $"rcs_pub{prop}", BlendTreeType.Simple1D);
                tree.blendParameter = param;
                // 1D trees clamp outside their thresholds, which gives the velocity
                // clamp for free - see the note on VelMax about keeping headroom.
                tree.AddChild(lo, -max);
                tree.AddChild(hi, max);
                state.motion = tree;
            }
        }

        // Live and lagged copy of every axis.
        private static IEnumerable<(string Param, string Prop, float Max)> PublishAxes()
        {
            foreach (var (param, prop, max) in Axes)
            {
                yield return (param, prop, max);
                yield return (Smoothed(param), SmoothedProp(prop), max);
            }
        }

        private static string PublishLayerName(string prop) =>
            "rcs_pub_" + prop.Replace("_RCS_", "").Replace(".", "");

        // "_RCS_Vel.x" -> "_RCS_VelSmoothed.x"
        private static string SmoothedProp(string prop)
        {
            int dot = prop.LastIndexOf('.');
            return prop.Substring(0, dot) + "Smoothed" + prop.Substring(dot);
        }

        // rcs_imu: each contact receiver's proximity (0..1) is used directly as a blend
        // weight against a clip holding +1 or -1, so the pair sums to a signed axis.
        private static void BuildImuLayer(AnimatorController c)
        {
            var state = AddLayerWithState(c, LayerImu, "imu", out _);
            var root = NewTree(c, "rcs_imu_root", BlendTreeType.Direct);
            state.motion = root;

            // Base child at constant weight 1 writing zero. A Direct tree whose weights
            // are all zero is ill-defined; this guarantees a written neutral value when
            // no receiver is triggered (and when Avatar Dynamics is disabled entirely).
            var zero = MaterialClip("rcs_imu_zero", null, 0f,
                                    "_RCS_ImuDeflect.x", "_RCS_ImuDeflect.z");
            AddDirectChild(root, zero, "RCS_One");

            foreach (var (param, prop, sign) in ImuAxes)
            {
                var clip = MaterialClip($"rcs_imu{prop}_{(sign > 0 ? "pos" : "neg")}", prop, sign);
                AddDirectChild(root, clip, param);
            }
        }

        // rcs_master: plain two-state toggle, matching the hud / transponder layers
        // rather than introducing a blend tree where the controller has none.
        private static void BuildMasterLayer(AnimatorController c)
        {
            var offState = AddLayerWithState(c, LayerMaster, "rcs_off", out var sm);
            offState.motion = MaterialClip("rcs_master_off", "_RCS_Master", 0f);

            var onState = sm.AddState("rcs_on");
            onState.writeDefaultValues = false;
            onState.motion = MaterialClip("rcs_master_on", "_RCS_Master", 1f);

            var toOn = offState.AddTransition(onState);
            toOn.hasExitTime = false;
            toOn.duration = 0f;
            toOn.AddCondition(AnimatorConditionMode.If, 0f, MasterParam);

            var toOff = onState.AddTransition(offState);
            toOff.hasExitTime = false;
            toOff.duration = 0f;
            toOff.AddCondition(AnimatorConditionMode.IfNot, 0f, MasterParam);

            sm.defaultState = onState;
        }

        // Visibility groups silence whole sets of thrusters regardless of what the
        // allocation wants. Poiyomi's UV tile dissolve hides prop GEOMETRY but not the
        // thruster material, so without these the plumes fire off unattached hardware.
        //
        // Membership lives in vertex green, so both components are written on both
        // renderer paths - which renderer a thruster sits on decides nothing, the
        // painting decides everything. One layer per group: they switch on different
        // parameters.

        // Group 1 - Body back thrusters, covered by whatever is on the back mount. Silent
        // whenever the back slot holds anything at all, which is one condition regardless of
        // how many back accessories exist.
        private static void BuildGroupPacksLayer(AnimatorController c)
        {
            WarnIfMissing(c, BackSlotParam, LayerGroupPacks);

            var clear = AddLayerWithState(c, LayerGroupPacks, "packs_stowed", out var sm);
            clear.motion = MaterialClip("rcs_group_packs_clear", "_GroupEnable.x", 1f);

            var covered = sm.AddState("packs_worn");
            covered.writeDefaultValues = false;
            covered.motion = MaterialClip("rcs_group_packs_covered", "_GroupEnable.x", 0f);

            var toCovered = clear.AddTransition(covered);
            toCovered.hasExitTime = false;
            toCovered.duration = 0f;
            toCovered.AddCondition(AnimatorConditionMode.NotEqual, 0f, BackSlotParam);

            var back = covered.AddTransition(clear);
            back.hasExitTime = false;
            back.duration = 0f;
            back.AddCondition(AnimatorConditionMode.Equals, 0f, BackSlotParam);

            sm.defaultState = clear;
        }

        // Group 2 - the Props plumes, which only exist while the wings are deployed.
        private static void BuildGroupWingsLayer(AnimatorController c)
        {
            WarnIfMissing(c, WingsParam, LayerGroupWings);

            var stowed = AddLayerWithState(c, LayerGroupWings, "wings_stowed", out var sm);
            stowed.motion = MaterialClip("rcs_group_wings_stowed", "_GroupEnable.y", 0f);

            var deployed = sm.AddState("wings_deployed");
            deployed.writeDefaultValues = false;
            deployed.motion = MaterialClip("rcs_group_wings_out", "_GroupEnable.y", 1f);

            var toOut = stowed.AddTransition(deployed);
            toOut.hasExitTime = false;
            toOut.duration = 0f;
            toOut.AddCondition(AnimatorConditionMode.If, 0f, WingsParam);

            var toIn = deployed.AddTransition(stowed);
            toIn.hasExitTime = false;
            toIn.duration = 0f;
            toIn.AddCondition(AnimatorConditionMode.IfNot, 0f, WingsParam);

            sm.defaultState = stowed;
        }

        // Group 3 - the thigh pack plumes, which exist only for one specific member of the
        // thigh slot. Note this is Equals a member value, not "anything worn": the thigh
        // hard-cases occupy the same mount but carry no thrusters, so their plumes must stay
        // dark. That distinction is exactly what a slot int expresses and a bool cannot.
        private static void BuildGroupThighsLayer(AnimatorController c)
        {
            WarnIfMissing(c, ThighSlotParam, LayerGroupThighs);

            var stowed = AddLayerWithState(c, LayerGroupThighs, "thighs_stowed", out var sm);
            stowed.motion = MaterialClip("rcs_group_thighs_stowed", "_GroupEnable.z", 0f);

            var worn = sm.AddState("thighs_worn");
            worn.writeDefaultValues = false;
            worn.motion = MaterialClip("rcs_group_thighs_worn", "_GroupEnable.z", 1f);

            var toWorn = stowed.AddTransition(worn);
            toWorn.hasExitTime = false;
            toWorn.duration = 0f;
            toWorn.AddCondition(AnimatorConditionMode.Equals, ThighSlotThrusters, ThighSlotParam);

            var toStowed = worn.AddTransition(stowed);
            toStowed.hasExitTime = false;
            toStowed.duration = 0f;
            toStowed.AddCondition(AnimatorConditionMode.NotEqual, ThighSlotThrusters, ThighSlotParam);

            sm.defaultState = stowed;
        }

        private static void WarnIfMissing(AnimatorController c, string param, string layer)
        {
            if (!HasParameter(c, param))
                Debug.LogWarning($"[RCS] Parameter '{param}' not found; the {layer} layer " +
                                 "will never switch.");
        }

        // ------------------------------------------------------------------- clips

        // Wiped and recreated each run so clips left over from renamed constants do not
        // accumulate. Safe because the layers referencing them are removed first.
        private static void ResetClipDir()
        {
            if (AssetDatabase.IsValidFolder(GeneratedClipDir))
                AssetDatabase.DeleteAsset(GeneratedClipDir);

            var parent = Path.GetDirectoryName(GeneratedClipDir).Replace('\\', '/');
            AssetDatabase.CreateFolder(parent, Path.GetFileName(GeneratedClipDir));
        }

        // Curves are authored on the in-memory clip and the asset is written AFTERWARDS,
        // by PersistClip. The reverse order - CreateAsset first, then SetEditorCurve, then
        // rely on SetDirty/SaveAssets to flush - lost the curves on exactly one clip out of
        // 38 in a build where every other clip came out correct
        // (rcs_group_thighs_stowed.anim, serialized with m_FloatCurves: [] and StopTime 1).
        // A clip that writes nothing is the worst possible failure here: with Write
        // Defaults off, its state leaves the property at whatever the material shipped,
        // so a gate that should force 0 silently holds 1 and the feature reads as
        // "the shader is ignoring my bool". Persisting a fully-built clip in one step
        // removes the flush from the critical path entirely.
        private static AnimationClip NewClip(string name)
        {
            return new AnimationClip { name = Sanitize(name) };
        }

        private static AnimationClip PersistClip(AnimationClip clip, string name)
        {
            var path = $"{GeneratedClipDir}/{Sanitize(name)}.anim";
            AssetDatabase.CreateAsset(clip, path);
            EditorUtility.SetDirty(clip);
            return clip;
        }

        private static string Sanitize(string name) => name.Replace(".", "_");

        /// <summary>
        /// A two-key constant clip driving one or more material properties on every
        /// renderer that carries thrusters.mat.
        /// </summary>
        private static AnimationClip MaterialClip(string name, string prop, float value,
                                                  params string[] extraProps)
        {
            var clip = NewClip(name);
            var props = new List<string>();
            if (!string.IsNullOrEmpty(prop)) props.Add(prop);
            props.AddRange(extraProps);

            var curve = AnimationCurve.Constant(0f, 1f / 60f, value);
            foreach (var rendererPath in RendererPaths)
            {
                foreach (var p in props)
                {
                    var binding = EditorCurveBinding.FloatCurve(
                        rendererPath, typeof(SkinnedMeshRenderer), "material." + p);
                    AnimationUtility.SetEditorCurve(clip, binding, curve);
                }
            }
            return PersistClip(clip, name);
        }

        /// <summary>
        /// A two-key constant clip driving an Animator parameter. This is what makes the
        /// smoothing feedback loop possible.
        /// </summary>
        private static AnimationClip ParamClip(string name, string param, float value)
        {
            var clip = NewClip(name);
            var binding = EditorCurveBinding.FloatCurve("", typeof(Animator), param);
            AnimationUtility.SetEditorCurve(clip, binding, AnimationCurve.Constant(0f, 1f / 60f, value));
            return PersistClip(clip, name);
        }

        // ------------------------------------------------------------ post-build audit

        /// <summary>
        /// Reloads every generated clip from disk and reports any that carry no curves.
        /// Reloading is the point: it checks what was actually SERIALIZED rather than what
        /// the in-memory object thinks it has, which is the only version the animator will
        /// ever play. Silent per-clip write failures are otherwise invisible until someone
        /// notices a gate not gating.
        /// </summary>
        private static void VerifyGeneratedClips()
        {
            var empty = new List<string>();
            foreach (var guid in AssetDatabase.FindAssets("t:AnimationClip", new[] { GeneratedClipDir }))
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(path);
                if (clip == null) { empty.Add($"{path} (failed to load)"); continue; }
                if (AnimationUtility.GetCurveBindings(clip).Length == 0)
                    empty.Add(Path.GetFileName(path));
            }

            if (empty.Count == 0) return;

            Debug.LogError($"[RCS] {empty.Count} generated clip(s) were written with NO curves: " +
                           string.Join(", ", empty) + ". A state playing an empty clip writes " +
                           "nothing, so with Write Defaults off the property keeps its material " +
                           "value - a gate meant to force 0 will hold whatever the material ships. " +
                           "Re-run Tools > Exegesis > Build RCS Animator Layers.");
        }
    }
}
