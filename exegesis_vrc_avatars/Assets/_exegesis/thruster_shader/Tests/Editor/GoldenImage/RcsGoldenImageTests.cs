using System.IO;
using NUnit.Framework;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Golden-image regression tests for the RCS allocation maths.
    ///
    /// Two layers of assertion, deliberately:
    ///
    /// 1. A semantic check. States flagged ExpectDark must render essentially nothing;
    ///    the others must render something. This runs even in capture mode, because a
    ///    freshly captured baseline would happily enshrine a flipped sign - the pixel
    ///    diff can only tell you the render changed, never that it was ever right.
    /// 2. The pixel diff against the checked-in baseline, which catches everything else.
    /// </summary>
    [TestFixture]
    public class RcsGoldenImageTests
    {
        private const int ChannelTolerance = 8;
        private const float MaxDiffFraction = 0.005f;

        // A dark state still contains the clear colour (0.06), so "dark" is a threshold
        // just above it rather than zero. A firing face is far brighter than this.
        private const float DarkLuminanceMax = 0.10f;
        private const float LitLuminanceMin = 0.12f;

        private static bool CaptureMode =>
            System.Environment.GetEnvironmentVariable("RCS_CAPTURE_BASELINES") == "1" ||
            System.Environment.GetEnvironmentVariable("HUD_CAPTURE_BASELINES") == "1";

        [Test]
        public void Shader_IsAvailableForRendering()
        {
            Assert.IsNotNull(RcsTestConstants.LoadShader(), "RCS thruster shader missing.");
        }

        [Test]
        public void GoldenImage([ValueSource(nameof(StateNames))] string stateName)
        {
            var state = FindState(stateName);
            var baselinePath = RcsRenderHarness.BaselinePath(stateName);

            Material mat = null;
            Texture2D actual = null;
            Texture2D baseline = null;

            try
            {
                mat = RcsRenderHarness.BuildTestMaterial(state.Floats, state.Vectors);
                Assert.IsNotNull(mat, "Could not build test material - is the shader missing?");
                actual = RcsRenderHarness.Render(mat);

                // ---- layer 1: semantics, independent of any baseline ----
                var luminance = RcsRenderHarness.MeanLuminance(actual);
                if (state.ExpectDark)
                {
                    if (luminance > DarkLuminanceMax)
                    {
                        DumpActual(actual, stateName);
                        Assert.Fail(
                            $"[{stateName}] expected no thruster to fire from this camera, but mean " +
                            $"luminance was {luminance:F4} (> {DarkLuminanceMax}). This usually means a " +
                            "flipped sign in the allocation, or that acceleration is no longer being " +
                            $"differentiated from velocity. Actual dumped to {RcsRenderHarness.FailureDir}.");
                    }
                }
                else if (luminance < LitLuminanceMin)
                {
                    DumpActual(actual, stateName);
                    Assert.Fail(
                        $"[{stateName}] expected thrusters to fire, but mean luminance was only " +
                        $"{luminance:F4} (< {LitLuminanceMin}). Actual dumped to {RcsRenderHarness.FailureDir}.");
                }

                // ---- capture path ----
                if (CaptureMode)
                {
                    RcsRenderHarness.WritePng(actual, baselinePath);
                    Debug.Log($"[RCS golden] captured baseline: {baselinePath}");
                    Assert.Pass($"Captured baseline for '{stateName}' (semantics checked).");
                }

                // ---- layer 2: pixel diff ----
                baseline = RcsRenderHarness.LoadPng(baselinePath);
                if (baseline == null)
                {
                    Assert.Fail(
                        $"No baseline for '{stateName}' at {baselinePath}. " +
                        "Run: Tools > Exegesis > Debug > Capture RCS Golden Baselines (on the CURRENT shader), " +
                        "eyeball the PNGs, then commit them.");
                }

                var diff = RcsRenderHarness.Compare(actual, baseline, ChannelTolerance);

                if (!diff.DimensionsMatch)
                {
                    DumpActual(actual, stateName);
                    Assert.Fail($"[{stateName}] render dimensions differ from baseline.");
                }

                if (diff.DiffFraction > MaxDiffFraction)
                {
                    DumpActual(actual, stateName);
                    Assert.Fail(
                        $"[{stateName}] {diff.DiffPixels}/{diff.TotalPixels} pixels differ " +
                        $"({diff.DiffFraction:P2} > {MaxDiffFraction:P2}), max channel delta {diff.MaxChannelDelta}. " +
                        $"Actual dumped to {RcsRenderHarness.FailureDir}. If this change is intentional, " +
                        "re-capture baselines and say why in the commit.");
                }
            }
            finally
            {
                if (actual != null) Object.DestroyImmediate(actual);
                if (mat != null) Object.DestroyImmediate(mat);
                if (baseline != null) Object.DestroyImmediate(baseline);
            }
        }

        private static void DumpActual(Texture2D actual, string stateName)
        {
            try
            {
                var path = Path.Combine(RcsRenderHarness.FailureDir, stateName + "_actual.png");
                RcsRenderHarness.WritePng(actual, path);
                Debug.Log($"[RCS golden] wrote failing render to {path}");
            }
            catch { /* best effort */ }
        }

        private static string[] StateNames()
        {
            var names = new string[RcsGoldenStates.All.Length];
            for (int i = 0; i < names.Length; i++) names[i] = RcsGoldenStates.All[i].Name;
            return names;
        }

        private static RcsGoldenStates.State FindState(string name)
        {
            foreach (var s in RcsGoldenStates.All)
                if (s.Name == name) return s;
            throw new System.ArgumentException($"Unknown golden state '{name}'.");
        }
    }
}
