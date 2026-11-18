// The expression assets are VRChat SDK types.
#if VRC_SDK_VRCSDK3

using System;
using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;
using VRC.SDK3.Avatars.ScriptableObjects;

namespace Exegesis.Fx
{
    /// <summary>
    /// Writes an avatar's ExpressionsSpec into its expression parameters asset and menu assets.
    ///
    /// Fills the EXISTING assets in place rather than replacing them, so the GUIDs the avatar
    /// descriptors (and ncho's VRCFury prefab) reference never change. A menu the spec names but
    /// that does not exist yet is created.
    ///
    /// Fill(...) is shared with the tests, which fill a throwaway in-memory copy and compare it
    /// with the committed asset: same code path, so a pass means the build would change nothing.
    /// </summary>
    public static class ExpressionsBuilder
    {
        private const string LogPrefix = "[expressions]";

        public static void Build(ExpressionsSpec spec, string avatarName)
        {
            var parameters = LoadOrCreate<VRCExpressionParameters>(spec.ParametersAsset);
            Fill(parameters, spec);
            EditorUtility.SetDirty(parameters);

            // Create every missing menu first, so submenu references resolve when filling.
            var menus = spec.AllMenus().ToList();
            foreach (var m in menus) LoadOrCreate<VRCExpressionsMenu>(m.Path);
            foreach (var m in menus)
            {
                var asset = AssetDatabase.LoadAssetAtPath<VRCExpressionsMenu>(m.Path);
                Fill(asset, m);
                EditorUtility.SetDirty(asset);
            }

            Debug.Log($"{LogPrefix} {avatarName}: wrote {spec.Parameters.Count} expression parameter(s) " +
                      $"and {menus.Count} menu(s).");
        }

        public static void Fill(VRCExpressionParameters asset, ExpressionsSpec spec)
        {
            asset.parameters = spec.Parameters.Select(p => new VRCExpressionParameters.Parameter
            {
                name = p.Name,
                valueType = (VRCExpressionParameters.ValueType)(int)p.Type,
                defaultValue = p.Default,
                saved = p.Saved,
                networkSynced = p.Synced,
            }).ToArray();
        }

        public static void Fill(VRCExpressionsMenu asset, MenuSpec spec)
        {
            asset.Parameters = spec.ParametersAsset == null
                ? null
                : Load<VRCExpressionParameters>(spec.ParametersAsset);

            asset.controls = spec.Controls.Select(c => new VRCExpressionsMenu.Control
            {
                name = c.Name,
                icon = c.Icon == null ? null : Load<Texture2D>(c.Icon),
                type = (VRCExpressionsMenu.Control.ControlType)(int)c.Type,
                parameter = new VRCExpressionsMenu.Control.Parameter { name = c.Parameter },
                value = c.Value,
                style = VRCExpressionsMenu.Control.Style.Style1,
                subMenu = c.SubMenu == null ? null : Load<VRCExpressionsMenu>(c.SubMenu.Path),
                subParameters = c.SubParameters
                    .Select(n => new VRCExpressionsMenu.Control.Parameter { name = n }).ToArray(),
                labels = new VRCExpressionsMenu.Control.Label[0],
            }).ToList();
        }

        private static T Load<T>(string path) where T : UnityEngine.Object
        {
            var asset = AssetDatabase.LoadAssetAtPath<T>(path);
            if (asset == null)
                throw new InvalidOperationException($"{LogPrefix} no {typeof(T).Name} at {path}.");
            return asset;
        }

        private static T LoadOrCreate<T>(string path) where T : ScriptableObject
        {
            var asset = AssetDatabase.LoadAssetAtPath<T>(path);
            if (asset != null) return asset;

            asset = ScriptableObject.CreateInstance<T>();
            AssetDatabase.CreateAsset(asset, path);
            Debug.Log($"{LogPrefix} created {path}.");
            return asset;
        }

        /// <summary>
        /// Problems that need the SDK or another avatar's view: missing icons, every expression
        /// parameter present in the FX controller with a matching type, and shared menus
        /// described identically by every avatar that uses them.
        /// </summary>
        public static IEnumerable<string> Problems(AvatarDefinition avatar, AnimatorController controller)
        {
            var spec = avatar.Expressions;
            foreach (var p in spec.Problems()) yield return p;

            var declared = controller.parameters.ToDictionary(p => p.name, p => p.type);
            AnimatorControllerParameterType? controllerType(string name) =>
                declared.TryGetValue(name, out var t) ? t : (AnimatorControllerParameterType?)null;

            foreach (var icon in spec.AllMenus().SelectMany(m => m.Controls).Select(c => c.Icon)
                         .Where(i => i != null).Distinct())
                if (AssetDatabase.LoadAssetAtPath<Texture2D>(icon) == null)
                    yield return $"menu icon {icon} does not exist.";

            foreach (var p in spec.Parameters)
            {
                var t = controllerType(p.Name);
                if (t == null)
                {
                    yield return $"expression parameter '{p.Name}' is not declared on the FX controller.";
                    continue;
                }
                var expected = p.Type == ExpressionType.Bool ? AnimatorControllerParameterType.Bool
                    : p.Type == ExpressionType.Int ? AnimatorControllerParameterType.Int
                    : AnimatorControllerParameterType.Float;
                if (t != expected)
                    yield return $"expression parameter '{p.Name}' is {p.Type} but the FX controller declares it {t}.";
            }
        }

        /// <summary>Menus that more than one avatar writes must be described identically.</summary>
        public static IEnumerable<string> SharedMenuConflicts(IEnumerable<AvatarDefinition> avatars)
        {
            var byPath = new Dictionary<string, (string Avatar, string Description)>();
            foreach (var a in avatars)
            foreach (var m in a.Expressions.AllMenus())
            {
                var d = m.Describe();
                if (!byPath.TryGetValue(m.Path, out var seen)) byPath[m.Path] = (a.Fx.Name, d);
                else if (seen.Description != d)
                    yield return $"menu {m.Path} is shared by {seen.Avatar} and {a.Fx.Name}, but they define it differently.";
            }
        }
    }
}

#endif
