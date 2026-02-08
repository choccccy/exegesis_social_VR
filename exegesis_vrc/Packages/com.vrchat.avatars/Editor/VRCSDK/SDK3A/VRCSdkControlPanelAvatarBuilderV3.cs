using UnityEditor;
using VRC.Editor;
using VRC.SDK3A.Editor;
using VRC.SDKBase.Editor;
using VRC.SDKBase.Editor.BuildPipeline;
using VRC.SDKBase.Editor.V3;

[assembly: VRCSdkControlPanelBuilder(typeof(VRCSdkControlPanelAvatarBuilderV3))]
namespace VRC.SDK3A.Editor
{
    public class VRCSdkControlPanelAvatarBuilderV3 : VRCSdkControlPanelAvatarBuilder
    {
        public override void SetupExtraPanelUI()
        {
            V3SdkUI.SetupV3UI(() => _builder.NoGuiErrorsOrIssues(), () =>
                {
                    bool buildBlocked = !VRCBuildPipelineCallbacks.OnVRCSDKBuildRequested(VRCSDKRequestedBuildType.Avatar);
                    if (!buildBlocked)
                    {
                        if (Core.APIUser.CurrentUser.canPublishAvatars)
                        {
                            EnvConfig.FogSettings originalFogSettings = EnvConfig.GetFogSettings();
                            EnvConfig.SetFogSettings(
                                new EnvConfig.FogSettings(EnvConfig.FogSettings.FogStrippingMode.Custom, true, true, true));

#if UNITY_ANDROID || UNITY_IOS
                            EditorPrefs.SetBool("VRC.SDKBase_StripAllShaders", true);
#else
                            EditorPrefs.SetBool("VRC.SDKBase_StripAllShaders", false);
#endif
                            
                            VRC_SdkBuilder.shouldBuildUnityPackage = false;
                            VRC_SdkBuilder.ExportAvatarToV3(_selectedAvatar.gameObject);

                            EnvConfig.SetFogSettings(originalFogSettings);
                        }
                        else
                        {
                            VRCSdkControlPanel.ShowContentPublishPermissionsDialog();
                        }
                    }
                }, 
                _v3Block);
        }
        
        public override bool IsValidBuilder(out string message)
        {
            if (!VRC.SDKBase.Editor.V3.V3SdkUI.V3Enabled())
            {
                message = "SDK V3 pipeline is not enabled.";
                return false;
            }
            FindAvatars();
            message = null;
            if (_avatars != null && _avatars.Length > 0) return true;
            message = "A VRCSceneDescriptor or VRCAvatarDescriptor\nis required to build VRChat SDK Content";
            return false;
        }
    }
}