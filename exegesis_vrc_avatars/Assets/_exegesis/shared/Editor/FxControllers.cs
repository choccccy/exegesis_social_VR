using System.Collections.Generic;
using System.Linq;

namespace Exegesis.Shared
{
    /// <summary>
    /// One avatar's FX controller: where it lives and where its golden snapshot lives.
    /// </summary>
    public sealed class FxController
    {
        /// <summary>Short name, used in test case names, log lines and the baseline file name.</summary>
        public string Name { get; }

        public string ControllerPath { get; }

        public string BaselineAssetPath { get; }

        // What the builder generates for an avatar lives in its AvatarDefinition
        // (Exegesis.Fx, fx/Editor/Avatars), not here: this assembly has no AAC and no SDK.

        public FxController(string name, string controllerPath)
        {
            Name = name;
            ControllerPath = controllerPath;
            BaselineAssetPath = $"{FxControllers.BaselineDir}/{name}_fx.snapshot.txt";
        }

        public override string ToString() => Name;
    }

    /// <summary>
    /// Every FX controller the generators build, in one place.
    ///
    /// Why this exists: lemaitre_fx and obi-me_fx started life as copies of ncho_fx. The
    /// generators only ever knew about ncho's path, so the rcs_* and slot_* layers in the other
    /// two were frozen at whatever ncho looked like the day each copy was made. Nothing failed
    /// and nothing said so. Listing every controller here, and having the builder and the tests
    /// both iterate this list, is what stops a controller from quietly falling out of the build.
    ///
    /// Adding an avatar means adding a line here. The builder will then generate into it, and
    /// the per-controller tests will cover it. Before its first build, capture its baseline so
    /// the first rebuild's diff is reviewable rather than just a new baseline that gets accepted.
    ///
    /// No AAC and no SDK dependency, deliberately: the tests and the snapshot tooling read this,
    /// and neither should need either.
    /// </summary>
    public static class FxControllers
    {
        public const string BaselineDir = "Assets/_exegesis/thruster_shader/Tests/Editor/Baselines";

        public static readonly FxController Ncho =
            new FxController("ncho", "Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller");

        public static readonly FxController Lemaitre =
            new FxController("lemaitre", "Assets/_exegesis/lemaitre/lemaitre_fx.controller");

        public static readonly FxController ObiMe =
            new FxController("obi-me", "Assets/_exegesis/obi-me/obi-me_fx.controller");

        public static readonly IReadOnlyList<FxController> All = new[] { Ncho, Lemaitre, ObiMe };

        public static FxController ByName(string name) => All.FirstOrDefault(c => c.Name == name);
    }
}
