using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.UIElements;
using UnityEngine.UIElements;

using ExpressionParameter = VRC.SDK3.Avatars.ScriptableObjects.VRCExpressionParameters.Parameter;
using ExpressionParameters = VRC.SDK3.Avatars.ScriptableObjects.VRCExpressionParameters;
using VRC.SDK3.Avatars.ScriptableObjects;


namespace VRC.SDK3.Editor
{
    [CustomEditor(typeof(VRCExpressionParameters))]
    public class VRCExpressionParametersEditor : UnityEditor.Editor
    {
        private SerializedProperty hasEmptyParameterList;
        private SerializedProperty propParameters;
        private ExpressionParameters script;

        private VisualElement root;
        private ToolbarMenu ActionsMenu;
        private ProgressBar MemoryBar;
        private VisualElement MemoryBarProgress;
        private Button LearnMoreButton;
        private ListView ParametersListView;
        private VisualElement ListHeader;
        private Foldout ListViewFoldout;

        private static string DOCUMENTATION_URL = "https://creators.vrchat.com/avatars/expression-menu-and-controls";

        private readonly Color colorMemoryFree = new(0, 0.5f, 1, 0.5f);
        private readonly Color colorMemoryLow = new(0.8f, 0.7f, 0, 0.5f);
        private readonly Color colorMemoryOut = new(1, 0, 0, 0.5f);


        public void OnEnable()
        {
            script = target as ExpressionParameters;
            if (script == null) return;
			
            propParameters = serializedObject.FindProperty(nameof(ExpressionParameters.parameters));
            hasEmptyParameterList = serializedObject.FindProperty(nameof(ExpressionParameters.isEmpty));
            
            if (script.parameters == null ||
                (script.parameters.Length == 0 && !hasEmptyParameterList.boolValue))
            {
                AddDefaultParameters(true);
            }
        }

        public override VisualElement CreateInspectorGUI()
        {
            root = new VisualElement();
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCExpressionParameters");
            uxml.CloneTree(root);

            ActionsMenu = root.Q<ToolbarMenu>("ActionsMenu");
            MemoryBar = root.Q<ProgressBar>("MemoryBar");
			
            MemoryBarProgress = MemoryBar.Q(className: "unity-progress-bar__progress");
            LearnMoreButton = root.Q<Button>("LearnMoreButton");
            ParametersListView = root.Q<ListView>("ParametersListView");
            ListHeader = root.Q<VisualElement>("ListHeader");

            // Move the header into the foldout area.
            ListViewFoldout = ParametersListView.Q<Foldout>();
            ListViewFoldout.hierarchy.Insert(1, ListHeader);

            // Force expanded view, folded up just looks broken.
            ListViewFoldout.value = true;
            ListViewFoldout.RegisterValueChangedCallback(_ => ListViewFoldout.value = true);

            LearnMoreButton.clicked += () => Application.OpenURL(DOCUMENTATION_URL);

            ActionsMenu.menu.AppendAction("Add Default Parameters", _ => AddDefaultParameters());
            ActionsMenu.menu.AppendAction("Copy from Animator", _ => CopyFromAnimator());

            ParametersListView.makeItem += () => new ExpressionParameterField();
            ParametersListView.bindItem += BindParameterListItem;

            ParametersListView.itemsAdded += _ =>
            {
                serializedObject.Update();
                hasEmptyParameterList.boolValue = false;
                serializedObject.ApplyModifiedProperties();
            };
            ParametersListView.itemsRemoved += _ =>
            {
                serializedObject.Update();
                hasEmptyParameterList.boolValue = script.parameters.Length == 1;
                serializedObject.ApplyModifiedProperties();
            };

            ParametersListView.BindProperty(propParameters);

            // With lots of small changes that affect this count, this will be refreshed every 100ms
            MemoryBar.schedule.Execute(RefreshMemoryBar).Every(100);
            RefreshMemoryBar();
			
            return root;
        }

        private void BindParameterListItem(VisualElement element, int i)
        {
            ExpressionParameterField parameterField = (ExpressionParameterField)element;
            SerializedProperty param = propParameters.GetArrayElementAtIndex(i);
            parameterField.BindProperty(param);
        }

        private void RefreshMemoryBar()
        {
            int cost = script.CalcTotalCost();
            MemoryBar.title = $"{cost}/{ExpressionParameters.MAX_PARAMETER_COST} Synced Bits";
            MemoryBar.value = cost;

            switch (cost)
            {
                case > 256:
                    MemoryBarProgress.style.backgroundColor = colorMemoryOut;
                    break;
                case > 128:
                    MemoryBarProgress.style.backgroundColor = colorMemoryLow;
                    break;
                default:
                    MemoryBarProgress.style.backgroundColor = colorMemoryFree;
                    break;
            }
        }

