using System;
using System.Collections.Generic;
using System.Linq;
using Exegesis.Shared;

namespace Exegesis.Fx
{
    /// <summary>
    /// Everything the builder needs to know about one avatar: its controller, its layers in
    /// order, and its parameters.
    ///
    /// The builder rebuilds the controller from empty on every run: these parameters, then
    /// these layers in this order, then the slot and RCS tools' layers and parameters after
    /// them. So this definition IS the controller, apart from what those two tools own.
    ///
    /// Each avatar's definition lives in its own file (NchoAvatar, LemaitreAvatar, ObiMeAvatar).
    /// Shared layers come from CommonLayers and shared parameters from CommonParameters;
    /// anything that differs per avatar is visible right there as an argument or an extra.
    /// </summary>
    public sealed class AvatarDefinition
    {
        public FxController Fx { get; }

        /// <summary>The avatar's layers, top to bottom. The slot and RCS layers follow these.</summary>
        public IReadOnlyList<LayerSpec> Layers { get; }

        /// <summary>The avatar's parameters, in order. The slot and RCS parameters follow these.</summary>
        public IReadOnlyList<ParamSpec> Parameters { get; }

        /// <summary>Expression parameters and menus (VRChat's side of the avatar).</summary>
        public ExpressionsSpec Expressions { get; }

        public AvatarDefinition(FxController fx, IEnumerable<LayerSpec> layers, IEnumerable<ParamSpec> parameters,
                                ExpressionsSpec expressions)
        {
            Fx = fx;
            Layers = layers.ToList();
            Parameters = parameters.ToList();
            Expressions = expressions;
        }

        /// <summary>
        /// Everything wrong with the definition. The builder refuses to touch the controller if
        /// this is not empty, and AvatarDefinitionTests reports it as a failure.
        ///
        /// The parameter checks matter most. A layer that references an undeclared parameter
        /// does not fail anywhere: Animator As Code quietly declares it, with a default of
        /// zero, so a typo in a spec becomes a new parameter nothing ever sets.
        /// </summary>
        public IEnumerable<string> Problems()
        {
            foreach (var p in Expressions.Problems()) yield return p;

            foreach (var p in Layers.SelectMany(l => l.Problems())) yield return p;

            foreach (var g in Layers.GroupBy(l => l.Name).Where(g => g.Count() > 1))
                yield return $"layer '{g.Key}' is defined {g.Count()} times.";
            foreach (var l in Layers.Where(l => l.Name.StartsWith("slot_") || l.Name.StartsWith("rcs_")))
                yield return $"layer '{l.Name}' uses a prefix the slot / RCS tools own.";

            foreach (var g in Parameters.GroupBy(p => p.Name).Where(g => g.Count() > 1))
                yield return $"parameter '{g.Key}' is declared {g.Count()} times.";
            foreach (var p in Parameters.Where(p => CommonParameters.Retired.Contains(p.Name)))
                yield return $"parameter '{p.Name}' is declared, but CommonParameters.Retired says it was removed.";

            var declared = Parameters.GroupBy(p => p.Name).ToDictionary(g => g.Key, g => g.First().Type);
            foreach (var layer in Layers)
            {
                foreach (var (param, type, use) in References(layer))
                {
                    if (!declared.TryGetValue(param, out var actual))
                        yield return $"{layer.Name}: {use} uses '{param}', which the avatar does not declare.";
                    else if (type != null && actual != type)
                        yield return $"{layer.Name}: {use} uses '{param}' as {type}, but it is declared {actual}.";
                }
            }
        }

        private static IEnumerable<(string Param, UnityEngine.AnimatorControllerParameterType? Type, string Use)>
            References(LayerSpec layer)
        {
            foreach (var s in layer.States)
            {
                if (s.MotionTime != null)
                    yield return (s.MotionTime, UnityEngine.AnimatorControllerParameterType.Float, $"state '{s.Name}' motion time");
                if (s.Driver != null)
                    foreach (var d in s.Driver.Drives)
                        yield return (d.Param, null, $"state '{s.Name}' driver");
            }

            foreach (var t in layer.Transitions)
                foreach (var c in t.Conditions)
                    yield return (c.Param, ToUnity(c.Kind), $"transition {t.From} -> {t.To ?? "Exit"}");
        }

        private static UnityEngine.AnimatorControllerParameterType ToUnity(ParamKind kind) =>
            kind == ParamKind.Bool ? UnityEngine.AnimatorControllerParameterType.Bool
            : kind == ParamKind.Int ? UnityEngine.AnimatorControllerParameterType.Int
            : UnityEngine.AnimatorControllerParameterType.Float;
    }

    public static class Avatars
    {
        /// <summary>
        /// Built fresh on every call, so nothing a build does to a spec can leak into the next.
        /// </summary>
        public static IReadOnlyList<AvatarDefinition> All => new[]
        {
            NchoAvatar.Define(),
            LemaitreAvatar.Define(),
            ObiMeAvatar.Define(),
        };

        /// <summary>
        /// The definition for a controller. Throws rather than returning null: a controller in
        /// FxControllers with no definition would otherwise build with none of its layers.
        /// </summary>
        public static AvatarDefinition For(FxController fx)
        {
            var avatar = All.FirstOrDefault(a => a.Fx.Name == fx.Name);
            if (avatar == null)
                throw new InvalidOperationException(
                    $"No AvatarDefinition for '{fx.Name}'. Add one under fx/Editor/Avatars and list it in Avatars.All.");
            return avatar;
        }
    }
}
