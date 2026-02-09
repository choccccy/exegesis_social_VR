using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using Object = UnityEngine.Object;
#if UNITY_EDITOR
using System.IO;
using UnityEditor;
using VRC.SDKBase;
#endif

#if UNITY_EDITOR

class QuickMaterialSwitcher : EditorWindow, IEditorOnly
{
    private List<string> materialPaths, texturePaths;

    private List<SerializedObject> objects = new List<SerializedObject>();
    private List<List<SerializedProperty>> materialGroups;

    private List<List<SerializedProperty>> textures = null;

    private bool mode;
    private bool textureMode;

    [SerializeField]
    private GameObject _target;
    private GameObject Target
    {
        get => _target;
        set
        {
            _target = value;
            OnConfigure();
            Repaint();
        }
    }
    
    [MenuItem("Tools/Quick Material Switcher")]
    static void OpenWindow()
    {
        if (Selection.activeGameObject == null) return;
        var window = GetWindow<QuickMaterialSwitcher>();
        window.Target = Selection.activeGameObject;
        window.Show();
    }
    
    [MenuItem("Tools/Quick Material Switcher", true)]
    static bool ValidateOpenWindow()
    {
        return Selection.activeGameObject != null;
    }

    private void OnEnable()
    {
        OnConfigure();
    }

    private void OnConfigure()
    {
        if (_target == null)
        {
            materialGroups = null;
            return;
        }
        
        objects.Clear();
        
        materialPaths = AssetDatabase.FindAssets("t:Material").Select(AssetDatabase.GUIDToAssetPath)
            .OrderBy(p => p).ToList();
        
        texturePaths = AssetDatabase.FindAssets("t:Texture").Select(AssetDatabase.GUIDToAssetPath)
            .OrderBy(p => p).ToList();
        
        var meshes = _target.GetComponentsInChildren<Renderer>(true);

        Dictionary<Material, List<SerializedProperty>> groups = new Dictionary<Material, List<SerializedProperty>>();
        
        foreach (var mesh in meshes)
        {
            var so = new SerializedObject(mesh);
            objects.Add(so);
            
            var mats = so.FindProperty("m_Materials");
            var n_materials = mats.arraySize;
            
            for (int i = 0; i < n_materials; i++)
            {
                SerializedProperty prop = mats.GetArrayElementAtIndex(i);
                Material mat = prop.objectReferenceValue as Material;
                
                if (mat != null)
                {
                    if (!groups.TryGetValue(mat, out var list))
                    {
                        list = new List<SerializedProperty>();
                        groups.Add(mat, list);
                    }
                    list.Add(prop.Copy());
                }
            }
        }

        Dictionary<Texture, List<SerializedProperty>> textures = new Dictionary<Texture, List<SerializedProperty>>();
        
        foreach (var mat in groups.Keys)
        {
            var so = new SerializedObject(mat);
            objects.Add(so);
            
            var iter = so.FindProperty("m_SavedProperties.m_TexEnvs");
            bool enterChildren = true;
            
            while (iter.Next(enterChildren))
            {
                enterChildren = iter.propertyType != SerializedPropertyType.String;
                
                if (iter.propertyType == SerializedPropertyType.ObjectReference)
                {
                    Texture tex = iter.objectReferenceValue as Texture;
                    if (tex != null)
                    {
                        if (!textures.TryGetValue(tex, out var list))
                        {
                            list = new List<SerializedProperty>();
                            textures.Add(tex, list);
                        }
                        list.Add(iter.Copy());
                    }
                }
            }
        }
        
        this.textures = textures.Values.OrderBy(list => list[0].objectReferenceValue.name)
            .ToList();

        materialGroups = groups.Values.OrderBy(list => list[0].objectReferenceValue.name)
            .ToList();
    }

    public void OnGUI()
    {
        EditorGUI.BeginChangeCheck();
        var newTarget = EditorGUILayout.ObjectField("Target", Target, typeof(GameObject), true) as GameObject;
        if (EditorGUI.EndChangeCheck())
        {
            Target = newTarget;
        }
        
        if (materialGroups == null) return;
        
        mode = EditorGUILayout.Toggle("Group by parent folder", mode);
        textureMode = EditorGUILayout.Toggle("Texture mode", textureMode);

        if (textureMode)
        {
            RenderSlots<Texture>(textures);
        }
        else
        {
            RenderSlots<Material>(materialGroups);
        }
    }

