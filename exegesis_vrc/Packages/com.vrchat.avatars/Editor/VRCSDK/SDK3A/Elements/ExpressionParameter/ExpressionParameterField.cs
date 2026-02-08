
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace VRC.SDK3.Editor
{
    public class ExpressionParameterField : VisualElement
    {

        private SerializedProperty property;
        private SerializedProperty propName;
        private SerializedProperty propType;
        private SerializedProperty propValue;
        private SerializedProperty propSaved;
        private SerializedProperty propSynced;

        private readonly TextField NameField;
        private readonly EnumField TypeField;
        private readonly Toggle DefaultBoolField;
        private readonly FloatField DefaultFloatField;
        private readonly IntegerField DefaultIntField;
        private readonly Toggle SavedField;
        private readonly Toggle SyncedField;
        
        
        public ExpressionParameterField()
        {
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCExpressionParameterField");
            uxml.CloneTree(this);

            NameField = this.Q<TextField>("NameField");
            TypeField = this.Q<EnumField>("TypeField");
            DefaultBoolField = this.Q<Toggle>("DefaultBoolField");
            DefaultFloatField = this.Q<FloatField>("DefaultFloatField");
            DefaultIntField = this.Q<IntegerField>("DefaultIntField");
            SavedField = this.Q<Toggle>("SavedField");
            SyncedField = this.Q<Toggle>("SyncedField");

            TypeField.RegisterValueChangedCallback(evt =>
            {
                // Check to see if the property has been disposed/deleted.
                if (evt.newValue == null) return;
                DisplayValueSlider();
                ReadFromFloat();
            });

            DefaultBoolField.RegisterValueChangedCallback(evt =>
            {
                propValue.floatValue = evt.newValue ? 1 : 0;
                property.serializedObject.ApplyModifiedProperties();
                ReadFromFloat();
            });
            DefaultFloatField.RegisterValueChangedCallback(evt =>
            {
                propValue.floatValue = evt.newValue;
                property.serializedObject.ApplyModifiedProperties();
                ReadFromFloat();
            });
            DefaultIntField.RegisterValueChangedCallback(evt =>
            {
                propValue.floatValue = evt.newValue;
                property.serializedObject.ApplyModifiedProperties();
                ReadFromFloat();
            });
        }

        public void BindProperty(SerializedProperty prop)
        {
            property = prop;
            
            propName = property.FindPropertyRelative(nameof(VRCExpressionParameters.Parameter.name));
            propType = property.FindPropertyRelative(nameof(VRCExpressionParameters.Parameter.valueType));
            propValue = property.FindPropertyRelative(nameof(VRCExpressionParameters.Parameter.defaultValue));
            propSaved = property.FindPropertyRelative(nameof(VRCExpressionParameters.Parameter.saved));
            propSynced = property.FindPropertyRelative(nameof(VRCExpressionParameters.Parameter.networkSynced));

            NameField.BindProperty(propName);
            TypeField.BindProperty(propType);
            SavedField.BindProperty(propSaved);
            SyncedField.BindProperty(propSynced);

            ReadFromFloat();
            DisplayValueSlider();
        }
        
        private void ReadFromFloat()
        {
            DefaultBoolField.SetValueWithoutNotify(propValue.floatValue != 0);
            DefaultFloatField.SetValueWithoutNotify(Mathf.Clamp(propValue.floatValue, -1, 1));
            DefaultIntField.SetValueWithoutNotify(Mathf.FloorToInt(Mathf.Clamp(propValue.floatValue, 0, 255)));
        }
        
        private void DisplayValueSlider()
        {
            switch ((VRCExpressionParameters.ValueType)propType.intValue)
            {
                default:
                case VRCExpressionParameters.ValueType.Bool:
                    DefaultBoolField.style.display = DisplayStyle.Flex;
                    DefaultFloatField.style.display = DisplayStyle.None;
                    DefaultIntField.style.display = DisplayStyle.None;
                    break;
                case VRCExpressionParameters.ValueType.Float:
                    DefaultBoolField.style.display = DisplayStyle.None;
                    DefaultFloatField.style.display = DisplayStyle.Flex;
                    DefaultIntField.style.display = DisplayStyle.None;
                    break;
                case VRCExpressionParameters.ValueType.Int:
                    DefaultBoolField.style.display = DisplayStyle.None;
                    DefaultFloatField.style.display = DisplayStyle.None;
                    DefaultIntField.style.display = DisplayStyle.Flex;
                    break;
            }
        }
    }
}