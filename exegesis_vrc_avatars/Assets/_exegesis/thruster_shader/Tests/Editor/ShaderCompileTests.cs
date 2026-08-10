using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using UnityEditor;
using UnityEditor.Rendering;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Pins that the RCS thruster shader is present, supported, and compiles clean.
    /// Cheapest possible guard: any edit to RCSThruster.shader / RCS_core.cginc that
    /// breaks compilation fails here with the compiler diagnostics attached.
    /// </summary>
    [TestFixture]
    public class ShaderCompileTests
    {
        private Shader _shader;

        [SetUp]
        public void SetUp()
        {
            _shader = RcsTestConstants.LoadShader();
        }

        [Test]
        public void Shader_IsFound()
        {
            Assert.IsNotNull(_shader,
                $"Shader '{RcsTestConstants.ShaderName}' not found at {RcsTestConstants.ShaderPath}.");
        }

        [Test]
        public void Shader_IsSupportedOnThisPlatform()
        {
            Assert.IsNotNull(_shader);
            Assert.IsTrue(_shader.isSupported,
                $"Shader '{_shader.name}' reports isSupported == false on this platform/graphics API.");
        }

        [Test]
        public void Shader_HasNoCompileErrors()
        {
            Assert.IsNotNull(_shader);

            var messages = ShaderUtil.GetShaderMessages(_shader);
            var errors = new List<ShaderMessage>();
            var warnings = new StringBuilder();

            foreach (var m in messages)
            {
                if (m.severity == ShaderCompilerMessageSeverity.Error)
                    errors.Add(m);
                else
                    warnings.AppendLine($"  [{m.platform}] {m.message} ({m.file}:{m.line})");
            }

            if (warnings.Length > 0)
                Debug.Log($"[RCS shader] compile warnings (non-fatal):\n{warnings}");

            if (errors.Count > 0)
            {
                var sb = new StringBuilder($"RCS shader has {errors.Count} compile error(s):\n");
                foreach (var e in errors)
                    sb.AppendLine($"  [{e.platform}] {e.message} - {e.messageDetails} ({e.file}:{e.line})");
                Assert.Fail(sb.ToString());
            }

            Assert.IsFalse(ShaderUtil.ShaderHasError(_shader),
                "ShaderUtil.ShaderHasError reported true.");
        }

        [Test]
        public void Shader_HasExpectedPassCount()
        {
            Assert.IsNotNull(_shader);
            // Single additive pass. No ShadowCaster on purpose: an emissive plume face
            // must not cast shadows, and there is deliberately no Fallback to add one.
            Assert.AreEqual(1, _shader.passCount,
                "Expected exactly one pass in the RCS thruster shader.");
        }

        [Test]
        public void Shader_DeclaresEveryAnimationContractProperty()
        {
            Assert.IsNotNull(_shader);

            var missing = new List<string>();
            foreach (var prop in RcsTestConstants.AnimationContractProperties)
                if (_shader.FindPropertyIndex(prop) < 0) missing.Add(prop);

            Assert.IsEmpty(missing,
                "The shader no longer declares animation-contract properties: " +
                string.Join(", ", missing) +
                ". The FX layers drive these by name; renaming one silently breaks the avatar.");
        }
    }
}
