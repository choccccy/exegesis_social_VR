
using System;
using System.Collections.Generic;
using Unity.Properties;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using VRC.SDK3.Avatars.ScriptableObjects;


namespace VRC.SDK3A.Editor.Elements
{
    public class ExpressionsControlParameterField : VisualElement
    {
        
        public new class UxmlFactory : UxmlFactory<ExpressionsControlParameterField, UxmlTraits>
        {
        }

        public new class UxmlTraits : VisualElement.UxmlTraits
        {
            public UxmlStringAttributeDescription label = new() { name = "label" };
            public UxmlBoolAttributeDescription disallowBool = new() { name = "disallowBool" };

            public override IEnumerable<UxmlChildElementDescription> uxmlChildElementsDescription
            {
                get { yield break; }
            }

            public override void Init(VisualElement element, IUxmlAttributes bag, CreationContext cc)
            {
                base.Init(element, bag, cc);
                ExpressionsControlParameterField parameterField = (ExpressionsControlParameterField)element;

                Label nameLabel = parameterField.Q<Label>();
                string labelText = label.GetValueFromBag(bag, cc);

                bool bagDisallowBool = disallowBool.GetValueFromBag(bag, cc);
                parameterField.DisallowBool = bagDisallowBool;
                
                parameterField.BoolHelpBoxContainer.style.display =
                    bagDisallowBool ? DisplayStyle.Flex : DisplayStyle.None;
                
                if (string.IsNullOrEmpty(labelText))
                {
                    nameLabel.style.display = DisplayStyle.None;
                }
                else
                {
                    nameLabel.style.display = DisplayStyle.Flex;
                    nameLabel.text = labelText;
                }
            }
        }
        
        
        public int Index;

        public VRCExpressionParameters.Parameter Parameter
        {
            get
            {
                if (parametersObject != null && 
                    parametersObject.parameters != null &&
                    parametersObject.parameters.Length != 0)
                {
                    return parametersObject.parameters[Mathf.Max(Index - 1, 0)];
                }
                return null;
            }
        }

        public event Action changed;

        private List<string> dropdownValues = new List<string>();
        private List<string> rawValues = new List<string>();
        private VRCExpressionParameters parametersObject;

        [CreateProperty]
        public bool DisallowBool { get; set; }

        private readonly VisualElement BoolHelpBoxContainer;
        private readonly DropdownField dropdown;
        private readonly TextField textField;
        private readonly HelpBox invalidParameterHelpBox;
        private readonly HelpBox invalidBoolHelpBox;

        private const string VARIABLE_NONE = "[None]";


        public ExpressionsControlParameterField(string label) : this()
        {
            Label nameLabel = this.Q<Label>();
            nameLabel.style.display = DisplayStyle.Flex;
            nameLabel.text = label;
        }

        public ExpressionsControlParameterField()
        {
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCExpressionsControlParameter");
            uxml.CloneTree(this);
            
            dropdown = this.Q<DropdownField>();
            textField = this.Q<TextField>();

            invalidParameterHelpBox = new HelpBox
            {
                messageType = HelpBoxMessageType.Error,
                text = "This parameter does not exist on the current parameter list.",
                style = { display = DisplayStyle.None }
            };
            
            this.Add(invalidParameterHelpBox);

            BoolHelpBoxContainer = this.Q<VisualElement>("BoolHelpBoxContainer");
            invalidBoolHelpBox = new HelpBox
            {
                messageType = HelpBoxMessageType.Error,
                text = "[Bool] is not a valid parameter type for this control.",
                style = { display = DisplayStyle.None }
            };
            BoolHelpBoxContainer.Add(invalidBoolHelpBox);

            dropdown.RegisterValueChangedCallback(DropdownChanged);
            textField.RegisterValueChangedCallback(TextFieldChanged);

            CheckBoolValidation();
        }

        private void DropdownChanged(ChangeEvent<string> evt)
        {
            int index = 0;
            if (dropdownValues.Contains(evt.newValue))
            {
                index = dropdownValues.IndexOf(evt.newValue);
            }

            textField.value = rawValues[index];
            Index = index;

            if (!DisallowBool) CheckBoolValidation();
            CheckParameterValidation();
        }

        private void TextFieldChanged(ChangeEvent<string> evt)
        {
            int index = 0;
            if (rawValues.Contains(evt.newValue))
            {
                index = rawValues.IndexOf(evt.newValue);
            }

            dropdown.SetValueWithoutNotify(dropdownValues[index]);
            Index = index;

            if (!DisallowBool) CheckBoolValidation();
            CheckParameterValidation();
            changed?.Invoke();
        }
        
        public void BindParameter(SerializedProperty property, VRCExpressionParameters parameters, bool validBool = true)
        {
            DisallowBool = validBool;
            SetChoices(parameters);
            textField.BindProperty(property);
        }

        public void SetChoices(VRCExpressionParameters parameters)
        {
            dropdownValues = new List<string>() { VARIABLE_NONE };
            rawValues = new List<string>() { string.Empty };
            parametersObject = parameters;

            if (parameters && parameters.parameters != null)
            {
                foreach (VRCExpressionParameters.Parameter parameter in parameters.parameters)
                {
                    dropdownValues.Add($"{parameter.name}, {parameter.valueType}");
                    rawValues.Add(parameter.name);
                }

                dropdown.choices = dropdownValues;
            }
            else
            {
                dropdown.choices = dropdownValues;
                dropdown.SetValueWithoutNotify(VARIABLE_NONE);
            }
            CheckParameterValidation();
        }

        private void CheckParameterValidation()
        {
            DisplayStyle invalidParameterDisplay = DisplayStyle.None;
            if (!rawValues.Contains(textField.value)) invalidParameterDisplay = DisplayStyle.Flex;
            invalidParameterHelpBox.style.display = invalidParameterDisplay;
        }
        
        private void CheckBoolValidation()
        {
            if (Parameter == null) return;
            
            invalidBoolHelpBox.style.display = 
                Parameter.valueType == VRCExpressionParameters.ValueType.Bool
                ? DisplayStyle.Flex : DisplayStyle.None;
        }
    }
}