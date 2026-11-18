using System.Collections.Generic;
using static Exegesis.Fx.Cond;
using static Exegesis.Fx.Shapes;

namespace Exegesis.Fx
{
    /// <summary>
    /// The layers more than one avatar has. lemaitre_fx and obi-me_fx began as copies of
    /// ncho_fx, so most layers are shared; where an avatar differs, the difference is a
    /// parameter here and the avatar's own file passes it.
    ///
    /// Every method returns a fresh LayerSpec, so an avatar can't mutate another's layers.
    /// </summary>
    public static class CommonLayers
    {
        private const float Fade = 0.25f;

        // ------------------------------------------------------------------ baselines

        /// <summary>Layer 0: empty, weight 0, as it has always been.</summary>
        public static LayerSpec Base() => new LayerSpec("base").WithWeight(0f);

        public static LayerSpec GlyphsNeutral() =>
            Neutral("glyphs_neutral", "[ncho]_glyphs_neutral", Clips.Ncho("[ncho]_glyphs_neutral"));

        /// <summary>Vent glow follows `heat`: the clip is a lookup table indexed by it.</summary>
        public static LayerSpec VentGlow(string clip) =>
            Neutral("vent_glow", "vent_glow", clip, mirror: true, motionTime: "heat");

        public static LayerSpec EyesNeutral(string clip) => Neutral("eyes_neutral", "eyes_neutral", clip);

        /// <summary>The water-level gauge, indexed by tracker battery.</summary>
        public static LayerSpec WaterLevel() =>
            Neutral("water_level", "eyes_battery", Clips.Ncho("water_level"), motionTime: "averageTrackerBattery");

        public static LayerSpec PanelsNeutral(string clip) => Neutral("panels_neutral", "[panels]_neutral", clip);

        /// <summary>
        /// Hides every Props dissolve tile. Accessory layers above it reveal single tiles; a
        /// slot in idle writes nothing and falls through to this. See docs/accessories.md.
        /// </summary>
        public static LayerSpec PropsNeutral() =>
            Neutral("props_neutral", "[props]_neutral", Clips.Ncho("[props]_neutral"));

        public static LayerSpec TouchNeutral() => Neutral("touch_neutral", "touch_neutral", Clips.Hud("touch_neutral"));

        // ------------------------------------------------------------------ eye overlays

        public static LayerSpec OverlayOpen() =>
            Toggle("overlay_open", "isOverlayOpen", Fade,
                   whenTrue: S("eyes_overlay", Clips.Ncho("eyes_overlay")),
                   whenFalse: S("empty", Clips.Empty),
                   trueFirst: true, startTrue: false);

        public static LayerSpec BattIndicator() =>
            Toggle("batt_indicator", "batt_indicator", Fade,
                   whenTrue: S("eyes_battery", Clips.Ncho("eyes_battery"), motionTime: "averageTrackerBattery"),
                   whenFalse: S("empty", Clips.Empty),
                   trueFirst: true, startTrue: false);

        // ------------------------------------------------------------------ panels

        /// <summary>
        /// A removable panel: the bool is true while the panel is ON, so the "true" state plays
        /// nothing and the "false" state plays the removal clip.
        /// </summary>
        /// <param name="startOff">The layer's default state is the removed one.</param>
        public static LayerSpec PanelOff(string layer, string param, string state, string clip,
                                         bool startOff = false) =>
            Toggle(layer, param, Fade,
                   whenTrue: S("empty", Clips.Empty),
                   whenFalse: S(state, clip),
                   trueFirst: true, startTrue: !startOff);

        public static LayerSpec FaceOff() =>
            PanelOff("face_off", "face_panels", "[panels]_face_off", Clips.Ncho("[panels]_face_off"));

        public static LayerSpec ChestOff() =>
            PanelOff("chest_off", "chest_panels", "[panels]_chest_off", Clips.Ncho("[panels]_chest_off"));

        /// <summary>The state is named torso; the clip and parameter say abdomen. Same thing.</summary>
        public static LayerSpec AbdomenOff() =>
            PanelOff("abdomen_off", "abdomen_panels", "[panels]_torso_off", Clips.Ncho("[panels]_abdomen_off"));

