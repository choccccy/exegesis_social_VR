#if UNITY_EDITOR
using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using JetBrains.Annotations;
using UnityEditor;
using UnityEngine;
using UnityEngine.Serialization;
using VRC.SDKBase;

[assembly: InternalsVisibleTo("VRC.SDK3A.Editor")]
namespace VRC.SDK3.Avatars.Components
{
    /// <summary>
    /// Internal storage class for handling per platform overrides
    /// Use VRC.SDK3A.Editor.PerPlatformOverrides to edit the overrides
    /// </summary>
    [AddComponentMenu("")]
    internal class VRCPerPlatformOverrides: MonoBehaviour, IEditorOnly
    {
        [Serializable]
        internal struct PlatformOverrideOption : IEquatable<PlatformOverrideOption>
        {
            public VRC_AvatarDescriptor avatar;
            public BuildTarget platform;

            public bool Equals(PlatformOverrideOption other)
            {
                return Equals(avatar, other.avatar) && platform == other.platform;
            }

            public override bool Equals(object obj)
            {
                return obj is PlatformOverrideOption other && Equals(other);
            }

            public override int GetHashCode()
            {
                return HashCode.Combine(avatar, (int) platform);
            }
        }
        
        [SerializeField]
        internal List<PlatformOverrideOption> platformOverrides = new List<PlatformOverrideOption>();
    }
}
#endif