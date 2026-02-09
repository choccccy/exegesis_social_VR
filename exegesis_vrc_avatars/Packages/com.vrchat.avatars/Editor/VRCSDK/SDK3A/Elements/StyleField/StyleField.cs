using System;
using System.Collections.Generic;
using UnityEditor.UIElements;
using UnityEngine.UIElements;
using System.Threading.Tasks;
using Cysharp.Threading.Tasks;
using JetBrains.Annotations;
using VRC.SDKBase.Editor.Api;

[assembly: UxmlNamespacePrefix("VRC.SDK3A.Editor.Elements", "vrca")]
namespace VRC.SDK3A.Editor.Elements
{
    public sealed class StyleField: PopupField<string>
    {
        public new class UxmlFactory : UxmlFactory<StyleField, UxmlTraits> {}

        public new class UxmlTraits : VisualElement.UxmlTraits
        {
            public override IEnumerable<UxmlChildElementDescription> uxmlChildElementsDescription
            {
                get { yield break; }
            }
        }

        private bool _stylesLoaded;
        private string _deferredValue;
        private Dictionary<string, string> _styleMap;
        
        public const string NOT_SPECIFIED = "Not Specified";
        
        public StyleField()
        {
            choices = new List<string>
            {
                null,
            };
            this.value = null;
            
            this.formatListItemCallback += entry => string.IsNullOrEmpty(entry) ? NOT_SPECIFIED : entry;
            this.formatSelectedValueCallback += entry => string.IsNullOrEmpty(entry) ? NOT_SPECIFIED : entry;
            
            // Avoid locking the UI thread
            Task.Run(async () =>
            {
                // Perform the calls on the main thread due to Unity's API restrictions
                await UniTask.SwitchToMainThread();
                var styles = await VRCApi.GetAvatarStyles();
                _styleMap = new Dictionary<string, string>();
                
                foreach (var s in styles)
                {
                    _styleMap.Add(s.StyleName, s.ID);
                    
                    if (choices.Contains(s.StyleName)) continue;
                    choices.Add(s.StyleName);
                }
                
                // Set the saved value after options are loaded
                if (string.IsNullOrWhiteSpace(_deferredValue)) return;
                if (choices.Contains(_deferredValue))
                {
                    value = _deferredValue;
                }
            }).ConfigureAwait(false);
        }

        /// <summary>
        /// Sets the value of the field. Use this method over modifying the `value` property directly.
        /// This is required to allow the field to be set to a value that is not in the list of choices while they're being fetched from the API
        /// </summary>
        /// <param name="value"></param>
        [PublicAPI]
        public void SetValue(string newValue)
        {
            if (_stylesLoaded)
            {
                value = newValue;
                return;
            }
            
            if (!choices.Contains(newValue))
            {
                _deferredValue = newValue;
                return;
            }

            value = newValue;
        }

        /// <summary>
        /// Gets the ID of the style with the given name.
        /// </summary>
        /// <param name="styleName"></param>
        /// <returns></returns>
        [PublicAPI]
        public string GetStyleId(string styleName)
        {
            if (string.IsNullOrWhiteSpace(styleName)) return null;
            if (_styleMap == null) return null;
            if (!_styleMap.TryGetValue(styleName, out var styleId)) return null;
            return styleId;
        }

        /// <summary>
        /// Gets the name of the style for a given ID
        /// </summary>
        /// <param name="styleId"></param>
        /// <returns></returns>
        [PublicAPI]
        public string GetStyleName(string styleId)
        {
            if (string.IsNullOrWhiteSpace(styleId)) return null;
            if (_styleMap == null) return null;
            foreach (var styleEntry in _styleMap)
            {
                if (styleEntry.Value == styleId) return styleEntry.Key;
            }

            return null;
        }
    }
}