using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

// Script Designed by BluWizard LABS. https://bluwizard.net

namespace BluUtilities.CurveEditorSizer
{
    [FilePath("ProjectSettings/BluUtilities.CurveEditorSizer.asset", FilePathAttribute.Location.ProjectFolder)]
    public class CurveEditorSizerSettings : ScriptableSingleton<CurveEditorSizerSettings>
    {
        [SerializeField] private bool _enabled = true;
        [SerializeField] private int _targetWidth = 600;
        [SerializeField] private int _targetHeight = 600;
        [SerializeField] private bool _lockMinMax = false;
        [SerializeField] private bool _onlyUndocked = true;
        [SerializeField] private bool _matchByTitle = true;
        [SerializeField] private string _titleContains = "Curve";
        [SerializeField] private bool _matchByTypeName = true;
        [SerializeField] private string _typeNameContains = "Curve";

        public static bool Enabled { get => instance._enabled; set { instance._enabled = value; instance.Save(); } }
        public static int TargetWidth { get => Mathf.Max(200, instance._targetWidth); set { instance._targetWidth = Mathf.Max(200, value); instance.Save(); } }
        public static int TargetHeight { get => Mathf.Max(150, instance._targetHeight); set { instance._targetHeight = Mathf.Max(150, value); instance.Save(); } }
        public static bool LockMinMax { get => instance._lockMinMax; set { instance._lockMinMax = value; instance.Save(); } }
        public static bool OnlyUndocked { get => instance._onlyUndocked; set { instance._onlyUndocked = value; instance.Save(); } }
        public static bool MatchByTitle { get => instance._matchByTitle; set { instance._matchByTitle = value; instance.Save(); } }
        public static string TitleContains { get => instance._titleContains; set { instance._titleContains = value ?? ""; instance.Save(); } }
        public static bool MatchByTypeName { get => instance._matchByTypeName; set { instance._matchByTypeName = value; instance.Save(); } }
        public static string TypeNameContains { get => instance._typeNameContains; set { instance._typeNameContains = value ?? ""; instance.Save(); } }

        public void Save() => Save(true);
    }

    public class CurveEditorSizerSettingsProvider : SettingsProvider
    {
        public CurveEditorSizerSettingsProvider() : base("Project/BluWizard LABS/Curve Editor Sizer", SettingsScope.Project) { }

        public override void OnGUI(string searchContext)
        {
            EditorGUILayout.LabelField("Curve Editor Sizer", EditorStyles.boldLabel);

            bool enabled = CurveEditorSizerSettings.Enabled;
            int targetWidth = CurveEditorSizerSettings.TargetWidth;
            int targetHeight = CurveEditorSizerSettings.TargetHeight;
            bool lockMinMax = CurveEditorSizerSettings.LockMinMax;
            bool onlyUndocked = CurveEditorSizerSettings.OnlyUndocked;
            bool matchByTitle = CurveEditorSizerSettings.MatchByTitle;
            string titleContains = CurveEditorSizerSettings.TitleContains;
            bool matchByType = CurveEditorSizerSettings.MatchByTypeName;
            string typeContains = CurveEditorSizerSettings.TypeNameContains;

            using (new EditorGUILayout.VerticalScope("box"))
            {
                enabled = EditorGUILayout.Toggle(new GUIContent("Enabled"), enabled);

                EditorGUI.BeginDisabledGroup(!enabled);
                targetWidth = EditorGUILayout.IntField(new GUIContent("Target Width"), targetWidth);
                targetHeight = EditorGUILayout.IntField(new GUIContent("Target Height"), targetHeight);
                lockMinMax = EditorGUILayout.Toggle(new GUIContent("Lock Min/Max Size"), lockMinMax);
                onlyUndocked = EditorGUILayout.Toggle(new GUIContent("Only Undocked Windows"), onlyUndocked);

                EditorGUILayout.Space(6);
                EditorGUILayout.LabelField("Window Matching", EditorStyles.boldLabel);
                matchByTitle = EditorGUILayout.Toggle(new GUIContent("Match By Title"), matchByTitle);
                if (matchByTitle)
                    titleContains = EditorGUILayout.TextField(new GUIContent("  Title Contains"), titleContains);

                matchByType = EditorGUILayout.Toggle(new GUIContent("Match By Type Name"), matchByType);
                if (matchByType)
                    typeContains = EditorGUILayout.TextField(new GUIContent("  Type Name Contains"), typeContains);
                EditorGUI.EndDisabledGroup();
            }

            CurveEditorSizerSettings.Enabled = enabled;
            CurveEditorSizerSettings.TargetWidth = targetWidth;
            CurveEditorSizerSettings.TargetHeight = targetHeight;
            CurveEditorSizerSettings.LockMinMax = lockMinMax;
            CurveEditorSizerSettings.OnlyUndocked = onlyUndocked;
            CurveEditorSizerSettings.MatchByTitle = matchByTitle;
            CurveEditorSizerSettings.TitleContains = titleContains;
            CurveEditorSizerSettings.MatchByTypeName = matchByType;
            CurveEditorSizerSettings.TypeNameContains = typeContains;

            EditorGUILayout.Space(8);
            using (new EditorGUILayout.HorizontalScope())
            {
                if (GUILayout.Button("Resize Focused Window Now"))
                {
                    CurveEditorSizer.TryResize(EditorWindow.focusedWindow, force: true);
                }

                if (GUILayout.Button("Reset To Defaults"))
                {
                    CurveEditorSizerSettings.Enabled = true;
                    CurveEditorSizerSettings.TargetWidth = 600;
                    CurveEditorSizerSettings.TargetHeight = 600;
                    CurveEditorSizerSettings.LockMinMax = false;
                    CurveEditorSizerSettings.OnlyUndocked = true;
                    CurveEditorSizerSettings.MatchByTitle = true;
                    CurveEditorSizerSettings.TitleContains = "Curve";
                    CurveEditorSizerSettings.MatchByTypeName = true;
                    CurveEditorSizerSettings.TypeNameContains = "Curve";
                }
            }
        }

