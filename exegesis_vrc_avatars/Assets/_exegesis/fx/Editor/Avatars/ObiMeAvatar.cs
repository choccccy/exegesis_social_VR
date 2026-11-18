using System.Collections.Generic;
using Exegesis.Shared;
using static Exegesis.Fx.Cond;
using static Exegesis.Fx.CommonLayers;
using static Exegesis.Fx.Shapes;

namespace Exegesis.Fx
{
    /// <summary>
    /// obi-me's FX layers written as code, in controller order. Started as a copy of ncho's.
    /// Differences: its own vent glow, panel clips and panels_neutral; a cage and bells where
    /// ncho has face and right-arm panels; wings without the contact sensors; and the
    /// manipulator / head-cam layers only obi-me has.
    /// </summary>
    public static class ObiMeAvatar
    {
        public static AvatarDefinition Define() => new AvatarDefinition(FxControllers.ObiMe, Layers());

        private static IEnumerable<LayerSpec> Layers()
        {
            yield return Base();
            // blink, tool_holstering: hand-built
            yield return GlyphsNeutral();
            // blushie: hand-built
            yield return VentGlow(Clips.ObiMe("obi-me_heat_glow"));
            // heat system: hand-built
            yield return EyesNeutral(Clips.Ncho("[ncho]_eyes_neutral"));
            // eyes: hand-built
            yield return OverlayOpen();
            // batt_control: hand-built
            yield return BattIndicator();
            yield return WaterLevel();
            // ears, tail_state: hand-built
            yield return PanelsNeutral(Clips.ObiMe("[obi-me]_panels_neutral"));
            yield return PropsNeutral();
            yield return PanelOff("cage_off", "cage", "[obi-me]_cage_off", Clips.ObiMe("[obi-me]_cage_off"));
            yield return PanelOff("chest_off", "chest_panels", "[obi-me]_chest_off", Clips.ObiMe("[obi-me]_chest_off"));
            yield return AbdomenOff();
            yield return PanelOff("groin_off", "groin_panels", "[obi-me]_groin_off", Clips.ObiMe("[obi-me]_groin_off"));
            yield return LeftArmOff();
            yield return PanelOff("bells_off", "bells", "[obi-me]_bells_off", Clips.ObiMe("[obi-me]_bells_off"));
            yield return LeftThighOff();
            yield return RightThighOff();
            yield return Pouches();
            yield return HardCaseMounts();
            yield return ArmHardCases();
            yield return WingDeploy();
            // panel_tool_control: hand-built
            yield return VertexRounding();
            yield return Audiolink();
            yield return FloorCollider();
            yield return Hud();
            yield return Transponder();
            yield return TouchNeutral();
            foreach (var t in Touches()) yield return t;
            yield return Eyeshadow();

            yield return Manipulator("L", "GestureLeft");
            yield return Manipulator("R", "GestureRight");
            yield return Neutral("lock_manipulators_neutral", "[obi-me]_unlock_big_manipulators",
                                 Clips.ObiMe("[obi-me]_unlock_big_manipulators"));
            yield return LockManipulator("L");
            yield return LockManipulator("R");
            yield return LowerHeadCam();
        }

        /// <summary>
        /// The small manipulator closes while that hand makes a fist (gesture 1), following
        /// the trigger's weight.
        /// </summary>
        private static LayerSpec Manipulator(string side, string gesture)
        {
            string closed = $"[obi-me]_manipulator_close_{side}";
            return new LayerSpec($"manipulator_{side}")
                .State(closed, Clips.ObiMe(closed), motionTime: $"{gesture}Weight")
                .State("empty", Clips.Empty)
                .Go(closed, "empty", 0f, IntNe(gesture, 1))
                .Go("empty", closed, 0f, IntEq(gesture, 1))
                .Default("empty");
        }

        /// <summary>Locks one big manipulator in place (unlocked by lock_manipulators_neutral).</summary>
        private static LayerSpec LockManipulator(string side)
        {
            string locked = $"[obi-me]_lock_big_manipulator_{side}";
            return Toggle($"lock_manipulator_{side}", $"lock_manipulator_{side}", 0f,
                          whenTrue: S(locked, Clips.ObiMe(locked)),
                          whenFalse: S("empty", Clips.Empty),
                          trueFirst: false, startTrue: false);
        }

        /// <summary>Moves the wearer's view to the lower body. Local only.</summary>
        private static LayerSpec LowerHeadCam() =>
            new LayerSpec("lower_head_cam")
                .State("[obi-me]_upper_body", Clips.ObiMe("[obi-me]_upper_body"))
                .State("[obi-me]_lower_body", Clips.ObiMe("[obi-me]_lower_body"))
                .Go("[obi-me]_upper_body", "[obi-me]_lower_body", 0f, If("lower_body"), If("IsLocal"))
                .Go("[obi-me]_lower_body", "[obi-me]_upper_body", 0f, IfNot("lower_body"))
                .Default("[obi-me]_upper_body");
    }
}
