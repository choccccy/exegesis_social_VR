
using UnityEditor;
using UnityEditor.UIElements;
using UnityEngine;
using UnityEngine.UIElements;
using VRC.SDK3.Avatars.ScriptableObjects;
using ExpressionsMenu = VRC.SDK3.Avatars.ScriptableObjects.VRCExpressionsMenu;
using ExpressionControl = VRC.SDK3.Avatars.ScriptableObjects.VRCExpressionsMenu.Control;


namespace VRC.SDK3A.Editor.Elements
{
    public class ExpressionsControlOptions : VisualElement
    {

        public new class UxmlFactory : UxmlFactory<ExpressionsControlOptions, UxmlTraits> { }

        public static bool ShowControlTypeHelpBox
        {
            get => SessionState.GetBool("ShowControlHelpBox", true);
            set => SessionState.SetBool("ShowControlHelpBox", value);
        }

        private ExpressionsControlLabel ControlNameField;
        private EnumField ControlTypeField;
        private ExpressionsControlParameterField ControlParameterField;
        private Slider ValueSlider;
        private SliderInt ValueIntSlider;
        private Toggle ValueToggle;
        private VisualElement ControlTypeHelpBoxContainer;
        private Button TypeInfoButton;
        private HelpBox ControlTypeHelpBox;
        private VisualElement MenuTypesContainer;
        private VRCCreateObjectField SubMenuObjectField;
        private VisualElement TwoAxisPuppetContainer;
        private ExpressionsControlParameterField HorizontalParam;
        private ExpressionsControlParameterField VerticalParam;
        private ExpressionsControlLabel UpLabel;
        private ExpressionsControlLabel RightLabel;
        private ExpressionsControlLabel DownLabel;
        private ExpressionsControlLabel LeftLabel;
        private VisualElement FourAxisPuppetContainer;
        private ExpressionsControlParameterField FourAxisUpParam;
        private ExpressionsControlParameterField FourAxisRightParam;
        private ExpressionsControlParameterField FourAxisDownParam;
        private ExpressionsControlParameterField FourAxisLeftParam;
        private ExpressionsControlLabel FourAxisUpLabel;
        private ExpressionsControlLabel FourAxisRightLabel;
        private ExpressionsControlLabel FourAxisDownLabel;
        private ExpressionsControlLabel FourAxisLeftLabel;
        private ExpressionsControlParameterField RotationParamField;

        public ExpressionsMenu Menu;

        private SerializedProperty propControl;
        private SerializedProperty propName;
        private SerializedProperty propIcon;
        private SerializedProperty propType;
        private SerializedProperty propSubMenu;
        private SerializedProperty propControlParameter;
        private SerializedProperty propControlParameterName;
        private SerializedProperty propValue;


        #region HelpBox Text

        private const string HELPBOX_BUTTON =
            "Click or hold to activate. The button remains active for a minimum 0.2s.\n" +
            "While active, the (Parameter) is set to (Value).\n" +
            "When inactive, the (Parameter) is reset to zero.";

        private const string HELPBOX_TOGGLE =
            "Click to toggle on or off.\n" +
            "When turned on, the (Parameter) is set to (Value).\n" +
            "When turned off, the (Parameter) is reset to zero.";

        private const string HELPBOX_SUBMENU =
            "Opens another expression menu.\n" +
            "When opened, the (Parameter) is set to (Value).\n" +
            "When closed, (Parameter) is reset to zero.";

        private const string HELPBOX_TWO_AXIS_PUPPET =
            "Puppet menu that maps the joystick to two parameters (-1 to +1).\n" +
            "When opened, the (Parameter) is set to (Value).\n" +
            "When closed, (Parameter) is reset to zero.";

        private const string HELPBOX_FOUR_AXIS_PUPPET =
            "Puppet menu that maps the joystick to four parameters (0 to 1).\n" +
            "When opened, the (Parameter) is set to (Value).\n" +
            "When closed, (Parameter) is reset to zero.";

        private const string HELPBOX_RADIAL_PUPPET =
            "Puppet menu that sets a value based on joystick rotation. (0 to 1)\n" +
            "When opened, the (Parameter) is set to (Value).\n" +
            "When closed, (Parameter) is reset to zero.";

        #endregion


        public ExpressionsControlOptions()
        {
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCExpressionsControlOptions");
            uxml.CloneTree(this);
            QueryAllElements();
            BindCallbacks();
        }

