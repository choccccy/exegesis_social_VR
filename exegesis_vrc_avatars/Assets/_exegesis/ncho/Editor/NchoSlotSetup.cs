// Guarded exactly like the SDK's own editor scripts. If the VRChat SDK is ever absent the
// whole tool compiles out rather than breaking the project; the slot layers it produced
// stay in the controller and keep working, since they are plain state machines.
#if VRC_SDK_VRCSDK3

using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;
using VRC.SDK3.Avatars.Components;
using VRC.SDKBase;

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
    /// Deliberately a separate assembly from Exegesis.RcsThruster.Editor. This one needs the
    /// SDK for VRCAvatarParameterDriver, and docs/rcs-thrusters.md records why the shader
    /// tooling must not take an SDK dependency: a version bump would otherwise break the
    /// shader inspector and the RCS animator tool along with it.
    /// </summary>
    internal static class NchoSlotSetup
    {
        private const string ControllerPath =
            "Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller";
        private const string AnimDir = "Assets/_exegesis/ncho/ncho_anim";

        // A clip that animates one irrelevant property on a GameObject called "Empty" that
        // does not exist on the avatar. With Write Defaults off this is a true no-op, which
        // is what an `idle` state needs: writing nothing is how the props_neutral layer
        // below gets to win.
        private const string EmptyClipPath = "Assets/_exegesis/generic_anim/_Empty.anim";

        private const string LayerPrefix = "slot_";
        private const string LoadoutLayer = "slot_loadout";
        private const string LoadoutParam = "loadout";

        /// <summary>
        /// Accessories dissolve in and out over this many seconds rather than popping. This is
        /// the transition DURATION, not anything in the clips - the clips are two-key
        /// constants. During a transition the animator blends the tile's dissolve alpha between
        /// the two states, and because the `idle` side writes nothing the blend runs against
        /// props_neutral's hidden value below, which is what produces the fade.
        ///
        /// The hand-built bool layers this replaced all used 0.25s, and losing it was
        /// immediately visible. SlotTransitionTests pins it now.
        ///
        /// Seconds, not a fraction of the clip: hasFixedDuration is set explicitly for the same
        /// reason. These clips are one frame long, so a normalised 0.25 would be ~4ms and read
        /// as an instant pop - the exact bug this constant exists to prevent, wearing a
        /// different hat.
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
            public string Layer;
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
        /// </summary>
        private static readonly Slot[] Slots =
        {
            new Slot
            {
                Param = "back_slot", Default = 1, Layer = "slot_back",
                Members = new[]
                {
                    Props(1, "thruster_backpack"),
                    Props(2, "arm_backpack"),
                },
            },
            new Slot
            {
                Param = "thigh_slot", Default = 1, Layer = "slot_thigh",
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
        private static void Build()
        {
            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(ControllerPath);
            if (controller == null)
            {
                EditorUtility.DisplayDialog("ncho slots",
                    $"Could not load the FX controller at:\n{ControllerPath}", "OK");
                return;
            }

            if (!ClipsExist()) return;

            RemoveExistingLayers(controller);
            int legacyRemoved = RemoveLegacyLayers(controller);
            EnsureParameters(controller);

            foreach (var slot in Slots) BuildSlotLayer(controller, slot);
            BuildLoadoutLayer(controller);

            var wings = DecoupleWingsFromRcs(controller);

            EditorUtility.SetDirty(controller);
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();

            ReportRetiredParams(controller);

            int slotLayers = controller.layers.Count(
                l => l.name != null && l.name.StartsWith(LayerPrefix));
            Debug.Log($"[slots] Rebuilt {slotLayers} '{LayerPrefix}*' layers in {ControllerPath}. " +
                      $"Removed {legacyRemoved} legacy accessory layer(s). " +
                      $"wing_deploy: dropped {wings.Transitions} '{MasterParam}' transition(s) and " +
                      $"{wings.Conditions} '{MasterParam}' condition(s).\n" +
                      "Re-run Tools > Exegesis > Build RCS Animator Layers after this, so the " +
                      "rcs_group_* layers pick up the slot ints.");
        }

        /// <summary>
        /// Fails the whole build if any member clip is missing, rather than producing a state
        /// with a null motion - which animates nothing and therefore looks exactly like the
        /// accessory being permanently stowed.
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

            Debug.LogError("[slots] Aborted - these clips are missing:\n  " +
                           string.Join("\n  ", missing) +
                           "\nA slot state with no motion writes nothing, which is " +
                           "indistinguishable from the accessory being stowed, so this fails " +
                           "loudly instead.");
            return false;
        }

        // --------------------------------------------------------------- parameters

        private static void EnsureParameters(AnimatorController c)
        {
            foreach (var slot in Slots) EnsureInt(c, slot.Param, slot.Default);

            // Not saved and not synced as an expression parameter: the driver runs locally
            // and the slot ints it writes are what replicate. See docs/accessories.md.
            EnsureInt(c, LoadoutParam, 0);
        }

        /// <summary>
        /// Adds the parameter, or CORRECTS ITS TYPE if it already exists as something else.
        ///
        /// The type correction is the point. Retyping a parameter that a transition already
        /// conditions on leaves the transition silently inert - an Equals on what the
        /// controller thinks is a Bool never matches - and nothing reports it. An existing
        /// Int's default is left alone, since it may have been tuned deliberately.
        /// </summary>
        private static void EnsureInt(AnimatorController c, string name, int defaultValue)
        {
            var ps = c.parameters;
            for (int i = 0; i < ps.Length; i++)
            {
                if (ps[i].name != name) continue;
                if (ps[i].type == AnimatorControllerParameterType.Int) return;

                Debug.LogWarning($"[slots] '{name}' was declared {ps[i].type} on the controller; " +
                                 "correcting to Int. Any hand-built transition conditioning on it " +
                                 "as the old type is now inert - check it.");
                ps[i].type = AnimatorControllerParameterType.Int;
                ps[i].defaultInt = defaultValue;
                c.parameters = ps;
                return;
            }

            c.AddParameter(new AnimatorControllerParameter
            {
                name = name,
                type = AnimatorControllerParameterType.Int,
                defaultInt = defaultValue,
            });
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
                Debug.LogWarning("[slots] Retired parameters are still referenced by layers this " +
                                 "tool does not own:\n  " + string.Join("\n  ", stillUsed) +
                                 "\nMigrate or delete those layers before removing the parameters.");
                return;
            }

            Debug.Log("[slots] These retired parameters are now unreferenced and safe to delete " +
                      "from the controller and from ncho_params.asset:\n  " +
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
                DestroyStateMachineAssets(layer.stateMachine);
            }
            c.layers = keep.ToArray();
        }

        private static int RemoveLegacyLayers(AnimatorController c)
        {
            var keep = new List<AnimatorControllerLayer>();
            int removed = 0;
            foreach (var layer in c.layers)
            {
                if (layer.name == null || !LegacyLayers.Contains(layer.name))
                {
                    keep.Add(layer);
                    continue;
                }
                DestroyStateMachineAssets(layer.stateMachine);
                removed++;
            }
            c.layers = keep.ToArray();
            return removed;
        }

        private static void DestroyStateMachineAssets(AnimatorStateMachine sm)
        {
            if (sm == null) return;

            foreach (var t in sm.anyStateTransitions) Object.DestroyImmediate(t, true);
            foreach (var t in sm.entryTransitions) Object.DestroyImmediate(t, true);

            foreach (var child in sm.states)
            {
                if (child.state == null) continue;
                foreach (var t in child.state.transitions) Object.DestroyImmediate(t, true);

                // Parameter drivers are sub-assets too. The loadout layer is rebuilt on every
                // run, so skipping these would leak a driver per preset per build.
                foreach (var b in child.state.behaviours)
                    if (b != null) Object.DestroyImmediate(b, true);

                Object.DestroyImmediate(child.state, true);
            }

            foreach (var child in sm.stateMachines)
                DestroyStateMachineAssets(child.stateMachine);

            Object.DestroyImmediate(sm, true);
        }

        private static AnimatorState AddLayerWithState(AnimatorController c, string layerName,
                                                       string stateName,
                                                       out AnimatorStateMachine sm)
        {
            c.AddLayer(layerName);
            var layers = c.layers;
            var layer = layers[layers.Length - 1];
            layer.defaultWeight = 1f;
            layer.blendingMode = AnimatorLayerBlendingMode.Override;
            c.layers = layers;

            sm = layer.stateMachine;
            var state = sm.AddState(stateName);
            state.writeDefaultValues = false;
            sm.defaultState = state;
            return state;
        }

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
        /// </summary>
        private static void BuildSlotLayer(AnimatorController c, Slot slot)
        {
            var empty = AssetDatabase.LoadAssetAtPath<AnimationClip>(EmptyClipPath);

            var idle = AddLayerWithState(c, slot.Layer, "idle", out var sm);
            idle.motion = empty;

            // Every member state first, so the direct swaps below have something to point at.
            var states = new List<(Member Member, AnimatorState State)>();
            foreach (var m in slot.Members)
            {
                var state = sm.AddState(m.StateName);
                state.writeDefaultValues = false;
                state.motion = AssetDatabase.LoadAssetAtPath<AnimationClip>(m.ClipPath);
                states.Add((m, state));
            }

            foreach (var (m, state) in states)
                Wire(idle.AddTransition(state), AnimatorConditionMode.Equals, m.Value, slot.Param);

            // One way out of each member, and it goes to idle. Any change to the slot - to
            // another member or to bare - takes this same path, which is what makes every
            // swap "old one leaves, then new one arrives" rather than a crossfade.
            foreach (var (m, state) in states)
                Wire(state.AddTransition(idle),
                     AnimatorConditionMode.NotEqual, m.Value, slot.Param);

            sm.defaultState = idle;
        }

        /// <summary>
        /// One place where every slot transition gets its timing, so the fade cannot be lost
        /// from some of them and kept in others.
        /// </summary>
        private static void Wire(AnimatorStateTransition t, AnimatorConditionMode mode,
                                 float threshold, string param)
        {
            t.hasExitTime = false;
            t.hasFixedDuration = true;
            t.duration = FadeSeconds;
            t.offset = 0f;
            t.AddCondition(mode, threshold, param);
        }

        /// <summary>
        /// The preset layer. Driver-only: every state plays the empty clip and animates
        /// nothing, so this layer can never fight the slot layers over a property - it only
        /// writes parameters, which the slot layers then react to.
        /// </summary>
        private static void BuildLoadoutLayer(AnimatorController c)
        {
            var empty = AssetDatabase.LoadAssetAtPath<AnimationClip>(EmptyClipPath);

            var idle = AddLayerWithState(c, LoadoutLayer, "idle", out var sm);
            idle.motion = empty;

            foreach (var preset in Presets)
            {
                var state = sm.AddState(preset.StateName);
                state.writeDefaultValues = false;
                state.motion = empty;

                var driver = state.AddStateMachineBehaviour<VRCAvatarParameterDriver>();
                driver.localOnly = false;
                driver.parameters = preset.Sets
                    .Select(s => new VRC_AvatarParameterDriver.Parameter
                    {
                        name = s.Param,
                        value = s.Value,
                        type = VRC_AvatarParameterDriver.ChangeType.Set,
                    })
                    .ToList();

                // The self-reset, appended to every preset. Without it this state re-enters
                // forever and pins the slot ints - see the Presets comment.
                driver.parameters.Add(new VRC_AvatarParameterDriver.Parameter
                {
                    name = LoadoutParam,
                    value = 0f,
                    type = VRC_AvatarParameterDriver.ChangeType.Set,
                });

                // Instant on purpose, unlike the slot layers: these transitions carry no
                // visuals, they only gate a driver. The fade happens downstream, when the slot
                // layers react to the ints this writes.
                var on = idle.AddTransition(state);
                on.hasExitTime = false;
                on.duration = 0f;
                on.AddCondition(AnimatorConditionMode.Equals, preset.Value, LoadoutParam);

                // Fires the frame after the driver has run, because the driver set loadout
                // to 0 on entry.
                var off = state.AddTransition(idle);
                off.hasExitTime = false;
                off.duration = 0f;
                off.AddCondition(AnimatorConditionMode.NotEqual, preset.Value, LoadoutParam);
            }

            sm.defaultState = idle;
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
        /// </summary>
        private static (int Transitions, int Conditions) DecoupleWingsFromRcs(AnimatorController c)
        {
            var layer = c.layers.FirstOrDefault(l => l.name == WingLayer);
            if (layer == null || layer.stateMachine == null)
            {
                Debug.LogWarning($"[slots] Layer '{WingLayer}' not found; skipped decoupling " +
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
