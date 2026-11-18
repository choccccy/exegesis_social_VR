using System.Collections.Generic;
using System.Linq;
using Exegesis.Shared;
using static Exegesis.Fx.CommonLayers;

namespace Exegesis.Fx
{
    /// <summary>
    /// lemaitre's FX layers written as code, in controller order. Started as a copy of ncho's;
    /// the differences are its base layer, its own neutral eyes, and wings
    /// without the contact sensors.
    /// </summary>
    public static class LemaitreAvatar
    {
        public static AvatarDefinition Define() => new AvatarDefinition(FxControllers.Lemaitre, Layers(), Parameters(), Expressions());

        private static IEnumerable<ParamSpec> Parameters() =>
            CommonParameters.BuiltIns()
                .Concat(CommonParameters.FaceTracking())
                .Concat(CommonParameters.Body())
                .Concat(new[]
                {
                    // Declared on lemaitre only; no layer reads them.
                    ParamSpec.Bool("TEU_core"),
                    ParamSpec.Bool("TEU_reset"),
                });

        private static ExpressionsSpec Expressions()
        {
            // Empty for now.
            var teu = new MenuSpec("Assets/_exegesis/lemaitre/TEU_menu.asset");

            var main = new MenuSpec("Assets/_exegesis/lemaitre/lemaitre_main_menu.asset", CommonExpressions.NchoParams)
                .SubMenu("TEU Core", teu, Icons.Equipment)
                .Toggle("Snub", "rcs")
                .SubMenu("Panels", CommonExpressions.NchoPanels(), Icons.Panels)
                .SubMenu("Config", CommonExpressions.Config(), Icons.Config)
                .SubMenu("Expression", CommonExpressions.Expression(), Icons.Expression);

            return new ExpressionsSpec("Assets/_exegesis/lemaitre/lemaitre_params.asset",
                CommonExpressions.Parameters().Concat(new[]
                {
                    ExpressionParam.Bool("TEU_core"),
                    ExpressionParam.Bool("TEU_reset"),
                }),
                main);
        }

        private static IEnumerable<LayerSpec> Layers()
        {
            // lemaitre's base layer plays the transparent core rather than nothing.
            yield return Base()
                .State("[lemaitre]_core_transparent 0", Clips.Lemaitre("[lemaitre]_core_transparent"))
                .Default("[lemaitre]_core_transparent 0");
            yield return Blink("[ncho]_blink", Clips.Ncho("[ncho]_blink"));
            yield return ToolHolstering();
            yield return GlyphsNeutral();
            yield return Blushie();
            yield return VentGlow(Clips.Ncho("ncho_heat_glow"));
            yield return HeatRadiation(HeatRates.Ncho);
            yield return TalkingHeatAdd(HeatRates.Ncho);
            yield return HeatIntegral();
            yield return ProxHeatAdd(HeatRates.Ncho);
            yield return EvilHeatAdd(HeatRates.Ncho);
            yield return EyesNeutral(Clips.Lemaitre("[lemaitre]_eyes_neutral"));
            yield return Eyes();
            yield return OverlayOpen();
            yield return BattControl();
            yield return BattIndicator();
            yield return WaterLevel();
            yield return Ears();
            yield return TailState();
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
            yield return PanelToolControl();
            yield return VertexRounding();
            yield return Audiolink();
            yield return FloorCollider();
            yield return Hud();
            yield return Transponder();
            yield return TouchNeutral();
            foreach (var t in Touches()) yield return t;
            yield return Eyeshadow();
        }
    }
}
