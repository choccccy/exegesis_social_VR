using System.Collections.Generic;
using System.IO;
using System.Linq;
using Exegesis.Shared;
using NUnit.Framework;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;
#if VRC_SDK_VRCSDK3
using VRC.SDK3.Avatars.Components;
using VRC.SDKBase;
#endif

namespace Exegesis.RcsThruster.Tests
{
    /// <summary>
    /// Tests for the INSTRUMENT, not for the animator.
    ///
    /// ControllerSnapshot is what the Animator As Code migration is measured with, so it has to
    /// be established that it can actually fail. A snapshot that quietly captures nothing
    /// compares equal to everything and passes forever - which would be indistinguishable from a
    /// perfect migration right up until something broke in the headset.
    ///
    /// So: build a small synthetic controller carrying one of every construct this project
    /// relies on, break it in one specific way, and require the snapshot to notice. One test
    /// case per invariant, each named after the failure it is standing guard against.
    ///
    /// A synthetic fixture rather than the real controller on purpose. Sensitivity to a field is
    /// a property of the snapshot code, not of which controller it is pointed at, and a fixture
    /// runs in milliseconds without invoking either generator.
    /// </summary>
    public class ControllerSnapshotTests
    {
        private const string Scratch = "Assets/_exegesis/thruster_shader/Tests/Editor/__snapshot_scratch";

        private const string Param = "num";
        private const string BoolParam = "flag";
        private const string FloatParam = "flt";

        [SetUp]
        public void SetUp()
        {
            if (AssetDatabase.IsValidFolder(Scratch)) AssetDatabase.DeleteAsset(Scratch);
            AssetDatabase.CreateFolder("Assets/_exegesis/thruster_shader/Tests/Editor",
                                       "__snapshot_scratch");
        }

        [TearDown]
        public void TearDown()
        {
            if (AssetDatabase.IsValidFolder(Scratch)) AssetDatabase.DeleteAsset(Scratch);
        }

        // ------------------------------------------------------------------ the fixture

        /// <summary>
        /// One synthetic controller carrying every construct the real one depends on: layers
        /// with non-default weights and blending, Write Defaults off, a faded transition with a
        /// fixed duration, Equals/NotEqual int conditions, a Direct blend tree with
        /// per-child weight parameters and normalisation forced off, a clip with real curves,
        /// and (when the SDK is present) a parameter driver.
        /// </summary>
        private AnimatorController BuildFixture(string name)
        {
            var path = $"{Scratch}/{name}.controller";
            var c = AnimatorController.CreateAnimatorControllerAtPath(path);

            c.AddParameter(FloatParam, AnimatorControllerParameterType.Float);
            c.AddParameter(Param, AnimatorControllerParameterType.Int);
            c.AddParameter(BoolParam, AnimatorControllerParameterType.Bool);

            var sm = c.layers[0].stateMachine;

            var idle = sm.AddState("idle");
            var a = sm.AddState("a");
            var b = sm.AddState("b");
            foreach (var s in new[] { idle, a, b }) s.writeDefaultValues = false;
            sm.defaultState = idle;

            a.motion = MakeClip(c, "fixture_a", "_GroupEnable.x", 1f);

            var tree = MakeDirectTree(c, "fixture_tree");
            AddDirectChild(tree, MakeClip(c, "fixture_lo", "_RCS_Vel.x", -1f), FloatParam);
            AddDirectChild(tree, MakeClip(c, "fixture_hi", "_RCS_Vel.x", 1f), "RCS_One");
            b.motion = tree;

            // Two entry transitions in a deliberate order, and one exit. Order is meaningful:
            // the animator takes the first whose conditions hold.
            Wire(idle.AddTransition(a), AnimatorConditionMode.Equals, 1f, Param, 0.25f, true);
            Wire(idle.AddTransition(b), AnimatorConditionMode.Equals, 2f, Param, 0.25f, true);
            Wire(a.AddTransition(idle), AnimatorConditionMode.NotEqual, 1f, Param, 0.25f, true);

            // A second layer with non-default weight and blending, so those fields are exercised.
            c.AddLayer("second");
            var layers = c.layers;
            layers[1].defaultWeight = 0.5f;
            layers[1].blendingMode = AnimatorLayerBlendingMode.Additive;
            c.layers = layers;

#if VRC_SDK_VRCSDK3
            var driver = b.AddStateMachineBehaviour<VRCAvatarParameterDriver>();
            driver.localOnly = false;
            driver.parameters = new List<VRC_AvatarParameterDriver.Parameter>
            {
                new VRC_AvatarParameterDriver.Parameter
                {
                    name = Param, value = 0f, type = VRC_AvatarParameterDriver.ChangeType.Set,
                },
                new VRC_AvatarParameterDriver.Parameter
                {
                    name = BoolParam, value = 1f, type = VRC_AvatarParameterDriver.ChangeType.Set,
                },
            };
#endif

            EditorUtility.SetDirty(c);
            AssetDatabase.SaveAssets();
            return c;
        }

