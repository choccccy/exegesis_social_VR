// NchoSlotSetup only exists when the VRChat SDK does, and a rebuild needs both tools.
#if VRC_SDK_VRCSDK3

using System.Collections.Generic;
using System.IO;
using System.Linq;
using Exegesis.Ncho;
using Exegesis.Shared;
using NUnit.Framework;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;
using UnityEngine.TestTools;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// What the generators guarantee about their own output, permanently.
    ///
    /// The headline is that the committed controller is exactly what the generators produce.
    /// That is the strongest single assertion in the suite: the migration's A/B test only proved
    /// that the new code agreed with the old code, so if both were wrong in the same way, or if
    /// the committed asset had drifted from either, it would still have passed. This compares a
    /// fresh build against the asset that actually ships.
    ///
    /// It therefore catches three separate things:
    ///   - a generated layer edited by hand in the Animator window and never regenerated;
    ///   - a change to a generator that was never re-run, so the tool and the asset disagree;
    ///   - a generator that is not idempotent, which is the property that makes re-running the
    ///     tools the normal way to apply a change.
    ///
    /// When it fails after a deliberate generator change, the fix is to run
    /// Tools > Exegesis > Build ncho Slot Layers then Build RCS Animator Layers, in that order,
    /// and commit the resulting controller - not to relax this test.
    /// </summary>
    public class GeneratorIdempotenceTests
    {
        private const string TestsDir = "Assets/_exegesis/thruster_shader/Tests/Editor";
        private const string ScratchName = "__idempotence_scratch";
        private const string Scratch = TestsDir + "/" + ScratchName;

        [SetUp]
        public void SetUp()
        {
            if (AssetDatabase.IsValidFolder(Scratch)) AssetDatabase.DeleteAsset(Scratch);
            AssetDatabase.CreateFolder(TestsDir, ScratchName);

            // VerifyGeneratedClips reports through Debug.LogError, and the Test Framework fails
            // any test that logs an unexpected error. The snapshot comparison is the assertion.
            LogAssert.ignoreFailingMessages = true;
        }

        [TearDown]
        public void TearDown()
        {
            LogAssert.ignoreFailingMessages = false;
            if (AssetDatabase.IsValidFolder(Scratch)) AssetDatabase.DeleteAsset(Scratch);
        }

        [Test]
        public void RebuildingTheCommittedController_ReproducesIt()
        {
            var committed = ControllerSnapshotBaseline.LoadController();
            Assert.IsNotNull(committed,
                $"No AnimatorController at {ControllerSnapshotBaseline.ControllerPath}.");

            var rebuiltPath = $"{Scratch}/rebuilt.controller";
            Assert.IsTrue(
                AssetDatabase.CopyAsset(ControllerSnapshotBaseline.ControllerPath, rebuiltPath),
                "Could not copy the committed controller into the scratch folder.");
            AssetDatabase.ImportAsset(rebuiltPath, ImportAssetOptions.ForceSynchronousImport);

            var rebuilt = AssetDatabase.LoadAssetAtPath<AnimatorController>(rebuiltPath);
            Assert.IsNotNull(rebuilt, "The scratch copy did not load.");

            // Slots first: that tool declares the ints the RCS group layers condition on, which
            // is what the menu priorities encode.
            NchoSlotSetup.Build(rebuilt);
            RcsAnimatorSetup.Build(rebuilt);

            AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset(rebuiltPath,
                ImportAssetOptions.ForceUpdate | ImportAssetOptions.ForceSynchronousImport);
            rebuilt = AssetDatabase.LoadAssetAtPath<AnimatorController>(rebuiltPath);

            // Compact detail: the rebuild writes its clips to a scratch folder, so they are
            // different ASSETS from the committed ones carrying identical content. Comparing by
            // content hash is the point - identity would differ and behaviour does not.
            var expected = ControllerSnapshot.Of(committed, ControllerSnapshot.Detail.Compact);
            var actual = ControllerSnapshot.Of(rebuilt, ControllerSnapshot.Detail.Compact);

            if (expected == actual) return;

            var dir = Path.Combine(Path.GetTempPath(), "rcs_controller_diff");
            Directory.CreateDirectory(dir);
            File.WriteAllText(Path.Combine(dir, "committed.snapshot.txt"), expected);
            File.WriteAllText(Path.Combine(dir, "rebuilt.snapshot.txt"), actual);

            Assert.Fail(
                "Rebuilding the committed controller did not reproduce it. Either a generated " +
                "layer has been hand-edited, or a generator changed and was never re-run.\n\n" +
                SnapshotDiff.Describe(expected, actual) +
                $"\n\nFull snapshots written to {dir}. '-' is the committed asset, '+' is the " +
                "fresh build. Fix by running Tools > Exegesis > Build ncho Slot Layers then " +
                "Build RCS Animator Layers and committing the result.");
        }

        /// <summary>
        /// Rebuilding must not grow the controller file.
        ///
        /// This is the one failure ControllerSnapshot cannot see, and it is worth being explicit
        /// about why: the snapshot walks the object graph reachable from the layers, so a
        /// sub-asset that nothing references any more is invisible to it. Two builds could
        /// therefore compare byte-identical while the .controller quietly doubled in size.
        ///
        /// Animator As Code makes this a live concern rather than a theoretical one. It creates
        /// a throwaway empty clip per layer, its layer-clearing path detaches states and
        /// transitions without destroying them, and its own ClearPreviousAssets only ever
        /// removes clips, blend trees and avatar masks. AnimatorAssets.SweepUnreachableSubAssets
        /// is what holds this line; this test is what proves it still does.
        /// </summary>
        [Test]
        public void RebuildingTwice_DoesNotAccumulateSubAssets()
        {
            var path = $"{Scratch}/accumulate.controller";
            Assert.IsTrue(AssetDatabase.CopyAsset(ControllerSnapshotBaseline.ControllerPath, path),
                          "Could not copy the committed controller into the scratch folder.");

            int first = BuildAndCountSubAssets(path);
            int second = BuildAndCountSubAssets(path);

            Assert.AreEqual(first, second,
                $"A second rebuild left {second - first} extra sub-asset(s) in the controller. " +
                "The file grows on every build, and nothing else in the suite would notice - " +
                "the snapshot only sees objects the layers still reference.");

            // Nothing should still be carrying AAC's generated naming. If it is, either a
            // creation site skipped the rename helpers in ExegesisAac, or an orphan survived the
            // sweep - and orphaned AAC assets are exactly what makes the committed diff churn.
            var stillDecorated = AssetDatabase.LoadAllAssetsAtPath(path)
                .Where(o => o != null && o.name != null && o.name.StartsWith("zAutogenerated"))
                .Select(o => $"{o.GetType().Name} '{o.name}'")
                .ToArray();

            CollectionAssert.IsEmpty(stillDecorated,
                "Sub-assets are still using Animator As Code's generated names, which carry a " +
                "random integer suffix and therefore change on every build. Create them through " +
                "ExegesisAac.Clip / DirectTree / Tree1D so the committed controller stays " +
                "reviewable in a diff.");
        }

        /// <summary>
        /// A build that differs from itself cannot be compared against anything.
        ///
        /// Aimed squarely at Animator As Code, which names every generated sub-asset with a
        /// fresh random integer suffix. If that ever leaks past ExegesisAac's renaming helpers,
        /// the committed controller starts churning on every rebuild and every comparison
        /// against it becomes a coin toss.
        /// </summary>
        [Test]
        public void BuildingTwice_ProducesTheSameController()
        {
            var first = ControllerSnapshot.Of(BuildIntoScratch("repeat_a"));
            var second = ControllerSnapshot.Of(BuildIntoScratch("repeat_b"));

            if (first == second) return;

            var dir = DumpForInspection("repeat_a", first, "repeat_b", second);
            Assert.Fail(
                "Two identical builds produced different controllers.\n\n" +
                SnapshotDiff.Describe(first, second) +
                $"\n\nFull snapshots written to {dir}.");
        }

        /// <summary>
        /// Every generated curve binds either an Animator parameter at the empty path, or a
        /// material property on one of the two renderers carrying thrusters.mat.
        ///
        /// This is the contract MaterialBindingTests validates from the other side, and it is
        /// also what keeps the generators scene-less: AAC's Transform, GameObject and Component
        /// clip overloads resolve paths against AacConfiguration.AnimatorRoot, which is the only
        /// thing that would ever need a scene loaded. A path outside this set means one of those
        /// overloads has crept in, and the headless run is about to stop working.
        /// </summary>
        [Test]
        public void GeneratedClips_BindOnlyByStringPath()
        {
            var controller = BuildIntoScratch("bindings");

            var offenders = new List<string>();
            foreach (var clip in AnimatorAssets.ClipsReachableFrom(controller, "rcs_"))
            {
                foreach (var b in AnimationUtility.GetCurveBindings(clip))
                {
                    bool ok = b.type == typeof(Animator)
                        ? b.path == ""
                        : b.path == "Body" || b.path == "Props";

                    if (!ok)
                        offenders.Add($"clip '{clip.name}' binds '{b.propertyName}' " +
                                      $"({b.type?.Name}) at path '{b.path}'");
                }
            }

            CollectionAssert.IsEmpty(offenders,
                "Generated clips must bind Animator parameters at the empty path and material " +
                "properties at 'Body' or 'Props', by string. Anything else means a scene-resolved " +
                "path has appeared, which breaks both the headless run and the material binding " +
                "the animations rely on.");
        }

        /// <summary>
        /// A fresh copy of the committed controller with both generators run over it.
        /// </summary>
        private static AnimatorController BuildIntoScratch(string name)
        {
            var path = $"{Scratch}/{name}.controller";
            Assert.IsTrue(AssetDatabase.CopyAsset(ControllerSnapshotBaseline.ControllerPath, path),
                          $"Could not copy the committed controller to {path}.");
            AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceSynchronousImport);

            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(path);
            Assert.IsNotNull(controller, $"Copy at {path} did not load.");

            // Slots first: that tool declares the ints the RCS group layers condition on.
            NchoSlotSetup.Build(controller);
            RcsAnimatorSetup.Build(controller);

            AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset(path,
                ImportAssetOptions.ForceUpdate | ImportAssetOptions.ForceSynchronousImport);

            return AssetDatabase.LoadAssetAtPath<AnimatorController>(path);
        }

        private static string DumpForInspection(string aName, string a, string bName, string b)
        {
            var dir = Path.Combine(Path.GetTempPath(), "rcs_controller_diff");
            Directory.CreateDirectory(dir);
            File.WriteAllText(Path.Combine(dir, $"{aName}.snapshot.txt"), a);
            File.WriteAllText(Path.Combine(dir, $"{bName}.snapshot.txt"), b);
            return dir;
        }

        private static int BuildAndCountSubAssets(string controllerPath)
        {
            AssetDatabase.ImportAsset(controllerPath, ImportAssetOptions.ForceSynchronousImport);
            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(controllerPath);
            Assert.IsNotNull(controller, $"Controller at {controllerPath} did not load.");

            NchoSlotSetup.Build(controller);
            RcsAnimatorSetup.Build(controller);

            AssetDatabase.SaveAssets();
            AssetDatabase.ImportAsset(controllerPath,
                ImportAssetOptions.ForceUpdate | ImportAssetOptions.ForceSynchronousImport);

            return AssetDatabase.LoadAllAssetsAtPath(controllerPath).Count(o => o != null);
        }
    }
}

#endif
