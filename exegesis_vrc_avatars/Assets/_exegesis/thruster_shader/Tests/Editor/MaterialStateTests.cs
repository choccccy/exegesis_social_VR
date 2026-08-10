using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.Rendering;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Pins the live thrusters.mat: that it is bound to the RCS shader at all, that it
    /// renders in the transparent queue, and that every animation-contract property
    /// resolves on the material (not just on the shader).
    ///
    /// Deliberately does NOT pin tuning values (_AccelGain, colours, thresholds...).
    /// Those are meant to be dialled in from the headset and would turn this test into
    /// a nuisance. The golden-image tests pin the maths; this pins the wiring.
    /// </summary>
    [TestFixture]
    public class MaterialStateTests
    {
        private Material _mat;

        [SetUp]
        public void SetUp()
        {
            _mat = RcsTestConstants.LoadMaterial();
        }

        [Test]
        public void Material_Exists()
        {
            Assert.IsNotNull(_mat, $"Material missing at {RcsTestConstants.MaterialPath}.");
        }

        [Test]
        public void Material_UsesRcsShader()
        {
            Assert.IsNotNull(_mat);
            Assert.IsNotNull(_mat.shader, "Material has no shader bound.");
            Assert.AreEqual(RcsTestConstants.ShaderName, _mat.shader.name,
                "thrusters.mat is not bound to the RCS shader. If this was an intentional " +
                "revert to Poiyomi, the FX rcs_* layers need removing too.");
        }

        [Test]
        public void Material_RendersInTransparentQueue()
        {
            Assert.IsNotNull(_mat);
            // Additive emission over the opaque body. -1 means "inherit from shader",
            // which the shader tags as Transparent (3000).
            var queue = _mat.renderQueue == -1 ? (int)RenderQueue.Transparent : _mat.renderQueue;
            Assert.GreaterOrEqual(queue, (int)RenderQueue.Transparent,
                $"Expected a transparent-range queue, got {queue}.");
        }

        [Test]
        public void Material_HasEveryAnimationContractProperty()
        {
            Assert.IsNotNull(_mat);

            var missing = new List<string>();
            foreach (var prop in RcsTestConstants.AnimationContractProperties)
                if (!_mat.HasProperty(prop)) missing.Add(prop);

            Assert.IsEmpty(missing,
                "thrusters.mat is missing animation-contract properties: " +
                string.Join(", ", missing));
        }

        [Test]
        public void Material_MasterAuthorityIsEnabledByDefault()
        {
            Assert.IsNotNull(_mat);
            Assert.IsTrue(_mat.HasProperty("_RCS_Master"));
            // Saved at 1 so the thrusters work even before the menu toggle layer runs.
            // With Write Defaults OFF across the controller, an unwritten property keeps
            // its serialized value, so this default is load-bearing.
            Assert.AreEqual(1f, _mat.GetFloat("_RCS_Master"), 0.001f,
                "_RCS_Master should be saved at 1 in the material.");
        }
    }
}
