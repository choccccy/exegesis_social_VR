
using UnityEngine;
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine.UIElements;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3.Editor;
using VRC.SDK3A.Editor.Elements;

using ExpressionsMenu = VRC.SDK3.Avatars.ScriptableObjects.VRCExpressionsMenu;
using ExpressionParameters = VRC.SDK3.Avatars.ScriptableObjects.VRCExpressionParameters;


[CustomEditor(typeof(ExpressionsMenu))]
public class VRCExpressionsMenuEditor : UnityEditor.Editor
{

    public VisualTreeAsset Uxml;
    [HideInInspector] public ExpressionsMenu Menu;

    public static int SelectedIndex
    {
        get => SessionState.GetInt("SelectedIndex", 0);
        set => SessionState.SetInt("SelectedIndex", value);
    }

    private SerializedProperty propParametersObject;
    private SerializedProperty propControls;
    private SerializedProperty propControl;

    private VisualElement root;
    private VRCCreateObjectField parametersCreateObjectField;
    private Label MaxCountLabel;
    private ListView ControlsListView;
    private VisualElement ControlsListViewSizeField;
    private VisualElement ControlOptionsContainer;
    private Foldout ControlsListViewFoldout;

    private ExpressionsControlOptions controlOptions;


    private void OnEnable()
    {
        Menu = target as ExpressionsMenu;
        Undo.undoRedoPerformed += RefreshListSizeView;
        
        // if params aren't set, check avatars to see if any has params set for this menu
        if (Menu != null && Menu.Parameters == null)
        {
            var avatars = FindObjectsByType<VRCAvatarDescriptor>(FindObjectsInactive.Include, FindObjectsSortMode.None);
            foreach (var avatar in avatars)
            {
                if (avatar.expressionsMenu != null && avatar.expressionParameters != null && IsSubmenuRecursive(Menu, avatar.expressionsMenu))
                {
                    Menu.Parameters = avatar.expressionParameters;
                    break;
                }
            }
        }

        // additionally, check for parent objects
        if (Menu != null && Menu.Parameters == null)
        {
            var assetPath = AssetDatabase.GetAssetPath(Menu);
            var mainAsset = AssetDatabase.LoadMainAssetAtPath(assetPath);
            if (mainAsset != null && mainAsset != Menu && mainAsset is ExpressionsMenu parentMenu)
            {
                Menu.Parameters = parentMenu.Parameters;
            }
        }
    }

    private bool IsSubmenuRecursive(ExpressionsMenu needle, ExpressionsMenu haystack, int depth = 0)
    {
        if (haystack == null) return false;
        if (haystack == needle) return true;
        if (depth > 16) return false; // arbitrary depth limit
        if (haystack.controls == null || haystack.controls.Count == 0) return false;

        foreach (var control in haystack.controls)
            if (control.subMenu != null && IsSubmenuRecursive(needle, control.subMenu, depth + 1))
                return true;

        return false;
    }

    private void OnDisable()
    {
        Undo.undoRedoPerformed -= RefreshListSizeView;
    }

    public override VisualElement CreateInspectorGUI()
    {
        root = new VisualElement();
        if (Uxml == null)
        {
            Uxml = Resources.Load<VisualTreeAsset>("VRCExpressionsMenu");
        }
        Uxml.CloneTree(root);

        QueryAllElements();

        // Force expanded view, folded up just looks broken.
        ControlsListViewFoldout.value = true;
        ControlsListViewFoldout.RegisterValueChangedCallback(_ => ControlsListViewFoldout.value = true);
        
        MaxCountLabel = new Label($" / {ExpressionsMenu.MAX_CONTROLS}  ");
        ControlsListViewSizeField.Add(MaxCountLabel);
        
        BindElements();

        // Select the most recently selected index for returning to this object.
        ControlSelected(SelectedIndex);
        return root;
    }

