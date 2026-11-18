// The expression assets are VRChat SDK types.
#if VRC_SDK_VRCSDK3

using System.Collections.Generic;
using System.Linq;
using Exegesis.Fx;
using Exegesis.Shared;
using NUnit.Framework;
using UnityEditor;
using UnityEngine;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// The committed expression parameters and menus are exactly what the avatar definitions
    /// generate, and they agree with the FX controllers.
    ///
    /// The committed assets are the golden copies: each test fills a throwaway in-memory object
    /// through ExpressionsBuilder.Fill - the same code the build uses - and compares it with
    /// the asset on disk. A pass means building would change nothing.
    /// </summary>
    public class ExpressionTests
    {
        private static IEnumerable<FxController> AllControllers => FxControllers.All;

        [TestCaseSource(nameof(AllControllers))]
        public void CommittedExpressionParameters_MatchTheDefinition(FxController fx)
        {
            var spec = Avatars.For(fx).Expressions;
            var committed = AssetDatabase.LoadAssetAtPath<VRCExpressionParameters>(spec.ParametersAsset);
            Assert.IsNotNull(committed, $"No expression parameters at {spec.ParametersAsset}.");

            var generated = ScriptableObject.CreateInstance<VRCExpressionParameters>();
            try
            {
                generated.name = committed.name;
                ExpressionsBuilder.Fill(generated, spec);
                Assert.AreEqual(EditorJsonUtility.ToJson(committed, true), EditorJsonUtility.ToJson(generated, true),
                    $"{spec.ParametersAsset} differs from {fx.Name}'s definition. Run Tools > Exegesis > " +
                    "Build FX Controllers, or fix the definition if the asset is right.");
            }
            finally
            {
                Object.DestroyImmediate(generated);
            }
        }

        [TestCaseSource(nameof(AllControllers))]
        public void CommittedMenus_MatchTheDefinition(FxController fx)
        {
            var differing = new List<string>();
            foreach (var menu in Avatars.For(fx).Expressions.AllMenus())
            {
                var committed = AssetDatabase.LoadAssetAtPath<VRCExpressionsMenu>(menu.Path);
                if (committed == null)
                {
                    differing.Add($"{menu.Path} does not exist");
                    continue;
                }

                var generated = ScriptableObject.CreateInstance<VRCExpressionsMenu>();
                try
                {
                    generated.name = committed.name;
                    ExpressionsBuilder.Fill(generated, menu);
                    if (EditorJsonUtility.ToJson(committed, true) != EditorJsonUtility.ToJson(generated, true))
                        differing.Add(menu.Path);
                }
                finally
                {
                    Object.DestroyImmediate(generated);
                }
            }

            CollectionAssert.IsEmpty(differing,
                $"{fx.Name}: these menus differ from the definition. Run Tools > Exegesis > Build FX " +
                "Controllers, or fix the definition if the asset is right.");
        }

        /// <summary>
        /// Every expression parameter exists on the FX controller with the matching type, every
        /// menu control names an expression parameter, and shared menus are defined the same way
        /// by every avatar that uses them.
        /// </summary>
        [TestCaseSource(nameof(AllControllers))]
        public void Expressions_AgreeWithTheController(FxController fx)
        {
            var controller = ControllerSnapshotBaseline.LoadController(fx);
            Assert.IsNotNull(controller, $"No AnimatorController at {fx.ControllerPath}.");

            var problems = ExpressionsBuilder.Problems(Avatars.For(fx), controller)
                .Concat(ExpressionsBuilder.SharedMenuConflicts(Avatars.All))
                .ToList();

            CollectionAssert.IsEmpty(problems, $"{fx.Name}'s expressions have problems.");
        }
    }
}

#endif
