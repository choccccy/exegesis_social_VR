using System.Collections.Generic;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using UnityEngine.UIElements.Experimental;
using VRC.SDKBase;
using VRC.SDKBase.Editor.Elements;

[assembly: UxmlNamespacePrefix("VRC.SDK3A.Editor.Elements", "vrca")]
namespace VRC.SDK3A.Editor.Elements
{
    public class AvatarSelector: VisualElement
    {
        public new class UxmlFactory : UxmlFactory<AvatarSelector, UxmlTraits> {}

        public new class UxmlTraits : VisualElement.UxmlTraits
        {
            public override IEnumerable<UxmlChildElementDescription> uxmlChildElementsDescription
            {
                get { yield break; }
            }
        }
        
        public bool PopupEnabled
        {
            get => _popupField.enabledSelf;
            set => _popupField.SetEnabled(value);
        }
        
        private PopupField<VRC_AvatarDescriptor> _popupField;
        private VisualElement _popupInput;
        private EventCallback<ChangeEvent<VRC_AvatarDescriptor>> _changeCallback;
        private readonly VisualElement _popupContainer;
        private readonly Button _optionsButton;
        private readonly PerPlatformOverridesElement _perPlatformOverridesElement;
        
        public VRC_AvatarDescriptor SelectedAvatar => _popupField?.value;

        public AvatarSelector()
        {
            Resources.Load<VisualTreeAsset>("AvatarSelector").CloneTree(this);
            styleSheets.Add(Resources.Load<StyleSheet>("AvatarSelectorStyles"));
            _popupContainer = this.Q("avatar-selector-dropdown");
            _optionsButton = this.Q<Button>("avatar-selector-options");
            var perPlatformConfigModal = this.Q<Modal>("avatar-per-platform-config-modal");
            var perPlatformConfigMarker = this.Q("avatar-options-active-marker");
            _perPlatformOverridesElement = this.Q<PerPlatformOverridesElement>();
            
            _perPlatformOverridesElement.OnPerPlatformOverridesChanged += (_, config) =>
            {
                perPlatformConfigMarker.EnableInClassList("d-none", (config?.Count ?? 0) == 0);
            };
            
            _optionsButton.clicked += () =>
            {
                perPlatformConfigModal.SetAnchor(this.panel.visualTree.Q("content-info-block"));
                _perPlatformOverridesElement.CreatePerPlatformConfig(SelectedAvatar?.gameObject);
                perPlatformConfigModal.Open();
            };

            VRCSdkControlPanel.OnUserPlatformsFetched += (_, _) =>
            {
                _perPlatformOverridesElement.CreatePerPlatformConfig(SelectedAvatar?.gameObject);
            };
            
            CreateField(new List<VRC_AvatarDescriptor>(), 0);
            _perPlatformOverridesElement.CreatePerPlatformConfig(SelectedAvatar?.gameObject);
            PingField();
        }

        private void CreateField(List<VRC_AvatarDescriptor> options, int selectedIndex)
        {
            if (_popupContainer.Contains(_popupField))
            {
                _popupContainer.Remove(_popupField);
            }

            if (options.Count == 0)
            {
                return;
            }
            
            _popupField = new PopupField<VRC_AvatarDescriptor>(
                null,
                options,
                selectedIndex,
                avatar => FormatAvatarName(options, avatar),
                avatar => FormatAvatarName(options, avatar)
            );
            _popupInput = _popupField.Q<VisualElement>(null, "unity-popup-field__input");
            _popupField.name = "avatar-selector-popup";
            _popupField.AddToClassList("flex-grow-1");
            if (_changeCallback != null)
            {
                _popupField.RegisterValueChangedCallback(_changeCallback);
                _popupField.RegisterValueChangedCallback(_ => _perPlatformOverridesElement.CreatePerPlatformConfig(SelectedAvatar?.gameObject));
            }
            _popupContainer.Add(_popupField);
        }
        
        private string FormatAvatarName(List<VRC_AvatarDescriptor> options, VRC_AvatarDescriptor avatar)
        {
            var currIndex = options.FindAll(a => a.name == avatar.name).IndexOf(avatar);
            return currIndex > 0 ? $"{avatar.name} [{currIndex}]" : avatar.name;
        }

        public void SetAvatars(List<VRC_AvatarDescriptor> avatars, int selectedIndex)
        {
            CreateField(avatars, selectedIndex);
            _perPlatformOverridesElement.CreatePerPlatformConfig(SelectedAvatar?.gameObject);
            PingField();
        }

        public void SetAvatarSelection(VRC_AvatarDescriptor avatar)
        {
            _popupField.value = avatar;
            _perPlatformOverridesElement.CreatePerPlatformConfig(SelectedAvatar?.gameObject);
        }
        
        public void RegisterValueChangedCallback(EventCallback<ChangeEvent<VRC_AvatarDescriptor>> callback)
        {
            _changeCallback = callback;
        }

        private void PingField()
        {
            if (_popupField == null) return;
            _popupField.schedule.Execute(() =>
            {
                var baseColor = _popupInput.resolvedStyle.backgroundColor;
                _popupInput.experimental.animation.Start(new StyleValues
                {
                    backgroundColor = new Color(0.3f, 0.71f, 0.37f, 0.53f)
                }, new StyleValues
                {
                    backgroundColor = baseColor
                }, 500);
            }).ExecuteLater(10);
        }
    }
}