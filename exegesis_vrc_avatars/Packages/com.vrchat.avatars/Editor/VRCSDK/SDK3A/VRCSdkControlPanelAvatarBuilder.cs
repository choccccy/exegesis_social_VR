#if !VRC_CLIENT
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Threading;
using System.Threading.Tasks;
using Cysharp.Threading.Tasks;
using UnityEditor;
using UnityEditor.Animations;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.Animations;
using UnityEngine.Networking;
using UnityEngine.SceneManagement;
using UnityEngine.UIElements;
using VRC.Core;
using VRC.Core.Pool;
using VRC.Dynamics;
using VRC.Editor;
using VRC.SDKBase.Editor.Api;
using VRC.SDKBase.Editor;
using VRC.SDKBase.Editor.BuildPipeline;
using VRC.SDKBase.Editor.Validation;
using VRC.SDKBase.Validation;
using VRC.SDKBase.Validation.Performance;
using VRC.SDKBase.Validation.Performance.Stats;
using VRC.SDK3.Avatars;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3.Avatars.ScriptableObjects;
using VRC.SDK3.Editor.Elements;
using VRC.SDK3A.Editor;
using VRC.SDK3A.Editor.Elements;
using VRC.SDKBase;
using VRC.SDKBase.Editor.Elements;
using Object = UnityEngine.Object;
using Progress = UnityEditor.Progress;
using VRCStation = VRC.SDK3.Avatars.Components.VRCStation;

[assembly: VRCSdkControlPanelBuilder(typeof(VRCSdkControlPanelAvatarBuilder))]
namespace VRC.SDK3A.Editor
{
    public class VRCSdkControlPanelAvatarBuilder : IVRCSdkAvatarBuilderApi
    {
        private const int MAX_ACTION_TEXTURE_SIZE = 256;

        protected VRCSdkControlPanel _builder;
        protected VRC_AvatarDescriptor[] _avatars;
        protected static VRC_AvatarDescriptor _selectedAvatar;
        private static VRCSdkControlPanelAvatarBuilder _instance;

        private static bool ShowAvatarPerformanceDetails
        {
            get => EditorPrefs.GetBool("VRC.SDKBase_showAvatarPerformanceDetails", false);
            set => EditorPrefs.SetBool("VRC.SDKBase_showAvatarPerformanceDetails",
                value);
        }

        private static PropertyInfo _legacyBlendShapeNormalsPropertyInfo;

        private static PropertyInfo LegacyBlendShapeNormalsPropertyInfo
        {
            get
            {
                if (_legacyBlendShapeNormalsPropertyInfo != null)
                {
                    return _legacyBlendShapeNormalsPropertyInfo;
                }

                Type modelImporterType = typeof(ModelImporter);
                _legacyBlendShapeNormalsPropertyInfo = modelImporterType.GetProperty(
                    "legacyComputeAllNormalsFromSmoothingGroupsWhenMeshHasBlendShapes",
                    BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.Public
                );

                return _legacyBlendShapeNormalsPropertyInfo;
            }
        }

        #region Main Interface Methods
        
        private bool _initialized;
        // Performs any first-time initialization tasks
        // This is called when the builder is mounted to the SDK panel
        public virtual void Initialize()
        {
            if (_initialized) return;
            _initialized = true;
            
            GameObject savedAvatar = null;
            if (!string.IsNullOrWhiteSpace(VRCMultiPlatformBuild.MPBContentIdentifier))
            {
                savedAvatar = GetAvatarFromSceneIdentifier(VRCMultiPlatformBuild.MPBContentIdentifier);
            }

            if (VRCMultiPlatformBuild.ShouldContinueMPB(out var isMPBFinished))
            {
                if (savedAvatar == null)
                {
                    Core.Logger.LogError("Failed to find avatar for Multi Platform Build");
                    return;
                }
                
                _selectedAvatar = savedAvatar.GetComponent<VRC_AvatarDescriptor>();
                
                // React to content loading to start a build
                ContentInfoLoaded += StartMultiPlatformBuild;
            } else if (savedAvatar != null) // select the same avatar as at the start of build for better qol
            {
                _selectedAvatar = savedAvatar.GetComponent<VRC_AvatarDescriptor>();
            }

            if (!isMPBFinished) return;
            ContentInfoLoaded += FinishMultiPlatformBuild;
        }
        
        public void ShowSettingsOptions()
        {
            EditorGUILayout.BeginVertical(VRCSdkControlPanel.boxGuiStyle);
            GUILayout.Label("Avatar Options", EditorStyles.boldLabel);
            bool prevShowPerfDetails = ShowAvatarPerformanceDetails;
            bool showPerfDetails =
                EditorGUILayout.ToggleLeft("Show All Avatar Performance Details", prevShowPerfDetails);
            if (showPerfDetails != prevShowPerfDetails)
            {
                ShowAvatarPerformanceDetails = showPerfDetails;
                _builder.ResetIssues();
            }

            EditorGUILayout.EndVertical();
        }
        
        private Texture2D _headerImage;

        public Texture2D GetHeaderImage()
        {
            if (_headerImage != null)
            {
                return _headerImage;
            }
            _headerImage = Resources.Load<Texture2D>("SDK_Banner_CreateAvatar");
            return _headerImage;
        }

        public virtual bool IsValidBuilder(out string message)
        {
            if (VRC.SDKBase.Editor.V3.V3SdkUI.V3Enabled()) 
            {
                message = "Multiple pipelines are present. V3 pipeline will take priority";
                return false;
            }
            FindAvatars();
            message = null;
            if (_avatars != null && _avatars.Length > 0) return true;
            message = "A VRCSceneDescriptor or VRCAvatarDescriptor\nis required to build VRChat SDK Content";
            return false;
        }
        
        protected void FindAvatars()
        {
            List<VRC_AvatarDescriptor> allAvatars = Tools.FindSceneObjectsOfTypeAll<VRC_AvatarDescriptor>().ToList();
            // Select only the active avatars
            VRC_AvatarDescriptor[] newAvatars =
                allAvatars.Where(av => null != av && av.gameObject.activeInHierarchy).ToArray();

            if (_avatars != null)
            {
                foreach (VRC_AvatarDescriptor a in newAvatars)
                    if (_avatars.Contains(a) == false)
                        _builder.CheckedForIssues = false;
            }

            _avatars = newAvatars.Reverse().ToArray();
        }
        
        private const string IDENTIFIER_SEPARATOR = "/*/";
        
        // This creates a unique identifier via the hierarchy path which differentiates between siblings
        private string GetAvatarSceneIdentifier(GameObject target)
        {
            var transform = target.transform;
            var hierarchyPath = transform.name + $"[{transform.GetSiblingIndex()}]";
            while (transform.parent != null)
            {
                transform = transform.parent;
                // Since any characters can be valid in a path - avoid using the regular path separator
                hierarchyPath = transform.name + IDENTIFIER_SEPARATOR + hierarchyPath;
            }
            return hierarchyPath;
        }
        
        private GameObject GetAvatarFromSceneIdentifier(string identifier)
        {
            var chunks = identifier.Split(IDENTIFIER_SEPARATOR, StringSplitOptions.RemoveEmptyEntries).ToList();
            var sceneRoots = SceneManager.GetActiveScene().GetRootGameObjects();

            // if avatar is at root - simply get from roots
            if (chunks.Count == 1)
            {
                var siblingIndexPosition = identifier.LastIndexOf("[", StringComparison.InvariantCulture);
                var siblingIndex = int.Parse(identifier[(siblingIndexPosition + 1)..^1]);
                var targetName = identifier.Substring(0, siblingIndexPosition);
                var targetRoot = sceneRoots[siblingIndex];

                return targetRoot.name == targetName ? targetRoot : null;
            }

            {
                var root = sceneRoots.FirstOrDefault(root => root.name == chunks[0]);
                var target = chunks[chunks.Count];
                
                chunks.RemoveAt(0);
                chunks.RemoveAt(chunks.Count);
                
                if (root == null) return null;
                foreach (var chunk in chunks)
                {
                    root = root.transform.Find(chunk)?.gameObject;
                    if (root == null) return null;    
                }

                var siblingIndexPosition = target.LastIndexOf("[", StringComparison.InvariantCulture);
                var siblingIndex = target[(siblingIndexPosition + 1)..^1];
                var targetName = target.Substring(0, siblingIndexPosition);

                var finalObject = root.transform.GetChild(int.Parse(siblingIndex));
                
                if (finalObject.name == targetName) return finalObject.gameObject;
            }

            return null;
        }

        public void CreateValidationsGUI(VisualElement root)
        {
            _instance ??= this;
            
            // If we're building - skip performing extra validations
            if (BuildPipeline.isBuildingPlayer)
            {
                root.Clear();
                var message = new Label("Building – Please Wait ...");
                message.AddToClassList("m-4");
                return;
            }
            
            _builder.ResetIssues();
            VRC_EditorTools.GetCheckProjectSetupMethod()?.Invoke(_builder, new object[] {});
            if (_selectedAvatar != null)
                OnGUIAvatarCheck(_selectedAvatar);
            _builder.CheckedForIssues = true;
            
            root.Clear();

            root.Add(_builder.CreateIssuesGUI());
            if (_selectedAvatar != null)
            {
                root.Add(_builder.CreateIssuesGUI(_selectedAvatar));
            }
        }
        
        public EventHandler OnContentChanged { get; set; }
        public EventHandler OnShouldRevalidate { get; set; }

        public void RegisterBuilder(VRCSdkControlPanel baseBuilder)
        {
            _builder = baseBuilder;
        }

        public void SelectAllComponents()
        {
            List<Object> show = new List<Object>(Selection.objects);
            foreach (VRC_AvatarDescriptor a in _avatars)
                show.Add(a.gameObject);
            Selection.objects = show.ToArray();
        }
        
        #endregion

        public static void SelectAvatar(VRC_AvatarDescriptor avatar)
        {
            if (_instance == null) return;
            _selectedAvatar = avatar;
            _instance._avatarSelector.SetAvatarSelection(avatar);
            _instance.HandleAvatarSwitch(_instance._visualRoot);
        }

        #region Avatar Validations (IMGUI)
        
        private void OnGUIAvatarCheck(VRC_AvatarDescriptor avatar)
        {
            if (avatar == null) return;
            string vrcFilePath = UnityWebRequest.UnEscapeURL(EditorPrefs.GetString("currentBuildingAssetBundlePath"));
            bool isMobilePlatform = ValidationEditorHelpers.IsMobilePlatform();
            if (!string.IsNullOrEmpty(vrcFilePath))
            {
                if (ValidationEditorHelpers.CheckIfAssetBundleFileTooLarge(ContentType.Avatar, vrcFilePath, out int fileSize, isMobilePlatform))
                {
                    _builder.OnGUIWarning(avatar,
                        ValidationHelpers.GetAssetBundleOverSizeLimitMessageSDKWarning(ContentType.Avatar, fileSize, isMobilePlatform),
                        delegate { Selection.activeObject = avatar.gameObject; }, null);
                }
            }

            if (ValidationEditorHelpers.CheckIfUncompressedAssetBundleFileTooLarge(ContentType.Avatar, out int fileSizeUncompressed, isMobilePlatform))
            {
                _builder.OnGUIWarning(avatar,
                    ValidationHelpers.GetAssetBundleOverSizeLimitMessageSDKWarning(ContentType.Avatar, fileSizeUncompressed, isMobilePlatform, false),
                    delegate { Selection.activeObject = avatar.gameObject; }, null);
            }

            // We need to make sure groups are refreshed first, otherwise unregistered constraints won't have accurate values.
            VRCConstraintBase[] vrcConstraints = avatar.GetComponentsInChildren<VRCConstraintBase>(true);
            VRCConstraintManager.Sdk_ManuallyRefreshGroups(vrcConstraints);

            AvatarPerformanceStats perfStats = new AvatarPerformanceStats(ValidationEditorHelpers.IsMobilePlatform());
            AvatarPerformance.CalculatePerformanceStats(avatar.Name, avatar.gameObject, perfStats, isMobilePlatform);

            OnGUIPerformanceInfo(avatar, perfStats, AvatarPerformanceCategory.Overall,
                GetAvatarSubSelectAction<VRC_AvatarDescriptor>(avatar), null);
            OnGUIPerformanceInfo(avatar, perfStats, AvatarPerformanceCategory.PolyCount,
                GetAvatarSubSelectAction(avatar, new[] {typeof(MeshRenderer), typeof(SkinnedMeshRenderer)}), null);
            OnGUIPerformanceInfo(avatar, perfStats, AvatarPerformanceCategory.AABB,
                GetAvatarSubSelectAction<VRC_AvatarDescriptor>(avatar), null);

            if (avatar.lipSync == VRC_AvatarDescriptor.LipSyncStyle.VisemeBlendShape &&
                avatar.VisemeSkinnedMesh == null)
                _builder.OnGUIError(avatar, "This avatar uses Visemes but the Face Mesh is not specified.",
                    delegate { Selection.activeObject = avatar.gameObject; }, null);

            VerifyAvatarMipMapStreaming(avatar);
            VerifyMaxTextureSize(avatar);
            // Pre-unity 2021 the 'Kaiser' algorithm would introduce a lot of aliasing - disable prior to that
#if UNITY_2021_1_OR_NEWER
            VerifyTextureMipFiltering(avatar);
#endif

            if (!avatar.TryGetComponent<Animator>(out var anim))
            {
                _builder.OnGUIError(avatar,
                    "This avatar does not contain an Animator, you need to add an Animator component for the avatar to work",
                    delegate { Selection.activeObject = avatar.gameObject; }, null);
                return;
            }
            if (anim == null)
            {
                _builder.OnGUIWarning(avatar,
                    "This avatar does not contain an Animator, and will not animate in VRChat.",
                    delegate { Selection.activeObject = avatar.gameObject; }, null);
            }
            else if (anim.isHuman == false)
            {
                _builder.OnGUIWarning(avatar,
                    "This avatar is not imported as a humanoid rig and will not play VRChat's provided animation set.",
                    delegate { Selection.activeObject = avatar.gameObject; }, null);
            }
            else if (avatar.gameObject.activeInHierarchy == false)
            {
                _builder.OnGUIError(avatar, "Your avatar is disabled in the scene hierarchy!",
                    delegate { Selection.activeObject = avatar.gameObject; }, null);
            }
            else
            {
                TryCheckHumanoidAvatarRootHierarchy(anim, avatar);

                Transform lFoot = anim.GetBoneTransform(HumanBodyBones.LeftFoot);
                Transform rFoot = anim.GetBoneTransform(HumanBodyBones.RightFoot);
                if ((lFoot == null) || (rFoot == null))
                    _builder.OnGUIError(avatar, "Your avatar is humanoid, but its feet aren't specified!",
                        delegate { Selection.activeObject = avatar.gameObject; }, null);
                if (lFoot != null && rFoot != null)
                {
                    Vector3 footPos = lFoot.position - avatar.transform.position;
                    if (footPos.y < 0)
                        _builder.OnGUIWarning(avatar,
                            "Avatar feet are beneath the avatar's origin (the floor). That's probably not what you want.",
                            delegate
                            {
                                List<Object> gos = new List<Object> {rFoot.gameObject, lFoot.gameObject};
                                Selection.objects = gos.ToArray();
                            }, null);
                }

                Transform lShoulder = anim.GetBoneTransform(HumanBodyBones.LeftUpperArm);
                Transform rShoulder = anim.GetBoneTransform(HumanBodyBones.RightUpperArm);
                if (lShoulder == null || rShoulder == null)
                    _builder.OnGUIError(avatar, "Your avatar is humanoid, but its upper arms aren't specified!",
                        delegate { Selection.activeObject = avatar.gameObject; }, null);
                if (lShoulder != null && rShoulder != null)
                {
                    Vector3 shoulderPosition = lShoulder.position - avatar.transform.position;
                    if (shoulderPosition.y < 0.2f)
                        _builder.OnGUIError(avatar, "This avatar is too short. The minimum is 20cm shoulder height.",
                            delegate { Selection.activeObject = avatar.gameObject; }, null);
                    else if (shoulderPosition.y < 1.0f)
                        _builder.OnGUIWarning(avatar, "This avatar is shorter than average.",
                            delegate { Selection.activeObject = avatar.gameObject; }, null);
                    else if (shoulderPosition.y > 5.0f)
                        _builder.OnGUIWarning(avatar, "This avatar is too tall. The maximum is 5m shoulder height.",
                            delegate { Selection.activeObject = avatar.gameObject; }, null);
                    else if (shoulderPosition.y > 2.5f)
                        _builder.OnGUIWarning(avatar, "This avatar is taller than average.",
                            delegate { Selection.activeObject = avatar.gameObject; }, null);
                }

                VRCHeadChop[] customHeadChops = avatar.GetComponentsInChildren<VRCHeadChop>(true);
                if (customHeadChops != null && customHeadChops.Length > 0)
                {
                    if (customHeadChops.Length > VRCHeadChop.MaxComponentCount)
                    {
                        _builder.OnGUIError(avatar, $"Your avatar contains too many VRCHeadChop components. The maximum allowed count is {VRCHeadChop.MaxComponentCount}, but this avatar contains a total of {customHeadChops.Length}. Please remove {customHeadChops.Length - VRCHeadChop.MaxComponentCount} of them.",
                            () =>
                            {
                                using (ListPool.Get(out List<Object> headChopObjects))
                                {
                                    foreach (VRCHeadChop headChop in customHeadChops)
                                    {
                                        headChopObjects.Add(headChop.gameObject);
                                    }

                                    Selection.objects = headChopObjects.ToArray();
                                }
                            }
                        );
                    }
                    else
                    {
                        _builder.OnGUIInformation(avatar, "Your avatar contains one or more VRCHeadChop components. Be sure to read the documentation and make sure you know what you're doing!");
                    }

                    _builder.OnGUILink(avatar, "VRCHeadChop Component", VRCSdkControlPanelHelp.AVATAR_CUSTOM_HEAD_CHOP_URL);
                }

                if (AnalyzeIK(avatar, anim) == false)
                    _builder.OnGUILink(avatar, "See Avatar Rig Requirements for more information.",
                        VRCSdkControlPanelHelp.AVATAR_RIG_REQUIREMENTS_URL);
            }

            ValidateFeatures(avatar, anim, perfStats);

            PipelineManager pm = avatar.GetComponent<PipelineManager>();

            PerformanceRating rating = perfStats.GetPerformanceRatingForCategory(AvatarPerformanceCategory.Overall);
            if (_builder.NoGuiErrors())
            {
                if (!anim.isHuman)
                {
                    if (pm != null) pm.fallbackStatus = PipelineManager.FallbackStatus.InvalidRig;
                    _builder.OnGUIInformation(avatar, "This avatar does not have a humanoid rig, so it can not be used as a custom fallback.");
                }
                else if (rating > PerformanceRating.Good)
                {
                    if (pm != null) pm.fallbackStatus = PipelineManager.FallbackStatus.InvalidPerformance;
                    _builder.OnGUIInformation(avatar, "This avatar does not have an overall rating of Good or better, so it can not be used as a custom fallback. See the link below for details on Avatar Optimization.");
                }
                else
                {
                    if (pm != null) pm.fallbackStatus = PipelineManager.FallbackStatus.Valid;
                    _builder.OnGUIInformation(avatar, "This avatar can be used as a custom fallback. This avatar must be uploaded for every supported platform to be valid for fallback selection.");
                    if (perfStats.animatorCount.HasValue && perfStats.animatorCount.Value > 1)
                        _builder.OnGUIInformation(avatar, "This avatar uses additional animators, they will be disabled when used as a fallback.");
                }

                // additional messages for Poor and Very Poor Avatars
#if UNITY_ANDROID || UNITY_IOS
                if (rating > PerformanceRating.Poor)
                    _builder.OnGUIInformation(avatar, "This avatar will be blocked by default due to performance. Your fallback will be shown instead.");
                else if (rating > PerformanceRating.Medium)
                    _builder.OnGUIInformation(avatar, "Other users may choose to block this avatar due to performance. Your fallback will be shown instead.");
#else
                if (rating > PerformanceRating.Medium)
                    _builder.OnGUIInformation(avatar, "Other users may choose to block this avatar due to performance. Your fallback will be shown instead.");
#endif
            }
            else
            {
                // shouldn't matter because we can't hit upload button
                if (pm != null) pm.fallbackStatus = PipelineManager.FallbackStatus.InvalidPlatform;
            }
            _validationsFoldout ??= _builder.rootVisualElement.Q<StepFoldout>("validations-foldout");
            _validationsFoldout?.SetTitle($"Review Any Alerts ({_builder.GUIAlertCount(avatar)})");
        }

        private void TryCheckHumanoidAvatarRootHierarchy(Animator anim, VRC_AvatarDescriptor avatar)
        {
            // avatarRoot only refreshes when we call anim.Rebind()
            // However, the public facing method also writes defaults.
            // Try to use reflection to call Rebind(false) to avoid writing defaults as we rebind.

            var rebindMethod = anim.GetType().GetMethod("Rebind", BindingFlags.Instance | BindingFlags.NonPublic);
            if (rebindMethod == null)
            {
                Debug.LogError("Failed to locate Rebind method for animator. Humanoid avatar root hierarchy cannot be verified!");
                return;
            }

            try
            {
                rebindMethod.Invoke(anim, new object[] { false });
            }
            catch
            {
                Debug.LogError("Failed to invoke Rebind method for animator. Humanoid avatar root hierarchy cannot be verified!");
                return;
            }

            // avatarRoot is now accurate, check it.
            Transform avatarAnimRoot = anim.avatarRoot;
            if (avatarAnimRoot != null && avatarAnimRoot != avatar.transform && avatarAnimRoot.IsChildOf(avatar.transform))
            {
                _builder.OnGUIError(avatar,
                    "This avatar's armature is not a direct child of its root. Click Auto-Fix to re-parent the armature and its siblings to be direct children of the avatar root.",
                    delegate
                    {
                        Object[] animChildren = new Object[avatarAnimRoot.childCount];
                        for (int i = 0; i < avatarAnimRoot.childCount; i++)
                        {
                            animChildren[i] = avatarAnimRoot.GetChild(i).gameObject;
                        }
                        Selection.objects = animChildren;
                    },
                    delegate
                    {
                        Undo.SetCurrentGroupName("Auto-Fix Animator Root");
                        int undoGroup = Undo.GetCurrentGroup();
                        try
                        {
                            while (avatarAnimRoot.childCount > 0)
                            {
                                Transform child = avatarAnimRoot.GetChild(0);
                                Undo.SetTransformParent(child, avatar.transform, "Auto-Fix Animator Root");
                            }
                        }
                        finally
                        {
                            Undo.CollapseUndoOperations(undoGroup);
                        }
                    });
            }
        }