        public static LayerSpec GroinOff() =>
            PanelOff("groin_off", "groin_panels", "[panels]_groin_off", Clips.Ncho("[panels]_groin_off"));

        public static LayerSpec LeftArmOff() =>
            PanelOff("left_arm_off", "left_arm_panels", "[panels]_left_arm_off",
                     Clips.Ncho("[panels]_left_arm_off"), startOff: true);

        public static LayerSpec RightArmOff() =>
            PanelOff("right_arm_off", "right_arm_panels", "[panels]_right_arm_off",
                     Clips.Ncho("[panels]_right_arm_off"));

        public static LayerSpec LeftThighOff() =>
            PanelOff("left_thigh_off", "left_thigh_panels", "[panels]_left_thigh_off",
                     Clips.Ncho("[panels]_left_thigh_off"));

        public static LayerSpec RightThighOff() =>
            PanelOff("right_thigh_off", "right_thigh_panels", "[panels]_right_thigh_off",
                     Clips.Ncho("[panels]_right_thigh_off"));

        public static LayerSpec Pouches() =>
            PanelOff("pouches", "pouches", "[panels]_pouches_off", Clips.Ncho("[panels]_pouches_off"));

        // ------------------------------------------------------------------ props

        public static LayerSpec HardCaseMounts() =>
            Toggle("hard-case_mounts", "hard-case_mounts", Fade,
                   whenTrue: S("[props]_hard-case_mounts_on", Clips.Ncho("[props]_hard-case_mounts_on")),
                   whenFalse: S("empty", Clips.Empty),
                   trueFirst: true, startTrue: true);

        /// <summary>The arm hard-cases hang off the mounts, so they need both bools.</summary>
        public static LayerSpec ArmHardCases() =>
            new LayerSpec("arm_hard-cases")
                .State("[props]_arm_hard-cases_on", Clips.Ncho("[props]_arm_hard-cases_on"))
                .State("empty", Clips.Empty)
                .Go("[props]_arm_hard-cases_on", "empty", Fade, IfNot("hard-case_mounts"))
                .Go("[props]_arm_hard-cases_on", "empty", Fade, IfNot("arm_hard-cases"))
                .Go("empty", "[props]_arm_hard-cases_on", Fade, If("arm_hard-cases"), If("hard-case_mounts"))
                .Default("empty");

        /// <summary>The wings, stowed or deployed. Answers to wings_deployed only - never `rcs`.</summary>
        public static LayerSpec WingDeploy() =>
            new LayerSpec("wing_deploy")
                .State("empty", Clips.Empty)
                .State("[props]_wings_deployed", Clips.Ncho("[props]_wings_deployed"))
                .Go("empty", "[props]_wings_deployed", 0.5f, If("wings_deployed"))
                .Go("[props]_wings_deployed", "empty", 0.5f, IfNot("wings_deployed"))
                .Default("empty");

        /// <summary>
        /// The wings with contact sensors: touching the lower sensor pushes them up out of the
        /// way, and they settle back when it clears. Answers to wings_deployed, never `rcs` -
        /// rcs is 1 on every load, which once had the wings out with their plumes off.
        /// </summary>
        public static LayerSpec WingDeployWithSensors()
        {
            const string down = "wings_down", deployed = "[props]_wings_deployed", up = "[props]_wings_up";
            return new LayerSpec("wing_deploy")
                .State(down, Clips.Empty)
                .State(deployed, Clips.Ncho("[props]_wings_deployed"))
                .State(up, Clips.Ncho("[props]_wings_up"))
                .Go(down, deployed, 0.5f, If("wings_deployed"), IfNot("wing_sensor_lower"), IfNot("wing_sensor_upper"))
                .Go(down, up, 0.5f, If("wing_sensor_lower"), IfNot("wing_sensor_upper"))
                .Go(deployed, down, 0.5f, IfNot("wings_deployed"))
                .Go(deployed, up, 0.5f, If("wing_sensor_lower"), IfNot("wing_sensor_upper"))
                .Go(deployed, down, 0.5f, If("wing_sensor_upper"))
                .Go(up, deployed, 0.5f, If("wings_deployed"), IfNot("wing_sensor_lower"), IfNot("wing_sensor_upper"))
                .Go(up, down, 0.5f, IfNot("wing_sensor_lower"))
                .Default(down);
        }

