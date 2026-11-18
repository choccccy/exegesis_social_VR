using System.Collections.Generic;
using System.Linq;
using Exegesis.Shared;
using NUnit.Framework;
using UnityEditor.Animations;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// The wings answer to wings_deployed and nothing else.
    ///
    /// wing_deploy once entered its deployed state on `wings_deployed OR rcs`. rcs defaults to
    /// 1 and is not saved, so the wings were out on every load while rcs_group_wings - which
    /// gates the wing plumes on wings_deployed alone - kept the plumes off. The slot tool used
    /// to strip rcs out of the hand-built layer on every build. The layer is now generated
    /// (CommonLayers.WingDeploy in Exegesis.Fx) and never writes the condition, so this is what guards it.
    ///
    /// The golden snapshot pins this too, but a snapshot can be re-blessed in bulk without
    /// anyone reading this particular line. This test says why it matters.
    /// </summary>
    public class WingDeployTests
    {
        private static IEnumerable<FxController> AllControllers => FxControllers.All;

        [TestCaseSource(nameof(AllControllers))]
        public void WingDeploy_NeverConditionsOnRcs(FxController fx)
        {
            var controller = ControllerSnapshotBaseline.LoadController(fx);
            Assert.IsNotNull(controller, $"No AnimatorController at {fx.ControllerPath}.");

            var layer = controller.layers.FirstOrDefault(l => l.name == "wing_deploy");
            Assert.IsNotNull(layer, $"{fx.Name}: no wing_deploy layer.");

            var sm = layer.stateMachine;
            var transitions = sm.anyStateTransitions
                .Concat(sm.states.SelectMany(s => s.state.transitions));

            var offenders = transitions
                .Where(t => t.conditions.Any(c => c.parameter == "rcs"))
                .Select(t => $"{t.destinationState?.name ?? "(exit)"}")
                .ToArray();

            CollectionAssert.IsEmpty(offenders,
                $"{fx.Name}: wing_deploy has transitions conditioned on `rcs`, into: " +
                string.Join(", ", offenders) + ". rcs is 1 on every load, so the wings would " +
                "deploy with their plumes off. Rebuild with Tools > Exegesis > Build FX Controllers.");
        }
    }
}
