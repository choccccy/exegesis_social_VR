using HarmonyLib;
using UnityEditor;
using VRC.SDKBase.Editor.Api;
using static Pumkin.VrcSdkPatches.PumkinPatcherLogger;
using static Pumkin.VrcSdkPatches.ReflectionHelpers;

namespace Pumkin.VrcSdkPatches
{
    internal static class PumkinPatcher
    {
        const string HarmonyId = "Pumkin.VrcSdkPatches";

        static Harmony Harmony
        {
            get
            {
                if(_harmony == null)
                    _harmony = new Harmony(HarmonyId);
                return _harmony;
            }
        }
        static Harmony _harmony;
        
        [InitializeOnLoadMethod]
        static void Initialize()
        {
            PumkinPatcherSettings.LoadSettings();
            PumkinPatcher.SetAvatarThumbnailPatchState(PumkinPatcherSettings.AnonymizeAvatarThumbnailNames);
            
            AssemblyReloadEvents.beforeAssemblyReload += () => { Harmony.UnpatchAll(HarmonyId); };
        }

        internal static void SetAvatarThumbnailPatchState(bool enabled)
        {
            if(enabled)
                AvatarThumbnailNamePatch.Patch(Harmony);
            else
                AvatarThumbnailNamePatch.UnPatch(Harmony);
        }
    }
}