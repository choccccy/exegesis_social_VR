using UnityEditor;
using UnityEngine;

namespace Exegesis.HudShader.Tests
{
    /// <summary>
    /// Deliberate baseline capture for the golden-image tests. Renders every state
    /// with the CURRENT shader and writes the PNGs to the Baselines folder. Run this
    /// ONCE against the unmodified shader to establish the regression pin, eyeball
    /// the results, then commit. Re-run only when a visual change is intentional
    /// (and say why in the commit).
    /// </summary>
    internal static class HudGoldenBaselineCapture
    {
        [MenuItem("Tools/Exegesis/Debug/Capture HUD Golden Baselines", false, 121)]
        public static void CaptureAll()
        {
            if (HudTestConstants.LoadMaterial() == null)
            {
                EditorUtility.DisplayDialog("HUD Golden Baselines",
                    "ncho_HUD material not found — cannot capture.", "OK");
                return;
            }

            int count = 0;
            try
            {
                foreach (var state in HudGoldenStates.All)
                {
                    Material mat = null;
                    Texture2D tex = null;
                    try
                    {
                        mat = HudRenderHarness.BuildTestMaterial(state.Overrides);
                        tex = HudRenderHarness.Render(mat, HudRenderHarness.DefaultSize, HudRenderHarness.DefaultSize, state.Background);
                        HudRenderHarness.WritePng(tex, HudRenderHarness.BaselinePath(state.Name));
                        count++;
                    }
                    finally
                    {
                        if (tex != null) Object.DestroyImmediate(tex);
                        if (mat != null) Object.DestroyImmediate(mat);
                    }
                }
            }
            finally
            {
                AssetDatabase.Refresh();
            }

            Debug.Log($"[HUD golden] captured {count} baseline(s) to {HudRenderHarness.BaselineDir}");
            EditorUtility.DisplayDialog("HUD Golden Baselines",
                $"Captured {count} baseline image(s) to:\n{HudRenderHarness.BaselineDir}\n\n" +
                "Eyeball them, then commit. Now run the EditMode tests to confirm green.",
                "OK");
        }
    }
}
