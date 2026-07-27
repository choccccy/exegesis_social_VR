using System.IO;
using NUnit.Framework;
using UnityEngine;

namespace Exegesis.HudShader.Tests
{
    /// <summary>
    /// Golden-image regression tests: render each state and compare to a checked-in
    /// baseline PNG. This is the only layer that catches *visual* regressions from
    /// cginc edits that still compile cleanly.
    ///
    /// Baselines are captured deliberately via Tools > Exegesis > Capture HUD Golden
    /// Baselines (so a human eyeballs them before they become the source of truth).
    /// A missing baseline fails the test rather than silently self-healing.
    /// </summary>
    [TestFixture]
    public class HudGoldenImageTests
    {
        // Tolerances tuned to absorb GPU/driver nondeterminism without hiding a real
        // visual change. Adjust with care and document why in the commit message.
        private const int ChannelTolerance = 8;      // per-channel delta (0-255) that counts as "same"
        private const float MaxDiffFraction = 0.005f; // <= 0.5% of pixels may differ

        [Test]
        public void Shader_IsAvailableForRendering()
        {
            Assert.IsNotNull(HudTestConstants.LoadShader(), "HUD shader missing.");
            Assert.IsNotNull(HudTestConstants.LoadMaterial(), "ncho_HUD material missing.");
        }

        [Test]
        public void GoldenImage([ValueSource(nameof(StateNames))] string stateName)
        {
            var state = FindState(stateName);
            var baselinePath = HudRenderHarness.BaselinePath(stateName);

            // Headless capture path: `HUD_CAPTURE_BASELINES=1` makes a test run write
            // baselines instead of comparing. Used to establish/refresh the pin from
            // the CLI (`-runTests`) without relying on a test-only menu item.
            if (System.Environment.GetEnvironmentVariable("HUD_CAPTURE_BASELINES") == "1")
            {
                Material capMat = null;
                Texture2D capTex = null;
                try
                {
                    capMat = HudRenderHarness.BuildTestMaterial(state.Overrides);
                    capTex = HudRenderHarness.Render(capMat, HudRenderHarness.DefaultSize, HudRenderHarness.DefaultSize, state.Background);
                    HudRenderHarness.WritePng(capTex, baselinePath);
                    Debug.Log($"[HUD golden] captured baseline: {baselinePath}");
                }
                finally
                {
                    if (capTex != null) Object.DestroyImmediate(capTex);
                    if (capMat != null) Object.DestroyImmediate(capMat);
                }
                Assert.Pass($"Captured baseline for '{stateName}'.");
            }

            var baseline = HudRenderHarness.LoadPng(baselinePath);
            if (baseline == null)
            {
                Assert.Fail(
                    $"No baseline for '{stateName}' at {baselinePath}. " +
                    "Run: Tools > Exegesis > Capture HUD Golden Baselines (on the CURRENT shader) " +
                    "and eyeball the PNGs before committing them.");
            }

            Material mat = null;
            Texture2D actual = null;
            try
            {
                mat = HudRenderHarness.BuildTestMaterial(state.Overrides);
                Assert.IsNotNull(mat, "Could not build test material.");
                actual = HudRenderHarness.Render(mat, HudRenderHarness.DefaultSize, HudRenderHarness.DefaultSize, state.Background);

                var diff = HudRenderHarness.Compare(actual, baseline, ChannelTolerance);

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
                        $"Actual dumped to {HudRenderHarness.FailureDir}. If this change is intentional, " +
                        "re-capture baselines and note why in the commit.");
                }
            }
            finally
            {
                if (actual != null) Object.DestroyImmediate(actual);
                if (mat != null) Object.DestroyImmediate(mat);
                Object.DestroyImmediate(baseline);
            }
        }

        private static void DumpActual(Texture2D actual, string stateName)
        {
            try
            {
                var path = Path.Combine(HudRenderHarness.FailureDir, stateName + "_actual.png");
                HudRenderHarness.WritePng(actual, path);
                Debug.Log($"[HUD golden] wrote failing render to {path}");
            }
            catch { /* best effort */ }
        }

        private static string[] StateNames()
        {
            var names = new string[HudGoldenStates.All.Length];
            for (int i = 0; i < names.Length; i++) names[i] = HudGoldenStates.All[i].Name;
            return names;
        }

        private static HudGoldenStates.State FindState(string name)
        {
            foreach (var s in HudGoldenStates.All)
                if (s.Name == name) return s;
            throw new System.ArgumentException($"Unknown golden state '{name}'.");
        }
    }
}
