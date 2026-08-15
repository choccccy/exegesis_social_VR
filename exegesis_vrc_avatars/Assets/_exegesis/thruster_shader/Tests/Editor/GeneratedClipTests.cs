using System.Collections.Generic;
using System.Linq;
using System.Text;
using Exegesis.Shared;
using NUnit.Framework;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Guards the generated clips against writing NOTHING.
    ///
    /// Every RCS state runs with Write Defaults off, which is what lets the layers stack
    /// without fighting each other - but it also means a state playing an empty clip
    /// leaves its property at whatever the material shipped. A gate clip meant to force
    /// _GroupEnable.z to 0 that instead writes no curve at all does not fail loudly; the
    /// property simply holds the material's 1 and the thrusters fire regardless of the
    /// bool. It presents as "the shader ignores my parameter", which sends the search to
    /// the shader and the vertex paint - a long way from the actual cause.
    ///
    /// That happened: one clip out of 38 in an otherwise-clean build serialized with
    /// m_FloatCurves: [] (rcs_group_thighs_stowed). RcsAnimatorSetup audits every clip after
    /// the build; this test pins the invariant from the other side, against what is on disk.
    ///
    /// WHERE the clips live changed with the Animator As Code migration and nothing else did.
    /// They used to be 38 .anim files in ncho_anim/rcs_generated/; AAC owns clip creation now,
    /// and its assets live in the container it is given - the controller. Both assertions below
    /// are the ones this file has always made. Only the lookup moved.
    /// </summary>
    [TestFixture]
    public class GeneratedClipTests
    {
        private const string ControllerPath =
            "Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller";

        /// <summary>
        /// Every clip the rcs_* layers reference.
        ///
        /// Reachability, not "every clip sub-asset in the file". The controller carries two
        /// orphaned clips from an old duplicate-the-controller operation ("Copied from
        /// ncho_fx/..."), and one of them has no curves - so the blunter query would report a
        /// permanent, unfixable failure that has nothing to do with the generators.
        /// </summary>
        private static AnimationClip[] LoadGeneratedClips()
        {
            var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(ControllerPath);
            Assert.IsNotNull(controller, $"No AnimatorController at {ControllerPath}.");
            return AnimatorAssets.ClipsReachableFrom(controller, "rcs_").ToArray();
        }

        [Test]
        public void EveryGeneratedClip_WritesAtLeastOneCurve()
        {
            var clips = LoadGeneratedClips();
            Assert.IsNotEmpty(clips,
                $"No generated clips found inside {ControllerPath} - run Build RCS Animator " +
                "Layers first.");

            var empty = new List<string>();
            foreach (var clip in clips)
                if (AnimationUtility.GetCurveBindings(clip).Length == 0)
                    empty.Add(clip.name);

            if (empty.Count == 0) return;

            var sb = new StringBuilder();
            sb.AppendLine($"{empty.Count} of {clips.Length} generated clips write no curves:");
            foreach (var n in empty) sb.AppendLine("  " + n);
            sb.AppendLine("With Write Defaults off these states leave their property at the");
            sb.AppendLine("material value, so any gate they implement silently does nothing.");
            Assert.Fail(sb.ToString());
        }

        /// <summary>
        /// The three visibility gates are only meaningful as PAIRS: one state must drive
        /// the component to 0 and the other to 1. Checking both halves catches a clip that
        /// exists and has curves but carries the wrong value - the other way a gate can be
        /// present and still not gate.
        /// </summary>
        [TestCase("rcs_group_packs_covered", "rcs_group_packs_clear", "_GroupEnable.x")]
        [TestCase("rcs_group_wings_stowed", "rcs_group_wings_out", "_GroupEnable.y")]
        [TestCase("rcs_group_thighs_stowed", "rcs_group_thighs_worn", "_GroupEnable.z")]
        public void GatePair_DrivesItsComponentBothWays(string offClip, string onClip, string prop)
        {
            var clips = LoadGeneratedClips();
            AssertGateClip(clips, offClip, prop, 0f);
            AssertGateClip(clips, onClip, prop, 1f);
        }

        private static void AssertGateClip(AnimationClip[] clips, string clipName, string prop,
                                           float expected)
        {
            // Clip names are a contract, not a convenience: this is how the gates are found
            // here, and how anyone reading the controller in the Animator window tells them
            // apart. ExegesisAac.Clip exists to keep them stable in the face of AAC's
            // random-suffixed generated naming.
            var clip = clips.FirstOrDefault(c => c.name == clipName);
            Assert.IsNotNull(clip,
                $"No clip named '{clipName}' inside {ControllerPath} - re-run Build RCS " +
                $"Animator Layers. Present: {string.Join(", ", clips.Select(c => c.name).OrderBy(n => n))}");

            var binding = "material." + prop;
            var found = new List<string>();

            foreach (var b in AnimationUtility.GetCurveBindings(clip))
            {
                if (b.propertyName != binding) continue;
                found.Add(b.path);

                var curve = AnimationUtility.GetEditorCurve(clip, b);
                Assert.IsNotNull(curve, $"{clipName}: binding {b.path}/{binding} has a null curve.");
                Assert.IsNotEmpty(curve.keys, $"{clipName}: binding {b.path}/{binding} has no keyframes.");

                foreach (var k in curve.keys)
                    Assert.AreEqual(expected, k.value, 0.0001f,
                        $"{clipName} drives {b.path}/{binding} to {k.value}, expected {expected}. " +
                        "A gate whose off-state does not reach 0 cannot silence its group.");
            }

            // Both renderers carry thrusters.mat, so both must be written; leaving one out
            // gates half the avatar.
            CollectionAssert.AreEquivalent(new[] { "Body", "Props" }, found,
                $"{clipName} must drive {binding} on both Body and Props, but wrote: " +
                (found.Count == 0 ? "nothing" : string.Join(", ", found)));
        }
    }
}
