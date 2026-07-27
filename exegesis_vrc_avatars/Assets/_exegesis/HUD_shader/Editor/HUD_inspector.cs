using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using System;
using System.Collections.Generic;

// Custom ShaderGUI for the exegesis/HUD shader. Groups the shader's properties into
// collapsible categories.
//
// This shader is CANCERFREE (overlay-only). The upstream VRC-Cancerspace screen-effect
// categories (screen shake, wobble, blur, distortion mapping, screen color adjustment,
// screen transforms, the render-queue exporter) were removed along with that machinery.
public class HUD_inspector : ShaderGUI {

    // Photoshop-style blend modes for the mask blend popup. Order mirrors the
    // BLENDMODE_* constants in CGInclude/CSEnums.cginc — keep them in sync.
    public enum BlendMode {
        Multiply,
        Screen,
        Overlay,
        Add,
        Subtract,
        Difference,
        Divide,
        Darken,
        Lighten,
        Normal,
        ColorDodge,
        ColorBurn,
        HardLight,
        SoftLight,
        Exclusion
    }

    static class Styles {
        public const string sliderModeCheckboxText = "Sliders for dummies";
        public const string randomizerOptionsCheckboxText = "Show Randomizer Controls";
        public const string shouldRandomizeCheckboxText = "Allow randomization";
        public static readonly GUIContent overlayImageText = new GUIContent("Image Overlay", "The overlay image and color.");

        public const string targetObjectSettingsTitle = "Target Object Settings";
        public const string particleSystemSettingsTitle = "Particle System Settings";
        public const string falloffSettingsTitle = "Falloff Settings";
        public const string overlaySettingsTitle = "Overlay";
        public const string overlay2SettingsTitle = "Secondary Overlay";
        public const string compassSettingsTitle = "HUD Compass";
        public const string horizonSettingsTitle = "HUD Artificial Horizon";
        public const string statusBarsTitle = "HUD Status Bars";
        public const string paperDollTitle = "Paper Doll";
        public const string projectionRotationText = "Rotation";
        public const string stencilTitle = "Stencil Testing";
        public const string maskingTitle = "Masking";
        public const string miscSettingsTitle = "Misc";
        public const string blendSettingsTitle = "Blending";

        public static readonly string[] blendNames = Enum.GetNames(typeof(BlendMode));
    }

    delegate void CSCategorySetup(MaterialEditor me);

    class CSCategory {
        public string name;
        public GUIStyle style;
        public CSCategorySetup setupDelegate;

        public CSCategory(string name, GUIStyle style, CSCategorySetup setupDelegate) {
            this.name = name;
            this.style = style;
            this.setupDelegate = setupDelegate;
        }
    }

    // Thin wrapper so a MaterialProperty can be passed around tersely.
    class CSProperty {
        public MaterialProperty prop;
        public CSProperty(MaterialProperty property) { prop = property; }
        public static implicit operator CSProperty(MaterialProperty property) => new CSProperty(property);
    }

    // Body regions for the paper doll, in the order the shader/property names use them.
    static readonly string[] PaperDollRegions = {
        "Head", "Chest", "Abdomen", "Hips", "LArm", "RArm", "LLeg", "RLeg"
    };

    static bool sliderMode = true;
    static int categoryExpansionFlags;
    static bool showRandomizerOptions = false;
    static readonly HashSet<string> propertiesWithRandomization = new HashSet<string>();

