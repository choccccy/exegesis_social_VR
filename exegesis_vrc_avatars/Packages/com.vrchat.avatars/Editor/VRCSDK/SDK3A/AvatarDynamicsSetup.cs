using System;
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using JetBrains.Annotations;
using UnityEngine.Animations;
using VRC.Core.Pool;
using VRC.SDK3.Avatars.Components;
using VRC.SDK3.Dynamics.PhysBone;
using VRC.Dynamics;
using VRC.SDK3.Dynamics;
using VRC.SDKBase.Validation;
using Object = UnityEngine.Object;

namespace VRC.SDK3.Avatars
{
    /// <summary>
    /// Avatar specific VRC dynamics setup.
    /// </summary>
    public static class AvatarDynamicsSetup
    {
        [InitializeOnLoadMethod]
        private static void EditorInit()
        {
            DynamicsComponent.DefaultUsage = DynamicsUsage.Avatar;
        }

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
        private static void RuntimeInitInitializeEvents()
        {
            //Contacts
            ContactBase.OnInitialize = Contact_OnInitialize;

            //PhysBones
            VRCPhysBoneBase.OnInitialize = PhysBone_OnInitialize;
            VRCPhysBoneColliderBase.OnPreShapeInitialize += PhysBoneCollider_OnPreShapeInitialize;
        }

