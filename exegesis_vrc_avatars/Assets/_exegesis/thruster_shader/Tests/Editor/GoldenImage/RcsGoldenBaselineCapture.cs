using UnityEditor;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Menu entry point for (re)capturing the RCS golden baselines from the CURRENT
    /// shader. Capture is deliberately a human-triggered act: the baselines become the
    /// source of truth, so someone should look at them before they are committed.
    ///
    /// Headless equivalent: run the suite with HUD_CAPTURE_BASELINES=1 (the run
    /// script's -Capture switch) or RCS_CAPTURE_BASELINES=1 for this suite alone.
    /// </summary>
    internal static class RcsGoldenBaselineCapture
    {
        // Priority leaves a gap above, so Unity draws a separator between the debugging aids
        // and these two - they overwrite the committed source of truth for the tests, which is
        // a different kind of action from poking a probe layer into the animator.
        [MenuItem("Tools/Exegesis/Debug/Capture RCS Golden Baselines", false, 120)]
        private static void Capture()
        {
            int written = 0;

            foreach (var state in RcsGoldenStates.All)
            {
                Material mat = null;
                Texture2D tex = null;
                try
                {
                    mat = RcsRenderHarness.BuildTestMaterial(state.Floats, state.Vectors);
                    if (mat == null)
                    {
                        Debug.LogError("[RCS golden] shader not found; nothing captured.");
                        return;
                    }

                    tex = RcsRenderHarness.Render(mat);
                    RcsRenderHarness.WritePng(tex, RcsRenderHarness.BaselinePath(state.Name));
                    written++;
                }
                finally
                {
                    if (tex != null) Object.DestroyImmediate(tex);
                    if (mat != null) Object.DestroyImmediate(mat);
                }
            }

            AssetDatabase.Refresh();
            Debug.Log($"[RCS golden] captured {written} baseline(s) to {RcsRenderHarness.BaselineDir}. " +
                      "Eyeball them before committing.");
        }
    }
}