        private static AnimationClip MakeClip(AnimatorController c, string name, string prop, float value)
        {
            // Curves first, then the asset - the ordering RcsAnimatorSetup learned the hard way.
            var clip = new AnimationClip { name = name };
            var binding = EditorCurveBinding.FloatCurve("Body", typeof(SkinnedMeshRenderer), "material." + prop);
            AnimationUtility.SetEditorCurve(clip, binding, AnimationCurve.Constant(0f, 1f / 60f, value));
            AssetDatabase.AddObjectToAsset(clip, c);
            return clip;
        }

        private static BlendTree MakeDirectTree(AnimatorController c, string name)
        {
            var tree = new BlendTree
            {
                name = name,
                blendType = BlendTreeType.Direct,
                useAutomaticThresholds = false,
                hideFlags = HideFlags.HideInHierarchy,
            };
            AssetDatabase.AddObjectToAsset(tree, c);
            SetNormalizedBlendValues(tree, false);
            return tree;
        }

        private static void AddDirectChild(BlendTree parent, Motion motion, string weightParam)
        {
            parent.AddChild(motion);
            var children = parent.children;
            children[children.Length - 1].directBlendParameter = weightParam;
            parent.children = children;
        }

        private static void Wire(AnimatorStateTransition t, AnimatorConditionMode mode,
                                 float threshold, string param, float duration, bool fixedDuration)
        {
            t.hasExitTime = false;
            t.hasFixedDuration = fixedDuration;
            t.duration = duration;
            t.offset = 0f;
            t.AddCondition(mode, threshold, param);
        }

        private static void SetNormalizedBlendValues(BlendTree tree, bool value)
        {
            var so = new SerializedObject(tree);
            var prop = so.FindProperty("m_NormalizedBlendValues");
            Assert.IsNotNull(prop, "m_NormalizedBlendValues is not on BlendTree any more. The " +
                                   "RCS design depends on Direct trees summing rather than " +
                                   "averaging, and nothing else can express that.");
            prop.boolValue = value;
            so.ApplyModifiedPropertiesWithoutUndo();
        }

        // ------------------------------------------------------------- the negative control

        /// <summary>
        /// Every one of these must change the snapshot. If any stops failing, the snapshot has
        /// gone blind to something the animator's behaviour depends on, and every equivalence
        /// result taken with it afterwards is worthless.
        /// </summary>
        [TestCase("writeDefaults", TestName = "Detects: layers stop stacking")]
        [TestCase("transitionDuration", TestName = "Detects: the accessory fade is dropped")]
        [TestCase("hasFixedDuration", TestName = "Detects: fade becomes a normalised ~4ms pop")]
        [TestCase("conditionThreshold", TestName = "Detects: a gate targets the wrong slot member")]
        [TestCase("conditionMode", TestName = "Detects: Equals becomes If and never matches an Int")]
        [TestCase("transitionAdded", TestName = "Detects: a member-to-member crossfade appears")]
        [TestCase("transitionOrder", TestName = "Detects: first-match-wins order changes")]
        [TestCase("treeNormalization", TestName = "Detects: Direct trees average instead of summing")]
        [TestCase("directBlendParameter", TestName = "Detects: the smoother's lerp is rewired")]
        [TestCase("clipKeyValue", TestName = "Detects: a gate clip writes the wrong value")]
        [TestCase("clipEmptied", TestName = "Detects: a generated clip writes nothing at all")]
        [TestCase("layerWeight", TestName = "Detects: a layer silently contributes nothing")]
        [TestCase("layerBlending", TestName = "Detects: Override becomes Additive")]
        [TestCase("defaultState", TestName = "Detects: rcs_master stops defaulting to on")]
        [TestCase("parameterType", TestName = "Detects: an Int is retyped and its conditions go inert")]
        [TestCase("driverParameterDropped", TestName = "Detects: a preset stops self-resetting loadout")]
        [TestCase("driverLocalOnly", TestName = "Detects: a driver's replication changes")]
        public void Snapshot_DetectsInjectedDifference(string mutation)
        {
            var c = BuildFixture("mutate_" + mutation);
            var before = ControllerSnapshot.Of(c);

            if (!Mutate(c, mutation))
                Assert.Ignore($"Mutation '{mutation}' is not applicable in this configuration " +
                              "(most likely the VRChat SDK is absent).");

            var after = ControllerSnapshot.Of(c);

            Assert.AreNotEqual(before, after,
                $"ControllerSnapshot did not notice '{mutation}'. It is therefore blind to that " +
                "property, and any equivalence result produced with it cannot be trusted. Add " +
                "the property to ControllerSnapshot rather than removing this case.");
        }

