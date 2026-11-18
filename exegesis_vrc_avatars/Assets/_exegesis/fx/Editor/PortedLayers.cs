using System.Collections.Generic;
using System.Linq;
using AnimatorAsCode.V1;
using Exegesis.Aac;
using Exegesis.Shared;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Fx
{
    /// <summary>
    /// Builds an avatar's ported layers - hand-built layers that are now written as code in its
    /// AvatarDefinition - into its FX controller, with Animator As Code.
    ///
    /// Each layer goes back exactly where the hand-built one was. Layer order is behaviour (a
    /// later layer wins a conflicting property), and until the builder owns the whole controller
    /// and declares the order itself, a port must not move anything. So: note every ported
    /// layer's index, remove them all, build them all (AAC appends), then reinsert in ascending
    /// index order - each insert lands at its original index because every layer before it is
    /// already back in place.
    /// </summary>
    public static class PortedLayers
    {
        private const string LogPrefix = "[ported]";

        /// <summary>
        /// Returns false, having touched nothing, if any spec has a problem (see
        /// LayerSpec.Problems). Validation runs first precisely so a bad spec cannot leave the
        /// controller half rebuilt.
        /// </summary>
        public static bool Build(AnimatorController controller, AvatarDefinition avatar)
        {
            var specs = avatar.Layers;

            var problems = specs.SelectMany(s => s.Problems()).ToList();
            problems.AddRange(specs.GroupBy(s => s.Name).Where(g => g.Count() > 1)
                                   .Select(g => $"layer '{g.Key}' is defined {g.Count()} times."));
            if (problems.Count > 0)
            {
                Debug.LogError($"{LogPrefix} {avatar.Fx.Name}: aborted, nothing was changed:\n  " +
                               string.Join("\n  ", problems));
                return false;
            }

            var layers = controller.layers;
            var originalIndex = specs.ToDictionary(
                s => s.Name, s => System.Array.FindIndex(layers, l => l.name == s.Name));

            ExegesisAac.RemoveLayersByName(controller, specs.Select(s => s.Name).ToArray());

            foreach (var spec in specs) BuildLayer(controller, spec);

            foreach (var spec in specs.Where(s => originalIndex[s.Name] >= 0)
                                      .OrderBy(s => originalIndex[s.Name]))
                ExegesisAac.MoveLayer(controller, spec.Name, originalIndex[spec.Name]);

            foreach (var spec in specs.Where(s => originalIndex[s.Name] < 0))
                Debug.LogWarning($"{LogPrefix} {avatar.Fx.Name}: had no '{spec.Name}' layer; appended one.");

            // AAC's throwaway default-motion clip per layer is unreferenced once every state
            // has its own motion.
            AnimatorAssets.SweepUnreachableSubAssets(controller, LogPrefix);
            EditorUtility.SetDirty(controller);

            Debug.Log($"{LogPrefix} {avatar.Fx.Name}: built {specs.Count} ported layer(s).");
            return true;
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

                states[s.Name] = state;
            }

            foreach (var t in spec.Transitions)
            {
                var transition = states[t.From].TransitionsTo(states[t.To]);

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
