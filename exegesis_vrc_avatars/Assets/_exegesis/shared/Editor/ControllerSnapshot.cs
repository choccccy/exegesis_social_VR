using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Shared
{
    /// <summary>
    /// Serialises an AnimatorController to canonical text: everything that decides how the
    /// animator BEHAVES, and nothing that does not.
    ///
    /// This exists so a reimplementation of the generator tools can be proved equivalent to the
    /// one it replaces. Comparing the .controller YAML directly does not work - GUIDs, fileIDs,
    /// sub-asset ordering and node positions all move for reasons that have nothing to do with
    /// behaviour - and comparing hand-picked properties only proves the properties someone
    /// thought to check, which is exactly how this project lost the 0.25s accessory fade once
    /// already.
    ///
    /// So: dump everything, exclude a short and explicitly justified list, and diff the text.
    ///
    /// DELIBERATELY EXCLUDED, each for a stated reason:
    ///   - Node positions (anyStatePosition, entryPosition, exitPosition,
    ///     parentStateMachinePosition, per-state and per-child positions). Animator-window
    ///     layout. AAC's AacDefaultsProvider.ConfigureStateMachine is not virtual and rewrites
    ///     them on every run, so including them would guarantee a false difference.
    ///   - GUIDs, fileIDs, hideFlags, and the controller asset's own name.
    ///   - The decoration AAC adds to generated sub-asset names - see NormalizeAssetName.
    ///
    /// Everything else is in, including the things no existing test looks at: blend tree
    /// normalisation, state machine behaviours, transition interruption settings, layer weights,
    /// entry transitions and every keyframe of every clip.
    ///
    /// No VRChat SDK dependency, on purpose. State machine behaviours are dumped through
    /// SerializedObject rather than by naming VRCAvatarParameterDriver's fields, which keeps
    /// this assembly SDK-free AND means a field added to the driver in a future SDK version is
    /// captured automatically instead of silently ignored.
    /// </summary>
    public static class ControllerSnapshot
    {
        /// <summary>
        /// Full inlines every keyframe of every clip - verbose, but a diff points straight at
        /// the curve that moved. Compact replaces each clip's curve block with a hash, which is
        /// what the committed golden baseline uses: this controller references 102 clips and
        /// inlining all of them produces a file nobody will read.
        /// </summary>
        public enum Detail
        {
            Full,
            Compact,
        }

        public static string Of(AnimatorController controller, Detail detail = Detail.Full)
        {
            if (controller == null) throw new ArgumentNullException(nameof(controller));

            var w = new Writer(detail);
            w.Line("controller");
            using (w.Indent())
            {
                DumpParameters(w, controller);
                DumpLayers(w, controller);
            }
            return w.ToString();
        }

        // ------------------------------------------------------------------ parameters

        private static void DumpParameters(Writer w, AnimatorController c)
        {
            var ps = c.parameters;
            w.Line($"parameters ({ps.Length})");
            using (w.Indent())
            {
                for (int i = 0; i < ps.Length; i++)
                {
                    var p = ps[i];
                    // Only the default matching the declared type is meaningful; Unity keeps
                    // stale values in the other three fields and they are not behaviour.
                    string def;
                    switch (p.type)
                    {
                        case AnimatorControllerParameterType.Float: def = Num(p.defaultFloat); break;
                        case AnimatorControllerParameterType.Int: def = p.defaultInt.ToString(CultureInfo.InvariantCulture); break;
                        case AnimatorControllerParameterType.Bool: def = p.defaultBool.ToString(); break;
                        case AnimatorControllerParameterType.Trigger: def = p.defaultBool.ToString(); break;
                        default: def = "?"; break;
                    }
                    w.Line($"[{i}] {Str(p.name)} type={p.type} default={def}");
                }
            }
        }

        // ---------------------------------------------------------------------- layers

        private static void DumpLayers(Writer w, AnimatorController c)
        {
            var layers = c.layers;
            w.Line($"layers ({layers.Length})");
            using (w.Indent())
            {
                for (int i = 0; i < layers.Length; i++)
                {
                    var l = layers[i];
                    w.Line($"[{i}] {Str(l.name)}");
                    using (w.Indent())
                    {
                        w.Line($"defaultWeight={Num(l.defaultWeight)} blendingMode={l.blendingMode} " +
                               $"ikPass={l.iKPass} syncedLayerIndex={l.syncedLayerIndex} " +
                               $"syncedLayerAffectsTiming={l.syncedLayerAffectsTiming} " +
                               $"mask={(l.avatarMask == null ? "none" : Str(l.avatarMask.name))}");
                        DumpStateMachine(w, l.stateMachine);
                    }
                }
            }
        }

        private static void DumpStateMachine(Writer w, AnimatorStateMachine sm)
        {
            if (sm == null) { w.Line("stateMachine none"); return; }

            w.Line($"stateMachine {Str(sm.name)}");
            using (w.Indent())
            {
                w.Line($"defaultState={(sm.defaultState == null ? "none" : Str(sm.defaultState.name))}");
                DumpBehaviours(w, sm.behaviours);

                var entry = sm.entryTransitions;
                w.Line($"entryTransitions ({entry.Length})");
                using (w.Indent())
                    for (int i = 0; i < entry.Length; i++) DumpTransitionBase(w, i, entry[i]);

                var any = sm.anyStateTransitions;
                w.Line($"anyStateTransitions ({any.Length})");
                using (w.Indent())
                    for (int i = 0; i < any.Length; i++) DumpStateTransition(w, i, any[i]);

                var states = sm.states;
                w.Line($"states ({states.Length})");
                using (w.Indent())
                    foreach (var child in states) DumpState(w, child.state);

                var subs = sm.stateMachines;
                w.Line($"subStateMachines ({subs.Length})");
                using (w.Indent())
                {
                    foreach (var child in subs)
                    {
                        if (child.stateMachine == null) { w.Line("subStateMachine none"); continue; }

                        // Transitions OUT of a sub-machine hang off the parent, keyed by child.
                        var outgoing = sm.GetStateMachineTransitions(child.stateMachine);
                        w.Line($"outgoingTransitions ({outgoing.Length})");
                        using (w.Indent())
                            for (int i = 0; i < outgoing.Length; i++) DumpTransitionBase(w, i, outgoing[i]);

                        DumpStateMachine(w, child.stateMachine);
                    }
                }
            }
        }

        private static void DumpState(Writer w, AnimatorState s)
        {
            if (s == null) { w.Line("state none"); return; }

            w.Line($"state {Str(s.name)}");
            using (w.Indent())
            {
                // writeDefaultValues first and alone on its line: it is the single most
                // load-bearing bit in this controller and a diff should shout about it.
                w.Line($"writeDefaultValues={s.writeDefaultValues}");
                w.Line($"speed={Num(s.speed)} speedParameter={Str(s.speedParameter)} " +
                       $"speedParameterActive={s.speedParameterActive}");
                w.Line($"cycleOffset={Num(s.cycleOffset)} cycleOffsetParameter={Str(s.cycleOffsetParameter)} " +
                       $"cycleOffsetParameterActive={s.cycleOffsetParameterActive}");
                w.Line($"timeParameter={Str(s.timeParameter)} timeParameterActive={s.timeParameterActive}");
                w.Line($"mirror={s.mirror} mirrorParameter={Str(s.mirrorParameter)} " +
                       $"mirrorParameterActive={s.mirrorParameterActive}");
                w.Line($"iKOnFeet={s.iKOnFeet} tag={Str(s.tag)}");

                DumpMotion(w, s.motion);
                DumpBehaviours(w, s.behaviours);

                var ts = s.transitions;
                w.Line($"transitions ({ts.Length})");
                using (w.Indent())
                    for (int i = 0; i < ts.Length; i++) DumpStateTransition(w, i, ts[i]);
            }
        }

        // ----------------------------------------------------------------- transitions

        private static void DumpStateTransition(Writer w, int index, AnimatorStateTransition t)
        {
            if (t == null) { w.Line($"[{index}] none"); return; }

            w.Line($"[{index}] -> {Destination(t)}");
            using (w.Indent())
            {
                w.Line($"duration={Num(t.duration)} offset={Num(t.offset)} exitTime={Num(t.exitTime)} " +
                       $"hasExitTime={t.hasExitTime} hasFixedDuration={t.hasFixedDuration}");
                w.Line($"interruptionSource={t.interruptionSource} orderedInterruption={t.orderedInterruption} " +
                       $"canTransitionToSelf={t.canTransitionToSelf}");
                w.Line($"mute={t.mute} solo={t.solo} isExit={t.isExit}");
                DumpConditions(w, t.conditions);
            }
        }

        /// <summary>
        /// Entry and state-machine transitions are AnimatorTransition, not
        /// AnimatorStateTransition - no duration, no exit time, no interruption. Worth noting
        /// because AAC's ConfigureTransition only ever runs on the latter.
        /// </summary>
        private static void DumpTransitionBase(Writer w, int index, AnimatorTransitionBase t)
        {
            if (t == null) { w.Line($"[{index}] none"); return; }

            w.Line($"[{index}] -> {Destination(t)}");
            using (w.Indent())
            {
                w.Line($"mute={t.mute} solo={t.solo} isExit={t.isExit}");
                DumpConditions(w, t.conditions);
            }
        }

        private static string Destination(AnimatorTransitionBase t)
        {
            if (t.destinationState != null) return "state " + Str(t.destinationState.name);
            if (t.destinationStateMachine != null) return "stateMachine " + Str(t.destinationStateMachine.name);
            return t.isExit ? "Exit" : "none";
        }

        private static void DumpConditions(Writer w, AnimatorCondition[] conditions)
        {
            w.Line($"conditions ({conditions.Length})");
            using (w.Indent())
            {
                for (int i = 0; i < conditions.Length; i++)
                {
                    var cond = conditions[i];
                    // Mode is dumped as the enum name, not its number: Equals vs If against an
                    // Int is the difference between a condition that matches and one that never
                    // does, and "6" vs "3" would not read as alarming in a diff.
                    w.Line($"[{i}] {Str(cond.parameter)} {cond.mode} {Num(cond.threshold)}");
                }
            }
        }

        // ------------------------------------------------------------------ behaviours

        private static readonly HashSet<string> SkippedBehaviourProperties = new HashSet<string>
        {
            "m_Script",             // a MonoScript reference; the type name is dumped instead
            "m_ObjectHideFlags",
            "m_CorrespondingSourceObject",
            "m_PrefabInstance",
            "m_PrefabAsset",
            "m_GameObject",
            "m_Enabled",
            "m_EditorHideFlags",
            "m_EditorClassIdentifier",
            "m_Name",
        };

        private static void DumpBehaviours(Writer w, StateMachineBehaviour[] behaviours)
        {
            behaviours = behaviours ?? new StateMachineBehaviour[0];
            w.Line($"behaviours ({behaviours.Length})");
            using (w.Indent())
            {
                for (int i = 0; i < behaviours.Length; i++)
                {
                    var b = behaviours[i];
                    if (b == null) { w.Line($"[{i}] none"); continue; }

                    w.Line($"[{i}] {b.GetType().FullName}");
                    using (w.Indent()) DumpSerializedFields(w, b);
                }
            }
        }

        /// <summary>
        /// Generic SerializedObject walk. Used instead of naming VRCAvatarParameterDriver's
        /// fields directly for two reasons: this assembly stays free of the VRChat SDK, and a
        /// field the SDK adds later is captured rather than silently dropped.
        /// </summary>
        private static void DumpSerializedFields(Writer w, UnityEngine.Object target)
        {
            var so = new SerializedObject(target);
            var it = so.GetIterator();

            // enterChildren true on the first Next() to get past the root.
            bool enter = true;
            while (it.Next(enter))
            {
                enter = true;

                if (it.depth == 0 && SkippedBehaviourProperties.Contains(it.name))
                {
                    enter = false;
                    continue;
                }

                // Generic containers only announce their shape; the leaves carry the values.
                if (it.propertyType == SerializedPropertyType.Generic)
                {
                    if (it.isArray) w.Line($"{it.propertyPath}.size={it.arraySize}");
                    continue;
                }

                w.Line($"{it.propertyPath}={SerializedValue(it)}");
                enter = false;
            }
        }

        private static string SerializedValue(SerializedProperty p)
        {
            switch (p.propertyType)
            {
                case SerializedPropertyType.Integer: return p.longValue.ToString(CultureInfo.InvariantCulture);
                case SerializedPropertyType.Boolean: return p.boolValue.ToString();
                case SerializedPropertyType.Float: return Num((float)p.doubleValue);
                case SerializedPropertyType.String: return Str(p.stringValue);
                case SerializedPropertyType.Enum: return p.enumValueIndex >= 0 && p.enumValueIndex < p.enumNames.Length
                    ? p.enumNames[p.enumValueIndex]
                    : p.enumValueIndex.ToString(CultureInfo.InvariantCulture);
                case SerializedPropertyType.ObjectReference:
                    // By name, never by GUID or instance id - those move between two builds of
                    // the same thing and would drown the diff.
                    return p.objectReferenceValue == null
                        ? "none"
                        : $"{p.objectReferenceValue.GetType().Name}:{Str(NormalizeAssetName(p.objectReferenceValue.name))}";
                case SerializedPropertyType.Vector2: return Vec(p.vector2Value.x, p.vector2Value.y);
                case SerializedPropertyType.Vector3: return Vec(p.vector3Value.x, p.vector3Value.y, p.vector3Value.z);
                case SerializedPropertyType.Vector4: return Vec(p.vector4Value.x, p.vector4Value.y, p.vector4Value.z, p.vector4Value.w);
                case SerializedPropertyType.Color:
                    var col = p.colorValue;
                    return Vec(col.r, col.g, col.b, col.a);
                case SerializedPropertyType.AnimationCurve: return $"curve(keys={p.animationCurveValue.length})";
                case SerializedPropertyType.ArraySize: return p.intValue.ToString(CultureInfo.InvariantCulture);
                default: return $"<{p.propertyType}>";
            }
        }

        // --------------------------------------------------------------------- motions

        private static void DumpMotion(Writer w, Motion motion)
        {
            if (motion == null) { w.Line("motion none"); return; }

            if (motion is BlendTree tree) { DumpBlendTree(w, tree); return; }
            if (motion is AnimationClip clip) { DumpClip(w, clip); return; }

            w.Line($"motion {motion.GetType().Name} {Str(NormalizeAssetName(motion.name))}");
        }

        private static void DumpBlendTree(Writer w, BlendTree tree)
        {
            // The tree's own name is not dumped. AAC's NewBlendTree() has no named overload, so
            // every tree it creates is called after a fresh Guid; the name carries no meaning
            // and comparing it would be comparing random numbers.
            w.Line("motion blendTree");
            using (w.Indent())
            {
                w.Line($"blendType={tree.blendType} blendParameter={Str(tree.blendParameter)} " +
                       $"blendParameterY={Str(tree.blendParameterY)}");
                w.Line($"useAutomaticThresholds={tree.useAutomaticThresholds} " +
                       $"minThreshold={Num(tree.minThreshold)} maxThreshold={Num(tree.maxThreshold)}");

                // No public accessor exists for this, and the whole RCS design rests on it:
                // with normalisation OFF a Direct tree SUMS its children instead of averaging
                // them, which is what makes the smoother a lerp and the IMU a signed pair.
                w.Line($"normalizedBlendValues={ReadNormalizedBlendValues(tree)}");

                var children = tree.children;
                w.Line($"children ({children.Length})");
                using (w.Indent())
                {
                    for (int i = 0; i < children.Length; i++)
                    {
                        var ch = children[i];
                        w.Line($"[{i}] threshold={Num(ch.threshold)} " +
                               $"directBlendParameter={Str(ch.directBlendParameter)} " +
                               $"timeScale={Num(ch.timeScale)} cycleOffset={Num(ch.cycleOffset)} " +
                               $"mirror={ch.mirror} position={Vec(ch.position.x, ch.position.y)}");
                        using (w.Indent()) DumpMotion(w, ch.motion);
                    }
                }
            }
        }

        private static string ReadNormalizedBlendValues(BlendTree tree)
        {
            var prop = new SerializedObject(tree).FindProperty("m_NormalizedBlendValues");
            return prop == null ? "<unreadable>" : prop.boolValue.ToString();
        }

        private static void DumpClip(Writer w, AnimationClip clip)
        {
            w.Line($"motion clip {Str(NormalizeAssetName(clip.name))}");
            using (w.Indent())
            {
                var body = ClipBody(clip, w.DetailLevel);
                foreach (var line in body) w.Line(line);
            }
        }

        /// <summary>
        /// The clip's curve data, either in full or hashed. Split out so Compact hashes exactly
        /// the same text that Full prints - a Compact snapshot is therefore just as sensitive to
        /// a changed keyframe, it simply reports it as a changed hash.
        /// </summary>
        private static List<string> ClipBody(AnimationClip clip, Detail detail)
        {
            var full = new List<string>();

            var settings = AnimationUtility.GetAnimationClipSettings(clip);
            full.Add($"frameRate={Num(clip.frameRate)} wrapMode={clip.wrapMode} legacy={clip.legacy}");
            full.Add($"settings: startTime={Num(settings.startTime)} stopTime={Num(settings.stopTime)} " +
                     $"loopTime={settings.loopTime} loopBlend={settings.loopBlend} " +
                     $"cycleOffset={Num(settings.cycleOffset)} " +
                     $"additiveReferencePose={settings.hasAdditiveReferencePose}");

            var floatBindings = AnimationUtility.GetCurveBindings(clip)
                .OrderBy(b => b.path, StringComparer.Ordinal)
                .ThenBy(b => b.type == null ? "" : b.type.FullName, StringComparer.Ordinal)
                .ThenBy(b => b.propertyName, StringComparer.Ordinal)
                .ToArray();

            full.Add($"floatCurves ({floatBindings.Length})");
            foreach (var b in floatBindings)
            {
                full.Add($"  {Str(b.path)} {(b.type == null ? "null" : b.type.FullName)} {Str(b.propertyName)}");
                var curve = AnimationUtility.GetEditorCurve(clip, b);
                if (curve == null) { full.Add("    <null curve>"); continue; }

                full.Add($"    preWrapMode={curve.preWrapMode} postWrapMode={curve.postWrapMode} keys={curve.length}");
                foreach (var k in curve.keys)
                {
                    full.Add($"    key t={Num(k.time)} v={Num(k.value)} in={Num(k.inTangent)} " +
                             $"out={Num(k.outTangent)} inW={Num(k.inWeight)} outW={Num(k.outWeight)} " +
                             $"wm={k.weightedMode}");
                }
            }

            var objBindings = AnimationUtility.GetObjectReferenceCurveBindings(clip)
                .OrderBy(b => b.path, StringComparer.Ordinal)
                .ThenBy(b => b.type == null ? "" : b.type.FullName, StringComparer.Ordinal)
                .ThenBy(b => b.propertyName, StringComparer.Ordinal)
                .ToArray();

            full.Add($"objectCurves ({objBindings.Length})");
            foreach (var b in objBindings)
            {
                full.Add($"  {Str(b.path)} {(b.type == null ? "null" : b.type.FullName)} {Str(b.propertyName)}");
                var keys = AnimationUtility.GetObjectReferenceCurve(clip, b) ?? new ObjectReferenceKeyframe[0];
                foreach (var k in keys)
                {
                    var v = k.value == null ? "none" : $"{k.value.GetType().Name}:{NormalizeAssetName(k.value.name)}";
                    full.Add($"    key t={Num(k.time)} v={Str(v)}");
                }
            }

            if (detail == Detail.Full) return full;

            // Compact: keep the shape visible, hash the detail. A changed keyframe still fails,
            // it just does not print 40,000 lines of context to say so.
            return new List<string>
            {
                full[0],
                $"floatCurves ({floatBindings.Length}) objectCurves ({objBindings.Length})",
                $"contentHash={Hash(string.Join("\n", full))}",
            };
        }

        private static string Hash(string text)
        {
            using (var sha = SHA256.Create())
            {
                var bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(text));
                var sb = new StringBuilder(bytes.Length * 2);
                foreach (var b in bytes) sb.Append(b.ToString("x2"));
                return sb.ToString(0, 32);
            }
        }

        // ------------------------------------------------------------------ formatting

        /// <summary>
        /// Strips the decoration AAC puts on generated sub-asset names.
        ///
        /// AacInternals.Internal_GenerateAnimationName produces
        /// "zAutogenerated/{AssetKey}__{name}_{Random.Range(0, int.MaxValue)}", so the same
        /// build run twice produces different names for identical assets. Without this, every
        /// snapshot comparison is noise and the committed controller churns forever.
        ///
        /// A name that does not carry the prefix is returned untouched, so hand-authored clips
        /// like _Empty.anim compare by their real names.
        /// </summary>
        public static string NormalizeAssetName(string name)
        {
            if (string.IsNullOrEmpty(name)) return name ?? "";

            var m = AutoGeneratedName.Match(name);
            if (!m.Success) return name;

            return TrailingRandomSuffix.Replace(m.Groups["body"].Value, "");
        }

        // "zAutogenerated/" is the current prefix, "zAutogenerated__" the legacy one AAC still
        // cleans up after. The key is followed by "__", and the key itself may contain neither.
        private static readonly Regex AutoGeneratedName =
            new Regex(@"^zAutogenerated(?:/|__)[^_]*__(?<body>.*)$", RegexOptions.Compiled);

        private static readonly Regex TrailingRandomSuffix =
            new Regex(@"_\d+$", RegexOptions.Compiled);

        /// <summary>
        /// Fixed-precision invariant formatting. Fixed rather than round-trip because two builds
        /// of the same value can differ in the last bit for reasons that are not behaviour;
        /// six decimals is far finer than anything here is tuned to. Negative zero is folded
        /// into zero, and the non-finite values get names rather than culture-dependent text.
        /// </summary>
        private static string Num(float v)
        {
            if (float.IsNaN(v)) return "NaN";
            if (float.IsPositiveInfinity(v)) return "+Inf";
            if (float.IsNegativeInfinity(v)) return "-Inf";
            if (v == 0f) return "0.000000";
            return v.ToString("F6", CultureInfo.InvariantCulture);
        }

        private static string Vec(params float[] parts) => "(" + string.Join(", ", parts.Select(Num)) + ")";

        private static string Str(string s) => s == null ? "<null>" : "\"" + s + "\"";

        // --------------------------------------------------------------------- plumbing

        private sealed class Writer
        {
            private readonly StringBuilder _sb = new StringBuilder();
            private int _depth;

            public Writer(Detail detail) { DetailLevel = detail; }

            public Detail DetailLevel { get; }

            public void Line(string text)
            {
                _sb.Append(' ', _depth * 2).Append(text).Append('\n');
            }

            public IDisposable Indent() => new Scope(this);

            public override string ToString() => _sb.ToString();

            private sealed class Scope : IDisposable
            {
                private readonly Writer _w;
                public Scope(Writer w) { _w = w; _w._depth++; }
                public void Dispose() { _w._depth--; }
            }
        }
    }
}
