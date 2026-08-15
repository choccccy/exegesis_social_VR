using UnityEditor.Animations;
using UnityEngine;

namespace Exegesis.Shared
{
    /// <summary>
    /// Declaring controller parameters, and CORRECTING THEIR TYPE when they already exist as
    /// something else.
    ///
    /// The type correction is the whole point, and it is why Animator As Code cannot own this.
    /// AAC's CreateParamIfNotExists matches by name only - a parameter already declared with the
    /// wrong type is left exactly as it is. An Equals condition against a parameter the
    /// controller believes is a Bool never matches, nothing logs it, and the layer sits in one
    /// state forever. That is this project's recurring failure shape, and getting a loud warning
    /// instead is the entire value of these functions.
    ///
    /// Note the deliberate asymmetry in how defaults are handled, carried over verbatim from the
    /// two generators:
    ///   - EnsureFloat OVERWRITES the default. Its parameters are blend-tree weights that the
    ///     tool owns outright and that must arrive at a known value.
    ///   - Ensure and EnsureInt PRESERVE an existing default. Those are VRChat expression
    ///     parameters carrying saved user values, and no build tool has any business resetting
    ///     what someone is wearing.
    /// </summary>
    public static class AnimatorParameters
    {
        public static bool Has(AnimatorController c, string name)
        {
            foreach (var p in c.parameters) if (p.name == name) return true;
            return false;
        }

        /// <summary>Declares a Float, or retypes it, always writing the given default.</summary>
        public static void EnsureFloat(AnimatorController c, string name, float defaultValue)
        {
            // c.parameters hands back an array that has to be written back wholesale; mutating
            // an element in place does not persist to the asset.
            var parameters = c.parameters;
            for (int i = 0; i < parameters.Length; i++)
            {
                if (parameters[i].name != name) continue;
                parameters[i].type = AnimatorControllerParameterType.Float;
                parameters[i].defaultFloat = defaultValue;
                c.parameters = parameters;
                return;
            }

            c.AddParameter(new AnimatorControllerParameter
            {
                name = name,
                type = AnimatorControllerParameterType.Float,
                defaultFloat = defaultValue,
            });
        }

        /// <summary>
        /// Declares a parameter if missing, and corrects its type if it exists as something
        /// else. An existing default is left alone.
        /// </summary>
        public static void Ensure(AnimatorController c, string name,
                                  AnimatorControllerParameterType type, string logPrefix)
        {
            var ps = c.parameters;
            for (int i = 0; i < ps.Length; i++)
            {
                if (ps[i].name != name) continue;
                if (ps[i].type == type) return;

                Debug.LogWarning($"{logPrefix} Parameter '{name}' was declared {ps[i].type}; " +
                                 $"corrected to {type}. Anything else conditioning on it as " +
                                 $"{ps[i].type} is now inert - check the hand-built layers.");
                ps[i].type = type;
                c.parameters = ps;
                return;
            }

            c.AddParameter(new AnimatorControllerParameter { name = name, type = type });
        }

        /// <summary>
        /// Declares an Int with a default if missing. An Int that already exists keeps its
        /// default; a parameter of some other type is retyped and DOES take the given default,
        /// because whatever value it held meant something else entirely.
        /// </summary>
        public static void EnsureInt(AnimatorController c, string name, int defaultValue,
                                     string logPrefix)
        {
            var ps = c.parameters;
            for (int i = 0; i < ps.Length; i++)
            {
                if (ps[i].name != name) continue;
                if (ps[i].type == AnimatorControllerParameterType.Int) return;

                Debug.LogWarning($"{logPrefix} '{name}' was declared {ps[i].type} on the " +
                                 "controller; correcting to Int. Any hand-built transition " +
                                 "conditioning on it as the old type is now inert - check it.");
                ps[i].type = AnimatorControllerParameterType.Int;
                ps[i].defaultInt = defaultValue;
                c.parameters = ps;
                return;
            }

            c.AddParameter(new AnimatorControllerParameter
            {
                name = name,
                type = AnimatorControllerParameterType.Int,
                defaultInt = defaultValue,
            });
        }
    }
}
