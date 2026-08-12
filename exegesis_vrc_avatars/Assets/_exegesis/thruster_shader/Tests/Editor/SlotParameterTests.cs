using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Guards the accessory-slot migration: accessories that share a physical mount are
    /// selected by one <b>int</b> per mount (0 = bare, 1 = first, 2 = second) instead of one
    /// bool each, so exclusivity is structural rather than policed.
    ///
    /// Two things make this worth testing rather than trusting.
    ///
    /// First, the failure mode is silent. An <c>Equals</c> condition on a parameter the
    /// controller believes is a <c>Bool</c> never matches, so a half-applied migration leaves
    /// a layer stuck in one state with nothing logged - the same shape of bug as the empty
    /// gate clip and the non-neutral shader default, both of which cost hours before they were
    /// pinned by tests.
    ///
    /// Second, the migration spans two generators that must agree: NchoSlotSetup owns the
    /// slot_* layers and the ints; RcsAnimatorSetup owns the rcs_group_* layers that read
    /// them. Nothing but a test checks that they were both re-run.
    ///
    /// See docs/accessories.md.
    /// </summary>
    [TestFixture]
    public class SlotParameterTests
    {
        private const string ControllerPath =
            "Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller";

        private const string BackSlot = "back_slot";
        private const string ThighSlot = "thigh_slot";

        // Must match the slot tables in NchoSlotSetup and the constant in RcsAnimatorSetup.
        private const int ThighSlotThrusters = 2;

        private static readonly string[] SlotLayers = { "slot_back", "slot_thigh" };

        /// <summary>Bools the slot ints replaced. None may still be driving anything.</summary>
        private static readonly string[] RetiredParams =
        {
            "thruster_backpack", "arm_backpack", "thigh_hard-cases", "thigh_thrusters",
        };

        private static AnimatorController Load()
        {
            var c = AssetDatabase.LoadAssetAtPath<AnimatorController>(ControllerPath);
            Assert.IsNotNull(c, $"Could not load {ControllerPath}.");
            return c;
        }

        private static AnimatorControllerLayer Layer(AnimatorController c, string name) =>
            c.layers.FirstOrDefault(l => l.name == name);

        private static IEnumerable<AnimatorStateTransition> Transitions(AnimatorControllerLayer l)
        {
            if (l?.stateMachine == null) yield break;
            foreach (var t in l.stateMachine.anyStateTransitions) yield return t;
            foreach (var child in l.stateMachine.states)
            {
                if (child.state == null) continue;
                foreach (var t in child.state.transitions) yield return t;
            }
        }

        /// <summary>
        /// The gate. Deliberately one test with one message rather than a dozen, because until
        /// both generators have been re-run in the editor the answer to every individual
        /// question is the same: "the migration has not been applied yet".
        ///
        /// This does NOT Assert.Ignore itself when unmigrated. An ignoring guard is a guard
        /// that passes forever if the migration is never finished, which is the failure it is
        /// supposed to prevent.
        /// </summary>
        [Test]
        public void SlotMigration_IsFullyApplied()
        {
            var c = Load();
            var problems = new List<string>();

            foreach (var name in SlotLayers)
                if (Layer(c, name) == null)
                    problems.Add($"layer '{name}' is missing");

            foreach (var p in new[] { BackSlot, ThighSlot })
            {
                var param = c.parameters.FirstOrDefault(x => x.name == p);
                if (param == null)
                    problems.Add($"parameter '{p}' is not declared");
                else if (param.type != AnimatorControllerParameterType.Int)
                    problems.Add($"parameter '{p}' is {param.type}, must be Int - " +
                                 "Equals conditions on it are currently inert");
            }

            // The RCS gates must read the slots, not the retired bools.
            AssertGatesOn(c, "rcs_group_packs", BackSlot, problems);
            AssertGatesOn(c, "rcs_group_thighs", ThighSlot, problems);

            foreach (var retired in RetiredParams)
            {
                var users = c.layers
                    .Where(l => Transitions(l).Any(t => t.conditions.Any(x => x.parameter == retired)))
                    .Select(l => l.name)
                    .ToArray();
                if (users.Length > 0)
                    problems.Add($"retired parameter '{retired}' is still used by: " +
                                 string.Join(", ", users));
            }

            if (problems.Count == 0) return;

            var sb = new StringBuilder("The accessory-slot migration is not fully applied:\n");
            foreach (var p in problems) sb.AppendLine("  - " + p);
            sb.AppendLine();
            sb.AppendLine("Fix by running BOTH generators, in this order:");
            sb.AppendLine("  1. Tools > Exegesis > Build ncho Slot Layers");
            sb.AppendLine("  2. Tools > Exegesis > Build RCS Animator Layers");
            sb.AppendLine("Order matters: the RCS group layers condition on the slot ints, which");
            sb.AppendLine("the first tool declares. See docs/accessories.md.");
            Assert.Fail(sb.ToString());
        }

        private static void AssertGatesOn(AnimatorController c, string layerName, string param,
                                          List<string> problems)
        {
            var layer = Layer(c, layerName);
            if (layer == null) { problems.Add($"layer '{layerName}' is missing"); return; }

            var conditions = Transitions(layer).SelectMany(t => t.conditions).ToArray();
            if (conditions.Length == 0)
            {
                problems.Add($"'{layerName}' has no transition conditions at all");
                return;
            }

            if (!conditions.Any(x => x.parameter == param))
                problems.Add($"'{layerName}' does not condition on '{param}' " +
                             $"(it uses: {string.Join(", ", conditions.Select(x => x.parameter).Distinct())})");

            // An int slot must be compared with Equals/NotEqual. If/IfNot are bool modes and
            // silently never match against an Int parameter.
            var wrongMode = conditions
                .Where(x => x.parameter == param)
                .Where(x => x.mode != AnimatorConditionMode.Equals &&
                            x.mode != AnimatorConditionMode.NotEqual)
                .Select(x => x.mode.ToString())
                .Distinct()
                .ToArray();
            if (wrongMode.Length > 0)
                problems.Add($"'{layerName}' compares '{param}' with {string.Join("/", wrongMode)}; " +
                             "an Int slot needs Equals/NotEqual");
        }

        /// <summary>
        /// The thigh plumes must fire for one specific slot member, not merely for "something
        /// worn on the thighs" - the hard-cases share that mount and carry no thrusters. A
        /// threshold of 0 here would light the plumes whenever the thighs were bare, which is
        /// the exact inversion a hand edit would produce.
        /// </summary>
        [Test]
        public void ThighGate_TargetsTheThrusterMemberSpecifically()
        {
            var c = Load();
            var layer = Layer(c, "rcs_group_thighs");
            if (layer == null) Assert.Ignore("rcs_group_thighs missing; run the generators.");

            var onThighSlot = Transitions(layer)
                .SelectMany(t => t.conditions)
                .Where(x => x.parameter == ThighSlot)
                .ToArray();

            if (onThighSlot.Length == 0)
                Assert.Ignore($"rcs_group_thighs does not reference {ThighSlot} yet; " +
                              "SlotMigration_IsFullyApplied covers that.");

            CollectionAssert.AreEquivalent(
                new[] { ThighSlotThrusters, ThighSlotThrusters },
                onThighSlot.Select(x => (int)x.threshold).ToArray(),
                $"Both thigh-gate conditions must test {ThighSlot} == {ThighSlotThrusters} " +
                "(the thruster packs). Any other value gates the plumes on the wrong member - " +
                "0 would light them while the thighs are bare.");
        }

        /// <summary>
        /// Accessories must dissolve in and out over ~0.25s, not pop.
        ///
        /// This is pinned because it was lost once and no automated check noticed: the fade is
        /// not in the clips, which are two-key constants - it comes entirely from the
        /// TRANSITION DURATION, so rebuilding the layers with a default duration of 0 silently
        /// removed it. Nothing failed, nothing logged; it was only visible by wearing the
        /// avatar.
        ///
        /// hasFixedDuration is checked too, because 0.25 normalised against a one-frame clip is
        /// about 4ms - a pop wearing the right number.
        /// </summary>
        [Test]
        public void SlotTransitions_KeepTheFade()
        {
            const float ExpectedFade = 0.25f;

            var c = Load();
            var failures = new StringBuilder();

            foreach (var layerName in SlotLayers)
            {
                var layer = Layer(c, layerName);
                if (layer == null)
                    Assert.Ignore($"'{layerName}' missing; run Build ncho Slot Layers.");

                var ts = Transitions(layer).ToArray();
                if (ts.Length == 0)
                {
                    failures.AppendLine($"  {layerName} has no transitions at all");
                    continue;
                }

                foreach (var t in ts)
                {
                    var where = $"{layerName}: -> {t.destinationState?.name ?? "(exit)"}";

                    if (!t.hasFixedDuration)
                        failures.AppendLine($"  {where} has hasFixedDuration off, so its " +
                                            "duration is a fraction of a one-frame clip");

                    if (!Mathf.Approximately(t.duration, ExpectedFade))
                        failures.AppendLine($"  {where} duration is {t.duration}s, expected " +
                                            $"{ExpectedFade}s");
                }
            }

            Assert.IsEmpty(failures.ToString(),
                "Accessory fades are wrong - they will pop in and out instead of dissolving:\n" +
                failures + "The fade comes from the transition duration, not the clips. See " +
                "FadeSeconds in NchoSlotSetup.cs.");
        }

        /// <summary>
        /// Swapping accessories must go **through `idle`**, never member-to-member: the old item
        /// fades out completely, then the new one fades in. One leaves, then the next arrives.
        ///
        /// This is a deliberate look, inherited from the ChoccyWicker clothing layers, and the
        /// reason it needs a test is that the alternative is *tempting*. A direct
        /// member-to-member transition halves the swap time and seems like a free win — but it
        /// crossfades, so two pieces of solid hardware dissolve into each other, both
        /// half-transparent and interpenetrating. That reads as a glitch, not a transition. It
        /// was implemented that way once and had to be reverted.
        ///
        /// So this asserts the ABSENCE of an optimisation, which no amount of reading the code
        /// will tell you was intentional.
        /// </summary>
        [Test]
        public void SlotMembers_SwapViaIdleNotDirectly()
        {
            var c = Load();
            var failures = new StringBuilder();

            foreach (var layerName in SlotLayers)
            {
                var layer = Layer(c, layerName);
                if (layer == null)
                    Assert.Ignore($"'{layerName}' missing; run Build ncho Slot Layers.");

                var members = layer.stateMachine.states
                    .Select(s => s.state)
                    .Where(s => s != null && s.name != "idle")
                    .ToArray();

                foreach (var state in members)
                {
                    var dests = state.transitions
                        .Select(t => t.destinationState?.name ?? "(exit)")
                        .ToArray();

                    if (!dests.Contains("idle"))
                        failures.AppendLine($"  {layerName}/{state.name} cannot reach idle, so it " +
                                            "can never be taken off");

                    foreach (var d in dests)
                    {
                        if (d == "idle") continue;
                        failures.AppendLine($"  {layerName}/{state.name} transitions straight to " +
                                            $"'{d}'. Swaps must pass through idle so the old item " +
                                            "is fully gone before the new one appears - a direct " +
                                            "transition crossfades them into each other.");
                    }
                }
            }

            Assert.IsEmpty(failures.ToString(),
                "Slot swaps are not sequential:\n" + failures);
        }

        /// <summary>
        /// The structural exclusivity claim, checked directly: within a slot layer every
        /// member state is entered on Equals-its-own-value and left on NotEqual-the-same-value,
        /// and no two members share a value. That combination is what makes two accessories on
        /// one mount unrepresentable.
        /// </summary>
        [Test]
        public void SlotLayers_AreMutuallyExclusiveByConstruction()
        {
            var c = Load();
            var failures = new StringBuilder();

            foreach (var layerName in SlotLayers)
            {
                var layer = Layer(c, layerName);
                if (layer == null)
                    Assert.Ignore($"'{layerName}' missing; run Build ncho Slot Layers.");

                var sm = layer.stateMachine;
                Assert.IsNotNull(sm, $"'{layerName}' has no state machine.");
                Assert.IsNotNull(sm.defaultState, $"'{layerName}' has no default state.");
                Assert.AreEqual("idle", sm.defaultState.name,
                    $"'{layerName}' must default to 'idle' - that is what makes 0, and any " +
                    "unmapped value, mean nothing worn.");

                var seen = new Dictionary<int, string>();

                foreach (var child in sm.states)
                {
                    var state = child.state;
                    if (state == null || state.name == "idle") continue;

                    Assert.IsFalse(state.writeDefaultValues,
                        $"'{layerName}/{state.name}' has Write Defaults ON. The whole controller " +
                        "is WD-off; a WD-on state here would stomp the props_neutral base layer.");

                    var exits = state.transitions
                        .SelectMany(t => t.conditions)
                        .Where(x => x.mode == AnimatorConditionMode.NotEqual)
                        .ToArray();

                    if (exits.Length == 0)
                    {
                        failures.AppendLine($"  {layerName}/{state.name} has no NotEqual exit " +
                                            "condition, so it can never be left");
                        continue;
                    }

                    int value = (int)exits[0].threshold;
                    if (seen.TryGetValue(value, out var other))
                        failures.AppendLine($"  {layerName}: '{state.name}' and '{other}' both " +
                                            $"claim value {value} - they would appear together");
                    else
                        seen[value] = state.name;

                    var entries = sm.defaultState.transitions
                        .Where(t => t.destinationState == state)
                        .SelectMany(t => t.conditions)
                        .Where(x => x.mode == AnimatorConditionMode.Equals)
                        .Select(x => (int)x.threshold)
                        .ToArray();

                    if (!entries.Contains(value))
                        failures.AppendLine($"  {layerName}/{state.name} exits on != {value} but " +
                                            $"is not entered on == {value} " +
                                            $"(entered on: {string.Join(",", entries)}) - the state " +
                                            "would latch or never appear");
                }

                if (seen.Count == 0)
                    failures.AppendLine($"  {layerName} has no member states at all");
            }

            Assert.IsEmpty(failures.ToString(),
                "Slot layers are not exclusive by construction:\n" + failures);
        }
    }
}
