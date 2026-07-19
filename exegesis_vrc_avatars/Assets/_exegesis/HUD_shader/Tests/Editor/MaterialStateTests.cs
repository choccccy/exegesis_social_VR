using NUnit.Framework;
using UnityEngine;

namespace Exegesis.HudShader.Tests
{
    /// <summary>
    /// Pins the ncho_HUD material's binding and serialized state, and — most
    /// importantly — that every animation-contract property still exists by name.
    /// The float-default checks catch accidental material corruption or an
    /// inspector change that silently rewrites saved values during a refactor.
    /// </summary>
    [TestFixture]
    public class MaterialStateTests
    {
        private Material _mat;

        [SetUp]
        public void SetUp()
        {
            _mat = HudTestConstants.LoadMaterial();
        }

        [Test]
        public void Material_IsFound()
        {
            Assert.IsNotNull(_mat, $"Material not found at {HudTestConstants.MaterialPath}.");
        }

        [Test]
        public void Material_UsesHudShader()
        {
            Assert.IsNotNull(_mat);
            Assert.IsNotNull(_mat.shader);
            Assert.AreEqual(HudTestConstants.ShaderName, _mat.shader.name);
        }

        [Test]
        public void Material_RenderQueueIsTransparentPlus3()
        {
            Assert.IsNotNull(_mat);
            // Tags { "Queue" = "Transparent+3" } => 3003, and the material keeps the
            // shader's queue (_CustomRenderQueue == -1).
            Assert.AreEqual(3003, _mat.renderQueue);
        }

        [Test]
        public void Material_HasEveryAnimationContractProperty()
        {
            Assert.IsNotNull(_mat);
            foreach (var prop in HudTestConstants.AnimationContractProperties)
            {
                Assert.IsTrue(_mat.HasProperty(prop),
                    $"Animation-contract property '{prop}' is missing from the shader. " +
                    "Renaming/removing it breaks the avatar's .anim clips and ncho_fx.controller.");
            }
        }

        // A representative slice of the material's saved floats. Not exhaustive —
        // just enough that a refactor which accidentally drops or resets state fails.
        [TestCase("_HUDOpacity", 0.8f)]
        [TestCase("_HUDScale", 1.25f)]
        [TestCase("_StatusBarsEnabled", 1f)]
        [TestCase("_PaperDollEnabled", 1f)]
        [TestCase("_CompassSnap", 1f)]
        [TestCase("_StatusBar0Fill", 1f)]
        [TestCase("_StatusBar2Fill", 0.1f)]
        [TestCase("_Overlay2Enabled", 0f)]
        public void Material_FloatDefaultsArePinned(string prop, float expected)
        {
            Assert.IsNotNull(_mat);
            Assert.IsTrue(_mat.HasProperty(prop), $"Property '{prop}' missing.");
            Assert.AreEqual(expected, _mat.GetFloat(prop), 1e-4f,
                $"Saved value of '{prop}' drifted from the pinned baseline.");
        }
    }
}