    /// <summary>
    /// Query a reference to all needed UI Elements.
    /// </summary>
    private void QueryAllElements()
    {
        parametersCreateObjectField = root.Q<VRCCreateObjectField>("ParametersCreateObjectField");
        ControlOptionsContainer = root.Q<VisualElement>("ControlOptionsContainer");
        ControlsListView = root.Q<ListView>("ControlsListView");
        ControlsListViewSizeField = ControlsListView.Q<VisualElement>("unity-list-view__size-field");
        ControlsListViewFoldout = ControlsListView.Q<Foldout>();
    }


    #region Data Binding

    /// <summary>
    /// Bind properties and callbacks to fields that do not change from Control selection.
    /// </summary>
    private void BindElements()
    {
        propParametersObject = serializedObject.FindProperty(nameof(ExpressionsMenu.Parameters));
        propControls = serializedObject.FindProperty(nameof(ExpressionsMenu.controls));

        InitControlsList();

        parametersCreateObjectField.BindProperty(propParametersObject, typeof(ExpressionParameters), "Parameters");
        parametersCreateObjectField.changed += () => ControlSelected(SelectedIndex);
    }

    private void InitControlsList()
    {
        ControlsListView.BindProperty(propControls);

        ControlsListView.makeItem += () => new ExpressionsControlField();
        ControlsListView.bindItem += BindControlListItem;

        ControlsListView.selectionChanged += _ =>
        {
            RefreshListSizeView();
            ControlSelected(ControlsListView.selectedIndex);
        };
        // Reselect the current control after reordering.
        ControlsListView.itemIndexChanged += (oldIndex, newIndex) =>
        {
            RefreshListSizeView();
            ControlSelected(newIndex);
        };
        // Block items from being added past the max control count.
        ControlsListView.itemsAdded += indices =>
        {
            foreach (var i in indices)
            {
                var element = propControls.GetArrayElementAtIndex(i);
                ApplyDefaultsToNewControl(element);
            }
            RefreshListSizeView();
            serializedObject.ApplyModifiedProperties(); // always apply
        };
        ControlsListView.itemsRemoved += _ =>
        {
            RefreshListSizeView();
            ControlsListView.schedule.Execute(RefreshListSizeView).ExecuteLater(100);

            if (propControls.arraySize == 1)
            {
                ControlSelected(-1);
            }
        };
    }

    private void ApplyDefaultsToNewControl(SerializedProperty control)
    {
        control.FindPropertyRelative(nameof(ExpressionsMenu.Control.name)).stringValue = "New Control";
        control.FindPropertyRelative(nameof(ExpressionsMenu.Control.value)).floatValue = 1;
    }

    private void BindControlListItem(VisualElement element, int i)
    {
        ExpressionsControlField controlField = (ExpressionsControlField)element;
        SerializedProperty control = propControls.GetArrayElementAtIndex(i);
        controlField.BindProperty(control);
    }

    private void RefreshListSizeView()
    {
        if (propControls.arraySize > ExpressionsMenu.MAX_CONTROLS || propControls.arraySize < 0)
        {
            propControls.arraySize = Mathf.Min(propControls.arraySize, ExpressionsMenu.MAX_CONTROLS);
            serializedObject.ApplyModifiedProperties();
        }
    }

    private void ControlSelected(int index)
    {
        if (index < 0 || propControls.arraySize == 0)
        {
            ControlOptionsContainer.style.display = DisplayStyle.None;
        }
        else
        {
            index = Mathf.Clamp(index, 0, propControls.arraySize - 1);
            SelectedIndex = index;
            ControlOptionsContainer.style.display = DisplayStyle.Flex;
            propControl = propControls.GetArrayElementAtIndex(index);

            if (controlOptions != null && ControlOptionsContainer.Contains(controlOptions))
            {
                ControlOptionsContainer.Remove(controlOptions);
            }
            controlOptions = new ExpressionsControlOptions(propControl, Menu);
            ControlOptionsContainer.Add(controlOptions);
        }
    }

    #endregion
}
