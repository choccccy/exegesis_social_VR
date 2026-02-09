
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace VRC.SDK3.Editor
{
    public class ExpressionsControlField : VisualElement
    {

        private readonly Label NameLabel;
        private readonly Label VariableLabel;
        private readonly EnumField TypeField;
        
        
        public ExpressionsControlField()
        {
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCExpressionsControl");
            uxml.CloneTree(this);
            
            NameLabel = this.Q<Label>("NameLabel");
            VariableLabel = this.Q<Label>("VariableLabel");
            TypeField = this.Q<EnumField>("TypeField");
        }
        
        public void BindProperty(SerializedProperty property)
        {
            SerializedProperty propName = property.FindPropertyRelative(nameof(VRCExpressionsMenu.Control.name));
            SerializedProperty propVariable = property.FindPropertyRelative(nameof(VRCExpressionsMenu.Control.parameter))
                .FindPropertyRelative(nameof(VRCExpressionsMenu.Control.parameter.name));
            SerializedProperty propType = property.FindPropertyRelative(nameof(VRCExpressionsMenu.Control.type));

            if (propName.stringValue == null)
            {
                propName.stringValue = "New Control";
                property.serializedObject.ApplyModifiedProperties();
            }
            NameLabel.BindProperty(propName);
            VariableLabel.BindProperty(propVariable);
            TypeField.BindProperty(propType);
        }
    }
}