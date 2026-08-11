using System.Collections.Generic;
using System.IO;
using System.Text;
using NUnit.Framework;
using UnityEditor;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Guards the generated clips in rcs_generated/ against writing NOTHING.
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
    /// m_FloatCurves: [] (rcs_group_thighs_stowed.anim). RcsAnimatorSetup now persists
    /// each clip only after its curves are authored, and audits the folder afterwards;
    /// this test pins the invariant from the other side, against what is on disk.
    /// </summary>
    [TestFixture]
    public class GeneratedClipTests
    {
        private const string ClipDir = "Assets/_exegesis/ncho/ncho_anim/rcs_generated";

        private static AnimationClip[] LoadClips()
        {
            var clips = new List<AnimationClip>();
            foreach (var guid in AssetDatabase.FindAssets("t:AnimationClip", new[] { ClipDir }))
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(path);
                if (clip != null) clips.Add(clip);
            }
            return clips.ToArray();
        }

        [Test]
        public void EveryGeneratedClip_WritesAtLeastOneCurve()
        {
            if (!AssetDatabase.IsValidFolder(ClipDir))
                Assert.Ignore($"{ClipDir} does not exist - run Build RCS Animator Layers first.");

            var clips = LoadClips();
            Assert.IsNotEmpty(clips, $"No clips found in {ClipDir}.");

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
            if (!AssetDatabase.IsValidFolder(ClipDir))
                Assert.Ignore($"{ClipDir} does not exist - run Build RCS Animator Layers first.");

            AssertGateClip(offClip, prop, 0f);
            AssertGateClip(onClip, prop, 1f);
        }

        private static void AssertGateClip(string clipName, string prop, float expected)
        {
            var path = $"{ClipDir}/{clipName}.anim";
            var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(path);
            Assert.IsNotNull(clip, $"{path} missing - re-run Build RCS Animator Layers.");

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
