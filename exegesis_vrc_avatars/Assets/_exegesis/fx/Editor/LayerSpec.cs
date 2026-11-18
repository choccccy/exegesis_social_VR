using System.Collections.Generic;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Fx
{
    /// <summary>
    /// One FX layer, written as code: its states, its transitions in evaluation order, and its
    /// default state. PortedLayers turns these into real layers with Animator As Code.
    ///
    /// Written fluently so a layer reads top to bottom like the Animator window would show it:
    /// <code>
    /// new LayerSpec("HUD")
    ///     .State("HUD_off", Clips.Hud("HUD_off"))
    ///     .State("HUD_on", Clips.Hud("HUD_on"))
    ///     .Go("HUD_off", "HUD_on", 0f, Cond.If("IsLocal"), Cond.If("hud"))
    ///     .Go("HUD_on", "HUD_off", 0f, Cond.IfNot("IsLocal"))
    ///     .Go("HUD_on", "HUD_off", 0f, Cond.IfNot("hud"))
    ///     .Default("HUD_off");
    /// </code>
    ///
    /// Order matters twice over. States are created in the order given, and each state's
    /// transitions are evaluated in the order given - the first whose conditions pass wins.
    /// The snapshot baselines record both, so a port has to reproduce them exactly.
    ///
    /// Every transition starts as: no exit time (exitTime 0), fixed duration, no offset. That
    /// is what every hand-built layer used; anything else is opted into explicitly with the
    /// modifiers below, which apply to the transition added last.
    ///
    /// There is deliberately no Write Defaults option. Every state is Write Defaults OFF
    /// (ExegesisDefaultsProvider), which is what lets layers stack; a state that needed it on
    /// would have to be designed around instead. WriteDefaultsTests holds that line.
    /// </summary>
    public sealed class LayerSpec
    {
        public string Name { get; }
        public float Weight { get; private set; } = 1f;
        public string DefaultState { get; private set; }
        public List<StateSpec> States { get; } = new List<StateSpec>();
        public List<TransitionSpec> Transitions { get; } = new List<TransitionSpec>();

        public LayerSpec(string name)
        {
            Name = name;
        }

        public LayerSpec WithWeight(float weight)
        {
            Weight = weight;
            return this;
        }

        /// <param name="speed">Playback speed multiplier.</param>
        /// <param name="mirror">Mirrors the motion.</param>
        /// <param name="motionTime">
        /// Float parameter that drives normalized time instead of the clock - the clip becomes
        /// a lookup table indexed by the parameter.
        /// </param>
        public LayerSpec State(string name, string clipPath, float speed = 1f,
                               bool mirror = false, string motionTime = null)
        {
            States.Add(new StateSpec(name, clipPath, speed, mirror, motionTime));
            return this;
        }

        public LayerSpec Go(string from, string to, float duration, params Cond[] when)
        {
            Transitions.Add(new TransitionSpec(from, to, duration, when));
            return this;
        }

        /// <summary>Makes the last transition's duration normalized rather than in seconds.</summary>
        public LayerSpec NotFixedDuration()
        {
            Transitions[Transitions.Count - 1].FixedDuration = false;
            return this;
        }

        /// <summary>Gives the last transition an exit time (normalized).</summary>
        public LayerSpec AfterExitTime(float exitTime)
        {
            var t = Transitions[Transitions.Count - 1];
            t.HasExitTime = true;
            t.ExitTime = exitTime;
            return this;
        }

        public LayerSpec Default(string state)
        {
            DefaultState = state;
            return this;
        }

        /// <summary>Every clip path the layer plays, for validation before anything is built.</summary>
        public IEnumerable<string> ClipPaths => States.Select(s => s.ClipPath);

        /// <summary>
        /// What is wrong with this spec, if anything. Checked for every layer before the build
        /// touches the controller, so a typo fails loudly instead of leaving half a controller.
        /// A missing clip is the important one: a state with no motion writes nothing, which
        /// with Write Defaults off is indistinguishable from the layer doing nothing at all.
        /// </summary>
        public IEnumerable<string> Problems()
        {
            var names = new HashSet<string>();
            foreach (var s in States)
            {
                if (!names.Add(s.Name)) yield return $"{Name}: duplicate state '{s.Name}'.";
                if (AssetDatabase.LoadAssetAtPath<AnimationClip>(s.ClipPath) == null)
                    yield return $"{Name}: state '{s.Name}' plays a missing clip, {s.ClipPath}.";
            }

            foreach (var t in Transitions)
            {
                if (!names.Contains(t.From)) yield return $"{Name}: transition from unknown state '{t.From}'.";
                if (!names.Contains(t.To)) yield return $"{Name}: transition to unknown state '{t.To}'.";
            }

            if (States.Count > 0 && DefaultState == null)
                yield return $"{Name}: has states but no default state.";
            if (DefaultState != null && !names.Contains(DefaultState))
                yield return $"{Name}: default state '{DefaultState}' does not exist.";
        }
    }

    public sealed class StateSpec
    {
        public string Name { get; }
        public string ClipPath { get; }
        public float Speed { get; }
        public bool Mirror { get; }
        public string MotionTime { get; }

        public StateSpec(string name, string clipPath, float speed = 1f,
                         bool mirror = false, string motionTime = null)
        {
            Name = name;
            ClipPath = clipPath;
            Speed = speed;
            Mirror = mirror;
            MotionTime = motionTime;
        }
    }

    public sealed class TransitionSpec
    {
        public string From { get; }
        public string To { get; }
        public float Duration { get; }
        public Cond[] Conditions { get; }
        public bool FixedDuration { get; set; } = true;
        public bool HasExitTime { get; set; }
        public float ExitTime { get; set; }

        public TransitionSpec(string from, string to, float duration, Cond[] conditions)
        {
            From = from;
            To = to;
            Duration = duration;
            Conditions = conditions;
        }
    }

    public enum ParamKind { Bool, Int, Float }

    /// <summary>
    /// A transition condition. The parameter's type is explicit because Greater and Less exist
    /// for both ints and floats, and Animator As Code needs to know which to declare.
    /// </summary>
    public readonly struct Cond
    {
        public string Param { get; }
        public ParamKind Kind { get; }
        public AnimatorConditionMode Mode { get; }
        public float Threshold { get; }

        private Cond(string param, ParamKind kind, AnimatorConditionMode mode, float threshold)
        {
            Param = param;
            Kind = kind;
            Mode = mode;
            Threshold = threshold;
        }

        public static Cond If(string p) => new Cond(p, ParamKind.Bool, AnimatorConditionMode.If, 0);
        public static Cond IfNot(string p) => new Cond(p, ParamKind.Bool, AnimatorConditionMode.IfNot, 0);
        public static Cond IntEq(string p, int v) => new Cond(p, ParamKind.Int, AnimatorConditionMode.Equals, v);
        public static Cond IntNe(string p, int v) => new Cond(p, ParamKind.Int, AnimatorConditionMode.NotEqual, v);
        public static Cond IntGt(string p, int v) => new Cond(p, ParamKind.Int, AnimatorConditionMode.Greater, v);
        public static Cond IntLt(string p, int v) => new Cond(p, ParamKind.Int, AnimatorConditionMode.Less, v);
        public static Cond Gt(string p, float v) => new Cond(p, ParamKind.Float, AnimatorConditionMode.Greater, v);
        public static Cond Lt(string p, float v) => new Cond(p, ParamKind.Float, AnimatorConditionMode.Less, v);
    }

    /// <summary>The two shapes most layers share. Anything else is written out with LayerSpec directly.</summary>
    public static class Shapes
    {
        /// <summary>One state, always on, no transitions: a baseline that other layers override.</summary>
        public static LayerSpec Neutral(string layer, string state, string clipPath,
                                        bool mirror = false, string motionTime = null)
        {
            return new LayerSpec(layer)
                .State(state, clipPath, mirror: mirror, motionTime: motionTime)
                .Default(state);
        }

        /// <summary>
        /// Two states on one bool: `whenTrue` while the parameter is true, `whenFalse` while it
        /// is false. Each state has exactly one way out, to the other.
        ///
        /// `trueFirst` and `startTrue` exist only because the hand-built layers were not
        /// consistent about which state came first or which was the default. Neither changes
        /// behaviour once the parameter has a value, but the snapshots record both.
        /// </summary>
        /// <param name="intoFalseNotFixed">
        /// The transition into the false state has a normalized duration. Only the touch layers
        /// do this, and with a duration of 0 it makes no difference; kept to match.
        /// </param>
        public static LayerSpec Toggle(string layer, string param, float fade,
                                       StateSpec whenTrue, StateSpec whenFalse,
                                       bool trueFirst, bool startTrue, bool intoFalseNotFixed = false)
        {
            var spec = new LayerSpec(layer);
            var order = trueFirst ? new[] { whenTrue, whenFalse } : new[] { whenFalse, whenTrue };
            foreach (var s in order)
                spec.State(s.Name, s.ClipPath, s.Speed, s.Mirror, s.MotionTime);

            foreach (var s in order)
            {
                if (s == whenTrue)
                {
                    spec.Go(whenTrue.Name, whenFalse.Name, fade, Cond.IfNot(param));
                    if (intoFalseNotFixed) spec.NotFixedDuration();
                }
                else
                {
                    spec.Go(whenFalse.Name, whenTrue.Name, fade, Cond.If(param));
                }
            }

            return spec.Default(startTrue ? whenTrue.Name : whenFalse.Name);
        }

        public static StateSpec S(string name, string clipPath, float speed = 1f,
                                  bool mirror = false, string motionTime = null) =>
            new StateSpec(name, clipPath, speed, mirror, motionTime);
    }
}
