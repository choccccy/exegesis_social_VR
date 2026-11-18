using System.Collections.Generic;
using System.Linq;
using Exegesis.Fx;
using Exegesis.Shared;
using NUnit.Framework;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// The avatar definitions are well-formed: one per controller, and every layer spec in them
    /// valid. A bad spec makes the build refuse to touch the controller, which is safe but easy
    /// to miss in a log; this names the problem as a failing test instead.
    /// </summary>
    public class AvatarDefinitionTests
    {
        private static IEnumerable<FxController> AllControllers => FxControllers.All;

        [TestCaseSource(nameof(AllControllers))]
        public void EveryController_HasAValidDefinition(FxController fx)
        {
            var avatar = Avatars.For(fx);

            var problems = avatar.Layers.SelectMany(l => l.Problems()).ToList();
            problems.AddRange(avatar.Layers.GroupBy(l => l.Name).Where(g => g.Count() > 1)
                                    .Select(g => $"layer '{g.Key}' is defined {g.Count()} times."));

            CollectionAssert.IsEmpty(problems, $"{fx.Name}'s AvatarDefinition has problems.");
        }

        [Test]
        public void EveryDefinition_IsForARegisteredController()
        {
            var registered = FxControllers.All.Select(c => c.Name).ToList();
            var orphans = Avatars.All.Select(a => a.Fx.Name).Where(n => !registered.Contains(n)).ToList();

            CollectionAssert.IsEmpty(orphans,
                "These avatar definitions point at controllers missing from FxControllers.All, " +
                "so the builder never builds them.");
        }
    }
}
