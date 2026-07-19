using System.Collections.Generic;

namespace Exegesis.HudShader.Tests
{
    /// <summary>
    /// The set of material states rendered as golden images. Each exercises a
    /// different slice of the composite path using toggles that actually exist on
    /// the shader. "default_all" (the material's real saved state, time-neutralized)
    /// is the primary pin — it moves if any compositing math changes.
    ///
    /// The tests and the "Capture Baselines" menu item both enumerate this list, so
    /// adding a state in one place covers both.
    /// </summary>
    internal static class HudGoldenStates
    {
        public struct State
        {
            public string Name;
            public Dictionary<string, float> Overrides; // null => just the time-neutralized default
        }

        public static readonly State[] All =
        {
            new State { Name = "default_all", Overrides = null },
            new State
            {
                Name = "statusbars_off",
                Overrides = new Dictionary<string, float> { { "_StatusBarsEnabled", 0f } },
            },
            new State
            {
                Name = "paperdoll_off",
                Overrides = new Dictionary<string, float> { { "_PaperDollEnabled", 0f } },
            },
            new State
            {
                Name = "paperdoll_touch_head_chest",
                Overrides = new Dictionary<string, float>
                {
                    { "_PaperDollEnabled", 1f },
                    { "_PD_HeadTouch", 1f },
                    { "_PD_ChestTouch", 1f },
                },
            },
            new State
            {
                Name = "overlay2_on",
                Overrides = new Dictionary<string, float> { { "_Overlay2Enabled", 1f } },
            },
            new State
            {
                Name = "hud_opacity_half",
                Overrides = new Dictionary<string, float> { { "_HUDOpacity", 0.4f } },
            },
            new State
            {
                Name = "statusbars_full",
                Overrides = new Dictionary<string, float>
                {
                    { "_StatusBarsEnabled", 1f },
                    { "_StatusBar0Fill", 1f },
                    { "_StatusBar1Fill", 1f },
                    { "_StatusBar2Fill", 1f },
                },
            },
        };
    }
}
