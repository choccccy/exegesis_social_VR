using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using System.Linq;

// Script designed by BluWizard LABS. https://bluwizard.net
// 
// This funny script is a sanity check that checks your project for animation files that is causing the following VRChat bug:
// https://feedback.vrchat.com/avatar-30/p/fallback-shader-type-hidden-becomes-visible-when-animated-material-alpha-changes
// The result of the scan will be printed into the Console. Make sure to enable "Info" Console messages.
//
// HEADS UP: This detects ANY material property that uses the common Material Properties naming schemes that may or may not contribute to the bug: _Color, _BaseColor, _MainColor, _Tint.
// 
// Hopefully this script will be useless when VRChat actually prioritizes fixing this bug. But it's here anyways just in case.

namespace BluUtilities
{
    public static class FindAlphaAnimatingClips
    {
        [MenuItem("Tools/BluWizard LABS/Debugging Tools/Scan for Material Alpha Animations")]
        public static void Scan()
        {
            // Find all AnimationClips in the project
            var clipGuids = AssetDatabase.FindAssets("t:AnimationClip");
            var clips = new List<AnimationClip>(clipGuids.Length);
            foreach (var guid in clipGuids)
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(path);
                if (clip != null) clips.Add(clip);
            }

            // Build a map of AnimationClip -> AnimatorControllers that reference it
            var controllerRefs = BuildControllerReferences();

            // Analyze clips for suspicious alpha animation curves
            int hitCount = 0;
            Debug.Log($"[<color=#0092d9>BluWizard LABS</color>] [<color=#27daf5>Alpha Anim Detector</color>] Scanning {clips.Count} Animation Clips...");
            foreach (var clip in clips)
            {
                var matches = GetAlphaBindings(clip);
                if (matches.Count == 0) continue;

                hitCount++;

                var clipPath = AssetDatabase.GetAssetPath(clip);
                var clipGuid = AssetDatabase.AssetPathToGUID(clipPath);
                if (string.IsNullOrEmpty(clipGuid)) clipGuid = "<no GUID>";

                // Find controllers referencing this clip (path -> GUID)
                var controllers = controllerRefs.TryGetValue(clip, out var ctrls) ? ctrls : new List<AnimatorController>();

                var controllerGuids = controllers.Select(c => AssetDatabase.GetAssetPath(c)).Select(p => $"{p} [GUID {AssetDatabase.AssetPathToGUID(p)}]").Distinct().ToList();

                // Print report line
                var props = string.Join(", ", matches.Select(m => $"[{m.type.Name}] {m.path} :: {m.propertyName}"));
                var ctrlsLine = controllerGuids.Count > 0 ? string.Join("; ", controllerGuids) : "(no AnimatorController reference found)";

                Debug.Log(
                    $"[<color=#0092d9>BluWizard LABS</color>] [<color=#27daf5>Alpha Anim Detector</color>] ⚠ AnimationClip: {clip.name} " +
                    $"\n Path: {clipPath} " +
                    $"\n GUID: {clipGuid} " +
                    $"\n Matches: {matches.Count} " +
                    $"\n Curves: {props} " +
                    $"\n Used by Animator Controllers: {ctrlsLine}"
                );
            }

            Debug.Log($"[<color=#0092d9>BluWizard LABS</color>] [<color=#27daf5>Alpha Anim Detector</color>] Done. Found {hitCount} clip(s) animating Material Alpha properties.");
        }

        // Helpers
        private struct BindingInfo
        {
            public System.Type type;
            public string path;
            public string propertyName;
        }

        // Detect binding that likely modify Material Alpha by casting a reasonably wide net to catch common pipelines
        private static List<BindingInfo> GetAlphaBindings(AnimationClip clip)
        {
            var results = new List<BindingInfo>();
            var curves = AnimationUtility.GetCurveBindings(clip);
            foreach (var b in curves)
            {
                if (IsAlphaProperty(b.propertyName))
                {
                    results.Add(new BindingInfo
                    {
                        type = b.type,
                        path = b.path,
                        propertyName = b.propertyName
                    });
                }
            }
            return results;
        }

        private static bool IsAlphaProperty(string propertyName)
        {
            // Normalize once
            var p = propertyName.Replace(" ", "");
            var l = p.ToLowerInvariant();

            if (l.Contains("alpha")) return true;

            // Common color channels with ".a"
            bool endsWithA = l.EndsWith(".a");
            if (endsWithA)
            {
                // Require a color-ish token if we only see ".a"
                if (l.Contains("_Color") || l.Contains("BaseColor") || l.Contains("_BaseColor") || l.Contains("MainColor") || l.Contains("_MainColor") || l.Contains("Tint") || l.Contains("_Tint"))
                {
                    return true;
                }
            }

            // Also catch "_Opacity" just in case some shader expose that.
            if (l.Contains("Opacity")) return true;

            return false;
        }

        // Build a reverse index: AnimationClip -> AnimatorControllers that reference it.
        private static Dictionary<AnimationClip, List<AnimatorController>> BuildControllerReferences()
        {
            var map = new Dictionary<AnimationClip, List<AnimatorController>>();
            var ctrlGuids = AssetDatabase.FindAssets("t:AnimatorController");

            foreach (var guid in ctrlGuids)
            {
                var path = AssetDatabase.GUIDToAssetPath(guid);
                var ctrl = AssetDatabase.LoadAssetAtPath<AnimatorController>(path);
                if (ctrl == null) continue;

                var clipsInController = new HashSet<AnimationClip>();
                foreach (var layer in ctrl.layers)
                {
                    if (layer?.stateMachine == null) continue;
                    GatherClipsFromStateMachine(layer.stateMachine, clipsInController);
                }

                foreach (var clip in clipsInController)
                {
                    if (!map.TryGetValue(clip, out var list))
                    {
                        list = new List<AnimatorController>();
                        map[clip] = list;
                    }
                    list.Add(ctrl);
                }
            }

            return map;
        }

        private static void GatherClipsFromStateMachine(AnimatorStateMachine sm, HashSet<AnimationClip> outClips)
        {
            if (sm == null) return;

            foreach (var state in sm.states)
            {
                if (state.state == null) continue;
                var motion = state.state.motion;
                GatherClipsFromMotion(motion, outClips);
            }

            foreach (var child in sm.stateMachines)
            {
                GatherClipsFromStateMachine(child.stateMachine, outClips);
            }
        }

        private static void GatherClipsFromMotion(Motion motion, HashSet<AnimationClip> outClips)
        {
            if (motion == null) return;

            var clip = motion as AnimationClip;
            if (clip != null)
            {
                outClips.Add(clip);
                return;
            }

            var bt = motion as BlendTree;
            if (bt != null)
            {
                // Recurse children
                var children = bt.children;
                for (int i = 0; i < children.Length; i++)
                {
                    GatherClipsFromMotion(children[i].motion, outClips);
                }
            }
        }
    }
}