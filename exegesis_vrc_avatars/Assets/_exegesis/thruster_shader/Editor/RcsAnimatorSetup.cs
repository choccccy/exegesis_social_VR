using System.Collections.Generic;
using System.Linq;
using AnimatorAsCode.V1;
using Exegesis.Aac;
using Exegesis.Shared;
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
    ///
    /// Built with Animator As Code, including the clips - which now live as sub-assets of the
    /// controller rather than as files in an rcs_generated folder. Three things AAC does not
    /// do are handled here: parameter declaration (AAC matches by name and will not correct a
    /// wrong type), Direct blend tree normalisation (AAC never touches it, and this design
    /// depends on it), and cleanup of the sub-assets it orphans.
    ///
    /// No VRChat SDK dependency, deliberately - see the header of NchoSlotSetup.
    /// </summary>
    public static class RcsAnimatorSetup
    {
        public const string DefaultControllerPath =
            "Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller";

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

        // AAC layer suffixes. With ExegesisDefaultsProvider these compose as "rcs" + "_" +
        // suffix, so "smooth" produces the layer rcs_smooth.
        private const string SystemName = "rcs";
        private const string SuffixSmooth = "smooth";
        private const string SuffixImu = "imu";
        private const string SuffixMaster = "master";
        private const string SuffixGroupPacks = "group_packs";
        private const string SuffixGroupWings = "group_wings";
        private const string SuffixGroupThighs = "group_thighs";

        // Teardown matches on PREFIX, not an explicit list. An earlier rename left the
        // old layer orphaned in the controller because its name was no longer in the
        // list that the teardown consulted - prefix matching makes renames safe.
        private const string LayerPrefix = "rcs_";

        // Namespaces the sub-assets AAC creates. Must differ from the slot tool's key.
        private const string AssetKey = "rcs";

        private const string LogPrefix = "[RCS]";

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
        private static void BuildFromMenu()
        {
            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(DefaultControllerPath);
            if (controller == null)
            {
                EditorUtility.DisplayDialog("RCS setup",
                    $"Could not load the FX controller at:\n{DefaultControllerPath}", "OK");
                return;
            }

            Build(controller);
        }

        /// <summary>
        /// Rebuilds every rcs_* layer in the given controller. The menu item passes the
        /// committed controller; the tests pass a scratch copy.
        /// </summary>
        public static void Build(AnimatorController controller)
        {
            // Teardown BEFORE AAC sees the controller, so AAC always appends a new layer rather
            // than clearing an existing one - the clearing path detaches states and transitions
            // without destroying them and leaks them into the committed file.
            ExegesisAac.RemoveLayersByPrefix(controller, LayerPrefix);
            EnsureParameters(controller);

            var aac = ExegesisAac.Create(controller, SystemName, AssetKey);

            BuildSmoothLayer(aac, controller);
            BuildPublishLayers(aac, controller);
            BuildImuLayer(aac, controller);
            BuildMasterLayer(aac, controller);
            BuildGroupPacksLayer(aac, controller);
            BuildGroupWingsLayer(aac, controller);
            BuildGroupThighsLayer(aac, controller);

            // AAC creates a throwaway empty clip per layer, and the previous build's clips and
            // trees are now unreferenced. Without this the committed controller grows on every
            // rebuild, and no other test would notice - the snapshot only walks what the layers
            // still reference.
            AnimatorAssets.SweepUnreachableSubAssets(controller, LogPrefix);

            EditorUtility.SetDirty(controller);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            VerifyGeneratedClips(controller);

            int rcsLayers = controller.layers.Count(l => l.name != null && l.name.StartsWith(LayerPrefix));
            Debug.Log($"{LogPrefix} Rebuilt {rcsLayers} '{LayerPrefix}*' layers in " +
                      $"{AssetDatabase.GetAssetPath(controller)}.");
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
            var c = AssetDatabase.LoadAssetAtPath<AnimatorController>(DefaultControllerPath);
            if (c == null) { Debug.LogError($"{LogPrefix} No controller at {DefaultControllerPath}"); return; }

            ExegesisAac.RemoveLayersByName(c, new[] { LayerForceVel });

            var aac = ExegesisAac.Create(c, SystemName, AssetKey + "_debug");
            var layer = aac.CreateSupportingArbitraryControllerLayer(c, "debug_forcevel");
            layer.NewState("force")
                 .WithAnimation(MaterialClip(aac, "rcs_debug_forcevel", "_RCS_Vel.z", 0.5f));

            EditorUtility.SetDirty(c);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            Debug.Log($"{LogPrefix} Added " + LayerForceVel + " writing _RCS_Vel.z = 0.5 from a " +
                      "plain clip. Enter play mode and read the 'vel' column in the RCS Test " +
                      "Driver. 0.500 means blend trees are the problem; 0.000 means _RCS_Vel " +
                      "cannot be reached at all. Re-run Build RCS Animator Layers to remove.");
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
            var c = AssetDatabase.LoadAssetAtPath<AnimatorController>(DefaultControllerPath);
            if (c == null) { Debug.LogError($"{LogPrefix} No controller at {DefaultControllerPath}"); return; }

            ExegesisAac.RemoveLayersByName(c, new[] { LayerTreeProbe });

            var aac = ExegesisAac.Create(c, SystemName, AssetKey + "_debug");
            var layer = aac.CreateSupportingArbitraryControllerLayer(c, "debug_treeprobe");

            var tree = ExegesisAac.Tree1D(aac, "rcs_debug_treeprobe_tree",
                                          Float(aac, "VelocityZ"));
            tree.WithAnimation(MaterialClip(aac, "rcs_debug_treeprobe", "_RCS_Vel.z", 0.7f), 0f);
            ExegesisAac.FinishTree1D(tree);

            layer.NewState("probe").WithAnimation(tree);

            EditorUtility.SetDirty(c);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            Debug.Log($"{LogPrefix} Added " + LayerTreeProbe + ": a 1D tree with one child " +
                      "writing _RCS_Vel.z = 0.7 regardless of the blend parameter. Enter play " +
                      "mode with _DebugView 4. Blue means blend trees work and VelocityZ is the " +
                      "problem; no blue means blend trees do not deliver. Re-run Build RCS " +
                      "Animator Layers to remove.");
        }

        // ------------------------------------------------------------------ params

        /// <summary>
        /// Declared here rather than left to AAC. AAC's CreateParamIfNotExists matches by NAME
        /// only, so a parameter already declared with the wrong type is silently kept - and an
        /// Equals condition against something the controller believes is a Bool never matches
        /// and never logs. That is precisely the shape of failure this project keeps losing
        /// hours to; AnimatorParameters corrects the type and says so.
        /// </summary>
        private static void EnsureParameters(AnimatorController c)
        {
            // Weight drivers for the direct blend trees. Never animated, so with Write
            // Defaults OFF across this controller they simply sit at their defaults.
            AnimatorParameters.EnsureFloat(c, "RCS_One", 1f);
            AnimatorParameters.EnsureFloat(c, "RCS_Lag", Lag);
            AnimatorParameters.EnsureFloat(c, "RCS_LagInv", 1f - Lag);

            foreach (var (param, _, _) in Axes)
                AnimatorParameters.EnsureFloat(c, Smoothed(param), 0f);

            foreach (var (param, _, _) in ImuAxes)
                AnimatorParameters.EnsureFloat(c, param, 0f);

            AnimatorParameters.Ensure(c, MasterParam, AnimatorControllerParameterType.Bool, LogPrefix);

            // The group layers condition on these, and a transition referencing a parameter
            // the controller does not declare is not a valid animator. Ensuring them means
            // the layers build cleanly whatever order the two setup tools are run in.
            AnimatorParameters.Ensure(c, BackSlotParam, AnimatorControllerParameterType.Int, LogPrefix);
            AnimatorParameters.Ensure(c, ThighSlotParam, AnimatorControllerParameterType.Int, LogPrefix);
            AnimatorParameters.Ensure(c, WingsParam, AnimatorControllerParameterType.Bool, LogPrefix);

            // The built-ins are already declared on this controller, but assert rather
            // than assume - a missing one would silently produce a dead layer.
            foreach (var (param, _, _) in Axes)
                if (!AnimatorParameters.Has(c, param))
                    Debug.LogWarning($"{LogPrefix} Built-in parameter '{param}' is not declared " +
                                     "on the controller. VRChat drives it anyway, but add it so " +
                                     "the blend tree can reference it.");
        }

        private static string Smoothed(string param) => param + "_smoothed";

        /// <summary>
        /// A float parameter handle for blend trees and clip bindings, WITHOUT registering it.
        ///
        /// layer.FloatParameter would declare anything missing, guessing a type. Everything
        /// referenced here is already declared by EnsureParameters - which is the code that gets
        /// to decide types and defaults - so a bare name is all that is wanted.
        /// </summary>
        private static AacFlFloatParameter Float(AacFlBase aac, string name) =>
            aac.NoAnimator().FloatParameter(name);

        // ------------------------------------------------------------------ layers

        // rcs_smooth: one direct tree evaluating smoothed = Lag*smoothed + LagInv*live
        // for each axis. Feeding a parameter back into itself through a blend tree is
        // the standard VRChat float-smoothing pattern; it works because animation clips
        // can drive Animator parameters, not just component properties.
        private static void BuildSmoothLayer(AacFlBase aac, AnimatorController c)
        {
            var layer = aac.CreateSupportingArbitraryControllerLayer(c, SuffixSmooth);
            var root = ExegesisAac.DirectTree(aac, "rcs_smooth_root", LogPrefix);
            layer.NewState("smooth").WithAnimation(root);

            foreach (var (param, _, max) in Axes)
            {
                var target = Smoothed(param);
                var lo = ParamClip(aac, $"rcs_{target}_lo", target, -max);
                var hi = ParamClip(aac, $"rcs_{target}_hi", target, max);

                // Feedback term: read the smoothed value, write it back scaled by Lag.
                var feedback = ExegesisAac.Tree1D(aac, $"rcs_{target}_feedback", Float(aac, target));
                feedback.WithAnimation(lo, -max).WithAnimation(hi, max);
                ExegesisAac.FinishTree1D(feedback);
                root.WithAnimation(feedback, Float(aac, "RCS_Lag"));

                // Target term: read the live value, write it scaled by 1-Lag.
                var live = ExegesisAac.Tree1D(aac, $"rcs_{target}_live", Float(aac, param));
                live.WithAnimation(lo, -max).WithAnimation(hi, max);
                ExegesisAac.FinishTree1D(live);
                root.WithAnimation(live, Float(aac, "RCS_LagInv"));
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
        //
        // Do not "simplify" this back into one Direct tree.
        private static void BuildPublishLayers(AacFlBase aac, AnimatorController c)
        {
            foreach (var (param, prop, max) in PublishAxes())
            {
                var layer = aac.CreateSupportingArbitraryControllerLayer(c, PublishLayerSuffix(prop));

                var lo = MaterialClip(aac, $"rcs_pub{prop}_lo", prop, -1f);
                var hi = MaterialClip(aac, $"rcs_pub{prop}_hi", prop, 1f);

                var tree = ExegesisAac.Tree1D(aac, $"rcs_pub{prop}", Float(aac, param));
                // 1D trees clamp outside their thresholds, which gives the velocity
                // clamp for free - see the note on VelMax about keeping headroom.
                tree.WithAnimation(lo, -max).WithAnimation(hi, max);
                ExegesisAac.FinishTree1D(tree);

                layer.NewState("publish").WithAnimation(tree);
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

        // "_RCS_Vel.x" -> "pub_Velx", which the defaults provider turns into rcs_pub_Velx.
        private static string PublishLayerSuffix(string prop) =>
            "pub_" + prop.Replace("_RCS_", "").Replace(".", "");

        // "_RCS_Vel.x" -> "_RCS_VelSmoothed.x"
        private static string SmoothedProp(string prop)
        {
            int dot = prop.LastIndexOf('.');
            return prop.Substring(0, dot) + "Smoothed" + prop.Substring(dot);
        }

        // rcs_imu: each contact receiver's proximity (0..1) is used directly as a blend
        // weight against a clip holding +1 or -1, so the pair sums to a signed axis.
        private static void BuildImuLayer(AacFlBase aac, AnimatorController c)
        {
            var layer = aac.CreateSupportingArbitraryControllerLayer(c, SuffixImu);
            var root = ExegesisAac.DirectTree(aac, "rcs_imu_root", LogPrefix);
            layer.NewState("imu").WithAnimation(root);

            // Base child at constant weight 1 writing zero. A Direct tree whose weights
            // are all zero is ill-defined; this guarantees a written neutral value when
            // no receiver is triggered (and when Avatar Dynamics is disabled entirely).
            //
            // Note this still leans on RCS_One arriving at its default of 1 - the same
            // assumption that failed for the publish layers. It has not misbehaved here, but
            // if the IMU ever reads as stuck at zero, start with this.
            var zero = MaterialClip(aac, "rcs_imu_zero", null, 0f,
                                    "_RCS_ImuDeflect.x", "_RCS_ImuDeflect.z");
            root.WithAnimation(zero, Float(aac, "RCS_One"));

            foreach (var (param, prop, sign) in ImuAxes)
            {
                var clip = MaterialClip(aac, $"rcs_imu{prop}_{(sign > 0 ? "pos" : "neg")}", prop, sign);
                root.WithAnimation(clip, Float(aac, param));
            }
        }

        // rcs_master: plain two-state toggle, matching the hud / transponder layers
        // rather than introducing a blend tree where the controller has none.
        private static void BuildMasterLayer(AacFlBase aac, AnimatorController c)
        {
            var layer = aac.CreateSupportingArbitraryControllerLayer(c, SuffixMaster);
            var master = layer.BoolParameter(MasterParam);

            var off = layer.NewState("rcs_off")
                           .WithAnimation(MaterialClip(aac, "rcs_master_off", "_RCS_Master", 0f));
            var on = layer.NewState("rcs_on")
                          .WithAnimation(MaterialClip(aac, "rcs_master_on", "_RCS_Master", 1f));

            off.TransitionsTo(on).When(master.IsTrue());
            on.TransitionsTo(off).When(master.IsFalse());

            // Master defaults ON. rcs_off is created first only because it reads better in the
            // Animator window; the default state is set explicitly and is not an accident of
            // creation order.
            layer.StateMachine.WithDefaultState(on);
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
        private static void BuildGroupPacksLayer(AacFlBase aac, AnimatorController c)
        {
            WarnIfMissing(c, BackSlotParam, LayerPrefix + SuffixGroupPacks);

            var layer = aac.CreateSupportingArbitraryControllerLayer(c, SuffixGroupPacks);
            var backSlot = layer.IntParameter(BackSlotParam);

            var clear = layer.NewState("packs_stowed")
                             .WithAnimation(MaterialClip(aac, "rcs_group_packs_clear", "_GroupEnable.x", 1f));
            var covered = layer.NewState("packs_worn")
                               .WithAnimation(MaterialClip(aac, "rcs_group_packs_covered", "_GroupEnable.x", 0f));

            clear.TransitionsTo(covered).When(backSlot.IsNotEqualTo(0));
            covered.TransitionsTo(clear).When(backSlot.IsEqualTo(0));

            layer.StateMachine.WithDefaultState(clear);
        }

        // Group 2 - the Props plumes, which only exist while the wings are deployed.
        private static void BuildGroupWingsLayer(AacFlBase aac, AnimatorController c)
        {
            WarnIfMissing(c, WingsParam, LayerPrefix + SuffixGroupWings);

            var layer = aac.CreateSupportingArbitraryControllerLayer(c, SuffixGroupWings);
            var wings = layer.BoolParameter(WingsParam);

            var stowed = layer.NewState("wings_stowed")
                              .WithAnimation(MaterialClip(aac, "rcs_group_wings_stowed", "_GroupEnable.y", 0f));
            var deployed = layer.NewState("wings_deployed")
                                .WithAnimation(MaterialClip(aac, "rcs_group_wings_out", "_GroupEnable.y", 1f));

            stowed.TransitionsTo(deployed).When(wings.IsTrue());
            deployed.TransitionsTo(stowed).When(wings.IsFalse());

            layer.StateMachine.WithDefaultState(stowed);
        }

        // Group 3 - the thigh pack plumes, which exist only for one specific member of the
        // thigh slot. Note this is Equals a member value, not "anything worn": the thigh
        // hard-cases occupy the same mount but carry no thrusters, so their plumes must stay
        // dark. That distinction is exactly what a slot int expresses and a bool cannot.
        private static void BuildGroupThighsLayer(AacFlBase aac, AnimatorController c)
        {
            WarnIfMissing(c, ThighSlotParam, LayerPrefix + SuffixGroupThighs);

            var layer = aac.CreateSupportingArbitraryControllerLayer(c, SuffixGroupThighs);
            var thighSlot = layer.IntParameter(ThighSlotParam);

            var stowed = layer.NewState("thighs_stowed")
                              .WithAnimation(MaterialClip(aac, "rcs_group_thighs_stowed", "_GroupEnable.z", 0f));
            var worn = layer.NewState("thighs_worn")
                            .WithAnimation(MaterialClip(aac, "rcs_group_thighs_worn", "_GroupEnable.z", 1f));

            stowed.TransitionsTo(worn).When(thighSlot.IsEqualTo(ThighSlotThrusters));
            worn.TransitionsTo(stowed).When(thighSlot.IsNotEqualTo(ThighSlotThrusters));

            layer.StateMachine.WithDefaultState(stowed);
        }

        private static void WarnIfMissing(AnimatorController c, string param, string layer)
        {
            if (!AnimatorParameters.Has(c, param))
                Debug.LogWarning($"{LogPrefix} Parameter '{param}' not found; the {layer} layer " +
                                 "will never switch.");
        }

        // ------------------------------------------------------------------- clips
        //
        // Clips are sub-assets of the controller now, not files in an rcs_generated folder.
        // That folder and its 38 .anim files are gone: AAC owns clip creation, and its assets
        // live in the container it is given.
        //
        // The name passed in is used verbatim as the clip's name, via ExegesisAac.Clip, which
        // strips AAC's random-integer decoration. Dots become underscores, as they always have -
        // the names are a contract GeneratedClipTests asserts on.

        private static string Sanitize(string name) => name.Replace(".", "_");

        /// <summary>
        /// A two-key constant clip driving one or more material properties on every
        /// renderer that carries thrusters.mat.
        ///
        /// WithOneFrame produces AnimationCurve.Constant(0, 1/60, value) - the same two-key,
        /// one-frame shape the hand-rolled version built.
        /// </summary>
        private static AacFlClip MaterialClip(AacFlBase aac, string name, string prop, float value,
                                              params string[] extraProps)
        {
            var props = new List<string>();
            if (!string.IsNullOrEmpty(prop)) props.Add(prop);
            props.AddRange(extraProps);

            var clip = ExegesisAac.Clip(aac, Sanitize(name));
            clip.Animating(edit =>
            {
                foreach (var rendererPath in RendererPaths)
                    foreach (var p in props)
                        edit.Animates(rendererPath, typeof(SkinnedMeshRenderer), "material." + p)
                            .WithOneFrame(value);
            });
            return clip;
        }

        /// <summary>
        /// A two-key constant clip driving an Animator parameter. This is what makes the
        /// smoothing feedback loop possible - clips can write parameters, not just component
        /// properties, so the lag needs no arithmetic anywhere in the animator.
        /// </summary>
        private static AacFlClip ParamClip(AacFlBase aac, string name, string param, float value)
        {
            var clip = ExegesisAac.Clip(aac, Sanitize(name));
            clip.Animating(edit => edit.AnimatesAnimator(Float(aac, param)).WithOneFrame(value));
            return clip;
        }

        // ------------------------------------------------------------ post-build audit

        /// <summary>
        /// Reloads every generated clip from disk and reports any that carry no curves.
        ///
        /// Reloading is the point: it checks what was actually SERIALIZED rather than what
        /// the in-memory object thinks it has, which is the only version the animator will
        /// ever play. This caught a real failure once - one clip out of 38 written with
        /// m_FloatCurves: [] while every other clip in the same build came out correct. With
        /// Write Defaults off, a state playing an empty clip writes nothing, so a gate meant to
        /// force 0 silently holds whatever the material shipped and the feature reads as "the
        /// shader is ignoring my bool".
        /// </summary>
        private static void VerifyGeneratedClips(AnimatorController controller)
        {
            var path = AssetDatabase.GetAssetPath(controller);
            if (string.IsNullOrEmpty(path)) return;

            // Reload the controller from disk so this inspects what was SERIALIZED, not what
            // the in-memory objects believe. Scoped to clips the rcs_* layers actually
            // reference: ncho_fx also carries two orphaned clips from an old duplication, one
            // of them legitimately empty, and auditing every clip in the file would report that
            // as a failure on every single build.
            var reloaded = AssetDatabase.LoadAssetAtPath<AnimatorController>(path);
            if (reloaded == null) return;

            var empty = AnimatorAssets.ClipsReachableFrom(reloaded, LayerPrefix)
                .Where(clip => AnimationUtility.GetCurveBindings(clip).Length == 0
                            && AnimationUtility.GetObjectReferenceCurveBindings(clip).Length == 0)
                .Select(clip => clip.name)
                .ToArray();

            if (empty.Length == 0) return;

            Debug.LogError($"{LogPrefix} {empty.Length} generated clip(s) were written with NO " +
                           "curves: " + string.Join(", ", empty) + ". A state playing an empty " +
                           "clip writes nothing, so with Write Defaults off the property keeps " +
                           "its material value - a gate meant to force 0 will hold whatever the " +
                           "material ships. Re-run Tools > Exegesis > Build RCS Animator Layers.");
        }
    }
}
