using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using UnityEditor;
using UnityEngine;

namespace Exegesis.Callout.Tests
{
    /// <summary>
    /// Pins the status-callout render model (docs/callouts.md) by rendering the real ncho.fbx:
    /// labels keep a constant size on screen, always draw over ncho's own body, draw over
    /// geometry behind the depth-pushed card, are hidden by geometry in front of it, and cost
    /// nothing when off. Also pins the ncho_callouts mesh contract (UV0/UV1, anchor bones).
    ///
    /// The label texture is swapped for solid white and the leader line set to pure green, so
    /// label pixels can be classified exactly: white = label, green = leader, red = ncho's body,
    /// blue = clear colour, grey = test walls.
    /// </summary>
    [TestFixture]
    public class CalloutTests
    {
        const string ShaderName = "exegesis/Callout";
        const string ShaderPath = "Assets/_exegesis/callout_shader/Callout.shader";
        const string MaterialPath = "Assets/_exegesis/callout_shader/callouts.mat";
        const string ModelPath = "Assets/_exegesis/ncho/ncho.fbx";
        const float SceneScale = 0.225f;      // ncho's root scale in exegesis.unity (~1.8 m tall)
        const int W = 1280, H = 720;          // non-square on purpose: exercises aspect correction
        const float LabelHeight = 0.04f;      // the material default, fraction of screen height

        // label ID -> expected anchor bone (docs/callouts.md ▸ Label slots)
        static readonly string[] AnchorBones =
        {
            "Chest", "Spine", "Hips_fix", "Head", "forearm_fix.L", "forearm_fix.R",
            "thigh_fix.L", "thigh_fix.R", "Hips_fix",
        };

        GameObject _avatar, _camGo;
        Camera _cam;
        RenderTexture _rt;
        Material _mat, _bodyMat, _wallMat;
        Texture2D _white;
        SkinnedMeshRenderer _callouts;
        readonly List<Object> _trash = new List<Object>();
        Vector3 _chestAnchor, _front;
        float _avatarHeight;

        // ---------------------------------------------------------------- setup

        [SetUp]
        public void SetUp()
        {
            var model = AssetDatabase.LoadAssetAtPath<GameObject>(ModelPath);
            Assert.IsNotNull(model, ModelPath + " not found");
            _avatar = Object.Instantiate(model);
            _avatar.hideFlags = HideFlags.HideAndDontSave;
            _avatar.transform.localScale = Vector3.one * SceneScale;

            var t = _avatar.transform.Find("ncho_callouts");
            Assert.IsNotNull(t, "ncho.fbx has no 'ncho_callouts' object. Re-export it (docs/callouts.md ▸ Mesh)");
            _callouts = t.GetComponent<SkinnedMeshRenderer>();
            Assert.IsNotNull(_callouts, "ncho_callouts is not a SkinnedMeshRenderer");
            _callouts.updateWhenOffscreen = true;   // labels extend past the anchors' bounds

            _white = new Texture2D(1024, 256, TextureFormat.RGBA32, false) { hideFlags = HideFlags.HideAndDontSave };
            _white.SetPixels32(Enumerable.Repeat(new Color32(255, 255, 255, 255), 1024 * 256).ToArray());
            _white.Apply();

            var src = AssetDatabase.LoadAssetAtPath<Material>(MaterialPath);
            Assert.IsNotNull(src, MaterialPath + " not found");
            _mat = new Material(src) { hideFlags = HideFlags.HideAndDontSave };
            _mat.SetTexture("_MainTex", _white);
            _mat.SetColor("_Color", Color.white);
            _mat.SetColor("_LineColor", Color.green);
            _mat.SetFloat("_LabelHeight", LabelHeight);
            _mat.SetFloat("_FadeStart", 1000f);
            _mat.SetFloat("_FadeEnd", 2000f);
            SetOn(chest: 1);
            _callouts.sharedMaterial = _mat;

            _bodyMat = new Material(Shader.Find("Unlit/Color")) { hideFlags = HideFlags.HideAndDontSave };
            _bodyMat.color = Color.red;
            _wallMat = new Material(Shader.Find("Unlit/Color")) { hideFlags = HideFlags.HideAndDontSave };
            _wallMat.color = new Color(0.5f, 0.5f, 0.5f, 1f);
            foreach (var r in _avatar.GetComponentsInChildren<SkinnedMeshRenderer>())
            {
                if (r == _callouts) continue;
                r.updateWhenOffscreen = true;
                r.sharedMaterials = Enumerable.Repeat(_bodyMat, r.sharedMesh.subMeshCount).ToArray();
            }

            _chestAnchor = AnchorWorld(0);
            var chestBone = FindDeep(_avatar.transform, "Chest");
            Assert.IsNotNull(chestBone, "Chest bone not found");
            _front = Vector3.ProjectOnPlane(_chestAnchor - chestBone.position, Vector3.up).normalized;
            Assert.Greater(Vector3.ProjectOnPlane(_chestAnchor - chestBone.position, Vector3.up).magnitude, 1e-4f,
                "can't work out ncho's facing from the chest anchor");
            var bodyBounds = _avatar.transform.Find("Body").GetComponent<SkinnedMeshRenderer>().bounds;
            _avatarHeight = bodyBounds.size.y;

            _camGo = new GameObject("Callout_Test_Camera") { hideFlags = HideFlags.HideAndDontSave };
            _cam = _camGo.AddComponent<Camera>();
            _cam.enabled = false;
            _cam.fieldOfView = 60f;
            _cam.nearClipPlane = 0.05f;
            _cam.farClipPlane = 500f;
            _cam.clearFlags = CameraClearFlags.SolidColor;
            _cam.backgroundColor = Color.blue;
            _rt = new RenderTexture(W, H, 24, RenderTextureFormat.ARGB32) { hideFlags = HideFlags.HideAndDontSave };
            _cam.targetTexture = _rt;
        }

