using System;
using UnityEngine;
using UnityEngine.UIElements;

namespace VRC.SDK3A.Editor.Elements
{
    public class AvatarUploadSuccessNotification: VisualElement
    {
        public AvatarUploadSuccessNotification(string id, string text = null, string buttonText = null,
            string buttonUrl = null, Action buttonAction = null)
        {
            Resources.Load<VisualTreeAsset>("AvatarUploadSuccessNotification").CloneTree(this);
            styleSheets.Add(Resources.Load<StyleSheet>("AvatarUploadSuccessNotificationStyles"));
            var notificationText = this.Q<Label>("notification-text");
            var notificationButton = this.Q<Button>("notification-button");

            if (!string.IsNullOrWhiteSpace(text))
            {
                notificationText.text = text;
            }

            if (!string.IsNullOrWhiteSpace(buttonText))
            {
                notificationButton.text = buttonText;
            }

            if (buttonAction != null)
            {
                notificationButton.clicked += buttonAction;
            }
            else
            {
                notificationButton.clicked += () =>
                {
                    Application.OpenURL(buttonUrl ?? $"https://vrchat.com/home/avatar/{id}");
                };
            }
        }
    }
}