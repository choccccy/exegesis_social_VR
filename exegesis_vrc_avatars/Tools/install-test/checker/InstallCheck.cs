// Install checker for Tools/install-test. Copied into a scratch test project by
// run_install_test.ps1; never lives under the real project's Assets/. Writes a report to
// $INSTALLCHECK_OUT. See docs/testing.md > Clean-room install test.
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class InstallCheck
{
    static readonly string[] Roots = { "Assets/_exegesis", "Assets/Editor/Poi_PS1" };
    static readonly HashSet<string> YamlExt = new HashSet<string> {
        ".mat", ".prefab", ".unity", ".controller", ".anim", ".asset", ".overrideController",
        ".mask", ".physicMaterial", ".playable", ".poiTemplateCollection", ".meta" };
    static readonly Regex GuidRe = new Regex(@"guid: ([0-9a-f]{32})");

    public static void Run()
    {
        var outPath = Environment.GetEnvironmentVariable("INSTALLCHECK_OUT") ?? "installcheck.txt";
        var sb = new StringBuilder();
        try { RunInner(sb); }
        catch (Exception e) { sb.AppendLine("CHECKER EXCEPTION: " + e); }
        File.WriteAllText(outPath, sb.ToString());
    }

    static IEnumerable<string> Files()
    {
        foreach (var r in Roots)
            if (Directory.Exists(r))
                foreach (var f in Directory.GetFiles(r, "*", SearchOption.AllDirectories))
                    yield return f.Replace(Path.DirectorySeparatorChar, '/');
    }

    static void RunInner(StringBuilder sb)
    {
        var files = Files().ToList();
        sb.AppendLine("files under roots: " + files.Count);
        foreach (var r in Roots) sb.AppendLine("  root " + r + " exists=" + Directory.Exists(r));

        // 1. Unresolved GUIDs
        var missing = new Dictionary<string, SortedSet<string>>();
        foreach (var f in files)
        {
            if (!YamlExt.Contains(Path.GetExtension(f))) continue;
            string text;
            try { text = File.ReadAllText(f); } catch { continue; }
            if (!text.StartsWith("%YAML") && !f.EndsWith(".meta")) continue;
            foreach (Match m in GuidRe.Matches(text))
            {
                var g = m.Groups[1].Value;
                if (g.StartsWith("0000000000000000")) continue; // built-in resources
                var p = AssetDatabase.GUIDToAssetPath(g);
                bool ok = !string.IsNullOrEmpty(p) && (File.Exists(p) || Directory.Exists(p));
                if (!ok)
                {
                    if (!missing.TryGetValue(g, out var set)) missing[g] = set = new SortedSet<string>();
                    set.Add(f);
                }
            }
        }
        sb.AppendLine();
        sb.AppendLine("== UNRESOLVED GUIDS: " + missing.Count);
        foreach (var kv in missing.OrderByDescending(k => k.Value.Count))
        {
            sb.AppendLine("  " + kv.Key + "  (" + kv.Value.Count + " files)");
            foreach (var f in kv.Value.Take(8)) sb.AppendLine("      " + f);
            if (kv.Value.Count > 8) sb.AppendLine("      ...");
        }

        // 2. Materials
        sb.AppendLine();
        var bad = new List<string>();
        var shaderUse = new Dictionary<string, int>();
        foreach (var f in files.Where(f => f.EndsWith(".mat")))
        {
            var mat = AssetDatabase.LoadAssetAtPath<Material>(f);
            if (mat == null) { bad.Add(f + " : failed to load"); continue; }
            var sh = mat.shader;
            var name = sh == null ? "<null>" : sh.name;
            shaderUse[name] = shaderUse.TryGetValue(name, out var c) ? c + 1 : 1;
            if (sh == null || name == "Hidden/InternalErrorShader")
                bad.Add(f + " : shader " + name);
            else if (ShaderUtil.ShaderHasError(sh))
                bad.Add(f + " : shader has errors: " + name);
        }
        sb.AppendLine("== BAD MATERIALS: " + bad.Count);
        foreach (var b in bad) sb.AppendLine("  " + b);
        sb.AppendLine("  shaders in use:");
        foreach (var kv in shaderUse.OrderBy(k => k.Key)) sb.AppendLine("    " + kv.Value + "x " + kv.Key);

        // 3. Prefabs
        sb.AppendLine();
        var pf = new List<string>();
        foreach (var f in files.Where(f => f.EndsWith(".prefab")))
        {
            var go = AssetDatabase.LoadAssetAtPath<GameObject>(f);
            if (go == null) { pf.Add(f + " : failed to load"); continue; }
            ScanHierarchy(go, f, pf);
        }
        sb.AppendLine("== PREFAB PROBLEMS: " + pf.Count);
        foreach (var p in pf) sb.AppendLine("  " + p);

        // 4. Scenes
        sb.AppendLine();
        foreach (var f in files.Where(f => f.EndsWith(".unity")))
        {
            var probs = new List<string>();
            var scene = EditorSceneManager.OpenScene(f, OpenSceneMode.Single);
            var avatars = new List<string>();
            foreach (var root in scene.GetRootGameObjects())
            {
                ScanHierarchy(root, "", probs);
                foreach (var c in root.GetComponentsInChildren<Component>(true))
                    if (c != null && c.GetType().Name == "VRCAvatarDescriptor")
                        avatars.Add(GetPath(c.transform));
            }
            sb.AppendLine("== SCENE " + f + " problems: " + probs.Count);
            sb.AppendLine("  avatars: " + string.Join(", ", avatars));
            foreach (var p in probs) sb.AppendLine("  " + p);
        }
    }

    static void ScanHierarchy(GameObject root, string ctx, List<string> probs)
    {
        foreach (var t in root.GetComponentsInChildren<Transform>(true))
        {
            var go = t.gameObject;
            var path = (ctx == "" ? "" : ctx + " :: ") + GetPath(t);
            int n = GameObjectUtility.GetMonoBehavioursWithMissingScriptCount(go);
            if (n > 0) probs.Add(path + " : " + n + " missing script(s)");
            if (PrefabUtility.IsPrefabAssetMissing(go)) probs.Add(path + " : missing prefab asset");
            var r = go.GetComponent<Renderer>();
            if (r != null)
            {
                var mats = r.sharedMaterials;
                for (int i = 0; i < mats.Length; i++)
                {
                    var m = mats[i];
                    if (m == null) probs.Add(path + " : renderer material slot " + i + " is null/missing");
                    else if (m.shader == null || m.shader.name == "Hidden/InternalErrorShader")
                        probs.Add(path + " : material " + m.name + " has error shader");
                }
                var smr = r as SkinnedMeshRenderer;
                if (smr != null && smr.sharedMesh == null) probs.Add(path + " : SkinnedMeshRenderer mesh missing");
            }
            var mf = go.GetComponent<MeshFilter>();
            if (mf != null && mf.sharedMesh == null) probs.Add(path + " : MeshFilter mesh missing");
        }
    }

    static string GetPath(Transform t)
    {
        var s = t.name;
        while (t.parent != null) { t = t.parent; s = t.name + "/" + s; }
        return s;
    }
}
