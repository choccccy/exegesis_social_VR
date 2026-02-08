using System;
using System.Collections.Generic;
using JetBrains.Annotations;
using UnityEditor;
using UnityEngine;
using VRC.SDK3.Avatars.Components;
using VRC.SDKBase;

namespace VRC.SDK3A.Editor
{
    /// <summary>
    /// Sets per-platform references for an avatar.
    /// These will be used during an avatar multi-platform build to change which avatar version is being uploaded for that particular platform
    /// </summary>
    public static class PerPlatformOverrides
    {
        [Serializable]
        public struct Option : IEquatable<Option>
        {
            public VRC_AvatarDescriptor avatar;
            public BuildTarget platform;

            public bool Equals(Option other)
            {
                return Equals(avatar, other.avatar) && platform == other.platform;
            }

            public override bool Equals(object obj)
            {
                return obj is Option other && Equals(other);
            }

            public override int GetHashCode()
            {
                return HashCode.Combine(avatar, (int)platform);
            }
        }

        /// <summary>
        /// Gets the platform overrides for the provided GameObject
        /// </summary>
        /// <param name="go"></param>
        /// <returns></returns>
        [PublicAPI]
        public static List<Option> GetPlatformOverrides(GameObject go)
        {
            if (!go.TryGetComponent<VRCPerPlatformOverrides>(out var vrcPerPlatformOverride)) return null;

            var overrides = new List<Option>();
            foreach (var platformOverride in vrcPerPlatformOverride.platformOverrides)
            {
                var option = new Option
                {
                    avatar = platformOverride.avatar,
                    platform = platformOverride.platform
                };
                overrides.Add(option);
            }

            return overrides;
        }

        /// <summary>
        /// Sets the platform overrides for the provided GameObject
        /// </summary>
        /// <param name="go"></param>
        /// <param name="overrides"></param>
        [PublicAPI]
        public static void SetPlatformOverrides(GameObject go, List<PerPlatformOverrides.Option> overrides)
        {
            if (!go.TryGetComponent<VRCPerPlatformOverrides>(out var vrcPerPlatformOverride))
            {
                vrcPerPlatformOverride = Undo.AddComponent<VRCPerPlatformOverrides>(go);
            }
            var overridesSo = new SerializedObject(vrcPerPlatformOverride);
            overridesSo.Update();
            var newOptions = new List<VRCPerPlatformOverrides.PlatformOverrideOption>();
            foreach (var option in overrides)
            {
                var platformOverride = new VRCPerPlatformOverrides.PlatformOverrideOption
                {
                    avatar = option.avatar,
                    platform = option.platform
                };
                newOptions.Add(platformOverride);
            }

            var prop = overridesSo.FindProperty("platformOverrides");
            prop.ClearArray();
            prop.arraySize = newOptions.Count;
            for (var i = 0; i < newOptions.Count; i++)
            {
                var platformOverride = newOptions[i];
                var element = prop.GetArrayElementAtIndex(i);
                element.FindPropertyRelative("avatar").objectReferenceValue = platformOverride.avatar;
                element.FindPropertyRelative("platform").intValue = (int) platformOverride.platform;
            }
            overridesSo.ApplyModifiedProperties();
        }
        
        /// <summary>
        /// Removes all platform overrides from the provided GameObject
        /// </summary>
        /// <param name="go"></param>
        public static void ClearPlatformOverrides(GameObject go)
        {
            if (!go.TryGetComponent<VRCPerPlatformOverrides>(out var vrcPerPlatformOverride)) return;
            Undo.DestroyObjectImmediate(vrcPerPlatformOverride);
        }
    }
}