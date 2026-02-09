using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using HarmonyLib;
using UnityEngine;
using VRC.SDKBase.Editor.Api;
using static Pumkin.VrcSdkPatches.PumkinPatcherLogger;
using static Pumkin.VrcSdkPatches.ReflectionHelpers;

namespace Pumkin.VrcSdkPatches
{
    internal static class AvatarThumbnailNamePatch
    {
        const string DefaultAvatarName = "Avatar";

        static MethodInfo vrcApi_createNewAvatarMethod;
        static MethodInfo vrcApi_updateAvatarImageMethod;
        static HarmonyMethod namePatchTranspilerHarmony;

        static AvatarThumbnailNamePatch()
        {
            vrcApi_createNewAvatarMethod = GetMethodIncludingAsync(typeof(VRCApi), nameof(VRCApi.CreateNewAvatar));
            vrcApi_updateAvatarImageMethod = GetMethodIncludingAsync(typeof(VRCApi), nameof(VRCApi.UpdateAvatarImage));
            var namePatchTranspiler = GetMethodIncludingAsync(typeof(AvatarThumbnailNamePatch), nameof(Transpiler));
            namePatchTranspilerHarmony = new HarmonyMethod(namePatchTranspiler);
        }

        public static void Patch(Harmony harmony)
        {
            Log($"Patching <b>{typeof(VRCApi).Name}:{nameof(VRCApi.CreateNewAvatar)}</b> to hide avatar names in thumbnails.");
            PatchInternal(harmony, vrcApi_createNewAvatarMethod, transpiler: namePatchTranspilerHarmony);
            
            Log($"Patching <b>{typeof(VRCApi).Name}:{nameof(VRCApi.UpdateAvatarImage)}</b> to hide avatar names in thumbnails.");
            PatchInternal(harmony, vrcApi_updateAvatarImageMethod, transpiler: namePatchTranspilerHarmony);
        }

        public static void UnPatch(Harmony harmony)
        {
            Log($"UnPatching <b>{typeof(VRCApi).Name}:{nameof(VRCApi.CreateNewAvatar)}</b> to no longer hide avatar names in thumbnails.");
            UnPatchInternal(harmony, vrcApi_createNewAvatarMethod, transpiler: namePatchTranspilerHarmony);
            
            Log($"UnPatching <b>{typeof(VRCApi).Name}:{nameof(VRCApi.UpdateAvatarImage)}</b> to no longer hide avatar names in thumbnails.");
            UnPatchInternal(harmony, vrcApi_updateAvatarImageMethod, transpiler: namePatchTranspilerHarmony);
        }

        static void PatchInternal(Harmony harmony, MethodBase targetMethod, HarmonyMethod prefix = null, HarmonyMethod postfix = null, HarmonyMethod transpiler = null, HarmonyMethod finalizer = null)
        {
            if(harmony == null || targetMethod == null)
            {
                LogError("Failed. Target method to patch was not found.");
                return;
            }

            harmony.Patch(targetMethod, prefix, postfix, transpiler, finalizer);
        }

        static void UnPatchInternal(Harmony harmony, MethodBase targetMethod, HarmonyMethod prefix = null, HarmonyMethod postfix = null, HarmonyMethod transpiler = null, HarmonyMethod finalizer = null)
        {
            if(harmony == null || targetMethod == null)
            {
                LogError("Failed. Target method to unpatch was not found.");
                return;
            }

            if(prefix != null) harmony.Unpatch(targetMethod, prefix.method);
            if(postfix != null) harmony.Unpatch(targetMethod, postfix.method);
            if(transpiler != null) harmony.Unpatch(targetMethod, transpiler.method);
            if(finalizer != null) harmony.Unpatch(targetMethod, finalizer.method);
        }

        public static string GetNameReplacement()
        {
            PumkinPatcherSettings.LoadSettings();
            var names = PumkinPatcherSettings.ReplacementNames;
            if(names == null || names.Count == 0)
            {
                Log($"Replaced avatar thumbnail name with <b>{DefaultAvatarName}</b>.");
                return DefaultAvatarName;
            }

            string newName = names[UnityEngine.Random.Range(0, names.Count)];
            Log($"Replaced avatar thumbnail name with <b>{newName}</b>.");
            return newName;
        }

        static IEnumerable<CodeInstruction> Transpiler(IEnumerable<CodeInstruction> instructions)
        {
            var codes = new List<CodeInstruction>(instructions);
            bool foundNewArray  = false;
            bool foundLoadAvatarString = false;
            int getDataIndex = -1;
            int getDataNameIndex = -1;
        
            for (int i = 0; i < codes.Count; i++)
            {
                // Look for new array declaration with size 10
                CodeInstruction inst = codes[i];
                if(inst.opcode == OpCodes.Ldc_I4_S && inst.operand is sbyte arraySize && arraySize == 10)
                {
                    if(i + 1 < codes.Count && codes[i + 1].opcode == OpCodes.Newarr && codes[i + 1].operand is Type stringType && stringType == typeof(string))
                    {
                        foundNewArray = true;
                        i++;
                        continue;
                    }
                }
                if(!foundNewArray) continue;

                // Then find the 'Avatar - ' string
                if(inst.opcode == OpCodes.Ldstr && inst.operand.ToString() == "Avatar - ")
                    foundLoadAvatarString = true;
                if(!foundLoadAvatarString) continue;

                // Then find vrc avatar data calls and store the indices for later.
                if(inst.opcode == OpCodes.Ldflda && codes[i - 1].opcode == OpCodes.Ldarg_0)
                {
                    var opString = inst.operand.ToString();
                    if(opString.Contains("VRC.SDKBase.Editor.Api.VRCAvatar") && opString.Contains("data"))
                    {
                        getDataIndex = i;
                        if(i + 1 < codes.Count)
                        {
                            var nextInst = codes[i + 1];
                            string nextOpString = nextInst.operand.ToString();
                            if(nextInst.opcode == OpCodes.Call && nextOpString.Contains("get_Name"))
                            {
                                getDataNameIndex = i + 1;
                                continue;
                            }
                        }
                    }
                }
                if(getDataIndex == -1 || getDataNameIndex == -1) continue;

                // Finally, if we find the ' - Image - ' string, we know this is the correct array, so patch the vrc data calls from earlier.
                if(inst.opcode == OpCodes.Ldstr && inst.operand.ToString() == " - Image - ")
                {
                    codes[getDataIndex - 1] = new CodeInstruction(OpCodes.Nop);
                    codes[getDataIndex] = new CodeInstruction(OpCodes.Nop);
                    codes[getDataNameIndex] = new CodeInstruction(OpCodes.Call, typeof(AvatarThumbnailNamePatch).GetMethod(nameof(GetNameReplacement)));
                    return codes.AsEnumerable();
                }
            }
            
            LogError("Failed. Could not find location in code to patch.");
            return codes.AsEnumerable();
        }
    }
}