    bool initialized;
    bool randomizingCurrentPass;
    System.Random rng;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props) {
        if (!initialized) {
            rng = new System.Random();
            initialized = true;
        }

        GUIStyle headerStyle = new GUIStyle(EditorStyles.foldout);
        headerStyle.fontStyle = FontStyle.Bold;
        headerStyle.onNormal = EditorStyles.boldLabel.onNormal;
        headerStyle.onFocused = EditorStyles.boldLabel.onFocused;

        List<CSCategory> categories = new List<CSCategory>();

        categories.Add(new CSCategory(Styles.falloffSettingsTitle, headerStyle, me => {
            CSProperty falloffCurve = FindProperty("_FalloffCurve", props);
            CSProperty falloffDepth = FindProperty("_DepthFalloff", props);
            CSProperty falloffColor = FindProperty("_ColorFalloff", props);

            DisplayRegularProperty(me, falloffCurve);
            if (falloffCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_MinFalloff", props));
            DisplayRegularProperty(me, FindProperty("_MaxFalloff", props));
            DisplayRegularProperty(me, falloffDepth);
            if (falloffDepth.prop.floatValue > .5) {
                CSProperty falloffDepthCurve = FindProperty("_DepthFalloffCurve", props);
                DisplayRegularProperty(me, falloffDepthCurve);
                if (falloffDepthCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_DepthMinFalloff", props));
                DisplayRegularProperty(me, FindProperty("_DepthMaxFalloff", props));
            }
            DisplayRegularProperty(me, falloffColor);
            if (falloffColor.prop.floatValue > .5) {
                CSProperty falloffColorCurve = FindProperty("_ColorFalloffCurve", props);
                DisplayRegularProperty(me, FindProperty("_ColorChannelForFalloff", props));
                DisplayRegularProperty(me, falloffColorCurve);
                if (falloffColorCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_ColorMinFalloff", props));
                DisplayRegularProperty(me, FindProperty("_ColorMaxFalloff", props));
            }
        }));

        categories.Add(new CSCategory(Styles.particleSystemSettingsTitle, headerStyle, me => {
            CSProperty falloffCurve = FindProperty("_LifetimeFalloffCurve", props);
            CSProperty falloff = FindProperty("_LifetimeFalloff", props);

            DisplayRegularProperty(me, FindProperty("_ParticleSystem", props));
            DisplayRegularProperty(me, falloff);
            if (falloff.prop.floatValue > .5) {
                DisplayRegularProperty(me, falloffCurve);
                if (falloffCurve.prop.floatValue > .5) DisplayRegularProperty(me, FindProperty("_LifetimeMinFalloff", props));
                DisplayRegularProperty(me, FindProperty("_LifetimeMaxFalloff", props));
            }
        }));

        categories.Add(new CSCategory("HUD", headerStyle, me => {
            DisplayFloatRangeProperty(me, FindProperty("_HUDScale", props));
            DisplayFloatRangeProperty(me, FindProperty("_HUDOpacity", props));
            DisplayFloatRangeProperty(me, FindProperty("_HUDDriftRadius", props));
            DisplayRegularProperty(me, FindProperty("_HUDDriftPeriod", props));
        }));

        categories.Add(new CSCategory(Styles.overlaySettingsTitle, headerStyle, me => {
            CSProperty overlayImageType = FindProperty("_OverlayImageType", props);
            CSProperty overlayImage = FindProperty("_MainTex", props);
            CSProperty overlayRotation = FindProperty("_MainTexRotation", props);
            CSProperty overlayPixelate = FindProperty("_PixelatedSampling", props);
            CSProperty overlayScrollSpeedX = FindProperty("_MainTexScrollSpeedX", props);
            CSProperty overlayScrollSpeedY = FindProperty("_MainTexScrollSpeedY", props);
            CSProperty overlayBoundary = FindProperty("_OverlayBoundaryHandling", props);
            CSProperty overlayColor = FindProperty("_OverlayColor", props);

            DisplayRegularProperty(me, overlayImageType);
            switch ((int) overlayImageType.prop.floatValue) {
                case 0: // Image
                case 1: // Flipbook
                    DisplayRegularProperty(me, overlayBoundary);
                    DisplayRegularProperty(me, overlayPixelate);
                    me.TexturePropertySingleLine(Styles.overlayImageText, overlayImage.prop, overlayColor.prop);
                    me.TextureScaleOffsetProperty(overlayImage.prop);
                    DisplayFloatWithSliderMode(me, overlayRotation);
                    if (overlayBoundary.prop.floatValue != 0) {
                        DisplayFloatWithSliderMode(me, overlayScrollSpeedX);
                        DisplayFloatWithSliderMode(me, overlayScrollSpeedY);
                    }
                    if ((int) overlayImageType.prop.floatValue == 1) {
                        DisplayIntField(me, FindProperty("_FlipbookTotalFrames", props));
                        DisplayIntField(me, FindProperty("_FlipbookStartFrame", props));
                        DisplayIntField(me, FindProperty("_FlipbookRows", props));
                        DisplayIntField(me, FindProperty("_FlipbookColumns", props));
                        DisplayFloatProperty(me, FindProperty("_FlipbookFPS", props));
                    }
                    break;
                case 2: // Cubemap
                    DisplayRegularProperty(me, FindProperty("_OverlayCubemap", props));
                    DisplayColorProperty(me, overlayColor);
                    DisplayVec3WithSliderMode(me, "Rotation",
                        FindProperty("_OverlayCubemapRotationX", props),
                        FindProperty("_OverlayCubemapRotationY", props),
                        FindProperty("_OverlayCubemapRotationZ", props));
                    DisplayVec3WithSliderMode(me, "Rotation Speed",
                        FindProperty("_OverlayCubemapSpeedX", props),
                        FindProperty("_OverlayCubemapSpeedY", props),
                        FindProperty("_OverlayCubemapSpeedZ", props));
                    break;
            }

            DisplayFloatRangeProperty(me, FindProperty("_BlendAmount", props));
        }));

        categories.Add(new CSCategory(Styles.overlay2SettingsTitle, headerStyle, me => {
            CSProperty tex   = FindProperty("_Overlay2Tex", props);
            CSProperty color = FindProperty("_Overlay2Color", props);

            DisplayRegularProperty(me, FindProperty("_Overlay2Enabled", props));
            me.TexturePropertySingleLine(new GUIContent("Secondary Overlay"), tex.prop, color.prop);
            me.TextureScaleOffsetProperty(tex.prop);
            DisplayFloatWithSliderMode(me, FindProperty("_Overlay2Rotation", props));
            DisplayRegularProperty(me, FindProperty("_Overlay2Pixelated", props));
            DisplayFloatWithSliderMode(me, FindProperty("_Overlay2ScrollSpeedX", props));
            DisplayFloatWithSliderMode(me, FindProperty("_Overlay2ScrollSpeedY", props));
            DisplayFloatRangeProperty(me, FindProperty("_Overlay2Opacity", props));
        }));

        categories.Add(new CSCategory(Styles.compassSettingsTitle, headerStyle, me => {
            CSProperty compassTex  = FindProperty("_CompassTex", props);
            CSProperty compassTint = FindProperty("_CompassTint", props);
            CSProperty compassMask = FindProperty("_CompassMask", props);
            CSProperty compassSnap = FindProperty("_CompassSnap", props);

            me.TexturePropertySingleLine(new GUIContent("Compass Strip"), compassTex.prop, compassTint.prop);
            DisplayFloatRangeProperty(me, FindProperty("_CompassWidth", props));
            DisplayFloatRangeProperty(me, FindProperty("_CompassHeight", props));
            DisplayFloatRangeProperty(me, FindProperty("_CompassYOffset", props));
            me.TexturePropertySingleLine(new GUIContent("Compass Mask (R)"), compassMask.prop);

            EditorGUILayout.Space();
            DisplayRegularProperty(me, compassSnap);
            if (compassSnap.prop.floatValue != 0) {
                DisplayFloatProperty(me, FindProperty("_CompassHUDResX", props));
                DisplayFloatProperty(me, FindProperty("_CompassHUDResY", props));
                DisplayFloatProperty(me, FindProperty("_CompassTexResX", props));
                DisplayFloatProperty(me, FindProperty("_CompassTexResY", props));
            }
        }));

        categories.Add(new CSCategory(Styles.horizonSettingsTitle, headerStyle, me => {
            DisplayRegularProperty(me, FindProperty("_HorizonPixelated", props));
            DisplayColorProperty(me, FindProperty("_HorizonColor", props));
            DisplayColorProperty(me, FindProperty("_HorizonColorUp90", props));
            DisplayColorProperty(me, FindProperty("_HorizonColorDown90", props));
            DisplayFloatRangeProperty(me, FindProperty("_HorizonThickness", props));
            DisplayRegularProperty(me, FindProperty("_HorizonHUDResX", props));
            DisplayRegularProperty(me, FindProperty("_HorizonHUDResY", props));
            DisplayFloatRangeProperty(me, FindProperty("_HorizonBandsPerSide", props));
            me.TexturePropertySingleLine(new GUIContent("Horizon Mask (B)"), FindProperty("_HorizonMask", props));
            DisplayRegularProperty(me, FindProperty("_HorizonRollOffset", props));
            DisplayRegularProperty(me, FindProperty("_HorizonUpperBandsDotted", props));
        }));

        categories.Add(new CSCategory(Styles.statusBarsTitle, headerStyle, me => {
            DisplayRegularProperty(me, FindProperty("_StatusBarsEnabled", props));
            DisplayRegularProperty(me, FindProperty("_StatusBarsPixelated", props));
            me.TexturePropertySingleLine(new GUIContent("Mask (RGB)"), FindProperty("_StatusBarsMask", props));
            DisplayFloatRangeProperty(me, FindProperty("_StatusBarsJitterIntensity", props));
            DisplayRegularProperty(me, FindProperty("_StatusBarsJitterFrequency", props));
            DisplayRegularProperty(me, FindProperty("_StatusBarsHUDResX", props));
            DisplayRegularProperty(me, FindProperty("_StatusBarsHUDResY", props));

            for (int b = 0; b < 3; ++b) {
                if (EditorGUILayout.Foldout(true, "Status Bar " + b, true)) {
                    EditorGUI.indentLevel++;
                    DisplayRegularProperty(me, FindProperty("_StatusBar" + b + "Layout", props));
                    DisplayFloatRangeProperty(me, FindProperty("_StatusBar" + b + "Fill", props));
                    DisplayRegularProperty(me, FindProperty("_StatusBar" + b + "BottomToTop", props));
                    DisplayRegularProperty(me, FindProperty("_StatusBar" + b + "Jitter", props));
                    me.TexturePropertySingleLine(new GUIContent("Gradient"), FindProperty("_StatusBar" + b + "Gradient", props));
                    EditorGUI.indentLevel--;
                }
            }
        }));

        categories.Add(new CSCategory(Styles.paperDollTitle, headerStyle, me => {
            DisplayRegularProperty(me, FindProperty("_PaperDollEnabled", props));
            me.TexturePropertySingleLine(new GUIContent("Mask"), FindProperty("_PaperDollMask", props));
            DisplayColorProperty(me, FindProperty("_PaperDollBaseColor", props));
            DisplayColorProperty(me, FindProperty("_PaperDollTouchColor", props));
            DisplayColorProperty(me, FindProperty("_PaperDollDamageColor", props));

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Regions", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;

            EditorGUILayout.LabelField("Touch", EditorStyles.boldLabel);
            foreach (string region in PaperDollRegions)
                DisplayRegularProperty(me, FindProperty("_PD_" + region + "Touch", props));

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("Damage", EditorStyles.boldLabel);
            foreach (string region in PaperDollRegions)
                DisplayRegularProperty(me, FindProperty("_PD_" + region + "Damage", props));

            EditorGUI.indentLevel--;
        }));

        categories.Add(new CSCategory(Styles.blendSettingsTitle, headerStyle, me => {
            DisplayRegularProperty(me, FindProperty("_BlendOp", props));
            DisplayRegularProperty(me, FindProperty("_BlendSource", props));
            DisplayRegularProperty(me, FindProperty("_BlendDestination", props));
        }));

        categories.Add(new CSCategory("Sensor Scanner", headerStyle, me => {
            EditorGUILayout.HelpBox(
                "First-person, PC-focused. Driven by the scene DEPTH texture (world-provided " +
                "by a realtime shadow light — no avatar light needed) + reconstructed normals. " +
                "Works in lit worlds and on shadow-casting props/avatars; blank in fullbright / " +
                "no-depth worlds. Toggle modes and mix freely.",
                MessageType.Info);

            CSProperty scan = FindProperty("_ScanEnabled", props);
            DisplayRegularProperty(me, scan);
            if (scan.prop.floatValue <= 0.5f) return;

            EditorGUI.indentLevel++;
            DisplayRegularProperty(me, FindProperty("_ScanColor", props));
            DisplayRegularProperty(me, FindProperty("_ScanBrightness", props));
            EditorGUILayout.Space();

            DrawScanMode(me, props, "_ScanNormalShade", new[] { "_ScanNormalContrast" });
            DrawScanMode(me, props, "_ScanEdges", new[] { "_ScanEdgeColor", "_ScanEdgeDepthThreshold", "_ScanEdgeNormalThreshold" });
            DrawScanMode(me, props, "_ScanRange", new[] { "_ScanRangeNearColor", "_ScanRangeFarColor", "_ScanRangeNear", "_ScanRangeFar" });
            DrawScanMode(me, props, "_ScanContours", new[] { "_ScanContourColor", "_ScanContourSpacing" });
            DrawScanMode(me, props, "_ScanSweep", new[] { "_ScanSweepColor", "_ScanSweepSpeed", "_ScanSweepRange", "_ScanSweepThickness" });
            EditorGUI.indentLevel--;
        }));

        categories.Add(new CSCategory(Styles.targetObjectSettingsTitle, headerStyle, me => {
            DisplayVec4Field(me, "Position",
                FindProperty("_ObjectPositionX", props), FindProperty("_ObjectPositionY", props),
                FindProperty("_ObjectPositionZ", props), FindProperty("_ObjectPositionA", props));
            DisplayVec3Field(me, "Rotation",
                FindProperty("_ObjectRotationX", props), FindProperty("_ObjectRotationY", props),
                FindProperty("_ObjectRotationZ", props));
            DisplayVec4Field(me, "Scale",
                FindProperty("_ObjectScaleX", props), FindProperty("_ObjectScaleY", props),
                FindProperty("_ObjectScaleZ", props), FindProperty("_ObjectScaleA", props));
            DisplayRegularProperty(me, FindProperty("_Puffiness", props));
        }));

        categories.Add(new CSCategory(Styles.stencilTitle, headerStyle, me => {
            DisplayIntSlider(me, FindProperty("_StencilRef", props), 0, 255);
            DisplayRegularProperty(me, FindProperty("_StencilComp", props));
            DisplayRegularProperty(me, FindProperty("_StencilPassOp", props));
            DisplayRegularProperty(me, FindProperty("_StencilFailOp", props));
            DisplayRegularProperty(me, FindProperty("_StencilZFailOp", props));
            DisplayIntSlider(me, FindProperty("_StencilReadMask", props), 0, 255);
            DisplayIntSlider(me, FindProperty("_StencilWriteMask", props), 0, 255);
        }));

        categories.Add(new CSCategory(Styles.maskingTitle, headerStyle, me => {
            DisplayRegularProperty(me, FindProperty("_OverlayMask", props));
            DisplayFloatRangeProperty(me, FindProperty("_OverlayMaskOpacity", props));

            DisplayRegularProperty(me, FindProperty("_OverallEffectMask", props));
            DisplayFloatRangeProperty(me, FindProperty("_OverallEffectMaskOpacity", props));
            BlendModePopup(me, FindProperty("_OverallEffectMaskBlendMode", props));

            EditorGUILayout.Space();
            DisplayRegularProperty(me, FindProperty("_OverallAmplitudeMask", props));
            DisplayFloatRangeProperty(me, FindProperty("_OverallAmplitudeMaskOpacity", props));
        }));

        categories.Add(new CSCategory(Styles.miscSettingsTitle, headerStyle, me => {
            DisplayRegularProperty(me, FindProperty("_CullMode", props));
            DisplayRegularProperty(me, FindProperty("_ZTest", props));
            DisplayRegularProperty(me, FindProperty("_ZWrite", props));
            ShowColorMaskFlags(me, FindProperty("_ColorMask", props));
            DisplayRegularProperty(me, FindProperty("_MirrorMode", props));
            DisplayRegularProperty(me, FindProperty("_EyeSelector", props));
            DisplayRegularProperty(me, FindProperty("_PlatformSelector", props));
            CSProperty projectionType = FindProperty("_ProjectionType", props);
            DisplayRegularProperty(me, projectionType);
            if (projectionType.prop.floatValue != 2) {
                DisplayVec3WithSliderMode(me, Styles.projectionRotationText,
                    FindProperty("_ProjectionRotX", props),
                    FindProperty("_ProjectionRotY", props),
                    FindProperty("_ProjectionRotZ", props));
            }
        }));

        EditorGUIUtility.labelWidth = 0f;

        sliderMode = EditorGUILayout.ToggleLeft(Styles.sliderModeCheckboxText, sliderMode);
        showRandomizerOptions = EditorGUILayout.ToggleLeft(Styles.randomizerOptionsCheckboxText, showRandomizerOptions);
        if (showRandomizerOptions) {
            randomizingCurrentPass = GUILayout.Button("Randomize Values");
        }

        int oldflags = categoryExpansionFlags;
        int newflags = 0;
        for (int i = 0; i < categories.Count; ++i) {
            bool expanded = EditorGUILayout.Foldout((oldflags & (1 << i)) != 0, categories[i].name, true, categories[i].style);
            newflags |= (expanded ? 1 : 0) << i;
            if (expanded) {
                EditorGUI.indentLevel++;
                categories[i].setupDelegate(materialEditor);
                EditorGUI.indentLevel--;
            }
        }
        categoryExpansionFlags = newflags;

        materialEditor.RenderQueueField();

        randomizingCurrentPass = false;
    }

    // ---- shared randomization boilerplate ---------------------------------------

    // True if this property is opted into randomization and this is a "Randomize" pass.
    bool ShouldRandomizeNow(string propName) {
        return randomizingCurrentPass && propertiesWithRandomization.Contains(propName);
    }

    // Draws the per-property "Allow randomization" opt-in toggle (only while the
    // randomizer controls are shown) and keeps the opt-in set up to date.
    void DrawRandomizeToggle(string propName) {
        if (!showRandomizerOptions) return;
        bool enabled = propertiesWithRandomization.Contains(propName);
        bool newState = EditorGUILayout.ToggleLeft(Styles.shouldRandomizeCheckboxText, enabled);
        if (newState == enabled) return;
        if (newState) propertiesWithRandomization.Add(propName);
        else propertiesWithRandomization.Remove(propName);
    }

    // ---- property drawers -------------------------------------------------------

    void BlendModePopup(MaterialEditor materialEditor, CSProperty prop) {
        EditorGUI.showMixedValue = prop.prop.hasMixedValue;
        var mode = (BlendMode) prop.prop.floatValue;
        EditorGUI.BeginChangeCheck();
        mode = (BlendMode) EditorGUILayout.Popup(prop.prop.displayName, (int) mode, Styles.blendNames);
        if (EditorGUI.EndChangeCheck()) {
            materialEditor.RegisterPropertyChangeUndo(prop.prop.displayName);
            prop.prop.floatValue = (float) mode;
        }
        EditorGUI.showMixedValue = false;
    }

    void DisplayRegularProperty(MaterialEditor me, CSProperty prop) {
        me.ShaderProperty(prop.prop, prop.prop.displayName);
    }

    // Draws a scanner mode toggle and, when it's on, its indented sub-properties.
    void DrawScanMode(MaterialEditor me, MaterialProperty[] props, string toggleName, string[] subProps) {
        CSProperty toggle = FindProperty(toggleName, props);
        DisplayRegularProperty(me, toggle);
        if (toggle.prop.floatValue > 0.5f) {
            EditorGUI.indentLevel++;
            foreach (var p in subProps) DisplayRegularProperty(me, FindProperty(p, props));
            EditorGUI.indentLevel--;
        }
        EditorGUILayout.Space();
    }

    void DisplayColorProperty(MaterialEditor me, CSProperty prop, bool randomizable = true) {
        if (ShouldRandomizeNow(prop.prop.name)) {
            prop.prop.colorValue = new Color(
                (float) rng.NextDouble(), (float) rng.NextDouble(),
                (float) rng.NextDouble(), (float) rng.NextDouble());
        }
        me.ColorProperty(prop.prop, prop.prop.displayName);
        if (randomizable) DrawRandomizeToggle(prop.prop.name);
    }

    void DisplayFloatRangeProperty(MaterialEditor me, CSProperty prop, bool randomizable = true) {
        if (ShouldRandomizeNow(prop.prop.name)) {
            prop.prop.floatValue = (float) (rng.NextDouble() *
                (prop.prop.rangeLimits.y - prop.prop.rangeLimits.x) + prop.prop.rangeLimits.x);
        }
        me.RangeProperty(prop.prop, prop.prop.displayName);
        if (randomizable) DrawRandomizeToggle(prop.prop.name);
    }

    void DisplayFloatProperty(MaterialEditor me, CSProperty prop, bool randomizable = true) {
        if (ShouldRandomizeNow(prop.prop.name)) {
            prop.prop.floatValue = (float) (rng.NextDouble() * 100);
        }
        me.FloatProperty(prop.prop, prop.prop.displayName);
        if (randomizable) DrawRandomizeToggle(prop.prop.name);
    }

    void DisplayFloatWithSliderMode(MaterialEditor me, CSProperty prop, bool randomizable = true) {
        if (sliderMode) DisplayFloatRangeProperty(me, prop, randomizable);
        else DisplayFloatProperty(me, prop, randomizable);
    }

    void DisplayVec3WithSliderMode(MaterialEditor me, string displayName, CSProperty xProp, CSProperty yProp, CSProperty zProp) {
        if (sliderMode) {
            DisplayFloatRangeProperty(me, xProp.prop);
            DisplayFloatRangeProperty(me, yProp.prop);
            DisplayFloatRangeProperty(me, zProp.prop);
        } else {
            DisplayVec3Field(me, displayName, xProp.prop, yProp.prop, zProp.prop);
        }
    }

    void DisplayVec3Field(MaterialEditor materialEditor, string displayName, CSProperty _xProp, CSProperty _yProp, CSProperty _zProp) {
        MaterialProperty xProp = _xProp.prop;
        MaterialProperty yProp = _yProp.prop;
        MaterialProperty zProp = _zProp.prop;
        materialEditor.BeginAnimatedCheck(xProp);
        materialEditor.BeginAnimatedCheck(yProp);
        materialEditor.BeginAnimatedCheck(zProp);
        EditorGUI.BeginChangeCheck();
        EditorGUI.showMixedValue = xProp.hasMixedValue || yProp.hasMixedValue || zProp.hasMixedValue;

        var oldLabelWidth = EditorGUIUtility.labelWidth;
        EditorGUIUtility.labelWidth = 0f;

        Vector3 v = EditorGUILayout.Vector3Field(displayName, new Vector3(xProp.floatValue, yProp.floatValue, zProp.floatValue));

        EditorGUIUtility.labelWidth = oldLabelWidth;
        EditorGUI.showMixedValue = false;

        if (EditorGUI.EndChangeCheck()) {
            xProp.floatValue = v.x;
            yProp.floatValue = v.y;
            zProp.floatValue = v.z;
        }

        materialEditor.EndAnimatedCheck();
        materialEditor.EndAnimatedCheck();
        materialEditor.EndAnimatedCheck();
    }

    void DisplayVec4Field(MaterialEditor materialEditor, string displayName, CSProperty _xProp, CSProperty _yProp, CSProperty _zProp, CSProperty _wProp) {
        MaterialProperty xProp = _xProp.prop;
        MaterialProperty yProp = _yProp.prop;
        MaterialProperty zProp = _zProp.prop;
        MaterialProperty wProp = _wProp.prop;
        materialEditor.BeginAnimatedCheck(xProp);
        materialEditor.BeginAnimatedCheck(yProp);
        materialEditor.BeginAnimatedCheck(zProp);
        materialEditor.BeginAnimatedCheck(wProp);
        EditorGUI.BeginChangeCheck();
        EditorGUI.showMixedValue = xProp.hasMixedValue || yProp.hasMixedValue || zProp.hasMixedValue || wProp.hasMixedValue;

        var oldLabelWidth = EditorGUIUtility.labelWidth;
        EditorGUIUtility.labelWidth = 0f;

        Vector4 v = EditorGUILayout.Vector4Field(displayName, new Vector4(xProp.floatValue, yProp.floatValue, zProp.floatValue, wProp.floatValue));

        EditorGUIUtility.labelWidth = oldLabelWidth;
        EditorGUI.showMixedValue = false;

        if (EditorGUI.EndChangeCheck()) {
            xProp.floatValue = v.x;
            yProp.floatValue = v.y;
            zProp.floatValue = v.z;
            wProp.floatValue = v.w;
        }

        materialEditor.EndAnimatedCheck();
        materialEditor.EndAnimatedCheck();
        materialEditor.EndAnimatedCheck();
        materialEditor.EndAnimatedCheck();
    }

    void DisplayIntField(MaterialEditor materialEditor, CSProperty property) {
        EditorGUI.showMixedValue = property.prop.hasMixedValue;
        int v = (int) property.prop.floatValue;
        EditorGUI.BeginChangeCheck();
        v = EditorGUILayout.IntField(property.prop.displayName, v);
        if (EditorGUI.EndChangeCheck()) {
            materialEditor.RegisterPropertyChangeUndo(property.prop.displayName);
            property.prop.floatValue = (float) v;
        }
        EditorGUI.showMixedValue = false;
    }

    void DisplayIntSlider(MaterialEditor materialEditor, CSProperty property, int min, int max) {
        EditorGUI.showMixedValue = property.prop.hasMixedValue;
        int v = (int) property.prop.floatValue;
        EditorGUI.BeginChangeCheck();
        v = EditorGUILayout.IntSlider(property.prop.displayName, v, min, max);
        if (EditorGUI.EndChangeCheck()) {
            materialEditor.RegisterPropertyChangeUndo(property.prop.displayName);
            property.prop.floatValue = (float) v;
        }
        EditorGUI.showMixedValue = false;
    }

    void ShowColorMaskFlags(MaterialEditor materialEditor, CSProperty property) {
        EditorGUI.showMixedValue = property.prop.hasMixedValue;
        ColorWriteMask v = (ColorWriteMask) ((int) property.prop.floatValue);
        EditorGUI.BeginChangeCheck();
        v = (ColorWriteMask) EditorGUILayout.EnumFlagsField(property.prop.displayName, v);
        if (EditorGUI.EndChangeCheck()) {
            materialEditor.RegisterPropertyChangeUndo(property.prop.displayName);
            int x = (int) v;
            if (x == -1) x = 15;
            property.prop.floatValue = (float) x;
        }
        EditorGUI.showMixedValue = false;
    }
}
