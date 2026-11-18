using System;
using System.IO;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Shared
{
    /// <summary>
    /// Where each committed FX controller's golden snapshot lives, and how to re-bless it.
    ///
    /// Same shape as the golden-image suites (RcsGoldenBaselineCapture, HudGoldenBaselineCapture):
    /// a committed baseline, a menu item to recapture it, and an environment variable so the
    /// headless runner can do the same thing. Paths come from FxControllers, which the menu item,
    /// the tests and the builder all share, so they cannot drift apart.
    ///
    /// Re-bless deliberately, not reflexively. The whole controller is covered - including the
    /// hand-built layers no generator owns - so a diff here after an intentional hand edit is
    /// expected and should be blessed, while a diff here after only touching the generators
    /// means something moved that should not have.
    /// </summary>
    public static class ControllerSnapshotBaseline
    {
        /// <summary>
        /// Read and written through System.IO rather than as a TextAsset: AssetDatabase caches
        /// TextAssets, and a test that compares against a stale cached baseline is worse than no
        /// test at all.
        /// </summary>
        public static string BaselineFullPath(FxController fx) =>
            Path.Combine(ProjectRoot, fx.BaselineAssetPath.Replace('/', Path.DirectorySeparatorChar));

        private static string ProjectRoot =>
            Directory.GetParent(Application.dataPath)?.FullName ?? Application.dataPath;

        /// <summary>
        /// Deliberately NOT wired to HUD_CAPTURE_BASELINES, which the headless runner's -Capture
        /// switch sets. The golden-image suites share that variable, so hanging this off it too
        /// would mean re-blessing the controllers every time someone recaptured a render - and
        /// silently, since a rewritten baseline never fails.
        /// </summary>
        public static bool CaptureRequested =>
            !string.IsNullOrEmpty(Environment.GetEnvironmentVariable("EXEGESIS_CAPTURE_SNAPSHOT"));

        public static AnimatorController LoadController(FxController fx) =>
            AssetDatabase.LoadAssetAtPath<AnimatorController>(fx.ControllerPath);

        /// <summary>
        /// Snapshots one committed controller and overwrites its baseline. Compact detail: a
        /// controller references over a hundred clips and inlining every keyframe of each would
        /// produce a baseline nobody reviews, which is the same as not having one. Each clip's
        /// curve data is hashed instead, so a changed keyframe still fails the test.
        /// </summary>
        public static string Capture(FxController fx)
        {
            var controller = LoadController(fx);
            if (controller == null)
                throw new InvalidOperationException($"No AnimatorController at {fx.ControllerPath}");

            var text = ControllerSnapshot.Of(controller, ControllerSnapshot.Detail.Compact);

            var full = BaselineFullPath(fx);
            var dir = Path.GetDirectoryName(full);
            if (!string.IsNullOrEmpty(dir)) Directory.CreateDirectory(dir);
            File.WriteAllText(full, text);

            return text;
        }

        [MenuItem("Tools/Exegesis/Debug/Capture Controller Snapshot Baselines", false, 121)]
        private static void CaptureFromMenu()
        {
            foreach (var fx in FxControllers.All)
            {
                var text = Capture(fx);
                AssetDatabase.ImportAsset(fx.BaselineAssetPath, ImportAssetOptions.ForceUpdate);
                Debug.Log($"[snapshot] {fx.Name}: captured {CountLines(text)} lines to " +
                          $"{fx.BaselineAssetPath}.");
            }

            Debug.Log("[snapshot] Review the diff before committing - these baselines cover the " +
                      "hand-built layers too, so an unexpected change here is a finding, not noise.");
        }

        private static int CountLines(string text)
        {
            int n = 0;
            foreach (var ch in text) if (ch == '\n') n++;
            return n;
        }

        /// <summary>
        /// Line endings are normalised on both sides of every comparison. The snapshot is
        /// written with \n, but git's autocrlf can hand it back with \r\n, and a baseline that
        /// fails depending on how it was checked out is a baseline nobody trusts.
        /// </summary>
        public static string Normalize(string text) =>
            (text ?? "").Replace("\r\n", "\n").Replace("\r", "\n");
    }
}
