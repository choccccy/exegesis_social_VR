// Scripts README install step "enable the PS1 module" for Tools/install-test, the way
// Poi > Installed Modules > Apply & Rebuild Shaders does it. Needs Poiyomi installed, so it
// sits outside any asmdef. Poi's own rebuild waits on EditorApplication.delayCall, which
// batchmode never reaches before -quit, so this calls ShaderGenerator directly.
using System;
using System.IO;
using System.Linq;
using System.Text;
using Poi.Tools;
using Poiyomi.ModularShaderSystem;
using UnityEditor;
using UnityEngine;

public static class InstallCheckPs1Step
{
    const string Ps1Guid = "6d3727a2d7b196646939c62c71b6d0f8";

    public static void Run()
    {
        var sb = new StringBuilder();
        try
        {
            PoiUserModules.InvalidateCaches();
            var entries = PoiUserModules.Discover();
            sb.AppendLine("discovered user modules:");
            foreach (var e in entries)
                sb.AppendLine("  " + e.DisplayName + " guid=" + e.Guid + " enabled=" + e.Enabled + " error=" + (e.Error ?? "none") + " path=" + e.AssetPath);
            var ps1 = entries.FirstOrDefault(e => e.Guid == Ps1Guid);
            if (ps1 == null) { sb.AppendLine("PS1 MODULE NOT DISCOVERED"); return; }
            if (!ps1.IsUsable) { sb.AppendLine("PS1 MODULE NOT USABLE: " + ps1.Error); return; }
            PoiUserModules.SetEnabled(Ps1Guid, true);
            PoiUserModules.Save();
            PoiUserModules.InvalidateCaches();
            entries = PoiUserModules.Discover();
            var targets = PoiUserModules.GetTargetShaders();
            var enabled = PoiUserModules.GetEnabledModules(entries);
            sb.AppendLine("targets: " + targets.Count + ", enabled modules: " + enabled.Count);
            PoiUserModules.ApplyToShaderAssets(targets, enabled);
            PoiUserModules.MarkRebuildPending(targets);
            // Same call Poi's Modules Toggles uses; the window path defers via delayCall, which batchmode never runs.
            int ok = 0;
            foreach (var sh in targets)
            {
                try
                {
                    ShaderGenerator.GenerateShader(ShaderDestinationManager.Instance.GetDestinationFromShaderName(sh.Name), sh);
                    ok++;
                }
                catch (Exception gex) { sb.AppendLine("  GEN FAIL " + sh.Name + ": " + gex.Message); }
            }
            PoiUserModules.MarkRebuilt(targets);
            sb.AppendLine("generated " + ok + "/" + targets.Count);
            AssetDatabase.Refresh();
        }
        catch (Exception ex) { sb.AppendLine("EXCEPTION: " + ex); }
        finally
        {
            File.WriteAllText(Environment.GetEnvironmentVariable("INSTALLCHECK_OUT") ?? "ps1step.txt", sb.ToString());
        }
    }

    // Run in a fresh session after the rebuild: do materials that set PS1 values now see the properties?
    public static void Verify()
    {
        var sb = new StringBuilder();
        foreach (var g in AssetDatabase.FindAssets("t:Material", new[] { "Assets/_exegesis" }))
        {
            var p = AssetDatabase.GUIDToAssetPath(g);
            var text = File.ReadAllText(p);
            if (!text.Contains("_EnablePS1Module")) continue;
            var m = AssetDatabase.LoadAssetAtPath<Material>(p);
            bool has = m.HasProperty("_EnablePS1Module");
            float v = has ? m.GetFloat("_EnablePS1Module") : -1;
            bool kw = m.IsKeywordEnabled("POI_PS1_MODULE");
            sb.AppendLine((has ? "OK   " : "MISS ") + p + " shader=" + m.shader.name + " _EnablePS1Module=" + v + " keyword=" + kw
                + " shaderErr=" + ShaderUtil.ShaderHasError(m.shader));
        }
        File.WriteAllText(Environment.GetEnvironmentVariable("INSTALLCHECK_OUT") ?? "ps1verify.txt", sb.ToString());
    }
}
