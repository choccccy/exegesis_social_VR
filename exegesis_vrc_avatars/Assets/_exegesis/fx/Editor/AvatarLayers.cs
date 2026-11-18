using System.Collections.Generic;
using System.Linq;
using AnimatorAsCode.V1;
#if VRC_SDK_VRCSDK3
using AnimatorAsCode.V1.VRC;
#endif
using Exegesis.Aac;
using Exegesis.Shared;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Fx
{
    /// <summary>
    /// Builds an avatar's layers, as its AvatarDefinition lists them, into its FX controller
    /// with Animator As Code. FxBuilder calls this on a controller it has just emptied, so each
    /// layer is appended and they land in exactly the order listed.
    /// </summary>
    public static class AvatarLayers
    {
        private const string LogPrefix = "[avatar]";

        /// <summary>
        /// Appends every layer. Assumes the definition has been validated
        /// (AvatarDefinition.Problems) and the controller emptied - FxBuilder does both.
        /// </summary>
        public static void Build(AnimatorController controller, AvatarDefinition avatar)
        {
            foreach (var spec in avatar.Layers) BuildLayer(controller, spec);

            // AAC's throwaway default-motion clip per layer is unreferenced once every state
            // has its own motion.
            AnimatorAssets.SweepUnreachableSubAssets(controller, LogPrefix);
            EditorUtility.SetDirty(controller);

            Debug.Log($"{LogPrefix} {avatar.Fx.Name}: built {avatar.Layers.Count} layer(s).");
        }

        private static void BuildLayer(AnimatorController controller, LayerSpec spec)
        {
            var aac = ExegesisAac.Create(controller, spec.Name, spec.Name);
            var layer = aac.CreateMainArbitraryControllerLayer(controller);
            if (spec.Weight != 1f) layer.WithWeight(spec.Weight);

            var states = new Dictionary<string, AacFlState>();
            foreach (var s in spec.States)
            {
                var clip = AssetDatabase.LoadAssetAtPath<AnimationClip>(s.ClipPath);
                var state = layer.NewState(s.Name).WithAnimation(clip);

                if (s.Speed != 1f) state.WithSpeedSetTo(s.Speed);
                if (s.MotionTime != null) state.WithMotionTime(layer.FloatParameter(s.MotionTime));
                if (s.Mirror) state.State.mirror = true;
                if (s.Driver != null) AddDriver(state, s.Driver, spec.Name);

                states[s.Name] = state;
            }

            foreach (var t in spec.Transitions)
            {
                var transition = t.To == null
                    ? states[t.From].Exits()
                    : states[t.From].TransitionsTo(states[t.To]);

                // Set directly rather than through AAC's helpers so every field is stated,
                // including the ones that only matter for matching the original exactly
                // (exitTime with no exit time, for one).
                var raw = (AnimatorStateTransition)transition.Transition;
                raw.duration = t.Duration;
                raw.offset = 0f;
                raw.hasExitTime = t.HasExitTime;
                raw.exitTime = t.ExitTime;
                raw.hasFixedDuration = t.FixedDuration;

                AacFlTransitionContinuation chain = null;
                foreach (var c in t.Conditions)
                {
                    var condition = ToAac(layer, c);
                    chain = chain == null ? transition.When(condition) : chain.And(condition);
                }
            }

            if (spec.DefaultState != null)
                layer.StateMachine.WithDefaultState(states[spec.DefaultState]);
        }

        /// <summary>
        /// Every field of every driven parameter is written out, not left to the SDK's defaults.
        /// The SDK defaults valueMax and chance to 1; the hand-built drivers have 0. Neither
        /// field is read by Set or Add, so it makes no difference in game, but it does in the
        /// snapshot, and a port is proven by an empty snapshot diff.
        /// </summary>
        private static void AddDriver(AacFlState state, DriverSpec spec, string layerName)
        {
#if VRC_SDK_VRCSDK3
            state.Driving(d =>
            {
                d.Driver.localOnly = spec.LocalOnly;
                d.Driver.debugString = "";
                foreach (var drive in spec.Drives)
                {
                    d.Driver.parameters.Add(new VRC.SDKBase.VRC_AvatarParameterDriver.Parameter
                    {
                        type = drive.Op == DriveOp.Set
                            ? VRC.SDKBase.VRC_AvatarParameterDriver.ChangeType.Set
                            : VRC.SDKBase.VRC_AvatarParameterDriver.ChangeType.Add,
                        name = drive.Param,
                        source = "",
                        value = drive.Value,
                        valueMin = 0f,
                        valueMax = 0f,
                        chance = 0f,
                        preventRepeats = false,
                        convertRange = false,
                        sourceMin = 0f,
                        sourceMax = 0f,
                        destMin = 0f,
                        destMax = 0f,
                    });
                }
            });
#else
            throw new System.InvalidOperationException(
                $"Layer '{layerName}' has a parameter driver, which needs the VRChat SDK.");
#endif
        }

        private static IAacFlCondition ToAac(AacFlLayer layer, Cond c)
        {
            switch (c.Kind)
            {
                case ParamKind.Bool:
                    var b = layer.BoolParameter(c.Param);
                    return c.Mode == AnimatorConditionMode.If ? b.IsTrue() : b.IsFalse();

                case ParamKind.Int:
                    var i = layer.IntParameter(c.Param);
                    int v = (int)c.Threshold;
                    switch (c.Mode)
                    {
                        case AnimatorConditionMode.Equals: return i.IsEqualTo(v);
                        case AnimatorConditionMode.NotEqual: return i.IsNotEqualTo(v);
                        case AnimatorConditionMode.Greater: return i.IsGreaterThan(v);
                        default: return i.IsLessThan(v);
                    }

                default:
                    var f = layer.FloatParameter(c.Param);
                    return c.Mode == AnimatorConditionMode.Greater
                        ? f.IsGreaterThan(c.Threshold)
                        : f.IsLessThan(c.Threshold);
            }
        }
    }
}
