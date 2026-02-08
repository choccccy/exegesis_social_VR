using System;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using HarmonyLib;

namespace Pumkin.VrcSdkPatches
{
    internal static class ReflectionHelpers
    {
        public static MethodInfo GetAsyncMethodInfo(Type targetType, string methodName)
        {
            var stateMachineType = targetType.Assembly.GetTypes()
                .FirstOrDefault(t => t.DeclaringType == targetType && t.Name.Contains($"<{methodName}>d__"));

            return stateMachineType?.GetMethod("MoveNext", BindingFlags.Instance | BindingFlags.NonPublic);
        }

        public static MethodInfo GetAsyncMethodInfo(string targetTypeName, string methodName)
        {
            Type type = AccessTools.TypeByName(targetTypeName);
            return GetAsyncMethodInfo(type, methodName);
        }

        public static MethodInfo GetAsyncMethodInfo(string typeColonMethodName)
        {
            string[] strArray = typeColonMethodName.Split(':');
            if (strArray.Length != 2)
                throw new ArgumentException("Method must be specified as 'Namespace.Type1.Type2:MethodName", nameof(typeColonMethodName));
            return GetAsyncMethodInfo(strArray[0], strArray[1]);
        }

        public static MethodInfo GetLocalMethod(Type targetType, string methodName, string innerMethodName)
        {
            string methodPattern = $"<{methodName}>g__{innerMethodName}|";
            return AccessTools.GetDeclaredMethods(targetType)?.FirstOrDefault(m => m.Name.StartsWith(methodPattern));
        }
        
        public static MethodInfo GetMethodIncludingAsync(Type type, string methodName)
        {
            if(!IsAsyncMethod(type, methodName))
                return AccessTools.Method(type, methodName);
            
            var stateMachineType = type.GetNestedTypes(BindingFlags.NonPublic).FirstOrDefault(t => t.Name.Contains(methodName));
            if (stateMachineType != null)
            {
                var moveNextMethod = AccessTools.Method(stateMachineType, "MoveNext");
                return moveNextMethod;
            }

            return null;
        }

        public static MethodInfo GetMethodIncludingAsync(string typeColonMethodName)
        {
            string[] strArray = typeColonMethodName.Split(':');
            if (strArray.Length != 2)
                throw new ArgumentException("Method must be specified as 'Namespace.Type1.Type2:MethodName", nameof(typeColonMethodName));
            return GetMethodIncludingAsync(strArray[0], strArray[1]);
        }

        public static MethodInfo GetMethodIncludingAsync(string typeName, string methodName)
        {
            return GetMethodIncludingAsync(AccessTools.TypeByName(typeName), methodName);
        }

        static bool IsAsyncMethod(Type classType, string methodName)
        {
            // Obtain the method with the specified name.
            MethodInfo method = AccessTools.Method(classType, methodName);

            Type attType = typeof(AsyncStateMachineAttribute);

            // Obtain the custom attribute for the method. 
            // The value returned contains the StateMachineType property. 
            // Null is returned if the attribute isn't present for the method. 
            var attrib = (AsyncStateMachineAttribute)method.GetCustomAttribute(attType);

            return attrib != null;
        }
    }
}