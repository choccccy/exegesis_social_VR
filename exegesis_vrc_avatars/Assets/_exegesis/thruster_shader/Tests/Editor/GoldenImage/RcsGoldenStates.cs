using System.Collections.Generic;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// The commanded-motion states rendered as golden images.
    ///
    /// The camera sees the +X, +Y and -Z faces of the cube (see RcsRenderHarness), and
    /// the shader's convention is that a face fires when its exhaust points AWAY from
    /// the direction you want to accelerate. So commanding +X acceleration fires the
    /// -X face, which this camera cannot see - that state is expected to be black, and
    /// is the pin that catches a flipped sign.
    ///
    /// Both the tests and the "Capture Baselines" menu item enumerate this list.
    /// </summary>
    internal static class RcsGoldenStates
    {
        public struct State
        {
            public string Name;
            public Dictionary<string, float> Floats;
            public Dictionary<string, Vector4> Vectors;

            /// <summary>
            /// True when the state must render essentially nothing from this camera.
            /// Asserted independently of the baseline, so a sign flip fails loudly even
            /// on a fresh capture where the baseline would just absorb it.
            /// </summary>
            public bool ExpectDark;
        }

        private static Dictionary<string, Vector4> V(params (string, Vector4)[] pairs)
        {
            var d = new Dictionary<string, Vector4>(pairs.Length);
            foreach (var (k, v) in pairs) d[k] = v;
            return d;
        }

        private static Dictionary<string, float> F(params (string, float)[] pairs)
        {
            var d = new Dictionary<string, float>(pairs.Length);
            foreach (var (k, v) in pairs) d[k] = v;
            return d;
        }

        public static readonly State[] All =
        {
            // Master authority off: the single cheapest "is it wired up" pin.
            new State
            {
                Name = "rcs_off",
                Floats = F(("_RCS_Master", 0f)),
                Vectors = V(("_RCS_Vel", new Vector4(1, 0, 0, 0))),
                ExpectDark = true,
            },

            // Sign convention. Commanding +X fires the -X face, away from this camera.
            new State
            {
                Name = "accel_pos_x_hidden_face",
                Vectors = V(("_RCS_Vel", new Vector4(1, 0, 0, 0))),
                ExpectDark = true,
            },

            // ...and commanding -X fires the +X face, which the camera does see.
            new State
            {
                Name = "accel_neg_x",
                Vectors = V(("_RCS_Vel", new Vector4(-1, 0, 0, 0))),
            },
            new State
            {
                Name = "accel_neg_y",
                Vectors = V(("_RCS_Vel", new Vector4(0, -1, 0, 0))),
            },
            new State
            {
                Name = "accel_pos_z",
                Vectors = V(("_RCS_Vel", new Vector4(0, 0, 1, 0))),
            },

            // The heart of "acceleration only": velocity that the lagged copy has caught
            // up with is NOT acceleration, so nothing may fire. If the differentiation
            // ever breaks, this is the state that goes bright.
            new State
            {
                Name = "accel_cancelled_by_lag",
                Vectors = V(
                    ("_RCS_Vel", new Vector4(0, 0, 1, 0)),
                    ("_RCS_VelSmoothed", new Vector4(0, 0, 1, 0))),
                ExpectDark = true,
            },

            // Same command, but with sustain dialled in - the knob that turns the system
            // back into velocity-following if pure-accel reads as broken in headset.
            new State
            {
                Name = "sustain_only",
                Floats = F(("_SustainWeight", 1f)),
                Vectors = V(
                    ("_RCS_Vel", new Vector4(0, 0, 1, 0)),
                    ("_RCS_VelSmoothed", new Vector4(0, 0, 1, 0))),
            },

            // Torque term. Lever arms are the cube corners, so yaw lights half of each
            // side face with a gradient across it - that gradient IS the cross product.
            new State
            {
                Name = "yaw",
                Vectors = V(("_RCS_AngVel", new Vector4(0, 1, 0, 0))),
            },

            // Pitch arrives via the pendulum, the path VRChat gives no parameter for.
            new State
            {
                Name = "imu_pitch",
                Vectors = V(("_RCS_ImuDeflect", new Vector4(0, 0, 1, 0))),
            },

            // Roll, same path, other axis.
            new State
            {
                Name = "imu_roll",
                Vectors = V(("_RCS_ImuDeflect", new Vector4(1, 0, 0, 0))),
            },

            // Moving the centre of mass changes every lever arm at once, which moves
            // where each face's yaw gradient crosses zero. Offset in X and Z, not Y:
            // for a yaw command only torque.y matters, and torque.y of the +/-X faces
            // depends on CoM.z while that of the +/-Z faces depends on CoM.x - a purely
            // vertical offset would cancel out and pin nothing.
            new State
            {
                Name = "com_offset_yaw",
                Vectors = V(
                    ("_CoM", new Vector4(0.6f, 0, 0.6f, 0)),
                    ("_RCS_AngVel", new Vector4(0, 1, 0, 0))),
            },

            // The direction source that real cone geometry needs. A truncated cone's
            // side normals are radial, so SkinnedNormal fires half of every cone at
            // once; the axis comes from the tangent frame instead. Pins that the
            // bitangent path compiles and produces a different, stable result.
            new State
            {
                Name = "dir_bitangent",
                Floats = F(("_ThrustDirSource", 3f)),
                Vectors = V(("_RCS_Vel", new Vector4(-0.6f, -0.5f, 0.7f, 0))),
            },

            // Gating actually silences. The cube has no colour attribute, so it reports
            // vertex colour WHITE and lands in group 2 - not group 0, which is the trap
            // this state exists to remember. Disabling every group must therefore take a
            // state that is otherwise brightly lit (accel_neg_x) fully dark.
            new State
            {
                Name = "group_gated",
                Vectors = V(
                    ("_GroupEnable", Vector4.zero),
                    ("_RCS_Vel", new Vector4(-1, 0, 0, 0))),
                ExpectDark = true,
            },

            // Everything at once: the broad "did the composite change" pin.
            new State
            {
                Name = "all_axes",
                Vectors = V(
                    ("_RCS_Vel", new Vector4(-0.6f, -0.5f, 0.7f, 0)),
                    ("_RCS_AngVel", new Vector4(0, 0.5f, 0, 0)),
                    ("_RCS_ImuDeflect", new Vector4(0.4f, 0, 0.4f, 0))),
            },
        };
    }
}
