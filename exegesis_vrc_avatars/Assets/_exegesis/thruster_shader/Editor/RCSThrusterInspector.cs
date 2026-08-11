using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Exegesis.RcsThruster
{
    /// <summary>
    /// ShaderGUI for Shader "exegesis/RCSThruster".
    ///
    /// Lives in its own assembly definition on purpose: per docs/testing.md, a test
    /// asmdef cannot reference the predefined Assembly-CSharp-Editor, so anything a
    /// test might ever need to touch has to sit in a real assembly.
    ///
    /// The grouping here follows the order you actually tune things in-headset
    /// (see the tuning order in docs/rcs-thrusters.md), not the order the properties
    /// happen to be declared in.
    /// </summary>
    public class RCSThrusterInspector : ShaderGUI
    {
        private static readonly string[] EmissionProps =
        {
            "_CoreMask", "_GlowMask", "_CoreColor", "_GlowColor",
            "_CoreThreshold", "_GlowGamma",
        };

        private static readonly string[] AllocationProps =
        {
            "_CoM", "_AccelGain", "_AngAccelGain", "_AccelTimeCorrect", "_SustainWeight",
            "_RotThrusterLinGain", "_TransThrusterRotGain",
            "_Deadzone", "_Sharpness", "_MinThrottle",
        };

        private static readonly string[] ImuProps =
        {
            "_ImuHeight", "_ImuGain", "_ImuLinearReject", "_ImuClamp",
        };

        private static readonly string[] FlickerProps =
        {
            "_FlickerAmp", "_FlickerSpeed",
        };

        private static readonly string[] EscapeHatchProps =
        {
            "_VelSpace", "_ThrustDirSource", "_ThrustDirFlip", "_CapNormalFlip", "_BellFlare", "_BellFlareProps",
            "_Cull", "_GroupEnable", "_GroupGateEnabled", "_DebugView",
        };

        // Written every frame by the FX layers. Shown read-only-ish at the bottom so
        // you can watch them move in play mode, but they are not hand-tuned.
        private static readonly string[] CommandProps =
        {
            "_RCS_Vel", "_RCS_VelSmoothed", "_RCS_AngVel", "_RCS_AngVelSmoothed",
            "_RCS_ImuDeflect", "_RCS_Master",
        };

        private bool _showEmission = true;
        private bool _showAllocation = true;
        private bool _showImu = true;
        private bool _showFlicker;
        private bool _showEscapeHatches;
        private bool _showCommand;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
        {
            var lookup = new Dictionary<string, MaterialProperty>(properties.Length);
            foreach (var p in properties) lookup[p.name] = p;

            Section(ref _showEmission, "Emission layers", materialEditor, lookup, EmissionProps);
            Section(ref _showAllocation, "Allocation", materialEditor, lookup, AllocationProps,
                "Center of mass is in the renderer's object space. Thrusters far from it " +
                "answer strongly to rotation and weakly to translation.");
            Section(ref _showImu, "Pendulum IMU (pitch and roll)", materialEditor, lookup, ImuProps,
                "Tune IMU Gain first with Linear Rejection at 0 until a deliberate lean reads " +
                "full scale, THEN raise Linear Rejection until walking straight stops producing roll.");
            Section(ref _showFlicker, "Flicker", materialEditor, lookup, FlickerProps);
            Section(ref _showEscapeHatches, "Escape hatches", materialEditor, lookup, EscapeHatchProps,
                "Velocity Space: flip to World if VelocityX/Y/Z turn out not to be player-local. " +
                "Thrust Direction Source: vertex colour override for painted thrusters whose " +
                "surface normal does not face the exhaust.");
            Section(ref _showCommand, "Live command (animator driven)", materialEditor, lookup, CommandProps,
                "The FX layers overwrite these every frame. Editing them here is only useful " +
                "for previewing outside play mode.");

            EditorGUILayout.Space();
            materialEditor.RenderQueueField();
            materialEditor.DoubleSidedGIField();
            materialEditor.EnableInstancingField();
        }

        private static void Section(ref bool expanded, string title, MaterialEditor editor,
                                    IDictionary<string, MaterialProperty> lookup,
                                    IEnumerable<string> propertyNames, string help = null)
        {
            expanded = EditorGUILayout.BeginFoldoutHeaderGroup(expanded, title);
            if (expanded)
            {
                EditorGUI.indentLevel++;
                if (!string.IsNullOrEmpty(help))
                    EditorGUILayout.HelpBox(help, MessageType.None);

                foreach (var name in propertyNames)
                {
                    if (!lookup.TryGetValue(name, out var prop)) continue;
                    editor.ShaderProperty(prop, prop.displayName);
                }
                EditorGUI.indentLevel--;
            }
            EditorGUILayout.EndFoldoutHeaderGroup();
        }
    }
}
