using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using JetBrains.Annotations;
using UnityEngine;
using VRC.SDKBase.Editor;
using VRC.SDKBase.Editor.Api;

namespace VRC.SDK3A.Editor
{
    /// <summary>
    /// This is the public interface you can use to interact with the Avatars SDK Builder
    /// </summary>
    public interface IVRCSdkAvatarBuilderApi: IVRCSdkBuilderApi
    {
        /// <summary>
        /// The currently selected avatar in the SDK Builder Panel
        /// </summary>
        public GameObject SelectedAvatar { get; }
        
        /// <summary>
        /// Sets the currently selected avatar in the SDK Builder Panel
        /// </summary>
        /// <param name="avatar"></param>
        public void SelectAvatar(GameObject avatar);
        
        /// <summary>
        /// Builds the provided avatar GameObject and returns a path to the built avatar bundle.
        /// Make sure the avatar has a valid AvatarDescriptor and PipelineManager components attached.
        /// </summary>
        /// <param name="target">The avatar GameObject to build</param>
        /// <returns>Path to the bundle</returns>
        /// <exception cref="BuilderException">Build process has encountered an error</exception>
        /// <exception cref="BuildBlockedException">Build was blocked by the SDK Callback</exception>
        /// <exception cref="ValidationException">Content has validation errors</exception>
        [PublicAPI]
        Task<string> Build(GameObject target);
        
        /// <summary>
        /// Builds the provided avatar GameObject with the overrides provided, and returns a path to the built avatar bundle.
        /// Make sure the avatar has a valid AvatarDescriptor and PipelineManager components attached.
        /// </summary>
        /// <param name="target">The avatar GameObject to build</param>
        /// <param name="overrides">A list of per-platform overrides to use during the build</param>
        /// <returns>Path to the bundle</returns>
        /// <exception cref="BuilderException">Build process has encountered an error</exception>
        /// <exception cref="BuildBlockedException">Build was blocked by the SDK Callback</exception>
        /// <exception cref="ValidationException">Content has validation errors</exception>
        [PublicAPI]
        Task<string> Build(GameObject target, List<PerPlatformOverrides.Option> overrides);

        
        /// <summary>
        /// Builds and uploads the provided avatar GameObject for the VRCAvatar specified.
        /// Make sure the avatar has a valid AvatarDescriptor and PipelineManager components attached
        /// </summary>
        /// <param name="target">The avatar GameObject to build</param>
        /// <param name="avatar">VRCAvatar object with avatar info. Must have a Name for avatar creation</param>
        /// <param name="thumbnailPath">Path to the thumbnail image on disk. Must be specified for first avatar creation</param>
        /// <param name="cancellationToken"></param>
        /// <exception cref="BuilderException">Build process has encountered an error</exception>
        /// <exception cref="BuildBlockedException">Build was blocked by the SDK Callback</exception>
        /// <exception cref="ValidationException">Content has validation errors</exception>
        /// <exception cref="OwnershipException">Current User does not own the target content</exception>
        /// <exception cref="UploadException">Content failed to upload</exception>
        [PublicAPI]
        Task BuildAndUpload(GameObject target, VRCAvatar avatar, string thumbnailPath = null, CancellationToken cancellationToken = default);
        
        /// <summary>
        /// Builds and uploads the provided avatar GameObject with the overrides provided, for the VRCAvatar specified.
        /// Make sure the avatar has a valid AvatarDescriptor and PipelineManager components attached
        /// </summary>
        /// <param name="target">The avatar GameObject to build</param>
        /// <param name="overrides">A list of per-platform overrides to use during the build</param>
        /// <param name="avatar">VRCAvatar object with avatar info. Must have a Name for avatar creation</param>
        /// <param name="thumbnailPath">Path to the thumbnail image on disk. Must be specified for first avatar creation</param>
        /// <param name="cancellationToken"></param>
        /// <exception cref="BuilderException">Build process has encountered an error</exception>
        /// <exception cref="BuildBlockedException">Build was blocked by the SDK Callback</exception>
        /// <exception cref="ValidationException">Content has validation errors</exception>
        /// <exception cref="OwnershipException">Current User does not own the target content</exception>
        /// <exception cref="UploadException">Content failed to upload</exception>
        [PublicAPI]
        Task BuildAndUpload(GameObject target, List<PerPlatformOverrides.Option> overrides, VRCAvatar avatar, string thumbnailPath = null, CancellationToken cancellationToken = default);
        
        /// <summary>
        /// Starts a multi-platform build chain for the VRCAvatar specified.
        /// This will automatically switch the editor to each of the supported platforms and perform a build+upload
        /// If any of the platforms encounter an error, the build chain will be stopped and the error will be thrown similar to BuildAndUpload
        /// </summary>
        /// <param name="target">The avatar GameObject to build</param>
        /// <param name="avatar">VRCAvatar object with avatar info. Must have a Name for avatar creation</param>
        /// <param name="thumbnailPath">Path to the thumbnail image on disk. Must be specified for first avatar creation</param>
        /// <param name="cancellationToken"></param>
        /// <exception cref="BuilderException">Build process has encountered an error</exception>
        /// <exception cref="BuildBlockedException">Build was blocked by the SDK Callback</exception>
        /// <exception cref="ValidationException">Content has validation errors</exception>
        /// <exception cref="OwnershipException">Current User does not own the target content</exception>
        /// <exception cref="UploadException">Content failed to upload</exception>
        /// <exception cref="BundleExistsException">This exact bundle was already uploaded</exception>
        [PublicAPI]
        Task BuildAndUploadMultiPlatform(GameObject target, VRCAvatar avatar, string thumbnailPath = null,
            CancellationToken cancellationToken = default);
        
        /// <summary>
        /// Starts a multi-platform build chain for the VRCAvatar specified.
        /// This will automatically switch the editor to each of the supported platforms and perform a build+upload
        /// The overrides list will be used to swap the target avatar GameObject depending on the platform
        /// If any of the platforms encounter an error, the build chain will be stopped and the error will be thrown similar to BuildAndUpload
        /// </summary>
        /// <param name="target">The avatar GameObject to build</param>
        /// <param name="overrides">A list of per-platform overrides to use during the build</param>
        /// <param name="avatar">VRCAvatar object with avatar info. Must have a Name for avatar creation</param>
        /// <param name="thumbnailPath">Path to the thumbnail image on disk. Must be specified for first avatar creation</param>
        /// <param name="cancellationToken"></param>
        /// <exception cref="BuilderException">Build process has encountered an error</exception>
        /// <exception cref="BuildBlockedException">Build was blocked by the SDK Callback</exception>
        /// <exception cref="ValidationException">Content has validation errors</exception>
        /// <exception cref="OwnershipException">Current User does not own the target content</exception>
        /// <exception cref="UploadException">Content failed to upload</exception>
        /// <exception cref="BundleExistsException">This exact bundle was already uploaded</exception>
        [PublicAPI]
        Task BuildAndUploadMultiPlatform(GameObject target, List<PerPlatformOverrides.Option> overrides, VRCAvatar avatar, string thumbnailPath = null,
            CancellationToken cancellationToken = default);
        
        /// <summary>
        /// Builds the provided avatar GameObject and adds it to the test avatar list
        /// </summary>
        /// <param name="target">The avatar GameObject to build</param>
        /// <exception cref="BuilderException">Build process has encountered an error</exception>
        /// <exception cref="BuildBlockedException">Build was blocked by the SDK Callback</exception>
        /// <exception cref="ValidationException">Content has validation errors</exception>
        [PublicAPI]
        Task BuildAndTest(GameObject target);
    }
}