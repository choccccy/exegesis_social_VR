// Guarded exactly like the SDK's own editor scripts. If the VRChat SDK is ever absent the
// whole tool compiles out rather than breaking the project; the slot layers it produced
// stay in the controller and keep working, since they are plain state machines.
#if VRC_SDK_VRCSDK3

using System.Collections.Generic;
using System.Linq;
using AnimatorAsCode.V1;
using AnimatorAsCode.V1.VRC;
using Exegesis.Aac;
using Exegesis.Shared;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Ncho
{
    /// <summary>
    /// Builds ncho's accessory SLOT layers into ncho_fx.controller.
    ///
    /// The problem this solves: every accessory used to be an independent bool on its own
    /// layer writing its own Poiyomi dissolve tile, so nothing stopped two accessories that
    /// occupy the same physical mount from being worn at once - the thruster backpack and
    /// the arm backpack both rendered on the same back mount, and the thigh hard-cases and
    /// thigh thruster packs both on the same thighs.
    ///
    /// The fix is one INT per mount point (0 = bare, 1 = first accessory, 2 = second...) with
    /// one state per member. A state machine can only be in one state, so exclusivity is
    /// structural - there is no bookkeeping between parameters that can get out of step, and
    /// adding a member cannot reintroduce the bug.
    ///
    /// This works because ncho already had the other half of the pattern: the always-on
    /// props_neutral layer sets ALL 16 Props dissolve tiles to hidden, and accessory layers
    /// above it override single tiles to visible. Combined with Write Defaults OFF, a slot
    /// sitting in `idle` writes nothing at all, so its tiles fall through to props_neutral's
    /// hidden values. That is what makes "bare" free: it needs no clip and no state.
    ///
    /// Idempotent, like RcsAnimatorSetup: it deletes and rebuilds anything named slot_*.
    /// Menu: Tools > Exegesis > Build ncho Slot Layers.
    ///
    /// Layers, states, transitions and drivers are built with Animator As Code. Four things are
    /// NOT, and each is documented where it appears: parameter declaration (AAC matches by name
    /// only and will leave a wrongly-typed parameter alone), layer teardown (AAC's clear-in-place
    /// leaks the sub-assets it detaches), the wing_deploy surgery (not expressible in AAC at
    /// all), and sub-asset cleanup.
    ///
    /// Deliberately a separate assembly from Exegesis.RcsThruster.Editor. This one needs the
    /// SDK for VRCAvatarParameterDriver, and docs/rcs-thrusters.md records why the shader
    /// tooling must not take an SDK dependency: a version bump would otherwise break the
    /// shader inspector and the RCS animator tool along with it.
    /// </summary>
    public static class NchoSlotSetup
    {
        public const string DefaultControllerPath =
            "Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller";
        private const string AnimDir = "Assets/_exegesis/ncho/ncho_anim";

        // A clip that animates one irrelevant property on a GameObject called "Empty" that
        // does not exist on the avatar. With Write Defaults off this is a true no-op, which
        // is what an `idle` state needs: writing nothing is how the props_neutral layer
        // below gets to win.
        //
        // Used EXPLICITLY rather than letting AAC assign its own empty clip. AAC gives every
        // state a generated one-frame clip animating "_ignored"/m_IsActive, which is also a
        // no-op under Write Defaults off - but it is a different no-op, and this project's
        // clips are a thing people read.
        private const string EmptyClipPath = "Assets/_exegesis/generic_anim/_Empty.anim";

        private const string LayerPrefix = "slot_";
        private const string LoadoutSuffix = "loadout";
        private const string LoadoutParam = "loadout";

        // AAC's SystemName. With ExegesisDefaultsProvider this composes as "slot" + "_" +
        // suffix, so the layer names come out exactly as they always have.
        private const string SystemName = "slot";

        // Namespaces the sub-assets AAC creates in the controller. Must differ from the RCS
        // tool's key so the two tools cannot collide.
        private const string AssetKey = "slot";

        private const string LogPrefix = "[slots]";

        /// <summary>
        /// Accessories dissolve in and out over this many seconds rather than popping. This is
        /// the transition DURATION, not anything in the clips - the clips are two-key
        /// constants. During a transition the animator blends the tile's dissolve alpha between
        /// the two states, and because the `idle` side writes nothing the blend runs against
        /// props_neutral's hidden value below, which is what produces the fade.
        ///
        /// The hand-built bool layers this replaced all used 0.25s, and losing it was
        /// immediately visible. SlotTransitions_KeepTheFade pins it now.
        ///
        /// Seconds, not a fraction of the clip: hasFixedDuration is set explicitly for the same
        /// reason. These clips are one frame long, so a normalised 0.25 would be ~4ms and read
        /// as an instant pop - the exact bug this constant exists to prevent, wearing a
        /// different hat. AAC's WithTransitionDurationSeconds relies on hasFixedDuration coming
        /// from the defaults provider, which is why ExegesisDefaultsProvider sets it and why
        /// nothing here may call WithTransitionDurationNormalized or ...Percent first - those
        /// flip the flag and silently reinterpret every duration set afterwards.
        /// </summary>
        private const float FadeSeconds = 0.25f;

        // Hand-built layers this tool REPLACES. Removed by exact name, once - after that the
        // removal is a no-op. Their clips are ordinary asset files and are reused by the new
        // slot states, so nothing is lost; only the layers and their states go.
        private static readonly string[] LegacyLayers =
        {
            "thruster_backpack", "arm_pack", "thigh_hard-cases", "thigh_thrusters",
        };

        // The bools those layers rode on. Retired in favour of the slot ints; the tool
        // reports whether anything still references them rather than deleting them, since a
        // parameter another layer depends on must not vanish silently.
        private static readonly string[] RetiredParams =
        {
            "thruster_backpack", "arm_backpack", "thigh_hard-cases", "thigh_thrusters",
        };

        private const string WingLayer = "wing_deploy";
        private const string MasterParam = "rcs";

        private struct Member
        {
            public int Value;
            public string StateName;
            public string ClipPath;
        }

        private struct Slot
        {
            public string Param;
            public int Default;
            public string Suffix;
            public Member[] Members;
        }

        private static Member Props(int value, string name) => new Member
        {
            Value = value,
            StateName = name,
            ClipPath = $"{AnimDir}/[props]_{name}_on.anim",
        };

        /// <summary>
        /// The slot table. Defaults reproduce the pre-migration appearance exactly:
        /// thruster_backpack and thigh_hard-cases both used to default to on.
        ///
        /// Values are a per-slot enumeration and MUST stay stable once uploaded - they are
        /// what the menu writes and what a saved parameter restores. Append new members with
        /// new numbers; never renumber existing ones.
        ///
        /// Suffix is what AAC appends to the system name, so "back" produces the layer
        /// slot_back. Renaming one renames a layer, which the docs, the tests and the
        /// teardown prefix all assume.
        /// </summary>
        private static readonly Slot[] Slots =
        {
            new Slot
            {
                Param = "back_slot", Default = 1, Suffix = "back",
                Members = new[]
                {
                    Props(1, "thruster_backpack"),
                    Props(2, "arm_backpack"),
                },
            },
            new Slot
            {
                Param = "thigh_slot", Default = 1, Suffix = "thigh",
                Members = new[]
                {
                    Props(1, "thigh_hard-cases"),
                    Props(2, "thigh_thrusters"),
                },
            },
        };

        private struct Preset
        {
            public int Value;
            public string StateName;
            public (string Param, float Value)[] Sets;
        }

        /// <summary>
        /// Loadout presets: one button that dresses several slots at once.
        ///
        /// A seed, not a design - re-point these once the real loadouts are known. The
        /// mechanism is what matters, and the mechanism is a driver-only state: it animates
        /// nothing and exists purely to host a VRCAvatarParameterDriver.
        ///
        /// EVERY preset must set `loadout` back to 0 (added automatically below). The
        /// reference implementation on the earlier avatar omits this, so its preset states
        /// re-enter continuously, re-fire their drivers every frame, and permanently pin the
        /// slot ints - individual slot toggles lose every fight with the preset. Resetting to
        /// 0 makes each preset a one-shot.
        /// </summary>
        private static readonly Preset[] Presets =
        {
            new Preset
            {
                Value = 1, StateName = "bare",
                Sets = new[]
                {
                    ("back_slot", 0f), ("thigh_slot", 0f),
                    ("hard-case_mounts", 0f), ("arm_hard-cases", 0f), ("wings_deployed", 0f),
                },
            },
            new Preset
            {
                Value = 2, StateName = "rcs_full",
                Sets = new[]
                {
                    ("back_slot", 1f), ("thigh_slot", 2f),
                    ("wings_deployed", 1f), ("rcs", 1f),
                },
            },
            new Preset
            {
                Value = 3, StateName = "hard_cases",
                Sets = new[]
                {
                    ("back_slot", 0f), ("thigh_slot", 1f),
                    ("hard-case_mounts", 1f), ("arm_hard-cases", 1f),
                },
            },
        };

        // Priority 1 puts this ABOVE Build RCS Animator Layers, which is the order the two
        // must actually be run in - this tool declares the slot ints those layers condition on.
        [MenuItem("Tools/Exegesis/Build ncho Slot Layers", false, 1)]
        private static void BuildFromMenu()
        {
            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(DefaultControllerPath);
            if (controller == null)
            {
                EditorUtility.DisplayDialog("ncho slots",
                    $"Could not load the FX controller at:\n{DefaultControllerPath}", "OK");
                return;
            }

            Build(controller);
        }

        /// <summary>
        /// Rebuilds every slot_* layer in the given controller, removes the hand-built layers it
        /// replaced, and decouples wing_deploy from `rcs`. The menu item passes the committed
        /// controller; the tests pass a scratch copy.
        /// </summary>
        public static void Build(AnimatorController controller)
        {
            if (!ClipsExist()) return;

            // Teardown BEFORE AAC sees the controller, so AAC always takes its
            // append-a-new-layer path. Its alternative, clearing a layer that already exists,
            // empties the state machine by assigning empty arrays over states and transitions -
            // which detaches those sub-assets without destroying them, and they accumulate in
            // the committed file on every rebuild.
            ExegesisAac.RemoveLayersByPrefix(controller, LayerPrefix);
            int legacyRemoved = ExegesisAac.RemoveLayersByName(controller, LegacyLayers);

            EnsureParameters(controller);

            var aac = ExegesisAac.Create(controller, SystemName, AssetKey);

            foreach (var slot in Slots) BuildSlotLayer(aac, controller, slot);
            BuildLoadoutLayer(aac, controller);

            var wings = DecoupleWingsFromRcs(controller);

            // AAC creates one throwaway empty clip per layer as the default motion for its
            // states. Every state here overrides it, so they end up unreferenced; the sweep is
            // what stops them piling up in the committed asset.
            AnimatorAssets.SweepUnreachableSubAssets(controller, LogPrefix);

            EditorUtility.SetDirty(controller);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            ReportRetiredParams(controller);

            int slotLayers = controller.layers.Count(
                l => l.name != null && l.name.StartsWith(LayerPrefix));
            Debug.Log($"{LogPrefix} Rebuilt {slotLayers} '{LayerPrefix}*' layers in " +
                      $"{AssetDatabase.GetAssetPath(controller)}. " +
                      $"Removed {legacyRemoved} legacy accessory layer(s). " +
                      $"wing_deploy: dropped {wings.Transitions} '{MasterParam}' transition(s) and " +
                      $"{wings.Conditions} '{MasterParam}' condition(s).\n" +
                      "Re-run Tools > Exegesis > Build RCS Animator Layers after this, so the " +
                      "rcs_group_* layers pick up the slot ints.");
        }

        /// <summary>
        /// Fails the whole build if any member clip is missing, rather than producing a state
        /// with a null motion - which animates nothing and therefore looks exactly like the
        /// accessory being permanently stowed. Runs before any mutation, so a missing clip
        /// leaves the controller untouched.
        /// </summary>
        private static bool ClipsExist()
        {
            var missing = new List<string>();

            if (AssetDatabase.LoadAssetAtPath<AnimationClip>(EmptyClipPath) == null)
                missing.Add(EmptyClipPath);

            foreach (var slot in Slots)
                foreach (var m in slot.Members)
                    if (AssetDatabase.LoadAssetAtPath<AnimationClip>(m.ClipPath) == null)
                        missing.Add(m.ClipPath);

            if (missing.Count == 0) return true;

            Debug.LogError($"{LogPrefix} Aborted - these clips are missing:\n  " +
                           string.Join("\n  ", missing) +
                           "\nA slot state with no motion writes nothing, which is " +
                           "indistinguishable from the accessory being stowed, so this fails " +
                           "loudly instead.");
            return false;
        }

        // --------------------------------------------------------------- parameters

        /// <summary>
        /// Declared here rather than left to AAC. AAC's CreateParamIfNotExists matches by NAME
        /// only: a parameter that already exists as the wrong type is silently kept, and an
        /// Equals condition against something the controller believes is a Bool never matches
        /// and never logs. AnimatorParameters corrects the type and says so.
        /// </summary>
        private static void EnsureParameters(AnimatorController c)
        {
            foreach (var slot in Slots)
                AnimatorParameters.EnsureInt(c, slot.Param, slot.Default, LogPrefix);

            // Not saved and not synced as an expression parameter: the driver runs locally
            // and the slot ints it writes are what replicate. See docs/accessories.md.
            AnimatorParameters.EnsureInt(c, LoadoutParam, 0, LogPrefix);
        }

        /// <summary>
        /// Reports whether the retired bools are still referenced anywhere. Deliberately does
        /// not delete them: removing a parameter that some other layer still conditions on
        /// would break that layer, and this tool cannot know every consumer.
        /// </summary>
        private static void ReportRetiredParams(AnimatorController c)
        {
            var declared = RetiredParams.Where(p => c.parameters.Any(q => q.name == p)).ToArray();
            if (declared.Length == 0) return;

            var stillUsed = new List<string>();
            foreach (var p in declared)
                if (ReferencingLayers(c, p).Any())
                    stillUsed.Add($"{p} (used by {string.Join(", ", ReferencingLayers(c, p))})");

            if (stillUsed.Count > 0)
            {
                Debug.LogWarning($"{LogPrefix} Retired parameters are still referenced by layers " +
                                 "this tool does not own:\n  " + string.Join("\n  ", stillUsed) +
                                 "\nMigrate or delete those layers before removing the parameters.");
                return;
            }

            Debug.Log($"{LogPrefix} These retired parameters are now unreferenced and safe to " +
                      "delete from the controller and from ncho_params.asset:\n  " +
                      string.Join("\n  ", declared));
        }

        private static IEnumerable<string> ReferencingLayers(AnimatorController c, string param)
        {
            foreach (var layer in c.layers)
            {
                if (layer.stateMachine == null) continue;
                if (StateMachineUses(layer.stateMachine, param)) yield return layer.name;
            }
        }

        private static bool StateMachineUses(AnimatorStateMachine sm, string param)
        {
            foreach (var t in sm.anyStateTransitions)
                if (t.conditions.Any(x => x.parameter == param)) return true;
            foreach (var t in sm.entryTransitions)
                if (t.conditions.Any(x => x.parameter == param)) return true;

            foreach (var child in sm.states)
            {
                if (child.state == null) continue;
                foreach (var t in child.state.transitions)
                    if (t.conditions.Any(x => x.parameter == param)) return true;
            }

            foreach (var child in sm.stateMachines)
                if (child.stateMachine != null && StateMachineUses(child.stateMachine, param))
                    return true;

            return false;
        }

        // ------------------------------------------------------------------- layers

        /// <summary>
        /// One layer per slot: an `idle` state plus one state per member.
        ///
        /// There is deliberately NO state for 0 and no Any State transition. "Bare" is `idle`,
        /// which no value matches, so 0 - and equally any value that has not been assigned a
        /// member - resolves to nothing worn. That is a useful property rather than an
        /// accident: a stale saved value from a removed accessory reads as bare, not as a
        /// broken state machine.
        ///
        /// Swaps route through `idle` ON PURPOSE, and there are deliberately NO member-to-member
        /// transitions. Changing 1 -> 2 therefore fades the old accessory out over FadeSeconds
        /// and only then fades the new one in: one item goes away, then the next appears.
        ///
        /// Direct member-to-member transitions would be half the duration, but they crossfade -
        /// the two accessories dissolve *into each other*, both half-visible and interpenetrating
        /// for a moment. For solid hardware that reads as a glitch rather than a transition. This
        /// is the same choice the ChoccyWicker clothing layers made, where the round trip is
        /// always garment -> Exit -> Entry -> idle -> next garment.
        ///
        /// SlotMembers_SwapViaIdleNotDirectly pins it, because "optimising" the extra step away
        /// looks like an obvious win until you see it move.
        ///
        /// The two transition loops are separate, and stay separate: transitions are evaluated
        /// in creation order, so this produces idle's two entry transitions first and then one
        /// exit transition per member, which is the order the controller has always had.
        /// </summary>
        private static void BuildSlotLayer(AacFlBase aac, AnimatorController c, Slot slot)
        {
            var empty = AssetDatabase.LoadAssetAtPath<AnimationClip>(EmptyClipPath);

            var layer = aac.CreateSupportingArbitraryControllerLayer(c, slot.Suffix);
            var param = layer.IntParameter(slot.Param);

            var idle = layer.NewState("idle").WithAnimation(empty);

            // Every member state first, so the transitions below have something to point at.
            var states = new List<(Member Member, AacFlState State)>();
            foreach (var m in slot.Members)
            {
                var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(m.ClipPath);
                states.Add((m, layer.NewState(m.StateName).WithAnimation(clip)));
            }

            foreach (var (m, state) in states)
                idle.TransitionsTo(state)
                    .WithTransitionDurationSeconds(FadeSeconds)
                    .When(param.IsEqualTo(m.Value));

            // One way out of each member, and it goes to idle. Any change to the slot - to
            // another member or to bare - takes this same path, which is what makes every
            // swap "old one leaves, then new one arrives" rather than a crossfade.
            foreach (var (m, state) in states)
                state.TransitionsTo(idle)
                     .WithTransitionDurationSeconds(FadeSeconds)
                     .When(param.IsNotEqualTo(m.Value));

            layer.StateMachine.WithDefaultState(idle);
        }

        /// <summary>
        /// The preset layer. Driver-only: every state plays the empty clip and animates
        /// nothing, so this layer can never fight the slot layers over a property - it only
        /// writes parameters, which the slot layers then react to.
        /// </summary>
        private static void BuildLoadoutLayer(AacFlBase aac, AnimatorController c)
        {
            var empty = AssetDatabase.LoadAssetAtPath<AnimationClip>(EmptyClipPath);

            var layer = aac.CreateSupportingArbitraryControllerLayer(c, LoadoutSuffix);
            var loadout = layer.IntParameter(LoadoutParam);

            var idle = layer.NewState("idle").WithAnimation(empty);

            foreach (var preset in Presets)
            {
                var state = layer.NewState(preset.StateName).WithAnimation(empty);

                // Driving() rather than Drives(): it creates the driver and sets localOnly
                // false explicitly, which is what the hand-built version did. Drives() would
                // leave localOnly at whatever the SDK defaults to, and mixing the two on one
                // state produces two separate drivers.
                //
                // Parameters come from NoAnimator() because a preset names parameters this tool
                // does not own - hard-case_mounts, arm_hard-cases - and layer.FloatParameter
                // would DECLARE any that were missing, quietly adding them to the controller
                // with a type it guessed. A driver only needs the name.
                state.Driving(driver =>
                {
                    foreach (var (param, value) in preset.Sets)
                        driver.Sets(aac.NoAnimator().FloatParameter(param), value);

                    // The self-reset, appended to every preset. Without it this state re-enters
                    // forever and pins the slot ints - see the Presets comment.
                    driver.Sets(aac.NoAnimator().FloatParameter(LoadoutParam), 0f);
                });

                // Instant on purpose, unlike the slot layers: these transitions carry no
                // visuals, they only gate a driver. The fade happens downstream, when the slot
                // layers react to the ints this writes. Duration 0 comes from the defaults
                // provider, so nothing is set here.
                idle.TransitionsTo(state).When(loadout.IsEqualTo(preset.Value));

                // Fires the frame after the driver has run, because the driver set loadout
                // to 0 on entry.
                state.TransitionsTo(idle).When(loadout.IsNotEqualTo(preset.Value));
            }

            layer.StateMachine.WithDefaultState(idle);
        }

        // ------------------------------------------------------------------- wings

        /// <summary>
        /// Removes `rcs` from the hand-built wing_deploy layer so the wings answer to
        /// wings_deployed alone.
        ///
        /// Why: rcs defaults to 1 and is not saved, so it was 1 on every load, and
        /// wing_deploy entered its deployed state on `wings_deployed OR rcs`. The wings were
        /// therefore always physically out - while rcs_group_wings gates the wing PLUMES on
        /// wings_deployed alone, which defaults to 0. Wings out, plumes silent, every load.
        ///
        /// The dangerous part, and the reason this is code rather than a hand edit: a
        /// transition whose conditions are all removed is ALWAYS TRUE. Stripping `rcs` from
        /// the standalone `If rcs` entry transition would leave an unconditional transition
        /// into the deployed state, which is strictly worse than the bug being fixed. So a
        /// transition that ends up with no conditions is deleted outright, and only
        /// transitions with other conditions surviving are edited in place.
        ///
        /// Stays hand-written: this edits a layer NEITHER tool owns, and AAC has no vocabulary
        /// for "modify what is already there" - everything it touches, it rebuilds.
        /// </summary>
        private static (int Transitions, int Conditions) DecoupleWingsFromRcs(AnimatorController c)
        {
            var layer = c.layers.FirstOrDefault(l => l.name == WingLayer);
            if (layer == null || layer.stateMachine == null)
            {
                Debug.LogWarning($"{LogPrefix} Layer '{WingLayer}' not found; skipped decoupling " +
                                 $"'{MasterParam}' from the wings.");
                return (0, 0);
            }

            int transitions = 0, conditions = 0;
            var sm = layer.stateMachine;

            foreach (var t in sm.anyStateTransitions.ToArray())
            {
                var r = StripParam(t, MasterParam);
                if (r == Strip.Deleted) { sm.RemoveAnyStateTransition(t); transitions++; }
                else if (r == Strip.Edited) conditions++;
            }

            foreach (var child in sm.states)
            {
                var state = child.state;
                if (state == null) continue;

                foreach (var t in state.transitions.ToArray())
                {
                    var r = StripParam(t, MasterParam);
                    if (r == Strip.Deleted) { state.RemoveTransition(t); transitions++; }
                    else if (r == Strip.Edited) conditions++;
                }
            }

            return (transitions, conditions);
        }

        private enum Strip { Untouched, Edited, Deleted }

        private static Strip StripParam(AnimatorStateTransition t, string param)
        {
            var kept = t.conditions.Where(x => x.parameter != param).ToArray();
            if (kept.Length == t.conditions.Length) return Strip.Untouched;
            if (kept.Length == 0) return Strip.Deleted;

            t.conditions = kept;
            return Strip.Edited;
        }
    }
}

#endif