        private bool Mutate(AnimatorController c, string mutation)
        {
            var sm = c.layers[0].stateMachine;
            var idle = State(sm, "idle");
            var a = State(sm, "a");
            var b = State(sm, "b");

            switch (mutation)
            {
                case "writeDefaults":
                    a.writeDefaultValues = !a.writeDefaultValues;
                    return true;

                case "transitionDuration":
                    idle.transitions[0].duration = 0f;
                    return true;

                case "hasFixedDuration":
                    idle.transitions[0].hasFixedDuration = !idle.transitions[0].hasFixedDuration;
                    return true;

                case "conditionThreshold":
                {
                    var t = idle.transitions[0];
                    var conds = t.conditions;
                    conds[0].threshold += 1f;
                    t.conditions = conds;
                    return true;
                }

                case "conditionMode":
                {
                    var t = idle.transitions[0];
                    var conds = t.conditions;
                    conds[0].mode = AnimatorConditionMode.If;
                    t.conditions = conds;
                    return true;
                }

                case "transitionAdded":
                    // The shortcut SlotMembers_SwapViaIdleNotDirectly exists to forbid.
                    Wire(a.AddTransition(b), AnimatorConditionMode.Equals, 2f, Param, 0.25f, true);
                    return true;

                case "transitionOrder":
                {
                    var ts = idle.transitions;
                    var swapped = new[] { ts[1], ts[0] }.Concat(ts.Skip(2)).ToArray();
                    idle.transitions = swapped;
                    return true;
                }

                case "treeNormalization":
                    SetNormalizedBlendValues((BlendTree)b.motion, true);
                    return true;

                case "directBlendParameter":
                {
                    var tree = (BlendTree)b.motion;
                    var children = tree.children;
                    children[0].directBlendParameter = "RCS_LagInv";
                    tree.children = children;
                    return true;
                }

                case "clipKeyValue":
                {
                    var clip = (AnimationClip)a.motion;
                    var binding = AnimationUtility.GetCurveBindings(clip)[0];
                    AnimationUtility.SetEditorCurve(clip, binding,
                                                    AnimationCurve.Constant(0f, 1f / 60f, 0f));
                    return true;
                }

                case "clipEmptied":
                {
                    var clip = (AnimationClip)a.motion;
                    clip.ClearCurves();
                    return true;
                }

                case "layerWeight":
                {
                    var layers = c.layers;
                    layers[0].defaultWeight = 0.25f;
                    c.layers = layers;
                    return true;
                }

                case "layerBlending":
                {
                    var layers = c.layers;
                    layers[0].blendingMode = AnimatorLayerBlendingMode.Additive;
                    c.layers = layers;
                    return true;
                }

                case "defaultState":
                    sm.defaultState = a;
                    return true;

                case "parameterType":
                {
                    var ps = c.parameters;
                    var i = System.Array.FindIndex(ps, p => p.name == Param);
                    ps[i].type = AnimatorControllerParameterType.Bool;
                    c.parameters = ps;
                    return true;
                }

                case "driverParameterDropped":
#if VRC_SDK_VRCSDK3
                {
                    var driver = b.behaviours.OfType<VRCAvatarParameterDriver>().FirstOrDefault();
                    if (driver == null || driver.parameters.Count == 0) return false;
                    driver.parameters.RemoveAt(driver.parameters.Count - 1);
                    return true;
                }
#else
                    return false;
#endif

                case "driverLocalOnly":
#if VRC_SDK_VRCSDK3
                {
                    var driver = b.behaviours.OfType<VRCAvatarParameterDriver>().FirstOrDefault();
                    if (driver == null) return false;
                    driver.localOnly = !driver.localOnly;
                    return true;
                }
#else
                    return false;
#endif

                default:
                    Assert.Fail($"Unknown mutation '{mutation}'.");
                    return false;
            }
        }

        private static AnimatorState State(AnimatorStateMachine sm, string name)
        {
            var s = sm.states.FirstOrDefault(x => x.state != null && x.state.name == name).state;
            Assert.IsNotNull(s, $"Fixture is missing the state '{name}'.");
            return s;
        }

        // ------------------------------------------------------------------ sanity checks

