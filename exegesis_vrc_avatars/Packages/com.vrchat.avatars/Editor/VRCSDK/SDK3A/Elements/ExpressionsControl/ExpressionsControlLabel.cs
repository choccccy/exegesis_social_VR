using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UIElements;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace VRC.SDK3A.Editor.Elements
{
    public class ExpressionsControlLabel : VisualElement
    {
        
        public new class UxmlFactory : UxmlFactory<ExpressionsControlLabel, UxmlTraits> { }
        
        
        public new class UxmlTraits : VisualElement.UxmlTraits
        {
            public UxmlStringAttributeDescription label = new() { name = "label" };

            public override IEnumerable<UxmlChildElementDescription> uxmlChildElementsDescription
            {
                get { yield break; }
            }

            public override void Init(VisualElement element, IUxmlAttributes bag, CreationContext cc)
            {
                base.Init(element, bag, cc);
                ExpressionsControlLabel controlLabel = (ExpressionsControlLabel)element;

                Label nameLabel = controlLabel.Q<Label>();
                string labelText = label.GetValueFromBag(bag, cc);

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

        public readonly Label Label;
        public readonly TextField TextField;
        public readonly ObjectField TextureField;
        

        public ExpressionsControlLabel(string label) : this()
        {
            Label nameLabel = this.Q<Label>();
            nameLabel.style.display = DisplayStyle.Flex;
            nameLabel.text = label;
        }
        
        public ExpressionsControlLabel()
        {
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCExpressionsControlLabel");
            uxml.CloneTree(this);

            Label = this.Q<Label>();
            TextField = this.Q<TextField>();
            TextureField = this.Q<ObjectField>();
        }
        
        
        public void BindProperty(SerializedProperty property)
        {
            TextField.BindProperty(property.FindPropertyRelative(nameof(VRCExpressionsMenu.Control.Label.name)));
            TextureField.BindProperty(property.FindPropertyRelative(nameof(VRCExpressionsMenu.Control.Label.icon)));
        }
        
        public void BindProperty(string label, SerializedProperty property)
        {
            Label.text = label;
            TextField.BindProperty(property.FindPropertyRelative(nameof(VRCExpressionsMenu.Control.Label.name)));
            TextureField.BindProperty(property.FindPropertyRelative(nameof(VRCExpressionsMenu.Control.Label.icon)));
        }
        
        public void BindProperty(SerializedProperty textProperty, SerializedProperty labelProperty)
        {
            TextField.BindProperty(textProperty);
            TextureField.BindProperty(labelProperty);
        }
        
        public void BindProperty(string label, SerializedProperty textProperty, SerializedProperty labelProperty)
        {
            Label.text = label;
            TextField.BindProperty(textProperty);
            TextureField.BindProperty(labelProperty);
        }
    }
}