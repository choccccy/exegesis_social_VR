using UnityEngine;

namespace Exegesis.Fx
{
    /// <summary>
    /// One animator parameter an avatar declares: name, type and default.
    ///
    /// The controller's parameter list is rebuilt from these on every build: the avatar's own,
    /// in the order its definition lists them, followed by whatever the slot and RCS tools
    /// declare for themselves. Order is cosmetic - everything addresses parameters by name -
    /// but keeping it stable keeps the snapshot diff readable.
    /// </summary>
    public readonly struct ParamSpec
    {
        public string Name { get; }
        public AnimatorControllerParameterType Type { get; }
        public float DefaultFloat { get; }
        public int DefaultInt { get; }
        public bool DefaultBool { get; }

        private ParamSpec(string name, AnimatorControllerParameterType type,
                          float f = 0f, int i = 0, bool b = false)
        {
            Name = name;
            Type = type;
            DefaultFloat = f;
            DefaultInt = i;
            DefaultBool = b;
        }

        public static ParamSpec Bool(string name, bool defaultValue = false) =>
            new ParamSpec(name, AnimatorControllerParameterType.Bool, b: defaultValue);

        public static ParamSpec Int(string name, int defaultValue = 0) =>
            new ParamSpec(name, AnimatorControllerParameterType.Int, i: defaultValue);

        public static ParamSpec Float(string name, float defaultValue = 0f) =>
            new ParamSpec(name, AnimatorControllerParameterType.Float, f: defaultValue);

        public AnimatorControllerParameter ToUnity() => new AnimatorControllerParameter
        {
            name = Name,
            type = Type,
            defaultFloat = DefaultFloat,
            defaultInt = DefaultInt,
            defaultBool = DefaultBool,
        };
    }
}