        [TearDown]
        public void TearDown()
        {
            Shader.SetGlobalFloat("_VRChatMirrorMode", 0f);
            Shader.SetGlobalVector("_VRChatMirrorCameraPos", Vector4.zero);
            Shader.SetGlobalVector("_CalloutTestEyeCentre", Vector4.zero);
            if (_cam != null) _cam.targetTexture = null;
            foreach (var o in _trash) if (o != null) Object.DestroyImmediate(o);
            _trash.Clear();
            Object.DestroyImmediate(_avatar);
            Object.DestroyImmediate(_camGo);
            Object.DestroyImmediate(_mat);
            Object.DestroyImmediate(_bodyMat);
            Object.DestroyImmediate(_wallMat);
            Object.DestroyImmediate(_white);
            if (_rt != null) { _rt.Release(); Object.DestroyImmediate(_rt); }
        }

        // ---------------------------------------------------------------- helpers

        void SetOn(float chest = 0, float abdomen = 0, float face = 0, float pouches = 0,
                   float leftArm = 0, float rightArm = 0)
        {
            _mat.SetVector("_CalloutOnA", new Vector4(chest, abdomen, 0, face));
            _mat.SetVector("_CalloutOnB", new Vector4(leftArm, rightArm, 0, 0));
            _mat.SetVector("_CalloutOnC", new Vector4(pouches, 0, 0, 0));
            _mat.SetVector("_CalloutOnD", Vector4.zero);
        }

        static Transform FindDeep(Transform root, string name)
        {
            if (root.name == name) return root;
            foreach (Transform c in root) { var f = FindDeep(c, name); if (f != null) return f; }
            return null;
        }

        static int CellId(Vector2 uv0, Vector2 uv1)
        {
            int col = Mathf.FloorToInt(uv0.x * 4f - uv1.x + 0.5f);
            int row = Mathf.FloorToInt(uv0.y * 4f - uv1.y + 0.5f);
            return (3 - row) * 4 + col;
        }

        /// <summary>World-space anchor of a label: the centre of its quad, skinned exactly
        /// (each vertex is 100% on one bone, so world = bone.localToWorld * bindpose * vertex).</summary>
        Vector3 AnchorWorld(int id)
        {
            var mesh = _callouts.sharedMesh;
            var uv0 = new List<Vector2>(); mesh.GetUVs(0, uv0);
            var uv1 = new List<Vector2>(); mesh.GetUVs(1, uv1);
            var v = mesh.vertices; var w = mesh.boneWeights; var bind = mesh.bindposes; var bones = _callouts.bones;
            var sum = Vector3.zero; int n = 0;
            for (int i = 0; i < v.Length; i++)
            {
                if (CellId(uv0[i], uv1[i]) != id) continue;
                int b = w[i].boneIndex0;
                sum += (bones[b].localToWorldMatrix * bind[b]).MultiplyPoint3x4(v[i]);
                n++;
            }
            Assert.AreEqual(4, n, "label " + id + " should have exactly 4 vertices");
            return sum / n;
        }

        GameObject Wall(Vector3 centre, Vector3 facing, float size)
        {
            var w = GameObject.CreatePrimitive(PrimitiveType.Quad);
            w.hideFlags = HideFlags.HideAndDontSave;
            Object.DestroyImmediate(w.GetComponent<Collider>());
            w.transform.position = centre;
            w.transform.rotation = Quaternion.LookRotation(-facing);   // the quad faces -forward
            w.transform.localScale = Vector3.one * size;
            w.GetComponent<MeshRenderer>().sharedMaterial = _wallMat;
            _trash.Add(w);
            return w;
        }

        /// <summary>white/yellow = label (yellow only with the asymmetric texture); bbox and centre
        /// cover both. green = leader line.</summary>
        struct Shot
        {
            public int white, yellow, green;
            public int minX, maxX, minY, maxY;
            public double sumWhiteX, sumYellowX;
            public int Label => white + yellow;
            public float CentreX => (minX + maxX) * 0.5f;
            public float Height => maxY - minY + 1;
            public double MeanWhiteX => sumWhiteX / Mathf.Max(white, 1);
            public double MeanYellowX => sumYellowX / Mathf.Max(yellow, 1);
        }

        void ResetCamera()
        {
            _cam.ResetWorldToCameraMatrix();
            _cam.ResetProjectionMatrix();
        }

        Shot Render(Vector3 camPos, Vector3 lookAt)
        {
            ResetCamera();
            _camGo.transform.position = camPos;
            _camGo.transform.LookAt(lookAt, Vector3.up);
            return Capture(false);
        }

        Shot Capture(bool invertCulling)
        {
            var prevCull = GL.invertCulling;
            GL.invertCulling = invertCulling;
            try { _cam.Render(); }
            finally { GL.invertCulling = prevCull; }
            var prev = RenderTexture.active;
            var tex = new Texture2D(W, H, TextureFormat.RGBA32, false);
            try
            {
                RenderTexture.active = _rt;
                tex.ReadPixels(new Rect(0, 0, W, H), 0, 0);
                tex.Apply();
                var px = tex.GetPixels32();
                var s = new Shot { minX = int.MaxValue, minY = int.MaxValue, maxX = -1, maxY = -1 };
                for (int y = 0; y < H; y++)
                for (int x = 0; x < W; x++)
                {
                    var c = px[y * W + x];
                    bool white = c.r > 240 && c.g > 240 && c.b > 240;
                    bool yellow = c.r > 240 && c.g > 240 && c.b < 60;
                    if (white) { s.white++; s.sumWhiteX += x; }
                    if (yellow) { s.yellow++; s.sumYellowX += x; }
                    if (white || yellow)
                    {
                        s.minX = Mathf.Min(s.minX, x); s.maxX = Mathf.Max(s.maxX, x);
                        s.minY = Mathf.Min(s.minY, y); s.maxY = Mathf.Max(s.maxY, y);
                    }
                    else if (c.g > 200 && c.r < 60 && c.b < 60) s.green++;
                }
                return s;
            }
            finally { RenderTexture.active = prev; Object.DestroyImmediate(tex); }
        }

        Vector3 FrontCam(float distance) => _chestAnchor + _front * distance;
        Vector3 BackCam(float distance) => _chestAnchor - _front * distance;
        float ExpectedHeightPx => LabelHeight * H;

        // ---------------------------------------------------------------- shader

