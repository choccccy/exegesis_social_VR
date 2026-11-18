using System.Linq;
using static Exegesis.Fx.Cond;

namespace Exegesis.Fx
{
    /// <summary>Face, ears, tail, tools and the panel tool: the layers that react to the wearer.</summary>
    public static partial class CommonLayers
    {
        /// <summary>
        /// The eight touch contacts, in the order the layers check them. The arm and leg
        /// contacts are named for the hand and thigh.
        /// </summary>
        private static readonly string[] TouchParams =
        {
            "head_touch", "chest_touch", "abdomen_touch", "hips_touch",
            "left_hand_touch", "right_hand_touch", "left_thigh_touch", "right_thigh_touch",
        };

        /// <summary>
        /// Face-tracked eyelids. The blink state's time follows the tracked eyelid, so it is a
        /// pose lookup rather than an animation; "slutty eyes" does the same for squint.
        /// </summary>
        /// <param name="blinkState">State name: ncho's is "[ncho]_blink", obi-me's "blink".</param>
        public static LayerSpec Blink(string blinkState, string blinkClip)
        {
            const string sly = "[ncho]_slutty_eyes";
            return new LayerSpec("blink")
                .State(blinkState, blinkClip, motionTime: "FT/v2/EyeLid")
                .State("empty", Clips.Empty)
                .State(sly, Clips.Ncho(sly), motionTime: "FT/v2/EyeSquint")
                .Go(blinkState, sly, 0f, Gt("FT/v2/EyeLid", 0.5f), Lt("FT/v2/EyeLid", 0.9f), Gt("FT/v2/EyeSquint", 0.3f))
                .Go("empty", blinkState, 0.25f).AfterExitTime(0.75f)
                .Go(sly, blinkState, 0f, Lt("FT/v2/EyeSquint", 0.3f))
                // Lid below 0.5 AND above 0.9 can never be true, so this transition never fires.
                // Kept because the port must not change anything; worth a look on its own.
                .Go(sly, blinkState, 0f, Lt("FT/v2/EyeLid", 0.5f), Gt("FT/v2/EyeLid", 0.9f)).AfterExitTime(0f)
                .Default("empty");
        }

        /// <summary>
        /// The screwdriver holster. `screwdriver_holster` is a contact receiver, true while the
        /// wearer's own right hand is at the holster. Point (right-hand gesture 3) at the holster
        /// to draw the screwdriver; slap the hand back on the holster to put it away.
        ///
        /// Each direction is ARMED by the hand leaving the holster. Without that, the contact
        /// that drew the screwdriver was still true when it finished drawing, so it went straight
        /// back unless the hand moved away within 1.5 s, and pointing at the holster looped
        /// draw / return / draw. So:
        ///   - drawn: the hand is still at the holster. Leaving it arms the return.
        ///   - held: touching the holster now returns it.
        ///   - returned: the hand is still at the holster. Leaving it arms the next draw.
        /// </summary>
        public static LayerSpec ToolHolstering()
        {
            const string grab = "grab_screwdriver", ungrab = "grab_screwdriver -1";
            const string drawn = "screwdriver_grabbed", held = "screwdriver_held", returned = "screwdriver_returned";
            return new LayerSpec("tool_holstering")
                .State("empty", Clips.Empty)
                .State(grab, Clips.Ncho("grab_screwdriver"))
                .State(ungrab, Clips.Ncho("grab_screwdriver"), speed: -1f)
                .State(drawn, Clips.Ncho("screwdriver_grabbed"))
                .State(held, Clips.Ncho("screwdriver_grabbed"))
                .State(returned, Clips.Empty)
                .Go("empty", grab, 0.25f, IntEq("GestureRight", 3), If("screwdriver_holster"))
                .Go(grab, drawn, 0f).AfterExitTime(9f)
                .Go(ungrab, returned, 0f).AfterExitTime(6f)
                .Go(drawn, held, 0f, IfNot("screwdriver_holster"))
                .Go(held, ungrab, 0f, If("screwdriver_holster"))
                .Go(returned, "empty", 0f, IfNot("screwdriver_holster"))
                .Default("empty");
        }

        /// <summary>Blushes while `blushie` is on or any touch contact is touched.</summary>
        public static LayerSpec Blushie()
        {
            var spec = new LayerSpec("blushie")
                .State("BlushieOff", Clips.Ncho("[ncho]_blushie_off"))
                .State("BlushieOn", Clips.Ncho("[ncho]_blushie_on"));

            foreach (var p in new[] { "blushie" }.Concat(TouchParams))
                spec.Go("BlushieOff", "BlushieOn", 0.25f, If(p));

            return spec
                .Go("BlushieOn", "BlushieOff", 0.25f,
                    new[] { "blushie" }.Concat(TouchParams).Select(IfNot).ToArray())
                .Default("BlushieOff");
        }