        // ------------------------------------------------------------------ shader / world

        public static LayerSpec VertexRounding() =>
            Toggle("vertex_rounding", "vertex_rounding", Fade,
                   whenTrue: S("vertex_rounding_on", Clips.Ncho("vertex_rounding_on")),
                   whenFalse: S("vertex_rounding_off", Clips.Ncho("vertex_rounding_off")),
                   trueFirst: true, startTrue: true);

        public static LayerSpec Audiolink() =>
            Toggle("audiolink", "audiolink", 0f,
                   whenTrue: S("[ncho]_audiolink_on", Clips.Ncho("[ncho]_audiolink_on")),
                   whenFalse: S("[ncho]_audiolink_off", Clips.Ncho("[ncho]_audiolink_off")),
                   trueFirst: true, startTrue: true);

        public static LayerSpec FloorCollider() =>
            Toggle("floor_collider", "floor", 0f,
                   whenTrue: S("[Choccy] FloorColliderOn", Clips.Generic("[Choccy] FloorColliderOn")),
                   whenFalse: S("[Choccy] FloorColliderOff", Clips.Generic("[Choccy] FloorColliderOff")),
                   trueFirst: false, startTrue: true);

        /// <summary>The HUD is only ever drawn for the wearer.</summary>
        public static LayerSpec Hud() =>
            new LayerSpec("HUD")
                .State("HUD_off", Clips.Hud("HUD_off"))
                .State("HUD_on", Clips.Hud("HUD_on"))
                .Go("HUD_off", "HUD_on", 0f, If("IsLocal"), If("hud"))
                .Go("HUD_on", "HUD_off", 0f, IfNot("IsLocal"))
                .Go("HUD_on", "HUD_off", 0f, IfNot("hud"))
                .Default("HUD_off");

        /// <summary>The transponder only shows to friends.</summary>
        public static LayerSpec Transponder() =>
            new LayerSpec("transponder")
                .State("transponder_off", Clips.Ncho("transponder_off"))
                .State("transponder_on", Clips.Ncho("transponder_on"))
                .Go("transponder_off", "transponder_on", 0f, If("transponder"), If("IsOnFriendsList"))
                .Go("transponder_on", "transponder_off", 0f, IfNot("transponder"))
                .Default("transponder_off");

        /// <param name="speed">lemaitre's plays at 100; the others at 1.</param>
        public static LayerSpec Eyeshadow(float speed = 1f) =>
            Toggle("eyeshadow", "eyeshadow", 0f,
                   whenTrue: S("[ncho]_eyeshadow_on", Clips.Ncho("[ncho]_eyeshadow_on"), speed),
                   whenFalse: S("[ncho]_eyeshadow_off", Clips.Ncho("[ncho]_eyeshadow_off"), speed),
                   trueFirst: false, startTrue: false);

        // ------------------------------------------------------------------ touch

        /// <summary>
        /// The eight touch highlights on the HUD body diagram, in controller order. Each lights
        /// its region while the matching contact is touched. Layer and state share a name; the
        /// arm and leg contacts are named for the hand and thigh.
        /// </summary>
        public static IEnumerable<LayerSpec> Touches()
        {
            yield return Touch("head_touch", "head_touch");
            yield return Touch("chest_touch", "chest_touch", trueFirst: true);
            yield return Touch("abdomen_touch", "abdomen_touch");
            yield return Touch("hips_touch", "hips_touch");
            yield return Touch("left_arm_touch", "left_hand_touch");
            yield return Touch("right_arm_touch", "right_hand_touch");
            yield return Touch("left_leg_touch", "left_thigh_touch");
            yield return Touch("right_leg_touch", "right_thigh_touch");
        }

        private static LayerSpec Touch(string layer, string param, bool trueFirst = false) =>
            Toggle(layer, param, 0f,
                   whenTrue: S(layer, Clips.Hud(layer)),
                   whenFalse: S("empty", Clips.Empty),
                   trueFirst: trueFirst, startTrue: false, intoFalseNotFixed: true);
    }
}
