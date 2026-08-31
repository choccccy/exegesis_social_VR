using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Exegesis.Shared
{
    /// <summary>
    /// Dumps every sub-object of an imported model asset with its local file ID.
    ///
    /// Unity derives a model sub-object's local file ID from its NAME. Rename a bone in
    /// Blender and every scene reference to it - PhysBone roots, m_CorrespondingSourceObject
    /// on the instantiated GameObjects and Transforms, prefab modification targets - silently
    /// stops resolving, because the ID it points at no longer exists. There is no error; the
    /// reference just goes missing.
    ///
    /// Repairing that needs the name -> fileID map from BOTH sides of the rename, and the
    /// "before" side cannot be reconstructed once the FBX has been reimported. The .meta's
    /// internalIDToNameTable is empty for these assets, so this is the only source. Dump
    /// before renaming, dump again after, and join the two through the rename table.
    ///
    /// Run headlessly (the project must not be open in an Editor - Unity locks it):
    ///   Tools/unity-repair/dump_fbx_ids.ps1 -Out before.json
    /// or from the menu: Tools > Exegesis > Debug > Dump FBX File IDs.
    ///
    /// See docs/rigging.md.
    /// </summary>
    public static class FbxIdDump
    {
        private static readonly string[] DefaultAssets =
        {
            "Assets/_exegesis/ncho/ncho.fbx",
            "Assets/_exegesis/obi-me/obi-me.fbx",
        };

        [MenuItem("Tools/Exegesis/Debug/Dump FBX File IDs")]
        public static void DumpFromMenu()
        {
            var path = EditorUtility.SaveFilePanel("Dump FBX file IDs", "", "fbx_ids.json", "json");
            if (string.IsNullOrEmpty(path)) return;
            Debug.Log(Dump(DefaultAssets, path));
        }

        /// <summary>Batch entry point. Reads -fbxIdOut &lt;path&gt; and optional -fbxAsset &lt;path&gt;.</summary>
        public static void DumpFromCommandLine()
        {
            var args = Environment.GetCommandLineArgs();
            var outPath = ArgValue(args, "-fbxIdOut");
            if (string.IsNullOrEmpty(outPath))
            {
                Debug.LogError("FbxIdDump: -fbxIdOut <path> is required");
                EditorApplication.Exit(2);
                return;
            }

            var assets = ArgValues(args, "-fbxAsset").ToArray();
            if (assets.Length == 0) assets = DefaultAssets;

            try
            {
                var summary = Dump(assets, outPath);
                Debug.Log(summary);
                Console.WriteLine(summary);
                EditorApplication.Exit(0);
            }
            catch (Exception e)
            {
                Debug.LogError("FbxIdDump failed: " + e);
                EditorApplication.Exit(1);
            }
        }

        /// <summary>
        /// Writes {assetPath: {guid, objects: [{name, type, fileId}]}} as JSON.
        /// Hand-rolled rather than JsonUtility: nested dictionaries and long values are
        /// exactly what JsonUtility cannot express, and the file has to be diffable.
        /// </summary>
        public static string Dump(IEnumerable<string> assetPaths, string outPath)
        {
            var json = new StringBuilder();
            json.Append("{\n");

            var counts = new List<string>();
            var assets = assetPaths.ToList();
            for (var a = 0; a < assets.Count; a++)
            {
                var assetPath = assets[a];
                var guid = AssetDatabase.AssetPathToGUID(assetPath);
                if (string.IsNullOrEmpty(guid))
                    throw new FileNotFoundException("no such asset: " + assetPath);

                // Force the import to be current, so the IDs we record are the IDs on disk.
                AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.ForceSynchronousImport);

                var entries = new List<(string Name, string Type, long FileId)>();
                foreach (var obj in AssetDatabase.LoadAllAssetsAtPath(assetPath))
                {
                    if (obj == null) continue;
                    if (!AssetDatabase.TryGetGUIDAndLocalFileIdentifier(obj, out _, out long fileId))
                        continue;
                    entries.Add((obj.name, obj.GetType().Name, fileId));
                }

                entries.Sort((x, y) =>
                {
                    var byName = string.CompareOrdinal(x.Name, y.Name);
                    return byName != 0 ? byName : string.CompareOrdinal(x.Type, y.Type);
                });

                json.Append("  ").Append(Quote(assetPath)).Append(": {\n");
                json.Append("    \"guid\": ").Append(Quote(guid)).Append(",\n");
                json.Append("    \"objects\": [\n");
                for (var i = 0; i < entries.Count; i++)
                {
                    var e = entries[i];
                    json.Append("      {\"name\": ").Append(Quote(e.Name))
                        .Append(", \"type\": ").Append(Quote(e.Type))
                        .Append(", \"fileId\": ").Append(e.FileId).Append("}");
                    json.Append(i == entries.Count - 1 ? "\n" : ",\n");
                }
                json.Append("    ]\n  }");
                json.Append(a == assets.Count - 1 ? "\n" : ",\n");

                counts.Add(string.Format("{0}: {1} objects", assetPath, entries.Count));
            }
            json.Append("}\n");

            var directory = Path.GetDirectoryName(Path.GetFullPath(outPath));
            if (!string.IsNullOrEmpty(directory)) Directory.CreateDirectory(directory);
            File.WriteAllText(outPath, json.ToString(), new UTF8Encoding(false));

            return "FbxIdDump wrote " + outPath + "  (" + string.Join("; ", counts) + ")";
        }

        private static string ArgValue(string[] args, string flag)
        {
            return ArgValues(args, flag).FirstOrDefault();
        }

        private static IEnumerable<string> ArgValues(string[] args, string flag)
        {
            for (var i = 0; i < args.Length - 1; i++)
                if (args[i] == flag)
                    yield return args[i + 1];
        }

        private static string Quote(string value)
        {
            return "\"" + value.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"";
        }
    }
}