    private void RenderSlots<T>(List<List<SerializedProperty>> groups) where T : UnityEngine.Object
    {
        EditorGUILayout.BeginHorizontal();
        bool allPrev = GUILayout.Button("--");
        bool allNext = GUILayout.Button("++");
        EditorGUILayout.EndHorizontal();
        EditorGUILayout.Separator();
        
        foreach (var group in groups)
        {
            EditorGUILayout.Space();

            var mat = group[0].objectReferenceValue;
            
            EditorGUI.BeginChangeCheck();
            if (mode)
            {
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField(Path.GetFileName(Path.GetDirectoryName(AssetDatabase.GetAssetPath(mat))) + "/");
            }
            var newMat = EditorGUILayout.ObjectField(mat, typeof(T), false) as T;
            if (mode)
            {
                EditorGUILayout.EndHorizontal();
            }
            bool changed = EditorGUI.EndChangeCheck();

            EditorGUILayout.BeginHorizontal();
            T prev, next;
            if (mode)
            {
                FindAdjacentByParentFolder<T>(newMat, out prev, out next);
            }
            else
            {
                FindAdjacent<T>(newMat, out prev, out next);
            }

            using (new EditorGUI.DisabledScope(prev == null))
            {
                if (GUILayout.Button("--") || (allPrev && prev != null))
                {
                    newMat = prev;
                    changed = true;
                }
            }
            
            using (new EditorGUI.DisabledScope(next == null))
            {
                if (GUILayout.Button("++") || (allNext && next != null))
                {
                    newMat = next;
                    changed = true;
                }
            }
            
            EditorGUILayout.EndHorizontal();
            
            if (changed) {
                foreach (var prop in group)
                {
                    prop.objectReferenceValue = newMat;
                }

                foreach (var obj in objects)
                {
                    obj.ApplyModifiedProperties();
                }
            }
        }
    }

    private void FindAdjacentByParentFolder<T>(T mat, out T prev, out T next)
    where T: UnityEngine.Object
    {
        prev = next = null;
        
        var path = AssetDatabase.GetAssetPath(mat);
        var up2Path = Path.GetDirectoryName(Path.GetDirectoryName(path));
        var filename = Path.GetFileName(path);

        var paths = (typeof(T) == typeof(Material)) ? materialPaths : texturePaths;
        var candidates = paths.Where(p => Path.GetDirectoryName(Path.GetDirectoryName(p)) == up2Path)
            .Where(p => Path.GetFileName(p) == filename)
            .ToList();

        var index = candidates.BinarySearch(path);
        if (index < 0) return;
        
        if (index > 0)
        {
            prev = AssetDatabase.LoadAssetAtPath<T>(candidates[index - 1]);
        }
        
        if (index < candidates.Count - 1)
        {
            next = AssetDatabase.LoadAssetAtPath<T>(candidates[index + 1]);
        }
    }
    
    private void FindAdjacent<T>(T mat, out T prev, out T next)
        where T: UnityEngine.Object
    {
        next = prev = null;
        var path = AssetDatabase.GetAssetPath(mat);
        if (string.IsNullOrEmpty(path)) return;

        var paths = (typeof(T) == typeof(Material)) ? materialPaths : texturePaths;
        int index = paths.BinarySearch(path);
        if (index < 0) return;

        if (index > 0 && Path.GetDirectoryName(path) == Path.GetDirectoryName(paths[index - 1]))
        {
            prev = AssetDatabase.LoadAssetAtPath<T>(paths[index - 1]);
        }
        
        if (index < materialPaths.Count - 1 && Path.GetDirectoryName(path) == Path.GetDirectoryName(paths[index + 1]))
        {
            next = AssetDatabase.LoadAssetAtPath<T>(paths[index + 1]);
        }
    }
}    

#endif