
using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using Object = UnityEngine.Object;


namespace VRC.SDK3A.Editor.Elements
{
    public class VRCCreateObjectField : VisualElement
    {
        
        public new class UxmlFactory : UxmlFactory<VRCCreateObjectField, UxmlTraits> { }
        
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
                VRCCreateObjectField createObjectField = (VRCCreateObjectField)element;

                Label nameLabel = createObjectField.Q<Label>();
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

        public event Action changed;

        public UnityEngine.Object Value => TargetObjectField.value;
        
        private readonly ObjectField TargetObjectField;
        private readonly Button ObjectCreateButton;
        private readonly Button ObjectOpenButton;
        
        private SerializedProperty propObject;
        private Object target;
        private System.Type objectType;
        private string newObjectName;
        
        
        public VRCCreateObjectField(string label) : this()
        {
            Label nameLabel = this.Q<Label>();
            nameLabel.style.display = DisplayStyle.Flex;
            nameLabel.text = label;
        }
        
        public VRCCreateObjectField()
        {
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCCreateObjectField");
            uxml.CloneTree(this);

            TargetObjectField = this.Q<ObjectField>("TargetObjectField");
            TargetObjectField.RegisterValueChangedCallback(evt =>
            {
                changed?.Invoke();
                RefreshButtons();
            });
            
            ObjectCreateButton = this.Q<Button>("ObjectCreateButton");
            ObjectCreateButton.clicked += ObjectCreateButtonClicked;
            
            ObjectOpenButton = this.Q<Button>("ObjectOpenButton");
            ObjectOpenButton.clicked += ObjectOpenButtonClicked;
            
        }

        private void RefreshButtons()
        {
            if (propObject != null && propObject.objectReferenceValue != null)
            {
                ObjectCreateButton.style.display = DisplayStyle.None;
                ObjectOpenButton.style.display = DisplayStyle.Flex;
            }
            else
            {
                ObjectCreateButton.style.display = DisplayStyle.Flex;
                ObjectOpenButton.style.display = DisplayStyle.None;
            }
        }
        
        private void ObjectCreateButtonClicked()
        {
            string path = EditorUtility.SaveFilePanel("VRC SDK", Application.dataPath, newObjectName, "asset");
            if (path.Length == 0) return;

            path = path.Replace(Application.dataPath, "");
            path = "Assets" + path;
            
            ScriptableObject newObject = ScriptableObject.CreateInstance(objectType);
            AssetDatabase.CreateAsset(newObject, path);
            AssetDatabase.SaveAssets();
            
            // Saving assets causes serialized object to get disposed, so we re-fetch here
            if (target != null)
            {
                propObject = new SerializedObject(target).FindProperty(propObject.propertyPath);
            }
            propObject.objectReferenceValue = newObject;
            propObject.serializedObject.ApplyModifiedProperties();
            Selection.objects = new Object[] { newObject };
        }
        
        private void ObjectOpenButtonClicked()
        {
            Selection.objects = new[] { propObject.objectReferenceValue };
        }
        
        public void BindProperty(SerializedProperty prop, System.Type type, string objectName = "NewObject")
        {
            propObject = prop;
            target = prop.serializedObject.targetObject;
            objectType = type;
            newObjectName = objectName;

            TargetObjectField.objectType = objectType;
            TargetObjectField.BindProperty(prop);
        }
        
    }
}