        public static ExpressionParameter[] GetDefaultParameters()
        {
            ExpressionParameter[] parameters = new ExpressionParameter[3];
            parameters[0] = new ExpressionParameter
            {
                name = "VRCEmote",
                valueType = ExpressionParameters.ValueType.Int
            };

            parameters[1] = new ExpressionParameter
            {
                name = "VRCFaceBlendH",
                valueType = ExpressionParameters.ValueType.Float
            };

            parameters[2] = new ExpressionParameter
            {
                name = "VRCFaceBlendV",
                valueType = ExpressionParameters.ValueType.Float
            };
            return parameters;
        }

        private void AddDefaultParameters(bool skipConfirmation = false)
        {
            AddParameters(GetDefaultParameters().ToList(), skipConfirmation);
        }

        private void CopyFromAnimator()
        {
            string path = EditorUtility.OpenFilePanel("VRC SDK", Application.dataPath, "controller");
            if (path.Length == 0) return;

            path = path.Replace(Application.dataPath, "");
            path = "Assets" + path;

            AnimatorController animator = AssetDatabase.LoadAssetAtPath<AnimatorController>(path);
            if (animator == null)
            {
                EditorUtility.DisplayDialog("VRC SDK", "No Animator selected.", "Return");
                return;
            }

            List<ExpressionParameter> vrcParameters = new();

            foreach (AnimatorControllerParameter animatorParameters in animator.parameters)
            {
                ExpressionParameter newVrcParameters = new()
                {
                    name = animatorParameters.name
                };
                switch (animatorParameters.type)
                {
                    case AnimatorControllerParameterType.Float:
                        newVrcParameters.valueType = VRCExpressionParameters.ValueType.Float;
                        newVrcParameters.defaultValue = animatorParameters.defaultFloat;
                        vrcParameters.Add(newVrcParameters);
                        break;
                    case AnimatorControllerParameterType.Int:
                        newVrcParameters.valueType = VRCExpressionParameters.ValueType.Int;
                        newVrcParameters.defaultValue = animatorParameters.defaultInt;
                        vrcParameters.Add(newVrcParameters);
                        break;
                    case AnimatorControllerParameterType.Bool:
                        newVrcParameters.valueType = VRCExpressionParameters.ValueType.Bool;
                        newVrcParameters.defaultValue = animatorParameters.defaultBool ? 1 : 0;
                        vrcParameters.Add(newVrcParameters);
                        break;
                    /* Triggers are not currently supported in ExpressionParameters, and will not be imported.
                    case AnimatorControllerParameterType.Trigger:
                        newVrcParameters.valueType = VRCExpressionParameters.ValueType.Bool;
                        newVrcParameters.defaultValue = animatorParameters.defaultBool ? 1 : 0;
                        break;
                    */
                }
            }

            AddParameters(vrcParameters);
        }

        private void AddParameters(List<ExpressionParameter> parameters, bool skipConfirmation = false)
        {
            serializedObject.Update();

            List<ExpressionParameter> baseParameters;
            if (script.parameters != null)
            {
                baseParameters = script.parameters.ToList();
            }
            else
            {
                baseParameters = new List<ExpressionParameter>();
            }
            HashSet<string> existingParameters = new(baseParameters.Select(item => item.name));
            List<ExpressionParameter> uniqueParameters =
                parameters.Where(item => !existingParameters.Contains(item.name)).ToList();
            if (uniqueParameters.Count == 0)
            {
                EditorUtility.DisplayDialog("VRC SDK", "No new variables found to add to your parameters.", "Return");
                return;
            }

            string parameterNames = string.Empty;
            for (int i = 0; i < uniqueParameters.Count; i++)
            {
                parameterNames += uniqueParameters[i].name;
                if (i != uniqueParameters.Count - 1) parameterNames += ", ";
            }

            if (skipConfirmation || EditorUtility.DisplayDialog("VRC SDK",
                    $"Do you want to add these {uniqueParameters.Count} parameters to your list?\n{parameterNames}",
                    "Yes", "No"))
            {
                baseParameters.AddRange(uniqueParameters);

                Undo.RecordObject(script, "Added parameters from animator.");
                script.parameters = baseParameters.ToArray();
                serializedObject.ApplyModifiedProperties();
            }
        }
    }
}