        [Test]
        public void Shader_CompilesWithoutErrors()
        {
            var shader = AssetDatabase.LoadAssetAtPath<Shader>(ShaderPath);
            Assert.IsNotNull(shader, ShaderPath + " not found");
            Assert.AreEqual(ShaderName, shader.name);
            var errors = ShaderUtil.GetShaderMessages(shader)
                .Where(m => m.severity == UnityEditor.Rendering.ShaderCompilerMessageSeverity.Error)
                .Select(m => "[" + m.platform + "] " + m.message + " (" + m.file + ":" + m.line + ")").ToList();
            Assert.IsEmpty(errors, "Callout.shader compile errors:\n" + string.Join("\n", errors));
            Assert.IsTrue(shader.isSupported, "Callout.shader is not supported on this platform");
        }

        [Test]
        public void Material_HasAnimatedProperties()
        {
            // These names are bound by the [panels]_*.anim clips. Renaming any breaks the toggles silently.
            foreach (var p in new[] { "_CalloutOnA", "_CalloutOnB", "_CalloutOnC", "_CalloutOnD" })
                Assert.IsTrue(_mat.HasProperty(p), "callouts.mat is missing animated property " + p);
        }

        // ---------------------------------------------------------------- mesh contract

        [Test]
        public void Mesh_HasOneQuadPerLabel_OnItsAnchorBone()
        {
            var mesh = _callouts.sharedMesh;
            var uv0 = new List<Vector2>(); mesh.GetUVs(0, uv0);
            var uv1 = new List<Vector2>(); mesh.GetUVs(1, uv1);
            Assert.AreEqual(mesh.vertexCount, uv1.Count, "ncho_callouts has no second UV channel (corner UVs)");
            Assert.AreEqual(AnchorBones.Length * 4, mesh.vertexCount, "expected one 4-vertex quad per label");

            var weights = mesh.boneWeights;
            var bones = _callouts.bones;
            var report = new StringBuilder();
            for (int i = 0; i < mesh.vertexCount; i++)
            {
                int id = CellId(uv0[i], uv1[i]);
                Assert.That(id, Is.InRange(0, AnchorBones.Length - 1), "vertex " + i + " is outside the used atlas cells");
                var w = weights[i];
                if (w.weight0 < 0.999f)
                    report.AppendLine("vertex " + i + " (label " + id + ") is not 100% on one bone: " + w.weight0);
                var bone = bones[w.boneIndex0].name;
                if (bone != AnchorBones[id])
                    report.AppendLine("label " + id + " is on " + bone + ", expected " + AnchorBones[id]);
            }
            Assert.IsEmpty(report.ToString(), report.ToString());
        }

        [Test]
        public void Mesh_QuadsShipTiny_SoEachVertexIsItsAnchor()
        {
            // The shader treats every vertex as its tooltip's anchor. The .blend keeps the quads
            // at an editable size; export_avatar.py (shrink_quads) must shrink them to ~1 mm.
            var mesh = _callouts.sharedMesh;
            var verts = mesh.vertices;
            var tris = mesh.triangles;
            float worst = 0f;
            for (int t = 0; t < tris.Length; t += 3)
                for (int k = 0; k < 3; k++)
                    worst = Mathf.Max(worst, (verts[tris[t + k]] - verts[tris[t + (k + 1) % 3]]).magnitude);
            // Mesh units -> metres through the import scale; compare against the avatar's height.
            Assert.Less(worst / mesh.bounds.size.magnitude, 0.002f,
                "ncho_callouts quads exported at an editable size (longest edge " + worst +
                " mesh units). Export through export_avatar.py, which shrinks them (docs/callouts.md ▸ Mesh)");
        }

        // ---------------------------------------------------------------- render model

        [Test]
        public void Label_KeepsConstantScreenSize_AcrossDistance()
        {
            var near = Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor);
            var far = Render(FrontCam(_avatarHeight * 6f), _chestAnchor);
            Assert.Greater(near.white, 0, "label not visible at near distance");
            Assert.Greater(far.white, 0, "label not visible at far distance");

            float nearH = near.maxY - near.minY + 1, farH = far.maxY - far.minY + 1;
            float nearW = near.maxX - near.minX + 1, farW = far.maxX - far.minX + 1;
            Assert.AreEqual(ExpectedHeightPx, nearH, 2.5f, "near label height (px)");
            Assert.AreEqual(ExpectedHeightPx, farH, 2.5f, "far label height (px)");
            Assert.AreEqual(nearW, farW, 2.5f, "label width changed with distance");
            // 4:1 cells: width must be 4x height in PIXELS, i.e. aspect-corrected on a 16:9 target.
            Assert.AreEqual(4f * nearH, nearW, 4f, "label aspect ratio is not corrected for the screen aspect");
        }

        [Test]
        public void Label_DrawsOverOwnBody_FromBehind()
        {
            // Run in both VR depth modes: the depth test must not depend on where it APPEARS.
            foreach (var mode in new[] { 0f, 1f })
            {
                _mat.SetFloat("_StereoDepth", mode);
                _mat.SetFloat("_DepthPush", 0.35f);
                DrawsOverOwnBodyFromBehind("_StereoDepth " + mode);
            }
        }

        void DrawsOverOwnBodyFromBehind(string mode)
        {
            var cam = BackCam(_avatarHeight * 1.2f);
            var pushed = Render(cam, _chestAnchor);
            float fullArea = ExpectedHeightPx * ExpectedHeightPx * 4f;
            Assert.Greater(pushed.white, fullArea * 0.9f,
                "from behind, the chest label should be fully visible over ncho's own back");

            // Negative control: without the depth push, the body must actually hide some of it,
            // or this test proves nothing about the push.
            _mat.SetFloat("_DepthPush", 0f);
            var unpushed = Render(cam, _chestAnchor);
            Assert.Less(unpushed.white, pushed.white * 0.9f,
                "with _DepthPush = 0 the body should hide part of the label (negative control)");
        }

