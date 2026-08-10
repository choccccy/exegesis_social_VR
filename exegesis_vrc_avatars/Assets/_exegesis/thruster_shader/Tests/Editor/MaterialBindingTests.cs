using System.Collections.Generic;
using System.Text;
using NUnit.Framework;
using UnityEditor;
using UnityEngine;

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Pins how animation binds to a material in the SECOND material slot.
    ///
    /// This matters more than it looks. thrusters.mat sits in slot [1] of the Body and
    /// Props renderers, and RcsAnimatorSetup authors its clips with the plain
    /// "material._RCS_Vel.x" binding. If Unity actually required an indexed
    /// "material[1]._RCS_Vel.x" for anything past slot 0, every generated clip would
    /// bind to nothing and the entire system would sit dead at its material defaults -
    /// with no error anywhere. Nothing else in this project animates a second slot, so
    /// there was no precedent to copy; this test asks Unity itself and freezes the answer.
    /// </summary>
    [TestFixture]
    public class MaterialBindingTests
    {
        private const string ProbeProperty = "_RCS_Master";

        [Test]
        public void SecondSlotMaterial_IsReachedByTheBindingTheClipsUse()
        {
            var thrusters = RcsTestConstants.LoadMaterial();
            Assert.IsNotNull(thrusters, "thrusters.mat missing.");

            GameObject root = null;
            Material slot0 = null;
            try
            {
                root = new GameObject("rcs_binding_probe") { hideFlags = HideFlags.HideAndDontSave };
                var child = new GameObject("Body") { hideFlags = HideFlags.HideAndDontSave };
                child.transform.SetParent(root.transform);

                var smr = child.AddComponent<SkinnedMeshRenderer>();
                smr.sharedMesh = Resources.GetBuiltinResource<Mesh>("Cube.fbx");

                // Slot 0 deliberately uses a shader that does NOT declare _RCS_*, so any
                // binding we find for it can only have come from slot 1.
                slot0 = new Material(Shader.Find("Standard")) { hideFlags = HideFlags.HideAndDontSave };
                smr.sharedMaterials = new[] { slot0, thrusters };

                var bindings = AnimationUtility.GetAnimatableBindings(child, root);

                var matching = new List<string>();
                foreach (var b in bindings)
                    if (b.propertyName.Contains(ProbeProperty))
                        matching.Add(b.propertyName);

                Assert.IsNotEmpty(matching,
                    $"Unity reports no animatable binding at all for {ProbeProperty} on a renderer " +
                    "whose slot [1] is thrusters.mat. Either the shader does not declare it or the " +
                    "material is not bound to the RCS shader.");

                var expected = "material." + ProbeProperty;
                if (!matching.Contains(expected))
                {
                    var sb = new StringBuilder();
                    sb.AppendLine(
                        $"RcsAnimatorSetup authors clips as '{expected}', but Unity does not offer " +
                        "that binding for a slot-[1] material. The generated clips would bind to " +
                        "nothing and the RCS system would sit dead at material defaults.");
                    sb.AppendLine("Unity offers these instead - update RendererPaths/binding names in");
                    sb.AppendLine("RcsAnimatorSetup.MaterialClip to match:");
                    foreach (var m in matching) sb.AppendLine("  " + m);
                    Assert.Fail(sb.ToString());
                }
            }
            finally
            {
                if (root != null) Object.DestroyImmediate(root);
                if (slot0 != null) Object.DestroyImmediate(slot0);
            }
        }
    }
}
