using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using static Pumkin.VrcSdkPatches.PumkinPatcherLogger;

namespace Pumkin.VrcSdkPatches
{
    [Serializable]
    public class PumkinPatcherSettingsWindow : EditorWindow
    {
        const string PackageJsonGuid = "8021f47c8e48e414c8afc59ee31cc8c5";
        
        [Serializable] class VersionWrapper { public string version; }

        [MenuItem("Tools/Pumkin/VRC SDK Patches")]
        public static void ShowWindow()
        {
            var window = GetWindow<PumkinPatcherSettingsWindow>("Patcher Settings");
            window.Show();
        }
        
        void OnDestroy()
        {
            SaveSettings();
        }

        void CreateGUI()
        {
            EditorApplication.quitting -= SaveSettings;
            EditorApplication.quitting += SaveSettings;
            
            PumkinPatcherSettings.LoadSettings();
            
            var tree = Resources.Load<VisualTreeAsset>("Pumkin/UI/PumkinPatcherSettingsWindow");
            tree.CloneTree(rootVisualElement);
            
            rootVisualElement.Q<Label>("version").text = $"v{GetPackageVersion()}";
            var anonymizeNames = rootVisualElement.Q<Toggle>("anonymizeAvatarThumbnailNames");
            anonymizeNames.SetValueWithoutNotify(PumkinPatcherSettings.AnonymizeAvatarThumbnailNames);
            anonymizeNames.RegisterValueChangedCallback(evt => PumkinPatcherSettings.AnonymizeAvatarThumbnailNames = evt.newValue);
            
            var names = rootVisualElement.Q<ListView>("replacementNames");
            names.itemsSource = PumkinPatcherSettings.ReplacementNames;
            names.makeItem = () => new TextField() { isDelayed = true };

            names.bindItem = (ve, index) =>
            {
                var textField = ve as TextField;
                textField.SetValueWithoutNotify(PumkinPatcherSettings.ReplacementNames[index]);
                textField.RegisterValueChangedCallback(evt =>
                {
                    PumkinPatcherSettings.ReplacementNames[index] = StringSanitizer.RemoveInvalidFilenameChars(evt.newValue);
                });
            };
            names.unbindItem = (ve, index) =>
            {
                ((TextField)ve).UnregisterValueChangedCallback(evt => PumkinPatcherSettings.ReplacementNames[index] = StringSanitizer.RemoveInvalidFilenameChars(evt.newValue));
            };
        }

        void SaveSettings()
        {
            PumkinPatcherSettings.SaveSettings();
        }

        Version GetPackageVersion()
        {
            string path = AssetDatabase.GUIDToAssetPath(PackageJsonGuid);
            if(string.IsNullOrEmpty(path))
            {
                LogError("Couldn't find package.json. Did the guid change? Ask Pumkin!");
                return new Version(0, 0, 0);
            }
                
            var text = AssetDatabase.LoadAssetAtPath<TextAsset>(path);
            if(text == null || string.IsNullOrWhiteSpace(text.text))
            {
                LogError("Couldn't load package.json for version. Are the contents valid json?");
                return new Version(0, 0, 0);
            }

            VersionWrapper wrapper = new VersionWrapper();
            JsonUtility.FromJsonOverwrite(text.text, wrapper);
            
            if(wrapper == null || string.IsNullOrWhiteSpace(wrapper.version))
            {
                LogError("Couldn't get version form package.json. What the heck happened here?");
                return new Version(0, 0, 0);
            }
            return new Version(wrapper.version);
        }
    }
}
