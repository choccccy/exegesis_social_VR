using System.Collections.Generic;
using System.Linq;
using UnityEditor;

namespace VRC.SDK3A.Editor
{
    public class AvatarBuilderSessionState
    {
        public const string SESSION_STATE_PREFIX = "VRC.SK3A.Editor";
        public const string AVATAR_NAME_KEY = SESSION_STATE_PREFIX + ".Avatar.Name";
        public const string AVATAR_DESC_KEY = SESSION_STATE_PREFIX + ".Avatar.Desc";
        public const string AVATAR_TAGS_KEY = SESSION_STATE_PREFIX + ".Avatar.Tags";
        public const string AVATAR_THUMBPATH_KEY = SESSION_STATE_PREFIX + ".Avatar.ThumbPath";
        public const string AVATAR_RELEASE_STATUS_KEY = SESSION_STATE_PREFIX + ".Avatar.ReleaseStatus";
        public const string AVATAR_SELECTED_PLATFORMS_KEY = SESSION_STATE_PREFIX + ".Avatar.Platforms";
        public const string AVATAR_PRIMARY_STYLE_KEY = SESSION_STATE_PREFIX + ".Avatar.Style.Primary";
        public const string AVATAR_SECONDARY_STYLE_KEY = SESSION_STATE_PREFIX + ".Avatar.Style.Secondary";

        public static string AvatarName
        {
            get => SessionState.GetString(AVATAR_NAME_KEY, "");
            set => SessionState.SetString(AVATAR_NAME_KEY, value);
        }

        public static string AvatarDesc
        {
            get => SessionState.GetString(AVATAR_DESC_KEY, "");
            set => SessionState.SetString(AVATAR_DESC_KEY, value);
        }

        public static string AvatarTags
        {
            get => SessionState.GetString(AVATAR_TAGS_KEY, "");
            set => SessionState.SetString(AVATAR_TAGS_KEY, value);
        }

        public static string AvatarThumbPath
        {
            get => SessionState.GetString(AVATAR_THUMBPATH_KEY, "");
            set => SessionState.SetString(AVATAR_THUMBPATH_KEY, value);
        }

        public static string AvatarReleaseStatus
        {
            get => SessionState.GetString(AVATAR_RELEASE_STATUS_KEY, "private");
            set => SessionState.SetString(AVATAR_RELEASE_STATUS_KEY, value);
        }
        
        public static List<BuildTarget> AvatarPlatforms
        {
            get
            {
                var loaded = SessionState.GetString(AVATAR_SELECTED_PLATFORMS_KEY, string.Empty);
                if (string.IsNullOrWhiteSpace(loaded)) return new List<BuildTarget>();
                return loaded.Split('|').Select(s => (BuildTarget) int.Parse(s)).ToList();
            }
            set
            {
                var serialized = string.Join("|", value.Select(t => ((int) t).ToString()));
                SessionState.SetString(AVATAR_SELECTED_PLATFORMS_KEY, serialized);
            }
        }
        
        public static string AvatarPrimaryStyle
        {
            get => SessionState.GetString(AVATAR_PRIMARY_STYLE_KEY, null);
            set => SessionState.SetString(AVATAR_PRIMARY_STYLE_KEY, value);
        }
        
        public static string AvatarSecondaryStyle
        {
            get => SessionState.GetString(AVATAR_SECONDARY_STYLE_KEY, null);
            set => SessionState.SetString(AVATAR_SECONDARY_STYLE_KEY, value);
        }

        public static void Clear()
        {
            SessionState.EraseString(AVATAR_NAME_KEY);
            SessionState.EraseString(AVATAR_DESC_KEY);
            SessionState.EraseString(AVATAR_TAGS_KEY);
            SessionState.EraseString(AVATAR_THUMBPATH_KEY);
            SessionState.EraseString(AVATAR_RELEASE_STATUS_KEY);
            SessionState.EraseString(AVATAR_PRIMARY_STYLE_KEY);
            SessionState.EraseString(AVATAR_SECONDARY_STYLE_KEY);
        }
    }
}