        private void GenerateDebugHashset(VRCAvatarDescriptor avatar)
        {
            avatar.animationHashSet.Clear();

            foreach (VRCAvatarDescriptor.CustomAnimLayer animLayer in avatar.baseAnimationLayers)
            {
                AnimatorController controller = animLayer.animatorController as AnimatorController;
                if (controller != null)
                {
                    foreach (AnimatorControllerLayer layer in controller.layers)
                    {
                        ProcessStateMachine(layer.stateMachine, "");
                        void ProcessStateMachine(AnimatorStateMachine stateMachine, string prefix)
                        {
                            //Update prefix
                            prefix = prefix + stateMachine.name + ".";

                            //States
                            foreach (var state in stateMachine.states)
                            {
                                VRCAvatarDescriptor.DebugHash hash = new VRCAvatarDescriptor.DebugHash();
                                string fullName = prefix + state.state.name;
                                hash.hash = Animator.StringToHash(fullName);
                                hash.name = fullName.Remove(0, layer.stateMachine.name.Length + 1);
                                avatar.animationHashSet.Add(hash);
                            }

                            //Sub State Machines
                            foreach (var subMachine in stateMachine.stateMachines)
                                ProcessStateMachine(subMachine.stateMachine, prefix);
                        }
                    }
                }
            }
        }