        public ExpressionsControlOptions(SerializedProperty property, VRCExpressionsMenu menu)
        {
            VisualTreeAsset uxml = Resources.Load<VisualTreeAsset>("VRCExpressionsControlOptions");
            uxml.CloneTree(this);
            Menu = menu;

            QueryAllElements();

            BindProperty(property);

            BindCallbacks();
            TypeInfoButtonClicked();
            UpdateValueSliders();
        }

        private void QueryAllElements()
        {
            ControlNameField = this.Q<ExpressionsControlLabel>("ControlNameField");
            ControlTypeHelpBoxContainer = this.Q<VisualElement>("ControlTypeHelpBoxContainer");
            TypeInfoButton = this.Q<Button>("TypeInfoButton");
            ControlTypeField = this.Q<EnumField>("ControlTypeField");
            ControlParameterField = this.Q<ExpressionsControlParameterField>("ControlParameterField");
            ValueSlider = this.Q<Slider>("ValueSlider");
            ValueIntSlider = this.Q<SliderInt>("ValueIntSlider");
            ValueToggle = this.Q<Toggle>("ValueToggle");

            MenuTypesContainer = this.Q<VisualElement>("MenuTypesContainer");
            SubMenuObjectField = this.Q<VRCCreateObjectField>("SubMenuObjectField");
            TwoAxisPuppetContainer = this.Q<VisualElement>("TwoAxisPuppetContainer");
            HorizontalParam = this.Q<ExpressionsControlParameterField>("HorizontalParam");
            VerticalParam = this.Q<ExpressionsControlParameterField>("VerticalParam");
            UpLabel = this.Q<ExpressionsControlLabel>("UpLabel");
            RightLabel = this.Q<ExpressionsControlLabel>("RightLabel");
            DownLabel = this.Q<ExpressionsControlLabel>("DownLabel");
            LeftLabel = this.Q<ExpressionsControlLabel>("LeftLabel");
            FourAxisPuppetContainer = this.Q<VisualElement>("FourAxisPuppetContainer");
            FourAxisUpParam = this.Q<ExpressionsControlParameterField>("FourAxisUpParam");
            FourAxisRightParam = this.Q<ExpressionsControlParameterField>("FourAxisRightParam");
            FourAxisDownParam = this.Q<ExpressionsControlParameterField>("FourAxisDownParam");
            FourAxisLeftParam = this.Q<ExpressionsControlParameterField>("FourAxisLeftParam");
            FourAxisUpLabel = this.Q<ExpressionsControlLabel>("FourAxisUpLabel");
            FourAxisRightLabel = this.Q<ExpressionsControlLabel>("FourAxisRightLabel");
            FourAxisDownLabel = this.Q<ExpressionsControlLabel>("FourAxisDownLabel");
            FourAxisLeftLabel = this.Q<ExpressionsControlLabel>("FourAxisLeftLabel");
            RotationParamField = this.Q<ExpressionsControlParameterField>("RotationParamField");
        }

        private void BindCallbacks()
        {
            // HelpBoxes must be added manually and cannot be created in UIBuilder.
            ControlTypeHelpBox = new HelpBox { messageType = HelpBoxMessageType.Info };
            ControlTypeHelpBoxContainer.Add(ControlTypeHelpBox);
            ControlParameterField.changed += DisplayValueSlider;

            TypeInfoButton.clicked += () =>
            {
                ShowControlTypeHelpBox = !ShowControlTypeHelpBox;
                TypeInfoButtonClicked();
            };

            ControlTypeField.RegisterValueChangedCallback(evt => ControlTypeChanged());

            ControlTypeChanged();
        }

        public void BindProperty(SerializedProperty prop)
        {
            propControl = prop;

            propName = propControl.FindPropertyRelative(nameof(ExpressionControl.name));
            propIcon = propControl.FindPropertyRelative(nameof(ExpressionControl.icon));
            propType = propControl.FindPropertyRelative(nameof(ExpressionControl.type));
            propSubMenu = propControl.FindPropertyRelative(nameof(ExpressionControl.subMenu));
            propControlParameter = propControl.FindPropertyRelative(nameof(ExpressionControl.parameter));
            propControlParameterName = propControlParameter.FindPropertyRelative(nameof(ExpressionControl.Parameter.name));
            propValue = propControl.FindPropertyRelative(nameof(ExpressionControl.value));

            ControlNameField.BindProperty(propName, propIcon);
            ControlTypeField.BindProperty(propType);
            ControlParameterField.BindParameter(propControlParameterName, Menu.Parameters);

            BindValueFields();
        }

