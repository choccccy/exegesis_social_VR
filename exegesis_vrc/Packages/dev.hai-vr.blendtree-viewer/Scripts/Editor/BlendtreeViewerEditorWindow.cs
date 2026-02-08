using System;
using System.Linq;
using UnityEditor;
using UnityEditor.Animations;
using UnityEngine;

namespace Hai.BlendtreeViewer.Scripts.Editor
{
    public class BlendtreeViewerEditorWindow : EditorWindow
    {
        private const string AnimatorStateLabel = "Animator State";
        private const string AnimatorBlendTreeLabel = "Animator BlendTree";
        private const string SelectLabel = "Select";
        private const string TypeAndChildCountLabel = "{0} (×{1})";

        public bool syncWithAnimator = true;
        // public bool readOnly = true;
        public BlendTree blendTree;
        
        private Vector2 _scrollPos;

        private bool collapseShared = false;

        public BlendtreeViewerEditorWindow()
        {
            titleContent = MakeTitle();
        }

        private void OnGUI()
        {
            ShowOptions();
            EditorGUILayout.Separator();
            if (blendTree != null)
            {
                _scrollPos = GUILayout.BeginScrollView(_scrollPos, GUILayout.Height(Screen.height - EditorGUIUtility.singleLineHeight * 6));
                DisplayBlendTree(blendTree, 0);
                GUILayout.EndScrollView();
            }
        }

        private void DisplayBlendTree(BlendTree bt, int indent)
        {
            var childMotions = bt.children;
            EditorGUILayout.BeginHorizontal();
            Indent(indent);
            EditorGUILayout.LabelField(string.Format(TypeAndChildCountLabel, BlendTreeType(bt), childMotions.Length), EditorStyles.boldLabel);

            var containerType = bt.blendType;
            var isSharedDbt = IsSharedDirectBlendtree(containerType, childMotions);
            if (containerType == UnityEditor.Animations.BlendTreeType.Direct)
            {
                if (isSharedDbt)
                {
                    EditorGUI.BeginDisabledGroup(true);
                    EditorGUILayout.LabelField("×", GUILayout.Width(10));
                    EditorGUILayout.TextField(childMotions[0].directBlendParameter, EditorStyles.boldLabel);
                    EditorGUI.EndDisabledGroup();
                }
            }
            if (containerType == UnityEditor.Animations.BlendTreeType.Simple1D)
            {
                EditorGUILayout.TextField(bt.blendParameter);
            }
            else if (containerType != UnityEditor.Animations.BlendTreeType.Direct) // implies 2D
            {
                EditorGUILayout.TextField(bt.blendParameter);
                EditorGUILayout.TextField(bt.blendParameterY);
            }
            
            EditorGUILayout.EndHorizontal();
            
            foreach (var childMotion in childMotions)
            {
                DisplayChildMotion(childMotion, containerType, isSharedDbt && collapseShared, indent);
            }
        }

        private static bool IsSharedDirectBlendtree(BlendTreeType containerType, ChildMotion[] childMotions)
        {
            return containerType is UnityEditor.Animations.BlendTreeType.Direct
                   && childMotions.Length > 1
                   && childMotions.All(motion => motion.directBlendParameter == childMotions[0].directBlendParameter);
        }

        private void DisplayChildMotion(ChildMotion childMotion, BlendTreeType containerType, bool isSharedDbt, int indent)
        { 
            EditorGUILayout.BeginHorizontal();
            Indent(indent);
            EditorGUILayout.ObjectField(childMotion.motion, typeof(Motion), false);
            if (containerType == UnityEditor.Animations.BlendTreeType.Direct)
            {
                if (!isSharedDbt)
                {
                    EditorGUILayout.LabelField("×", GUILayout.Width(10));
                    EditorGUILayout.TextField(childMotion.directBlendParameter);
                }
            }
            else if (containerType == UnityEditor.Animations.BlendTreeType.Simple1D)
            {
                EditorGUILayout.TextField($"({childMotion.threshold})", EditorStyles.label);
            }
            else
            {
                EditorGUILayout.TextField($"({childMotion.position.x}, {childMotion.position.y})", EditorStyles.label);
            }
            EditorGUILayout.EndHorizontal();

            if (childMotion.motion is BlendTree bt)
            {
                DisplayBlendTree(bt, indent + 1);
            }
            else if (childMotion.motion is AnimationClip clip)
            {
                DisplayAnimationClip(clip, indent + 1);
            }
        }

