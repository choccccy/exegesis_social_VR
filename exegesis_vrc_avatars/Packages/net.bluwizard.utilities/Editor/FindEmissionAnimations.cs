using UnityEditor;
using UnityEngine;
using System.Linq;

// Script designed by BluWizard LABS. https://bluwizard.net
// 
// This funny script was created to help a friend find Animation Clips that are interfering with their Emission properties.
// Use this if for some reason that they're being animated in a Poiyomi material when they're not supposed to.
// Running the script will throw all detected animation clips interfering with these properties directly into the console.

namespace BluUtilities.FindEmissionAnimations
{
    public static class FindEmissionAnimations
    {
        [MenuItem("Tools/BluWizard LABS/Debugging Tools/Find Emission Animations")]
        public static void Find()
        {
            string[] guids = AssetDatabase.FindAssets("t:AnimationClip");
            string[] keys = {
                "material._EmissionColor",
                "material._Emission",
                "material._EmissionStrength",
                "_EmissionColor",
                "_Emission",
                "_EmissionStrength",
            };

            int hits = 0;
            foreach (var g in guids)
            {
                var path = AssetDatabase.GUIDToAssetPath(g);
                var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(path);
                if (clip == null) continue;

                var bindings = AnimationUtility.GetCurveBindings(clip).Concat(AnimationUtility.GetObjectReferenceCurveBindings(clip));

                foreach (var b in bindings)
                {
                    string prop = b.propertyName ?? "";
                    if (keys.Any(k => prop.Contains(k)))
                    {
                        Debug.Log($"[<color=#0092d9>BluWizard LABS</color>] Found Clips at Path: {b.path} Property: {prop} Type: {b.type?.Name}", clip);
                        hits++;
                    }
                }
            }
            if (hits == 0)
            {
                Debug.Log("[<color=#0092d9>BluWizard LABS</color>] No animation clips found writing to emission-related properties.");
            }
        }
    }
}