        /// <summary>
        /// The eyes: `eyes_state` picks open (1) or closed (2), 0 leaves them alone; talking
        /// drives the voice pose by volume, and a head touch closes them.
        /// </summary>
        public static LayerSpec Eyes() =>
            new LayerSpec("eyes")
                .State("eyes_open", Clips.Ncho("eyes_open"))
                .State("eyes_closed", Clips.Ncho("eyes_closed"))
                .State("voice", Clips.Ncho("voice"), motionTime: "Voice")
                .State("empty", Clips.Empty)
                .Go("eyes_open", "eyes_closed", 0.1f, IntEq("eyes_state", 2))
                .Go("eyes_open", "voice", 0f, Gt("Voice", 0f))
                .Go("eyes_open", "empty", 0.1f, IntEq("eyes_state", 0))
                .Go("eyes_closed", "eyes_open", 0.1f, IntEq("eyes_state", 1))
                .Go("eyes_closed", "empty", 0.1f, IntEq("eyes_state", 0), IfNot("head_touch"))
                .Go("voice", "eyes_closed", 0.1f, IntEq("eyes_state", 2))
                .Go("voice", "empty", 0f, Lt("Voice", 0.01f))
                .Go("voice", "eyes_closed", 0.1f, If("head_touch"), IntNe("eyes_state", 1))
                .Go("empty", "eyes_open", 0.1f, IntEq("eyes_state", 1))
                .Go("empty", "eyes_closed", 0.1f, IntEq("eyes_state", 2))
                .Go("empty", "voice", 0f, Gt("Voice", 0f))
                .Go("empty", "eyes_closed", 0.1f, If("head_touch"))
                .Default("empty");

        /// <summary>Ears go down for a head touch or closed eyes.</summary>
        public static LayerSpec Ears() =>
            new LayerSpec("ears")
                .State("ears_down", Clips.Ncho("ears_down"))
                .State("ears_neutral", Clips.Ncho("ears_neutral"))
                .Go("ears_down", "ears_neutral", 0.25f, IfNot("head_touch"), IntNe("eyes_state", 2))
                .Go("ears_neutral", "ears_down", 0.25f, If("head_touch"))
                .Go("ears_neutral", "ears_down", 0.25f, IntEq("eyes_state", 2))
                .Default("ears_neutral");

        /// <summary>
        /// `tail_state` 0 is neutral, 1 between the legs, 2 in hand. In neutral, any touch wags
        /// it while `tail_wagging` is on.
        /// </summary>
        public static LayerSpec TailState()
        {
            const string wag = "[Choccy] WickerLRWag [60BPM]";
            var spec = new LayerSpec("tail_state")
                .State(wag, Clips.Generic(wag), speed: 3f)
                .State("tail_neutral", Clips.Ncho("tail_neutral"))
                .State("tail_between_legs", Clips.Ncho("tail_between_legs"))
                .State("tail_in_hand", Clips.Ncho("tail_in_hand"))
                .Go(wag, "tail_neutral", 0.25f, TouchParams.Select(IfNot).ToArray())
                .Go(wag, "tail_neutral", 0.25f, IfNot("tail_wagging"))
                .Go(wag, "tail_neutral", 0.25f, IntNe("tail_state", 0));

            foreach (var touch in TouchParams)
                spec.Go("tail_neutral", wag, 0.25f, If(touch), If("tail_wagging"), IntEq("tail_state", 0));

            return spec
                .Go("tail_neutral", "tail_between_legs", 0.25f, IntEq("tail_state", 1))
                .Go("tail_neutral", "tail_in_hand", 0.25f, IntEq("tail_state", 2))
                .Go("tail_between_legs", "tail_neutral", 0.25f, IntNe("tail_state", 1))
                .Go("tail_in_hand", "tail_neutral", 0.25f, IntNe("tail_state", 2))
                .Default("tail_neutral");
        }

        /// <summary>
        /// The panel tool: while a region's `*_panels_tool` bool is on, flip that region's
        /// panel - a one-shot state drives the panel bool to the opposite value, waits, and
        /// exits back to idle.
        ///
        /// State and transition orders are listed out rather than generated because the
        /// hand-built layer had no consistent order, and the port must match it.
        /// </summary>
        public static LayerSpec PanelToolControl()
        {
            // (panel, true = drive it on) in state order.
            var states = new[]
            {
                ("groin", false), ("groin", true), ("abdomen", true), ("abdomen", false),
                ("left_thigh", false), ("left_thigh", true), ("chest", false), ("chest", true),
                ("face", true), ("face", false), ("right_thigh", false), ("right_thigh", true),
            };
            // The idle state's transitions, in evaluation order.
            var order = new[]
            {
                ("groin", false), ("groin", true), ("abdomen", true), ("abdomen", false),
                ("chest", false), ("face", true), ("face", false), ("chest", true),
                ("left_thigh", true), ("left_thigh", false), ("right_thigh", true), ("right_thigh", false),
            };

            string Name((string Panel, bool On) s) => $"{s.Panel}_panels_{(s.On ? "on" : "off")}";

            var spec = new LayerSpec("panel_tool_control").State("empty", Clips.Empty, speed: 10f);
            foreach (var s in states)
                spec.State(Name(s), Clips.Empty).Drives(false, Drive.Set($"{s.Item1}_panels", s.Item2));

            // Turning a panel on needs it off now, and vice versa.
            foreach (var s in order)
                spec.Go("empty", Name(s), 0f,
                        s.Item2 ? IfNot($"{s.Item1}_panels") : If($"{s.Item1}_panels"),
                        If($"{s.Item1}_panels_tool"));

            foreach (var s in states)
                spec.Exit(Name(s), 0f).AfterExitTime(3f);

            return spec.Default("empty");
        }
    }
}