        [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
        private static void RuntimeInitPhysBoneGrabHelper()
        {
            // PhysBoneManager singleton should exist following DynamicsSetup.
            PhysBoneManager.Inst.gameObject.AddComponent<PhysBoneGrabHelper>();
        }


        private static bool Contact_OnInitialize(ContactBase contact)
        {
            contact.Usage = DynamicsUsage.Avatar;

            var receiver = contact as ContactReceiver;
            if (receiver != null && !string.IsNullOrWhiteSpace(receiver.parameter))
            {
                var avatarDesc = receiver.GetComponentInParent<VRCAvatarDescriptor>();
                if (avatarDesc != null)
                {
                    var animator = avatarDesc.GetComponent<Animator>();
                    if (animator != null)
                    {
                        // called from SDK, so create SDK Param access
                        receiver.paramAccess = new AnimParameterAccessAvatarSDK(animator, receiver.parameter);
                    }
                }
            }

            return true;
        }

        private static void PhysBone_OnInitialize(VRCPhysBoneBase physBone)
        {
            physBone.Usage = DynamicsUsage.Avatar;

            if (!string.IsNullOrEmpty(physBone.parameter))
            {
                var avatarDesc = physBone.GetComponentInParent<VRCAvatarDescriptor>();
                if (avatarDesc != null)
                {
                    var animator = avatarDesc.GetComponent<Animator>();
                    if (animator != null)
                    {
                        physBone.param_IsGrabbed = new AnimParameterAccessAvatarSDK(animator, physBone.parameter + VRCPhysBoneBase.PARAM_ISGRABBED);
                        physBone.param_IsPosed = new AnimParameterAccessAvatarSDK(animator, physBone.parameter + VRCPhysBoneBase.PARAM_ISPOSED);
                        physBone.param_Angle = new AnimParameterAccessAvatarSDK(animator, physBone.parameter + VRCPhysBoneBase.PARAM_ANGLE);
                        physBone.param_Stretch = new AnimParameterAccessAvatarSDK(animator, physBone.parameter + VRCPhysBoneBase.PARAM_STRETCH);
                        physBone.param_Squish = new AnimParameterAccessAvatarSDK(animator, physBone.parameter + VRCPhysBoneBase.PARAM_SQUISH);
                    }
                }
            }
        }

        private static void PhysBoneCollider_OnPreShapeInitialize(VRCPhysBoneColliderBase physBoneCollider)
        {
            physBoneCollider.Usage = DynamicsUsage.Avatar;
        }

        #region PhysBone Conversion
        [MenuItem("VRChat SDK/Utilities/Convert DynamicBones To PhysBones")]
        public static void ConvertSelectedToPhysBones()
        {
            List<GameObject> avatarObjs = new List<GameObject>();
            foreach (var obj in Selection.objects)
            {
                var gameObj = obj as GameObject;
                if (gameObj == null)
                    continue;

                var descriptor = gameObj.GetComponent<VRCAvatarDescriptor>();
                if (descriptor != null)
                {
                    avatarObjs.Add(gameObj);
                }
            }
            if (avatarObjs.Count == 0)
            {
                EditorUtility.DisplayDialog("Warning", "No avatars found.  Please select an avatar in the hierarchy window before using this feature.", "Okay");
            }
            else
            {
                ConvertDynamicBonesToPhysBones(avatarObjs);
            }
        }
        public static void ConvertDynamicBonesToPhysBones(IEnumerable<GameObject> avatarGameObjects)
        {
            if (!EditorUtility.DisplayDialog("Warning", "This operation will remove all DynamicBone components and replace them with PhysBone components on your avatar. This process attempts to match settings but the result may not appear to be the same. This is not reversible so please make a backup before continuing!", "Proceed", "Cancel"))
                return;

            foreach(var avatarObj in avatarGameObjects)
                ConvertToPhysBones(avatarObj);
        }
        static void ConvertToPhysBones(GameObject avatarObj)
        {
            try
            {
                //Find types
                var TypeDynamicBone = TypeUtils.GetTypeFromName("DynamicBone");
                var TypeDynamicBoneCollider = TypeUtils.GetTypeFromName("DynamicBoneCollider");
                if (TypeDynamicBone == null || TypeDynamicBoneCollider == null)
                {
                    EditorUtility.DisplayDialog("Error", "DynamicBone not found in the project.", "Okay");
                    return;
                }

                //Get Data
                var animator = avatarObj.GetComponent<Animator>();
                var dbcList = avatarObj.GetComponentsInChildren(TypeDynamicBoneCollider, true);
                var dbList = avatarObj.GetComponentsInChildren(TypeDynamicBone, true);

                //Convert Colliders
                var dbcDataList = new List<PhysBoneMigration.DynamicBoneColliderData>();
                foreach (var dbc in dbcList)
                {
                    var data = new PhysBoneMigration.DynamicBoneColliderData();
                    data.gameObject = dbc.gameObject;
                    data.bound = (PhysBoneMigration.DynamicBoneColliderData.Bound)(int)TypeDynamicBoneCollider.GetField("m_Bound").GetValue(dbc);
                    data.direction = (PhysBoneMigration.DynamicBoneColliderData.Direction)(int)TypeDynamicBoneCollider.GetField("m_Direction").GetValue(dbc);
                    data.radius = (float)TypeDynamicBoneCollider.GetField("m_Radius").GetValue(dbc);
                    data.height = (float)TypeDynamicBoneCollider.GetField("m_Height").GetValue(dbc);
                    data.center = (Vector3)TypeDynamicBoneCollider.GetField("m_Center").GetValue(dbc);

                    dbcDataList.Add(data);
                }

                //Convert to PhysBones
                var dbDataList = new List<PhysBoneMigration.DynamicBoneData>();
                foreach (var db in dbList)
                {
                    var data = new PhysBoneMigration.DynamicBoneData();
                    data.enabled = ((MonoBehaviour)db).enabled;
                    data.gameObject = db.gameObject;
                    data.root = (Transform)TypeDynamicBone.GetField("m_Root").GetValue(db);
                    data.exclusions = (List<Transform>)TypeDynamicBone.GetField("m_Exclusions").GetValue(db);
                    data.endLength = (float)TypeDynamicBone.GetField("m_EndLength").GetValue(db);
                    data.endOffset = (Vector3)TypeDynamicBone.GetField("m_EndOffset").GetValue(db);
                    data.elasticity = (float)TypeDynamicBone.GetField("m_Elasticity").GetValue(db);
                    data.elasticityDistrib = (AnimationCurve)TypeDynamicBone.GetField("m_ElasticityDistrib").GetValue(db);
                    data.damping = (float)TypeDynamicBone.GetField("m_Damping").GetValue(db);
                    data.dampingDistrib = (AnimationCurve)TypeDynamicBone.GetField("m_DampingDistrib").GetValue(db);
                    data.inert = (float)TypeDynamicBone.GetField("m_Inert").GetValue(db);
                    data.inertDistrib = (AnimationCurve)TypeDynamicBone.GetField("m_InertDistrib").GetValue(db);
                    data.stiffness = (float)TypeDynamicBone.GetField("m_Stiffness").GetValue(db);
                    data.stiffnessDistrib = (AnimationCurve)TypeDynamicBone.GetField("m_StiffnessDistrib").GetValue(db);
                    data.radius = (float)TypeDynamicBone.GetField("m_Radius").GetValue(db);
                    data.radiusDistrib = (AnimationCurve)TypeDynamicBone.GetField("m_RadiusDistrib").GetValue(db);
                    data.freezeAxis = (PhysBoneMigration.DynamicBoneData.FreezeAxis)(int)TypeDynamicBone.GetField("m_FreezeAxis").GetValue(db);
                    data.gravity = (Vector3)TypeDynamicBone.GetField("m_Gravity").GetValue(db);
                    data.force = (Vector3)TypeDynamicBone.GetField("m_Force").GetValue(db);

                    //Colliders
                    var dbColliders = (IList)TypeDynamicBone.GetField("m_Colliders").GetValue(db);
                    if (dbColliders != null && dbColliders.Count > 0)
                    {
                        var colliders = new List<int>(dbColliders.Count);
                        foreach (var dbc in dbColliders)
                        {
                            var index = System.Array.IndexOf(dbcList, (Component)dbc);
                            if (index >= 0)
                                colliders.Add(index);
                        }
                        data.colliders = colliders;
                    }

                    dbDataList.Add(data);
                }

                //Convert to PhysBones
                PhysBoneMigration.Convert(animator, dbDataList, dbcDataList);

                //Cleanup
                foreach (var dbc in dbcList)
                    Component.DestroyImmediate(dbc);
                foreach (var db in dbList)
                    Component.DestroyImmediate(db);
            }
            catch (System.Exception e)
            {
                Debug.LogError(e);
                EditorUtility.DisplayDialog("Error", "Encountered critical error while attempting to this operation.", "Okay");
            }
        }
        #endregion


        #region Constraint Conversion

        #region User Delegates

        /// <summary>
        /// Delegate function to determine if a given Unity constraint is due to be handled for auto-conversion by user
        /// tooling. If true is returned, this constraint will not be considered problematic and will not prompt a
        /// validation warning in the SDK.
        /// </summary>
        /// <param name="constraint">The Unity constraint.</param>
        /// <returns>True if this constraint will be converted into a VRChat constraint by a build-time process.</returns>
        [PublicAPI]
        public delegate bool IsUnityConstraintAutoConvertedDelegate(IConstraint constraint);

        /// <summary>
        /// An event function to determine if a given Unity constraint is due to be handled for auto-conversion by user
        /// tooling. If true is returned, this constraint will not be considered problematic and will not prompt a
        /// validation warning in the SDK.
        /// </summary>
        /// <param name="constraint">The Unity constraint.</param>
        /// <returns>True if this constraint will be converted into a VRChat constraint by a build-time process.</returns>
        [PublicAPI]
        public static event IsUnityConstraintAutoConvertedDelegate IsUnityConstraintAutoConverted;

        /// <summary>
        /// Delegate function for manually controlling the process of converting Unity constraints into VRChat constraints
        /// on one or more game objects. If this delegate is unused or all subscriptions return false, the native SDK
        /// conversion process will run instead.
        /// </summary>
        /// <param name="gameObjects">The list of game objects selected for conversion. If the SDK's auto-fix option is
        /// used, this will be the single game object containing the avatar descriptor of the current avatar. Note that
        /// animation clips referencing the converted constraint components must also be updated to reference the new
        /// VRChat components.</param>
        /// <param name="isAutoFix">True if this conversion was triggered by the user selecting the auto-fix button from
        /// the validations list in the SDK. False if conversion was triggered by some other means, such as selecting
        /// a context menu item.</param>
        /// <returns>True if conversion was carried out, false if it was not. If this method returns true, the SDK will
        /// not attempt to run its own conversion process.</returns>
        [PublicAPI]
        public delegate bool ConvertUnityConstraintsAcrossGameObjectsDelegate(List<GameObject> gameObjects, bool isAutoFix);

        /// <summary>
        /// Delegate function for manually controlling the process of converting Unity constraints into VRChat constraints
        /// on one or more animation clips. If this delegate is unused or all subscriptions return false, the native SDK
        /// conversion process will run instead.
        /// </summary>
        /// <param name="animationClips">The list of animation clips selected for conversion.</param>
        /// <returns>True if conversion was carried out, false if it was not. If this method returns true, the SDK will
        /// not attempt to run its own conversion process.</returns>
        [PublicAPI]
        public delegate bool ConvertUnityConstraintsAcrossAnimationClipsDelegate(List<AnimationClip> animationClips);

        /// <summary>
        /// An event function for manually controlling the process of converting Unity constraints into VRChat constraints
        /// on one or more game objects. If this delegate is unused or all subscriptions return false, the native SDK
        /// conversion process will run instead.
        /// </summary>
        /// <param name="gameObjects">The list of game objects selected for conversion. If the SDK's auto-fix option is
        /// used, this will be the single game object containing the avatar descriptor of the current avatar. Note that
        /// animation clips referencing the converted constraint components must also be updated to reference the new
        /// VRChat components.</param>
        /// <param name="isAutoFix">True if this conversion was triggered by the user selecting the auto-fix button from
        /// the validations list in the SDK. False if conversion was triggered by some other means, such as selecting
        /// a context menu item.</param>
        /// <returns>True if conversion was carried out, false if it was not. If this method returns true, the SDK will
        /// not attempt to run its own conversion process.</returns>
        [PublicAPI]
        public static event ConvertUnityConstraintsAcrossGameObjectsDelegate OnConvertUnityConstraintsAcrossGameObjects;

        /// <summary>
        /// An event function for manually controlling the process of converting Unity constraints into VRChat constraints
        /// on one or more animation clips. If this delegate is unused or all subscriptions return false, the native SDK
        /// conversion process will run instead.
        /// </summary>
        /// <param name="animationClips">The list of animation clips selected for conversion.</param>
        /// <returns>True if conversion was carried out, false if it was not. If this method returns true, the SDK will
        /// not attempt to run its own conversion process.</returns>
        [PublicAPI]
        public static event ConvertUnityConstraintsAcrossAnimationClipsDelegate OnConvertUnityConstraintsAcrossAnimationClips;

        #endregion // User Delegates

        /// <summary>
        /// Editor-only constraint component creator. This creates components with undo support.
        /// </summary>
        private class EditorConstraintSubstituteCreator : VRCConstraintManager.IConstraintSubstituteCreator
        {
            T VRCConstraintManager.IConstraintSubstituteCreator.CreateSubstituteComponent<T>(GameObject hostGameObject)
            {
                return Undo.AddComponent<T>(hostGameObject);
            }
        }
        private static readonly EditorConstraintSubstituteCreator EditorSubstituteCreator = new EditorConstraintSubstituteCreator();

        /// <summary>
        /// Maps from Unity's constraint types to the equivalent VRChat constraint types.
        /// </summary>
        private static readonly Dictionary<Type, Type> ConstraintAnimatorTypeRebindDictionary = new Dictionary<Type, Type>()
        {
            { typeof(PositionConstraint), typeof(VRC.SDK3.Dynamics.Constraint.Components.VRCPositionConstraint) },
            { typeof(RotationConstraint), typeof(VRC.SDK3.Dynamics.Constraint.Components.VRCRotationConstraint) },
            { typeof(ScaleConstraint), typeof(VRC.SDK3.Dynamics.Constraint.Components.VRCScaleConstraint) },
            { typeof(ParentConstraint), typeof(VRC.SDK3.Dynamics.Constraint.Components.VRCParentConstraint) },
            { typeof(AimConstraint), typeof(VRC.SDK3.Dynamics.Constraint.Components.VRCAimConstraint) },
            { typeof(LookAtConstraint), typeof(VRC.SDK3.Dynamics.Constraint.Components.VRCLookAtConstraint) },
        };

        /// <summary>
        /// Maps from property names on Unity constraints to the equivalent property names on VRChat constraints.
        /// </summary>
        private static readonly Dictionary<string, string> ConstraintAnimatorPropertyRebindDictionary = new Dictionary<string, string>()
        {
            // These names are lifted from the C# source files for Unity's inspectors:
            // https://github.com/Unity-Technologies/UnityCsReference/tree/master/Editor/Mono/Inspector

            { "m_Enabled", "m_Enabled" },

            { "m_Active", nameof(VRCConstraintBase.IsActive) },
            { "m_Weight", nameof(VRCConstraintBase.GlobalWeight) },
            { "m_IsLocked", nameof(VRCConstraintBase.Locked) },
            { "m_Sources", nameof(VRCConstraintBase.Sources) },

            { "m_TranslationAtRest.x", $"{nameof(Dynamics.Constraint.Components.VRCPositionConstraint.PositionAtRest)}.x" },
            { "m_TranslationAtRest.y", $"{nameof(Dynamics.Constraint.Components.VRCPositionConstraint.PositionAtRest)}.y" },
            { "m_TranslationAtRest.z", $"{nameof(Dynamics.Constraint.Components.VRCPositionConstraint.PositionAtRest)}.z" },
            { "m_TranslationOffset.x", $"{nameof(Dynamics.Constraint.Components.VRCPositionConstraint.PositionOffset)}.x" },
            { "m_TranslationOffset.y", $"{nameof(Dynamics.Constraint.Components.VRCPositionConstraint.PositionOffset)}.y" },
            { "m_TranslationOffset.z", $"{nameof(Dynamics.Constraint.Components.VRCPositionConstraint.PositionOffset)}.z" },
            { "m_AffectTranslationX", nameof(Dynamics.Constraint.Components.VRCPositionConstraint.AffectsPositionX) },
            { "m_AffectTranslationY", nameof(Dynamics.Constraint.Components.VRCPositionConstraint.AffectsPositionY) },
            { "m_AffectTranslationZ", nameof(Dynamics.Constraint.Components.VRCPositionConstraint.AffectsPositionZ) },

            { "m_RotationAtRest.x", $"{nameof(Dynamics.Constraint.Components.VRCRotationConstraint.RotationAtRest)}.x" },
            { "m_RotationAtRest.y", $"{nameof(Dynamics.Constraint.Components.VRCRotationConstraint.RotationAtRest)}.y" },
            { "m_RotationAtRest.z", $"{nameof(Dynamics.Constraint.Components.VRCRotationConstraint.RotationAtRest)}.z" },
            { "m_RotationOffset.x", $"{nameof(Dynamics.Constraint.Components.VRCRotationConstraint.RotationOffset)}.x" },
            { "m_RotationOffset.y", $"{nameof(Dynamics.Constraint.Components.VRCRotationConstraint.RotationOffset)}.y" },
            { "m_RotationOffset.z", $"{nameof(Dynamics.Constraint.Components.VRCRotationConstraint.RotationOffset)}.z" },
            { "m_AffectRotationX", nameof(Dynamics.Constraint.Components.VRCRotationConstraint.AffectsRotationX) },
            { "m_AffectRotationY", nameof(Dynamics.Constraint.Components.VRCRotationConstraint.AffectsRotationY) },
            { "m_AffectRotationZ", nameof(Dynamics.Constraint.Components.VRCRotationConstraint.AffectsRotationZ) },

            { "m_ScaleAtRest.x", $"{nameof(Dynamics.Constraint.Components.VRCScaleConstraint.ScaleAtRest)}.x" },
            { "m_ScaleAtRest.y", $"{nameof(Dynamics.Constraint.Components.VRCScaleConstraint.ScaleAtRest)}.y" },
            { "m_ScaleAtRest.z", $"{nameof(Dynamics.Constraint.Components.VRCScaleConstraint.ScaleAtRest)}.z" },
            { "m_ScaleOffset.x", $"{nameof(Dynamics.Constraint.Components.VRCScaleConstraint.ScaleOffset)}.x" },
            { "m_ScaleOffset.y", $"{nameof(Dynamics.Constraint.Components.VRCScaleConstraint.ScaleOffset)}.y" },
            { "m_ScaleOffset.z", $"{nameof(Dynamics.Constraint.Components.VRCScaleConstraint.ScaleOffset)}.z" },
            { "m_AffectScalingX", nameof(Dynamics.Constraint.Components.VRCScaleConstraint.AffectsScaleX) },
            { "m_AffectScalingY", nameof(Dynamics.Constraint.Components.VRCScaleConstraint.AffectsScaleY) },
            { "m_AffectScalingZ", nameof(Dynamics.Constraint.Components.VRCScaleConstraint.AffectsScaleZ) },

            { "m_AimVector.x", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.AimAxis)}.x" },
            { "m_AimVector.y", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.AimAxis)}.y" },
            { "m_AimVector.z", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.AimAxis)}.z" },
            { "m_UpVector.x", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.UpAxis)}.x" },
            { "m_UpVector.y", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.UpAxis)}.y" },
            { "m_UpVector.z", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.UpAxis)}.z" },
            { "m_WorldUpVector.x", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.WorldUpVector)}.x" },
            { "m_WorldUpVector.y", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.WorldUpVector)}.y" },
            { "m_WorldUpVector.z", $"{nameof(Dynamics.Constraint.Components.VRCAimConstraint.WorldUpVector)}.z" },
            { "m_WorldUpObject", nameof(Dynamics.Constraint.Components.VRCAimConstraint.WorldUpTransform) },
            { "m_UpType", nameof(Dynamics.Constraint.Components.VRCAimConstraint.WorldUp) },

            { "m_UseUpObject", nameof(Dynamics.Constraint.Components.VRCLookAtConstraint.UseUpTransform) },
            //{ "m_WorldUpObject", nameof(Dynamics.Constraint.Components.VRCLookAtConstraint.WorldUpTransform) }, // in common with aim constraints
            { "m_Roll", nameof(Dynamics.Constraint.Components.VRCLookAtConstraint.Roll) },
        };

        /// <summary>
        /// Maps from property names within source array elements on Unity constraints to the equivalent names on VRChat constraints.
        /// </summary>
        private static readonly Dictionary<string, string> ConstraintAnimatorArrayPostfixPropertyRebindDictionary = new Dictionary<string, string>()
        {
            { "m_Sources__sourceTransform", "SourceTransform" }, // Known limitation: pptr references to elements in an array are not supported for non-engine types
            { "m_Sources__weight", "Weight" },
            { "m_TranslationOffsets__x", "ParentPositionOffset.x" },
            { "m_TranslationOffsets__y", "ParentPositionOffset.y" },
            { "m_TranslationOffsets__z", "ParentPositionOffset.z" },
            { "m_RotationOffsets__x", "ParentRotationOffset.x" },
            { "m_RotationOffsets__y", "ParentRotationOffset.y" },
            { "m_RotationOffsets__z", "ParentRotationOffset.z" },
        };

        #region Converter Menu Items

        [MenuItem("VRChat SDK/Utilities/Convert Unity Constraints To VRChat Constraints")] // Static toolbar menu entry.
        [MenuItem("Assets/VRChat Utilities/Convert Unity Constraints To VRChat Constraints")] // Right click context on assets.
        private static void ConvertSelectedToVrChatConstraints_AssetContext()
        {
            List<GameObject> gameObjects = new List<GameObject>();
            List<AnimationClip> animationClips = new List<AnimationClip>();
            bool isMixedSelection = false;
            foreach (Object obj in Selection.objects)
            {
                if (obj is GameObject gameObject)
                {
                    if (animationClips.Count > 0)
                    {
                        isMixedSelection = true;
                        break;
                    }
                    gameObjects.Add(gameObject);
                }
                else if (obj is AnimationClip clip)
                {
                    if (gameObjects.Count > 0)
                    {
                        isMixedSelection = true;
                        break;
                    }
                    animationClips.Add(clip);
                }
            }

            if (isMixedSelection)
            {
                EditorUtility.DisplayDialog("Warning",
                    "A mixture of game objects and animation clips are selected. Please select only game objects or only animation clips and try again.",
                    "Okay");
                return;
            }

            if (gameObjects.Count > 0)
            {
                ConvertUnityConstraintsAcrossGameObjects(gameObjects);
            }
            else if (animationClips.Count > 0)
            {
                ConvertUnityConstraintsAcrossAnimationClips(animationClips);
            }
            else
            {
                EditorUtility.DisplayDialog("Warning",
                    "No convertible objects are selected. Please select a game object, prefab or animation clip to use this feature.",
                    "Okay");
            }
        }

        [MenuItem("Assets/VRChat Utilities/Convert Unity Constraints To VRChat Constraints", true)]
        private static bool ConvertSelectedToVrChatConstraints_AssetContextValidation()
        {
            foreach (Object obj in Selection.objects)
            {
                if (obj is not GameObject && obj is not AnimationClip)
                {
                    return false;
                }
            }

            return true;
        }

        // Option for specific individual Unity constraint components by right clicking on them.
        [MenuItem("CONTEXT/IConstraint/Convert To VRChat Constraint")]
        private static void ConvertSelectedToVrChatConstraint_IndividualContext(MenuCommand command)
        {
            if (command.context is IConstraint unityConstraint)
            {
                if (!CheckAnimationPreviewState(true))
                {
                    return;
                }

                Component unityConstraintComponent = (Component)unityConstraint;
                GameObject targetGameObject = unityConstraintComponent.gameObject;

                // Catch the avatar from parents in case we have avatar animation layers containing anims to convert.
                VRCAvatarDescriptor avatarDescriptor = targetGameObject.GetComponentInParent<VRCAvatarDescriptor>();

                ExecuteConstraintsTaskWithUndoAndUserReport(targetGameObject.name, () =>
                {
                    // Convert this constraint only. We will not attempt to rebind clips in this context because the user
                    // is specifically targeting a single constraint component. No modal dialog is shown since it's likely
                    // to annoy users that do this frequently which means we can't warn of clips being updated automatically.
                    return DoConvertUnityConstraints(new [] { unityConstraint }, avatarDescriptor, false);
                });
            }
        }

        #endregion // Converter Menu Items

        /// <summary>
        /// Convert Unity constraints across the given game objects into VRChat constraints. Shows a modal confirmation
        /// dialog. May be overridden by user tooling.
        /// </summary>
        /// <param name="targetGameObjects">The game objects to search through.</param>
        [PublicAPI]
        public static void ConvertUnityConstraintsAcrossGameObjects(List<GameObject> targetGameObjects)
        {
            ConvertUnityConstraintsAcrossGameObjects(targetGameObjects, false);
        }

        /// <summary>
        /// Convert Unity constraints across the given game objects into VRChat constraints. Shows a modal confirmation
        /// dialog. May be overridden by user tooling.
        /// </summary>
        /// <param name="targetGameObjects">The game objects to search through.</param>
        /// <param name="isAutoFix">True if this was triggered from the context of the auto-fix function in the SDK
        /// validation window.</param>
        internal static void ConvertUnityConstraintsAcrossGameObjects(List<GameObject> targetGameObjects, bool isAutoFix)
        {
            // If user tooling is overriding this function, use that instead.
            bool wasConvertedByUserTooling = TryExecuteUserConstraintsDelegate(OnConvertUnityConstraintsAcrossGameObjects, targetGameObjects, isAutoFix);
            if (wasConvertedByUserTooling)
            {
                // User tooling is claiming to have handled this for us. Stop now.
                return;
            }

            if (!CheckAnimationPreviewState(true))
            {
                return;
            }

            bool handlingAvatarsOnly = true;
            foreach (GameObject targetGameObject in targetGameObjects)
            {
                VRCAvatarDescriptor avatarDescriptor = targetGameObject.GetComponentInParent<VRCAvatarDescriptor>();
                if (avatarDescriptor == null)
                {
                    handlingAvatarsOnly = false;
                    break;
                }
            }

            bool hasMultiple = targetGameObjects.Count > 1;
            string subject = handlingAvatarsOnly ? "avatar" : "object";
            bool canContinue = EditorUtility.DisplayDialog("Auto Convert Constraints",
                $"All Unity constraints on {(hasMultiple ? $"the selected {subject}s" : $"this {subject}")} will be replaced with equivalent VRChat constraints.\n\n" +
                $"If {(hasMultiple ? "an" : "this")} {subject} references any animation clips that animate the replaced Unity constraints, those animation " +
                "clips will be automatically updated so they target the newly created VRChat constraints instead.\n\n" +
                "If your animator setup is very complex, you may want to back up your project first!",
                "Proceed", "Cancel");

            if (!canContinue)
            {
                return;
            }
            
            ExecuteConstraintsTaskWithUndoAndUserReport(hasMultiple ? "Multiple Objects" : targetGameObjects[0].name, () =>
            {
                // Cycle all targets and actually make the conversions.
                bool issuesGenerated = false;
                foreach (GameObject targetGameObject in targetGameObjects)
                {
                    if (targetGameObject == null)
                    {
                        continue;
                    }

                    IConstraint[] unityConstraints = targetGameObject.GetComponentsInChildren<IConstraint>(true);

                    // Catch the avatar from parents in case we have avatar animation layers containing anims to convert.
                    VRCAvatarDescriptor avatarDescriptor = targetGameObject.GetComponentInParent<VRCAvatarDescriptor>();

                    issuesGenerated |= DoConvertUnityConstraints(unityConstraints, avatarDescriptor, true);
                }
                return issuesGenerated;
            });
        }

        /// <summary>
        /// Converts Unity constraints across the given animation clips into VRChat constraints. Shows a modal
        /// confirmation dialog. May be overridden by user tooling.
        /// </summary>
        /// <param name="targetAnimationClips">The animation clips to search through.</param>
        [PublicAPI]
        public static void ConvertUnityConstraintsAcrossAnimationClips(List<AnimationClip> targetAnimationClips)
        {
            // If user tooling is overriding this function, use that instead.
            bool wasConvertedByUserTooling = TryExecuteUserConstraintsDelegate(OnConvertUnityConstraintsAcrossAnimationClips, targetAnimationClips);
            if (wasConvertedByUserTooling)
            {
                // User tooling is claiming to have handled this for us. Stop now.
                return;
            }

            bool hasMultiple = targetAnimationClips.Count > 1;
            bool canContinue = EditorUtility.DisplayDialog("Auto Convert Constraints",
                $"All animation tracks targeting Unity constraints in the selected animation {(hasMultiple ? "clips" : "clip")} will be updated to target VRChat constraints instead.\n\n" +
                $"Please note that only the first {VRCConstraintSourceKeyableList.MaxFlatLength} sources of a VRChat constraint can be animated due to engine limitations.\n\n" +
                "If your animator setup is very complex, you may want to back up your project first!",
                "Proceed", "Cancel");

            if (!canContinue)
            {
                return;
            }

            ExecuteConstraintsTaskWithUndoAndUserReport(hasMultiple ? "Multiple Clips" : targetAnimationClips[0].name, () =>
            {
                bool issuesGenerated = false;
                foreach (AnimationClip clip in targetAnimationClips)
                {
                    // No original constraint available. All bindings relevant to Unity constraints will be converted.
                    issuesGenerated |= RebindConstraintAnimationClip(clip);
                }
                return issuesGenerated;
            });
        }

        /// <summary>
        /// Convert an array of Unity constraints into VRChat constraints. This will run immediately without displaying
        /// a modal confirmation dialog.
        /// </summary>
        /// <param name="unityConstraints">The array of Unity constraints to convert. These objects will be destroyed
        /// as substitutes are created for them.</param>
        /// <param name="avatarDescriptor">An optional avatar descriptor. If this is given and we're converting
        /// animation clips, this avatar will be searched for any animation clips referencing the original Unity
        /// constraints so those clips can be automatically updated. Not used if we are not converting animation clips.</param>
        /// <param name="convertReferencedAnimationClips">If true, this method will attempt to automatically convert
        /// the curve bindings of any referenced animation clips that animate the original Unity constraints so they
        /// target the newly created VRChat constraints instead. If false, animation clips will not be modified
        /// automatically.</param>
        /// <returns>True if any issues were encountered that the user should be notified about. These issues will be
        /// recorded in Unity's console window. Returns false if there were no issues to report.</returns>
        [PublicAPI]
        public static bool DoConvertUnityConstraints(IConstraint[] unityConstraints, VRCAvatarDescriptor avatarDescriptor, bool convertReferencedAnimationClips)
        {
            // Recheck the animation preview state with no modal because this is a public API.
            if (!CheckAnimationPreviewState(false))
            {
                return true;
            }

            if (unityConstraints == null || unityConstraints.Length == 0)
            {
                // No constraints to convert...
                return false;
            }

            bool issueGenerated = false;

            foreach (IConstraint unityConstraint in unityConstraints)
            {
                Component unityConstraintComponent = (Component)unityConstraint;

                // Bind without keeping the binding, then destroy the original.
                // Use the publicly exposed types here, since we're in the SDK.
                bool substituteCreated = VRCConstraintManager.TryCreateSubstituteConstraint<
                    VRC.SDK3.Dynamics.Constraint.Components.VRCPositionConstraint,
                    VRC.SDK3.Dynamics.Constraint.Components.VRCRotationConstraint,
                    VRC.SDK3.Dynamics.Constraint.Components.VRCScaleConstraint,
                    VRC.SDK3.Dynamics.Constraint.Components.VRCParentConstraint,
                    VRC.SDK3.Dynamics.Constraint.Components.VRCAimConstraint,
                    VRC.SDK3.Dynamics.Constraint.Components.VRCLookAtConstraint
                >(unityConstraint, out VRCConstraintBase substituteConstraint, EditorSubstituteCreator, false);

                if (substituteCreated)
                {
                    GameObject hostGameObject = substituteConstraint.gameObject;
                    if (hostGameObject.GetComponents(substituteConstraint.GetType()).Length > 1)
                    {
                        // The engine can't reliably handle cases where multiple components of the same type on one game object are being animated.
                        // Unity's approach to this problem is to disallow multiples of the same component on one game object. We're avoiding that
                        // solution, so just signal a warning instead so the avatar author can decide what to do next.
                        Debug.LogWarning(
                            $"Auto Convert Constraints: The game object \"{hostGameObject.name}\" already contains one or more VRChat constraints of type {substituteConstraint.GetType().Name}. " +
                            "Animating components of the same type on the same game object is not supported. You may need to move the duplicate types to their own game objects.",
                            hostGameObject);
                        issueGenerated = true;
                    }

                    if (convertReferencedAnimationClips)
                    {
                        using (HashSetPool.Get(out HashSet<AnimationClip> clipsToConvert))
                        {
                            // Search for referenced animation clips.
                            GetReferencedAnimationClips(hostGameObject, avatarDescriptor, clipsToConvert);

                            foreach (AnimationClip clip in clipsToConvert)
                            {
                                // Try to rebind this...
                                issueGenerated |= RebindConstraintAnimationClip(clip, unityConstraint);
                            }
                        }
                    }

                    // Destroy the original Unity component now that we've finished setting up a substitute.
                    Undo.DestroyObjectImmediate(unityConstraintComponent);
                }
                else
                {
                    issueGenerated = true;
                }
            }

            return issueGenerated;
        }


        internal static void CheckUserToolingHandledUnityConstraints(List<IConstraint> unityConstraints)
        {
            if (IsUnityConstraintAutoConverted == null)
            {
                return;
            }

            // Remove all constraints from the list that are handled according to user tooling.
            for (int i = unityConstraints.Count - 1; i >= 0; i--)
            {
                bool isConstraintHandled = TryExecuteUserConstraintsDelegate(IsUnityConstraintAutoConverted, unityConstraints[i]);
                if (isConstraintHandled)
                {
                    unityConstraints.RemoveAt(i);
                }
            }
        }

        private static bool TryExecuteUserConstraintsDelegate(Delegate delegateFunction, params object[] args)
        {
            if (delegateFunction != null)
            {
                bool combinedResult = false;

                foreach (Delegate dlg in delegateFunction.GetInvocationList())
                {
                    try
                    {
                        object resultObj = dlg.DynamicInvoke(args);
                        combinedResult |= resultObj is true; // safely cast from object to bool
                    }
                    catch (Exception ex)
                    {
                        // User tooling failed.
                        // Treat as converted/handled, as the user converter may have left the project in an unknown state,
                        // so we should avoid running the native SDK converter.
                        Debug.LogException(ex);
                        combinedResult = true;
                    }
                }

                return combinedResult;
            }

            return false;
        }

        private static void ExecuteConstraintsTaskWithUndoAndUserReport(string undoSubjectLabel, Func<bool> action)
        {
            Undo.SetCurrentGroupName(!string.IsNullOrEmpty(undoSubjectLabel) ? $"Convert Constraints ({undoSubjectLabel})" : "Convert Constraints");
            int undoGroup = Undo.GetCurrentGroup();

            bool issuesGenerated = false;
            bool gotException = false;
            try
            {
                // Do the work.
                issuesGenerated = action();
            }
            catch (Exception ex)
            {
                Debug.LogException(ex);
                gotException = true;
            }
            finally
            {
                Undo.CollapseUndoOperations(undoGroup);

                if (gotException)
                {
                    EditorUtility.DisplayDialog("Auto Convert Constraints",
                        "Constraint conversion failed! Please check for associated errors in the console for more information.",
                        "Okay");
                }
                else if (issuesGenerated)
                {
                    EditorUtility.DisplayDialog("Auto Convert Constraints",
                        "Constraint conversion finished with one or more issues. Please check for associated warnings and errors in the console for more information.",
                        "Okay");
                }
            }
        }

        /// <summary>
        /// Rebind the curves referencing Unity constraints in the given clip to reference VRChat constraints instead.
        /// </summary>
        /// <param name="clip">The clip to rebind.</param>
        /// <param name="oldConstraint">The original Unity constraint. Optional. If provided, we will only convert
        /// bindings specific to this constraint, otherwise we will convert all bindings that target any subtype of
        /// IConstraint.</param>
        /// <returns>True if any issues were generated, false otherwise.</returns>
        [PublicAPI]
        public static bool RebindConstraintAnimationClip(AnimationClip clip, IConstraint oldConstraint = null)
        {
            if (clip == null)
            {
                return false;
            }

            // If no constraint is passed in, that means we're trying to convert this clip in place as a standalone asset...
            GameObject hostGameObject = oldConstraint != null ? ((Component)oldConstraint).gameObject : null;
            string hostGameObjectPath = GenerateGameObjectPath(hostGameObject);

            bool anyIssuesGenerated = false;
            bool hasReportedPptrWarning = false;

            using (ListPool.Get(out List<EditorCurveBinding> curveBindings))
            {
                curveBindings.AddRange(AnimationUtility.GetCurveBindings(clip));
                curveBindings.AddRange(AnimationUtility.GetObjectReferenceCurveBindings(clip));

                for (int curveBindingIndex = 0; curveBindingIndex < curveBindings.Count; curveBindingIndex++)
                {
                    EditorCurveBinding curveBinding = curveBindings[curveBindingIndex];


                    // If you animate multiple game objects with the same path, Unity treats the reference as
                    // ambiguous and warns the user. Therefore, we're making the assumption that game object
                    // names are unique identifiers in this context. This isn't perfect, but there seems to
                    // be no way of retrieving the serialized reference ID for the Unity constraint's sources.

                    // Additionally, skip if the original target type of the curve does not match the original
                    // type, to handle a game object containing multiple constraints. This relies on Unity not
                    // allowing multiples of the same type of constraint on one game object (even though we do).
                    // This also has the effect of filtering out animated types that aren't related to constraints
                    // at all like blend shapes on SkinnedMeshRenderers.

                    bool skipBinding;
                    if (hostGameObjectPath != null && oldConstraint != null)
                    {
                        skipBinding = !hostGameObjectPath.EndsWith(curveBinding.path) || curveBinding.type != oldConstraint.GetType();
                    }
                    else
                    {
                        skipBinding = !typeof(IConstraint).IsAssignableFrom(curveBinding.type);
                    }
                    if (skipBinding)
                    {
                        continue;
                    }


                    bool hasBindingSubstitute = TryGetSubstituteAnimationBinding(
                        curveBinding.type, curveBinding.propertyName,
                        out Type replacementType, out string replacementProperty,
                        out bool isArrayProperty
                    );

                    // This is expected to be false when dealing with anything that is not a Unity constraint.
                    if (hasBindingSubstitute)
                    {
                        Undo.RecordObject(clip, $"Rebind Property {curveBinding.propertyName}");

                        // Split by whether this is a float curve or an object reference curve (transforms)
                        bool isPPtrCurve = curveBinding.isPPtrCurve;
                        if (isPPtrCurve)
                        {
                            ObjectReferenceKeyframe[] ptrKeyframes = AnimationUtility.GetObjectReferenceCurve(clip, curveBinding);

                            // Remove old.
                            AnimationUtility.SetObjectReferenceCurve(clip, curveBinding, null);

                            // Try redirecting. The path remains unchanged.
                            curveBinding.type = replacementType;
                            curveBinding.propertyName = replacementProperty;

                            // Add new.
                            AnimationUtility.SetObjectReferenceCurve(clip, curveBinding, ptrKeyframes);
                        }
                        else
                        {
                            AnimationCurve curve = AnimationUtility.GetEditorCurve(clip, curveBinding);

                            // Remove old.
                            AnimationUtility.SetEditorCurve(clip, curveBinding, null);

                            // Try redirecting. The path remains unchanged.
                            curveBinding.type = replacementType;
                            curveBinding.propertyName = replacementProperty;

                            // Add new.
                            AnimationUtility.SetEditorCurve(clip, curveBinding, curve);
                        }

                        if (isArrayProperty && isPPtrCurve)
                        {
                            // Arrays to pointers aren't officially supported on non-Unity types.
                            // Warn the user as they'll likely need to use a different approach.
                            if (!hasReportedPptrWarning)
                            {
                                Debug.LogWarning(
                                    $"Auto Convert Constraints: The clip \"{clip.name}\" animates the transform reference of one or more sources. " +
                                    "VRChat constraints do not support animating per-source transform references. You may need to use an alternative approach instead, such as having multiple sources referring to different transforms and animating their weights to switch between them.",
                                    clip
                                );
                                hasReportedPptrWarning = true;
                            }
                            anyIssuesGenerated = true;
                        }

                        PrefabUtility.RecordPrefabInstancePropertyModifications(clip);
                    }
                    else
                    {
                        anyIssuesGenerated = true;
                    }
                }
            }

            return anyIssuesGenerated;
        }

        /// <summary>
        /// Given a Unity constraint type and Unity constraint property name from a MecAnim curve binding, attempt to
        /// translate them into an equivalent type and property name for VRChat constraints. These can then be
        /// assigned back to the original curve binding to redirect it from a Unity constraint to an equivalent VRChat
        /// constraint.
        /// </summary>
        /// <param name="unityConstraintType">The type of the original Unity constraint. This should be one of the
        /// engine's constraint types implementing <c>UnityEngine.Animations.IConstraint</c>.</param>
        /// <param name="unityConstraintPropertyName">The name of the animated property on the original Unity constraint.</param>
        /// <param name="vrcConstraintType">If this method returns true, this out parameter is set to the equivalent
        /// VRChat constraint type for the given Unity constraint type.</param>
        /// <param name="vrcConstraintPropertyName">If this method returns true, this out parameter is set to the
        /// equivalent VRChat constraint property name for the given Unity constraint property name.</param>
        /// <param name="isArrayProperty">If this method returns true, this out parameter indicates whether the
        /// resulting property is part of an array.</param>
        /// <returns>True if a substitute type and property name can be found. False if there is no match. Out parameter
        /// values are undefined and should not be used when this method returns false.</returns>
        [PublicAPI]
        public static bool TryGetSubstituteAnimationBinding(Type unityConstraintType, string unityConstraintPropertyName, out Type vrcConstraintType, out string vrcConstraintPropertyName, out bool isArrayProperty)
        {
            vrcConstraintType = default;
            vrcConstraintPropertyName = default;
            isArrayProperty = default;

            if (unityConstraintType == null)
            {
                Debug.LogError("Auto Convert Constraints: Cannot perform binding mapping because the given Unity constraint type is null.");
                return false;
            }

            if (string.IsNullOrEmpty(unityConstraintPropertyName))
            {
                Debug.LogError("Auto Convert Constraints: Cannot perform binding mapping because the given Unity constraint property name is null or empty.");
                return false;
            }

            if (!ConstraintAnimatorTypeRebindDictionary.TryGetValue(unityConstraintType, out vrcConstraintType))
            {
                Debug.LogError($"Auto Convert Constraints: Failed to map the type {unityConstraintType.Name} to a VRChat constraint type.");
                return false;
            }

            // Deal with standard fields.
            if (ConstraintAnimatorPropertyRebindDictionary.TryGetValue(unityConstraintPropertyName, out vrcConstraintPropertyName))
            {
                isArrayProperty = false;
                return true;
            }

            // Deal with array types.
            Regex arrayRegex = new Regex("^(.*).Array.data\\[(\\d+)\\].(.+)$");
            Match match = arrayRegex.Match(unityConstraintPropertyName);
            if (
                match.Success &&
                ConstraintAnimatorArrayPostfixPropertyRebindDictionary.TryGetValue($"{match.Groups[1].Value}__{match.Groups[3].Value}", out string suffix) &&
                int.TryParse(match.Groups[2].Value, out int sourceIndex)
            )
            {
                // We can only animate a limited number of sources. Refuse conversion and notify if we've gone over.
                if (sourceIndex >= 0 && sourceIndex < VRCConstraintSourceKeyableList.MaxFlatLength)
                {
                    vrcConstraintPropertyName = $"Sources.source{sourceIndex}.{suffix}";
                    isArrayProperty = true;
                    return true;
                }
                else
                {
                    Debug.LogError($"Auto Convert Constraints: Failed to convert animation property \"{unityConstraintPropertyName}\" because it is out of range. Only the first {VRCConstraintSourceKeyableList.MaxFlatLength} sources of a VRChat constraint can be animated due to engine limitations.");
                    return false;
                }
            }

            Debug.LogError($"Auto Convert Constraints: Failed to convert animation property \"{unityConstraintPropertyName}\" because it wasn't recognized by the converter.");
            return false;
        }

        #region Utility

        /// <summary>
        /// Validate preview state. Returns true if we can continue with a conversion.
        /// </summary>
        private static bool CheckAnimationPreviewState(bool showModalDialog)
        {
            bool isPreviewing = AnimationMode.InAnimationMode();

            if (isPreviewing)
            {
                if (showModalDialog)
                {
                    EditorUtility.DisplayDialog("Warning",
                        "An animation is currently being previewed. The animation preview must be stopped first, otherwise previewed values could become permanent.\n\nPlease stop previewing the animation before using this feature.",
                        "Okay");
                }
                else
                {
                    Debug.LogError("Auto Convert Constraints: An animation is currently being previewed. The animation preview must be stopped first, otherwise previewed values could become permanent.");
                }
            }

            return !isPreviewing;
        }

        /// <summary>
        /// Given the host game object of a constraint and an optional avatar descriptor, get a list of all referenced
        /// animation clips.<br/>
        /// <br/>
        /// Note that this will return all potential clips for processing, including clips that may not be related to
        /// the converted constraint.
        /// </summary>
        /// <param name="hostGameObject">The host game object of a constraint.</param>
        /// <param name="avatarDescriptor">The avatar descriptor for the avatar owning this constraint, if any.</param>
        /// <param name="results">Populated with a set of clips to process.</param>
        private static void GetReferencedAnimationClips(GameObject hostGameObject, VRCAvatarDescriptor avatarDescriptor, HashSet<AnimationClip> results)
        {
            // Only attempt to update the clip if either of the following are true:
            // - It is in an animation used by the parent avatar descriptor if any.
            // - It is assigned to a parent Animator component directly if any.
            if (avatarDescriptor != null)
            {
                // Fetch animation clips from this avatar.
                GetAnimationClipsFromAvatarLayers(avatarDescriptor.baseAnimationLayers, results);
                GetAnimationClipsFromAvatarLayers(avatarDescriptor.specialAnimationLayers, results);
            }
            else
            {
                // GetComponentInParent() behaves oddly on prefabs, we must include inactive or results will be missed.
                // https://issuetracker.unity3d.com/issues/getcomponentinparent-is-returning-null-when-the-gameobject-is-a-prefab
                Animator parentAnimator = hostGameObject.GetComponentInParent<Animator>(true);
                if (parentAnimator != null)
                {
                    GetAnimationClipsFromRuntimeAnimatorController(parentAnimator.runtimeAnimatorController, results);
                }
            }
        }

        private static void GetAnimationClipsFromAvatarLayers(VRCAvatarDescriptor.CustomAnimLayer[] avatarCustomAnimLayers, HashSet<AnimationClip> results)
        {
            for (int animationLayerIndex = 0; animationLayerIndex < avatarCustomAnimLayers.Length; animationLayerIndex++)
            {
                GetAnimationClipsFromRuntimeAnimatorController(avatarCustomAnimLayers[animationLayerIndex].animatorController, results);
            }
        }

        private static void GetAnimationClipsFromRuntimeAnimatorController(RuntimeAnimatorController runtimeAnimatorController, HashSet<AnimationClip> results)
        {
            if (runtimeAnimatorController != null)
            {
                AnimationClip[] clipArray = runtimeAnimatorController.animationClips;
                for (int i = 0; i < clipArray.Length; i++)
                {
                    results.Add(clipArray[i]);
                }
            }
        }

        #endregion // Utility
        
        #endregion // Constraint Conversion


        #region Utility
        private static readonly StringBuilder GameObjectPathBuilder = new StringBuilder();
        private static string GenerateGameObjectPath(GameObject processedGameObject)
        {
            if (processedGameObject == null)
            {
                return null;
            }

            GameObjectPathBuilder.Clear();
            AppendTransformAndParents(processedGameObject.transform);

            void AppendTransformAndParents(Transform tr)
            {
                const char separator = '/';
                if (tr.parent != null)
                {
                    AppendTransformAndParents(tr.parent);
                    GameObjectPathBuilder.Append(separator);
                }

                GameObjectPathBuilder.Append(tr.name);
            }

            return GameObjectPathBuilder.ToString();
        }

        internal static Action GetDeepestConstraintSubSelection(Component avatar)
        {
            return () =>
            {
                IConstraint[] unityConstraints = avatar.GetComponentsInChildren<IConstraint>(true);
                if (unityConstraints.Length > 0)
                {
                    // We assume the worst case where all Unity constraints are at the maximum depth, so just select
                    // those.
                    Object[] unityObjects = new Object[unityConstraints.Length];
                    for (int i = 0; i < unityConstraints.Length; i++)
                    {
                        unityObjects[i] = ((Component)unityConstraints[i]).gameObject;
                    }
                    Selection.objects = unityObjects;
                    return;
                }

                VRCConstraintBase[] vrcConstraints = avatar.GetComponentsInChildren<VRCConstraintBase>(true);

                // We'll select the constraint with the highest group index. If there's a tie for first, select them all.
                int highestSeenGroupIndex = int.MinValue;
                List<Object> selectedObjects = new List<Object>();
                foreach (VRCConstraintBase candidate in vrcConstraints)
                {
                    // Use the latest valid value so we can work with disabled constraints too.
                    int candidateGroupIndex = candidate.LatestValidExecutionGroupIndex;

                    if (candidateGroupIndex > highestSeenGroupIndex)
                    {
                        // Start a new group.
                        selectedObjects.Clear();
                        selectedObjects.Add(candidate.gameObject);
                        highestSeenGroupIndex = candidateGroupIndex;
                    }
                    else if (candidateGroupIndex == highestSeenGroupIndex)
                    {
                        // Join the existing group, since I'm tied for it.
                        selectedObjects.Add(candidate.gameObject);
                    }
                }

                Selection.objects = selectedObjects.Count > 0 ? selectedObjects.ToArray() : new Object[] {avatar.gameObject};
            };
        }
        #endregion
    }
}