        private void ControlTypeChanged()
        {
            ExpressionControl.ControlType controlType =
                (ExpressionControl.ControlType)propControl.FindPropertyRelative(nameof(ExpressionControl.type))
                    .enumValueFlag;

            SerializedProperty propSubParameters =
                propControl.FindPropertyRelative(nameof(ExpressionControl.subParameters));
            SerializedProperty propLabels = propControl.FindPropertyRelative(nameof(ExpressionControl.labels));


            switch (controlType)
            {
                default:
                case ExpressionControl.ControlType.Button:
                    MenuTypesContainer.style.display = DisplayStyle.None;

                    ControlTypeHelpBox.text = HELPBOX_BUTTON;
                    break;
                case ExpressionControl.ControlType.Toggle:
                    MenuTypesContainer.style.display = DisplayStyle.None;

                    ControlTypeHelpBox.text = HELPBOX_TOGGLE;
                    break;
                case ExpressionControl.ControlType.SubMenu:
                    MenuTypesContainer.style.display = DisplayStyle.Flex;
                    SubMenuObjectField.style.display = DisplayStyle.Flex;
                    TwoAxisPuppetContainer.style.display = DisplayStyle.None;
                    FourAxisPuppetContainer.style.display = DisplayStyle.None;
                    RotationParamField.style.display = DisplayStyle.None;

                    ControlTypeHelpBox.text = HELPBOX_SUBMENU;

                    SubMenuObjectField.BindProperty(propSubMenu, typeof(ExpressionsMenu), "SubMenu");
                    break;
                case ExpressionControl.ControlType.TwoAxisPuppet:
                    MenuTypesContainer.style.display = DisplayStyle.Flex;
                    SubMenuObjectField.style.display = DisplayStyle.None;
                    TwoAxisPuppetContainer.style.display = DisplayStyle.Flex;
                    FourAxisPuppetContainer.style.display = DisplayStyle.None;
                    RotationParamField.style.display = DisplayStyle.None;

                    ControlTypeHelpBox.text = HELPBOX_TWO_AXIS_PUPPET;

                    propSubParameters.arraySize = 2;
                    propLabels.arraySize = 4;
                    propControl.serializedObject.ApplyModifiedProperties();

                    SerializedProperty propHorizontal = propSubParameters.GetArrayElementAtIndex(0);
                    SerializedProperty propVertical = propSubParameters.GetArrayElementAtIndex(1);

                    HorizontalParam.BindParameter(
                        propHorizontal.FindPropertyRelative(nameof(ExpressionControl.Parameter.name)),
                        Menu.Parameters,
                        false);

                    VerticalParam.BindParameter(
                        propVertical.FindPropertyRelative(nameof(ExpressionControl.Parameter.name)),
                        Menu.Parameters,
                        false);

                    UpLabel.BindProperty(propLabels.GetArrayElementAtIndex(0));
                    RightLabel.BindProperty(propLabels.GetArrayElementAtIndex(1));
                    DownLabel.BindProperty(propLabels.GetArrayElementAtIndex(2));
                    LeftLabel.BindProperty(propLabels.GetArrayElementAtIndex(3));
                    break;
                case ExpressionControl.ControlType.FourAxisPuppet:
                    MenuTypesContainer.style.display = DisplayStyle.Flex;
                    SubMenuObjectField.style.display = DisplayStyle.None;
                    TwoAxisPuppetContainer.style.display = DisplayStyle.None;
                    FourAxisPuppetContainer.style.display = DisplayStyle.Flex;
                    RotationParamField.style.display = DisplayStyle.None;

                    ControlTypeHelpBox.text = HELPBOX_FOUR_AXIS_PUPPET;

                    propSubParameters.arraySize = 4;
                    propLabels.arraySize = 4;
                    propControl.serializedObject.ApplyModifiedProperties();

                    SerializedProperty propUp = propSubParameters.GetArrayElementAtIndex(0);
                    SerializedProperty propRight = propSubParameters.GetArrayElementAtIndex(1);
                    SerializedProperty propDown = propSubParameters.GetArrayElementAtIndex(2);
                    SerializedProperty propLeft = propSubParameters.GetArrayElementAtIndex(3);
                    FourAxisUpParam.BindParameter(
                        propUp.FindPropertyRelative(nameof(ExpressionControl.Parameter.name)),
                        Menu.Parameters,
                        false);
                    FourAxisRightParam.BindParameter(
                        propRight.FindPropertyRelative(nameof(ExpressionControl.Parameter.name)),
                        Menu.Parameters,
                        false);
                    FourAxisDownParam.BindParameter(
                        propDown.FindPropertyRelative(nameof(ExpressionControl.Parameter.name)),
                        Menu.Parameters,
                        false);
                    FourAxisLeftParam.BindParameter(
                        propLeft.FindPropertyRelative(nameof(ExpressionControl.Parameter.name)),
                        Menu.Parameters,
                        false);

                    FourAxisUpLabel.BindProperty(propLabels.GetArrayElementAtIndex(0));
                    FourAxisRightLabel.BindProperty(propLabels.GetArrayElementAtIndex(1));
                    FourAxisDownLabel.BindProperty(propLabels.GetArrayElementAtIndex(2));
                    FourAxisLeftLabel.BindProperty(propLabels.GetArrayElementAtIndex(3));
                    break;
                case ExpressionControl.ControlType.RadialPuppet:
                    MenuTypesContainer.style.display = DisplayStyle.Flex;
                    SubMenuObjectField.style.display = DisplayStyle.None;
                    TwoAxisPuppetContainer.style.display = DisplayStyle.None;
                    FourAxisPuppetContainer.style.display = DisplayStyle.None;
                    RotationParamField.style.display = DisplayStyle.Flex;

                    ControlTypeHelpBox.text = HELPBOX_RADIAL_PUPPET;

                    propSubParameters.arraySize = 1;
                    propLabels.arraySize = 0;
                    propControl.serializedObject.ApplyModifiedProperties();

                    SerializedProperty propRotation = propSubParameters.GetArrayElementAtIndex(0);
                    RotationParamField.BindParameter(
                        propRotation.FindPropertyRelative(nameof(ExpressionControl.Parameter.name)),
                        Menu.Parameters,
                        false);
                    break;
            }
        }