        private void DisplayAnimationClip(AnimationClip clip, int indent)
        {
            var editorCurveBindings = AnimationUtility.GetCurveBindings(clip);
            var enumerable = editorCurveBindings
                .Where(binding => binding.type == typeof(Animator))
                .OrderBy(binding => binding.propertyName);
            foreach (var binding in enumerable)
            {
                AnimationCurve curve = AnimationUtility.GetEditorCurve(clip, binding);
                EditorGUILayout.BeginHorizontal();
                Indent(indent);
                EditorGUILayout.TextField(binding.propertyName);
                EditorGUILayout.LabelField("=", GUILayout.Width(20));
                var keys = curve.keys;
                if (keys.Length == 1 || keys.Length == 2 && keys[0].value == keys[1].value)
                {
                    EditorGUILayout.TextField($"{keys[0].value}", EditorStyles.label);
                }
                else if (keys.Length > 0) // unlikely to be 0, but just in case
                {
                    EditorGUILayout.TextField($"{keys[0].value} → {keys[curve.length - 1].value}", EditorStyles.label);
                    EditorGUILayout.CurveField(curve);
                }
                EditorGUILayout.EndHorizontal();
            }
        }

        private void Indent(int indent)
        {
            EditorGUILayout.LabelField("", GUILayout.Width(indent * 20));
        }

        private static string BlendTreeType(BlendTree bt)
        {
            return Enum.GetName(typeof(BlendTreeType), bt.blendType);
        }

        private void ShowOptions()
        {
            var serializedObject = new SerializedObject(this);
            EditorGUILayout.PropertyField(serializedObject.FindProperty(nameof(blendTree)));

            BlendTree btNullable;
            var activeObjectNullable = Selection.activeObject;
            if (activeObjectNullable is AnimatorState state)
            {
                btNullable = state.motion as BlendTree;
                // EditorGUILayout.ObjectField(new GUIContent(AnimatorStateLabel), activeObjectNullable, typeof(AnimatorState), false);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.ObjectField(new GUIContent(AnimatorBlendTreeLabel), btNullable, typeof(BlendTree), false);
                MakeSelectButton(btNullable);
                EditorGUILayout.EndHorizontal();
            }
            else
            {
                btNullable = activeObjectNullable as BlendTree;
                // EditorGUILayout.ObjectField(new GUIContent(AnimatorStateLabel), null, typeof(AnimatorState), false);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.ObjectField(new GUIContent(AnimatorBlendTreeLabel), btNullable, typeof(BlendTree), false);
                MakeSelectButton(btNullable);
                EditorGUILayout.EndHorizontal();
            }

            if (syncWithAnimator && btNullable != null && blendTree != btNullable)
            {
                SetBlendTreeNow(btNullable);
            }
            
            EditorGUILayout.BeginHorizontal();
            EditorGUILayout.PropertyField(serializedObject.FindProperty(nameof(syncWithAnimator)));
            // EditorGUILayout.PropertyField(serializedObject.FindProperty(nameof(readOnly)));
            EditorGUILayout.EndHorizontal();
            serializedObject.ApplyModifiedProperties();
        }

        private void MakeSelectButton(BlendTree btNullable)
        {
            EditorGUI.BeginDisabledGroup(btNullable == null);
            if (GUILayout.Button(SelectLabel, GUILayout.Width(100)))
            {
                SetBlendTreeNow(btNullable);
            }
            EditorGUI.EndDisabledGroup();
        }

        private void SetBlendTreeNow(BlendTree newFocus)
        {
            var serializedObject = new SerializedObject(this);
            serializedObject.FindProperty(nameof(blendTree)).objectReferenceValue = newFocus;
            serializedObject.ApplyModifiedProperties();
        }

        private void OnEnable()
        {
            Selection.selectionChanged += SelectionChanged;
        }

        private void OnDisable()
        {
            Selection.selectionChanged -= SelectionChanged;
        }

        private void SelectionChanged()
        {
            if (Selection.activeObject is AnimatorState || Selection.activeObject is BlendTree)
            {
                Repaint();
            }
        }

        [MenuItem("Window/Haï/BlendTreeViewer")]
        public static void ShowWindow()
        {
            Obtain().Show();
        }

        [MenuItem("CONTEXT/BlendTree/Haï BlendTreeViewer")]
        public static void OpenEditor(MenuCommand command)
        {
            var window = Obtain();
            window.UsingBlendtree((BlendTree) command.context);
            window.Show();
            window.TryExecuteUpdate();
        }

        private void TryExecuteUpdate()
        {
        }

        private void UsingBlendtree(BlendTree blendTree)
        {
            this.blendTree = blendTree;
        }

        private static BlendtreeViewerEditorWindow Obtain()
        {
            var editor = GetWindow<BlendtreeViewerEditorWindow>(false, null, false);
            editor.titleContent = MakeTitle();
            return editor;
        }

        private static GUIContent MakeTitle()
        {
            return new GUIContent("BlendTreeViewer");
        }
    }
}