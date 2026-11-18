using System;
using System.Collections.Generic;
using System.Linq;
using Exegesis.Shared;

namespace Exegesis.Fx
{
    /// <summary>
    /// Everything the builder needs to know about one avatar: its controller, and the layers
    /// written as code for it.
    ///
    /// Each avatar's definition lives in its own file (NchoAvatar, LemaitreAvatar, ObiMeAvatar)
    /// and lists its layers in controller order, so the file reads like the Animator window's
    /// layer list. Shared layers come from CommonLayers; anything that differs per avatar is
    /// visible right there as an argument or an avatar-only layer.
    /// </summary>
    public sealed class AvatarDefinition
    {
        public FxController Fx { get; }

        /// <summary>Hand-built layers that are now generated, in controller order.</summary>
        public IReadOnlyList<LayerSpec> Layers { get; }

        public AvatarDefinition(FxController fx, IEnumerable<LayerSpec> layers)
        {
            Fx = fx;
            Layers = layers.ToList();
        }
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