        [Test]
        public void Snapshot_IsDeterministic()
        {
            var c = BuildFixture("determinism");
            Assert.AreEqual(ControllerSnapshot.Of(c), ControllerSnapshot.Of(c),
                "Snapshotting the same controller twice produced different text, so every " +
                "comparison built on it is a coin toss.");
        }

        [Test]
        public void Snapshot_SurvivesAnAssetCopy()
        {
            // The equivalence test copies the committed controller before building into it, so
            // a copy that does not snapshot identically would invalidate the whole approach.
            var original = BuildFixture("copy_source");
            var copyPath = $"{Scratch}/copy_target.controller";
            Assert.IsTrue(AssetDatabase.CopyAsset($"{Scratch}/copy_source.controller", copyPath),
                          "AssetDatabase.CopyAsset failed.");
            AssetDatabase.ImportAsset(copyPath, ImportAssetOptions.ForceSynchronousImport);

            var copy = AssetDatabase.LoadAssetAtPath<AnimatorController>(copyPath);
            Assert.IsNotNull(copy);

            Assert.AreEqual(ControllerSnapshot.Of(original), ControllerSnapshot.Of(copy),
                "A straight copy of a controller did not snapshot identically. Either the copy " +
                "is not faithful or the snapshot is capturing asset identity rather than " +
                "behaviour.");
        }

        [Test]
        public void CompactDetail_StillNoticesAChangedKeyframe()
        {
            // The committed baseline uses Compact, which replaces curve data with a hash. If the
            // hash did not cover the keyframes, the baseline would be decorative.
            var c = BuildFixture("compact");
            var before = ControllerSnapshot.Of(c, ControllerSnapshot.Detail.Compact);

            Mutate(c, "clipKeyValue");

            Assert.AreNotEqual(before, ControllerSnapshot.Of(c, ControllerSnapshot.Detail.Compact),
                "Compact detail missed a changed keyframe, so the committed golden baseline " +
                "would not catch one either.");
        }

        [Test]
        public void NormalizeAssetName_StripsAacDecorationAndNothingElse()
        {
            // AAC names generated sub-assets zAutogenerated/<key>__<name>_<random int>, so two
            // builds of the same thing disagree on every name. Hand-authored names must survive
            // untouched or the snapshot stops comparing them at all.
            Assert.AreEqual("rcs_group_packs_covered",
                ControllerSnapshot.NormalizeAssetName("zAutogenerated/rcs__rcs_group_packs_covered_1734829"));
            Assert.AreEqual("rcs_group_packs_covered",
                ControllerSnapshot.NormalizeAssetName("zAutogenerated__rcs__rcs_group_packs_covered_2"));
            Assert.AreEqual("_Empty", ControllerSnapshot.NormalizeAssetName("_Empty"));
            Assert.AreEqual("[props]_thigh_thrusters_on",
                ControllerSnapshot.NormalizeAssetName("[props]_thigh_thrusters_on"));
        }

        // -------------------------------------------------------------------- the baseline

        [Test]
        public void CommittedController_MatchesGolden()
        {
            var controller = ControllerSnapshotBaseline.LoadController();
            Assert.IsNotNull(controller,
                $"No AnimatorController at {ControllerSnapshotBaseline.ControllerPath}.");

            if (ControllerSnapshotBaseline.CaptureRequested)
            {
                ControllerSnapshotBaseline.Capture();
                Assert.Ignore("Capture mode: rewrote the controller snapshot baseline. Review " +
                              "the diff, then run again without capture to assert against it.");
            }

            var baselinePath = ControllerSnapshotBaseline.BaselineFullPath;
            if (!File.Exists(baselinePath))
                Assert.Ignore($"No baseline at {ControllerSnapshotBaseline.BaselineAssetPath}. " +
                              "Capture one with Tools > Exegesis > Debug > Capture Controller " +
                              "Snapshot Baseline.");

            var expected = ControllerSnapshotBaseline.Normalize(File.ReadAllText(baselinePath));
            var actual = ControllerSnapshotBaseline.Normalize(
                ControllerSnapshot.Of(controller, ControllerSnapshot.Detail.Compact));

            if (expected == actual) return;

            Assert.Fail("The committed controller no longer matches its snapshot baseline.\n\n" +
                        SnapshotDiff.Describe(expected, actual) +
                        "\n\nIf this change was intended, re-bless with Tools > Exegesis > Debug " +
                        "> Capture Controller Snapshot Baseline. If it was not, something " +
                        "changed the controller that should not have - the baseline covers the " +
                        "hand-built layers as well as the generated ones.");
        }
    }
}