        [Test]
        public void Label_HiddenByWallInFront()
        {
            float d = _avatarHeight * 2f;
            var cam = FrontCam(d);
            Assert.Greater(Render(cam, _chestAnchor).white, 0, "label should be visible before adding the wall");
            Wall(_chestAnchor + _front * (d * 0.5f), _front, _avatarHeight * 10f);   // between camera and ncho
            Assert.AreEqual(0, Render(cam, _chestAnchor).white, "a wall in front of ncho must hide the label");
        }

        [Test]
        public void Label_DrawsOverWallBehind()
        {
            float d = _avatarHeight * 2f;
            var cam = FrontCam(d);
            var open = Render(cam, _chestAnchor);
            Wall(_chestAnchor - _front * 1.0f, _front, _avatarHeight * 10f);   // 1 m behind the chest anchor
            var walled = Render(cam, _chestAnchor);
            Assert.AreEqual(open.white, walled.white, open.white * 0.02f,
                "a wall behind ncho must not hide any of the label");
        }

        [Test]
        public void Label_PartlyCutByThinPoleInFront()
        {
            float d = _avatarHeight * 2f;
            var cam = FrontCam(d);
            var open = Render(cam, _chestAnchor);
            // A vertical pole half-way to the camera, through the label's centre on screen.
            var mid = new Vector3((open.minX + open.maxX) * 0.5f, (open.minY + open.maxY) * 0.5f, 0f);
            var ray = _cam.ScreenPointToRay(new Vector3(mid.x, mid.y, 0f));
            var poleCentre = ray.GetPoint(d * 0.5f);
            var pole = Wall(poleCentre, _front, 1f);
            pole.transform.localScale = new Vector3(0.02f, _avatarHeight * 3f, 1f);
            var cut = Render(cam, _chestAnchor);
            Assert.Less(cut.white, open.white, "the pole should hide part of the label");
            Assert.Greater(cut.white, open.white * 0.5f, "a thin pole should hide only a strip of the label");
        }