        private void BindValueFields()
        {
            ValueSlider.RegisterValueChangedCallback(evt =>
            {
                propValue.floatValue = evt.newValue;
                propControl.serializedObject.ApplyModifiedProperties();
                ValueIntSlider.SetValueWithoutNotify(Mathf.FloorToInt(evt.newValue));
            });

            ValueIntSlider.RegisterValueChangedCallback(evt =>
            {
                propValue.floatValue = evt.newValue;
                propControl.serializedObject.ApplyModifiedProperties();
                ValueSlider.SetValueWithoutNotify(evt.newValue);
            });

            ValueToggle.RegisterValueChangedCallback(evt =>
            {
                propValue.floatValue = evt.newValue ? 1f : 0f;
                propControl.serializedObject.ApplyModifiedProperties();
            });
        }

        private void TypeInfoButtonClicked()
        {
            ControlTypeHelpBox.style.display = ShowControlTypeHelpBox ? DisplayStyle.None : DisplayStyle.Flex;
        }

        private void DisplayValueSlider()
        {
            if (ControlParameterField.Parameter != null && ControlParameterField.Index > 0)
            {
                switch (ControlParameterField.Parameter.valueType)
                {
                    case VRCExpressionParameters.ValueType.Int:
                        ValueSlider.style.display = DisplayStyle.None;
                        ValueIntSlider.style.display = DisplayStyle.Flex;
                        ValueToggle.style.display = DisplayStyle.None;
                        break;
                    case VRCExpressionParameters.ValueType.Float:
                        ValueSlider.style.display = DisplayStyle.Flex;
                        ValueIntSlider.style.display = DisplayStyle.None;
                        ValueToggle.style.display = DisplayStyle.None;
                        break;
                    default:
                    case VRCExpressionParameters.ValueType.Bool:
                        ValueSlider.style.display = DisplayStyle.None;
                        ValueIntSlider.style.display = DisplayStyle.None;
                        ValueToggle.style.display = DisplayStyle.Flex;
                        break;
                }
            }
            else
            {
                ValueSlider.style.display = DisplayStyle.None;
                ValueIntSlider.style.display = DisplayStyle.None;
                ValueToggle.style.display = DisplayStyle.None;
            }
        }

        private void UpdateValueSliders()
        {
            ValueSlider.SetValueWithoutNotify(propValue.floatValue);
            ValueIntSlider.SetValueWithoutNotify(Mathf.FloorToInt(propValue.floatValue));
            ValueToggle.SetValueWithoutNotify(propValue.floatValue > 0f);
        }
    }
}