// NchoSlotSetup only exists when the VRChat SDK does, and every build needs it.
#if VRC_SDK_VRCSDK3

using System;
using System.Collections.Generic;
using System.Linq;
using Exegesis.Aac;
using Exegesis.Ncho;
using Exegesis.RcsThruster;
using Exegesis.Shared;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Fx
{
    /// <summary>
    /// The one entry point that builds the avatars' FX controllers.
    ///
    /// Every build starts from an EMPTY controller and puts back exactly what code declares:
    ///   1. the avatar's parameters (AvatarDefinition.Parameters),
    ///   2. the avatar's layers, in order (AvatarDefinition.Layers),
    ///   3. the slot tool's layers and parameters,
    ///   4. the RCS tool's layers and parameters.
    /// So the code is the whole controller. The asset is emptied rather than replaced, so its
    /// GUID, which the avatar descriptors reference, never changes. See
    /// docs/animator-generation.md.
    ///
    /// Before emptying anything it refuses to build if the controller holds a layer or
    /// parameter that no code declares, because building would delete it. That is the one
    /// way work could be lost: a layer added in the Animator window.
    ///
    /// Why one entry point rather than one menu item per generator:
    ///   - The ORDER is part of the contract. NchoSlotSetup declares the slot ints the
    ///     rcs_group_* layers condition on, so slots must run first. That used to live in menu
    ///     priorities and in a log line asking you to run the other tool next. Now it lives
    ///     here, once.
    ///   - The per-generator menu items only ever targeted ncho_fx. lemaitre_fx and obi-me_fx
    ///     are copies of it, and their generated layers silently froze at whatever ncho looked
    ///     like the day each copy was made.
    ///
    /// Separate assembly because it needs both generators, and they live apart on purpose: the
    /// slot tool needs the VRChat SDK, and the RCS / shader tooling must not take that dependency.
    /// </summary>
    public static class FxBuilder
    {
        private const string LogPrefix = "[fx]";

        /// <summary>
        /// Rebuilds one controller from empty, as the avatar `fx` names is defined. The tests
        /// call this on a scratch copy; the menu item calls it on each committed controller.
        ///
        /// Throws, having changed nothing, if the definition has problems or the controller
        /// holds anything undeclared. Throwing rather than logging is deliberate: a test that
        /// builds a scratch copy must fail, not compare an unbuilt copy and pass.
        /// </summary>
        public static void Build(AnimatorController controller, FxController fx)
        {
            if (controller == null) throw new ArgumentNullException(nameof(controller));
            if (fx == null) throw new ArgumentNullException(nameof(fx));

            var avatar = Avatars.For(fx);
            var problems = Preflight(controller, avatar).ToList();
            if (problems.Count > 0)
                throw new InvalidOperationException(
                    $"{LogPrefix} {fx.Name}: not built, nothing was changed:\n  " + string.Join("\n  ", problems));

            ExegesisAac.ClearController(controller);
            controller.parameters = avatar.Parameters.Select(p => p.ToUnity()).ToArray();

            AvatarLayers.Build(controller, avatar);

            // Slots before RCS: that tool declares the ints the RCS group layers condition on.
            NchoSlotSetup.Build(controller);
            RcsAnimatorSetup.Build(controller);

            // Last, so it covers every generator's clips. Without it the saved bytes depend on
            // whether anything happened to read the clips before the next save.
            AnimatorAssets.SyncEditorCurves(controller);
            EditorUtility.SetDirty(controller);
            AssetDatabase.SaveAssets();
        }

        /// <summary>
        /// What would stop a build. Checked before the controller is touched.
        /// </summary>
        private static IEnumerable<string> Preflight(AnimatorController controller, AvatarDefinition avatar)
        {
            foreach (var p in avatar.Problems()) yield return p;
            foreach (var clip in NchoSlotSetup.MissingClips()) yield return $"slot tool: missing clip {clip}";

            var layers = new HashSet<string>(avatar.Layers.Select(l => l.Name));
            foreach (var l in controller.layers)
            {
                // The slot and RCS tools own their prefixes, debug probes included.
                if (layers.Contains(l.name) || l.name.StartsWith("slot_") || l.name.StartsWith("rcs_")) continue;
                yield return $"layer '{l.name}' is in the controller but no code declares it. Building " +
                             "would delete it. If it was added in the Animator window, write it as a " +
                             $"LayerSpec in {avatar.Fx.Name}'s definition (fx/Editor/Avatars) instead.";
            }

            var parameters = new HashSet<string>(avatar.Parameters.Select(p => p.Name)
                .Concat(NchoSlotSetup.ParameterNames)
                .Concat(RcsAnimatorSetup.ParameterNames)
                .Concat(CommonParameters.Retired));
            foreach (var p in controller.parameters)
            {
                if (parameters.Contains(p.name)) continue;
                yield return $"parameter '{p.name}' is in the controller but no code declares it. " +
                             $"Building would delete it. Add it to {avatar.Fx.Name}'s parameters.";
            }
        }

        /// <summary>
        /// Writes the avatar's expression parameters and menus. Runs after its controller is
        /// built, because it checks every expression parameter against the controller's
        /// declarations: an expression parameter the animator does not declare (or declares
        /// with another type) syncs and saves a value nothing ever reads.
        ///
        /// Throws, having written nothing, on any problem - including a shared menu (Config,
        /// Expression, Panels) that two avatars describe differently.
        /// </summary>
        public static void BuildExpressions(AnimatorController controller, FxController fx)
        {
            var avatar = Avatars.For(fx);
            var problems = ExpressionsBuilder.Problems(avatar, controller)
                .Concat(ExpressionsBuilder.SharedMenuConflicts(Avatars.All))
                .ToList();
            if (problems.Count > 0)
                throw new InvalidOperationException(
                    $"{LogPrefix} {fx.Name}: expressions not written, nothing was changed:\n  " +
                    string.Join("\n  ", problems));

            ExpressionsBuilder.Build(avatar.Expressions, fx.Name);
        }

        /// <summary>
        /// Builds every controller in FxControllers, and each avatar's expressions. Returns the ones that failed - could not be
        /// loaded, or refused to build - so callers can fail loudly rather than skip an avatar.
        /// Skipping one silently is the exact failure this class exists to prevent.
        /// </summary>
        public static List<FxController> BuildAll(IEnumerable<FxController> controllers = null)
        {
            var failed = new List<FxController>();

            foreach (var fx in controllers ?? FxControllers.All)
            {
                var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(fx.ControllerPath);
                if (controller == null)
                {
                    Debug.LogError($"{LogPrefix} {fx.Name}: no AnimatorController at {fx.ControllerPath}.");
                    failed.Add(fx);
                    continue;
                }

                Debug.Log($"{LogPrefix} {fx.Name}: building {fx.ControllerPath}");
                try
                {
                    Build(controller, fx);
                    BuildExpressions(controller, fx);
                }
                catch (InvalidOperationException e)
                {
                    Debug.LogError(e.Message);
                    failed.Add(fx);
                }
            }

            AssetDatabase.SaveAssets();
            return failed;
        }

        // Priority 0: the top of Tools > Exegesis, since it is now the only build entry point.
        [MenuItem("Tools/Exegesis/Build FX Controllers", false, 0)]
        private static void BuildAllFromMenu()
        {
            var missing = BuildAll();
            if (missing.Count == 0)
            {
                Debug.Log($"{LogPrefix} Built {FxControllers.All.Count} FX controller(s): " +
                          string.Join(", ", FxControllers.All.Select(c => c.Name)) + ".");
                return;
            }

            EditorUtility.DisplayDialog("Build FX Controllers",
                "These were not built (the Console says why):\n" +
                string.Join("\n", missing.Select(m => $"{m.Name}: {m.ControllerPath}")) +
                "\n\nThe others were built.", "OK");
        }

        /// <summary>
        /// Headless entry point, for building in the clone:
        ///
        ///   Unity.exe -batchmode -projectPath &lt;clone&gt; -executeMethod Exegesis.Fx.FxBuilder.BuildAllFromCommandLine
        ///             [-fxOnly ncho,lemaitre]
        ///
        /// Deliberately has no -quit-style shortcut around the exit code: a controller that
        /// failed to load exits 1, so a script driving this cannot mistake a partial build for a
        /// complete one.
        /// </summary>
        public static void BuildAllFromCommandLine()
        {
            int code = 0;
            try
            {
                var targets = SelectFromArgs(Environment.GetCommandLineArgs());
                var missing = BuildAll(targets);
                if (missing.Count > 0) code = 1;
            }
            catch (Exception e)
            {
                Debug.LogException(e);
                code = 1;
            }

            EditorApplication.Exit(code);
        }

        private static IEnumerable<FxController> SelectFromArgs(string[] args)
        {
            int i = Array.IndexOf(args, "-fxOnly");
            if (i < 0 || i + 1 >= args.Length) return FxControllers.All;

            var names = args[i + 1].Split(',').Select(s => s.Trim()).Where(s => s.Length > 0).ToArray();
            var unknown = names.Where(n => FxControllers.ByName(n) == null).ToArray();
            if (unknown.Length > 0)
                throw new ArgumentException($"{LogPrefix} Unknown controller name(s): " +
                                            string.Join(", ", unknown) + ". Known: " +
                                            string.Join(", ", FxControllers.All.Select(c => c.Name)));

            return names.Select(FxControllers.ByName).ToArray();
        }
    }
}

#endif
