#if VRC_SDK_VRCSDK3
using System;
using System.Collections.Generic;
using System.Text;
using UnityEditor;
using UnityEngine;
using VRC.SDK3.Avatars.Components;
using VRC.SDKBase;

[CustomEditor(typeof(VRCAnimatorPlayAudio), true)]
public class VRC_AnimatorPlayAudioEditor : UnityEditor.Editor
{
	string[] parameterNames;
	private SerializedProperty sourcePath;
	private SerializedProperty playbackOrder;
	private SerializedProperty parameterName;
	private SerializedProperty pitch;
	private SerializedProperty pitchMin;
	private SerializedProperty pitchMax;
	private SerializedProperty pitchApplySettings;
	private SerializedProperty volume;
	private SerializedProperty volumeMin;
	private SerializedProperty volumeMax;
	private SerializedProperty volumeApplySettings;
	private SerializedProperty clips;
	private SerializedProperty clipsApplySettings;
	private SerializedProperty delayInSeconds;
	private SerializedProperty loop;
	private SerializedProperty loopApplySettings;
	private SerializedProperty stopOnEnter;
	private SerializedProperty playOnEnter;
	private SerializedProperty stopOnExit;
	private SerializedProperty playOnExit;

	private void OnEnable()
	{
		sourcePath = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.SourcePath));
		playbackOrder = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.PlaybackOrder));
		parameterName = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.ParameterName));
		pitch = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.Pitch));
		pitchMin = pitch.FindPropertyRelative("x");
		pitchMax = pitch.FindPropertyRelative("y");
		pitchApplySettings = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.PitchApplySettings));
		volume = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.Volume));
		volumeMin = volume.FindPropertyRelative("x");
		volumeMax = volume.FindPropertyRelative("y");
		volumeApplySettings = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.VolumeApplySettings));
		clips = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.Clips));
		clipsApplySettings = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.ClipsApplySettings));
		delayInSeconds = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.DelayInSeconds));
		loop = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.Loop));
		loopApplySettings = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.LoopApplySettings));
		stopOnEnter = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.StopOnEnter));
		playOnEnter = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.PlayOnEnter));
		stopOnExit = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.StopOnExit));
		playOnExit = serializedObject.FindProperty(nameof(VRCAnimatorPlayAudio.PlayOnExit));
	}

	// Stolen from VRCUtils
	private string GetRelativePath(Transform t, Transform haltAt = null)
	{
		if (haltAt == t)
			return "";
		string path = t.name;
		for (Transform cur = t.parent; cur != null && cur != haltAt; cur = cur.parent)
			path = cur.name + "/" + path;
		return haltAt == null ? "/" + path : path;
	}

	// Stolen from VRCAvatarParameterDriverEditor
	int DrawParamaterDropdown(SerializedProperty name, string label)
	{
		//Name
		EditorGUILayout.BeginHorizontal();
		EditorGUILayout.PrefixLabel(label);
		var index = -1;
		if (parameterNames != null)
		{
			//Find index
			EditorGUI.BeginChangeCheck();
			index = Array.IndexOf(parameterNames, name.stringValue);
			index = EditorGUILayout.Popup(index, parameterNames);
			if (EditorGUI.EndChangeCheck() && index >= 0)
				name.stringValue = parameterNames[index];
		}
		name.stringValue = EditorGUILayout.TextField(name.stringValue);
		EditorGUILayout.EndHorizontal();

		if (index < 0)
			EditorGUILayout.HelpBox($"Parameter '{name.stringValue}' not found. Make sure you defined in the Animator window's Parameters tab.", MessageType.Warning);

		return index;
	}

	void UpdateParameters()
	{
		//Build parameter names
		var controller = GetCurrentController();
		if (controller != null)
		{
			//Standard
			List<string> names = new List<string>();
			foreach (var item in controller.parameters)
			{
				if(item.type == AnimatorControllerParameterType.Int) names.Add(item.name);
			}
			parameterNames = names.ToArray();
		}
	}

	static UnityEditor.Animations.AnimatorController GetCurrentController()
	{
		UnityEditor.Animations.AnimatorController controller = null;
		var toolType = Type.GetType("UnityEditor.Graphs.AnimatorControllerTool, UnityEditor.Graphs");
		var tool = EditorWindow.GetWindow(toolType);
		var controllerProperty = toolType.GetProperty("animatorController", System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);
		if (controllerProperty != null)
		{
			controller = controllerProperty.GetValue(tool, null) as UnityEditor.Animations.AnimatorController;
		}
		else
			Debug.LogError("Unable to find animator window.", tool);
		return controller;
	}


	public override void OnInspectorGUI()
	{
		serializedObject.Update();
		//Update parameters
		if (parameterNames == null)
			UpdateParameters();

		EditorGUILayout.Space();
		EditorGUILayout.LabelField("Drag & drop your AudioSource below to automatically fill the path relative to the avatar root.");
		using (var check = new EditorGUI.ChangeCheckScope())
		{
			AudioSource source = (AudioSource)EditorGUILayout.ObjectField("", null, typeof(AudioSource), true);
			if (check.changed)
			{
				VRCAvatarDescriptor descriptor = source.GetComponentInParent<VRCAvatarDescriptor>();
				if (descriptor != null)
				{
					sourcePath.stringValue = GetRelativePath(source.transform, descriptor.transform);
				}
				else
				{
					Debug.LogError("This audio source is not part of the hierarchy of an avatar with a valid descriptor.");
				}
			}
		}
		EditorGUILayout.PropertyField(sourcePath);
		EditorGUILayout.Space(16);
		EditorGUILayout.LabelField("AudioClips", EditorStyles.boldLabel);
		using (new EditorGUILayout.HorizontalScope())
		{
			using (new EditorGUI.DisabledScope(clipsApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.NeverApply))
			{
				EditorGUILayout.PropertyField(playbackOrder);
			}
			EditorGUILayout.PropertyField(clipsApplySettings, GUIContent.none, GUILayout.Width(150));
		}
		if(playbackOrder.intValue == (int)VRCAnimatorPlayAudio.Order.Parameter)
		{
			EditorGUILayout.HelpBox("Select an 'Int' avatar parameter below. The value of this parameter will determine which clip is selected.", MessageType.Info);
			DrawParamaterDropdown(parameterName, "Parameter Name");
		}

		using (new EditorGUI.DisabledScope(clipsApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.NeverApply))
		{
			EditorGUILayout.PropertyField(clips);
		}

		EditorGUILayout.Space(16);
		EditorGUILayout.LabelField("AudioSource settings", EditorStyles.boldLabel);
		using (new EditorGUILayout.HorizontalScope())
		{
			using (new EditorGUI.DisabledScope(volumeApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.NeverApply))
			{
				EditorGUILayout.LabelField("Random Volume", GUILayout.MinWidth(100));
				EditorGUILayout.LabelField("Min", GUILayout.Width(25));
				volumeMin.floatValue = Mathf.Clamp(EditorGUILayout.FloatField(volumeMin.floatValue), 0, 1);
				EditorGUILayout.LabelField("Max", GUILayout.Width(25));
				volumeMax.floatValue = Mathf.Clamp(EditorGUILayout.FloatField(volumeMax.floatValue), 0, 1);
			}

			EditorGUILayout.PropertyField(volumeApplySettings, GUIContent.none);
		}
		using (new EditorGUILayout.HorizontalScope())
		{
			using (new EditorGUI.DisabledScope(pitchApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.NeverApply))
			{
				EditorGUILayout.LabelField("Random Pitch", GUILayout.MinWidth(100));
				EditorGUILayout.LabelField("Min", GUILayout.Width(25));
				pitchMin.floatValue = Mathf.Clamp(EditorGUILayout.FloatField(pitchMin.floatValue), -3, 3);
				EditorGUILayout.LabelField("Max", GUILayout.Width(25));
				pitchMax.floatValue = Mathf.Clamp(EditorGUILayout.FloatField(pitchMax.floatValue), -3, 3);
			}
			EditorGUILayout.PropertyField(pitchApplySettings, GUIContent.none);
		}
		using (new EditorGUILayout.HorizontalScope())
		{
			using (new EditorGUI.DisabledScope(loopApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.NeverApply))
			{
				EditorGUILayout.LabelField("Loop", GUILayout.MinWidth(100));
				EditorGUILayout.PropertyField(loop, GUIContent.none);
			}
			EditorGUILayout.PropertyField(loopApplySettings, GUIContent.none);
		}
		
		EditorGUILayout.Space(16);
		EditorGUILayout.LabelField("Play settings", EditorStyles.boldLabel);

		using (new EditorGUILayout.HorizontalScope())
		{
			EditorGUILayout.PrefixLabel(" ");
			EditorGUILayout.LabelField("Stop Audio Source", "Play Audio Source");
		}
		using (new EditorGUILayout.HorizontalScope())
		{
			EditorGUILayout.PrefixLabel("On Enter");
			EditorGUILayout.PropertyField(stopOnEnter, GUIContent.none);
			EditorGUILayout.PropertyField(playOnEnter, GUIContent.none);
		}
		using (new EditorGUILayout.HorizontalScope())
		{
			EditorGUILayout.PrefixLabel("On Exit");
			EditorGUILayout.PropertyField(stopOnExit, GUIContent.none);
			EditorGUILayout.PropertyField(playOnExit, GUIContent.none);
		}
		using (new EditorGUI.DisabledScope(!playOnEnter.boolValue))
		{
			EditorGUILayout.PropertyField(delayInSeconds, new GUIContent("Play On Enter Delay In Seconds"));
			delayInSeconds.floatValue = Mathf.Clamp(delayInSeconds.floatValue, 0, 60);
		}

		if ((clipsApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.ApplyIfStopped
		    || volumeApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.ApplyIfStopped
		    || pitchApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.ApplyIfStopped
		    || loopApplySettings.intValue == (int) VRC_AnimatorPlayAudio.ApplySettings.ApplyIfStopped) && !stopOnEnter.boolValue)
		{
			EditorGUILayout.HelpBox("If the audio source has not finished playing when entering this state, settings with 'Apply If Stopped' will not be applied.", MessageType.Info);
		}
		serializedObject.ApplyModifiedProperties();
	}
}
#endif
