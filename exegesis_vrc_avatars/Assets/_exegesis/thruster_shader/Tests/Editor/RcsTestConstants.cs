using UnityEditor;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Shared constants for the RCS thruster test suite.
    ///
    /// The animation-contract list is the important part: ncho_fx.controller drives
    /// these six by name from its rcs_* layers, so renaming one silently breaks the
    /// avatar exactly the way docs/project.md warns about. A test pins their existence.
    /// </summary>
    internal static class RcsTestConstants
    {
        public const string ShaderName = "exegesis/RCSThruster";
        public const string ShaderPath = "Assets/_exegesis/thruster_shader/RCSThruster.shader";
        public const string MaterialPath = "Assets/_exegesis/ncho/ncho_tex/thrusters.mat";

        /// <summary>
        /// Driven by name from the rcs_publish and rcs_imu FX layers.
        /// </summary>
        public static readonly string[] AnimationContractProperties =
        {
            "_RCS_Vel",
            "_RCS_VelSmoothed",
            "_RCS_AngVel",
            "_RCS_AngVelSmoothed",
            "_RCS_ImuDeflect",
            "_RCS_Master",
        };

        public static Shader LoadShader()
        {
            var byPath = AssetDatabase.LoadAssetAtPath<Shader>(ShaderPath);
            return byPath != null ? byPath : Shader.Find(ShaderName);
        }

        public static Material LoadMaterial()
        {
            return AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
        }
    }
}
