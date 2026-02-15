Shader "Hidden/Locked/SPSPatched/7dda7e9f9ba1185718468d95116b32d3"
{
	Properties
	{
[Header(SPS)]
_SPS_Length("World length of mesh (m)", Float) = 0
_SPS_BakedLength("World length of mesh when baked (m)", Float) = 0
_SPS_Bake("Baked mesh info", 2D) = "white" {}
_SPS_Enabled("Enabled (0-1)", Float) = 1
_SPS_Overrun("Overrun", Float) = 1
_SPS_BlendshapeVertCount("Baked blendshape vert count", Float) = 0
_SPS_BlendshapeCount("Blendshape Count", Float) = 0
_SPS_Blendshape0("Blendshape 0", Float) = 0
_SPS_Blendshape1("Blendshape 1", Float) = 0
_SPS_Blendshape2("Blendshape 2", Float) = 0
_SPS_Blendshape3("Blendshape 3", Float) = 0
_SPS_Blendshape4("Blendshape 4", Float) = 0
_SPS_Blendshape5("Blendshape 5", Float) = 0
_SPS_Blendshape6("Blendshape 6", Float) = 0
_SPS_Blendshape7("Blendshape 7", Float) = 0
_SPS_Blendshape8("Blendshape 8", Float) = 0
_SPS_Blendshape9("Blendshape 9", Float) = 0
_SPS_Blendshape10("Blendshape 10", Float) = 0
_SPS_Blendshape11("Blendshape 11", Float) = 0
_SPS_Blendshape12("Blendshape 12", Float) = 0
_SPS_Blendshape13("Blendshape 13", Float) = 0
_SPS_Blendshape14("Blendshape 14", Float) = 0
_SPS_Blendshape15("Blendshape 15", Float) = 0

_SPS_Plus_Enabled("_SPS_Plus_Enabled", Float) = 0
_SPS_Plus_Ring("_SPS_Plus_Ring", Float) = 0
_SPS_Plus_Hole("_SPS_Plus_Hole", Float) = 0


		[HideInInspector] shader_master_label ("<color=#E75898ff>Poiyomi 8.1.167</color>", Float) = 0
		[HideInInspector] shader_is_using_thry_editor ("", Float) = 0
		[HideInInspector] shader_locale ("0db0b86376c3dca4b9a6828ef8615fe0", Float) = 0
		[HideInInspector] footer_youtube ("{texture:{name:icon-youtube,height:16},action:{type:URL,data:https://www.youtube.com/poiyomi},hover:YOUTUBE}", Float) = 0
		[HideInInspector] footer_twitter ("{texture:{name:icon-twitter,height:16},action:{type:URL,data:https://twitter.com/poiyomi},hover:TWITTER}", Float) = 0
		[HideInInspector] footer_patreon ("{texture:{name:icon-patreon,height:16},action:{type:URL,data:https://www.patreon.com/poiyomi},hover:PATREON}", Float) = 0
		[HideInInspector] footer_discord ("{texture:{name:icon-discord,height:16},action:{type:URL,data:https://discord.gg/Ays52PY},hover:DISCORD}", Float) = 0
		[HideInInspector] footer_github ("{texture:{name:icon-github,height:16},action:{type:URL,data:https://github.com/poiyomi/PoiyomiToonShader},hover:GITHUB}", Float) = 0
		[Header(POIYOMI SHADER UI FAILED TO LOAD)]
		[Header(.    This is caused by scripts failing to compile. It can be fixed.)]
		[Header(.          The inspector will look broken and will not work properly until fixed.)]
		[Header(.    Please check your console for script errors.)]
		[Header(.          You can filter by errors in the console window.)]
		[Header(.          Often the topmost error points to the erroring script.)]
		[Space(30)][Header(Common Error Causes)]
		[Header(.    Installing multiple Poiyomi Shader packages)]
		[Header(.          Make sure to delete the Poiyomi shader folder before you update Poiyomi.)]
		[Header(.          If a package came with Poiyomi this is bad practice and can cause issues.)]
		[Header(.          Delete the package and import it without any Poiyomi components.)]
		[Header(.    Bad VRCSDK installation (e.g. Both VCC and Standalone))]
		[Header(.          Delete the VRCSDK Folder in Assets if you are using the VCC.)]
		[Header(.          Avoid using third party SDKs. They can cause incompatibility.)]
		[Header(.    Script Errors in other scripts)]
		[Header(.          Outdated tools or prefabs can cause this.)]
		[Header(.          Update things that are throwing errors or move them outside the project.)]
		[Space(30)][Header(Visit Our Discord to Ask For Help)]
		[Space(5)]_ShaderUIWarning0 (" → discord.gg/poiyomi ←    We can help you get it fixed!                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         --{condition_showS:(0==1)}", Int) = -0
		[Space(1400)][Header(POIYOMI SHADER UI FAILED TO LOAD)]
		_ShaderUIWarning1 ("Please scroll up for more information!                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     --{condition_showS:(0==1)}", Int) = -0
		[HideInInspector] _ForgotToLockMaterial (";;YOU_FORGOT_TO_LOCK_THIS_MATERIAL;", Int) = 1
		[ThryShaderOptimizerLockButton] _ShaderOptimizerEnabled ("", Int) = 1
		[Helpbox(1)] _LockTooltip ("Animations don't work by default when locked in. Right click a property if you want to animate it. The shader will lock in automatically at upload time.", Int) = 0
		[HideInInspector] GeometryShader_Enabled("GEOMETRY SHADER ENABLED", Float) = 1
		[HideInInspector] Tessellation_Enabled("TESSELLATION ENABLED", Float) = 1
		[ThryWideEnum(Opaque, 0, Cutout, 1, TransClipping, 9, Fade, 2, Transparent, 3, Additive, 4, Soft Additive, 5, Multiplicative, 6, 2x Multiplicative, 7)]_Mode("Rendering Preset--{on_value_actions:[
		{value:0,actions:[{type:SET_PROPERTY,data:render_queue=2000}, {type:SET_PROPERTY,data:render_type=Opaque},            {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=0}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:1,actions:[{type:SET_PROPERTY,data:render_queue=2450}, {type:SET_PROPERTY,data:render_type=TransparentCutout}, {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=.5}, {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:9,actions:[{type:SET_PROPERTY,data:render_queue=2450}, {type:SET_PROPERTY,data:render_type=TransparentCutout}, {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=5}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=5}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=5}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:2,actions:[{type:SET_PROPERTY,data:render_queue=3000}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=5}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=5}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=5}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:3,actions:[{type:SET_PROPERTY,data:render_queue=3000}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=1}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:4,actions:[{type:SET_PROPERTY,data:render_queue=3000}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=1},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=1},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:5,actions:[{type:SET_PROPERTY,data:render_queue=3000}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=4}, {type:SET_PROPERTY,data:_DstBlend=1},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=4}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=4}, {type:SET_PROPERTY,data:_OutlineDstBlend=1},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:6,actions:[{type:SET_PROPERTY,data:render_queue=3000}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=2}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=2}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=2}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:7,actions:[{type:SET_PROPERTY,data:render_queue=3000}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=2}, {type:SET_PROPERTY,data:_DstBlend=3},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=2}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=2}, {type:SET_PROPERTY,data:_OutlineDstBlend=3},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]}
		}]}]}", Int) = 0
		[HideInInspector] m_mainCategory ("Color & Normals--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/color-and-normals/main},hover:Documentation}}", Float) = 0
		_Color ("Color & Alpha--{reference_property:_ColorThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _ColorThemeIndex ("", Int) = 0
		[sRGBWarning(true)]_MainTex ("Texture--{reference_properties:[_MainTexPan, _MainTexUV, _MainPixelMode, _MainTexStochastic]}", 2D) = "white" { }
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _MainTexUV ("UV", Int) = 0
		[HideInInspector][Vector2]_MainTexPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ToggleUI]_MainPixelMode ("Pixel Mode", Float) = 0
		[HideInInspector][ToggleUI]_MainTexStochastic ("Stochastic Sampling", Float) = 0
		[Normal]_BumpMap ("Normal Map--{reference_properties:[_BumpMapPan, _BumpMapUV, _BumpScale, _BumpMapStochastic]}", 2D) = "bump" { }
		[HideInInspector][Vector2]_BumpMapPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _BumpMapUV ("UV", Int) = 0
		[HideInInspector]_BumpScale ("Intensity", Range(0, 10)) = 1
		[HideInInspector][ToggleUI]_BumpMapStochastic ("Stochastic Sampling", Float) = 0
		[sRGBWarning]_ClippingMask ("Alpha Map--{reference_properties:[_ClippingMaskPan, _ClippingMaskUV, _Inverse_Clipping]}", 2D) = "white" { }
		[HideInInspector][Vector2]_ClippingMaskPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _ClippingMaskUV ("UV", Int) = 0
		[HideInInspector][ToggleUI]_Inverse_Clipping ("Invert", Float) = 0
		_Cutoff ("Alpha Cutoff", Range(0, 1.001)) = 0.5
		[HideInInspector] m_start_Alpha ("Alpha Options--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/color-and-normals/alpha-options},hover:Documentation}}", Float) = 0
		[ToggleUI]_AlphaForceOpaque ("Force Opaque", Float) = 0
		_AlphaMod ("Alpha Mod", Range(-1, 1)) = 0.0
		[ToggleUI]_AlphaPremultiply ("Alpha Premultiply", Float) = 0
		_AlphaBoostFA ("Boost Transparency in ForwardAdd--{condition_showS:(_AddBlendOp==4)}", Range(1, 100)) = 10
		[HideInInspector] m_start_AlphaGlobalMask ("Global Mask", Float) = 0
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _AlphaGlobalMask ("Alpha--{reference_property:_AlphaGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6 , Replace, 0)] _AlphaGlobalMaskBlendType ("Blending", Int) = 2
		[HideInInspector] m_end_AlphaGlobalMask ("Global Mask", Float) = 0
		[HideInInspector] m_end_Alpha ("Alpha Options", Float) = 0
		[HideInInspector] m_start_DecalSection ("Decals--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/color-and-normals/decals},hover:YouTube}}", Float) = 0
		[sRGBWarning]_DecalMask ("Decal RGBA Mask--{reference_properties:[_DecalMaskPan, _DecalMaskUV]}", 2D) = "white" { }
		[HideInInspector][Vector2]_DecalMaskPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _DecalMaskUV ("UV", Int) = 0
		[HideInInspector] g_start_DecalTPSMaskGroup ("--{condition_showS:(_TPSPenetratorEnabled==1)}", Float) = 0
		[ThryToggleUI(true)] _DecalTPSDepthMaskEnabled ("<size=13><b>  TPS Depth Enabled</b></size>", Float) = 0
		_Decal0TPSMaskStrength ("Mask r Strength--{condition_showS:(_DecalTPSDepthMaskEnabled==1)}", Range(0, 1)) = 1
		_Decal1TPSMaskStrength ("Mask g Strength--{condition_showS:(_DecalTPSDepthMaskEnabled==1)}", Range(0, 1)) = 1
		_Decal2TPSMaskStrength ("Mask b Strength--{condition_showS:(_DecalTPSDepthMaskEnabled==1)}", Range(0, 1)) = 1
		_Decal3TPSMaskStrength ("Mask a Strength--{condition_showS:(_DecalTPSDepthMaskEnabled==1)}", Range(0, 1)) = 1
		[HideInInspector] g_end_DecalTPSMaskGroup ("", Float) = 0
		[HideInInspector] m_end_DecalSection ("Decal", Float) = 0
		[HideInInspector] m_start_GlobalThemes ("Global Themes--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/color-and-normals/global-themes},hover:Documentation}}", Float) = 0
		[HideInInspector] m_start_GlobalThemeColor0 ("Theme Color 0", Float) = 0
		[HDR]_GlobalThemeColor0 ("Theme Color 0",       Color       ) = (1, 1, 1, 1)
		_GlobalThemeHue0        ("Hue Adjust",          Range( 0, 1)) = 0
		_GlobalThemeHueSpeed0   ("Hue Adjust Speed",    Float       ) = 0
		_GlobalThemeSaturation0 ("Saturation Adjust",   Range(-1, 1)) = 0
		_GlobalThemeValue0      ("Value Adjust",        Range(-1, 1)) = 0
		[HideInInspector] m_end_GlobalThemeColor0   ("Theme Color 0", Float) = 0
		[HideInInspector] m_start_GlobalThemeColor1 ("Theme Color 1", Float) = 0
		[HDR]_GlobalThemeColor1 ("Theme Color 1",       Color       ) = (1, 1, 1, 1)
		_GlobalThemeHue1        ("Hue Adjust",          Range( 0, 1)) = 0
		_GlobalThemeHueSpeed1   ("Hue Adjust Speed",    Float       ) = 0
		_GlobalThemeSaturation1 ("Saturation Adjust",   Range(-1, 1)) = 0
		_GlobalThemeValue1      ("Value Adjust",        Range(-1, 1)) = 0
		[HideInInspector] m_end_GlobalThemeColor1   ("Theme Color 1", Float) = 0
		[HideInInspector] m_start_GlobalThemeColor2 ("Theme Color 2", Float) = 0
		[HDR]_GlobalThemeColor2 ("Theme Color 2",       Color       ) = (1, 1, 1, 1)
		_GlobalThemeHue2        ("Hue Adjust",          Range( 0, 1)) = 0
		_GlobalThemeHueSpeed2   ("Hue Adjust Speed",    Float       ) = 0
		_GlobalThemeSaturation2 ("Saturation Adjust",   Range(-1, 1)) = 0
		_GlobalThemeValue2      ("Value Adjust",        Range(-1, 1)) = 0
		[HideInInspector] m_end_GlobalThemeColor2   ("Theme Color 2", Float) = 0
		[HideInInspector] m_start_GlobalThemeColor3 ("Theme Color 3", Float) = 0
		[HDR]_GlobalThemeColor3 ("Theme Color 3",       Color       ) = (1, 1, 1, 1)
		_GlobalThemeHue3        ("Hue Adjust",          Range( 0, 1)) = 0
		_GlobalThemeHueSpeed3   ("Hue Adjust Speed",    Float       ) = 0
		_GlobalThemeSaturation3 ("Saturation Adjust",   Range(-1, 1)) = 0
		_GlobalThemeValue3      ("Value Adjust",        Range(-1, 1)) = 0
		[HideInInspector] m_end_GlobalThemeColor3   ("Theme Color 3", Float) = 0
		[HideInInspector] m_end_GlobalThemes ("Global Themes", Float ) = 0
		[HideInInspector] m_start_GlobalMask ("Global Mask", Float) = 0
		[HideInInspector] m_start_GlobalMaskModifiers ("Modifiers", Float) = 0
		[HideInInspector] m_end_GlobalMaskModifiers ("", Float) = 0
		[HideInInspector] m_end_GlobalMask ("Global Mask", Float) = 0
		[HideInInspector] m_lightingCategory ("Shading", Float) = 0
		[HideInInspector] m_start_PoiLightData ("Light Data--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/light-data},hover:Documentation}}", Float) = 0
		[sRGBWarning]_LightingAOMaps ("AO Maps (expand)--{reference_properties:[_LightingAOMapsPan, _LightingAOMapsUV,_LightDataAOStrengthR,_LightDataAOStrengthG,_LightDataAOStrengthB,_LightDataAOStrengthA, _LightDataAOGlobalMaskR]}", 2D) = "white" { }
		[HideInInspector][Vector2]_LightingAOMapsPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _LightingAOMapsUV ("UV", Int) = 0
		[HideInInspector]_LightDataAOStrengthR ("R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightDataAOStrengthG ("G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightDataAOStrengthB ("B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightDataAOStrengthA ("A Strength", Range(0, 1)) = 0
		[HideInInspector][ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _LightDataAOGlobalMaskR ("Global Mask--{reference_property:_LightDataAOGlobalMaskBlendTypeR}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6 , Replace, 0)] _LightDataAOGlobalMaskBlendTypeR ("Blending", Range(0, 1)) = 2
		[sRGBWarning]_LightingDetailShadowMaps ("Detail Shadows (expand)--{reference_properties:[_LightingDetailShadowMapsPan, _LightingDetailShadowMapsUV,_LightingDetailShadowStrengthR,_LightingDetailShadowStrengthG,_LightingDetailShadowStrengthB,_LightingDetailShadowStrengthA,_LightingAddDetailShadowStrengthR,_LightingAddDetailShadowStrengthG,_LightingAddDetailShadowStrengthB,_LightingAddDetailShadowStrengthA, _LightDataDetailShadowGlobalMaskR]}", 2D) = "white" { }
		[HideInInspector][Vector2]_LightingDetailShadowMapsPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _LightingDetailShadowMapsUV ("UV", Int) = 0
		[HideInInspector]_LightingDetailShadowStrengthR ("R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightingDetailShadowStrengthG ("G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingDetailShadowStrengthB ("B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingDetailShadowStrengthA ("A Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingAddDetailShadowStrengthR ("Additive R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightingAddDetailShadowStrengthG ("Additive G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingAddDetailShadowStrengthB ("Additive B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingAddDetailShadowStrengthA ("Additive A Strength", Range(0, 1)) = 0
		[HideInInspector][ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _LightDataDetailShadowGlobalMaskR ("Global Mask--{reference_property:_LightDataDetailShadowGlobalMaskBlendTypeR}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6 , Replace, 0)] _LightDataDetailShadowGlobalMaskBlendTypeR ("Blending", Range(0, 1)) = 2
		[sRGBWarning]_LightingShadowMasks ("Shadow Masks (expand)--{reference_properties:[_LightingShadowMasksPan, _LightingShadowMasksUV,_LightingShadowMaskStrengthR,_LightingShadowMaskStrengthG,_LightingShadowMaskStrengthB,_LightingShadowMaskStrengthA, _LightDataShadowMaskGlobalMaskR]}", 2D) = "white" { }
		[HideInInspector][Vector2]_LightingShadowMasksPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _LightingShadowMasksUV ("UV", Int) = 0
		[HideInInspector]_LightingShadowMaskStrengthR ("R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightingShadowMaskStrengthG ("G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingShadowMaskStrengthB ("B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingShadowMaskStrengthA ("A Strength", Range(0, 1)) = 0
		[HideInInspector][ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _LightDataShadowMaskGlobalMaskR ("Global Mask--{reference_property:_LightDataShadowMaskGlobalMaskBlendTypeR}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6 , Replace, 0)] _LightDataShadowMaskGlobalMaskBlendTypeR ("Blending", Range(0, 1)) = 2
		[Space(15)]
		[ThryHeaderLabel(Base Pass Lighting, 13)]
		[Space(4)]
		[Enum(Poi Custom, 0, Standard, 1, UTS2, 2, OpenLit(lil toon), 3)] _LightingColorMode ("Light Color Mode", Int) = 0
		[Enum(Poi Custom, 0, Normalized NDotL, 1, Saturated NDotL, 2)] _LightingMapMode ("Light Map Mode", Int) = 0
		[Enum(Poi Custom, 0, Forced Local Direction, 1, Forced World Direction, 2, UTS2, 3, OpenLit(lil toon), 4)] _LightingDirectionMode ("Light Direction Mode", Int) = 0
		[Vector3]_LightngForcedDirection ("Forced Direction--{condition_showS:(_LightingDirectionMode==1 || _LightingDirectionMode==2)}", Vector) = (0, 0, 0)
		[ToggleUI]_LightingForceColorEnabled ("Force Light Color", Float) = 0
		_LightingForcedColor ("Forced Color--{condition_showS:(_LightingForceColorEnabled==1), reference_property:_LightingForcedColorThemeIndex}", Color) = (1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _LightingForcedColorThemeIndex ("", Int) = 0
		_Unlit_Intensity ("Unlit_Intensity--{condition_showS:(_LightingColorMode==2)}", Range(0.001, 4)) = 1
		[ToggleUI]_LightingCapEnabled ("Limit Brightness", Float) = 1
		_LightingCap ("Max Brightness--{condition_showS:(_LightingCapEnabled==1)}", Range(0, 10)) = 1
		_LightingMinLightBrightness ("Min Brightness", Range(0, 1)) = 0
		_LightingIndirectUsesNormals ("Indirect Uses Normals--{condition_showS:(_LightingColorMode==0)}", Range(0, 1)) = 0
		_LightingCastedShadows ("Receive Casted Shadows", Range(0, 1)) = 0
		_LightingMonochromatic ("Grayscale Lighting", Range(0, 1)) = 0
		[Space(15)]
		[ThryHeaderLabel(Add Pass Lighting(Realtime), 13)]
		[Space(4)]
		[ToggleUI]_LightingVertexLightingEnabled ("Vertex lights (Non-Important)", Float) = 1
		[ToggleUI]_LightingAdditiveEnable ("Pixel lights (Important)", Float) = 1
		[ToggleUI]_DisableDirectionalInAdd ("Ignore Directional--{condition_showS:(_LightingAdditiveEnable==1)}", Float) = 1
		[ToggleUI]_LightingAdditiveLimited ("Limit Brightness", Float) = 0
		_LightingAdditiveLimit ("Max Brightness--{condition_showS:(_LightingAdditiveLimited==1)}", Range(0, 10)) = 1
		_LightingAdditiveCastedShadows ("Receive Casted Shadows", Range(0, 1)) = 1
		_LightingAdditiveMonochromatic ("Grayscale Lighting", Range(0, 1)) = 0
		_LightingAdditivePassthrough ("Point Light Passthrough--{condition_showS:(_LightingAdditiveEnable==1)}", Range(0, 1)) = .5
		[Space(15)]
		[ThryHeaderLabel(Debug Visualization, 13)]
		[Space(4)]
		[NoAnimate][ThryToggleUI(false)]_LightDataDebugEnabled ("Debug", Float) = 0
		[ThryWideEnum(Direct Color, 0, Indirect Color, 1, Light Map, 2, Attenuation, 3, N Dot L, 4, Half Dir, 5, Direction, 6, Add Color, 7, Add Attenuation, 8, Add Shadow, 9, Add N Dot L, 10)] _LightingDebugVisualize ("Visualize--{condition_showS:(_LightDataDebugEnabled==1)}", Int) = 0
		[HideInInspector] m_end_PoiLightData ("Light Data", Float) = 0
		[HideInInspector] m_start_PoiShading (" Shading--{reference_property:_ShadingEnabled,button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/main},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(VIGNETTE_MASKED)]_ShadingEnabled ("Enable Shading", Float) = 1
		[ThryHeaderLabel(Base Pass Shading, 13)]
		[Space(4)]
		[KeywordEnum(TextureRamp, Multilayer Math, Wrapped, Skin, ShadeMap, Flat, Realistic, Cloth, SDF)] _LightingMode ("Lighting Type", Float) = 5
		_LightingShadowColor ("Shadow Tint--{condition_showS:(_LightingMode!=4 && _LightingMode!=1 && _LightingMode!=5)}", Color) = (1, 1, 1)
		_ShadowStrength ("Shadow Strength--{condition_showS:(_LightingMode<=4 || _LightingMode==8)}", Range(0, 1)) = 1
		_LightingIgnoreAmbientColor ("Ignore Indirect Shadow Color--{condition_showS:(_LightingMode<=3 || _LightingMode==8)}", Range(0, 1)) = 1
		[Space(15)]
		[ThryHeaderLabel(Add Pass Shading, 13)]
		[Space(4)]
		[Enum(Realistic, 0, Toon, 1, Same as Base Pass, 3)] _LightingAdditiveType ("Lighting Type", Int) = 1
		_LightingAdditiveGradientStart ("Gradient Start--{condition_showS:(_LightingAdditiveType==1)}", Range(0, 1)) = 0
		_LightingAdditiveGradientEnd ("Gradient End--{condition_showS:(_LightingAdditiveType==1)}", Range(0, 1)) = .5
		[HideInInspector] m_end_PoiShading ("Shading", Float) = 0
		[HideInInspector] m_start_matcap ("Matcap 0--{reference_property:_MatcapEnable,button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/matcap},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(POI_MATCAP0)]_MatcapEnable ("Enable Matcap", Float) = 0
		[ThryWideEnum(UTS Style, 0, Top Pinch, 1, Double Sided, 2)] _MatcapUVMode ("UV Mode", Int) = 1
		_MatcapColor ("Color--{reference_property:_MatcapColorThemeIndex}", Color) = (1, 1, 1, 1)
		_MatcapBaseColorMix ("Base Color Mix", Range(0, 1)) = 0
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _MatcapColorThemeIndex ("", Int) = 0
		[sRGBWarning(true)]_Matcap ("Matcap--{reference_properties:[_MatcapUVToBlend, _MatCapBlendUV1]}", 2D) = "white" { }
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _MatcapUVToBlend ("UV To Blend", Int) = 1
		[HideInInspector][VectorToSliders(Blend UV X, 0.0, 1.0, Blend UV Y, 0.0, 1.0)]_MatCapBlendUV1 ("UV Blend", Vector) = (0, 0, 0, 0)
		_MatcapBorder ("Border", Range(0, 5)) = 0.43
		_MatcapRotation ("Rotation", Range(-1, 1)) = 0
		[sRGBWarning]_MatcapMask ("Mask--{reference_properties:[_MatcapMaskPan, _MatcapMaskUV, _MatcapMaskChannel, _MatcapMaskInvert]}", 2D) = "white" { }
		[HideInInspector][Vector2]_MatcapMaskPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _MatcapMaskUV ("UV", Int) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3)]_MatcapMaskChannel ("Channel", Float) = 0
		[HideInInspector][ToggleUI]_MatcapMaskInvert ("Invert", Float) = 0
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MatcapMaskGlobalMask ("Global Mask--{reference_property:_MatcapMaskGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6 , Replace, 0)]_MatcapMaskGlobalMaskBlendType ("Blending", Range(0, 1)) = 2
		_MatcapEmissionStrength ("Emission Strength", Range(0, 20)) = 0
		_MatcapIntensity ("Intensity", Range(0, 5)) = 1
		_MatcapLightMask ("Hide in Shadow", Range(0, 1)) = 0
		_MatcapReplace ("Replace Blend", Range(0, 1)) = 1
		_MatcapMultiply ("Multiply Blend", Range(0, 1)) = 0
		_MatcapAdd ("Add Blend", Range(0, 1)) = 0
		_MatcapMixed ("Mixed Blend", Range(0, 1)) = 0
		_MatcapScreen ("Screen Blend", Range(0, 1)) = 0
		_MatcapAddToLight ("Add To Light", Range(0, 1)) = 0
		_MatcapAlphaOverride ("Override Alpha", Range(0, 1)) = 0
		[Enum(Vertex, 0, Pixel, 1)] _MatcapNormal ("Normal to use", Int) = 1
		[ThryToggle(POI_MATCAP0_CUSTOM_NORMAL, true)] _Matcap0CustomNormal ("<size=13><b>  Custom Normal</b></size>", Float) = 0
		[Normal]_Matcap0NormalMap ("Normal Map--{reference_properties:[_Matcap0NormalMapPan, _Matcap0NormalMapUV, _Matcap0NormalMapScale], condition_showS:(_Matcap0CustomNormal==1)}", 2D) = "bump" { }
		[HideInInspector][Vector2]_Matcap0NormalMapPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _Matcap0NormalMapUV ("UV", Int) = 0
		[HideInInspector]_Matcap0NormalMapScale ("Intensity", Range(0, 10)) = 1
		[ThryToggleUI(true)] _MatcapHueShiftEnabled ("<size=13><b>  Hue Shift</b></size>", Float) = 0
		_MatcapHueShiftSpeed ("Shift Speed--{condition_showS:(_MatcapHueShiftEnabled==1)}", Float) = 0
		_MatcapHueShift ("Hue Shift--{condition_showS:(_MatcapHueShiftEnabled==1)}", Range(0, 1)) = 0
		[ThryToggleUI(true)] _MatcapSmoothnessEnabled ("<size=13><b>  Blur</b></size>", Float) = 0
		_MatcapSmoothness ("Smoothness--{condition_showS:(_MatcapSmoothnessEnabled==1)}", Range(0, 1)) = 1
		[ToggleUI]_MatcapMaskSmoothnessApply ("Apply Mask for Smoothness--{condition_showS:(_MatcapSmoothnessEnabled==1)}", Float) = 0
		[Enum(R, 0, G, 1, B, 2, A, 3)]_MatcapMaskSmoothnessChannel ("Mask Channel for Smoothness--{condition_showS:(_MatcapSmoothnessEnabled==1)}", Int) = 3
		[HideInInspector] g_start_MatcapTPSMaskGroup ("--{condition_showS:(_TPSPenetratorEnabled==1)}", Float) = 0
		[ThryToggleUI(true)] _MatcapTPSDepthEnabled ("<size=13><b>  TPS Depth Mask Enabled</b></size>", Float) = 0
		_MatcapTPSMaskStrength ("TPS Mask Strength--{condition_showS:(_MatcapTPSDepthEnabled==1)}", Range(0, 1)) = 1
		[HideInInspector] g_end_MatcapTPSMaskGroup ("", Float) = 0
		[HideInInspector] m_end_matcap ("Matcap--{condition_showS:(_MatcapHueShiftEnabled==1)}", Float) = 0
		[HideInInspector] m_start_rimLight1Options ("Rim Lighting 1--{reference_property:_EnableRimLighting,button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/rim-lighting},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(_GLOSSYREFLECTIONS_OFF)]_EnableRimLighting ("Enable Rim Lighting", Float) = 0
		[KeywordEnum(Poiyomi, UTS2, LilToon)] _RimStyle ("Style", Float) = 0
		[sRGBWarning(true)]_RimTex ("Rim Texture--{reference_properties:[_RimTexPan, _RimTexUV], condition_showS:_RimStyle==0}", 2D) = "white" { }
		[HideInInspector][Vector2]_RimTexPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _RimTexUV ("UV", Int) = 0
		[sRGBWarning]_RimMask ("Mask & Bias--{reference_properties:[_RimMaskPan, _RimMaskUV, _RimMaskChannel, _RimMaskInvert, _RimBiasIntensity], condition_showS:_RimStyle==0}", 2D) = "white" { }
		[HideInInspector][Vector2]_RimMaskPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _RimMaskUV ("UV", Int) = 0
		[HideInInspector][ToggleUI]_RimMaskInvert("Invert Mask", Float) = 0
		[HideInInspector]_RimBiasIntensity("Bias Intensity", Range(0,1)) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3)]_RimMaskChannel ("Channel", Float) = 0
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _RimGlobalMask ("Global Mask--{reference_property:_RimGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Replace, 0, Multiply, 2, Screen, 6, Linear Dodge(Add), 8, Overlay, 9, Mixed, 20)] _RimGlobalMaskBlendType ("Blending", Int) = 2
		_Is_NormalMapToRimLight ("Normal Strength", Range(0, 1)) = 1
		[ToggleUI]_RimLightingInvert ("Invert Rim Lighting--{ condition_showS:_RimStyle==0}", Float) = 0
		_RimLightColor ("Rim Color--{condition_showS:_RimStyle==0||_RimStyle==1,reference_property:_RimLightColorThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _RimLightColorThemeIndex ("", Int) = 0
		_RimWidth ("Rim Width--{ condition_showS:_RimStyle==0}", Range(0, 1)) = 0.8
		_RimSharpness ("Rim Sharpness--{ condition_showS:_RimStyle==0}", Range(0, 1)) = .25
		_RimPower ("Rim Power--{ condition_showS:_RimStyle==0}", Range(0, 10)) = 1
		_RimStrength ("Rim Emission--{ condition_showS:_RimStyle==0}", Range(0, 20)) = 0
		_RimBaseColorMix ("Mix Base Color--{ condition_showS:_RimStyle==0}", Range(0, 1)) = 0
		[ThryWideEnum(Add, 0, Replace, 1, Multiply, 2, Mixed, 3)] _RimBlendMode ("Blend Mode--{ condition_showS:_RimStyle==0}", Int) = 0
		_RimBrightness ("Brightness--{ condition_showS:_RimStyle==0}", Range(0, 10)) = 1
		_RimBlendStrength ("Blend Strength--{ condition_showS:_RimStyle==0}", Range(0, 1)) = 1
		[ThryToggle(false)] _RimClamp ("Clamp Intensity", Float) = 0
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _RimApplyGlobalMaskIndex ("Apply to Global Mask--{reference_property:_RimApplyGlobalMaskBlendType,condition_showS:_RimStyle==0}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6 , Replace, 0)] _RimApplyGlobalMaskBlendType ("Blending", Int) = 2
		[sRGBWarning]_Set_RimLightMask ("Set_RimLightMask--{reference_properties:[_Set_RimLightMaskPan, _Set_RimLightMaskUV, _Set_RimLightMaskChannel], condition_showS:_RimStyle==1}", 2D) = "white" { }
		[HideInInspector][Vector2]_Set_RimLightMaskPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _Set_RimLightMaskUV ("UV", Int) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3)]_Set_RimLightMaskChannel ("Channel", Float) = 1
		_Tweak_RimLightMaskLevel ("Tweak_RimLightMaskLevel--{ condition_showS:_RimStyle==1}", Range(-1, 1)) = 0
		_Is_LightColor_RimLight ("Mix Light Color--{ condition_showS:_RimStyle==1}", Range(0, 1)) = 1
		_RimLight_Power ("Rim Power--{ condition_showS:_RimStyle==1}", Range(0, 1)) = 0.1
		_RimLight_InsideMask ("Inside Mask--{ condition_showS:_RimStyle==1}", Range(0.0001, 1)) = 0.0001
		[Toggle(_)] _RimLight_FeatherOff ("Feather Off--{ condition_showS:_RimStyle==1}", Float) = 0
		[ThryToggleUI(true)] _LightDirection_MaskOn ("<size=13><b>  Light Direction Mask</b></size>--{ condition_showS:_RimStyle==1}", Float) = 0
		_Tweak_LightDirection_MaskLevel ("Light Dir Mask Level--{ condition_showS:_LightDirection_MaskOn==1&&_RimStyle==1}", Range(0, 0.5)) = 0
		[ThryToggleUI(true)] _Add_Antipodean_RimLight ("<size=13><b>  Antipodean(Ap) Rim</b></size>--{ condition_showS:_LightDirection_MaskOn==1&&_RimStyle==1}", Float) = 0
		_Is_LightColor_Ap_RimLight ("Ap Light Color Mix--{ condition_showS:_LightDirection_MaskOn==1&&_Add_Antipodean_RimLight==1&&_RimStyle==1}", Range(0, 1)) = 1
		_Ap_RimLightColor ("Ap Color--{reference_property:_RimApColorThemeIndex, condition_showS:_LightDirection_MaskOn==1&&_Add_Antipodean_RimLight==1&&_RimStyle==1}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _RimApColorThemeIndex ("", Int) = 0
		_Ap_RimLight_Power ("Ap Power--{ condition_showS:_LightDirection_MaskOn==1&&_Add_Antipodean_RimLight==1&&_RimStyle==1}", Range(0, 1)) = 0.1
		[Toggle(_)] _Ap_RimLight_FeatherOff ("Ap Feather Off--{ condition_showS:_LightDirection_MaskOn==1&&_Add_Antipodean_RimLight==1&&_RimStyle==1}", Float) = 0
		[HDR][Gamma]_RimColor ("Rim Color--{condition_showS:_RimStyle==2,reference_property:_RimLightColorThemeIndex}", Color) = (0.66,0.5,0.48,1)
		[sRGBWarning(true)] _RimColorTex ("Texture--{condition_showS:_RimStyle==2,reference_properties:[_RimColorTexPan, _RimColorTexUV]}", 2D) = "white" {}
		[HideInInspector][Vector2] _RimColorTexPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)] _RimColorTexUV ("UV", Int) = 0
		_RimMainStrength ("Main Color Blend--{condition_showS:_RimStyle==2}", Range(0, 1)) = 0
		_RimNormalStrength ("Normal Strength--{condition_showS:_RimStyle==2}", Range(0, 1)) = 1.0
		_RimBorder ("Border--{condition_showS:_RimStyle==2}", Range(0, 1)) = 0.5
		_RimBlur ("Blur--{condition_showS:_RimStyle==2}", Range(0, 1)) = 0.65
		[PowerSlider(3.0)]_RimFresnelPower ("Fresnel Power--{condition_showS:_RimStyle==2}", Range(0.01, 50)) = 3.5
		_RimEnableLighting ("Enable Lighting--{condition_showS:_RimStyle==2}", Range(0, 1)) = 1
		_RimShadowMask ("Shadow Mask--{condition_showS:_RimStyle==2}", Range(0, 1)) = 0.5
		[ToggleUI]_RimBackfaceMask ("Backface Mask--{condition_showS:_RimStyle==2}", Int) = 1
		_RimVRParallaxStrength ("VR Parallax Strength--{condition_showS:_RimStyle==2}", Range(0, 1)) = 1
		_RimDirStrength ("Light direction strength--{condition_showS:_RimStyle==2}", Range(0, 1)) = 0
		_RimDirRange ("Direction Light Width--{condition_showS:_RimStyle==2}", Range(-1, 1)) = 0
		_RimIndirRange ("Indirection Light Width--{condition_showS:_RimStyle==2}", Range(-1, 1)) = 0
		[HDR][Gamma]_RimIndirColor ("Indirection Color--{condition_showS:_RimStyle==2}", Color) = (1,1,1,1)
		_RimIndirBorder ("Indirection Border--{condition_showS:_RimStyle==2}", Range(0, 1)) = 0.5
		_RimIndirBlur ("Indirection Blur--{condition_showS:_RimStyle==2}", Range(0, 1)) = 0.1
		[ThryToggleUI(true)] _RimShadowToggle ("<size=13><b>  Light Direction Mask</b></size>--{ condition_showS:_RimStyle==0}", Float) = 0
		[Enum(Shadow Map, 0, Custom, 1)]_RimShadowMaskRampType ("Light Falloff Type--{ condition_showS:_RimStyle==0&&_RimShadowToggle==1}", Int) = 0
		[ToggleUI]_RimShadowMaskInvert ("Invert Shadow Mask--{ condition_showS:_RimStyle==0&&_RimShadowToggle==1}", Float) = 0
		_RimShadowMaskStrength ("Shadow Mask Strength--{ condition_showS:_RimStyle==0&&_RimShadowToggle==1}", Range(0, 1)) = 1
		[MultiSlider]_RimShadowAlpha ("Hide In Shadow--{ condition_showS:_RimStyle==0&&_RimShadowToggle==1&&_RimShadowMaskRampType==1}", Vector) = (0.0, 0.0, 0, 1)
		_RimShadowWidth ("Shrink In Shadow--{ condition_showS:_RimStyle==0&&_RimShadowToggle==1}", Range(0, 1)) = 0
		[ThryToggleUI(true)] _RimHueShiftEnabled ("<size=13><b>  Hue Shift</b></size>", Float) = 0
		_RimHueShiftSpeed ("Shift Speed--{condition_showS:(_RimHueShiftEnabled==1)}", Float) = 0
		_RimHueShift ("Hue Shift--{condition_showS:(_RimHueShiftEnabled==1)}", Range(0, 1)) = 0
		[HideInInspector] m_start_RimAudioLink ("Audio Link ♫--{ condition_showS:_EnableAudioLink==1&&_RimStyle==0}", Float) = 0
		[Enum(Bass, 0, Low Mid, 1, High Mid, 2, Treble, 3)] _AudioLinkRimWidthBand ("Width Add Band", Int) = 0
		[VectorLabel(Min, Max)] _AudioLinkRimWidthAdd ("Width Add", Vector) = (0, 0, 0, 0)
		[Space(7)]
		[Enum(Bass, 0, Low Mid, 1, High Mid, 2, Treble, 3)] _AudioLinkRimEmissionBand ("Emission Add Band", Int) = 0
		[VectorLabel(Min, Max)] _AudioLinkRimEmissionAdd ("Emission Add", Vector) = (0, 0, 0, 0)
		[Space(7)]
		[Enum(Bass, 0, Low Mid, 1, High Mid, 2, Treble, 3)] _AudioLinkRimBrightnessBand ("Brightness Band", Int) = 0
		[VectorLabel(Min, Max)] _AudioLinkRimBrightnessAdd ("Brightness Add", Vector) = (0, 0, 0, 0)
		[HideInInspector] m_end_RimAudioLink ("Audio Link", Float) = 0
		[HideInInspector] m_end_rim1LightOptions ("Rim Lighting", Float) = 0
		[HideInInspector] m_start_brdf ("Reflections & Specular--{reference_property:_MochieBRDF,button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/reflections-and-specular},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(MOCHIE_PBR)]_MochieBRDF ("Enable", Float) = 0
		_MochieReflectionStrength ("Reflection Strength", Range(0, 1)) = 1
		_MochieSpecularStrength ("Specular Strength", Range(0, 1)) = 1
		_MochieMetallicMultiplier ("Metallic", Range(0, 1)) = 0
		_MochieRoughnessMultiplier ("Smoothness", Range(0, 1)) = 1
		_MochieReflectionTint ("Reflection Tint--{reference_property:_MochieReflectionTintThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _MochieReflectionTintThemeIndex ("", Int) = 0
		_MochieSpecularTint ("Specular Tint--{reference_property:_MochieSpecularTintThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _MochieSpecularTintThemeIndex ("", Int) = 0
		[Space(8)]
		[sRGBWarning]_MochieMetallicMaps ("Packed Maps [Expand]--{reference_properties:[_MochieMetallicMapsPan, _MochieMetallicMapsUV, _MochieMetallicMapsStochastic, _MochieMetallicMapsMetallicChannel, _MochieMetallicMapsRoughnessChannel, _MochieMetallicMapsReflectionMaskChannel, _MochieMetallicMapsSpecularMaskChannel, _MochieMetallicMapInvert, _MochieRoughnessMapInvert, _MochieReflectionMaskInvert, _MochieSpecularMaskInvert]}", 2D) = "white" { }
		[HideInInspector][Vector2]_MochieMetallicMapsPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)]_MochieMetallicMapsUV ("UV", Int) = 0
		[HideInInspector][ToggleUI]_MochieMetallicMapsStochastic ("Stochastic Sampling", Float) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsMetallicChannel ("Metallic Channel", Float) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsRoughnessChannel ("Smoothness Channel", Float) = 1
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsReflectionMaskChannel ("Reflection Mask Channel", Float) = 2
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsSpecularMaskChannel ("Specular Mask Channel", Float) = 3
		[HideInInspector][ToggleUI]_MochieMetallicMapInvert ("Invert Metallic", Float) = 0
		[HideInInspector][ToggleUI]_MochieRoughnessMapInvert ("Invert Smoothness", Float) = 0
		[HideInInspector][ToggleUI]_MochieReflectionMaskInvert ("Invert Reflection Mask", Float) = 0
		[HideInInspector][ToggleUI]_MochieSpecularMaskInvert ("Invert Specular Mask", Float) = 0
		[ThryToggleUI(true)]_PBRSplitMaskSample ("<size=13><b>  Split Mask Sampling</b></size>", Float) = 0
		[VectorLabel(tX, tY, oX, oY)]_PBRMaskScaleTiling ("Tiling/Offset--{condition_showS:(_PBRSplitMaskSample==1)}", Vector) = (1, 1, 0, 0)
		[ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7)]_MochieMetallicMasksUV ("UV--{condition_showS:(_PBRSplitMaskSample==1)}", Int) = 0
		[ToggleUI]_PBRSplitMaskStochastic ("Stochastic Sampling--{condition_showS:(_PBRSplitMaskSample==1)}", Float) = 0
		[Vector2]_MochieMetallicMasksPan ("Panning--{condition_showS:(_PBRSplitMaskSample==1)}", Vector) = (0, 0, 0, 0)
		[ThryToggleUI(true)]_Specular2ndLayer ("<size=13><b>  2nd Specular</b></size>", Float) = 0
		_MochieSpecularStrength2 ("Strength--{condition_showS:(_Specular2ndLayer==1)}", Range(0, 1)) = 1
		_MochieRoughnessMultiplier2 ("Smoothness--{condition_showS:(_Specular2ndLayer==1)}", Range(0, 1)) = 1
		[Space(4)]
		[ThryTexture][NoScaleOffset]_MochieReflCube ("Fallback Cubemap", Cube) = "" { }
		[ToggleUI]_MochieForceFallback ("Force Fallback", Int) = 0
		[HideInInspector] m_start_brdfadvanced ("Advanced", Float) = 0
		[ToggleUI]_MochieLitFallback ("Lit Fallback", Float) = 1
		[ToggleUI]_IgnoreCastedShadows ("Ignore Casted Shadows", Float) = 0
		_PBRNormalSelect ("Pixel Normal Mix", Range(0, 1)) = 1
		[PowerSlider(.2)]_RefSpecFresnel ("Fresnel Reflection", Range(0, 1)) = 1
		[ThryToggleUI(true)]_MochieGSAAEnabled ("<size=13><b>  GSAA</b></size>", Float) = 1
		_PoiGSAAVariance ("GSAA Variance", Range(0, 1)) = 0.15
		_PoiGSAAThreshold ("GSAA Threshold", Range(0, 1)) = 0.1
		[HideInInspector] g_start_BRDFTPSMaskGroup ("--{condition_showS:(_TPSPenetratorEnabled==1)}", Float) = 0
		[ThryToggleUI(true)] _BRDFTPSDepthEnabled ("<size=13><b>  TPS Depth Enabled</b></size>", Float) = 0
		_BRDFTPSReflectionMaskStrength ("Reflection Mask Strength--{condition_showS:(_BRDFTPSDepthEnabled==1)}", Range(0, 1)) = 1
		_BRDFTPSSpecularMaskStrength ("Specular Mask Strength--{condition_showS:(_BRDFTPSDepthEnabled==1)}", Range(0, 1)) = 1
		[HideInInspector] g_end_BRDFTPSMaskGroup ("", Float) = 0
		[HideInInspector] m_end_brdfadvanced ("", Float) = 0
		[HideInInspector] m_start_brdfglobalmask ("Global Mask", Float) = 0
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieMetallicGlobalMask ("Metallic--{reference_property:_MochieMetallicGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Replace, 0, Multiply, 2, Screen, 6, Linear Dodge(Add), 8, Overlay, 9, Mixed, 20)] _MochieMetallicGlobalMaskBlendType ("Blending", Int) = 2
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieSmoothnessGlobalMask ("Smoothness--{reference_property:_MochieSmoothnessGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Replace, 0, Multiply, 2, Screen, 6, Linear Dodge(Add), 8, Overlay, 9, Mixed, 20)] _MochieSmoothnessGlobalMaskBlendType ("Blending", Int) = 2
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieReflectionStrengthGlobalMask ("Reflection Strength--{reference_property:_MochieReflectionStrengthGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Replace, 0, Multiply, 2, Screen, 6, Linear Dodge(Add), 8, Overlay, 9, Mixed, 20)] _MochieReflectionStrengthGlobalMaskBlendType ("Blending", Int) = 2
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieSpecularStrengthGlobalMask ("Specular Strength--{reference_property:_MochieSpecularStrengthGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Replace, 0, Multiply, 2, Screen, 6, Linear Dodge(Add), 8, Overlay, 9, Mixed, 20)] _MochieSpecularStrengthGlobalMaskBlendType ("Blending", Int) = 2
		[HideInInspector] m_end_brdfglobalmask ("", Float) = 0
		[HideInInspector] m_end_brdf ("", Float) = 0
		[HideInInspector] m_specialFXCategory ("Special FX", Float) = 0
		[HideInInspector] m_modifierCategory ("Modifiers", Float) = 0
		[HideInInspector] m_start_Stochastic ("Stochastic Sampling", Float) = 0
		[KeywordEnum(Deliot Heitz, Hextile, None)] _StochasticMode ("Sampling Mode", Float) = 0
		[HideInInspector] g_start_deliot ("Deliot Heitz--{condition_show:{type:PROPERTY_BOOL,data:_StochasticMode==0}}", Float) = 0
		_StochasticDeliotHeitzDensity ("Detiling Density", Range(0.1, 10)) = 1
		[HideInInspector] g_end_deliot ("Deliot Heitz", Float) = 0
		[HideInInspector] g_start_hextile ("Hextile--{condition_show:{type:PROPERTY_BOOL,data:_StochasticMode==1}}", Float) = 0
		_StochasticHexGridDensity ("Hex Grid Density", Range(0.1, 10)) = 1
		_StochasticHexRotationStrength ("Rotation Strength", Range(0, 2)) = 0
		_StochasticHexFallOffContrast("Falloff Contrast", Range(0.01, 0.99)) = 0.6
		_StochasticHexFallOffPower("Falloff Power", Range(0, 20)) = 7
		[HideInInspector] g_end_hextile ("Hextile", Float) = 0
		[HideInInspector] m_end_Stochastic ("Stochastic Sampling", Float) = 0
		[HideInInspector] m_start_uvLocalWorld ("Local World UV", Float) = 0
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3, VColor R, 4, VColor G, 5, VColor B, 6, VColor A, 7)] _UVModLocalPos0 ("Local X", Int) = 0
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3, VColor R, 4, VColor G, 5, VColor B, 6, VColor A, 7)] _UVModLocalPos1 ("Local Y", Int) = 1
		[Space(10)]
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3)] _UVModWorldPos0 ("World X", Int) = 0
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3)] _UVModWorldPos1 ("World Y", Int) = 2
		[HideInInspector] m_end_uvLocalWorld ("Local World UV", Float) = 0
		[HideInInspector] m_start_uvPanosphere ("Panosphere UV", Float) = 0
		[ToggleUI] _StereoEnabled ("Stereo Enabled", Float) = 0
		[ToggleUI] _PanoUseBothEyes ("Perspective Correct (VR)", Float) = 1
		[HideInInspector] m_end_uvPanosphere ("Panosphere UV", Float) = 0
		[HideInInspector] m_start_uvPolar ("Polar UV", Float) = 0
		[ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8)] _PolarUV ("UV", Int) = 0
		[Vector2]_PolarCenter ("Center Coordinate", Vector) = (.5, .5, 0, 0)
		_PolarRadialScale ("Radial Scale", Float) = 1
		_PolarLengthScale ("Length Scale", Float) = 1
		_PolarSpiralPower ("Spiral Power", Float) = 0
		[HideInInspector] m_end_uvPolar ("Polar UV", Float) = 0
		[HideInInspector] m_thirdpartyCategory ("Third Party", Float) = 0
		[HideInInspector] m_postprocessing ("Post Processing", Float) = 0
		[HideInInspector] m_start_PoiLightData ("PP Animations--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/post-processing/pp-animations},hover:Documentation}}", Float) = 0
		[Helpbox(1)] _PPHelp ("This section meant for real time adjustments through animations and not to be changed in unity", Int) = 0
		_PPLightingMultiplier ("Lighting Mulitplier", Float) = 1
		_PPLightingAddition ("Lighting Add", Float) = 0
		_PPEmissionMultiplier ("Emission Multiplier", Float) = 1
		_PPFinalColorMultiplier ("Final Color Multiplier", Float) = 1
		[HideInInspector] m_end_PoiLightData ("PP Animations ", Float) = 0
		[HideInInspector] m_renderingCategory ("Rendering--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/rendering/main},hover:Documentation}}", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4
		[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 1
		[Enum(Thry.ColorMask)] _ColorMask ("Color Mask", Int) = 15
		_OffsetFactor ("Offset Factor", Float) = 0.0
		_OffsetUnits ("Offset Units", Float) = 0.0
		[ToggleUI]_RenderingReduceClipDistance ("Reduce Clip Distance", Float) = 0
		[ToggleUI]_IgnoreFog ("Ignore Fog", Float) = 0
		[HideInInspector] Instancing ("Instancing", Float) = 0 //add this property for instancing variants settings to be shown
		[HideInInspector] m_start_blending ("Blending--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/rendering/blending},hover:Documentation}}", Float) = 0
		[Enum(Thry.BlendOp)]_BlendOp ("RGB Blend Op", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("RGB Source Blend", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("RGB Destination Blend", Int) = 0
		[Space][ThryHeaderLabel(Additive Blending, 13)]
		[Enum(Thry.BlendOp)]_AddBlendOp ("RGB Blend Op", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _AddSrcBlend ("RGB Source Blend", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _AddDstBlend ("RGB Destination Blend", Int) = 1
		[HideInInspector] m_start_alphaBlending ("Advanced Alpha Blending", Float) = 0
		[Enum(Thry.BlendOp)]_BlendOpAlpha ("Alpha Blend Op", Int) = 4
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlpha ("Alpha Source Blend", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlendAlpha ("Alpha Destination Blend", Int) = 1
		[Space][ThryHeaderLabel(Additive Blending, 13)]
		[Enum(Thry.BlendOp)]_AddBlendOpAlpha ("Alpha Blend Op", Int) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _AddSrcBlendAlpha ("Alpha Source Blend", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _AddDstBlendAlpha ("Alpha Destination Blend", Int) = 1
		[HideInInspector] m_end_alphaBlending ("Advanced Alpha Blending", Float) = 0
		[HideInInspector] m_end_blending ("Blending", Float) = 0
		[HideInInspector] m_start_StencilPassOptions ("Stencil--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/rendering/stencil},hover:Documentation}}", Float) = 0
		[ThryWideEnum(Simple, 0, Front Face vs Back Face, 1)] _StencilType ("Stencil Type", Float) = 0
		[IntRange] _StencilRef ("Stencil Reference Value", Range(0, 255)) = 0
		[IntRange] _StencilReadMask ("Stencil ReadMask Value", Range(0, 255)) = 255
		[IntRange] _StencilWriteMask ("Stencil WriteMask Value", Range(0, 255)) = 255
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Stencil Pass Op--{condition_showS:(_StencilType==0)}", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Stencil Fail Op--{condition_showS:(_StencilType==0)}", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("Stencil ZFail Op--{condition_showS:(_StencilType==0)}", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilCompareFunction ("Stencil Compare Function--{condition_showS:(_StencilType==0)}", Float) = 8
		[HideInInspector] m_start_StencilPassBackOptions("Back--{condition_showS:(_StencilType==1)}", Float) = 0
		[Helpbox(1)] _FFBFStencilHelp0 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilBackPassOp ("Back Pass Op", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilBackFailOp ("Back Fail Op", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilBackZFailOp ("Back ZFail Op", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilBackCompareFunction ("Back Compare Function", Float) = 8
		[HideInInspector] m_end_StencilPassBackOptions("Back", Float) = 0
		[HideInInspector] m_start_StencilPassFrontOptions("Front--{condition_showS:(_StencilType==1)}", Float) = 0
		[Helpbox(1)] _FFBFStencilHelp1 ("Front Face and Back Face Stencils only work when locked in due to Unity's Stencil managment", Int) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFrontPassOp ("Front Pass Op", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFrontFailOp ("Front Fail Op", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilFrontZFailOp ("Front ZFail Op", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilFrontCompareFunction ("Front Compare Function", Float) = 8
		[HideInInspector] m_end_StencilPassFrontOptions("Front", Float) = 0
		[HideInInspector] m_end_StencilPassOptions ("Stencil", Float) = 0
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "VRCFallback" = "Standard" }
		Pass
		{

			Tags { "LightMode" = "ForwardBase" }
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilCompareFunction]
				Pass [_StencilPassOp]
				Fail [_StencilFailOp]
				ZFail [_StencilZFailOp]
			}
			ZWrite [_ZWrite]
			Cull Back
			AlphaToMask [_AlphaToCoverage]
			ZTest [_ZTest]
			ColorMask RGBA
			Offset [_OffsetFactor], [_OffsetUnits]
			BlendOp [_BlendOp], [_BlendOpAlpha]
			Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
			CGPROGRAM

 #define MOCHIE_PBR 
 #define POI_MATCAP0 
 #define VIGNETTE_MASKED 
 #define _GLOSSYREFLECTIONS_OFF 
 #define _LIGHTINGMODE_FLAT 
 #define _RIM2STYLE_POIYOMI 
 #define _RIMSTYLE_POIYOMI 
 #define _STOCHASTICMODE_DELIOT_HEITZ 
 #define PROP_MATCAP 
 #define OPTIMIZER_ENABLED 
			#pragma target 5.0
			#pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile_fwdbase
			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#pragma multi_compile _ VERTEXLIGHT_ON
			#define POI_PASS_BASE
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "AutoLight.cginc"
			#include "UnityLightingCommon.cginc"
			#include "UnityPBSLighting.cginc"
			#ifdef POI_PASS_META
			#include "UnityMetaPass.cginc"
			#endif
			// #pragma vertex vert
#pragma vertex spsVert

			#pragma fragment frag
			#define DielectricSpec float4(0.04, 0.04, 0.04, 1.0 - 0.04)
			#define PI float(3.14159265359)
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex,samplertex,coord,dx,dy) tex.SampleGrad (sampler##samplertex,coord,dx,dy)
			#define POI_PAN_UV(uv, pan) (uv + _Time.x * pan)
			#define POI2D_SAMPLER_PAN(tex, texSampler, uv, pan) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, POI_PAN_UV(uv, pan)))
			#define POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, POI_PAN_UV(uv, pan), dx, dy))
			#define POI2D_SAMPLER(tex, texSampler, uv) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_GRAD(tex, texSampler, uv, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, uv, dx, dy))
			#define POI2D_PAN(tex, uv, pan) (tex2D(tex, POI_PAN_UV(uv, pan)))
			#define POI2D(tex, uv) (tex2D(tex, uv))
			#define POI_SAMPLE_TEX2D(tex, uv) (UNITY_SAMPLE_TEX2D(tex, uv))
			#define POI_SAMPLE_TEX2D_PAN(tex, uv, pan) (UNITY_SAMPLE_TEX2D(tex, POI_PAN_UV(uv, pan)))
			#define POI_SAFE_RGB0 float4(mainTexture.rgb * .0001, 0)
			#define POI_SAFE_RGB1 float4(mainTexture.rgb * .0001, 1)
			#define POI_SAFE_RGBA mainTexture
			#if defined(UNITY_COMPILER_HLSL)
			#define PoiInitStruct(type, name) name = (type)0;
			#else
			#define PoiInitStruct(type, name)
			#endif
			#define POI_ERROR(poiMesh, gridSize) lerp(float3(1, 0, 1), float3(0, 0, 0), fmod(floor((poiMesh.worldPos.x) * gridSize) + floor((poiMesh.worldPos.y) * gridSize) + floor((poiMesh.worldPos.z) * gridSize), 2) == 0)
			#define POI_NAN (asfloat(-1))
			#define POI_MODE_OPAQUE 0
			#define POI_MODE_CUTOUT 1
			#define POI_MODE_FADE 2
			#define POI_MODE_TRANSPARENT 3
			#define POI_MODE_ADDITIVE 4
			#define POI_MODE_SOFTADDITIVE 5
			#define POI_MODE_MULTIPLICATIVE 6
			#define POI_MODE_2XMULTIPLICATIVE 7
			#define POI_MODE_TRANSCLIPPING 9
			float _Mode;
			float _StochasticDeliotHeitzDensity;
			float _StochasticHexGridDensity;
			float _StochasticHexRotationStrength;
			float _StochasticHexFallOffContrast;
			float _StochasticHexFallOffPower;
			#if defined(PROP_LIGHTINGAOMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _LightingAOMaps;
			#endif
			float4 _LightingAOMaps_ST;
			float2 _LightingAOMapsPan;
			float _LightingAOMapsUV;
			float _LightDataAOStrengthR;
			float _LightDataAOStrengthG;
			float _LightDataAOStrengthB;
			float _LightDataAOStrengthA;
			float _LightDataAOGlobalMaskR;
			float _LightDataAOGlobalMaskBlendTypeR;
			#if defined(PROP_LIGHTINGDETAILSHADOWMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _LightingDetailShadowMaps;
			#endif
			float4 _LightingDetailShadowMaps_ST;
			float2 _LightingDetailShadowMapsPan;
			float _LightingDetailShadowMapsUV;
			float _LightingDetailShadowStrengthR;
			float _LightingDetailShadowStrengthG;
			float _LightingDetailShadowStrengthB;
			float _LightingDetailShadowStrengthA;
			float _LightingAddDetailShadowStrengthR;
			float _LightingAddDetailShadowStrengthG;
			float _LightingAddDetailShadowStrengthB;
			float _LightingAddDetailShadowStrengthA;
			float _LightDataDetailShadowGlobalMaskR;
			float _LightDataDetailShadowGlobalMaskBlendTypeR;
			#if defined(PROP_LIGHTINGSHADOWMASKS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _LightingShadowMasks;
			#endif
			float4 _LightingShadowMasks_ST;
			float2 _LightingShadowMasksPan;
			float _LightingShadowMasksUV;
			float _LightingShadowMaskStrengthR;
			float _LightingShadowMaskStrengthG;
			float _LightingShadowMaskStrengthB;
			float _LightingShadowMaskStrengthA;
			float _LightDataShadowMaskGlobalMaskR;
			float _LightDataShadowMaskGlobalMaskBlendTypeR;
			float _Unlit_Intensity;
			float _LightingColorMode;
			float _LightingMapMode;
			float _LightingDirectionMode;
			float3 _LightngForcedDirection;
			float _LightingIndirectUsesNormals;
			float _LightingCapEnabled;
			float _LightingCap;
			float _LightingForceColorEnabled;
			float3 _LightingForcedColor;
			float _LightingForcedColorThemeIndex;
			float _LightingCastedShadows;
			float _LightingMonochromatic;
			float _LightingMinLightBrightness;
			float _LightingAdditiveEnable;
			float _LightingAdditiveLimited;
			float _LightingAdditiveLimit;
			float _LightingAdditiveCastedShadows;
			float _LightingAdditiveMonochromatic;
			float _LightingAdditivePassthrough;
			float _DisableDirectionalInAdd;
			float _LightingVertexLightingEnabled;
			float _LightDataDebugEnabled;
			float _LightingDebugVisualize;
			float _IgnoreFog;
			float _RenderingReduceClipDistance;
			float _AddBlendOp;
			float4 _Color;
			float _ColorThemeIndex;
			UNITY_DECLARE_TEX2D(_MainTex);
			UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
			float _MainPixelMode;
			float4 _MainTex_ST;
			float2 _MainTexPan;
			float _MainTexUV;
			float4 _MainTex_TexelSize;
			float _MainTexStochastic;
			#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _BumpMap;
			#endif
			float4 _BumpMap_ST;
			float2 _BumpMapPan;
			float _BumpMapUV;
			float _BumpScale;
			float _BumpMapStochastic;
			Texture2D _ClippingMask;
			float4 _ClippingMask_ST;
			float2 _ClippingMaskPan;
			float _ClippingMaskUV;
			float _Inverse_Clipping;
			float _Cutoff;
			SamplerState sampler_linear_clamp;
			SamplerState sampler_linear_repeat;
			float _AlphaForceOpaque;
			float _AlphaMod;
			float _AlphaPremultiply;
			float _AlphaBoostFA;
			float _AlphaGlobalMask;
			float _AlphaGlobalMaskBlendType;
			float4 _GlobalThemeColor0;
			float4 _GlobalThemeColor1;
			float4 _GlobalThemeColor2;
			float4 _GlobalThemeColor3;
			float _GlobalThemeHue0;
			float _GlobalThemeHue1;
			float _GlobalThemeHue2;
			float _GlobalThemeHue3;
			float _GlobalThemeHueSpeed0;
			float _GlobalThemeHueSpeed1;
			float _GlobalThemeHueSpeed2;
			float _GlobalThemeHueSpeed3;
			float _GlobalThemeSaturation0;
			float _GlobalThemeSaturation1;
			float _GlobalThemeSaturation2;
			float _GlobalThemeSaturation3;
			float _GlobalThemeValue0;
			float _GlobalThemeValue1;
			float _GlobalThemeValue2;
			float _GlobalThemeValue3;
			float _StereoEnabled;
			float _PolarUV;
			float2 _PolarCenter;
			float _PolarRadialScale;
			float _PolarLengthScale;
			float _PolarSpiralPower;
			float _PanoUseBothEyes;
			float _UVModWorldPos0;
			float _UVModWorldPos1;
			float _UVModLocalPos0;
			float _UVModLocalPos1;
			float _ShadowStrength;
			float _LightingIgnoreAmbientColor;
			float3 _LightingShadowColor;
			float _LightingAdditiveType;
			float _LightingAdditiveGradientStart;
			float _LightingAdditiveGradientEnd;
			float _LightingAdditiveDetailStrength;
			#ifdef POI_MATCAP0
			#if defined(PROP_MATCAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _Matcap;
			float4 _Matcap_ST;
			float4 _Matcap_TexelSize;
			float2 _MatcapPan;
			float _MatcapUV;
			#endif
			#if defined(PROP_MATCAPMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _MatcapMask;
			float4 _MatcapMask_ST;
			float2 _MatcapMaskPan;
			float _MatcapMaskUV;
			float _MatcapMaskChannel;
			#endif
			float _MatcapUVToBlend;
			float4 _MatCapBlendUV1;
			float _MatcapUVMode;
			float _MatcapMaskInvert;
			float _MatcapMaskGlobalMask;
			float _MatcapMaskGlobalMaskBlendType;
			float _MatcapBorder;
			float _MatcapRotation;
			float _MatcapSmoothnessEnabled;
			float _MatcapSmoothness;
			float _MatcapMaskSmoothnessChannel;
			float _MatcapMaskSmoothnessApply;
			float4 _MatcapColor;
			float _MatcapBaseColorMix;
			float _MatcapColorThemeIndex;
			float _MatcapIntensity;
			float _MatcapReplace;
			float _MatcapMultiply;
			float _MatcapAdd;
			float _MatcapAddToLight;
			float _MatcapMixed;
			float _MatcapScreen;
			float _MatcapAlphaOverride;
			float _MatcapEnable;
			float _MatcapLightMask;
			float _MatcapEmissionStrength;
			float _MatcapNormal;
			float _MatcapHueShiftEnabled;
			float _MatcapHueShiftSpeed;
			float _MatcapHueShift;
			float _MatcapTPSDepthEnabled;
			float _MatcapTPSMaskStrength;
			#endif
			#ifdef _GLOSSYREFLECTIONS_OFF
			float _Is_NormalMapToRimLight;
			float4 _RimLightColor;
			float _RimLightColorThemeIndex;
			float _RimClamp;
			#ifdef _RIMSTYLE_POIYOMI
			float _RimLightingInvert;
			float _RimWidth;
			float _RimStrength;
			float _RimSharpness;
			float _RimBaseColorMix;
			float _EnableRimLighting;
			float _RimWidthNoiseStrength;
			float4 _RimShadowAlpha;
			float _RimShadowWidth;
			float _RimBlendStrength;
			float _RimBlendMode;
			float _RimShadowToggle;
			float _RimPower;
			float _RimShadowMaskStrength;
			float _RimShadowMaskRampType;
			float _RimShadowMaskInvert;
			float _RimBrightness;
			#if defined(PROP_RIMTEX) || !defined(OPTIMIZER_ENABLED)
			Texture2D _RimTex;
			#endif
			float4 _RimTex_ST;
			float2 _RimTexPan;
			float _RimTexUV;
			#if defined(PROP_RIMMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _RimMask;
			#endif
			float4 _RimMask_ST;
			float2 _RimMaskPan;
			float _RimMaskUV;
			float _RimMaskChannel;
			float _RimMaskInvert;
			float _RimBiasIntensity;
			#ifdef POI_AUDIOLINK
			half _AudioLinkRimWidthBand;
			float2 _AudioLinkRimWidthAdd;
			half _AudioLinkRimEmissionBand;
			float2 _AudioLinkRimEmissionAdd;
			half _AudioLinkRimBrightnessBand;
			float2 _AudioLinkRimBrightnessAdd;
			#endif
			#endif
			float _RimGlobalMask;
			float _RimGlobalMaskBlendType;
			float _RimApplyGlobalMaskIndex;
			float _RimApplyGlobalMaskBlendType;
			float _RimHueShiftEnabled;
			float _RimHueShiftSpeed;
			float _RimHueShift;
			#endif
			#ifdef MOCHIE_PBR
			#if defined(PROP_MOCHIEMETALLICMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _MochieMetallicMaps;
			float _PBRMapsStochastic;
			#endif
			float4 _MochieMetallicMaps_ST; float2 _MochieMetallicMapsPan; float _MochieMetallicMapsUV; float _MochieMetallicMapsStochastic;
			float _MochieMetallicMapInvert;
			float _MochieRoughnessMapInvert;
			float _MochieReflectionMaskInvert;
			float _MochieSpecularMaskInvert;
			float _MochieMetallicMapsMetallicChannel;
			float _MochieMetallicMapsRoughnessChannel;
			float _MochieMetallicMapsReflectionMaskChannel;
			float _MochieMetallicMapsSpecularMaskChannel;
			float _PBRNormalSelect;
			float _MochieReflectionTintThemeIndex;
			float _MochieSpecularTintThemeIndex;
			float _MochieRoughnessMultiplier;
			float _MochieMetallicMultiplier;
			float _MochieReflectionStrength;
			float _MochieSpecularStrength;
			float4 _MochieSpecularTint;
			float4 _MochieReflectionTint;
			float _MochieLitFallback;
			float _IgnoreCastedShadows;
			float _PBRSplitMaskSample;
			float _PBRSplitMaskStochastic;
			float4 _PBRMaskScaleTiling;
			float _MochieMetallicMasksUV;
			float4 _MochieMetallicMasksPan;
			float _Specular2ndLayer;
			float _MochieSpecularStrength2;
			float _MochieRoughnessMultiplier2;
			float _RefSpecFresnel;
			samplerCUBE _MochieReflCube;
			float4 _MochieReflCube_HDR;
			float _MochieForceFallback;
			float _MochieGSAAEnabled;
			float _PoiGSAAVariance;
			float _PoiGSAAThreshold;
			float _BRDFTPSReflectionMaskStrength;
			float _BRDFTPSSpecularMaskStrength;
			float _BRDFTPSDepthEnabled;
			float _MochieMetallicGlobalMask;
			float _MochieMetallicGlobalMaskBlendType;
			float _MochieSmoothnessGlobalMask;
			float _MochieSmoothnessGlobalMaskBlendType;
			float _MochieReflectionStrengthGlobalMask;
			float _MochieReflectionStrengthGlobalMaskBlendType;
			float _MochieSpecularStrengthGlobalMask;
			float _MochieSpecularStrengthGlobalMaskBlendType;
			#endif
			float _PPLightingMultiplier;
			float _PPLightingAddition;
			float _PPEmissionMultiplier;
			float _PPFinalColorMultiplier;
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 color : COLOR;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				uint vertexId : SV_VertexID;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOut
			{
				float4 pos : SV_POSITION;
				float2 uv[4] : TEXCOORD0;
				float3 objNormal : TEXCOORD4;
				float3 normal : TEXCOORD5;
				float3 tangent : TEXCOORD6;
				float3 binormal : TEXCOORD7;
				float4 worldPos : TEXCOORD8;
				float4 localPos : TEXCOORD9;
				float3 objectPos : TEXCOORD10;
				float4 vertexColor : TEXCOORD11;
				float4 lightmapUV : TEXCOORD12;
				float4 grabPos: TEXCOORD13;
				float4 worldDirection: TEXCOORD14;
				float4 extra: TEXCOORD15;
				UNITY_SHADOW_COORDS(16)
				UNITY_FOG_COORDS(17)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			struct PoiMesh
			{
				float3 normals[2];
				float3 objNormal;
				float3 tangentSpaceNormal;
				float3 binormal[2];
				float3 tangent[2];
				float3 worldPos;
				float3 localPos;
				float3 objectPosition;
				float isFrontFace;
				float4 vertexColor;
				float4 lightmapUV;
				float2 uv[9];
				float2 parallaxUV;
			};
			struct PoiCam
			{
				float3 viewDir;
				float3 forwardDir;
				float3 worldPos;
				float distanceToVert;
				float4 clipPos;
				float3 reflectionDir;
				float3 vertexReflectionDir;
				float3 tangentViewDir;
				float4 grabPos;
				float2 screenUV;
				float vDotN;
				float4 worldDirection;
			};
			struct PoiMods
			{
				float4 PBR; // smoothness, metallic, smoothness mask, metallic mask
				float4 Mask;
				float4 audioLink;
				float audioLinkAvailable;
				float audioLinkVersion;
				float4 audioLinkTexture;
				float audioLinkViaLuma;
				float2 detailMask;
				float2 backFaceDetailIntensity;
				float globalEmission;
				float4 globalColorTheme[12];
				float globalMask[16];
				float ALTime[8];
			};
			struct PoiLight
			{
				float3 direction;
				float attenuation;
				float attenuationStrength;
				float3 directColor;
				float3 indirectColor;
				float occlusion;
				float shadowMask;
				float detailShadow;
				float3 halfDir;
				float lightMap;
				float lightMapNoAttenuation;
				float3 rampedLightMap;
				float vertexNDotL;
				float nDotL;
				float nDotV;
				float vertexNDotV;
				float nDotH;
				float vertexNDotH;
				float lDotv;
				float lDotH;
				float nDotLSaturated;
				float nDotLNormalized;
				#ifdef POI_PASS_ADD
				float additiveShadow;
				#endif
				float3 finalLighting;
				float3 finalLightAdd;
				#if defined(VERTEXLIGHT_ON)
				float4 vDotNL;
				float4 vertexVDotNL;
				float3 vColor[4];
				float4 vCorrectedDotNL;
				float4 vAttenuation;
				float4 vAttenuationDotNL;
				float3 vPosition[4];
				float3 vDirection[4];
				float3 vFinalLighting;
				float3 vHalfDir[4];
				half4 vDotNH;
				half4 vertexVDotNH;
				half4 vDotLH;
				#endif
			};
			struct PoiVertexLights
			{
				float3 direction;
				float3 color;
				float attenuation;
			};
			struct PoiFragData
			{
				float3 baseColor;
				float3 finalColor;
				float alpha;
				float3 emission;
			};
			#ifndef glsl_mod
			#define glsl_mod(x, y) (((x) - (y) * floor((x) / (y))))
			#endif
			uniform float random_uniform_float_only_used_to_stop_compiler_warnings = 0.0f;
			float2 poiUV(float2 uv, float4 tex_st)
			{
				return uv * tex_st.xy + tex_st.zw;
			}
			float2 vertexUV(in VertexOut o, int index)
			{
				switch(index)
				{
					case 0:
					return o.uv[0];
					case 1:
					return o.uv[1];
					case 2:
					return o.uv[2];
					case 3:
					return o.uv[3];
					default:
					return o.uv[0];
				}
			}
			float2 vertexUV(in appdata v, int index)
			{
				switch(index)
				{
					case 0:
					return v.uv0;
					case 1:
					return v.uv1;
					case 2:
					return v.uv2;
					case 3:
					return v.uv3;
					default:
					return v.uv0;
				}
			}
			float calculateluminance(float3 color)
			{
				return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
			}
			float _VRChatCameraMode;
			float _VRChatMirrorMode;
			float VRCCameraMode()
			{
				return _VRChatCameraMode;
			}
			float VRCMirrorMode()
			{
				return _VRChatMirrorMode;
			}
			bool IsInMirror()
			{
				return unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
			}
			bool IsOrthographicCamera()
			{
				return unity_OrthoParams.w == 1 || UNITY_MATRIX_P[3][3] == 1;
			}
			float shEvaluateDiffuseL1Geomerics_local(float L0, float3 L1, float3 n)
			{
				float R0 = max(0, L0);
				float3 R1 = 0.5f * L1;
				float lenR1 = length(R1);
				float q = dot(normalize(R1), n) * 0.5 + 0.5;
				q = saturate(q); // Thanks to ScruffyRuffles for the bug identity.
				float p = 1.0f + 2.0f * lenR1 / R0;
				float a = (1.0f - lenR1 / R0) / (1.0f + lenR1 / R0);
				return R0 * (a + (1.0f - a) * (p + 1.0f) * pow(q, p));
			}
			half3 BetterSH9(half4 normal)
			{
				float3 indirect;
				float3 L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) + float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
				indirect.r = shEvaluateDiffuseL1Geomerics_local(L0.r, unity_SHAr.xyz, normal.xyz);
				indirect.g = shEvaluateDiffuseL1Geomerics_local(L0.g, unity_SHAg.xyz, normal.xyz);
				indirect.b = shEvaluateDiffuseL1Geomerics_local(L0.b, unity_SHAb.xyz, normal.xyz);
				indirect = max(0, indirect);
				indirect += SHEvalLinearL2(normal);
				return indirect;
			}
			float3 getCameraForward()
			{
				#if UNITY_SINGLE_PASS_STEREO
				float3 p1 = mul(unity_StereoCameraToWorld[0], float4(0, 0, 1, 1));
				float3 p2 = mul(unity_StereoCameraToWorld[0], float4(0, 0, 0, 1));
				#else
				float3 p1 = mul(unity_CameraToWorld, float4(0, 0, 1, 1)).xyz;
				float3 p2 = mul(unity_CameraToWorld, float4(0, 0, 0, 1)).xyz;
				#endif
				return normalize(p2 - p1);
			}
			half3 GetSHLength()
			{
				half3 x, x1;
				x.r = length(unity_SHAr);
				x.g = length(unity_SHAg);
				x.b = length(unity_SHAb);
				x1.r = length(unity_SHBr);
				x1.g = length(unity_SHBg);
				x1.b = length(unity_SHBb);
				return x + x1;
			}
			float3 BoxProjection(float3 direction, float3 position, float4 cubemapPosition, float3 boxMin, float3 boxMax)
			{
				#if UNITY_SPECCUBE_BOX_PROJECTION
				if (cubemapPosition.w > 0)
				{
					float3 factors = ((direction > 0 ? boxMax : boxMin) - position) / direction;
					float scalar = min(min(factors.x, factors.y), factors.z);
					direction = direction * scalar + (position - cubemapPosition.xyz);
				}
				#endif
				return direction;
			}
			float poiMax(float2 i)
			{
				return max(i.x, i.y);
			}
			float poiMax(float3 i)
			{
				return max(max(i.x, i.y), i.z);
			}
			float poiMax(float4 i)
			{
				return max(max(max(i.x, i.y), i.z), i.w);
			}
			float3 calculateNormal(in float3 baseNormal, in PoiMesh poiMesh, in Texture2D normalTexture, in float4 normal_ST, in float2 normalPan, in float normalUV, in float normalIntensity)
			{
				float3 normal = UnpackScaleNormal(POI2D_SAMPLER_PAN(normalTexture, _MainTex, poiUV(poiMesh.uv[normalUV], normal_ST), normalPan), normalIntensity);
				return normalize(
				normal.x * poiMesh.tangent[0] +
				normal.y * poiMesh.binormal[0] +
				normal.z * baseNormal
				);
			}
			float remap(float x, float minOld, float maxOld, float minNew = 0, float maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float2 remap(float2 x, float2 minOld, float2 maxOld, float2 minNew = 0, float2 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float3 remap(float3 x, float3 minOld, float3 maxOld, float3 minNew = 0, float3 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float4 remap(float4 x, float4 minOld, float4 maxOld, float4 minNew = 0, float4 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float remapClamped(float minOld, float maxOld, float x, float minNew = 0, float maxNew = 1)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float2 remapClamped(float2 minOld, float2 maxOld, float2 x, float2 minNew, float2 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float3 remapClamped(float3 minOld, float3 maxOld, float3 x, float3 minNew, float3 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float4 remapClamped(float4 minOld, float4 maxOld, float4 x, float4 minNew, float4 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float2 calcParallax(in float height, in PoiCam poiCam)
			{
				return ((height * - 1) + 1) * (poiCam.tangentViewDir.xy / poiCam.tangentViewDir.z);
			}
			float4 poiBlend(const float sourceFactor, const  float4 sourceColor, const  float destinationFactor, const  float4 destinationColor, const float4 blendFactor)
			{
				float4 sA = 1 - blendFactor;
				const float4 blendData[11] = {
					float4(0.0, 0.0, 0.0, 0.0),
					float4(1.0, 1.0, 1.0, 1.0),
					destinationColor,
					sourceColor,
					float4(1.0, 1.0, 1.0, 1.0) - destinationColor,
					sA,
					float4(1.0, 1.0, 1.0, 1.0) - sourceColor,
					sA,
					float4(1.0, 1.0, 1.0, 1.0) - sA,
					saturate(sourceColor.aaaa),
					1 - sA,
				};
				return lerp(blendData[sourceFactor] * sourceColor + blendData[destinationFactor] * destinationColor, sourceColor, sA);
			}
			float blendAverage(float base, float blend)
			{
				return (base + blend) / 2.0;
			}
			float3 blendAverage(float3 base, float3 blend)
			{
				return (base + blend) / 2.0;
			}
			float blendColorBurn(float base, float blend)
			{
				return (blend == 0.0) ? blend : max((1.0 - ((1.0 - base) * rcp(random_uniform_float_only_used_to_stop_compiler_warnings + blend))), 0.0);
			}
			float3 blendColorBurn(float3 base, float3 blend)
			{
				return float3(blendColorBurn(base.r, blend.r), blendColorBurn(base.g, blend.g), blendColorBurn(base.b, blend.b));
			}
			float blendColorDodge(float base, float blend)
			{
				return (blend == 1.0) ? blend : min(base / (1.0 - blend), 1.0);
			}
			float3 blendColorDodge(float3 base, float3 blend)
			{
				return float3(blendColorDodge(base.r, blend.r), blendColorDodge(base.g, blend.g), blendColorDodge(base.b, blend.b));
			}
			float blendDarken(float base, float blend)
			{
				return min(blend, base);
			}
			float3 blendDarken(float3 base, float3 blend)
			{
				return float3(blendDarken(base.r, blend.r), blendDarken(base.g, blend.g), blendDarken(base.b, blend.b));
			}
			float blendExclusion(float base, float blend)
			{
				return base + blend - 2.0 * base * blend;
			}
			float3 blendExclusion(float3 base, float3 blend)
			{
				return base + blend - 2.0 * base * blend;
			}
			float blendReflect(float base, float blend)
			{
				return (blend == 1.0) ? blend : min(base * base / (1.0 - blend), 1.0);
			}
			float3 blendReflect(float3 base, float3 blend)
			{
				return float3(blendReflect(base.r, blend.r), blendReflect(base.g, blend.g), blendReflect(base.b, blend.b));
			}
			float blendGlow(float base, float blend)
			{
				return blendReflect(blend, base);
			}
			float3 blendGlow(float3 base, float3 blend)
			{
				return blendReflect(blend, base);
			}
			float blendOverlay(float base, float blend)
			{
				return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
			}
			float3 blendOverlay(float3 base, float3 blend)
			{
				return float3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
			}
			float blendHardLight(float base, float blend)
			{
				return blendOverlay(blend, base);
			}
			float3 blendHardLight(float3 base, float3 blend)
			{
				return blendOverlay(blend, base);
			}
			float blendVividLight(float base, float blend)
			{
				return (blend < 0.5) ? blendColorBurn(base, (2.0 * blend)) : blendColorDodge(base, (2.0 * (blend - 0.5)));
			}
			float3 blendVividLight(float3 base, float3 blend)
			{
				return float3(blendVividLight(base.r, blend.r), blendVividLight(base.g, blend.g), blendVividLight(base.b, blend.b));
			}
			float blendHardMix(float base, float blend)
			{
				return (blendVividLight(base, blend) < 0.5) ? 0.0 : 1.0;
			}
			float3 blendHardMix(float3 base, float3 blend)
			{
				return float3(blendHardMix(base.r, blend.r), blendHardMix(base.g, blend.g), blendHardMix(base.b, blend.b));
			}
			float blendLighten(float base, float blend)
			{
				return max(blend, base);
			}
			float3 blendLighten(float3 base, float3 blend)
			{
				return float3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
			}
			float blendLinearBurn(float base, float blend)
			{
				return max(base + blend - 1.0, 0.0);
			}
			float3 blendLinearBurn(float3 base, float3 blend)
			{
				return max(base + blend - float3(1.0, 1.0, 1.0), float3(0.0, 0.0, 0.0));
			}
			float blendLinearDodge(float base, float blend)
			{
				return min(base + blend, 1.0);
			}
			float3 blendLinearDodge(float3 base, float3 blend)
			{
				return min(base + blend, float3(1.0, 1.0, 1.0));
			}
			float blendLinearLight(float base, float blend)
			{
				return blend < 0.5 ? blendLinearBurn(base, (2.0 * blend)) : blendLinearDodge(base, (2.0 * (blend - 0.5)));
			}
			float3 blendLinearLight(float3 base, float3 blend)
			{
				return float3(blendLinearLight(base.r, blend.r), blendLinearLight(base.g, blend.g), blendLinearLight(base.b, blend.b));
			}
			float blendMultiply(float base, float blend)
			{
				return base * blend;
			}
			float3 blendMultiply(float3 base, float3 blend)
			{
				return base * blend;
			}
			float blendNegation(float base, float blend)
			{
				return 1.0 - abs(1.0 - base - blend);
			}
			float3 blendNegation(float3 base, float3 blend)
			{
				return float3(1.0, 1.0, 1.0) - abs(float3(1.0, 1.0, 1.0) - base - blend);
			}
			float blendNormal(float base, float blend)
			{
				return blend;
			}
			float3 blendNormal(float3 base, float3 blend)
			{
				return blend;
			}
			float blendPhoenix(float base, float blend)
			{
				return min(base, blend) - max(base, blend) + 1.0;
			}
			float3 blendPhoenix(float3 base, float3 blend)
			{
				return min(base, blend) - max(base, blend) + float3(1.0, 1.0, 1.0);
			}
			float blendPinLight(float base, float blend)
			{
				return (blend < 0.5) ? blendDarken(base, (2.0 * blend)) : blendLighten(base, (2.0 * (blend - 0.5)));
			}
			float3 blendPinLight(float3 base, float3 blend)
			{
				return float3(blendPinLight(base.r, blend.r), blendPinLight(base.g, blend.g), blendPinLight(base.b, blend.b));
			}
			float blendScreen(float base, float blend)
			{
				return 1.0 - ((1.0 - base) * (1.0 - blend));
			}
			float3 blendScreen(float3 base, float3 blend)
			{
				return float3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
			}
			float blendSoftLight(float base, float blend)
			{
				return (blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend));
			}
			float3 blendSoftLight(float3 base, float3 blend)
			{
				return float3(blendSoftLight(base.r, blend.r), blendSoftLight(base.g, blend.g), blendSoftLight(base.b, blend.b));
			}
			float blendSubtract(float base, float blend)
			{
				return max(base - blend, 0.0);
			}
			float3 blendSubtract(float3 base, float3 blend)
			{
				return max(base - blend, 0.0);
			}
			float blendDifference(float base, float blend)
			{
				return abs(base - blend);
			}
			float3 blendDifference(float3 base, float3 blend)
			{
				return abs(base - blend);
			}
			float blendDivide(float base, float blend)
			{
				return base / max(blend, 0.0001);
			}
			float3 blendDivide(float3 base, float3 blend)
			{
				return base / max(blend, 0.0001);
			}
			float blendMixed(float base, float blend)
			{
				return base + base * blend;
			}
			float3 blendMixed(float3 base, float3 blend)
			{
				return base + base * blend;
			}
			float3 customBlend(float3 base, float3 blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					case 6: return blendScreen(base, blend); break;
					case 8: return blendLinearDodge(base, blend); break;
					case 9: return blendOverlay(base, blend); break;
					case 20: return blendMixed(base, blend); break;
					default: return 0; break;
				}
			}
			float customBlend(float base, float blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					case 6: return blendScreen(base, blend); break;
					case 8: return blendLinearDodge(base, blend); break;
					case 9: return blendOverlay(base, blend); break;
					case 20: return blendMixed(base, blend); break;
					default: return 0; break;
				}
			}
			float3 customBlend(float3 base, float3 blend, float blendType, float alpha)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 8: output = lerp(base, blendLinearDodge(base, blend), alpha); break;
					case 9: output = lerp(base, blendOverlay(base, blend), alpha); break;
					case 20: output = lerp(base, blendMixed(base, blend), alpha); break;
					default: output = 0; break;
				}
				return output;
			}
			#define REPLACE 0
			#define SUBSTRACT 1
			#define MULTIPLY 2
			#define DIVIDE 3
			#define MIN 4
			#define MAX 5
			#define AVERAGE 6
			#define ADD 7
			float maskBlend(float baseMask, float blendMask, float blendType)
			{
				float output = 0;
				switch(blendType)
				{
					case REPLACE: output = blendMask; break;
					case SUBSTRACT: output = baseMask - blendMask; break;
					case MULTIPLY: output = baseMask * blendMask; break;
					case DIVIDE: output = baseMask / blendMask; break;
					case MIN: output = min(baseMask, blendMask); break;
					case MAX: output = max(baseMask, blendMask); break;
					case AVERAGE: output = (baseMask + blendMask) * 0.5; break;
					case ADD: output = baseMask + blendMask; break;
				}
				return saturate(output);
			}
			float random(float2 p)
			{
				return frac(sin(dot(p, float2(12.9898, 78.2383))) * 43758.5453123);
			}
			float2 random2(float2 p)
			{
				return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
			}
			float3 random3(float2 p)
			{
				return frac(sin(float3(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)), dot(p, float2(248.3, 315.9)))) * 43758.5453);
			}
			float3 random3(float3 p)
			{
				return frac(sin(float3(dot(p, float3(127.1, 311.7, 248.6)), dot(p, float3(269.5, 183.3, 423.3)), dot(p, float3(248.3, 315.9, 184.2)))) * 43758.5453);
			}
			float3 randomFloat3(float2 Seed, float maximum)
			{
				return (.5 + float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed), float2(12.9898, 78.233))) * 43758.5453)
				) * .5) * (maximum);
			}
			float3 randomFloat3Range(float2 Seed, float Range)
			{
				return (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1) * Range;
			}
			float3 randomFloat3WiggleRange(float2 Seed, float Range, float wiggleSpeed)
			{
				float3 rando = (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1);
				float speed = 1 + wiggleSpeed;
				return float3(sin((_Time.x + rando.x * PI) * speed), sin((_Time.x + rando.y * PI) * speed), sin((_Time.x + rando.z * PI) * speed)) * Range;
			}
			void poiDither(float4 In, float4 ScreenPosition, out float4 Out)
			{
				float2 uv = ScreenPosition.xy * _ScreenParams.xy;
				float DITHER_THRESHOLDS[16] = {
					1.0 / 17.0, 9.0 / 17.0, 3.0 / 17.0, 11.0 / 17.0,
					13.0 / 17.0, 5.0 / 17.0, 15.0 / 17.0, 7.0 / 17.0,
					4.0 / 17.0, 12.0 / 17.0, 2.0 / 17.0, 10.0 / 17.0,
					16.0 / 17.0, 8.0 / 17.0, 14.0 / 17.0, 6.0 / 17.0
				};
				uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
				Out = In - DITHER_THRESHOLDS[index];
			}
			static const float Epsilon = 1e-10;
			static const float3 HCYwts = float3(0.299, 0.587, 0.114);
			static const float HCLgamma = 3;
			static const float HCLy0 = 100;
			static const float HCLmaxL = 0.530454533953517; // == exp(HCLgamma / HCLy0) - 0.5
			static const float3 wref = float3(1.0, 1.0, 1.0);
			#define TAU 6.28318531
			float3 HUEtoRGB(in float H)
			{
				float R = abs(H * 6 - 3) - 1;
				float G = 2 - abs(H * 6 - 2);
				float B = 2 - abs(H * 6 - 4);
				return saturate(float3(R, G, B));
			}
			float3 RGBtoHCV(in float3 RGB)
			{
				float4 P = (RGB.g < RGB.b) ? float4(RGB.bg, -1.0, 2.0 / 3.0) : float4(RGB.gb, 0.0, -1.0 / 3.0);
				float4 Q = (RGB.r < P.x) ? float4(P.xyw, RGB.r) : float4(RGB.r, P.yzx);
				float C = Q.x - min(Q.w, Q.y);
				float H = abs((Q.w - Q.y) / (6 * C + Epsilon) + Q.z);
				return float3(H, C, Q.x);
			}
			float3 HSVtoRGB(in float3 HSV)
			{
				float3 RGB = HUEtoRGB(HSV.x);
				return ((RGB - 1) * HSV.y + 1) * HSV.z;
			}
			float3 RGBtoHSV(in float3 RGB)
			{
				float3 HCV = RGBtoHCV(RGB);
				float S = HCV.y / (HCV.z + Epsilon);
				return float3(HCV.x, S, HCV.z);
			}
			float3 HSLtoRGB(in float3 HSL)
			{
				float3 RGB = HUEtoRGB(HSL.x);
				float C = (1 - abs(2 * HSL.z - 1)) * HSL.y;
				return (RGB - 0.5) * C + HSL.z;
			}
			float3 RGBtoHSL(in float3 RGB)
			{
				float3 HCV = RGBtoHCV(RGB);
				float L = HCV.z - HCV.y * 0.5;
				float S = HCV.y / (1 - abs(L * 2 - 1) + Epsilon);
				return float3(HCV.x, S, L);
			}
			void DecomposeHDRColor(in float3 linearColorHDR, out float3 baseLinearColor, out float exposure)
			{
				float maxColorComponent = max(linearColorHDR.r, max(linearColorHDR.g, linearColorHDR.b));
				bool isSDR = maxColorComponent <= 1.0;
				float scaleFactor = isSDR ? 1.0 : (1.0 / maxColorComponent);
				exposure = isSDR ? 0.0 : log(maxColorComponent) * 1.44269504089; // ln(2)
				baseLinearColor = scaleFactor * linearColorHDR;
			}
			float3 ApplyHDRExposure(float3 linearColor, float exposure)
			{
				return linearColor * pow(2, exposure);
			}
			float3 ModifyViaHSV(float3 color, float h, float s, float v)
			{
				float3 colorHSV = RGBtoHSV(color);
				colorHSV.x = frac(colorHSV.x + h);
				colorHSV.y = saturate(colorHSV.y + s);
				colorHSV.z = saturate(colorHSV.z + v);
				return HSVtoRGB(colorHSV);
			}
			float3 ModifyViaHSV(float3 color, float3 HSVMod)
			{
				return ModifyViaHSV(color, HSVMod.x, HSVMod.y, HSVMod.z);
			}
			float3 hueShift(float3 color, float hueOffset)
			{
				color = RGBtoHSV(color);
				color.x = frac(hueOffset +color.x);
				return HSVtoRGB(color);
			}
			float xyzF(float t)
			{
				return lerp(pow(t, 1. / 3.), 7.787037 * t + 0.139731, step(t, 0.00885645));
			}
			float xyzR(float t)
			{
				return lerp(t * t * t, 0.1284185 * (t - 0.139731), step(t, 0.20689655));
			}
			float4x4 poiRotationMatrixFromAngles(float x, float y, float z)
			{
				float angleX = radians(x);
				float c = cos(angleX);
				float s = sin(angleX);
				float4x4 rotateXMatrix = float4x4(1, 0, 0, 0,
				0, c, -s, 0,
				0, s, c, 0,
				0, 0, 0, 1);
				float angleY = radians(y);
				c = cos(angleY);
				s = sin(angleY);
				float4x4 rotateYMatrix = float4x4(c, 0, s, 0,
				0, 1, 0, 0,
				- s, 0, c, 0,
				0, 0, 0, 1);
				float angleZ = radians(z);
				c = cos(angleZ);
				s = sin(angleZ);
				float4x4 rotateZMatrix = float4x4(c, -s, 0, 0,
				s, c, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1);
				return mul(mul(rotateXMatrix, rotateYMatrix), rotateZMatrix);
			}
			float4x4 poiRotationMatrixFromAngles(float3 angles)
			{
				float angleX = radians(angles.x);
				float c = cos(angleX);
				float s = sin(angleX);
				float4x4 rotateXMatrix = float4x4(1, 0, 0, 0,
				0, c, -s, 0,
				0, s, c, 0,
				0, 0, 0, 1);
				float angleY = radians(angles.y);
				c = cos(angleY);
				s = sin(angleY);
				float4x4 rotateYMatrix = float4x4(c, 0, s, 0,
				0, 1, 0, 0,
				- s, 0, c, 0,
				0, 0, 0, 1);
				float angleZ = radians(angles.z);
				c = cos(angleZ);
				s = sin(angleZ);
				float4x4 rotateZMatrix = float4x4(c, -s, 0, 0,
				s, c, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1);
				return mul(mul(rotateXMatrix, rotateYMatrix), rotateZMatrix);
			}
			float3 getCameraPosition()
			{
				#ifdef USING_STEREO_MATRICES
				return lerp(unity_StereoWorldSpaceCameraPos[0], unity_StereoWorldSpaceCameraPos[1], 0.5);
				#endif
				return _WorldSpaceCameraPos;
			}
			half2 calcScreenUVs(half4 grabPos)
			{
				half2 uv = grabPos.xy / (grabPos.w + 0.0000000001);
				#if UNITY_SINGLE_PASS_STEREO
				uv.xy *= half2(_ScreenParams.x * 2, _ScreenParams.y);
				#else
				uv.xy *= _ScreenParams.xy;
				#endif
				return uv;
			}
			float CalcMipLevel(float2 texture_coord)
			{
				float2 dx = ddx(texture_coord);
				float2 dy = ddy(texture_coord);
				float delta_max_sqr = max(dot(dx, dx), dot(dy, dy));
				return 0.5 * log2(delta_max_sqr);
			}
			float inverseLerp(float A, float B, float T)
			{
				return (T - A) / (B - A);
			}
			float inverseLerp2(float2 a, float2 b, float2 value)
			{
				float2 AB = b - a;
				float2 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float inverseLerp3(float3 a, float3 b, float3 value)
			{
				float3 AB = b - a;
				float3 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float inverseLerp4(float4 a, float4 b, float4 value)
			{
				float4 AB = b - a;
				float4 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float4 quaternion_conjugate(float4 v)
			{
				return float4(
				v.x, -v.yzw
				);
			}
			float4 quaternion_mul(float4 v1, float4 v2)
			{
				float4 result1 = (v1.x * v2 + v1 * v2.x);
				float4 result2 = float4(
				- dot(v1.yzw, v2.yzw),
				cross(v1.yzw, v2.yzw)
				);
				return float4(result1 + result2);
			}
			float4 get_quaternion_from_angle(float3 axis, float angle)
			{
				float sn = sin(angle * 0.5);
				float cs = cos(angle * 0.5);
				return float4(axis * sn, cs);
			}
			float4 quaternion_from_vector(float3 inVec)
			{
				return float4(0.0, inVec);
			}
			float degree_to_radius(float degree)
			{
				return (
				degree / 180.0 * PI
				);
			}
			float3 rotate_with_quaternion(float3 inVec, float3 rotation)
			{
				float4 qx = get_quaternion_from_angle(float3(1, 0, 0), radians(rotation.x));
				float4 qy = get_quaternion_from_angle(float3(0, 1, 0), radians(rotation.y));
				float4 qz = get_quaternion_from_angle(float3(0, 0, 1), radians(rotation.z));
				#define MUL3(A, B, C) quaternion_mul(quaternion_mul((A), (B)), (C))
				float4 quaternion = normalize(MUL3(qx, qy, qz));
				float4 conjugate = quaternion_conjugate(quaternion);
				float4 inVecQ = quaternion_from_vector(inVec);
				float3 rotated = (
				MUL3(quaternion, inVecQ, conjugate)
				).yzw;
				return rotated;
			}
			float4 transform(float4 input, float4 pos, float4 rotation, float4 scale)
			{
				input.rgb *= (scale.xyz * scale.w);
				input = float4(rotate_with_quaternion(input.xyz, rotation.xyz * rotation.w) + (pos.xyz * pos.w), input.w);
				return input;
			}
			float2 RotateUV(float2 _uv, float _radian, float2 _piv, float _time)
			{
				float RotateUV_ang = _radian;
				float RotateUV_cos = cos(_time * RotateUV_ang);
				float RotateUV_sin = sin(_time * RotateUV_ang);
				return (mul(_uv - _piv, float2x2(RotateUV_cos, -RotateUV_sin, RotateUV_sin, RotateUV_cos)) + _piv);
			}
			float3 poiThemeColor(in PoiMods poiMods, in float3 srcColor, in float themeIndex)
			{
				if (themeIndex == 0) return srcColor;
				themeIndex -= 1;
				if (themeIndex <= 3)
				{
					return poiMods.globalColorTheme[themeIndex];
				}
				#ifdef POI_AUDIOLINK
				if (poiMods.audioLinkAvailable)
				{
					return poiMods.globalColorTheme[themeIndex];
				}
				#endif
				return srcColor;
			}
			float3 lilToneCorrection(float3 c, float4 hsvg)
			{
				c = pow(abs(c), hsvg.w);
				float4 p = (c.b > c.g) ? float4(c.bg, -1.0, 2.0 / 3.0) : float4(c.gb, 0.0, -1.0 / 3.0);
				float4 q = (p.x > c.r) ? float4(p.xyw, c.r) : float4(c.r, p.yzx);
				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				float3 hsv = float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
				hsv = float3(hsv.x + hsvg.x, saturate(hsv.y * hsvg.y), saturate(hsv.z * hsvg.z));
				return hsv.z - hsv.z * hsv.y + hsv.z * hsv.y * saturate(abs(frac(hsv.x + float3(1.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0) - 1.0);
			}
			float lilIsIn0to1(float f)
			{
				float value = 0.5 - abs(f - 0.5);
				return saturate(value / clamp(fwidth(value), 0.0001, 1.0));
			}
			float lilIsIn0to1(float f, float nv)
			{
				float value = 0.5 - abs(f - 0.5);
				return saturate(value / clamp(fwidth(value), 0.0001, nv));
			}
			float poiEdgeLinearNoSaturate(float value, float border)
			{
				return (value - border) / clamp(fwidth(value), 0.0001, 1.0);
			}
			float3 poiEdgeLinearNoSaturate(float value, float3 border)
			{
				return float3(
				(value - border.x) / clamp(fwidth(value), 0.0001, 1.0),
				(value - border.y) / clamp(fwidth(value), 0.0001, 1.0),
				(value - border.z) / clamp(fwidth(value), 0.0001, 1.0)
				);
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur)
			{
				float borderMin = saturate(border - blur * 0.5);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / saturate(borderMax - borderMin + fwidth(value));
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / saturate(borderMax - borderMin + fwidth(value));
			}
			float poiEdgeNonLinearNoSaturate(float value, float border)
			{
				float fwidthValue = fwidth(value);
				return smoothstep(border - fwidthValue, border + fwidthValue, value);
			}
			float poiEdgeNonLinearNoSaturate(float value, float border, float blur)
			{
				float fwidthValue = fwidth(value);
				float borderMin = saturate(border - blur * 0.5);
				float borderMax = saturate(border + blur * 0.5);
				return smoothstep(borderMin - fwidthValue, borderMax + fwidthValue, value);
			}
			float poiEdgeNonLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float fwidthValue = fwidth(value);
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return smoothstep(borderMin - fwidthValue, borderMax + fwidthValue, value);
			}
			float poiEdgeNonLinear(float value, float border)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border));
			}
			float poiEdgeNonLinear(float value, float border, float blur)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border, blur));
			}
			float poiEdgeNonLinear(float value, float border, float blur, float borderRange)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border, blur, borderRange));
			}
			float poiEdgeLinear(float value, float border)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border));
			}
			float poiEdgeLinear(float value, float border, float blur)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border, blur));
			}
			float poiEdgeLinear(float value, float border, float blur, float borderRange)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border, blur, borderRange));
			}
			float3 OpenLitLinearToSRGB(float3 col)
			{
				return LinearToGammaSpace(col);
			}
			float3 OpenLitSRGBToLinear(float3 col)
			{
				return GammaToLinearSpace(col);
			}
			float OpenLitLuminance(float3 rgb)
			{
				#if defined(UNITY_COLORSPACE_GAMMA)
				return dot(rgb, float3(0.22, 0.707, 0.071));
				#else
				return dot(rgb, float3(0.0396819152, 0.458021790, 0.00609653955));
				#endif
			}
			float OpenLitGray(float3 rgb)
			{
				return dot(rgb, float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
			}
			void OpenLitShadeSH9ToonDouble(float3 lightDirection, out float3 shMax, out float3 shMin)
			{
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 N = lightDirection * 0.666666;
				float4 vB = N.xyzz * N.yzzx;
				float3 res = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
				res.r += dot(unity_SHBr, vB);
				res.g += dot(unity_SHBg, vB);
				res.b += dot(unity_SHBb, vB);
				res += unity_SHC.rgb * (N.x * N.x - N.y * N.y);
				float3 l1;
				l1.r = dot(unity_SHAr.rgb, N);
				l1.g = dot(unity_SHAg.rgb, N);
				l1.b = dot(unity_SHAb.rgb, N);
				shMax = res + l1;
				shMin = res - l1;
				#if defined(UNITY_COLORSPACE_GAMMA)
				shMax = OpenLitLinearToSRGB(shMax);
				shMin = OpenLitLinearToSRGB(shMin);
				#endif
				#else
				shMax = 0.0;
				shMin = 0.0;
				#endif
			}
			float3 OpenLitComputeCustomLightDirection(float4 lightDirectionOverride)
			{
				float3 customDir = length(lightDirectionOverride.xyz) * normalize(mul((float3x3)unity_ObjectToWorld, lightDirectionOverride.xyz));
				return lightDirectionOverride.w ? customDir : lightDirectionOverride.xyz; // .w isn't doc'd anywhere and is always 0 unless end user changes it
			}
			float3 OpenLitLightingDirectionForSH9()
			{
				float3 mainDir = _WorldSpaceLightPos0.xyz * OpenLitLuminance(_LightColor0.rgb);
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 sh9Dir = unity_SHAr.xyz * 0.333333 + unity_SHAg.xyz * 0.333333 + unity_SHAb.xyz * 0.333333;
				float3 sh9DirAbs = float3(sh9Dir.x, abs(sh9Dir.y), sh9Dir.z);
				#else
				float3 sh9Dir = 0;
				float3 sh9DirAbs = 0;
				#endif
				float3 lightDirectionForSH9 = sh9Dir + mainDir;
				lightDirectionForSH9 = dot(lightDirectionForSH9, lightDirectionForSH9) < 0.000001 ? 0 : normalize(lightDirectionForSH9);
				return lightDirectionForSH9;
			}
			float3 OpenLitLightingDirection(float4 lightDirectionOverride)
			{
				float3 mainDir = _WorldSpaceLightPos0.xyz * OpenLitLuminance(_LightColor0.rgb);
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 sh9Dir = unity_SHAr.xyz * 0.333333 + unity_SHAg.xyz * 0.333333 + unity_SHAb.xyz * 0.333333;
				float3 sh9DirAbs = float3(sh9Dir.x, abs(sh9Dir.y), sh9Dir.z);
				#else
				float3 sh9Dir = 0;
				float3 sh9DirAbs = 0;
				#endif
				float3 customDir = OpenLitComputeCustomLightDirection(lightDirectionOverride);
				return normalize(sh9DirAbs + mainDir + customDir);
			}
			float3 OpenLitLightingDirection()
			{
				float4 customDir = float4(0.001, 0.002, 0.001, 0.0);
				return OpenLitLightingDirection(customDir);
			}
			inline float4 CalculateFrustumCorrection()
			{
				float x1 = -UNITY_MATRIX_P._31 / (UNITY_MATRIX_P._11 * UNITY_MATRIX_P._34);
				float x2 = -UNITY_MATRIX_P._32 / (UNITY_MATRIX_P._22 * UNITY_MATRIX_P._34);
				return float4(x1, x2, 0, UNITY_MATRIX_P._33 / UNITY_MATRIX_P._34 + x1 * UNITY_MATRIX_P._13 + x2 * UNITY_MATRIX_P._23);
			}
			inline float CorrectedLinearEyeDepth(float z, float B)
			{
				return 1.0 / (z / UNITY_MATRIX_P._34 + B);
			}
			float2 sharpSample(float4 texelSize, float2 p)
			{
				p = p * texelSize.zw;
				float2 c = max(0.0, fwidth(p));
				p = floor(p) + saturate(frac(p) / c);
				p = (p - 0.5) * texelSize.xy;
				return p;
			}
			void applyToGlobalMask(inout PoiMods poiMods, int index, int blendType, float val)
			{
				float valBlended = saturate(maskBlend(poiMods.globalMask[index], val, blendType));
				switch(index)
				{
					case 0: poiMods.globalMask[0] = valBlended; break;
					case 1: poiMods.globalMask[1] = valBlended; break;
					case 2: poiMods.globalMask[2] = valBlended; break;
					case 3: poiMods.globalMask[3] = valBlended; break;
					case 4: poiMods.globalMask[4] = valBlended; break;
					case 5: poiMods.globalMask[5] = valBlended; break;
					case 6: poiMods.globalMask[6] = valBlended; break;
					case 7: poiMods.globalMask[7] = valBlended; break;
					case 8: poiMods.globalMask[8] = valBlended; break;
					case 9: poiMods.globalMask[9] = valBlended; break;
					case 10: poiMods.globalMask[10] = valBlended; break;
					case 11: poiMods.globalMask[11] = valBlended; break;
					case 12: poiMods.globalMask[12] = valBlended; break;
					case 13: poiMods.globalMask[13] = valBlended; break;
					case 14: poiMods.globalMask[14] = valBlended; break;
					case 15: poiMods.globalMask[15] = valBlended; break;
				}
			}
			void assignValueToVectorFromIndex(inout float4 vec, int index, float value)
			{
				switch(index)
				{
					case 0: vec[0] = value; break;
					case 1: vec[1] = value; break;
					case 2: vec[2] = value; break;
					case 3: vec[3] = value; break;
				}
			}
			float3 mod289(float3 x)
			{
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			float2 mod289(float2 x)
			{
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			float3 permute(float3 x)
			{
				return mod289(((x * 34.0) + 1.0) * x);
			}
			float snoise(float2 v)
			{
				const float4 C = float4(0.211324865405187, // (3.0-sqrt(3.0))/6.0
				0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
				- 0.577350269189626, // -1.0 + 2.0 * C.x
				0.024390243902439); // 1.0 / 41.0
				float2 i = floor(v + dot(v, C.yy));
				float2 x0 = v - i + dot(i, C.xx);
				float2 i1;
				i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod289(i); // Avoid truncation effects in permutation
				float3 p = permute(permute(i.y + float3(0.0, i1.y, 1.0))
				+ i.x + float3(0.0, i1.x, 1.0));
				float3 m = max(0.5 - float3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
				m = m * m ;
				m = m * m ;
				float3 x = 2.0 * frac(p * C.www) - 1.0;
				float3 h = abs(x) - 0.5;
				float3 ox = floor(x + 0.5);
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot(m, g);
			}
			VertexOut vert(
			#ifndef POI_TESSELLATED
			appdata v
			#else
			tessAppData v
			#endif
			)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				VertexOut o;
				PoiInitStruct(VertexOut, o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				#ifdef POI_TESSELLATED
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(v);
				#endif
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.objectPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				o.objNormal = v.normal;
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.tangent = UnityObjectToWorldDir(v.tangent);
				o.binormal = cross(o.normal, o.tangent) * (v.tangent.w * unity_WorldTransformParams.w);
				o.vertexColor = v.color;
				o.uv[0] = v.uv0;
				o.uv[1] = v.uv1;
				o.uv[2] = v.uv2;
				o.uv[3] = v.uv3;
				#if defined(LIGHTMAP_ON)
				o.lightmapUV.xy = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				#ifdef DYNAMICLIGHTMAP_ON
				o.lightmapUV.zw = v.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				o.localPos = v.vertex;
				o.worldPos = mul(unity_ObjectToWorld, o.localPos);
				float3 localOffset = float3(0, 0, 0);
				float3 worldOffset = float3(0, 0, 0);
				o.localPos.rgb += localOffset;
				o.worldPos.rgb += worldOffset;
				o.pos = UnityObjectToClipPos(o.localPos);
				#ifdef POI_PASS_OUTLINE
				#if defined(UNITY_REVERSED_Z)
				o.pos.z += _Offset_Z * - 0.01;
				#else
				o.pos.z += _Offset_Z * 0.01;
				#endif
				#endif
				o.grabPos = ComputeGrabScreenPos(o.pos);
				#ifndef FORWARD_META_PASS
				#if !defined(UNITY_PASS_SHADOWCASTER)
				UNITY_TRANSFER_SHADOW(o, o.uv[0].xy);
				#else
				v.vertex.xyz = o.localPos.xyz;
				TRANSFER_SHADOW_CASTER_NOPOS(o, o.pos);
				#endif
				#endif
				UNITY_TRANSFER_FOG(o, o.pos);
				if (0.0)
				{
					if (o.pos.w < _ProjectionParams.y * 1.01 && o.pos.w > 0)
					{
						o.pos.z = o.pos.z * 0.0001 + o.pos.w * 0.999;
					}
				}
				#ifdef POI_PASS_META
				o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
				#endif
				#if defined(GRAIN)
				float4 worldDirection;
				worldDirection.xyz = o.worldPos.xyz - _WorldSpaceCameraPos;
				worldDirection.w = dot(o.pos, CalculateFrustumCorrection());
				o.worldDirection = worldDirection;
				#endif
				return o;
			}
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, uv) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan)) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if defined(_STOCHASTICMODE_HEXTILE)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, uv, false) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), false) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), false, dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#ifndef POI2D_SAMPLER_STOCHASTIC
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (POI2D_SAMPLER(tex, texSampler, uv))
			#endif
			#ifndef POI2D_SAMPLER_PAN_STOCHASTIC
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#endif
			#ifndef POI2D_SAMPLER_PANGRAD_STOCHASTIC
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if !defined(_STOCHASTICMODE_NONE)
			float2 StochasticHash2D2D (float2 s)
			{
				return frac(sin(glsl_mod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159)) * 43758.5453);
			}
			#endif
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			float3x3 DeliotHeitzStochasticUVBW(float2 uv)
			{
				const float2x2 stochasticSkewedGrid = float2x2(1.0, -0.57735027, 0.0, 1.15470054);
				float2 skewUV = mul(stochasticSkewedGrid, uv * 3.4641 * 1.0);
				float2 vxID = floor(skewUV);
				float3 bary = float3(frac(skewUV), 0);
				bary.z = 1.0 - bary.x - bary.y;
				float3x3 pos = float3x3(
				float3(vxID, 				bary.z),
				float3(vxID + float2(0, 1), bary.y),
				float3(vxID + float2(1, 0), bary.x)
				);
				float3x3 neg = float3x3(
				float3(vxID + float2(1, 1), 	 -bary.z),
				float3(vxID + float2(1, 0), 1.0 - bary.y),
				float3(vxID + float2(0, 1), 1.0 - bary.x)
				);
				return (bary.z > 0) ? pos : neg;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, float2 dx, float2 dy)
			{
				float3x3 UVBW = DeliotHeitzStochasticUVBW(uv);
				return 	mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[0].xy), dx, dy), UVBW[0].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[1].xy), dx, dy), UVBW[1].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[2].xy), dx, dy), UVBW[2].z) ;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv)
			{
				float2 dx = ddx(uv), dy = ddy(uv);
				return DeliotHeitzSampleTexture(tex, texSampler, uv, dx, dy);
			}
			#endif // defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#if defined(_STOCHASTICMODE_HEXTILE)
			float2 HextileMakeCenUV(float2 vertex)
			{
				const float2x2 stochasticInverseSkewedGrid = float2x2(1.0, 0.5, 0.0, 1.0/1.15470054);
				return mul(stochasticInverseSkewedGrid, vertex) * 0.288675;
			}
			float2x2 HextileLoadRot2x2(float2 idx, float rotStrength)
			{
				float angle = abs(idx.x * idx.y) + abs(idx.x + idx.y) + PI;
				angle = glsl_mod(angle, 2 * PI);
				if(angle < 0)  angle += 2 * PI;
				if(angle > PI) angle -= 2 * PI;
				angle *= rotStrength;
				float cs = cos(angle), si = sin(angle);
				return float2x2(cs, -si, si, cs);
			}
			float4x4 HextileUVBWR(float2 uv)
			{
				const float2x2 stochasticSkewedGrid = float2x2(1.0, -0.57735027, 0.0, 1.15470054);
				float2 skewedCoord = mul(stochasticSkewedGrid, uv * 3.4641 * 1.0);
				float2 baseId = float2(floor(skewedCoord));
				float3 temp = float3(frac(skewedCoord), 0);
				temp.z = 1 - temp.x - temp.y;
				float s = step(0.0, -temp.z);
				float s2 = 2 * s - 1;
				float3 weights = float3(-temp.z * s2, s - temp.y * s2, s - temp.x * s2);
				float2 vertex0 = baseId + float2(s, s);
				float2 vertex1 = baseId + float2(s, 1 - s);
				float2 vertex2 = baseId + float2(1 - s, s);
				float2 cen0 = HextileMakeCenUV(vertex0), cen1 = HextileMakeCenUV(vertex1), cen2 = HextileMakeCenUV(vertex2);
				float2x2 rot0 = float2x2(1, 0, 0, 1), rot1 = float2x2(1, 0, 0, 1), rot2 = float2x2(1, 0, 0, 1);
				if(0.0 > 0)
				{
					rot0 = HextileLoadRot2x2(vertex0, 0.0);
					rot1 = HextileLoadRot2x2(vertex1, 0.0);
					rot2 = HextileLoadRot2x2(vertex2, 0.0);
				}
				return float4x4(
				float4(mul(uv - cen0, rot0) + cen0 + StochasticHash2D2D(vertex0), rot0[0].x, -rot0[0].y),
				float4(mul(uv - cen1, rot1) + cen1 + StochasticHash2D2D(vertex1), rot1[0].x, -rot1[0].y),
				float4(mul(uv - cen2, rot2) + cen2 + StochasticHash2D2D(vertex2), rot2[0].x, -rot2[0].y),
				float4(weights, 0)
				);
			}
			float4 HextileSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, bool isNormalMap, float2 dUVdx, float2 dUVdy)
			{
				float4x4 UVBWR = HextileUVBWR(uv);
				float2x2 rot0 = float2x2(1, 0, 0, 1), rot1 = float2x2(1, 0, 0, 1), rot2 = float2x2(1, 0, 0, 1);
				if(0.0 > 0)
				{
					rot0 = float2x2(UVBWR[0].z, -UVBWR[0].w, UVBWR[0].w, UVBWR[0].z);
					rot1 = float2x2(UVBWR[1].z, -UVBWR[1].w, UVBWR[1].w, UVBWR[1].z);
					rot2 = float2x2(UVBWR[2].z, -UVBWR[2].w, UVBWR[2].w, UVBWR[2].z);
				}
				float3 W = UVBWR[3].xyz;
				float4 c0 = tex.SampleGrad(texSampler, UVBWR[0].xy, mul(dUVdx, rot0), mul(dUVdy, rot0));
				float4 c1 = tex.SampleGrad(texSampler, UVBWR[1].xy, mul(dUVdx, rot1), mul(dUVdy, rot1));
				float4 c2 = tex.SampleGrad(texSampler, UVBWR[2].xy, mul(dUVdx, rot2), mul(dUVdy, rot2));
				const float3 Lw = float3(0.299, 0.587, 0.114);
				float3 Dw = float3(dot(c0.xyz, Lw), dot(c1.xyz, Lw), dot(c2.xyz, Lw));
				Dw = lerp(1.0, Dw, 0.6);
				W = Dw * pow(W, 7.0);
				W /= (W.x + W.y + W.z);
				return W.x * c0 + W.y * c1 + W.z * c2;
			}
			float4 HextileSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, bool isNormalMap)
			{
				return HextileSampleTexture(tex, texSampler, uv, isNormalMap, ddx(uv), ddy(uv));
			}
			#endif // defined(_STOCHASTICMODE_HEXTILE)
			void applyAlphaOptions(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiMods poiMods)
			{
				poiFragData.alpha = saturate(poiFragData.alpha + 0.0);
				if (0.0 > 0)
				{
					poiFragData.alpha = maskBlend(poiFragData.alpha, poiMods.globalMask[0.0-1], 2.0);
				}
			}
			void calculateGlobalThemes(inout PoiMods poiMods)
			{
				float4 themeColorExposures = 0;
				float4 themeColor0, themeColor1, themeColor2, themeColor3 = 0;
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor0.rgb, themeColorExposures.x);
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor1.rgb, themeColorExposures.y);
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor2.rgb, themeColorExposures.z);
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor3.rgb, themeColorExposures.w);
				poiMods.globalColorTheme[0] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor0.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.x), float4(1,1,1,1).a);
				poiMods.globalColorTheme[1] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor1.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.y), float4(1,1,1,1).a);
				poiMods.globalColorTheme[2] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor2.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.z), float4(1,1,1,1).a);
				poiMods.globalColorTheme[3] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor3.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.w), float4(1,1,1,1).a);
			}
			float customDistanceBlend(float base, float blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					default: return 0; break;
				}
			}
			void ApplyGlobalMaskModifiers(in PoiMesh poiMesh, inout PoiMods poiMods, in PoiCam poiCam)
			{
			}
			float2 calculatePolarCoordinate(in PoiMesh poiMesh)
			{
				float2 delta = poiMesh.uv[0.0] - float4(0.5,0.5,0,0);
				float radius = length(delta) * 2 * 1.0;
				float angle = atan2(delta.x, delta.y);
				float phi = angle / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				angle = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				angle *= 1.0;
				return float2(radius, angle + distance(poiMesh.uv[0.0], float4(0.5,0.5,0,0)) * 0.0);
			}
			float2 MonoPanoProjection(float3 coords)
			{
				float3 normalizedCoords = normalize(coords);
				float latitude = acos(normalizedCoords.y);
				float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
				float phi = longitude / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				longitude = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				longitude *= 2;
				float2 sphereCoords = float2(longitude, latitude) * float2(1.0, 1.0 / UNITY_PI);
				sphereCoords = float2(1.0, 1.0) - sphereCoords;
				return (sphereCoords + float4(0, 1 - unity_StereoEyeIndex, 1, 1.0).xy) * float4(0, 1 - unity_StereoEyeIndex, 1, 1.0).zw;
			}
			float2 StereoPanoProjection(float3 coords)
			{
				float3 normalizedCoords = normalize(coords);
				float latitude = acos(normalizedCoords.y);
				float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
				float phi = longitude / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				longitude = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				longitude *= 2;
				float2 sphereCoords = float2(longitude, latitude) * float2(0.5, 1.0 / UNITY_PI);
				sphereCoords = float2(0.5, 1.0) - sphereCoords;
				return (sphereCoords + float4(0, 1 - unity_StereoEyeIndex, 1, 0.5).xy) * float4(0, 1 - unity_StereoEyeIndex, 1, 0.5).zw;
			}
			float2 calculateWorldUV(in PoiMesh poiMesh)
			{
				return float2(0.0 != 3 ? poiMesh.worldPos[ 0.0] : 0.0f, 2.0 != 3 ? poiMesh.worldPos[2.0] : 0.0f);
			}
			float2 calculatelocalUV(in PoiMesh poiMesh)
			{
				float localUVs[8];
				localUVs[0] = poiMesh.localPos.x;
				localUVs[1] = poiMesh.localPos.y;
				localUVs[2] = poiMesh.localPos.z;
				localUVs[3] = 0;
				localUVs[4] = poiMesh.vertexColor.r;
				localUVs[5] = poiMesh.vertexColor.g;
				localUVs[6] = poiMesh.vertexColor.b;
				localUVs[7] = poiMesh.vertexColor.a;
				return float2(localUVs[0.0],localUVs[1.0]);
			}
			float2 calculatePanosphereUV(in PoiMesh poiMesh)
			{
				float3 viewDirection = normalize(lerp(getCameraPosition().xyz, _WorldSpaceCameraPos.xyz, 1.0) - poiMesh.worldPos.xyz) * - 1;
				return lerp(MonoPanoProjection(viewDirection), StereoPanoProjection(viewDirection), 0.0);
			}
			#if defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL) || defined(GEOM_TYPE_FROND) || defined(DEPTH_OF_FIELD_COC_VIEW)
			float2 decalUV(float uvNumber, float2 position, half rotation, half rotationSpeed, half2 scale, float4 scaleOffset, float depth, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				scaleOffset = float4(-scaleOffset.x, scaleOffset.y, -scaleOffset.z, scaleOffset.w);
				float2 centerOffset = float2((scaleOffset.x + scaleOffset.y)/2, (scaleOffset.z + scaleOffset.w)/2);
				float2 uv = poiMesh.uv[uvNumber] + calcParallax(depth + 1, poiCam);
				float2 decalCenter = position + centerOffset;
				float theta = radians(rotation + _Time.z * rotationSpeed);
				float cs = cos(theta);
				float sn = sin(theta);
				uv = float2((uv.x - decalCenter.x) * cs - (uv.y - decalCenter.y) * sn + decalCenter.x, (uv.x - decalCenter.x) * sn + (uv.y - decalCenter.y) * cs + decalCenter.y);
				uv = remap(uv, float2(0, 0) - scale / 2 + position + scaleOffset.xz, scale / 2 + position + scaleOffset.yw, float2(0, 0), float2(1, 1));
				return uv;
			}
			inline float3 decalHueShift(float enabled, float3 color, float shift, float shiftSpeed)
			{
				if (enabled)
				{
					color = hueShift(color, shift + _Time.x * shiftSpeed);
				}
				return color;
			}
			inline float applyTilingClipping(float enabled, float2 uv)
			{
				float ret = 1;
				if (!enabled)
				{
					if (uv.x > 1 || uv.y > 1 || uv.x < 0 || uv.y < 0)
					{
						ret = 0;
					}
				}
				return ret;
			}
			struct PoiDecal
			{
				float m_DecalMaskChannel;
				float m_DecalGlobalMask;
				float m_DecalGlobalMaskBlendType;
				float m_DecalApplyGlobalMaskIndex;
				float m_DecalApplyGlobalMaskBlendType;
				float4 m_DecalTexture_ST;
				float2 m_DecalTexturePan;
				float m_DecalTextureUV;
				float4 m_DecalColor;
				float m_DecalColorThemeIndex;
				fixed m_DecalTiled;
				float m_DecalBlendType;
				half m_DecalRotation;
				half2 m_DecalScale;
				float4 m_DecalSideOffset;
				half2 m_DecalPosition;
				half m_DecalRotationSpeed;
				float m_DecalEmissionStrength;
				float m_DecalBlendAlpha;
				float m_DecalOverrideAlpha;
				float m_DecalHueShiftEnabled;
				float m_DecalHueShift;
				float m_DecalHueShiftSpeed;
				float m_DecalDepth;
				float m_DecalHueAngleStrength;
				float m_DecalChannelSeparationEnable;
				float m_DecalChannelSeparation;
				float m_DecalChannelSeparationPremultiply;
				float m_DecalChannelSeparationHue;
				float m_DecalChannelSeparationVertical;
				float m_DecalChannelSeparationAngleStrength;
				#if defined(POI_AUDIOLINK)
				half m_AudioLinkDecalScaleBand;
				float4 m_AudioLinkDecalScale;
				half m_AudioLinkDecalRotationBand;
				float2 m_AudioLinkDecalRotation;
				half m_AudioLinkDecalAlphaBand;
				float2 m_AudioLinkDecalAlpha;
				half m_AudioLinkDecalEmissionBand;
				float2 m_AudioLinkDecalEmission;
				float m_DecalRotationCTALBand;
				float m_DecalRotationCTALSpeed;
				float m_DecalRotationCTALType;
				float m_AudioLinkDecalColorChord;
				float m_AudioLinkDecalSideBand;
				float4 m_AudioLinkDecalSideMin;
				float4 m_AudioLinkDecalSideMax;
				float2 m_AudioLinkDecalChannelSeparation;
				float m_AudioLinkDecalChannelSeparationBand;
				#endif
				float4 decalColor;
				float2 decalScale;
				float decalRotation;
				float2 uv;
				float4 dduv;
				float4 sideMod;
				float decalChannelOffset;
				float4 decalMask;
				void Init(in float4 DecalMask)
				{
					decalMask = DecalMask;
					decalScale = m_DecalScale;
				}
				void InitAudiolink(in PoiMods poiMods)
				{
					#ifdef POI_AUDIOLINK
					if (poiMods.audioLinkAvailable)
					{
						decalScale += lerp(m_AudioLinkDecalScale.xy, m_AudioLinkDecalScale.zw, poiMods.audioLink[m_AudioLinkDecalScaleBand]);
						sideMod += lerp(m_AudioLinkDecalSideMin, m_AudioLinkDecalSideMax, poiMods.audioLink[m_AudioLinkDecalSideBand]);
						decalRotation += lerp(m_AudioLinkDecalRotation.x, m_AudioLinkDecalRotation.y, poiMods.audioLink[m_AudioLinkDecalRotationBand]);
						decalRotation += AudioLinkGetChronoTime(m_DecalRotationCTALType, m_DecalRotationCTALBand) * m_DecalRotationCTALSpeed * 360;
						decalChannelOffset += lerp(m_AudioLinkDecalChannelSeparation[0], m_AudioLinkDecalChannelSeparation[1], poiMods.audioLink[m_AudioLinkDecalChannelSeparationBand]);
					}
					#endif
				}
				void SampleDecalNoTexture(in PoiMods poiMods, in PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
				{
					uv = decalUV(m_DecalTextureUV, m_DecalPosition, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					decalColor = float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					decalColor.rgb = decalHueShift(m_DecalHueShiftEnabled, decalColor.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					decalColor.a *= decalMask[m_DecalMaskChannel] * applyTilingClipping(m_DecalTiled, uv);
				}
				void SampleDecal(sampler2D decalTexture, in PoiMods poiMods, in PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
				{
					uv = decalUV(m_DecalTextureUV, m_DecalPosition, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					float4 dduv = any(fwidth(uv) > .5) ? 0.001 : float4(ddx(uv) * m_DecalTexture_ST.x, ddy(uv) * m_DecalTexture_ST.y);
					decalColor = tex2D(decalTexture, poiUV(uv, m_DecalTexture_ST) + m_DecalTexturePan * _Time.x, dduv.xy, dduv.zw) * float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					decalColor.rgb = decalHueShift(m_DecalHueShiftEnabled, decalColor.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					decalColor.a *= decalMask[m_DecalMaskChannel] * applyTilingClipping(m_DecalTiled, uv);
				}
				void SampleDecalChannelSeparation(sampler2D decalTexture, in PoiMods poiMods, in PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
				{
					decalColor = 0;
					decalChannelOffset += m_DecalChannelSeparation + m_DecalChannelSeparationAngleStrength * (m_DecalChannelSeparationAngleStrength > 0 ? (1 - poiLight.nDotV) : poiLight.nDotV);
					float2 positionOffset = decalChannelOffset * 0.01 * (decalScale.x + decalScale.y) * float2(cos(m_DecalChannelSeparationVertical), sin(m_DecalChannelSeparationVertical));
					float2 uvSample0 = decalUV(m_DecalTextureUV, m_DecalPosition + positionOffset, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					float2 uvSample1 = decalUV(m_DecalTextureUV, m_DecalPosition - positionOffset, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					float4 dduvSample0 = any(fwidth(uvSample0) > .5) ? 0.001 : float4(ddx(uvSample0) * m_DecalTexture_ST.x, ddy(uvSample0) * m_DecalTexture_ST.y);
					float4 dduvSample1 = any(fwidth(uvSample1) > .5) ? 0.001 : float4(ddx(uvSample1) * m_DecalTexture_ST.x, ddy(uvSample1) * m_DecalTexture_ST.y);
					float4 sample0 = tex2D(decalTexture, poiUV(uvSample0, m_DecalTexture_ST) + m_DecalTexturePan * _Time.x, dduvSample0.xy, dduvSample0.zw) * float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					float4 sample1 = tex2D(decalTexture, poiUV(uvSample1, m_DecalTexture_ST) + m_DecalTexturePan * _Time.x, dduvSample1.xy, dduvSample1.zw) * float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					sample0.rgb = decalHueShift(m_DecalHueShiftEnabled, sample0.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					sample1.rgb = decalHueShift(m_DecalHueShiftEnabled, sample1.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					float3 channelSeparationColor = HUEtoRGB(frac(m_DecalChannelSeparationHue));
					if (m_DecalChannelSeparationPremultiply)
					{
						decalColor.rgb = lerp(sample0 * sample0.a, sample1 * sample1.a, channelSeparationColor);
					}
					else
					{
						decalColor.rgb = lerp(sample0, sample1, channelSeparationColor);
					}
					decalColor.a = 0.5 * (sample0.a + sample1.a);
					decalColor.a *= decalMask[m_DecalMaskChannel] * max(applyTilingClipping(m_DecalTiled, uvSample0), applyTilingClipping(m_DecalTiled, uvSample1));
				}
				void Apply(inout float alphaOverride, inout float decalAlpha, inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, inout PoiMods poiMods, in PoiLight poiLight)
				{
					if (m_DecalGlobalMask > 0)
					{
						decalColor.a = maskBlend(decalColor.a, poiMods.globalMask[m_DecalGlobalMask - 1], m_DecalGlobalMaskBlendType);
					}
					float audioLinkDecalAlpha = 0;
					float audioLinkDecalEmission = 0;
					#ifdef POI_AUDIOLINK
					audioLinkDecalEmission = lerp(m_AudioLinkDecalEmission.x, m_AudioLinkDecalEmission.y, poiMods.audioLink[m_AudioLinkDecalEmissionBand]) * poiMods.audioLinkAvailable;
					if (m_AudioLinkDecalColorChord)
					{
						if (poiMods.audioLinkAvailable)
						{
							decalColor.rgb *= AudioLinkLerp(ALPASS_CCSTRIP + float2(uv.x * AUDIOLINK_WIDTH, 0)).rgb;
						}
						else
						{
							decalAlpha = 0;
						}
					}
					audioLinkDecalAlpha = lerp(m_AudioLinkDecalAlpha.x, m_AudioLinkDecalAlpha.y, poiMods.audioLink[m_AudioLinkDecalAlphaBand]) * poiMods.audioLinkAvailable;
					#endif
					if (m_DecalOverrideAlpha)
					{
						alphaOverride += 1;
						decalAlpha = lerp(decalAlpha, min(decalAlpha, decalColor.a), decalMask[m_DecalMaskChannel]);
					}
					float decalAlphaMixed = decalColor.a * saturate(m_DecalBlendAlpha + audioLinkDecalAlpha);
					if (m_DecalApplyGlobalMaskIndex > 0)
					{
						applyToGlobalMask(poiMods, m_DecalApplyGlobalMaskIndex - 1, m_DecalApplyGlobalMaskBlendType, decalAlphaMixed);
					}
					poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, customBlend(poiFragData.baseColor.rgb, decalColor.rgb, m_DecalBlendType), decalAlphaMixed);
					poiFragData.emission += decalColor.rgb * decalColor.a * max(m_DecalEmissionStrength + audioLinkDecalEmission, 0);
				}
			};
			void applyDecals(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, inout PoiMods poiMods, in PoiLight poiLight)
			{
				float decalAlpha = 1;
				float alphaOverride = 0;
				#if defined(PROP_DECALMASK) || !defined(OPTIMIZER_ENABLED)
				float4 decalMask = POI2D_SAMPLER_PAN(_DecalMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				#else
				float4 decalMask = 1;
				#endif
				#ifdef TPS_Penetrator
				if (0.0)
				{
					decalMask.r = lerp(0, decalMask.r * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					decalMask.g = lerp(0, decalMask.g * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					decalMask.b = lerp(0, decalMask.b * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					decalMask.a = lerp(0, decalMask.a * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
				}
				#endif
				float4 decalColor = 1;
				float2 uv = 0;
				if (alphaOverride)
				{
					poiFragData.alpha *= decalAlpha;
				}
				poiFragData.baseColor = saturate(poiFragData.baseColor);
			}
			#endif
			#ifdef VIGNETTE_MASKED
			void calculateShading(inout PoiLight poiLight, inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				float shadowAttenuation = lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				float attenuation = 1;
				#if defined(POINT) || defined(SPOT)
				shadowAttenuation = lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				attenuation = poiLight.attenuation;
				#endif
				#ifdef UNITY_PASS_FORWARDADD
				if (1.0 == 0) // Realistic
				{
					poiLight.rampedLightMap = max(0, poiLight.nDotL);
					poiLight.finalLighting = poiLight.directColor * attenuation * max(0, poiLight.nDotL) * poiLight.detailShadow * shadowAttenuation;
					return;
				}
				else if (1.0 == 1) // Toon
				{
					#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
					float passthrough = 0;
					#else
					float passthrough = 0.5;
					#endif
					if (0.5 == 0.0) 0.5 += 0.001;
					poiLight.rampedLightMap = smoothstep(0.5, 0.0, 1 - (.5 * poiLight.nDotL + .5));
					#if defined(POINT) || defined(SPOT)
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.additiveShadow, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(0.0, 0.5, 1 - (.5 * poiLight.nDotL + .5))) * poiLight.attenuation;
					#else
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.attenuation, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(0.0, 0.5, 1 - (.5 * poiLight.nDotL + .5)));
					#endif
					return;
				}
				#endif
				float shadowStrength = 1.0 * poiLight.shadowMask;
				#ifdef POI_PASS_OUTLINE
				shadowStrength = lerp(0, shadowStrength, _OutlineShadowStrength);
				#endif
				#ifdef _LIGHTINGMODE_FLAT
				poiLight.finalLighting = poiLight.directColor * attenuation * shadowAttenuation;
				poiLight.rampedLightMap = poiLight.nDotLSaturated;
				#endif
				if (1.0)
				{
					#if defined(VERTEXLIGHT_ON)
					float3 vertexLighting = float3(0, 0, 0);
					for (int index = 0; index < 4; index++)
					{
						if (1.0 == 0 || 1.0 == 3)
						{
							vertexLighting += poiLight.vColor[index] * poiLight.vAttenuationDotNL[index] * poiLight.detailShadow; // Realistic
						}
						if (1.0 == 1) // Toon
						{
							vertexLighting += lerp(poiLight.vColor[index] * poiLight.vAttenuation[index], poiLight.vColor[index] * 0.5 * poiLight.vAttenuation[index], smoothstep(0.0, 0.5, 1 - (.5 * poiLight.vDotNL[index] + .5))) * poiLight.detailShadow;
						}
					}
					float3 mixedLight = poiLight.finalLighting;
					poiLight.finalLighting = vertexLighting + poiLight.finalLighting;
					#endif
				}
			}
			#endif
			void blendMatcap(inout PoiLight poiLight, inout PoiFragData poiFragData, in PoiMods poiMods, float add, float lightAdd, float multiply, float replace, float mixed, float screen, float4 matcapColor, float matcapMask, float emissionStrength, float matcapLightMask, uint globalMaskIndex, float globalMaskBlendType)
			{
				if (matcapLightMask)
				{
					matcapMask *= lerp(1, poiLight.rampedLightMap, matcapLightMask);
				}
				if (globalMaskIndex > 0)
				{
					matcapMask = maskBlend(matcapMask, poiMods.globalMask[globalMaskIndex - 1], globalMaskBlendType);
				}
				poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, matcapColor.rgb, replace * matcapMask * matcapColor.a * .999999);
				poiFragData.baseColor.rgb *= lerp(1, matcapColor.rgb, multiply * matcapMask * matcapColor.a);
				poiFragData.baseColor.rgb += matcapColor.rgb * add * matcapMask * matcapColor.a;
				poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, blendScreen(poiFragData.baseColor.rgb, matcapColor.rgb), screen * matcapMask * matcapColor.a);
				poiLight.finalLightAdd += matcapColor.rgb * lightAdd * matcapMask * matcapColor.a;
				poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, poiFragData.baseColor.rgb + poiFragData.baseColor.rgb * matcapColor.rgb, mixed * matcapMask * matcapColor.a);
				poiFragData.emission += matcapColor.rgb * emissionStrength * matcapMask * matcapColor.a;
			}
			#if defined(POI_MATCAP0) || defined(COLOR_GRADING_HDR_3D) || defined(POI_MATCAP2) || defined(POI_MATCAP3)
			void applyMatcap(inout PoiFragData poiFragData, in PoiCam poiCam, in PoiMesh poiMesh, inout PoiLight poiLight, in PoiMods poiMods)
			{
				float4 matcap = 0;
				float matcapMask = 0;
				float4 matcap2 = 0;
				float matcap2Mask = 0;
				float4 matcap3 = 0;
				float matcap3Mask = 0;
				float4 matcap4 = 0;
				float matcap4Mask = 0;
				float2 matcapUV = 0;
				#ifdef POI_MATCAP0
				float3 normal0 = poiMesh.normals[1.0];
				switch(1.0)
				{
					case 0:
					{
						float3 viewNormal = (mul(UNITY_MATRIX_V, float4(normal0, 0))).rgb;
						float3 NormalBlend_MatCapUV_Detail = viewNormal.rgb * float3(-1, -1, 1);
						float3 NormalBlend_MatCapUV_Base = (mul(UNITY_MATRIX_V, float4(poiCam.viewDir, 0)).rgb * float3(-1, -1, 1)) + float3(0, 0, 1);
						float3 noSknewViewNormal = NormalBlend_MatCapUV_Base * dot(NormalBlend_MatCapUV_Base, NormalBlend_MatCapUV_Detail) / NormalBlend_MatCapUV_Base.b - NormalBlend_MatCapUV_Detail;
						matcapUV = noSknewViewNormal.rg * 0.43 + 0.5;
						break;
					}
					case 1:
					{
						float3 worldViewUp = normalize(float3(0, 1, 0) - poiCam.viewDir * dot(poiCam.viewDir, float3(0, 1, 0)));
						float3 worldViewRight = normalize(cross(poiCam.viewDir, worldViewUp));
						matcapUV = float2(dot(worldViewRight, normal0), dot(worldViewUp, normal0)) * 0.43 + 0.5;
						break;
					}
					case 2:
					{
						float3 reflection = reflect(-poiCam.viewDir, normal0);
						float2 uv = float2(dot(reflection, float3(1, 0, 0)), dot(reflection, float3(0, 1, 0)));
						matcapUV = uv * 0.43 + 0.5;
						break;
					}
				}
				matcapUV = lerp(matcapUV, poiMesh.uv[1.0], float4(0,0,0,0).xy);
				matcapUV = RotateUV(matcapUV, 0.0 * PI, float2(.5, .5), 1.0f);
				if (IsInMirror())
				{
					matcapUV.x = 1 - matcapUV.x;
				}
				float matcapSmoothness;
				float mipCount0 = 9;
				if (0.0)
				{
					if (float4(0.001953125,0.001953125,512,512).z == 8192) mipCount0 = 13;
					if (float4(0.001953125,0.001953125,512,512).z == 4096) mipCount0 = 12;
					if (float4(0.001953125,0.001953125,512,512).z == 2048) mipCount0 = 11;
					if (float4(0.001953125,0.001953125,512,512).z == 1024) mipCount0 = 10;
					if (float4(0.001953125,0.001953125,512,512).z == 512) mipCount0 = 9;
					if (float4(0.001953125,0.001953125,512,512).z == 256) mipCount0 = 8;
					if (float4(0.001953125,0.001953125,512,512).z == 128) mipCount0 = 7;
					if (float4(0.001953125,0.001953125,512,512).z == 64) mipCount0 = 6;
					if (float4(0.001953125,0.001953125,512,512).z == 32) mipCount0 = 5;
					matcapSmoothness = 1.0;
					if (0.0)
					{
						#if defined(PROP_MATCAPMASK) || !defined(OPTIMIZER_ENABLED)
						matcapSmoothness *= POI2D_SAMPLER_PAN(_MatcapMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0))[3.0];
						#endif
					}
					matcapSmoothness = (1 - matcapSmoothness) * mipCount0;
				}
				#if defined(PROP_MATCAP) || !defined(OPTIMIZER_ENABLED)
				if (0.0)
				{
					matcap = UNITY_SAMPLE_TEX2D_SAMPLER_LOD(_Matcap, _MainTex, TRANSFORM_TEX(matcapUV, _Matcap), matcapSmoothness) * float4(poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0), float4(1,1,1,1).a);
				}
				else
				{
					matcap = UNITY_SAMPLE_TEX2D_SAMPLER(_Matcap, _MainTex, TRANSFORM_TEX(matcapUV, _Matcap)) * float4(poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0), float4(1,1,1,1).a);
				}
				#else
				matcap = float4(poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0), float4(1,1,1,1).a);
				#endif
				matcap.rgb *= 1.0;
				matcap.rgb = lerp(matcap.rgb, matcap.rgb * poiFragData.baseColor.rgb, 0.0);
				#if defined(PROP_MATCAPMASK) || !defined(OPTIMIZER_ENABLED)
				matcapMask = POI2D_SAMPLER_PAN(_MatcapMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0))[0.0];
				#else
				matcapMask = 1;
				#endif
				if (0.0)
				{
					matcapMask = 1 - matcapMask;
				}
				#ifdef TPS_Penetrator
				if (0.0)
				{
					matcapMask = lerp(0, matcapMask * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
				}
				#endif
				poiFragData.alpha *= lerp(1, matcap.a, matcapMask * 0.0);
				if (0.0)
				{
					matcap.rgb = hueShift(matcap.rgb, 0.0 + _Time.x * 0.0);
				}
				blendMatcap(poiLight, poiFragData, poiMods, 0.0, 0.0, 0.331, 0.0, 1.0, 0.0, matcap, matcapMask, 0.0, 0.0, 0.0, 2.0);
				#endif
			}
			#endif
			#if defined(_GLOSSYREFLECTIONS_OFF) || defined(POI_RIM2)
			#if defined(_RIMSTYLE_POIYOMI) || defined(_RIM2STYLE_POIYOMI)
			void ApplyPoiyomiRimLighting(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight, inout PoiMods poiMods, float Is_NormalMapToRimLight, float RimInvert, float RimPower, float RimStrength, float RimShadowWidth, float RimShadowToggle, float RimWidth, float RimBlendStrength, float RimMask, float RimGlobalMask, float RimGlobalMaskBlendType, float4 RimTex, float4 RimLightColor, float RimLightColorThemeIndex, float RimHueShiftEnabled, float RimHueShift, float RimHueShiftSpeed, float RimSharpness, float RimShadowMaskRampType, float RimShadowMaskInvert, float RimShadowMaskStrength, float2 RimShadowAlpha, float RimApplyGlobalMaskIndex, float RimApplyGlobalMaskBlendType, float RimBaseColorMix, float RimBrightness, float RimBlendMode, half AudioLinkRimWidthBand, float2 AudioLinkRimWidthAdd, half AudioLinkRimEmissionBand, float2 AudioLinkRimEmissionAdd, half AudioLinkRimBrightnessBand, float2 AudioLinkRimBrightnessAdd, float RimClamp, float rimBias, float rimBiasIntensity)
			{
				float viewDotNormal = abs(dot(poiCam.viewDir, lerp(poiMesh.normals[0], poiMesh.normals[1], Is_NormalMapToRimLight)));
				
				if (RimInvert)
				{
					viewDotNormal = 1 - viewDotNormal;
				}
				viewDotNormal = pow(viewDotNormal, RimPower);
				if (RimShadowWidth && RimShadowToggle)
				{
					viewDotNormal += lerp(0, (1 - poiLight.nDotLNormalized) * 3, RimShadowWidth);
				}
				viewDotNormal *= lerp(1, rimBias, rimBiasIntensity);
				float rimStrength = RimStrength;
				float rimWidth = lerp( - .05, 1, RimWidth);
				float blendStrength = RimBlendStrength;
				#ifdef POI_AUDIOLINK
				
				if (poiMods.audioLinkAvailable)
				{
					rimWidth = clamp(rimWidth + lerp(AudioLinkRimWidthAdd.x, AudioLinkRimWidthAdd.y, poiMods.audioLink[AudioLinkRimWidthBand]), - .05, 1);
					rimStrength += lerp(AudioLinkRimEmissionAdd.x, AudioLinkRimEmissionAdd.y, poiMods.audioLink[AudioLinkRimEmissionBand]);
					blendStrength += lerp(AudioLinkRimBrightnessAdd.x, AudioLinkRimBrightnessAdd.y, poiMods.audioLink[AudioLinkRimBrightnessBand]);
				}
				#endif
				float rimMask = RimMask;
				if (RimGlobalMask > 0)
				{
					rimMask = maskBlend(rimMask, poiMods.globalMask[RimGlobalMask-1], RimGlobalMaskBlendType);
				}
				float4 rimColor = RimTex;
				rimColor *= float4(poiThemeColor(poiMods, RimLightColor.rgb, RimLightColorThemeIndex), RimLightColor.a);
				
				if (RimHueShiftEnabled)
				{
					rimColor.rgb = hueShift(rimColor.rgb, RimHueShift + _Time.x * RimHueShiftSpeed);
				}
				float rim = 1 - smoothstep(min(RimSharpness, rimWidth), rimWidth, viewDotNormal);
				rim *= RimLightColor.a * rimColor.a * rimMask;
				if (RimShadowToggle)
				{
					switch(RimShadowMaskRampType)
					{
						case 0:
						float rampedLightMap = poiLight.rampedLightMap;
						if (RimShadowMaskInvert) rampedLightMap = 1 - rampedLightMap;
						rim = lerp(rim, rim * rampedLightMap, RimShadowMaskStrength);
						break;
						case 1:
						float nDotLNormalized = poiLight.nDotLNormalized;
						if (RimShadowMaskInvert) nDotLNormalized = 1 - nDotLNormalized;
						rim = lerp(rim, rim * smoothstep(RimShadowAlpha.x, RimShadowAlpha.y, nDotLNormalized), RimShadowMaskStrength);
						break;
					}
				}
				if (RimApplyGlobalMaskIndex > 0)
				{
					applyToGlobalMask(poiMods, RimApplyGlobalMaskIndex-1, RimApplyGlobalMaskBlendType, rim * blendStrength);
				}
				float3 finalRimColor = rimColor.rgb * lerp(1, poiFragData.baseColor, RimBaseColorMix);
				finalRimColor *= RimBrightness;
				switch(RimBlendMode)
				{
					case 0: poiFragData.baseColor += finalRimColor * rim * blendStrength; break;
					case 1: poiFragData.baseColor = lerp(poiFragData.baseColor, finalRimColor, rim * blendStrength); break;
					case 2: poiFragData.baseColor = lerp(poiFragData.baseColor, poiFragData.baseColor * finalRimColor, rim * blendStrength); break;
					case 3: poiFragData.baseColor = lerp(poiFragData.baseColor.rgb, poiFragData.baseColor.rgb + poiFragData.baseColor.rgb * finalRimColor, rim * blendStrength); break;
				}
				if(RimClamp)
				{
					poiFragData.baseColor = saturate(poiFragData.baseColor);
				}
				poiFragData.emission += finalRimColor * rim * rimStrength;
			}
			#endif
			#if defined(_RIMSTYLE_UTS2) || defined(_RIM2STYLE_UTS2)
			void ApplyUTS2RimLighting(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight, in PoiMods poiMods, float Set_RimLightMask_var, float RimGlobalMask, float RimGlobalMaskBlendType, float4 RimLightColor, float RimLightColorThemeIndex, float Is_LightColor_RimLight, float Is_NormalMapToRimLight, float RimLight_Power, float RimLight_InsideMask, float RimLight_FeatherOff, float LightDirection_MaskOn, float Tweak_LightDirection_MaskLevel, float Add_Antipodean_RimLight, float4 Ap_RimLightColor, float RimApColorThemeIndex, float Is_LightColor_Ap_RimLight, float Ap_RimLight_Power, float Ap_RimLight_FeatherOff, float Tweak_RimLightMaskLevel, float RimHueShiftEnabled, float RimHueShift, float RimHueShiftSpeed, float RimClamp)
			{
				if (RimGlobalMask > 0)
				{
					Set_RimLightMask_var = maskBlend(Set_RimLightMask_var, poiMods.globalMask[RimGlobalMask-1], RimGlobalMaskBlendType);
				}
				float3 rimColor = float3(poiThemeColor(poiMods, RimLightColor.rgb, RimLightColorThemeIndex));
				float3 _Is_LightColor_RimLight_var = lerp(rimColor, (rimColor * poiLight.directColor), Is_LightColor_RimLight);
				float _RimArea_var = (1.0 - dot(lerp(poiMesh.normals[0], poiMesh.normals[1], Is_NormalMapToRimLight), poiCam.viewDir));
				float _RimLightPower_var = pow(_RimArea_var, exp2(lerp(3, 0, RimLight_Power)));
				float _Rimlight_InsideMask_var = saturate(lerp((0.0 + ((_RimLightPower_var - RimLight_InsideMask) * (1.0 - 0.0)) / (1.0 - RimLight_InsideMask)), step(RimLight_InsideMask, _RimLightPower_var), RimLight_FeatherOff));
				float _VertHalfLambert_var = 0.5 * dot(poiMesh.normals[0], poiLight.direction) + 0.5;
				float3 _LightDirection_MaskOn_var = lerp((_Is_LightColor_RimLight_var * _Rimlight_InsideMask_var), (_Is_LightColor_RimLight_var * saturate((_Rimlight_InsideMask_var - ((1.0 - _VertHalfLambert_var) + Tweak_LightDirection_MaskLevel)))), LightDirection_MaskOn);
				float _ApRimLightPower_var = pow(_RimArea_var, exp2(lerp(3, 0, Ap_RimLight_Power)));
				float3 ApRimColor = float3(poiThemeColor(poiMods, Ap_RimLightColor.rgb, RimApColorThemeIndex));
				float3 _RimLight_var = (saturate((Set_RimLightMask_var + Tweak_RimLightMaskLevel)) * lerp(_LightDirection_MaskOn_var, (_LightDirection_MaskOn_var + (lerp(ApRimColor, (ApRimColor * poiLight.directColor), Is_LightColor_Ap_RimLight) * saturate((lerp((0.0 + ((_ApRimLightPower_var - RimLight_InsideMask) * (1.0 - 0.0)) / (1.0 - RimLight_InsideMask)), step(RimLight_InsideMask, _ApRimLightPower_var), Ap_RimLight_FeatherOff) - (saturate(_VertHalfLambert_var) + Tweak_LightDirection_MaskLevel))))), Add_Antipodean_RimLight));
				
				if (RimHueShiftEnabled)
				{
					_RimLight_var = hueShift(_RimLight_var, RimHueShift + _Time.x * RimHueShiftSpeed);
				}
				poiFragData.baseColor += _RimLight_var;
				if(RimClamp)
				{
					poiFragData.baseColor = saturate(poiFragData.baseColor);
				}
			}
			#endif
			#if defined(_RIMSTYLE_LILTOON) || defined(_RIM2STYLE_LILTOON)
			void ApplyLiltoonRimLighting(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight, in PoiMods poiMods, float4 RimColor, float4 RimIndirColor, float4 RimColorTex, float RimMainStrength, float RimNormalStrength, float RimDirRange, float RimIndirRange, float RimFresnelPower, float RimBackfaceMask, float RimDirStrength, float RimBorder, float RimBlur, float RimIndirBorder, float RimIndirBlur, float RimShadowMask, float RimEnableLighting, float RimVRParallaxStrength, float RimGlobalMask, float RimGlobalMaskBlendType, float RimHueShiftEnabled, float RimHueShift, float RimHueShiftSpeed, float RimClamp)
			{
				if (RimGlobalMask > 0)
				{
					RimColorTex.a = maskBlend(RimColorTex.a, poiMods.globalMask[RimGlobalMask-1], RimGlobalMaskBlendType);
				}
				float4 rimColor = RimColor;
				float4 rimIndirColor = RimIndirColor;
				rimColor *= RimColorTex;
				rimIndirColor *= RimColorTex;
				if (RimHueShiftEnabled)
				{
					rimColor.rgb = hueShift(rimColor.rgb, RimHueShift + _Time.x * RimHueShiftSpeed);
					rimIndirColor.rgb = hueShift(rimIndirColor.rgb, RimHueShift + _Time.x * RimHueShiftSpeed);
				}
				rimColor.rgb = lerp(rimColor.rgb, rimColor.rgb * poiFragData.baseColor, RimMainStrength);
				float3 centerViewDir = !IsOrthographicCamera() ? normalize(getCameraPosition() - poiMesh.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 viewDir = lerp(centerViewDir, poiCam.viewDir, RimVRParallaxStrength);
				float3 normal = lerp(poiMesh.normals[0], poiMesh.normals[1], RimNormalStrength);
				float nvabs = abs(dot(normal, viewDir));
				float lnRaw = dot(poiLight.direction, normal) * 0.5 + 0.5;
				float lnDir = saturate((lnRaw + RimDirRange) / (1.0 + RimDirRange));
				float lnIndir = saturate((1.0-lnRaw + RimIndirRange) / (1.0 + RimIndirRange));
				float rim = pow(saturate(1.0 - nvabs), RimFresnelPower);
				rim = !poiMesh.isFrontFace && RimBackfaceMask ? 0.0 : rim;
				float rimDir = lerp(rim, rim * lnDir, RimDirStrength);
				float rimIndir = rim * lnIndir * RimDirStrength;
				rimDir = poiEdgeLinear(rimDir, RimBorder, RimBlur);
				rimIndir = poiEdgeLinear(rimIndir, RimIndirBorder, RimIndirBlur);
				rimDir = lerp(rimDir, rimDir * poiLight.rampedLightMap, RimShadowMask);
				rimIndir = lerp(rimIndir, rimIndir * poiLight.rampedLightMap, RimShadowMask);
				float3 rimSum = rimDir * rimColor.a * rimColor.rgb + rimIndir * rimIndirColor.a * rimIndirColor.rgb;
				poiFragData.baseColor += rimSum * RimEnableLighting;
				poiFragData.emission += rimSum * (1-RimEnableLighting);
				if(RimClamp)
				{
					poiFragData.baseColor = saturate(poiFragData.baseColor);
				}
			}
			#endif
			#endif
			#if defined(MOCHIE_PBR) || defined(POI_CLEARCOAT)
			float GSAA_Filament(float3 worldNormal, float perceptualRoughness, float gsaaVariance, float gsaaThreshold)
			{
				float3 du = ddx(worldNormal);
				float3 dv = ddy(worldNormal);
				float variance = gsaaVariance * (dot(du, du) + dot(dv, dv));
				float roughness = perceptualRoughness * perceptualRoughness;
				float kernelRoughness = min(2.0 * variance, gsaaThreshold);
				float squareRoughness = saturate(roughness * roughness + kernelRoughness);
				return sqrt(sqrt(squareRoughness));
			}
			bool SceneHasReflections()
			{
				float width, height;
				unity_SpecCube0.GetDimensions(width, height);
				return !(width * height < 2);
			}
			float3 GetWorldReflections(float3 reflDir, float3 worldPos, float roughness)
			{
				float3 baseReflDir = reflDir;
				reflDir = BoxProjection(reflDir, worldPos, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
				float4 envSample0 = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflDir, roughness * UNITY_SPECCUBE_LOD_STEPS);
				float3 p0 = DecodeHDR(envSample0, unity_SpecCube0_HDR);
				float interpolator = unity_SpecCube0_BoxMin.w;
				
				if (interpolator < 0.99999)
				{
					float3 refDirBlend = BoxProjection(baseReflDir, worldPos, unity_SpecCube1_ProbePosition, unity_SpecCube1_BoxMin, unity_SpecCube1_BoxMax);
					float4 envSample1 = UNITY_SAMPLE_TEXCUBE_SAMPLER_LOD(unity_SpecCube1, unity_SpecCube0, refDirBlend, roughness * UNITY_SPECCUBE_LOD_STEPS);
					float3 p1 = DecodeHDR(envSample1, unity_SpecCube1_HDR);
					p0 = lerp(p1, p0, interpolator);
				}
				return p0;
			}
			float3 GetReflections(in PoiCam poiCam, in PoiLight pl, in PoiMesh poiMesh, float roughness, float ForceFallback, float LightFallback, samplerCUBE reflectionCube, float4 hdrData, float3 reflectionDir)
			{
				float3 reflections = 0;
				float3 lighting = pl.finalLighting;
				if (ForceFallback == 0)
				{
					
					if (SceneHasReflections())
					{
						#ifdef UNITY_PASS_FORWARDBASE
						reflections = GetWorldReflections(reflectionDir, poiMesh.worldPos.xyz, roughness);
						#endif
					}
					else
					{
						#ifdef UNITY_PASS_FORWARDBASE
						reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
						reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
						#endif
						#ifdef POI_PASS_ADD
						if (LightFallback)
						{
							reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
							reflections = DecodeHDR(float4(reflections, 1), hdrData) * pl.finalLighting;
						}
						#endif
					}
				}
				else
				{
					#ifdef UNITY_PASS_FORWARDBASE
					reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
					reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
					#endif
					#ifdef POI_PASS_ADD
					if (LightFallback)
					{
						reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
						reflections = DecodeHDR(float4(reflections, 1), hdrData) * pl.finalLighting;
					}
					#endif
				}
				reflections *= pl.occlusion;
				return reflections;
			}
			float GetGGXTerm(float nDotL, float nDotV, float nDotH, float roughness)
			{
				float visibilityTerm = 0;
				if (nDotL > 0)
				{
					float rough = roughness;
					float rough2 = roughness * roughness;
					float lambdaV = nDotL * (nDotV * (1 - rough) + rough);
					float lambdaL = nDotV * (nDotL * (1 - rough) + rough);
					visibilityTerm = 0.5f / (lambdaV + lambdaL + 1e-5f);
					float d = (nDotH * rough2 - nDotH) * nDotH + 1.0f;
					float dotTerm = UNITY_INV_PI * rough2 / (d * d + 1e-7f);
					visibilityTerm *= dotTerm * UNITY_PI;
				}
				return visibilityTerm;
			}
			void GetSpecFresTerm(float nDotL, float nDotV, float nDotH, float lDotH, inout float3 specularTerm, inout float3 fresnelTerm, float3 specCol, float roughness)
			{
				specularTerm = GetGGXTerm(nDotL, nDotV, nDotH, roughness);
				fresnelTerm = FresnelTerm(specCol, lDotH);
				specularTerm = max(0, specularTerm * max(0.00001, nDotL));
			}
			float GetRoughness(float smoothness)
			{
				float rough = 1 - smoothness;
				rough *= 1.7 - 0.7 * rough;
				return rough;
			}
			#endif
			#ifdef MOCHIE_PBR
			void MochieBRDF(inout PoiFragData poiFragData, in PoiCam poiCam, inout PoiLight poiLight, in PoiMesh poiMesh, inout PoiMods poiMods)
			{
				float smoothness = 0.313;
				float smoothness2 = 1.0;
				float metallic = 0.0;
				float specularMask = 1;
				float reflectionMask = 1;
				smoothness *= poiMods.PBR.x;
				smoothness2 *= poiMods.PBR.x;
				metallic *= poiMods.PBR.y;
				specularMask *= poiMods.PBR.z;
				reflectionMask *= poiMods.PBR.w;
				#if defined(PROP_MOCHIEMETALLICMAPS) || !defined(OPTIMIZER_ENABLED)
				float4 PBRMaps = POI2D_SAMPLER_PAN_STOCHASTIC(_MochieMetallicMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0), 0.0);
				
				if (0.0)
				{
					float4 PBRSplitMask = POI2D_SAMPLER_PAN_STOCHASTIC(_MochieMetallicMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0).xy, 0.0);
					assignValueToVectorFromIndex(PBRMaps, 2.0, PBRSplitMask[2.0]);
					assignValueToVectorFromIndex(PBRMaps, 3.0, PBRSplitMask[3.0]);
				}
				if (0.0 < 4)
				{
					metallic *= PBRMaps[0.0];
				}
				if (1.0 < 4)
				{
					smoothness *= PBRMaps[1.0];
					smoothness2 *= PBRMaps[1.0];
				}
				if (2.0 < 4)
				{
					reflectionMask *= PBRMaps[2.0];
				}
				if (3.0 < 4)
				{
					specularMask *= PBRMaps[3.0];
				}
				#endif
				reflectionMask *= 0.459;
				specularMask *= 0.45;
				if (0.0 > 0)
				{
					metallic = customBlend(metallic, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					smoothness = customBlend(smoothness, poiMods.globalMask[0.0 - 1], 2.0);
					smoothness2 = customBlend(smoothness2, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					reflectionMask = customBlend(reflectionMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					specularMask = customBlend(specularMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0)
				{
					metallic = 1 - metallic;
				}
				if (0.0)
				{
					smoothness = 1 - smoothness;
					smoothness2 = 1 - smoothness2;
				}
				if (0.0)
				{
					reflectionMask = 1 - reflectionMask;
				}
				if (0.0)
				{
					specularMask = 1 - specularMask;
				}
				#ifdef TPS_Penetrator
				if (0.0)
				{
					reflectionMask = lerp(0, reflectionMask * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					specularMask = lerp(0, specularMask * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
				}
				#endif
				float roughness = GetRoughness(smoothness);
				float roughness2 = GetRoughness(smoothness2);
				float3 specCol = lerp(unity_ColorSpaceDielectricSpec.rgb, poiFragData.baseColor, metallic);
				float omr = unity_ColorSpaceDielectricSpec.a - metallic * unity_ColorSpaceDielectricSpec.a;
				float percepRough = 1 - smoothness;
				float percepRough2 = 1 - smoothness2;
				
				if (1.0)
				{
					percepRough = GSAA_Filament(poiMesh.normals[1.0], percepRough, 0.15, 0.1);
					if (0.0 == 1 && 1.0 > 0)
					{
						percepRough2 = GSAA_Filament(poiMesh.normals[1.0], percepRough2, 0.15, 0.1);
					}
				}
				float brdfRoughness = percepRough * percepRough;
				brdfRoughness = max(brdfRoughness, 0.002);
				float brdfRoughness2 = percepRough2 * percepRough2;
				brdfRoughness2 = max(brdfRoughness2, 0.002);
				float3 diffuse = poiFragData.baseColor;
				float3 specular = 0;
				float3 specular2 = 0;
				float3 vSpecular = 0;
				float3 vSpecular2 = 0;
				float3 reflections = 0;
				float3 environment = 0;
				float attenuation = min(poiLight.nDotLSaturated, lerp(poiLight.attenuation, 1, 0.0));
				#ifdef POI_PASS_ADD
				attenuation *= lerp(poiLight.additiveShadow, 1, 0.0);
				#endif
				float3 fresnelTerm = 1;
				float3 specularTerm = 1;
				float pbrNDotL = lerp(poiLight.vertexNDotL, poiLight.nDotL, 1.0);
				float pbrNDotV = lerp(poiLight.vertexNDotV, poiLight.nDotV, 1.0);
				float pbrNDotH = lerp(poiLight.vertexNDotH, poiLight.nDotH, 1.0);
				float3 pbrReflectionDir = lerp(poiCam.vertexReflectionDir, poiCam.reflectionDir, 1.0);
				GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness);
				specular = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation;
				if (1.0)
				{
					#if defined(VERTEXLIGHT_ON)
					for (int index = 0; index < 4; index++)
					{
						fresnelTerm = 1;
						specularTerm = 1;
						float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
						float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
						GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness);
						vSpecular += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * poiLight.vAttenuation[index];
					}
					#endif
				}
				if (0.0 == 1)
				{
					float3 fresnelTerm = 1;
					float3 specularTerm = 1;
					GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness2);
					specular2 = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation * 1.0;
					if (1.0)
					{
						#if defined(VERTEXLIGHT_ON)
						for (int index = 0; index < 4; index++)
						{
							fresnelTerm = 1;
							specularTerm = 1;
							float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
							float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
							GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness2);
							vSpecular2 += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * poiLight.vAttenuation[index] * 1.0;
						}
						#endif
					}
				}
				float surfaceReduction = (1.0 / (brdfRoughness * brdfRoughness + 1.0));
				float grazingTerm = saturate(smoothness + (1 - omr));
				float3 reflCol = GetReflections(poiCam, poiLight, poiMesh, roughness, 0.0, 1.0, _MochieReflCube, _MochieReflCube_HDR, pbrReflectionDir);
				reflections = surfaceReduction * reflCol * lerp(1, FresnelLerp(specCol, grazingTerm, pbrNDotV), 1.0);
				reflections *= poiThemeColor(poiMods, float4(1,1,1,1), 0.0);
				reflections *= reflectionMask;
				#ifdef POI_PASS_ADD
				reflections *= poiLight.attenuation;
				#endif
				diffuse = lerp(diffuse, diffuse * omr, reflectionMask);
				poiMods.PBR = float4(smoothness, metallic, specularMask, reflectionMask);
				environment = max(specular + vSpecular, specular2 + vSpecular2);
				environment += reflections;
				diffuse *= poiLight.finalLighting;
				poiFragData.finalColor = diffuse;
				poiLight.finalLightAdd += environment;
			}
			#endif
			float4 frag(VertexOut i, uint facing : SV_IsFrontFace) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				PoiMesh poiMesh;
				PoiInitStruct(PoiMesh, poiMesh);
				PoiLight poiLight;
				PoiInitStruct(PoiLight, poiLight);
				PoiVertexLights poiVertexLights;
				PoiInitStruct(PoiVertexLights, poiVertexLights);
				PoiCam poiCam;
				PoiInitStruct(PoiCam, poiCam);
				PoiMods poiMods;
				PoiInitStruct(PoiMods, poiMods);
				poiMods.globalEmission = 1;
				poiMods.PBR = 1;
				PoiFragData poiFragData;
				poiFragData.emission = 0;
				poiFragData.baseColor = float3(0, 0, 0);
				poiFragData.finalColor = float3(0, 0, 0);
				poiFragData.alpha = 1;
				#ifdef POI_UDIMDISCARD
				applyUDIMDiscard(i);
				#endif
				poiMesh.objectPosition = i.objectPos;
				poiMesh.objNormal = i.objNormal;
				poiMesh.normals[0] = i.normal;
				poiMesh.tangent[0] = i.tangent;
				poiMesh.binormal[0] = i.binormal;
				poiMesh.worldPos = i.worldPos.xyz;
				poiMesh.localPos = i.localPos.xyz;
				poiMesh.vertexColor = i.vertexColor;
				poiMesh.isFrontFace = facing;
				#ifndef POI_PASS_OUTLINE
				if (!poiMesh.isFrontFace)
				{
					poiMesh.normals[0] *= -1;
					poiMesh.tangent[0] *= -1;
					poiMesh.binormal[0] *= -1;
				}
				#endif
				poiCam.viewDir = !IsOrthographicCamera() ? normalize(_WorldSpaceCameraPos - i.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 tanToWorld0 = float3(i.tangent.x, i.binormal.x, i.normal.x);
				float3 tanToWorld1 = float3(i.tangent.y, i.binormal.y, i.normal.y);
				float3 tanToWorld2 = float3(i.tangent.z, i.binormal.z, i.normal.z);
				float3 ase_tanViewDir = tanToWorld0 * poiCam.viewDir.x + tanToWorld1 * poiCam.viewDir.y + tanToWorld2 * poiCam.viewDir.z;
				poiCam.tangentViewDir = normalize(ase_tanViewDir);
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				poiMesh.lightmapUV = i.lightmapUV;
				#endif
				poiMesh.parallaxUV = poiCam.tangentViewDir.xy / max(poiCam.tangentViewDir.z, 0.0001);
				poiMesh.uv[0] = i.uv[0];
				poiMesh.uv[1] = i.uv[1];
				poiMesh.uv[2] = i.uv[2];
				poiMesh.uv[3] = i.uv[3];
				poiMesh.uv[4] = poiMesh.uv[0];
				poiMesh.uv[5] = poiMesh.uv[0];
				poiMesh.uv[6] = poiMesh.uv[0];
				poiMesh.uv[7] = poiMesh.uv[0];
				poiMesh.uv[8] = poiMesh.uv[0];
				poiMesh.uv[4] = calculatePanosphereUV(poiMesh);
				poiMesh.uv[5] = calculateWorldUV(poiMesh);
				poiMesh.uv[6] = calculatePolarCoordinate(poiMesh);
				poiMesh.uv[8] = calculatelocalUV(poiMesh);
				poiMods.globalMask[0]  = 1;
				poiMods.globalMask[1]  = 1;
				poiMods.globalMask[2]  = 1;
				poiMods.globalMask[3]  = 1;
				poiMods.globalMask[4]  = 1;
				poiMods.globalMask[5]  = 1;
				poiMods.globalMask[6]  = 1;
				poiMods.globalMask[7]  = 1;
				poiMods.globalMask[8]  = 1;
				poiMods.globalMask[9]  = 1;
				poiMods.globalMask[10] = 1;
				poiMods.globalMask[11] = 1;
				poiMods.globalMask[12] = 1;
				poiMods.globalMask[13] = 1;
				poiMods.globalMask[14] = 1;
				poiMods.globalMask[15] = 1;
				ApplyGlobalMaskModifiers(poiMesh, poiMods, poiCam);
				float2 mainUV = poiMesh.uv[0.0].xy;
				if (0.0)
				{
					mainUV = sharpSample(float4(1,1,1,1), mainUV);
				}
				float4 mainTexture = POI2D_SAMPLER_PAN_STOCHASTIC(_MainTex, _MainTex, poiUV(mainUV, float4(1,1,0,0)), float4(0,0,0,0), 0.0);
				#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
				poiMesh.tangentSpaceNormal = UnpackScaleNormal(POI2D_SAMPLER_PAN_STOCHASTIC(_BumpMap, _MainTex, poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0)), float4(0,0,0,0), 0.0), 1.0);
				#else
				poiMesh.tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				#endif
				poiMesh.normals[1] = normalize(
				poiMesh.tangentSpaceNormal.x * poiMesh.tangent[0] +
				poiMesh.tangentSpaceNormal.y * poiMesh.binormal[0] +
				poiMesh.tangentSpaceNormal.z * poiMesh.normals[0]
				);
				poiMesh.tangent[1] = cross(poiMesh.binormal[0], -poiMesh.normals[1]);
				poiMesh.binormal[1] = cross(-poiMesh.normals[1], poiMesh.tangent[0]);
				poiCam.forwardDir = getCameraForward();
				poiCam.worldPos = _WorldSpaceCameraPos;
				poiCam.reflectionDir = reflect(-poiCam.viewDir, poiMesh.normals[1]);
				poiCam.vertexReflectionDir = reflect(-poiCam.viewDir, poiMesh.normals[0]);
				poiCam.distanceToVert = distance(poiMesh.worldPos, poiCam.worldPos);
				poiCam.grabPos = i.grabPos;
				poiCam.screenUV = calcScreenUVs(i.grabPos);
				poiCam.vDotN = abs(dot(poiCam.viewDir, poiMesh.normals[1]));
				poiCam.clipPos = i.pos;
				poiCam.worldDirection = i.worldDirection;
				calculateGlobalThemes(poiMods);
				poiLight.finalLightAdd = 0;
				#if defined(PROP_LIGHTINGAOMAPS) || !defined(OPTIMIZER_ENABLED)
				float4 AOMaps = POI2D_SAMPLER_PAN(_LightingAOMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				poiLight.occlusion = min(min(min(lerp(1, AOMaps.r, 1.0), lerp(1, AOMaps.g, 0.0)), lerp(1, AOMaps.b, 0.0)), lerp(1, AOMaps.a, 0.0));
				#else
				poiLight.occlusion = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.occlusion = maskBlend(poiLight.occlusion, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#if defined(PROP_LIGHTINGDETAILSHADOWMAPS) || !defined(OPTIMIZER_ENABLED)
				float4 DetailShadows = POI2D_SAMPLER_PAN(_LightingDetailShadowMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				#ifndef POI_PASS_ADD
				poiLight.detailShadow = lerp(1, DetailShadows.r, 1.0) * lerp(1, DetailShadows.g, 0.0) * lerp(1, DetailShadows.b, 0.0) * lerp(1, DetailShadows.a, 0.0);
				#else
				poiLight.detailShadow = lerp(1, DetailShadows.r, 1.0) * lerp(1, DetailShadows.g, 0.0) * lerp(1, DetailShadows.b, 0.0) * lerp(1, DetailShadows.a, 0.0);
				#endif
				#else
				poiLight.detailShadow = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.detailShadow = maskBlend(poiLight.detailShadow, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#if defined(PROP_LIGHTINGSHADOWMASKS) || !defined(OPTIMIZER_ENABLED)
				float4 ShadowMasks = POI2D_SAMPLER_PAN(_LightingShadowMasks, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				poiLight.shadowMask = lerp(1, ShadowMasks.r, 1.0) * lerp(1, ShadowMasks.g, 0.0) * lerp(1, ShadowMasks.b, 0.0) * lerp(1, ShadowMasks.a, 0.0);
				#else
				poiLight.shadowMask = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.shadowMask = maskBlend(poiLight.shadowMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#ifdef UNITY_PASS_FORWARDBASE
				bool lightExists = false;
				if (any(_LightColor0.rgb >= 0.002))
				{
					lightExists = true;
				}
				if (1.0)
				{
					#if defined(VERTEXLIGHT_ON)
					float4 toLightX = unity_4LightPosX0 - i.worldPos.x;
					float4 toLightY = unity_4LightPosY0 - i.worldPos.y;
					float4 toLightZ = unity_4LightPosZ0 - i.worldPos.z;
					float4 lengthSq = 0;
					lengthSq += toLightX * toLightX;
					lengthSq += toLightY * toLightY;
					lengthSq += toLightZ * toLightZ;
					float4 lightAttenSq = unity_4LightAtten0;
					float4 atten = 1.0 / (1.0 + lengthSq * lightAttenSq);
					float4 vLightWeight = saturate(1 - (lengthSq * lightAttenSq / 25));
					poiLight.vAttenuation = min(atten, vLightWeight * vLightWeight);
					poiLight.vDotNL = 0;
					poiLight.vDotNL += toLightX * poiMesh.normals[1].x;
					poiLight.vDotNL += toLightY * poiMesh.normals[1].y;
					poiLight.vDotNL += toLightZ * poiMesh.normals[1].z;
					float4 corr = rsqrt(lengthSq);
					poiLight.vertexVDotNL = max(0, poiLight.vDotNL * corr);
					poiLight.vertexVDotNL = 0;
					poiLight.vertexVDotNL += toLightX * poiMesh.normals[0].x;
					poiLight.vertexVDotNL += toLightY * poiMesh.normals[0].y;
					poiLight.vertexVDotNL += toLightZ * poiMesh.normals[0].z;
					poiLight.vertexVDotNL = max(0, poiLight.vDotNL * corr);
					poiLight.vAttenuationDotNL = saturate(poiLight.vAttenuation * saturate(poiLight.vDotNL));
					[unroll]
					for (int index = 0; index < 4; index++)
					{
						poiLight.vPosition[index] = float3(unity_4LightPosX0[index], unity_4LightPosY0[index], unity_4LightPosZ0[index]);
						float3 vertexToLightSource = poiLight.vPosition[index] - poiMesh.worldPos;
						poiLight.vDirection[index] = normalize(vertexToLightSource);
						poiLight.vColor[index] = 0.0 ? min(1.0, unity_LightColor[index].rgb) : unity_LightColor[index].rgb;
						poiLight.vColor[index] = lerp(poiLight.vColor[index], dot(poiLight.vColor[index], float3(0.299, 0.587, 0.114)), 0.0);
						poiLight.vHalfDir[index] = Unity_SafeNormalize(poiLight.vDirection[index] + poiCam.viewDir);
						poiLight.vDotNL[index] = dot(poiMesh.normals[1], poiLight.vDirection[index]);
						poiLight.vCorrectedDotNL[index] = .5 * (poiLight.vDotNL[index] + 1);
						poiLight.vDotLH[index] = saturate(dot(poiLight.vDirection[index], poiLight.vHalfDir[index]));
						poiLight.vDotNH[index] = dot(poiMesh.normals[1], poiLight.vHalfDir[index]);
						poiLight.vertexVDotNH[index] = saturate(dot(poiMesh.normals[0], poiLight.vHalfDir[index]));
					}
					#endif
				}
				if (0.0 == 0) // Poi Custom Light Color
				{
					float3 magic = max(BetterSH9(normalize(unity_SHAr + unity_SHAg + unity_SHAb)), 0);
					float3 normalLight = _LightColor0.rgb + BetterSH9(float4(0, 0, 0, 1));
					float magiLumi = calculateluminance(magic);
					float normaLumi = calculateluminance(normalLight);
					float maginormalumi = magiLumi + normaLumi;
					float magiratio = magiLumi / maginormalumi;
					float normaRatio = normaLumi / maginormalumi;
					float target = calculateluminance(magic * magiratio + normalLight * normaRatio);
					float3 properLightColor = magic + normalLight;
					float properLuminance = calculateluminance(magic + normalLight);
					poiLight.directColor = properLightColor * max(0.0001, (target / properLuminance));
					poiLight.indirectColor = BetterSH9(float4(lerp(0, poiMesh.normals[1], 0.0), 1));
				}
				if (0.0 == 1) // More standard approach to light color
				{
					float3 indirectColor = BetterSH9(float4(poiMesh.normals[1], 1));
					if (lightExists)
					{
						poiLight.directColor = _LightColor0.rgb;
						poiLight.indirectColor = indirectColor;
					}
					else
					{
						poiLight.directColor = indirectColor * 0.6;
						poiLight.indirectColor = indirectColor * 0.5;
					}
				}
				if (0.0 == 2) // UTS style
				{
					poiLight.indirectColor = saturate(max(half3(0.05, 0.05, 0.05) * 1.0, max(ShadeSH9(half4(0.0, 0.0, 0.0, 1.0)), ShadeSH9(half4(0.0, -1.0, 0.0, 1.0)).rgb) * 1.0));
					poiLight.directColor = max(poiLight.indirectColor, _LightColor0.rgb);
				}
				if (0.0 == 3) // OpenLit
				{
					float3 lightDirectionForSH9 = OpenLitLightingDirectionForSH9();
					OpenLitShadeSH9ToonDouble(lightDirectionForSH9, poiLight.directColor, poiLight.indirectColor);
					poiLight.directColor += _LightColor0.rgb;
				}
				float lightMapMode = 0.0;
				if (0.0 == 0)
				{
					poiLight.direction = _WorldSpaceLightPos0.xyz + unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz;
				}
				if (0.0 == 1 || 0.0 == 2)
				{
					if (0.0 == 1)
					{
						poiLight.direction = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;;
					}
					if (0.0 == 2)
					{
						poiLight.direction = float4(0,0,0,1);
					}
					if (lightMapMode == 0)
					{
						lightMapMode == 1;
					}
				}
				if (0.0 == 3) // UTS
				{
					float3 defaultLightDirection = normalize(UNITY_MATRIX_V[2].xyz + UNITY_MATRIX_V[1].xyz);
					float3 lightDirection = normalize(lerp(defaultLightDirection, _WorldSpaceLightPos0.xyz, any(_WorldSpaceLightPos0.xyz)));
					poiLight.direction = lightDirection;
				}
				if (0.0 == 4) // OpenLit
				{
					poiLight.direction = OpenLitLightingDirection(); // float4 customDir = 0; // Do we want to give users to alter this (OpenLit always does!)?
				}
				if (!any(poiLight.direction))
				{
					poiLight.direction = float3(.4, 1, .4);
				}
				poiLight.direction = normalize(poiLight.direction);
				poiLight.attenuationStrength = 0.0;
				poiLight.attenuation = 1;
				if (!all(_LightColor0.rgb == 0.0))
				{
					UNITY_LIGHT_ATTENUATION(attenuation, i, poiMesh.worldPos)
					poiLight.attenuation *= attenuation;
				}
				if (!any(poiLight.directColor) && !any(poiLight.indirectColor) && lightMapMode == 0)
				{
					lightMapMode = 1;
					if (0.0 == 0)
					{
						poiLight.direction = normalize(float3(.4, 1, .4));
					}
				}
				poiLight.halfDir = normalize(poiLight.direction + poiCam.viewDir);
				poiLight.vertexNDotL = dot(poiMesh.normals[0], poiLight.direction);
				poiLight.nDotL = dot(poiMesh.normals[1], poiLight.direction);
				poiLight.nDotLSaturated = saturate(poiLight.nDotL);
				poiLight.nDotLNormalized = (poiLight.nDotL + 1) * 0.5;
				poiLight.nDotV = abs(dot(poiMesh.normals[1], poiCam.viewDir));
				poiLight.vertexNDotV = abs(dot(poiMesh.normals[0], poiCam.viewDir));
				poiLight.nDotH = dot(poiMesh.normals[1], poiLight.halfDir);
				poiLight.vertexNDotH = max(0.00001, dot(poiMesh.normals[0], poiLight.halfDir));
				poiLight.lDotv = dot(poiLight.direction, poiCam.viewDir);
				poiLight.lDotH = max(0.00001, dot(poiLight.direction, poiLight.halfDir));
				if (lightMapMode == 0)
				{
					float3 ShadeSH9Plus = GetSHLength();
					float3 ShadeSH9Minus = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) + float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
					float3 greyScaleVector = float3(.33333, .33333, .33333);
					float bw_lightColor = dot(poiLight.directColor, greyScaleVector);
					float bw_directLighting = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor * lerp(1, poiLight.attenuation, poiLight.attenuationStrength)) + dot(ShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_directLightingNoAtten = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor) + dot(ShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_bottomIndirectLighting = dot(ShadeSH9Minus, greyScaleVector);
					float bw_topIndirectLighting = dot(ShadeSH9Plus, greyScaleVector);
					float lightDifference = ((bw_topIndirectLighting + bw_lightColor) - bw_bottomIndirectLighting);
					poiLight.lightMap = smoothstep(0, lightDifference, bw_directLighting - bw_bottomIndirectLighting) * poiLight.detailShadow;
					poiLight.lightMap = smoothstep(0, lightDifference, bw_directLighting - bw_bottomIndirectLighting) * poiLight.detailShadow;
					poiLight.lightMapNoAttenuation = smoothstep(0, lightDifference, bw_directLightingNoAtten - bw_bottomIndirectLighting) * poiLight.detailShadow;
				}
				if (lightMapMode == 1)
				{
					poiLight.lightMapNoAttenuation = poiLight.nDotLNormalized;
					poiLight.lightMap = poiLight.nDotLNormalized * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				}
				if (lightMapMode == 2)
				{
					poiLight.lightMapNoAttenuation = poiLight.nDotLSaturated;
					poiLight.lightMap = poiLight.nDotLSaturated * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				}
				poiLight.directColor = max(poiLight.directColor, 0.0001);
				poiLight.indirectColor = max(poiLight.indirectColor, 0.0001);
				if (0.0 == 3)
				{
					poiLight.directColor = max(poiLight.directColor, 0.0);
				}
				else
				{
					poiLight.directColor = max(poiLight.directColor, poiLight.directColor * min(10000, (0.0 * rcp(calculateluminance(poiLight.directColor)))));
					poiLight.indirectColor = max(poiLight.indirectColor, poiLight.indirectColor * min(10000, (0.0 * rcp(calculateluminance(poiLight.indirectColor)))));
				}
				poiLight.directColor = lerp(poiLight.directColor, dot(poiLight.directColor, float3(0.299, 0.587, 0.114)), 0.0);
				poiLight.indirectColor = lerp(poiLight.indirectColor, dot(poiLight.indirectColor, float3(0.299, 0.587, 0.114)), 0.0);
				if (1.0)
				{
					poiLight.directColor = min(poiLight.directColor, 1.0);
					poiLight.indirectColor = min(poiLight.indirectColor, 1.0);
				}
				if (0.0)
				{
					poiLight.directColor = poiThemeColor(poiMods, float4(1,1,1,1), 0.0);
				}
				#ifdef UNITY_PASS_FORWARDBASE
				poiLight.directColor = max(poiLight.directColor * 1.0, 0);
				poiLight.directColor = max(poiLight.directColor + 0.0, 0);
				poiLight.indirectColor = max(poiLight.indirectColor * 1.0, 0);
				poiLight.indirectColor = max(poiLight.indirectColor + 0.0, 0);
				#endif
				#endif
				#ifdef POI_PASS_ADD
				if (!1.0)
				{
					return float4(mainTexture.rgb * .0001, 1);
				}
				#if defined(DIRECTIONAL)
				if (1.0)
				{
					return float4(mainTexture.rgb * .0001, 1);
				}
				#endif
				poiLight.direction = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w);
				#if defined(POINT) || defined(SPOT)
				#ifdef POINT
				unityShadowCoord3 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(poiMesh.worldPos, 1)).xyz;
				poiLight.attenuation = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).r;
				#endif
				#ifdef SPOT
				unityShadowCoord4 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(poiMesh.worldPos, 1));
				poiLight.attenuation = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) * UnitySpotAttenuate(lightCoord.xyz);
				#endif
				#else
				UNITY_LIGHT_ATTENUATION(attenuation, i, poiMesh.worldPos)
				poiLight.attenuation = attenuation;
				#endif
				poiLight.additiveShadow = UNITY_SHADOW_ATTENUATION(i, poiMesh.worldPos);
				poiLight.attenuationStrength = 1.0;
				poiLight.directColor = 0.0 ? min(1.0, _LightColor0.rgb) : _LightColor0.rgb;
				#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
				poiLight.indirectColor = 0;
				#else
				poiLight.indirectColor = lerp(0, poiLight.directColor, 0.5);
				#endif
				poiLight.directColor = lerp(poiLight.directColor, dot(poiLight.directColor, float3(0.299, 0.587, 0.114)), 0.0);
				poiLight.indirectColor = lerp(poiLight.indirectColor, dot(poiLight.indirectColor, float3(0.299, 0.587, 0.114)), 0.0);
				poiLight.halfDir = normalize(poiLight.direction + poiCam.viewDir);
				poiLight.nDotL = dot(poiMesh.normals[1], poiLight.direction);
				poiLight.nDotLSaturated = saturate(poiLight.nDotL);
				poiLight.nDotLNormalized = (poiLight.nDotL + 1) * 0.5;
				poiLight.nDotV = abs(dot(poiMesh.normals[1], poiCam.viewDir));
				poiLight.nDotH = dot(poiMesh.normals[1], poiLight.halfDir);
				poiLight.lDotv = dot(poiLight.direction, poiCam.viewDir);
				poiLight.lDotH = dot(poiLight.direction, poiLight.halfDir);
				poiLight.vertexNDotL = dot(poiMesh.normals[0], poiLight.direction);
				poiLight.vertexNDotV = abs(dot(poiMesh.normals[0], poiCam.viewDir));
				poiLight.vertexNDotH = max(0.00001, dot(poiMesh.normals[0], poiLight.halfDir));
				if (0.0 == 1)
				{
					poiLight.lightMap = poiLight.nDotLNormalized;
				}
				if (0.0 == 2 || 0.0 == 0)
				{
					poiLight.lightMap = poiLight.nDotLSaturated;
				}
				poiLight.lightMap *= lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				#endif
				poiFragData.baseColor = mainTexture.rgb * poiThemeColor(poiMods, float4(0.673178,0.2713008,0.1356672,1).rgb, 0.0);
				poiFragData.alpha = mainTexture.a * float4(0.673178,0.2713008,0.1356672,1).a;
				#if defined(PROP_CLIPPINGMASK) || !defined(OPTIMIZER_ENABLED)
				float alphaMask = POI2D_SAMPLER_PAN(_ClippingMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0)).r;
				if (0.0)
				{
					alphaMask = 1 - alphaMask;
				}
				poiFragData.alpha *= alphaMask;
				#endif
				applyAlphaOptions(poiFragData, poiMesh, poiCam, poiMods);
				#if defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL) || defined(GEOM_TYPE_FROND) || defined(DEPTH_OF_FIELD_COC_VIEW)
				applyDecals(poiFragData, poiMesh, poiCam, poiMods, poiLight);
				#endif
				#if defined(_LIGHTINGMODE_SHADEMAP) && defined(VIGNETTE_MASKED)
				#ifndef POI_PASS_OUTLINE
				#endif
				#endif
				#ifdef VIGNETTE_MASKED
				#ifdef POI_PASS_OUTLINE
				if (_OutlineLit)
				{
					calculateShading(poiLight, poiFragData, poiMesh, poiCam);
				}
				else
				{
					poiLight.finalLighting = 1;
				}
				#else
				calculateShading(poiLight, poiFragData, poiMesh, poiCam);
				#endif
				#else
				poiLight.finalLighting = 1;
				poiLight.rampedLightMap = poiEdgeNonLinear(poiLight.nDotL, 0.1, .1);
				#endif
				#if defined(POI_MATCAP0) || defined(COLOR_GRADING_HDR_3D) || defined(POI_MATCAP2) || defined(POI_MATCAP3)
				applyMatcap(poiFragData, poiCam, poiMesh, poiLight, poiMods);
				#endif
				#ifdef _GLOSSYREFLECTIONS_OFF
				#ifdef _RIMSTYLE_POIYOMI
				#if defined(PROP_RIMMASK) || !defined(OPTIMIZER_ENABLED)
				float4 rimMaskAndBias = POI2D_SAMPLER_PAN(_RimMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				float rimMask = rimMaskAndBias[0.0];
				float rimBias = rimMaskAndBias.a;
				#else
				float rimMask = 1;
				float rimBias = 0;
				#endif
				if(0.0)
				{
					rimMask = 1 - rimMask;
				}
				#if defined(PROP_RIMTEX) || !defined(OPTIMIZER_ENABLED)
				float4 rimColor = POI2D_SAMPLER_PAN(_RimTex, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				#else
				float4 rimColor = 1;
				#endif
				half AudioLinkRimWidthBand = 0;
				float2 AudioLinkRimWidthAdd = 0;
				half AudioLinkRimEmissionBand = 0;
				float2 AudioLinkRimEmissionAdd = 0;
				half AudioLinkRimBrightnessBand = 0;
				float2 AudioLinkRimBrightnessAdd = 0;
				#ifdef POI_AUDIOLINK
				AudioLinkRimWidthBand = 0.0;
				AudioLinkRimWidthAdd = float4(0,0,0,0);
				AudioLinkRimEmissionBand = 0.0;
				AudioLinkRimEmissionAdd = float4(0,0,0,0);
				AudioLinkRimBrightnessBand = 0.0;
				AudioLinkRimBrightnessAdd = float4(0,0,0,0);
				#endif
				ApplyPoiyomiRimLighting(poiFragData, poiMesh, poiCam, poiLight, poiMods, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.407, rimMask, 0.0, 2.0, rimColor, float4(0.673178,0.05184535,0.01049035,1), 0.0, 0.0, 0.0, 0.0, 0.131, 0.0, 0.0, 1.0, float4(0,0,0,1), 0.0, 2.0, 0.0, 1.0, 2.0, AudioLinkRimWidthBand, AudioLinkRimWidthAdd, AudioLinkRimEmissionBand, AudioLinkRimEmissionAdd, AudioLinkRimBrightnessBand, AudioLinkRimBrightnessAdd, 0.0, rimBias, 0.0);
				#endif
				#endif
				
				if (0.0)
				{
					poiFragData.baseColor *= saturate(poiFragData.alpha);
				}
				poiFragData.finalColor = poiFragData.baseColor;
				poiFragData.finalColor = poiFragData.baseColor * poiLight.finalLighting;
				#ifdef MOCHIE_PBR
				MochieBRDF(poiFragData, poiCam, poiLight, poiMesh, poiMods);
				#endif
				if (0.0 == 0)
				{
					UNITY_APPLY_FOG(i.fogCoord, poiFragData.finalColor);
				}
				poiFragData.alpha = 0.0 ? 1 : poiFragData.alpha;
				poiFragData.finalColor += poiLight.finalLightAdd;
				#ifdef UNITY_PASS_FORWARDBASE
				poiFragData.emission = max(poiFragData.emission * 1.0, 0);
				poiFragData.finalColor = max(poiFragData.finalColor * 1.0, 0);
				#endif
				if (0.0 == POI_MODE_OPAQUE)
				{
					poiFragData.alpha = 1;
				}
				clip(poiFragData.alpha - 0.5);
				if (0.0 == POI_MODE_CUTOUT && !0.0)
				{
					poiFragData.alpha = 1;
				}
				return float4(poiFragData.finalColor + poiFragData.emission * poiMods.globalEmission, poiFragData.alpha) + POI_SAFE_RGB0;
			}
struct SpsInputs : appdata {
#define SPS_STRUCT_POSITION_TYPE float4
#define SPS_STRUCT_POSITION_TYPE_float4
#define SPS_STRUCT_POSITION_NAME vertex
#define SPS_STRUCT_NORMAL_TYPE float3
#define SPS_STRUCT_NORMAL_TYPE_float3
#define SPS_STRUCT_NORMAL_NAME normal
#define SPS_STRUCT_TANGENT_TYPE float4
#define SPS_STRUCT_TANGENT_TYPE_float4
#define SPS_STRUCT_TANGENT_NAME tangent
#define SPS_STRUCT_COLOR_TYPE float4
#define SPS_STRUCT_COLOR_TYPE_float4
#define SPS_STRUCT_COLOR_NAME color
#define SPS_STRUCT_TEXCOORD_TYPE float2
#define SPS_STRUCT_TEXCOORD_TYPE_float2
#define SPS_STRUCT_TEXCOORD_NAME uv0
#define SPS_STRUCT_TEXCOORD1_TYPE float2
#define SPS_STRUCT_TEXCOORD1_TYPE_float2
#define SPS_STRUCT_TEXCOORD1_NAME uv1
#define SPS_STRUCT_TEXCOORD2_TYPE float2
#define SPS_STRUCT_TEXCOORD2_TYPE_float2
#define SPS_STRUCT_TEXCOORD2_NAME uv2
#define SPS_STRUCT_TEXCOORD3_TYPE float2
#define SPS_STRUCT_TEXCOORD3_TYPE_float2
#define SPS_STRUCT_TEXCOORD3_NAME uv3
#define SPS_STRUCT_SV_VertexID_TYPE uint
#define SPS_STRUCT_SV_VertexID_TYPE_uint
#define SPS_STRUCT_SV_VertexID_NAME vertexId

// Add parameters needed by SPS if missing from the existing struct
#ifndef SPS_STRUCT_POSITION_NAME
  float3 spsPosition : POSITION;
  #define SPS_STRUCT_POSITION_TYPE float3
  #define SPS_STRUCT_POSITION_TYPE_float3
  #define SPS_STRUCT_POSITION_NAME spsPosition
#endif
#ifndef SPS_STRUCT_NORMAL_NAME
  float3 spsNormal : NORMAL;
  #define SPS_STRUCT_NORMAL_TYPE float3
  #define SPS_STRUCT_NORMAL_TYPE_float3
  #define SPS_STRUCT_NORMAL_NAME spsNormal
#endif
#ifndef SPS_STRUCT_TANGENT_NAME
  float4 spsTangent : TANGENT;
  #define SPS_STRUCT_TANGENT_TYPE float4
  #define SPS_STRUCT_TANGENT_TYPE_float4
  #define SPS_STRUCT_TANGENT_NAME spsTangent
#endif
#ifndef SPS_STRUCT_SV_VertexID_NAME
  uint spsVertexId : SV_VertexID;
  #define SPS_STRUCT_SV_VertexID_TYPE uint
  #define SPS_STRUCT_SV_VertexID_TYPE_uint
  #define SPS_STRUCT_SV_VertexID_NAME spsVertexId
#endif
#ifndef SPS_STRUCT_COLOR_NAME
  float4 spsColor : COLOR;
  #define SPS_STRUCT_COLOR_TYPE float4
  #define SPS_STRUCT_COLOR_TYPE_float4
  #define SPS_STRUCT_COLOR_NAME spsColor
#endif
};
#define SPS_VANILLA_VERT_PARAM_TYPE appdata


#ifndef SPS_UTILS
#define SPS_UTILS

#include "UnityShaderVariables.cginc"

float sps_map(float value, float min1, float max1, float min2, float max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float sps_saturated_map(float value, float min, float max) {
    return saturate(sps_map(value, min, max, 0, 1));
}

// normalize fails fatally and discards the vert if length == 0
float3 sps_normalize(float3 a) {
    return length(a) == 0 ? float3(0,0,1) : normalize(a);
}

#define sps_angle_between(a,b) acos(dot(sps_normalize(a),sps_normalize(b)))

float3 sps_nearest_normal(float3 forward, float3 approximate) {
    return sps_normalize(cross(forward, cross(approximate, forward)));
}

float3 sps_toLocal(float3 v) { return mul(unity_WorldToObject, float4(v, 1)).xyz; }
float3 sps_toWorld(float3 v) { return mul(unity_ObjectToWorld, float4(v, 1)).xyz; }
// https://forum.unity.com/threads/point-light-in-v-f-shader.499717/#post-9052987
float sps_attenToRange(float atten) { return 5.0 * (1.0 / sqrt(atten)); }

#endif




// https://en.wikipedia.org/wiki/B%C3%A9zier_curve
float3 sps_bezier(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
	const float minT = 1-t;
	return
		minT * minT * minT * p0
		+ 3 * minT * minT * t * p1
		+ 3 * minT * t * t * p2
		+ t * t * t * p3;
}
float3 sps_bezierDerivative(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
	const float minT = 1-t;
	return
		3 * minT * minT * (p1 - p0)
		+ 6 * minT * t * (p2 - p1)
		+ 3 * t * t * (p3 - p2);
}

// https://gamedev.stackexchange.com/questions/105230/points-evenly-spaced-along-a-bezier-curve
// https://gamedev.stackexchange.com/questions/5373/moving-ships-between-two-planets-along-a-bezier-missing-some-equations-for-acce/5427#5427
// https://www.geometrictools.com/Documentation/MovingAlongCurveSpecifiedSpeed.pdf
// https://gamedev.stackexchange.com/questions/137022/consistent-normals-at-any-angle-in-bezier-curve/
void sps_bezierSolve(float3 p0, float3 p1, float3 p2, float3 p3, float lookingForLength, out float curveLength, out float3 position, out float3 forward, out float3 up)
{
	#define SPS_BEZIER_SAMPLES 50
	float sampledT[SPS_BEZIER_SAMPLES];
	float sampledLength[SPS_BEZIER_SAMPLES];
	float3 sampledUp[SPS_BEZIER_SAMPLES];
	float totalLength = 0;
	float3 lastPoint = p0;
	sampledT[0] = 0;
	sampledLength[0] = 0;
	sampledUp[0] = float3(0,1,0);
	{
		for(int i = 1; i < SPS_BEZIER_SAMPLES; i++)
		{
			const float t = float(i) / (SPS_BEZIER_SAMPLES-1);
			const float3 currentPoint = sps_bezier(p0, p1, p2, p3, t);
			const float3 currentForward = sps_normalize(sps_bezierDerivative(p0, p1, p2, p3, t));
			const float3 lastUp = sampledUp[i-1];
			const float3 currentUp = sps_nearest_normal(currentForward, lastUp);

			sampledT[i] = t;
			totalLength += length(currentPoint - lastPoint);
			sampledLength[i] = totalLength;
			sampledUp[i] = currentUp;
			lastPoint = currentPoint;
		}
	}

	float adjustedT = 1;
	float3 approximateUp = sampledUp[SPS_BEZIER_SAMPLES - 1];
	for(int i = 1; i < SPS_BEZIER_SAMPLES; i++)
	{
		if (lookingForLength <= sampledLength[i])
		{
			const float fraction = sps_map(lookingForLength, sampledLength[i-1], sampledLength[i], 0, 1);
			adjustedT = lerp(sampledT[i-1], sampledT[i], fraction);
			approximateUp = lerp(sampledUp[i-1], sampledUp[i], fraction);
			break;
		}
	}

	curveLength = totalLength;
	const float t = saturate(adjustedT);
	position = sps_bezier(p0, p1, p2, p3, t);
	forward = sps_normalize(sps_bezierDerivative(p0, p1, p2, p3, t));
	up = sps_nearest_normal(forward, approximateUp);
}


#include "UnityShaderVariables.cginc"
#ifndef SPS_GLOBALS
#define SPS_GLOBALS

#define SPS_PI float(3.14159265359)

#define SPS_TYPE_INVALID 0
#define SPS_TYPE_HOLE 1
#define SPS_TYPE_RING_TWOWAY 2
#define SPS_TYPE_SPSPLUS 3
#define SPS_TYPE_RING_ONEWAY 4
#define SPS_TYPE_FRONT 5

#ifdef SHADER_TARGET_SURFACE_ANALYSIS
    #define SPS_TEX_DEFINE(name) float4 name##_TexelSize; sampler2D name;
    #define SPS_TEX_RAW_FLOAT4_XY(name,x,y) tex2Dlod(name, float4(uint2(x,y) * name##_TexelSize.xy, 0, 0))
#else
    #define SPS_TEX_DEFINE(name) Texture2D name;
    #define SPS_TEX_RAW_FLOAT4_XY(name,x,y) name[uint2(x,y)]
#endif
float SpsInt4ToFloat(int4 data) { return asfloat((data[3] << 24) | (data[2] << 16) | (data[1] << 8) | data[0]); }
#define SPS_TEX_RAW_FLOAT4(tex, offset) ((float4)(SPS_TEX_RAW_FLOAT4_XY(tex, (offset)%8192, (offset)/8192)))
#define SPS_TEX_RAW_INT4(tex, offset) ((int4)(SPS_TEX_RAW_FLOAT4(tex, offset) * 255))
#define SPS_TEX_FLOAT(tex, offset) SpsInt4ToFloat(SPS_TEX_RAW_INT4(tex, offset))
#define SPS_TEX_FLOAT3(tex, offset) float3(SPS_TEX_FLOAT(tex, offset), SPS_TEX_FLOAT(tex, (offset)+1), SPS_TEX_FLOAT(tex, (offset)+2))

float _SPS_Length;
float _SPS_BakedLength;
SPS_TEX_DEFINE(_SPS_Bake)
float _SPS_BlendshapeVertCount;
float _SPS_Blendshape0;
float _SPS_Blendshape1;
float _SPS_Blendshape2;
float _SPS_Blendshape3;
float _SPS_Blendshape4;
float _SPS_Blendshape5;
float _SPS_Blendshape6;
float _SPS_Blendshape7;
float _SPS_Blendshape8;
float _SPS_Blendshape9;
float _SPS_Blendshape10;
float _SPS_Blendshape11;
float _SPS_Blendshape12;
float _SPS_Blendshape13;
float _SPS_Blendshape14;
float _SPS_Blendshape15;
float _SPS_BlendshapeCount;

float _SPS_Enabled;
float _SPS_Overrun;
float _SPS_Target_LL_Lights;

#endif




#ifndef SPS_PLUS
#define SPS_PLUS

float _SPS_Plus_Enabled;
float _SPS_Plus_Ring;
float _SPS_Plus_Hole;

void sps_plus_search(
    out float distance,
    out int type
) {
    distance = 999;
    type = SPS_TYPE_INVALID;
    
    float maxVal = 0;
    if (_SPS_Plus_Ring > maxVal) { maxVal = _SPS_Plus_Ring; type = SPS_TYPE_RING_TWOWAY; }
    if (_SPS_Plus_Hole == maxVal) { type = SPS_TYPE_RING_ONEWAY; }
    if (_SPS_Plus_Hole > maxVal) { maxVal = _SPS_Plus_Hole; type = SPS_TYPE_HOLE; }

    if (maxVal > 0) {
        distance = (1 - maxVal) * 3;
    }
}

#endif




void sps_light_parse(float range, half4 color, out int type) {
	type = SPS_TYPE_INVALID;

	if (range >= 0.5 || (length(color.rgb) > 0 && color.a > 0)) {
		// Outside of SPS range, or visible light
		return;
	}

	const int secondDecimal = round((range % 0.1) * 100);

	if (_SPS_Plus_Enabled > 0.5) {
		if (secondDecimal == 1 || secondDecimal == 2) {
			const int fourthDecimal = round((range % 0.001) * 10000);
			if (fourthDecimal == 2) {
				type = SPS_TYPE_SPSPLUS;
				return;
			}
		}
	}

	if (secondDecimal == 1) type = SPS_TYPE_HOLE;
	if (secondDecimal == 2) type = SPS_TYPE_RING_TWOWAY;
	if (secondDecimal == 5) type = SPS_TYPE_FRONT;
}

// Find nearby socket lights
void sps_light_search(
	inout int ioType,
	inout float3 ioRootLocal,
	inout float3 ioRootNormal
) {
	// Collect useful info about all the nearby lights that unity tells us about
	// (usually the brightest 4)
	int lightType[4];
	float3 lightWorldPos[4];
	float3 lightLocalPos[4];
	{
		for(int i = 0; i < 4; i++) {
	 		const float range = sps_attenToRange(unity_4LightAtten0[i]);
			sps_light_parse(range, unity_LightColor[i], lightType[i]);
	 		lightWorldPos[i] = float3(unity_4LightPosX0[i], unity_4LightPosY0[i], unity_4LightPosZ0[i]);
	 		lightLocalPos[i] = sps_toLocal(lightWorldPos[i]);
	 	}
	}

	// Fill in SPS light info from contacts
	if (_SPS_Plus_Enabled > 0.5) {
		float spsPlusDistance;
		int spsPlusType;
		sps_plus_search(spsPlusDistance, spsPlusType);
		if (spsPlusType != SPS_TYPE_INVALID) {
			bool spsLightFound = false;
			int spsLightIndex = 0;
			float spsMinError = 0;
			for(int i = 0; i < 4; i++) {
				if (lightType[i] != SPS_TYPE_SPSPLUS) continue;
				const float3 myPos = lightLocalPos[i];
				const float3 otherPos = lightLocalPos[spsLightIndex];
				const float myError = abs(length(myPos) - spsPlusDistance);
				if (myError > 0.2) continue;
				const float otherError = spsMinError;

				bool imBetter = false;
				if (!spsLightFound) imBetter = true;
				else if (myError < 0.3 && myPos.z >= 0 && otherPos.z < 0) imBetter = true;
				else if (otherError < 0.3 && otherPos.z >= 0 && myPos.z < 0) imBetter = false;
				else if (myError < otherError) imBetter = true;

				if (imBetter) {
					spsLightFound = true;
					spsLightIndex = i;
					spsMinError = myError;
				}
			}
			if (spsLightFound) {
				lightType[spsLightIndex] = spsPlusType;
			}
		}
	}

	// Find nearest socket root
	int rootIndex = 0;
	bool rootFound = false;
	{
	 	float minDistance = -1;
	 	for(int i = 0; i < 4; i++) {
	 		const float distance = length(lightLocalPos[i]);
	 		const int type = lightType[i];
	 		if (distance < minDistance || minDistance < 0) {
	 			if (type == SPS_TYPE_HOLE || type == SPS_TYPE_RING_TWOWAY || type == SPS_TYPE_RING_ONEWAY) {
	 				rootFound = true;
	 				rootIndex = i;
	 				minDistance = distance;
	 			}
	 		}
	 	}
	}
	
	int frontIndex = 0;
	bool frontFound = false;
	if (rootFound) {
	 	// Find front (normal) light for socket root if available
	 	float minDistance = 0.1;
	 	for(int i = 0; i < 4; i++) {
	 		const float distFromRoot = length(lightWorldPos[i] - lightWorldPos[rootIndex]);
	 		if (lightType[i] == SPS_TYPE_FRONT && distFromRoot < minDistance) {
	 			frontFound = true;
	 			frontIndex = i;
	 			minDistance = distFromRoot;
	 		}
	 	}
	}

	// This can happen if the socket was misconfigured, or if it's on a first person head bone that's been shrunk down
	// Ignore the normal, since it'll be so close to the root that rounding error will cause problems
	if (frontFound && length(lightLocalPos[frontIndex] - lightLocalPos[rootIndex]) < 0.00005) {
		frontFound = false;
	}

	if (!rootFound) return;
	if (ioType != SPS_TYPE_INVALID && length(lightLocalPos[rootIndex]) >= length(ioRootLocal)) return;

	ioType = lightType[rootIndex];
	ioRootLocal = lightLocalPos[rootIndex];
	ioRootNormal = frontFound
		? lightLocalPos[frontIndex] - lightLocalPos[rootIndex]
		: -1 * lightLocalPos[rootIndex];
	ioRootNormal = sps_normalize(ioRootNormal);
}











void SpsApplyBlendshape(uint vertexId, inout float3 position, inout float3 normal, inout float3 tangent, float blendshapeValue, int blendshapeId)
{
    if (blendshapeId >= _SPS_BlendshapeCount) return;
    const int vertCount = (int)_SPS_BlendshapeVertCount;
    const uint bytesPerBlendshapeVertex = 9;
    const uint bytesPerBlendshape = vertCount * bytesPerBlendshapeVertex + 1;
    const uint blendshapeOffset = 1 + (vertCount * 10) + bytesPerBlendshape * blendshapeId;
    const uint vertexOffset = blendshapeOffset + 1 + (vertexId * bytesPerBlendshapeVertex);
    const float blendshapeValueAtBake = SPS_TEX_FLOAT(_SPS_Bake, blendshapeOffset);
    const float blendshapeValueNow = blendshapeValue;
    const float change = (blendshapeValueNow - blendshapeValueAtBake) * 0.01;
    position += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset) * change;
    normal += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset + 3) * change;
    tangent += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset + 6) * change;
}

void SpsGetBakedPosition(uint vertexId, out float3 position, out float3 normal, out float3 tangent, out float active) {
    const uint bakeIndex = 1 + vertexId * 10;
    position = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex);
    normal = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex + 3);
    tangent = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex + 6);
    active = SPS_TEX_FLOAT(_SPS_Bake, bakeIndex + 9);
    if (position.z < 0) active = 0;

    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape0, 0);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape1, 1);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape2, 2);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape3, 3);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape4, 4);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape5, 5);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape6, 6);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape7, 7);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape8, 8);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape9, 9);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape10, 10);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape11, 11);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape12, 12);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape13, 13);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape14, 14);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape15, 15);
}






// SPS Penetration Shader
void sps_apply_real(
	inout SPS_STRUCT_POSITION_TYPE vertex,
	inout SPS_STRUCT_NORMAL_TYPE normal,
	inout SPS_STRUCT_TANGENT_TYPE tangent,
	uint vertexId,
	inout SPS_STRUCT_COLOR_TYPE color
) {
	const float worldLength = _SPS_Length;
	const float3 origVertex = vertex.xyz;
	const float3 origNormal = normal.xyz;
	const float3 origTangent = tangent.xyz;
	float3 bakedVertex;
	float3 bakedNormal;
	float3 bakedTangent;
	float active;
	SpsGetBakedPosition(vertexId, bakedVertex, bakedNormal, bakedTangent, active);

	bakedVertex *= (_SPS_Length / _SPS_BakedLength);
	
	if (active == 0) return;

	float3 rootPos;
	int type = SPS_TYPE_INVALID;
	float3 frontNormal;
	sps_light_search(type, rootPos, frontNormal);
	if (type == SPS_TYPE_INVALID) return;

	float orfDistance = length(rootPos);
	float exitAngle = sps_angle_between(rootPos, float3(0,0,1));
	float entranceAngle = SPS_PI - sps_angle_between(frontNormal, rootPos);

	// Flip backward bidirectional rings
	if (type == SPS_TYPE_RING_TWOWAY && entranceAngle > SPS_PI/2) {
		frontNormal *= -1;
		entranceAngle = SPS_PI - entranceAngle;
	}

	// Decide if we should cancel deformation due to extreme angles, long distance, etc
	float bezierLerp;
	float dumbLerp;
	float shrinkLerp = 0;
	{
		float applyLerp = 1;
		// Cancel if base angle is too sharp
		const float allowedExitAngle = 0.6;
		const float exitAngleTooSharp = exitAngle > SPS_PI*allowedExitAngle ? 1 : 0;
		applyLerp = min(applyLerp, 1-exitAngleTooSharp);

		// Cancel if the entrance angle is too sharp
		if (type != SPS_TYPE_RING_TWOWAY) {
			const float allowedEntranceAngle = 0.8;
			const float entranceAngleTooSharp = entranceAngle > SPS_PI*allowedEntranceAngle ? 1 : 0;
			applyLerp = min(applyLerp, 1-entranceAngleTooSharp);
		}

		if (type == SPS_TYPE_HOLE) {
			// Uncancel if hilted in a hole
			const float hiltedSphereRadius = 0.5;
			const float inSphere = orfDistance > worldLength*hiltedSphereRadius ? 0 : 1;
			//const float hilted = min(isBehind, inSphere);
			//shrinkLerp = hilted;
			const float hilted = inSphere;
			applyLerp = max(applyLerp, hilted);
		} else {
			// Cancel if ring is near or behind base
			const float isBehind = rootPos.z > 0 ? 0 : 1;
			applyLerp = min(applyLerp, 1-isBehind);
		}

		// Cancel if too far away
		const float tooFar = sps_saturated_map(orfDistance, worldLength*1.2, worldLength*1.6);
		applyLerp = min(applyLerp, 1-tooFar);

		applyLerp = applyLerp * saturate(_SPS_Enabled);

		dumbLerp = sps_saturated_map(applyLerp, 0, 0.2) * active;
		bezierLerp = sps_saturated_map(applyLerp, 0, 1);
		shrinkLerp = sps_saturated_map(applyLerp, 0.8, 1) * shrinkLerp;
	}

	rootPos *= (1-shrinkLerp);
	orfDistance *= (1-shrinkLerp);

	float3 bezierPos;
	float3 bezierForward;
	float3 bezierRight;
	float3 bezierUp;
	float curveLength;
	if (length(rootPos) == 0) {
		bezierPos = float3(0,0,0);
		bezierForward = float3(0,0,1);
		bezierRight = float3(1,0,0);
		bezierUp = float3(0,1,0);
		curveLength = 0;
	} else{
		const float3 p0 = float3(0,0,0);
		const float p1Dist = min(orfDistance, max(worldLength / 8, rootPos.z / 4));
		const float p1DistWithPullout = sps_map(bezierLerp, 0, 1, worldLength * 5, p1Dist);
		const float3 p1 = float3(0,0,p1DistWithPullout);
		const float3 p2 = rootPos + frontNormal * p1Dist;
		const float3 p3 = rootPos;
		sps_bezierSolve(p0, p1, p2, p3, bakedVertex.z, curveLength, bezierPos, bezierForward, bezierUp);
		bezierRight = sps_normalize(cross(bezierUp, bezierForward));
	}

	// Handle holes and rings
	float holeShrink = 1;
	if (type == SPS_TYPE_RING_TWOWAY || type == SPS_TYPE_RING_ONEWAY) {
		if (bakedVertex.z >= curveLength) {
			// Straighten if past socket
			bezierPos += (bakedVertex.z - curveLength) * bezierForward;
		}
	} else {
		const float holeRecessDistance = worldLength * 0.05;
		const float holeRecessDistance2 = worldLength * 0.1;
		holeShrink = sps_saturated_map(
			bakedVertex.z,
			curveLength + holeRecessDistance2,
			curveLength + holeRecessDistance
		);
		if(_SPS_Overrun > 0) {
			if (bakedVertex.z >= curveLength + holeRecessDistance2) {
				// If way past socket, condense to point
				bezierPos += holeRecessDistance2 * bezierForward;
			} else if (bakedVertex.z >= curveLength) {
				// Straighten if past socket
				bezierPos += (bakedVertex.z - curveLength) * bezierForward;
			}
		}
	}

	float3 deformedVertex = bezierPos + bezierRight * bakedVertex.x * holeShrink + bezierUp * bakedVertex.y * holeShrink;
	vertex.xyz = lerp(origVertex, deformedVertex, dumbLerp);
	if (length(bakedNormal) != 0) {
		float3 deformedNormal = bezierRight * bakedNormal.x + bezierUp * bakedNormal.y + bezierForward * bakedNormal.z;
		normal.xyz = lerp(origNormal, deformedNormal, dumbLerp);
	}
	if (length(bakedTangent) != 0) {
		float3 deformedTangent = bezierRight * bakedTangent.x + bezierUp * bakedTangent.y + bezierForward * bakedTangent.z;
		tangent.xyz = lerp(origTangent, deformedTangent, dumbLerp);
	}
}

void sps_apply(inout SpsInputs o) {

	// When VERTEXLIGHT_ON is missing, there are no lights nearby, and the 4light arrays will be full of junk
	// Temporarily disable this check since apparently it causes some passes to not apply SPS
	//#ifdef VERTEXLIGHT_ON
	sps_apply_real(
		o.SPS_STRUCT_POSITION_NAME,
		o.SPS_STRUCT_NORMAL_NAME,
		o.SPS_STRUCT_TANGENT_NAME,
		o.SPS_STRUCT_SV_VertexID_NAME,
		o.SPS_STRUCT_COLOR_NAME
	);
	//#endif

}

VertexOut spsVert(
			#ifndef POI_TESSELLATED
			SpsInputs v
			#else
			tessAppData v
			#endif
			) {
  sps_apply(v);
  return vert(
			#ifndef POI_TESSELLATED
			(appdata)v
			#else
			v
			#endif
			);
}

			ENDCG
		
}
		Pass
		{

			Tags { "LightMode" = "ForwardAdd" }
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilCompareFunction]
				Pass [_StencilPassOp]
				Fail [_StencilFailOp]
				ZFail [_StencilZFailOp]
			}
			ZWrite Off
			Cull Back
			AlphaToMask [_AlphaToCoverage]
			ZTest [_ZTest]
			ColorMask RGBA
			Offset [_OffsetFactor], [_OffsetUnits]
			BlendOp [_AddBlendOp], [_AddBlendOpAlpha]
			Blend [_AddSrcBlend] [_AddDstBlend], [_AddSrcBlendAlpha] [_AddDstBlendAlpha]
			CGPROGRAM

 #define MOCHIE_PBR 
 #define POI_MATCAP0 
 #define VIGNETTE_MASKED 
 #define _GLOSSYREFLECTIONS_OFF 
 #define _LIGHTINGMODE_FLAT 
 #define _RIM2STYLE_POIYOMI 
 #define _RIMSTYLE_POIYOMI 
 #define _STOCHASTICMODE_DELIOT_HEITZ 
 #define PROP_MATCAP 
 #define OPTIMIZER_ENABLED 
			#pragma target 5.0
			#pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define POI_PASS_ADD
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "AutoLight.cginc"
			#include "UnityLightingCommon.cginc"
			#include "UnityPBSLighting.cginc"
			#ifdef POI_PASS_META
			#include "UnityMetaPass.cginc"
			#endif
			// #pragma vertex vert
#pragma vertex spsVert

			#pragma fragment frag
			#define DielectricSpec float4(0.04, 0.04, 0.04, 1.0 - 0.04)
			#define PI float(3.14159265359)
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex,samplertex,coord,dx,dy) tex.SampleGrad (sampler##samplertex,coord,dx,dy)
			#define POI_PAN_UV(uv, pan) (uv + _Time.x * pan)
			#define POI2D_SAMPLER_PAN(tex, texSampler, uv, pan) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, POI_PAN_UV(uv, pan)))
			#define POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, POI_PAN_UV(uv, pan), dx, dy))
			#define POI2D_SAMPLER(tex, texSampler, uv) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_GRAD(tex, texSampler, uv, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, uv, dx, dy))
			#define POI2D_PAN(tex, uv, pan) (tex2D(tex, POI_PAN_UV(uv, pan)))
			#define POI2D(tex, uv) (tex2D(tex, uv))
			#define POI_SAMPLE_TEX2D(tex, uv) (UNITY_SAMPLE_TEX2D(tex, uv))
			#define POI_SAMPLE_TEX2D_PAN(tex, uv, pan) (UNITY_SAMPLE_TEX2D(tex, POI_PAN_UV(uv, pan)))
			#define POI_SAFE_RGB0 float4(mainTexture.rgb * .0001, 0)
			#define POI_SAFE_RGB1 float4(mainTexture.rgb * .0001, 1)
			#define POI_SAFE_RGBA mainTexture
			#if defined(UNITY_COMPILER_HLSL)
			#define PoiInitStruct(type, name) name = (type)0;
			#else
			#define PoiInitStruct(type, name)
			#endif
			#define POI_ERROR(poiMesh, gridSize) lerp(float3(1, 0, 1), float3(0, 0, 0), fmod(floor((poiMesh.worldPos.x) * gridSize) + floor((poiMesh.worldPos.y) * gridSize) + floor((poiMesh.worldPos.z) * gridSize), 2) == 0)
			#define POI_NAN (asfloat(-1))
			#define POI_MODE_OPAQUE 0
			#define POI_MODE_CUTOUT 1
			#define POI_MODE_FADE 2
			#define POI_MODE_TRANSPARENT 3
			#define POI_MODE_ADDITIVE 4
			#define POI_MODE_SOFTADDITIVE 5
			#define POI_MODE_MULTIPLICATIVE 6
			#define POI_MODE_2XMULTIPLICATIVE 7
			#define POI_MODE_TRANSCLIPPING 9
			float _Mode;
			float _StochasticDeliotHeitzDensity;
			float _StochasticHexGridDensity;
			float _StochasticHexRotationStrength;
			float _StochasticHexFallOffContrast;
			float _StochasticHexFallOffPower;
			#if defined(PROP_LIGHTINGAOMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _LightingAOMaps;
			#endif
			float4 _LightingAOMaps_ST;
			float2 _LightingAOMapsPan;
			float _LightingAOMapsUV;
			float _LightDataAOStrengthR;
			float _LightDataAOStrengthG;
			float _LightDataAOStrengthB;
			float _LightDataAOStrengthA;
			float _LightDataAOGlobalMaskR;
			float _LightDataAOGlobalMaskBlendTypeR;
			#if defined(PROP_LIGHTINGDETAILSHADOWMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _LightingDetailShadowMaps;
			#endif
			float4 _LightingDetailShadowMaps_ST;
			float2 _LightingDetailShadowMapsPan;
			float _LightingDetailShadowMapsUV;
			float _LightingDetailShadowStrengthR;
			float _LightingDetailShadowStrengthG;
			float _LightingDetailShadowStrengthB;
			float _LightingDetailShadowStrengthA;
			float _LightingAddDetailShadowStrengthR;
			float _LightingAddDetailShadowStrengthG;
			float _LightingAddDetailShadowStrengthB;
			float _LightingAddDetailShadowStrengthA;
			float _LightDataDetailShadowGlobalMaskR;
			float _LightDataDetailShadowGlobalMaskBlendTypeR;
			#if defined(PROP_LIGHTINGSHADOWMASKS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _LightingShadowMasks;
			#endif
			float4 _LightingShadowMasks_ST;
			float2 _LightingShadowMasksPan;
			float _LightingShadowMasksUV;
			float _LightingShadowMaskStrengthR;
			float _LightingShadowMaskStrengthG;
			float _LightingShadowMaskStrengthB;
			float _LightingShadowMaskStrengthA;
			float _LightDataShadowMaskGlobalMaskR;
			float _LightDataShadowMaskGlobalMaskBlendTypeR;
			float _Unlit_Intensity;
			float _LightingColorMode;
			float _LightingMapMode;
			float _LightingDirectionMode;
			float3 _LightngForcedDirection;
			float _LightingIndirectUsesNormals;
			float _LightingCapEnabled;
			float _LightingCap;
			float _LightingForceColorEnabled;
			float3 _LightingForcedColor;
			float _LightingForcedColorThemeIndex;
			float _LightingCastedShadows;
			float _LightingMonochromatic;
			float _LightingMinLightBrightness;
			float _LightingAdditiveEnable;
			float _LightingAdditiveLimited;
			float _LightingAdditiveLimit;
			float _LightingAdditiveCastedShadows;
			float _LightingAdditiveMonochromatic;
			float _LightingAdditivePassthrough;
			float _DisableDirectionalInAdd;
			float _LightingVertexLightingEnabled;
			float _LightDataDebugEnabled;
			float _LightingDebugVisualize;
			float _IgnoreFog;
			float _RenderingReduceClipDistance;
			float _AddBlendOp;
			float4 _Color;
			float _ColorThemeIndex;
			UNITY_DECLARE_TEX2D(_MainTex);
			UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
			float _MainPixelMode;
			float4 _MainTex_ST;
			float2 _MainTexPan;
			float _MainTexUV;
			float4 _MainTex_TexelSize;
			float _MainTexStochastic;
			#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _BumpMap;
			#endif
			float4 _BumpMap_ST;
			float2 _BumpMapPan;
			float _BumpMapUV;
			float _BumpScale;
			float _BumpMapStochastic;
			Texture2D _ClippingMask;
			float4 _ClippingMask_ST;
			float2 _ClippingMaskPan;
			float _ClippingMaskUV;
			float _Inverse_Clipping;
			float _Cutoff;
			SamplerState sampler_linear_clamp;
			SamplerState sampler_linear_repeat;
			float _AlphaForceOpaque;
			float _AlphaMod;
			float _AlphaPremultiply;
			float _AlphaBoostFA;
			float _AlphaGlobalMask;
			float _AlphaGlobalMaskBlendType;
			float4 _GlobalThemeColor0;
			float4 _GlobalThemeColor1;
			float4 _GlobalThemeColor2;
			float4 _GlobalThemeColor3;
			float _GlobalThemeHue0;
			float _GlobalThemeHue1;
			float _GlobalThemeHue2;
			float _GlobalThemeHue3;
			float _GlobalThemeHueSpeed0;
			float _GlobalThemeHueSpeed1;
			float _GlobalThemeHueSpeed2;
			float _GlobalThemeHueSpeed3;
			float _GlobalThemeSaturation0;
			float _GlobalThemeSaturation1;
			float _GlobalThemeSaturation2;
			float _GlobalThemeSaturation3;
			float _GlobalThemeValue0;
			float _GlobalThemeValue1;
			float _GlobalThemeValue2;
			float _GlobalThemeValue3;
			float _StereoEnabled;
			float _PolarUV;
			float2 _PolarCenter;
			float _PolarRadialScale;
			float _PolarLengthScale;
			float _PolarSpiralPower;
			float _PanoUseBothEyes;
			float _UVModWorldPos0;
			float _UVModWorldPos1;
			float _UVModLocalPos0;
			float _UVModLocalPos1;
			float _ShadowStrength;
			float _LightingIgnoreAmbientColor;
			float3 _LightingShadowColor;
			float _LightingAdditiveType;
			float _LightingAdditiveGradientStart;
			float _LightingAdditiveGradientEnd;
			float _LightingAdditiveDetailStrength;
			#ifdef POI_MATCAP0
			#if defined(PROP_MATCAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _Matcap;
			float4 _Matcap_ST;
			float4 _Matcap_TexelSize;
			float2 _MatcapPan;
			float _MatcapUV;
			#endif
			#if defined(PROP_MATCAPMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _MatcapMask;
			float4 _MatcapMask_ST;
			float2 _MatcapMaskPan;
			float _MatcapMaskUV;
			float _MatcapMaskChannel;
			#endif
			float _MatcapUVToBlend;
			float4 _MatCapBlendUV1;
			float _MatcapUVMode;
			float _MatcapMaskInvert;
			float _MatcapMaskGlobalMask;
			float _MatcapMaskGlobalMaskBlendType;
			float _MatcapBorder;
			float _MatcapRotation;
			float _MatcapSmoothnessEnabled;
			float _MatcapSmoothness;
			float _MatcapMaskSmoothnessChannel;
			float _MatcapMaskSmoothnessApply;
			float4 _MatcapColor;
			float _MatcapBaseColorMix;
			float _MatcapColorThemeIndex;
			float _MatcapIntensity;
			float _MatcapReplace;
			float _MatcapMultiply;
			float _MatcapAdd;
			float _MatcapAddToLight;
			float _MatcapMixed;
			float _MatcapScreen;
			float _MatcapAlphaOverride;
			float _MatcapEnable;
			float _MatcapLightMask;
			float _MatcapEmissionStrength;
			float _MatcapNormal;
			float _MatcapHueShiftEnabled;
			float _MatcapHueShiftSpeed;
			float _MatcapHueShift;
			float _MatcapTPSDepthEnabled;
			float _MatcapTPSMaskStrength;
			#endif
			#ifdef _GLOSSYREFLECTIONS_OFF
			float _Is_NormalMapToRimLight;
			float4 _RimLightColor;
			float _RimLightColorThemeIndex;
			float _RimClamp;
			#ifdef _RIMSTYLE_POIYOMI
			float _RimLightingInvert;
			float _RimWidth;
			float _RimStrength;
			float _RimSharpness;
			float _RimBaseColorMix;
			float _EnableRimLighting;
			float _RimWidthNoiseStrength;
			float4 _RimShadowAlpha;
			float _RimShadowWidth;
			float _RimBlendStrength;
			float _RimBlendMode;
			float _RimShadowToggle;
			float _RimPower;
			float _RimShadowMaskStrength;
			float _RimShadowMaskRampType;
			float _RimShadowMaskInvert;
			float _RimBrightness;
			#if defined(PROP_RIMTEX) || !defined(OPTIMIZER_ENABLED)
			Texture2D _RimTex;
			#endif
			float4 _RimTex_ST;
			float2 _RimTexPan;
			float _RimTexUV;
			#if defined(PROP_RIMMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _RimMask;
			#endif
			float4 _RimMask_ST;
			float2 _RimMaskPan;
			float _RimMaskUV;
			float _RimMaskChannel;
			float _RimMaskInvert;
			float _RimBiasIntensity;
			#ifdef POI_AUDIOLINK
			half _AudioLinkRimWidthBand;
			float2 _AudioLinkRimWidthAdd;
			half _AudioLinkRimEmissionBand;
			float2 _AudioLinkRimEmissionAdd;
			half _AudioLinkRimBrightnessBand;
			float2 _AudioLinkRimBrightnessAdd;
			#endif
			#endif
			float _RimGlobalMask;
			float _RimGlobalMaskBlendType;
			float _RimApplyGlobalMaskIndex;
			float _RimApplyGlobalMaskBlendType;
			float _RimHueShiftEnabled;
			float _RimHueShiftSpeed;
			float _RimHueShift;
			#endif
			#ifdef MOCHIE_PBR
			#if defined(PROP_MOCHIEMETALLICMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _MochieMetallicMaps;
			float _PBRMapsStochastic;
			#endif
			float4 _MochieMetallicMaps_ST; float2 _MochieMetallicMapsPan; float _MochieMetallicMapsUV; float _MochieMetallicMapsStochastic;
			float _MochieMetallicMapInvert;
			float _MochieRoughnessMapInvert;
			float _MochieReflectionMaskInvert;
			float _MochieSpecularMaskInvert;
			float _MochieMetallicMapsMetallicChannel;
			float _MochieMetallicMapsRoughnessChannel;
			float _MochieMetallicMapsReflectionMaskChannel;
			float _MochieMetallicMapsSpecularMaskChannel;
			float _PBRNormalSelect;
			float _MochieReflectionTintThemeIndex;
			float _MochieSpecularTintThemeIndex;
			float _MochieRoughnessMultiplier;
			float _MochieMetallicMultiplier;
			float _MochieReflectionStrength;
			float _MochieSpecularStrength;
			float4 _MochieSpecularTint;
			float4 _MochieReflectionTint;
			float _MochieLitFallback;
			float _IgnoreCastedShadows;
			float _PBRSplitMaskSample;
			float _PBRSplitMaskStochastic;
			float4 _PBRMaskScaleTiling;
			float _MochieMetallicMasksUV;
			float4 _MochieMetallicMasksPan;
			float _Specular2ndLayer;
			float _MochieSpecularStrength2;
			float _MochieRoughnessMultiplier2;
			float _RefSpecFresnel;
			samplerCUBE _MochieReflCube;
			float4 _MochieReflCube_HDR;
			float _MochieForceFallback;
			float _MochieGSAAEnabled;
			float _PoiGSAAVariance;
			float _PoiGSAAThreshold;
			float _BRDFTPSReflectionMaskStrength;
			float _BRDFTPSSpecularMaskStrength;
			float _BRDFTPSDepthEnabled;
			float _MochieMetallicGlobalMask;
			float _MochieMetallicGlobalMaskBlendType;
			float _MochieSmoothnessGlobalMask;
			float _MochieSmoothnessGlobalMaskBlendType;
			float _MochieReflectionStrengthGlobalMask;
			float _MochieReflectionStrengthGlobalMaskBlendType;
			float _MochieSpecularStrengthGlobalMask;
			float _MochieSpecularStrengthGlobalMaskBlendType;
			#endif
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 color : COLOR;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				uint vertexId : SV_VertexID;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOut
			{
				float4 pos : SV_POSITION;
				float2 uv[4] : TEXCOORD0;
				float3 objNormal : TEXCOORD4;
				float3 normal : TEXCOORD5;
				float3 tangent : TEXCOORD6;
				float3 binormal : TEXCOORD7;
				float4 worldPos : TEXCOORD8;
				float4 localPos : TEXCOORD9;
				float3 objectPos : TEXCOORD10;
				float4 vertexColor : TEXCOORD11;
				float4 lightmapUV : TEXCOORD12;
				float4 grabPos: TEXCOORD13;
				float4 worldDirection: TEXCOORD14;
				float4 extra: TEXCOORD15;
				UNITY_SHADOW_COORDS(16)
				UNITY_FOG_COORDS(17)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			struct PoiMesh
			{
				float3 normals[2];
				float3 objNormal;
				float3 tangentSpaceNormal;
				float3 binormal[2];
				float3 tangent[2];
				float3 worldPos;
				float3 localPos;
				float3 objectPosition;
				float isFrontFace;
				float4 vertexColor;
				float4 lightmapUV;
				float2 uv[9];
				float2 parallaxUV;
			};
			struct PoiCam
			{
				float3 viewDir;
				float3 forwardDir;
				float3 worldPos;
				float distanceToVert;
				float4 clipPos;
				float3 reflectionDir;
				float3 vertexReflectionDir;
				float3 tangentViewDir;
				float4 grabPos;
				float2 screenUV;
				float vDotN;
				float4 worldDirection;
			};
			struct PoiMods
			{
				float4 PBR; // smoothness, metallic, smoothness mask, metallic mask
				float4 Mask;
				float4 audioLink;
				float audioLinkAvailable;
				float audioLinkVersion;
				float4 audioLinkTexture;
				float audioLinkViaLuma;
				float2 detailMask;
				float2 backFaceDetailIntensity;
				float globalEmission;
				float4 globalColorTheme[12];
				float globalMask[16];
				float ALTime[8];
			};
			struct PoiLight
			{
				float3 direction;
				float attenuation;
				float attenuationStrength;
				float3 directColor;
				float3 indirectColor;
				float occlusion;
				float shadowMask;
				float detailShadow;
				float3 halfDir;
				float lightMap;
				float lightMapNoAttenuation;
				float3 rampedLightMap;
				float vertexNDotL;
				float nDotL;
				float nDotV;
				float vertexNDotV;
				float nDotH;
				float vertexNDotH;
				float lDotv;
				float lDotH;
				float nDotLSaturated;
				float nDotLNormalized;
				#ifdef POI_PASS_ADD
				float additiveShadow;
				#endif
				float3 finalLighting;
				float3 finalLightAdd;
				#if defined(VERTEXLIGHT_ON)
				float4 vDotNL;
				float4 vertexVDotNL;
				float3 vColor[4];
				float4 vCorrectedDotNL;
				float4 vAttenuation;
				float4 vAttenuationDotNL;
				float3 vPosition[4];
				float3 vDirection[4];
				float3 vFinalLighting;
				float3 vHalfDir[4];
				half4 vDotNH;
				half4 vertexVDotNH;
				half4 vDotLH;
				#endif
			};
			struct PoiVertexLights
			{
				float3 direction;
				float3 color;
				float attenuation;
			};
			struct PoiFragData
			{
				float3 baseColor;
				float3 finalColor;
				float alpha;
				float3 emission;
			};
			#ifndef glsl_mod
			#define glsl_mod(x, y) (((x) - (y) * floor((x) / (y))))
			#endif
			uniform float random_uniform_float_only_used_to_stop_compiler_warnings = 0.0f;
			float2 poiUV(float2 uv, float4 tex_st)
			{
				return uv * tex_st.xy + tex_st.zw;
			}
			float2 vertexUV(in VertexOut o, int index)
			{
				switch(index)
				{
					case 0:
					return o.uv[0];
					case 1:
					return o.uv[1];
					case 2:
					return o.uv[2];
					case 3:
					return o.uv[3];
					default:
					return o.uv[0];
				}
			}
			float2 vertexUV(in appdata v, int index)
			{
				switch(index)
				{
					case 0:
					return v.uv0;
					case 1:
					return v.uv1;
					case 2:
					return v.uv2;
					case 3:
					return v.uv3;
					default:
					return v.uv0;
				}
			}
			float calculateluminance(float3 color)
			{
				return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
			}
			float _VRChatCameraMode;
			float _VRChatMirrorMode;
			float VRCCameraMode()
			{
				return _VRChatCameraMode;
			}
			float VRCMirrorMode()
			{
				return _VRChatMirrorMode;
			}
			bool IsInMirror()
			{
				return unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
			}
			bool IsOrthographicCamera()
			{
				return unity_OrthoParams.w == 1 || UNITY_MATRIX_P[3][3] == 1;
			}
			float shEvaluateDiffuseL1Geomerics_local(float L0, float3 L1, float3 n)
			{
				float R0 = max(0, L0);
				float3 R1 = 0.5f * L1;
				float lenR1 = length(R1);
				float q = dot(normalize(R1), n) * 0.5 + 0.5;
				q = saturate(q); // Thanks to ScruffyRuffles for the bug identity.
				float p = 1.0f + 2.0f * lenR1 / R0;
				float a = (1.0f - lenR1 / R0) / (1.0f + lenR1 / R0);
				return R0 * (a + (1.0f - a) * (p + 1.0f) * pow(q, p));
			}
			half3 BetterSH9(half4 normal)
			{
				float3 indirect;
				float3 L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) + float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
				indirect.r = shEvaluateDiffuseL1Geomerics_local(L0.r, unity_SHAr.xyz, normal.xyz);
				indirect.g = shEvaluateDiffuseL1Geomerics_local(L0.g, unity_SHAg.xyz, normal.xyz);
				indirect.b = shEvaluateDiffuseL1Geomerics_local(L0.b, unity_SHAb.xyz, normal.xyz);
				indirect = max(0, indirect);
				indirect += SHEvalLinearL2(normal);
				return indirect;
			}
			float3 getCameraForward()
			{
				#if UNITY_SINGLE_PASS_STEREO
				float3 p1 = mul(unity_StereoCameraToWorld[0], float4(0, 0, 1, 1));
				float3 p2 = mul(unity_StereoCameraToWorld[0], float4(0, 0, 0, 1));
				#else
				float3 p1 = mul(unity_CameraToWorld, float4(0, 0, 1, 1)).xyz;
				float3 p2 = mul(unity_CameraToWorld, float4(0, 0, 0, 1)).xyz;
				#endif
				return normalize(p2 - p1);
			}
			half3 GetSHLength()
			{
				half3 x, x1;
				x.r = length(unity_SHAr);
				x.g = length(unity_SHAg);
				x.b = length(unity_SHAb);
				x1.r = length(unity_SHBr);
				x1.g = length(unity_SHBg);
				x1.b = length(unity_SHBb);
				return x + x1;
			}
			float3 BoxProjection(float3 direction, float3 position, float4 cubemapPosition, float3 boxMin, float3 boxMax)
			{
				#if UNITY_SPECCUBE_BOX_PROJECTION
				if (cubemapPosition.w > 0)
				{
					float3 factors = ((direction > 0 ? boxMax : boxMin) - position) / direction;
					float scalar = min(min(factors.x, factors.y), factors.z);
					direction = direction * scalar + (position - cubemapPosition.xyz);
				}
				#endif
				return direction;
			}
			float poiMax(float2 i)
			{
				return max(i.x, i.y);
			}
			float poiMax(float3 i)
			{
				return max(max(i.x, i.y), i.z);
			}
			float poiMax(float4 i)
			{
				return max(max(max(i.x, i.y), i.z), i.w);
			}
			float3 calculateNormal(in float3 baseNormal, in PoiMesh poiMesh, in Texture2D normalTexture, in float4 normal_ST, in float2 normalPan, in float normalUV, in float normalIntensity)
			{
				float3 normal = UnpackScaleNormal(POI2D_SAMPLER_PAN(normalTexture, _MainTex, poiUV(poiMesh.uv[normalUV], normal_ST), normalPan), normalIntensity);
				return normalize(
				normal.x * poiMesh.tangent[0] +
				normal.y * poiMesh.binormal[0] +
				normal.z * baseNormal
				);
			}
			float remap(float x, float minOld, float maxOld, float minNew = 0, float maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float2 remap(float2 x, float2 minOld, float2 maxOld, float2 minNew = 0, float2 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float3 remap(float3 x, float3 minOld, float3 maxOld, float3 minNew = 0, float3 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float4 remap(float4 x, float4 minOld, float4 maxOld, float4 minNew = 0, float4 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float remapClamped(float minOld, float maxOld, float x, float minNew = 0, float maxNew = 1)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float2 remapClamped(float2 minOld, float2 maxOld, float2 x, float2 minNew, float2 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float3 remapClamped(float3 minOld, float3 maxOld, float3 x, float3 minNew, float3 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float4 remapClamped(float4 minOld, float4 maxOld, float4 x, float4 minNew, float4 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float2 calcParallax(in float height, in PoiCam poiCam)
			{
				return ((height * - 1) + 1) * (poiCam.tangentViewDir.xy / poiCam.tangentViewDir.z);
			}
			float4 poiBlend(const float sourceFactor, const  float4 sourceColor, const  float destinationFactor, const  float4 destinationColor, const float4 blendFactor)
			{
				float4 sA = 1 - blendFactor;
				const float4 blendData[11] = {
					float4(0.0, 0.0, 0.0, 0.0),
					float4(1.0, 1.0, 1.0, 1.0),
					destinationColor,
					sourceColor,
					float4(1.0, 1.0, 1.0, 1.0) - destinationColor,
					sA,
					float4(1.0, 1.0, 1.0, 1.0) - sourceColor,
					sA,
					float4(1.0, 1.0, 1.0, 1.0) - sA,
					saturate(sourceColor.aaaa),
					1 - sA,
				};
				return lerp(blendData[sourceFactor] * sourceColor + blendData[destinationFactor] * destinationColor, sourceColor, sA);
			}
			float blendAverage(float base, float blend)
			{
				return (base + blend) / 2.0;
			}
			float3 blendAverage(float3 base, float3 blend)
			{
				return (base + blend) / 2.0;
			}
			float blendColorBurn(float base, float blend)
			{
				return (blend == 0.0) ? blend : max((1.0 - ((1.0 - base) * rcp(random_uniform_float_only_used_to_stop_compiler_warnings + blend))), 0.0);
			}
			float3 blendColorBurn(float3 base, float3 blend)
			{
				return float3(blendColorBurn(base.r, blend.r), blendColorBurn(base.g, blend.g), blendColorBurn(base.b, blend.b));
			}
			float blendColorDodge(float base, float blend)
			{
				return (blend == 1.0) ? blend : min(base / (1.0 - blend), 1.0);
			}
			float3 blendColorDodge(float3 base, float3 blend)
			{
				return float3(blendColorDodge(base.r, blend.r), blendColorDodge(base.g, blend.g), blendColorDodge(base.b, blend.b));
			}
			float blendDarken(float base, float blend)
			{
				return min(blend, base);
			}
			float3 blendDarken(float3 base, float3 blend)
			{
				return float3(blendDarken(base.r, blend.r), blendDarken(base.g, blend.g), blendDarken(base.b, blend.b));
			}
			float blendExclusion(float base, float blend)
			{
				return base + blend - 2.0 * base * blend;
			}
			float3 blendExclusion(float3 base, float3 blend)
			{
				return base + blend - 2.0 * base * blend;
			}
			float blendReflect(float base, float blend)
			{
				return (blend == 1.0) ? blend : min(base * base / (1.0 - blend), 1.0);
			}
			float3 blendReflect(float3 base, float3 blend)
			{
				return float3(blendReflect(base.r, blend.r), blendReflect(base.g, blend.g), blendReflect(base.b, blend.b));
			}
			float blendGlow(float base, float blend)
			{
				return blendReflect(blend, base);
			}
			float3 blendGlow(float3 base, float3 blend)
			{
				return blendReflect(blend, base);
			}
			float blendOverlay(float base, float blend)
			{
				return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
			}
			float3 blendOverlay(float3 base, float3 blend)
			{
				return float3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
			}
			float blendHardLight(float base, float blend)
			{
				return blendOverlay(blend, base);
			}
			float3 blendHardLight(float3 base, float3 blend)
			{
				return blendOverlay(blend, base);
			}
			float blendVividLight(float base, float blend)
			{
				return (blend < 0.5) ? blendColorBurn(base, (2.0 * blend)) : blendColorDodge(base, (2.0 * (blend - 0.5)));
			}
			float3 blendVividLight(float3 base, float3 blend)
			{
				return float3(blendVividLight(base.r, blend.r), blendVividLight(base.g, blend.g), blendVividLight(base.b, blend.b));
			}
			float blendHardMix(float base, float blend)
			{
				return (blendVividLight(base, blend) < 0.5) ? 0.0 : 1.0;
			}
			float3 blendHardMix(float3 base, float3 blend)
			{
				return float3(blendHardMix(base.r, blend.r), blendHardMix(base.g, blend.g), blendHardMix(base.b, blend.b));
			}
			float blendLighten(float base, float blend)
			{
				return max(blend, base);
			}
			float3 blendLighten(float3 base, float3 blend)
			{
				return float3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
			}
			float blendLinearBurn(float base, float blend)
			{
				return max(base + blend - 1.0, 0.0);
			}
			float3 blendLinearBurn(float3 base, float3 blend)
			{
				return max(base + blend - float3(1.0, 1.0, 1.0), float3(0.0, 0.0, 0.0));
			}
			float blendLinearDodge(float base, float blend)
			{
				return min(base + blend, 1.0);
			}
			float3 blendLinearDodge(float3 base, float3 blend)
			{
				return min(base + blend, float3(1.0, 1.0, 1.0));
			}
			float blendLinearLight(float base, float blend)
			{
				return blend < 0.5 ? blendLinearBurn(base, (2.0 * blend)) : blendLinearDodge(base, (2.0 * (blend - 0.5)));
			}
			float3 blendLinearLight(float3 base, float3 blend)
			{
				return float3(blendLinearLight(base.r, blend.r), blendLinearLight(base.g, blend.g), blendLinearLight(base.b, blend.b));
			}
			float blendMultiply(float base, float blend)
			{
				return base * blend;
			}
			float3 blendMultiply(float3 base, float3 blend)
			{
				return base * blend;
			}
			float blendNegation(float base, float blend)
			{
				return 1.0 - abs(1.0 - base - blend);
			}
			float3 blendNegation(float3 base, float3 blend)
			{
				return float3(1.0, 1.0, 1.0) - abs(float3(1.0, 1.0, 1.0) - base - blend);
			}
			float blendNormal(float base, float blend)
			{
				return blend;
			}
			float3 blendNormal(float3 base, float3 blend)
			{
				return blend;
			}
			float blendPhoenix(float base, float blend)
			{
				return min(base, blend) - max(base, blend) + 1.0;
			}
			float3 blendPhoenix(float3 base, float3 blend)
			{
				return min(base, blend) - max(base, blend) + float3(1.0, 1.0, 1.0);
			}
			float blendPinLight(float base, float blend)
			{
				return (blend < 0.5) ? blendDarken(base, (2.0 * blend)) : blendLighten(base, (2.0 * (blend - 0.5)));
			}
			float3 blendPinLight(float3 base, float3 blend)
			{
				return float3(blendPinLight(base.r, blend.r), blendPinLight(base.g, blend.g), blendPinLight(base.b, blend.b));
			}
			float blendScreen(float base, float blend)
			{
				return 1.0 - ((1.0 - base) * (1.0 - blend));
			}
			float3 blendScreen(float3 base, float3 blend)
			{
				return float3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
			}
			float blendSoftLight(float base, float blend)
			{
				return (blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend));
			}
			float3 blendSoftLight(float3 base, float3 blend)
			{
				return float3(blendSoftLight(base.r, blend.r), blendSoftLight(base.g, blend.g), blendSoftLight(base.b, blend.b));
			}
			float blendSubtract(float base, float blend)
			{
				return max(base - blend, 0.0);
			}
			float3 blendSubtract(float3 base, float3 blend)
			{
				return max(base - blend, 0.0);
			}
			float blendDifference(float base, float blend)
			{
				return abs(base - blend);
			}
			float3 blendDifference(float3 base, float3 blend)
			{
				return abs(base - blend);
			}
			float blendDivide(float base, float blend)
			{
				return base / max(blend, 0.0001);
			}
			float3 blendDivide(float3 base, float3 blend)
			{
				return base / max(blend, 0.0001);
			}
			float blendMixed(float base, float blend)
			{
				return base + base * blend;
			}
			float3 blendMixed(float3 base, float3 blend)
			{
				return base + base * blend;
			}
			float3 customBlend(float3 base, float3 blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					case 6: return blendScreen(base, blend); break;
					case 8: return blendLinearDodge(base, blend); break;
					case 9: return blendOverlay(base, blend); break;
					case 20: return blendMixed(base, blend); break;
					default: return 0; break;
				}
			}
			float customBlend(float base, float blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					case 6: return blendScreen(base, blend); break;
					case 8: return blendLinearDodge(base, blend); break;
					case 9: return blendOverlay(base, blend); break;
					case 20: return blendMixed(base, blend); break;
					default: return 0; break;
				}
			}
			float3 customBlend(float3 base, float3 blend, float blendType, float alpha)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 8: output = lerp(base, blendLinearDodge(base, blend), alpha); break;
					case 9: output = lerp(base, blendOverlay(base, blend), alpha); break;
					case 20: output = lerp(base, blendMixed(base, blend), alpha); break;
					default: output = 0; break;
				}
				return output;
			}
			#define REPLACE 0
			#define SUBSTRACT 1
			#define MULTIPLY 2
			#define DIVIDE 3
			#define MIN 4
			#define MAX 5
			#define AVERAGE 6
			#define ADD 7
			float maskBlend(float baseMask, float blendMask, float blendType)
			{
				float output = 0;
				switch(blendType)
				{
					case REPLACE: output = blendMask; break;
					case SUBSTRACT: output = baseMask - blendMask; break;
					case MULTIPLY: output = baseMask * blendMask; break;
					case DIVIDE: output = baseMask / blendMask; break;
					case MIN: output = min(baseMask, blendMask); break;
					case MAX: output = max(baseMask, blendMask); break;
					case AVERAGE: output = (baseMask + blendMask) * 0.5; break;
					case ADD: output = baseMask + blendMask; break;
				}
				return saturate(output);
			}
			float random(float2 p)
			{
				return frac(sin(dot(p, float2(12.9898, 78.2383))) * 43758.5453123);
			}
			float2 random2(float2 p)
			{
				return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
			}
			float3 random3(float2 p)
			{
				return frac(sin(float3(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)), dot(p, float2(248.3, 315.9)))) * 43758.5453);
			}
			float3 random3(float3 p)
			{
				return frac(sin(float3(dot(p, float3(127.1, 311.7, 248.6)), dot(p, float3(269.5, 183.3, 423.3)), dot(p, float3(248.3, 315.9, 184.2)))) * 43758.5453);
			}
			float3 randomFloat3(float2 Seed, float maximum)
			{
				return (.5 + float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed), float2(12.9898, 78.233))) * 43758.5453)
				) * .5) * (maximum);
			}
			float3 randomFloat3Range(float2 Seed, float Range)
			{
				return (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1) * Range;
			}
			float3 randomFloat3WiggleRange(float2 Seed, float Range, float wiggleSpeed)
			{
				float3 rando = (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1);
				float speed = 1 + wiggleSpeed;
				return float3(sin((_Time.x + rando.x * PI) * speed), sin((_Time.x + rando.y * PI) * speed), sin((_Time.x + rando.z * PI) * speed)) * Range;
			}
			void poiDither(float4 In, float4 ScreenPosition, out float4 Out)
			{
				float2 uv = ScreenPosition.xy * _ScreenParams.xy;
				float DITHER_THRESHOLDS[16] = {
					1.0 / 17.0, 9.0 / 17.0, 3.0 / 17.0, 11.0 / 17.0,
					13.0 / 17.0, 5.0 / 17.0, 15.0 / 17.0, 7.0 / 17.0,
					4.0 / 17.0, 12.0 / 17.0, 2.0 / 17.0, 10.0 / 17.0,
					16.0 / 17.0, 8.0 / 17.0, 14.0 / 17.0, 6.0 / 17.0
				};
				uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
				Out = In - DITHER_THRESHOLDS[index];
			}
			static const float Epsilon = 1e-10;
			static const float3 HCYwts = float3(0.299, 0.587, 0.114);
			static const float HCLgamma = 3;
			static const float HCLy0 = 100;
			static const float HCLmaxL = 0.530454533953517; // == exp(HCLgamma / HCLy0) - 0.5
			static const float3 wref = float3(1.0, 1.0, 1.0);
			#define TAU 6.28318531
			float3 HUEtoRGB(in float H)
			{
				float R = abs(H * 6 - 3) - 1;
				float G = 2 - abs(H * 6 - 2);
				float B = 2 - abs(H * 6 - 4);
				return saturate(float3(R, G, B));
			}
			float3 RGBtoHCV(in float3 RGB)
			{
				float4 P = (RGB.g < RGB.b) ? float4(RGB.bg, -1.0, 2.0 / 3.0) : float4(RGB.gb, 0.0, -1.0 / 3.0);
				float4 Q = (RGB.r < P.x) ? float4(P.xyw, RGB.r) : float4(RGB.r, P.yzx);
				float C = Q.x - min(Q.w, Q.y);
				float H = abs((Q.w - Q.y) / (6 * C + Epsilon) + Q.z);
				return float3(H, C, Q.x);
			}
			float3 HSVtoRGB(in float3 HSV)
			{
				float3 RGB = HUEtoRGB(HSV.x);
				return ((RGB - 1) * HSV.y + 1) * HSV.z;
			}
			float3 RGBtoHSV(in float3 RGB)
			{
				float3 HCV = RGBtoHCV(RGB);
				float S = HCV.y / (HCV.z + Epsilon);
				return float3(HCV.x, S, HCV.z);
			}
			float3 HSLtoRGB(in float3 HSL)
			{
				float3 RGB = HUEtoRGB(HSL.x);
				float C = (1 - abs(2 * HSL.z - 1)) * HSL.y;
				return (RGB - 0.5) * C + HSL.z;
			}
			float3 RGBtoHSL(in float3 RGB)
			{
				float3 HCV = RGBtoHCV(RGB);
				float L = HCV.z - HCV.y * 0.5;
				float S = HCV.y / (1 - abs(L * 2 - 1) + Epsilon);
				return float3(HCV.x, S, L);
			}
			void DecomposeHDRColor(in float3 linearColorHDR, out float3 baseLinearColor, out float exposure)
			{
				float maxColorComponent = max(linearColorHDR.r, max(linearColorHDR.g, linearColorHDR.b));
				bool isSDR = maxColorComponent <= 1.0;
				float scaleFactor = isSDR ? 1.0 : (1.0 / maxColorComponent);
				exposure = isSDR ? 0.0 : log(maxColorComponent) * 1.44269504089; // ln(2)
				baseLinearColor = scaleFactor * linearColorHDR;
			}
			float3 ApplyHDRExposure(float3 linearColor, float exposure)
			{
				return linearColor * pow(2, exposure);
			}
			float3 ModifyViaHSV(float3 color, float h, float s, float v)
			{
				float3 colorHSV = RGBtoHSV(color);
				colorHSV.x = frac(colorHSV.x + h);
				colorHSV.y = saturate(colorHSV.y + s);
				colorHSV.z = saturate(colorHSV.z + v);
				return HSVtoRGB(colorHSV);
			}
			float3 ModifyViaHSV(float3 color, float3 HSVMod)
			{
				return ModifyViaHSV(color, HSVMod.x, HSVMod.y, HSVMod.z);
			}
			float3 hueShift(float3 color, float hueOffset)
			{
				color = RGBtoHSV(color);
				color.x = frac(hueOffset +color.x);
				return HSVtoRGB(color);
			}
			float xyzF(float t)
			{
				return lerp(pow(t, 1. / 3.), 7.787037 * t + 0.139731, step(t, 0.00885645));
			}
			float xyzR(float t)
			{
				return lerp(t * t * t, 0.1284185 * (t - 0.139731), step(t, 0.20689655));
			}
			float4x4 poiRotationMatrixFromAngles(float x, float y, float z)
			{
				float angleX = radians(x);
				float c = cos(angleX);
				float s = sin(angleX);
				float4x4 rotateXMatrix = float4x4(1, 0, 0, 0,
				0, c, -s, 0,
				0, s, c, 0,
				0, 0, 0, 1);
				float angleY = radians(y);
				c = cos(angleY);
				s = sin(angleY);
				float4x4 rotateYMatrix = float4x4(c, 0, s, 0,
				0, 1, 0, 0,
				- s, 0, c, 0,
				0, 0, 0, 1);
				float angleZ = radians(z);
				c = cos(angleZ);
				s = sin(angleZ);
				float4x4 rotateZMatrix = float4x4(c, -s, 0, 0,
				s, c, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1);
				return mul(mul(rotateXMatrix, rotateYMatrix), rotateZMatrix);
			}
			float4x4 poiRotationMatrixFromAngles(float3 angles)
			{
				float angleX = radians(angles.x);
				float c = cos(angleX);
				float s = sin(angleX);
				float4x4 rotateXMatrix = float4x4(1, 0, 0, 0,
				0, c, -s, 0,
				0, s, c, 0,
				0, 0, 0, 1);
				float angleY = radians(angles.y);
				c = cos(angleY);
				s = sin(angleY);
				float4x4 rotateYMatrix = float4x4(c, 0, s, 0,
				0, 1, 0, 0,
				- s, 0, c, 0,
				0, 0, 0, 1);
				float angleZ = radians(angles.z);
				c = cos(angleZ);
				s = sin(angleZ);
				float4x4 rotateZMatrix = float4x4(c, -s, 0, 0,
				s, c, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1);
				return mul(mul(rotateXMatrix, rotateYMatrix), rotateZMatrix);
			}
			float3 getCameraPosition()
			{
				#ifdef USING_STEREO_MATRICES
				return lerp(unity_StereoWorldSpaceCameraPos[0], unity_StereoWorldSpaceCameraPos[1], 0.5);
				#endif
				return _WorldSpaceCameraPos;
			}
			half2 calcScreenUVs(half4 grabPos)
			{
				half2 uv = grabPos.xy / (grabPos.w + 0.0000000001);
				#if UNITY_SINGLE_PASS_STEREO
				uv.xy *= half2(_ScreenParams.x * 2, _ScreenParams.y);
				#else
				uv.xy *= _ScreenParams.xy;
				#endif
				return uv;
			}
			float CalcMipLevel(float2 texture_coord)
			{
				float2 dx = ddx(texture_coord);
				float2 dy = ddy(texture_coord);
				float delta_max_sqr = max(dot(dx, dx), dot(dy, dy));
				return 0.5 * log2(delta_max_sqr);
			}
			float inverseLerp(float A, float B, float T)
			{
				return (T - A) / (B - A);
			}
			float inverseLerp2(float2 a, float2 b, float2 value)
			{
				float2 AB = b - a;
				float2 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float inverseLerp3(float3 a, float3 b, float3 value)
			{
				float3 AB = b - a;
				float3 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float inverseLerp4(float4 a, float4 b, float4 value)
			{
				float4 AB = b - a;
				float4 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float4 quaternion_conjugate(float4 v)
			{
				return float4(
				v.x, -v.yzw
				);
			}
			float4 quaternion_mul(float4 v1, float4 v2)
			{
				float4 result1 = (v1.x * v2 + v1 * v2.x);
				float4 result2 = float4(
				- dot(v1.yzw, v2.yzw),
				cross(v1.yzw, v2.yzw)
				);
				return float4(result1 + result2);
			}
			float4 get_quaternion_from_angle(float3 axis, float angle)
			{
				float sn = sin(angle * 0.5);
				float cs = cos(angle * 0.5);
				return float4(axis * sn, cs);
			}
			float4 quaternion_from_vector(float3 inVec)
			{
				return float4(0.0, inVec);
			}
			float degree_to_radius(float degree)
			{
				return (
				degree / 180.0 * PI
				);
			}
			float3 rotate_with_quaternion(float3 inVec, float3 rotation)
			{
				float4 qx = get_quaternion_from_angle(float3(1, 0, 0), radians(rotation.x));
				float4 qy = get_quaternion_from_angle(float3(0, 1, 0), radians(rotation.y));
				float4 qz = get_quaternion_from_angle(float3(0, 0, 1), radians(rotation.z));
				#define MUL3(A, B, C) quaternion_mul(quaternion_mul((A), (B)), (C))
				float4 quaternion = normalize(MUL3(qx, qy, qz));
				float4 conjugate = quaternion_conjugate(quaternion);
				float4 inVecQ = quaternion_from_vector(inVec);
				float3 rotated = (
				MUL3(quaternion, inVecQ, conjugate)
				).yzw;
				return rotated;
			}
			float4 transform(float4 input, float4 pos, float4 rotation, float4 scale)
			{
				input.rgb *= (scale.xyz * scale.w);
				input = float4(rotate_with_quaternion(input.xyz, rotation.xyz * rotation.w) + (pos.xyz * pos.w), input.w);
				return input;
			}
			float2 RotateUV(float2 _uv, float _radian, float2 _piv, float _time)
			{
				float RotateUV_ang = _radian;
				float RotateUV_cos = cos(_time * RotateUV_ang);
				float RotateUV_sin = sin(_time * RotateUV_ang);
				return (mul(_uv - _piv, float2x2(RotateUV_cos, -RotateUV_sin, RotateUV_sin, RotateUV_cos)) + _piv);
			}
			float3 poiThemeColor(in PoiMods poiMods, in float3 srcColor, in float themeIndex)
			{
				if (themeIndex == 0) return srcColor;
				themeIndex -= 1;
				if (themeIndex <= 3)
				{
					return poiMods.globalColorTheme[themeIndex];
				}
				#ifdef POI_AUDIOLINK
				if (poiMods.audioLinkAvailable)
				{
					return poiMods.globalColorTheme[themeIndex];
				}
				#endif
				return srcColor;
			}
			float3 lilToneCorrection(float3 c, float4 hsvg)
			{
				c = pow(abs(c), hsvg.w);
				float4 p = (c.b > c.g) ? float4(c.bg, -1.0, 2.0 / 3.0) : float4(c.gb, 0.0, -1.0 / 3.0);
				float4 q = (p.x > c.r) ? float4(p.xyw, c.r) : float4(c.r, p.yzx);
				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				float3 hsv = float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
				hsv = float3(hsv.x + hsvg.x, saturate(hsv.y * hsvg.y), saturate(hsv.z * hsvg.z));
				return hsv.z - hsv.z * hsv.y + hsv.z * hsv.y * saturate(abs(frac(hsv.x + float3(1.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0) - 1.0);
			}
			float lilIsIn0to1(float f)
			{
				float value = 0.5 - abs(f - 0.5);
				return saturate(value / clamp(fwidth(value), 0.0001, 1.0));
			}
			float lilIsIn0to1(float f, float nv)
			{
				float value = 0.5 - abs(f - 0.5);
				return saturate(value / clamp(fwidth(value), 0.0001, nv));
			}
			float poiEdgeLinearNoSaturate(float value, float border)
			{
				return (value - border) / clamp(fwidth(value), 0.0001, 1.0);
			}
			float3 poiEdgeLinearNoSaturate(float value, float3 border)
			{
				return float3(
				(value - border.x) / clamp(fwidth(value), 0.0001, 1.0),
				(value - border.y) / clamp(fwidth(value), 0.0001, 1.0),
				(value - border.z) / clamp(fwidth(value), 0.0001, 1.0)
				);
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur)
			{
				float borderMin = saturate(border - blur * 0.5);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / saturate(borderMax - borderMin + fwidth(value));
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / saturate(borderMax - borderMin + fwidth(value));
			}
			float poiEdgeNonLinearNoSaturate(float value, float border)
			{
				float fwidthValue = fwidth(value);
				return smoothstep(border - fwidthValue, border + fwidthValue, value);
			}
			float poiEdgeNonLinearNoSaturate(float value, float border, float blur)
			{
				float fwidthValue = fwidth(value);
				float borderMin = saturate(border - blur * 0.5);
				float borderMax = saturate(border + blur * 0.5);
				return smoothstep(borderMin - fwidthValue, borderMax + fwidthValue, value);
			}
			float poiEdgeNonLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float fwidthValue = fwidth(value);
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return smoothstep(borderMin - fwidthValue, borderMax + fwidthValue, value);
			}
			float poiEdgeNonLinear(float value, float border)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border));
			}
			float poiEdgeNonLinear(float value, float border, float blur)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border, blur));
			}
			float poiEdgeNonLinear(float value, float border, float blur, float borderRange)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border, blur, borderRange));
			}
			float poiEdgeLinear(float value, float border)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border));
			}
			float poiEdgeLinear(float value, float border, float blur)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border, blur));
			}
			float poiEdgeLinear(float value, float border, float blur, float borderRange)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border, blur, borderRange));
			}
			float3 OpenLitLinearToSRGB(float3 col)
			{
				return LinearToGammaSpace(col);
			}
			float3 OpenLitSRGBToLinear(float3 col)
			{
				return GammaToLinearSpace(col);
			}
			float OpenLitLuminance(float3 rgb)
			{
				#if defined(UNITY_COLORSPACE_GAMMA)
				return dot(rgb, float3(0.22, 0.707, 0.071));
				#else
				return dot(rgb, float3(0.0396819152, 0.458021790, 0.00609653955));
				#endif
			}
			float OpenLitGray(float3 rgb)
			{
				return dot(rgb, float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
			}
			void OpenLitShadeSH9ToonDouble(float3 lightDirection, out float3 shMax, out float3 shMin)
			{
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 N = lightDirection * 0.666666;
				float4 vB = N.xyzz * N.yzzx;
				float3 res = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
				res.r += dot(unity_SHBr, vB);
				res.g += dot(unity_SHBg, vB);
				res.b += dot(unity_SHBb, vB);
				res += unity_SHC.rgb * (N.x * N.x - N.y * N.y);
				float3 l1;
				l1.r = dot(unity_SHAr.rgb, N);
				l1.g = dot(unity_SHAg.rgb, N);
				l1.b = dot(unity_SHAb.rgb, N);
				shMax = res + l1;
				shMin = res - l1;
				#if defined(UNITY_COLORSPACE_GAMMA)
				shMax = OpenLitLinearToSRGB(shMax);
				shMin = OpenLitLinearToSRGB(shMin);
				#endif
				#else
				shMax = 0.0;
				shMin = 0.0;
				#endif
			}
			float3 OpenLitComputeCustomLightDirection(float4 lightDirectionOverride)
			{
				float3 customDir = length(lightDirectionOverride.xyz) * normalize(mul((float3x3)unity_ObjectToWorld, lightDirectionOverride.xyz));
				return lightDirectionOverride.w ? customDir : lightDirectionOverride.xyz; // .w isn't doc'd anywhere and is always 0 unless end user changes it
			}
			float3 OpenLitLightingDirectionForSH9()
			{
				float3 mainDir = _WorldSpaceLightPos0.xyz * OpenLitLuminance(_LightColor0.rgb);
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 sh9Dir = unity_SHAr.xyz * 0.333333 + unity_SHAg.xyz * 0.333333 + unity_SHAb.xyz * 0.333333;
				float3 sh9DirAbs = float3(sh9Dir.x, abs(sh9Dir.y), sh9Dir.z);
				#else
				float3 sh9Dir = 0;
				float3 sh9DirAbs = 0;
				#endif
				float3 lightDirectionForSH9 = sh9Dir + mainDir;
				lightDirectionForSH9 = dot(lightDirectionForSH9, lightDirectionForSH9) < 0.000001 ? 0 : normalize(lightDirectionForSH9);
				return lightDirectionForSH9;
			}
			float3 OpenLitLightingDirection(float4 lightDirectionOverride)
			{
				float3 mainDir = _WorldSpaceLightPos0.xyz * OpenLitLuminance(_LightColor0.rgb);
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 sh9Dir = unity_SHAr.xyz * 0.333333 + unity_SHAg.xyz * 0.333333 + unity_SHAb.xyz * 0.333333;
				float3 sh9DirAbs = float3(sh9Dir.x, abs(sh9Dir.y), sh9Dir.z);
				#else
				float3 sh9Dir = 0;
				float3 sh9DirAbs = 0;
				#endif
				float3 customDir = OpenLitComputeCustomLightDirection(lightDirectionOverride);
				return normalize(sh9DirAbs + mainDir + customDir);
			}
			float3 OpenLitLightingDirection()
			{
				float4 customDir = float4(0.001, 0.002, 0.001, 0.0);
				return OpenLitLightingDirection(customDir);
			}
			inline float4 CalculateFrustumCorrection()
			{
				float x1 = -UNITY_MATRIX_P._31 / (UNITY_MATRIX_P._11 * UNITY_MATRIX_P._34);
				float x2 = -UNITY_MATRIX_P._32 / (UNITY_MATRIX_P._22 * UNITY_MATRIX_P._34);
				return float4(x1, x2, 0, UNITY_MATRIX_P._33 / UNITY_MATRIX_P._34 + x1 * UNITY_MATRIX_P._13 + x2 * UNITY_MATRIX_P._23);
			}
			inline float CorrectedLinearEyeDepth(float z, float B)
			{
				return 1.0 / (z / UNITY_MATRIX_P._34 + B);
			}
			float2 sharpSample(float4 texelSize, float2 p)
			{
				p = p * texelSize.zw;
				float2 c = max(0.0, fwidth(p));
				p = floor(p) + saturate(frac(p) / c);
				p = (p - 0.5) * texelSize.xy;
				return p;
			}
			void applyToGlobalMask(inout PoiMods poiMods, int index, int blendType, float val)
			{
				float valBlended = saturate(maskBlend(poiMods.globalMask[index], val, blendType));
				switch(index)
				{
					case 0: poiMods.globalMask[0] = valBlended; break;
					case 1: poiMods.globalMask[1] = valBlended; break;
					case 2: poiMods.globalMask[2] = valBlended; break;
					case 3: poiMods.globalMask[3] = valBlended; break;
					case 4: poiMods.globalMask[4] = valBlended; break;
					case 5: poiMods.globalMask[5] = valBlended; break;
					case 6: poiMods.globalMask[6] = valBlended; break;
					case 7: poiMods.globalMask[7] = valBlended; break;
					case 8: poiMods.globalMask[8] = valBlended; break;
					case 9: poiMods.globalMask[9] = valBlended; break;
					case 10: poiMods.globalMask[10] = valBlended; break;
					case 11: poiMods.globalMask[11] = valBlended; break;
					case 12: poiMods.globalMask[12] = valBlended; break;
					case 13: poiMods.globalMask[13] = valBlended; break;
					case 14: poiMods.globalMask[14] = valBlended; break;
					case 15: poiMods.globalMask[15] = valBlended; break;
				}
			}
			void assignValueToVectorFromIndex(inout float4 vec, int index, float value)
			{
				switch(index)
				{
					case 0: vec[0] = value; break;
					case 1: vec[1] = value; break;
					case 2: vec[2] = value; break;
					case 3: vec[3] = value; break;
				}
			}
			float3 mod289(float3 x)
			{
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			float2 mod289(float2 x)
			{
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			float3 permute(float3 x)
			{
				return mod289(((x * 34.0) + 1.0) * x);
			}
			float snoise(float2 v)
			{
				const float4 C = float4(0.211324865405187, // (3.0-sqrt(3.0))/6.0
				0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
				- 0.577350269189626, // -1.0 + 2.0 * C.x
				0.024390243902439); // 1.0 / 41.0
				float2 i = floor(v + dot(v, C.yy));
				float2 x0 = v - i + dot(i, C.xx);
				float2 i1;
				i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod289(i); // Avoid truncation effects in permutation
				float3 p = permute(permute(i.y + float3(0.0, i1.y, 1.0))
				+ i.x + float3(0.0, i1.x, 1.0));
				float3 m = max(0.5 - float3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
				m = m * m ;
				m = m * m ;
				float3 x = 2.0 * frac(p * C.www) - 1.0;
				float3 h = abs(x) - 0.5;
				float3 ox = floor(x + 0.5);
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot(m, g);
			}
			VertexOut vert(
			#ifndef POI_TESSELLATED
			appdata v
			#else
			tessAppData v
			#endif
			)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				VertexOut o;
				PoiInitStruct(VertexOut, o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				#ifdef POI_TESSELLATED
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(v);
				#endif
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.objectPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				o.objNormal = v.normal;
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.tangent = UnityObjectToWorldDir(v.tangent);
				o.binormal = cross(o.normal, o.tangent) * (v.tangent.w * unity_WorldTransformParams.w);
				o.vertexColor = v.color;
				o.uv[0] = v.uv0;
				o.uv[1] = v.uv1;
				o.uv[2] = v.uv2;
				o.uv[3] = v.uv3;
				#if defined(LIGHTMAP_ON)
				o.lightmapUV.xy = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				#ifdef DYNAMICLIGHTMAP_ON
				o.lightmapUV.zw = v.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				o.localPos = v.vertex;
				o.worldPos = mul(unity_ObjectToWorld, o.localPos);
				float3 localOffset = float3(0, 0, 0);
				float3 worldOffset = float3(0, 0, 0);
				o.localPos.rgb += localOffset;
				o.worldPos.rgb += worldOffset;
				o.pos = UnityObjectToClipPos(o.localPos);
				#ifdef POI_PASS_OUTLINE
				#if defined(UNITY_REVERSED_Z)
				o.pos.z += _Offset_Z * - 0.01;
				#else
				o.pos.z += _Offset_Z * 0.01;
				#endif
				#endif
				o.grabPos = ComputeGrabScreenPos(o.pos);
				#ifndef FORWARD_META_PASS
				#if !defined(UNITY_PASS_SHADOWCASTER)
				UNITY_TRANSFER_SHADOW(o, o.uv[0].xy);
				#else
				v.vertex.xyz = o.localPos.xyz;
				TRANSFER_SHADOW_CASTER_NOPOS(o, o.pos);
				#endif
				#endif
				UNITY_TRANSFER_FOG(o, o.pos);
				if (0.0)
				{
					if (o.pos.w < _ProjectionParams.y * 1.01 && o.pos.w > 0)
					{
						o.pos.z = o.pos.z * 0.0001 + o.pos.w * 0.999;
					}
				}
				#ifdef POI_PASS_META
				o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
				#endif
				#if defined(GRAIN)
				float4 worldDirection;
				worldDirection.xyz = o.worldPos.xyz - _WorldSpaceCameraPos;
				worldDirection.w = dot(o.pos, CalculateFrustumCorrection());
				o.worldDirection = worldDirection;
				#endif
				return o;
			}
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, uv) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan)) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if defined(_STOCHASTICMODE_HEXTILE)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, uv, false) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), false) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), false, dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#ifndef POI2D_SAMPLER_STOCHASTIC
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (POI2D_SAMPLER(tex, texSampler, uv))
			#endif
			#ifndef POI2D_SAMPLER_PAN_STOCHASTIC
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#endif
			#ifndef POI2D_SAMPLER_PANGRAD_STOCHASTIC
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if !defined(_STOCHASTICMODE_NONE)
			float2 StochasticHash2D2D (float2 s)
			{
				return frac(sin(glsl_mod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159)) * 43758.5453);
			}
			#endif
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			float3x3 DeliotHeitzStochasticUVBW(float2 uv)
			{
				const float2x2 stochasticSkewedGrid = float2x2(1.0, -0.57735027, 0.0, 1.15470054);
				float2 skewUV = mul(stochasticSkewedGrid, uv * 3.4641 * 1.0);
				float2 vxID = floor(skewUV);
				float3 bary = float3(frac(skewUV), 0);
				bary.z = 1.0 - bary.x - bary.y;
				float3x3 pos = float3x3(
				float3(vxID, 				bary.z),
				float3(vxID + float2(0, 1), bary.y),
				float3(vxID + float2(1, 0), bary.x)
				);
				float3x3 neg = float3x3(
				float3(vxID + float2(1, 1), 	 -bary.z),
				float3(vxID + float2(1, 0), 1.0 - bary.y),
				float3(vxID + float2(0, 1), 1.0 - bary.x)
				);
				return (bary.z > 0) ? pos : neg;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, float2 dx, float2 dy)
			{
				float3x3 UVBW = DeliotHeitzStochasticUVBW(uv);
				return 	mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[0].xy), dx, dy), UVBW[0].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[1].xy), dx, dy), UVBW[1].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[2].xy), dx, dy), UVBW[2].z) ;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv)
			{
				float2 dx = ddx(uv), dy = ddy(uv);
				return DeliotHeitzSampleTexture(tex, texSampler, uv, dx, dy);
			}
			#endif // defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#if defined(_STOCHASTICMODE_HEXTILE)
			float2 HextileMakeCenUV(float2 vertex)
			{
				const float2x2 stochasticInverseSkewedGrid = float2x2(1.0, 0.5, 0.0, 1.0/1.15470054);
				return mul(stochasticInverseSkewedGrid, vertex) * 0.288675;
			}
			float2x2 HextileLoadRot2x2(float2 idx, float rotStrength)
			{
				float angle = abs(idx.x * idx.y) + abs(idx.x + idx.y) + PI;
				angle = glsl_mod(angle, 2 * PI);
				if(angle < 0)  angle += 2 * PI;
				if(angle > PI) angle -= 2 * PI;
				angle *= rotStrength;
				float cs = cos(angle), si = sin(angle);
				return float2x2(cs, -si, si, cs);
			}
			float4x4 HextileUVBWR(float2 uv)
			{
				const float2x2 stochasticSkewedGrid = float2x2(1.0, -0.57735027, 0.0, 1.15470054);
				float2 skewedCoord = mul(stochasticSkewedGrid, uv * 3.4641 * 1.0);
				float2 baseId = float2(floor(skewedCoord));
				float3 temp = float3(frac(skewedCoord), 0);
				temp.z = 1 - temp.x - temp.y;
				float s = step(0.0, -temp.z);
				float s2 = 2 * s - 1;
				float3 weights = float3(-temp.z * s2, s - temp.y * s2, s - temp.x * s2);
				float2 vertex0 = baseId + float2(s, s);
				float2 vertex1 = baseId + float2(s, 1 - s);
				float2 vertex2 = baseId + float2(1 - s, s);
				float2 cen0 = HextileMakeCenUV(vertex0), cen1 = HextileMakeCenUV(vertex1), cen2 = HextileMakeCenUV(vertex2);
				float2x2 rot0 = float2x2(1, 0, 0, 1), rot1 = float2x2(1, 0, 0, 1), rot2 = float2x2(1, 0, 0, 1);
				if(0.0 > 0)
				{
					rot0 = HextileLoadRot2x2(vertex0, 0.0);
					rot1 = HextileLoadRot2x2(vertex1, 0.0);
					rot2 = HextileLoadRot2x2(vertex2, 0.0);
				}
				return float4x4(
				float4(mul(uv - cen0, rot0) + cen0 + StochasticHash2D2D(vertex0), rot0[0].x, -rot0[0].y),
				float4(mul(uv - cen1, rot1) + cen1 + StochasticHash2D2D(vertex1), rot1[0].x, -rot1[0].y),
				float4(mul(uv - cen2, rot2) + cen2 + StochasticHash2D2D(vertex2), rot2[0].x, -rot2[0].y),
				float4(weights, 0)
				);
			}
			float4 HextileSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, bool isNormalMap, float2 dUVdx, float2 dUVdy)
			{
				float4x4 UVBWR = HextileUVBWR(uv);
				float2x2 rot0 = float2x2(1, 0, 0, 1), rot1 = float2x2(1, 0, 0, 1), rot2 = float2x2(1, 0, 0, 1);
				if(0.0 > 0)
				{
					rot0 = float2x2(UVBWR[0].z, -UVBWR[0].w, UVBWR[0].w, UVBWR[0].z);
					rot1 = float2x2(UVBWR[1].z, -UVBWR[1].w, UVBWR[1].w, UVBWR[1].z);
					rot2 = float2x2(UVBWR[2].z, -UVBWR[2].w, UVBWR[2].w, UVBWR[2].z);
				}
				float3 W = UVBWR[3].xyz;
				float4 c0 = tex.SampleGrad(texSampler, UVBWR[0].xy, mul(dUVdx, rot0), mul(dUVdy, rot0));
				float4 c1 = tex.SampleGrad(texSampler, UVBWR[1].xy, mul(dUVdx, rot1), mul(dUVdy, rot1));
				float4 c2 = tex.SampleGrad(texSampler, UVBWR[2].xy, mul(dUVdx, rot2), mul(dUVdy, rot2));
				const float3 Lw = float3(0.299, 0.587, 0.114);
				float3 Dw = float3(dot(c0.xyz, Lw), dot(c1.xyz, Lw), dot(c2.xyz, Lw));
				Dw = lerp(1.0, Dw, 0.6);
				W = Dw * pow(W, 7.0);
				W /= (W.x + W.y + W.z);
				return W.x * c0 + W.y * c1 + W.z * c2;
			}
			float4 HextileSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, bool isNormalMap)
			{
				return HextileSampleTexture(tex, texSampler, uv, isNormalMap, ddx(uv), ddy(uv));
			}
			#endif // defined(_STOCHASTICMODE_HEXTILE)
			void applyAlphaOptions(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiMods poiMods)
			{
				poiFragData.alpha = saturate(poiFragData.alpha + 0.0);
				if (0.0 > 0)
				{
					poiFragData.alpha = maskBlend(poiFragData.alpha, poiMods.globalMask[0.0-1], 2.0);
				}
			}
			void calculateGlobalThemes(inout PoiMods poiMods)
			{
				float4 themeColorExposures = 0;
				float4 themeColor0, themeColor1, themeColor2, themeColor3 = 0;
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor0.rgb, themeColorExposures.x);
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor1.rgb, themeColorExposures.y);
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor2.rgb, themeColorExposures.z);
				DecomposeHDRColor(float4(1,1,1,1).rgb, themeColor3.rgb, themeColorExposures.w);
				poiMods.globalColorTheme[0] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor0.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.x), float4(1,1,1,1).a);
				poiMods.globalColorTheme[1] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor1.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.y), float4(1,1,1,1).a);
				poiMods.globalColorTheme[2] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor2.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.z), float4(1,1,1,1).a);
				poiMods.globalColorTheme[3] = float4(ApplyHDRExposure(ModifyViaHSV(themeColor3.rgb, frac(0.0 + 0.0 * _Time.x), 0.0, 0.0), themeColorExposures.w), float4(1,1,1,1).a);
			}
			float customDistanceBlend(float base, float blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					default: return 0; break;
				}
			}
			void ApplyGlobalMaskModifiers(in PoiMesh poiMesh, inout PoiMods poiMods, in PoiCam poiCam)
			{
			}
			float2 calculatePolarCoordinate(in PoiMesh poiMesh)
			{
				float2 delta = poiMesh.uv[0.0] - float4(0.5,0.5,0,0);
				float radius = length(delta) * 2 * 1.0;
				float angle = atan2(delta.x, delta.y);
				float phi = angle / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				angle = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				angle *= 1.0;
				return float2(radius, angle + distance(poiMesh.uv[0.0], float4(0.5,0.5,0,0)) * 0.0);
			}
			float2 MonoPanoProjection(float3 coords)
			{
				float3 normalizedCoords = normalize(coords);
				float latitude = acos(normalizedCoords.y);
				float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
				float phi = longitude / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				longitude = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				longitude *= 2;
				float2 sphereCoords = float2(longitude, latitude) * float2(1.0, 1.0 / UNITY_PI);
				sphereCoords = float2(1.0, 1.0) - sphereCoords;
				return (sphereCoords + float4(0, 1 - unity_StereoEyeIndex, 1, 1.0).xy) * float4(0, 1 - unity_StereoEyeIndex, 1, 1.0).zw;
			}
			float2 StereoPanoProjection(float3 coords)
			{
				float3 normalizedCoords = normalize(coords);
				float latitude = acos(normalizedCoords.y);
				float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
				float phi = longitude / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				longitude = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				longitude *= 2;
				float2 sphereCoords = float2(longitude, latitude) * float2(0.5, 1.0 / UNITY_PI);
				sphereCoords = float2(0.5, 1.0) - sphereCoords;
				return (sphereCoords + float4(0, 1 - unity_StereoEyeIndex, 1, 0.5).xy) * float4(0, 1 - unity_StereoEyeIndex, 1, 0.5).zw;
			}
			float2 calculateWorldUV(in PoiMesh poiMesh)
			{
				return float2(0.0 != 3 ? poiMesh.worldPos[ 0.0] : 0.0f, 2.0 != 3 ? poiMesh.worldPos[2.0] : 0.0f);
			}
			float2 calculatelocalUV(in PoiMesh poiMesh)
			{
				float localUVs[8];
				localUVs[0] = poiMesh.localPos.x;
				localUVs[1] = poiMesh.localPos.y;
				localUVs[2] = poiMesh.localPos.z;
				localUVs[3] = 0;
				localUVs[4] = poiMesh.vertexColor.r;
				localUVs[5] = poiMesh.vertexColor.g;
				localUVs[6] = poiMesh.vertexColor.b;
				localUVs[7] = poiMesh.vertexColor.a;
				return float2(localUVs[0.0],localUVs[1.0]);
			}
			float2 calculatePanosphereUV(in PoiMesh poiMesh)
			{
				float3 viewDirection = normalize(lerp(getCameraPosition().xyz, _WorldSpaceCameraPos.xyz, 1.0) - poiMesh.worldPos.xyz) * - 1;
				return lerp(MonoPanoProjection(viewDirection), StereoPanoProjection(viewDirection), 0.0);
			}
			#if defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL) || defined(GEOM_TYPE_FROND) || defined(DEPTH_OF_FIELD_COC_VIEW)
			float2 decalUV(float uvNumber, float2 position, half rotation, half rotationSpeed, half2 scale, float4 scaleOffset, float depth, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				scaleOffset = float4(-scaleOffset.x, scaleOffset.y, -scaleOffset.z, scaleOffset.w);
				float2 centerOffset = float2((scaleOffset.x + scaleOffset.y)/2, (scaleOffset.z + scaleOffset.w)/2);
				float2 uv = poiMesh.uv[uvNumber] + calcParallax(depth + 1, poiCam);
				float2 decalCenter = position + centerOffset;
				float theta = radians(rotation + _Time.z * rotationSpeed);
				float cs = cos(theta);
				float sn = sin(theta);
				uv = float2((uv.x - decalCenter.x) * cs - (uv.y - decalCenter.y) * sn + decalCenter.x, (uv.x - decalCenter.x) * sn + (uv.y - decalCenter.y) * cs + decalCenter.y);
				uv = remap(uv, float2(0, 0) - scale / 2 + position + scaleOffset.xz, scale / 2 + position + scaleOffset.yw, float2(0, 0), float2(1, 1));
				return uv;
			}
			inline float3 decalHueShift(float enabled, float3 color, float shift, float shiftSpeed)
			{
				if (enabled)
				{
					color = hueShift(color, shift + _Time.x * shiftSpeed);
				}
				return color;
			}
			inline float applyTilingClipping(float enabled, float2 uv)
			{
				float ret = 1;
				if (!enabled)
				{
					if (uv.x > 1 || uv.y > 1 || uv.x < 0 || uv.y < 0)
					{
						ret = 0;
					}
				}
				return ret;
			}
			struct PoiDecal
			{
				float m_DecalMaskChannel;
				float m_DecalGlobalMask;
				float m_DecalGlobalMaskBlendType;
				float m_DecalApplyGlobalMaskIndex;
				float m_DecalApplyGlobalMaskBlendType;
				float4 m_DecalTexture_ST;
				float2 m_DecalTexturePan;
				float m_DecalTextureUV;
				float4 m_DecalColor;
				float m_DecalColorThemeIndex;
				fixed m_DecalTiled;
				float m_DecalBlendType;
				half m_DecalRotation;
				half2 m_DecalScale;
				float4 m_DecalSideOffset;
				half2 m_DecalPosition;
				half m_DecalRotationSpeed;
				float m_DecalEmissionStrength;
				float m_DecalBlendAlpha;
				float m_DecalOverrideAlpha;
				float m_DecalHueShiftEnabled;
				float m_DecalHueShift;
				float m_DecalHueShiftSpeed;
				float m_DecalDepth;
				float m_DecalHueAngleStrength;
				float m_DecalChannelSeparationEnable;
				float m_DecalChannelSeparation;
				float m_DecalChannelSeparationPremultiply;
				float m_DecalChannelSeparationHue;
				float m_DecalChannelSeparationVertical;
				float m_DecalChannelSeparationAngleStrength;
				#if defined(POI_AUDIOLINK)
				half m_AudioLinkDecalScaleBand;
				float4 m_AudioLinkDecalScale;
				half m_AudioLinkDecalRotationBand;
				float2 m_AudioLinkDecalRotation;
				half m_AudioLinkDecalAlphaBand;
				float2 m_AudioLinkDecalAlpha;
				half m_AudioLinkDecalEmissionBand;
				float2 m_AudioLinkDecalEmission;
				float m_DecalRotationCTALBand;
				float m_DecalRotationCTALSpeed;
				float m_DecalRotationCTALType;
				float m_AudioLinkDecalColorChord;
				float m_AudioLinkDecalSideBand;
				float4 m_AudioLinkDecalSideMin;
				float4 m_AudioLinkDecalSideMax;
				float2 m_AudioLinkDecalChannelSeparation;
				float m_AudioLinkDecalChannelSeparationBand;
				#endif
				float4 decalColor;
				float2 decalScale;
				float decalRotation;
				float2 uv;
				float4 dduv;
				float4 sideMod;
				float decalChannelOffset;
				float4 decalMask;
				void Init(in float4 DecalMask)
				{
					decalMask = DecalMask;
					decalScale = m_DecalScale;
				}
				void InitAudiolink(in PoiMods poiMods)
				{
					#ifdef POI_AUDIOLINK
					if (poiMods.audioLinkAvailable)
					{
						decalScale += lerp(m_AudioLinkDecalScale.xy, m_AudioLinkDecalScale.zw, poiMods.audioLink[m_AudioLinkDecalScaleBand]);
						sideMod += lerp(m_AudioLinkDecalSideMin, m_AudioLinkDecalSideMax, poiMods.audioLink[m_AudioLinkDecalSideBand]);
						decalRotation += lerp(m_AudioLinkDecalRotation.x, m_AudioLinkDecalRotation.y, poiMods.audioLink[m_AudioLinkDecalRotationBand]);
						decalRotation += AudioLinkGetChronoTime(m_DecalRotationCTALType, m_DecalRotationCTALBand) * m_DecalRotationCTALSpeed * 360;
						decalChannelOffset += lerp(m_AudioLinkDecalChannelSeparation[0], m_AudioLinkDecalChannelSeparation[1], poiMods.audioLink[m_AudioLinkDecalChannelSeparationBand]);
					}
					#endif
				}
				void SampleDecalNoTexture(in PoiMods poiMods, in PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
				{
					uv = decalUV(m_DecalTextureUV, m_DecalPosition, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					decalColor = float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					decalColor.rgb = decalHueShift(m_DecalHueShiftEnabled, decalColor.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					decalColor.a *= decalMask[m_DecalMaskChannel] * applyTilingClipping(m_DecalTiled, uv);
				}
				void SampleDecal(sampler2D decalTexture, in PoiMods poiMods, in PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
				{
					uv = decalUV(m_DecalTextureUV, m_DecalPosition, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					float4 dduv = any(fwidth(uv) > .5) ? 0.001 : float4(ddx(uv) * m_DecalTexture_ST.x, ddy(uv) * m_DecalTexture_ST.y);
					decalColor = tex2D(decalTexture, poiUV(uv, m_DecalTexture_ST) + m_DecalTexturePan * _Time.x, dduv.xy, dduv.zw) * float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					decalColor.rgb = decalHueShift(m_DecalHueShiftEnabled, decalColor.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					decalColor.a *= decalMask[m_DecalMaskChannel] * applyTilingClipping(m_DecalTiled, uv);
				}
				void SampleDecalChannelSeparation(sampler2D decalTexture, in PoiMods poiMods, in PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
				{
					decalColor = 0;
					decalChannelOffset += m_DecalChannelSeparation + m_DecalChannelSeparationAngleStrength * (m_DecalChannelSeparationAngleStrength > 0 ? (1 - poiLight.nDotV) : poiLight.nDotV);
					float2 positionOffset = decalChannelOffset * 0.01 * (decalScale.x + decalScale.y) * float2(cos(m_DecalChannelSeparationVertical), sin(m_DecalChannelSeparationVertical));
					float2 uvSample0 = decalUV(m_DecalTextureUV, m_DecalPosition + positionOffset, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					float2 uvSample1 = decalUV(m_DecalTextureUV, m_DecalPosition - positionOffset, m_DecalRotation + decalRotation, m_DecalRotationSpeed, decalScale, m_DecalSideOffset +sideMod, m_DecalDepth, poiMesh, poiCam);
					float4 dduvSample0 = any(fwidth(uvSample0) > .5) ? 0.001 : float4(ddx(uvSample0) * m_DecalTexture_ST.x, ddy(uvSample0) * m_DecalTexture_ST.y);
					float4 dduvSample1 = any(fwidth(uvSample1) > .5) ? 0.001 : float4(ddx(uvSample1) * m_DecalTexture_ST.x, ddy(uvSample1) * m_DecalTexture_ST.y);
					float4 sample0 = tex2D(decalTexture, poiUV(uvSample0, m_DecalTexture_ST) + m_DecalTexturePan * _Time.x, dduvSample0.xy, dduvSample0.zw) * float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					float4 sample1 = tex2D(decalTexture, poiUV(uvSample1, m_DecalTexture_ST) + m_DecalTexturePan * _Time.x, dduvSample1.xy, dduvSample1.zw) * float4(poiThemeColor(poiMods, m_DecalColor.rgb, m_DecalColorThemeIndex), m_DecalColor.a);
					sample0.rgb = decalHueShift(m_DecalHueShiftEnabled, sample0.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					sample1.rgb = decalHueShift(m_DecalHueShiftEnabled, sample1.rgb, m_DecalHueShift + poiLight.nDotV * m_DecalHueAngleStrength, m_DecalHueShiftSpeed);
					float3 channelSeparationColor = HUEtoRGB(frac(m_DecalChannelSeparationHue));
					if (m_DecalChannelSeparationPremultiply)
					{
						decalColor.rgb = lerp(sample0 * sample0.a, sample1 * sample1.a, channelSeparationColor);
					}
					else
					{
						decalColor.rgb = lerp(sample0, sample1, channelSeparationColor);
					}
					decalColor.a = 0.5 * (sample0.a + sample1.a);
					decalColor.a *= decalMask[m_DecalMaskChannel] * max(applyTilingClipping(m_DecalTiled, uvSample0), applyTilingClipping(m_DecalTiled, uvSample1));
				}
				void Apply(inout float alphaOverride, inout float decalAlpha, inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, inout PoiMods poiMods, in PoiLight poiLight)
				{
					if (m_DecalGlobalMask > 0)
					{
						decalColor.a = maskBlend(decalColor.a, poiMods.globalMask[m_DecalGlobalMask - 1], m_DecalGlobalMaskBlendType);
					}
					float audioLinkDecalAlpha = 0;
					float audioLinkDecalEmission = 0;
					#ifdef POI_AUDIOLINK
					audioLinkDecalEmission = lerp(m_AudioLinkDecalEmission.x, m_AudioLinkDecalEmission.y, poiMods.audioLink[m_AudioLinkDecalEmissionBand]) * poiMods.audioLinkAvailable;
					if (m_AudioLinkDecalColorChord)
					{
						if (poiMods.audioLinkAvailable)
						{
							decalColor.rgb *= AudioLinkLerp(ALPASS_CCSTRIP + float2(uv.x * AUDIOLINK_WIDTH, 0)).rgb;
						}
						else
						{
							decalAlpha = 0;
						}
					}
					audioLinkDecalAlpha = lerp(m_AudioLinkDecalAlpha.x, m_AudioLinkDecalAlpha.y, poiMods.audioLink[m_AudioLinkDecalAlphaBand]) * poiMods.audioLinkAvailable;
					#endif
					if (m_DecalOverrideAlpha)
					{
						alphaOverride += 1;
						decalAlpha = lerp(decalAlpha, min(decalAlpha, decalColor.a), decalMask[m_DecalMaskChannel]);
					}
					float decalAlphaMixed = decalColor.a * saturate(m_DecalBlendAlpha + audioLinkDecalAlpha);
					if (m_DecalApplyGlobalMaskIndex > 0)
					{
						applyToGlobalMask(poiMods, m_DecalApplyGlobalMaskIndex - 1, m_DecalApplyGlobalMaskBlendType, decalAlphaMixed);
					}
					poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, customBlend(poiFragData.baseColor.rgb, decalColor.rgb, m_DecalBlendType), decalAlphaMixed);
					poiFragData.emission += decalColor.rgb * decalColor.a * max(m_DecalEmissionStrength + audioLinkDecalEmission, 0);
				}
			};
			void applyDecals(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, inout PoiMods poiMods, in PoiLight poiLight)
			{
				float decalAlpha = 1;
				float alphaOverride = 0;
				#if defined(PROP_DECALMASK) || !defined(OPTIMIZER_ENABLED)
				float4 decalMask = POI2D_SAMPLER_PAN(_DecalMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				#else
				float4 decalMask = 1;
				#endif
				#ifdef TPS_Penetrator
				if (0.0)
				{
					decalMask.r = lerp(0, decalMask.r * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					decalMask.g = lerp(0, decalMask.g * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					decalMask.b = lerp(0, decalMask.b * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					decalMask.a = lerp(0, decalMask.a * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
				}
				#endif
				float4 decalColor = 1;
				float2 uv = 0;
				if (alphaOverride)
				{
					poiFragData.alpha *= decalAlpha;
				}
				poiFragData.baseColor = saturate(poiFragData.baseColor);
			}
			#endif
			#ifdef VIGNETTE_MASKED
			void calculateShading(inout PoiLight poiLight, inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				float shadowAttenuation = lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				float attenuation = 1;
				#if defined(POINT) || defined(SPOT)
				shadowAttenuation = lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				attenuation = poiLight.attenuation;
				#endif
				#ifdef UNITY_PASS_FORWARDADD
				if (1.0 == 0) // Realistic
				{
					poiLight.rampedLightMap = max(0, poiLight.nDotL);
					poiLight.finalLighting = poiLight.directColor * attenuation * max(0, poiLight.nDotL) * poiLight.detailShadow * shadowAttenuation;
					return;
				}
				else if (1.0 == 1) // Toon
				{
					#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
					float passthrough = 0;
					#else
					float passthrough = 0.5;
					#endif
					if (0.5 == 0.0) 0.5 += 0.001;
					poiLight.rampedLightMap = smoothstep(0.5, 0.0, 1 - (.5 * poiLight.nDotL + .5));
					#if defined(POINT) || defined(SPOT)
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.additiveShadow, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(0.0, 0.5, 1 - (.5 * poiLight.nDotL + .5))) * poiLight.attenuation;
					#else
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.attenuation, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(0.0, 0.5, 1 - (.5 * poiLight.nDotL + .5)));
					#endif
					return;
				}
				#endif
				float shadowStrength = 1.0 * poiLight.shadowMask;
				#ifdef POI_PASS_OUTLINE
				shadowStrength = lerp(0, shadowStrength, _OutlineShadowStrength);
				#endif
				#ifdef _LIGHTINGMODE_FLAT
				poiLight.finalLighting = poiLight.directColor * attenuation * shadowAttenuation;
				poiLight.rampedLightMap = poiLight.nDotLSaturated;
				#endif
				if (1.0)
				{
					#if defined(VERTEXLIGHT_ON)
					float3 vertexLighting = float3(0, 0, 0);
					for (int index = 0; index < 4; index++)
					{
						if (1.0 == 0 || 1.0 == 3)
						{
							vertexLighting += poiLight.vColor[index] * poiLight.vAttenuationDotNL[index] * poiLight.detailShadow; // Realistic
						}
						if (1.0 == 1) // Toon
						{
							vertexLighting += lerp(poiLight.vColor[index] * poiLight.vAttenuation[index], poiLight.vColor[index] * 0.5 * poiLight.vAttenuation[index], smoothstep(0.0, 0.5, 1 - (.5 * poiLight.vDotNL[index] + .5))) * poiLight.detailShadow;
						}
					}
					float3 mixedLight = poiLight.finalLighting;
					poiLight.finalLighting = vertexLighting + poiLight.finalLighting;
					#endif
				}
			}
			#endif
			void blendMatcap(inout PoiLight poiLight, inout PoiFragData poiFragData, in PoiMods poiMods, float add, float lightAdd, float multiply, float replace, float mixed, float screen, float4 matcapColor, float matcapMask, float emissionStrength, float matcapLightMask, uint globalMaskIndex, float globalMaskBlendType)
			{
				if (matcapLightMask)
				{
					matcapMask *= lerp(1, poiLight.rampedLightMap, matcapLightMask);
				}
				if (globalMaskIndex > 0)
				{
					matcapMask = maskBlend(matcapMask, poiMods.globalMask[globalMaskIndex - 1], globalMaskBlendType);
				}
				poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, matcapColor.rgb, replace * matcapMask * matcapColor.a * .999999);
				poiFragData.baseColor.rgb *= lerp(1, matcapColor.rgb, multiply * matcapMask * matcapColor.a);
				poiFragData.baseColor.rgb += matcapColor.rgb * add * matcapMask * matcapColor.a;
				poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, blendScreen(poiFragData.baseColor.rgb, matcapColor.rgb), screen * matcapMask * matcapColor.a);
				poiLight.finalLightAdd += matcapColor.rgb * lightAdd * matcapMask * matcapColor.a;
				poiFragData.baseColor.rgb = lerp(poiFragData.baseColor.rgb, poiFragData.baseColor.rgb + poiFragData.baseColor.rgb * matcapColor.rgb, mixed * matcapMask * matcapColor.a);
				poiFragData.emission += matcapColor.rgb * emissionStrength * matcapMask * matcapColor.a;
			}
			#if defined(POI_MATCAP0) || defined(COLOR_GRADING_HDR_3D) || defined(POI_MATCAP2) || defined(POI_MATCAP3)
			void applyMatcap(inout PoiFragData poiFragData, in PoiCam poiCam, in PoiMesh poiMesh, inout PoiLight poiLight, in PoiMods poiMods)
			{
				float4 matcap = 0;
				float matcapMask = 0;
				float4 matcap2 = 0;
				float matcap2Mask = 0;
				float4 matcap3 = 0;
				float matcap3Mask = 0;
				float4 matcap4 = 0;
				float matcap4Mask = 0;
				float2 matcapUV = 0;
				#ifdef POI_MATCAP0
				float3 normal0 = poiMesh.normals[1.0];
				switch(1.0)
				{
					case 0:
					{
						float3 viewNormal = (mul(UNITY_MATRIX_V, float4(normal0, 0))).rgb;
						float3 NormalBlend_MatCapUV_Detail = viewNormal.rgb * float3(-1, -1, 1);
						float3 NormalBlend_MatCapUV_Base = (mul(UNITY_MATRIX_V, float4(poiCam.viewDir, 0)).rgb * float3(-1, -1, 1)) + float3(0, 0, 1);
						float3 noSknewViewNormal = NormalBlend_MatCapUV_Base * dot(NormalBlend_MatCapUV_Base, NormalBlend_MatCapUV_Detail) / NormalBlend_MatCapUV_Base.b - NormalBlend_MatCapUV_Detail;
						matcapUV = noSknewViewNormal.rg * 0.43 + 0.5;
						break;
					}
					case 1:
					{
						float3 worldViewUp = normalize(float3(0, 1, 0) - poiCam.viewDir * dot(poiCam.viewDir, float3(0, 1, 0)));
						float3 worldViewRight = normalize(cross(poiCam.viewDir, worldViewUp));
						matcapUV = float2(dot(worldViewRight, normal0), dot(worldViewUp, normal0)) * 0.43 + 0.5;
						break;
					}
					case 2:
					{
						float3 reflection = reflect(-poiCam.viewDir, normal0);
						float2 uv = float2(dot(reflection, float3(1, 0, 0)), dot(reflection, float3(0, 1, 0)));
						matcapUV = uv * 0.43 + 0.5;
						break;
					}
				}
				matcapUV = lerp(matcapUV, poiMesh.uv[1.0], float4(0,0,0,0).xy);
				matcapUV = RotateUV(matcapUV, 0.0 * PI, float2(.5, .5), 1.0f);
				if (IsInMirror())
				{
					matcapUV.x = 1 - matcapUV.x;
				}
				float matcapSmoothness;
				float mipCount0 = 9;
				if (0.0)
				{
					if (float4(0.001953125,0.001953125,512,512).z == 8192) mipCount0 = 13;
					if (float4(0.001953125,0.001953125,512,512).z == 4096) mipCount0 = 12;
					if (float4(0.001953125,0.001953125,512,512).z == 2048) mipCount0 = 11;
					if (float4(0.001953125,0.001953125,512,512).z == 1024) mipCount0 = 10;
					if (float4(0.001953125,0.001953125,512,512).z == 512) mipCount0 = 9;
					if (float4(0.001953125,0.001953125,512,512).z == 256) mipCount0 = 8;
					if (float4(0.001953125,0.001953125,512,512).z == 128) mipCount0 = 7;
					if (float4(0.001953125,0.001953125,512,512).z == 64) mipCount0 = 6;
					if (float4(0.001953125,0.001953125,512,512).z == 32) mipCount0 = 5;
					matcapSmoothness = 1.0;
					if (0.0)
					{
						#if defined(PROP_MATCAPMASK) || !defined(OPTIMIZER_ENABLED)
						matcapSmoothness *= POI2D_SAMPLER_PAN(_MatcapMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0))[3.0];
						#endif
					}
					matcapSmoothness = (1 - matcapSmoothness) * mipCount0;
				}
				#if defined(PROP_MATCAP) || !defined(OPTIMIZER_ENABLED)
				if (0.0)
				{
					matcap = UNITY_SAMPLE_TEX2D_SAMPLER_LOD(_Matcap, _MainTex, TRANSFORM_TEX(matcapUV, _Matcap), matcapSmoothness) * float4(poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0), float4(1,1,1,1).a);
				}
				else
				{
					matcap = UNITY_SAMPLE_TEX2D_SAMPLER(_Matcap, _MainTex, TRANSFORM_TEX(matcapUV, _Matcap)) * float4(poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0), float4(1,1,1,1).a);
				}
				#else
				matcap = float4(poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0), float4(1,1,1,1).a);
				#endif
				matcap.rgb *= 1.0;
				matcap.rgb = lerp(matcap.rgb, matcap.rgb * poiFragData.baseColor.rgb, 0.0);
				#if defined(PROP_MATCAPMASK) || !defined(OPTIMIZER_ENABLED)
				matcapMask = POI2D_SAMPLER_PAN(_MatcapMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0))[0.0];
				#else
				matcapMask = 1;
				#endif
				if (0.0)
				{
					matcapMask = 1 - matcapMask;
				}
				#ifdef TPS_Penetrator
				if (0.0)
				{
					matcapMask = lerp(0, matcapMask * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
				}
				#endif
				poiFragData.alpha *= lerp(1, matcap.a, matcapMask * 0.0);
				if (0.0)
				{
					matcap.rgb = hueShift(matcap.rgb, 0.0 + _Time.x * 0.0);
				}
				blendMatcap(poiLight, poiFragData, poiMods, 0.0, 0.0, 0.331, 0.0, 1.0, 0.0, matcap, matcapMask, 0.0, 0.0, 0.0, 2.0);
				#endif
			}
			#endif
			#if defined(_GLOSSYREFLECTIONS_OFF) || defined(POI_RIM2)
			#if defined(_RIMSTYLE_POIYOMI) || defined(_RIM2STYLE_POIYOMI)
			void ApplyPoiyomiRimLighting(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight, inout PoiMods poiMods, float Is_NormalMapToRimLight, float RimInvert, float RimPower, float RimStrength, float RimShadowWidth, float RimShadowToggle, float RimWidth, float RimBlendStrength, float RimMask, float RimGlobalMask, float RimGlobalMaskBlendType, float4 RimTex, float4 RimLightColor, float RimLightColorThemeIndex, float RimHueShiftEnabled, float RimHueShift, float RimHueShiftSpeed, float RimSharpness, float RimShadowMaskRampType, float RimShadowMaskInvert, float RimShadowMaskStrength, float2 RimShadowAlpha, float RimApplyGlobalMaskIndex, float RimApplyGlobalMaskBlendType, float RimBaseColorMix, float RimBrightness, float RimBlendMode, half AudioLinkRimWidthBand, float2 AudioLinkRimWidthAdd, half AudioLinkRimEmissionBand, float2 AudioLinkRimEmissionAdd, half AudioLinkRimBrightnessBand, float2 AudioLinkRimBrightnessAdd, float RimClamp, float rimBias, float rimBiasIntensity)
			{
				float viewDotNormal = abs(dot(poiCam.viewDir, lerp(poiMesh.normals[0], poiMesh.normals[1], Is_NormalMapToRimLight)));
				
				if (RimInvert)
				{
					viewDotNormal = 1 - viewDotNormal;
				}
				viewDotNormal = pow(viewDotNormal, RimPower);
				if (RimShadowWidth && RimShadowToggle)
				{
					viewDotNormal += lerp(0, (1 - poiLight.nDotLNormalized) * 3, RimShadowWidth);
				}
				viewDotNormal *= lerp(1, rimBias, rimBiasIntensity);
				float rimStrength = RimStrength;
				float rimWidth = lerp( - .05, 1, RimWidth);
				float blendStrength = RimBlendStrength;
				#ifdef POI_AUDIOLINK
				
				if (poiMods.audioLinkAvailable)
				{
					rimWidth = clamp(rimWidth + lerp(AudioLinkRimWidthAdd.x, AudioLinkRimWidthAdd.y, poiMods.audioLink[AudioLinkRimWidthBand]), - .05, 1);
					rimStrength += lerp(AudioLinkRimEmissionAdd.x, AudioLinkRimEmissionAdd.y, poiMods.audioLink[AudioLinkRimEmissionBand]);
					blendStrength += lerp(AudioLinkRimBrightnessAdd.x, AudioLinkRimBrightnessAdd.y, poiMods.audioLink[AudioLinkRimBrightnessBand]);
				}
				#endif
				float rimMask = RimMask;
				if (RimGlobalMask > 0)
				{
					rimMask = maskBlend(rimMask, poiMods.globalMask[RimGlobalMask-1], RimGlobalMaskBlendType);
				}
				float4 rimColor = RimTex;
				rimColor *= float4(poiThemeColor(poiMods, RimLightColor.rgb, RimLightColorThemeIndex), RimLightColor.a);
				
				if (RimHueShiftEnabled)
				{
					rimColor.rgb = hueShift(rimColor.rgb, RimHueShift + _Time.x * RimHueShiftSpeed);
				}
				float rim = 1 - smoothstep(min(RimSharpness, rimWidth), rimWidth, viewDotNormal);
				rim *= RimLightColor.a * rimColor.a * rimMask;
				if (RimShadowToggle)
				{
					switch(RimShadowMaskRampType)
					{
						case 0:
						float rampedLightMap = poiLight.rampedLightMap;
						if (RimShadowMaskInvert) rampedLightMap = 1 - rampedLightMap;
						rim = lerp(rim, rim * rampedLightMap, RimShadowMaskStrength);
						break;
						case 1:
						float nDotLNormalized = poiLight.nDotLNormalized;
						if (RimShadowMaskInvert) nDotLNormalized = 1 - nDotLNormalized;
						rim = lerp(rim, rim * smoothstep(RimShadowAlpha.x, RimShadowAlpha.y, nDotLNormalized), RimShadowMaskStrength);
						break;
					}
				}
				if (RimApplyGlobalMaskIndex > 0)
				{
					applyToGlobalMask(poiMods, RimApplyGlobalMaskIndex-1, RimApplyGlobalMaskBlendType, rim * blendStrength);
				}
				float3 finalRimColor = rimColor.rgb * lerp(1, poiFragData.baseColor, RimBaseColorMix);
				finalRimColor *= RimBrightness;
				switch(RimBlendMode)
				{
					case 0: poiFragData.baseColor += finalRimColor * rim * blendStrength; break;
					case 1: poiFragData.baseColor = lerp(poiFragData.baseColor, finalRimColor, rim * blendStrength); break;
					case 2: poiFragData.baseColor = lerp(poiFragData.baseColor, poiFragData.baseColor * finalRimColor, rim * blendStrength); break;
					case 3: poiFragData.baseColor = lerp(poiFragData.baseColor.rgb, poiFragData.baseColor.rgb + poiFragData.baseColor.rgb * finalRimColor, rim * blendStrength); break;
				}
				if(RimClamp)
				{
					poiFragData.baseColor = saturate(poiFragData.baseColor);
				}
				poiFragData.emission += finalRimColor * rim * rimStrength;
			}
			#endif
			#if defined(_RIMSTYLE_UTS2) || defined(_RIM2STYLE_UTS2)
			void ApplyUTS2RimLighting(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight, in PoiMods poiMods, float Set_RimLightMask_var, float RimGlobalMask, float RimGlobalMaskBlendType, float4 RimLightColor, float RimLightColorThemeIndex, float Is_LightColor_RimLight, float Is_NormalMapToRimLight, float RimLight_Power, float RimLight_InsideMask, float RimLight_FeatherOff, float LightDirection_MaskOn, float Tweak_LightDirection_MaskLevel, float Add_Antipodean_RimLight, float4 Ap_RimLightColor, float RimApColorThemeIndex, float Is_LightColor_Ap_RimLight, float Ap_RimLight_Power, float Ap_RimLight_FeatherOff, float Tweak_RimLightMaskLevel, float RimHueShiftEnabled, float RimHueShift, float RimHueShiftSpeed, float RimClamp)
			{
				if (RimGlobalMask > 0)
				{
					Set_RimLightMask_var = maskBlend(Set_RimLightMask_var, poiMods.globalMask[RimGlobalMask-1], RimGlobalMaskBlendType);
				}
				float3 rimColor = float3(poiThemeColor(poiMods, RimLightColor.rgb, RimLightColorThemeIndex));
				float3 _Is_LightColor_RimLight_var = lerp(rimColor, (rimColor * poiLight.directColor), Is_LightColor_RimLight);
				float _RimArea_var = (1.0 - dot(lerp(poiMesh.normals[0], poiMesh.normals[1], Is_NormalMapToRimLight), poiCam.viewDir));
				float _RimLightPower_var = pow(_RimArea_var, exp2(lerp(3, 0, RimLight_Power)));
				float _Rimlight_InsideMask_var = saturate(lerp((0.0 + ((_RimLightPower_var - RimLight_InsideMask) * (1.0 - 0.0)) / (1.0 - RimLight_InsideMask)), step(RimLight_InsideMask, _RimLightPower_var), RimLight_FeatherOff));
				float _VertHalfLambert_var = 0.5 * dot(poiMesh.normals[0], poiLight.direction) + 0.5;
				float3 _LightDirection_MaskOn_var = lerp((_Is_LightColor_RimLight_var * _Rimlight_InsideMask_var), (_Is_LightColor_RimLight_var * saturate((_Rimlight_InsideMask_var - ((1.0 - _VertHalfLambert_var) + Tweak_LightDirection_MaskLevel)))), LightDirection_MaskOn);
				float _ApRimLightPower_var = pow(_RimArea_var, exp2(lerp(3, 0, Ap_RimLight_Power)));
				float3 ApRimColor = float3(poiThemeColor(poiMods, Ap_RimLightColor.rgb, RimApColorThemeIndex));
				float3 _RimLight_var = (saturate((Set_RimLightMask_var + Tweak_RimLightMaskLevel)) * lerp(_LightDirection_MaskOn_var, (_LightDirection_MaskOn_var + (lerp(ApRimColor, (ApRimColor * poiLight.directColor), Is_LightColor_Ap_RimLight) * saturate((lerp((0.0 + ((_ApRimLightPower_var - RimLight_InsideMask) * (1.0 - 0.0)) / (1.0 - RimLight_InsideMask)), step(RimLight_InsideMask, _ApRimLightPower_var), Ap_RimLight_FeatherOff) - (saturate(_VertHalfLambert_var) + Tweak_LightDirection_MaskLevel))))), Add_Antipodean_RimLight));
				
				if (RimHueShiftEnabled)
				{
					_RimLight_var = hueShift(_RimLight_var, RimHueShift + _Time.x * RimHueShiftSpeed);
				}
				poiFragData.baseColor += _RimLight_var;
				if(RimClamp)
				{
					poiFragData.baseColor = saturate(poiFragData.baseColor);
				}
			}
			#endif
			#if defined(_RIMSTYLE_LILTOON) || defined(_RIM2STYLE_LILTOON)
			void ApplyLiltoonRimLighting(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight, in PoiMods poiMods, float4 RimColor, float4 RimIndirColor, float4 RimColorTex, float RimMainStrength, float RimNormalStrength, float RimDirRange, float RimIndirRange, float RimFresnelPower, float RimBackfaceMask, float RimDirStrength, float RimBorder, float RimBlur, float RimIndirBorder, float RimIndirBlur, float RimShadowMask, float RimEnableLighting, float RimVRParallaxStrength, float RimGlobalMask, float RimGlobalMaskBlendType, float RimHueShiftEnabled, float RimHueShift, float RimHueShiftSpeed, float RimClamp)
			{
				if (RimGlobalMask > 0)
				{
					RimColorTex.a = maskBlend(RimColorTex.a, poiMods.globalMask[RimGlobalMask-1], RimGlobalMaskBlendType);
				}
				float4 rimColor = RimColor;
				float4 rimIndirColor = RimIndirColor;
				rimColor *= RimColorTex;
				rimIndirColor *= RimColorTex;
				if (RimHueShiftEnabled)
				{
					rimColor.rgb = hueShift(rimColor.rgb, RimHueShift + _Time.x * RimHueShiftSpeed);
					rimIndirColor.rgb = hueShift(rimIndirColor.rgb, RimHueShift + _Time.x * RimHueShiftSpeed);
				}
				rimColor.rgb = lerp(rimColor.rgb, rimColor.rgb * poiFragData.baseColor, RimMainStrength);
				float3 centerViewDir = !IsOrthographicCamera() ? normalize(getCameraPosition() - poiMesh.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 viewDir = lerp(centerViewDir, poiCam.viewDir, RimVRParallaxStrength);
				float3 normal = lerp(poiMesh.normals[0], poiMesh.normals[1], RimNormalStrength);
				float nvabs = abs(dot(normal, viewDir));
				float lnRaw = dot(poiLight.direction, normal) * 0.5 + 0.5;
				float lnDir = saturate((lnRaw + RimDirRange) / (1.0 + RimDirRange));
				float lnIndir = saturate((1.0-lnRaw + RimIndirRange) / (1.0 + RimIndirRange));
				float rim = pow(saturate(1.0 - nvabs), RimFresnelPower);
				rim = !poiMesh.isFrontFace && RimBackfaceMask ? 0.0 : rim;
				float rimDir = lerp(rim, rim * lnDir, RimDirStrength);
				float rimIndir = rim * lnIndir * RimDirStrength;
				rimDir = poiEdgeLinear(rimDir, RimBorder, RimBlur);
				rimIndir = poiEdgeLinear(rimIndir, RimIndirBorder, RimIndirBlur);
				rimDir = lerp(rimDir, rimDir * poiLight.rampedLightMap, RimShadowMask);
				rimIndir = lerp(rimIndir, rimIndir * poiLight.rampedLightMap, RimShadowMask);
				float3 rimSum = rimDir * rimColor.a * rimColor.rgb + rimIndir * rimIndirColor.a * rimIndirColor.rgb;
				poiFragData.baseColor += rimSum * RimEnableLighting;
				poiFragData.emission += rimSum * (1-RimEnableLighting);
				if(RimClamp)
				{
					poiFragData.baseColor = saturate(poiFragData.baseColor);
				}
			}
			#endif
			#endif
			#if defined(MOCHIE_PBR) || defined(POI_CLEARCOAT)
			float GSAA_Filament(float3 worldNormal, float perceptualRoughness, float gsaaVariance, float gsaaThreshold)
			{
				float3 du = ddx(worldNormal);
				float3 dv = ddy(worldNormal);
				float variance = gsaaVariance * (dot(du, du) + dot(dv, dv));
				float roughness = perceptualRoughness * perceptualRoughness;
				float kernelRoughness = min(2.0 * variance, gsaaThreshold);
				float squareRoughness = saturate(roughness * roughness + kernelRoughness);
				return sqrt(sqrt(squareRoughness));
			}
			bool SceneHasReflections()
			{
				float width, height;
				unity_SpecCube0.GetDimensions(width, height);
				return !(width * height < 2);
			}
			float3 GetWorldReflections(float3 reflDir, float3 worldPos, float roughness)
			{
				float3 baseReflDir = reflDir;
				reflDir = BoxProjection(reflDir, worldPos, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
				float4 envSample0 = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflDir, roughness * UNITY_SPECCUBE_LOD_STEPS);
				float3 p0 = DecodeHDR(envSample0, unity_SpecCube0_HDR);
				float interpolator = unity_SpecCube0_BoxMin.w;
				
				if (interpolator < 0.99999)
				{
					float3 refDirBlend = BoxProjection(baseReflDir, worldPos, unity_SpecCube1_ProbePosition, unity_SpecCube1_BoxMin, unity_SpecCube1_BoxMax);
					float4 envSample1 = UNITY_SAMPLE_TEXCUBE_SAMPLER_LOD(unity_SpecCube1, unity_SpecCube0, refDirBlend, roughness * UNITY_SPECCUBE_LOD_STEPS);
					float3 p1 = DecodeHDR(envSample1, unity_SpecCube1_HDR);
					p0 = lerp(p1, p0, interpolator);
				}
				return p0;
			}
			float3 GetReflections(in PoiCam poiCam, in PoiLight pl, in PoiMesh poiMesh, float roughness, float ForceFallback, float LightFallback, samplerCUBE reflectionCube, float4 hdrData, float3 reflectionDir)
			{
				float3 reflections = 0;
				float3 lighting = pl.finalLighting;
				if (ForceFallback == 0)
				{
					
					if (SceneHasReflections())
					{
						#ifdef UNITY_PASS_FORWARDBASE
						reflections = GetWorldReflections(reflectionDir, poiMesh.worldPos.xyz, roughness);
						#endif
					}
					else
					{
						#ifdef UNITY_PASS_FORWARDBASE
						reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
						reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
						#endif
						#ifdef POI_PASS_ADD
						if (LightFallback)
						{
							reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
							reflections = DecodeHDR(float4(reflections, 1), hdrData) * pl.finalLighting;
						}
						#endif
					}
				}
				else
				{
					#ifdef UNITY_PASS_FORWARDBASE
					reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
					reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
					#endif
					#ifdef POI_PASS_ADD
					if (LightFallback)
					{
						reflections = texCUBElod(reflectionCube, float4(reflectionDir, roughness * UNITY_SPECCUBE_LOD_STEPS));
						reflections = DecodeHDR(float4(reflections, 1), hdrData) * pl.finalLighting;
					}
					#endif
				}
				reflections *= pl.occlusion;
				return reflections;
			}
			float GetGGXTerm(float nDotL, float nDotV, float nDotH, float roughness)
			{
				float visibilityTerm = 0;
				if (nDotL > 0)
				{
					float rough = roughness;
					float rough2 = roughness * roughness;
					float lambdaV = nDotL * (nDotV * (1 - rough) + rough);
					float lambdaL = nDotV * (nDotL * (1 - rough) + rough);
					visibilityTerm = 0.5f / (lambdaV + lambdaL + 1e-5f);
					float d = (nDotH * rough2 - nDotH) * nDotH + 1.0f;
					float dotTerm = UNITY_INV_PI * rough2 / (d * d + 1e-7f);
					visibilityTerm *= dotTerm * UNITY_PI;
				}
				return visibilityTerm;
			}
			void GetSpecFresTerm(float nDotL, float nDotV, float nDotH, float lDotH, inout float3 specularTerm, inout float3 fresnelTerm, float3 specCol, float roughness)
			{
				specularTerm = GetGGXTerm(nDotL, nDotV, nDotH, roughness);
				fresnelTerm = FresnelTerm(specCol, lDotH);
				specularTerm = max(0, specularTerm * max(0.00001, nDotL));
			}
			float GetRoughness(float smoothness)
			{
				float rough = 1 - smoothness;
				rough *= 1.7 - 0.7 * rough;
				return rough;
			}
			#endif
			#ifdef MOCHIE_PBR
			void MochieBRDF(inout PoiFragData poiFragData, in PoiCam poiCam, inout PoiLight poiLight, in PoiMesh poiMesh, inout PoiMods poiMods)
			{
				float smoothness = 0.313;
				float smoothness2 = 1.0;
				float metallic = 0.0;
				float specularMask = 1;
				float reflectionMask = 1;
				smoothness *= poiMods.PBR.x;
				smoothness2 *= poiMods.PBR.x;
				metallic *= poiMods.PBR.y;
				specularMask *= poiMods.PBR.z;
				reflectionMask *= poiMods.PBR.w;
				#if defined(PROP_MOCHIEMETALLICMAPS) || !defined(OPTIMIZER_ENABLED)
				float4 PBRMaps = POI2D_SAMPLER_PAN_STOCHASTIC(_MochieMetallicMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0), 0.0);
				
				if (0.0)
				{
					float4 PBRSplitMask = POI2D_SAMPLER_PAN_STOCHASTIC(_MochieMetallicMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0).xy, 0.0);
					assignValueToVectorFromIndex(PBRMaps, 2.0, PBRSplitMask[2.0]);
					assignValueToVectorFromIndex(PBRMaps, 3.0, PBRSplitMask[3.0]);
				}
				if (0.0 < 4)
				{
					metallic *= PBRMaps[0.0];
				}
				if (1.0 < 4)
				{
					smoothness *= PBRMaps[1.0];
					smoothness2 *= PBRMaps[1.0];
				}
				if (2.0 < 4)
				{
					reflectionMask *= PBRMaps[2.0];
				}
				if (3.0 < 4)
				{
					specularMask *= PBRMaps[3.0];
				}
				#endif
				reflectionMask *= 0.459;
				specularMask *= 0.45;
				if (0.0 > 0)
				{
					metallic = customBlend(metallic, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					smoothness = customBlend(smoothness, poiMods.globalMask[0.0 - 1], 2.0);
					smoothness2 = customBlend(smoothness2, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					reflectionMask = customBlend(reflectionMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					specularMask = customBlend(specularMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0)
				{
					metallic = 1 - metallic;
				}
				if (0.0)
				{
					smoothness = 1 - smoothness;
					smoothness2 = 1 - smoothness2;
				}
				if (0.0)
				{
					reflectionMask = 1 - reflectionMask;
				}
				if (0.0)
				{
					specularMask = 1 - specularMask;
				}
				#ifdef TPS_Penetrator
				if (0.0)
				{
					reflectionMask = lerp(0, reflectionMask * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
					specularMask = lerp(0, specularMask * TPSBufferedDepth(poiMesh.localPos, poiMesh.vertexColor), 1.0);
				}
				#endif
				float roughness = GetRoughness(smoothness);
				float roughness2 = GetRoughness(smoothness2);
				float3 specCol = lerp(unity_ColorSpaceDielectricSpec.rgb, poiFragData.baseColor, metallic);
				float omr = unity_ColorSpaceDielectricSpec.a - metallic * unity_ColorSpaceDielectricSpec.a;
				float percepRough = 1 - smoothness;
				float percepRough2 = 1 - smoothness2;
				
				if (1.0)
				{
					percepRough = GSAA_Filament(poiMesh.normals[1.0], percepRough, 0.15, 0.1);
					if (0.0 == 1 && 1.0 > 0)
					{
						percepRough2 = GSAA_Filament(poiMesh.normals[1.0], percepRough2, 0.15, 0.1);
					}
				}
				float brdfRoughness = percepRough * percepRough;
				brdfRoughness = max(brdfRoughness, 0.002);
				float brdfRoughness2 = percepRough2 * percepRough2;
				brdfRoughness2 = max(brdfRoughness2, 0.002);
				float3 diffuse = poiFragData.baseColor;
				float3 specular = 0;
				float3 specular2 = 0;
				float3 vSpecular = 0;
				float3 vSpecular2 = 0;
				float3 reflections = 0;
				float3 environment = 0;
				float attenuation = min(poiLight.nDotLSaturated, lerp(poiLight.attenuation, 1, 0.0));
				#ifdef POI_PASS_ADD
				attenuation *= lerp(poiLight.additiveShadow, 1, 0.0);
				#endif
				float3 fresnelTerm = 1;
				float3 specularTerm = 1;
				float pbrNDotL = lerp(poiLight.vertexNDotL, poiLight.nDotL, 1.0);
				float pbrNDotV = lerp(poiLight.vertexNDotV, poiLight.nDotV, 1.0);
				float pbrNDotH = lerp(poiLight.vertexNDotH, poiLight.nDotH, 1.0);
				float3 pbrReflectionDir = lerp(poiCam.vertexReflectionDir, poiCam.reflectionDir, 1.0);
				GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness);
				specular = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation;
				if (1.0)
				{
					#if defined(VERTEXLIGHT_ON)
					for (int index = 0; index < 4; index++)
					{
						fresnelTerm = 1;
						specularTerm = 1;
						float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
						float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
						GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness);
						vSpecular += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * poiLight.vAttenuation[index];
					}
					#endif
				}
				if (0.0 == 1)
				{
					float3 fresnelTerm = 1;
					float3 specularTerm = 1;
					GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness2);
					specular2 = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation * 1.0;
					if (1.0)
					{
						#if defined(VERTEXLIGHT_ON)
						for (int index = 0; index < 4; index++)
						{
							fresnelTerm = 1;
							specularTerm = 1;
							float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
							float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
							GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness2);
							vSpecular2 += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * poiLight.vAttenuation[index] * 1.0;
						}
						#endif
					}
				}
				float surfaceReduction = (1.0 / (brdfRoughness * brdfRoughness + 1.0));
				float grazingTerm = saturate(smoothness + (1 - omr));
				float3 reflCol = GetReflections(poiCam, poiLight, poiMesh, roughness, 0.0, 1.0, _MochieReflCube, _MochieReflCube_HDR, pbrReflectionDir);
				reflections = surfaceReduction * reflCol * lerp(1, FresnelLerp(specCol, grazingTerm, pbrNDotV), 1.0);
				reflections *= poiThemeColor(poiMods, float4(1,1,1,1), 0.0);
				reflections *= reflectionMask;
				#ifdef POI_PASS_ADD
				reflections *= poiLight.attenuation;
				#endif
				diffuse = lerp(diffuse, diffuse * omr, reflectionMask);
				poiMods.PBR = float4(smoothness, metallic, specularMask, reflectionMask);
				environment = max(specular + vSpecular, specular2 + vSpecular2);
				environment += reflections;
				diffuse *= poiLight.finalLighting;
				poiFragData.finalColor = diffuse;
				poiLight.finalLightAdd += environment;
			}
			#endif
			float4 frag(VertexOut i, uint facing : SV_IsFrontFace) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				PoiMesh poiMesh;
				PoiInitStruct(PoiMesh, poiMesh);
				PoiLight poiLight;
				PoiInitStruct(PoiLight, poiLight);
				PoiVertexLights poiVertexLights;
				PoiInitStruct(PoiVertexLights, poiVertexLights);
				PoiCam poiCam;
				PoiInitStruct(PoiCam, poiCam);
				PoiMods poiMods;
				PoiInitStruct(PoiMods, poiMods);
				poiMods.globalEmission = 1;
				poiMods.PBR = 1;
				PoiFragData poiFragData;
				poiFragData.emission = 0;
				poiFragData.baseColor = float3(0, 0, 0);
				poiFragData.finalColor = float3(0, 0, 0);
				poiFragData.alpha = 1;
				#ifdef POI_UDIMDISCARD
				applyUDIMDiscard(i);
				#endif
				poiMesh.objectPosition = i.objectPos;
				poiMesh.objNormal = i.objNormal;
				poiMesh.normals[0] = i.normal;
				poiMesh.tangent[0] = i.tangent;
				poiMesh.binormal[0] = i.binormal;
				poiMesh.worldPos = i.worldPos.xyz;
				poiMesh.localPos = i.localPos.xyz;
				poiMesh.vertexColor = i.vertexColor;
				poiMesh.isFrontFace = facing;
				#ifndef POI_PASS_OUTLINE
				if (!poiMesh.isFrontFace)
				{
					poiMesh.normals[0] *= -1;
					poiMesh.tangent[0] *= -1;
					poiMesh.binormal[0] *= -1;
				}
				#endif
				poiCam.viewDir = !IsOrthographicCamera() ? normalize(_WorldSpaceCameraPos - i.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 tanToWorld0 = float3(i.tangent.x, i.binormal.x, i.normal.x);
				float3 tanToWorld1 = float3(i.tangent.y, i.binormal.y, i.normal.y);
				float3 tanToWorld2 = float3(i.tangent.z, i.binormal.z, i.normal.z);
				float3 ase_tanViewDir = tanToWorld0 * poiCam.viewDir.x + tanToWorld1 * poiCam.viewDir.y + tanToWorld2 * poiCam.viewDir.z;
				poiCam.tangentViewDir = normalize(ase_tanViewDir);
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				poiMesh.lightmapUV = i.lightmapUV;
				#endif
				poiMesh.parallaxUV = poiCam.tangentViewDir.xy / max(poiCam.tangentViewDir.z, 0.0001);
				poiMesh.uv[0] = i.uv[0];
				poiMesh.uv[1] = i.uv[1];
				poiMesh.uv[2] = i.uv[2];
				poiMesh.uv[3] = i.uv[3];
				poiMesh.uv[4] = poiMesh.uv[0];
				poiMesh.uv[5] = poiMesh.uv[0];
				poiMesh.uv[6] = poiMesh.uv[0];
				poiMesh.uv[7] = poiMesh.uv[0];
				poiMesh.uv[8] = poiMesh.uv[0];
				poiMesh.uv[4] = calculatePanosphereUV(poiMesh);
				poiMesh.uv[5] = calculateWorldUV(poiMesh);
				poiMesh.uv[6] = calculatePolarCoordinate(poiMesh);
				poiMesh.uv[8] = calculatelocalUV(poiMesh);
				poiMods.globalMask[0]  = 1;
				poiMods.globalMask[1]  = 1;
				poiMods.globalMask[2]  = 1;
				poiMods.globalMask[3]  = 1;
				poiMods.globalMask[4]  = 1;
				poiMods.globalMask[5]  = 1;
				poiMods.globalMask[6]  = 1;
				poiMods.globalMask[7]  = 1;
				poiMods.globalMask[8]  = 1;
				poiMods.globalMask[9]  = 1;
				poiMods.globalMask[10] = 1;
				poiMods.globalMask[11] = 1;
				poiMods.globalMask[12] = 1;
				poiMods.globalMask[13] = 1;
				poiMods.globalMask[14] = 1;
				poiMods.globalMask[15] = 1;
				ApplyGlobalMaskModifiers(poiMesh, poiMods, poiCam);
				float2 mainUV = poiMesh.uv[0.0].xy;
				if (0.0)
				{
					mainUV = sharpSample(float4(1,1,1,1), mainUV);
				}
				float4 mainTexture = POI2D_SAMPLER_PAN_STOCHASTIC(_MainTex, _MainTex, poiUV(mainUV, float4(1,1,0,0)), float4(0,0,0,0), 0.0);
				#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
				poiMesh.tangentSpaceNormal = UnpackScaleNormal(POI2D_SAMPLER_PAN_STOCHASTIC(_BumpMap, _MainTex, poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0)), float4(0,0,0,0), 0.0), 1.0);
				#else
				poiMesh.tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				#endif
				poiMesh.normals[1] = normalize(
				poiMesh.tangentSpaceNormal.x * poiMesh.tangent[0] +
				poiMesh.tangentSpaceNormal.y * poiMesh.binormal[0] +
				poiMesh.tangentSpaceNormal.z * poiMesh.normals[0]
				);
				poiMesh.tangent[1] = cross(poiMesh.binormal[0], -poiMesh.normals[1]);
				poiMesh.binormal[1] = cross(-poiMesh.normals[1], poiMesh.tangent[0]);
				poiCam.forwardDir = getCameraForward();
				poiCam.worldPos = _WorldSpaceCameraPos;
				poiCam.reflectionDir = reflect(-poiCam.viewDir, poiMesh.normals[1]);
				poiCam.vertexReflectionDir = reflect(-poiCam.viewDir, poiMesh.normals[0]);
				poiCam.distanceToVert = distance(poiMesh.worldPos, poiCam.worldPos);
				poiCam.grabPos = i.grabPos;
				poiCam.screenUV = calcScreenUVs(i.grabPos);
				poiCam.vDotN = abs(dot(poiCam.viewDir, poiMesh.normals[1]));
				poiCam.clipPos = i.pos;
				poiCam.worldDirection = i.worldDirection;
				calculateGlobalThemes(poiMods);
				poiLight.finalLightAdd = 0;
				#if defined(PROP_LIGHTINGAOMAPS) || !defined(OPTIMIZER_ENABLED)
				float4 AOMaps = POI2D_SAMPLER_PAN(_LightingAOMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				poiLight.occlusion = min(min(min(lerp(1, AOMaps.r, 1.0), lerp(1, AOMaps.g, 0.0)), lerp(1, AOMaps.b, 0.0)), lerp(1, AOMaps.a, 0.0));
				#else
				poiLight.occlusion = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.occlusion = maskBlend(poiLight.occlusion, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#if defined(PROP_LIGHTINGDETAILSHADOWMAPS) || !defined(OPTIMIZER_ENABLED)
				float4 DetailShadows = POI2D_SAMPLER_PAN(_LightingDetailShadowMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				#ifndef POI_PASS_ADD
				poiLight.detailShadow = lerp(1, DetailShadows.r, 1.0) * lerp(1, DetailShadows.g, 0.0) * lerp(1, DetailShadows.b, 0.0) * lerp(1, DetailShadows.a, 0.0);
				#else
				poiLight.detailShadow = lerp(1, DetailShadows.r, 1.0) * lerp(1, DetailShadows.g, 0.0) * lerp(1, DetailShadows.b, 0.0) * lerp(1, DetailShadows.a, 0.0);
				#endif
				#else
				poiLight.detailShadow = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.detailShadow = maskBlend(poiLight.detailShadow, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#if defined(PROP_LIGHTINGSHADOWMASKS) || !defined(OPTIMIZER_ENABLED)
				float4 ShadowMasks = POI2D_SAMPLER_PAN(_LightingShadowMasks, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				poiLight.shadowMask = lerp(1, ShadowMasks.r, 1.0) * lerp(1, ShadowMasks.g, 0.0) * lerp(1, ShadowMasks.b, 0.0) * lerp(1, ShadowMasks.a, 0.0);
				#else
				poiLight.shadowMask = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.shadowMask = maskBlend(poiLight.shadowMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#ifdef UNITY_PASS_FORWARDBASE
				bool lightExists = false;
				if (any(_LightColor0.rgb >= 0.002))
				{
					lightExists = true;
				}
				if (1.0)
				{
					#if defined(VERTEXLIGHT_ON)
					float4 toLightX = unity_4LightPosX0 - i.worldPos.x;
					float4 toLightY = unity_4LightPosY0 - i.worldPos.y;
					float4 toLightZ = unity_4LightPosZ0 - i.worldPos.z;
					float4 lengthSq = 0;
					lengthSq += toLightX * toLightX;
					lengthSq += toLightY * toLightY;
					lengthSq += toLightZ * toLightZ;
					float4 lightAttenSq = unity_4LightAtten0;
					float4 atten = 1.0 / (1.0 + lengthSq * lightAttenSq);
					float4 vLightWeight = saturate(1 - (lengthSq * lightAttenSq / 25));
					poiLight.vAttenuation = min(atten, vLightWeight * vLightWeight);
					poiLight.vDotNL = 0;
					poiLight.vDotNL += toLightX * poiMesh.normals[1].x;
					poiLight.vDotNL += toLightY * poiMesh.normals[1].y;
					poiLight.vDotNL += toLightZ * poiMesh.normals[1].z;
					float4 corr = rsqrt(lengthSq);
					poiLight.vertexVDotNL = max(0, poiLight.vDotNL * corr);
					poiLight.vertexVDotNL = 0;
					poiLight.vertexVDotNL += toLightX * poiMesh.normals[0].x;
					poiLight.vertexVDotNL += toLightY * poiMesh.normals[0].y;
					poiLight.vertexVDotNL += toLightZ * poiMesh.normals[0].z;
					poiLight.vertexVDotNL = max(0, poiLight.vDotNL * corr);
					poiLight.vAttenuationDotNL = saturate(poiLight.vAttenuation * saturate(poiLight.vDotNL));
					[unroll]
					for (int index = 0; index < 4; index++)
					{
						poiLight.vPosition[index] = float3(unity_4LightPosX0[index], unity_4LightPosY0[index], unity_4LightPosZ0[index]);
						float3 vertexToLightSource = poiLight.vPosition[index] - poiMesh.worldPos;
						poiLight.vDirection[index] = normalize(vertexToLightSource);
						poiLight.vColor[index] = 0.0 ? min(1.0, unity_LightColor[index].rgb) : unity_LightColor[index].rgb;
						poiLight.vColor[index] = lerp(poiLight.vColor[index], dot(poiLight.vColor[index], float3(0.299, 0.587, 0.114)), 0.0);
						poiLight.vHalfDir[index] = Unity_SafeNormalize(poiLight.vDirection[index] + poiCam.viewDir);
						poiLight.vDotNL[index] = dot(poiMesh.normals[1], poiLight.vDirection[index]);
						poiLight.vCorrectedDotNL[index] = .5 * (poiLight.vDotNL[index] + 1);
						poiLight.vDotLH[index] = saturate(dot(poiLight.vDirection[index], poiLight.vHalfDir[index]));
						poiLight.vDotNH[index] = dot(poiMesh.normals[1], poiLight.vHalfDir[index]);
						poiLight.vertexVDotNH[index] = saturate(dot(poiMesh.normals[0], poiLight.vHalfDir[index]));
					}
					#endif
				}
				if (0.0 == 0) // Poi Custom Light Color
				{
					float3 magic = max(BetterSH9(normalize(unity_SHAr + unity_SHAg + unity_SHAb)), 0);
					float3 normalLight = _LightColor0.rgb + BetterSH9(float4(0, 0, 0, 1));
					float magiLumi = calculateluminance(magic);
					float normaLumi = calculateluminance(normalLight);
					float maginormalumi = magiLumi + normaLumi;
					float magiratio = magiLumi / maginormalumi;
					float normaRatio = normaLumi / maginormalumi;
					float target = calculateluminance(magic * magiratio + normalLight * normaRatio);
					float3 properLightColor = magic + normalLight;
					float properLuminance = calculateluminance(magic + normalLight);
					poiLight.directColor = properLightColor * max(0.0001, (target / properLuminance));
					poiLight.indirectColor = BetterSH9(float4(lerp(0, poiMesh.normals[1], 0.0), 1));
				}
				if (0.0 == 1) // More standard approach to light color
				{
					float3 indirectColor = BetterSH9(float4(poiMesh.normals[1], 1));
					if (lightExists)
					{
						poiLight.directColor = _LightColor0.rgb;
						poiLight.indirectColor = indirectColor;
					}
					else
					{
						poiLight.directColor = indirectColor * 0.6;
						poiLight.indirectColor = indirectColor * 0.5;
					}
				}
				if (0.0 == 2) // UTS style
				{
					poiLight.indirectColor = saturate(max(half3(0.05, 0.05, 0.05) * 1.0, max(ShadeSH9(half4(0.0, 0.0, 0.0, 1.0)), ShadeSH9(half4(0.0, -1.0, 0.0, 1.0)).rgb) * 1.0));
					poiLight.directColor = max(poiLight.indirectColor, _LightColor0.rgb);
				}
				if (0.0 == 3) // OpenLit
				{
					float3 lightDirectionForSH9 = OpenLitLightingDirectionForSH9();
					OpenLitShadeSH9ToonDouble(lightDirectionForSH9, poiLight.directColor, poiLight.indirectColor);
					poiLight.directColor += _LightColor0.rgb;
				}
				float lightMapMode = 0.0;
				if (0.0 == 0)
				{
					poiLight.direction = _WorldSpaceLightPos0.xyz + unity_SHAr.xyz + unity_SHAg.xyz + unity_SHAb.xyz;
				}
				if (0.0 == 1 || 0.0 == 2)
				{
					if (0.0 == 1)
					{
						poiLight.direction = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;;
					}
					if (0.0 == 2)
					{
						poiLight.direction = float4(0,0,0,1);
					}
					if (lightMapMode == 0)
					{
						lightMapMode == 1;
					}
				}
				if (0.0 == 3) // UTS
				{
					float3 defaultLightDirection = normalize(UNITY_MATRIX_V[2].xyz + UNITY_MATRIX_V[1].xyz);
					float3 lightDirection = normalize(lerp(defaultLightDirection, _WorldSpaceLightPos0.xyz, any(_WorldSpaceLightPos0.xyz)));
					poiLight.direction = lightDirection;
				}
				if (0.0 == 4) // OpenLit
				{
					poiLight.direction = OpenLitLightingDirection(); // float4 customDir = 0; // Do we want to give users to alter this (OpenLit always does!)?
				}
				if (!any(poiLight.direction))
				{
					poiLight.direction = float3(.4, 1, .4);
				}
				poiLight.direction = normalize(poiLight.direction);
				poiLight.attenuationStrength = 0.0;
				poiLight.attenuation = 1;
				if (!all(_LightColor0.rgb == 0.0))
				{
					UNITY_LIGHT_ATTENUATION(attenuation, i, poiMesh.worldPos)
					poiLight.attenuation *= attenuation;
				}
				if (!any(poiLight.directColor) && !any(poiLight.indirectColor) && lightMapMode == 0)
				{
					lightMapMode = 1;
					if (0.0 == 0)
					{
						poiLight.direction = normalize(float3(.4, 1, .4));
					}
				}
				poiLight.halfDir = normalize(poiLight.direction + poiCam.viewDir);
				poiLight.vertexNDotL = dot(poiMesh.normals[0], poiLight.direction);
				poiLight.nDotL = dot(poiMesh.normals[1], poiLight.direction);
				poiLight.nDotLSaturated = saturate(poiLight.nDotL);
				poiLight.nDotLNormalized = (poiLight.nDotL + 1) * 0.5;
				poiLight.nDotV = abs(dot(poiMesh.normals[1], poiCam.viewDir));
				poiLight.vertexNDotV = abs(dot(poiMesh.normals[0], poiCam.viewDir));
				poiLight.nDotH = dot(poiMesh.normals[1], poiLight.halfDir);
				poiLight.vertexNDotH = max(0.00001, dot(poiMesh.normals[0], poiLight.halfDir));
				poiLight.lDotv = dot(poiLight.direction, poiCam.viewDir);
				poiLight.lDotH = max(0.00001, dot(poiLight.direction, poiLight.halfDir));
				if (lightMapMode == 0)
				{
					float3 ShadeSH9Plus = GetSHLength();
					float3 ShadeSH9Minus = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) + float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
					float3 greyScaleVector = float3(.33333, .33333, .33333);
					float bw_lightColor = dot(poiLight.directColor, greyScaleVector);
					float bw_directLighting = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor * lerp(1, poiLight.attenuation, poiLight.attenuationStrength)) + dot(ShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_directLightingNoAtten = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor) + dot(ShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_bottomIndirectLighting = dot(ShadeSH9Minus, greyScaleVector);
					float bw_topIndirectLighting = dot(ShadeSH9Plus, greyScaleVector);
					float lightDifference = ((bw_topIndirectLighting + bw_lightColor) - bw_bottomIndirectLighting);
					poiLight.lightMap = smoothstep(0, lightDifference, bw_directLighting - bw_bottomIndirectLighting) * poiLight.detailShadow;
					poiLight.lightMap = smoothstep(0, lightDifference, bw_directLighting - bw_bottomIndirectLighting) * poiLight.detailShadow;
					poiLight.lightMapNoAttenuation = smoothstep(0, lightDifference, bw_directLightingNoAtten - bw_bottomIndirectLighting) * poiLight.detailShadow;
				}
				if (lightMapMode == 1)
				{
					poiLight.lightMapNoAttenuation = poiLight.nDotLNormalized;
					poiLight.lightMap = poiLight.nDotLNormalized * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				}
				if (lightMapMode == 2)
				{
					poiLight.lightMapNoAttenuation = poiLight.nDotLSaturated;
					poiLight.lightMap = poiLight.nDotLSaturated * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				}
				poiLight.directColor = max(poiLight.directColor, 0.0001);
				poiLight.indirectColor = max(poiLight.indirectColor, 0.0001);
				if (0.0 == 3)
				{
					poiLight.directColor = max(poiLight.directColor, 0.0);
				}
				else
				{
					poiLight.directColor = max(poiLight.directColor, poiLight.directColor * min(10000, (0.0 * rcp(calculateluminance(poiLight.directColor)))));
					poiLight.indirectColor = max(poiLight.indirectColor, poiLight.indirectColor * min(10000, (0.0 * rcp(calculateluminance(poiLight.indirectColor)))));
				}
				poiLight.directColor = lerp(poiLight.directColor, dot(poiLight.directColor, float3(0.299, 0.587, 0.114)), 0.0);
				poiLight.indirectColor = lerp(poiLight.indirectColor, dot(poiLight.indirectColor, float3(0.299, 0.587, 0.114)), 0.0);
				if (1.0)
				{
					poiLight.directColor = min(poiLight.directColor, 1.0);
					poiLight.indirectColor = min(poiLight.indirectColor, 1.0);
				}
				if (0.0)
				{
					poiLight.directColor = poiThemeColor(poiMods, float4(1,1,1,1), 0.0);
				}
				#ifdef UNITY_PASS_FORWARDBASE
				poiLight.directColor = max(poiLight.directColor * 1.0, 0);
				poiLight.directColor = max(poiLight.directColor + 0.0, 0);
				poiLight.indirectColor = max(poiLight.indirectColor * 1.0, 0);
				poiLight.indirectColor = max(poiLight.indirectColor + 0.0, 0);
				#endif
				#endif
				#ifdef POI_PASS_ADD
				if (!1.0)
				{
					return float4(mainTexture.rgb * .0001, 1);
				}
				#if defined(DIRECTIONAL)
				if (1.0)
				{
					return float4(mainTexture.rgb * .0001, 1);
				}
				#endif
				poiLight.direction = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w);
				#if defined(POINT) || defined(SPOT)
				#ifdef POINT
				unityShadowCoord3 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(poiMesh.worldPos, 1)).xyz;
				poiLight.attenuation = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).r;
				#endif
				#ifdef SPOT
				unityShadowCoord4 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(poiMesh.worldPos, 1));
				poiLight.attenuation = (lightCoord.z > 0) * UnitySpotCookie(lightCoord) * UnitySpotAttenuate(lightCoord.xyz);
				#endif
				#else
				UNITY_LIGHT_ATTENUATION(attenuation, i, poiMesh.worldPos)
				poiLight.attenuation = attenuation;
				#endif
				poiLight.additiveShadow = UNITY_SHADOW_ATTENUATION(i, poiMesh.worldPos);
				poiLight.attenuationStrength = 1.0;
				poiLight.directColor = 0.0 ? min(1.0, _LightColor0.rgb) : _LightColor0.rgb;
				#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
				poiLight.indirectColor = 0;
				#else
				poiLight.indirectColor = lerp(0, poiLight.directColor, 0.5);
				#endif
				poiLight.directColor = lerp(poiLight.directColor, dot(poiLight.directColor, float3(0.299, 0.587, 0.114)), 0.0);
				poiLight.indirectColor = lerp(poiLight.indirectColor, dot(poiLight.indirectColor, float3(0.299, 0.587, 0.114)), 0.0);
				poiLight.halfDir = normalize(poiLight.direction + poiCam.viewDir);
				poiLight.nDotL = dot(poiMesh.normals[1], poiLight.direction);
				poiLight.nDotLSaturated = saturate(poiLight.nDotL);
				poiLight.nDotLNormalized = (poiLight.nDotL + 1) * 0.5;
				poiLight.nDotV = abs(dot(poiMesh.normals[1], poiCam.viewDir));
				poiLight.nDotH = dot(poiMesh.normals[1], poiLight.halfDir);
				poiLight.lDotv = dot(poiLight.direction, poiCam.viewDir);
				poiLight.lDotH = dot(poiLight.direction, poiLight.halfDir);
				poiLight.vertexNDotL = dot(poiMesh.normals[0], poiLight.direction);
				poiLight.vertexNDotV = abs(dot(poiMesh.normals[0], poiCam.viewDir));
				poiLight.vertexNDotH = max(0.00001, dot(poiMesh.normals[0], poiLight.halfDir));
				if (0.0 == 1)
				{
					poiLight.lightMap = poiLight.nDotLNormalized;
				}
				if (0.0 == 2 || 0.0 == 0)
				{
					poiLight.lightMap = poiLight.nDotLSaturated;
				}
				poiLight.lightMap *= lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				#endif
				poiFragData.baseColor = mainTexture.rgb * poiThemeColor(poiMods, float4(0.673178,0.2713008,0.1356672,1).rgb, 0.0);
				poiFragData.alpha = mainTexture.a * float4(0.673178,0.2713008,0.1356672,1).a;
				#if defined(PROP_CLIPPINGMASK) || !defined(OPTIMIZER_ENABLED)
				float alphaMask = POI2D_SAMPLER_PAN(_ClippingMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0)).r;
				if (0.0)
				{
					alphaMask = 1 - alphaMask;
				}
				poiFragData.alpha *= alphaMask;
				#endif
				applyAlphaOptions(poiFragData, poiMesh, poiCam, poiMods);
				#if defined(GEOM_TYPE_BRANCH) || defined(GEOM_TYPE_BRANCH_DETAIL) || defined(GEOM_TYPE_FROND) || defined(DEPTH_OF_FIELD_COC_VIEW)
				applyDecals(poiFragData, poiMesh, poiCam, poiMods, poiLight);
				#endif
				#if defined(_LIGHTINGMODE_SHADEMAP) && defined(VIGNETTE_MASKED)
				#ifndef POI_PASS_OUTLINE
				#endif
				#endif
				#ifdef VIGNETTE_MASKED
				#ifdef POI_PASS_OUTLINE
				if (_OutlineLit)
				{
					calculateShading(poiLight, poiFragData, poiMesh, poiCam);
				}
				else
				{
					poiLight.finalLighting = 1;
				}
				#else
				calculateShading(poiLight, poiFragData, poiMesh, poiCam);
				#endif
				#else
				poiLight.finalLighting = 1;
				poiLight.rampedLightMap = poiEdgeNonLinear(poiLight.nDotL, 0.1, .1);
				#endif
				#if defined(POI_MATCAP0) || defined(COLOR_GRADING_HDR_3D) || defined(POI_MATCAP2) || defined(POI_MATCAP3)
				applyMatcap(poiFragData, poiCam, poiMesh, poiLight, poiMods);
				#endif
				#ifdef _GLOSSYREFLECTIONS_OFF
				#ifdef _RIMSTYLE_POIYOMI
				#if defined(PROP_RIMMASK) || !defined(OPTIMIZER_ENABLED)
				float4 rimMaskAndBias = POI2D_SAMPLER_PAN(_RimMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				float rimMask = rimMaskAndBias[0.0];
				float rimBias = rimMaskAndBias.a;
				#else
				float rimMask = 1;
				float rimBias = 0;
				#endif
				if(0.0)
				{
					rimMask = 1 - rimMask;
				}
				#if defined(PROP_RIMTEX) || !defined(OPTIMIZER_ENABLED)
				float4 rimColor = POI2D_SAMPLER_PAN(_RimTex, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				#else
				float4 rimColor = 1;
				#endif
				half AudioLinkRimWidthBand = 0;
				float2 AudioLinkRimWidthAdd = 0;
				half AudioLinkRimEmissionBand = 0;
				float2 AudioLinkRimEmissionAdd = 0;
				half AudioLinkRimBrightnessBand = 0;
				float2 AudioLinkRimBrightnessAdd = 0;
				#ifdef POI_AUDIOLINK
				AudioLinkRimWidthBand = 0.0;
				AudioLinkRimWidthAdd = float4(0,0,0,0);
				AudioLinkRimEmissionBand = 0.0;
				AudioLinkRimEmissionAdd = float4(0,0,0,0);
				AudioLinkRimBrightnessBand = 0.0;
				AudioLinkRimBrightnessAdd = float4(0,0,0,0);
				#endif
				ApplyPoiyomiRimLighting(poiFragData, poiMesh, poiCam, poiLight, poiMods, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.407, rimMask, 0.0, 2.0, rimColor, float4(0.673178,0.05184535,0.01049035,1), 0.0, 0.0, 0.0, 0.0, 0.131, 0.0, 0.0, 1.0, float4(0,0,0,1), 0.0, 2.0, 0.0, 1.0, 2.0, AudioLinkRimWidthBand, AudioLinkRimWidthAdd, AudioLinkRimEmissionBand, AudioLinkRimEmissionAdd, AudioLinkRimBrightnessBand, AudioLinkRimBrightnessAdd, 0.0, rimBias, 0.0);
				#endif
				#endif
				if (0.0)
				{
					poiFragData.baseColor *= saturate(poiFragData.alpha);
				}
				poiFragData.finalColor = poiFragData.baseColor;
				poiFragData.finalColor = poiFragData.baseColor * poiLight.finalLighting;
				#ifdef MOCHIE_PBR
				MochieBRDF(poiFragData, poiCam, poiLight, poiMesh, poiMods);
				#endif
				if (0.0 == 0)
				{
					UNITY_APPLY_FOG(i.fogCoord, poiFragData.finalColor);
				}
				poiFragData.alpha = 0.0 ? 1 : poiFragData.alpha;
				poiFragData.finalColor += poiLight.finalLightAdd;
				if (0.0 == POI_MODE_OPAQUE)
				{
					poiFragData.alpha = 1;
				}
				clip(poiFragData.alpha - 0.5);
				if (0.0 == POI_MODE_CUTOUT && !0.0)
				{
					poiFragData.alpha = 1;
				}
				if (0.0 == 4)
				{
					poiFragData.alpha = saturate(poiFragData.alpha * 10.0);
				}
				if (0.0 != POI_MODE_TRANSPARENT)
				{
					poiFragData.finalColor *= poiFragData.alpha;
				}
				return float4(poiFragData.finalColor, poiFragData.alpha) + POI_SAFE_RGB0;
			}
struct SpsInputs : appdata {
#define SPS_STRUCT_POSITION_TYPE float4
#define SPS_STRUCT_POSITION_TYPE_float4
#define SPS_STRUCT_POSITION_NAME vertex
#define SPS_STRUCT_NORMAL_TYPE float3
#define SPS_STRUCT_NORMAL_TYPE_float3
#define SPS_STRUCT_NORMAL_NAME normal
#define SPS_STRUCT_TANGENT_TYPE float4
#define SPS_STRUCT_TANGENT_TYPE_float4
#define SPS_STRUCT_TANGENT_NAME tangent
#define SPS_STRUCT_COLOR_TYPE float4
#define SPS_STRUCT_COLOR_TYPE_float4
#define SPS_STRUCT_COLOR_NAME color
#define SPS_STRUCT_TEXCOORD_TYPE float2
#define SPS_STRUCT_TEXCOORD_TYPE_float2
#define SPS_STRUCT_TEXCOORD_NAME uv0
#define SPS_STRUCT_TEXCOORD1_TYPE float2
#define SPS_STRUCT_TEXCOORD1_TYPE_float2
#define SPS_STRUCT_TEXCOORD1_NAME uv1
#define SPS_STRUCT_TEXCOORD2_TYPE float2
#define SPS_STRUCT_TEXCOORD2_TYPE_float2
#define SPS_STRUCT_TEXCOORD2_NAME uv2
#define SPS_STRUCT_TEXCOORD3_TYPE float2
#define SPS_STRUCT_TEXCOORD3_TYPE_float2
#define SPS_STRUCT_TEXCOORD3_NAME uv3
#define SPS_STRUCT_SV_VertexID_TYPE uint
#define SPS_STRUCT_SV_VertexID_TYPE_uint
#define SPS_STRUCT_SV_VertexID_NAME vertexId

// Add parameters needed by SPS if missing from the existing struct
#ifndef SPS_STRUCT_POSITION_NAME
  float3 spsPosition : POSITION;
  #define SPS_STRUCT_POSITION_TYPE float3
  #define SPS_STRUCT_POSITION_TYPE_float3
  #define SPS_STRUCT_POSITION_NAME spsPosition
#endif
#ifndef SPS_STRUCT_NORMAL_NAME
  float3 spsNormal : NORMAL;
  #define SPS_STRUCT_NORMAL_TYPE float3
  #define SPS_STRUCT_NORMAL_TYPE_float3
  #define SPS_STRUCT_NORMAL_NAME spsNormal
#endif
#ifndef SPS_STRUCT_TANGENT_NAME
  float4 spsTangent : TANGENT;
  #define SPS_STRUCT_TANGENT_TYPE float4
  #define SPS_STRUCT_TANGENT_TYPE_float4
  #define SPS_STRUCT_TANGENT_NAME spsTangent
#endif
#ifndef SPS_STRUCT_SV_VertexID_NAME
  uint spsVertexId : SV_VertexID;
  #define SPS_STRUCT_SV_VertexID_TYPE uint
  #define SPS_STRUCT_SV_VertexID_TYPE_uint
  #define SPS_STRUCT_SV_VertexID_NAME spsVertexId
#endif
#ifndef SPS_STRUCT_COLOR_NAME
  float4 spsColor : COLOR;
  #define SPS_STRUCT_COLOR_TYPE float4
  #define SPS_STRUCT_COLOR_TYPE_float4
  #define SPS_STRUCT_COLOR_NAME spsColor
#endif
};
#define SPS_VANILLA_VERT_PARAM_TYPE appdata


#ifndef SPS_UTILS
#define SPS_UTILS

#include "UnityShaderVariables.cginc"

float sps_map(float value, float min1, float max1, float min2, float max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float sps_saturated_map(float value, float min, float max) {
    return saturate(sps_map(value, min, max, 0, 1));
}

// normalize fails fatally and discards the vert if length == 0
float3 sps_normalize(float3 a) {
    return length(a) == 0 ? float3(0,0,1) : normalize(a);
}

#define sps_angle_between(a,b) acos(dot(sps_normalize(a),sps_normalize(b)))

float3 sps_nearest_normal(float3 forward, float3 approximate) {
    return sps_normalize(cross(forward, cross(approximate, forward)));
}

float3 sps_toLocal(float3 v) { return mul(unity_WorldToObject, float4(v, 1)).xyz; }
float3 sps_toWorld(float3 v) { return mul(unity_ObjectToWorld, float4(v, 1)).xyz; }
// https://forum.unity.com/threads/point-light-in-v-f-shader.499717/#post-9052987
float sps_attenToRange(float atten) { return 5.0 * (1.0 / sqrt(atten)); }

#endif




// https://en.wikipedia.org/wiki/B%C3%A9zier_curve
float3 sps_bezier(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
	const float minT = 1-t;
	return
		minT * minT * minT * p0
		+ 3 * minT * minT * t * p1
		+ 3 * minT * t * t * p2
		+ t * t * t * p3;
}
float3 sps_bezierDerivative(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
	const float minT = 1-t;
	return
		3 * minT * minT * (p1 - p0)
		+ 6 * minT * t * (p2 - p1)
		+ 3 * t * t * (p3 - p2);
}

// https://gamedev.stackexchange.com/questions/105230/points-evenly-spaced-along-a-bezier-curve
// https://gamedev.stackexchange.com/questions/5373/moving-ships-between-two-planets-along-a-bezier-missing-some-equations-for-acce/5427#5427
// https://www.geometrictools.com/Documentation/MovingAlongCurveSpecifiedSpeed.pdf
// https://gamedev.stackexchange.com/questions/137022/consistent-normals-at-any-angle-in-bezier-curve/
void sps_bezierSolve(float3 p0, float3 p1, float3 p2, float3 p3, float lookingForLength, out float curveLength, out float3 position, out float3 forward, out float3 up)
{
	#define SPS_BEZIER_SAMPLES 50
	float sampledT[SPS_BEZIER_SAMPLES];
	float sampledLength[SPS_BEZIER_SAMPLES];
	float3 sampledUp[SPS_BEZIER_SAMPLES];
	float totalLength = 0;
	float3 lastPoint = p0;
	sampledT[0] = 0;
	sampledLength[0] = 0;
	sampledUp[0] = float3(0,1,0);
	{
		for(int i = 1; i < SPS_BEZIER_SAMPLES; i++)
		{
			const float t = float(i) / (SPS_BEZIER_SAMPLES-1);
			const float3 currentPoint = sps_bezier(p0, p1, p2, p3, t);
			const float3 currentForward = sps_normalize(sps_bezierDerivative(p0, p1, p2, p3, t));
			const float3 lastUp = sampledUp[i-1];
			const float3 currentUp = sps_nearest_normal(currentForward, lastUp);

			sampledT[i] = t;
			totalLength += length(currentPoint - lastPoint);
			sampledLength[i] = totalLength;
			sampledUp[i] = currentUp;
			lastPoint = currentPoint;
		}
	}

	float adjustedT = 1;
	float3 approximateUp = sampledUp[SPS_BEZIER_SAMPLES - 1];
	for(int i = 1; i < SPS_BEZIER_SAMPLES; i++)
	{
		if (lookingForLength <= sampledLength[i])
		{
			const float fraction = sps_map(lookingForLength, sampledLength[i-1], sampledLength[i], 0, 1);
			adjustedT = lerp(sampledT[i-1], sampledT[i], fraction);
			approximateUp = lerp(sampledUp[i-1], sampledUp[i], fraction);
			break;
		}
	}

	curveLength = totalLength;
	const float t = saturate(adjustedT);
	position = sps_bezier(p0, p1, p2, p3, t);
	forward = sps_normalize(sps_bezierDerivative(p0, p1, p2, p3, t));
	up = sps_nearest_normal(forward, approximateUp);
}


#include "UnityShaderVariables.cginc"
#ifndef SPS_GLOBALS
#define SPS_GLOBALS

#define SPS_PI float(3.14159265359)

#define SPS_TYPE_INVALID 0
#define SPS_TYPE_HOLE 1
#define SPS_TYPE_RING_TWOWAY 2
#define SPS_TYPE_SPSPLUS 3
#define SPS_TYPE_RING_ONEWAY 4
#define SPS_TYPE_FRONT 5

#ifdef SHADER_TARGET_SURFACE_ANALYSIS
    #define SPS_TEX_DEFINE(name) float4 name##_TexelSize; sampler2D name;
    #define SPS_TEX_RAW_FLOAT4_XY(name,x,y) tex2Dlod(name, float4(uint2(x,y) * name##_TexelSize.xy, 0, 0))
#else
    #define SPS_TEX_DEFINE(name) Texture2D name;
    #define SPS_TEX_RAW_FLOAT4_XY(name,x,y) name[uint2(x,y)]
#endif
float SpsInt4ToFloat(int4 data) { return asfloat((data[3] << 24) | (data[2] << 16) | (data[1] << 8) | data[0]); }
#define SPS_TEX_RAW_FLOAT4(tex, offset) ((float4)(SPS_TEX_RAW_FLOAT4_XY(tex, (offset)%8192, (offset)/8192)))
#define SPS_TEX_RAW_INT4(tex, offset) ((int4)(SPS_TEX_RAW_FLOAT4(tex, offset) * 255))
#define SPS_TEX_FLOAT(tex, offset) SpsInt4ToFloat(SPS_TEX_RAW_INT4(tex, offset))
#define SPS_TEX_FLOAT3(tex, offset) float3(SPS_TEX_FLOAT(tex, offset), SPS_TEX_FLOAT(tex, (offset)+1), SPS_TEX_FLOAT(tex, (offset)+2))

float _SPS_Length;
float _SPS_BakedLength;
SPS_TEX_DEFINE(_SPS_Bake)
float _SPS_BlendshapeVertCount;
float _SPS_Blendshape0;
float _SPS_Blendshape1;
float _SPS_Blendshape2;
float _SPS_Blendshape3;
float _SPS_Blendshape4;
float _SPS_Blendshape5;
float _SPS_Blendshape6;
float _SPS_Blendshape7;
float _SPS_Blendshape8;
float _SPS_Blendshape9;
float _SPS_Blendshape10;
float _SPS_Blendshape11;
float _SPS_Blendshape12;
float _SPS_Blendshape13;
float _SPS_Blendshape14;
float _SPS_Blendshape15;
float _SPS_BlendshapeCount;

float _SPS_Enabled;
float _SPS_Overrun;
float _SPS_Target_LL_Lights;

#endif




#ifndef SPS_PLUS
#define SPS_PLUS

float _SPS_Plus_Enabled;
float _SPS_Plus_Ring;
float _SPS_Plus_Hole;

void sps_plus_search(
    out float distance,
    out int type
) {
    distance = 999;
    type = SPS_TYPE_INVALID;
    
    float maxVal = 0;
    if (_SPS_Plus_Ring > maxVal) { maxVal = _SPS_Plus_Ring; type = SPS_TYPE_RING_TWOWAY; }
    if (_SPS_Plus_Hole == maxVal) { type = SPS_TYPE_RING_ONEWAY; }
    if (_SPS_Plus_Hole > maxVal) { maxVal = _SPS_Plus_Hole; type = SPS_TYPE_HOLE; }

    if (maxVal > 0) {
        distance = (1 - maxVal) * 3;
    }
}

#endif




void sps_light_parse(float range, half4 color, out int type) {
	type = SPS_TYPE_INVALID;

	if (range >= 0.5 || (length(color.rgb) > 0 && color.a > 0)) {
		// Outside of SPS range, or visible light
		return;
	}

	const int secondDecimal = round((range % 0.1) * 100);

	if (_SPS_Plus_Enabled > 0.5) {
		if (secondDecimal == 1 || secondDecimal == 2) {
			const int fourthDecimal = round((range % 0.001) * 10000);
			if (fourthDecimal == 2) {
				type = SPS_TYPE_SPSPLUS;
				return;
			}
		}
	}

	if (secondDecimal == 1) type = SPS_TYPE_HOLE;
	if (secondDecimal == 2) type = SPS_TYPE_RING_TWOWAY;
	if (secondDecimal == 5) type = SPS_TYPE_FRONT;
}

// Find nearby socket lights
void sps_light_search(
	inout int ioType,
	inout float3 ioRootLocal,
	inout float3 ioRootNormal
) {
	// Collect useful info about all the nearby lights that unity tells us about
	// (usually the brightest 4)
	int lightType[4];
	float3 lightWorldPos[4];
	float3 lightLocalPos[4];
	{
		for(int i = 0; i < 4; i++) {
	 		const float range = sps_attenToRange(unity_4LightAtten0[i]);
			sps_light_parse(range, unity_LightColor[i], lightType[i]);
	 		lightWorldPos[i] = float3(unity_4LightPosX0[i], unity_4LightPosY0[i], unity_4LightPosZ0[i]);
	 		lightLocalPos[i] = sps_toLocal(lightWorldPos[i]);
	 	}
	}

	// Fill in SPS light info from contacts
	if (_SPS_Plus_Enabled > 0.5) {
		float spsPlusDistance;
		int spsPlusType;
		sps_plus_search(spsPlusDistance, spsPlusType);
		if (spsPlusType != SPS_TYPE_INVALID) {
			bool spsLightFound = false;
			int spsLightIndex = 0;
			float spsMinError = 0;
			for(int i = 0; i < 4; i++) {
				if (lightType[i] != SPS_TYPE_SPSPLUS) continue;
				const float3 myPos = lightLocalPos[i];
				const float3 otherPos = lightLocalPos[spsLightIndex];
				const float myError = abs(length(myPos) - spsPlusDistance);
				if (myError > 0.2) continue;
				const float otherError = spsMinError;

				bool imBetter = false;
				if (!spsLightFound) imBetter = true;
				else if (myError < 0.3 && myPos.z >= 0 && otherPos.z < 0) imBetter = true;
				else if (otherError < 0.3 && otherPos.z >= 0 && myPos.z < 0) imBetter = false;
				else if (myError < otherError) imBetter = true;

				if (imBetter) {
					spsLightFound = true;
					spsLightIndex = i;
					spsMinError = myError;
				}
			}
			if (spsLightFound) {
				lightType[spsLightIndex] = spsPlusType;
			}
		}
	}

	// Find nearest socket root
	int rootIndex = 0;
	bool rootFound = false;
	{
	 	float minDistance = -1;
	 	for(int i = 0; i < 4; i++) {
	 		const float distance = length(lightLocalPos[i]);
	 		const int type = lightType[i];
	 		if (distance < minDistance || minDistance < 0) {
	 			if (type == SPS_TYPE_HOLE || type == SPS_TYPE_RING_TWOWAY || type == SPS_TYPE_RING_ONEWAY) {
	 				rootFound = true;
	 				rootIndex = i;
	 				minDistance = distance;
	 			}
	 		}
	 	}
	}
	
	int frontIndex = 0;
	bool frontFound = false;
	if (rootFound) {
	 	// Find front (normal) light for socket root if available
	 	float minDistance = 0.1;
	 	for(int i = 0; i < 4; i++) {
	 		const float distFromRoot = length(lightWorldPos[i] - lightWorldPos[rootIndex]);
	 		if (lightType[i] == SPS_TYPE_FRONT && distFromRoot < minDistance) {
	 			frontFound = true;
	 			frontIndex = i;
	 			minDistance = distFromRoot;
	 		}
	 	}
	}

	// This can happen if the socket was misconfigured, or if it's on a first person head bone that's been shrunk down
	// Ignore the normal, since it'll be so close to the root that rounding error will cause problems
	if (frontFound && length(lightLocalPos[frontIndex] - lightLocalPos[rootIndex]) < 0.00005) {
		frontFound = false;
	}

	if (!rootFound) return;
	if (ioType != SPS_TYPE_INVALID && length(lightLocalPos[rootIndex]) >= length(ioRootLocal)) return;

	ioType = lightType[rootIndex];
	ioRootLocal = lightLocalPos[rootIndex];
	ioRootNormal = frontFound
		? lightLocalPos[frontIndex] - lightLocalPos[rootIndex]
		: -1 * lightLocalPos[rootIndex];
	ioRootNormal = sps_normalize(ioRootNormal);
}











void SpsApplyBlendshape(uint vertexId, inout float3 position, inout float3 normal, inout float3 tangent, float blendshapeValue, int blendshapeId)
{
    if (blendshapeId >= _SPS_BlendshapeCount) return;
    const int vertCount = (int)_SPS_BlendshapeVertCount;
    const uint bytesPerBlendshapeVertex = 9;
    const uint bytesPerBlendshape = vertCount * bytesPerBlendshapeVertex + 1;
    const uint blendshapeOffset = 1 + (vertCount * 10) + bytesPerBlendshape * blendshapeId;
    const uint vertexOffset = blendshapeOffset + 1 + (vertexId * bytesPerBlendshapeVertex);
    const float blendshapeValueAtBake = SPS_TEX_FLOAT(_SPS_Bake, blendshapeOffset);
    const float blendshapeValueNow = blendshapeValue;
    const float change = (blendshapeValueNow - blendshapeValueAtBake) * 0.01;
    position += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset) * change;
    normal += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset + 3) * change;
    tangent += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset + 6) * change;
}

void SpsGetBakedPosition(uint vertexId, out float3 position, out float3 normal, out float3 tangent, out float active) {
    const uint bakeIndex = 1 + vertexId * 10;
    position = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex);
    normal = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex + 3);
    tangent = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex + 6);
    active = SPS_TEX_FLOAT(_SPS_Bake, bakeIndex + 9);
    if (position.z < 0) active = 0;

    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape0, 0);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape1, 1);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape2, 2);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape3, 3);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape4, 4);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape5, 5);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape6, 6);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape7, 7);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape8, 8);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape9, 9);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape10, 10);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape11, 11);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape12, 12);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape13, 13);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape14, 14);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape15, 15);
}






// SPS Penetration Shader
void sps_apply_real(
	inout SPS_STRUCT_POSITION_TYPE vertex,
	inout SPS_STRUCT_NORMAL_TYPE normal,
	inout SPS_STRUCT_TANGENT_TYPE tangent,
	uint vertexId,
	inout SPS_STRUCT_COLOR_TYPE color
) {
	const float worldLength = _SPS_Length;
	const float3 origVertex = vertex.xyz;
	const float3 origNormal = normal.xyz;
	const float3 origTangent = tangent.xyz;
	float3 bakedVertex;
	float3 bakedNormal;
	float3 bakedTangent;
	float active;
	SpsGetBakedPosition(vertexId, bakedVertex, bakedNormal, bakedTangent, active);

	bakedVertex *= (_SPS_Length / _SPS_BakedLength);
	
	if (active == 0) return;

	float3 rootPos;
	int type = SPS_TYPE_INVALID;
	float3 frontNormal;
	sps_light_search(type, rootPos, frontNormal);
	if (type == SPS_TYPE_INVALID) return;

	float orfDistance = length(rootPos);
	float exitAngle = sps_angle_between(rootPos, float3(0,0,1));
	float entranceAngle = SPS_PI - sps_angle_between(frontNormal, rootPos);

	// Flip backward bidirectional rings
	if (type == SPS_TYPE_RING_TWOWAY && entranceAngle > SPS_PI/2) {
		frontNormal *= -1;
		entranceAngle = SPS_PI - entranceAngle;
	}

	// Decide if we should cancel deformation due to extreme angles, long distance, etc
	float bezierLerp;
	float dumbLerp;
	float shrinkLerp = 0;
	{
		float applyLerp = 1;
		// Cancel if base angle is too sharp
		const float allowedExitAngle = 0.6;
		const float exitAngleTooSharp = exitAngle > SPS_PI*allowedExitAngle ? 1 : 0;
		applyLerp = min(applyLerp, 1-exitAngleTooSharp);

		// Cancel if the entrance angle is too sharp
		if (type != SPS_TYPE_RING_TWOWAY) {
			const float allowedEntranceAngle = 0.8;
			const float entranceAngleTooSharp = entranceAngle > SPS_PI*allowedEntranceAngle ? 1 : 0;
			applyLerp = min(applyLerp, 1-entranceAngleTooSharp);
		}

		if (type == SPS_TYPE_HOLE) {
			// Uncancel if hilted in a hole
			const float hiltedSphereRadius = 0.5;
			const float inSphere = orfDistance > worldLength*hiltedSphereRadius ? 0 : 1;
			//const float hilted = min(isBehind, inSphere);
			//shrinkLerp = hilted;
			const float hilted = inSphere;
			applyLerp = max(applyLerp, hilted);
		} else {
			// Cancel if ring is near or behind base
			const float isBehind = rootPos.z > 0 ? 0 : 1;
			applyLerp = min(applyLerp, 1-isBehind);
		}

		// Cancel if too far away
		const float tooFar = sps_saturated_map(orfDistance, worldLength*1.2, worldLength*1.6);
		applyLerp = min(applyLerp, 1-tooFar);

		applyLerp = applyLerp * saturate(_SPS_Enabled);

		dumbLerp = sps_saturated_map(applyLerp, 0, 0.2) * active;
		bezierLerp = sps_saturated_map(applyLerp, 0, 1);
		shrinkLerp = sps_saturated_map(applyLerp, 0.8, 1) * shrinkLerp;
	}

	rootPos *= (1-shrinkLerp);
	orfDistance *= (1-shrinkLerp);

	float3 bezierPos;
	float3 bezierForward;
	float3 bezierRight;
	float3 bezierUp;
	float curveLength;
	if (length(rootPos) == 0) {
		bezierPos = float3(0,0,0);
		bezierForward = float3(0,0,1);
		bezierRight = float3(1,0,0);
		bezierUp = float3(0,1,0);
		curveLength = 0;
	} else{
		const float3 p0 = float3(0,0,0);
		const float p1Dist = min(orfDistance, max(worldLength / 8, rootPos.z / 4));
		const float p1DistWithPullout = sps_map(bezierLerp, 0, 1, worldLength * 5, p1Dist);
		const float3 p1 = float3(0,0,p1DistWithPullout);
		const float3 p2 = rootPos + frontNormal * p1Dist;
		const float3 p3 = rootPos;
		sps_bezierSolve(p0, p1, p2, p3, bakedVertex.z, curveLength, bezierPos, bezierForward, bezierUp);
		bezierRight = sps_normalize(cross(bezierUp, bezierForward));
	}

	// Handle holes and rings
	float holeShrink = 1;
	if (type == SPS_TYPE_RING_TWOWAY || type == SPS_TYPE_RING_ONEWAY) {
		if (bakedVertex.z >= curveLength) {
			// Straighten if past socket
			bezierPos += (bakedVertex.z - curveLength) * bezierForward;
		}
	} else {
		const float holeRecessDistance = worldLength * 0.05;
		const float holeRecessDistance2 = worldLength * 0.1;
		holeShrink = sps_saturated_map(
			bakedVertex.z,
			curveLength + holeRecessDistance2,
			curveLength + holeRecessDistance
		);
		if(_SPS_Overrun > 0) {
			if (bakedVertex.z >= curveLength + holeRecessDistance2) {
				// If way past socket, condense to point
				bezierPos += holeRecessDistance2 * bezierForward;
			} else if (bakedVertex.z >= curveLength) {
				// Straighten if past socket
				bezierPos += (bakedVertex.z - curveLength) * bezierForward;
			}
		}
	}

	float3 deformedVertex = bezierPos + bezierRight * bakedVertex.x * holeShrink + bezierUp * bakedVertex.y * holeShrink;
	vertex.xyz = lerp(origVertex, deformedVertex, dumbLerp);
	if (length(bakedNormal) != 0) {
		float3 deformedNormal = bezierRight * bakedNormal.x + bezierUp * bakedNormal.y + bezierForward * bakedNormal.z;
		normal.xyz = lerp(origNormal, deformedNormal, dumbLerp);
	}
	if (length(bakedTangent) != 0) {
		float3 deformedTangent = bezierRight * bakedTangent.x + bezierUp * bakedTangent.y + bezierForward * bakedTangent.z;
		tangent.xyz = lerp(origTangent, deformedTangent, dumbLerp);
	}
}

void sps_apply(inout SpsInputs o) {

	// When VERTEXLIGHT_ON is missing, there are no lights nearby, and the 4light arrays will be full of junk
	// Temporarily disable this check since apparently it causes some passes to not apply SPS
	//#ifdef VERTEXLIGHT_ON
	sps_apply_real(
		o.SPS_STRUCT_POSITION_NAME,
		o.SPS_STRUCT_NORMAL_NAME,
		o.SPS_STRUCT_TANGENT_NAME,
		o.SPS_STRUCT_SV_VertexID_NAME,
		o.SPS_STRUCT_COLOR_NAME
	);
	//#endif

}

VertexOut spsVert(
			#ifndef POI_TESSELLATED
			SpsInputs v
			#else
			tessAppData v
			#endif
			) {
  sps_apply(v);
  return vert(
			#ifndef POI_TESSELLATED
			(appdata)v
			#else
			v
			#endif
			);
}

			ENDCG
		
}
		Pass
		{

			Tags { "LightMode" = "ShadowCaster" }
			Stencil
			{
				Ref [_StencilRef]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
				Comp [_StencilCompareFunction]
				Pass [_StencilPassOp]
				Fail [_StencilFailOp]
				ZFail [_StencilZFailOp]
			}
			ZWrite [_ZWrite]
			Cull Back
			AlphaToMask Off
			ZTest [_ZTest]
			ColorMask RGBA
			Offset [_OffsetFactor], [_OffsetUnits]
			BlendOp [_BlendOp], [_BlendOpAlpha]
			Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
			CGPROGRAM

 #define MOCHIE_PBR 
 #define POI_MATCAP0 
 #define VIGNETTE_MASKED 
 #define _GLOSSYREFLECTIONS_OFF 
 #define _LIGHTINGMODE_FLAT 
 #define _RIM2STYLE_POIYOMI 
 #define _RIMSTYLE_POIYOMI 
 #define _STOCHASTICMODE_DELIOT_HEITZ 
 #define PROP_MATCAP 
 #define OPTIMIZER_ENABLED 
			#pragma target 5.0
			#pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED _MIXED_LIGHTING_SUBTRACTIVE
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#pragma multi_compile_instancing
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_fog
			#define POI_PASS_SHADOW
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "AutoLight.cginc"
			#include "UnityLightingCommon.cginc"
			#include "UnityPBSLighting.cginc"
			#ifdef POI_PASS_META
			#include "UnityMetaPass.cginc"
			#endif
			// #pragma vertex vert
#pragma vertex spsVert

			#pragma fragment frag
			#define DielectricSpec float4(0.04, 0.04, 0.04, 1.0 - 0.04)
			#define PI float(3.14159265359)
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex,samplertex,coord,dx,dy) tex.SampleGrad (sampler##samplertex,coord,dx,dy)
			#define POI_PAN_UV(uv, pan) (uv + _Time.x * pan)
			#define POI2D_SAMPLER_PAN(tex, texSampler, uv, pan) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, POI_PAN_UV(uv, pan)))
			#define POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, POI_PAN_UV(uv, pan), dx, dy))
			#define POI2D_SAMPLER(tex, texSampler, uv) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_GRAD(tex, texSampler, uv, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, uv, dx, dy))
			#define POI2D_PAN(tex, uv, pan) (tex2D(tex, POI_PAN_UV(uv, pan)))
			#define POI2D(tex, uv) (tex2D(tex, uv))
			#define POI_SAMPLE_TEX2D(tex, uv) (UNITY_SAMPLE_TEX2D(tex, uv))
			#define POI_SAMPLE_TEX2D_PAN(tex, uv, pan) (UNITY_SAMPLE_TEX2D(tex, POI_PAN_UV(uv, pan)))
			#define POI_SAFE_RGB0 float4(mainTexture.rgb * .0001, 0)
			#define POI_SAFE_RGB1 float4(mainTexture.rgb * .0001, 1)
			#define POI_SAFE_RGBA mainTexture
			#if defined(UNITY_COMPILER_HLSL)
			#define PoiInitStruct(type, name) name = (type)0;
			#else
			#define PoiInitStruct(type, name)
			#endif
			#define POI_ERROR(poiMesh, gridSize) lerp(float3(1, 0, 1), float3(0, 0, 0), fmod(floor((poiMesh.worldPos.x) * gridSize) + floor((poiMesh.worldPos.y) * gridSize) + floor((poiMesh.worldPos.z) * gridSize), 2) == 0)
			#define POI_NAN (asfloat(-1))
			#define POI_MODE_OPAQUE 0
			#define POI_MODE_CUTOUT 1
			#define POI_MODE_FADE 2
			#define POI_MODE_TRANSPARENT 3
			#define POI_MODE_ADDITIVE 4
			#define POI_MODE_SOFTADDITIVE 5
			#define POI_MODE_MULTIPLICATIVE 6
			#define POI_MODE_2XMULTIPLICATIVE 7
			#define POI_MODE_TRANSCLIPPING 9
			float _Mode;
			float _StochasticDeliotHeitzDensity;
			float _StochasticHexGridDensity;
			float _StochasticHexRotationStrength;
			float _StochasticHexFallOffContrast;
			float _StochasticHexFallOffPower;
			float _IgnoreFog;
			float _RenderingReduceClipDistance;
			float _AddBlendOp;
			float4 _Color;
			float _ColorThemeIndex;
			UNITY_DECLARE_TEX2D(_MainTex);
			UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
			float _MainPixelMode;
			float4 _MainTex_ST;
			float2 _MainTexPan;
			float _MainTexUV;
			float4 _MainTex_TexelSize;
			float _MainTexStochastic;
			#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _BumpMap;
			#endif
			float4 _BumpMap_ST;
			float2 _BumpMapPan;
			float _BumpMapUV;
			float _BumpScale;
			float _BumpMapStochastic;
			Texture2D _ClippingMask;
			float4 _ClippingMask_ST;
			float2 _ClippingMaskPan;
			float _ClippingMaskUV;
			float _Inverse_Clipping;
			float _Cutoff;
			SamplerState sampler_linear_clamp;
			SamplerState sampler_linear_repeat;
			float _AlphaForceOpaque;
			float _AlphaMod;
			float _AlphaPremultiply;
			float _AlphaBoostFA;
			float _AlphaGlobalMask;
			float _AlphaGlobalMaskBlendType;
			float _StereoEnabled;
			float _PolarUV;
			float2 _PolarCenter;
			float _PolarRadialScale;
			float _PolarLengthScale;
			float _PolarSpiralPower;
			float _PanoUseBothEyes;
			float _UVModWorldPos0;
			float _UVModWorldPos1;
			float _UVModLocalPos0;
			float _UVModLocalPos1;
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 color : COLOR;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				uint vertexId : SV_VertexID;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOut
			{
				float4 pos : SV_POSITION;
				float2 uv[4] : TEXCOORD0;
				float3 objNormal : TEXCOORD4;
				float3 normal : TEXCOORD5;
				float3 tangent : TEXCOORD6;
				float3 binormal : TEXCOORD7;
				float4 worldPos : TEXCOORD8;
				float4 localPos : TEXCOORD9;
				float3 objectPos : TEXCOORD10;
				float4 vertexColor : TEXCOORD11;
				float4 lightmapUV : TEXCOORD12;
				float4 grabPos: TEXCOORD13;
				float4 worldDirection: TEXCOORD14;
				float4 extra: TEXCOORD15;
				UNITY_SHADOW_COORDS(16)
				UNITY_FOG_COORDS(17)
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			struct PoiMesh
			{
				float3 normals[2];
				float3 objNormal;
				float3 tangentSpaceNormal;
				float3 binormal[2];
				float3 tangent[2];
				float3 worldPos;
				float3 localPos;
				float3 objectPosition;
				float isFrontFace;
				float4 vertexColor;
				float4 lightmapUV;
				float2 uv[9];
				float2 parallaxUV;
			};
			struct PoiCam
			{
				float3 viewDir;
				float3 forwardDir;
				float3 worldPos;
				float distanceToVert;
				float4 clipPos;
				float3 reflectionDir;
				float3 vertexReflectionDir;
				float3 tangentViewDir;
				float4 grabPos;
				float2 screenUV;
				float vDotN;
				float4 worldDirection;
			};
			struct PoiMods
			{
				float4 PBR; // smoothness, metallic, smoothness mask, metallic mask
				float4 Mask;
				float4 audioLink;
				float audioLinkAvailable;
				float audioLinkVersion;
				float4 audioLinkTexture;
				float audioLinkViaLuma;
				float2 detailMask;
				float2 backFaceDetailIntensity;
				float globalEmission;
				float4 globalColorTheme[12];
				float globalMask[16];
				float ALTime[8];
			};
			struct PoiLight
			{
				float3 direction;
				float attenuation;
				float attenuationStrength;
				float3 directColor;
				float3 indirectColor;
				float occlusion;
				float shadowMask;
				float detailShadow;
				float3 halfDir;
				float lightMap;
				float lightMapNoAttenuation;
				float3 rampedLightMap;
				float vertexNDotL;
				float nDotL;
				float nDotV;
				float vertexNDotV;
				float nDotH;
				float vertexNDotH;
				float lDotv;
				float lDotH;
				float nDotLSaturated;
				float nDotLNormalized;
				#ifdef POI_PASS_ADD
				float additiveShadow;
				#endif
				float3 finalLighting;
				float3 finalLightAdd;
				#if defined(VERTEXLIGHT_ON)
				float4 vDotNL;
				float4 vertexVDotNL;
				float3 vColor[4];
				float4 vCorrectedDotNL;
				float4 vAttenuation;
				float4 vAttenuationDotNL;
				float3 vPosition[4];
				float3 vDirection[4];
				float3 vFinalLighting;
				float3 vHalfDir[4];
				half4 vDotNH;
				half4 vertexVDotNH;
				half4 vDotLH;
				#endif
			};
			struct PoiVertexLights
			{
				float3 direction;
				float3 color;
				float attenuation;
			};
			struct PoiFragData
			{
				float3 baseColor;
				float3 finalColor;
				float alpha;
				float3 emission;
			};
			#ifndef glsl_mod
			#define glsl_mod(x, y) (((x) - (y) * floor((x) / (y))))
			#endif
			uniform float random_uniform_float_only_used_to_stop_compiler_warnings = 0.0f;
			float2 poiUV(float2 uv, float4 tex_st)
			{
				return uv * tex_st.xy + tex_st.zw;
			}
			float2 vertexUV(in VertexOut o, int index)
			{
				switch(index)
				{
					case 0:
					return o.uv[0];
					case 1:
					return o.uv[1];
					case 2:
					return o.uv[2];
					case 3:
					return o.uv[3];
					default:
					return o.uv[0];
				}
			}
			float2 vertexUV(in appdata v, int index)
			{
				switch(index)
				{
					case 0:
					return v.uv0;
					case 1:
					return v.uv1;
					case 2:
					return v.uv2;
					case 3:
					return v.uv3;
					default:
					return v.uv0;
				}
			}
			float calculateluminance(float3 color)
			{
				return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
			}
			float _VRChatCameraMode;
			float _VRChatMirrorMode;
			float VRCCameraMode()
			{
				return _VRChatCameraMode;
			}
			float VRCMirrorMode()
			{
				return _VRChatMirrorMode;
			}
			bool IsInMirror()
			{
				return unity_CameraProjection[2][0] != 0.f || unity_CameraProjection[2][1] != 0.f;
			}
			bool IsOrthographicCamera()
			{
				return unity_OrthoParams.w == 1 || UNITY_MATRIX_P[3][3] == 1;
			}
			float shEvaluateDiffuseL1Geomerics_local(float L0, float3 L1, float3 n)
			{
				float R0 = max(0, L0);
				float3 R1 = 0.5f * L1;
				float lenR1 = length(R1);
				float q = dot(normalize(R1), n) * 0.5 + 0.5;
				q = saturate(q); // Thanks to ScruffyRuffles for the bug identity.
				float p = 1.0f + 2.0f * lenR1 / R0;
				float a = (1.0f - lenR1 / R0) / (1.0f + lenR1 / R0);
				return R0 * (a + (1.0f - a) * (p + 1.0f) * pow(q, p));
			}
			half3 BetterSH9(half4 normal)
			{
				float3 indirect;
				float3 L0 = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) + float3(unity_SHBr.z, unity_SHBg.z, unity_SHBb.z) / 3.0;
				indirect.r = shEvaluateDiffuseL1Geomerics_local(L0.r, unity_SHAr.xyz, normal.xyz);
				indirect.g = shEvaluateDiffuseL1Geomerics_local(L0.g, unity_SHAg.xyz, normal.xyz);
				indirect.b = shEvaluateDiffuseL1Geomerics_local(L0.b, unity_SHAb.xyz, normal.xyz);
				indirect = max(0, indirect);
				indirect += SHEvalLinearL2(normal);
				return indirect;
			}
			float3 getCameraForward()
			{
				#if UNITY_SINGLE_PASS_STEREO
				float3 p1 = mul(unity_StereoCameraToWorld[0], float4(0, 0, 1, 1));
				float3 p2 = mul(unity_StereoCameraToWorld[0], float4(0, 0, 0, 1));
				#else
				float3 p1 = mul(unity_CameraToWorld, float4(0, 0, 1, 1)).xyz;
				float3 p2 = mul(unity_CameraToWorld, float4(0, 0, 0, 1)).xyz;
				#endif
				return normalize(p2 - p1);
			}
			half3 GetSHLength()
			{
				half3 x, x1;
				x.r = length(unity_SHAr);
				x.g = length(unity_SHAg);
				x.b = length(unity_SHAb);
				x1.r = length(unity_SHBr);
				x1.g = length(unity_SHBg);
				x1.b = length(unity_SHBb);
				return x + x1;
			}
			float3 BoxProjection(float3 direction, float3 position, float4 cubemapPosition, float3 boxMin, float3 boxMax)
			{
				#if UNITY_SPECCUBE_BOX_PROJECTION
				if (cubemapPosition.w > 0)
				{
					float3 factors = ((direction > 0 ? boxMax : boxMin) - position) / direction;
					float scalar = min(min(factors.x, factors.y), factors.z);
					direction = direction * scalar + (position - cubemapPosition.xyz);
				}
				#endif
				return direction;
			}
			float poiMax(float2 i)
			{
				return max(i.x, i.y);
			}
			float poiMax(float3 i)
			{
				return max(max(i.x, i.y), i.z);
			}
			float poiMax(float4 i)
			{
				return max(max(max(i.x, i.y), i.z), i.w);
			}
			float3 calculateNormal(in float3 baseNormal, in PoiMesh poiMesh, in Texture2D normalTexture, in float4 normal_ST, in float2 normalPan, in float normalUV, in float normalIntensity)
			{
				float3 normal = UnpackScaleNormal(POI2D_SAMPLER_PAN(normalTexture, _MainTex, poiUV(poiMesh.uv[normalUV], normal_ST), normalPan), normalIntensity);
				return normalize(
				normal.x * poiMesh.tangent[0] +
				normal.y * poiMesh.binormal[0] +
				normal.z * baseNormal
				);
			}
			float remap(float x, float minOld, float maxOld, float minNew = 0, float maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float2 remap(float2 x, float2 minOld, float2 maxOld, float2 minNew = 0, float2 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float3 remap(float3 x, float3 minOld, float3 maxOld, float3 minNew = 0, float3 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float4 remap(float4 x, float4 minOld, float4 maxOld, float4 minNew = 0, float4 maxNew = 1)
			{
				return minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld);
			}
			float remapClamped(float minOld, float maxOld, float x, float minNew = 0, float maxNew = 1)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float2 remapClamped(float2 minOld, float2 maxOld, float2 x, float2 minNew, float2 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float3 remapClamped(float3 minOld, float3 maxOld, float3 x, float3 minNew, float3 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float4 remapClamped(float4 minOld, float4 maxOld, float4 x, float4 minNew, float4 maxNew)
			{
				return clamp(minNew + (x - minOld) * (maxNew - minNew) / (maxOld - minOld), minNew, maxNew);
			}
			float2 calcParallax(in float height, in PoiCam poiCam)
			{
				return ((height * - 1) + 1) * (poiCam.tangentViewDir.xy / poiCam.tangentViewDir.z);
			}
			float4 poiBlend(const float sourceFactor, const  float4 sourceColor, const  float destinationFactor, const  float4 destinationColor, const float4 blendFactor)
			{
				float4 sA = 1 - blendFactor;
				const float4 blendData[11] = {
					float4(0.0, 0.0, 0.0, 0.0),
					float4(1.0, 1.0, 1.0, 1.0),
					destinationColor,
					sourceColor,
					float4(1.0, 1.0, 1.0, 1.0) - destinationColor,
					sA,
					float4(1.0, 1.0, 1.0, 1.0) - sourceColor,
					sA,
					float4(1.0, 1.0, 1.0, 1.0) - sA,
					saturate(sourceColor.aaaa),
					1 - sA,
				};
				return lerp(blendData[sourceFactor] * sourceColor + blendData[destinationFactor] * destinationColor, sourceColor, sA);
			}
			float blendAverage(float base, float blend)
			{
				return (base + blend) / 2.0;
			}
			float3 blendAverage(float3 base, float3 blend)
			{
				return (base + blend) / 2.0;
			}
			float blendColorBurn(float base, float blend)
			{
				return (blend == 0.0) ? blend : max((1.0 - ((1.0 - base) * rcp(random_uniform_float_only_used_to_stop_compiler_warnings + blend))), 0.0);
			}
			float3 blendColorBurn(float3 base, float3 blend)
			{
				return float3(blendColorBurn(base.r, blend.r), blendColorBurn(base.g, blend.g), blendColorBurn(base.b, blend.b));
			}
			float blendColorDodge(float base, float blend)
			{
				return (blend == 1.0) ? blend : min(base / (1.0 - blend), 1.0);
			}
			float3 blendColorDodge(float3 base, float3 blend)
			{
				return float3(blendColorDodge(base.r, blend.r), blendColorDodge(base.g, blend.g), blendColorDodge(base.b, blend.b));
			}
			float blendDarken(float base, float blend)
			{
				return min(blend, base);
			}
			float3 blendDarken(float3 base, float3 blend)
			{
				return float3(blendDarken(base.r, blend.r), blendDarken(base.g, blend.g), blendDarken(base.b, blend.b));
			}
			float blendExclusion(float base, float blend)
			{
				return base + blend - 2.0 * base * blend;
			}
			float3 blendExclusion(float3 base, float3 blend)
			{
				return base + blend - 2.0 * base * blend;
			}
			float blendReflect(float base, float blend)
			{
				return (blend == 1.0) ? blend : min(base * base / (1.0 - blend), 1.0);
			}
			float3 blendReflect(float3 base, float3 blend)
			{
				return float3(blendReflect(base.r, blend.r), blendReflect(base.g, blend.g), blendReflect(base.b, blend.b));
			}
			float blendGlow(float base, float blend)
			{
				return blendReflect(blend, base);
			}
			float3 blendGlow(float3 base, float3 blend)
			{
				return blendReflect(blend, base);
			}
			float blendOverlay(float base, float blend)
			{
				return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
			}
			float3 blendOverlay(float3 base, float3 blend)
			{
				return float3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
			}
			float blendHardLight(float base, float blend)
			{
				return blendOverlay(blend, base);
			}
			float3 blendHardLight(float3 base, float3 blend)
			{
				return blendOverlay(blend, base);
			}
			float blendVividLight(float base, float blend)
			{
				return (blend < 0.5) ? blendColorBurn(base, (2.0 * blend)) : blendColorDodge(base, (2.0 * (blend - 0.5)));
			}
			float3 blendVividLight(float3 base, float3 blend)
			{
				return float3(blendVividLight(base.r, blend.r), blendVividLight(base.g, blend.g), blendVividLight(base.b, blend.b));
			}
			float blendHardMix(float base, float blend)
			{
				return (blendVividLight(base, blend) < 0.5) ? 0.0 : 1.0;
			}
			float3 blendHardMix(float3 base, float3 blend)
			{
				return float3(blendHardMix(base.r, blend.r), blendHardMix(base.g, blend.g), blendHardMix(base.b, blend.b));
			}
			float blendLighten(float base, float blend)
			{
				return max(blend, base);
			}
			float3 blendLighten(float3 base, float3 blend)
			{
				return float3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
			}
			float blendLinearBurn(float base, float blend)
			{
				return max(base + blend - 1.0, 0.0);
			}
			float3 blendLinearBurn(float3 base, float3 blend)
			{
				return max(base + blend - float3(1.0, 1.0, 1.0), float3(0.0, 0.0, 0.0));
			}
			float blendLinearDodge(float base, float blend)
			{
				return min(base + blend, 1.0);
			}
			float3 blendLinearDodge(float3 base, float3 blend)
			{
				return min(base + blend, float3(1.0, 1.0, 1.0));
			}
			float blendLinearLight(float base, float blend)
			{
				return blend < 0.5 ? blendLinearBurn(base, (2.0 * blend)) : blendLinearDodge(base, (2.0 * (blend - 0.5)));
			}
			float3 blendLinearLight(float3 base, float3 blend)
			{
				return float3(blendLinearLight(base.r, blend.r), blendLinearLight(base.g, blend.g), blendLinearLight(base.b, blend.b));
			}
			float blendMultiply(float base, float blend)
			{
				return base * blend;
			}
			float3 blendMultiply(float3 base, float3 blend)
			{
				return base * blend;
			}
			float blendNegation(float base, float blend)
			{
				return 1.0 - abs(1.0 - base - blend);
			}
			float3 blendNegation(float3 base, float3 blend)
			{
				return float3(1.0, 1.0, 1.0) - abs(float3(1.0, 1.0, 1.0) - base - blend);
			}
			float blendNormal(float base, float blend)
			{
				return blend;
			}
			float3 blendNormal(float3 base, float3 blend)
			{
				return blend;
			}
			float blendPhoenix(float base, float blend)
			{
				return min(base, blend) - max(base, blend) + 1.0;
			}
			float3 blendPhoenix(float3 base, float3 blend)
			{
				return min(base, blend) - max(base, blend) + float3(1.0, 1.0, 1.0);
			}
			float blendPinLight(float base, float blend)
			{
				return (blend < 0.5) ? blendDarken(base, (2.0 * blend)) : blendLighten(base, (2.0 * (blend - 0.5)));
			}
			float3 blendPinLight(float3 base, float3 blend)
			{
				return float3(blendPinLight(base.r, blend.r), blendPinLight(base.g, blend.g), blendPinLight(base.b, blend.b));
			}
			float blendScreen(float base, float blend)
			{
				return 1.0 - ((1.0 - base) * (1.0 - blend));
			}
			float3 blendScreen(float3 base, float3 blend)
			{
				return float3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
			}
			float blendSoftLight(float base, float blend)
			{
				return (blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend));
			}
			float3 blendSoftLight(float3 base, float3 blend)
			{
				return float3(blendSoftLight(base.r, blend.r), blendSoftLight(base.g, blend.g), blendSoftLight(base.b, blend.b));
			}
			float blendSubtract(float base, float blend)
			{
				return max(base - blend, 0.0);
			}
			float3 blendSubtract(float3 base, float3 blend)
			{
				return max(base - blend, 0.0);
			}
			float blendDifference(float base, float blend)
			{
				return abs(base - blend);
			}
			float3 blendDifference(float3 base, float3 blend)
			{
				return abs(base - blend);
			}
			float blendDivide(float base, float blend)
			{
				return base / max(blend, 0.0001);
			}
			float3 blendDivide(float3 base, float3 blend)
			{
				return base / max(blend, 0.0001);
			}
			float blendMixed(float base, float blend)
			{
				return base + base * blend;
			}
			float3 blendMixed(float3 base, float3 blend)
			{
				return base + base * blend;
			}
			float3 customBlend(float3 base, float3 blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					case 6: return blendScreen(base, blend); break;
					case 8: return blendLinearDodge(base, blend); break;
					case 9: return blendOverlay(base, blend); break;
					case 20: return blendMixed(base, blend); break;
					default: return 0; break;
				}
			}
			float customBlend(float base, float blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					case 6: return blendScreen(base, blend); break;
					case 8: return blendLinearDodge(base, blend); break;
					case 9: return blendOverlay(base, blend); break;
					case 20: return blendMixed(base, blend); break;
					default: return 0; break;
				}
			}
			float3 customBlend(float3 base, float3 blend, float blendType, float alpha)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 8: output = lerp(base, blendLinearDodge(base, blend), alpha); break;
					case 9: output = lerp(base, blendOverlay(base, blend), alpha); break;
					case 20: output = lerp(base, blendMixed(base, blend), alpha); break;
					default: output = 0; break;
				}
				return output;
			}
			#define REPLACE 0
			#define SUBSTRACT 1
			#define MULTIPLY 2
			#define DIVIDE 3
			#define MIN 4
			#define MAX 5
			#define AVERAGE 6
			#define ADD 7
			float maskBlend(float baseMask, float blendMask, float blendType)
			{
				float output = 0;
				switch(blendType)
				{
					case REPLACE: output = blendMask; break;
					case SUBSTRACT: output = baseMask - blendMask; break;
					case MULTIPLY: output = baseMask * blendMask; break;
					case DIVIDE: output = baseMask / blendMask; break;
					case MIN: output = min(baseMask, blendMask); break;
					case MAX: output = max(baseMask, blendMask); break;
					case AVERAGE: output = (baseMask + blendMask) * 0.5; break;
					case ADD: output = baseMask + blendMask; break;
				}
				return saturate(output);
			}
			float random(float2 p)
			{
				return frac(sin(dot(p, float2(12.9898, 78.2383))) * 43758.5453123);
			}
			float2 random2(float2 p)
			{
				return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
			}
			float3 random3(float2 p)
			{
				return frac(sin(float3(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)), dot(p, float2(248.3, 315.9)))) * 43758.5453);
			}
			float3 random3(float3 p)
			{
				return frac(sin(float3(dot(p, float3(127.1, 311.7, 248.6)), dot(p, float3(269.5, 183.3, 423.3)), dot(p, float3(248.3, 315.9, 184.2)))) * 43758.5453);
			}
			float3 randomFloat3(float2 Seed, float maximum)
			{
				return (.5 + float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed), float2(12.9898, 78.233))) * 43758.5453)
				) * .5) * (maximum);
			}
			float3 randomFloat3Range(float2 Seed, float Range)
			{
				return (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1) * Range;
			}
			float3 randomFloat3WiggleRange(float2 Seed, float Range, float wiggleSpeed)
			{
				float3 rando = (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1);
				float speed = 1 + wiggleSpeed;
				return float3(sin((_Time.x + rando.x * PI) * speed), sin((_Time.x + rando.y * PI) * speed), sin((_Time.x + rando.z * PI) * speed)) * Range;
			}
			void poiDither(float4 In, float4 ScreenPosition, out float4 Out)
			{
				float2 uv = ScreenPosition.xy * _ScreenParams.xy;
				float DITHER_THRESHOLDS[16] = {
					1.0 / 17.0, 9.0 / 17.0, 3.0 / 17.0, 11.0 / 17.0,
					13.0 / 17.0, 5.0 / 17.0, 15.0 / 17.0, 7.0 / 17.0,
					4.0 / 17.0, 12.0 / 17.0, 2.0 / 17.0, 10.0 / 17.0,
					16.0 / 17.0, 8.0 / 17.0, 14.0 / 17.0, 6.0 / 17.0
				};
				uint index = (uint(uv.x) % 4) * 4 + uint(uv.y) % 4;
				Out = In - DITHER_THRESHOLDS[index];
			}
			static const float Epsilon = 1e-10;
			static const float3 HCYwts = float3(0.299, 0.587, 0.114);
			static const float HCLgamma = 3;
			static const float HCLy0 = 100;
			static const float HCLmaxL = 0.530454533953517; // == exp(HCLgamma / HCLy0) - 0.5
			static const float3 wref = float3(1.0, 1.0, 1.0);
			#define TAU 6.28318531
			float3 HUEtoRGB(in float H)
			{
				float R = abs(H * 6 - 3) - 1;
				float G = 2 - abs(H * 6 - 2);
				float B = 2 - abs(H * 6 - 4);
				return saturate(float3(R, G, B));
			}
			float3 RGBtoHCV(in float3 RGB)
			{
				float4 P = (RGB.g < RGB.b) ? float4(RGB.bg, -1.0, 2.0 / 3.0) : float4(RGB.gb, 0.0, -1.0 / 3.0);
				float4 Q = (RGB.r < P.x) ? float4(P.xyw, RGB.r) : float4(RGB.r, P.yzx);
				float C = Q.x - min(Q.w, Q.y);
				float H = abs((Q.w - Q.y) / (6 * C + Epsilon) + Q.z);
				return float3(H, C, Q.x);
			}
			float3 HSVtoRGB(in float3 HSV)
			{
				float3 RGB = HUEtoRGB(HSV.x);
				return ((RGB - 1) * HSV.y + 1) * HSV.z;
			}
			float3 RGBtoHSV(in float3 RGB)
			{
				float3 HCV = RGBtoHCV(RGB);
				float S = HCV.y / (HCV.z + Epsilon);
				return float3(HCV.x, S, HCV.z);
			}
			float3 HSLtoRGB(in float3 HSL)
			{
				float3 RGB = HUEtoRGB(HSL.x);
				float C = (1 - abs(2 * HSL.z - 1)) * HSL.y;
				return (RGB - 0.5) * C + HSL.z;
			}
			float3 RGBtoHSL(in float3 RGB)
			{
				float3 HCV = RGBtoHCV(RGB);
				float L = HCV.z - HCV.y * 0.5;
				float S = HCV.y / (1 - abs(L * 2 - 1) + Epsilon);
				return float3(HCV.x, S, L);
			}
			void DecomposeHDRColor(in float3 linearColorHDR, out float3 baseLinearColor, out float exposure)
			{
				float maxColorComponent = max(linearColorHDR.r, max(linearColorHDR.g, linearColorHDR.b));
				bool isSDR = maxColorComponent <= 1.0;
				float scaleFactor = isSDR ? 1.0 : (1.0 / maxColorComponent);
				exposure = isSDR ? 0.0 : log(maxColorComponent) * 1.44269504089; // ln(2)
				baseLinearColor = scaleFactor * linearColorHDR;
			}
			float3 ApplyHDRExposure(float3 linearColor, float exposure)
			{
				return linearColor * pow(2, exposure);
			}
			float3 ModifyViaHSV(float3 color, float h, float s, float v)
			{
				float3 colorHSV = RGBtoHSV(color);
				colorHSV.x = frac(colorHSV.x + h);
				colorHSV.y = saturate(colorHSV.y + s);
				colorHSV.z = saturate(colorHSV.z + v);
				return HSVtoRGB(colorHSV);
			}
			float3 ModifyViaHSV(float3 color, float3 HSVMod)
			{
				return ModifyViaHSV(color, HSVMod.x, HSVMod.y, HSVMod.z);
			}
			float3 hueShift(float3 color, float hueOffset)
			{
				color = RGBtoHSV(color);
				color.x = frac(hueOffset +color.x);
				return HSVtoRGB(color);
			}
			float xyzF(float t)
			{
				return lerp(pow(t, 1. / 3.), 7.787037 * t + 0.139731, step(t, 0.00885645));
			}
			float xyzR(float t)
			{
				return lerp(t * t * t, 0.1284185 * (t - 0.139731), step(t, 0.20689655));
			}
			float4x4 poiRotationMatrixFromAngles(float x, float y, float z)
			{
				float angleX = radians(x);
				float c = cos(angleX);
				float s = sin(angleX);
				float4x4 rotateXMatrix = float4x4(1, 0, 0, 0,
				0, c, -s, 0,
				0, s, c, 0,
				0, 0, 0, 1);
				float angleY = radians(y);
				c = cos(angleY);
				s = sin(angleY);
				float4x4 rotateYMatrix = float4x4(c, 0, s, 0,
				0, 1, 0, 0,
				- s, 0, c, 0,
				0, 0, 0, 1);
				float angleZ = radians(z);
				c = cos(angleZ);
				s = sin(angleZ);
				float4x4 rotateZMatrix = float4x4(c, -s, 0, 0,
				s, c, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1);
				return mul(mul(rotateXMatrix, rotateYMatrix), rotateZMatrix);
			}
			float4x4 poiRotationMatrixFromAngles(float3 angles)
			{
				float angleX = radians(angles.x);
				float c = cos(angleX);
				float s = sin(angleX);
				float4x4 rotateXMatrix = float4x4(1, 0, 0, 0,
				0, c, -s, 0,
				0, s, c, 0,
				0, 0, 0, 1);
				float angleY = radians(angles.y);
				c = cos(angleY);
				s = sin(angleY);
				float4x4 rotateYMatrix = float4x4(c, 0, s, 0,
				0, 1, 0, 0,
				- s, 0, c, 0,
				0, 0, 0, 1);
				float angleZ = radians(angles.z);
				c = cos(angleZ);
				s = sin(angleZ);
				float4x4 rotateZMatrix = float4x4(c, -s, 0, 0,
				s, c, 0, 0,
				0, 0, 1, 0,
				0, 0, 0, 1);
				return mul(mul(rotateXMatrix, rotateYMatrix), rotateZMatrix);
			}
			float3 getCameraPosition()
			{
				#ifdef USING_STEREO_MATRICES
				return lerp(unity_StereoWorldSpaceCameraPos[0], unity_StereoWorldSpaceCameraPos[1], 0.5);
				#endif
				return _WorldSpaceCameraPos;
			}
			half2 calcScreenUVs(half4 grabPos)
			{
				half2 uv = grabPos.xy / (grabPos.w + 0.0000000001);
				#if UNITY_SINGLE_PASS_STEREO
				uv.xy *= half2(_ScreenParams.x * 2, _ScreenParams.y);
				#else
				uv.xy *= _ScreenParams.xy;
				#endif
				return uv;
			}
			float CalcMipLevel(float2 texture_coord)
			{
				float2 dx = ddx(texture_coord);
				float2 dy = ddy(texture_coord);
				float delta_max_sqr = max(dot(dx, dx), dot(dy, dy));
				return 0.5 * log2(delta_max_sqr);
			}
			float inverseLerp(float A, float B, float T)
			{
				return (T - A) / (B - A);
			}
			float inverseLerp2(float2 a, float2 b, float2 value)
			{
				float2 AB = b - a;
				float2 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float inverseLerp3(float3 a, float3 b, float3 value)
			{
				float3 AB = b - a;
				float3 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float inverseLerp4(float4 a, float4 b, float4 value)
			{
				float4 AB = b - a;
				float4 AV = value - a;
				return dot(AV, AB) / dot(AB, AB);
			}
			float4 quaternion_conjugate(float4 v)
			{
				return float4(
				v.x, -v.yzw
				);
			}
			float4 quaternion_mul(float4 v1, float4 v2)
			{
				float4 result1 = (v1.x * v2 + v1 * v2.x);
				float4 result2 = float4(
				- dot(v1.yzw, v2.yzw),
				cross(v1.yzw, v2.yzw)
				);
				return float4(result1 + result2);
			}
			float4 get_quaternion_from_angle(float3 axis, float angle)
			{
				float sn = sin(angle * 0.5);
				float cs = cos(angle * 0.5);
				return float4(axis * sn, cs);
			}
			float4 quaternion_from_vector(float3 inVec)
			{
				return float4(0.0, inVec);
			}
			float degree_to_radius(float degree)
			{
				return (
				degree / 180.0 * PI
				);
			}
			float3 rotate_with_quaternion(float3 inVec, float3 rotation)
			{
				float4 qx = get_quaternion_from_angle(float3(1, 0, 0), radians(rotation.x));
				float4 qy = get_quaternion_from_angle(float3(0, 1, 0), radians(rotation.y));
				float4 qz = get_quaternion_from_angle(float3(0, 0, 1), radians(rotation.z));
				#define MUL3(A, B, C) quaternion_mul(quaternion_mul((A), (B)), (C))
				float4 quaternion = normalize(MUL3(qx, qy, qz));
				float4 conjugate = quaternion_conjugate(quaternion);
				float4 inVecQ = quaternion_from_vector(inVec);
				float3 rotated = (
				MUL3(quaternion, inVecQ, conjugate)
				).yzw;
				return rotated;
			}
			float4 transform(float4 input, float4 pos, float4 rotation, float4 scale)
			{
				input.rgb *= (scale.xyz * scale.w);
				input = float4(rotate_with_quaternion(input.xyz, rotation.xyz * rotation.w) + (pos.xyz * pos.w), input.w);
				return input;
			}
			float2 RotateUV(float2 _uv, float _radian, float2 _piv, float _time)
			{
				float RotateUV_ang = _radian;
				float RotateUV_cos = cos(_time * RotateUV_ang);
				float RotateUV_sin = sin(_time * RotateUV_ang);
				return (mul(_uv - _piv, float2x2(RotateUV_cos, -RotateUV_sin, RotateUV_sin, RotateUV_cos)) + _piv);
			}
			float3 poiThemeColor(in PoiMods poiMods, in float3 srcColor, in float themeIndex)
			{
				if (themeIndex == 0) return srcColor;
				themeIndex -= 1;
				if (themeIndex <= 3)
				{
					return poiMods.globalColorTheme[themeIndex];
				}
				#ifdef POI_AUDIOLINK
				if (poiMods.audioLinkAvailable)
				{
					return poiMods.globalColorTheme[themeIndex];
				}
				#endif
				return srcColor;
			}
			float3 lilToneCorrection(float3 c, float4 hsvg)
			{
				c = pow(abs(c), hsvg.w);
				float4 p = (c.b > c.g) ? float4(c.bg, -1.0, 2.0 / 3.0) : float4(c.gb, 0.0, -1.0 / 3.0);
				float4 q = (p.x > c.r) ? float4(p.xyw, c.r) : float4(c.r, p.yzx);
				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				float3 hsv = float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
				hsv = float3(hsv.x + hsvg.x, saturate(hsv.y * hsvg.y), saturate(hsv.z * hsvg.z));
				return hsv.z - hsv.z * hsv.y + hsv.z * hsv.y * saturate(abs(frac(hsv.x + float3(1.0, 2.0 / 3.0, 1.0 / 3.0)) * 6.0 - 3.0) - 1.0);
			}
			float lilIsIn0to1(float f)
			{
				float value = 0.5 - abs(f - 0.5);
				return saturate(value / clamp(fwidth(value), 0.0001, 1.0));
			}
			float lilIsIn0to1(float f, float nv)
			{
				float value = 0.5 - abs(f - 0.5);
				return saturate(value / clamp(fwidth(value), 0.0001, nv));
			}
			float poiEdgeLinearNoSaturate(float value, float border)
			{
				return (value - border) / clamp(fwidth(value), 0.0001, 1.0);
			}
			float3 poiEdgeLinearNoSaturate(float value, float3 border)
			{
				return float3(
				(value - border.x) / clamp(fwidth(value), 0.0001, 1.0),
				(value - border.y) / clamp(fwidth(value), 0.0001, 1.0),
				(value - border.z) / clamp(fwidth(value), 0.0001, 1.0)
				);
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur)
			{
				float borderMin = saturate(border - blur * 0.5);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / saturate(borderMax - borderMin + fwidth(value));
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / saturate(borderMax - borderMin + fwidth(value));
			}
			float poiEdgeNonLinearNoSaturate(float value, float border)
			{
				float fwidthValue = fwidth(value);
				return smoothstep(border - fwidthValue, border + fwidthValue, value);
			}
			float poiEdgeNonLinearNoSaturate(float value, float border, float blur)
			{
				float fwidthValue = fwidth(value);
				float borderMin = saturate(border - blur * 0.5);
				float borderMax = saturate(border + blur * 0.5);
				return smoothstep(borderMin - fwidthValue, borderMax + fwidthValue, value);
			}
			float poiEdgeNonLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float fwidthValue = fwidth(value);
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return smoothstep(borderMin - fwidthValue, borderMax + fwidthValue, value);
			}
			float poiEdgeNonLinear(float value, float border)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border));
			}
			float poiEdgeNonLinear(float value, float border, float blur)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border, blur));
			}
			float poiEdgeNonLinear(float value, float border, float blur, float borderRange)
			{
				return saturate(poiEdgeNonLinearNoSaturate(value, border, blur, borderRange));
			}
			float poiEdgeLinear(float value, float border)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border));
			}
			float poiEdgeLinear(float value, float border, float blur)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border, blur));
			}
			float poiEdgeLinear(float value, float border, float blur, float borderRange)
			{
				return saturate(poiEdgeLinearNoSaturate(value, border, blur, borderRange));
			}
			float3 OpenLitLinearToSRGB(float3 col)
			{
				return LinearToGammaSpace(col);
			}
			float3 OpenLitSRGBToLinear(float3 col)
			{
				return GammaToLinearSpace(col);
			}
			float OpenLitLuminance(float3 rgb)
			{
				#if defined(UNITY_COLORSPACE_GAMMA)
				return dot(rgb, float3(0.22, 0.707, 0.071));
				#else
				return dot(rgb, float3(0.0396819152, 0.458021790, 0.00609653955));
				#endif
			}
			float OpenLitGray(float3 rgb)
			{
				return dot(rgb, float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
			}
			void OpenLitShadeSH9ToonDouble(float3 lightDirection, out float3 shMax, out float3 shMin)
			{
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 N = lightDirection * 0.666666;
				float4 vB = N.xyzz * N.yzzx;
				float3 res = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
				res.r += dot(unity_SHBr, vB);
				res.g += dot(unity_SHBg, vB);
				res.b += dot(unity_SHBb, vB);
				res += unity_SHC.rgb * (N.x * N.x - N.y * N.y);
				float3 l1;
				l1.r = dot(unity_SHAr.rgb, N);
				l1.g = dot(unity_SHAg.rgb, N);
				l1.b = dot(unity_SHAb.rgb, N);
				shMax = res + l1;
				shMin = res - l1;
				#if defined(UNITY_COLORSPACE_GAMMA)
				shMax = OpenLitLinearToSRGB(shMax);
				shMin = OpenLitLinearToSRGB(shMin);
				#endif
				#else
				shMax = 0.0;
				shMin = 0.0;
				#endif
			}
			float3 OpenLitComputeCustomLightDirection(float4 lightDirectionOverride)
			{
				float3 customDir = length(lightDirectionOverride.xyz) * normalize(mul((float3x3)unity_ObjectToWorld, lightDirectionOverride.xyz));
				return lightDirectionOverride.w ? customDir : lightDirectionOverride.xyz; // .w isn't doc'd anywhere and is always 0 unless end user changes it
			}
			float3 OpenLitLightingDirectionForSH9()
			{
				float3 mainDir = _WorldSpaceLightPos0.xyz * OpenLitLuminance(_LightColor0.rgb);
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 sh9Dir = unity_SHAr.xyz * 0.333333 + unity_SHAg.xyz * 0.333333 + unity_SHAb.xyz * 0.333333;
				float3 sh9DirAbs = float3(sh9Dir.x, abs(sh9Dir.y), sh9Dir.z);
				#else
				float3 sh9Dir = 0;
				float3 sh9DirAbs = 0;
				#endif
				float3 lightDirectionForSH9 = sh9Dir + mainDir;
				lightDirectionForSH9 = dot(lightDirectionForSH9, lightDirectionForSH9) < 0.000001 ? 0 : normalize(lightDirectionForSH9);
				return lightDirectionForSH9;
			}
			float3 OpenLitLightingDirection(float4 lightDirectionOverride)
			{
				float3 mainDir = _WorldSpaceLightPos0.xyz * OpenLitLuminance(_LightColor0.rgb);
				#if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
				float3 sh9Dir = unity_SHAr.xyz * 0.333333 + unity_SHAg.xyz * 0.333333 + unity_SHAb.xyz * 0.333333;
				float3 sh9DirAbs = float3(sh9Dir.x, abs(sh9Dir.y), sh9Dir.z);
				#else
				float3 sh9Dir = 0;
				float3 sh9DirAbs = 0;
				#endif
				float3 customDir = OpenLitComputeCustomLightDirection(lightDirectionOverride);
				return normalize(sh9DirAbs + mainDir + customDir);
			}
			float3 OpenLitLightingDirection()
			{
				float4 customDir = float4(0.001, 0.002, 0.001, 0.0);
				return OpenLitLightingDirection(customDir);
			}
			inline float4 CalculateFrustumCorrection()
			{
				float x1 = -UNITY_MATRIX_P._31 / (UNITY_MATRIX_P._11 * UNITY_MATRIX_P._34);
				float x2 = -UNITY_MATRIX_P._32 / (UNITY_MATRIX_P._22 * UNITY_MATRIX_P._34);
				return float4(x1, x2, 0, UNITY_MATRIX_P._33 / UNITY_MATRIX_P._34 + x1 * UNITY_MATRIX_P._13 + x2 * UNITY_MATRIX_P._23);
			}
			inline float CorrectedLinearEyeDepth(float z, float B)
			{
				return 1.0 / (z / UNITY_MATRIX_P._34 + B);
			}
			float2 sharpSample(float4 texelSize, float2 p)
			{
				p = p * texelSize.zw;
				float2 c = max(0.0, fwidth(p));
				p = floor(p) + saturate(frac(p) / c);
				p = (p - 0.5) * texelSize.xy;
				return p;
			}
			void applyToGlobalMask(inout PoiMods poiMods, int index, int blendType, float val)
			{
				float valBlended = saturate(maskBlend(poiMods.globalMask[index], val, blendType));
				switch(index)
				{
					case 0: poiMods.globalMask[0] = valBlended; break;
					case 1: poiMods.globalMask[1] = valBlended; break;
					case 2: poiMods.globalMask[2] = valBlended; break;
					case 3: poiMods.globalMask[3] = valBlended; break;
					case 4: poiMods.globalMask[4] = valBlended; break;
					case 5: poiMods.globalMask[5] = valBlended; break;
					case 6: poiMods.globalMask[6] = valBlended; break;
					case 7: poiMods.globalMask[7] = valBlended; break;
					case 8: poiMods.globalMask[8] = valBlended; break;
					case 9: poiMods.globalMask[9] = valBlended; break;
					case 10: poiMods.globalMask[10] = valBlended; break;
					case 11: poiMods.globalMask[11] = valBlended; break;
					case 12: poiMods.globalMask[12] = valBlended; break;
					case 13: poiMods.globalMask[13] = valBlended; break;
					case 14: poiMods.globalMask[14] = valBlended; break;
					case 15: poiMods.globalMask[15] = valBlended; break;
				}
			}
			void assignValueToVectorFromIndex(inout float4 vec, int index, float value)
			{
				switch(index)
				{
					case 0: vec[0] = value; break;
					case 1: vec[1] = value; break;
					case 2: vec[2] = value; break;
					case 3: vec[3] = value; break;
				}
			}
			float3 mod289(float3 x)
			{
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			float2 mod289(float2 x)
			{
				return x - floor(x * (1.0 / 289.0)) * 289.0;
			}
			float3 permute(float3 x)
			{
				return mod289(((x * 34.0) + 1.0) * x);
			}
			float snoise(float2 v)
			{
				const float4 C = float4(0.211324865405187, // (3.0-sqrt(3.0))/6.0
				0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
				- 0.577350269189626, // -1.0 + 2.0 * C.x
				0.024390243902439); // 1.0 / 41.0
				float2 i = floor(v + dot(v, C.yy));
				float2 x0 = v - i + dot(i, C.xx);
				float2 i1;
				i1 = (x0.x > x0.y) ? float2(1.0, 0.0) : float2(0.0, 1.0);
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod289(i); // Avoid truncation effects in permutation
				float3 p = permute(permute(i.y + float3(0.0, i1.y, 1.0))
				+ i.x + float3(0.0, i1.x, 1.0));
				float3 m = max(0.5 - float3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), 0.0);
				m = m * m ;
				m = m * m ;
				float3 x = 2.0 * frac(p * C.www) - 1.0;
				float3 h = abs(x) - 0.5;
				float3 ox = floor(x + 0.5);
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * (a0 * a0 + h * h);
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot(m, g);
			}
			VertexOut vert(
			#ifndef POI_TESSELLATED
			appdata v
			#else
			tessAppData v
			#endif
			)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				VertexOut o;
				PoiInitStruct(VertexOut, o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				#ifdef POI_TESSELLATED
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(v);
				#endif
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.objectPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				o.objNormal = v.normal;
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.tangent = UnityObjectToWorldDir(v.tangent);
				o.binormal = cross(o.normal, o.tangent) * (v.tangent.w * unity_WorldTransformParams.w);
				o.vertexColor = v.color;
				o.uv[0] = v.uv0;
				o.uv[1] = v.uv1;
				o.uv[2] = v.uv2;
				o.uv[3] = v.uv3;
				#if defined(LIGHTMAP_ON)
				o.lightmapUV.xy = v.uv1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				#ifdef DYNAMICLIGHTMAP_ON
				o.lightmapUV.zw = v.uv2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif
				o.localPos = v.vertex;
				o.worldPos = mul(unity_ObjectToWorld, o.localPos);
				float3 localOffset = float3(0, 0, 0);
				float3 worldOffset = float3(0, 0, 0);
				o.localPos.rgb += localOffset;
				o.worldPos.rgb += worldOffset;
				o.pos = UnityObjectToClipPos(o.localPos);
				#ifdef POI_PASS_OUTLINE
				#if defined(UNITY_REVERSED_Z)
				o.pos.z += _Offset_Z * - 0.01;
				#else
				o.pos.z += _Offset_Z * 0.01;
				#endif
				#endif
				o.grabPos = ComputeGrabScreenPos(o.pos);
				#ifndef FORWARD_META_PASS
				#if !defined(UNITY_PASS_SHADOWCASTER)
				UNITY_TRANSFER_SHADOW(o, o.uv[0].xy);
				#else
				v.vertex.xyz = o.localPos.xyz;
				TRANSFER_SHADOW_CASTER_NOPOS(o, o.pos);
				#endif
				#endif
				UNITY_TRANSFER_FOG(o, o.pos);
				if (0.0)
				{
					if (o.pos.w < _ProjectionParams.y * 1.01 && o.pos.w > 0)
					{
						o.pos.z = o.pos.z * 0.0001 + o.pos.w * 0.999;
					}
				}
				#ifdef POI_PASS_META
				o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
				#endif
				#if defined(GRAIN)
				float4 worldDirection;
				worldDirection.xyz = o.worldPos.xyz - _WorldSpaceCameraPos;
				worldDirection.w = dot(o.pos, CalculateFrustumCorrection());
				o.worldDirection = worldDirection;
				#endif
				return o;
			}
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, uv) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan)) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if defined(_STOCHASTICMODE_HEXTILE)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, uv, false) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), false) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? HextileSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), false, dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#ifndef POI2D_SAMPLER_STOCHASTIC
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (POI2D_SAMPLER(tex, texSampler, uv))
			#endif
			#ifndef POI2D_SAMPLER_PAN_STOCHASTIC
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#endif
			#ifndef POI2D_SAMPLER_PANGRAD_STOCHASTIC
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if !defined(_STOCHASTICMODE_NONE)
			float2 StochasticHash2D2D (float2 s)
			{
				return frac(sin(glsl_mod(float2(dot(s, float2(127.1,311.7)), dot(s, float2(269.5,183.3))), 3.14159)) * 43758.5453);
			}
			#endif
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			float3x3 DeliotHeitzStochasticUVBW(float2 uv)
			{
				const float2x2 stochasticSkewedGrid = float2x2(1.0, -0.57735027, 0.0, 1.15470054);
				float2 skewUV = mul(stochasticSkewedGrid, uv * 3.4641 * 1.0);
				float2 vxID = floor(skewUV);
				float3 bary = float3(frac(skewUV), 0);
				bary.z = 1.0 - bary.x - bary.y;
				float3x3 pos = float3x3(
				float3(vxID, 				bary.z),
				float3(vxID + float2(0, 1), bary.y),
				float3(vxID + float2(1, 0), bary.x)
				);
				float3x3 neg = float3x3(
				float3(vxID + float2(1, 1), 	 -bary.z),
				float3(vxID + float2(1, 0), 1.0 - bary.y),
				float3(vxID + float2(0, 1), 1.0 - bary.x)
				);
				return (bary.z > 0) ? pos : neg;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, float2 dx, float2 dy)
			{
				float3x3 UVBW = DeliotHeitzStochasticUVBW(uv);
				return 	mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[0].xy), dx, dy), UVBW[0].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[1].xy), dx, dy), UVBW[1].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[2].xy), dx, dy), UVBW[2].z) ;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv)
			{
				float2 dx = ddx(uv), dy = ddy(uv);
				return DeliotHeitzSampleTexture(tex, texSampler, uv, dx, dy);
			}
			#endif // defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#if defined(_STOCHASTICMODE_HEXTILE)
			float2 HextileMakeCenUV(float2 vertex)
			{
				const float2x2 stochasticInverseSkewedGrid = float2x2(1.0, 0.5, 0.0, 1.0/1.15470054);
				return mul(stochasticInverseSkewedGrid, vertex) * 0.288675;
			}
			float2x2 HextileLoadRot2x2(float2 idx, float rotStrength)
			{
				float angle = abs(idx.x * idx.y) + abs(idx.x + idx.y) + PI;
				angle = glsl_mod(angle, 2 * PI);
				if(angle < 0)  angle += 2 * PI;
				if(angle > PI) angle -= 2 * PI;
				angle *= rotStrength;
				float cs = cos(angle), si = sin(angle);
				return float2x2(cs, -si, si, cs);
			}
			float4x4 HextileUVBWR(float2 uv)
			{
				const float2x2 stochasticSkewedGrid = float2x2(1.0, -0.57735027, 0.0, 1.15470054);
				float2 skewedCoord = mul(stochasticSkewedGrid, uv * 3.4641 * 1.0);
				float2 baseId = float2(floor(skewedCoord));
				float3 temp = float3(frac(skewedCoord), 0);
				temp.z = 1 - temp.x - temp.y;
				float s = step(0.0, -temp.z);
				float s2 = 2 * s - 1;
				float3 weights = float3(-temp.z * s2, s - temp.y * s2, s - temp.x * s2);
				float2 vertex0 = baseId + float2(s, s);
				float2 vertex1 = baseId + float2(s, 1 - s);
				float2 vertex2 = baseId + float2(1 - s, s);
				float2 cen0 = HextileMakeCenUV(vertex0), cen1 = HextileMakeCenUV(vertex1), cen2 = HextileMakeCenUV(vertex2);
				float2x2 rot0 = float2x2(1, 0, 0, 1), rot1 = float2x2(1, 0, 0, 1), rot2 = float2x2(1, 0, 0, 1);
				if(0.0 > 0)
				{
					rot0 = HextileLoadRot2x2(vertex0, 0.0);
					rot1 = HextileLoadRot2x2(vertex1, 0.0);
					rot2 = HextileLoadRot2x2(vertex2, 0.0);
				}
				return float4x4(
				float4(mul(uv - cen0, rot0) + cen0 + StochasticHash2D2D(vertex0), rot0[0].x, -rot0[0].y),
				float4(mul(uv - cen1, rot1) + cen1 + StochasticHash2D2D(vertex1), rot1[0].x, -rot1[0].y),
				float4(mul(uv - cen2, rot2) + cen2 + StochasticHash2D2D(vertex2), rot2[0].x, -rot2[0].y),
				float4(weights, 0)
				);
			}
			float4 HextileSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, bool isNormalMap, float2 dUVdx, float2 dUVdy)
			{
				float4x4 UVBWR = HextileUVBWR(uv);
				float2x2 rot0 = float2x2(1, 0, 0, 1), rot1 = float2x2(1, 0, 0, 1), rot2 = float2x2(1, 0, 0, 1);
				if(0.0 > 0)
				{
					rot0 = float2x2(UVBWR[0].z, -UVBWR[0].w, UVBWR[0].w, UVBWR[0].z);
					rot1 = float2x2(UVBWR[1].z, -UVBWR[1].w, UVBWR[1].w, UVBWR[1].z);
					rot2 = float2x2(UVBWR[2].z, -UVBWR[2].w, UVBWR[2].w, UVBWR[2].z);
				}
				float3 W = UVBWR[3].xyz;
				float4 c0 = tex.SampleGrad(texSampler, UVBWR[0].xy, mul(dUVdx, rot0), mul(dUVdy, rot0));
				float4 c1 = tex.SampleGrad(texSampler, UVBWR[1].xy, mul(dUVdx, rot1), mul(dUVdy, rot1));
				float4 c2 = tex.SampleGrad(texSampler, UVBWR[2].xy, mul(dUVdx, rot2), mul(dUVdy, rot2));
				const float3 Lw = float3(0.299, 0.587, 0.114);
				float3 Dw = float3(dot(c0.xyz, Lw), dot(c1.xyz, Lw), dot(c2.xyz, Lw));
				Dw = lerp(1.0, Dw, 0.6);
				W = Dw * pow(W, 7.0);
				W /= (W.x + W.y + W.z);
				return W.x * c0 + W.y * c1 + W.z * c2;
			}
			float4 HextileSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, bool isNormalMap)
			{
				return HextileSampleTexture(tex, texSampler, uv, isNormalMap, ddx(uv), ddy(uv));
			}
			#endif // defined(_STOCHASTICMODE_HEXTILE)
			void applyAlphaOptions(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiMods poiMods)
			{
				poiFragData.alpha = saturate(poiFragData.alpha + 0.0);
				if (0.0 > 0)
				{
					poiFragData.alpha = maskBlend(poiFragData.alpha, poiMods.globalMask[0.0-1], 2.0);
				}
			}
			float customDistanceBlend(float base, float blend, float blendType)
			{
				switch(blendType)
				{
					case 0: return blendNormal(base, blend); break;
					case 2: return blendMultiply(base, blend); break;
					default: return 0; break;
				}
			}
			void ApplyGlobalMaskModifiers(in PoiMesh poiMesh, inout PoiMods poiMods, in PoiCam poiCam)
			{
			}
			float2 calculatePolarCoordinate(in PoiMesh poiMesh)
			{
				float2 delta = poiMesh.uv[0.0] - float4(0.5,0.5,0,0);
				float radius = length(delta) * 2 * 1.0;
				float angle = atan2(delta.x, delta.y);
				float phi = angle / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				angle = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				angle *= 1.0;
				return float2(radius, angle + distance(poiMesh.uv[0.0], float4(0.5,0.5,0,0)) * 0.0);
			}
			float2 MonoPanoProjection(float3 coords)
			{
				float3 normalizedCoords = normalize(coords);
				float latitude = acos(normalizedCoords.y);
				float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
				float phi = longitude / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				longitude = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				longitude *= 2;
				float2 sphereCoords = float2(longitude, latitude) * float2(1.0, 1.0 / UNITY_PI);
				sphereCoords = float2(1.0, 1.0) - sphereCoords;
				return (sphereCoords + float4(0, 1 - unity_StereoEyeIndex, 1, 1.0).xy) * float4(0, 1 - unity_StereoEyeIndex, 1, 1.0).zw;
			}
			float2 StereoPanoProjection(float3 coords)
			{
				float3 normalizedCoords = normalize(coords);
				float latitude = acos(normalizedCoords.y);
				float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
				float phi = longitude / (UNITY_PI * 2.0);
				float phi_frac = frac(phi);
				longitude = fwidth(phi) - 0.0001 < fwidth(phi_frac) ? phi : phi_frac;
				longitude *= 2;
				float2 sphereCoords = float2(longitude, latitude) * float2(0.5, 1.0 / UNITY_PI);
				sphereCoords = float2(0.5, 1.0) - sphereCoords;
				return (sphereCoords + float4(0, 1 - unity_StereoEyeIndex, 1, 0.5).xy) * float4(0, 1 - unity_StereoEyeIndex, 1, 0.5).zw;
			}
			float2 calculateWorldUV(in PoiMesh poiMesh)
			{
				return float2(0.0 != 3 ? poiMesh.worldPos[ 0.0] : 0.0f, 2.0 != 3 ? poiMesh.worldPos[2.0] : 0.0f);
			}
			float2 calculatelocalUV(in PoiMesh poiMesh)
			{
				float localUVs[8];
				localUVs[0] = poiMesh.localPos.x;
				localUVs[1] = poiMesh.localPos.y;
				localUVs[2] = poiMesh.localPos.z;
				localUVs[3] = 0;
				localUVs[4] = poiMesh.vertexColor.r;
				localUVs[5] = poiMesh.vertexColor.g;
				localUVs[6] = poiMesh.vertexColor.b;
				localUVs[7] = poiMesh.vertexColor.a;
				return float2(localUVs[0.0],localUVs[1.0]);
			}
			float2 calculatePanosphereUV(in PoiMesh poiMesh)
			{
				float3 viewDirection = normalize(lerp(getCameraPosition().xyz, _WorldSpaceCameraPos.xyz, 1.0) - poiMesh.worldPos.xyz) * - 1;
				return lerp(MonoPanoProjection(viewDirection), StereoPanoProjection(viewDirection), 0.0);
			}
			float4 frag(VertexOut i, uint facing : SV_IsFrontFace) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				PoiMesh poiMesh;
				PoiInitStruct(PoiMesh, poiMesh);
				PoiLight poiLight;
				PoiInitStruct(PoiLight, poiLight);
				PoiVertexLights poiVertexLights;
				PoiInitStruct(PoiVertexLights, poiVertexLights);
				PoiCam poiCam;
				PoiInitStruct(PoiCam, poiCam);
				PoiMods poiMods;
				PoiInitStruct(PoiMods, poiMods);
				poiMods.globalEmission = 1;
				poiMods.PBR = 1;
				PoiFragData poiFragData;
				poiFragData.emission = 0;
				poiFragData.baseColor = float3(0, 0, 0);
				poiFragData.finalColor = float3(0, 0, 0);
				poiFragData.alpha = 1;
				#ifdef POI_UDIMDISCARD
				applyUDIMDiscard(i);
				#endif
				poiMesh.objectPosition = i.objectPos;
				poiMesh.objNormal = i.objNormal;
				poiMesh.normals[0] = i.normal;
				poiMesh.tangent[0] = i.tangent;
				poiMesh.binormal[0] = i.binormal;
				poiMesh.worldPos = i.worldPos.xyz;
				poiMesh.localPos = i.localPos.xyz;
				poiMesh.vertexColor = i.vertexColor;
				poiMesh.isFrontFace = facing;
				#ifndef POI_PASS_OUTLINE
				if (!poiMesh.isFrontFace)
				{
					poiMesh.normals[0] *= -1;
					poiMesh.tangent[0] *= -1;
					poiMesh.binormal[0] *= -1;
				}
				#endif
				poiCam.viewDir = !IsOrthographicCamera() ? normalize(_WorldSpaceCameraPos - i.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 tanToWorld0 = float3(i.tangent.x, i.binormal.x, i.normal.x);
				float3 tanToWorld1 = float3(i.tangent.y, i.binormal.y, i.normal.y);
				float3 tanToWorld2 = float3(i.tangent.z, i.binormal.z, i.normal.z);
				float3 ase_tanViewDir = tanToWorld0 * poiCam.viewDir.x + tanToWorld1 * poiCam.viewDir.y + tanToWorld2 * poiCam.viewDir.z;
				poiCam.tangentViewDir = normalize(ase_tanViewDir);
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				poiMesh.lightmapUV = i.lightmapUV;
				#endif
				poiMesh.parallaxUV = poiCam.tangentViewDir.xy / max(poiCam.tangentViewDir.z, 0.0001);
				poiMesh.uv[0] = i.uv[0];
				poiMesh.uv[1] = i.uv[1];
				poiMesh.uv[2] = i.uv[2];
				poiMesh.uv[3] = i.uv[3];
				poiMesh.uv[4] = poiMesh.uv[0];
				poiMesh.uv[5] = poiMesh.uv[0];
				poiMesh.uv[6] = poiMesh.uv[0];
				poiMesh.uv[7] = poiMesh.uv[0];
				poiMesh.uv[8] = poiMesh.uv[0];
				poiMesh.uv[4] = calculatePanosphereUV(poiMesh);
				poiMesh.uv[5] = calculateWorldUV(poiMesh);
				poiMesh.uv[6] = calculatePolarCoordinate(poiMesh);
				poiMesh.uv[8] = calculatelocalUV(poiMesh);
				poiMods.globalMask[0]  = 1;
				poiMods.globalMask[1]  = 1;
				poiMods.globalMask[2]  = 1;
				poiMods.globalMask[3]  = 1;
				poiMods.globalMask[4]  = 1;
				poiMods.globalMask[5]  = 1;
				poiMods.globalMask[6]  = 1;
				poiMods.globalMask[7]  = 1;
				poiMods.globalMask[8]  = 1;
				poiMods.globalMask[9]  = 1;
				poiMods.globalMask[10] = 1;
				poiMods.globalMask[11] = 1;
				poiMods.globalMask[12] = 1;
				poiMods.globalMask[13] = 1;
				poiMods.globalMask[14] = 1;
				poiMods.globalMask[15] = 1;
				ApplyGlobalMaskModifiers(poiMesh, poiMods, poiCam);
				float2 mainUV = poiMesh.uv[0.0].xy;
				if (0.0)
				{
					mainUV = sharpSample(float4(1,1,1,1), mainUV);
				}
				float4 mainTexture = POI2D_SAMPLER_PAN_STOCHASTIC(_MainTex, _MainTex, poiUV(mainUV, float4(1,1,0,0)), float4(0,0,0,0), 0.0);
				#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
				poiMesh.tangentSpaceNormal = UnpackScaleNormal(POI2D_SAMPLER_PAN_STOCHASTIC(_BumpMap, _MainTex, poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0)), float4(0,0,0,0), 0.0), 1.0);
				#else
				poiMesh.tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				#endif
				poiMesh.normals[1] = normalize(
				poiMesh.tangentSpaceNormal.x * poiMesh.tangent[0] +
				poiMesh.tangentSpaceNormal.y * poiMesh.binormal[0] +
				poiMesh.tangentSpaceNormal.z * poiMesh.normals[0]
				);
				poiMesh.tangent[1] = cross(poiMesh.binormal[0], -poiMesh.normals[1]);
				poiMesh.binormal[1] = cross(-poiMesh.normals[1], poiMesh.tangent[0]);
				poiCam.forwardDir = getCameraForward();
				poiCam.worldPos = _WorldSpaceCameraPos;
				poiCam.reflectionDir = reflect(-poiCam.viewDir, poiMesh.normals[1]);
				poiCam.vertexReflectionDir = reflect(-poiCam.viewDir, poiMesh.normals[0]);
				poiCam.distanceToVert = distance(poiMesh.worldPos, poiCam.worldPos);
				poiCam.grabPos = i.grabPos;
				poiCam.screenUV = calcScreenUVs(i.grabPos);
				poiCam.vDotN = abs(dot(poiCam.viewDir, poiMesh.normals[1]));
				poiCam.clipPos = i.pos;
				poiCam.worldDirection = i.worldDirection;
				poiFragData.baseColor = mainTexture.rgb * poiThemeColor(poiMods, float4(0.673178,0.2713008,0.1356672,1).rgb, 0.0);
				poiFragData.alpha = mainTexture.a * float4(0.673178,0.2713008,0.1356672,1).a;
				#if defined(PROP_CLIPPINGMASK) || !defined(OPTIMIZER_ENABLED)
				float alphaMask = POI2D_SAMPLER_PAN(_ClippingMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0)).r;
				if (0.0)
				{
					alphaMask = 1 - alphaMask;
				}
				poiFragData.alpha *= alphaMask;
				#endif
				applyAlphaOptions(poiFragData, poiMesh, poiCam, poiMods);
				poiFragData.finalColor = poiFragData.baseColor;
				if (0.0 == 0)
				{
					UNITY_APPLY_FOG(i.fogCoord, poiFragData.finalColor);
				}
				poiFragData.alpha = 0.0 ? 1 : poiFragData.alpha;
				if (0.0 == POI_MODE_OPAQUE)
				{
					poiFragData.alpha = 1;
				}
				clip(poiFragData.alpha - 0.5);
				return float4(poiFragData.finalColor, poiFragData.alpha) + POI_SAFE_RGB0;
			}
struct SpsInputs : appdata {
#define SPS_STRUCT_POSITION_TYPE float4
#define SPS_STRUCT_POSITION_TYPE_float4
#define SPS_STRUCT_POSITION_NAME vertex
#define SPS_STRUCT_NORMAL_TYPE float3
#define SPS_STRUCT_NORMAL_TYPE_float3
#define SPS_STRUCT_NORMAL_NAME normal
#define SPS_STRUCT_TANGENT_TYPE float4
#define SPS_STRUCT_TANGENT_TYPE_float4
#define SPS_STRUCT_TANGENT_NAME tangent
#define SPS_STRUCT_COLOR_TYPE float4
#define SPS_STRUCT_COLOR_TYPE_float4
#define SPS_STRUCT_COLOR_NAME color
#define SPS_STRUCT_TEXCOORD_TYPE float2
#define SPS_STRUCT_TEXCOORD_TYPE_float2
#define SPS_STRUCT_TEXCOORD_NAME uv0
#define SPS_STRUCT_TEXCOORD1_TYPE float2
#define SPS_STRUCT_TEXCOORD1_TYPE_float2
#define SPS_STRUCT_TEXCOORD1_NAME uv1
#define SPS_STRUCT_TEXCOORD2_TYPE float2
#define SPS_STRUCT_TEXCOORD2_TYPE_float2
#define SPS_STRUCT_TEXCOORD2_NAME uv2
#define SPS_STRUCT_TEXCOORD3_TYPE float2
#define SPS_STRUCT_TEXCOORD3_TYPE_float2
#define SPS_STRUCT_TEXCOORD3_NAME uv3
#define SPS_STRUCT_SV_VertexID_TYPE uint
#define SPS_STRUCT_SV_VertexID_TYPE_uint
#define SPS_STRUCT_SV_VertexID_NAME vertexId

// Add parameters needed by SPS if missing from the existing struct
#ifndef SPS_STRUCT_POSITION_NAME
  float3 spsPosition : POSITION;
  #define SPS_STRUCT_POSITION_TYPE float3
  #define SPS_STRUCT_POSITION_TYPE_float3
  #define SPS_STRUCT_POSITION_NAME spsPosition
#endif
#ifndef SPS_STRUCT_NORMAL_NAME
  float3 spsNormal : NORMAL;
  #define SPS_STRUCT_NORMAL_TYPE float3
  #define SPS_STRUCT_NORMAL_TYPE_float3
  #define SPS_STRUCT_NORMAL_NAME spsNormal
#endif
#ifndef SPS_STRUCT_TANGENT_NAME
  float4 spsTangent : TANGENT;
  #define SPS_STRUCT_TANGENT_TYPE float4
  #define SPS_STRUCT_TANGENT_TYPE_float4
  #define SPS_STRUCT_TANGENT_NAME spsTangent
#endif
#ifndef SPS_STRUCT_SV_VertexID_NAME
  uint spsVertexId : SV_VertexID;
  #define SPS_STRUCT_SV_VertexID_TYPE uint
  #define SPS_STRUCT_SV_VertexID_TYPE_uint
  #define SPS_STRUCT_SV_VertexID_NAME spsVertexId
#endif
#ifndef SPS_STRUCT_COLOR_NAME
  float4 spsColor : COLOR;
  #define SPS_STRUCT_COLOR_TYPE float4
  #define SPS_STRUCT_COLOR_TYPE_float4
  #define SPS_STRUCT_COLOR_NAME spsColor
#endif
};
#define SPS_VANILLA_VERT_PARAM_TYPE appdata


#ifndef SPS_UTILS
#define SPS_UTILS

#include "UnityShaderVariables.cginc"

float sps_map(float value, float min1, float max1, float min2, float max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float sps_saturated_map(float value, float min, float max) {
    return saturate(sps_map(value, min, max, 0, 1));
}

// normalize fails fatally and discards the vert if length == 0
float3 sps_normalize(float3 a) {
    return length(a) == 0 ? float3(0,0,1) : normalize(a);
}

#define sps_angle_between(a,b) acos(dot(sps_normalize(a),sps_normalize(b)))

float3 sps_nearest_normal(float3 forward, float3 approximate) {
    return sps_normalize(cross(forward, cross(approximate, forward)));
}

float3 sps_toLocal(float3 v) { return mul(unity_WorldToObject, float4(v, 1)).xyz; }
float3 sps_toWorld(float3 v) { return mul(unity_ObjectToWorld, float4(v, 1)).xyz; }
// https://forum.unity.com/threads/point-light-in-v-f-shader.499717/#post-9052987
float sps_attenToRange(float atten) { return 5.0 * (1.0 / sqrt(atten)); }

#endif




// https://en.wikipedia.org/wiki/B%C3%A9zier_curve
float3 sps_bezier(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
	const float minT = 1-t;
	return
		minT * minT * minT * p0
		+ 3 * minT * minT * t * p1
		+ 3 * minT * t * t * p2
		+ t * t * t * p3;
}
float3 sps_bezierDerivative(float3 p0, float3 p1, float3 p2, float3 p3, float t)
{
	const float minT = 1-t;
	return
		3 * minT * minT * (p1 - p0)
		+ 6 * minT * t * (p2 - p1)
		+ 3 * t * t * (p3 - p2);
}

// https://gamedev.stackexchange.com/questions/105230/points-evenly-spaced-along-a-bezier-curve
// https://gamedev.stackexchange.com/questions/5373/moving-ships-between-two-planets-along-a-bezier-missing-some-equations-for-acce/5427#5427
// https://www.geometrictools.com/Documentation/MovingAlongCurveSpecifiedSpeed.pdf
// https://gamedev.stackexchange.com/questions/137022/consistent-normals-at-any-angle-in-bezier-curve/
void sps_bezierSolve(float3 p0, float3 p1, float3 p2, float3 p3, float lookingForLength, out float curveLength, out float3 position, out float3 forward, out float3 up)
{
	#define SPS_BEZIER_SAMPLES 50
	float sampledT[SPS_BEZIER_SAMPLES];
	float sampledLength[SPS_BEZIER_SAMPLES];
	float3 sampledUp[SPS_BEZIER_SAMPLES];
	float totalLength = 0;
	float3 lastPoint = p0;
	sampledT[0] = 0;
	sampledLength[0] = 0;
	sampledUp[0] = float3(0,1,0);
	{
		for(int i = 1; i < SPS_BEZIER_SAMPLES; i++)
		{
			const float t = float(i) / (SPS_BEZIER_SAMPLES-1);
			const float3 currentPoint = sps_bezier(p0, p1, p2, p3, t);
			const float3 currentForward = sps_normalize(sps_bezierDerivative(p0, p1, p2, p3, t));
			const float3 lastUp = sampledUp[i-1];
			const float3 currentUp = sps_nearest_normal(currentForward, lastUp);

			sampledT[i] = t;
			totalLength += length(currentPoint - lastPoint);
			sampledLength[i] = totalLength;
			sampledUp[i] = currentUp;
			lastPoint = currentPoint;
		}
	}

	float adjustedT = 1;
	float3 approximateUp = sampledUp[SPS_BEZIER_SAMPLES - 1];
	for(int i = 1; i < SPS_BEZIER_SAMPLES; i++)
	{
		if (lookingForLength <= sampledLength[i])
		{
			const float fraction = sps_map(lookingForLength, sampledLength[i-1], sampledLength[i], 0, 1);
			adjustedT = lerp(sampledT[i-1], sampledT[i], fraction);
			approximateUp = lerp(sampledUp[i-1], sampledUp[i], fraction);
			break;
		}
	}

	curveLength = totalLength;
	const float t = saturate(adjustedT);
	position = sps_bezier(p0, p1, p2, p3, t);
	forward = sps_normalize(sps_bezierDerivative(p0, p1, p2, p3, t));
	up = sps_nearest_normal(forward, approximateUp);
}


#include "UnityShaderVariables.cginc"
#ifndef SPS_GLOBALS
#define SPS_GLOBALS

#define SPS_PI float(3.14159265359)

#define SPS_TYPE_INVALID 0
#define SPS_TYPE_HOLE 1
#define SPS_TYPE_RING_TWOWAY 2
#define SPS_TYPE_SPSPLUS 3
#define SPS_TYPE_RING_ONEWAY 4
#define SPS_TYPE_FRONT 5

#ifdef SHADER_TARGET_SURFACE_ANALYSIS
    #define SPS_TEX_DEFINE(name) float4 name##_TexelSize; sampler2D name;
    #define SPS_TEX_RAW_FLOAT4_XY(name,x,y) tex2Dlod(name, float4(uint2(x,y) * name##_TexelSize.xy, 0, 0))
#else
    #define SPS_TEX_DEFINE(name) Texture2D name;
    #define SPS_TEX_RAW_FLOAT4_XY(name,x,y) name[uint2(x,y)]
#endif
float SpsInt4ToFloat(int4 data) { return asfloat((data[3] << 24) | (data[2] << 16) | (data[1] << 8) | data[0]); }
#define SPS_TEX_RAW_FLOAT4(tex, offset) ((float4)(SPS_TEX_RAW_FLOAT4_XY(tex, (offset)%8192, (offset)/8192)))
#define SPS_TEX_RAW_INT4(tex, offset) ((int4)(SPS_TEX_RAW_FLOAT4(tex, offset) * 255))
#define SPS_TEX_FLOAT(tex, offset) SpsInt4ToFloat(SPS_TEX_RAW_INT4(tex, offset))
#define SPS_TEX_FLOAT3(tex, offset) float3(SPS_TEX_FLOAT(tex, offset), SPS_TEX_FLOAT(tex, (offset)+1), SPS_TEX_FLOAT(tex, (offset)+2))

float _SPS_Length;
float _SPS_BakedLength;
SPS_TEX_DEFINE(_SPS_Bake)
float _SPS_BlendshapeVertCount;
float _SPS_Blendshape0;
float _SPS_Blendshape1;
float _SPS_Blendshape2;
float _SPS_Blendshape3;
float _SPS_Blendshape4;
float _SPS_Blendshape5;
float _SPS_Blendshape6;
float _SPS_Blendshape7;
float _SPS_Blendshape8;
float _SPS_Blendshape9;
float _SPS_Blendshape10;
float _SPS_Blendshape11;
float _SPS_Blendshape12;
float _SPS_Blendshape13;
float _SPS_Blendshape14;
float _SPS_Blendshape15;
float _SPS_BlendshapeCount;

float _SPS_Enabled;
float _SPS_Overrun;
float _SPS_Target_LL_Lights;

#endif




#ifndef SPS_PLUS
#define SPS_PLUS

float _SPS_Plus_Enabled;
float _SPS_Plus_Ring;
float _SPS_Plus_Hole;

void sps_plus_search(
    out float distance,
    out int type
) {
    distance = 999;
    type = SPS_TYPE_INVALID;
    
    float maxVal = 0;
    if (_SPS_Plus_Ring > maxVal) { maxVal = _SPS_Plus_Ring; type = SPS_TYPE_RING_TWOWAY; }
    if (_SPS_Plus_Hole == maxVal) { type = SPS_TYPE_RING_ONEWAY; }
    if (_SPS_Plus_Hole > maxVal) { maxVal = _SPS_Plus_Hole; type = SPS_TYPE_HOLE; }

    if (maxVal > 0) {
        distance = (1 - maxVal) * 3;
    }
}

#endif




void sps_light_parse(float range, half4 color, out int type) {
	type = SPS_TYPE_INVALID;

	if (range >= 0.5 || (length(color.rgb) > 0 && color.a > 0)) {
		// Outside of SPS range, or visible light
		return;
	}

	const int secondDecimal = round((range % 0.1) * 100);

	if (_SPS_Plus_Enabled > 0.5) {
		if (secondDecimal == 1 || secondDecimal == 2) {
			const int fourthDecimal = round((range % 0.001) * 10000);
			if (fourthDecimal == 2) {
				type = SPS_TYPE_SPSPLUS;
				return;
			}
		}
	}

	if (secondDecimal == 1) type = SPS_TYPE_HOLE;
	if (secondDecimal == 2) type = SPS_TYPE_RING_TWOWAY;
	if (secondDecimal == 5) type = SPS_TYPE_FRONT;
}

// Find nearby socket lights
void sps_light_search(
	inout int ioType,
	inout float3 ioRootLocal,
	inout float3 ioRootNormal
) {
	// Collect useful info about all the nearby lights that unity tells us about
	// (usually the brightest 4)
	int lightType[4];
	float3 lightWorldPos[4];
	float3 lightLocalPos[4];
	{
		for(int i = 0; i < 4; i++) {
	 		const float range = sps_attenToRange(unity_4LightAtten0[i]);
			sps_light_parse(range, unity_LightColor[i], lightType[i]);
	 		lightWorldPos[i] = float3(unity_4LightPosX0[i], unity_4LightPosY0[i], unity_4LightPosZ0[i]);
	 		lightLocalPos[i] = sps_toLocal(lightWorldPos[i]);
	 	}
	}

	// Fill in SPS light info from contacts
	if (_SPS_Plus_Enabled > 0.5) {
		float spsPlusDistance;
		int spsPlusType;
		sps_plus_search(spsPlusDistance, spsPlusType);
		if (spsPlusType != SPS_TYPE_INVALID) {
			bool spsLightFound = false;
			int spsLightIndex = 0;
			float spsMinError = 0;
			for(int i = 0; i < 4; i++) {
				if (lightType[i] != SPS_TYPE_SPSPLUS) continue;
				const float3 myPos = lightLocalPos[i];
				const float3 otherPos = lightLocalPos[spsLightIndex];
				const float myError = abs(length(myPos) - spsPlusDistance);
				if (myError > 0.2) continue;
				const float otherError = spsMinError;

				bool imBetter = false;
				if (!spsLightFound) imBetter = true;
				else if (myError < 0.3 && myPos.z >= 0 && otherPos.z < 0) imBetter = true;
				else if (otherError < 0.3 && otherPos.z >= 0 && myPos.z < 0) imBetter = false;
				else if (myError < otherError) imBetter = true;

				if (imBetter) {
					spsLightFound = true;
					spsLightIndex = i;
					spsMinError = myError;
				}
			}
			if (spsLightFound) {
				lightType[spsLightIndex] = spsPlusType;
			}
		}
	}

	// Find nearest socket root
	int rootIndex = 0;
	bool rootFound = false;
	{
	 	float minDistance = -1;
	 	for(int i = 0; i < 4; i++) {
	 		const float distance = length(lightLocalPos[i]);
	 		const int type = lightType[i];
	 		if (distance < minDistance || minDistance < 0) {
	 			if (type == SPS_TYPE_HOLE || type == SPS_TYPE_RING_TWOWAY || type == SPS_TYPE_RING_ONEWAY) {
	 				rootFound = true;
	 				rootIndex = i;
	 				minDistance = distance;
	 			}
	 		}
	 	}
	}
	
	int frontIndex = 0;
	bool frontFound = false;
	if (rootFound) {
	 	// Find front (normal) light for socket root if available
	 	float minDistance = 0.1;
	 	for(int i = 0; i < 4; i++) {
	 		const float distFromRoot = length(lightWorldPos[i] - lightWorldPos[rootIndex]);
	 		if (lightType[i] == SPS_TYPE_FRONT && distFromRoot < minDistance) {
	 			frontFound = true;
	 			frontIndex = i;
	 			minDistance = distFromRoot;
	 		}
	 	}
	}

	// This can happen if the socket was misconfigured, or if it's on a first person head bone that's been shrunk down
	// Ignore the normal, since it'll be so close to the root that rounding error will cause problems
	if (frontFound && length(lightLocalPos[frontIndex] - lightLocalPos[rootIndex]) < 0.00005) {
		frontFound = false;
	}

	if (!rootFound) return;
	if (ioType != SPS_TYPE_INVALID && length(lightLocalPos[rootIndex]) >= length(ioRootLocal)) return;

	ioType = lightType[rootIndex];
	ioRootLocal = lightLocalPos[rootIndex];
	ioRootNormal = frontFound
		? lightLocalPos[frontIndex] - lightLocalPos[rootIndex]
		: -1 * lightLocalPos[rootIndex];
	ioRootNormal = sps_normalize(ioRootNormal);
}











void SpsApplyBlendshape(uint vertexId, inout float3 position, inout float3 normal, inout float3 tangent, float blendshapeValue, int blendshapeId)
{
    if (blendshapeId >= _SPS_BlendshapeCount) return;
    const int vertCount = (int)_SPS_BlendshapeVertCount;
    const uint bytesPerBlendshapeVertex = 9;
    const uint bytesPerBlendshape = vertCount * bytesPerBlendshapeVertex + 1;
    const uint blendshapeOffset = 1 + (vertCount * 10) + bytesPerBlendshape * blendshapeId;
    const uint vertexOffset = blendshapeOffset + 1 + (vertexId * bytesPerBlendshapeVertex);
    const float blendshapeValueAtBake = SPS_TEX_FLOAT(_SPS_Bake, blendshapeOffset);
    const float blendshapeValueNow = blendshapeValue;
    const float change = (blendshapeValueNow - blendshapeValueAtBake) * 0.01;
    position += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset) * change;
    normal += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset + 3) * change;
    tangent += SPS_TEX_FLOAT3(_SPS_Bake, vertexOffset + 6) * change;
}

void SpsGetBakedPosition(uint vertexId, out float3 position, out float3 normal, out float3 tangent, out float active) {
    const uint bakeIndex = 1 + vertexId * 10;
    position = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex);
    normal = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex + 3);
    tangent = SPS_TEX_FLOAT3(_SPS_Bake, bakeIndex + 6);
    active = SPS_TEX_FLOAT(_SPS_Bake, bakeIndex + 9);
    if (position.z < 0) active = 0;

    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape0, 0);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape1, 1);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape2, 2);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape3, 3);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape4, 4);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape5, 5);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape6, 6);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape7, 7);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape8, 8);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape9, 9);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape10, 10);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape11, 11);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape12, 12);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape13, 13);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape14, 14);
    SpsApplyBlendshape(vertexId, position, normal, tangent, _SPS_Blendshape15, 15);
}






// SPS Penetration Shader
void sps_apply_real(
	inout SPS_STRUCT_POSITION_TYPE vertex,
	inout SPS_STRUCT_NORMAL_TYPE normal,
	inout SPS_STRUCT_TANGENT_TYPE tangent,
	uint vertexId,
	inout SPS_STRUCT_COLOR_TYPE color
) {
	const float worldLength = _SPS_Length;
	const float3 origVertex = vertex.xyz;
	const float3 origNormal = normal.xyz;
	const float3 origTangent = tangent.xyz;
	float3 bakedVertex;
	float3 bakedNormal;
	float3 bakedTangent;
	float active;
	SpsGetBakedPosition(vertexId, bakedVertex, bakedNormal, bakedTangent, active);

	bakedVertex *= (_SPS_Length / _SPS_BakedLength);
	
	if (active == 0) return;

	float3 rootPos;
	int type = SPS_TYPE_INVALID;
	float3 frontNormal;
	sps_light_search(type, rootPos, frontNormal);
	if (type == SPS_TYPE_INVALID) return;

	float orfDistance = length(rootPos);
	float exitAngle = sps_angle_between(rootPos, float3(0,0,1));
	float entranceAngle = SPS_PI - sps_angle_between(frontNormal, rootPos);

	// Flip backward bidirectional rings
	if (type == SPS_TYPE_RING_TWOWAY && entranceAngle > SPS_PI/2) {
		frontNormal *= -1;
		entranceAngle = SPS_PI - entranceAngle;
	}

	// Decide if we should cancel deformation due to extreme angles, long distance, etc
	float bezierLerp;
	float dumbLerp;
	float shrinkLerp = 0;
	{
		float applyLerp = 1;
		// Cancel if base angle is too sharp
		const float allowedExitAngle = 0.6;
		const float exitAngleTooSharp = exitAngle > SPS_PI*allowedExitAngle ? 1 : 0;
		applyLerp = min(applyLerp, 1-exitAngleTooSharp);

		// Cancel if the entrance angle is too sharp
		if (type != SPS_TYPE_RING_TWOWAY) {
			const float allowedEntranceAngle = 0.8;
			const float entranceAngleTooSharp = entranceAngle > SPS_PI*allowedEntranceAngle ? 1 : 0;
			applyLerp = min(applyLerp, 1-entranceAngleTooSharp);
		}

		if (type == SPS_TYPE_HOLE) {
			// Uncancel if hilted in a hole
			const float hiltedSphereRadius = 0.5;
			const float inSphere = orfDistance > worldLength*hiltedSphereRadius ? 0 : 1;
			//const float hilted = min(isBehind, inSphere);
			//shrinkLerp = hilted;
			const float hilted = inSphere;
			applyLerp = max(applyLerp, hilted);
		} else {
			// Cancel if ring is near or behind base
			const float isBehind = rootPos.z > 0 ? 0 : 1;
			applyLerp = min(applyLerp, 1-isBehind);
		}

		// Cancel if too far away
		const float tooFar = sps_saturated_map(orfDistance, worldLength*1.2, worldLength*1.6);
		applyLerp = min(applyLerp, 1-tooFar);

		applyLerp = applyLerp * saturate(_SPS_Enabled);

		dumbLerp = sps_saturated_map(applyLerp, 0, 0.2) * active;
		bezierLerp = sps_saturated_map(applyLerp, 0, 1);
		shrinkLerp = sps_saturated_map(applyLerp, 0.8, 1) * shrinkLerp;
	}

	rootPos *= (1-shrinkLerp);
	orfDistance *= (1-shrinkLerp);

	float3 bezierPos;
	float3 bezierForward;
	float3 bezierRight;
	float3 bezierUp;
	float curveLength;
	if (length(rootPos) == 0) {
		bezierPos = float3(0,0,0);
		bezierForward = float3(0,0,1);
		bezierRight = float3(1,0,0);
		bezierUp = float3(0,1,0);
		curveLength = 0;
	} else{
		const float3 p0 = float3(0,0,0);
		const float p1Dist = min(orfDistance, max(worldLength / 8, rootPos.z / 4));
		const float p1DistWithPullout = sps_map(bezierLerp, 0, 1, worldLength * 5, p1Dist);
		const float3 p1 = float3(0,0,p1DistWithPullout);
		const float3 p2 = rootPos + frontNormal * p1Dist;
		const float3 p3 = rootPos;
		sps_bezierSolve(p0, p1, p2, p3, bakedVertex.z, curveLength, bezierPos, bezierForward, bezierUp);
		bezierRight = sps_normalize(cross(bezierUp, bezierForward));
	}

	// Handle holes and rings
	float holeShrink = 1;
	if (type == SPS_TYPE_RING_TWOWAY || type == SPS_TYPE_RING_ONEWAY) {
		if (bakedVertex.z >= curveLength) {
			// Straighten if past socket
			bezierPos += (bakedVertex.z - curveLength) * bezierForward;
		}
	} else {
		const float holeRecessDistance = worldLength * 0.05;
		const float holeRecessDistance2 = worldLength * 0.1;
		holeShrink = sps_saturated_map(
			bakedVertex.z,
			curveLength + holeRecessDistance2,
			curveLength + holeRecessDistance
		);
		if(_SPS_Overrun > 0) {
			if (bakedVertex.z >= curveLength + holeRecessDistance2) {
				// If way past socket, condense to point
				bezierPos += holeRecessDistance2 * bezierForward;
			} else if (bakedVertex.z >= curveLength) {
				// Straighten if past socket
				bezierPos += (bakedVertex.z - curveLength) * bezierForward;
			}
		}
	}

	float3 deformedVertex = bezierPos + bezierRight * bakedVertex.x * holeShrink + bezierUp * bakedVertex.y * holeShrink;
	vertex.xyz = lerp(origVertex, deformedVertex, dumbLerp);
	if (length(bakedNormal) != 0) {
		float3 deformedNormal = bezierRight * bakedNormal.x + bezierUp * bakedNormal.y + bezierForward * bakedNormal.z;
		normal.xyz = lerp(origNormal, deformedNormal, dumbLerp);
	}
	if (length(bakedTangent) != 0) {
		float3 deformedTangent = bezierRight * bakedTangent.x + bezierUp * bakedTangent.y + bezierForward * bakedTangent.z;
		tangent.xyz = lerp(origTangent, deformedTangent, dumbLerp);
	}
}

void sps_apply(inout SpsInputs o) {

	// When VERTEXLIGHT_ON is missing, there are no lights nearby, and the 4light arrays will be full of junk
	// Temporarily disable this check since apparently it causes some passes to not apply SPS
	//#ifdef VERTEXLIGHT_ON
	sps_apply_real(
		o.SPS_STRUCT_POSITION_NAME,
		o.SPS_STRUCT_NORMAL_NAME,
		o.SPS_STRUCT_TANGENT_NAME,
		o.SPS_STRUCT_SV_VertexID_NAME,
		o.SPS_STRUCT_COLOR_NAME
	);
	//#endif

}

VertexOut spsVert(
			#ifndef POI_TESSELLATED
			SpsInputs v
			#else
			tessAppData v
			#endif
			) {
  sps_apply(v);
  return vert(
			#ifndef POI_TESSELLATED
			(appdata)v
			#else
			v
			#endif
			);
}

			ENDCG
		
}
	}
}
