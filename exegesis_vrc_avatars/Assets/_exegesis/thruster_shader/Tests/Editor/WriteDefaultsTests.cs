using System.Collections.Generic;
using System.Linq;
using Exegesis.Shared;
using NUnit.Framework;
using UnityEditor.Animations;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Every state in every FX controller is Write Defaults OFF.
    ///
    /// That is what lets the layers stack: a state that writes nothing lets the layers below it
    /// win, which is how "bare" accessory slots and every *_neutral baseline work. A single
    /// Write Defaults ON state breaks that for every property its layer's clips touch, and with
    /// mixed Write Defaults the result depends on Unity's merge rules rather than layer order.
    ///
    /// Checks the whole controller, hand-built layers included. Until the 2026-11 ports,
    /// lemaitre's base layer and five obi-me states were ON; they were turned off when those
    /// layers moved to code (LayerSpec has no way to turn it back on).
    /// </summary>
    public class WriteDefaultsTests
    {
        private static IEnumerable<FxController> AllControllers => FxControllers.All;

        [TestCaseSource(nameof(AllControllers))]
        public void EveryState_IsWriteDefaultsOff(FxController fx)
        {
            var controller = ControllerSnapshotBaseline.LoadController(fx);
            Assert.IsNotNull(controller, $"No AnimatorController at {fx.ControllerPath}.");

            var on = controller.layers
                .SelectMany(l => States(l.stateMachine).Select(s => (Layer: l.name, State: s)))
                .Where(x => x.State.writeDefaultValues)
                .Select(x => $"{x.Layer} / {x.State.name}")
                .ToArray();

            CollectionAssert.IsEmpty(on,
                $"{fx.Name}: these states are Write Defaults ON. Every state must be OFF so the " +
                "layers stack by order.");
        }

        private static IEnumerable<AnimatorState> States(AnimatorStateMachine sm)
        {
            if (sm == null) yield break;
            foreach (var s in sm.states) yield return s.state;
            foreach (var child in sm.stateMachines)
                foreach (var s in States(child.stateMachine)) yield return s;
        }
    }
}