        private void ValidateFeatures(VRC_AvatarDescriptor avatar, Animator anim, AvatarPerformanceStats perfStats)
        {
            //Create avatar debug hashset
            VRCAvatarDescriptor avatarSDK3 = avatar as VRCAvatarDescriptor;
            if (avatarSDK3 != null)
            {
                GenerateDebugHashset(avatarSDK3);
            }

            List<Component> toRemoveSilently = new List<Component>();

            //Validate Playable Layers
            if (avatarSDK3 != null && avatarSDK3.customizeAnimationLayers)
            {
                VRCAvatarDescriptor.CustomAnimLayer gestureLayer = avatarSDK3.baseAnimationLayers[2];
                if (anim != null
                    && anim.isHuman
                    && gestureLayer.animatorController != null
                    && gestureLayer.type == VRCAvatarDescriptor.AnimLayerType.Gesture
                    && !gestureLayer.isDefault)
                {
                    AnimatorController controller = gestureLayer.animatorController as AnimatorController;
                    if (controller != null && controller.layers[0].avatarMask == null)
                        _builder.OnGUIError(avatar, "Gesture Layer needs valid mask on first animator layer",
                            delegate { OpenAnimatorControllerWindow(controller); }, null);
                }
            }

            //Expression menu images
            if (avatarSDK3 != null)
            {
                bool ValidateTexture(Texture2D texture)
                {
                    string path = AssetDatabase.GetAssetPath(texture);
                    TextureImporter importer = AssetImporter.GetAtPath(path) as TextureImporter;
                    if (importer == null)
                        return true;
                    TextureImporterPlatformSettings settings = importer.GetDefaultPlatformTextureSettings();

                    //Max texture size
                    if ((texture.width > MAX_ACTION_TEXTURE_SIZE || texture.height > MAX_ACTION_TEXTURE_SIZE) &&
                        settings.maxTextureSize > MAX_ACTION_TEXTURE_SIZE)
                        return false;

                    //Compression
                    if (settings.textureCompression == TextureImporterCompression.Uncompressed)
                        return false;

                    //Success
                    return true;
                }

                void FixTexture(Texture2D texture)
                {
                    string path = AssetDatabase.GetAssetPath(texture);
                    TextureImporter importer = AssetImporter.GetAtPath(path) as TextureImporter;
                    if (importer == null)
                        return;
                    TextureImporterPlatformSettings settings = importer.GetDefaultPlatformTextureSettings();

                    //Max texture size
                    if (texture.width > MAX_ACTION_TEXTURE_SIZE || texture.height > MAX_ACTION_TEXTURE_SIZE)
                        settings.maxTextureSize = Math.Min(settings.maxTextureSize, MAX_ACTION_TEXTURE_SIZE);

                    //Compression
                    if (settings.textureCompression == TextureImporterCompression.Uncompressed)
                        settings.textureCompression = TextureImporterCompression.Compressed;

                    //Set & Reimport
                    importer.SetPlatformTextureSettings(settings);
                    AssetDatabase.ImportAsset(path);
                }

                //Find all textures
                List<Texture2D> textures = new List<Texture2D>();
                List<VRCExpressionsMenu> menuStack = new List<VRCExpressionsMenu>();
                FindTextures(avatarSDK3.expressionsMenu);

                void FindTextures(VRCExpressionsMenu menu)
                {
                    if (menu == null || menuStack.Contains(menu)) //Prevent recursive menu searching
                        return;
                    menuStack.Add(menu);

                    //Check controls
                    foreach (VRCExpressionsMenu.Control control in menu.controls)
                    {
                        AddTexture(control.icon);
                        if (control.labels != null)
                        {
                            foreach (VRCExpressionsMenu.Control.Label label in control.labels)
                                AddTexture(label.icon);
                        }

                        if (control.subMenu != null)
                            FindTextures(control.subMenu);
                    }

                    void AddTexture(Texture2D texture)
                    {
                        if (texture != null)
                            textures.Add(texture);
                    }
                }

                //Validate
                bool isValid = true;
                foreach (Texture2D texture in textures)
                {
                    if (!ValidateTexture(texture))
                        isValid = false;
                }

                if (!isValid)
                    _builder.OnGUIError(avatar, "Images used for Actions & Moods are too large.",
                        delegate { Selection.activeObject = avatar.gameObject; }, FixTextures);

                //Fix
                void FixTextures()
                {
                    foreach (Texture2D texture in textures)
                        FixTexture(texture);
                }
            }

            //Expression menu parameters
            if (avatarSDK3 != null)
            {
                //Check for expression menu/parameters object
                if (avatarSDK3.expressionsMenu != null || avatarSDK3.expressionParameters != null)
                {
                    //Menu
                    if (avatarSDK3.expressionsMenu == null)
                        _builder.OnGUIError(avatar, "VRCExpressionsMenu object reference is missing.",
                            delegate { Selection.activeObject = avatarSDK3; }, null);

                    //Parameters
                    if (avatarSDK3.expressionParameters == null)
                        _builder.OnGUIError(avatar, "VRCExpressionParameters object reference is missing.",
                            delegate { Selection.activeObject = avatarSDK3; }, null);
                }

                //Check if parameters is valid
                if (avatarSDK3.expressionParameters != null && avatarSDK3.expressionParameters.CalcTotalCost() > VRCExpressionParameters.MAX_PARAMETER_COST)
                {
                    _builder.OnGUIError(avatar, "VRCExpressionParameters has too many parameters defined.",
                        delegate { Selection.activeObject = avatarSDK3.expressionParameters; }, null);
                }

                //Find all existing parameters
                if (avatarSDK3.expressionsMenu != null && avatarSDK3.expressionParameters != null)
                {
                    List<VRCExpressionsMenu> menuStack = new List<VRCExpressionsMenu>();
                    List<string> parameters = new List<string>();
                    List<VRCExpressionsMenu> selects = new List<VRCExpressionsMenu>();
                    FindParameters(avatarSDK3.expressionsMenu);

                    void FindParameters(VRCExpressionsMenu menu)
                    {
                        if (menu == null || menuStack.Contains(menu)) //Prevent recursive menu searching
                            return;
                        menuStack.Add(menu);

                        //Check controls
                        foreach (VRCExpressionsMenu.Control control in menu.controls)
                        {
                            AddParameter(control.parameter);
                            if (control.subParameters != null)
                            {
                                foreach (VRCExpressionsMenu.Control.Parameter subParameter in control.subParameters)
                                {
                                    AddParameter(subParameter);
                                }
                            }

                            if (control.subMenu != null)
                                FindParameters(control.subMenu);
                        }

                        void AddParameter(VRCExpressionsMenu.Control.Parameter parameter)
                        {
                            if (parameter != null)
                            {
                                parameters.Add(parameter.name);
                                selects.Add(menu);
                            }
                        }
                    }

                    //Validate parameters
                    for (int i = 0; i < parameters.Count; i++)
                    {
                        string parameter = parameters[i];
                        VRCExpressionsMenu select = selects[i];

                        //Find
                        bool exists = string.IsNullOrEmpty(parameter) || avatarSDK3.expressionParameters.FindParameter(parameter) != null;
                        if (!exists)
                        {
                            _builder.OnGUIError(avatar,
                                "VRCExpressionsMenu uses a parameter that is not defined.\nParameter: " + parameter,
                                delegate { Selection.activeObject = select; }, null);
                        }
                    }

                    //Validate param choices
                    foreach (var menu in menuStack)
                    {
                        foreach (var control in menu.controls)
                        {
                            bool isValid = true;
                            if (control.type == VRCExpressionsMenu.Control.ControlType.FourAxisPuppet)
                            {
                                isValid &= ValidateNonBoolParam(control.subParameters[0].name);
                                isValid &= ValidateNonBoolParam(control.subParameters[1].name);
                                isValid &= ValidateNonBoolParam(control.subParameters[2].name);
                                isValid &= ValidateNonBoolParam(control.subParameters[3].name);
                            }
                            else if (control.type == VRCExpressionsMenu.Control.ControlType.RadialPuppet)
                            {
                                isValid &= ValidateNonBoolParam(control.subParameters[0].name);
                            }
                            else if (control.type == VRCExpressionsMenu.Control.ControlType.TwoAxisPuppet)
                            {
                                isValid &= ValidateNonBoolParam(control.subParameters[0].name);
                                isValid &= ValidateNonBoolParam(control.subParameters[1].name);
                            }
                            if (!isValid)
                            {
                                _builder.OnGUIError(avatar,
                                "VRCExpressionsMenu uses an invalid parameter for a control.\nControl: " + control.name,
                                delegate { Selection.activeObject = menu; }, null);
                            }
                        }

                        bool ValidateNonBoolParam(string name)
                        {
                            VRCExpressionParameters.Parameter param = string.IsNullOrEmpty(name) ? null : avatarSDK3.expressionParameters.FindParameter(name);
                            if (param != null && param.valueType == VRCExpressionParameters.ValueType.Bool)
                                return false;
                            return true;
                        }
                    }
                }

                //Dynamic Bones
                //Get types (null if DynamicBone is not installed/owned)
                var typeDynamicBone = TypeUtils.GetTypeFromName("DynamicBone");
                var typeDynamicBoneCollider = TypeUtils.GetTypeFromName("DynamicBoneCollider");

                GameObject avatarObj = avatarSDK3.gameObject;

                var dbList = typeDynamicBone != null ? avatarObj.GetComponentsInChildren(typeDynamicBone, true) : null;
                var dbcList = typeDynamicBoneCollider != null ? avatarObj.GetComponentsInChildren(typeDynamicBoneCollider, true) : null;

                int dbCount = dbList?.Length ?? 0;
                int dbcCount = dbcList?.Length ?? 0;

                if (dbCount > 0 || dbcCount > 0)
                {
                    _builder.OnGUIError(avatar, "This avatar uses depreciated DynamicBone components. Please use PhysBones instead. Click Auto Fix to automatically convert DynamicBones to PhysBones.",
                        () =>
                        {
                            Object[] unifiedArray = new Object[dbCount + dbcCount];

                            if (dbList != null)
                            {
                                for (int i = 0; i < dbCount; i++)
                                {
                                    unifiedArray[i] = dbList[i].gameObject;
                                }
                            }

                            if (dbcList != null)
                            {
                                for (int j = 0; j < dbcCount; j++)
                                {
                                    unifiedArray[dbCount + j] = dbcList[j].gameObject;
                                }
                            }

                            Selection.objects = unifiedArray;
                        },
                        () => { AvatarDynamicsSetup.ConvertDynamicBonesToPhysBones( new GameObject[]{ avatarSDK3.gameObject } ); }
                    );

                    // handling these components directly so do not include in the generic illegal components validation which will just delete them
                    if (dbList != null)
                    {
                        toRemoveSilently.AddRange(dbList);
                    }
                    if (dbcList != null)
                    {
                        toRemoveSilently.AddRange(dbcList);
                    }
                }

                //Unity constraints upgrade
                List<IConstraint> unityConstraints = new List<IConstraint>(avatar.gameObject.GetComponentsInChildren<IConstraint>(true));

                // Ignore constraints that user tooling claims to be handling at build time.
                AvatarDynamicsSetup.CheckUserToolingHandledUnityConstraints(unityConstraints);

                if (unityConstraints.Count > 0)
                {
#if UNITY_STANDALONE
                    _builder.OnGUIWarning(avatar, "This avatar uses Unity constraints. Consider using VRChat constraints instead. " +
                                                  "Click Auto Fix to attempt to replace all constraints and rebind avatar animations automatically.",
#else
                    _builder.OnGUIError(avatar, "Unity constraints are not allowed on this platform. Consider using VRChat constraints instead. " +
                                                "Click Auto Fix to attempt to replace all constraints and rebind avatar animations automatically.",
#endif
                        () =>
                        {
                            Object[] unityConstraintObjects = new Object[unityConstraints.Count];
                            for (int i = 0; i < unityConstraints.Count; i++)
                            {
                                unityConstraintObjects[i] = ((Component)unityConstraints[i]).gameObject;
                            }
                            Selection.objects = unityConstraintObjects;
                        },
                        () =>
                        {
                            AvatarDynamicsSetup.ConvertUnityConstraintsAcrossGameObjects(new List<GameObject>() { avatarSDK3.gameObject }, true );
                        }
                    );
                }
            }

            List<Component> componentsToRemove = SDK3.Validation.AvatarValidation.FindIllegalComponents(avatar.gameObject).ToList();

            foreach (Component c in componentsToRemove)
            {
                // silently remove specific components
                string typeName = c.GetType().Name;
                if (typeName == "PipelineSaver" || typeName == "ParentChangeDetector")
                {
                    toRemoveSilently.Add(c);
                }
            }

            foreach (Component c in toRemoveSilently)
            {
                componentsToRemove.Remove(c);
            }

            HashSet<string> componentsToRemoveNames = new HashSet<string>();
            List<Component> toRemove = componentsToRemove ?? componentsToRemove;
            foreach (Component c in toRemove)
            {
                if (componentsToRemoveNames.Contains(c.GetType().Name) == false)
                    componentsToRemoveNames.Add(c.GetType().Name);
            }

            if (componentsToRemoveNames.Count > 0)
                _builder.OnGUIError(avatar,
                    "The following component types are found on the Avatar and will be removed by the client: " +
                    string.Join(", ", componentsToRemoveNames.ToArray()),
                    delegate { ShowRestrictedComponents(toRemove); },
                    delegate { FixRestrictedComponents(toRemove); });

            List<AudioSource> audioSources =
                avatar.gameObject.GetComponentsInChildrenExcludingEditorOnly<AudioSource>(true).ToList();
            if (audioSources.Count > 0)
                _builder.OnGUIWarning(avatar,
                    "Audio sources found on Avatar, they will be adjusted to safe limits, if necessary.",
                    GetAvatarSubSelectAction<AudioSource>(avatar), null);

            List<AudioClip> audioClipsWithoutLoadInBackground = new List<AudioClip>();
            foreach (var audioSource in audioSources)
            {
                if (audioSource.clip && audioSource.clip.loadType == AudioClipLoadType.DecompressOnLoad &&
                    !audioSource.clip.loadInBackground && !audioClipsWithoutLoadInBackground.Contains(audioSource.clip))
                {
                    audioClipsWithoutLoadInBackground.Add(audioSource.clip);
                }
            }
            if (audioClipsWithoutLoadInBackground.Count > 0)
            {
                _builder.OnGUIError(avatar,
                    "Found an audio clip with load type `Decompress On Load` which doesn't have `Load In Background` enabled.\nPlease enable `Load In Background` on the audio clip.", 
                    GetAvatarAudioSourcesWithDecompressOnLoadWithoutBackgroundLoad(avatar), () => FixAudioClipLoadInBackground(audioClipsWithoutLoadInBackground));
            }

            List<AudioClip> animatorPlayAudioClipsWithoutLoadInBackground = ScanAvatarForAnimatorPlayAudio(avatarSDK3);
            if (animatorPlayAudioClipsWithoutLoadInBackground.Count > 0)
            {
                _builder.OnGUIError(avatar,
                    "Found one or several audio clips used in state behaviours with load type `Decompress On Load` which doesn't have `Load In Background` enabled. Please enable `Load In Background` on these audio clips.",
                    null, () => FixAudioClipLoadInBackground(animatorPlayAudioClipsWithoutLoadInBackground));
            }
            
            List<VRCStation> stations =
                avatar.gameObject.GetComponentsInChildrenExcludingEditorOnly<VRCStation>(true).ToList();
            if (stations.Count > 0)
                _builder.OnGUIWarning(avatar, "Stations found on Avatar, they will be adjusted to safe limits, if necessary.",
                    GetAvatarSubSelectAction<VRCStation>(avatar), null);

            if (VRCSdkControlPanel.HasSubstances(avatar.gameObject))
            {
                _builder.OnGUIWarning(avatar,
                    "This avatar has one or more Substance materials, which is not supported and may break in-game. Please bake your Substances to regular materials.",
                    () => { Selection.objects = VRCSdkControlPanel.GetSubstanceObjects(avatar.gameObject); },
                    null);
            }

            ScanAvatarForAutoDestructComponents(avatar, out List<ParticleSystem> autoDestructSystems, out List<ParticleSystem> autoDisableRootSystems, out List<TrailRenderer> autoDestructTrails);
            if (autoDestructSystems.Count > 0)
            {
                _builder.OnGUIError(avatar,
                    "This avatar contains one or more particle systems configured to destroy themselves when they stop. This is not allowed. Please use a different stop action.",
                    () => Selection.objects = CreateObjectArray(autoDestructSystems),
                    () =>
                    {
                        foreach (ParticleSystem system in autoDestructSystems)
                        {
                            ParticleSystem.MainModule mainModule = system.main;
                            // Disable is the closest available alternative, unless on the root where disabling isn't allowed.
                            mainModule.stopAction = system.gameObject != avatar.gameObject ? ParticleSystemStopAction.Disable : ParticleSystemStopAction.None;
                        }
                    });
            }
            if (autoDisableRootSystems.Count > 0)
            {
                // Message is phrased in the singular because particle systems disallow multiples, but applying to multiples internally anyway to be safe.
                _builder.OnGUIError(avatar,
                    "This avatar contains a particle system on the avatar root configured to disable itself when it stops. This is not allowed. Please use a different stop action.",
                    () => Selection.objects = CreateObjectArray(autoDisableRootSystems),
                    () =>
                    {
                        foreach (ParticleSystem system in autoDisableRootSystems)
                        {
                            ParticleSystem.MainModule mainModule = system.main;
                            mainModule.stopAction = ParticleSystemStopAction.None;
                        }
                    });
            }
            if (autoDestructTrails.Count > 0)
            {
                _builder.OnGUIError(avatar,
                    "This avatar contains one or more trail renderers configured to auto-destruct when the trail ends. This is not allowed. Please disable auto-destruction.",
                    () => Selection.objects = CreateObjectArray(autoDestructTrails),
                    () =>
                    {
                        foreach (TrailRenderer trail in autoDestructTrails)
                        {
                            trail.autodestruct = false;
                        }
                    });
            }

            CheckAvatarMeshesForLegacyBlendShapesSetting(avatar);
            CheckAvatarMeshesForMeshReadWriteSetting(avatar);

#if UNITY_ANDROID || UNITY_IOS
            IEnumerable<Shader> illegalShaders = VRC.SDK3.Validation.AvatarValidation.FindIllegalShaders(avatar.gameObject);
            foreach (Shader s in illegalShaders)
            {
                _builder.OnGUIError(avatar, "Avatar uses unsupported shader '" + s.name + "'. You can only use the shaders provided in 'VRChat/Mobile' for Quest avatars.", delegate () { Selection.activeObject
     = avatar.gameObject; }, null);
            }
#endif

            if (ScanAvatarForWriteDefaultsMixture(avatarSDK3))
            {
                _builder.OnGUIWarning(avatar,
                    "This avatar uses a mixture of Write Defaults in its animator states. To avoid animation issues, VRChat recommends using the same Write Defaults setting across all animator states.",
                    null,
                    null
                );
                _builder.OnGUILink(null, "Write Defaults Guidelines", VRCSdkControlPanelHelp.AVATAR_WRITE_DEFAULTS_ON_STATES_URL);
            }

            if (ScanAvatarForWriteDefaultsOffEmptyClips(avatarSDK3))
            {
                _builder.OnGUIWarning(avatar,
                    "This avatar contains one or more animator states with Write Defaults disabled where the animation clip is either missing or empty. To avoid animation issues, assign animation clips containing at least one property.",
                    null,
                    null
                );
            }

            // Searching from the given transform rather than from its parent here in the SDK. The parent may contain
            // other avatars as children, which we don't want to scan here for performance.
            PhysBoneManager.UpdateExecutionGroupsForRoot(avatar.transform, fromTransformRoot: false, out bool hasUnassignedGroups, out bool hasCyclicDependencies);
            if(hasUnassignedGroups)
            {
                _builder.OnGUIError(avatar,
                    $"This avatar contains VRCPhysBone or VRCPhysBoneCollider components which exceed the maximum dependency depth of {PhysBoneManager.MAX_EXECUTION_GROUPS}.  Remove or move these components to change their dependencies.  See console for more information.",
                    null,
                    null
                );
            }
            if(hasCyclicDependencies)
            {
                _builder.OnGUIWarning(avatar,
                    $"This avatar contains VRCPhysBone or VRCPhysBoneCollider components which have cyclic dependencies.  As a result some components will run out of order.  Remove or move these components to change their dependencies.  See console for more information.",
                    null,
                    null
                );
            }

            foreach (AvatarPerformanceCategory perfCategory in Enum.GetValues(typeof(AvatarPerformanceCategory)))
            {
                if (perfCategory == AvatarPerformanceCategory.Overall ||
                    perfCategory == AvatarPerformanceCategory.PolyCount ||
                    perfCategory == AvatarPerformanceCategory.AABB ||
                    perfCategory == AvatarPerformanceCategory.AvatarPerformanceCategoryCount)
                {
                    continue;
                }

                Action show = null;

                switch (perfCategory)
                {
                    case AvatarPerformanceCategory.AnimatorCount:
                        show = GetAvatarSubSelectAction<Animator>(avatar);
                        break;
                    case AvatarPerformanceCategory.AudioSourceCount:
                        show = GetAvatarSubSelectAction<AudioSource>(avatar);
                        break;
                    case AvatarPerformanceCategory.BoneCount:
                        show = GetAvatarSubSelectAction<SkinnedMeshRenderer>(avatar);
                        break;
                    case AvatarPerformanceCategory.ClothCount:
                        show = GetAvatarSubSelectAction<Cloth>(avatar);
                        break;
                    case AvatarPerformanceCategory.ClothMaxVertices:
                        show = GetAvatarSubSelectAction<Cloth>(avatar);
                        break;
                    case AvatarPerformanceCategory.LightCount:
                        show = GetAvatarSubSelectAction<Light>(avatar);
                        break;
                    case AvatarPerformanceCategory.LineRendererCount:
                        show = GetAvatarSubSelectAction<LineRenderer>(avatar);
                        break;
                    case AvatarPerformanceCategory.MaterialCount:
                        show = GetAvatarSubSelectAction(avatar,
                            new[] {typeof(MeshRenderer), typeof(SkinnedMeshRenderer)});
                        break;
                    case AvatarPerformanceCategory.MeshCount:
                        show = GetAvatarSubSelectAction(avatar,
                            new[] {typeof(MeshRenderer), typeof(SkinnedMeshRenderer)});
                        break;
                    case AvatarPerformanceCategory.ParticleCollisionEnabled:
                        show = GetAvatarSubSelectAction<ParticleSystem>(avatar);
                        break;
                    case AvatarPerformanceCategory.ParticleMaxMeshPolyCount:
                        show = GetAvatarSubSelectAction<ParticleSystem>(avatar);
                        break;
                    case AvatarPerformanceCategory.ParticleSystemCount:
                        show = GetAvatarSubSelectAction<ParticleSystem>(avatar);
                        break;
                    case AvatarPerformanceCategory.ParticleTotalCount:
                        show = GetAvatarSubSelectAction<ParticleSystem>(avatar);
                        break;
                    case AvatarPerformanceCategory.ParticleTrailsEnabled:
                        show = GetAvatarSubSelectAction<ParticleSystem>(avatar);
                        break;
                    case AvatarPerformanceCategory.PhysicsColliderCount:
                        show = GetAvatarSubSelectAction<Collider>(avatar);
                        break;
                    case AvatarPerformanceCategory.PhysicsRigidbodyCount:
                        show = GetAvatarSubSelectAction<Rigidbody>(avatar);
                        break;
                    case AvatarPerformanceCategory.PolyCount:
                        show = GetAvatarSubSelectAction(avatar,
                            new[] {typeof(MeshRenderer), typeof(SkinnedMeshRenderer)});
                        break;
                    case AvatarPerformanceCategory.SkinnedMeshCount:
                        show = GetAvatarSubSelectAction<SkinnedMeshRenderer>(avatar);
                        break;
                    case AvatarPerformanceCategory.TrailRendererCount:
                        show = GetAvatarSubSelectAction<TrailRenderer>(avatar);
                        break;
                    case AvatarPerformanceCategory.PhysBoneComponentCount:
                    case AvatarPerformanceCategory.PhysBoneTransformCount:
                        show = GetAvatarSubSelectAction<VRC.SDK3.Dynamics.PhysBone.Components.VRCPhysBone>(avatar);
                        break;
                    case AvatarPerformanceCategory.PhysBoneColliderCount:
                    case AvatarPerformanceCategory.PhysBoneCollisionCheckCount:
                        show = GetAvatarSubSelectAction<VRC.SDK3.Dynamics.PhysBone.Components.VRCPhysBoneCollider>(avatar);
                        break;
                    case AvatarPerformanceCategory.ContactCount:
                        // Show non-local contacts only.
                        show = GetAvatarSubSelectAction<VRC.Dynamics.ContactBase>(avatar, contactBase => !contactBase.IsLocalOnly);
                        break;
                    case AvatarPerformanceCategory.ConstraintsCount:
                        show = GetAvatarSubSelectAction(avatar, new Type[] { typeof(VRC.Dynamics.VRCConstraintBase), typeof(IConstraint) });
                        break;
                    case AvatarPerformanceCategory.ConstraintDepth:
                        // Behaves slightly differently from constraint count, we want to select the VRChat constraints at the end of the deepest chain(s) instead.
                        show = AvatarDynamicsSetup.GetDeepestConstraintSubSelection(avatar);
                        break;
                }

                OnGUIPerformanceInfo(avatar, perfStats, perfCategory, show, null);
            }

            _builder.OnGUILink(avatar, "Avatar Optimization Tips", VRCSdkControlPanelHelp.AVATAR_OPTIMIZATION_TIPS_URL);
        }

        private void OnGUIPerformanceInfo(VRC_AvatarDescriptor avatar, AvatarPerformanceStats perfStats,
            AvatarPerformanceCategory perfCategory, Action show, Action fix)
        {
            PerformanceRating rating = perfStats.GetPerformanceRatingForCategory(perfCategory);
            SDKPerformanceDisplay.GetSDKPerformanceInfoText(perfStats, perfCategory, out string statText, out string errorText,
                out PerformanceInfoDisplayLevel displayLevel);

            switch (displayLevel)
            {
                case PerformanceInfoDisplayLevel.None:
                {
                    break;
                }
                case PerformanceInfoDisplayLevel.Verbose:
                {
                    if (ShowAvatarPerformanceDetails)
                    {
                        _builder.OnGUIStat(avatar, statText, rating, show, fix);
                    }

                    break;
                }
                case PerformanceInfoDisplayLevel.Info:
                case PerformanceInfoDisplayLevel.Warning:
                case PerformanceInfoDisplayLevel.Error:
                {
                    _builder.OnGUIStat(avatar, statText, rating, show, fix);
                    break;
                }
                default:
                {
                    _builder.OnGUIError(avatar, "Unknown performance display level.",
                        delegate { Selection.activeObject = avatar.gameObject; }, null);
                    break;
                }
            }

            if (!string.IsNullOrEmpty(errorText))
            {
                _builder.OnGUIError(avatar, errorText, delegate { Selection.activeObject = avatar.gameObject; }, null);
            }
        }
        
        #endregion

        #region Avatar Builder UI (UIToolkit)

        private const string ACCEPT_TERMS_BLOCK_TEXT = "You must accept the terms below to upload content to VRChat";
        private int _progressId;
        
        public void CreateBuilderErrorGUI(VisualElement root)
        {
            var errorContainer = new VisualElement();
            errorContainer.AddToClassList("builder-error-container");
            root.Add(errorContainer);
            var errorLabel = new Label("A VRCAvatarDescriptor is required to build a VRChat Avatar");
            errorLabel.AddToClassList("mb-2");
            errorLabel.AddToClassList("text-center");
            errorLabel.AddToClassList("white-space-normal");
            errorLabel.style.maxWidth = 450;
            errorContainer.Add(errorLabel);
            var addButton = new Button
            {
                text = "Add a VRCAvatarDescriptor",
                tooltip = "Adds a VRCAvatarDescriptor to the selected GameObject"
            };
            addButton.clickable.clicked += () =>
            {
                Undo.AddComponent<VRCAvatarDescriptor>(Selection.activeGameObject);
                _builder.ResetIssues();
            };
            errorContainer.Add(addButton);
            
            if (Selection.activeGameObject == null)
            {
                addButton.SetEnabled(false);
            }

            errorContainer.schedule.Execute(() =>
            {
                var hasSelection = Selection.activeGameObject != null;
                addButton.SetEnabled(hasSelection);
                errorLabel.text = "A VRCAvatarDescriptor is required to build a VRChat Avatar" + (hasSelection ? "" : ".\nSelect a GameObject to add a VRCAvatarDescriptor to it.");
            }).Every(500);
        }
        
        private VRCAvatar _avatarData;
        private VRCAvatar _originalAvatarData;
        
        private VisualElement _visualRoot;
        private VisualElement _buildVisualRoot;

        private VisualElement _saveChangesBlock;
        private Button _saveChangesButton;
        private Button _discardChangesButton;
        
        private Foldout _infoFoldout;
        
        private AvatarSelector _avatarSelector;
        private VRCTextField _nameField;

        private StyleField _primaryStyleField;
        private StyleField _secondaryStyleField;
        
        private ContentWarningsField _contentWarningsField;
        private TagsField _tagsField;
        
        private VRCTextField _descriptionField;
        
        private Label _lastUpdatedLabel;
        private Label _versionLabel;
        
        private PopupField<string> _visibilityPopup;
        private Thumbnail _thumbnail;
        private ThumbnailBlock _thumbnailBlock;
        private string _newThumbnailImagePath;
        
        private VisualElement _buildButtonsBlock;
        private BuilderProgress _builderProgress;
        private Button _buildAndTestButton;
        private Button _buildAndUploadButton;
        private VisualElement _uploadDisabledBlock;
        private Label _uploadDisabledText;
        private VisualElement _localTestDisabledBlock;
        private Label _localTestDisabledText;
        private VisualElement _fallbackInfo;
        private VisualElement _visibilityPopupBlock;
        private StepFoldout _validationsFoldout;
        private VisualElement _mainBuildActionDisabledBlock;
        private Label _mainBuildActionDisabledText;
        
        protected VisualElement _v3Block;
        
        // AVM
        private Modal _avmNotesModal;
        private TextField _avmNotesTextField;
        private Button _avmNotesSendButton;

        private string _lastBlueprintId;

        private bool _isContentInfoDirty;
        private bool IsContentInfoDirty
        {
            get => _isContentInfoDirty;
            set
            {
                _isContentInfoDirty = value;
                var isDirty = CheckDirty();
                var alreadyDirty = !_saveChangesBlock.ClassListContains("d-none");
                _saveChangesBlock.EnableInClassList("d-none", !isDirty);
                if (isDirty && !alreadyDirty)
                {
                    _saveChangesBlock.experimental.animation.Start(new Vector2(_visualRoot.layout.width, 0), new Vector2(_visualRoot.layout.width, 50), 250, (element, vector2) =>
                    {
                        element.style.height = vector2.y;
                    });
                }
            }
        }

        private static CancellationTokenSource _avatarSwitchCancellationToken = new CancellationTokenSource();

        private bool _uiEnabled;
        private bool UiEnabled
        {
            get => _uiEnabled;
            set
            {
                _uiEnabled = value;
                _infoFoldout.SetEnabled(value);
                _saveChangesButton.SetEnabled(value);
                _discardChangesButton.SetEnabled(value);
                _buildAndTestButton?.SetEnabled(value);
                _buildAndUploadButton?.SetEnabled(value);
                _thumbnail.SetEnabled(value);
                _avatarSelector.PopupEnabled = value;
                _primaryStyleField?.SetEnabled(value);
                _secondaryStyleField?.SetEnabled(value);
            }
        }

        private bool IsNewAvatar { get; set; }

        private bool IsAvatarAVM => _avatarData.Lock;

        private enum FallbackStatus
        {
            Incompatible,
            Compatible,
            Selectable,
            Selected
        }

        private FallbackStatus _currentFallbackStatus;

        private FallbackStatus CurrentFallbackStatus
        {
            get => _currentFallbackStatus;
            set
            {
                _currentFallbackStatus = value;
                switch (_currentFallbackStatus)
                {
                    case FallbackStatus.Incompatible:
                        _fallbackInfo.Clear();
                        var label = new Label(
                            "This avatar cannot be used as a fallback. Check Validations below for more info");
                        label.AddToClassList("white-space-normal");
                        _fallbackInfo.Add(label);
                        break;
                    case FallbackStatus.Compatible:
                        _fallbackInfo.Clear();
                        label = new Label();
                        if (Tools.Platform == "android")
                        {
                            label.text = "This avatar can be used as a fallback. Check Validations below for more info.";
                        }
                        else
                        {
                            label.text =
                                "This avatar can be used as a fallback. Switch to the Android platform to select it.";
                        }
                        label.AddToClassList("white-space-normal");
                        _fallbackInfo.Add(label);
                        break;
                    case FallbackStatus.Selectable:
                    {
                        async void SetAvatarFallback()
                        {
                            try
                            {
                                _avatarData = await VRCApi.SetAvatarAsFallback(_avatarData.ID, _avatarData);
                                CurrentFallbackStatus = FallbackStatus.Selected;
                            }
                            catch (ApiErrorException apiError)
                            {
                                await _builder.ShowBuilderNotification("Failed to set fallback",
                                    new AvatarFallbackSelectionErrorNotification(apiError.ErrorMessage),
                                    "red");
                            }
                            catch (RequestFailedException requestError)
                            {
                                await _builder.ShowBuilderNotification("Failed to set fallback",
                                    new AvatarFallbackSelectionErrorNotification(requestError.Message),
                                    "red");
                            }
                        }
                        _fallbackInfo.Clear();
                        var button = new Button(SetAvatarFallback)
                        {
                            text = "Set this avatar as fallback"
                        };
                        button.AddToClassList("flex-grow-1");
                        _fallbackInfo.Add(button);
                        break;
                    }
                    case FallbackStatus.Selected:
                        _fallbackInfo.Clear();
                        label = new Label(
                            "This avatar is currently set as your fallback");
                        label.AddToClassList("white-space-normal");
                        _fallbackInfo.Add(label);
                        break;
                }
            }
        }

        public void CreateContentInfoGUI(VisualElement root)
        {
            root.Clear();
            root.UnregisterCallback<DetachFromPanelEvent>(HandlePanelDetach);
            EditorSceneManager.sceneClosed -= HandleSceneClosed;
            VRCSdkControlPanel.OnSdkPanelDisable -= HandleSdkPanelDisable;
            
            var tree = Resources.Load<VisualTreeAsset>("VRCSdkAvatarBuilderContentInfo");
            tree.CloneTree(root);
            var styles = Resources.Load<StyleSheet>("VRCSdkAvatarBuilderContentInfoStyles");
            if (!root.styleSheets.Contains(styles))
            {
                root.styleSheets.Add(styles);
            }

            root.RegisterCallback<DetachFromPanelEvent>(HandlePanelDetach);
            EditorSceneManager.sceneClosed += HandleSceneClosed;
            VRCSdkControlPanel.OnSdkPanelDisable += HandleSdkPanelDisable;
            
            _avatarSelector = root.Q<AvatarSelector>("avatar-selector");
            _nameField = root.Q<VRCTextField>("content-name");
            _primaryStyleField = root.Q<StyleField>("avatar-primary-style");
            _secondaryStyleField = root.Q<StyleField>("avatar-secondary-style");
            _descriptionField = root.Q<VRCTextField>("content-description");
            _lastUpdatedLabel = root.Q<Label>("last-updated-label");
            _versionLabel = root.Q<Label>("version-label");
            _infoFoldout = _builder.rootVisualElement.Q<Foldout>("info-foldout");
            _thumbnailBlock = root.Q<ThumbnailBlock>();
            _thumbnail = _thumbnailBlock.Thumbnail;
            _saveChangesBlock = root.panel.visualTree.Q("save-changes-block");
            _saveChangesButton = _saveChangesBlock.Q<Button>("save-changes-button");
            _discardChangesButton = _saveChangesBlock.Q<Button>("discard-changes-button");
            _fallbackInfo = root.Q<VisualElement>("fallback-avatar-info");
            _contentWarningsField = root.Q<ContentWarningsField>("content-warnings");
            _tagsField = root.Q<TagsField>("content-tags");
            _validationsFoldout = _builder.rootVisualElement.Q<StepFoldout>("validations-foldout");
            
            _visibilityPopupBlock = root.Q("visibility-block");
            _visibilityPopup = new PopupField<string>(
                "Visibility", 
                new List<string> {"private", "public"},
                "private",
                selected => selected.Substring(0,1).ToUpper() + selected.Substring(1), 
                item => item.Substring(0,1).ToUpper() + item.Substring(1)
            );
            _visibilityPopupBlock.Add(_visibilityPopup);

            var currentAvatars = _avatars.ToList();
            
            {
                _avatarSelector.RegisterValueChangedCallback(evt =>
                {
                    _selectedAvatar = evt.newValue;
                    HandleAvatarSwitch(root);
                });

                var selectedIndex = currentAvatars.IndexOf(_selectedAvatar);
                if (selectedIndex < 0) selectedIndex = currentAvatars.Count - 1;
                _avatarSelector.SetAvatars(currentAvatars, selectedIndex);
            }
            
            // avatars can be added or removed at any time, so we need to check for changes periodically
            root.schedule.Execute(() =>
            {
                // this handles a case where the avatars didn't exist when the builder was opened
                if (_selectedAvatar == null && _avatars.Length > 0)
                {
                    // special case when the avatar gets removed during upload
                    if (_uploadState == SdkUploadState.Uploading) return;
                    
                    _selectedAvatar = _avatars[_avatars.Length - 1];
                    HandleAvatarSwitch(root);
                }
                
                // ignore any changes while the UI is disabled
                if (!UiEnabled) return;

                // this handles addition and removal of new avatars
                if (_avatars.SequenceEqual(currentAvatars)) return;
                
                currentAvatars = _avatars.ToList();
                if (currentAvatars.Count == 0) return;
                var selectedIndex = currentAvatars.IndexOf(_selectedAvatar);
                // if the selected avatar was removed - redraw the whole panel with new data
                if (selectedIndex == -1)
                {
                    selectedIndex = currentAvatars.Count - 1;
                    _selectedAvatar = _avatars[selectedIndex];
                    HandleAvatarSwitch(root);
                }
                // update the popup with the new list on any sequence change
                _avatarSelector.SetAvatars(currentAvatars, selectedIndex);
            }).Every(1000);

            if (_selectedAvatar != null)
            {
                HandleAvatarSwitch(root);
            }
        }

        private async void HandleAvatarSwitch(VisualElement root)
        {
            // We want to avoid any background operations while building
            if (VRCMultiPlatformBuild.MPBState == VRCMultiPlatformBuild.MultiPlatformBuildState.Building) return;
            
            _visualRoot = root;
            // Cancel all ongoing ops
            _avatarSwitchCancellationToken.Cancel();
            _avatarSwitchCancellationToken = new CancellationTokenSource();
            
            var platformsBlock = root.Q<Label>("content-platform-info");
            
            // Unregister all the callbacks to avoid multiple calls
            _nameField.UnregisterCallback<ChangeEvent<string>>(HandleNameChange);
            _descriptionField.UnregisterCallback<ChangeEvent<string>>(HandleDescriptionChange);
            _visibilityPopup.UnregisterCallback<ChangeEvent<string>>(HandleVisibilityChange);
            _thumbnailBlock.OnNewThumbnailSelected -= HandleThumbnailChanged;
            _discardChangesButton.clicked -= HandleDiscardChangesClick;
            _saveChangesButton.clicked -= HandleSaveChangesClick;
            _contentWarningsField.OnToggleOption -= HandleToggleTag;
            root.schedule.Execute(CheckBlueprintChanges).Pause();

            // Load the avatar data
            _nameField.Loading = true;
            _descriptionField.Loading = true;
            _thumbnail.Loading = true;
            _contentWarningsField.Loading = true;
            _nameField.Reset();
            _descriptionField.Reset();
            _thumbnail.ClearImage();
            IsNewAvatar = false;
            _fallbackInfo.Clear();
            _fallbackInfo.Add(new Label("Loading..."));
            UiEnabled = false;
            IsContentInfoDirty = false;

            // we're in the middle of scene changes, so we exit early
            if (_selectedAvatar == null) return;
            
            OnContentChanged?.Invoke(this, EventArgs.Empty);
            
            // Ensure we re-check for issues
            _builder.CheckedForIssues = false;
            
            var hasPm = _selectedAvatar.TryGetComponent<PipelineManager>(out var pm);
            if (!hasPm)
            {
                Debug.LogWarning("No PipelineManager found on the avatar, make sure you added an Avatar Descriptor");
                return;
            }
            

            var avatarId = pm.blueprintId;
            _lastBlueprintId = avatarId;
            _avatarData = new VRCAvatar();
            bool hasRemoteAvatarRecord;
            if (string.IsNullOrWhiteSpace(avatarId))
            {
                IsNewAvatar = true;
                hasRemoteAvatarRecord = false;
            }
            else
            {
                try
                {
                    _avatarData = await VRCApi.GetAvatar(avatarId, true, cancellationToken: _avatarSwitchCancellationToken.Token);
                    if (APIUser.CurrentUser != null && _avatarData.AuthorId != APIUser.CurrentUser?.id)
                    {
                        ClearAvatarData(pm);
                    }
                }
                catch (TaskCanceledException)
                {
                    // avatar selection changed
                    return;
                }
                catch (ApiErrorException ex)
                {
                    // 404 here with a defined blueprint usually means we do not own the content
                    // so we clear the blueprint ID and treat it as a new avatar
                    if (ex.StatusCode == HttpStatusCode.NotFound)
                    {
                        ClearAvatarData(pm);
                    }
                    else
                    {
                        Debug.LogError(ex.ErrorMessage);
                    }
                }
                catch (Exception ex)
                {
                    Debug.LogException(ex);
                }

                hasRemoteAvatarRecord = true; // Either complete or incomplete.

                // Treat this as a new avatar if the container appears to be incomplete.
                // This may happen if a previous upload process was interrupted, meaning we reserved an
                // avatar record at the start of the upload, and then never actually pushed any bundles to it.
                IsNewAvatar =
                    _avatarData.PendingUpload ||
                    string.IsNullOrEmpty(_avatarData.Name) ||
                    string.IsNullOrEmpty(_avatarData.ImageUrl) ||
                    string.IsNullOrEmpty(_avatarData.ThumbnailImageUrl);
            }

            if (IsNewAvatar && !hasRemoteAvatarRecord)
            {
                // Wipe out all data, replacing with local session state
                RestoreSessionState();
                
                _avatarData.CreatedAt = DateTime.Now;
                _avatarData.UpdatedAt = DateTime.MinValue;
                // Hide these labels:
                _lastUpdatedLabel.parent.AddToClassList("d-none");
                _versionLabel.parent.AddToClassList("d-none");
                _fallbackInfo.AddToClassList("d-none");

                platformsBlock.parent.AddToClassList("d-none");
                
                switch (pm.fallbackStatus)
                {
                    case PipelineManager.FallbackStatus.Valid:
                        CurrentFallbackStatus = FallbackStatus.Compatible;
                        break;
                    default:
                        CurrentFallbackStatus = FallbackStatus.Incompatible;
                        break;
                }
            }
            else
            {
                AvatarBuilderSessionState.Clear();

                // If this is a complete record, this will populate the UI normally.
                // If this is an incomplete record, this will populate the UI with whatever data it can.

                platformsBlock.parent.RemoveFromClassList("d-none");

                _nameField.value = _avatarData.Name;
                _descriptionField.value = _avatarData.Description;
                _visibilityPopup.value = _avatarData.ReleaseStatus;

                _primaryStyleField.SetValue(_avatarData.Styles.Primary);
                _secondaryStyleField.SetValue(_avatarData.Styles.Secondary);
                
                // Populate and show the last updated, version and fallback info labels...

                _lastUpdatedLabel.text = (_avatarData.UpdatedAt != DateTime.MinValue ? _avatarData.UpdatedAt : _avatarData.CreatedAt).ToLocalTime().ToString(CultureInfo.CurrentCulture);
                _lastUpdatedLabel.parent.RemoveFromClassList("d-none");
                
                _versionLabel.text = _avatarData.Version.ToString();
                _versionLabel.parent.RemoveFromClassList("d-none");

                _fallbackInfo.parent.RemoveFromClassList("d-none");

                var platforms = new HashSet<string>();
                foreach (var p in _avatarData.UnityPackages.Select(p => VRCSdkControlPanel.CONTENT_PLATFORMS_MAP[p.Platform]))
                {
                    platforms.Add(p);
                }
                platformsBlock.text = string.Join(", ", platforms);
                
                await _thumbnail.SetImageUrl(_avatarData.ThumbnailImageUrl, _avatarSwitchCancellationToken.Token);
                
                if (APIUser.CurrentUser?.fallbackId == _avatarData.ID)
                {
                    CurrentFallbackStatus = FallbackStatus.Selected;
                }
                else
                {
                    switch (pm.fallbackStatus)
                    {
                        case PipelineManager.FallbackStatus.Valid:
                            if (platforms.Contains("Windows") && platforms.Contains("Android") && Tools.Platform == "android")
                            {
                                CurrentFallbackStatus = FallbackStatus.Selectable;
                            }
                            else
                            {
                                CurrentFallbackStatus = FallbackStatus.Compatible;
                            }
                            break;
                        default:
                            CurrentFallbackStatus = FallbackStatus.Incompatible;
                            break;
                    }
                }
            }

            // Notify now, whether this is a new avatar or not.
            ContentInfoLoaded?.Invoke(this, (_selectedAvatar.gameObject, _avatarData, _newThumbnailImagePath));
            
            _nameField.Loading = false;
            _descriptionField.Loading = false;
            _thumbnail.Loading = false;
            _contentWarningsField.Loading = false;
            UiEnabled = true;

            var avatarTags = _avatarData.Tags ?? new List<string>();
            _originalAvatarData = _avatarData;
            // lists get passed by reference, so we instantiate a new list to avoid modifying the original
            _originalAvatarData.Tags = new List<string>(avatarTags);

            _contentWarningsField.OriginalOptions = _originalAvatarData.Tags;
            _contentWarningsField.SelectedOptions = avatarTags;
            _contentWarningsField.OnToggleOption += HandleToggleTag;
            
            _tagsField.TagFilter = tagList => tagList.Where(t =>
                (APIUser.CurrentUser?.hasSuperPowers ?? false) || t.StartsWith("author_tag_")).ToList();
            _tagsField.TagLimit = APIUser.CurrentUser?.hasSuperPowers ?? false ? 100 : 10;
            _tagsField.FormatTagDisplay = input => input.Replace("author_tag_", "");
            _tagsField.IsProtectedTag = input => input.StartsWith("system_");
            _tagsField.tags = avatarTags;
            
            _tagsField.OnAddTag += HandleAddTag;
            _tagsField.OnRemoveTag += HandleRemoveTag;

            _nameField.RegisterValueChangedCallback(HandleNameChange);
            _descriptionField.RegisterValueChangedCallback(HandleDescriptionChange);
            _visibilityPopup.RegisterValueChangedCallback(HandleVisibilityChange);
            _thumbnailBlock.OnNewThumbnailSelected += HandleThumbnailChanged;
            _primaryStyleField.RegisterValueChangedCallback(HandlePrimaryStyleChange);
            _secondaryStyleField.RegisterValueChangedCallback(HandleSecondaryStyleChange);
            _secondaryStyleField.SetEnabled(_primaryStyleField.value != null);
            
            _discardChangesButton.clicked += HandleDiscardChangesClick;
            _saveChangesButton.clicked += HandleSaveChangesClick;

            root.schedule.Execute(CheckBlueprintChanges).Every(1000);
        }

        private void ClearAvatarData(PipelineManager pm)
        {
            // Do not clear blueprint IDs during a build or upload
            if (_buildState != SdkBuildState.Building && _uploadState != SdkUploadState.Uploading)
            {
                Core.Logger.LogError("Loaded data for an avatar we do not own, clearing blueprint ID");
                Undo.RecordObject(pm, "Cleared the blueprint ID we do not own");
                pm.blueprintId = "";
                _lastBlueprintId = "";
            }
            _avatarData = new VRCAvatar();
            IsNewAvatar = true;
        }

        private void RestoreSessionState()
        {
            _avatarData.Name = AvatarBuilderSessionState.AvatarName;
            _nameField.SetValueWithoutNotify(_avatarData.Name);

            _avatarData.Description = AvatarBuilderSessionState.AvatarDesc;
            _descriptionField.SetValueWithoutNotify(_avatarData.Description);
            
            _avatarData.ReleaseStatus = AvatarBuilderSessionState.AvatarReleaseStatus;
            _visibilityPopup.SetValueWithoutNotify(_avatarData.ReleaseStatus);

            _avatarData.Styles = new VRCAvatar.AvatarStyles
            {
                Primary = AvatarBuilderSessionState.AvatarPrimaryStyle,
                Secondary = AvatarBuilderSessionState.AvatarSecondaryStyle
            };

            _avatarData.Tags = new List<string>(AvatarBuilderSessionState.AvatarTags.Split('|', StringSplitOptions.RemoveEmptyEntries).Where(t => !string.IsNullOrWhiteSpace(t)));
            _tagsField.tags = _contentWarningsField.SelectedOptions = _avatarData.Tags;
            
            _newThumbnailImagePath = AvatarBuilderSessionState.AvatarThumbPath;
            if (!string.IsNullOrWhiteSpace(_newThumbnailImagePath))
                _thumbnail.SetImage(_newThumbnailImagePath);
        }

        #region Event Handlers

        private void HandlePanelDetach(DetachFromPanelEvent evt)
        {
            EditorSceneManager.sceneClosed -= HandleSceneClosed;
        }

        // This auto-cancels uploads when the user changes scenes
        private void HandleSceneClosed(Scene scene)
        {
            _avatarSwitchCancellationToken.Cancel();
            _avatarSwitchCancellationToken = new CancellationTokenSource();
            
            if (_avatarUploadCancellationTokenSource == null) return;
            _avatarUploadCancellationTokenSource.Cancel();
            _avatarUploadCancellationTokenSource = null;
        }

        private void HandleSdkPanelDisable(object sender, EventArgs evt)
        {
            _avatarSwitchCancellationToken.Cancel();
            _avatarSwitchCancellationToken = new CancellationTokenSource();
            
            if (_avatarUploadCancellationTokenSource == null) return;
            _avatarUploadCancellationTokenSource.Cancel();
            _avatarUploadCancellationTokenSource = null;
        }

        
        private void HandleFoldoutToggle(ChangeEvent<bool> evt)
        {
            SessionState.SetBool($"{AvatarBuilderSessionState.SESSION_STATE_PREFIX}.Foldout.{((VisualElement) evt.currentTarget).name}", evt.newValue);
        }

        private void HandleNameChange(ChangeEvent<string> evt)
        {
            _avatarData.Name = evt.newValue;
            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarName = _avatarData.Name;

            // do not allow empty names
            _saveChangesButton.SetEnabled(!string.IsNullOrWhiteSpace(evt.newValue));
            IsContentInfoDirty = CheckDirty();
        }

        private void HandleDescriptionChange(ChangeEvent<string> evt)
        {
            _avatarData.Description = evt.newValue;
            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarDesc = _avatarData.Description;

            IsContentInfoDirty = CheckDirty();
        }

        private void HandlePrimaryStyleChange(ChangeEvent<string> evt)
        {
            _avatarData.Styles = new VRCAvatar.AvatarStyles
            {
                Primary = evt.newValue,
                Secondary = _avatarData.Styles.Secondary
            };
            
            // Swap values if we select the same one
            if (evt.newValue == _secondaryStyleField.value && evt.newValue != null)
            {
                _secondaryStyleField.value = evt.previousValue;
                _avatarData.Styles = new VRCAvatar.AvatarStyles
                {
                    Primary = evt.newValue,
                    Secondary = evt.previousValue
                };
            }

            // If we unselect the primary style, and we have a secondary style - set primary to secondary, and clear secondary
            if (evt.newValue == null && _secondaryStyleField.value != null)
            {
                _primaryStyleField.SetValueWithoutNotify(_secondaryStyleField.value);
                _avatarData.Styles = new VRCAvatar.AvatarStyles
                {
                    Primary = _secondaryStyleField.value,
                    Secondary = null
                };
                _secondaryStyleField.value = null;
            }
            
            // We should account for swapping and other aliasing here
            _secondaryStyleField.SetEnabled(_avatarData.Styles.Primary != null);
            
            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarPrimaryStyle = _avatarData.Styles.Primary;

            IsContentInfoDirty = CheckDirty();
        }
        
        private void HandleSecondaryStyleChange(ChangeEvent<string> evt)
        {
            _avatarData.Styles = new VRCAvatar.AvatarStyles
            {
                Primary = _avatarData.Styles.Primary,
                Secondary = evt.newValue
            };
            
            // Swap values if we select the same one
            if (evt.newValue == _primaryStyleField.value  && evt.newValue != StyleField.NOT_SPECIFIED)
            {
                _primaryStyleField.value = evt.previousValue;
                _avatarData.Styles = new VRCAvatar.AvatarStyles
                {
                    Primary = evt.previousValue,
                    Secondary = evt.newValue
                };
            }
            
            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarPrimaryStyle = _avatarData.Styles.Primary;

            IsContentInfoDirty = CheckDirty();
        }

        private void SetupAvatarStylesForUpload(ref VRCAvatar avatarData)
        {
            // Handle style ids and hierarchy
            if (avatarData.Styles.Primary == null)
            {
                // If we have secondary style but no primary - move it to primary
                if (avatarData.Styles.Secondary != null)
                {
                    avatarData.Styles = new VRCAvatar.AvatarStyles
                    {
                        Primary = avatarData.Styles.Secondary,
                        Secondary = null
                    };
                }
            }

            // Styles should be submitted via ID while they come back as flat strings
            // So we resolve them back their IDs here
            avatarData.Styles = new VRCAvatar.AvatarStyles
            {
                Primary = _primaryStyleField.GetStyleId(avatarData.Styles.Primary),
                Secondary = _secondaryStyleField.GetStyleId(avatarData.Styles.Secondary)
            };
        }
        
        private void HandleAddTag(object sender, string tag)
        {
            if (_avatarData.Tags == null)
                _avatarData.Tags = new List<string>();

            var formattedTag = "author_tag_" + tag.ToLowerInvariant().Replace(' ', '_');
            if (string.IsNullOrWhiteSpace(formattedTag)) return;
            if (_avatarData.Tags.Contains(formattedTag)) return;
            
            _avatarData.Tags.Add(formattedTag);
            _tagsField.tags = _contentWarningsField.SelectedOptions = _avatarData.Tags;

            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarTags = string.Join("|", _avatarData.Tags);

            IsContentInfoDirty = CheckDirty();
        }

        private void HandleRemoveTag(object sender, string tag)
        {
            if (_avatarData.Tags == null)
                _avatarData.Tags = new List<string>();

            if (!_avatarData.Tags.Contains(tag))
                return;

            _avatarData.Tags.Remove(tag);
            _tagsField.tags = _contentWarningsField.SelectedOptions = _avatarData.Tags;

            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarTags = string.Join("|", _avatarData.Tags);

            IsContentInfoDirty = CheckDirty();
        }
        
        private void HandleToggleTag(object sender, string tag)
        {
            if (_avatarData.Tags == null)
                _avatarData.Tags = new List<string>();

            if (_avatarData.Tags.Contains(tag))
                _avatarData.Tags.Remove(tag);
            else
                _avatarData.Tags.Add(tag);

            _tagsField.tags = _contentWarningsField.SelectedOptions = _avatarData.Tags;
            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarTags = string.Join("|", _avatarData.Tags);

            IsContentInfoDirty = CheckDirty();
        }

        private void HandleVisibilityChange(ChangeEvent<string> evt)
        {
            _avatarData.ReleaseStatus = evt.newValue;

            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarReleaseStatus = evt.newValue;
            
            IsContentInfoDirty = CheckDirty();
        }

        private void HandleThumbnailChanged(object sender, string imagePath)
        {
            if (string.IsNullOrWhiteSpace(imagePath)) return;
            
            _newThumbnailImagePath = imagePath;
            if (IsNewAvatar)
                AvatarBuilderSessionState.AvatarThumbPath = _newThumbnailImagePath;
            
            _thumbnail.SetImage(_newThumbnailImagePath);
            IsContentInfoDirty = CheckDirty();
        }

        private async void HandleDiscardChangesClick()
        {
            _avatarData = _originalAvatarData;
            _avatarData.Tags = new List<string>(_originalAvatarData.Tags);
            _contentWarningsField.SelectedOptions = _avatarData.Tags;
            _tagsField.tags = _contentWarningsField.OriginalOptions = _avatarData.Tags;
            _nameField.value = _avatarData.Name;
            _descriptionField.value = _avatarData.Description;
            _visibilityPopup.value = _avatarData.ReleaseStatus;
            _lastUpdatedLabel.text = _avatarData.UpdatedAt != DateTime.MinValue ? _avatarData.UpdatedAt.ToString() : _avatarData.CreatedAt.ToString();
            _versionLabel.text = _avatarData.Version.ToString();
            _primaryStyleField.value = _avatarData.Styles.Primary;
            _secondaryStyleField.value = _avatarData.Styles.Secondary;

            _nameField.Reset();
            _descriptionField.Reset();
            _newThumbnailImagePath = null;
            await _thumbnail.SetImageUrl(_avatarData.ThumbnailImageUrl, _avatarSwitchCancellationToken.Token);
            IsContentInfoDirty = false;
        }

        private async void HandleSaveChangesClick()
        {
            _tagsField.StopEditing();
            UiEnabled = false;

            if (_nameField.IsPlaceholder() || string.IsNullOrWhiteSpace(_nameField.text))
            {
                Debug.LogError("Name cannot be empty");
                UiEnabled = true;
                return;
            }

            if (_descriptionField.IsPlaceholder())
            {
                _avatarData.Description = "";
            }

            SetupAvatarStylesForUpload(ref _avatarData);
            
            _avatarUploadCancellationTokenSource = new CancellationTokenSource();
            _avatarUploadCancellationToken = _avatarUploadCancellationTokenSource.Token;
            
            if (!string.IsNullOrWhiteSpace(_newThumbnailImagePath))
            {
                _builderProgress.ClearProgress();

                // to avoid loss of exceptions, we hoist it into a local function
                async void Progress(string status, float percentage)
                {
                    // these callbacks can be dispatched off-thread, so we ensure we're main thread pinned
                    await UniTask.SwitchToMainThread();
                    _builderProgress.SetProgress(new BuilderProgress.ProgressBarStateData
                    {
                        Visible = true,
                        Progress = percentage * 0.8f,
                        Text = status
                    });
                }
                
                _newThumbnailImagePath = VRC_EditorTools.CropImage(_newThumbnailImagePath, 800, 600, true);
                VRCAvatar updatedAvatar;
                try
                {
                    updatedAvatar = await VRCApi.UpdateAvatarImage(
                        _avatarData.ID,
                        _avatarData,
                        _newThumbnailImagePath,
                        Progress, _avatarUploadCancellationToken);
                    
                    // also need to update the base avatar data
                    if (!AvatarDataEqual())
                    {
                        _builderProgress.SetProgress(new BuilderProgress.ProgressBarStateData
                        {
                            Visible = true,
                            Text = "Saving Avatar Changes...",
                            Progress = 1f
                        });

                        updatedAvatar = await VRCApi.UpdateAvatarInfo(_avatarData.ID, _avatarData,
                            _avatarUploadCancellationToken);
                    }
                }
                catch (ApiErrorException e)
                {
                    InfoUpdateError(this, e.ErrorMessage);
                    return;
                }
                catch (Exception e)
                {
                    InfoUpdateError(this, e.Message);
                    return;
                }

                _avatarData = updatedAvatar;
                _originalAvatarData = updatedAvatar;
                await _thumbnail.SetImageUrl(_avatarData.ThumbnailImageUrl, _avatarSwitchCancellationToken.Token);
                _contentWarningsField.OriginalOptions = _originalAvatarData.Tags = new List<string>(_avatarData.Tags ?? new List<string>());
                _tagsField.tags = _contentWarningsField.SelectedOptions = _avatarData.Tags ?? new List<string>();
                _newThumbnailImagePath = null;
            }
            else
            {
                _builderProgress.SetProgress(new BuilderProgress.ProgressBarStateData
                {
                    Visible = true,
                    Text = "Saving Avatar Changes...",
                    Progress = 1f
                });
                Core.Logger.Log("Updating avatar");
                var updatedAvatar = await VRCApi.UpdateAvatarInfo(_avatarData.ID, _avatarData, _avatarUploadCancellationToken);
                Core.Logger.Log("Updated avatar");
                _avatarData = updatedAvatar;
                _originalAvatarData = updatedAvatar;
                _contentWarningsField.OriginalOptions = _originalAvatarData.Tags = new List<string>(_avatarData.Tags ?? new List<string>());
                _tagsField.tags = _contentWarningsField.SelectedOptions = _avatarData.Tags ?? new List<string>();
            }
            
            _builderProgress.HideProgress();
            
            UiEnabled = true;
            _nameField.value = _avatarData.Name;
            _descriptionField.value = _avatarData.Description;
            _visibilityPopup.value = _avatarData.ReleaseStatus;
            _lastUpdatedLabel.text = _avatarData.UpdatedAt != DateTime.MinValue ? _avatarData.UpdatedAt.ToString(): _avatarData.CreatedAt.ToString();
            _versionLabel.text = _avatarData.Version.ToString();
            _primaryStyleField.value = _avatarData.Styles.Primary;
            _secondaryStyleField.value = _avatarData.Styles.Secondary;

            _nameField.Reset();
            _descriptionField.Reset();
            IsContentInfoDirty = false;
        }
        #endregion

        private bool AvatarDataEqual()
        {
            return _avatarData.Name.Equals(_originalAvatarData.Name) &&
                   _avatarData.Description.Equals(_originalAvatarData.Description) &&
                   _avatarData.Tags.SequenceEqual(_originalAvatarData.Tags) &&
                   _avatarData.ReleaseStatus.Equals(_originalAvatarData.ReleaseStatus) &&
                   _avatarData.Styles.Primary == _originalAvatarData.Styles.Primary && // style strings can be null
                   _avatarData.Styles.Secondary == _originalAvatarData.Styles.Secondary;
        }
        
        private bool CheckDirty()
        {
            // we ignore the diffs for new avatars, since they're not published yet
            if (IsNewAvatar) return false;
            if (string.IsNullOrWhiteSpace(_avatarData.ID) || string.IsNullOrWhiteSpace(_originalAvatarData.ID))
                return false;
            return !AvatarDataEqual()|| !string.IsNullOrWhiteSpace(_newThumbnailImagePath);
        }

        private void CheckBlueprintChanges()
        {
            if (!UiEnabled) return;
            if (_selectedAvatar == null) return;
            if (!_selectedAvatar.TryGetComponent<PipelineManager>(out var pm)) return;
            if (_lastBlueprintId == pm.blueprintId) return;
            HandleAvatarSwitch(_visualRoot);
            _lastBlueprintId = pm.blueprintId;
        }

        private enum SDKBuildActionType
        {
            BuildAndPublish,
            BuildAndTest,
        }

        private string GetBuildTypeText(SDKBuildActionType actionType)
        {
            switch (actionType)
            {
                case SDKBuildActionType.BuildAndPublish: return "Build & Publish Your Avatar Online";
                case SDKBuildActionType.BuildAndTest: return "Build & Test Your Avatar";
            }
            throw new Exception($"Unknown SDK Build Action {actionType}");
        }
        
        private record SDKBuildAction
        {
            public SDKBuildActionType BuildActionType;
            public Action OnMainActionClicked;
            public Action<VisualElement> OnSetup; // Called when the user switched the build type to this build type
        }

        private List<SDKBuildAction> _sdkBuildActions;
        private SDKBuildAction _selectedSDKBuildAction;
        private List<BuildTarget> _selectedBuildTargets = new();
        
        private void OnMainActionClicked()
        {
            SDKBuildAction selected = _sdkBuildActions
                .FirstOrDefault(x => x.BuildActionType.ToString() == VRCSettings.SDKAvatarBuildType);
            if (selected != null && selected.OnMainActionClicked != null)
            {
                selected.OnMainActionClicked();
            }
        }
        
        private void BuildAndPublishSetup(VisualElement root)
        {
            var mainActionButton = root.Q<Button>("main-action-button");
            var isMPB = _selectedBuildTargets.Count > 1;
            if (_selectedBuildTargets.Count == 0)
            {
                mainActionButton.text = "You need to select at least one platform";
                mainActionButton.SetEnabled(false);
            }
            else
            {
                mainActionButton.text = isMPB ? "Multi-Platform Build & Publish" : "Build & Publish";
                mainActionButton.SetEnabled(true);
            }
        }

        private void OnBuildAndPublishAction()
        {
            // Check for Monetized Avatar
            if (!IsAvatarAVM)
            {
                RunBuildAndPublish().ConfigureAwait(false);
                return;
            }

            var confirmationModal = Modal.CreateAndShow(
                "This avatar is linked to a product",
                "Since this avatar has been marked for sale, it will be <b>reviewed</b> by our moderators before becoming available for purchase inside VRChat.",
                () => RunBuildAndPublish(uploadSuccess: ShowAVMUploadSuccessModal).ConfigureAwait(false),
                "OK",
                _buildButtonsBlock);
            confirmationModal.SetIcon("vrcIssueIcon");
            confirmationModal.OnCancel += (_, _) =>
            {
                // Perform some cancellation logic if needed
            };
        }

        private async void ShowAVMUploadSuccessModal(object sender, string id)
        {
            await Task.Delay(100);
            _builderProgress?.SetCancelButtonVisibility(false);
            _builderProgress?.HideProgress();
            UiEnabled = true;
            
            _originalAvatarData = _avatarData;
            _originalAvatarData.Tags = new List<string>(_avatarData.Tags ?? new List<string>());
            _newThumbnailImagePath = null;
            
            HandleAvatarSwitch(_visualRoot);
            
            _avmNotesTextField.value = "";
            _avmNotesModal.Open();

            _avmNotesSendButton.clicked += OnAVMNotesSendButtonOnClicked;
            
            void OnCancel(object o, EventArgs eventArgs)
            {
                _avmNotesSendButton.clicked -= OnAVMNotesSendButtonOnClicked;
                _avmNotesModal.OnCancel -= OnCancel;
            }
            
            _avmNotesModal.OnCancel += OnCancel;

            async void OnClose(object o, EventArgs eventArgs)
            {
                _avmNotesModal.OnClose -= OnClose;
                await _builder.ShowBuilderNotification("Upload Succeeded!", new AvatarUploadSuccessNotification(id, "We’ll notify you via email as soon as your avatar has been reviewed.", "OK", buttonAction: () => _builder.DismissNotification()), "green");
            }

            _avmNotesModal.OnClose += OnClose;
            return;

            void OnAVMNotesSendButtonOnClicked()
            {
                try
                {
                    VRCApi.SubmitAssetReviewNotes(_avatarData.ID, _avmNotesTextField.value).ConfigureAwait(false);
                }
                catch (ApiErrorException e)
                {
                    Core.Logger.Log($"Failed to send AVM notes: {e.ErrorMessage}");
                }
                catch (Exception e)
                {
                    Debug.LogException(e);
                }
                _avmNotesSendButton.clicked -= OnAVMNotesSendButtonOnClicked;
                _avmNotesModal.OnCancel -= OnCancel;
                _avmNotesModal.Close();
            }
        }

        private async Task RunBuildAndPublish(EventHandler<string> buildSuccess = null, EventHandler<string> uploadSuccess = null)
        {
            
            VRC_SdkBuilder.ActiveBuildType = VRC_SdkBuilder.BuildType.Publish;
            
            // Kick off the multi-platform build process
            var isMPB = _selectedBuildTargets.Count > 1;
            if (isMPB)
            {
                StartMultiPlatformBuild(this, (_selectedAvatar.gameObject, _avatarData, _newThumbnailImagePath));
                return;
            }
            
            UiEnabled = false;

            SetupAvatarStylesForUpload(ref _avatarData);

            SubscribePanelToBuildCallbacks(buildSuccess: buildSuccess, uploadSuccess: uploadSuccess);

            _avatarUploadCancellationTokenSource = new CancellationTokenSource();

            try
            {
                await BuildAndUpload(_selectedAvatar.gameObject,
                    PerPlatformOverrides.GetPlatformOverrides(_selectedAvatar.gameObject), _avatarData,
                    _newThumbnailImagePath,
                    _avatarUploadCancellationTokenSource.Token);
            }
            finally
            {
                    
                UnsubscribePanelFromBuildCallbacks(buildSuccess: buildSuccess, uploadSuccess: uploadSuccess);
            }
        }
        
        private void BuildAndTestSetup(VisualElement root)
        {
            var mainActionButton = root.Q<Button>("main-action-button");
            mainActionButton.text = "Build & Test";
        }

        private async void OnBuildAndTestAction()
        {
            VRC_SdkBuilder.ActiveBuildType = VRC_SdkBuilder.BuildType.Test;
                
            UiEnabled = false;

            async void BuildSuccess(object sender, string path)
            {
                BuildStageSuccess(sender, path);

                await Task.Delay(500);
                _builderProgress.HideProgress();
                UiEnabled = true;
                _thumbnail.Loading = false;
                RevertThumbnail();
                
                ShowBuildSuccessNotification(true);
            }

            SubscribePanelToBuildCallbacks(buildSuccess: BuildSuccess);

            try
            {
                await BuildAndTest(_selectedAvatar.gameObject);
            }
            finally
            {
                UnsubscribePanelFromBuildCallbacks(buildSuccess: BuildSuccess);
            }
        }
        
        public void CreateBuildGUI(VisualElement root)
        {
            var tree = Resources.Load<VisualTreeAsset>("VRCSdkAvatarBuilderBuildLayout");
            tree.CloneTree(root);
            _buildVisualRoot = root;
            
            _buildButtonsBlock = root.Q<VisualElement>("build-buttons-block");
            _builderProgress = root.Q<BuilderProgress>("progress-bar");
            _avmNotesModal = root.Q<Modal>("avm-update-notes-modal");
            _avmNotesModal.SetAnchor(_buildButtonsBlock);
            _avmNotesTextField = _avmNotesModal.Q<TextField>("avm-update-notes-field");
            _avmNotesSendButton = _avmNotesModal.Q<Button>("avm-update-notes-send");
            
            // Setup build types and their associated action when clicking the main action button
            _sdkBuildActions = new List<SDKBuildAction>()
            {
                new SDKBuildAction{BuildActionType = SDKBuildActionType.BuildAndPublish, OnMainActionClicked = OnBuildAndPublishAction, OnSetup = BuildAndPublishSetup},
                new SDKBuildAction{BuildActionType = SDKBuildActionType.BuildAndTest, OnSetup = BuildAndTestSetup, OnMainActionClicked = OnBuildAndTestAction},
            };
            
            var platformPopup = root.Q<PlatformSwitcherPopup>("platform-switcher-popup");
            
            {
                var buildTypeContainer = root.Q<VisualElement>("build-type-container");
                List<string> buildTypeOptions = _sdkBuildActions.Select(x => GetBuildTypeText(x.BuildActionType)).ToList(); 

                int selectedBuildTypeIndex = _sdkBuildActions.FindIndex(x=>x.BuildActionType.ToString() == VRCSettings.SDKAvatarBuildType);
                if (selectedBuildTypeIndex < 0 || selectedBuildTypeIndex >= buildTypeOptions.Count)
                {
                    // Reset to a known good index if out of bounds
                    selectedBuildTypeIndex = 0;
                    VRCSettings.SDKAvatarBuildType = _sdkBuildActions[0].BuildActionType.ToString();
                }
                
                var buildTypePopup = new PopupField<string>(null, buildTypeOptions, selectedBuildTypeIndex)
                {
                    name = "build-type-dropdown",
                };
                // Unity dropdown menus filter out a single '&' character
                buildTypePopup.formatListItemCallback += s => s.Replace("&", "&&"); 
                buildTypePopup.AddToClassList("ml-0");
                buildTypePopup.AddToClassList("flex-grow-1");
                
                if (_sdkBuildActions[selectedBuildTypeIndex].OnSetup != null)
                {
                    // Set up the currently selected build action
                    _sdkBuildActions[selectedBuildTypeIndex].OnSetup(root);
                }
                
                _selectedSDKBuildAction = _sdkBuildActions[selectedBuildTypeIndex];

                buildTypeContainer.Insert(1, buildTypePopup);

                var mainActionButton = root.Q<Button>("main-action-button");
                buildTypePopup.RegisterValueChangedCallback(evt =>
                {
                    SDKBuildAction selected = _sdkBuildActions
                        .FirstOrDefault(x => GetBuildTypeText(x.BuildActionType) == evt.newValue);
                    _selectedSDKBuildAction = selected;
                    mainActionButton.SetEnabled(true);
                    if (selected != null)
                    {
                        VRCSettings.SDKAvatarBuildType = selected.BuildActionType.ToString();
                        if (selected.OnSetup != null)
                        {
                            selected.OnSetup(root);
                        }
                        
                        // Only Build & Publish supports multi-platform
                        if (selected.BuildActionType != SDKBuildActionType.BuildAndPublish)
                        {
                            _selectedBuildTargets = new List<BuildTarget> { VRC_EditorTools.GetCurrentBuildTargetEnum() };
                            platformPopup.SelectedOptions = _selectedBuildTargets;
                        }
                    }
                    platformPopup.Refresh();
                });
                
                mainActionButton.clicked += OnMainActionClicked;
            }
            
            {
                _selectedBuildTargets = AvatarBuilderSessionState.AvatarPlatforms.Count > 0
                    ? AvatarBuilderSessionState.AvatarPlatforms
                    : new List<BuildTarget> { VRC_EditorTools.GetCurrentBuildTargetEnum() };
                // fire the build type setup on initial platform load
                _selectedSDKBuildAction?.OnSetup?.Invoke(root);
                platformPopup.SelectedOptions = _selectedBuildTargets;
                platformPopup.OnToggleOption += (_, target) =>
                {
                    if (platformPopup.SelectedOptions.Contains(target))
                    {
                        _selectedBuildTargets.Remove(target);
                        platformPopup.SelectedOptions = _selectedBuildTargets;
                        AvatarBuilderSessionState.AvatarPlatforms = _selectedBuildTargets;
                        return;
                    }
                    
                    _selectedBuildTargets.Add(target);
                    // If the current action isn't build & publish - we only support one target platform at a time
                    // This invokes platform switching logic
                    if (_selectedSDKBuildAction?.BuildActionType != SDKBuildActionType.BuildAndPublish)
                    {
                        _selectedBuildTargets.RemoveAll(t => t != target);
                    }
                    platformPopup.SelectedOptions = _selectedBuildTargets;
                    AvatarBuilderSessionState.AvatarPlatforms = _selectedBuildTargets;
                };
                platformPopup.OnPopupClosed += (_, platforms) =>
                {
                    var currentTarget = VRC_EditorTools.GetCurrentBuildTargetEnum();
                    // If only one target is selected - ask to switch
                    if (platforms.Count == 1 && platforms[0] != currentTarget)
                    {
                        if (EditorUtility.DisplayDialog("Build Target Switcher",
                                $"Are you sure you want to switch your build target to {VRC_EditorTools.GetTargetName(platforms[0])}? This could take a while.",
                                "Confirm", "Cancel"))
                        {
                            EditorUserBuildSettings.selectedBuildTargetGroup =
                                VRC_EditorTools.GetBuildTargetGroupForTarget(platforms[0]);
                            var switched =
                                EditorUserBuildSettings.SwitchActiveBuildTargetAsync(
                                    EditorUserBuildSettings.selectedBuildTargetGroup, platforms[0]);
                            if (!switched)
                            {
                                _builder.ShowBuilderNotification(
                                    $"Failed to switch to {VRC_EditorTools.GetTargetName(platforms[0])} target platform",
                                    new GenericBuilderNotification(
                                        $"Check if the Platform Support for {VRC_EditorTools.GetTargetName(platforms[0])} is installed in the Unity Hub",
                                        "Unity Console might have more information",
                                        "Show Console",
                                        VRC_EditorTools.OpenConsoleWindow
                                    ),
                                    "red"
                                ).ConfigureAwait(false);
                            }
                        }
                        else
                        {
                            platformPopup.SelectedOptions = new List<BuildTarget> { currentTarget };
                        }
                    }

                    _selectedBuildTargets = platformPopup.SelectedOptions.ToList();
                    _selectedSDKBuildAction?.OnSetup?.Invoke(root);
                    AvatarBuilderSessionState.AvatarPlatforms = _selectedBuildTargets;
                };
            }

            _v3Block = root.Q("v3-block");
            _mainBuildActionDisabledBlock = root.Q<VisualElement>("main-action-disabled-block");
            _mainBuildActionDisabledText = root.Q<Label>("main-action-disabled-text");
            
            SetupExtraPanelUI();

            root.schedule.Execute(() =>
            {
                if (_selectedAvatar == null) return;
                
                var isBuildingMPB = VRCMultiPlatformBuild.MPB;
                _buildButtonsBlock.SetEnabled(!isBuildingMPB);
                
                SDKBuildAction selectedAction = _sdkBuildActions
                    .FirstOrDefault(x => x.BuildActionType.ToString() == VRCSettings.SDKAvatarBuildType);
                if (selectedAction == null) throw new Exception($"Unable to identify selected build action {VRCSettings.SDKAvatarBuildType}");

                if (selectedAction.BuildActionType == SDKBuildActionType.BuildAndTest)
                {
                    if (!PlatformSupportsBuildAndTest())
                    {
                        _mainBuildActionDisabledText.text = "Building & testing on this platform is not supported";
                        _mainBuildActionDisabledBlock.RemoveFromClassList("d-none");
                        return;
                    }
                }
                else // Online Publishing
                {
                    if (IsNewAvatar && (string.IsNullOrWhiteSpace(_avatarData.Name) || string.IsNullOrWhiteSpace(_newThumbnailImagePath)))
                    {
                        _mainBuildActionDisabledText.text = "Please set a name and thumbnail before uploading";
                        _mainBuildActionDisabledBlock.RemoveFromClassList("d-none");
                        return;
                    }
                }
                // No errors. Hide disable block
                _mainBuildActionDisabledBlock.AddToClassList("d-none");
            }).Every(1000);
        }
        
        private bool PlatformSupportsBuildAndTest()
        {
            switch (Tools.Platform)
            {
                case "standalonewindows":
                case "android":
                case "ios":
                    return true;
            }

            return false;
        }
        
        public virtual void SetupExtraPanelUI()
        {
            
        }
        
        private async void StartMultiPlatformBuild(object sender, object data)
        {
            if (VRCMultiPlatformBuild.MPBState ==
                VRCMultiPlatformBuild.MultiPlatformBuildState.Building)
            {
                return;
            }
            
            // Sometimes the user might get loaded in after the SDK panel is opened
            // We wait for the user to log in before proceeding with MPB
            if (APIUser.CurrentUser == null)
            {
                var loginTimeoutSource = new CancellationTokenSource();
                loginTimeoutSource.CancelAfter(TimeSpan.FromMinutes(1));
                try
                {
                    await UniTask.WaitUntil(() => APIUser.CurrentUser != null, PlayerLoopTiming.Update,
                        loginTimeoutSource.Token);
                }
                catch (TaskCanceledException)
                {
                    Core.Logger.LogError("Timed out waiting for user to log in");
                    return;
                }
            }
            
            // If we're already in MPB - restore the build target list
            if (VRCMultiPlatformBuild.MPB)
            {
                _selectedBuildTargets = VRCMultiPlatformBuild.MPBPlatformsList;
            }
            
            var (target, content, thumbnailPath) = ((GameObject target, VRCAvatar content, string thumbnailPath)) data;
            
            if (string.IsNullOrWhiteSpace(content.ID) && string.IsNullOrWhiteSpace(content.Name))
            {
                return;
            }

            // If running a secondary platform build - ensure we're building the avatar we want
            if (VRCMultiPlatformBuild.MPBBuiltCount > 0)
            {
                if (target != GetAvatarFromSceneIdentifier(VRCMultiPlatformBuild.MPBContentIdentifier)) return;
            }

            ContentInfoLoaded -= StartMultiPlatformBuild;
            
            UiEnabled = false;
            
            SubscribePanelToBuildCallbacks(buildError: MultiPlatformBuildError, uploadError: MultiPlatformUploadError);
            _avatarUploadCancellationTokenSource = new CancellationTokenSource();

            try
            {
                await BuildAndUploadMultiPlatform(target, PerPlatformOverrides.GetPlatformOverrides(target), content,
                    thumbnailPath, _avatarUploadCancellationTokenSource.Token);
            }
            finally
            {
                UnsubscribePanelFromBuildCallbacks(buildError: MultiPlatformBuildError, uploadError: MultiPlatformUploadError);
            }
        }

        private async void FinishMultiPlatformBuild(object sender, object data)
        {
            // When the user is being logged in after domain reload
            // ContentInfoLoaded can trigger while builder is in the background
            // We avoid dispatching this code until we're on the builder itself
            if (_builder.CurrentTab != VRCSdkControlPanel.PanelTab.Builder)
            {
                return;
            }
            ContentInfoLoaded -= FinishMultiPlatformBuild;
            
            // If avatar is a part of AVM - we need to show a special modal
            if (IsAvatarAVM)
            {
                ShowAVMUploadSuccessModal(this, _avatarData.ID);
                return;
            }
            
            await _builder.ShowBuilderNotification(
                "Multi-Platform Upload Finished",
                new AvatarUploadSuccessNotification(_avatarData.ID),
                "green"
            );
        }

        private async Task<string> Build(GameObject target, bool testAvatar, List<PerPlatformOverrides.Option> overrides)
        {
            if (target == null) return null;
            
            // Swap the target if we have overrides saved
            if (overrides != null)
            {
                if (target.TryGetComponent<PipelineManager>(out var pipelineManager))
                {
                    if (!string.IsNullOrWhiteSpace(pipelineManager.blueprintId))
                    {
                        var currentPlatform = VRC_EditorTools.GetCurrentBuildTargetEnum();
                        var overridePlatform = overrides.FirstOrDefault(o => o.platform == currentPlatform);
                        if (overridePlatform.avatar != null)
                        {
                            if (overridePlatform.avatar.TryGetComponent<PipelineManager>(out var overridePm))
                            {
                                // Ensure blueprint IDs are set and match
                                if (string.IsNullOrWhiteSpace(overridePm.blueprintId) || overridePm.blueprintId != pipelineManager.blueprintId)
                                {
                                    Undo.RecordObject(overridePm, "Set BlueprintId");
                                    overridePm.blueprintId = pipelineManager.blueprintId;
                                }
                                target = overridePlatform.avatar.gameObject;
                            }
                        }
                    }
                }
            }
            
            var buildBlocked =
                    !VRCBuildPipelineCallbacks.OnVRCSDKBuildRequested(VRCSDKRequestedBuildType.Avatar);
            if (buildBlocked)
            {
                throw await HandleBuildError(new BuildBlockedException("Build was blocked by the SDK callback"));
            }

            if (_builder == null)
            {
                throw await HandleBuildError(new BuilderException("Open the SDK panel to build and upload avatars"));
            }

            var originalFogSettings = EnvConfig.GetFogSettings();
            EnvConfig.SetFogSettings(
                new EnvConfig.FogSettings(EnvConfig.FogSettings.FogStrippingMode.Custom, true, true, true));

#if UNITY_ANDROID || UNITY_IOS
            EditorPrefs.SetBool("VRC.SDKBase_StripAllShaders", true);
#else
            EditorPrefs.SetBool("VRC.SDKBase_StripAllShaders", false);
#endif
            
            if (!target.TryGetComponent<PipelineManager>(out var pM))
            {
                throw await HandleBuildError(new BuilderException("This avatar does not have a PipelineManager"));
            }

            // builds can still self-assign ids for local testing
            if (string.IsNullOrWhiteSpace(pM.blueprintId) && VRC_SdkBuilder.ActiveBuildType == VRC_SdkBuilder.BuildType.Test)
            {
                Undo.RecordObject(pM, "Set BlueprintId");
                pM.AssignId(PipelineManager.ContentType.avatar);
            }

            VRC_SdkBuilder.shouldBuildUnityPackage = false;
            VRC_SdkBuilder.ClearCallbacks();

            var successTask = new TaskCompletionSource<string>();
            var errorTask = new TaskCompletionSource<string>();
            var validationTask = new TaskCompletionSource<object>();

            VRC_SdkBuilder.RegisterBuildProgressCallback(OnBuildProgress);
            VRC_SdkBuilder.RegisterBuildContentProcessedCallback(RegenerateAnimatorStateHashes);
            VRC_SdkBuilder.RegisterBuildContentProcessedCallback(AvatarValidation);
            VRC_SdkBuilder.RegisterBuildErrorCallback(OnBuildError);
            VRC_SdkBuilder.RegisterBuildSuccessCallback(OnBuildSuccess);

            VRC_EditorTools.GetSetPanelBuildingMethod().Invoke(_builder, null);
            OnSdkBuildStart?.Invoke(this, target);
            _buildState = SdkBuildState.Building;
            OnSdkBuildStateChange?.Invoke(this, _buildState);

            await Task.Delay(100);
            
            if (testAvatar && !PlatformSupportsBuildAndTest())
            {
                throw new BuilderException($"Avatar testing is not supported on platform '{Tools.Platform}'");
            }

            if (testAvatar)
            {
                try
                {
                    VRC_SdkBuilder.RunExportAndTestAvatarBlueprint(target);
                }
                catch
                {
                    // Errors are handled by the error callback
                }
            }
            else
            {
                try
                {
                    VRC_SdkBuilder.RunExportAvatarBlueprint(target);
                }
                catch
                {
                    // Errors are handled by the error callback
                }
            }

            // wait for avatar validations to finish first
            var avatarProcessedTask = Task.WhenAll(successTask.Task, validationTask.Task);
            var result = await Task.WhenAny(avatarProcessedTask, errorTask.Task);

            string bundlePath = null;
            bundlePath = result == avatarProcessedTask ? successTask.Task.Result : null;
            
            VRC_SdkBuilder.ClearCallbacks();
            EnvConfig.SetFogSettings(originalFogSettings);

            if (bundlePath == null)
            {
                throw await HandleBuildError(new BuilderException(errorTask.Task.Status == TaskStatus.RanToCompletion ? errorTask.Task.Result : "Unexpected Error Occurred"));
            }
            else
            {
                _buildState = SdkBuildState.Success;
                OnSdkBuildSuccess?.Invoke(this, bundlePath);
                OnSdkBuildStateChange?.Invoke(this, _buildState);
            }

            await FinishBuild();

            return bundlePath;
            
            void OnBuildProgress(object sender, string buildStatus)
            {
                OnSdkBuildProgress?.Invoke(sender, buildStatus);
            }

            async void AvatarValidation(object _, object processedAvatar)
            {
                try
                {
                    var avatarObject = (GameObject)processedAvatar;
                    if(avatarObject == null || !avatarObject.TryGetComponent<VRCAvatarDescriptor>(out var descriptor))
                    {
                        validationTask.TrySetResult(null);
                        return;
                    }

                    try
                    {
                        await CheckAvatarForValidationIssues(descriptor);
                    }
                    catch(Exception e)
                    {
                        if(e is ValidationException validationException)
                        {
                            Debug.LogError("Encountered the following validation issues during build:");
                            foreach(var error in validationException.Errors)
                            {
                                Debug.LogError(error);
                            }
                        }

                        errorTask.TrySetResult(e.Message);
                        return;
                    }

                    validationTask.TrySetResult(null);
                }
                catch(Exception e)
                {
                    // Catch and log any otherwise uncaught exceptions to protect against async void exceptions.
                    Debug.LogException(e);
                }
            }

            void RegenerateAnimatorStateHashes(object _, object processedAvatar)
            {
                var avatarObject = (GameObject)processedAvatar;
                if(avatarObject == null)
                    return;

                if(!avatarObject.TryGetComponent<VRCAvatarDescriptor>(out var descriptor))
                    return;

                GenerateDebugHashset(descriptor);

                if(!descriptor.TryGetComponent<Animator>(out var animator))
                    return;

                if(!animator.isHuman)
                    return;

                // re-save the layer masks for base layers after potential modifications
                var sO = new SerializedObject(descriptor);
                var baseLayers = sO.FindProperty("baseAnimationLayers");
                for(int i = 0; i < baseLayers.arraySize; i++)
                {
                    var layer = baseLayers.GetArrayElementAtIndex(i);
                    var type = (VRCAvatarDescriptor.AnimLayerType)layer.FindPropertyRelative("type").enumValueIndex;
                    switch(type)
                    {
                        case VRCAvatarDescriptor.AnimLayerType.FX:
                            SetLayerMaskFromControllerInternal(layer);
                            break;
                        case VRCAvatarDescriptor.AnimLayerType.Gesture:
                            SetLayerMaskFromControllerInternal(layer);
                            break;
                    }
                }
            }

            void OnBuildError(object _, string error)
            {
                errorTask.TrySetResult(error);
            }

            void OnBuildSuccess(object _, (string path, string signature) buildResult)
            {
                successTask.TrySetResult(buildResult.path);
            }
        }

        private async Task FinishBuild()
        {
            await Task.Delay(100);
            _buildState = SdkBuildState.Idle;
            OnSdkBuildFinish?.Invoke(this, "Avatar build finished");
            OnSdkBuildStateChange?.Invoke(this, _buildState);
            VRC_EditorTools.GetSetPanelIdleMethod().Invoke(_builder, null);
        }

        private async Task<Exception> HandleBuildError(Exception exception)
        {
            OnSdkBuildError?.Invoke(this, exception.Message);
            _buildState = SdkBuildState.Failure;
            OnSdkBuildStateChange?.Invoke(this, _buildState);

            await FinishBuild();
            return exception;
        }

        private async Task<bool> Upload(GameObject target, VRCAvatar avatar, bool firstTimeCreation, string bundlePath, string thumbnailPath = null,
            CancellationToken cancellationToken = default)
        {
            if (VRC_EditorTools.DryRunState)
            {
                return false;
            }
            
            if (cancellationToken == CancellationToken.None)
            {
                _avatarUploadCancellationTokenSource = new CancellationTokenSource();
                _avatarUploadCancellationToken = _avatarUploadCancellationTokenSource.Token;
            }
            else
            {
                _avatarUploadCancellationToken = cancellationToken;
            }
            
            if (string.IsNullOrWhiteSpace(bundlePath) || !File.Exists(bundlePath))
            {
                throw await HandleUploadError(new UploadException("Failed to find the built avatar bundle, the build likely failed"));
            }

            await VerifyUploadPermissions();

            bool mobile = ValidationEditorHelpers.IsMobilePlatform();
            if (ValidationEditorHelpers.CheckIfAssetBundleFileTooLarge(ContentType.Avatar, bundlePath, out int fileSize, mobile))
            {
                var limit = ValidationHelpers.GetAssetBundleSizeLimit(ContentType.Avatar, mobile);
                throw await HandleUploadError(new UploadException(
                    $"Avatar download size is too large for the target platform. {ValidationHelpers.FormatFileSize(fileSize)} > {ValidationHelpers.FormatFileSize(limit)}"));
            }

            if (ValidationEditorHelpers.CheckIfUncompressedAssetBundleFileTooLarge(ContentType.Avatar, out int fileSizeUncompressed, mobile))
            {
                var limit = ValidationHelpers.GetAssetBundleSizeLimit(ContentType.Avatar, mobile, false);
                throw await HandleUploadError(new UploadException(
                    $"Avatar uncompressed size is too large for the target platform. {ValidationHelpers.FormatFileSize(fileSizeUncompressed)} > {ValidationHelpers.FormatFileSize(limit)}"));
            }

            VRC_EditorTools.GetSetPanelUploadingMethod().Invoke(_builder, null);
            _uploadState = SdkUploadState.Uploading;
            OnSdkUploadStateChange?.Invoke(this, _uploadState);
            OnSdkUploadStart?.Invoke(this, EventArgs.Empty);

            await Task.Delay(100, _avatarUploadCancellationToken);
            
            if (!target.TryGetComponent<PipelineManager>(out var pM))
            {
                throw await HandleUploadError(new UploadException("Target avatar does not have a PipelineManager, make sure a PipelineManager component is present before uploading"));
            }
            
            // Guard against using a self-assigned ID being uploaded for an API-driven ID
            // This will cause the avatar to fail validation
            if (string.IsNullOrWhiteSpace(avatar.ID))
            {
                throw await HandleUploadError(new UploadException(
                    "Avatar info does not contain an ID. Make sure to acquire an ID from the API before uploading"));
            }

            VRCAvatar remoteData;
            try
            {
                remoteData =
                    await VRCApi.GetAvatar(avatar.ID, cancellationToken: _avatarUploadCancellationToken);
                if (APIUser.CurrentUser == null || remoteData.AuthorId != APIUser.CurrentUser?.id)
                {
                    throw await HandleUploadError(
                        new OwnershipException(
                            "Avatar's current ID belongs to a different user, assign a different ID"));
                }
            }
            catch (ApiErrorException e)
            {
                throw await HandleUploadError(
                    new UploadException(
                        $"Failed to load avatar data: {e.ErrorMessage}"));
            }
            catch (Exception e)
            {
                Debug.LogException(e);
                throw await HandleUploadError(
                    new UploadException(
                        $"Failed to load avatar data: {e.Message}"));
            }
            
            var hasNewThumbnail = !string.IsNullOrWhiteSpace(thumbnailPath);

            // We're uploading to a newly created record that doesn't have a thumbnail yet
            if (firstTimeCreation && !hasNewThumbnail)
            {
                throw await HandleUploadError(new UploadException("Thumbnail image is required for avatar creation"));
            }

            if (string.IsNullOrWhiteSpace(pM.blueprintId))
            {
                throw await HandleUploadError(new UploadException(
                    "Target avatar does not have a blueprint id assigned. Make sure an id is created and assigned before uploading"));
            }
            
            if (pM.blueprintId != avatar.ID)
            {
                throw await HandleUploadError(new UploadException(
                    "Target avatar's assigned ID doesn't match the API id. Make sure the PipelineManager component has the correct ID assigned before uploading"));
            }

            try
            {
                await VRCCopyrightAgreement.CheckCopyrightAgreement(pM, avatar);
            }
            catch (Exception e)
            {
                throw await HandleUploadError(e);
            }

            try
            {
                if (avatar.Tags?.Contains(VRCApi.AVATAR_FALLBACK_TAG) ?? false)
                {
                    if (pM.fallbackStatus == PipelineManager.FallbackStatus.InvalidPerformance ||
                        pM.fallbackStatus == PipelineManager.FallbackStatus.InvalidRig)
                    {
                        avatar.Tags = avatar.Tags.Where(t => t != VRCApi.AVATAR_FALLBACK_TAG).ToList();
                    }
                }

                // First time creation
                if (firstTimeCreation)
                {
                    Core.Logger.Log("Uploading an avatar for a pending avatar record", API.LOG_CATEGORY);
                    thumbnailPath = VRC_EditorTools.CropImage(thumbnailPath, 800, 600);
                    await VRCApi.CreateNewAvatar(avatar.ID, avatar, bundlePath, thumbnailPath,
                        (status, percentage) => OnSdkUploadProgress?.Invoke(this, (status, percentage)),
                        _avatarUploadCancellationToken);
                    _uploadState = SdkUploadState.Success;
                    OnSdkUploadSuccess?.Invoke(this, avatar.ID);

                    await FinishUpload();
                    return true;
                }
                
                // Avatar updates
                // Update content info first, to avoid overwriting the data
                if (!remoteData.ContentInfoEqual(avatar))
                {
                    Core.Logger.Log("Updating avatar info due to local changes", API.LOG_CATEGORY);
                    avatar = await VRCApi.UpdateAvatarInfo(pM.blueprintId, avatar, _avatarUploadCancellationToken);
                }
                
                if (hasNewThumbnail)
                {
                    Core.Logger.Log("Updating avatar thumbnail", API.LOG_CATEGORY);
                    thumbnailPath = VRC_EditorTools.CropImage(thumbnailPath, 800, 600);
                    avatar = await VRCApi.UpdateAvatarImage(pM.blueprintId, avatar, thumbnailPath,
                        (status, percentage) => { OnSdkUploadProgress?.Invoke(this, (status, percentage * 0.5f)); },
                        _avatarUploadCancellationToken);
                    _newThumbnailImagePath = null;
                }
                
                Core.Logger.Log("Updating avatar bundle", API.LOG_CATEGORY);
                avatar = await VRCApi.UpdateAvatarBundle(pM.blueprintId, avatar, bundlePath,
                    (status, percentage) =>
                    {
                        OnSdkUploadProgress?.Invoke(this, (status, (hasNewThumbnail
                            ? (0.5f +
                               percentage * 0.5f)
                            : percentage)));
                    },
                    _avatarUploadCancellationToken);
                
                _uploadState = SdkUploadState.Success;
                OnSdkUploadSuccess?.Invoke(this, avatar.ID);

                var packageList = VRCAnalyticsTools.GetPackageList();
                try
                {
                    AnalyticsSDK.ProjectPublished(packageList.ToArray(), _avatarData.ID,
                        AnalyticsSDK.ProjectType.Avatar);
                }
                catch (Exception e)
                {
                    Debug.LogError("Failed to send VPM manifest data to analytics");
                    Debug.LogException(e);
                }

                await FinishUpload();
            }
            catch (TaskCanceledException e)
            {
                AnalyticsSDK.AvatarUploadFailed(pM.blueprintId, !firstTimeCreation);
                if (cancellationToken.IsCancellationRequested)
                {
                    Core.Logger.LogError("Request cancelled", API.LOG_CATEGORY);
                    throw await HandleUploadError(new UploadException("Request Cancelled", e));
                }
            }
            catch (ApiErrorException e)
            {
                AnalyticsSDK.AvatarUploadFailed(pM.blueprintId, !firstTimeCreation);
                throw await HandleUploadError(new UploadException(e.ErrorMessage, e));
            }
            catch (Exception e)
            {
                AnalyticsSDK.AvatarUploadFailed(pM.blueprintId, !firstTimeCreation);
                throw await HandleUploadError(new UploadException(e.Message, e));
            }

            return true;
        }
        
        private async Task FinishUpload()
        {
            await Task.Delay(100);

            _uploadState = SdkUploadState.Idle;
            OnSdkUploadFinish?.Invoke(this, "Avatar upload finished");
            OnSdkUploadStateChange?.Invoke(this, _uploadState);
            VRC_EditorTools.GetSetPanelIdleMethod().Invoke(_builder, null);
            _avatarUploadCancellationToken = default;
            VRC_EditorTools.ToggleSdkTabsEnabled(_builder, true);
        }

        private async Task<Exception> HandleUploadError(Exception exception)
        {
            OnSdkUploadError?.Invoke(this, exception.Message);
            _uploadState = SdkUploadState.Failure;
            OnSdkUploadStateChange?.Invoke(this, _uploadState);

            await FinishUpload();
            return exception;
        }

        private async Task CheckCopyrightAgreement(PipelineManager pM, VRCAvatar avatar)
        {
            try
            {
                await VRCCopyrightAgreement.CheckCopyrightAgreement(pM, avatar);
            }
            catch (Exception e)
            {
                throw await HandleUploadError(e);
            }
        }

        private async Task VerifyUploadPermissions()
        {
            if (!(APIUser.CurrentUser?.canPublishAvatars ?? false))
            {
                VRCSdkControlPanel.ShowContentPublishPermissionsDialog();
                throw await HandleBuildError(new BuildBlockedException("Current User does not have permissions to build and upload avatars"));
            }
        }


        #region Build Callbacks
        
        private void SubscribePanelToBuildCallbacks(EventHandler<object> buildStart = null,
            EventHandler<string> buildError = null, EventHandler<string> buildSuccess = null,
            EventHandler uploadStart = null, EventHandler<(string, float)> uploadProgress = null,
            EventHandler<string> uploadError = null, EventHandler<string> uploadSuccess = null,
            EventHandler<string> uploadFinish = null)
        {
            OnSdkBuildStart += buildStart ?? BuildStart;
            OnSdkBuildError += buildError ?? BuildError;
            OnSdkBuildSuccess += buildSuccess ?? BuildStageSuccess;

            OnSdkUploadStart += uploadStart ?? UploadStart;
            OnSdkUploadProgress += uploadProgress ?? UploadProgress;
            OnSdkUploadError += uploadError ?? UploadError;
            OnSdkUploadSuccess += uploadSuccess ?? UploadSuccess;
            OnSdkUploadFinish += uploadFinish ?? UploadFinish;
        }

        private void UnsubscribePanelFromBuildCallbacks(EventHandler<object> buildStart = null,
            EventHandler<string> buildError = null, EventHandler<string> buildSuccess = null,
            EventHandler uploadStart = null, EventHandler<(string, float)> uploadProgress = null,
            EventHandler<string> uploadError = null, EventHandler<string> uploadSuccess = null,
            EventHandler<string> uploadFinish = null)
        {
            OnSdkBuildStart -= buildStart ?? BuildStart;
            OnSdkBuildError -= buildError ?? BuildError;
            OnSdkBuildSuccess -= buildSuccess ?? BuildStageSuccess;

            OnSdkUploadStart -= uploadStart ?? UploadStart;
            OnSdkUploadProgress -= uploadProgress ?? UploadProgress;
            OnSdkUploadError -= uploadError ?? UploadError;
            OnSdkUploadSuccess -= uploadSuccess ?? UploadSuccess;
            OnSdkUploadFinish -= uploadFinish ?? UploadFinish;
        }

        private void BuildStart(object sender, object target)
        {
            UiEnabled = false;
            _thumbnail.Loading = true;
            _thumbnail.ClearImage();
            
            _builderProgress.SetProgress(new BuilderProgress.ProgressBarStateData
            {
                Visible = true,
                Text = "Building Avatar",
                Progress = 0.0f
            });
        }
        private async void BuildError(object sender, string error)
        {
            Core.Logger.Log("Failed to build avatar!");
            Core.Logger.LogError(error);
            
            VRC_SdkBuilder.ActiveBuildType = VRC_SdkBuilder.BuildType.None;

            await Task.Delay(100);
            _builderProgress.HideProgress();
            UiEnabled = true;
            _thumbnail.Loading = false;
            RevertThumbnail();
            
            await _builder.ShowBuilderNotification(
                "Build Failed",
                new AvatarUploadErrorNotification(error),
                "red"
            );
        }
        
        private void MultiPlatformBuildError(object sender, string error)
        {
            if (Progress.Exists(VRCMultiPlatformBuild.MPBProgress))
            {
                Progress.Report(VRCMultiPlatformBuild.MPBProgress, 6, 6, $"{EditorUserBuildSettings.activeBuildTarget} bundle failed to build");
                Progress.Finish(VRCMultiPlatformBuild.MPBProgress, Progress.Status.Failed);
            }
            VRCMultiPlatformBuild.ClearMPBState();
            BuildError(sender, error);
        }
        
        private void BuildStageSuccess(object sender, string path)
        {
            VRC_SdkBuilder.ActiveBuildType = VRC_SdkBuilder.BuildType.None;
            _builderProgress.SetProgress(new BuilderProgress.ProgressBarStateData
            {
                Visible = true,
                Text = "Avatar Built",
                Progress = 0.1f
            });
        }

        private async void RevertThumbnail()
        {
            if (IsNewAvatar)
            {
                if (string.IsNullOrEmpty(_newThumbnailImagePath))
                {
                    _thumbnail.ClearImage();
                }
                else
                {
                    _thumbnail.SetImage(_newThumbnailImagePath);
                }
            }
            else
            {
                await _thumbnail.SetImageUrl(_avatarData.ThumbnailImageUrl, _avatarSwitchCancellationToken.Token);
            }
        }

        private void UploadStart(object sender, EventArgs e)
        {
            _thumbnail.Loading = true;
            _thumbnail.ClearImage();
            _builderProgress.SetCancelButtonVisibility(true);
            _builderProgress.OnCancel += (_, _) => CancelUpload();
            VRC_EditorTools.ToggleSdkTabsEnabled(_builder, false);
            _progressId = Progress.Start("Avatar Upload", "Uploading Avatar to VRChat", Progress.Options.Synchronous, VRCMultiPlatformBuild.MPBProgress);
        }

        private async void UploadProgress(object sender, (string status, float percentage) progress)
        {
            await UniTask.SwitchToMainThread();
            _builderProgress.SetProgress(new BuilderProgress.ProgressBarStateData
            {
                Visible = true,
                Text = progress.status,
                Progress = 0.2f + progress.percentage * 0.8f
            });
            _builderProgress.MarkDirtyRepaint();
            if (Progress.Exists(_progressId))
            {
                Progress.Report(_progressId, progress.percentage, progress.status);
            }
        }
        private async void UploadSuccess(object sender, string avatarId)
        {
            await Task.Delay(100);
            _builderProgress.SetCancelButtonVisibility(false);
            _builderProgress.HideProgress();
            UiEnabled = true;

            _originalAvatarData = _avatarData;
            _originalAvatarData.Tags = new List<string>(_avatarData.Tags ?? new List<string>());
            _newThumbnailImagePath = null;

            await _builder.ShowBuilderNotification(
                "Upload Succeeded!",
                new AvatarUploadSuccessNotification(avatarId),
                "green"
            );
            
            HandleAvatarSwitch(_visualRoot);
        }
        private async void UploadError(object sender, string error)
        {
            Core.Logger.Log("Failed to upload avatar!");
            Core.Logger.LogError(error);
            
            await Task.Delay(100);
            _builderProgress.SetCancelButtonVisibility(false);
            _builderProgress.HideProgress();
            UiEnabled = true;
            _thumbnail.Loading = false;
            RevertThumbnail();
            
            if (Progress.Exists(_platformProgressId))
            {
                Progress.Report(_platformProgressId, 2, 2, error);
                Progress.Finish(_platformProgressId, Progress.Status.Failed);
            }
            
            await _builder.ShowBuilderNotification(
                "Upload Failed",
                new AvatarUploadErrorNotification(error),
                "red"
            );
        }
        
        private async void InfoUpdateError(object sender, string error)
        {
            Core.Logger.Log("Failed to update avatar info!");
            Core.Logger.LogError(error);
            
            await Task.Delay(100);
            _builderProgress.SetCancelButtonVisibility(false);
            _builderProgress.HideProgress();
            UiEnabled = true;
            _thumbnail.Loading = false;
            RevertThumbnail();
            
            if (Progress.Exists(_platformProgressId))
            {
                Progress.Report(_platformProgressId, 2, 2, error);
                Progress.Finish(_platformProgressId, Progress.Status.Failed);
            }
            
            await _builder.ShowBuilderNotification(
                "Update Failed",
                new GenericBuilderNotification(error),
                "red"
            );
        }
        
        private void MultiPlatformUploadError(object sender, string error)
        {
            if (Progress.Exists(VRCMultiPlatformBuild.MPBProgress))
            {
                Progress.Report(VRCMultiPlatformBuild.MPBProgress, 6, 6, $"{EditorUserBuildSettings.activeBuildTarget} bundle failed to upload");
                Progress.Finish(VRCMultiPlatformBuild.MPBProgress, Progress.Status.Failed);
            }
            VRCMultiPlatformBuild.ClearMPBState();
            UploadError(sender, error);
        }

        private void UploadFinish(object sender, string message)
        {
            _builderProgress.OnCancel -= (_, _) => CancelUpload();
            if (Progress.Exists(_progressId))
            {
                Progress.Finish(_progressId);
                _progressId = 0;
            }
        }

        private async void ShowBuildSuccessNotification(bool testBuild = false)
        {
            await _builder.ShowBuilderNotification(
                "Build Succeeded!",
                new AvatarBuildSuccessNotification(testBuild),
                "green"
            );
        }

        #endregion

        #endregion

        #region Public API Backing

        private SdkBuildState _buildState;
        private SdkUploadState _uploadState;
        
        private static CancellationTokenSource _avatarUploadCancellationTokenSource;
        private CancellationToken _avatarUploadCancellationToken;

        #endregion

        #region Public API
        
        public event EventHandler<object> OnSdkBuildStart;
        public event EventHandler<string> OnSdkBuildProgress;
        public event EventHandler<string> OnSdkBuildFinish;
        public event EventHandler<string> OnSdkBuildSuccess;
        public event EventHandler<string> OnSdkBuildError;
        public event EventHandler<SdkBuildState> OnSdkBuildStateChange;
        public SdkBuildState BuildState => _buildState;
        
        public event EventHandler OnSdkUploadStart;
        public event EventHandler<(string status, float percentage)> OnSdkUploadProgress;
        public event EventHandler<string> OnSdkUploadFinish;
        public event EventHandler<string> OnSdkUploadSuccess;
        public event EventHandler<string> OnSdkUploadError;
        public event EventHandler<SdkUploadState> OnSdkUploadStateChange;
        public SdkUploadState UploadState => _uploadState;

        public GameObject SelectedAvatar => _avatarSelector?.SelectedAvatar?.gameObject;
        public void SelectAvatar(GameObject avatar)
        {
            if (!avatar.TryGetComponent<VRC_AvatarDescriptor>(out var descriptor)) return;
            SelectAvatar(descriptor);
        }

        public event EventHandler<object> ContentInfoLoaded;

        public async Task<string> Build(GameObject target)
        {
            return await Build(target, false, null);
        }
        
        public async Task<string> Build(GameObject target, List<PerPlatformOverrides.Option> overrides)
        {
            return await Build(target, false, overrides);
        }

        public async Task BuildAndUpload(GameObject target, VRCAvatar avatar, string thumbnailPath = null, CancellationToken cancellationToken = default)
        {
            await BuildAndUpload(target, null, avatar, thumbnailPath, cancellationToken);
        }
        
        public async Task BuildAndUpload(GameObject target, List<PerPlatformOverrides.Option>  overrides, VRCAvatar avatar, string thumbnailPath = null, CancellationToken cancellationToken = default)
        {
            if (VRC_EditorTools.DryRunState)
            {
                return;
            }
            if (cancellationToken == default)
            {
                _avatarUploadCancellationTokenSource = new CancellationTokenSource();
                _avatarUploadCancellationToken = _avatarUploadCancellationTokenSource.Token;
            }
            else
            {
                _avatarUploadCancellationToken = cancellationToken;
            }

            // Verify upload permissions before attempting to build
            await VerifyUploadPermissions();
            
            if (!target.TryGetComponent<PipelineManager>(out var pM))
            {
                throw await HandleUploadError(new UploadException("Target avatar does not have a PipelineManager, make sure a PipelineManager component is present before uploading"));
            }
            
            // If blueprint is not set we need to create a record in the database (or use an existing one if possible)
            bool firstTimeCreation;
            (avatar, firstTimeCreation) = await ReserveAvatarId(avatar, cancellationToken, pM);

            string bundlePath;
            try
            {
                // Front-run the Copyright Agreement to avoid blocking the upload
                await CheckCopyrightAgreement(pM, avatar);
                
                VRC_SdkBuilder.ActiveBuildType = VRC_SdkBuilder.BuildType.Publish;
                bundlePath = await Build(target, false, overrides);
            }
            catch (Exception)
            {
                if (!firstTimeCreation) throw;
                
                // Clean up the avatar record we created to get an ID
                await VRCApi.DeleteAvatar(pM.blueprintId);
                Undo.RecordObject(pM, "Clearing id after a failed build");
                pM.blueprintId = "";
                throw;
            }
            await Upload(target, avatar, firstTimeCreation, bundlePath, thumbnailPath, cancellationToken);
        }

        private async Task<(VRCAvatar avatar, bool firstTimeCreation)> ReserveAvatarId(VRCAvatar avatar, CancellationToken cancellationToken, PipelineManager pM)
        {
            var firstTimeCreation = string.IsNullOrWhiteSpace(pM.blueprintId);

            if (firstTimeCreation)
            {
                avatar = await VRCApi.CreateAvatarRecord(avatar, (status, percentage) => { OnSdkUploadProgress?.Invoke(this, (status, percentage)); }, cancellationToken);
                if (string.IsNullOrEmpty(avatar.ID))
                {
                    throw await HandleBuildError(new BuilderException("Failed to reserve an avatar ID"));
                }
                Undo.RecordObject(pM, "Assigning a new ID");
                pM.blueprintId = avatar.ID;
            } else if (string.IsNullOrWhiteSpace(avatar.ID))
            {
                Core.Logger.Log("Avatar ID is empty, while blueprint ID is not, this is not supported, please make sure that avatar.ID is populated");
                // fallback for legacy tools
                avatar.ID = pM.blueprintId;
            }

            return (avatar, firstTimeCreation);
        }

        private int _platformProgressId = -1;

        public async Task BuildAndUploadMultiPlatform(GameObject target, VRCAvatar avatar, string thumbnailPath = null,
            CancellationToken cancellationToken = default)
        {
            await BuildAndUploadMultiPlatform(target, null, avatar, thumbnailPath, cancellationToken);
        }
        
        public async Task BuildAndUploadMultiPlatform(GameObject target, List<PerPlatformOverrides.Option> overrides, VRCAvatar avatar, string thumbnailPath = null,
            CancellationToken cancellationToken = default)
        {
            UiEnabled = false;
            // Give the UI a moment to update
            await Task.Delay(200, cancellationToken);

            if (string.IsNullOrWhiteSpace(VRCMultiPlatformBuild.MPBContentIdentifier))
            {
                VRCMultiPlatformBuild.MPBContentIdentifier = GetAvatarSceneIdentifier(target);
            }

            var currentTarget = VRC_EditorTools.GetCurrentBuildTargetEnum();

            // If target platform includes windows - build it first
            // This is needed for non-destructive tools that rely on PC builds to correctly align synced avatar parameters between platforms
            var optimizedTargetOrder = false;
            if (!VRCMultiPlatformBuild.MPB && _selectedBuildTargets.Contains(BuildTarget.StandaloneWindows64) &&
                currentTarget != BuildTarget.StandaloneWindows64)
            {
                optimizedTargetOrder = true;
                _selectedBuildTargets.Remove(BuildTarget.StandaloneWindows64);
                _selectedBuildTargets.Insert(0, BuildTarget.StandaloneWindows64);
                // If we also want to build for the current target - ensure its last in the list
                if (_selectedBuildTargets.Contains(currentTarget))
                {
                    _selectedBuildTargets.Remove(currentTarget);
                    _selectedBuildTargets.Add(currentTarget);
                }
            }

            _platformProgressId = VRCMultiPlatformBuild.StartMPB(_selectedBuildTargets);
            
            // If one of the targets is android - we must set the default texture format to ASTC
            // Doing it prior to building will also avoid the double-import issue
            if (_selectedBuildTargets.Contains(BuildTarget.Android) &&
                EditorUserBuildSettings.androidBuildSubtarget != MobileTextureSubtarget.ASTC)
            {
                EditorUserBuildSettings.androidBuildSubtarget = MobileTextureSubtarget.ASTC;
                AssetDatabase.Refresh();
            }

            // If we are not on the first platform - switch to it
            if (!_selectedBuildTargets.Contains(currentTarget) || optimizedTargetOrder)
            {
                await VRCMultiPlatformBuild.SetUpNextMPBTarget(cancellationToken, incrementBuildCount: false);
                return;
            }
            
            // Verify upload permissions before attempting to build
            await VerifyUploadPermissions();

            if (!target.TryGetComponent<PipelineManager>(out var pM))
            {
                throw await HandleUploadError(new UploadException("Target avatar does not have a PipelineManager, make sure a PipelineManager component is present before uploading"));
            }

            // If blueprint is not set we need to create a record in the database (or use an existing one if possible)
            bool firstTimeCreation;
            (avatar, firstTimeCreation) = await ReserveAvatarId(avatar, cancellationToken, pM);
            
            if (string.IsNullOrWhiteSpace(avatar.ID))
            {
                Core.Logger.Log("Avatar ID is empty, while blueprint ID is not, this is not supported, please make sure that avatar.ID is populated");
                // fallback for legacy tools
                avatar.ID = pM.blueprintId;
            }
            
            SetupAvatarStylesForUpload(ref avatar);

            string bundlePath;
            try
            {
                // Front-run the Copyright Agreement to avoid blocking the upload
                await CheckCopyrightAgreement(pM, avatar);

                bundlePath = await Build(target, false, overrides);
            }
            catch (Exception)
            {
                if (!firstTimeCreation) throw;
                
                // Clean up the avatar record we created to get an ID
                await VRCApi.DeleteAvatar(pM.blueprintId);
                Undo.RecordObject(pM, "Clearing id after a failed build");
                pM.blueprintId = "";
                throw;
            }

            VRCMultiPlatformBuild.ReportMPBUploadStart(_platformProgressId);

            if (await Upload(target, avatar, firstTimeCreation, bundlePath, thumbnailPath, cancellationToken))
            {
                VRCMultiPlatformBuild.ReportMPBUploadFinish(_platformProgressId);
            }
            else
            {
                VRCMultiPlatformBuild.ReportMPBUploadSkipped(_platformProgressId);
            }


            _platformProgressId = -1;

            // Set up next target
            var willSwitchTarget = await VRCMultiPlatformBuild.SetUpNextMPBTarget(cancellationToken);
            if (willSwitchTarget) return;

            // If we are done, but still in a success MPB state - clean up and show success notification
            if (VRCMultiPlatformBuild.MPB)
            {
                VRCMultiPlatformBuild.ReportMPBDone();
                var avatarId = _selectedAvatar?.GetComponent<PipelineManager>()?.blueprintId ?? "";
                await _builder.ShowBuilderNotification(
                    "Multi-Platform Upload Finished",
                    new AvatarUploadSuccessNotification(avatarId),
                    "green"
                );
            }
        }
     
        public async Task BuildAndTest(GameObject target)
        {
            VRC_SdkBuilder.ActiveBuildType = VRC_SdkBuilder.BuildType.Test;
            await Build(target, true, null);
        }

        public void CancelUpload()
        {
            VRC_EditorTools.GetSetPanelIdleMethod().Invoke(_builder, null);
            if (_avatarUploadCancellationToken != default)
            {
                _avatarUploadCancellationTokenSource?.Cancel();
                Core.Logger.Log("Avatar upload canceled");
                return;
            }
            
            Core.Logger.LogError("Custom cancellation token passed, you should cancel via its token source instead");
        }
        
        #endregion
        
        #region Validation Helpers

        private static Object[] CreateObjectArray<T>(IList<T> elements) where T : Component
        {
            Object[] objects = new Object[elements.Count];
            for (int i = 0; i < elements.Count; i++)
            {
                objects[i] = elements[i].gameObject;
            }
            return objects;
        }

        private async Task CheckAvatarForValidationIssues(VRC_AvatarDescriptor targetDescriptor)
        {
            _builder.CheckedForIssues = false;
            _builder.ResetIssues();
            VRC_EditorTools.GetCheckProjectSetupMethod().Invoke(_builder, new object[] {});
            OnGUIAvatarCheck(targetDescriptor);
            _builder.CheckedForIssues = true;
            if (!_builder.NoGuiErrorsOrIssuesForItem(targetDescriptor) || !_builder.NoGuiErrorsOrIssuesForItem(_builder))
            {
                var errorsList = new List<string>();
                errorsList.AddRange(_builder.GetGuiErrorsOrIssuesForItem(targetDescriptor).Select(i => i.issueText));
                errorsList.AddRange(_builder.GetGuiErrorsOrIssuesForItem(_builder).Select(i => i.issueText));
                throw await HandleBuildError(new ValidationException("Avatar validation failed", errorsList));
            }
        }

        
        private static Action GetAvatarSubSelectAction(Component avatar, Type[] types)
        {
            return () =>
            {
                List<Object> gos = new List<Object>();
                foreach (Type t in types)
                {
                    List<Component> components = avatar.gameObject.GetComponentsInChildrenExcludingEditorOnly(t, true);
                    foreach (Component c in components)
                        gos.Add(c.gameObject);
                }

                Selection.objects = gos.Count > 0 ? gos.ToArray() : new Object[] {avatar.gameObject};
            };
        }

        private static Action GetAvatarSubSelectAction<T>(Component avatar, Predicate<T> condition = null) where T : Component
        {
            return () =>
            {
                List<Object> gos = new List<Object>();

                List<T> components = avatar.gameObject.GetComponentsInChildrenExcludingEditorOnly<T>(true);
                foreach (T c in components)
                {
                    if (condition == null || condition(c))
                    {
                        gos.Add(c.gameObject);
                    }
                }

                Selection.objects = gos.Count > 0 ? gos.ToArray() : new Object[] {avatar.gameObject};
            };
        }

        private static Action GetAvatarAudioSourcesWithDecompressOnLoadWithoutBackgroundLoad(Component avatar)
        {
            return () =>
            {
                List<Object> gos = new List<Object>();
                AudioSource[] audioSources = avatar.GetComponentsInChildren<AudioSource>(true);

                foreach (var audioSource in audioSources)
                {
                    if (audioSource.clip && audioSource.clip.loadType == AudioClipLoadType.DecompressOnLoad && !audioSource.clip.loadInBackground)
                    {
                        gos.Add(audioSource.gameObject);
                    }
                }

                Selection.objects = gos.Count > 0 ? gos.ToArray() : new Object[] { avatar.gameObject };
            };
        }

        private void VerifyAvatarMipMapStreaming(Component avatar)
        {
            List<TextureImporter> badTextureImporters = new List<TextureImporter>();
            List<Object> badTextures = new List<Object>();
            foreach (Renderer r in avatar.gameObject.GetComponentsInChildrenExcludingEditorOnly<Renderer>(true))
            {
                foreach (Material m in r.sharedMaterials)
                {
                    if (!m)
                        continue;
                    int[] texIDs = m.GetTexturePropertyNameIDs();
                    if (texIDs == null)
                        continue;
                    foreach (int i in texIDs)
                    {
                        Texture t = m.GetTexture(i);
                        if (!t)
                            continue;
                        string path = AssetDatabase.GetAssetPath(t);
                        if (string.IsNullOrEmpty(path))
                            continue;
                        TextureImporter importer = AssetImporter.GetAtPath(path) as TextureImporter;
                        if (importer != null && importer.mipmapEnabled && !importer.streamingMipmaps)
                        {
                            badTextureImporters.Add(importer);
                            badTextures.Add(t);
                        }
                    }
                }
            }

            if (badTextureImporters.Count == 0)
                return;

            _builder.OnGUIError(avatar, "This avatar has mipmapped textures without 'Streaming Mip Maps' enabled.",
                () => { Selection.objects = badTextures.ToArray(); },
                () =>
                {
                    List<string> paths = new List<string>();
                    foreach (TextureImporter t in badTextureImporters)
                    {
                        Undo.RecordObject(t, "Set Mip Map Streaming");
                        t.streamingMipmaps = true;
                        t.streamingMipmapsPriority = 0;
                        EditorUtility.SetDirty(t);
                        paths.Add(t.assetPath);
                    }

                    AssetDatabase.ForceReserializeAssets(paths);
                    AssetDatabase.Refresh();
                });
        }
        
        private void VerifyMaxTextureSize(Component avatar)
        {
            var renderers = avatar.gameObject.GetComponentsInChildrenExcludingEditorOnly<Renderer>(true);
            List<TextureImporter> badTextureImporters = VRCSdkControlPanel.GetOversizeTextureImporters(renderers);

            if (badTextureImporters.Count == 0)
                return;

            _builder.OnGUIError(avatar, $"This avatar has textures bigger than {VRCSdkControlPanel.MAX_SDK_TEXTURE_SIZE}. Please reduce them to save memory for users.",
                null,
                () =>
                {
                    List<string> paths = new List<string>();
                    foreach (TextureImporter t in badTextureImporters)
                    {
                        Undo.RecordObject(t, $"Set Max Texture Size to {VRCSdkControlPanel.MAX_SDK_TEXTURE_SIZE}");
                        t.maxTextureSize = VRCSdkControlPanel.MAX_SDK_TEXTURE_SIZE;
                        EditorUtility.SetDirty(t);
                        paths.Add(t.assetPath);
                    }

                    AssetDatabase.ForceReserializeAssets(paths);
                    AssetDatabase.Refresh();
                });
        }

        private void VerifyTextureMipFiltering(Component avatar)
        {
            var renderers = avatar.gameObject.GetComponentsInChildrenExcludingEditorOnly<Renderer>(true);
            List<TextureImporter> badTextureImporters = VRCSdkControlPanel.GetBoxFilteredTextureImporters(renderers);
            if (badTextureImporters.Count == 0)
                return;

            _builder.OnGUIInformation(avatar, $"This avatar uses textures with 'Box' mipmap filtering, which blurs distant textures. Switch to 'Kaiser' for improved sharpness{(VRCPackageSettings.Instance.dpidMipmaps ? " (this will be overriden with the newer 'DPID' algorithm, this can be disabled in the settings)": "")}.",
                null,
                () =>
                {
                    List<string> paths = new List<string>();
                    foreach (TextureImporter t in badTextureImporters)
                    {
                        Undo.RecordObject(t, $"Set texture filtering to 'Kaiser'");
                        t.mipmapFilter = TextureImporterMipFilter.KaiserFilter;
                        EditorUtility.SetDirty(t);
                        paths.Add(t.assetPath);
                    }

                    AssetDatabase.ForceReserializeAssets(paths);
                    AssetDatabase.Refresh();
                });
        }

        private bool AnalyzeIK(Object ad, Animator anim)
        {
            bool hasHead;
            bool hasFeet;
            bool hasHands;
#if VRC_SDK_VRCSDK2
            bool hasThreeFingers;
#endif
            bool correctSpineHierarchy;
            bool correctLeftArmHierarchy;
            bool correctRightArmHierarchy;
            bool correctLeftLegHierarchy;
            bool correctRightLegHierarchy;

            bool status = true;

            Transform head = anim.GetBoneTransform(HumanBodyBones.Head);
            Transform lFoot = anim.GetBoneTransform(HumanBodyBones.LeftFoot);
            Transform rFoot = anim.GetBoneTransform(HumanBodyBones.RightFoot);
            Transform lHand = anim.GetBoneTransform(HumanBodyBones.LeftHand);
            Transform rHand = anim.GetBoneTransform(HumanBodyBones.RightHand);

            hasHead = null != head;
            hasFeet = (null != lFoot && null != rFoot);
            hasHands = (null != lHand && null != rHand);

            if (!hasHead || !hasFeet || !hasHands)
            {
                _builder.OnGUIError(ad, "Humanoid avatar must have head, hands and feet bones mapped.",
                    delegate { Selection.activeObject = anim.gameObject; }, null);
                return false;
            }

            Transform lThumb = anim.GetBoneTransform(HumanBodyBones.LeftThumbProximal);
            Transform lIndex = anim.GetBoneTransform(HumanBodyBones.LeftIndexProximal);
            Transform lMiddle = anim.GetBoneTransform(HumanBodyBones.LeftMiddleProximal);
            Transform rThumb = anim.GetBoneTransform(HumanBodyBones.RightThumbProximal);
            Transform rIndex = anim.GetBoneTransform(HumanBodyBones.RightIndexProximal);
            Transform rMiddle = anim.GetBoneTransform(HumanBodyBones.RightMiddleProximal);

            Transform pelvis = anim.GetBoneTransform(HumanBodyBones.Hips);
            Transform chest = anim.GetBoneTransform(HumanBodyBones.Chest);
            Transform upperChest = anim.GetBoneTransform(HumanBodyBones.UpperChest);
            Transform torso = anim.GetBoneTransform(HumanBodyBones.Spine);

            Transform neck = anim.GetBoneTransform(HumanBodyBones.Neck);
            Transform lClav = anim.GetBoneTransform(HumanBodyBones.LeftShoulder);
            Transform rClav = anim.GetBoneTransform(HumanBodyBones.RightShoulder);


            if (null == neck || null == lClav || null == rClav || null == pelvis || null == torso || null == chest)
            {
                string missingElements =
                    ((null == neck) ? "Neck, " : "") +
                    (((null == lClav) || (null == rClav)) ? "Shoulders, " : "") +
                    ((null == pelvis) ? "Pelvis, " : "") +
                    ((null == torso) ? "Spine, " : "") +
                    ((null == chest) ? "Chest, " : "");
                missingElements = missingElements.Remove(missingElements.LastIndexOf(',')) + ".";
                _builder.OnGUIError(ad, "Spine hierarchy missing elements, please map: " + missingElements,
                    delegate { Selection.activeObject = anim.gameObject; }, null);
                return false;
            }

            if (null != upperChest)
                correctSpineHierarchy =
                    lClav.parent == upperChest && rClav.parent == upperChest && neck.parent == upperChest;
            else
                correctSpineHierarchy = lClav.parent == chest && rClav.parent == chest && neck.parent == chest;

            if (!correctSpineHierarchy)
            {
                _builder.OnGUIError(ad,
                    "Spine hierarchy incorrect. Make sure that the parent of both Shoulders and the Neck is the Chest (or UpperChest if set).",
                    delegate
                    {
                        List<Object> gos = new List<Object>
                        {
                            lClav.gameObject,
                            rClav.gameObject,
                            neck.gameObject,
                            null != upperChest ? upperChest.gameObject : chest.gameObject
                        };
                        Selection.objects = gos.ToArray();
                    }, null);
                return false;
            }

            Transform lShoulder = anim.GetBoneTransform(HumanBodyBones.LeftUpperArm);
            Transform lElbow = anim.GetBoneTransform(HumanBodyBones.LeftLowerArm);
            Transform rShoulder = anim.GetBoneTransform(HumanBodyBones.RightUpperArm);
            Transform rElbow = anim.GetBoneTransform(HumanBodyBones.RightLowerArm);

            correctLeftArmHierarchy = lShoulder && lElbow && lShoulder.GetChild(0) == lElbow && lHand &&
                                      lElbow.GetChild(0) == lHand;
            correctRightArmHierarchy = rShoulder && rElbow && rShoulder.GetChild(0) == rElbow && rHand &&
                                       rElbow.GetChild(0) == rHand;

            if (!(correctLeftArmHierarchy && correctRightArmHierarchy))
            {
                _builder.OnGUIWarning(ad,
                    "LowerArm is not first child of UpperArm or Hand is not first child of LowerArm: you may have problems with Forearm rotations.",
                    delegate
                    {
                        List<Object> gos = new List<Object>();
                        if (!correctLeftArmHierarchy && lShoulder)
                            gos.Add(lShoulder.gameObject);
                        if (!correctRightArmHierarchy && rShoulder)
                            gos.Add(rShoulder.gameObject);
                        if (gos.Count > 0)
                            Selection.objects = gos.ToArray();
                        else
                            Selection.activeObject = anim.gameObject;
                    }, null);
                status = false;
            }

            Transform lHip = anim.GetBoneTransform(HumanBodyBones.LeftUpperLeg);
            Transform lKnee = anim.GetBoneTransform(HumanBodyBones.LeftLowerLeg);
            Transform rHip = anim.GetBoneTransform(HumanBodyBones.RightUpperLeg);
            Transform rKnee = anim.GetBoneTransform(HumanBodyBones.RightLowerLeg);

            correctLeftLegHierarchy = lHip && lKnee && lHip.GetChild(0) == lKnee && lKnee.GetChild(0) == lFoot;
            correctRightLegHierarchy = rHip && rKnee && rHip.GetChild(0) == rKnee && rKnee.GetChild(0) == rFoot;

            if (!(correctLeftLegHierarchy && correctRightLegHierarchy))
            {
                _builder.OnGUIWarning(ad,
                    "LowerLeg is not first child of UpperLeg or Foot is not first child of LowerLeg: you may have problems with Shin rotations.",
                    delegate
                    {
                        List<Object> gos = new List<Object>();
                        if (!correctLeftLegHierarchy && lHip)
                            gos.Add(lHip.gameObject);
                        if (!correctRightLegHierarchy && rHip)
                            gos.Add(rHip.gameObject);
                        if (gos.Count > 0)
                            Selection.objects = gos.ToArray();
                        else
                            Selection.activeObject = anim.gameObject;
                    }, null);
                status = false;
            }

            if (!(IsAncestor(pelvis, rFoot) && IsAncestor(pelvis, lFoot) && IsAncestor(pelvis, lHand) &&
                  IsAncestor(pelvis, rHand)))
            {
                _builder.OnGUIWarning(ad,
                    "This avatar has a split hierarchy (Hips bone is not the ancestor of all humanoid bones). IK may not work correctly.",
                    delegate
                    {
                        List<Object> gos = new List<Object> {pelvis.gameObject};
                        if (!IsAncestor(pelvis, rFoot))
                            gos.Add(rFoot.gameObject);
                        if (!IsAncestor(pelvis, lFoot))
                            gos.Add(lFoot.gameObject);
                        if (!IsAncestor(pelvis, lHand))
                            gos.Add(lHand.gameObject);
                        if (!IsAncestor(pelvis, rHand))
                            gos.Add(rHand.gameObject);
                        Selection.objects = gos.ToArray();
                    }, null);
                status = false;
            }

            // if thigh bone rotations diverge from 180 from hip bone rotations, full-body tracking/ik does not work well
            if (!lHip || !rHip) return status;
            {
                Vector3 hipLocalUp = pelvis.InverseTransformVector(Vector3.up);
                Vector3 legLDir = lHip.TransformVector(hipLocalUp);
                Vector3 legRDir = rHip.TransformVector(hipLocalUp);
                float angL = Vector3.Angle(Vector3.up, legLDir);
                float angR = Vector3.Angle(Vector3.up, legRDir);
                if (!(angL < 175f) && !(angR < 175f)) return status;
                string angle = $"{Mathf.Min(angL, angR):F1}";
                _builder.OnGUIWarning(ad,
                    $"The angle between pelvis and thigh bones should be close to 180 degrees (this avatar's angle is {angle}). Your avatar may not work well with full-body IK and Tracking.",
                    delegate
                    {
                        List<Object> gos = new List<Object>();
                        if (angL < 175f)
                            gos.Add(rFoot.gameObject);
                        if (angR < 175f)
                            gos.Add(lFoot.gameObject);
                        Selection.objects = gos.ToArray();
                    }, null);
                status = false;
            }

            return status;
        }

        private static bool IsAncestor(Object ancestor, Transform child)
        {
            bool found = false;
            Transform thisParent = child.parent;
            while (thisParent != null)
            {
                if (thisParent == ancestor)
                {
                    found = true;
                    break;
                }

                thisParent = thisParent.parent;
            }

            return found;
        }

        private void CheckAvatarMeshesForLegacyBlendShapesSetting(Component avatar)
        {
            if (LegacyBlendShapeNormalsPropertyInfo == null)
            {
                Debug.LogError(
                    "Could not check for legacy blend shape normals because 'legacyComputeAllNormalsFromSmoothingGroupsWhenMeshHasBlendShapes' was not found.");
                return;
            }

            // Get all of the meshes used by skinned mesh renderers.
            HashSet<Mesh> avatarMeshes = GetAllMeshesInGameObjectHierarchy(avatar.gameObject);
            HashSet<Mesh> incorrectlyConfiguredMeshes =
                ScanMeshesForIncorrectBlendShapeNormalsSetting(avatarMeshes);
            if (incorrectlyConfiguredMeshes.Count > 0)
            {
                _builder.OnGUIError(
                    avatar,
                    "This avatar contains skinned meshes that were imported with Blendshape Normals set to 'Calculate' but aren't using 'Legacy Blendshape Normals'. This will significantly increase the size of the uploaded avatar. This must be fixed in the mesh import settings before uploading.",
                    null,
                    () => { EnableLegacyBlendShapeNormals(incorrectlyConfiguredMeshes); });
            }
        }

        private static HashSet<Mesh> ScanMeshesForIncorrectBlendShapeNormalsSetting(IEnumerable<Mesh> avatarMeshes)
        {
            HashSet<Mesh> incorrectlyConfiguredMeshes = new HashSet<Mesh>();
            foreach (Mesh avatarMesh in avatarMeshes)
            {
                // Can't get ModelImporter if the model isn't an asset.
                if (!AssetDatabase.Contains(avatarMesh))
                {
                    continue;
                }

                string meshAssetPath = AssetDatabase.GetAssetPath(avatarMesh);
                if (string.IsNullOrEmpty(meshAssetPath))
                {
                    continue;
                }

                ModelImporter avatarImporter = AssetImporter.GetAtPath(meshAssetPath) as ModelImporter;
                if (avatarImporter == null)
                {
                    continue;
                }

                if (avatarImporter.importBlendShapeNormals != ModelImporterNormals.Calculate)
                {
                    continue;
                }

                bool useLegacyBlendShapeNormals = (bool) LegacyBlendShapeNormalsPropertyInfo.GetValue(avatarImporter);
                if (useLegacyBlendShapeNormals)
                {
                    continue;
                }

                incorrectlyConfiguredMeshes.Add(avatarMesh);
            }

            return incorrectlyConfiguredMeshes;
        }

        private static void EnableLegacyBlendShapeNormals(IEnumerable<Mesh> meshesToFix)
        {
            HashSet<string> meshAssetPaths = new HashSet<string>();
            foreach (Mesh meshToFix in meshesToFix)
            {
                // Can't get ModelImporter if the model isn't an asset.
                if (!AssetDatabase.Contains(meshToFix))
                {
                    continue;
                }

                string meshAssetPath = AssetDatabase.GetAssetPath(meshToFix);
                if (string.IsNullOrEmpty(meshAssetPath))
                {
                    continue;
                }

                if (meshAssetPaths.Contains(meshAssetPath))
                {
                    continue;
                }

                meshAssetPaths.Add(meshAssetPath);
            }

            foreach (string meshAssetPath in meshAssetPaths)
            {
                ModelImporter avatarImporter = AssetImporter.GetAtPath(meshAssetPath) as ModelImporter;
                if (avatarImporter == null)
                {
                    continue;
                }

                if (avatarImporter.importBlendShapeNormals != ModelImporterNormals.Calculate)
                {
                    continue;
                }

                LegacyBlendShapeNormalsPropertyInfo.SetValue(avatarImporter, true);
                avatarImporter.SaveAndReimport();
            }
        }

        private void CheckAvatarMeshesForMeshReadWriteSetting(Component avatar)
        {
            // Get all of the meshes used by skinned mesh renderers.
            HashSet<Mesh> avatarMeshes = GetAllMeshesInGameObjectHierarchy(avatar.gameObject);
            HashSet<Mesh> incorrectlyConfiguredMeshes =
                ScanMeshesForDisabledMeshReadWriteSetting(avatarMeshes);
            if (incorrectlyConfiguredMeshes.Count > 0)
            {
                _builder.OnGUIError(
                    avatar,
                    "This avatar contains meshes that were imported with Read/Write disabled. This must be fixed in the mesh import settings before uploading.",
                    null,
                    () => { EnableMeshReadWrite(incorrectlyConfiguredMeshes); });
            }
        }

        private static HashSet<Mesh> ScanMeshesForDisabledMeshReadWriteSetting(IEnumerable<Mesh> avatarMeshes)
        {
            HashSet<Mesh> incorrectlyConfiguredMeshes = new HashSet<Mesh>();
            foreach (Mesh avatarMesh in avatarMeshes)
            {
                // Can't get ModelImporter if the model isn't an asset.
                if (!AssetDatabase.Contains(avatarMesh))
                {
                    continue;
                }

                string meshAssetPath = AssetDatabase.GetAssetPath(avatarMesh);
                if (string.IsNullOrEmpty(meshAssetPath))
                {
                    continue;
                }

                ModelImporter avatarImporter = AssetImporter.GetAtPath(meshAssetPath) as ModelImporter;
                if (avatarImporter == null)
                {
                    continue;
                }

                if (avatarImporter.isReadable)
                {
                    continue;
                }

                incorrectlyConfiguredMeshes.Add(avatarMesh);
            }

            return incorrectlyConfiguredMeshes;
        }

        private static void EnableMeshReadWrite(IEnumerable<Mesh> meshesToFix)
        {
            HashSet<string> meshAssetPaths = new HashSet<string>();
            foreach (Mesh meshToFix in meshesToFix)
            {
                // Can't get ModelImporter if the model isn't an asset.
                if (!AssetDatabase.Contains(meshToFix))
                {
                    continue;
                }

                string meshAssetPath = AssetDatabase.GetAssetPath(meshToFix);
                if (string.IsNullOrEmpty(meshAssetPath))
                {
                    continue;
                }

                if (meshAssetPaths.Contains(meshAssetPath))
                {
                    continue;
                }

                meshAssetPaths.Add(meshAssetPath);
            }

            foreach (string meshAssetPath in meshAssetPaths)
            {
                ModelImporter avatarImporter = AssetImporter.GetAtPath(meshAssetPath) as ModelImporter;
                if (avatarImporter == null)
                {
                    continue;
                }

                if (avatarImporter.isReadable)
                {
                    continue;
                }

                avatarImporter.isReadable = true;
                avatarImporter.SaveAndReimport();
            }
        }

        private static HashSet<Mesh> GetAllMeshesInGameObjectHierarchy(GameObject avatar)
        {
            HashSet<Mesh> avatarMeshes = new HashSet<Mesh>();
            foreach (SkinnedMeshRenderer avatarSkinnedMeshRenderer in avatar
                .GetComponentsInChildrenExcludingEditorOnly<SkinnedMeshRenderer>(true))
            {
                if (avatarSkinnedMeshRenderer == null)
                {
                    continue;
                }

                Mesh skinnedMesh = avatarSkinnedMeshRenderer.sharedMesh;
                if (skinnedMesh == null)
                {
                    continue;
                }

                if (avatarMeshes.Contains(skinnedMesh))
                {
                    continue;
                }

                avatarMeshes.Add(skinnedMesh);
            }

            foreach (MeshFilter avatarMeshFilter in avatar.GetComponentsInChildrenExcludingEditorOnly<MeshFilter>(true))
            {
                if (avatarMeshFilter == null)
                {
                    continue;
                }

                Mesh skinnedMesh = avatarMeshFilter.sharedMesh;
                if (skinnedMesh == null)
                {
                    continue;
                }

                if (avatarMeshes.Contains(skinnedMesh))
                {
                    continue;
                }

                avatarMeshes.Add(skinnedMesh);
            }

            foreach (ParticleSystemRenderer avatarParticleSystemRenderer in avatar
                .GetComponentsInChildrenExcludingEditorOnly<ParticleSystemRenderer>(true))
            {
                if (avatarParticleSystemRenderer == null)
                {
                    continue;
                }

                Mesh[] avatarParticleSystemRendererMeshes = new Mesh[avatarParticleSystemRenderer.meshCount];
                avatarParticleSystemRenderer.GetMeshes(avatarParticleSystemRendererMeshes);
                foreach (Mesh avatarParticleSystemRendererMesh in avatarParticleSystemRendererMeshes)
                {
                    if (avatarParticleSystemRendererMesh == null)
                    {
                        continue;
                    }

                    if (avatarMeshes.Contains(avatarParticleSystemRendererMesh))
                    {
                        continue;
                    }

                    avatarMeshes.Add(avatarParticleSystemRendererMesh);
                }
            }

            return avatarMeshes;
        }

        private void OpenAnimatorControllerWindow(object animatorController)
        {
            Assembly asm = Assembly.Load("UnityEditor.Graphs");
            Module editorGraphModule = asm.GetModule("UnityEditor.Graphs.dll");
            Type animatorWindowType = editorGraphModule.GetType("UnityEditor.Graphs.AnimatorControllerTool");
            EditorWindow animatorWindow = EditorWindow.GetWindow(animatorWindowType, false, "Animator", false);
            PropertyInfo propInfo = animatorWindowType.GetProperty("animatorController");
            if (propInfo != null) propInfo.SetValue(animatorWindow, animatorController, null);
        }

        private static void ShowRestrictedComponents(IEnumerable<Component> componentsToRemove)
        {
            List<Object> gos = new List<Object>();
            foreach (Component c in componentsToRemove)
                gos.Add(c.gameObject);
            Selection.objects = gos.ToArray();
        }

        private static void FixRestrictedComponents(IEnumerable<Component> componentsToRemove)
        {
            if (!(componentsToRemove is List<Component> list)) return;
            for (int v = list.Count - 1; v > -1; v--)
            {
                Undo.DestroyObjectImmediate(list[v]);
            }
        }

        private static void SetLayerMaskFromControllerInternal(SerializedProperty layer)
        {
            var method = typeof(AvatarDescriptorEditor3).GetMethod("SetLayerMaskFromController",
                BindingFlags.Static | BindingFlags.NonPublic);
            method?.Invoke(null, new object[] { layer });
            layer.serializedObject.ApplyModifiedProperties();
        }

        private enum WriteDefaultsScanResult
        {
            NoStates,
            AllEnabled,
            AllDisabled,
            Mixture,
        }

        /// <summary>
        /// Scan for a mixture of Write Defaults settings on the animators of this avatar, with exceptions for additive
        /// layers and blend trees set to direct blending.
        ///
        /// Attempts to warn of this issue: https://vrcfury.com/technical/wd/#mixed-write-defaults
        /// </summary>
        /// <param name="avatarSDK3">The avatar.</param>
        /// <returns>True if we find a mixture of WD states on this avatar or false if we do not.</returns>
        private static bool ScanAvatarForWriteDefaultsMixture(VRCAvatarDescriptor avatarSDK3)
        {
            if (avatarSDK3 != null)
            {
                foreach (VRCAvatarDescriptor.CustomAnimLayer customLayer in avatarSDK3.baseAnimationLayers)
                {
                    AnimatorController controller = customLayer.animatorController as AnimatorController;
                    if (controller != null)
                    {
                        WriteDefaultsScanResult scanResult = WriteDefaultsScanResult.NoStates;
                        foreach (AnimatorControllerLayer controllerLayer in controller.layers)
                        {
                            // If this layer is set to additive blending instead of override, skip it. This is due to known WD bugs.
                            if (controllerLayer.blendingMode == AnimatorLayerBlendingMode.Additive)
                            {
                                continue;
                            }

                            // This will scan this state machine and all child state machines it contains.
                            scanResult = ScanStateMachineForWriteDefaultsMixture(controllerLayer.stateMachine, scanResult);
                            if (scanResult == WriteDefaultsScanResult.Mixture)
                            {
                                return true;
                            }
                        }
                    }
                }
            }

            return false;
        }

        private static WriteDefaultsScanResult ScanStateMachineForWriteDefaultsMixture(AnimatorStateMachine stateMachine, WriteDefaultsScanResult runningResult)
        {
            if (runningResult == WriteDefaultsScanResult.Mixture)
            {
                // Mixture already established from caller.
                return WriteDefaultsScanResult.Mixture;
            }

            foreach (ChildAnimatorState childState in stateMachine.states)
            {
                AnimatorState checkedState = childState.state;

                // If this is a blend tree set to Direct Blend, skip it. This is due to known WD bugs.
                BlendTree blendTreeState = checkedState.motion as BlendTree;
                if (blendTreeState != null && blendTreeState.blendType == BlendTreeType.Direct)
                {
                    continue;
                }

                bool wdState = childState.state.writeDefaultValues;
                if (runningResult == WriteDefaultsScanResult.NoStates)
                {
                    runningResult = wdState ? WriteDefaultsScanResult.AllEnabled : WriteDefaultsScanResult.AllDisabled;
                }
                else
                {
                    bool enabledExpected = runningResult == WriteDefaultsScanResult.AllEnabled;
                    if (wdState != enabledExpected)
                    {
                        // Found a mixture of WD settings.
                        return WriteDefaultsScanResult.Mixture;
                    }
                }
            }

            // This state machine could itself contain nested state machines. Recursively search those too.
            foreach (ChildAnimatorStateMachine childStateMachine in stateMachine.stateMachines)
            {
                runningResult = ScanStateMachineForWriteDefaultsMixture(childStateMachine.stateMachine, runningResult);
                if (runningResult == WriteDefaultsScanResult.Mixture)
                {
                    return WriteDefaultsScanResult.Mixture;
                }
            }

            return runningResult;
        }

        /// <summary>
        /// Scan for WD off states that contain empty motions across all blend tree children.
        ///
        /// Attempts to warn of this issue: https://vrcfury.com/technical/wd/#empty-animations-with-wd-off
        /// </summary>
        /// <param name="avatarSDK3">The avatar.</param>
        /// <returns>True if we find a mixture of WD states on this avatar or false if we do not.</returns>
        private static bool ScanAvatarForWriteDefaultsOffEmptyClips(VRCAvatarDescriptor avatarSDK3)
        {
            if (avatarSDK3 != null)
            {
                foreach (VRCAvatarDescriptor.CustomAnimLayer customLayer in avatarSDK3.baseAnimationLayers)
                {
                    AnimatorController controller = customLayer.animatorController as AnimatorController;
                    if (controller != null)
                    {
                        foreach (AnimatorControllerLayer controllerLayer in controller.layers)
                        {
                            bool issueFound = ScanStateMachineForWriteDefaultsOffEmptyClips(controllerLayer.stateMachine);
                            if (issueFound)
                            {
                                return true;
                            }
                        }
                    }
                }
            }

            return false;
        }

        private static bool ScanStateMachineForWriteDefaultsOffEmptyClips(AnimatorStateMachine stateMachine)
        {
            foreach (ChildAnimatorState childState in stateMachine.states)
            {
                AnimatorState checkedState = childState.state;

                if (!checkedState.writeDefaultValues)
                {
                    bool issueFound = CheckMotion(checkedState.motion);
                    if (issueFound)
                    {
                        return true;
                    }
                }
            }

            // This state machine could itself contain nested state machines. Recursively search those too.
            foreach (ChildAnimatorStateMachine childStateMachine in stateMachine.stateMachines)
            {
                bool issueFound = ScanStateMachineForWriteDefaultsOffEmptyClips(childStateMachine.stateMachine);
                if (issueFound)
                {
                    return true;
                }
            }

            return false;


            bool CheckMotion(Motion checkedMotion)
            {
                if (checkedMotion == null)
                {
                    // No motion assigned on WD off state.
                    return true;
                }

                if (checkedMotion is AnimationClip animationClip && animationClip.empty)
                {
                    // Empty clip assigned on WD off state.
                    return true;
                }

                if (checkedMotion is BlendTree blendTree)
                {
                    foreach (ChildMotion childMotion in blendTree.children)
                    {
                        bool issueFound = CheckMotion(childMotion.motion);
                        if (issueFound)
                        {
                            // Null or empty motion on child blend state.
                            return true;
                        }
                    }
                }

                // Motion is all clear.
                return false;
            }
        }

        private static List<AudioClip> ScanAvatarForAnimatorPlayAudio(VRCAvatarDescriptor avatarSDK3)
        {
            List<AudioClip> errorClips = new List<AudioClip>();
            if (avatarSDK3 != null)
            {
                foreach (VRCAvatarDescriptor.CustomAnimLayer customLayer in avatarSDK3.baseAnimationLayers)
                {
                    AnimatorController controller = customLayer.animatorController as AnimatorController;
                    if (controller != null)
                    {
                        VRC_AnimatorPlayAudio[] stateBehaviours = controller.GetBehaviours<VRC_AnimatorPlayAudio>();
;                       foreach (VRC_AnimatorPlayAudio sB in stateBehaviours)
                        {
                            foreach (AudioClip audio in sB.Clips)
                            {
                                if (audio != null && audio.loadType == AudioClipLoadType.DecompressOnLoad && !audio.loadInBackground && !errorClips.Contains(audio))
                                {
                                    errorClips.Add(audio);
                                }
                            }
                        }
                    }
                }
            }
            return errorClips;
        }

        private static void ScanAvatarForAutoDestructComponents(VRC_AvatarDescriptor avatar, out List<ParticleSystem> autoDestructSystems, out List<ParticleSystem> autoDisableRootSystems, out List<TrailRenderer> autoDestructTrails)
        {
            autoDestructSystems = new List<ParticleSystem>();
            autoDisableRootSystems = new List<ParticleSystem>();
            autoDestructTrails = new List<TrailRenderer>();

            if (avatar == null)
            {
                return;
            }

            ParticleSystem[] systems = avatar.GetComponentsInChildren<ParticleSystem>(true);
            foreach (ParticleSystem system in systems)
            {
                if (system.main.stopAction == ParticleSystemStopAction.Destroy)
                {
                    autoDestructSystems.Add(system);
                }
                else if (system.main.stopAction == ParticleSystemStopAction.Disable && system.gameObject == avatar.gameObject)
                {
                    autoDisableRootSystems.Add(system);
                }
            }

            TrailRenderer[] trails = avatar.GetComponentsInChildren<TrailRenderer>(true);
            foreach (TrailRenderer trail in trails)
            {
                if (trail.autodestruct)
                {
                    autoDestructTrails.Add(trail);
                }
            }
        }

        private static void FixAudioClipLoadInBackground(List<AudioClip> audioClips)
        {
            foreach (AudioClip clip in audioClips)
            {
                AudioImporter importer = AssetImporter.GetAtPath(AssetDatabase.GetAssetPath(clip.GetInstanceID())) as AudioImporter;
                if (importer != null)
                {
                    importer.loadInBackground = true;
                    importer.SaveAndReimport();
                }
            }
        }

        #endregion
    }
}
#endif
