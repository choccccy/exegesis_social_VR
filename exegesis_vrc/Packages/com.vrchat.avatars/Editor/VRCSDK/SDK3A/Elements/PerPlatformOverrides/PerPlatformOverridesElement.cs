using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using VRC.SDKBase;

[assembly: UxmlNamespacePrefix("VRC.SDK3A.Editor.Elements", "vrca")]
namespace VRC.SDK3A.Editor.Elements
{
    public class PerPlatformOverridesElement : VisualElement
    {
        public new class UxmlFactory : UxmlFactory<PerPlatformOverridesElement, UxmlTraits>
        {
        }

        public new class UxmlTraits : VisualElement.UxmlTraits
        {
            public override IEnumerable<UxmlChildElementDescription> uxmlChildElementsDescription
            {
                get { yield break; }
            }
        }
        
        private readonly VisualElement _perPlatformConfigContainer;
        private readonly Button _perPlatformConfigAddButton;
        private GameObject _targetAvatar;
        public EventHandler<List<PerPlatformOverrides.Option>> OnPerPlatformOverridesChanged;

        public PerPlatformOverridesElement() : this(null)
        {
        }
        
        public PerPlatformOverridesElement(GameObject targetAvatar)
        {
            Resources.Load<VisualTreeAsset>("PerPlatformOverrides").CloneTree(this);
            _perPlatformConfigContainer = this.Q("avatar-per-platform-config");
            _perPlatformConfigAddButton = this.Q<Button>("avatar-per-platform-entry-add-btn");
            _perPlatformConfigAddButton.clicked += AddPerPlatformConfigEntry;
            CreatePerPlatformConfig(targetAvatar);
        }
        
        public void CreatePerPlatformConfig(GameObject targetAvatar)
        {
            _targetAvatar = targetAvatar;
            _perPlatformConfigContainer.Clear();
            var platformOptions = VRC_EditorTools.GetBuildTargetOptionsAsEnum();
            
            if (_targetAvatar == null) return;
            var config = PerPlatformOverrides.GetPlatformOverrides(_targetAvatar);

            // If we ended up with a platform not in the supported list, we don't want to throw an error.
            // This is needed so the user can remove/fix it
            var combinedOptions = platformOptions.Union(config?.Select(o => o.platform) ?? new List<BuildTarget>()).ToList();
            
            // Always re-send event on re-render to perform any necessary UI updates
            OnPerPlatformOverridesChanged?.Invoke(this, config);
            
            if (config == null)
            {
                _perPlatformConfigAddButton.RemoveFromClassList("d-none");
                return;
            }

            foreach (var option in config)
            {
                var row = new VisualElement();
                row.AddToClassList("row");
                row.AddToClassList("align-items-center");

                var dropdown = new PopupField<BuildTarget>(
                    combinedOptions,
                    option.platform,
                    VRC_EditorTools.GetTargetName,
                    VRC_EditorTools.GetTargetName
                );
                dropdown.AddToClassList("flex-shrink-1");
                dropdown.AddToClassList("flex-4");
                dropdown.RegisterValueChangedCallback(evt =>
                {
                    var index = config.IndexOf(option);
                    if (index == -1) return;
                    // disallow duplicate platforms
                    if (config.Any(o => o.platform == evt.newValue))
                    {
                        // rebuild the list
                        CreatePerPlatformConfig(_targetAvatar);
                        return;
                    }
                    config[index] = new PerPlatformOverrides.Option
                    {
                        avatar = config[index].avatar,
                        platform = evt.newValue
                    };
                    PerPlatformOverrides.SetPlatformOverrides(_targetAvatar, config);
                    OnPerPlatformOverridesChanged?.Invoke(this, config);
                    // rebuild the list
                    CreatePerPlatformConfig(_targetAvatar);
                });
                row.Add(dropdown);

                var avatarField = new ObjectField
                {
                    objectType = typeof(VRC_AvatarDescriptor),
                    allowSceneObjects = true,
                    value = option.avatar
                };
                avatarField.AddToClassList("flex-shrink-1");
                avatarField.AddToClassList("flex-6");
                avatarField.RegisterValueChangedCallback(evt =>
                {
                    var index = config.IndexOf(option);
                    if (index == -1) return;
                    config[index] = new PerPlatformOverrides.Option
                    {
                        avatar = evt.newValue as VRC_AvatarDescriptor,
                        platform = config[index].platform
                    };
                    PerPlatformOverrides.SetPlatformOverrides(_targetAvatar, config);
                    OnPerPlatformOverridesChanged?.Invoke(this, config);
                    // Rebuild the list
                    CreatePerPlatformConfig(_targetAvatar);
                });
                row.Add(avatarField);

                var removeButton = new Button(() =>
                {
                    config.Remove(option);
                    if (config.Count == 0)
                    {
                        PerPlatformOverrides.ClearPlatformOverrides(_targetAvatar);
                    }
                    else
                    {
                        PerPlatformOverrides.SetPlatformOverrides(_targetAvatar, config);
                    }
                    OnPerPlatformOverridesChanged?.Invoke(this, config);
                    // Rebuild the list
                    CreatePerPlatformConfig(_targetAvatar);
                })
                {
                    text = "-"
                };
                
                row.Add(removeButton);
                
                _perPlatformConfigContainer.Add(row);
            }
            
            // Only allow one override per platform
            _perPlatformConfigAddButton.EnableInClassList("d-none", config.Select(o => o.platform).Intersect(platformOptions).Count() == platformOptions.Count());
        }

        private void AddPerPlatformConfigEntry()
        {
            if (_targetAvatar == null) return;
            var config = PerPlatformOverrides.GetPlatformOverrides(_targetAvatar) ?? new List<PerPlatformOverrides.Option>();

            var platformOptions = VRC_EditorTools.GetBuildTargetOptionsAsEnum();
            var currentPlatform = VRC_EditorTools.GetCurrentBuildTargetEnum();
            var newOption = new PerPlatformOverrides.Option
            {
                avatar = null,
                platform = currentPlatform
            };
            // attempt to pick a different platform if the current one is already in use
            if (config.Any(o => o.platform == newOption.platform))
            {
                foreach (var t in platformOptions)
                {
                    if (config.Any(o => o.platform == t)) continue;
                    newOption.platform = t;
                    break;
                }
            }
            
            config.Add(newOption);
            PerPlatformOverrides.SetPlatformOverrides(_targetAvatar, config);
            OnPerPlatformOverridesChanged?.Invoke(this, config);
            // Rebuild the list
            CreatePerPlatformConfig(_targetAvatar);
        }
    }
}