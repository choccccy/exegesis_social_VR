// NchoSlotSetup only exists when the VRChat SDK does, and every build needs it.
#if VRC_SDK_VRCSDK3

using System;
using System.Collections.Generic;
using System.Linq;
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
    /// Today it runs the two existing generators, slots then RCS, over every controller in
    /// FxControllers. The goal is for it to own each controller outright: every layer generated
    /// from code, nothing edited in the Animator window. Hand-built layers move into it one
    /// family at a time, each proven against the controller snapshot baseline before the
    /// hand-built original is deleted. See docs/animator-generation.md.
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
        /// Builds every generated layer into one controller, configured for the avatar `fx`
        /// describes. The tests call this on a scratch copy; the menu item calls it on each
        /// committed controller.
        /// </summary>
        public static void Build(AnimatorController controller, FxController fx)
        {
            if (controller == null) throw new ArgumentNullException(nameof(controller));
            if (fx == null) throw new ArgumentNullException(nameof(fx));

            // Hand-built layers now written as code, from the avatar's definition. Each keeps
            // its original position in the controller.
            PortedLayers.Build(controller, Avatars.For(fx));

            // Slots first: that tool declares the ints the RCS group layers condition on.
            NchoSlotSetup.Build(controller);
            RcsAnimatorSetup.Build(controller);

            // Last, so it covers every generator's clips. Without it the saved bytes depend on
            // whether anything happened to read the clips before the next save.
            AnimatorAssets.SyncEditorCurves(controller);
            EditorUtility.SetDirty(controller);
            AssetDatabase.SaveAssets();
        }

        /// <summary>
        /// Builds every controller in FxControllers. Returns the ones that could not be loaded,
        /// so callers can fail loudly rather than skip an avatar - skipping one silently is the
        /// exact failure this class exists to prevent.
        /// </summary>
        public static List<FxController> BuildAll(IEnumerable<FxController> controllers = null)
        {
            var missing = new List<FxController>();

            foreach (var fx in controllers ?? FxControllers.All)
            {
                var controller = AssetDatabase.LoadAssetAtPath<AnimatorController>(fx.ControllerPath);
                if (controller == null)
                {
                    Debug.LogError($"{LogPrefix} {fx.Name}: no AnimatorController at {fx.ControllerPath}.");
                    missing.Add(fx);
                    continue;
                }

                Debug.Log($"{LogPrefix} {fx.Name}: building {fx.ControllerPath}");
                Build(controller, fx);
            }

            AssetDatabase.SaveAssets();
            return missing;
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
                "Could not load:\n" +
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
