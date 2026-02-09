using UnityEditor;
using UnityEngine;
using UnityEngine.UIElements;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3A.Editor.Elements;

namespace VRC.SDK3A.Editor
{
    [CustomEditor(typeof(VRCPerPlatformOverrides))]
    internal class PerPlatformOverridesEditor : UnityEditor.Editor
    {
        public override VisualElement CreateInspectorGUI()
        {
            var root = new VisualElement();
            root.styleSheets.Add(Resources.Load<StyleSheet>("VRCSdkPanelStyles"));
            root.AddToClassList("col");
            root.AddToClassList("mt-2");

            var t = (VRCPerPlatformOverrides) target;
            
            var overridesElement = new PerPlatformOverridesElement(t.gameObject);
            overridesElement.OnPerPlatformOverridesChanged += (_, _) =>
            {
                if (VRCSdkControlPanel.window == null) return;
                if (!VRCSdkControlPanel.TryGetBuilder<IVRCSdkAvatarBuilderApi>(out var builder)) return;
                if (builder.SelectedAvatar != t.gameObject) return;
                // Ensure that all of panel's data is in sync
                builder.SelectAvatar(t.gameObject);
            };
            
            VRCSdkControlPanel.OnUserPlatformsFetched += (_, _) =>
            {
                overridesElement.CreatePerPlatformConfig(t.gameObject);
            };
            root.Add(overridesElement);

            return root;
        }
    }
}