using System.Collections.Generic;
using static Exegesis.Fx.ParamSpec;

namespace Exegesis.Fx
{
    /// <summary>
    /// The parameters every avatar declares, in blocks, so each avatar's definition composes
    /// its list from these plus its own extras. The slot and RCS tools declare theirs
    /// separately (NchoSlotSetup, RcsAnimatorSetup); they are not repeated here.
    /// </summary>
    public static class CommonParameters
    {
        /// <summary>
        /// Parameters removed on purpose. The builder normally refuses to build a controller
        /// that holds a parameter nobody declares, because building would delete it; these it
        /// is allowed to delete. Removing a parameter is therefore a change made in code and
        /// reviewed like one, not a side effect.
        ///
        /// The four bools the accessory slots (back_slot / thigh_slot) replaced. Removed in
        /// November 2026, once nothing referenced them: no layer, expression parameter, menu,
        /// contact or VRCFury component. SlotParameterTests keeps them gone.
        /// </summary>
        public static readonly string[] Retired =
        {
            "thruster_backpack", "arm_backpack", "thigh_hard-cases", "thigh_thrusters",
        };

        /// <summary>
        /// VRChat's built-in parameters plus the OSC ones these avatars read (overlay, keyboard,
        /// wrist, battery). Declared so layers can reference them; VRChat and the OSC apps
        /// write them.
        /// </summary>
        /// <param name="gestureWeights">GestureLeftWeight / GestureRightWeight (obi-me's manipulators).</param>
        public static IEnumerable<ParamSpec> BuiltIns(bool gestureWeights = false)
        {
            yield return Bool("IsLocal");
            yield return Float("Voice");
            yield return Int("GestureLeft");
            yield return Int("GestureRight");
            if (gestureWeights)
            {
                yield return Float("GestureLeftWeight");
                yield return Float("GestureRightWeight");
            }
            yield return Float("AngularY");
            yield return Float("VelocityX");
            yield return Float("VelocityY");
            yield return Float("VelocityZ");
            yield return Float("VelocityMagnitude");
            yield return Float("Upright");
            yield return Bool("Grounded");
            yield return Bool("AFK");
            yield return Bool("MuteSelf");
            yield return Bool("IsOnFriendsList");
            yield return Bool("isOverlayOpen");
            yield return Bool("isKeyboardOpen");
            yield return Bool("isWristVisible");
            yield return Float("averageControllerBattery", 1f);
            yield return Float("averageTrackerBattery");
        }

        /// <summary>Face tracking (VRCFT v2). The lid defaults open.</summary>
        public static IEnumerable<ParamSpec> FaceTracking()
        {
            yield return Float("FT/v2/EyeLid", 1f);
            yield return Float("FT/v2/EyeSquint");
        }

        /// <summary>The avatar's own state: touch contacts, heat, panels, toggles, accessories.</summary>
        public static IEnumerable<ParamSpec> Body()
        {
            yield return Bool("batt_indicator");

            // Contact receivers.
            yield return Bool("head_touch");
            yield return Bool("chest_touch");
            yield return Bool("abdomen_touch");
            yield return Bool("hips_touch");
            yield return Bool("left_hand_touch");
            yield return Bool("right_hand_touch");
            yield return Bool("left_thigh_touch");
            yield return Bool("right_thigh_touch");

            yield return Float("evil_heat");
            yield return Int("eyes_state");
            yield return Bool("blushie");
            yield return Float("heat");
            yield return Float("heat_integral");
            yield return Bool("vertex_rounding");
            yield return Bool("floor", true);

            // Panels: true while the panel is ON.
            yield return Bool("left_arm_panels");
            yield return Bool("right_arm_panels");
            yield return Bool("left_thigh_panels", true);
            yield return Bool("right_thigh_panels");
            yield return Bool("chest_panels", true);
            yield return Bool("face_panels", true);
            yield return Bool("abdomen_panels", true);
            yield return Bool("groin_panels", true);
            yield return Bool("pouches", true);

            // The panel tool, one per region.
            yield return Bool("face_panels_tool");
            yield return Bool("chest_panels_tool");
            yield return Bool("abdomen_panels_tool");
            yield return Bool("groin_panels_tool");
            yield return Bool("left_thigh_panels_tool");
            yield return Bool("right_thigh_panels_tool");

            yield return Bool("audiolink", true);
            yield return Bool("hud", true);
            yield return Bool("transponder");
            yield return Bool("tail_wagging", true);
            yield return Bool("screwdriver_holster");
            yield return Int("tail_state");
            yield return Bool("eyeshadow");
            yield return Float("ab_wire_Stretch");
            yield return Bool("hard-case_mounts", true);
            yield return Bool("arm_hard-cases");
            yield return Bool("wings_deployed");
            // thruster_backpack, arm_backpack, thigh_hard-cases and thigh_thrusters used to be
            // declared here. See Retired.
        }
    }
}