        [SettingsProvider]
        public static SettingsProvider CreateProvider() => new CurveEditorSizerSettingsProvider();
    }

    [InitializeOnLoad]
    public static class CurveEditorSizer
    {
        private static readonly HashSet<int> _resized = new HashSet<int>();
        private static double _nextScanTime;
        private static int _lastFocusedId = 0;

        static CurveEditorSizer()
        {
            EditorApplication.update += OnUpdate;
            EditorApplication.delayCall += () => _nextScanTime = EditorApplication.timeSinceStartup + 0.25;
        }

        private static void OnUpdate()
        {
            if (!CurveEditorSizerSettings.Enabled) return;

            var win = EditorWindow.focusedWindow;
            int id = win ? win.GetInstanceID() : 0;
            if (id == 0 || id == _lastFocusedId) return;

            _lastFocusedId = id;

            _resized.Clear();
            TryResize(win);
        }

        public static void TryResize(EditorWindow win, bool force = false)
        {
            if (win == null) return;

            int id = win.GetInstanceID();
            if (!force && _resized.Contains(id)) return;
            if (!LooksLikeCurveEditor(win)) return;
            if (CurveEditorSizerSettings.OnlyUndocked && IsDocked(win)) return;

            int w = CurveEditorSizerSettings.TargetWidth;
            int h = CurveEditorSizerSettings.TargetHeight;

            Rect before = win.position;

            Rect pos = before;
            pos.width = w;
            pos.height = h;

            if (CurveEditorSizerSettings.LockMinMax)
            {
                win.minSize = new Vector2(w, h);
                win.maxSize = new Vector2(w, h);
            }
            else
            {
                win.minSize = new Vector2(Mathf.Min(300, w), Mathf.Min(200, h));
                win.maxSize = Vector2.one * 10000f;
            }

            bool sizeChanged = !Mathf.Approximately((float)before.width, (float)pos.width) || !Mathf.Approximately((float)before.height, (float)pos.height);

            if (sizeChanged)
            {
                win.position = pos;
                win.Repaint();
                Debug.Log($"[<color=#0092d9>BluWizard LABS</color>] [<color=#00cc00>Curve Editor Fix</color>] Automatically resized \"{win.titleContent?.text}\" window to {w}x{h}.");
            }

            _resized.Add(id);
        }

        private static bool LooksLikeCurveEditor(EditorWindow win)
        {
            var title = win.titleContent?.text ?? "";
            var typeName = win.GetType().Name ?? "";
            bool match = true;

            if (CurveEditorSizerSettings.MatchByTitle)
                match &= title.IndexOf(CurveEditorSizerSettings.TitleContains, StringComparison.OrdinalIgnoreCase) >= 0;
            if (CurveEditorSizerSettings.MatchByTypeName)
                match &= typeName.IndexOf(CurveEditorSizerSettings.TypeNameContains, StringComparison.OrdinalIgnoreCase) >= 0;

            return match;
        }

        private static bool IsDocked(EditorWindow win)
        {
            var root = win.GetType().GetProperty("m_Parent", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance)?.GetValue(win);
            if (root == null) return false;
            var windowProp = root.GetType().GetProperty("window");
            var container = windowProp?.GetValue(root);
            return container != null;
        }
    }
}