        [Test]
        public void Labels_Off_DrawNothing()
        {
            SetOn();
            var s = Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor);
            Assert.AreEqual(0, s.white, "label pixels with every label off");
            Assert.AreEqual(0, s.green, "leader-line pixels with every label off");
        }

        [Test]
        public void Labels_PastFadeEnd_DrawNothing()
        {
            _mat.SetFloat("_FadeStart", _avatarHeight * 2f);
            _mat.SetFloat("_FadeEnd", _avatarHeight * 3f);
            Assert.Greater(Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor).white, 0, "visible inside fade start");
            Assert.AreEqual(0, Render(FrontCam(_avatarHeight * 4f), _chestAnchor).white, "drawn past _FadeEnd");
        }

        [Test]
        public void OnlyEnabledLabelsDraw()
        {
            // chest alone, then chest + face: the face label must add pixels, so IDs map to slots.
            var one = Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor);
            SetOn(chest: 1, face: 1);
            var two = Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor);
            Assert.Greater(two.white, one.white * 1.5f, "enabling the face label should add a second label");
        }

        // ---------------------------------------------------------------- shared geometry helpers

        /// <summary>Left half of every atlas cell white, right half yellow: shows which way text reads.</summary>
        void UseAsymmetricTexture()
        {
            var px = new Color32[1024 * 256];
            for (int y = 0; y < 256; y++)
            for (int x = 0; x < 1024; x++)
                px[y * 1024 + x] = (x % 256) < 128 ? new Color32(255, 255, 255, 255) : new Color32(255, 255, 0, 255);
            _white.SetPixels32(px);
            _white.Apply();
        }

        /// <summary>Screen x (pixels) of a world point through the camera's CURRENT matrices,
        /// custom ones included.</summary>
        float ScreenX(Vector3 world)
        {
            var clip = _cam.projectionMatrix * _cam.worldToCameraMatrix * new Vector4(world.x, world.y, world.z, 1f);
            return (clip.x / clip.w * 0.5f + 0.5f) * W;
        }

        Vector3 RootWorld => _callouts.rootBone != null ? _callouts.rootBone.position : _callouts.transform.position;

        /// <summary>The Centered-layout card, rebuilt on the CPU from the documented model: it faces
        /// <paramref name="eye"/>, its up is the camera's up made perpendicular to the line of sight,
        /// it sits _DepthPush in front of the anchor, and it's sized for _LabelHeight of the screen.
        /// Returns its screen bounding box (pixels) through the camera's current matrices.</summary>
        Rect ExpectedCardBox(int id, Vector3 eye, bool eyeLocked = false)
        {
            // eyeLocked (_StereoDepth = Match HUD): the card keeps its offset from the centre eye in
            // every eye's own frame, i.e. it moves with this eye. Eye cameras here share one rotation.
            var eyeShift = eyeLocked ? _camGo.transform.position - eye : Vector3.zero;
            var anchor = AnchorWorld(id);
            var toEye = eye - anchor; float dist = toEye.magnitude; toEye /= dist;
            var camUp = _camGo.transform.up; var camRight = _camGo.transform.right;
            var up = (camUp - toEye * Vector3.Dot(camUp, toEye)).normalized;
            var right = camRight - toEye * Vector3.Dot(camRight, toEye);
            right = (right - up * Vector3.Dot(right, up)).normalized;
            float pushed = Mathf.Max(dist - _mat.GetFloat("_DepthPush"), dist * 0.5f);
            var centre = eye - toEye * pushed;
            float unit = 2f * _mat.GetFloat("_LabelHeight") * pushed / Mathf.Abs(_cam.projectionMatrix.m11);
            var tex = _mat.GetTexture("_MainTex");
            float aspect = (tex.width / 4f) / (tex.height / 4f);
            float minX = float.MaxValue, maxX = float.MinValue, minY = float.MaxValue, maxY = float.MinValue;
            foreach (var sx in new[] { -0.5f, 0.5f })
            foreach (var sy in new[] { -0.5f, 0.5f })
            {
                var c = centre + (right * (sx * aspect) + up * sy) * unit + eyeShift;
                var clip = _cam.projectionMatrix * _cam.worldToCameraMatrix * new Vector4(c.x, c.y, c.z, 1f);
                float x = (clip.x / clip.w * 0.5f + 0.5f) * W, y = (clip.y / clip.w * 0.5f + 0.5f) * H;
                minX = Mathf.Min(minX, x); maxX = Mathf.Max(maxX, x); minY = Mathf.Min(minY, y); maxY = Mathf.Max(maxY, y);
            }
            return Rect.MinMaxRect(minX, minY, maxX, maxY);
        }

        /// <summary>The rendered bounding box matches the projected card to within ~2 px (edge AA).</summary>
        void AssertMatchesCard(string what, Shot s, Rect expected)
        {
            Assert.Greater(s.Label, 0, what + ": not visible");
            string got = " (got x " + s.minX + ".." + s.maxX + ", y " + s.minY + ".." + s.maxY + "; expected x " +
                         expected.xMin.ToString("F1") + ".." + expected.xMax.ToString("F1") + ", y " +
                         expected.yMin.ToString("F1") + ".." + expected.yMax.ToString("F1") + ")";
            Assert.AreEqual(expected.xMin, s.minX, 2f, what + ": left edge" + got);
            Assert.AreEqual(expected.xMax, s.maxX + 1, 2f, what + ": right edge" + got);
            Assert.AreEqual(expected.yMin, s.minY, 2f, what + ": bottom edge" + got);
            Assert.AreEqual(expected.yMax, s.maxY + 1, 2f, what + ": top edge" + got);
        }

        // ---------------------------------------------------------------- mirrors

        // The standard Unity planar-mirror camera, which is what VRChat's mirror is: the viewer's view
        // matrix times a reflection across the mirror plane, an oblique projection that clips at
        // the plane, and inverted culling (the reflection flips handedness). The mirror texture is
        // shown at the same screen positions, so this render IS what the viewer sees in the mirror.
        // Layout: ncho faces +_front; the mirror stands 1.5 m in front of the chest, facing ncho;
        // the viewer stands 0.5 m in front of ncho, looking into the mirror.
        void SetupMirrorCamera(float viewerYawDegrees = 0f)
        {
            ResetCamera();
            var planePoint = _chestAnchor + _front * 1.5f;
            var n = -_front;                       // the mirror's normal points at the viewer / ncho side
            var viewerPos = _chestAnchor + _front * 0.5f;
            _camGo.transform.position = viewerPos;
            _camGo.transform.rotation = Quaternion.AngleAxis(viewerYawDegrees, Vector3.up)
                                      * Quaternion.LookRotation(_front, Vector3.up);
            var viewer = _cam.worldToCameraMatrix;

            float d = -Vector3.Dot(n, planePoint);
            var r = Matrix4x4.identity;
            r.m00 = 1 - 2 * n.x * n.x; r.m01 = -2 * n.x * n.y;    r.m02 = -2 * n.x * n.z;    r.m03 = -2 * d * n.x;
            r.m10 = -2 * n.y * n.x;    r.m11 = 1 - 2 * n.y * n.y; r.m12 = -2 * n.y * n.z;    r.m13 = -2 * d * n.y;
            r.m20 = -2 * n.z * n.x;    r.m21 = -2 * n.z * n.y;    r.m22 = 1 - 2 * n.z * n.z; r.m23 = -2 * d * n.z;
            _cam.worldToCameraMatrix = viewer * r;

            var w2c = _cam.worldToCameraMatrix;
            var cpos = w2c.MultiplyPoint(planePoint + n * 0.01f);
            var cnormal = w2c.MultiplyVector(n).normalized;
            _cam.projectionMatrix = _cam.CalculateObliqueMatrix(
                new Vector4(cnormal.x, cnormal.y, cnormal.z, -Vector3.Dot(cpos, cnormal)));

            // Like VRChat's mirror camera, it sits at the REFLECTED eye position. The custom
            // worldToCameraMatrix stays in force; this moves _WorldSpaceCameraPos to match.
            _mirrorEye = r.MultiplyPoint(viewerPos);
            _camGo.transform.position = _mirrorEye;
        }

        Vector3 _mirrorEye;

        /// <summary>Renders the mirror view. vrchatGlobal sets _VRChatMirrorMode as VRChat does for
        /// mirror renders; false leaves only the oblique-projection fallback to detect it.</summary>
        Shot RenderMirror(bool vrchatGlobal = true, float viewerYawDegrees = 0f)
        {
            SetupMirrorCamera(viewerYawDegrees);
            Shader.SetGlobalFloat("_VRChatMirrorMode", vrchatGlobal ? 1f : 0f);
            Shader.SetGlobalVector("_VRChatMirrorCameraPos", vrchatGlobal ? _mirrorEye : Vector3.zero);
            try { return Capture(true); }
            finally { Shader.SetGlobalFloat("_VRChatMirrorMode", 0f); }
        }

        [Test]
        public void Mirror_SeesTheLabels()
        {
            Assert.Greater(RenderMirror().Label, 0, "the label should appear in the mirror by default");
        }

        [Test]
        public void Mirror_ObliqueFallback_DetectsOffAxisMirror_ButNotHeadOn()
        {
            // Without VRChat's global, detection falls back to the projection's oblique z-row terms.
            Assert.Greater(RenderMirror(vrchatGlobal: false, viewerYawDegrees: 12f).Label, 0,
                "test setup: the label should be in frame for the off-axis mirror view");
            _mat.SetFloat("_HideInMirror", 1f);
            Assert.AreEqual(0, RenderMirror(vrchatGlobal: false, viewerYawDegrees: 12f).Label,
                "fallback should detect a mirror viewed off-axis");
            // Documented blind spot: head-on, the oblique x/y terms are exactly zero. This is why
            // the shader reads _VRChatMirrorMode first. If this starts hiding, the fallback has
            // changed: update docs/callouts.md.
            Assert.Greater(RenderMirror(vrchatGlobal: false, viewerYawDegrees: 0f).Label, 0,
                "head-on mirror without the VRChat global is expected to be missed by the fallback");
        }

        [Test]
        public void Mirror_HideInMirror_HidesOnlyInMirrors()
        {
            _mat.SetFloat("_HideInMirror", 1f);
            Assert.AreEqual(0, RenderMirror().Label, "_HideInMirror = 1 should hide labels in the mirror");
            Assert.Greater(Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor).Label, 0,
                "_HideInMirror = 1 must not hide labels for a normal camera");
        }

        [Test]
        public void Mirror_TextReadsForwards_UnlessMirrorFlip()
        {
            UseAsymmetricTexture();
            var normal = Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor);
            Assert.Less(normal.MeanWhiteX, normal.MeanYellowX, "normal camera: text should read left-to-right");

            var mirror = RenderMirror();
            Assert.Greater(mirror.white, 0); Assert.Greater(mirror.yellow, 0);
            Assert.Less(mirror.MeanWhiteX, mirror.MeanYellowX, "mirror: text should read forwards by default");

            _mat.SetFloat("_MirrorFlip", 1f);
            var flipped = RenderMirror();
            Assert.Greater(flipped.MeanWhiteX, flipped.MeanYellowX, "mirror + _MirrorFlip: text should be reversed");
            var normalFlip = Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor);
            Assert.Less(normalFlip.MeanWhiteX, normalFlip.MeanYellowX, "_MirrorFlip must only affect mirrors");
        }

        /// <summary>The arm label must sit on the far side of its arm from the body centre, on screen.</summary>
        void AssertArmLabelOutside(string view, int armId, Shot s)
        {
            var anchor = AnchorWorld(armId);
            float ax = ScreenX(anchor), ox = ScreenX(RootWorld);
            Assert.Greater(s.Label, 0, view + ": arm label " + armId + " not visible");
            Assert.Greater(Mathf.Abs(ax - ox), 5f, view + ": arm anchor too close to the body centre to judge");
            Assert.AreEqual(Mathf.Sign(ax - ox), Mathf.Sign(s.CentreX - ox),
                view + ": label " + armId + " is on the wrong side of the body (anchor x " + ax + ", centre x " + ox + ", label x " + s.CentreX + ")");
            Assert.Greater(Mathf.Abs(s.CentreX - ox), Mathf.Abs(ax - ox),
                view + ": label " + armId + " should be further out than its anchor");
        }

        [Test]
        public void AutoSide_PutsArmLabelsOutside_ForCameraAndMirror()
        {
            _mat.SetFloat("_LayoutMode", 1f);   // auto-side is a Callout-layout feature
            foreach (var arm in new[] { 4, 5 })
            {
                SetOn(leftArm: arm == 4 ? 1 : 0, rightArm: arm == 5 ? 1 : 0);
                AssertArmLabelOutside("front camera", arm, Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor));
                AssertArmLabelOutside("back camera", arm, Render(BackCam(_avatarHeight * 1.5f), _chestAnchor));
                AssertArmLabelOutside("mirror", arm, RenderMirror());
            }
        }

        // ---------------------------------------------------------------- VR

        [Test]
        public void Stereo_InstancedVariant_Compiles()
        {
            // VRChat PC renders single-pass instanced: Unity compiles every shader with
            // STEREO_INSTANCING_ON. Compile that variant explicitly; the desktop variant is the
            // only one the rest of this suite exercises.
            var shader = AssetDatabase.LoadAssetAtPath<Shader>(ShaderPath);
            var pass = ShaderUtil.GetShaderData(shader).GetSubshader(0).GetPass(0);
            var report = new StringBuilder();
            byte[] monoVs = null, stereoVs = null;
            foreach (var keywords in new[] { new string[0], new[] { "STEREO_INSTANCING_ON" } })
            foreach (var stage in new[] { UnityEditor.Rendering.ShaderType.Vertex, UnityEditor.Rendering.ShaderType.Fragment })
            {
                var info = pass.CompileVariant(stage, keywords, UnityEditor.Rendering.ShaderCompilerPlatform.D3D,
                                               BuildTarget.StandaloneWindows64);
                string tag = stage + (keywords.Length > 0 ? " [" + keywords[0] + "]" : " [mono]");
                if (!info.Success) report.AppendLine(tag + " FAILED");
                foreach (var m in info.Messages)
                    if (m.severity == UnityEditor.Rendering.ShaderCompilerMessageSeverity.Error)
                        report.AppendLine(tag + ": " + m.message + " (" + m.file + ":" + m.line + ")");
                if (stage == UnityEditor.Rendering.ShaderType.Vertex)
                {
                    if (keywords.Length == 0) monoVs = info.ShaderData; else stereoVs = info.ShaderData;
                }
            }
            Assert.IsEmpty(report.ToString(), report.ToString());
            Assert.IsNotNull(monoVs); Assert.IsNotNull(stereoVs);
            Assert.IsFalse(monoVs.SequenceEqual(stereoVs),
                "the stereo-instanced vertex shader is identical to the mono one: the stereo macros are not taking effect");
        }

        const float Ipd = 0.064f;

        /// <summary>One eye of a headset: offset half the IPD along the head's right axis, looking
        /// straight ahead (parallel eyes), with a real per-eye ASYMMETRIC frustum, wider on the
        /// outer side as headset eye projections are.</summary>
        void SetupEye(bool left, Vector3 head, Vector3 lookDir)
        {
            ResetCamera();
            var rot = Quaternion.LookRotation(lookDir, Vector3.up);
            _camGo.transform.rotation = rot;
            _camGo.transform.position = head + rot * Vector3.right * (left ? -Ipd : Ipd) * 0.5f;
            float n = _cam.nearClipPlane, f = _cam.farClipPlane;
            float t = n * Mathf.Tan(50f * Mathf.Deg2Rad);
            float width = 2f * t * W / H, outer = width * 0.57f, inner = width - outer;
            _cam.projectionMatrix = left ? Matrix4x4.Frustum(-outer, inner, -t, t, n, f)
                                         : Matrix4x4.Frustum(-inner, outer, -t, t, n, f);
        }

        /// <summary>View-space direction (x/z, y/z) of a screen pixel through the current camera:
        /// exactly the quantity the ncho HUD positions its content by (CSUV.cginc).</summary>
        Vector2 ViewDirection(float px, float py)
        {
            var ndc = new Vector4(px / W * 2f - 1f, py / H * 2f - 1f, 1f, 1f);
            var v = _cam.projectionMatrix.inverse * ndc;
            return new Vector2(v.x / v.z, v.y / v.z);
        }

        [Test]
        public void Stereo_DefaultIsCard()
        {
            // Match HUD (infinity) was nauseating in-headset (2026-11-10); Card is the default.
            var shader = AssetDatabase.LoadAssetAtPath<Shader>(ShaderPath);
            int i = shader.FindPropertyIndex("_StereoDepth");
            Assert.GreaterOrEqual(i, 0, "_StereoDepth missing");
            Assert.AreEqual(1f, shader.GetPropertyDefaultFloatValue(i), "_StereoDepth should default to Card (1)");
        }

        [Test]
        public void Stereo_MatchHudMode_IsAtInfinity()
        {
            // The HUD puts each feature at the same view-space direction in each eye: zero disparity,
            // optical infinity. In Match HUD mode the tooltips must do the same: identical view
            // direction in both eyes, while still depth-testing _DepthPush in front of the anchor.
            _mat.SetFloat("_StereoDepth", 0f);
            var head = FrontCam(1.2f);
            Shader.SetGlobalVector("_CalloutTestEyeCentre", new Vector4(head.x, head.y, head.z, 1f));
            foreach (var id in new[] { 0, 4 })
            {
                SetOn(chest: id == 0 ? 1 : 0, leftArm: id == 4 ? 1 : 0);
                SetupEye(true, head, -_front);
                var l = Capture(false);
                AssertMatchesCard("tooltip " + id + " left eye", l, ExpectedCardBox(id, head, eyeLocked: true));
                var dirL = ViewDirection(l.CentreX + 0.5f, (l.minY + l.maxY) * 0.5f + 0.5f);
                float tol = 2.5f * 2f / W / _cam.projectionMatrix.m00;   // ~2.5 px, in x/z units
                SetupEye(false, head, -_front);
                var r = Capture(false);
                AssertMatchesCard("tooltip " + id + " right eye", r, ExpectedCardBox(id, head, eyeLocked: true));
                var dirR = ViewDirection(r.CentreX + 0.5f, (r.minY + r.maxY) * 0.5f + 0.5f);
                Assert.AreEqual(dirL.x, dirR.x, tol, "tooltip " + id + ": eyes see it in different directions " +
                    "(" + dirL + " vs " + dirR + "); the HUD's content has none, so they'd sit at different depths");
                Assert.AreEqual(dirL.y, dirR.y, tol, "tooltip " + id + ": vertical direction differs between eyes");
            }

            // ...and it still depth-tests as the card _DepthPush (0.35 m) in front of the anchor, per eye.
            SetOn(chest: 1);
            var behindCard = Wall(_chestAnchor + _front * 0.2f, _front, 3f);
            foreach (var left in new[] { true, false })
            {
                SetupEye(left, head, -_front);
                Assert.Greater(Capture(false).Label, 0, (left ? "left" : "right") +
                    " eye: a wall 0.20 m in front of the anchor is behind the card and must not hide it");
            }
            Object.DestroyImmediate(behindCard);
            Wall(_chestAnchor + _front * 0.5f, _front, 3f);
            foreach (var left in new[] { true, false })
            {
                SetupEye(left, head, -_front);
                Assert.AreEqual(0, Capture(false).Label, (left ? "left" : "right") +
                    " eye: a wall 0.50 m in front of the anchor is in front of the card and must hide it");
            }
        }

        [Test]
        public void Stereo_CardMode_FusesAtThePushedDepth()
        {
            _mat.SetFloat("_StereoDepth", 1f);
            // Close enough that "at the anchor" and "_DepthPush in front of it" differ by several
            // pixels of disparity, so the test can tell them apart.
            var head = FrontCam(1.2f);
            // In VRChat (stereo instanced) the shader builds ONE card from the centre eye. Two mono
            // cameras can't reach that path, so pin the centre eye through the test hook.
            Shader.SetGlobalVector("_CalloutTestEyeCentre", new Vector4(head.x, head.y, head.z, 1f));
            float push = _mat.GetFloat("_DepthPush");
            foreach (var id in new[] { 0, 4 })   // a centre-line tooltip and a side tooltip
            {
                SetOn(chest: id == 0 ? 1 : 0, leftArm: id == 4 ? 1 : 0);
                var anchor = AnchorWorld(id);
                float dist = Vector3.Distance(head, anchor);
                var pushedCentre = head + (anchor - head).normalized * Mathf.Max(dist - push, dist * 0.5f);

                SetupEye(true, head, -_front);
                var l = Capture(false); float anchorL = ScreenX(anchor), pushedL = ScreenX(pushedCentre);
                SetupEye(false, head, -_front);
                var r = Capture(false); float anchorR = ScreenX(anchor), pushedR = ScreenX(pushedCentre);

                // Both eyes must see the SAME world card (built from the centre eye). A real card off to
                // the side legitimately projects a little narrower in the eye that sees it more
                // obliquely, so compare each eye against that card's projection, not eye against eye.
                SetupEye(true, head, -_front);
                AssertMatchesCard("tooltip " + id + " left eye", l, ExpectedCardBox(id, head));
                SetupEye(false, head, -_front);
                AssertMatchesCard("tooltip " + id + " right eye", r, ExpectedCardBox(id, head));
                Assert.AreEqual(l.minY, r.minY, 1f, "tooltip " + id + ": vertical mismatch between eyes");

                float labelDisparity = l.CentreX - r.CentreX;
                float pushedDisparity = pushedL - pushedR, anchorDisparity = anchorL - anchorR;
                Assert.Greater(Mathf.Abs(pushedDisparity - anchorDisparity), 3f,
                    "test setup: pushed and anchor depths too close to tell apart");
                Assert.AreEqual(pushedDisparity, labelDisparity, 1.5f,
                    "tooltip " + id + ": disparity " + labelDisparity + " px; expected " + pushedDisparity +
                    " px (the card _DepthPush in front of its anchor). Anchor depth would be " + anchorDisparity + " px");
            }
        }

        // ---------------------------------------------------------------- billboard

        [Test]
        public void Billboard_FacesCameraPosition_NotCameraRotation()
        {
            // Same camera position, turned so the tooltip sits off-axis. A card that copies the
            // camera's rotation stays parallel to the image plane, so it keeps its on-axis size. A card
            // that LOOKS AT the camera is tilted against the image plane off-axis; its near edge is
            // closer, so it projects visibly taller. Compare against the exact projected card.
            _mat.SetFloat("_LabelHeight", 0.1f);   // bigger, for a precise measurement
            var pos = FrontCam(_avatarHeight * 1.5f);
            var onAxis = Render(pos, _chestAnchor);
            AssertMatchesCard("on-axis", onAxis, ExpectedCardBox(0, pos));
            const float yaw = 30f;
            ResetCamera();
            _camGo.transform.position = pos;
            _camGo.transform.rotation = Quaternion.AngleAxis(yaw, Vector3.up) * Quaternion.LookRotation(_chestAnchor - pos, Vector3.up);
            var offAxis = Capture(false);
            Assert.Greater(Mathf.Abs(offAxis.CentreX - W * 0.5f), W * 0.15f, "test setup: tooltip should be well off-centre");
            AssertMatchesCard("off-axis", offAxis, ExpectedCardBox(0, pos));
            Assert.Greater(offAxis.Height, onAxis.Height + 5f,
                "off-axis the card should project taller (it faces the camera position); the same height " +
                "would mean it copies the camera's rotation");
        }

        [Test]
        public void Billboard_MatchesCameraRoll()
        {
            // Rolled camera: if the card matches roll it stays upright on screen, so its screen-space
            // bounding box is unchanged. A world-upright card would appear tilted, with a bigger box.
            var pos = FrontCam(_avatarHeight * 1.5f);
            var level = Render(pos, _chestAnchor);
            ResetCamera();
            _camGo.transform.position = pos;
            _camGo.transform.rotation = Quaternion.LookRotation(_chestAnchor - pos, Vector3.up)
                                      * Quaternion.AngleAxis(30f, Vector3.forward);
            var rolled = Capture(false);
            Assert.AreEqual(level.Height, rolled.Height, 1.5f, "rolled camera: the tooltip should roll with it");
            Assert.AreEqual(level.maxX - level.minX, rolled.maxX - rolled.minX, 1.5f, "rolled camera: the tooltip should roll with it");
        }

        // ---------------------------------------------------------------- layout and art

        [Test]
        public void Centered_ArtIsCentredOnItsAnchor_WithNoLeaderLine()
        {
            var cam = FrontCam(_avatarHeight * 1.5f);
            var s = Render(cam, _chestAnchor);
            float cy = (s.minY + s.maxY) * 0.5f;
            Assert.AreEqual(W * 0.5f, s.CentreX, 1.5f, "Centered: the art should be centred on its anchor (x)");
            Assert.AreEqual(H * 0.5f, cy, 1.5f, "Centered: the art should be centred on its anchor (y)");
            Assert.AreEqual(0, s.green, "Centered layout draws no leader line");

            _mat.SetFloat("_LayoutMode", 1f);
            var callout = Render(cam, _chestAnchor);
            Assert.Greater(callout.green, 0, "Callout layout should draw a leader line");
            Assert.Greater(Mathf.Abs(callout.CentreX - W * 0.5f), 10f, "Callout layout should offset the label");
        }

        [Test]
        public void PixelArt_KeepsTexelsCrisp()
        {
            // A 4x4-texel checker per cell, magnified ~18x. Plain bilinear smears every texel edge
            // across many pixels; pixel-art sampling keeps each edge to about one pixel.
            var checker = new Texture2D(16, 16, TextureFormat.RGBA32, false) { hideFlags = HideFlags.HideAndDontSave };
            checker.filterMode = FilterMode.Bilinear;
            checker.wrapMode = TextureWrapMode.Clamp;
            var px = new Color32[256];
            for (int i = 0; i < 256; i++)
                px[i] = ((i % 16) + (i / 16)) % 2 == 0 ? new Color32(255, 255, 255, 255) : new Color32(255, 255, 0, 255);
            checker.SetPixels32(px); checker.Apply();
            _trash.Add(checker);
            _mat.SetTexture("_MainTex", checker);
            _mat.SetFloat("_LabelHeight", 0.1f);

            int Smeared()
            {
                Render(FrontCam(_avatarHeight * 1.5f), _chestAnchor);
                var prev = RenderTexture.active;
                var tex = new Texture2D(W, H, TextureFormat.RGBA32, false);
                try
                {
                    RenderTexture.active = _rt;
                    tex.ReadPixels(new Rect(0, 0, W, H), 0, 0); tex.Apply();
                    int n = 0;
                    foreach (var c in tex.GetPixels32())
                        if (c.r > 240 && c.g > 240 && c.b > 30 && c.b < 225) n++;   // between white and yellow
                    return n;
                }
                finally { RenderTexture.active = prev; Object.DestroyImmediate(tex); }
            }

            _mat.SetFloat("_PixelArt", 0f);
            int bilinear = Smeared();
            _mat.SetFloat("_PixelArt", 1f);
            int crisp = Smeared();
            Assert.Greater(bilinear, 500, "test setup: plain bilinear should smear visibly");
            Assert.Less(crisp, bilinear / 4, "pixel-art sampling: " + crisp + " smeared pixels vs " + bilinear + " bilinear");
        }

        [Test]
        public void Stereo_AsymmetricEyeProjection_IsNotMistakenForAMirror()
        {
            // Per-eye headset projections are off-centre. The mirror test looks at the projection's
            // oblique z row; an asymmetric frustum must not trip it.
            _mat.SetFloat("_HideInMirror", 1f);
            _mat.SetFloat("_MirrorFlip", 1f);
            UseAsymmetricTexture();
            var head = FrontCam(_avatarHeight * 1.5f);
            foreach (var left in new[] { true, false })
            {
                SetupEye(left, head, -_front);
                var s = Capture(false);
                Assert.Greater(s.Label, 0, (left ? "left" : "right") + " eye: label hidden as if in a mirror");
                Assert.Less(s.MeanWhiteX, s.MeanYellowX, (left ? "left" : "right") + " eye: text flipped as if in a mirror");
            }
        }
    }
}
