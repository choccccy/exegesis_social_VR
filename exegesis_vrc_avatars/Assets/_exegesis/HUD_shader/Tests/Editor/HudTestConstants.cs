using UnityEditor;
using UnityEngine;

namespace Exegesis.HudShader.Tests
{
    /// <summary>
    /// Shared constants for the HUD shader test suite: asset paths, the shader's
    /// declared name, and the set of shader properties that are a hard public
    /// contract because VRChat animation clips / the FX controller drive them by
    /// name. Renaming any contract property silently breaks the avatar, so a test
    /// pins their existence.
    /// </summary>
    internal static class HudTestConstants
    {
        public const string ShaderName = "exegesis/HUD";
        public const string ShaderPath = "Assets/_exegesis/HUD_shader/HUD.shader";
        public const string MaterialPath = "Assets/_exegesis/HUD/ncho_HUD.mat";

        /// <summary>
        /// Properties driven by name from .anim clips and ncho_fx.controller.
        /// See the refactor plan / CLAUDE.md — these must NOT be renamed without a
        /// coordinated update across the animation assets.
        /// </summary>
        public static readonly string[] AnimationContractProperties =
        {
            "_PD_HeadTouch",
            "_PD_ChestTouch",
            "_PD_AbdomenTouch",
            "_PD_HipsTouch",
            "_PD_LArmTouch",
            "_PD_RArmTouch",
            "_PD_LLegTouch",
            "_PD_RLegTouch",
            "_StatusBar0Fill",
            "_StatusBar1Fill",
            "_StatusBar2Fill",
            "_Overlay2Enabled",
        };

        public static Shader LoadShader()
        {
            // Prefer the explicit asset path so the test fails loudly if the file
            // moved, then fall back to name resolution.
            var byPath = AssetDatabase.LoadAssetAtPath<Shader>(ShaderPath);
            return byPath != null ? byPath : Shader.Find(ShaderName);
        }

        public static Material LoadMaterial()
        {
            return AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
        }
    }
}
