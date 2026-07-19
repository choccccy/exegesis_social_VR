using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using UnityEditor;
using UnityEditor.Rendering;
using UnityEngine;

namespace Exegesis.HudShader.Tests
{
    /// <summary>
    /// Pins that the HUD shader is present, supported on this platform, and
    /// compiles with zero errors. This is the cheapest, most robust regression
    /// guard: any edit to HUD.shader / HUD_core.cginc / CGInclude that breaks
    /// compilation fails here immediately, with the compiler messages attached.
    /// </summary>
    [TestFixture]
    public class ShaderCompileTests
    {
        private Shader _shader;

        [SetUp]
        public void SetUp()
        {
            _shader = HudTestConstants.LoadShader();
        }

        [Test]
        public void Shader_IsFound()
        {
            Assert.IsNotNull(_shader,
                $"Shader '{HudTestConstants.ShaderName}' not found at {HudTestConstants.ShaderPath}.");
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

            // GetShaderMessages surfaces the actual compiler diagnostics; ShaderHasError
            // is the coarse boolean. We assert on errors only and log warnings so that
            // pre-existing warnings don't fail the pin but stay visible.
            var messages = ShaderUtil.GetShaderMessages(_shader);
            var errors = new List<ShaderMessage>();
            var warnings = new StringBuilder();

            foreach (var m in messages)
            {
                if (m.severity == UnityEditor.Rendering.ShaderCompilerMessageSeverity.Error)
                    errors.Add(m);
                else
                    warnings.AppendLine($"  [{m.platform}] {m.message} ({m.file}:{m.line})");
            }

            if (warnings.Length > 0)
                Debug.Log($"[HUD shader] compile warnings (non-fatal):\n{warnings}");

            if (errors.Count > 0)
            {
                var sb = new StringBuilder($"HUD shader has {errors.Count} compile error(s):\n");
                foreach (var e in errors)
                    sb.AppendLine($"  [{e.platform}] {e.message} — {e.messageDetails} ({e.file}:{e.line})");
                Assert.Fail(sb.ToString());
            }

            Assert.IsFalse(ShaderUtil.ShaderHasError(_shader),
                "ShaderUtil.ShaderHasError reported true.");
        }

        [Test]
        public void Shader_HasExpectedPassCount()
        {
            Assert.IsNotNull(_shader);
            // The HUD is a single-pass overlay. If this changes (e.g. a GrabPass or a
            // radar/IR pass is added later) this pin should be updated deliberately.
            Assert.AreEqual(1, _shader.passCount,
                "Expected exactly one pass in the HUD shader.");
        }
    }
}
