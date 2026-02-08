using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class TMPAutoImporter : AssetPostprocessor
{
    private static readonly string packagePath = "Packages/com.unity.textmeshpro/Package Resources/TMP Essential Resources.unitypackage";

    private static readonly string folderToCheck = "Assets/TextMesh Pro";

    [InitializeOnLoadMethod]
    private static void OnProjectLoadedInEditor()
    {
        if (!System.IO.Directory.Exists(folderToCheck))
        {
            ImportPackage();
        }
        else
        {
            Debug.Log("Found TMP Essential Resources in this Unity Project.");
        }
    }

    private static void ImportPackage()
    {
        Debug.Log("TMP Essential Resources does not exist in project. BluWizard LABS will now auto-import TMP Resources...");
        AssetDatabase.ImportPackage(packagePath, false);
        Debug.Log("TMP Essential Resources was imported successfully.");
    }
}