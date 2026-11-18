using static Exegesis.Fx.Cond;

namespace Exegesis.Fx
{
    /// <summary>
    /// How fast each source heats or cools the avatar, per pulse. obi-me runs cooler than ncho.
    /// </summary>
    public sealed class HeatRates
    {
        public float SlowRadiate { get; set; }
        public float FastRadiate { get; set; }
        public float Talking { get; set; }
        public float Evil { get; set; }
        public float Proximity { get; set; }
        public float Internal { get; set; }

        public static HeatRates Ncho => new HeatRates
        {
            SlowRadiate = -0.005f, FastRadiate = -0.01f,
            Talking = 0.01f, Evil = 0.02f, Proximity = 0.03f, Internal = 0.04f,
        };
    }

    /// <summary>
    /// The heat system: a `heat` float from 0 to 1 that touch, talking and `evil_heat` push up
    /// and radiation pulls back down. vent_glow reads it directly; heat_integral quantises it
    /// into three steps for anything that wants a coarse level.
    ///
    /// Every add / radiate layer has the same shape: an empty idle state that, when its
    /// conditions hold, enters a pulse state whose driver changes `heat` once, then returns
    /// after an exit time of 0.1. The rate of change is therefore the drive value times the
    /// pulse frequency, and the drive values per avatar are in HeatRates.
    ///
    /// The drivers are local-only: the wearer computes heat and the parameter syncs.
    /// </summary>
    public static partial class CommonLayers
    {
        private const float PulseExitTime = 0.1f;

        /// <summary>
        /// Cools by `slow` below 0.85 and by `fast` above it.
        /// The 0.8499999 against 0.85 is what the hand-built layer had; it is kept rather than
        /// tidied because a port must not change anything.
        /// </summary>
        public static LayerSpec HeatRadiation(HeatRates rates) =>
            new LayerSpec("heat_radiation")
                .State("empty", Clips.Empty)
                .State("slow_radiate", Clips.Empty).Drives(true, Drive.Add("heat", rates.SlowRadiate))
                .State("fast_radiate", Clips.Empty).Drives(true, Drive.Add("heat", rates.FastRadiate))
                .Go("empty", "slow_radiate", 0f, Gt("heat", 0f), Lt("heat", 0.85f)).AfterExitTime(0f)
                .Go("empty", "fast_radiate", 0f, Gt("heat", 0.8499999f)).AfterExitTime(0f)
                .Go("slow_radiate", "empty", 0f).AfterExitTime(PulseExitTime)
                .Go("fast_radiate", "empty", 0f).AfterExitTime(PulseExitTime)
                .Default("empty");

        /// <summary>Talking warms, up to 0.69.</summary>
        public static LayerSpec TalkingHeatAdd(HeatRates rates) =>
            new LayerSpec("talking_heat_add")
                .State("empty", Clips.Empty)
                .State("talk_heat_add", Clips.Empty).Drives(true, Drive.Add("heat", rates.Talking))
                .Go("empty", "talk_heat_add", 0f, Gt("Voice", 0f), Lt("heat", 0.69f)).AfterExitTime(0f)
                .Go("talk_heat_add", "empty", 0f).AfterExitTime(PulseExitTime)
                .Default("empty");

        /// <summary>
        /// Quantises heat to 0 / 0.5 / 1 in `heat_integral`, stepping up at 0.6 and 0.8 and back
        /// down past the same lines. Synced drivers, unlike the rest of the system.
        /// </summary>
        public static LayerSpec HeatIntegral()
        {
            const string zero = "0_0 heat integral", half = "0_5 heat integral", full = "1_0 heat integral";
            return new LayerSpec("heat_integral")
                .State(zero, Clips.Empty).Drives(false, Drive.Set("heat_integral", 0f))
                .State(half, Clips.Empty).Drives(false, Drive.Set("heat_integral", 0.5f))
                .State(full, Clips.Empty).Drives(false, Drive.Set("heat_integral", 1f))
                .Go(zero, half, 0f, Gt("heat", 0.6f))
                .Go(half, full, 0f, Gt("heat", 0.8f))
                .Go(half, zero, 0f, Lt("heat", 0.6f))
                .Go(full, half, 0f, Lt("heat", 0.8f))
                .Default(zero);
        }

        /// <summary>
        /// Touch warms, up to 0.84. Touching a region whose panel is OFF warms faster, up to
        /// 0.92, and so does stretching the abdomen wire, up to 0.96.
        /// </summary>
        public static LayerSpec ProxHeatAdd(HeatRates rates)
        {
            var spec = new LayerSpec("prox_heat_add")
                .State("empty", Clips.Empty)
                .State("prox_heat_add", Clips.Empty).Drives(true, Drive.Add("heat", rates.Proximity))
                .State("internal_heat_add", Clips.Empty).Drives(true, Drive.Add("heat", rates.Internal));

            foreach (var touch in TouchParams)
                spec.Go("empty", "prox_heat_add", 0f, If(touch), Lt("heat", 0.84f)).AfterExitTime(0f);

            // Touch params paired with the panel covering that region. Note the order is not
            // TouchParams', and the arms have no panel entry here.
            var exposed = new[]
            {
                ("right_thigh_touch", "right_thigh_panels"),
                ("left_thigh_touch", "left_thigh_panels"),
                ("hips_touch", "groin_panels"),
                ("abdomen_touch", "abdomen_panels"),
                ("chest_touch", "chest_panels"),
                ("head_touch", "face_panels"),
            };
            foreach (var (touch, panel) in exposed)
                spec.Go("empty", "internal_heat_add", 0f, If(touch), Lt("heat", 0.92f), IfNot(panel)).AfterExitTime(0f);

            spec.Go("empty", "internal_heat_add", 0f, Gt("ab_wire_Stretch", 0.2f), Lt("heat", 0.96f)).AfterExitTime(0f);

            return spec
                .Go("prox_heat_add", "empty", 0f).AfterExitTime(PulseExitTime)
                .Go("internal_heat_add", "empty", 0f).AfterExitTime(PulseExitTime)
                .Default("empty");
        }

        /// <summary>`evil_heat` warms all the way to 1.</summary>
        public static LayerSpec EvilHeatAdd(HeatRates rates) =>
            new LayerSpec("evil_heat_add")
                .State("empty", Clips.Empty)
                .State("evil_heat_add", Clips.Empty).Drives(true, Drive.Add("heat", rates.Evil))
                .Go("empty", "evil_heat_add", 0f, Gt("evil_heat", 0f), Lt("heat", 1f)).AfterExitTime(0f)
                .Go("evil_heat_add", "empty", 0f).AfterExitTime(PulseExitTime)
                .Default("empty");

        /// <summary>
        /// Flashes the battery indicator once on load: idle, then on, then off, then Exit (which
        /// re-enters idle). Synced drivers.
        /// </summary>
        public static LayerSpec BattControl() =>
            new LayerSpec("batt_control")
                .State("idle", Clips.Ncho("batt_idle"))
                .State("batt_indicator_on", Clips.Ncho("batt_state")).Drives(false, Drive.Set("batt_indicator", true))
                .State("batt_indicator_off", Clips.Ncho("batt_state")).Drives(false, Drive.Set("batt_indicator", false))
                .Go("idle", "batt_indicator_on", 0f).AfterExitTime(0f)
                .Go("batt_indicator_on", "batt_indicator_off", 0f).AfterExitTime(0f)
                .Exit("batt_indicator_off", 0.25f).AfterExitTime(0.75f)
                .Default("idle");
    }
}
