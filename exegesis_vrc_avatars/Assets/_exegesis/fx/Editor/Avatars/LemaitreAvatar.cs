using System.Collections.Generic;
using Exegesis.Shared;
using static Exegesis.Fx.CommonLayers;

namespace Exegesis.Fx
{
    /// <summary>
    /// lemaitre's FX layers written as code, in controller order. Started as a copy of ncho's;
    /// the differences are its base layer, its own neutral eyes, eyeshadow speed, and wings
    /// without the contact sensors.
    /// </summary>
    public static class LemaitreAvatar
    {
        public static AvatarDefinition Define() => new AvatarDefinition(FxControllers.Lemaitre, Layers());

        private static IEnumerable<LayerSpec> Layers()
        {
            // lemaitre's base layer plays the transparent core rather than nothing.
            yield return Base()
                .State("[lemaitre]_core_transparent 0", Clips.Lemaitre("[lemaitre]_core_transparent"))
                .Default("[lemaitre]_core_transparent 0");
            // blink, tool_holstering: hand-built
            yield return GlyphsNeutral();
            // blushie: hand-built
            yield return VentGlow(Clips.Ncho("ncho_heat_glow"));
            // heat system: hand-built
            yield return EyesNeutral(Clips.Lemaitre("[lemaitre]_eyes_neutral"));
            // eyes: hand-built
            yield return OverlayOpen();
            // batt_control: hand-built
            yield return BattIndicator();
            yield return WaterLevel();
            // ears, tail_state: hand-built
            yield return PanelsNeutral(Clips.Ncho("[panels]_neutral"));
            yield return PropsNeutral();
            yield return FaceOff();
            yield return ChestOff();
            yield return AbdomenOff();
            yield return GroinOff();
            yield return LeftArmOff();
            yield return RightArmOff();
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
            yield return Eyeshadow(speed: 100f);
        }
    }
}
