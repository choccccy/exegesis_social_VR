using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Enforces the project's hardest-won rule: <b>every feature keyed to a vertex-colour
    /// channel must ship a default that does nothing.</b>
    ///
    /// A mesh with no colour attribute reports vertex colour WHITE, and an unpainted channel
    /// on a mesh that does have one reports 0. Either way the shader gets a value it was
    /// never given deliberately, so a feature whose default is "active" is really a feature
    /// that fires against garbage on every mesh nobody has painted yet.
    ///
    /// This failed three times before it was written down, and each time it presented as the
    /// WHOLE SYSTEM being broken rather than as one new feature misconfigured - which is what
    /// makes it expensive. Shipping `_TransThrusterRotGain = 0` multiplied the torque term by
    /// zero on every thruster on the avatar, because blue was 0 everywhere; the symptom was
    /// "rotation does nothing", miles from the feature that had just been added.
    ///
    /// The prose version lives in docs/rcs-thrusters.md. This is the version that fails a
    /// build, and it reads the defaults out of the compiled shader rather than trusting the
    /// .shader text, so an override anywhere in the property block is caught.
    /// </summary>
    [TestFixture]
    public class NeutralDefaultTests
    {
        /// <summary>Float properties whose shader default must be the no-op value.</summary>
        private static readonly (string Prop, float Neutral, string Why)[] NeutralFloats =
        {
            ("_RotThrusterLinGain",  1f, "How much LINEAR authority a rotation thruster keeps. " +
                                         "Keyed to vertex blue. At 0 an unpainted avatar (blue 0 " +
                                         "everywhere) loses nothing - but the paired property " +
                                         "below loses everything, so both ship at 1 and the split " +
                                         "is opt-in."),
            ("_TransThrusterRotGain", 1f, "How much ROTATION authority a translation thruster keeps. " +
                                          "Keyed to vertex blue. This is the one that shipped at 0 " +
                                          "and killed rotation avatar-wide."),
            ("_BellFlare",            0f, "Cone-slant correction in degrees. 0 = no rotation applied."),
            ("_BellFlareProps",       0f, "Ditto, for group >= 2 geometry."),
            ("_MinThrottle",          0f, "A floor on lit throttle; above 0 every thruster glows at rest."),
            ("_DebugView",            0f, "Debug visualisations must ship OFF."),
        };

        [Test]
        public void VertexKeyedFeatures_ShipTheirNoOpDefault()
        {
            var shader = RcsTestConstants.LoadShader();
            Assert.IsNotNull(shader, "RCS shader not found.");

            var failures = new StringBuilder();
            var missing = new List<string>();

            foreach (var (prop, neutral, why) in NeutralFloats)
            {
                int i = shader.FindPropertyIndex(prop);
                if (i < 0) { missing.Add(prop); continue; }

                float actual = shader.GetPropertyDefaultFloatValue(i);
                if (Mathf.Approximately(actual, neutral)) continue;

                failures.AppendLine($"  {prop}: default is {actual}, must be {neutral}");
                failures.AppendLine($"      {why}");
            }

            Assert.IsEmpty(missing,
                "Properties named by the neutral-default rule no longer exist on the shader: " +
                string.Join(", ", missing) + ". Update NeutralDefaultTests alongside the rename.");

            if (failures.Length > 0)
                Assert.Fail("Shader properties ship a default that is NOT a no-op:\n" + failures +
                            "An added feature must never silently remove behaviour that already " +
                            "worked. Ship the neutral value and make the behaviour opt-in - see " +
                            "docs/rcs-thrusters.md, 'Footguns'.");
        }

        /// <summary>
        /// The gate inputs default all-on so geometry nobody has assigned to a group still
        /// fires. Note this is the SHADER default, i.e. the value a fresh material starts
        /// from; at runtime the rcs_group_* layers drive these every frame.
        /// </summary>
        [Test]
        public void GroupEnable_DefaultsAllOn()
        {
            var shader = RcsTestConstants.LoadShader();
            Assert.IsNotNull(shader);

            int i = shader.FindPropertyIndex("_GroupEnable");
            Assert.GreaterOrEqual(i, 0, "_GroupEnable missing from the shader.");

            var v = shader.GetPropertyDefaultVectorValue(i);
            Assert.AreEqual(Vector4.one, v,
                $"_GroupEnable defaults to {v}, expected (1,1,1,1). A zero component means every " +
                "thruster painted into that group is dark on a fresh material, before any animator " +
                "layer has run.");
        }

        /// <summary>
        /// The deliberate exception, pinned so it cannot drift either way.
        ///
        /// `_GroupGateEnabled` is an escape hatch rather than a feature default: at 1 the group
        /// gates work, which is what the avatar wants. It was retrofitted mid-debug precisely
        /// because there was no way to rule gating out as the cause of a dark avatar, so it must
        /// stay ON by default - a 0 here would silently disable every visibility group instead.
        /// </summary>
        [Test]
        public void GroupGating_ShipsEnabled()
        {
            var shader = RcsTestConstants.LoadShader();
            Assert.IsNotNull(shader);

            int i = shader.FindPropertyIndex("_GroupGateEnabled");
            Assert.GreaterOrEqual(i, 0, "_GroupGateEnabled missing from the shader.");

            Assert.AreEqual(1f, shader.GetPropertyDefaultFloatValue(i), 0.0001f,
                "_GroupGateEnabled must default to 1. It is the off-switch for group gating, not " +
                "a feature toggle; shipping 0 disables every visibility group at once.");
        }
    }
}
