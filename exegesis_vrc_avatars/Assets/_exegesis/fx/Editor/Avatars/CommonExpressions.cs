using System.Collections.Generic;
using static Exegesis.Fx.ExpressionParam;

namespace Exegesis.Fx
{
    /// <summary>Menu icons, by file name in Assets/_exegesis/icons.</summary>
    public static class Icons
    {
        public static string Get(string name) => $"Assets/_exegesis/icons/{name}.png";

        public static readonly string Equipment = Get("icons8-wrench-64");
        public static readonly string Panels = Get("glyph");
        public static readonly string Config = Get("icons8-gear-96");
        public static readonly string Expression = Get("icons8-tongue-out-100");
    }

    /// <summary>
    /// Expression parameters and menus more than one avatar uses. The menus here are single
    /// assets shared by several avatars' menu trees; ExpressionsBuilder refuses to build if two
    /// avatars describe a shared menu differently.
    /// </summary>
    public static class CommonExpressions
    {
        private const string NchoAnim = "Assets/_exegesis/ncho/ncho_anim";

        /// <summary>
        /// The parameters asset every shared menu points its inspector at. Inspector-only:
        /// VRChat reads the descriptor's parameters, not this.
        /// </summary>
        public const string NchoParams = NchoAnim + "/ncho_params.asset";

        /// <summary>
        /// The expression parameters every avatar declares, in order. The defaults here are the
        /// ones VRChat applies, and a few differ from the animator's: right_arm_panels and
        /// thigh_slot, for two.
        /// </summary>
        public static IEnumerable<ExpressionParam> Parameters()
        {
            // OSC (overlay, keyboard, wrist, battery) and face tracking.
            yield return Bool("isOverlayOpen");
            yield return Bool("isKeyboardOpen");
            yield return Bool("isWristVisible");
            yield return Float("averageControllerBattery", 1f);
            yield return Float("averageTrackerBattery");
            yield return Float("FT/v2/EyeLid", 1f);
            yield return Float("FT/v2/EyeSquint");
            yield return Int("eyes_state");

            // Contacts: local only, the effects they drive are what sync.
            yield return Bool("head_touch", synced: false);
            yield return Bool("chest_touch", synced: false);
            yield return Bool("abdomen_touch", synced: false);
            yield return Bool("hips_touch", synced: false);
            yield return Bool("left_hand_touch", synced: false);
            yield return Bool("right_hand_touch", synced: false);
            yield return Bool("left_thigh_touch", synced: false);
            yield return Bool("right_thigh_touch", synced: false);
            yield return Float("evil_heat", synced: false);

            yield return Float("heat", saved: true);
            yield return Float("heat_integral");
            yield return Bool("vertex_rounding", true, saved: true);
            yield return Bool("tail_wagging", true);
            yield return Bool("floor", true);

            yield return Bool("face_panels", true, saved: true);
            yield return Bool("chest_panels", true, saved: true);
            yield return Bool("abdomen_panels", true, saved: true);
            yield return Bool("groin_panels", true);
            yield return Bool("left_arm_panels", saved: true);
            yield return Bool("right_arm_panels", true, saved: true);
            yield return Bool("left_thigh_panels", true, saved: true);
            yield return Bool("right_thigh_panels", true, saved: true);
            yield return Bool("pouches", true, saved: true);

            yield return Bool("blushie");
            yield return Bool("audiolink", true);
            yield return Bool("hud", true, saved: true);
            yield return Bool("transponder");
            yield return Int("tail_state");
            yield return Bool("eyeshadow", saved: true);
            yield return Float("ab_wire_Stretch");
            yield return Bool("hard-case_mounts", true, saved: true);
            yield return Bool("arm_hard-cases", saved: true);
            yield return Bool("wings_deployed", saved: true);

            // The accessory slots. loadout is a one-shot preset trigger: local, never saved.
            yield return Int("back_slot", 1, saved: true);
            yield return Int("thigh_slot", 2, saved: true);
            yield return Int("loadout", synced: false);

            yield return Bool("rcs", true);
        }

        /// <summary>Config: render and world toggles. Shared by all three avatars.</summary>
        public static MenuSpec Config() =>
            new MenuSpec($"{NchoAnim}/ncho_config_menu.asset", NchoParams)
                .Toggle("AudioLink", "audiolink", icon: Icons.Get("icons8-musical-note-96"))
                .Toggle("Vertex Rounding", "vertex_rounding", icon: Icons.Get("Playstation_logo"),
                        subParameters: "vertex_rounding")
                .Toggle("Floor", "floor", icon: Icons.Get("icons8-floor-96"))
                .Toggle("Prox Wagging", "tail_wagging", icon: Icons.Get("noun-fox-tail-wag"))
                .Toggle("Transponder", "transponder", icon: Icons.Get("icons8-walkie-talkie-64"))
                .Toggle("HUD", "hud", icon: Icons.Get("icons8-google-glass-64"))
                // A parameterless toggle and a submenu with nothing behind it: placeholders.
                .Toggle("snub", "")
                .SubMenu("Page 2 (snub)", null, icon: Icons.Get("icons8-circled-2-96"), value: 0f);

        /// <summary>Expression: face and cuddle controls. Shared by all three avatars.</summary>
        public static MenuSpec Expression() =>
            new MenuSpec($"{NchoAnim}/ncho_cuddle_menu.asset", NchoParams)
                // A submenu with nothing behind it and one empty sub-parameter: a placeholder.
                .SubMenu("SPS", null, icon: Icons.Get("broken_img"), subParameters: "")
                .Toggle("Blushie", "blushie")
                .Toggle("Close Eyes", "eyes_state", 2f, Icons.Get("icons8-closed-eye-96"))
                .Toggle("Open Eyes", "eyes_state", 1f, Icons.Get("icons8-eye-96"))
                .Toggle("Eyeshadow", "eyeshadow");

        /// <summary>Panels: ncho's panel set. lemaitre uses it too; obi-me has its own.</summary>
        public static MenuSpec NchoPanels() =>
            new MenuSpec($"{NchoAnim}/ncho_panels_menu.asset", NchoParams)
                .Toggle("Face Panels", "face_panels")
                .Toggle("Left Arm Panels", "left_arm_panels")
                .Toggle("Right Arm Panels", "right_arm_panels")
                .Toggle("Chest Panels", "chest_panels")
                .Toggle("Abdomen Panels", "abdomen_panels")
                .Toggle("Left Thigh Panels", "left_thigh_panels")
                .Toggle("Right Thigh Panels", "right_thigh_panels")
                .Toggle("Groin Panels", "groin_panels");
    }
}
