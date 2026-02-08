Shader "Hidden/Locked/SPSPatched/17ac475ba2fbf57f742a807d85f4ae03"
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


		[HideInInspector] shader_master_label ("<color=#E75898ff>Poiyomi 9.3.52</color>", Float) = 0
		[HideInInspector] shader_is_using_thry_editor ("", Float) = 0
		[HideInInspector] shader_locale ("0db0b86376c3dca4b9a6828ef8615fe0", Float) = 0
		[HideInInspector] footer_website ("{texture:{name:icon-poilogo,height:24},action:{type:URL,data:https://www.poiyomi.com},hover:WEBSITE}", Float) = 0
		[HideInInspector] footer_discord ("{texture:{name:icon-discord,height:24},action:{type:URL,data:https://discord.gg/Ays52PY},hover:DISCORD}", Float) = 0
		[HideInInspector] footer_patreon ("{texture:{name:icon-patreon-new,height:24},action:{type:URL,data:https://www.patreon.com/poiyomi},hover:PATREON}", Float) = 0
		[HideInInspector] footer_youtube ("{texture:{name:icon-youtube,height:24},action:{type:URL,data:https://www.youtube.com/poiyomi},hover:YOUTUBE}", Float) = 0
		[HideInInspector] footer_github ("{texture:{name:icon-github,height:24},action:{type:URL,data:https://github.com/poiyomi/PoiyomiToonShader},hover:GITHUB}", Float) = 0
		[HideInInspector] footer_bluesky ("{texture:{name:icon-bluesky,height:24},action:{type:URL,data:https://bsky.app/profile/poiyomi.com},hover:BLUESKY}", Float) = 0
		[HideInInspector] footer_twitter ("{texture:{name:icon-twitter,height:24},action:{type:URL,data:https://x.com/poiyomi},hover:X}", Float) = 0
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
		[HideInInspector] GeometryShader_Enabled("GEOMETRY SHADER ENABLED", Float) = 1
		[HideInInspector] Tessellation_Enabled("TESSELLATION ENABLED", Float) = 1
		[ThryWideEnum(Opaque, 0, Cutout, 1, TransClipping, 9, Fade, 2, Transparent, 3, Additive, 4, Soft Additive, 5, Multiplicative, 6, 2x Multiplicative, 7)]_Mode("Rendering Preset--{on_value_actions:[
		{value:0,actions:[{type:SET_PROPERTY,data:render_queue=2000},{type:SET_PROPERTY,data:_AlphaForceOpaque=1}, {type:SET_PROPERTY,data:render_type=Opaque},            {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=0}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:1,actions:[{type:SET_PROPERTY,data:render_queue=2450},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=TransparentCutout}, {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=.5}, {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:9,actions:[{type:SET_PROPERTY,data:render_queue=2460},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=TransparentCutout}, {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0.01},  {type:SET_PROPERTY,data:_SrcBlend=5}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=5}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=1}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=5}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:2,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0.002},  {type:SET_PROPERTY,data:_SrcBlend=5}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=5}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=5}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:3,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=10}, {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=1}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=10}, {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:4,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=1}, {type:SET_PROPERTY,data:_DstBlend=1},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=1}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=1}, {type:SET_PROPERTY,data:_OutlineDstBlend=1},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:5,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=4}, {type:SET_PROPERTY,data:_DstBlend=1},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=4}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=4}, {type:SET_PROPERTY,data:_OutlineDstBlend=1},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:6,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=2}, {type:SET_PROPERTY,data:_DstBlend=0},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=2}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=2}, {type:SET_PROPERTY,data:_OutlineDstBlend=0},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]},
		{value:7,actions:[{type:SET_PROPERTY,data:render_queue=3000},{type:SET_PROPERTY,data:_AlphaForceOpaque=0}, {type:SET_PROPERTY,data:render_type=Transparent},       {type:SET_PROPERTY,data:_BlendOp=0}, {type:SET_PROPERTY,data:_BlendOpAlpha=4}, {type:SET_PROPERTY,data:_Cutoff=0},  {type:SET_PROPERTY,data:_SrcBlend=2}, {type:SET_PROPERTY,data:_DstBlend=3},  {type:SET_PROPERTY,data:_SrcBlendAlpha=1}, {type:SET_PROPERTY,data:_DstBlendAlpha=1},  {type:SET_PROPERTY,data:_AddSrcBlend=2}, {type:SET_PROPERTY,data:_AddDstBlend=1}, {type:SET_PROPERTY,data:_AddSrcBlendAlpha=0}, {type:SET_PROPERTY,data:_AddDstBlendAlpha=1}, {type:SET_PROPERTY,data:_AlphaToCoverage=0},  {type:SET_PROPERTY,data:_ZWrite=0}, {type:SET_PROPERTY,data:_ZTest=4},   {type:SET_PROPERTY,data:_AlphaPremultiply=0}, {type:SET_PROPERTY,data:_OutlineSrcBlend=2}, {type:SET_PROPERTY,data:_OutlineDstBlend=3},  {type:SET_PROPERTY,data:_OutlineSrcBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineDstBlendAlpha=1}, {type:SET_PROPERTY,data:_OutlineBlendOp=0}, {type:SET_PROPERTY,data:_OutlineBlendOpAlpha=4}]}
		}]}]}", Int) = 0
		[HideInInspector] m_mainCategory ("Color & Normals--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/color-and-normals/main},hover:Documentation}}", Float) = 0
		_Color ("Color & Alpha--{reference_property:_ColorThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _ColorThemeIndex ("", Int) = 0
		[sRGBWarning(true)]_MainTex ("Texture--{reference_properties:[_MainTexPan, _MainTexUV, _MainPixelMode, _MainTexStochastic, _MainIgnoreTexAlpha]}", 2D) = "white" { }
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _MainTexUV ("UV", Int) = 0
		[HideInInspector][Vector2]_MainTexPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ToggleUI]_MainPixelMode ("Pixel Mode", Float) = 0
		[HideInInspector][ToggleUI]_MainTexStochastic ("Stochastic Sampling", Float) = 0
		[HideInInspector][ToggleUI]_MainIgnoreTexAlpha ("Ignore Alpha", Float) = 0
		[Normal]_BumpMap ("Normal Map--{reference_properties:[_BumpMapPan, _BumpMapUV, _BumpScale, _BumpMapStochastic]}", 2D) = "bump" { }
		[HideInInspector][Vector2]_BumpMapPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _BumpMapUV ("UV", Int) = 0
		[HideInInspector]_BumpScale ("Intensity", Range(0, 10)) = 1
		[HideInInspector][ToggleUI]_BumpMapStochastic ("Stochastic Sampling", Float) = 0
		[sRGBWarning]_AlphaMask ("Alpha Map--{reference_properties:[_AlphaMaskPan, _AlphaMaskUV, _AlphaMaskInvert, _MainAlphaMaskMode, _AlphaMaskBlendStrength, _AlphaMaskValue], alts:[_AlphaMap]}", 2D) = "white" { }
		[HideInInspector][Vector2]_AlphaMaskPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _AlphaMaskUV ("UV", Int) = 0
		[HideInInspector][ThryWideEnum(Off, 0, Replace, 1, Multiply, 2, Add, 3, Subtract, 4)]_MainAlphaMaskMode ("Blend Mode", Int) = 2
		[HideInInspector]_AlphaMaskBlendStrength ("Blend Strength", Float) = 1
		[HideInInspector]_AlphaMaskValue ("Blend Offset", Float) = 0
		[HideInInspector][ToggleUI]_AlphaMaskInvert ("Invert", Float) = 0
		_Cutoff ("Alpha Cutoff", Range(0, 1.001)) = 0.5
		[HideInInspector] m_start_Alpha ("Alpha Options--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/color-and-normals/alpha-options},hover:Documentation}}", Float) = 0
		[ToggleUI]_AlphaForceOpaque ("Force Opaque", Float) = 1
		_AlphaMod ("Alpha Mod", Range(-1, 1)) = 0.0
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _AlphaGlobalMask ("Global Mask--{reference_property:_AlphaGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _AlphaGlobalMaskBlendType ("Blending", Int) = 2
		[HideInInspector] m_end_Alpha ("Alpha Options", Float) = 0
		[HideInInspector] m_lightingCategory ("Shading", Float) = 0
		[HideInInspector] m_start_PoiLightData ("Light Data--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/light-data},hover:Documentation}}", Float) = 0
		[TextureKeyword][sRGBWarning][ThryRGBAPacker(R, G, B, A, Linear, false)]_LightingAOMaps ("AO Maps (expand)--{reference_properties:[_LightingAOMapsPan, _LightingAOMapsUV,_LightDataAOStrengthR,_LightDataAOStrengthG,_LightDataAOStrengthB,_LightDataAOStrengthA, _LightDataAOGlobalMaskR]}", 2D) = "white" { }
		[HideInInspector][Vector2]_LightingAOMapsPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _LightingAOMapsUV ("UV", Int) = 0
		[HideInInspector]_LightDataAOStrengthR ("R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightDataAOStrengthG ("G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightDataAOStrengthB ("B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightDataAOStrengthA ("A Strength", Range(0, 1)) = 0
		[HideInInspector][ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _LightDataAOGlobalMaskR ("Global Mask--{reference_property:_LightDataAOGlobalMaskBlendTypeR}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _LightDataAOGlobalMaskBlendTypeR ("Blending", Range(0, 1)) = 2
		[TextureKeyword][sRGBWarning][ThryRGBAPacker(R, G, B, A, Linear, false)]_LightingDetailShadowMaps ("Shadow Map (expand)--{reference_properties:[_LightingDetailShadowMapsPan, _LightingDetailShadowMapsUV,_LightingDetailShadowStrengthR,_LightingDetailShadowStrengthG,_LightingDetailShadowStrengthB,_LightingDetailShadowStrengthA,_LightingAddDetailShadowStrengthR,_LightingAddDetailShadowStrengthG,_LightingAddDetailShadowStrengthB,_LightingAddDetailShadowStrengthA, _LightDataDetailShadowGlobalMaskR]}", 2D) = "white" { }
		[HideInInspector][Vector2]_LightingDetailShadowMapsPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _LightingDetailShadowMapsUV ("UV", Int) = 0
		[HideInInspector]_LightingDetailShadowStrengthR ("R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightingDetailShadowStrengthG ("G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingDetailShadowStrengthB ("B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingDetailShadowStrengthA ("A Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingAddDetailShadowStrengthR ("Additive R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightingAddDetailShadowStrengthG ("Additive G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingAddDetailShadowStrengthB ("Additive B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingAddDetailShadowStrengthA ("Additive A Strength", Range(0, 1)) = 0
		[HideInInspector][ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _LightDataDetailShadowGlobalMaskR ("Global Mask--{reference_property:_LightDataDetailShadowGlobalMaskBlendTypeR}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _LightDataDetailShadowGlobalMaskBlendTypeR ("Blending", Range(0, 1)) = 2
		[TextureKeyword][sRGBWarning][ThryRGBAPacker(R, G, B, A, Linear, false)]_LightingShadowMasks ("Shadow Masks (expand)--{reference_properties:[_LightingShadowMasksPan, _LightingShadowMasksUV,_LightingShadowMaskStrengthR,_LightingShadowMaskStrengthG,_LightingShadowMaskStrengthB,_LightingShadowMaskStrengthA, _LightDataShadowMaskGlobalMaskR]}", 2D) = "white" { }
		[HideInInspector][Vector2]_LightingShadowMasksPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _LightingShadowMasksUV ("UV", Int) = 0
		[HideInInspector]_LightingShadowMaskStrengthR ("R Strength", Range(0, 1)) = 1
		[HideInInspector]_LightingShadowMaskStrengthG ("G Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingShadowMaskStrengthB ("B Strength", Range(0, 1)) = 0
		[HideInInspector]_LightingShadowMaskStrengthA ("A Strength", Range(0, 1)) = 0
		[HideInInspector][ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _LightDataShadowMaskGlobalMaskR ("Global Mask--{reference_property:_LightDataShadowMaskGlobalMaskBlendTypeR}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _LightDataShadowMaskGlobalMaskBlendTypeR ("Blending", Range(0, 1)) = 2
		[HideInInspector] s_start_LightDataBasePass ("Base Pass (Directional & Baked Lights)--{persistent_expand:true,default_expand:true}", Float) = 1
		[Enum(Poi Custom, 0, Standard, 1, UTS2, 2, OpenLit(lil toon), 3)] _LightingColorMode ("Light Color Mode", Int) = 0
		[Enum(Poi Custom, 0, Normalized NDotL, 1, Saturated NDotL, 2, Casted Shadows Only, 3, SDF, 4)] _LightingMapMode ("Light Map Mode", Int) = 0
		[HideInInspector] s_start_LightDataSDF ("Signed Distance fields--{persistent_expand:true,default_expand:true, condition_showS:(_LightingMapMode==4)}", Float) = 1
		[TextureKeyword][sRGBWarning][ThryRGBAPacker(R, G, Nothing, Nothing, Linear, false)]_LightDataSDFMap ("SDF Map (expand)--{reference_properties:[_LightDataSDFMapPan, _LightDataSDFMapUV]}", 2D) = "white" { }
		[HideInInspector][Vector2]_LightDataSDFMapPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _LightDataSDFMapUV ("UV", Int) = 0
		_LightDataSDFMapLOD ("LOD", Range(0, 1)) = 0
		_LightDataSDFBlendY ("Blend Y Direction", Range(0.001, 2)) = 1
		[HideInInspector] s_end_LightDataSDF ("Signed Distance fields", Float) = 1
		[Enum(Poi Custom, 0, Forced Local Direction, 1, Forced World Direction, 2, UTS2, 3, OpenLit(lil toon), 4, View Direction, 5)] _LightingDirectionMode ("Light Direction Mode", Int) = 0
		[Vector3]_LightngForcedDirection ("Forced Direction--{condition_showS:(_LightingDirectionMode==1 || _LightingDirectionMode==2)}", Vector) = (0, 0, 0)
		_LightingViewDirOffsetPitch ("View Dir Offset Pitch--{condition_showS:_LightingDirectionMode==5}", Range(-90, 90)) = 0
		_LightingViewDirOffsetYaw ("View Dir Offset Yaw--{condition_showS:_LightingDirectionMode==5}", Range(-90, 90)) = 0
		[ToggleUI]_LightingForceColorEnabled ("Force Light Color", Float) = 0
		_LightingForcedColor ("Forced Color--{condition_showS:(_LightingForceColorEnabled==1), reference_property:_LightingForcedColorThemeIndex}", Color) = (1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _LightingForcedColorThemeIndex ("", Int) = 0
		_Unlit_Intensity ("Unlit_Intensity--{condition_showS:(_LightingColorMode==2)}", Range(0.001, 4)) = 1
		[DoNotLock][ToggleUI]_LightingCapEnabled ("Limit Brightness", Float) = 1
		[DoNotLock]_LightingCap ("Max Brightness--{condition_showS:(_LightingCapEnabled==1)}", Range(0, 10)) = 1
		[DoNotLock]_LightingMinLightBrightness ("Min Brightness", Range(0, 1)) = 0
		_LightingIndirectUsesNormals ("Indirect Uses Normals--{condition_showS:(_LightingColorMode==0)}", Range(0, 1)) = 0
		_LightingCastedShadows ("Receive Casted Shadows", Range(0, 1)) = 0
		[DoNotLock]_LightingMonochromatic ("Grayscale Lighting", Range(0, 1)) = 0
		[ToggleUI]_LightingVertexLightingEnabled ("Vertex lights (Non-Important)", Float) = 1
		[ToggleUI]_LightingMirrorVertexLightingEnabled ("Mirror Vertex lights (Non-Important)", Float) = 1
		[ToggleUI]_LightingEnableLightVolumes ("Light Volumes", Float) = 1
		[HideInInspector] s_end_LightDataBasePass ("Base Pass", Float) = 1
		[HideInInspector] s_start_LightDataAddPass ("Add Pass (Point & Spot lights)--{persistent_expand:true,default_expand:true}", Float) = 1
		[ToggleUI]_LightingAdditiveEnable ("Pixel lights (Important)", Float) = 1
		[ToggleUI]_DisableDirectionalInAdd ("Ignore Directional Lights--{condition_showS:(_LightingAdditiveEnable==1)}", Float) = 1
		[ToggleUI]_LightingAdditiveLimited ("Limit Brightness", Float) = 1
		_LightingAdditiveLimit ("Max Brightness--{condition_showS:(_LightingAdditiveLimited==1)}", Range(0, 10)) = 1
		_LightingAdditiveCastedShadows ("Receive Casted Shadows", Range(0, 1)) = 1
		_LightingAdditiveMonochromatic ("Grayscale Lighting", Range(0, 1)) = 0
		_LightingAdditivePassthrough ("Point Light Passthrough--{condition_showS:(_LightingAdditiveEnable==1)}", Range(0, 1)) = .5
		[HideInInspector] s_end_LightDataAddPass ("Add Pass", Float) = 1
		[HideInInspector] s_start_LightDataDebug ("Debug / Data Visualizations--{reference_property:_LightDataDebugEnabled,persistent_expand:true}", Float) = 0
		[HideInInspector][DoNotAnimate][ThryToggleUI(false)]_LightDataDebugEnabled ("Debug", Float) = 0
		[ThryWideEnum(Direct Color, 0, Indirect Color, 1, Light Map, 2, Attenuation, 3, N Dot L, 4, Half Dir, 5, Direction, 6, Add Color, 7, Add Attenuation, 8, Add Shadow, 9, Add N Dot L, 10)] _LightingDebugVisualize ("Visualize", Int) = 0
		[HideInInspector] s_end_LightDataDebug ("Debug", Float) = 0
		[HideInInspector] m_end_PoiLightData ("Light Data", Float) = 0
		[HideInInspector] m_start_PoiShading (" Shading--{reference_property:_ShadingEnabled,button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/main},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(VIGNETTE_MASKED)]_ShadingEnabled ("Enable Shading", Float) = 1
		[DoNotAnimate][KeywordEnum(TextureRamp, Multilayer Math, Wrapped, Skin, ShadeMap, Flat, Realistic, Cloth, SDF)] _LightingMode ("Lighting Type", Float) = 5
		_LightingShadowColor ("Shadow Tint--{condition_showS:(_LightingMode!=4 && _LightingMode!=1 && _LightingMode!=5)}", Color) = (1, 1, 1)
		_ShadowStrength ("Shadow Strength--{condition_showS:(_LightingMode<=4 || _LightingMode==8)}", Range(0, 1)) = 1
		_LightingIgnoreAmbientColor ("Ignore Indirect Shadow Color--{condition_showS:(_LightingMode<=3 || _LightingMode==8)}", Range(0, 1)) = 1
		[Space(15)]
		[HideInInspector] s_start_ShadingAddPass ("Add Pass (Point & Spot Lights)--{persistent_expand:true,default_expand:false}", Float) = 0
		[Enum(Realistic, 0, Toon, 1, Same as Base Pass, 3)] _LightingAdditiveType ("Lighting Type", Int) = 3
		_LightingAdditiveGradientStart ("Gradient Start--{condition_showS:(_LightingAdditiveType==1)}", Range(0, 1)) = 0
		_LightingAdditiveGradientEnd ("Gradient End--{condition_showS:(_LightingAdditiveType==1)}", Range(0, 1)) = .5
		[HideInInspector] s_end_ShadingAddPass ("Add Pass", Float) = 0
		[HideInInspector] s_start_ShadingGlobalMask ("Global Masks--{persistent_expand:true,default_expand:false}", Float) = 0
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _ShadingRampedLightMapApplyGlobalMaskIndex ("LightMap to Global Mask--{reference_property:_ShadingRampedLightMapApplyGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _ShadingRampedLightMapApplyGlobalMaskBlendType ("Blending", Int) = 2
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _ShadingRampedLightMapInverseApplyGlobalMaskIndex ("Inversed LightMap to Global Mask--{reference_property:_ShadingRampedLightMapInverseApplyGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _ShadingRampedLightMapInverseApplyGlobalMaskBlendType ("Blending", Int) = 2
		[HideInInspector] s_end_ShadingGlobalMask ("Global Masks", Float) = 0
		[HideInInspector] m_end_PoiShading ("Shading", Float) = 0
		[HideInInspector] m_start_brdf (" Reflections & Specular--{reference_property:_MochieBRDF,button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/reflections-and-specular},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(MOCHIE_PBR)]_MochieBRDF ("Enable", Float) = 0
		_MochieMetallicMultiplier ("Metallic", Range(0, 1)) = 0
		_MochieRoughnessMultiplier ("Smoothness", Range(0, 1)) = 1
		_MochieReflectionTint ("Reflection Tint--{reference_property:_MochieReflectionTintThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _MochieReflectionTintThemeIndex ("", Int) = 0
		_MochieSpecularTint ("Specular Tint--{reference_property:_MochieSpecularTintThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _MochieSpecularTintThemeIndex ("", Int) = 0
		[sRGBWarning][ThryRGBAPacker(R Metallic Map, G Smoothness Map, B Reflection Mask, A Specular Mask, linear, false)]_MochieMetallicMaps ("Packed Maps [Click to Expand]--{reference_properties:[_MochieMetallicMapsPan, _MochieMetallicMapsUV, _MochieMetallicMapsStochastic, _MochieMetallicMapsMetallicChannel, _MochieMetallicMapsRoughnessChannel, _MochieMetallicMapsReflectionMaskChannel, _MochieMetallicMapsSpecularMaskChannel, _MochieMetallicMapInvert, _MochieRoughnessMapInvert, _MochieReflectionMaskInvert, _MochieSpecularMaskInvert]}", 2D) = "white" { }
		[HideInInspector][Vector2]_MochieMetallicMapsPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)]_MochieMetallicMapsUV ("UV", Int) = 0
		[HideInInspector][ToggleUI]_MochieMetallicMapsStochastic ("Stochastic Sampling", Float) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsMetallicChannel ("Metallic Channel", Float) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsRoughnessChannel ("Smoothness Channel", Float) = 1
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsReflectionMaskChannel ("Reflection Mask Channel", Float) = 2
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3, White, 4)]_MochieMetallicMapsSpecularMaskChannel ("Specular Mask Channel", Float) = 3
		[HideInInspector][ToggleUI]_MochieMetallicMapInvert ("Invert Metallic", Float) = 0
		[HideInInspector][ToggleUI]_MochieRoughnessMapInvert ("Invert Smoothness", Float) = 0
		[HideInInspector][ToggleUI]_MochieReflectionMaskInvert ("Invert Reflection Mask", Float) = 0
		[HideInInspector][ToggleUI]_MochieSpecularMaskInvert ("Invert Specular Mask", Float) = 0
		[Space(10)]
		_MochieReflectionStrength ("Reflection Visibility", Range(0, 1)) = 1
		_MochieSpecularStrength ("Specular Visibility", Range(0, 5)) = 1
		_RefSpecFresnelStrength ("Fresnel Strength", Range(0, 1)) = .5
		_SFExposureOcclusion ("Exposure Occlusion", Range(0, 1)) = 0
		[Space(10)]
		[ThryTexture][NoScaleOffset]_MochieReflCube ("Cubemap", Cube) = "" { }
		[ToggleUI]_MochieForceFallback ("Force Fallback", Int) = 0
		[HideInInspector] s_start_BRDFTPSMaskGroup ("TPS--{condition_showS:(_TPSPenetratorEnabled==1)}", Float) = 0
		[ThryToggleUI(true)] _BRDFTPSDepthEnabled ("<size=13><b>  TPS Depth Enabled</b></size>", Float) = 0
		_BRDFTPSReflectionMaskStrength ("Reflection Mask Strength--{condition_showS:(_BRDFTPSDepthEnabled==1)}", Range(0, 1)) = 1
		_BRDFTPSSpecularMaskStrength ("Specular Mask Strength--{condition_showS:(_BRDFTPSDepthEnabled==1)}", Range(0, 1)) = 1
		[HideInInspector] s_end_BRDFTPSMaskGroup ("", Float) = 0
		[HideInInspector] s_start_ggxanisotropics(" Anisotropics--{reference_property:_GGXAnisotropics,persistent_expand:true,default_expand:false}", Float) = 0
		[HideInInspector][ThryToggle(GGX_ANISOTROPICS)]_GGXAnisotropics ("Enable", Float) = 0
		[sRGBWarning]_AnisotropyMap("Anisotropy Map--{reference_properties:[_AnisotropyMapPan, _AnisotropyMapUV, _AnisotropyMapChannel]}", 2D) = "bump" { }
		[HideInInspector][Vector2]_AnisotropyMapPan("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)] _AnisotropyMapUV ("UV", Int) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3)]_AnisotropyMapChannel ("Channel", Float) = 0
		_Anisotropy ("Anisotropy", Range(-1, 1)) = 0
		_ReflectionAnisotropicStretch("Reflection Stretch", Range(1, 5)) = 1
		_RoughnessAnisotropy("Roughness Anisotropy", Range(0, 1)) = 1
		[HideInInspector] s_end_ggxanisotropics ("", Float) = 0
		[HideInInspector] s_start_PBRSecondSpecular ("2nd Specular--{reference_property:_Specular2ndLayer,persistent_expand:true,default_expand:false}", Float) = 0
		[HideInInspector][ToggleUI]_Specular2ndLayer ("2nd Specular", Float) = 0
		_MochieSpecularStrength2 ("Visibility", Range(0, 5)) = 1
		_MochieRoughnessMultiplier2 ("Smoothness", Range(0, 1)) = 1
		[HideInInspector] s_end_PBRSecondSpecular ("Name", Float) = 0
		[HideInInspector] s_start_PBRSplitMaskSample ("Split Mask Sampling--{reference_property:_PBRSplitMaskSample,persistent_expand:true,default_expand:false}", Float) = 0
		[HideInInspector][ToggleUI]_PBRSplitMaskSample ("Split Mask Sampling", Float) = 0
		[VectorLabel(tX, tY, oX, oY)]_PBRMaskScaleTiling ("Tiling/Offset", Vector) = (1, 1, 0, 0)
		[ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8, Polar UV, 6, Distorted UV, 7, Matcap, 9)]_MochieMetallicMasksUV ("UV", Int) = 0
		[ToggleUI]_PBRSplitMaskStochastic ("Stochastic Sampling", Float) = 0
		[Vector2]_MochieMetallicMasksPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector] s_end_PBRSplitMaskSample ("Split Mask Sampling", Float) = 0
		[HideInInspector] s_start_brdfadvanced ("GSAA & Advanced Controls--{persistent_expand:true,default_expand:false}", Float) = 0
		[ToggleUI]_MochieLitFallback ("Lit Fallback", Float) = 1
		[ToggleUI]_IgnoreCastedShadows ("Ignore Casted Shadows", Float) = 0
		_PBRNormalSelect ("Pixel Normal Mix", Range(0, 1)) = 1
		[ThryToggleUI(true)]_MochieGSAAEnabled ("<size=13><b>  GSAA</b></size>", Float) = 1
		_PoiGSAAVariance ("GSAA Variance--{condition_showS:(_MochieGSAAEnabled==1)}", Range(0, 1)) = 0.15
		_PoiGSAAThreshold ("GSAA Threshold--{condition_showS:(_MochieGSAAEnabled==1)}", Range(0, 1)) = 0.1
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieMetallicGlobalMask ("Metallic--{reference_property:_MochieMetallicGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _MochieMetallicGlobalMaskBlendType ("Blending", Int) = 2
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieSmoothnessGlobalMask ("Smoothness--{reference_property:_MochieSmoothnessGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _MochieSmoothnessGlobalMaskBlendType ("Blending", Int) = 2
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieReflectionStrengthGlobalMask ("Reflection Strength--{reference_property:_MochieReflectionStrengthGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _MochieReflectionStrengthGlobalMaskBlendType ("Blending", Int) = 2
		[ThryWideEnum(Off, 0, 1R, 1, 1G, 2, 1B, 3, 1A, 4, 2R, 5, 2G, 6, 2B, 7, 2A, 8, 3R, 9, 3G, 10, 3B, 11, 3A, 12, 4R, 13, 4G, 14, 4B, 15, 4A, 16)] _MochieSpecularStrengthGlobalMask ("Specular Strength--{reference_property:_MochieSpecularStrengthGlobalMaskBlendType}", Int) = 0
		[HideInInspector][ThryWideEnum(Add, 7, Subtract, 1, Multiply, 2, Divide, 3, Min, 4, Max, 5, Average, 6, Replace, 0)] _MochieSpecularStrengthGlobalMaskBlendType ("Blending", Int) = 2
		[HideInInspector] s_end_brdfadvanced ("", Float) = 0
		[HideInInspector] m_end_brdf ("", Float) = 0
		[HideInInspector] m_start_LTCGI (" LTCGI--{reference_property:_LTCGIEnabled, button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/shading/ltcgi},hover:Documentation}}", Float) = 0
		[HideInInspector] [ThryToggle(POI_LTCGI)]_LTCGIEnabled ("LTCGI Enabled", Float) = 0
		[Helpbox(1)] _LTCGI_Attribution ("This section uses LTCGI by _pi_, click for 'github.com/pimaker/ltcgi'--{onClick:{type:URL,data:https://github.com/pimaker/ltcgi}}", Float) = 0
		[ToggleUI] _LTCGI_AnimToggle ("Anim Toggle", Int) = 1
		_LTCGI_DiffuseColor ("Diffuse Tint--{reference_property:_LTCGI_DiffuseColorThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _LTCGI_DiffuseColorThemeIndex ("", Int) = 0
		_LTCGI_SpecularColor ("Specular Tint--{reference_property:_LTCGI_SpecularColorThemeIndex}", Color) = (1, 1, 1, 1)
		[HideInInspector][ThryWideEnum(Off, 0, Theme Color 0, 1, Theme Color 1, 2, Theme Color 2, 3, Theme Color 3, 4, ColorChord 0, 5, ColorChord 1, 6, ColorChord 2, 7, ColorChord 3, 8, AL Theme 0, 9, AL Theme 1, 10, AL Theme 2, 11, AL Theme 3, 12)] _LTCGI_SpecularColorThemeIndex ("", Int) = 0
		[ToggleUI] _LTCGI_UsePBR ("Use Reflection and Specular's Settings", Int) = 1
		[ToggleUI] _LTCGI_UseEO ("Use Exposure Occlusion--{condition_showS:(_LTCGI_UsePBR==1 && _MochieBRDF==1)}", Int) = 0
		_LTCGI_Smoothness ("Smoothness--{condition_showS:(_LTCGI_UsePBR==0 || _MochieBRDF==0)}", Range(0, 1)) = 0.0
		_LTCGI_Metallic ("Metallic--{condition_showS:(_LTCGI_UsePBR==0 || _MochieBRDF==0)}", Range(0, 1)) = 0.0
		[HideInInspector] m_end_LTCGI ("LTCGI", Float) = 0
		[HideInInspector] m_OutlineCategory (" Outlines--{reference_property:_EnableOutlines,button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/outlines/main},hover:Documentation}}", Float) = 0
		[HideInInspector] m_specialFXCategory ("Special FX", Float) = 0
		[HideInInspector] m_vertexCategory ("Vertex Options", Float) = 0
		[HideInInspector] m_start_vertexManipulation (" Basics & Fun--{reference_property:_VertexManipulationsEnabled, button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/vertex-options/basics},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(AUTO_EXPOSURE)]_VertexManipulationsEnabled ("Enabled", Float) = 0
		[sRGBWarning][ThryRGBAPacker(Mask R, Mask G, Mask B, Mask A, Linear, false)] _VertexBasicsMask ("RGBA Effects Mask [Click to Expand]--{reference_properties:[_VertexBasicsMaskUVPan, VertexBasicsMaskUV]}", 2D) = "white" { }
		[HideInInspector][Vector2] _VertexBasicsMaskUVPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3)] VertexBasicsMaskUV ("UV", Int) = 0
		[ThryWideEnum(R, 0, G, 1, B, 2, A, 3, Vert Col R, 4, Vert Col G, 5, Vert Col B, 6, Vert Col A, 7)] _VertexBasicsMaskChannel ("Basics Mask Channel", Float) = 0
		[Vector3]_VertexManipulationLocalTranslation ("Local Translation", Vector) = (0, 0, 0, 1)
		[Vector3]_VertexManipulationWorldTranslation ("World Translation", Vector) = (0, 0, 0, 1)
		_VertexManipulationLocalScale ("Scale", Vector) = (1, 1, 1, 1)
		[Vector3]_VertexManipulationLocalRotation ("Rotation", Vector) = (0, 0, 0, 1)
		[Vector3]_VertexManipulationLocalRotationSpeed ("Rotation Speed", Vector) = (0, 0, 0, 1)
		[HideInInspector] s_start_VertexManipulationHeight ("Height Map--{persistent_expand:true,default_expand:true}", Float) = 1
		[sRGBWarning] _VertexManipulationHeightMask ("Height Map Texture--{reference_properties:[_VertexManipulationHeightMaskPan, _VertexManipulationHeightMaskUV, _VertexManipulationHeightMapChannel]}", 2D) = "white" { }
		[HideInInspector][Vector2] _VertexManipulationHeightMaskPan ("Panning", Vector) = (0, 0, 0, 0)
		[HideInInspector][Enum(UV0, 0, UV1, 1, UV2, 2, UV3, 3)] _VertexManipulationHeightMaskUV ("UV", Int) = 0
		[HideInInspector][Enum(R, 0, G, 1, B, 2, A, 3)] _VertexManipulationHeightMapChannel ("Map Channel", Float) = 0
		[ThryWideEnum(R, 0, G, 1, B, 2, A, 3, Vert Col R, 4, Vert Col G, 5, Vert Col B, 6, Vert Col A, 7)] _VertexManipulationHeightMaskChannel ("Mask Channel", Float) = 0
		_VertexManipulationHeight ("Height", Float) = 0
		_VertexManipulationHeightBias ("Map Bias", Range(0, 1)) = 0
		[HideInInspector] s_end_VertexManipulationHeight ("Height Map", Float) = 0
		[HideInInspector] s_start_vertexRounding ("Vertex Rounding (Blocky/PS1)--{reference_property:_VertexRoundingEnabled,persistent_expand:true,default_expand:true}", Float) = 0
		[HideInInspector][ToggleUI]_VertexRoundingEnabled ("Rounding Enabled", Float) = 0
		[ThryWideEnum(R, 0, G, 1, B, 2, A, 3, Vert Col R, 4, Vert Col G, 5, Vert Col B, 6, Vert Col A, 7)]_VertexRoundingMaskChannel ("Mask Channel", Float) = 0
		[ThryWideEnum(World, 0, Local, 1)]_VertexRoundingSpace ("Rounding Space", Int) = 0
		_VertexRoundingDivision ("Rounding Interval", Float) = 0.02
		[HideInInspector] s_end_vertexRounding ("Vertex Rounding (Blocky/PS1)", Float) = 0
		[HideInInspector] m_end_vertexManipulation ("Vertex Options", Float) = 0
		[HideInInspector] m_start_Uzumore (" View Clip Prevention (Uzumore)--{reference_property:_UzumoreCategoryToggle,button_author:{text:sigmal00,action:{type:URL,data:https://github.com/sigmal00},hover:GitHub}}, button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/vertex-options/view-clip-prevention},hover:Documentation}}", Float) = 0
		[HideInInspector][ThryToggle(POI_UZUMORE)] _UzumoreCategoryToggle (" View Clip Prevention (Uzumore)", Float) = 0
		[ToggleUI] _UzumoreEnabled ("Animation Toggle", Float) = 1
		_UzumoreAmount ("Push Amount (m)", Float) = 0.1
		_UzumoreBias ("Push Bias", Float) = 0.001
		[sRGBWarning]_UzumoreMask ("Push Mask (A)", 2D) = "white" { }
		[ThryWideEnum(R, 0, G, 1, B, 2, A, 3)] _UzumoreMaskUV ("Push Mask Channel", Float) = 3
		[HideInInspector] m_end_Uzumore ("Camera Push Back", Float) = 0
		[HideInInspector] m_modifierCategory ("Global Modifiers & Data", Float) = 0
		[HideInInspector] m_start_PoiGlobalCategory ("Global Data and Masks", Float) = 0
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
		[HideInInspector] m_start_GlobalMask ("Global Mask--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/modifiers/global-masks},hover:Documentation}}", Float) = 0
		[HideInInspector] m_start_GlobalMaskModifiers ("Modifiers", Float) = 0
		[HideInInspector] m_end_GlobalMaskModifiers ("", Float) = 0
		[HideInInspector] m_end_GlobalMask ("Global Mask", Float) = 0
		[HideInInspector] m_end_PoiGlobalCategory ("Global Data and Masks ", Float) = 0
		[HideInInspector] m_start_PoiUVCategory ("UVs", Float) = 0
		[HideInInspector] m_start_Stochastic ("Stochastic Sampling--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/modifiers/uvs/stochastic-sampling},hover:Documentation}}", Float) = 0
		[KeywordEnum(Deliot Heitz, Hextile, None)] _StochasticMode ("Sampling Mode", Float) = 0
		[HideInInspector] s_start_deliot ("Deliot Heitz--{persistent_expand:true,default_expand:false,condition_show:_StochasticMode==0}", Float) = 0
		_StochasticDeliotHeitzDensity ("Detiling Density", Range(0.1, 10)) = 1
		[HideInInspector] s_end_deliot ("Deliot Heitz", Float) = 0
		[HideInInspector] m_end_Stochastic ("Stochastic Sampling", Float) = 0
		[HideInInspector] m_start_uvLocalWorld ("Local World UV--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/modifiers/uvs/local-world-uv},hover:Documentation}}", Float) = 0
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3, VColor R, 4, VColor G, 5, VColor B, 6, VColor A, 7)] _UVModLocalPos0 ("Local X", Int) = 0
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3, VColor R, 4, VColor G, 5, VColor B, 6, VColor A, 7)] _UVModLocalPos1 ("Local Y", Int) = 1
		[Space(10)]
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3)] _UVModWorldPos0 ("World X", Int) = 0
		[ThryWideEnum(X, 0, Y, 1, Z, 2, Zero, 3)] _UVModWorldPos1 ("World Y", Int) = 2
		[HideInInspector] m_end_uvLocalWorld ("Local World UV", Float) = 0
		[HideInInspector] m_start_uvPanosphere ("Panosphere UV--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/modifiers/uvs/panosphere-uv},hover:Documentation}}", Float) = 0
		[ToggleUI] _StereoEnabled ("Stereo Enabled", Float) = 0
		[ToggleUI] _PanoUseBothEyes ("Perspective Correct (VR)", Float) = 1
		[HideInInspector] m_end_uvPanosphere ("Panosphere UV", Float) = 0
		[HideInInspector] m_start_uvPolar ("Polar UV--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/modifiers/uvs/polar-uv},hover:Documentation}}", Float) = 0
		[ThryWideEnum(UV0, 0, UV1, 1, UV2, 2, UV3, 3, Panosphere, 4, World Pos, 5, Local Pos, 8)] _PolarUV ("UV", Int) = 0
		[Vector2]_PolarCenter ("Center Coordinate", Vector) = (.5, .5, 0, 0)
		_PolarRadialScale ("Radial Scale", Float) = 1
		_PolarLengthScale ("Length Scale", Float) = 1
		_PolarSpiralPower ("Spiral Power", Float) = 0
		[HideInInspector] m_end_uvPolar ("Polar UV", Float) = 0
		[HideInInspector] m_end_PoiUVCategory ("UVs ", Float) = 0
		[HideInInspector] m_start_PoiPostProcessingCategory ("Post Processing", Float) = 0
		[HideInInspector] m_start_PPAnimations ("PP Animations--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/post-processing/pp-animations},hover:Documentation}}", Float) = 0
		[Helpbox(1)] _PPHelp ("This section meant for real time adjustments through animations and not to be changed in unity", Int) = 0
		_PPLightingMultiplier ("Lighting Mulitplier", Float) = 1
		_PPLightingAddition ("Lighting Add", Float) = 0
		_PPEmissionMultiplier ("Emission Multiplier", Float) = 1
		_PPFinalColorMultiplier ("Final Color Multiplier", Float) = 1
		[HideInInspector] m_end_PPAnimations ("PP Animations ", Float) = 0
		[HideInInspector] m_end_PoiPostProcessingCategory ("Post Processing ", Float) = 0
		[HideInInspector] m_thirdpartyCategory ("Third Party", Float) = 0
		[HideInInspector] m_renderingCategory ("Rendering--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/rendering/main},hover:Documentation}}", Float) = 0
		[DoNotAnimate][Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull", Float) = 2
		[DoNotAnimate][Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Float) = 4
		[DoNotAnimate][Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 1
		[DoNotAnimate][ThryMask(Thry.ColorMaskFlags)] _ColorMask ("Color Mask", Int) = 15
		[DoNotAnimate] _OffsetFactor ("Offset Factor", Float) = 0.0
		[DoNotAnimate] _OffsetUnits ("Offset Units", Float) = 0.0
		[DoNotAnimate][ToggleUI] _RenderingReduceClipDistance ("Reduce Clip Distance", Float) = 0
		[DoNotAnimate][ToggleUI] _ZClip ("Z Clip", Float) = 1
		[DoNotAnimate][ToggleUI] _IgnoreFog ("Ignore Fog", Float) = 0
		[DoNotAnimate][ToggleUI]_FlipBackfaceNormals ("Flip Backface Normals", Int) = 1
		[DoNotAnimate][HideInInspector] Instancing ("Instancing", Float) = 0 //add this property for instancing variants settings to be shown
		[ToggleUI] _RenderingEarlyZEnabled ("Early Z", Float) = 0
		[HideInInspector] m_start_blending ("Blending--{button_help:{text:Tutorial,action:{type:URL,data:https://www.poiyomi.com/rendering/blending},hover:Documentation}}", Float) = 0
		[DoNotAnimate][Enum(Thry.BlendOp)] _BlendOp ("RGB Blend Op", Int) = 0
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("RGB Source Blend", Int) = 1
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("RGB Destination Blend", Int) = 0
		[DoNotAnimate][Space][ThryHeaderLabel(Additive Blending, 13)]
		[DoNotAnimate][Enum(Thry.BlendOp)] _AddBlendOp ("RGB Blend Op", Int) = 4
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddSrcBlend ("RGB Source Blend", Int) = 1
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddDstBlend ("RGB Destination Blend", Int) = 1
		[DoNotAnimate][HideInInspector] m_start_alphaBlending ("Advanced Alpha Blending", Float) = 0
		[DoNotAnimate][Enum(Thry.BlendOp)] _BlendOpAlpha ("Alpha Blend Op", Int) = 0
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _SrcBlendAlpha ("Alpha Source Blend", Int) = 1
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _DstBlendAlpha ("Alpha Destination Blend", Int) = 10
		[DoNotAnimate][Space][ThryHeaderLabel(Additive Blending, 13)]
		[DoNotAnimate][Enum(Thry.BlendOp)] _AddBlendOpAlpha ("Alpha Blend Op", Int) = 4
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddSrcBlendAlpha ("Alpha Source Blend", Int) = 0
		[DoNotAnimate][Enum(UnityEngine.Rendering.BlendMode)] _AddDstBlendAlpha ("Alpha Destination Blend", Int) = 1
		[DoNotAnimate][HideInInspector] m_end_alphaBlending ("Advanced Alpha Blending", Float) = 0
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

			Name "Base"
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
			ZTest [_ZTest]
			ColorMask RGBA
			Offset [_OffsetFactor], [_OffsetUnits]
			BlendOp [_BlendOp], [_BlendOpAlpha]
			Blend [_SrcBlend] [_DstBlend], [_SrcBlendAlpha] [_DstBlendAlpha]
			CGPROGRAM

 #define AUTO_EXPOSURE 
 #define MOCHIE_PBR 
 #define POI_LTCGI 
 #define VIGNETTE_MASKED 
 #define _LIGHTINGMODE_REALISTIC 
 #define _STOCHASTICMODE_DELIOT_HEITZ 
 #define PROP_BUMPMAP 
 #define PROP_MOCHIEMETALLICMAPS 
 #define OPTIMIZER_ENABLED 
			#pragma target 5.0
			#pragma multi_compile_fwdbase
			#pragma multi_compile_instancing
			#pragma multi_compile_vertex _ FOG_EXP2
			#pragma multi_compile_fragment _ VERTEXLIGHT_ON
			#define POI_PASS_BASE
			#pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED _MIXED_LIGHTING_SUBTRACTIVE
			#pragma skip_variants DECALS_OFF DECALS_3RT DECALS_4RT DECAL_SURFACE_GRADIENT _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma skip_variants _ADDITIONAL_LIGHT_SHADOWS
			#pragma skip_variants PROBE_VOLUMES_OFF PROBE_VOLUMES_L1 PROBE_VOLUMES_L2
			#pragma skip_variants _SCREEN_SPACE_OCCLUSION
			// #pragma vertex vert
#pragma vertex spsVert

			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#ifndef VRC_LIGHT_VOLUMES_INCLUDED
			#define VRC_LIGHT_VOLUMES_INCLUDED
			#define VRCLV_VERSION 2
			#define VRCLV_MAX_VOLUMES_COUNT 32
			#define VRCLV_MAX_LIGHTS_COUNT 128
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS
			cbuffer LightVolumeUniforms {
				#endif
				uniform float _UdonLightVolumeEnabled;
				uniform float _UdonLightVolumeVersion;
				uniform float _UdonLightVolumeCount;
				uniform float _UdonLightVolumeAdditiveMaxOverdraw;
				uniform float _UdonLightVolumeAdditiveCount;
				uniform float _UdonLightVolumeProbesBlend;
				uniform float _UdonLightVolumeSharpBounds;
				uniform float4x4 _UdonLightVolumeInvWorldMatrix[VRCLV_MAX_VOLUMES_COUNT];
				uniform float4 _UdonLightVolumeRotation[VRCLV_MAX_VOLUMES_COUNT * 2]; // Legacy! Used in this version to have back compatibility with older worlds. Array commented above will be used in future releases! Legacy!
				uniform float3 _UdonLightVolumeInvLocalEdgeSmooth[VRCLV_MAX_VOLUMES_COUNT];
				uniform float3 _UdonLightVolumeUvw[VRCLV_MAX_VOLUMES_COUNT * 6]; // Legacy! AABB Bounds of islands on the 3D Texture atlas. Array commented above will be used in future releases! Legacy!
				uniform float4 _UdonLightVolumeOcclusionUvw[VRCLV_MAX_VOLUMES_COUNT];
				uniform float4 _UdonLightVolumeColor[VRCLV_MAX_VOLUMES_COUNT];
				uniform float _UdonPointLightVolumeCount;
				uniform float _UdonPointLightVolumeCubeCount;
				uniform float4 _UdonPointLightVolumePosition[VRCLV_MAX_LIGHTS_COUNT];
				uniform float4 _UdonPointLightVolumeColor[VRCLV_MAX_LIGHTS_COUNT];
				uniform float4 _UdonPointLightVolumeDirection[VRCLV_MAX_LIGHTS_COUNT];
				uniform float3 _UdonPointLightVolumeCustomID[VRCLV_MAX_LIGHTS_COUNT];
				uniform float _UdonLightBrightnessCutoff;
				uniform float _UdonLightVolumeOcclusionCount;
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS
			}
			#endif
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS
			uniform Texture3D _UdonLightVolume;
			uniform SamplerState sampler_UdonLightVolume;
			uniform Texture2DArray _UdonPointLightVolumeTexture;
			#define LV_SAMPLE(tex, uvw) tex.SampleLevel(sampler_UdonLightVolume, uvw, 0)
			#else
			#define LV_SAMPLE(tex, uvw) float4(0,0,0,0)
			#endif
			#define LV_PI 3.141592653589793f
			#define LV_PI2 6.283185307179586f
			float LV_Smoothstep01(float x) {
				return x * x * (3 - 2 * x);
			}
			float3 LV_MultiplyVectorByQuaternion(float3 v, float4 q) {
				float3 t = 2.0 * cross(q.xyz, v);
				return v + q.w * t + cross(q.xyz, t);
			}
			float3 LV_MultiplyVectorByMatrix2x3(float3 v, float3 r0, float3 r1) {
				float3 r2 = cross(r0, r1);
				return float3(dot(v, r0), dot(v, r1), dot(v, r2));
			}
			float LV_FastAcos(float x) {
				float absX = abs(x);
				float res = -0.156583f * absX + LV_PI * 0.5f;
				res *= sqrt(1.0f - absX);
				return (x >= 0) ? res : (LV_PI - res);
			}
			float LV_DistributionGGX(float NoH, float roughness) {
				float f = (roughness - 1) * ((roughness + 1) * (NoH * NoH)) + 1;
				return (roughness * roughness) / ((float) LV_PI * f * f);
			}
			bool LV_PointLocalAABB(float3 localUVW) {
				return all(abs(localUVW) <= 0.5);
			}
			float3 LV_LocalFromVolume(uint volumeID, float3 worldPos) {
				return mul(_UdonLightVolumeInvWorldMatrix[volumeID], float4(worldPos, 1.0)).xyz;
			}
			float LV_EvaluateSH(float L0, float3 L1, float3 n) {
				return L0 + dot(L1, n);
			}
			float4 LV_SampleCubemapArray(uint id, float3 dir) {
				float3 absDir = abs(dir);
				float2 uv;
				uint face;
				if (absDir.x >= absDir.y && absDir.x >= absDir.z) {
					face = dir.x > 0 ? 0 : 1;
					uv = float2((dir.x > 0 ? -dir.z : dir.z), -dir.y) * rcp(absDir.x);
				} else if (absDir.y >= absDir.z) {
					face = dir.y > 0 ? 2 : 3;
					uv = float2(dir.x, (dir.y > 0 ? dir.z : -dir.z)) * rcp(absDir.y);
				} else {
					face = dir.z > 0 ? 4 : 5;
					uv = float2((dir.z > 0 ? dir.x : -dir.x), -dir.y) * rcp(absDir.z);
				}
				float3 uvid = float3(uv * 0.5 + 0.5, id * 6 + face);
				return LV_SAMPLE(_UdonPointLightVolumeTexture, uvid);
			}
			float4 LV_ProjectQuadLightIrradianceSH(float3 shadingPosition, float3 lightVertices[4]) {
				[unroll] for (uint edge0 = 0; edge0 < 4; edge0++) {
					lightVertices[edge0] = normalize(lightVertices[edge0] - shadingPosition);
				}
				const float3 zhDir0 = float3(0.866025, -0.500001, -0.000004);
				const float3 zhDir1 = float3(-0.759553, 0.438522, -0.480394);
				const float3 zhDir2 = float3(-0.000002, 0.638694,  0.769461);
				const float3 zhWeightL1y = float3(2.1995339f, 2.50785367f, 1.56572711f);
				const float3 zhWeightL1z = float3(-1.82572523f, -2.08165037f, 0.00000000f);
				const float3 zhWeightL1x = float3(2.42459869f, 1.44790525f, 0.90397552f);
				float solidAngle = 0.0;
				float3 surfaceIntegral = 0.0;
				[loop] for (uint edge1 = 0; edge1 < 4; edge1++) {
					uint next = (edge1 + 1) % 4;
					uint prev = (edge1 + 4 - 1) % 4;
					float3 prevVert = lightVertices[prev];
					float3 thisVert = lightVertices[edge1];
					float3 nextVert = lightVertices[next];
					float3 a = cross(thisVert, prevVert);
					float3 b = cross(thisVert, nextVert);
					float lenA = length(a);
					float lenB = length(b);
					solidAngle += LV_FastAcos(clamp(dot(a, b) / (lenA * lenB), -1, 1));
					float3 mu = b * rcp(lenB);
					float cosGamma = dot(thisVert, nextVert);
					float gamma = LV_FastAcos(clamp(cosGamma, -1, 1));
					surfaceIntegral.x += gamma * dot(zhDir0, mu);
					surfaceIntegral.y += gamma * dot(zhDir1, mu);
					surfaceIntegral.z += gamma * dot(zhDir2, mu);
				}
				solidAngle = solidAngle - LV_PI2;
				surfaceIntegral *= 0.5;
				const float normalizationL0 = 0.5f * sqrt(1.0f / LV_PI);
				float l0 = normalizationL0 * solidAngle;
				float l1y = dot(zhWeightL1y, surfaceIntegral);
				float l1z = dot(zhWeightL1z, surfaceIntegral);
				float l1x = dot(zhWeightL1x, surfaceIntegral);
				const float cosineKernelL0 = LV_PI; // (1)
				const float cosineKernelL1 = LV_PI2 / 3.0f; // (1)
				const float oneOverPi = 1.0f / LV_PI; // (2)
				const float normalizationL1 = 0.5f * sqrt(3.0f / LV_PI); // (3)
				const float weightL0 = cosineKernelL0 * normalizationL0 * oneOverPi; // (1), (2), (3)
				const float weightL1 = cosineKernelL1 * normalizationL1 * oneOverPi; // (1), (2), (3)
				l0  *= weightL0;
				l1y *= weightL1;
				l1z *= weightL1;
				l1x *= weightL1;
				return float4(l1x, l1y, l1z, l0);
			}
			void LV_QuadLight(float3 worldPos, float3 centroidPos, float4 rotationQuat, float2 size, float3 color, float sqMaxDist, float occlusion, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, inout uint count) {
				float3 lightToWorldPos = worldPos - centroidPos;
				float3 normal = LV_MultiplyVectorByQuaternion(float3(0, 0, 1), rotationQuat);
				 if (dot(normal, lightToWorldPos) < 0.0) return;
				float sqCutoffDist = sqMaxDist - dot(lightToWorldPos, lightToWorldPos);
				color.rgb *= saturate(sqCutoffDist / sqMaxDist) * LV_PI * occlusion;
				float2 halfSize = size * 0.5f;
				float3 xAxis = LV_MultiplyVectorByQuaternion(float3(1, 0, 0), rotationQuat);
				float3 yAxis = cross(normal, xAxis);
				float3 verts[4];
				verts[0] = centroidPos + (-halfSize.x * xAxis) + ( halfSize.y * yAxis);
				verts[1] = centroidPos + ( halfSize.x * xAxis) + ( halfSize.y * yAxis);
				verts[2] = centroidPos + ( halfSize.x * xAxis) + (-halfSize.y * yAxis);
				verts[3] = centroidPos + (-halfSize.x * xAxis) + (-halfSize.y * yAxis);
				float4 areaLightSH = LV_ProjectQuadLightIrradianceSH(worldPos, verts);
				float lenL1 = length(areaLightSH.xyz);
				if (lenL1 > areaLightSH.w) areaLightSH.xyz *= areaLightSH.w / lenL1;
				L0  += areaLightSH.w * color.rgb;
				L1r += areaLightSH.xyz * color.r;
				L1g += areaLightSH.xyz * color.g;
				L1b += areaLightSH.xyz * color.b;
				count++;
			}
			float3 LV_PointLightAttenuation(float sqdist, float sqlightSize, float3 color, float brightnessCutoff, float sqMaxDist) {
				float mask = saturate(1 - sqdist / sqMaxDist);
				return mask * mask * color * sqlightSize / (sqdist + sqlightSize);
			}
			float LV_PointLightSolidAngle(float sqdist, float sqlightSize) {
				return saturate(sqrt(sqdist / (sqlightSize + sqdist)));
			}
			void LV_SphereLight(float sqdist, float3 dirN, float sqlightSize, float3 color, float occlusion, float sqMaxDist, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, inout uint count) {
				float3 att = LV_PointLightAttenuation(sqdist, sqlightSize, color, _UdonLightBrightnessCutoff, sqMaxDist);
				float3 l0 = att * occlusion;
				float3 l1 = dirN * LV_PointLightSolidAngle(sqdist, sqlightSize);
				L0 += l0;
				L1r += l0.r * l1;
				L1g += l0.g * l1;
				L1b += l0.b * l1;
				count++;
			}
			void LV_SphereSpotLight(float sqdist, float3 dirN, float sqlightSize, float3 att, float spotMask, float cosAngle, float coneFalloff, float occlusion, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, inout uint count) {
				float smoothedCone = LV_Smoothstep01(saturate(spotMask * coneFalloff));
				float3 l0 = att * (occlusion * smoothedCone);
				float3 l1 = dirN * LV_PointLightSolidAngle(sqdist, sqlightSize * saturate(1 - cosAngle));
				L0 += l0;
				L1r += l0.r * l1;
				L1g += l0.g * l1;
				L1b += l0.b * l1;
				count++;
			}
			void LV_SphereSpotLightCookie(float sqdist, float3 dirN, float sqlightSize, float3 att, float4 lightRot, float tanAngle, uint customId, float occlusion, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, inout uint count) {
				float3 localDir = LV_MultiplyVectorByQuaternion(-dirN, lightRot);
				float2 uv = localDir.xy * rcp(localDir.z * tanAngle);
				 if (
				localDir.z <= 0.0 || // Culling by direction
				abs(uv.x) > 1.0 || abs(uv.y) > 1.0 // Culling by UV
				) return;
				uint id = (uint) _UdonPointLightVolumeCubeCount * 5 - customId - 1;
				float3 uvid = float3(uv * 0.5 + 0.5, id);
				float angleSize = saturate(rsqrt(1 + tanAngle * tanAngle));
				float4 cookie = LV_SAMPLE(_UdonPointLightVolumeTexture, uvid);
				float3 l0 = att * cookie.rgb * (cookie.a * occlusion);
				float3 l1 = dirN * LV_PointLightSolidAngle(sqdist, sqlightSize * (1 - angleSize));
				L0 += l0;
				L1r += l0.r * l1;
				L1g += l0.g * l1;
				L1b += l0.b * l1;
				count++;
			}
			void LV_SphereSpotLightAttenuationLUT(float sqdist, float3 dirN, float sqlightSize, float3 color, float spotMask, float cosAngle, uint customId, float occlusion, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, inout uint count) {
				float dirRadius = sqdist * abs(sqlightSize);
				float spot = 1 - saturate(spotMask * rcp(1 - cosAngle));
				uint id = (uint) _UdonPointLightVolumeCubeCount * 5 + customId - 1;
				float3 uvid = float3(sqrt(float2(spot, dirRadius)), id);
				float3 att = color.rgb * LV_SAMPLE(_UdonPointLightVolumeTexture, uvid).xyz * occlusion;
				L0 += att;
				L1r += dirN * att.r;
				L1g += dirN * att.g;
				L1b += dirN * att.b;
				count++;
			}
			void LV_PointLight(uint id, float3 worldPos, float4 occlusion, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, inout uint count) {
				float3 customID_data = _UdonPointLightVolumeCustomID[id];
				int shadowId = (int) customID_data.y; // Shadowmask id
				int customId = (int) customID_data.x; // Custom Texture ID
				float sqrRange = customID_data.z; // Squared culling distance
				float4 pos = _UdonPointLightVolumePosition[id]; // Light position and inversed squared range
				float3 dir = pos.xyz - worldPos;
				float sqlen = max(dot(dir, dir), 1e-6);
				 if (sqlen > sqrRange) return; // Early distance based culling
				float3 dirN = dir * rsqrt(sqlen);
				float lightOcclusion = 1;
				if (_UdonLightVolumeOcclusionCount != 0 && shadowId >= 0) {
					lightOcclusion = dot(occlusion, float4(shadowId == 0, shadowId == 1, shadowId == 2, shadowId == 3));
				}
				float4 color = _UdonPointLightVolumeColor[id]; // Color, angle
				float4 ldir = _UdonPointLightVolumeDirection[id]; // Dir + falloff or Rotation
				 if (pos.w < 0) { // It is a spot light
					float angle = color.w;
					float spotMask = dot(ldir.xyz, -dirN) - angle;
					 if(customId >= 0 && spotMask < 0) return; // Spot cone based culling
					 if (customId > 0) {  // If it uses Attenuation LUT
						LV_SphereSpotLightAttenuationLUT(sqlen, dirN, -pos.w, color.rgb, spotMask, angle, customId, lightOcclusion, L0, L1r, L1g, L1b, count);
					} else { // If it uses default parametric attenuation
						float3 att = LV_PointLightAttenuation(sqlen, -pos.w, color.rgb, _UdonLightBrightnessCutoff, sqrRange);
						 if (customId < 0) { // If uses cookie
							LV_SphereSpotLightCookie(sqlen, dirN, -pos.w, att, ldir, angle, customId, lightOcclusion, L0, L1r, L1g, L1b, count);
						} else { // If it uses default parametric attenuation
							LV_SphereSpotLight(sqlen, dirN, -pos.w, att, spotMask, angle, ldir.w, lightOcclusion, L0, L1r, L1g, L1b, count);
						}
					}
				} else if (color.w <= 1.5f) { // It is a point light
					 if (customId > 0) { // Using LUT
						float invSqRange = abs(pos.w); // Sign of range defines if it's point light (positive) or a spot light (negative)
						float dirRadius = sqlen * invSqRange;
						uint id = (uint) _UdonPointLightVolumeCubeCount * 5 + customId;
						float3 uvid = float3(sqrt(float2(0, dirRadius)), id);
						float3 att = color.rgb * LV_SAMPLE(_UdonPointLightVolumeTexture, uvid).xyz * lightOcclusion;
						L0 += att;
						L1r += dirN * att.r;
						L1g += dirN * att.g;
						L1b += dirN * att.b;
						count++;
					} else { // If it uses default parametric attenuation
						float3 l0 = 0, l1r = 0, l1g = 0, l1b = 0;
						LV_SphereLight(sqlen, dirN, pos.w, color.rgb, lightOcclusion, sqrRange, l0, l1r, l1g, l1b, count);
						float3 cubeColor = 1;
						 if (customId < 0) { // If it uses a cubemap
							uint id = -customId - 1; // Cubemap ID starts from zero and should not take in count texture array slices count.
							cubeColor = LV_SampleCubemapArray(id, LV_MultiplyVectorByQuaternion(dirN, ldir)).xyz;
						}
						L0 += l0 * cubeColor;
						L1r += l1r * cubeColor.r;
						L1g += l1g * cubeColor.g;
						L1b += l1b * cubeColor.b;
					}
				} else { // It is an area light
					LV_QuadLight(worldPos, pos.xyz, ldir, float2(pos.w, color.w - 2.0f), color.rgb, sqrRange, lightOcclusion, L0, L1r, L1g, L1b, count);
				}
			}
			void LV_SampleLightVolumeTex(float3 uvw0, float3 uvw1, float3 uvw2, out float3 L0, out float3 L1r, out float3 L1g, out float3 L1b) {
				float4 tex0 = LV_SAMPLE(_UdonLightVolume, uvw0);
				float4 tex1 = LV_SAMPLE(_UdonLightVolume, uvw1);
				float4 tex2 = LV_SAMPLE(_UdonLightVolume, uvw2);
				L0 = tex0.rgb;
				L1r = float3(tex1.r, tex2.r, tex0.a);
				L1g = float3(tex1.g, tex2.g, tex1.a);
				L1b = float3(tex1.b, tex2.b, tex2.a);
			}
			float LV_BoundsMask(float3 localUVW, float3 invLocalEdgeSmooth) {
				float3 distToMin = (localUVW + 0.5) * invLocalEdgeSmooth;
				float3 distToMax = (0.5 - localUVW) * invLocalEdgeSmooth;
				float3 fade = saturate(min(distToMin, distToMax));
				return fade.x * fade.y * fade.z;
			}
			void LV_SampleLightProbe(inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b) {
				L0 += float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
				L1r += unity_SHAr.xyz;
				L1g += unity_SHAg.xyz;
				L1b += unity_SHAb.xyz;
			}
			void LV_SampleLightProbeDering(inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b) {
				L0 += float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
				L1r += unity_SHAr.xyz * 0.565f;
				L1g += unity_SHAg.xyz * 0.565f;
				L1b += unity_SHAb.xyz * 0.565f;
			}
			void LV_SampleVolume(uint id, float3 localUVW, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, out float4 occlusion) {
				uint uvwID = id * 6;
				float3 uvwScaled = saturate(localUVW + 0.5) * (_UdonLightVolumeUvw[uvwID + 1].xyz - _UdonLightVolumeUvw[uvwID].xyz);
				float3 uvw0 = uvwScaled + _UdonLightVolumeUvw[uvwID].xyz;
				float3 uvw1 = uvwScaled + _UdonLightVolumeUvw[uvwID + 2].xyz;
				float3 uvw2 = uvwScaled + _UdonLightVolumeUvw[uvwID + 4].xyz;
				float3 l0, l1r, l1g, l1b;
				LV_SampleLightVolumeTex(uvw0, uvw1, uvw2, l0, l1r, l1g, l1b);
				float4 uvwOcclusion = _UdonLightVolumeOcclusionUvw[id];
				 if (uvwOcclusion.x >= 0) {
					occlusion = 1.0f - LV_SAMPLE(_UdonLightVolume, uvwOcclusion.xyz + uvwScaled * uvwOcclusion.w);
				} else {
					occlusion = 1;
				}
				float4 color = _UdonLightVolumeColor[id];
				L0 += l0 * color.rgb;
				l1r *= color.r;
				l1g *= color.g;
				l1b *= color.b;
				if (color.a != 0) {
					float3 r0 = _UdonLightVolumeRotation[id * 2].xyz;
					float3 r1 = _UdonLightVolumeRotation[id * 2 + 1].xyz;
					L1r += LV_MultiplyVectorByMatrix2x3(l1r, r0, r1);
					L1g += LV_MultiplyVectorByMatrix2x3(l1g, r0, r1);
					L1b += LV_MultiplyVectorByMatrix2x3(l1b, r0, r1);
				} else {
					L1r += l1r;
					L1g += l1g;
					L1b += l1b;
				}
			}
			float4 LV_SampleVolumeOcclusion(uint id, float3 localUVW) {
				float4 uvwOcclusion = _UdonLightVolumeOcclusionUvw[id];
				 if (uvwOcclusion.x >= 0) {
					uint uvwID = id * 6;
					float3 uvwScaled = saturate(localUVW + 0.5) * (_UdonLightVolumeUvw[uvwID + 1].xyz - _UdonLightVolumeUvw[uvwID].xyz);
					return 1.0f - LV_SAMPLE(_UdonLightVolume, uvwOcclusion.xyz + uvwScaled * uvwOcclusion.w);
				} else {
					return 1;
				}
			}
			void LV_PointLightVolumeSH(float3 worldPos, float4 occlusion, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b) {
				uint pointCount = min((uint) _UdonPointLightVolumeCount, VRCLV_MAX_LIGHTS_COUNT);
				 if (pointCount == 0) return;
				uint maxOverdraw = min((uint) _UdonLightVolumeAdditiveMaxOverdraw, VRCLV_MAX_LIGHTS_COUNT);
				uint pcount = 0; // Point lights counter
				[loop] for (uint pid = 0; pid < pointCount && pcount < maxOverdraw; pid++) {
					LV_PointLight(pid, worldPos, occlusion, L0, L1r, L1g, L1b, pcount);
				}
			}
			void LV_LightVolumeSH(float3 worldPos, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, out float4 occlusion) {
				occlusion = 1;
				float4 mOcclusion = 1; // Multiplicative occlusion. Applies on top of regular occlusion
				uint volumesCount = min((uint) _UdonLightVolumeCount, VRCLV_MAX_VOLUMES_COUNT);
				 if (volumesCount == 0) { // Legacy! Fallback to default light probes if Light Volume are not enabled or a version is too old to have a support. Legacy!
					LV_SampleLightProbe(L0, L1r, L1g, L1b);
					return;
				}
				uint maxOverdraw = min((uint) _UdonLightVolumeAdditiveMaxOverdraw, VRCLV_MAX_VOLUMES_COUNT);
				uint additiveCount = min((uint) _UdonLightVolumeAdditiveCount, VRCLV_MAX_VOLUMES_COUNT);
				bool lightProbesBlend = _UdonLightVolumeProbesBlend;
				uint volumeID_A = -1; // Main, dominant volume ID
				uint volumeID_B = -1; // Secondary volume ID to blend main with
				float3 localUVW   = 0; // Last local UVW to use in disabled Light Probes mode
				float3 localUVW_A = 0; // Main local UVW
				float3 localUVW_B = 0; // Secondary local UVW
				bool isNoA = true;
				bool isNoB = true;
				uint addVolumesCount = 0;
				[loop] for (uint id = 0; id < volumesCount; id++) {
					localUVW = LV_LocalFromVolume(id, worldPos);
					 if (LV_PointLocalAABB(localUVW)) { // Intersection test
						 if (id < additiveCount) { // Sampling additive volumes
							 if (addVolumesCount < maxOverdraw) {
								float4 occ; // Multiplicative occlusion
								LV_SampleVolume(id, localUVW, L0, L1r, L1g, L1b, occ);
								mOcclusion *= occ;
								addVolumesCount++;
							}
						} else if (isNoA) { // First, searching for volume A
							volumeID_A = id;
							localUVW_A = localUVW;
							isNoA = false;
						} else { // Next, searching for volume B if A found
							volumeID_B = id;
							localUVW_B = localUVW;
							isNoB = false;
							break;
						}
					}
				}
				 if (isNoA && lightProbesBlend) {
					LV_SampleLightProbe(L0, L1r, L1g, L1b);
					occlusion *= mOcclusion;
					return;
				}
				localUVW_A = isNoA ? localUVW : localUVW_A;
				volumeID_A = isNoA ? volumesCount - 1 : volumeID_A;
				float3 L0_A  = 0;
				float3 L1r_A = 0;
				float3 L1g_A = 0;
				float3 L1b_A = 0;
				float4 occlusion_A = 1;
				LV_SampleVolume(volumeID_A, localUVW_A, L0_A, L1r_A, L1g_A, L1b_A, occlusion_A);
				float mask = LV_BoundsMask(localUVW_A, _UdonLightVolumeInvLocalEdgeSmooth[volumeID_A]);
				 if (mask == 1 || isNoA || (_UdonLightVolumeSharpBounds && isNoB)) { // Returning SH A result if it's the center of mask or out of bounds
					L0  += L0_A;
					L1r += L1r_A;
					L1g += L1g_A;
					L1b += L1b_A;
					occlusion = occlusion_A;
					occlusion *= mOcclusion;
					return;
				}
				float3 L0_B  = 0;
				float3 L1r_B = 0;
				float3 L1g_B = 0;
				float3 L1b_B = 0;
				float4 occlusion_B = 1;
				 if (isNoB && lightProbesBlend) { // No Volume found and light volumes blending enabled
					LV_SampleLightProbe(L0_B, L1r_B, L1g_B, L1b_B);
				} else { // Blending Volume A and Volume B
					localUVW_B = isNoB ? localUVW : localUVW_B;
					volumeID_B = isNoB ? volumesCount - 1 : volumeID_B;
					LV_SampleVolume(volumeID_B, localUVW_B, L0_B, L1r_B, L1g_B, L1b_B, occlusion_B);
				}
				occlusion = lerp(occlusion_B, occlusion_A, mask);
				occlusion *= mOcclusion;
				L0  += lerp(L0_B,  L0_A,  mask);
				L1r += lerp(L1r_B, L1r_A, mask);
				L1g += lerp(L1g_B, L1g_A, mask);
				L1b += lerp(L1b_B, L1b_A, mask);
			}
			void LV_LightVolumeAdditiveSH(float3 worldPos, inout float3 L0, inout float3 L1r, inout float3 L1g, inout float3 L1b, out float4 occlusion) {
				occlusion = 1;
				float4 mOcclusion = 1; // Multiplicative occlusion. Applies on top of regular occlusion
				uint additiveCount = min((uint) _UdonLightVolumeAdditiveCount, VRCLV_MAX_VOLUMES_COUNT);
				 if (additiveCount == 0 && (uint) _UdonPointLightVolumeCount == 0) return; // Legacy!
				uint volumesCount = min((uint) _UdonLightVolumeCount, VRCLV_MAX_VOLUMES_COUNT);
				uint maxOverdraw = min((uint) _UdonLightVolumeAdditiveMaxOverdraw, VRCLV_MAX_VOLUMES_COUNT);
				uint volumeID_A = -1; // Main, dominant volume ID
				uint volumeID_B = -1; // Secondary volume ID to blend main with
				float3 localUVW   = 0; // Last local UVW to use in disabled Light Probes mode
				float3 localUVW_A = 0; // Main local UVW for Y Axis and Free rotations
				float3 localUVW_B = 0; // Secondary local UVW
				bool isNoA = true;
				bool isNoB = true;
				uint addVolumesCount = 0;
				uint count = min(_UdonLightVolumeOcclusionCount == 0 ? additiveCount : volumesCount, VRCLV_MAX_VOLUMES_COUNT); // Only use all volumes if occlusion volumes are enabled
				[loop] for (uint id = 0; id < count; id++) {
					localUVW = LV_LocalFromVolume(id, worldPos);
					 if (LV_PointLocalAABB(localUVW)) { // Intersection test
						 if (id < additiveCount) { // Sampling additive volumes
							 if (addVolumesCount < maxOverdraw) {
								float4 occ; // Multiplicative occlusion
								LV_SampleVolume(id, localUVW, L0, L1r, L1g, L1b, occ);
								mOcclusion *= occ;
								addVolumesCount++;
							}
						} else if (isNoA) { // First, searching for volume A
							volumeID_A = id;
							localUVW_A = localUVW;
							isNoA = false;
						} else { // Next, searching for volume B if A found
							volumeID_B = id;
							localUVW_B = localUVW;
							isNoB = false;
							break;
						}
					}
				}
				 if (isNoA || _UdonLightVolumeOcclusionCount == 0) {
					occlusion *= mOcclusion;
					return;
				}
				localUVW_A = isNoA ? localUVW : localUVW_A;
				volumeID_A = isNoA ? volumesCount - 1 : volumeID_A;
				occlusion = LV_SampleVolumeOcclusion(volumeID_A, localUVW_A);
				float mask = LV_BoundsMask(localUVW_A, _UdonLightVolumeInvLocalEdgeSmooth[volumeID_A]);
				 if (mask == 1 || (_UdonLightVolumeSharpBounds && isNoB)) {
					occlusion *= mOcclusion;
					return; // Returning A result if it's the center of mask or out of bounds
				}
				 if (isNoB) occlusion = lerp(1, occlusion, mask);
				else occlusion = lerp(LV_SampleVolumeOcclusion(volumeID_B, localUVW_B), occlusion, mask);
				occlusion *= mOcclusion;
			}
			float3 LightVolumeSpecular(float3 f0, float smoothness, float3 worldNormal, float3 viewDir, float3 L0, float3 L1r, float3 L1g, float3 L1b) {
				float3 specColor = max(float3(dot(reflect(-L1r, worldNormal), viewDir), dot(reflect(-L1g, worldNormal), viewDir), dot(reflect(-L1b, worldNormal), viewDir)), 0);
				float3 rDir = normalize(normalize(L1r) + viewDir);
				float3 gDir = normalize(normalize(L1g) + viewDir);
				float3 bDir = normalize(normalize(L1b) + viewDir);
				float rNh = saturate(dot(worldNormal, rDir));
				float gNh = saturate(dot(worldNormal, gDir));
				float bNh = saturate(dot(worldNormal, bDir));
				float roughness = 1 - smoothness * 0.9f;
				float roughExp = roughness * roughness;
				float rSpec = LV_DistributionGGX(rNh, roughExp);
				float gSpec = LV_DistributionGGX(gNh, roughExp);
				float bSpec = LV_DistributionGGX(bNh, roughExp);
				float3 specs = (rSpec + gSpec + bSpec) * f0;
				float3 coloredSpecs = specs * specColor;
				float3 a = coloredSpecs + specs * L0;
				float3 b = coloredSpecs * 3;
				return max(lerp(a, b, smoothness) * 0.5f, 0.0);
			}
			float3 LightVolumeSpecular(float3 albedo, float smoothness, float metallic, float3 worldNormal, float3 viewDir, float3 L0, float3 L1r, float3 L1g, float3 L1b) {
				float3 specularf0 = lerp(0.04f, albedo, metallic);
				return LightVolumeSpecular(specularf0, smoothness, worldNormal, viewDir, L0, L1r, L1g, L1b);
			}
			float3 LightVolumeSpecularDominant(float3 f0, float smoothness, float3 worldNormal, float3 viewDir, float3 L0, float3 L1r, float3 L1g, float3 L1b) {
				float3 dominantDir = L1r + L1g + L1b;
				float3 dir = normalize(normalize(dominantDir) + viewDir);
				float nh = saturate(dot(worldNormal, dir));
				float roughness = 1 - smoothness * 0.9f;
				float roughExp = roughness * roughness;
				float spec = LV_DistributionGGX(nh, roughExp);
				return max(spec * L0 * f0, 0.0) * 1.5f;
			}
			float3 LightVolumeSpecularDominant(float3 albedo, float smoothness, float metallic, float3 worldNormal, float3 viewDir, float3 L0, float3 L1r, float3 L1g, float3 L1b) {
				float3 specularf0 = lerp(0.04f, albedo, metallic);
				return LightVolumeSpecularDominant(specularf0, smoothness, worldNormal, viewDir, L0, L1r, L1g, L1b);
			}
			float3 LightVolumeEvaluate(float3 worldNormal, float3 L0, float3 L1r, float3 L1g, float3 L1b) {
				return float3(LV_EvaluateSH(L0.r, L1r, worldNormal), LV_EvaluateSH(L0.g, L1g, worldNormal), LV_EvaluateSH(L0.b, L1b, worldNormal));
			}
			void LightVolumeSH(float3 worldPos, out float3 L0, out float3 L1r, out float3 L1g, out float3 L1b, float3 worldPosOffset = 0) {
				L0 = 0; L1r = 0; L1g = 0; L1b = 0;
				if (_UdonLightVolumeEnabled == 0) {
					LV_SampleLightProbeDering(L0, L1r, L1g, L1b);
				} else {
					float4 occlusion = 1;
					LV_LightVolumeSH(worldPos + worldPosOffset, L0, L1r, L1g, L1b, occlusion);
					LV_PointLightVolumeSH(worldPos, occlusion, L0, L1r, L1g, L1b);
				}
			}
			void LightVolumeAdditiveSH(float3 worldPos, out float3 L0, out float3 L1r, out float3 L1g, out float3 L1b, float3 worldPosOffset = 0) {
				L0 = 0; L1r = 0; L1g = 0; L1b = 0;
				if (_UdonLightVolumeEnabled != 0) {
					float4 occlusion = 1;
					LV_LightVolumeAdditiveSH(worldPos + worldPosOffset, L0, L1r, L1g, L1b, occlusion);
					LV_PointLightVolumeSH(worldPos, occlusion, L0, L1r, L1g, L1b);
				}
			}
			float3 LightVolumeSH_L0(float3 worldPos, float3 worldPosOffset = 0) {
				if (_UdonLightVolumeEnabled == 0) {
					return float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w);
				} else {
					float3 L0 = 0; float4 occlusion = 1;
					float3 unused_L1; // Let's just pray that compiler will strip everything x.x
					LV_LightVolumeSH(worldPos + worldPosOffset, L0, unused_L1, unused_L1, unused_L1, occlusion);
					LV_PointLightVolumeSH(worldPos, occlusion, L0, unused_L1, unused_L1, unused_L1);
					return L0;
				}
			}
			float3 LightVolumeAdditiveSH_L0(float3 worldPos, float3 worldPosOffset = 0) {
				if (_UdonLightVolumeEnabled == 0) {
					return 0;
				} else {
					float3 L0 = 0; float4 occlusion = 1;
					float3 unused_L1; // Let's just pray that compiler will strip everything x.x
					LV_LightVolumeAdditiveSH(worldPos + worldPosOffset, L0, unused_L1, unused_L1, unused_L1, occlusion);
					LV_PointLightVolumeSH(worldPos, occlusion, L0, unused_L1, unused_L1, unused_L1);
					return L0;
				}
			}
			float LightVolumesEnabled() {
				return _UdonLightVolumeEnabled;
			}
			float LightVolumesVersion() {
				return _UdonLightVolumeVersion == 0 ? _UdonLightVolumeEnabled : _UdonLightVolumeVersion;
			}
			#endif
			SamplerState sampler_linear_clamp;
			SamplerState sampler_linear_repeat;
			SamplerState sampler_trilinear_clamp;
			SamplerState sampler_trilinear_repeat;
			SamplerState sampler_point_clamp;
			SamplerState sampler_point_repeat;
			#define DielectricSpec float4(0.04, 0.04, 0.04, 1.0 - 0.04)
			#define HALF_PI float(1.5707964)
			#define PI float(3.14159265359)
			#define TWO_PI float(6.28318530718)
			#define PI_OVER_2 1.5707963f
			#define PI_OVER_4 0.785398f
			#define EPSILON 0.000001f
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, samplertex, coord, dx, dy) tex.SampleGrad(sampler##samplertex, coord, dx, dy)
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRADD(tex, samp, uv, pan, dx, dy) tex.SampleGrad(samp, POI_PAN_UV(uv, pan), dx, dy)
			#define POI_PAN_UV(uv, pan) (uv + _Time.x * pan)
			#define POI2D_SAMPLER_PAN(tex, texSampler, uv, pan) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, POI_PAN_UV(uv, pan)))
			#define POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, POI_PAN_UV(uv, pan), dx, dy))
			#define POI2D_SAMPLER(tex, texSampler, uv) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, uv))
			#define POI_SAMPLE_1D_X(tex, samp, uv) tex.Sample(samp, float2(uv, 0.5))
			#define POI2D_SAMPLER_GRAD(tex, texSampler, uv, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, uv, dx, dy))
			#define POI2D_SAMPLER_GRADD(tex, texSampler, uv, dx, dy) tex.SampleGrad(texSampler, uv, dx, dy)
			#define POI2D_PAN(tex, uv, pan) (tex2D(tex, POI_PAN_UV(uv, pan)))
			#define POI2D(tex, uv) (tex2D(tex, uv))
			#define POI_SAMPLE_TEX2D(tex, uv) (UNITY_SAMPLE_TEX2D(tex, uv))
			#define POI_SAMPLE_TEX2D_PAN(tex, uv, pan) (UNITY_SAMPLE_TEX2D(tex, POI_PAN_UV(uv, pan)))
			#define POI_SAMPLE_CUBE_LOD(tex, sampler, coord, lod) tex.SampleLevel(sampler, coord, lod)
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define POI_SAMPLE_SCREEN(tex, samp, uv)          tex.Sample(samp, float3(uv, unity_StereoEyeIndex))
			#else
			#define POI_SAMPLE_SCREEN(tex, samp, uv)          tex.Sample(samp, uv)
			#endif
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
			#ifndef UNITY_SPECCUBE_LOD_STEPS
			#define UNITY_SPECCUBE_LOD_STEPS (6)
			#endif
			#ifndef UNITY_LIGHTING_COMMON_INCLUDED
			#define UNITY_LIGHTING_COMMON_INCLUDED
			fixed4 _LightColor0;
			fixed4 _SpecColor;
			struct UnityLight
			{
				half3 color;
				half3 dir;
				half ndotl;
			};
			struct UnityIndirect
			{
				half3 diffuse;
				half3 specular;
			};
			struct UnityGI
			{
				UnityLight light;
				UnityIndirect indirect;
			};
			struct UnityGIInput
			{
				UnityLight light;
				float3 worldPos;
				half3 worldViewDir;
				half atten;
				half3 ambient;
				#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION) || defined(UNITY_ENABLE_REFLECTION_BUFFERS)
				float4 boxMin[2];
				#endif
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
				float4 boxMax[2];
				float4 probePosition[2];
				#endif
				float4 probeHDR[2];
			};
			#endif
			float _GrabMode;
			float _Mode;
			struct Unity_GlossyEnvironmentData
			{
				half roughness;
				half3 reflUVW;
			};
			#ifndef _STOCHASTICMODE_NONE
			#ifdef _STOCHASTICMODE_DELIOT_HEITZ
			float _StochasticDeliotHeitzDensity;
			#endif
			#endif
			#if defined(PROP_LIGHTINGAOMAPS)
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
			#if defined(PROP_LIGHTINGDETAILSHADOWMAPS)
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
			#if defined(PROP_LIGHTINGSHADOWMASKS)
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
			#if defined(PROP_LIGHTDATASDFMAP)
			Texture2D _LightDataSDFMap;
			float4 _LightDataSDFMap_ST;
			float2 _LightDataSDFMapPan;
			float _LightDataSDFMapUV;
			float _LightDataSDFMapLOD;
			float _LightDataSDFBlendY;
			#endif
			float _LightingDirectionMode;
			float3 _LightngForcedDirection;
			float _LightingViewDirOffsetPitch;
			float _LightingViewDirOffsetYaw;
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
			float _LightingMirrorVertexLightingEnabled;
			float _LightingEnableLightVolumes;
			float _LightDataDebugEnabled;
			float _LightingDebugVisualize;
			uint _UdonForceSceneLighting;
			float4 _Color;
			float _ColorThemeIndex;
			UNITY_DECLARE_TEX2D(_MainTex);
			#ifdef UNITY_STEREO_INSTANCING_ENABLED
			#define STEREO_UV(uv) float3(uv, unity_StereoEyeIndex)
			Texture2DArray<float> _CameraDepthTexture;
			#else
			#define STEREO_UV(uv) uv
			Texture2D<float> _CameraDepthTexture;
			#endif
			float SampleScreenDepth(float2 uv)
			{
				uv.y = _ProjectionParams.x * 0.5 + 0.5 - uv.y * _ProjectionParams.x;
				return _CameraDepthTexture.SampleLevel(sampler_point_clamp, STEREO_UV(uv), 0);
			}
			bool DepthTextureExists()
			{
				#ifdef UNITY_STEREO_INSTANCING_ENABLED
				float3 dTexDim;
				_CameraDepthTexture.GetDimensions(dTexDim.x, dTexDim.y, dTexDim.z);
				#else
				float2 dTexDim;
				_CameraDepthTexture.GetDimensions(dTexDim.x, dTexDim.y);
				#endif
				return dTexDim.x > 16;
			}
			float _MainPixelMode;
			float4 _MainTex_ST;
			float2 _MainTexPan;
			float _MainTexUV;
			float4 _MainTex_TexelSize;
			float _MainTexStochastic;
			float _MainIgnoreTexAlpha;
			#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _BumpMap;
			#endif
			float4 _BumpMap_ST;
			float2 _BumpMapPan;
			float _BumpMapUV;
			float _BumpScale;
			float _BumpMapStochastic;
			#if defined(PROP_ALPHAMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _AlphaMask;
			#endif
			float4 _AlphaMask_ST;
			float2 _AlphaMaskPan;
			float _AlphaMaskUV;
			float _AlphaMaskInvert;
			float _MainAlphaMaskMode;
			float _AlphaMaskBlendStrength;
			float _AlphaMaskValue;
			float _Cutoff;
			float _AlphaForceOpaque;
			float _AlphaMod;
			float _AlphaPremultiply;
			float _AlphaBoostFA;
			float _AlphaGlobalMask;
			float _AlphaGlobalMaskBlendType;
			float _IgnoreFog;
			float _RenderingReduceClipDistance;
			int _FlipBackfaceNormals;
			float _AddBlendOp;
			float _Cull;
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
			int _GlobalMaskVertexColorLinearSpace;
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
			#ifdef AUTO_EXPOSURE
			#if defined(PROP_VERTEXBASICSMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _VertexBasicsMask;
			float4 _VertexBasicsMask_ST;
			float4 _VertexBasicsMaskUVPan;
			float VertexBasicsMaskUV;
			float _VertexBasicsMaskChannel;
			#endif
			float4 _VertexManipulationLocalTranslation;
			float4 _VertexManipulationWorldTranslation;
			float4 _VertexManipulationLocalRotation;
			float3 _VertexManipulationLocalRotationSpeed;
			float4 _VertexManipulationLocalScale;
			float _VertexRoundingEnabled;
			int _VertexRoundingSpace;
			float _VertexRoundingDivision;
			float _VertexRoundingMaskChannel;
			#endif
			#ifdef POI_LTCGI
			float4 _LTCGI_DiffuseColor;
			int _LTCGI_DiffuseColorThemeIndex;
			float4 _LTCGI_SpecularColor;
			int _LTCGI_SpecularColorThemeIndex;
			float _LTCGI_Smoothness;
			float _LTCGI_Metallic;
			int _LTCGI_UsePBR;
			int _LTCGI_UseEO;
			int _LTCGI_AnimToggle;
			#endif
			float _ShadowStrength;
			float _LightingIgnoreAmbientColor;
			float3 _LightingShadowColor;
			float _ShadingRampedLightMapApplyGlobalMaskIndex;
			float _ShadingRampedLightMapApplyGlobalMaskBlendType;
			float _ShadingRampedLightMapInverseApplyGlobalMaskIndex;
			float _ShadingRampedLightMapInverseApplyGlobalMaskBlendType;
			float _LightingAdditiveType;
			float _LightingAdditiveGradientStart;
			float _LightingAdditiveGradientEnd;
			float _LightingAdditiveDetailStrength;
			struct MatcapAudioLinkData
			{
				float matcapALEnabled;
				float matcapALAlphaAddBand;
				float4 matcapALAlphaAdd;
				float matcapALEmissionAddBand;
				float4 matcapALEmissionAdd;
				float matcapALIntensityAddBand;
				float4 matcapALIntensityAdd;
				float matcapALChronoPanType;
				float matcapALChronoPanBand;
				float matcapALChronoPanSpeed;
			};
			#ifdef MOCHIE_PBR
			#if defined(PROP_MOCHIEMETALLICMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _MochieMetallicMaps;
			float _PBRMapsStochastic;
			#endif
			float4 _MochieMetallicMaps_ST;
			float2 _MochieMetallicMapsPan;
			float _MochieMetallicMapsUV;
			float _MochieMetallicMapsStochastic;
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
			float _RefSpecFresnelStrength;
			float _SFExposureOcclusion;
			TextureCube _MochieReflCube;
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
			struct tessellatedAppData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 color : COLOR;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				uint vertexId : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOut
			{
				float4 pos : SV_POSITION;
				float4 uv[2] : TEXCOORD0;
				float3 normal : TEXCOORD2;
				float4 tangent : TEXCOORD3;
				float4 worldPos : TEXCOORD4;
				float4 localPos : TEXCOORD5;
				float4 vertexColor : TEXCOORD6;
				float4 lightmapUV : TEXCOORD7;
				float worldDir : TEXCOORD8;
				float2 fogData: TEXCOORD10;
				UNITY_SHADOW_COORDS(12)
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
				float2 uv[10];
				float2 parallaxUV;
				float2 dx;
				float2 dy;
				uint isRightHand;
			};
			struct PoiCam
			{
				float3 viewDir;
				float3 forwardDir;
				float3 worldPos;
				float distanceToVert;
				float4 clipPos;
				float4 screenSpacePosition;
				float3 reflectionDir;
				float3 vertexReflectionDir;
				float3 tangentViewDir;
				float4 posScreenSpace;
				float2 posScreenPixels;
				float2 screenUV;
				float vDotN;
				float4 worldDirection;
			};
			struct PoiMods
			{
				float4 Mask;
				float audioLink[5];
				float audioLinkAvailable;
				float audioLinkVersion;
				float4 audioLinkTexture;
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
				float nDotVCentered;
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
				float3 LTCGISpecular;
				float3 LTCGIDiffuse;
				float directLuminance;
				float indirectLuminance;
				float finalLuminance;
				#if defined(VERTEXLIGHT_ON)
				float4 vDotNL;
				float4 vertexVDotNL;
				float3 vColor[4];
				float4 vCorrectedDotNL;
				float4 vAttenuation;
				float4 vSaturatedDotNL;
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
				float smoothness;
				float smoothness2;
				float metallic;
				float specularMask;
				float reflectionMask;
				float3 baseColor;
				float3 finalColor;
				float alpha;
				float3 emission;
				float toggleVertexLights;
			};
			float4 poiTransformClipSpacetoScreenSpaceFrag(float4 clipPos)
			{
				float4 positionSS = float4(clipPos.xyz * clipPos.w, clipPos.w);
				positionSS.xy = positionSS.xy / _ScreenParams.xy;
				return positionSS;
			}
			static float4 PoiSHAr = 0;
			static float4 PoiSHAg = 0;
			static float4 PoiSHAb = 0;
			static float4 PoiSHBr = 0;
			static float4 PoiSHBg = 0;
			static float4 PoiSHBb = 0;
			static float4 PoiSHC  = 0;
			half3 PoiSHEval_L0L1(half4 normal)
			{
				half3 x;
				x.r = dot(PoiSHAr, normal);
				x.g = dot(PoiSHAg, normal);
				x.b = dot(PoiSHAb, normal);
				return x;
			}
			half3 PoiSHEval_L2(half4 normal)
			{
				half3 x1, x2;
				half4 vB = normal.xyzz * normal.yzzx;
				x1.r = dot(PoiSHBr, vB);
				x1.g = dot(PoiSHBg, vB);
				x1.b = dot(PoiSHBb, vB);
				half  vC = normal.x*normal.x - normal.y*normal.y;
				x2    = PoiSHC.rgb * vC;
				return x1 + x2;
			}
			half3 PoiShadeSH9 (half4 normal)
			{
				half3 res = PoiSHEval_L0L1(normal);
				res += PoiSHEval_L2(normal);
				#ifdef UNITY_COLORSPACE_GAMMA
				res = LinearToGammaSpace(res);
				#endif
				return res;
			}
			inline half4 Pow5(half4 x)
			{
				return x * x * x * x * x;
			}
			inline half3 FresnelLerp(half3 F0, half3 F90, half cosA)
			{
				half t = Pow5(1 - cosA);   // ala Schlick interpoliation
				return lerp(F0, F90, t);
			}
			inline half3 FresnelTerm(half3 F0, half cosA)
			{
				half t = Pow5(1 - cosA);   // ala Schlick interpoliation
				return F0 + (1 - F0) * t;
			}
			half perceptualRoughnessToMipmapLevel(half perceptualRoughness)
			{
				return perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
			}
			half3 Unity_GlossyEnvironment(UNITY_ARGS_TEXCUBE(tex), half4 hdr, Unity_GlossyEnvironmentData glossIn)
			{
				half perceptualRoughness = glossIn.roughness /* perceptualRoughness */ ;
				#if 0
				float m = PerceptualRoughnessToRoughness(perceptualRoughness); // m is the real roughness parameter
				const float fEps = 1.192092896e-07F;        // smallest such that 1.0+FLT_EPSILON != 1.0  (+1e-4h is NOT good here. is visibly very wrong)
				float n = (2.0 / max(fEps, m * m)) - 2.0;        // remap to spec power. See eq. 21 in --> https://dl.dropboxusercontent.com/u/55891920/papers/mm_brdf.pdf
				n /= 4;                                     // remap from n_dot_h formulatino to n_dot_r. See section "Pre-convolved Cube Maps vs Path Tracers" --> https://s3.amazonaws.com/docs.knaldtech.com/knald/1.0.0/lys_power_drops.html
				perceptualRoughness = pow(2 / (n + 2), 0.25);      // remap back to square root of real roughness (0.25 include both the sqrt root of the conversion and sqrt for going from roughness to perceptualRoughness)
				#else
				perceptualRoughness = perceptualRoughness * (1.7 - 0.7 * perceptualRoughness);
				#endif
				half mip = perceptualRoughnessToMipmapLevel(perceptualRoughness);
				half3 R = glossIn.reflUVW;
				half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(tex, R, mip);
				return DecodeHDR(rgbm, hdr);
			}
			half3 UnpackScaleNormalDXT5nm(half4 packednormal, half bumpScale)
			{
				half3 normal;
				normal.xy = (packednormal.wy * 2 - 1);
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				return normal;
			}
			half3 LerpWhiteTo(half3 b, half t)
			{
				half oneMinusT = 1 - t;
				return half3(oneMinusT, oneMinusT, oneMinusT) + b * t;
			}
			inline float GGXTerm(float NdotH, float roughness)
			{
				float a2 = roughness * roughness;
				float d = (NdotH * a2 - NdotH) * NdotH + 1.0f; // 2 mad
				return UNITY_INV_PI * a2 / (d * d + 1e-7f); // This function is not intended to be running on Mobile,
			}
			Unity_GlossyEnvironmentData UnityGlossyEnvironmentSetup(half Smoothness, half3 worldViewDir, half3 Normal, half3 fresnel0)
			{
				Unity_GlossyEnvironmentData g;
				g.roughness /* perceptualRoughness */ = 1 - Smoothness;
				g.reflUVW = reflect(-worldViewDir, Normal);
				return g;
			}
			half3 UnpackScaleNormalRGorAG(half4 packednormal, half bumpScale)
			{
				#if defined(UNITY_NO_DXT5nm)
				half3 normal = packednormal.xyz * 2 - 1;
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				return normal;
				#elif defined(UNITY_ASTC_NORMALMAP_ENCODING)
				half3 normal;
				normal.xy = (packednormal.wy * 2 - 1);
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				normal.xy *= bumpScale;
				return normal;
				#else
				packednormal.x *= packednormal.w;
				half3 normal;
				normal.xy = (packednormal.xy * 2 - 1);
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				return normal;
				#endif
			}
			half3 UnpackScaleNormal(half4 packednormal, half bumpScale)
			{
				return UnpackScaleNormalRGorAG(packednormal, bumpScale);
			}
			half3 BlendNormals(half3 n1, half3 n2)
			{
				return normalize(half3(n1.xy + n2.xy, n1.z * n2.z));
			}
			inline float2 Pow4(float2 x)
			{
				return x * x * x * x;
			}
			inline float3 Unity_SafeNormalize(float3 inVec)
			{
				float dp3 = max(0.001f, dot(inVec, inVec));
				return inVec * rsqrt(dp3);
			}
			inline float3 BoxProjectedCubemapDirection(float3 worldRefl, float3 worldPos, float4 cubemapCenter, float4 boxMin, float4 boxMax)
			{
				
				if (cubemapCenter.w > 0.0)
				{
					float3 nrdir = normalize(worldRefl);
					#if 1
					float3 rbmax = (boxMax.xyz - worldPos) / nrdir;
					float3 rbmin = (boxMin.xyz - worldPos) / nrdir;
					float3 rbminmax = (nrdir > 0.0f) ? rbmax : rbmin;
					#else // Optimized version
					float3 rbmax = (boxMax.xyz - worldPos);
					float3 rbmin = (boxMin.xyz - worldPos);
					float3 select = step(float3(0, 0, 0), nrdir);
					float3 rbminmax = lerp(rbmax, rbmin, select);
					rbminmax /= nrdir;
					#endif
					float fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);
					worldPos -= cubemapCenter.xyz;
					worldRefl = worldPos + nrdir * fa;
				}
				return worldRefl;
			}
			inline half3 UnityGI_IndirectSpecular(UnityGIInput data, half occlusion, Unity_GlossyEnvironmentData glossIn)
			{
				half3 specular;
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
				half3 originalReflUVW = glossIn.reflUVW;
				glossIn.reflUVW = BoxProjectedCubemapDirection(originalReflUVW, data.worldPos, data.probePosition[0], data.boxMin[0], data.boxMax[0]);
				#endif
				#ifdef _GLOSSYREFLECTIONS_OFF
				specular = unity_IndirectSpecColor.rgb;
				#else
				half3 env0 = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE(unity_SpecCube0), data.probeHDR[0], glossIn);
				#ifdef UNITY_SPECCUBE_BLENDING
				const float kBlendFactor = 0.99999;
				float blendLerp = data.boxMin[0].w;
				
				if (blendLerp < kBlendFactor)
				{
					#ifdef UNITY_SPECCUBE_BOX_PROJECTION
					glossIn.reflUVW = BoxProjectedCubemapDirection(originalReflUVW, data.worldPos, data.probePosition[1], data.boxMin[1], data.boxMax[1]);
					#endif
					half3 env1 = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1, unity_SpecCube0), data.probeHDR[1], glossIn);
					specular = lerp(env1, env0, blendLerp);
				}
				else
				{
					specular = env0;
				}
				#else
				specular = env0;
				#endif
				#endif
				return specular * occlusion;
			}
			inline half3 UnityGI_IndirectSpecular(UnityGIInput data, half occlusion, half3 normalWorld, Unity_GlossyEnvironmentData glossIn)
			{
				return UnityGI_IndirectSpecular(data, occlusion, glossIn);
			}
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
					return o.uv[0].xy;
					case 1:
					return o.uv[0].zw;
					case 2:
					return o.uv[1].xy;
					case 3:
					return o.uv[1].zw;
					default:
					return o.uv[0].xy;
				}
			}
			float2 vertexUV(in appdata v, int index)
			{
				switch(index)
				{
					case 0:
					return v.uv0.xy;
					case 1:
					return v.uv1.xy;
					case 2:
					return v.uv2.xy;
					case 3:
					return v.uv3.xy;
					default:
					return v.uv0.xy;
				}
			}
			float calculateluminance(float3 color)
			{
				return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
			}
			float dotToDegrees(float dot)
			{
				dot = clamp(dot, -1.0, 1.0);
				return degrees(acos(dot));
			}
			float dotToDegrees(float3 a, float3 b)
			{
				return dotToDegrees(dot(normalize(a), normalize(b)));
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
				float3 L0 = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w) + float3(PoiSHBr.z, PoiSHBg.z, PoiSHBb.z) / 3.0;
				indirect.r = shEvaluateDiffuseL1Geomerics_local(L0.r, PoiSHAr.xyz, normal.xyz);
				indirect.g = shEvaluateDiffuseL1Geomerics_local(L0.g, PoiSHAg.xyz, normal.xyz);
				indirect.b = shEvaluateDiffuseL1Geomerics_local(L0.b, PoiSHAb.xyz, normal.xyz);
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
				x.r = length(PoiSHAr);
				x.g = length(PoiSHAg);
				x.b = length(PoiSHAb);
				x1.r = length(PoiSHBr);
				x1.g = length(PoiSHBg);
				x1.b = length(PoiSHBb);
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
			float blendOverlay(float base, float blend)
			{
				return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
			}
			float3 blendOverlay(float3 base, float3 blend)
			{
				return float3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
			}
			float blendLighten(float base, float blend)
			{
				return max(blend, base);
			}
			float3 blendLighten(float3 base, float3 blend)
			{
				return float3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
			}
			float blendLinearDodge(float base, float blend)
			{
				return min(base + blend, 1.0);
			}
			float3 blendLinearDodge(float3 base, float3 blend)
			{
				return base + blend;
			}
			float blendMultiply(float base, float blend)
			{
				return base * blend;
			}
			float3 blendMultiply(float3 base, float3 blend)
			{
				return base * blend;
			}
			float blendNormal(float base, float blend)
			{
				return blend;
			}
			float3 blendNormal(float3 base, float3 blend)
			{
				return blend;
			}
			float blendScreen(float base, float blend)
			{
				return 1.0 - ((1.0 - base) * (1.0 - blend));
			}
			float3 blendScreen(float3 base, float3 blend)
			{
				return float3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
			}
			float blendSubtract(float base, float blend)
			{
				return max(base - blend, 0.0);
			}
			float3 blendSubtract(float3 base, float3 blend)
			{
				return max(base - blend, 0.0);
			}
			float blendMixed(float base, float blend)
			{
				return base + base * blend;
			}
			float3 blendMixed(float3 base, float3 blend)
			{
				return base + base * blend;
			}
			float3 customBlend(float3 base, float3 blend, float blendType, float alpha = 1)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 1: output = lerp(base, blendDarken(base, blend), alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 5: output = lerp(base, blendLighten(base, blend), alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 7: output = blendSubtract(base, blend * alpha); break;
					case 8: output = lerp(base, blendLinearDodge(base, blend), alpha); break;
					case 9: output = lerp(base, blendOverlay(base, blend), alpha); break;
					case 20: output = lerp(base, blendMixed(base, blend), alpha); break;
					default: output = 0; break;
				}
				return output;
			}
			float3 customBlend(float base, float blend, float blendType, float alpha = 1)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 5: output = lerp(base, blendLighten(base, blend), alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 7: output = blendSubtract(base, blend * alpha); break;
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
			float globalMaskBlend(float baseMask, float globalMaskIndex, float blendType, PoiMods poiMods)
			{
				if (globalMaskIndex == 0)
				{
					return baseMask;
				}
				else
				{
					return maskBlend(baseMask, poiMods.globalMask[globalMaskIndex - 1], blendType);
				}
			}
			inline float poiRand(float2 co)
			{
				float3 p3 = frac(float3(co.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.x + p3.y) * p3.z);
			}
			inline float4 poiRand4(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				float2 a = frac((p3.xx + p3.yz) * p3.zy);
				float2 s2 = seed + 37.0;
				float3 q3 = frac(float3(s2.xyx) * 0.1031);
				q3 += dot(q3, q3.yzx + 33.33);
				float2 b = frac((q3.xx + q3.yz) * q3.zy);
				return float4(a, b);
			}
			inline float2 poiRand2(float seed)
			{
				float2 x = float2(seed, seed * 1.3);
				float3 p3 = frac(float3(x.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			inline float2 poiRand2(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			inline float poiRand3(float seed)
			{
				float p = frac(seed * 0.1031);
				p *= p + 33.33;
				p *= p + p;
				return frac(p);
			}
			inline float3 poiRand3(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			inline float3 poiRand3(float3 seed)
			{
				float3 p3 = frac(seed * 0.1031);
				p3 += dot(p3, p3.zyx + 31.32);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			inline float3 poiRand3Range(float2 Seed, float Range)
			{
				float3 r = poiRand3(Seed);
				return (r * 2.0 - 1.0) * Range;
			}
			float3 randomFloat3WiggleRange(float2 Seed, float Range, float wiggleSpeed, float timeOffset)
			{
				float3 rando = (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1);
				float speed = 1 + wiggleSpeed;
				return float3(sin(((_Time.x + timeOffset) + rando.x * PI) * speed), sin(((_Time.x + timeOffset) + rando.y * PI) * speed), sin(((_Time.x + timeOffset) + rando.z * PI) * speed)) * Range;
			}
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
				float H = abs((Q.w - Q.y) / (6 * C + EPSILON) + Q.z);
				return float3(H, C, Q.x);
			}
			float3 RGBtoHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
			float3 HSVtoRGB(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
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
			float4x4 brightnessMatrix(float brightness)
			{
				return float4x4(
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				brightness, brightness, brightness, 1
				);
			}
			float4x4 contrastMatrix(float contrast)
			{
				float t = (1.0 - contrast) / 2.0;
				return float4x4(
				contrast, 0, 0, 0,
				0, contrast, 0, 0,
				0, 0, contrast, 0,
				t, t, t, 1
				);
			}
			float4x4 saturationMatrix(float saturation)
			{
				float3 luminance = float3(0.3086, 0.6094, 0.0820);
				float oneMinusSat = 1.0 - saturation;
				float3 red = luminance.x * oneMinusSat;
				red += float3(saturation, 0, 0);
				float3 green = luminance.y * oneMinusSat;
				green += float3(0, saturation, 0);
				float3 blue = luminance.z * oneMinusSat;
				blue += float3(0, 0, saturation);
				return float4x4(
				red, 0,
				green, 0,
				blue, 0,
				0, 0, 0, 1
				);
			}
			float4 PoiColorBCS(float4 color, float brightness, float contrast, float saturation)
			{
				return mul(color, mul(brightnessMatrix(brightness), mul(contrastMatrix(contrast), saturationMatrix(saturation))));
			}
			float3 PoiColorBCS(float3 color, float brightness, float contrast, float saturation)
			{
				return mul(float4(color, 1), mul(brightnessMatrix(brightness), mul(contrastMatrix(contrast), saturationMatrix(saturation)))).rgb;
			}
			float3 linear_srgb_to_oklab(float3 c)
			{
				float l = 0.4122214708 * c.x + 0.5363325363 * c.y + 0.0514459929 * c.z;
				float m = 0.2119034982 * c.x + 0.6806995451 * c.y + 0.1073969566 * c.z;
				float s = 0.0883024619 * c.x + 0.2817188376 * c.y + 0.6299787005 * c.z;
				float l_ = pow(l, 1.0 / 3.0);
				float m_ = pow(m, 1.0 / 3.0);
				float s_ = pow(s, 1.0 / 3.0);
				return float3(
				0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
				1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
				0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
				);
			}
			float3 oklab_to_linear_srgb(float3 c)
			{
				float l_ = c.x + 0.3963377774 * c.y + 0.2158037573 * c.z;
				float m_ = c.x - 0.1055613458 * c.y - 0.0638541728 * c.z;
				float s_ = c.x - 0.0894841775 * c.y - 1.2914855480 * c.z;
				float l = l_ * l_ * l_;
				float m = m_ * m_ * m_;
				float s = s_ * s_ * s_;
				return float3(
				+ 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
				- 1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
				- 0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
				);
			}
			float3 hueShiftOKLab(float3 color, float shift, float selectOrShift)
			{
				float3 oklab = linear_srgb_to_oklab(color);
				float chroma = length(oklab.yz);
				oklab.y = selectOrShift > 0.5 ? oklab.y : chroma;
				oklab.z = selectOrShift > 0.5 ? oklab.z : 0;
				float s, c;
				sincos(shift * TWO_PI, s, c);
				oklab.yz = float2(c * oklab.y - s * oklab.z, s * oklab.y + c * oklab.z);
				return oklab_to_linear_srgb(oklab);
			}
			float3 hueShiftHSV(float3 color, float hueOffset, float selectOrShift)
			{
				float3 hsvCol = RGBtoHSV(color);
				hsvCol.x = hsvCol.x * selectOrShift + hueOffset;
				return HSVtoRGB(hsvCol);
			}
			float3 hueShift(float3 color, float shift, float ColorSpace, float selectOrShift)
			{
				switch(ColorSpace)
				{
					case 0.0:
					return hueShiftOKLab(color, shift, selectOrShift);
					case 1.0:
					return hueShiftHSV(color, shift, selectOrShift);
					default:
					return float3(1.0, 0.0, 0.0);
				}
			}
			float4 hueShift(float4 color, float shift, float ColorSpace, float selectOrShift)
			{
				return float4(hueShift(color.rgb, shift, ColorSpace, selectOrShift), color.a);
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
			float3 _VRChatMirrorCameraPos;
			float3 getCameraPosition()
			{
				#ifdef USING_STEREO_MATRICES
				return unity_StereoWorldSpaceCameraPos[0] * .5 + unity_StereoWorldSpaceCameraPos[1] * .5;
				#endif
				return _VRChatMirrorMode == 1 ? _VRChatMirrorCameraPos : _WorldSpaceCameraPos;
			}
			#ifdef POI_AUDIOLINK
			inline int poiALBandPass(int bandIdx)
			{
				bandIdx = clamp(bandIdx, 0, 3);
				return bandIdx == 0 ? ALPASS_AUDIOBASS : bandIdx == 1 ? ALPASS_AUDIOLOWMIDS : bandIdx == 2 ? ALPASS_AUDIOHIGHMIDS : ALPASS_AUDIOTREBLE;
			}
			#endif
			float2 calcPixelScreenUVs(half4 grabPos)
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
			float4 QuaternionFromMatrix(
			float m00, float m01, float m02,
			float m10, float m11, float m12,
			float m20, float m21, float m22)
			{
				float4 q;
				float trace = m00 + m11 + m22;
				if (trace > 0)
				{
					float s = sqrt(trace + 1) * 2;
					q.w = 0.25 * s;
					q.x = (m21 - m12) / s;
					q.y = (m02 - m20) / s;
					q.z = (m10 - m01) / s;
				}
				else if (m00 > m11 && m00 > m22)
				{
					float s = sqrt(1 + m00 - m11 - m22) * 2;
					q.w = (m21 - m12) / s;
					q.x = 0.25 * s;
					q.y = (m01 + m10) / s;
					q.z = (m02 + m20) / s;
				}
				else if (m11 > m22)
				{
					float s = sqrt(1 + m11 - m00 - m22) * 2;
					q.w = (m02 - m20) / s;
					q.x = (m01 + m10) / s;
					q.y = 0.25 * s;
					q.z = (m12 + m21) / s;
				}
				else
				{
					float s = sqrt(1 + m22 - m00 - m11) * 2;
					q.w = (m10 - m01) / s;
					q.x = (m02 + m20) / s;
					q.y = (m12 + m21) / s;
					q.z = 0.25 * s;
				}
				return q;
			}
			float4 MulQuat(float4 a, float4 b)
			{
				return float4(
				a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
				a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
				a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w,
				a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z
				);
			}
			float4 QuaternionFromBasis(float3 sx, float3 sy, float3 sz)
			{
				return QuaternionFromMatrix(
				sx.x, sy.x, sz.x,
				sx.y, sy.y, sz.y,
				sx.z, sy.z, sz.z
				);
			}
			float4 BuildQuatFromForwardUp(float3 forward, float3 up)
			{
				float3 f = normalize(forward);
				float3 u = normalize(up);
				float3 x = normalize(cross(u, f));
				float3 y = cross(f, x);
				return QuaternionFromBasis(x, y, f);
			}
			float3 QuaternionToEuler(float4 q)
			{
				float3 euler;
				float sinr_cosp = 2 * (q.w * q.z + q.x * q.y);
				float cosr_cosp = 1 - 2 * (q.z * q.z + q.x * q.x);
				euler.z = atan2(sinr_cosp, cosr_cosp) * 57.2958;
				float sinp = 2 * (q.w * q.x - q.y * q.z);
				if (abs(sinp) >= 1)
				euler.x = (sinp >= 0 ? 1 : - 1) * 90;
				else
				euler.x = asin(sinp) * 57.2958;
				float siny_cosp = 2 * (q.w * q.y + q.z * q.x);
				float cosy_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
				euler.y = atan2(siny_cosp, cosy_cosp) * 57.2958;
				return euler;
			}
			float4 EulerToQuaternion(float3 euler)
			{
				float3 eulerRad = euler * 0.0174533;
				float cx = cos(eulerRad.x * 0.5);
				float sx = sin(eulerRad.x * 0.5);
				float cy = cos(eulerRad.y * 0.5);
				float sy = sin(eulerRad.y * 0.5);
				float cz = cos(eulerRad.z * 0.5);
				float sz = sin(eulerRad.z * 0.5);
				float4 q;
				q.w = cx * cy * cz + sx * sy * sz;
				q.x = sx * cy * cz - cx * sy * sz;
				q.y = cx * sy * cz + sx * cy * sz;
				q.z = cx * cy * sz - sx * sy * cz;
				return q;
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
			float3 RotateByQuaternion(float4 q, float3 v)
			{
				float3 u = q.xyz;
				float s = q.w;
				return 2.0 * dot(u, v) * u
				+ (s * s - dot(u, u)) * v
				+ 2.0 * s * cross(u, v);
			}
			float4 SlerpQuaternion(float4 qa, float4 qb, float t)
			{
				float cosHalfTheta = dot(qa, qb);
				if (cosHalfTheta < 0.0)
				{
					qb = -qb;
					cosHalfTheta = -cosHalfTheta;
				}
				if (cosHalfTheta > 0.9995)
				{
					float4 qr = normalize(qa * (1 - t) + qb * t);
					return qr;
				}
				float halfTheta = acos(cosHalfTheta);
				float sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta);
				float a = sin((1 - t) * halfTheta) / sinHalfTheta;
				float b = sin(t * halfTheta) / sinHalfTheta;
				return qa * a + qb * b;
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
			float3 RotateAroundAxis(float3 original, float3 axis, float radian)
			{
				float s = sin(radian);
				float c = cos(radian);
				float one_minus_c = 1.0 - c;
				axis = normalize(axis);
				float3x3 rot_mat = {
					one_minus_c * axis.x * axis.x + c, one_minus_c * axis.x * axis.y - axis.z * s, one_minus_c * axis.z * axis.x + axis.y * s,
					one_minus_c * axis.x * axis.y + axis.z * s, one_minus_c * axis.y * axis.y + c, one_minus_c * axis.y * axis.z - axis.x * s,
					one_minus_c * axis.z * axis.x - axis.y * s, one_minus_c * axis.y * axis.z + axis.x * s, one_minus_c * axis.z * axis.z + c
				};
				return mul(rot_mat, original);
			}
			float3 poiThemeColor(in PoiMods poiMods, in float3 srcColor, in float themeIndex)
			{
				float3 outputColor = srcColor;
				if (themeIndex != 0)
				{
					themeIndex = max(themeIndex - 1, 0);
					if (themeIndex <= 3)
					{
						outputColor = poiMods.globalColorTheme[themeIndex];
					}
					else
					{
						#ifdef POI_AUDIOLINK
						if (poiMods.audioLinkAvailable)
						{
							outputColor = poiMods.globalColorTheme[themeIndex];
						}
						#endif
					}
				}
				return outputColor;
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
			float3 lilBlendColor(float3 dstCol, float3 srcCol, float3 srcA, int blendMode)
			{
				float3 ad = dstCol + srcCol;
				float3 mu = dstCol * srcCol;
				float3 outCol = float3(0, 0, 0);
				if (blendMode == 0) outCol = srcCol; // Normal
				if (blendMode == 1) outCol = ad; // Add
				if (blendMode == 2) outCol = max(ad - mu, dstCol); // Screen
				if (blendMode == 3) outCol = mu; // Multiply
				return lerp(dstCol, outCol, srcA);
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
				return (value - borderMin) / max(saturate(borderMax - borderMin + fwidth(value)), .0001);
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / max(saturate(borderMax - borderMin + fwidth(value)), .0001);
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
			float3 AdjustLitLuminance(float3 rgb, float targetLuminance)
			{
				float currentLuminance;
				#if defined(UNITY_COLORSPACE_GAMMA)
				currentLuminance = dot(rgb, float3(0.22, 0.707, 0.071));
				#else
				currentLuminance = dot(rgb, float3(0.0396819152, 0.458021790, 0.00609653955));
				#endif
				float luminanceRatio = targetLuminance / currentLuminance;
				return rgb * luminanceRatio;
			}
			float3 ClampLuminance(float3 rgb, float minLuminance, float maxLuminance)
			{
				float currentLuminance = dot(rgb, float3(0.299, 0.587, 0.114));
				float minRatio = (currentLuminance != 0) ? minLuminance / currentLuminance : 1.0;
				float maxRatio = (currentLuminance != 0) ? maxLuminance / currentLuminance : 1.0;
				float luminanceRatio = clamp(min(maxRatio, max(minRatio, 1.0)), 0.0, 1.0);
				return lerp(rgb, rgb * luminanceRatio, luminanceRatio < 1.0);
			}
			float3 MaxLuminance(float3 rgb, float maxLuminance)
			{
				float currentLuminance = dot(rgb, float3(0.299, 0.587, 0.114));
				float luminanceRatio = (currentLuminance != 0) ? maxLuminance / max(currentLuminance, 0.00001) : 1.0;
				return lerp(rgb, rgb * luminanceRatio, currentLuminance > maxLuminance);
			}
			float OpenLitGray(float3 rgb)
			{
				return dot(rgb, float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
			}
			void OpenLitShadeSH9ToonDouble(float3 lightDirection, out float3 shMax, out float3 shMin)
			{
				#if !defined(LIGHTMAP_ON)
				float3 N = lightDirection * 0.666666;
				float4 vB = N.xyzz * N.yzzx;
				float3 res = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w);
				res.r += dot(PoiSHBr, vB);
				res.g += dot(PoiSHBg, vB);
				res.b += dot(PoiSHBb, vB);
				res += PoiSHC.rgb * (N.x * N.x - N.y * N.y);
				float3 l1;
				l1.r = dot(PoiSHAr.rgb, N);
				l1.g = dot(PoiSHAg.rgb, N);
				l1.b = dot(PoiSHAb.rgb, N);
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
				#if !defined(LIGHTMAP_ON)
				float3 sh9Dir = PoiSHAr.xyz * 0.333333 + PoiSHAg.xyz * 0.333333 + PoiSHAb.xyz * 0.333333;
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
				float3 sh9Dir = PoiSHAr.xyz * 0.333333 + PoiSHAg.xyz * 0.333333 + PoiSHAb.xyz * 0.333333;
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
			inline float CorrectedLinearEyeDepth(float z, float correctionFactor)
			{
				return 1.f / (z / UNITY_MATRIX_P._34 + correctionFactor);
			}
			float evalRamp4(float time, float4 ramp)
			{
				return lerp(ramp.x, ramp.y, smoothstep(ramp.z, ramp.w, time));
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
				const float4 C = float4(0.211324865405187, // (3.0 - sqrt(3.0)) / 6.0
				0.366025403784439, // 0.5 * (sqrt(3.0) - 1.0)
				- 0.577350269189626, // - 1.0 + 2.0 * C.x
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
			float poiInvertToggle(in float value, in float toggle)
			{
				return (toggle == 0 ? value : 1 - value);
			}
			float3 PoiBlendNormal(float3 dstNormal, float3 srcNormal)
			{
				return float3(dstNormal.xy + srcNormal.xy, dstNormal.z * srcNormal.z);
			}
			float3 lilTransformDirOStoWS(float3 directionOS, bool doNormalize)
			{
				if (doNormalize) return normalize(mul((float3x3)unity_ObjectToWorld, directionOS));
				else            return mul((float3x3)unity_ObjectToWorld, directionOS);
			}
			float2 poiGetWidthAndHeight(Texture2D tex)
			{
				uint width, height;
				tex.GetDimensions(width, height);
				return float2(width, height);
			}
			float2 poiGetWidthAndHeight(Texture2DArray tex)
			{
				uint width, height, element;
				tex.GetDimensions(width, height, element);
				return float2(width, height);
			}
			bool SceneHasReflections()
			{
				float width, height;
				unity_SpecCube0.GetDimensions(width, height);
				return !(width * height < 2);
			}
			void applyUnityFog(inout float3 col, float2 fogData)
			{
				if (0.0 == 0)
				{
					float fogFactor = 1.0;
					float depth = UNITY_Z_0_FAR_FROM_CLIPSPACE(fogData.x);
					if (unity_FogParams.z != unity_FogParams.w)
					{
						fogFactor = depth * unity_FogParams.z + unity_FogParams.w;
					}
					else if (fogData.y)
					{
						float exponent_val = unity_FogParams.x * depth;
						fogFactor = exp2(-exponent_val * exponent_val);
					}
					else if (unity_FogParams.y != 0.0f)
					{
						float exponent = unity_FogParams.y * depth;
						fogFactor = exp2(-exponent);
					}
					fixed3 appliedFogColor = unity_FogColor.rgb;
					#if defined(UNITY_PASS_FORWARDADD)
					appliedFogColor = fixed3(0, 0, 0);
					#endif
					col.rgb = lerp(appliedFogColor, col.rgb, saturate(fogFactor));
				}
			}
			void applyReducedRenderClipDistance(inout VertexOut o)
			{
				if (o.pos.w < _ProjectionParams.y * 1.01 && o.pos.w > 0)
				{
					#if defined(UNITY_REVERSED_Z) // DirectX
					o.pos.z = o.pos.z * 0.0001 + o.pos.w * 0.999;
					#else // OpenGL
					o.pos.z = o.pos.z * 0.0001 - o.pos.w * 0.999;
					#endif
				}
			}
			VertexOut vert(appdata v)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				VertexOut o;
				PoiInitStruct(VertexOut, o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				#ifdef POI_TESSELLATED
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(v);
				#endif
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				#ifdef POI_AUDIOLINK
				float vertexAudioLink[5];
				vertexAudioLink[0] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 0))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 0))[0];
				vertexAudioLink[1] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 1))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 1))[0];
				vertexAudioLink[2] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 2))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 2))[0];
				vertexAudioLink[3] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 3))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 3))[0];
				vertexAudioLink[4] = AudioLinkData(ALPASS_GENERALVU + float2(8, 0))[0];
				#endif
				#ifdef AUTO_EXPOSURE
				float3 ALLocalTranslation = 0;
				float3 ALrotation = 0;
				float3 CTALRotation = 0;
				float3 ALScale = 0;
				float3 ALWorldTranslation = 0;
				float ALHeight = 0;
				float ALRoundingAmount = 0;
				float4 ALSpectrumLocalOffset = 0;
				#if defined(PROP_VERTEXBASICSMASK) || !defined(OPTIMIZER_ENABLED)
				float4 vertexMaskTex = _VertexBasicsMask.SampleLevel(sampler_linear_repeat, poiUV(vertexUV(v, 0.0), float4(1,1,0,0)) + float4(0,0,0,0).xy * _Time.x, 0);
				#else
				float4 vertexMaskTex = 1;
				#endif
				float vertexEffectsMask[8] = {
					vertexMaskTex.r,
					vertexMaskTex.g,
					vertexMaskTex.b,
					vertexMaskTex.a,
					v.color.r,
					v.color.g,
					v.color.b,
					v.color.a
				};
				float basicsMask = vertexEffectsMask[0.0];
				float4 rotation = float4(
				lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask) +
				float3(180, 0, 0) +
				lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask) * _Time.x +
				ALrotation +
				CTALRotation,
				float4(0,0,0,1).w
				);
				float4 localTranslation = lerp(float4(0, 0, 0, 0), float4(0,0,0,1), basicsMask) + float4(ALLocalTranslation, 0) + ALSpectrumLocalOffset;
				float4 manualScale = lerp(float4(1, 1, 1, 1), float4(1,1,1,1), basicsMask);
				float4 localScale = manualScale + float4(ALScale, 0);
				v.normal = rotate_with_quaternion(v.normal, rotation.xyz);
				v.tangent.xyz = rotate_with_quaternion(v.tangent.xyz, rotation.xyz);
				v.vertex = transform(v.vertex, localTranslation, rotation, localScale);
				o.normal = UnityObjectToWorldNormal(v.normal);
				float3 heightOffset = 0;
				if ((0.0 + ALHeight) != 0)
				{
					#if defined(PROP_VERTEXMANIPULATIONHEIGHTMASK) || !defined(OPTIMIZER_ENABLED)
					heightOffset = (_VertexManipulationHeightMask.SampleLevel(sampler_linear_repeat, poiUV(vertexUV(v, 0.0), float4(1,1,0,0)) + float4(0,0,0,0).xy * _Time.x, 0)[0.0] - 0.0) * (0.0 + ALHeight) * o.normal;
					#else
					heightOffset = (0.0 + ALHeight) * o.normal;
					#endif
					heightOffset *= vertexEffectsMask[0.0];
				}
				float3 worldTranslation = lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask);
				v.vertex.xyz += mul(unity_WorldToObject, worldTranslation + ALWorldTranslation + heightOffset).xyz;
				
				if (1.0)
				{
					float roundingMask = vertexEffectsMask[0.0];
					if (roundingMask > 0)
					{
						float3 preRoundingVertex = v.vertex.xyz;
						float divisionAmount = max(0.0025 + ALRoundingAmount, 0.0000001);
						if (0 == 0)
						{
							float4 worldPos = mul(unity_ObjectToWorld, float4(preRoundingVertex, 1));
							float3 worldRoundPosition = (ceil(worldPos.xyz / divisionAmount) * divisionAmount) - divisionAmount * .5;
							v.vertex = mul(unity_WorldToObject, float4(worldRoundPosition, worldPos.w));
						}
						else if (0 == 1)
						{
							v.vertex.xyz = (ceil(preRoundingVertex / divisionAmount) * divisionAmount) - divisionAmount * .5;
						}
						v.vertex.xyz = lerp(preRoundingVertex, v.vertex.xyz, roundingMask);
					}
				}
				#endif
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.tangent.xyz = UnityObjectToWorldDir(v.tangent);
				o.tangent.w = v.tangent.w;
				o.vertexColor = v.color;
				o.uv[0] = float4(v.uv0.xy, v.uv1.xy);
				o.uv[1] = float4(v.uv2.xy, v.uv3.xy);
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
				o.fogData.x = o.pos.z; // This is used for fog calculations, so we need to ensure it's in clip space
				#ifdef FOG_EXP2
				o.fogData.y = 1;
				#else
				o.fogData.y = 0;
				#endif
				#ifndef FORWARD_META_PASS
				#if !defined(UNITY_PASS_SHADOWCASTER)
				UNITY_TRANSFER_SHADOW(o, o.uv[0].xy);
				#else
				v.vertex.xyz = o.localPos.xyz;
				TRANSFER_SHADOW_CASTER_NOPOS(o, o.pos);
				#endif
				#endif
				o.worldDir = dot(o.pos, CalculateFrustumCorrection());
				if (0.0)
				{
					applyReducedRenderClipDistance(o);
				}
				#ifdef POI_PASS_META
				o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
				#endif
				#ifdef POI_PASS_LILFUR
				#endif
				return o;
			}
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, uv) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan)) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if !defined(_STOCHASTICMODE_NONE)
			float2 StochasticHash2D2D(float2 s)
			{
				return frac(sin(glsl_mod(float2(dot(s, float2(127.1, 311.7)), dot(s, float2(269.5, 183.3))), 3.14159)) * 43758.5453);
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
				float3(vxID, bary.z),
				float3(vxID + float2(0, 1), bary.y),
				float3(vxID + float2(1, 0), bary.x)
				);
				float3x3 neg = float3x3(
				float3(vxID + float2(1, 1), -bary.z),
				float3(vxID + float2(1, 0), 1.0 - bary.y),
				float3(vxID + float2(0, 1), 1.0 - bary.x)
				);
				return (bary.z > 0) ? pos : neg;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, float2 dx, float2 dy)
			{
				float3x3 UVBW = DeliotHeitzStochasticUVBW(uv);
				return mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[0].xy), dx, dy), UVBW[0].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[1].xy), dx, dy), UVBW[1].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[2].xy), dx, dy), UVBW[2].z) ;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv)
			{
				float2 dx = ddx(uv), dy = ddy(uv);
				return DeliotHeitzSampleTexture(tex, texSampler, uv, dx, dy);
			}
			#endif // defined(_STOCHASTICMODE_DELIOT_HEITZ)
			void applyAlphaOptions(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiMods poiMods)
			{
				poiFragData.alpha = saturate(poiFragData.alpha + 0.0);
				if (0.0 > 0)
				{
					poiFragData.alpha = maskBlend(poiFragData.alpha, poiMods.globalMask[0.0 - 1], 2.0);
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
			#ifdef POI_LTCGI
			#define LTCGI_COLORMODE_STATIC 0
			#define LTCGI_COLORMODE_TEXTURE 1
			#define LTCGI_COLORMODE_SINGLEUV 2
			#define LTCGI_COLORMODE_AUDIOLINK 3
			struct ltcgi_flags
			{
				bool doublesided; // if the light is doublesided or only illuminates the front face
				bool diffFromLm; // diffuse lighting intensity will not be calculated via LTC but taken directly from the lightmap
				bool specular; // if the light has a specular component
				bool diffuse; // if the light has a diffuse component
				uint colormode; // colormode, see above
				uint texindex; // index of the texture to shade with, if colormode == LTCGI_COLORMODE_TEXTURE
				uint lmch, lmidx; // lightmap channel and index
				bool cylinder; // is this light a cylinder
				uint alBand; // audiolink band if colormode == LTCGI_COLORMODE_AUDIOLINK
				bool lmdOnly; // if this light is lightmap-diffuse _only_, that is, no LTC will be run (Lw will be all 0 in that case) - this will never be true on avatars (with LTCGI_ALWAYS_LTC_DIFFUSE)
			};
			struct ltcgi_input
			{
				uint i; // light number
				float3 Lw[4]; // world space area light vertices, Lw[1] == Lw[3] for triangle lights, shifted by input worldPos (i.e. world space position as seen from (0, 0, 0))
				bool isTri; // if this is a triangle light, quad if false
				float2 uvStart; //
				float2 uvEnd; // defines the UV layout of the area, top left to bottom right
				float3 rawColor; // the raw light color, unaffected by any colormode calculations (i.e. exactly what's given as "color" in editor)
				float3 screenNormal; // world space normal direction of area light
				ltcgi_flags flags; // flags, see above
			};
			struct ltcgi_output
			{
				ltcgi_input input; // input data that resulted in this output
				float intensity; // intensity output by LTC calculation
				float3 color; // color output by LTCGI colormode calculation
			};
			struct accumulator_struct
			{
				float3 diffuse;
				float3 specular;
			};
			void callback_diffuse(inout accumulator_struct acc, in ltcgi_output output);
			void callback_specular(inout accumulator_struct acc, in ltcgi_output output);
			#define LTCGI_V2_CUSTOM_INPUT accumulator_struct
			#define LTCGI_V2_DIFFUSE_CALLBACK callback_diffuse
			#define LTCGI_V2_SPECULAR_CALLBACK callback_specular
			#define LTCGI_BICUBIC_LIGHTMAP
			#define LTCGI_LIGHTMAP_CUTOFF 0.1
			#define LTCGI_SPECULAR_LIGHTMAP_STEP 0.3
			#define LTCGI_UV_BLUR_DISTANCE 333
			#define LTCGI_LTC_DIFFUSE_FALLBACK
			#define LTCGI_DISTANCE_FADE_APPROX
			#define LTCGI_DISTANCE_FADE_APPROX_MULT 50
			#define LTCGI_STATIC_TEXTURES
			#define MAX_SOURCES 16
			#define LUT_SIZE 256
			static float LUT_SCALE = (LUT_SIZE - 1.0) / LUT_SIZE;
			const float LUT_BIAS = 0.5 / LUT_SIZE;
			#ifdef POI_AUDIOLINK
			#define LTCGI_AUDIOLINK
			#endif
			#define LTCGI_STATIC_UNIFORMS
			#define LTCGI_CYLINDER
			#define LTCGI_AVATAR_MODE
			#ifdef LTCGI_AVATAR_MODE
			#undef LTCGI_STATIC_UNIFORMS
			#undef LTCGI_BICUBIC_LIGHTMAP
			#define LTCGI_ALWAYS_LTC_DIFFUSE
			#endif
			#ifdef LTCGI_TOGGLEABLE_SPEC_DIFF_OFF
			#undef LTCGI_DIFFUSE_OFF
			#undef LTCGI_SPECULAR_OFF
			#endif
			#if defined(LTCGI_V2_CUSTOM_INPUT) || defined(LTCGI_V2_DIFFUSE_CALLBACK) || defined(LTCGI_V2_SPECULAR_CALLBACK)
			#define LTCGI_API_V2
			#endif
			#ifndef LTCGI_SAMPLER
			SamplerState sampler_LTCGI_trilinear_clamp_sampler;
			#define LTCGI_SAMPLER sampler_LTCGI_trilinear_clamp_sampler
			#endif
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER
			uniform Texture2D<float4> _Udon_LTCGI_lut2;
			uniform Texture2D<float4> _Udon_LTCGI_lut1;
			#endif
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER
			uniform Texture2D<float4> _Udon_LTCGI_static_uniforms;
			#endif
			#ifdef LTCGI_STATIC_UNIFORMS
			float4 _Udon_LTCGI_Vertices_0_get(uint i)
			{
				return _Udon_LTCGI_static_uniforms[uint2(0, i)];
			}
			float4 _Udon_LTCGI_Vertices_1_get(uint i)
			{
				return _Udon_LTCGI_static_uniforms[uint2(1, i)];
			}
			float4 _Udon_LTCGI_Vertices_2_get(uint i)
			{
				return _Udon_LTCGI_static_uniforms[uint2(2, i)];
			}
			float4 _Udon_LTCGI_Vertices_3_get(uint i)
			{
				return _Udon_LTCGI_static_uniforms[uint2(3, i)];
			}
			#else
			uniform float4 _Udon_LTCGI_Vertices_0[MAX_SOURCES];
			uniform float4 _Udon_LTCGI_Vertices_1[MAX_SOURCES];
			uniform float4 _Udon_LTCGI_Vertices_2[MAX_SOURCES];
			uniform float4 _Udon_LTCGI_Vertices_3[MAX_SOURCES];
			float4 _Udon_LTCGI_Vertices_0_get(uint i)
			{
				return _Udon_LTCGI_Vertices_0[i];
			}
			float4 _Udon_LTCGI_Vertices_1_get(uint i)
			{
				return _Udon_LTCGI_Vertices_1[i];
			}
			float4 _Udon_LTCGI_Vertices_2_get(uint i)
			{
				return _Udon_LTCGI_Vertices_2[i];
			}
			float4 _Udon_LTCGI_Vertices_3_get(uint i)
			{
				return _Udon_LTCGI_Vertices_3[i];
			}
			#endif
			uniform uint _Udon_LTCGI_ScreenCount;
			uniform bool _Udon_LTCGI_Mask[MAX_SOURCES];
			uniform float4 _Udon_LTCGI_ExtraData[MAX_SOURCES];
			ltcgi_flags ltcgi_parse_flags(uint val, bool noLmDiff)
			{
				ltcgi_flags ret = (ltcgi_flags)0;
				ret.doublesided = (val & 1) == 1;
				#ifdef LTCGI_ALWAYS_LTC_DIFFUSE
				ret.diffFromLm = false;
				#else
				ret.diffFromLm = !noLmDiff && (val & 2) == 2;
				#endif
				ret.diffuse = (val & 8) == 8;
				ret.specular = (val & 4) == 4;
				ret.texindex = (val & 0xf0) >> 4;
				ret.colormode = (val & 0x300) >> 8;
				#ifdef LTCGI_ALWAYS_LTC_DIFFUSE
				ret.lmch = 0;
				#else
				ret.lmch = (val & 0xC00) >> 10;
				#endif
				ret.cylinder = (val & (1 << 12)) == (1 << 12);
				#ifdef LTCGI_AUDIOLINK
				ret.alBand = (val & 0x6000) >> 13;
				#endif
				ret.lmdOnly = (val & (1 << 15)) == (1 << 15);
				return ret;
			}
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER
			uniform Texture2D<float4> _Udon_LTCGI_Texture_LOD0;
			uniform Texture2D<float4> _Udon_LTCGI_Texture_LOD1;
			uniform Texture2D<float4> _Udon_LTCGI_Texture_LOD2;
			uniform Texture2D<float4> _Udon_LTCGI_Texture_LOD3;
			#endif
			UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Udon_LTCGI_Texture_LOD0_arr);
			UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Udon_LTCGI_Texture_LOD1_arr);
			UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Udon_LTCGI_Texture_LOD2_arr);
			UNITY_DECLARE_TEX2DARRAY_NOSAMPLER(_Udon_LTCGI_Texture_LOD3_arr);
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER
			#ifndef LTCGI_ALWAYS_LTC_DIFFUSE
			uniform Texture2D<float4> _Udon_LTCGI_Lightmap;
			#endif
			#endif
			uniform float3 _Udon_LTCGI_LightmapMult;
			uniform float4 _Udon_LTCGI_LightmapST;
			uniform float _Udon_LTCGI_GlobalEnable;
			float3 LTCGI_IntegrateEdge(float3 v1, float3 v2)
			{
				float x = dot(v1, v2);
				float y = abs(x);
				float a = 0.8543985 + (0.4965155 + 0.0145206 * y) * y;
				float b = 3.4175940 + (4.1616724 + y) * y;
				float v = a / b;
				float theta_sintheta = (x > 0.0) ? v : 0.5 * rsqrt(max(1.0 - x * x, 1e-7)) - v;
				return cross(v1, v2) * theta_sintheta;
			}
			void LTCGI_ClipQuadToHorizon(inout float3 L[5], out int n)
			{
				uint config = 0;
				if (L[0].z > 0.0) config += 1;
				if (L[1].z > 0.0) config += 2;
				if (L[2].z > 0.0) config += 4;
				if (L[3].z > 0.0) config += 8;
				n = 0;
				[forcecase]
				switch(config)
				{
					case 13: // V1 V3 V4 clip V2 <- tl;dr: this fecker has to be first or shader go boom
					n = 5;
					L[4] = L[3];
					L[3] = L[2];
					L[2] = -L[1].z * L[2] + L[2].z * L[1];
					L[1] = -L[1].z * L[0] + L[0].z * L[1];
					break;
					case 15: // V1 V2 V3 V4 - most common
					n = 4;
					break;
					case 9: // V1 V4 clip V2 V3
					n = 4;
					L[1] = -L[1].z * L[0] + L[0].z * L[1];
					L[2] = -L[2].z * L[3] + L[3].z * L[2];
					break;
					case 0: // clip all
					break;
					case 1: // V1 clip V2 V3 V4
					n = 3;
					L[1] = -L[1].z * L[0] + L[0].z * L[1];
					L[2] = -L[3].z * L[0] + L[0].z * L[3];
					L[3] = L[0];
					break;
					case 2: // V2 clip V1 V3 V4
					n = 3;
					L[0] = -L[0].z * L[1] + L[1].z * L[0];
					L[2] = -L[2].z * L[1] + L[1].z * L[2];
					L[3] = L[0];
					break;
					case 3: // V1 V2 clip V3 V4
					n = 4;
					L[2] = -L[2].z * L[1] + L[1].z * L[2];
					L[3] = -L[3].z * L[0] + L[0].z * L[3];
					break;
					case 4: // V3 clip V1 V2 V4
					n = 3;
					L[0] = -L[3].z * L[2] + L[2].z * L[3];
					L[1] = -L[1].z * L[2] + L[2].z * L[1];
					L[3] = L[0];
					break;
					case 5: // V1 V3 clip V2 V4) impossible
					break;
					case 6: // V2 V3 clip V1 V4
					n = 4;
					L[0] = -L[0].z * L[1] + L[1].z * L[0];
					L[3] = -L[3].z * L[2] + L[2].z * L[3];
					break;
					case 7: // V1 V2 V3 clip V4
					n = 5;
					L[4] = -L[3].z * L[0] + L[0].z * L[3];
					L[3] = -L[3].z * L[2] + L[2].z * L[3];
					break;
					case 8: // V4 clip V1 V2 V3
					n = 3;
					L[0] = -L[0].z * L[3] + L[3].z * L[0];
					L[1] = -L[2].z * L[3] + L[3].z * L[2];
					L[2] = L[3];
					break;
					case 10: // V2 V4 clip V1 V3) impossible
					break;
					case 11: // V1 V2 V4 clip V3
					n = 5;
					L[4] = L[3];
					L[3] = -L[2].z * L[3] + L[3].z * L[2];
					L[2] = -L[2].z * L[1] + L[1].z * L[2];
					break;
					case 12: // V3 V4 clip V1 V2
					n = 4;
					L[1] = -L[1].z * L[2] + L[2].z * L[1];
					L[0] = -L[0].z * L[3] + L[3].z * L[0];
					break;
					case 14: // V2 V3 V4 clip V1
					n = 5;
					L[4] = -L[0].z * L[3] + L[3].z * L[0];
					L[0] = -L[0].z * L[1] + L[1].z * L[0];
					break;
				}
				if (n == 3)
				L[3] = L[0];
				if (n == 4)
				L[4] = L[0];
			}
			float2 LTCGI_inset_uv(float2 uv)
			{
				return uv * 0.75 + float2(0.125, 0.125);
			}
			half3 premul_alpha(half4 i)
			{
				return i.rgb * i.a;
			}
			void LTCGI_sample(float2 uv, uint lod, uint idx, float blend, out float3 result)
			{
				result = 0;
				#ifndef LTCGI_STATIC_TEXTURES
				idx = 0; // optimize away the branches below
				#endif
				
				if (lod == 0)
				{
					
					if (any(saturate(abs(uv - 0.5) - 0.5)))
					{
						lod = 1;
					}
					else
					{
						float lod = (1 - blend) * 1.5;
						
						if (idx == 0)
						{
							#ifndef SHADER_TARGET_SURFACE_ANALYSIS
							result = premul_alpha(_Udon_LTCGI_Texture_LOD0.SampleLevel(LTCGI_SAMPLER, uv, lod));
							return;
							#else
							result = 0;
							return;
							#endif
						}
						else
						{
							result = premul_alpha(UNITY_SAMPLE_TEX2DARRAY_SAMPLER_LOD(
							_Udon_LTCGI_Texture_LOD0_arr,
							_LTCGI_trilinear_clamp_sampler,
							float3(uv, idx - 1),
							lod
							));
							return;
						}
					}
				}
				float2 ruv = LTCGI_inset_uv(uv);
				
				if (idx == 0)
				{
					#ifndef SHADER_TARGET_SURFACE_ANALYSIS
					switch(lod)
					{
						case 1:
						result = _Udon_LTCGI_Texture_LOD1.SampleLevel(LTCGI_SAMPLER, ruv, 0).rgb;
						return;
						case 2:
						result = _Udon_LTCGI_Texture_LOD2.SampleLevel(LTCGI_SAMPLER, ruv, 0).rgb;
						return;
						default:
						result = _Udon_LTCGI_Texture_LOD3.SampleLevel(LTCGI_SAMPLER, ruv, blend * 0.72).rgb;
						return;
					}
					#else
					result = 0;
					return;
					#endif
				}
				else
				{
					[forcecase]
					switch(lod)
					{
						case 1:
						result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER_LOD(
						_Udon_LTCGI_Texture_LOD1_arr,
						_LTCGI_trilinear_clamp_sampler,
						float3(ruv, idx - 1),
						0
						).rgb;
						return;
						case 2:
						result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER_LOD(
						_Udon_LTCGI_Texture_LOD2_arr,
						_LTCGI_trilinear_clamp_sampler,
						float3(ruv, idx - 1),
						0
						).rgb;
						return;
						default:
						result = UNITY_SAMPLE_TEX2DARRAY_SAMPLER_LOD(
						_Udon_LTCGI_Texture_LOD3_arr,
						_LTCGI_trilinear_clamp_sampler,
						float3(ruv, idx - 1),
						blend
						).rgb;
						return;
					}
				}
			}
			void LTCGI_trilinear(float2 uv, float d, uint idx, out float3 result)
			{
				uint low = (uint)d;
				uint high = low + 1;
				if (low >= 3)
				{
					LTCGI_sample(uv, 3, idx, d - 3, result);
				}
				else
				{
					float amount = saturate(high - d);
					float3 low_sample;
					LTCGI_sample(uv, low, idx, amount, low_sample);
					float3 high_sample;
					LTCGI_sample(uv, high, idx, 0, high_sample);
					result = lerp(high_sample, low_sample, amount);
				}
			}
			bool LTCGI_tri_ray(float3 orig, float3 dir, float3 v0, float3 v1, float3 v2, out float2 bary)
			{
				float3 v0v1 = v1 - v0;
				float3 v0v2 = v2 - v0;
				float3 pvec = cross(dir, v0v2);
				float det = dot(v0v1, pvec);
				float invDet = 1 / det;
				float3 tvec = orig - v0;
				bary.x = dot(tvec, pvec) * invDet;
				float3 qvec = cross(tvec, v0v1);
				bary.y = dot(dir, qvec) * invDet;
				return bary.x >= 0;
			}
			float2 LTCGI_rotateVector(float2 x, float angle)
			{
				float c = cos(angle);
				float s = sin(angle);
				return mul(float2x2(c, s, -s, c), x);
			}
			float2 LTCGI_calculateUV(uint i, ltcgi_flags flags, float3 L[5], bool isTri, float2 uvStart, float2 uvEnd, out float3 ray)
			{
				float3 E1 = L[1] - L[0];
				float3 E2 = L[3] - L[0];
				ray = cross(E1, E2);
				float2 bary;
				bool hit0 = LTCGI_tri_ray(0, ray, L[0], L[2], L[3], bary) || isTri;
				if (!hit0)
				{
					LTCGI_tri_ray(0, ray, L[0], L[1], L[2], bary);
				}
				float2 uvs[4];
				#ifdef LTCGI_CYLINDER
				if (flags.cylinder)
				{
					uvs[0] = uvStart;
					uvs[1] = float2(uvStart.x, uvEnd.y);
					uvs[2] = float2(uvEnd.x, uvStart.y);
					uvs[3] = uvEnd;
				}
				else
				#endif
				{
					uvs[0] = uvStart; // == _Udon_LTCGI_static_uniforms[uint2(4, i)].xy;
					uvs[1] = _Udon_LTCGI_static_uniforms[uint2(4, i)].zw;
					uvs[2] = _Udon_LTCGI_static_uniforms[uint2(5, i)].xy;
					uvs[3] = uvEnd; // == _Udon_LTCGI_static_uniforms[uint2(5, i)].zw;
				}
				float3 bary3 = float3(bary, 1 - bary.x - bary.y);
				float2 uv = uvs[1 + hit0 * 2] * bary3.x + uvs[3 - hit0] * bary3.y + uvs[0] * bary3.z;
				return uv;
			}
			void LTCGI_GetLw(uint i, ltcgi_flags flags, float3 worldPos, out float3 Lw[4], out float2 uvStart, out float2 uvEnd, out bool isTri)
			{
				bool cylinder = false;
				#ifdef LTCGI_CYLINDER
				cylinder = flags.cylinder;
				#endif
				float4 v0 = _Udon_LTCGI_Vertices_0_get(i);
				float4 v1 = _Udon_LTCGI_Vertices_1_get(i);
				float4 v2 = _Udon_LTCGI_Vertices_2_get(i);
				float4 v3 = _Udon_LTCGI_Vertices_3_get(i);
				
				if (cylinder)
				{
					float3 in_base = v0.xyz;
					float in_height = v0.w;
					float in_radius = v1.w;
					float in_size = v2.w;
					float in_angle = v3.w;
					float2 towardsCylinder = LTCGI_rotateVector((in_base - worldPos).xz, -in_angle);
					float angle = atan2(towardsCylinder.x, towardsCylinder.y);
					float angleClamped = clamp(angle, -in_size, in_size) + in_angle;
					float2 facing = float2(sin(angleClamped), cos(angleClamped));
					float2 tangent = float2(facing.y, -facing.x);
					float2 onCylinderFacing = facing * in_radius;
					float rclip = saturate(lerp(1, 0, (angleClamped - in_angle) - (in_size - UNITY_HALF_PI * 0.5f)));
					float lclip = saturate(lerp(1, 0, - (angleClamped - in_angle) - (in_size - UNITY_HALF_PI * 0.5f)));
					float2 p1 = in_base.xz - onCylinderFacing + tangent * in_radius * lclip;
					float2 p2 = in_base.xz - onCylinderFacing - tangent * in_radius * rclip;
					Lw[0] = float3(p1.x, in_base.y, p1.y) - worldPos;
					Lw[1] = float3(p1.x, in_base.y + in_height, p1.y) - worldPos;
					Lw[2] = float3(p2.x, in_base.y, p2.y) - worldPos;
					Lw[3] = float3(p2.x, in_base.y + in_height, p2.y) - worldPos;
					isTri = false;
					float2 viewDir = normalize((in_base - worldPos).xz);
					float forwardAngle = -in_angle + UNITY_HALF_PI;
					float viewAngle = forwardAngle - atan2(viewDir.y, viewDir.x);
					if (viewAngle < - UNITY_PI)
					viewAngle += UNITY_TWO_PI;
					if (viewAngle > UNITY_PI)
					viewAngle -= UNITY_TWO_PI;
					viewAngle = clamp(viewAngle * 0.5f, -in_size, in_size);
					viewAngle = sin(viewAngle);
					uvStart = float2(1 - saturate(viewAngle), 0);
					uvEnd = float2(1 - saturate(viewAngle + 1), 1);
				}
				else
				{
					Lw[0] = v0.xyz - worldPos;
					Lw[1] = v1.xyz - worldPos;
					Lw[2] = v2.xyz - worldPos;
					Lw[3] = v3.xyz - worldPos;
					#ifndef SHADER_TARGET_SURFACE_ANALYSIS
					uvStart = _Udon_LTCGI_static_uniforms[uint2(4, i)].xy;
					uvEnd = _Udon_LTCGI_static_uniforms[uint2(5, i)].zw;
					#else
					uvStart = float2(0, 0);
					uvEnd = float2(1, 1);
					#endif
					isTri = /*distance(Lw[2], Lw[3]) < 0.001 || */distance(Lw[1], Lw[3]) < 0.001;
				}
			}
			#ifndef SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER
			float4 LTCGI_cubic(float v)
			{
				float4 n = float4(1.0, 2.0, 3.0, 4.0) - v;
				float4 s = n * n * n;
				float x = s.x;
				float y = s.y - 4.0 * s.x;
				float z = s.z - 4.0 * s.y + 6.0 * s.x;
				float w = 6.0 - x - y - z;
				return float4(x, y, z, w);
			}
			float4 LTCGI_SampleTexture2DBicubicFilter(Texture2D tex, SamplerState smp, float2 coord, float4 texSize)
			{
				coord = coord * texSize.xy - 0.5;
				float fx = frac(coord.x);
				float fy = frac(coord.y);
				coord.x -= fx;
				coord.y -= fy;
				float4 xcubic = LTCGI_cubic(fx);
				float4 ycubic = LTCGI_cubic(fy);
				float4 c = float4(coord.x - 0.5, coord.x + 1.5, coord.y - 0.5, coord.y + 1.5);
				float4 s = float4(xcubic.x + xcubic.y, xcubic.z + xcubic.w, ycubic.x + ycubic.y, ycubic.z + ycubic.w);
				float4 offset = c + float4(xcubic.y, xcubic.w, ycubic.y, ycubic.w) / s;
				float4 sample0 = tex.Sample(smp, float2(offset.x, offset.z) * texSize.zw);
				float4 sample1 = tex.Sample(smp, float2(offset.y, offset.z) * texSize.zw);
				float4 sample2 = tex.Sample(smp, float2(offset.x, offset.w) * texSize.zw);
				float4 sample3 = tex.Sample(smp, float2(offset.y, offset.w) * texSize.zw);
				float sx = s.x / (s.x + s.y);
				float sy = s.z / (s.z + s.w);
				return lerp(
				lerp(sample3, sample2, sx),
				lerp(sample1, sample0, sx), sy);
			}
			float4 LTCGI_SampleShadowmap(float2 lmuv)
			{
				#ifdef LTCGI_ALWAYS_LTC_DIFFUSE
				return 1;
				#else
				lmuv = lmuv * _Udon_LTCGI_LightmapST.xy + _Udon_LTCGI_LightmapST.zw;
				#ifdef LTCGI_BICUBIC_LIGHTMAP
				float width, height;
				_Udon_LTCGI_Lightmap.GetDimensions(width, height);
				float4 _Udon_LTCGI_Lightmap_TexelSize = float4(width, height, 1.0 / width, 1.0 / height);
				return LTCGI_SampleTexture2DBicubicFilter(
				_Udon_LTCGI_Lightmap, LTCGI_SAMPLER,
				lmuv, _Udon_LTCGI_Lightmap_TexelSize
				);
				#else
				return _Udon_LTCGI_Lightmap.Sample(LTCGI_SAMPLER, lmuv);
				#endif
				#endif
			}
			#else
			float4 LTCGI_SampleShadowmap(float2 lmuv)
			{
				return 1;
			}
			#endif
			#ifdef SHADER_TARGET_SURFACE_ANALYSIS
			#define const
			#endif
			void LTCGI_Evaluate(ltcgi_input input, float3 worldNorm, float3 viewDir, float3x3 Minv, float roughness, const bool diffuse, out ltcgi_output output)
			{
				output.input = input;
				output.color = input.rawColor; // copy for colormode static
				output.intensity = 0;
				#ifdef LTCGI_DISTANCE_FADE_APPROX
				if (diffuse) // static branch, specular does not directly fade with distance
				{
					if (!input.flags.lmdOnly)
					{
						float3 ctr = (input.Lw[0] + input.Lw[1]) / 2;
						float dist = length(ctr);
						if (dist > LTCGI_DISTANCE_FADE_APPROX_MULT)
						{
							return;
						}
					}
				}
				#endif
				#define RET1_IF_LMDIFF  if (/*const*/ diffuse && input.flags.diffFromLm) \
				{ \
					output.intensity = 1.0f; return; \
				}
				if (input.flags.colormode == LTCGI_COLORMODE_SINGLEUV)
				{
					float2 uv = input.uvStart;
					if (uv.x < 0) uv.xy = uv.yx;
					#ifdef LTCGI_VISUALIZE_SAMPLE_UV
					output.color = float3(uv.xy, 0);
					#else
					float3 sampled;
					LTCGI_sample(LTCGI_inset_uv(uv), 1, input.flags.texindex, 0, sampled);
					output.color *= sampled;
					#endif
					RET1_IF_LMDIFF
				}
				#ifdef LTCGI_AUDIOLINK
				if (input.flags.colormode == LTCGI_COLORMODE_AUDIOLINK)
				{
					float al = AudioLinkData(ALPASS_AUDIOLINK + uint2(0, input.flags.alBand)).r;
					output.color *= al;
					RET1_IF_LMDIFF
				}
				#endif
				float3 L[5];
				L[0] = mul(Minv, input.Lw[0]);
				L[1] = mul(Minv, input.Lw[1]);
				L[2] = input.isTri ? L[1] : mul(Minv, input.Lw[3]);
				L[3] = mul(Minv, input.Lw[2]);
				L[4] = 0;
				
				if (input.flags.colormode == LTCGI_COLORMODE_TEXTURE)
				{
					float3 RN;
					float2 uv = LTCGI_calculateUV(input.i, input.flags, L, input.isTri, input.uvStart, input.uvEnd, RN);
					float planeAreaSquared = dot(RN, RN);
					float planeDistxPlaneArea = dot(RN, L[0]);
					float3 sampled;
					
					if (diffuse)
					{
						float3 sampled1;
						LTCGI_sample(uv, 3, input.flags.texindex, 10, sampled1);
						float3 sampled2;
						LTCGI_sample(uv, 3, input.flags.texindex, 100, sampled2);
						sampled =
						sampled1 * 0.75 +
						sampled2 * 0.25;
					}
					else
					{
						float d = abs(planeDistxPlaneArea) / planeAreaSquared;
						d *= LTCGI_UV_BLUR_DISTANCE;
						d = log(d) / log(3.0);
						d = clamp(d, saturate(roughness * 5.75), 1000);
						LTCGI_trilinear(uv, d, input.flags.texindex, sampled);
					}
					output.color *= sampled;
				}
				RET1_IF_LMDIFF
				#undef RET1_IF_LMDIFF
				int n;
				LTCGI_ClipQuadToHorizon(L, n);
				if (n == 0)
				return;
				L[0] = normalize(L[0]);
				L[1] = normalize(L[1]);
				L[2] = normalize(L[2]);
				L[3] = normalize(L[3]);
				L[4] = normalize(L[4]);
				float sum = 0;
				[unroll(5)]
				for (uint v = 0; v < max(3, (uint)n); v++)
				{
					float3 a = L[v];
					float3 b = L[(v + 1) % 5];
					sum += LTCGI_IntegrateEdge(a, b).z;
				}
				output.intensity = abs(sum);
				return;
			}
			void LTCGI_Contribution(
			#ifdef LTCGI_API_V2
			inout LTCGI_V2_CUSTOM_INPUT data,
			#endif
			float3 worldPos, float3 worldNorm, float3 viewDir, float roughness, float2 lmuv
			#ifndef LTCGI_API_V2
			, inout half3 diffuse, inout half3 specular, out float totalSpecularIntensity, out float totalDiffuseIntensity
			#endif
			)
			{
				#ifndef LTCGI_API_V2
				totalSpecularIntensity = 0;
				#endif
				if (_Udon_LTCGI_GlobalEnable == 0.0f)
				{
					return;
				}
				float theta = acos(dot(worldNorm, viewDir));
				float2 uv = float2(roughness, theta / (0.5 * UNITY_PI));
				uv = uv * LUT_SCALE + LUT_BIAS;
				#ifndef UNITY_UV_STARTS_AT_TOP
				uv.y = 1 - uv.y;
				#endif
				float3 lms = LTCGI_SampleShadowmap(lmuv);
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER
				float4 t = _Udon_LTCGI_lut1.SampleLevel(LTCGI_SAMPLER, uv, 0);
				#endif
				float3x3 Minv = float3x3(
				float3(1, 0, t.w),
				float3(0, t.z, 0),
				float3(t.y, 0, t.x)
				);
				float3 T1, T2;
				T1 = normalize(viewDir - worldNorm * dot(viewDir, worldNorm));
				T2 = cross(worldNorm, T1);
				float3x3 identityBrdf = float3x3(float3(T1), float3(T2), float3(worldNorm));
				Minv = mul(Minv, identityBrdf);
				#ifndef LTCGI_SPECULAR_OFF
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER
				float spec_amp = _Udon_LTCGI_lut2.SampleLevel(LTCGI_SAMPLER, uv, 0).x;
				#endif
				#endif
				bool noLm = false;
				#ifdef LTCGI_LTC_DIFFUSE_FALLBACK
				#ifndef LTCGI_ALWAYS_LTC_DIFFUSE
				#ifndef SHADER_TARGET_SURFACE_ANALYSIS
				float2 lmSize;
				_Udon_LTCGI_Lightmap.GetDimensions(lmSize.x, lmSize.y);
				noLm = lmSize.x == 1;
				#endif
				#endif
				#endif
				#ifdef LTCGI_ALWAYS_LTC_DIFFUSE
				noLm = true;
				#endif
				uint count = min(_Udon_LTCGI_ScreenCount, MAX_SOURCES);
				[loop]
				for (uint i = 0; i < count; i++)
				{
					if (_Udon_LTCGI_Mask[i]) continue;
					float4 extra = _Udon_LTCGI_ExtraData[i];
					float3 color = extra.rgb;
					if (!any(color)) continue;
					ltcgi_flags flags = ltcgi_parse_flags(asuint(extra.w), noLm);
					#ifdef LTCGI_ALWAYS_LTC_DIFFUSE
					if (flags.lmdOnly) continue;
					#endif
					#ifdef LTCGI_TOGGLEABLE_SPEC_DIFF_OFF
					flags.diffuse = flags.specular = true;
					#endif
					float3 Lw[4];
					float2 uvStart = (float2)0, uvEnd = (float2)0;
					bool isTri = false;
					if (flags.lmdOnly)
					{
						Lw[0] = Lw[1] = Lw[2] = Lw[3] = (float3)0;
					}
					else
					{
						LTCGI_GetLw(i, flags, worldPos, Lw, uvStart, uvEnd, isTri);
					}
					float3 screenNorm = cross(Lw[1] - Lw[0], Lw[2] - Lw[0]);
					if (!flags.doublesided)
					{
						if (dot(screenNorm, Lw[0]) < 0)
						continue;
					}
					float lm = 1;
					if (flags.lmch)
					{
						lm = lms[flags.lmch - 1];
						if (lm < 0.001) continue;
					}
					ltcgi_input input;
					input.i = i;
					input.Lw = Lw;
					input.isTri = isTri;
					input.uvStart = uvStart;
					input.uvEnd = uvEnd;
					input.rawColor = color;
					input.flags = flags;
					input.screenNormal = screenNorm;
					#ifndef LTCGI_DIFFUSE_OFF
					
					if (flags.diffuse)
					{
						float lmd = lm;
						if (flags.lmch)
						{
							if (flags.diffFromLm)
							lmd *= _Udon_LTCGI_LightmapMult[flags.lmch - 1];
							else
							lmd = smoothstep(0.0, LTCGI_SPECULAR_LIGHTMAP_STEP, saturate(lm - LTCGI_LIGHTMAP_CUTOFF));
						}
						ltcgi_output diff;
						LTCGI_Evaluate(input, worldNorm, viewDir, identityBrdf, roughness, true, diff);
						diff.intensity *= lmd;
						#ifdef LTCGI_API_V2
						LTCGI_V2_DIFFUSE_CALLBACK(data, diff);
						#else
						diffuse += (diff.intensity * diff.color);
						totalDiffuseIntensity += diff.intensity;
						#endif
					}
					#endif
					#ifndef LTCGI_SPECULAR_OFF
					
					if (flags.specular)
					{
						ltcgi_output spec;
						LTCGI_Evaluate(input, worldNorm, viewDir, Minv, roughness, false, spec);
						spec.intensity *= spec_amp * smoothstep(0.0, LTCGI_SPECULAR_LIGHTMAP_STEP, saturate(lm - LTCGI_LIGHTMAP_CUTOFF));
						#ifdef LTCGI_API_V2
						LTCGI_V2_SPECULAR_CALLBACK(data, spec);
						#else
						specular += spec.intensity * spec.color;
						totalSpecularIntensity += spec.intensity;
						#endif
					}
					#endif
				}
			}
			#ifndef LTCGI_API_V2
			void LTCGI_Contribution(
			float3 worldPos, float3 worldNorm, float3 viewDir, float roughness, float2 lmuv, inout half3 diffuse
			)
			{
				half3 _u1;
				float _u2, _u3;
				LTCGI_Contribution(worldPos, worldNorm, viewDir, roughness, lmuv, diffuse, _u1, _u2, _u3);
			}
			void LTCGI_Contribution(
			float3 worldPos, float3 worldNorm, float3 viewDir, float roughness, float2 lmuv, inout half3 diffuse, inout half3 specular
			)
			{
				float _u1, _u2;
				LTCGI_Contribution(worldPos, worldNorm, viewDir, roughness, lmuv, diffuse, specular, _u1, _u2);
			}
			void LTCGI_Contribution(
			float3 worldPos, float3 worldNorm, float3 viewDir, float roughness, float2 lmuv, inout half3 diffuse, inout half3 specular, out float totalSpecularIntensity
			)
			{
				float _u1;
				LTCGI_Contribution(worldPos, worldNorm, viewDir, roughness, lmuv, diffuse, specular, totalSpecularIntensity, _u1);
			}
			#endif
			void callback_diffuse(inout accumulator_struct acc, in ltcgi_output output)
			{
				acc.diffuse += output.intensity * output.color;
			}
			void callback_specular(inout accumulator_struct acc, in ltcgi_output output)
			{
				acc.specular += output.intensity * output.color;
			}
			#endif
			#ifdef VIGNETTE_MASKED
			#ifdef _LIGHTINGMODE_REALISTIC
			#if defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
			#if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK)
			#define SUBTRACTIVE_LIGHTING 1
			#endif
			#endif
			float FadeShadows(float attenuation, inout PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				#if HANDLE_SHADOWS_BLENDING_IN_GI || ADDITIONAL_MASKED_DIRECTIONAL_SHADOWS
				#if ADDITIONAL_MASKED_DIRECTIONAL_SHADOWS
				attenuation = poiLight.attenuation;
				#endif
				float viewZ = dot(_WorldSpaceCameraPos - poiMesh.worldPos, UNITY_MATRIX_V[2].xyz);
				float shadowFadeDistance = UnityComputeShadowFadeDistance(poiMesh.worldPos, viewZ);
				float shadowFade = UnityComputeShadowFade(shadowFadeDistance);
				float bakedAttenuation = UnitySampleBakedOcclusion(poiMesh.lightmapUV.xy, poiMesh.worldPos);
				attenuation = UnityMixRealtimeAndBakedShadows(attenuation, bakedAttenuation, shadowFade);
				#endif
				return attenuation;
			}
			void ApplySubtractiveLighting(inout UnityIndirect indirectLight, inout PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				#if SUBTRACTIVE_LIGHTING
				poiLight.attenuation = FadeShadows(poiLight.attenuation, poiLight, poiMesh, poiCam);
				float ndotl = saturate(dot(poiMesh.normals[0], _WorldSpaceLightPos0.xyz));
				float3 shadowedLightEstimate = ndotl * (1 - poiLight.attenuation) * _LightColor0.rgb;
				float3 subtractedLight = indirectLight.diffuse - shadowedLightEstimate;
				subtractedLight = max(subtractedLight, unity_ShadowColor.rgb);
				subtractedLight = lerp(subtractedLight, indirectLight.diffuse, _LightShadowData.x);
				indirectLight.diffuse = min(subtractedLight, indirectLight.diffuse);
				#endif
			}
			UnityIndirect CreateIndirectLight(in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight)
			{
				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;
				#if defined(LIGHTMAP_ON)
				indirectLight.diffuse = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, poiMesh.lightmapUV.xy));
				#if defined(DIRLIGHTMAP_COMBINED)
				float4 lightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, poiMesh.lightmapUV.xy);
				indirectLight.diffuse = DecodeDirectionalLightmap(indirectLight.diffuse, lightmapDirection, poiMesh.normals[1]);
				#endif
				ApplySubtractiveLighting(indirectLight, poiLight, poiMesh, poiCam);
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float3 dynamicLightDiffuse = DecodeRealtimeLightmap(
				UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, poiMesh.lightmapUV.zw)
				);
				#if defined(DIRLIGHTMAP_COMBINED)
				float4 dynamicLightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, poiMesh.lightmapUV.zw);
				indirectLight.diffuse += DecodeDirectionalLightmap(dynamicLightDiffuse, dynamicLightmapDirection, poiMesh.normals[1]);
				#else
				indirectLight.diffuse += dynamicLightDiffuse;
				#endif
				#endif
				#if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
				#if UNITY_LIGHT_PROBE_PROXY_VOLUME
				if (unity_ProbeVolumeParams.x == 1)
				{
					indirectLight.diffuse = SHEvalLinearL0L1_SampleProbeVolume(
					float4(poiMesh.normals[1], 1), poiMesh.worldPos
					);
					indirectLight.diffuse = max(0, indirectLight.diffuse);
					#if defined(UNITY_COLORSPACE_GAMMA)
					indirectLight.diffuse = LinearToGammaSpace(indirectLight.diffuse);
					#endif
				}
				else
				{
					indirectLight.diffuse += max(0, PoiShadeSH9(float4(poiMesh.normals[1], 1)));
				}
				#else
				indirectLight.diffuse += max(0, PoiShadeSH9(float4(poiMesh.normals[1], 1)));
				#endif
				#endif
				indirectLight.diffuse *= poiLight.occlusion;
				return indirectLight;
			}
			#endif
			float GetRemapMinValue(float scale, float offset)
			{
				return clamp(-offset / scale, -0.01f, 1.01f); // Remap min
			}
			float GetRemapMaxValue(float scale, float offset)
			{
				return clamp((1.0f - offset) / scale, -0.01f, 1.01f); // Remap Max
			}
			sampler2D_float unity_NHxRoughness;
			half3 BRDF3_Direct(half3 diffColor, half3 specColor, half rlPow4, half smoothness)
			{
				half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp
				half specular = tex2D(unity_NHxRoughness, half2(rlPow4, 1 - smoothness)).r * LUT_RANGE;
				#if defined(_SPECULARHIGHLIGHTS_OFF)
				specular = 0.0;
				#endif
				return diffColor + specular * specColor;
			}
			half3 BRDF3_Indirect(half3 diffColor, half3 specColor, UnityIndirect indirect, half grazingTerm, half fresnelTerm)
			{
				half3 c = indirect.diffuse * diffColor;
				c += indirect.specular * lerp(specColor, grazingTerm, fresnelTerm);
				return c;
			}
			half4 POI_BRDF_PBS(half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness, float3 normal, float3 viewDir, UnityLight light, UnityIndirect gi)
			{
				float3 reflDir = reflect(viewDir, normal);
				half nl = saturate(dot(normal, light.dir));
				half nv = saturate(dot(normal, viewDir));
				half2 rlPow4AndFresnelTerm = Pow4(float2(dot(reflDir, light.dir), 1 - nv));  // use R.L instead of N.H to save couple of instructions
				half rlPow4 = rlPow4AndFresnelTerm.x; // power exponent must match kHorizontalWarpExp in NHxRoughness() function in GeneratedTextures.cpp
				half fresnelTerm = rlPow4AndFresnelTerm.y;
				half grazingTerm = saturate(smoothness + (1 - oneMinusReflectivity));
				half3 color = BRDF3_Direct(diffColor, specColor, rlPow4, smoothness);
				color *= light.color * nl;
				color += BRDF3_Indirect(diffColor, specColor, gi, grazingTerm, fresnelTerm);
				return half4(color, 1);
			}
			void calculateShading(inout PoiLight poiLight, inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				float shadowAttenuation = lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				float attenuation = 1;
				#if defined(POINT) || defined(SPOT)
				shadowAttenuation = lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				#endif
				#ifdef POI_PASS_ADD
				if (3.0 == 3)
				{
					#if defined(POINT) || defined(SPOT)
					#if defined(_LIGHTINGMODE_REALISTIC) || defined(_LIGHTINGMODE_CLOTH) || defined(_LIGHTINGMODE_WRAPPED)
					poiLight.rampedLightMap = max(0, poiLight.nDotL);
					poiLight.finalLighting = poiLight.directColor * attenuation * max(0, poiLight.nDotL) * poiLight.detailShadow * shadowAttenuation;
					return;
					#endif
					#endif
				}
				if (3.0 == 0)
				{
					poiLight.rampedLightMap = max(0, poiLight.nDotL);
					poiLight.finalLighting = poiLight.directColor * attenuation * max(0, poiLight.nDotL) * poiLight.detailShadow * shadowAttenuation;
					return;
				}
				if (3.0 == 1)
				{
					#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
					float passthrough = 0;
					#else
					float passthrough = 0.5;
					#endif
					float2 ToonAddGradient = float2(0.0, 0.5);
					if (ToonAddGradient.x == ToonAddGradient.y) ToonAddGradient.y += 0.0001;
					poiLight.rampedLightMap = smoothstep(ToonAddGradient.y, ToonAddGradient.x, 1 - (.5 * poiLight.nDotL + .5));
					#if defined(POINT) || defined(SPOT)
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.additiveShadow, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(ToonAddGradient.x, ToonAddGradient.y, 1 - (.5 * poiLight.nDotL + .5)));
					#else
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.attenuation, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(ToonAddGradient.x, ToonAddGradient.y, 1 - (.5 * poiLight.nDotL + .5)));
					#endif
					return;
				}
				#endif
				float shadowStrength = 1.0 * poiLight.shadowMask;
				#ifdef POI_PASS_OUTLINE
				shadowStrength = lerp(0, shadowStrength, 0.0);
				#endif
				#ifdef _LIGHTINGMODE_REALISTIC
				UnityLight light;
				light.dir = poiLight.direction;
				light.color = max(0, _LightColor0.rgb) * saturate(shadowAttenuation * attenuation * poiLight.detailShadow);
				light.ndotl = poiLight.nDotLSaturated;
				UnityIndirect indirectLight = (UnityIndirect)0;
				#ifdef UNITY_PASS_FORWARDBASE
				indirectLight = CreateIndirectLight(poiMesh, poiCam, poiLight);
				#endif
				#ifdef UNITY_PASS_FORWARDBASE
				light.color = max(light.color * 1.0, 0);
				light.color = max(light.color + 0.0, 0);
				indirectLight.diffuse = max(indirectLight.diffuse * 1.0, 0);
				indirectLight.diffuse = max(indirectLight.diffuse + 0.0, 0);
				#endif
				poiLight.rampedLightMap = poiLight.nDotLSaturated;
				poiLight.finalLighting = max(POI_BRDF_PBS(1, 0, 0, 0, poiMesh.normals[1], poiCam.viewDir, light, indirectLight).xyz, _LightingMinLightBrightness);
				#ifdef UNITY_PASS_FORWARDBASE
				if (_UdonLightVolumeEnabled && 1.0)
				{
					float3 L0 = 0;
					float3 L1r = 0;
					float3 L1g = 0;
					float3 L1b = 0;
					#ifdef LIGHTMAP_ON
					LightVolumeAdditiveSH(poiMesh.worldPos, L0, L1r, L1g, L1b);
					poiLight.finalLighting += clamp(LightVolumeEvaluate(poiMesh.normals[1], L0, L1r, L1g, L1b), _LightingMinLightBrightness, _LightingCap);
					#endif
				}
				#endif
				#endif
				if (poiFragData.toggleVertexLights)
				{
					#if defined(VERTEXLIGHT_ON)
					float3 vertexLighting = float3(0, 0, 0);
					for (int index = 0; index < 4; index++)
					{
						float lightingMode = 3.0;
						if (lightingMode == 3)
						{
							#if defined(_LIGHTINGMODE_REALISTIC)
							lightingMode = 0;
							#else
							lightingMode = 1;
							#endif
						}
						if (lightingMode == 0)
						{
							vertexLighting = max(vertexLighting, poiLight.vColor[index] * poiLight.vSaturatedDotNL[index] * poiLight.detailShadow); // Realistic
						}
						if (lightingMode == 1)
						{
							float2 ToonAddGradient = float2(0.0, 0.5);
							if (ToonAddGradient.x == ToonAddGradient.y) ToonAddGradient.y += 0.0001;
							vertexLighting = max(vertexLighting, lerp(poiLight.vColor[index], poiLight.vColor[index] * 0.5, smoothstep(ToonAddGradient.x, ToonAddGradient.y, 1 - (.5 * poiLight.vDotNL[index] + .5))) * poiLight.detailShadow);
						}
					}
					float3 mixedLight = poiLight.finalLighting;
					poiLight.finalLighting = max(vertexLighting, poiLight.finalLighting);
					#endif
				}
			}
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
			float3 GetReflections(in PoiCam poiCam, in PoiLight pl, in PoiMesh poiMesh, float perceptualRoughness, float ForceFallback, float LightFallback, TextureCube reflectionCube, float4 hdrData, float3 reflectionDir)
			{
				float3 reflections = 0;
				float3 lighting = pl.finalLighting;
				if (ForceFallback == 0)
				{
					
					if (SceneHasReflections())
					{
						#ifdef UNITY_PASS_FORWARDBASE
						reflections = GetWorldReflections(reflectionDir, poiMesh.worldPos.xyz, perceptualRoughness);
						#endif
					}
					else
					{
						#ifdef UNITY_PASS_FORWARDBASE
						float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
						float mipLevel0 = floor(mipLevel);
						float mipLevel1 = mipLevel0 + 1;
						float mipLerp = frac(mipLevel);
						float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
						float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
						reflections = lerp(sample0, sample1, mipLerp);
						reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
						#endif
						#ifdef POI_PASS_ADD
						if (LightFallback)
						{
							float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
							float mipLevel0 = floor(mipLevel);
							float mipLevel1 = mipLevel0 + 1;
							float mipLerp = frac(mipLevel);
							float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
							float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
							reflections = lerp(sample0, sample1, mipLerp);
							reflections = DecodeHDR(float4(reflections, 1), hdrData) * pl.finalLighting;
						}
						#endif
					}
				}
				else
				{
					#ifdef UNITY_PASS_FORWARDBASE
					float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
					float mipLevel0 = floor(mipLevel);
					float mipLevel1 = mipLevel0 + 1;
					float mipLerp = frac(mipLevel);
					float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
					float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
					reflections = lerp(sample0, sample1, mipLerp);
					reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
					#endif
					#ifdef POI_PASS_ADD
					if (LightFallback)
					{
						float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
						float mipLevel0 = floor(mipLevel);
						float mipLevel1 = mipLevel0 + 1;
						float mipLerp = frac(mipLevel);
						float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
						float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
						reflections = lerp(sample0, sample1, mipLerp);
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
					float lambdaV = nDotL * (nDotV * (1 - roughness) + roughness);
					float lambdaL = nDotV * (nDotL * (1 - roughness) + roughness);
					visibilityTerm = 0.5f / (lambdaV + lambdaL + 1e-5f);
					float a = nDotH * roughness;
					float k = roughness / (1.0 - nDotH * nDotH + a * a+ 1e-5f);
					float dotTerm = k * k * UNITY_INV_PI;
					visibilityTerm *= dotTerm;
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
			float SFVisibility(float brdfRoughness, float3 directColor, float NDotV, float ExposureOcclusion)
			{
				float Visibility = saturate(length(directColor + EPSILON) * (1.0/(ExposureOcclusion))); //Using direct color because I think it should be generally more forgiving
				return saturate(pow(NDotV + Visibility, exp2(-16.0 * brdfRoughness - 1.0)) - 1.0 + Visibility);
			}
			#endif
			#ifdef MOCHIE_PBR
			void MetallicAndSpecularFragDataInit(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiMods poiMods)
			{
				float smoothness = 1.0;
				float smoothness2 = 1.0;
				float metallic = 1.0;
				float specularMask = 1;
				float reflectionMask = 1;
				smoothness *= poiFragData.smoothness;
				smoothness2 *= poiFragData.smoothness2;
				metallic *= poiFragData.metallic;
				specularMask *= poiFragData.specularMask;
				reflectionMask *= poiFragData.reflectionMask;
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
				reflectionMask *= 1.0;
				specularMask *= 1.0;
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
				poiFragData.smoothness *= smoothness;
				poiFragData.smoothness2 *= smoothness2;
				poiFragData.metallic *= metallic;
				poiFragData.specularMask *= specularMask;
				poiFragData.reflectionMask *= reflectionMask;
			}
			void MochieBRDF(inout PoiFragData poiFragData, in PoiCam poiCam, inout PoiLight poiLight, in PoiMesh poiMesh, inout PoiMods poiMods)
			{
				float smoothness = poiFragData.smoothness;
				float smoothness2 = poiFragData.smoothness2;
				float metallic = poiFragData.metallic;
				float specularMask = poiFragData.specularMask;
				float reflectionMask = poiFragData.reflectionMask;
				if (0.0 > 0)
				{
					metallic = maskBlend(metallic, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					smoothness = maskBlend(smoothness, poiMods.globalMask[0.0 - 1], 2.0);
					smoothness2 = maskBlend(smoothness2, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					reflectionMask = customBlend(reflectionMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					specularMask = customBlend(specularMask, poiMods.globalMask[0.0 - 1], 2.0);
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
					float3 normals = lerp(poiMesh.normals[0], poiMesh.normals[1], 1.0);
					percepRough = GSAA_Filament(normals, percepRough, 0.15, 0.1);
					if (0.0 == 1 && 1.0 > 0)
					{
						percepRough2 = GSAA_Filament(normals, percepRough2, 0.15, 0.1);
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
				#if defined(POINT) || defined(SPOT)
				float attenuation = lerp(poiLight.additiveShadow, 1, 0.0);
				#else
				float attenuation = min(poiLight.nDotLSaturated, lerp(poiLight.attenuation, 1, 0.0));
				#endif
				float3 fresnelTerm = 1;
				float3 specularTerm = 1;
				float pbrNDotL = lerp(poiLight.vertexNDotL, poiLight.nDotL, 1.0);
				float pbrNDotV = lerp(poiLight.vertexNDotV, poiLight.nDotV, 1.0);
				float pbrNDotH = lerp(poiLight.vertexNDotH, poiLight.nDotH, 1.0);
				float3 pbrReflectionDir = lerp(poiCam.vertexReflectionDir, poiCam.reflectionDir, 1.0);
				GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness);
				specular = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation;
				if (poiFragData.toggleVertexLights)
				{
					#if defined(VERTEXLIGHT_ON)
					for (int index = 0; index < 4; index++)
					{
						fresnelTerm = 1;
						specularTerm = 1;
						float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
						float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
						GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness);
						vSpecular += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion;
					}
					#endif
				}
				if (0.0 == 1)
				{
					float3 fresnelTerm = 1;
					float3 specularTerm = 1;
					GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness2);
					specular2 = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation * 1.0;
					if (poiFragData.toggleVertexLights)
					{
						#if defined(VERTEXLIGHT_ON)
						for (int index = 0; index < 4; index++)
						{
							fresnelTerm = 1;
							specularTerm = 1;
							float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
							float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
							GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness2);
							vSpecular2 += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * 1.0;
						}
						#endif
					}
				}
				float surfaceReduction = (1.0 / (brdfRoughness * brdfRoughness + 1.0));
				float grazingTerm = saturate(smoothness + (1 - omr));
				float3 reflCol = GetReflections(poiCam, poiLight, poiMesh, percepRough, 0.0, 1.0, _MochieReflCube, _MochieReflCube_HDR, pbrReflectionDir);
				reflections = surfaceReduction * reflCol * FresnelLerp(specCol, specCol + lerp(specCol, 1, 0.5) * 0.5, pbrNDotV) * SFVisibility(brdfRoughness, poiLight.directColor, pbrNDotV, 0.0);
				reflections *= poiThemeColor(poiMods, float4(1,1,1,1), 0.0);
				reflections *= reflectionMask;
				diffuse = lerp(diffuse, diffuse * omr, reflectionMask);
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
				PoiSHAr = unity_SHAr;
				PoiSHAg = unity_SHAg;
				PoiSHAb = unity_SHAb;
				PoiSHBr = unity_SHBr;
				PoiSHBg = unity_SHBg;
				PoiSHBb = unity_SHBb;
				PoiSHC =  unity_SHC;
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
				PoiFragData poiFragData;
				poiFragData.smoothness = 1;
				poiFragData.smoothness2 = 1;
				poiFragData.metallic = 1;
				poiFragData.specularMask = 1;
				poiFragData.reflectionMask = 1;
				poiFragData.emission = 0;
				poiFragData.baseColor = float3(0, 0, 0);
				poiFragData.finalColor = float3(0, 0, 0);
				poiFragData.alpha = 1;
				poiFragData.toggleVertexLights = 0;
				#ifdef POI_UDIMDISCARD
				applyUDIMDiscard(i, facing);
				#endif
				poiMesh.objectPosition = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				poiMesh.objNormal = mul(unity_WorldToObject, i.normal);
				poiMesh.normals[0] = i.normal;
				poiMesh.tangent[0] = i.tangent.xyz;
				poiMesh.binormal[0] = cross(i.normal, i.tangent.xyz) * (i.tangent.w * unity_WorldTransformParams.w);
				poiMesh.worldPos = i.worldPos.xyz;
				poiMesh.localPos = i.localPos.xyz;
				poiMesh.vertexColor = i.vertexColor;
				poiMesh.isFrontFace = facing;
				poiMesh.dx = ddx(poiMesh.uv[0]);
				poiMesh.dy = ddy(poiMesh.uv[0]);
				poiMesh.isRightHand = i.tangent.w > 0.0;
				#ifndef POI_PASS_OUTLINE
				if (!poiMesh.isFrontFace && 1)
				{
					poiMesh.normals[0] *= -1;
					poiMesh.tangent[0] *= -1;
					poiMesh.binormal[0] *= -1;
				}
				#endif
				poiCam.viewDir = !IsOrthographicCamera() ? normalize(_WorldSpaceCameraPos - i.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 tanToWorld0 = float3(poiMesh.tangent[0].x, poiMesh.binormal[0].x, poiMesh.normals[0].x);
				float3 tanToWorld1 = float3(poiMesh.tangent[0].y, poiMesh.binormal[0].y, poiMesh.normals[0].y);
				float3 tanToWorld2 = float3(poiMesh.tangent[0].z, poiMesh.binormal[0].z, poiMesh.normals[0].z);
				float3 ase_tanViewDir = tanToWorld0 * poiCam.viewDir.x + tanToWorld1 * poiCam.viewDir.y + tanToWorld2 * poiCam.viewDir.z;
				poiCam.tangentViewDir = normalize(ase_tanViewDir);
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				poiMesh.lightmapUV = i.lightmapUV;
				#endif
				poiMesh.parallaxUV = poiCam.tangentViewDir.xy / max(poiCam.tangentViewDir.z, 0.0001);
				poiMesh.uv[0] = i.uv[0].xy;
				poiMesh.uv[1] = i.uv[0].zw;
				poiMesh.uv[2] = i.uv[1].xy;
				poiMesh.uv[3] = i.uv[1].zw;
				poiMesh.uv[4] = poiMesh.uv[0];
				poiMesh.uv[5] = poiMesh.uv[0];
				poiMesh.uv[6] = poiMesh.uv[0];
				poiMesh.uv[7] = poiMesh.uv[0];
				poiMesh.uv[8] = poiMesh.uv[0];
				poiMesh.uv[4] = calculatePanosphereUV(poiMesh);
				poiMesh.uv[5] = calculateWorldUV(poiMesh);
				poiMesh.uv[6] = calculatePolarCoordinate(poiMesh);
				poiMesh.uv[8] = calculatelocalUV(poiMesh);
				float3 worldViewUp = normalize(float3(0, 1, 0) - poiCam.viewDir * dot(poiCam.viewDir, float3(0, 1, 0)));
				float3 worldViewRight = normalize(cross(poiCam.viewDir, worldViewUp));
				poiMesh.uv[9] = float2(dot(worldViewRight, poiMesh.normals[0]), dot(worldViewUp, poiMesh.normals[0])) * 0.5 + 0.5;
				poiMods.globalMask[0] = 1;
				poiMods.globalMask[1] = 1;
				poiMods.globalMask[2] = 1;
				poiMods.globalMask[3] = 1;
				poiMods.globalMask[4] = 1;
				poiMods.globalMask[5] = 1;
				poiMods.globalMask[6] = 1;
				poiMods.globalMask[7] = 1;
				poiMods.globalMask[8] = 1;
				poiMods.globalMask[9] = 1;
				poiMods.globalMask[10] = 1;
				poiMods.globalMask[11] = 1;
				poiMods.globalMask[12] = 1;
				poiMods.globalMask[13] = 1;
				poiMods.globalMask[14] = 1;
				poiMods.globalMask[15] = 1;
				ApplyGlobalMaskModifiers(poiMesh, poiMods, poiCam);
				float2 mainUV = poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0));
				if (0.0)
				{
					mainUV = sharpSample(float4(0.03125,0.03125,32,32), mainUV);
				}
				float4 mainTexture = POI2D_SAMPLER_PAN_STOCHASTIC(_MainTex, _MainTex, mainUV, float4(0,0,0,0), 0.0);
				mainTexture.a = max(mainTexture.a, 0.0);
				#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
				poiMesh.tangentSpaceNormal = UnpackScaleNormal(POI2D_SAMPLER_PAN_STOCHASTIC(_BumpMap, _MainTex, poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0)), float4(0,0,0,0), 0.0), 1.0);
				#else
				poiMesh.tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				#endif
				float3 tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				poiMesh.normals[0] = normalize(
				tangentSpaceNormal.x * poiMesh.tangent[0] +
				tangentSpaceNormal.y * poiMesh.binormal[0] +
				tangentSpaceNormal.z * poiMesh.normals[0]
				);
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
				poiCam.clipPos = i.pos;
				poiCam.distanceToVert = distance(poiMesh.worldPos, poiCam.worldPos);
				poiCam.posScreenSpace = poiTransformClipSpacetoScreenSpaceFrag(poiCam.clipPos);
				#if defined(POI_GRABPASS) && defined(POI_PASS_BASE)
				poiCam.screenUV = poiCam.clipPos.xy / poiGetWidthAndHeight(_PoiGrab2);
				#else
				poiCam.screenUV = poiCam.clipPos.xy / _ScreenParams.xy;
				#endif
				#ifdef UNITY_SINGLE_PASS_STEREO
				poiCam.posScreenSpace.x = poiCam.posScreenSpace.x * 0.5;
				#endif
				poiCam.posScreenPixels = calcPixelScreenUVs(poiCam.posScreenSpace);
				poiCam.vDotN = abs(dot(poiCam.viewDir, poiMesh.normals[1]));
				poiCam.worldDirection.xyz = poiMesh.worldPos.xyz - poiCam.worldPos;
				poiCam.worldDirection.w = i.worldDir;
				calculateGlobalThemes(poiMods);
				if (_UdonForceSceneLighting)
				{
					_LightingMinLightBrightness = 0;
					_LightingCapEnabled = 0;
					_LightingMonochromatic = 0;
				}
				poiLight.finalLightAdd = 0;
				#ifdef UNITY_PASS_FORWARDBASE
				float3 L0 = float3(0, 0, 0);
				float3 L1r = float3(0, 0, 0);
				float3 L1g = float3(0, 0, 0);
				float3 L1b = float3(0, 0, 0);
				if (_UdonLightVolumeEnabled && 1.0)
				{
					LightVolumeSH(poiMesh.worldPos, L0, L1r, L1g, L1b);
					PoiSHAr = float4(L1r, L0.r);
					PoiSHAg = float4(L1g, L0.g);
					PoiSHAb = float4(L1b, L0.b);
					PoiSHBr = 0;
					PoiSHBg = 0;
					PoiSHBb = 0;
					PoiSHC = 0;
				}
				#endif
				#if defined(PROP_LIGHTINGAOMAPS)
				float4 AOMaps = POI2D_SAMPLER_PAN(_LightingAOMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				poiLight.occlusion = min(min(min(lerp(1, AOMaps.r, 1.0), lerp(1, AOMaps.g, 0.0)), lerp(1, AOMaps.b, 0.0)), lerp(1, AOMaps.a, 0.0));
				#else
				poiLight.occlusion = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.occlusion = maskBlend(poiLight.occlusion, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#if defined(PROP_LIGHTINGDETAILSHADOWMAPS)
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
				#if defined(PROP_LIGHTINGSHADOWMASKS)
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
					poiFragData.toggleVertexLights = 1;
				}
				if (IsInMirror() && 1.0 == 0)
				{
					poiFragData.toggleVertexLights = 0;
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
					poiLight.vSaturatedDotNL = saturate(poiLight.vDotNL);
					[unroll]
					for (int index = 0; index < 4; index++)
					{
						poiLight.vPosition[index] = float3(unity_4LightPosX0[index], unity_4LightPosY0[index], unity_4LightPosZ0[index]);
						float3 vertexToLightSource = poiLight.vPosition[index] - poiMesh.worldPos;
						poiLight.vDirection[index] = normalize(vertexToLightSource);
						poiLight.vColor[index] = 0.0 ? MaxLuminance(unity_LightColor[index].rgb * poiLight.vAttenuation[index], 1.0) : unity_LightColor[index].rgb * poiLight.vAttenuation[index];
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
					float3 magic = max(BetterSH9(normalize(PoiSHAr + PoiSHAg + PoiSHAb)), 0);
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
					poiLight.indirectColor = saturate(max(half3(0.05, 0.05, 0.05) * 1.0, max(PoiShadeSH9(half4(0.0, 0.0, 0.0, 1.0)), PoiShadeSH9(half4(0.0, -1.0, 0.0, 1.0)).rgb) * 1.0));
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
					poiLight.direction = calculateluminance(_LightColor0.rgb) * _WorldSpaceLightPos0.xyz + (PoiSHAr.xyz + PoiSHAg.xyz + PoiSHAb.xyz) / 3.0;
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
						lightMapMode = 1;
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
				if (0.0 == 5) // View Direction
				{
					float3 upViewDir = normalize(UNITY_MATRIX_V[1].xyz);
					float3 rightViewDir = normalize(UNITY_MATRIX_V[0].xyz);
					float yawOffset_Rads = radians(!IsInMirror() ? - 0.0 : 0.0);
					float3 rotatedViewYaw = normalize(RotateAroundAxis(rightViewDir, upViewDir, yawOffset_Rads));
					float3 rotatedViewCameraMeshOffset = RotateAroundAxis((getCameraPosition() - (poiMesh.worldPos)), upViewDir, yawOffset_Rads);
					float pitchOffset_Rads = radians(!IsInMirror() ? 0.0 : - 0.0);
					float3 rotatedViewPitch = RotateAroundAxis(rotatedViewCameraMeshOffset, rotatedViewYaw, pitchOffset_Rads);
					poiLight.direction = normalize(rotatedViewPitch);
				}
				if (!any(poiLight.direction))
				{
					poiLight.direction = float3(.4, 1, .4);
				}
				poiLight.direction = normalize(poiLight.direction);
				poiLight.attenuationStrength = 1.0;
				poiLight.attenuation = 1;
				#ifndef POI_PASS_LILFUR
				if (!all(_LightColor0.rgb == 0.0))
				{
					UNITY_LIGHT_ATTENUATION(attenuation, i, poiMesh.worldPos)
					poiLight.attenuation *= attenuation;
				}
				#endif
				#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
				half bakedAtten = UnitySampleBakedOcclusion(poiMesh.lightmapUV.xy, poiMesh.worldPos);
				float zDist = dot(_WorldSpaceCameraPos - poiMesh.worldPos, UNITY_MATRIX_V[2].xyz);
				float fadeDist = UnityComputeShadowFadeDistance(poiMesh.worldPos, zDist);
				poiLight.attenuation = UnityMixRealtimeAndBakedShadows(poiLight.attenuation, bakedAtten, UnityComputeShadowFade(fadeDist));
				#endif
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
				poiLight.nDotVCentered = abs(dot(poiMesh.normals[1], normalize(getCameraPosition() - i.worldPos.xyz)));
				poiLight.vertexNDotV = abs(dot(poiMesh.normals[0], poiCam.viewDir));
				poiLight.nDotH = dot(poiMesh.normals[1], poiLight.halfDir);
				poiLight.vertexNDotH = max(0.00001, dot(poiMesh.normals[0], poiLight.halfDir));
				poiLight.lDotv = dot(poiLight.direction, poiCam.viewDir);
				poiLight.lDotH = max(0.00001, dot(poiLight.direction, poiLight.halfDir));
				if (lightMapMode == 0)
				{
					float3 ShadeSH9Plus = GetSHLength();
					float3 ShadeSH9Minus = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w) + float3(PoiSHBr.z, PoiSHBg.z, PoiSHBb.z) / 3.0;
					float3 greyScaleVector = float3(.33333, .33333, .33333);
					float bw_lightColor = dot(poiLight.directColor, greyScaleVector);
					float bw_directLighting = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor * lerp(1, poiLight.attenuation, poiLight.attenuationStrength)) + dot(PoiShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_directLightingNoAtten = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor) + dot(PoiShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_bottomIndirectLighting = dot(ShadeSH9Minus, greyScaleVector);
					float bw_topIndirectLighting = dot(ShadeSH9Plus, greyScaleVector);
					float lightDifference = ((bw_topIndirectLighting + bw_lightColor) - bw_bottomIndirectLighting);
					poiLight.lightMap = smoothstep(0, lightDifference, bw_directLighting - bw_bottomIndirectLighting);
					poiLight.lightMapNoAttenuation = smoothstep(0, lightDifference, bw_directLightingNoAtten - bw_bottomIndirectLighting);
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
				if (lightMapMode == 3)
				{
					poiLight.lightMapNoAttenuation = 1;
					poiLight.lightMap = lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				}
				if (lightMapMode == 4)
				{
					#if defined(PROP_LIGHTDATASDFMAP)
					float2 lightDataSDFMap = 1;
					if (0.0 > 0)
					{
						float sdfLod = pow(0.0, 4.0);
						lightDataSDFMap = POI2D_SAMPLER_PANGRAD(_LightDataSDFMap, _linear_repeat, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0), max(poiMesh.dx, sdfLod), max(poiMesh.dy, sdfLod)).rg;
					}
					else
					{
						lightDataSDFMap = POI2D_SAMPLER_PAN(_LightDataSDFMap, _linear_repeat, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0)).rg;
					}
					poiLight.lightMapNoAttenuation = poiLight.nDotLSaturated;
					float3 faceR = mul((float3x3)unity_ObjectToWorld, float3(-1.0, 0.0, 0.0));
					float LdotR = dot(poiLight.direction.xz, faceR.xz);
					float sdf = LdotR < 0 ? lightDataSDFMap.g : lightDataSDFMap.r;
					float3 faceF = mul((float3x3)unity_ObjectToWorld, float3(0.0, 0.0, 1.0)).xyz;
					faceF.y *= 1.0;
					faceF = dot(faceF, faceF) == 0 ? 0 : normalize(faceF);
					float3 faceL = poiLight.direction;
					faceL.y *= 1.0;
					faceL = dot(faceL, faceL) == 0 ? 0 : normalize(faceL);
					float lnSDF = dot(faceL, faceF);
					poiLight.lightMapNoAttenuation = saturate(lnSDF * 0.5 + sdf * 0.5 + 0.25);
					poiLight.lightMap = saturate(lnSDF * 0.5 + sdf * 0.5 + 0.25) * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
					#else
					poiLight.lightMapNoAttenuation = poiLight.nDotLNormalized;
					poiLight.lightMap = poiLight.nDotLNormalized * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
					#endif
				}
				poiLight.lightMapNoAttenuation *= poiLight.detailShadow;
				poiLight.lightMap *= poiLight.detailShadow;
				poiLight.directColor = max(poiLight.directColor, 0.0001);
				poiLight.indirectColor = max(poiLight.indirectColor, 0.0001);
				if (0.0 == 3)
				{
					poiLight.directColor = max(poiLight.directColor, _LightingMinLightBrightness);
				}
				else
				{
					poiLight.directColor = max(poiLight.directColor, poiLight.directColor * min(10000, (_LightingMinLightBrightness * rcp(calculateluminance(poiLight.directColor)))));
					poiLight.indirectColor = max(poiLight.indirectColor, poiLight.indirectColor * min(10000, (_LightingMinLightBrightness * rcp(calculateluminance(poiLight.indirectColor)))));
				}
				poiLight.directColor = lerp(poiLight.directColor, dot(poiLight.directColor, float3(0.299, 0.587, 0.114)), _LightingMonochromatic);
				poiLight.indirectColor = lerp(poiLight.indirectColor, dot(poiLight.indirectColor, float3(0.299, 0.587, 0.114)), _LightingMonochromatic);
				if (_LightingCapEnabled)
				{
					poiLight.directColor = min(poiLight.directColor, _LightingCap);
					poiLight.indirectColor = min(poiLight.indirectColor, _LightingCap);
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
				poiLight.directColor = 0.0 ? MaxLuminance(_LightColor0.rgb * poiLight.attenuation, 1.0) : _LightColor0.rgb * poiLight.attenuation;
				#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
				poiLight.indirectColor = 0;
				#else
				poiLight.indirectColor = lerp(0, poiLight.directColor, 0.5);
				poiLight.indirectColor = 0.0 ? MaxLuminance(poiLight.indirectColor, 1.0) : poiLight.indirectColor;
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
				if (0.0 == 0 || 0.0 == 1 || 0.0 == 2)
				{
					poiLight.lightMap = poiLight.nDotLNormalized;
				}
				if (0.0 == 3)
				{
					poiLight.lightMap = 1;
				}
				poiLight.lightMap *= poiLight.detailShadow;
				poiLight.lightMapNoAttenuation = poiLight.lightMap;
				poiLight.lightMap *= lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				#endif
				#if defined(MOCHIE_PBR)
				MetallicAndSpecularFragDataInit(poiFragData, poiMesh, poiMods);
				#endif
				poiFragData.baseColor = mainTexture.rgb;
				#if !defined(POI_PASS_BASETWO) && !defined(POI_PASS_ADDTWO)
				poiFragData.baseColor *= poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0);
				poiFragData.alpha = mainTexture.a * float4(1,1,1,1).a;
				#else
				poiFragData.baseColor *= poiThemeColor(poiMods, _TwoPassColor.rgb, _TwoPassColorThemeIndex);
				poiFragData.alpha = mainTexture.a * _TwoPassColor.a;
				#endif
				if (2.0)
				{
					#if defined(PROP_ALPHAMASK) || !defined(OPTIMIZER_ENABLED)
					float alphaMask = POI2D_SAMPLER_PAN(_AlphaMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0).xy).r;
					#else
					float alphaMask = 1;
					#endif
					alphaMask = saturate(alphaMask * 1.0 + (0.0 ? 0.0 * - 1 : 0.0));
					if (0.0) alphaMask = 1 - alphaMask;
					if (2.0 == 1) poiFragData.alpha = alphaMask;
					if (2.0 == 2) poiFragData.alpha = poiFragData.alpha * alphaMask;
					if (2.0 == 3) poiFragData.alpha = saturate(poiFragData.alpha + alphaMask);
					if (2.0 == 4) poiFragData.alpha = saturate(poiFragData.alpha - alphaMask);
				}
				applyAlphaOptions(poiFragData, poiMesh, poiCam, poiMods);
				#if defined(_LIGHTINGMODE_SHADEMAP) && defined(VIGNETTE_MASKED)
				#ifndef POI_PASS_OUTLINE
				#endif
				#endif
				#ifdef VIGNETTE_MASKED
				#ifdef POI_PASS_OUTLINE
				if (1.0)
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
				if (0.0 > 0)
				{
					applyToGlobalMask(poiMods, 0.0 - 1, 2.0, poiLight.rampedLightMap);
				}
				if (0.0 > 0)
				{
					applyToGlobalMask(poiMods, 0.0 - 1, 2.0, 1 - poiLight.rampedLightMap);
				}
				poiLight.directLuminance = dot(poiLight.directColor, float3(0.299, 0.587, 0.114));
				poiLight.indirectLuminance = dot(poiLight.directColor, float3(0.299, 0.587, 0.114));
				poiLight.finalLuminance = dot(poiLight.finalLighting, float3(0.299, 0.587, 0.114));
				#ifdef POI_GRABPASS
				poiLight.finalLighting = max(poiLight.finalLighting, 0.0001);
				#endif
				
				if (0.0)
				{
					poiFragData.baseColor *= saturate(poiFragData.alpha);
				}
				poiFragData.finalColor = poiFragData.baseColor;
				#ifdef POI_LTCGI
				if (1)
				{
					float LTCGIsmoothness = 0.0;
					float LTCGImetalness = 0.0;
					float LTCGISpecMask = 1;
					if (1)
					{
						#ifdef MOCHIE_PBR
						float smoothness = poiFragData.smoothness;
						float metallic = poiFragData.metallic;
						float specularMask = poiFragData.specularMask;
						if (0.0 > 0)
						{
							metallic = customBlend(metallic, poiMods.globalMask[0.0 - 1], 2.0);
						}
						if (0.0 > 0)
						{
							smoothness = customBlend(smoothness, poiMods.globalMask[0.0 - 1], 2.0);
						}
						if (0.0 > 0)
						{
							specularMask = customBlend(specularMask, poiMods.globalMask[0.0 - 1], 2.0);
						}
						if (0)
						{
							specularMask *= SFVisibility(pow((1-smoothness),2), poiLight.directColor, poiLight.nDotV, 0.0);
						}
						LTCGIsmoothness = smoothness;
						LTCGImetalness = metallic;
						LTCGISpecMask = specularMask;
						#endif
					}
					accumulator_struct acc = (accumulator_struct)0;
					LTCGI_Contribution(
					acc, // our accumulator
					poiMesh.worldPos, // world position of the shaded point
					poiMesh.normals[1], // world space normal
					normalize(poiCam.worldPos - poiMesh.worldPos), // view vector to shaded point, normalized
					1.0f - LTCGIsmoothness, // roughness
					poiMesh.uv[1] // shadowmap coordinates (the normal Unity ones, they should be in sync with LTCGI maps)
					);
					acc.specular *= poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0);
					acc.diffuse *= poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0);
					poiLight.finalLightAdd += (acc.specular * lerp(unity_ColorSpaceDielectricSpec, poiFragData.baseColor, LTCGImetalness)) * LTCGISpecMask;
					poiLight.finalLighting += acc.diffuse;
					if (_LightingCapEnabled)
					{
						poiLight.finalLighting = min(poiLight.finalLighting, _LightingCap);
					}
				}
				#endif
				poiFragData.finalColor = poiFragData.baseColor * poiLight.finalLighting;
				#ifdef MOCHIE_PBR
				MochieBRDF(poiFragData, poiCam, poiLight, poiMesh, poiMods);
				#endif
				#ifndef POI_PASS_LILFUR
				#if !defined(POI_PASS_BASETWO) && !defined(POI_PASS_ADDTWO)
				poiFragData.alpha = 1.0 ? 1 : poiFragData.alpha;
				#else
				poiFragData.alpha = _AlphaForceOpaque2 ? 1 : poiFragData.alpha;
				#endif
				#endif
				poiFragData.finalColor += poiLight.finalLightAdd;
				#ifdef UNITY_PASS_FORWARDBASE
				poiFragData.emission = max(poiFragData.emission * 1.0, 0);
				poiFragData.finalColor = max(poiFragData.finalColor * 1.0, 0);
				#endif
				if (0.0 == POI_MODE_OPAQUE)
				{
				}
				clip(poiFragData.alpha - 0.5);
				if (0.0 == POI_MODE_CUTOUT && !0.0)
				{
					poiFragData.alpha = 1;
				}
				poiFragData.finalColor += poiFragData.emission * poiMods.globalEmission;
				applyUnityFog(poiFragData.finalColor, i.fogData);
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

VertexOut spsVert(SpsInputs v) {
  sps_apply(v);
  return vert((appdata)v);
}

			ENDCG
		
}
		Pass
		{

			Name "Add"
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
			ZTest [_ZTest]
			ColorMask RGBA
			Offset [_OffsetFactor], [_OffsetUnits]
			BlendOp [_AddBlendOp], [_AddBlendOpAlpha]
			Blend [_AddSrcBlend] [_AddDstBlend], [_AddSrcBlendAlpha] [_AddDstBlendAlpha]
			CGPROGRAM

 #define AUTO_EXPOSURE 
 #define MOCHIE_PBR 
 #define POI_LTCGI 
 #define VIGNETTE_MASKED 
 #define _LIGHTINGMODE_REALISTIC 
 #define _STOCHASTICMODE_DELIOT_HEITZ 
 #define PROP_BUMPMAP 
 #define PROP_MOCHIEMETALLICMAPS 
 #define OPTIMIZER_ENABLED 
			#pragma target 5.0
			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_instancing
			#pragma multi_compile_vertex _ FOG_EXP2
			#define POI_PASS_ADD
			#pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED _MIXED_LIGHTING_SUBTRACTIVE
			#pragma skip_variants DECALS_OFF DECALS_3RT DECALS_4RT DECAL_SURFACE_GRADIENT _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma skip_variants _ADDITIONAL_LIGHT_SHADOWS
			#pragma skip_variants PROBE_VOLUMES_OFF PROBE_VOLUMES_L1 PROBE_VOLUMES_L2
			#pragma skip_variants _SCREEN_SPACE_OCCLUSION
			// #pragma vertex vert
#pragma vertex spsVert

			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			SamplerState sampler_linear_clamp;
			SamplerState sampler_linear_repeat;
			SamplerState sampler_trilinear_clamp;
			SamplerState sampler_trilinear_repeat;
			SamplerState sampler_point_clamp;
			SamplerState sampler_point_repeat;
			#define DielectricSpec float4(0.04, 0.04, 0.04, 1.0 - 0.04)
			#define HALF_PI float(1.5707964)
			#define PI float(3.14159265359)
			#define TWO_PI float(6.28318530718)
			#define PI_OVER_2 1.5707963f
			#define PI_OVER_4 0.785398f
			#define EPSILON 0.000001f
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, samplertex, coord, dx, dy) tex.SampleGrad(sampler##samplertex, coord, dx, dy)
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRADD(tex, samp, uv, pan, dx, dy) tex.SampleGrad(samp, POI_PAN_UV(uv, pan), dx, dy)
			#define POI_PAN_UV(uv, pan) (uv + _Time.x * pan)
			#define POI2D_SAMPLER_PAN(tex, texSampler, uv, pan) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, POI_PAN_UV(uv, pan)))
			#define POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, POI_PAN_UV(uv, pan), dx, dy))
			#define POI2D_SAMPLER(tex, texSampler, uv) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, uv))
			#define POI_SAMPLE_1D_X(tex, samp, uv) tex.Sample(samp, float2(uv, 0.5))
			#define POI2D_SAMPLER_GRAD(tex, texSampler, uv, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, uv, dx, dy))
			#define POI2D_SAMPLER_GRADD(tex, texSampler, uv, dx, dy) tex.SampleGrad(texSampler, uv, dx, dy)
			#define POI2D_PAN(tex, uv, pan) (tex2D(tex, POI_PAN_UV(uv, pan)))
			#define POI2D(tex, uv) (tex2D(tex, uv))
			#define POI_SAMPLE_TEX2D(tex, uv) (UNITY_SAMPLE_TEX2D(tex, uv))
			#define POI_SAMPLE_TEX2D_PAN(tex, uv, pan) (UNITY_SAMPLE_TEX2D(tex, POI_PAN_UV(uv, pan)))
			#define POI_SAMPLE_CUBE_LOD(tex, sampler, coord, lod) tex.SampleLevel(sampler, coord, lod)
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define POI_SAMPLE_SCREEN(tex, samp, uv)          tex.Sample(samp, float3(uv, unity_StereoEyeIndex))
			#else
			#define POI_SAMPLE_SCREEN(tex, samp, uv)          tex.Sample(samp, uv)
			#endif
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
			#ifndef UNITY_SPECCUBE_LOD_STEPS
			#define UNITY_SPECCUBE_LOD_STEPS (6)
			#endif
			#ifndef UNITY_LIGHTING_COMMON_INCLUDED
			#define UNITY_LIGHTING_COMMON_INCLUDED
			fixed4 _LightColor0;
			fixed4 _SpecColor;
			struct UnityLight
			{
				half3 color;
				half3 dir;
				half ndotl;
			};
			struct UnityIndirect
			{
				half3 diffuse;
				half3 specular;
			};
			struct UnityGI
			{
				UnityLight light;
				UnityIndirect indirect;
			};
			struct UnityGIInput
			{
				UnityLight light;
				float3 worldPos;
				half3 worldViewDir;
				half atten;
				half3 ambient;
				#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION) || defined(UNITY_ENABLE_REFLECTION_BUFFERS)
				float4 boxMin[2];
				#endif
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
				float4 boxMax[2];
				float4 probePosition[2];
				#endif
				float4 probeHDR[2];
			};
			#endif
			float _GrabMode;
			float _Mode;
			struct Unity_GlossyEnvironmentData
			{
				half roughness;
				half3 reflUVW;
			};
			#ifndef _STOCHASTICMODE_NONE
			#ifdef _STOCHASTICMODE_DELIOT_HEITZ
			float _StochasticDeliotHeitzDensity;
			#endif
			#endif
			#if defined(PROP_LIGHTINGAOMAPS)
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
			#if defined(PROP_LIGHTINGDETAILSHADOWMAPS)
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
			#if defined(PROP_LIGHTINGSHADOWMASKS)
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
			#if defined(PROP_LIGHTDATASDFMAP)
			Texture2D _LightDataSDFMap;
			float4 _LightDataSDFMap_ST;
			float2 _LightDataSDFMapPan;
			float _LightDataSDFMapUV;
			float _LightDataSDFMapLOD;
			float _LightDataSDFBlendY;
			#endif
			float _LightingDirectionMode;
			float3 _LightngForcedDirection;
			float _LightingViewDirOffsetPitch;
			float _LightingViewDirOffsetYaw;
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
			float _LightingMirrorVertexLightingEnabled;
			float _LightingEnableLightVolumes;
			float _LightDataDebugEnabled;
			float _LightingDebugVisualize;
			uint _UdonForceSceneLighting;
			float4 _Color;
			float _ColorThemeIndex;
			UNITY_DECLARE_TEX2D(_MainTex);
			#ifdef UNITY_STEREO_INSTANCING_ENABLED
			#define STEREO_UV(uv) float3(uv, unity_StereoEyeIndex)
			Texture2DArray<float> _CameraDepthTexture;
			#else
			#define STEREO_UV(uv) uv
			Texture2D<float> _CameraDepthTexture;
			#endif
			float SampleScreenDepth(float2 uv)
			{
				uv.y = _ProjectionParams.x * 0.5 + 0.5 - uv.y * _ProjectionParams.x;
				return _CameraDepthTexture.SampleLevel(sampler_point_clamp, STEREO_UV(uv), 0);
			}
			bool DepthTextureExists()
			{
				#ifdef UNITY_STEREO_INSTANCING_ENABLED
				float3 dTexDim;
				_CameraDepthTexture.GetDimensions(dTexDim.x, dTexDim.y, dTexDim.z);
				#else
				float2 dTexDim;
				_CameraDepthTexture.GetDimensions(dTexDim.x, dTexDim.y);
				#endif
				return dTexDim.x > 16;
			}
			float _MainPixelMode;
			float4 _MainTex_ST;
			float2 _MainTexPan;
			float _MainTexUV;
			float4 _MainTex_TexelSize;
			float _MainTexStochastic;
			float _MainIgnoreTexAlpha;
			#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _BumpMap;
			#endif
			float4 _BumpMap_ST;
			float2 _BumpMapPan;
			float _BumpMapUV;
			float _BumpScale;
			float _BumpMapStochastic;
			#if defined(PROP_ALPHAMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _AlphaMask;
			#endif
			float4 _AlphaMask_ST;
			float2 _AlphaMaskPan;
			float _AlphaMaskUV;
			float _AlphaMaskInvert;
			float _MainAlphaMaskMode;
			float _AlphaMaskBlendStrength;
			float _AlphaMaskValue;
			float _Cutoff;
			float _AlphaForceOpaque;
			float _AlphaMod;
			float _AlphaPremultiply;
			float _AlphaBoostFA;
			float _AlphaGlobalMask;
			float _AlphaGlobalMaskBlendType;
			float _IgnoreFog;
			float _RenderingReduceClipDistance;
			int _FlipBackfaceNormals;
			float _AddBlendOp;
			float _Cull;
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
			int _GlobalMaskVertexColorLinearSpace;
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
			#ifdef AUTO_EXPOSURE
			#if defined(PROP_VERTEXBASICSMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _VertexBasicsMask;
			float4 _VertexBasicsMask_ST;
			float4 _VertexBasicsMaskUVPan;
			float VertexBasicsMaskUV;
			float _VertexBasicsMaskChannel;
			#endif
			float4 _VertexManipulationLocalTranslation;
			float4 _VertexManipulationWorldTranslation;
			float4 _VertexManipulationLocalRotation;
			float3 _VertexManipulationLocalRotationSpeed;
			float4 _VertexManipulationLocalScale;
			float _VertexRoundingEnabled;
			int _VertexRoundingSpace;
			float _VertexRoundingDivision;
			float _VertexRoundingMaskChannel;
			#endif
			float _ShadowStrength;
			float _LightingIgnoreAmbientColor;
			float3 _LightingShadowColor;
			float _ShadingRampedLightMapApplyGlobalMaskIndex;
			float _ShadingRampedLightMapApplyGlobalMaskBlendType;
			float _ShadingRampedLightMapInverseApplyGlobalMaskIndex;
			float _ShadingRampedLightMapInverseApplyGlobalMaskBlendType;
			float _LightingAdditiveType;
			float _LightingAdditiveGradientStart;
			float _LightingAdditiveGradientEnd;
			float _LightingAdditiveDetailStrength;
			struct MatcapAudioLinkData
			{
				float matcapALEnabled;
				float matcapALAlphaAddBand;
				float4 matcapALAlphaAdd;
				float matcapALEmissionAddBand;
				float4 matcapALEmissionAdd;
				float matcapALIntensityAddBand;
				float4 matcapALIntensityAdd;
				float matcapALChronoPanType;
				float matcapALChronoPanBand;
				float matcapALChronoPanSpeed;
			};
			#ifdef MOCHIE_PBR
			#if defined(PROP_MOCHIEMETALLICMAPS) || !defined(OPTIMIZER_ENABLED)
			Texture2D _MochieMetallicMaps;
			float _PBRMapsStochastic;
			#endif
			float4 _MochieMetallicMaps_ST;
			float2 _MochieMetallicMapsPan;
			float _MochieMetallicMapsUV;
			float _MochieMetallicMapsStochastic;
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
			float _RefSpecFresnelStrength;
			float _SFExposureOcclusion;
			TextureCube _MochieReflCube;
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
			struct tessellatedAppData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 color : COLOR;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				uint vertexId : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOut
			{
				float4 pos : SV_POSITION;
				float4 uv[2] : TEXCOORD0;
				float3 normal : TEXCOORD2;
				float4 tangent : TEXCOORD3;
				float4 worldPos : TEXCOORD4;
				float4 localPos : TEXCOORD5;
				float4 vertexColor : TEXCOORD6;
				float4 lightmapUV : TEXCOORD7;
				float worldDir : TEXCOORD8;
				float2 fogData: TEXCOORD10;
				UNITY_SHADOW_COORDS(12)
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
				float2 uv[10];
				float2 parallaxUV;
				float2 dx;
				float2 dy;
				uint isRightHand;
			};
			struct PoiCam
			{
				float3 viewDir;
				float3 forwardDir;
				float3 worldPos;
				float distanceToVert;
				float4 clipPos;
				float4 screenSpacePosition;
				float3 reflectionDir;
				float3 vertexReflectionDir;
				float3 tangentViewDir;
				float4 posScreenSpace;
				float2 posScreenPixels;
				float2 screenUV;
				float vDotN;
				float4 worldDirection;
			};
			struct PoiMods
			{
				float4 Mask;
				float audioLink[5];
				float audioLinkAvailable;
				float audioLinkVersion;
				float4 audioLinkTexture;
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
				float nDotVCentered;
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
				float3 LTCGISpecular;
				float3 LTCGIDiffuse;
				float directLuminance;
				float indirectLuminance;
				float finalLuminance;
				#if defined(VERTEXLIGHT_ON)
				float4 vDotNL;
				float4 vertexVDotNL;
				float3 vColor[4];
				float4 vCorrectedDotNL;
				float4 vAttenuation;
				float4 vSaturatedDotNL;
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
				float smoothness;
				float smoothness2;
				float metallic;
				float specularMask;
				float reflectionMask;
				float3 baseColor;
				float3 finalColor;
				float alpha;
				float3 emission;
				float toggleVertexLights;
			};
			float4 poiTransformClipSpacetoScreenSpaceFrag(float4 clipPos)
			{
				float4 positionSS = float4(clipPos.xyz * clipPos.w, clipPos.w);
				positionSS.xy = positionSS.xy / _ScreenParams.xy;
				return positionSS;
			}
			static float4 PoiSHAr = 0;
			static float4 PoiSHAg = 0;
			static float4 PoiSHAb = 0;
			static float4 PoiSHBr = 0;
			static float4 PoiSHBg = 0;
			static float4 PoiSHBb = 0;
			static float4 PoiSHC  = 0;
			half3 PoiSHEval_L0L1(half4 normal)
			{
				half3 x;
				x.r = dot(PoiSHAr, normal);
				x.g = dot(PoiSHAg, normal);
				x.b = dot(PoiSHAb, normal);
				return x;
			}
			half3 PoiSHEval_L2(half4 normal)
			{
				half3 x1, x2;
				half4 vB = normal.xyzz * normal.yzzx;
				x1.r = dot(PoiSHBr, vB);
				x1.g = dot(PoiSHBg, vB);
				x1.b = dot(PoiSHBb, vB);
				half  vC = normal.x*normal.x - normal.y*normal.y;
				x2    = PoiSHC.rgb * vC;
				return x1 + x2;
			}
			half3 PoiShadeSH9 (half4 normal)
			{
				half3 res = PoiSHEval_L0L1(normal);
				res += PoiSHEval_L2(normal);
				#ifdef UNITY_COLORSPACE_GAMMA
				res = LinearToGammaSpace(res);
				#endif
				return res;
			}
			inline half4 Pow5(half4 x)
			{
				return x * x * x * x * x;
			}
			inline half3 FresnelLerp(half3 F0, half3 F90, half cosA)
			{
				half t = Pow5(1 - cosA);   // ala Schlick interpoliation
				return lerp(F0, F90, t);
			}
			inline half3 FresnelTerm(half3 F0, half cosA)
			{
				half t = Pow5(1 - cosA);   // ala Schlick interpoliation
				return F0 + (1 - F0) * t;
			}
			half perceptualRoughnessToMipmapLevel(half perceptualRoughness)
			{
				return perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
			}
			half3 Unity_GlossyEnvironment(UNITY_ARGS_TEXCUBE(tex), half4 hdr, Unity_GlossyEnvironmentData glossIn)
			{
				half perceptualRoughness = glossIn.roughness /* perceptualRoughness */ ;
				#if 0
				float m = PerceptualRoughnessToRoughness(perceptualRoughness); // m is the real roughness parameter
				const float fEps = 1.192092896e-07F;        // smallest such that 1.0+FLT_EPSILON != 1.0  (+1e-4h is NOT good here. is visibly very wrong)
				float n = (2.0 / max(fEps, m * m)) - 2.0;        // remap to spec power. See eq. 21 in --> https://dl.dropboxusercontent.com/u/55891920/papers/mm_brdf.pdf
				n /= 4;                                     // remap from n_dot_h formulatino to n_dot_r. See section "Pre-convolved Cube Maps vs Path Tracers" --> https://s3.amazonaws.com/docs.knaldtech.com/knald/1.0.0/lys_power_drops.html
				perceptualRoughness = pow(2 / (n + 2), 0.25);      // remap back to square root of real roughness (0.25 include both the sqrt root of the conversion and sqrt for going from roughness to perceptualRoughness)
				#else
				perceptualRoughness = perceptualRoughness * (1.7 - 0.7 * perceptualRoughness);
				#endif
				half mip = perceptualRoughnessToMipmapLevel(perceptualRoughness);
				half3 R = glossIn.reflUVW;
				half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(tex, R, mip);
				return DecodeHDR(rgbm, hdr);
			}
			half3 UnpackScaleNormalDXT5nm(half4 packednormal, half bumpScale)
			{
				half3 normal;
				normal.xy = (packednormal.wy * 2 - 1);
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				return normal;
			}
			half3 LerpWhiteTo(half3 b, half t)
			{
				half oneMinusT = 1 - t;
				return half3(oneMinusT, oneMinusT, oneMinusT) + b * t;
			}
			inline float GGXTerm(float NdotH, float roughness)
			{
				float a2 = roughness * roughness;
				float d = (NdotH * a2 - NdotH) * NdotH + 1.0f; // 2 mad
				return UNITY_INV_PI * a2 / (d * d + 1e-7f); // This function is not intended to be running on Mobile,
			}
			Unity_GlossyEnvironmentData UnityGlossyEnvironmentSetup(half Smoothness, half3 worldViewDir, half3 Normal, half3 fresnel0)
			{
				Unity_GlossyEnvironmentData g;
				g.roughness /* perceptualRoughness */ = 1 - Smoothness;
				g.reflUVW = reflect(-worldViewDir, Normal);
				return g;
			}
			half3 UnpackScaleNormalRGorAG(half4 packednormal, half bumpScale)
			{
				#if defined(UNITY_NO_DXT5nm)
				half3 normal = packednormal.xyz * 2 - 1;
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				return normal;
				#elif defined(UNITY_ASTC_NORMALMAP_ENCODING)
				half3 normal;
				normal.xy = (packednormal.wy * 2 - 1);
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				normal.xy *= bumpScale;
				return normal;
				#else
				packednormal.x *= packednormal.w;
				half3 normal;
				normal.xy = (packednormal.xy * 2 - 1);
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				return normal;
				#endif
			}
			half3 UnpackScaleNormal(half4 packednormal, half bumpScale)
			{
				return UnpackScaleNormalRGorAG(packednormal, bumpScale);
			}
			half3 BlendNormals(half3 n1, half3 n2)
			{
				return normalize(half3(n1.xy + n2.xy, n1.z * n2.z));
			}
			inline float2 Pow4(float2 x)
			{
				return x * x * x * x;
			}
			inline float3 Unity_SafeNormalize(float3 inVec)
			{
				float dp3 = max(0.001f, dot(inVec, inVec));
				return inVec * rsqrt(dp3);
			}
			inline float3 BoxProjectedCubemapDirection(float3 worldRefl, float3 worldPos, float4 cubemapCenter, float4 boxMin, float4 boxMax)
			{
				
				if (cubemapCenter.w > 0.0)
				{
					float3 nrdir = normalize(worldRefl);
					#if 1
					float3 rbmax = (boxMax.xyz - worldPos) / nrdir;
					float3 rbmin = (boxMin.xyz - worldPos) / nrdir;
					float3 rbminmax = (nrdir > 0.0f) ? rbmax : rbmin;
					#else // Optimized version
					float3 rbmax = (boxMax.xyz - worldPos);
					float3 rbmin = (boxMin.xyz - worldPos);
					float3 select = step(float3(0, 0, 0), nrdir);
					float3 rbminmax = lerp(rbmax, rbmin, select);
					rbminmax /= nrdir;
					#endif
					float fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);
					worldPos -= cubemapCenter.xyz;
					worldRefl = worldPos + nrdir * fa;
				}
				return worldRefl;
			}
			inline half3 UnityGI_IndirectSpecular(UnityGIInput data, half occlusion, Unity_GlossyEnvironmentData glossIn)
			{
				half3 specular;
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
				half3 originalReflUVW = glossIn.reflUVW;
				glossIn.reflUVW = BoxProjectedCubemapDirection(originalReflUVW, data.worldPos, data.probePosition[0], data.boxMin[0], data.boxMax[0]);
				#endif
				#ifdef _GLOSSYREFLECTIONS_OFF
				specular = unity_IndirectSpecColor.rgb;
				#else
				half3 env0 = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE(unity_SpecCube0), data.probeHDR[0], glossIn);
				#ifdef UNITY_SPECCUBE_BLENDING
				const float kBlendFactor = 0.99999;
				float blendLerp = data.boxMin[0].w;
				
				if (blendLerp < kBlendFactor)
				{
					#ifdef UNITY_SPECCUBE_BOX_PROJECTION
					glossIn.reflUVW = BoxProjectedCubemapDirection(originalReflUVW, data.worldPos, data.probePosition[1], data.boxMin[1], data.boxMax[1]);
					#endif
					half3 env1 = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1, unity_SpecCube0), data.probeHDR[1], glossIn);
					specular = lerp(env1, env0, blendLerp);
				}
				else
				{
					specular = env0;
				}
				#else
				specular = env0;
				#endif
				#endif
				return specular * occlusion;
			}
			inline half3 UnityGI_IndirectSpecular(UnityGIInput data, half occlusion, half3 normalWorld, Unity_GlossyEnvironmentData glossIn)
			{
				return UnityGI_IndirectSpecular(data, occlusion, glossIn);
			}
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
					return o.uv[0].xy;
					case 1:
					return o.uv[0].zw;
					case 2:
					return o.uv[1].xy;
					case 3:
					return o.uv[1].zw;
					default:
					return o.uv[0].xy;
				}
			}
			float2 vertexUV(in appdata v, int index)
			{
				switch(index)
				{
					case 0:
					return v.uv0.xy;
					case 1:
					return v.uv1.xy;
					case 2:
					return v.uv2.xy;
					case 3:
					return v.uv3.xy;
					default:
					return v.uv0.xy;
				}
			}
			float calculateluminance(float3 color)
			{
				return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
			}
			float dotToDegrees(float dot)
			{
				dot = clamp(dot, -1.0, 1.0);
				return degrees(acos(dot));
			}
			float dotToDegrees(float3 a, float3 b)
			{
				return dotToDegrees(dot(normalize(a), normalize(b)));
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
				float3 L0 = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w) + float3(PoiSHBr.z, PoiSHBg.z, PoiSHBb.z) / 3.0;
				indirect.r = shEvaluateDiffuseL1Geomerics_local(L0.r, PoiSHAr.xyz, normal.xyz);
				indirect.g = shEvaluateDiffuseL1Geomerics_local(L0.g, PoiSHAg.xyz, normal.xyz);
				indirect.b = shEvaluateDiffuseL1Geomerics_local(L0.b, PoiSHAb.xyz, normal.xyz);
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
				x.r = length(PoiSHAr);
				x.g = length(PoiSHAg);
				x.b = length(PoiSHAb);
				x1.r = length(PoiSHBr);
				x1.g = length(PoiSHBg);
				x1.b = length(PoiSHBb);
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
			float blendOverlay(float base, float blend)
			{
				return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
			}
			float3 blendOverlay(float3 base, float3 blend)
			{
				return float3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
			}
			float blendLighten(float base, float blend)
			{
				return max(blend, base);
			}
			float3 blendLighten(float3 base, float3 blend)
			{
				return float3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
			}
			float blendLinearDodge(float base, float blend)
			{
				return min(base + blend, 1.0);
			}
			float3 blendLinearDodge(float3 base, float3 blend)
			{
				return base + blend;
			}
			float blendMultiply(float base, float blend)
			{
				return base * blend;
			}
			float3 blendMultiply(float3 base, float3 blend)
			{
				return base * blend;
			}
			float blendNormal(float base, float blend)
			{
				return blend;
			}
			float3 blendNormal(float3 base, float3 blend)
			{
				return blend;
			}
			float blendScreen(float base, float blend)
			{
				return 1.0 - ((1.0 - base) * (1.0 - blend));
			}
			float3 blendScreen(float3 base, float3 blend)
			{
				return float3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
			}
			float blendSubtract(float base, float blend)
			{
				return max(base - blend, 0.0);
			}
			float3 blendSubtract(float3 base, float3 blend)
			{
				return max(base - blend, 0.0);
			}
			float blendMixed(float base, float blend)
			{
				return base + base * blend;
			}
			float3 blendMixed(float3 base, float3 blend)
			{
				return base + base * blend;
			}
			float3 customBlend(float3 base, float3 blend, float blendType, float alpha = 1)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 1: output = lerp(base, blendDarken(base, blend), alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 5: output = lerp(base, blendLighten(base, blend), alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 7: output = blendSubtract(base, blend * alpha); break;
					case 8: output = lerp(base, blendLinearDodge(base, blend), alpha); break;
					case 9: output = lerp(base, blendOverlay(base, blend), alpha); break;
					case 20: output = lerp(base, blendMixed(base, blend), alpha); break;
					default: output = 0; break;
				}
				return output;
			}
			float3 customBlend(float base, float blend, float blendType, float alpha = 1)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 5: output = lerp(base, blendLighten(base, blend), alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 7: output = blendSubtract(base, blend * alpha); break;
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
			float globalMaskBlend(float baseMask, float globalMaskIndex, float blendType, PoiMods poiMods)
			{
				if (globalMaskIndex == 0)
				{
					return baseMask;
				}
				else
				{
					return maskBlend(baseMask, poiMods.globalMask[globalMaskIndex - 1], blendType);
				}
			}
			inline float poiRand(float2 co)
			{
				float3 p3 = frac(float3(co.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.x + p3.y) * p3.z);
			}
			inline float4 poiRand4(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				float2 a = frac((p3.xx + p3.yz) * p3.zy);
				float2 s2 = seed + 37.0;
				float3 q3 = frac(float3(s2.xyx) * 0.1031);
				q3 += dot(q3, q3.yzx + 33.33);
				float2 b = frac((q3.xx + q3.yz) * q3.zy);
				return float4(a, b);
			}
			inline float2 poiRand2(float seed)
			{
				float2 x = float2(seed, seed * 1.3);
				float3 p3 = frac(float3(x.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			inline float2 poiRand2(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			inline float poiRand3(float seed)
			{
				float p = frac(seed * 0.1031);
				p *= p + 33.33;
				p *= p + p;
				return frac(p);
			}
			inline float3 poiRand3(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			inline float3 poiRand3(float3 seed)
			{
				float3 p3 = frac(seed * 0.1031);
				p3 += dot(p3, p3.zyx + 31.32);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			inline float3 poiRand3Range(float2 Seed, float Range)
			{
				float3 r = poiRand3(Seed);
				return (r * 2.0 - 1.0) * Range;
			}
			float3 randomFloat3WiggleRange(float2 Seed, float Range, float wiggleSpeed, float timeOffset)
			{
				float3 rando = (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1);
				float speed = 1 + wiggleSpeed;
				return float3(sin(((_Time.x + timeOffset) + rando.x * PI) * speed), sin(((_Time.x + timeOffset) + rando.y * PI) * speed), sin(((_Time.x + timeOffset) + rando.z * PI) * speed)) * Range;
			}
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
				float H = abs((Q.w - Q.y) / (6 * C + EPSILON) + Q.z);
				return float3(H, C, Q.x);
			}
			float3 RGBtoHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
			float3 HSVtoRGB(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
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
			float4x4 brightnessMatrix(float brightness)
			{
				return float4x4(
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				brightness, brightness, brightness, 1
				);
			}
			float4x4 contrastMatrix(float contrast)
			{
				float t = (1.0 - contrast) / 2.0;
				return float4x4(
				contrast, 0, 0, 0,
				0, contrast, 0, 0,
				0, 0, contrast, 0,
				t, t, t, 1
				);
			}
			float4x4 saturationMatrix(float saturation)
			{
				float3 luminance = float3(0.3086, 0.6094, 0.0820);
				float oneMinusSat = 1.0 - saturation;
				float3 red = luminance.x * oneMinusSat;
				red += float3(saturation, 0, 0);
				float3 green = luminance.y * oneMinusSat;
				green += float3(0, saturation, 0);
				float3 blue = luminance.z * oneMinusSat;
				blue += float3(0, 0, saturation);
				return float4x4(
				red, 0,
				green, 0,
				blue, 0,
				0, 0, 0, 1
				);
			}
			float4 PoiColorBCS(float4 color, float brightness, float contrast, float saturation)
			{
				return mul(color, mul(brightnessMatrix(brightness), mul(contrastMatrix(contrast), saturationMatrix(saturation))));
			}
			float3 PoiColorBCS(float3 color, float brightness, float contrast, float saturation)
			{
				return mul(float4(color, 1), mul(brightnessMatrix(brightness), mul(contrastMatrix(contrast), saturationMatrix(saturation)))).rgb;
			}
			float3 linear_srgb_to_oklab(float3 c)
			{
				float l = 0.4122214708 * c.x + 0.5363325363 * c.y + 0.0514459929 * c.z;
				float m = 0.2119034982 * c.x + 0.6806995451 * c.y + 0.1073969566 * c.z;
				float s = 0.0883024619 * c.x + 0.2817188376 * c.y + 0.6299787005 * c.z;
				float l_ = pow(l, 1.0 / 3.0);
				float m_ = pow(m, 1.0 / 3.0);
				float s_ = pow(s, 1.0 / 3.0);
				return float3(
				0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
				1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
				0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
				);
			}
			float3 oklab_to_linear_srgb(float3 c)
			{
				float l_ = c.x + 0.3963377774 * c.y + 0.2158037573 * c.z;
				float m_ = c.x - 0.1055613458 * c.y - 0.0638541728 * c.z;
				float s_ = c.x - 0.0894841775 * c.y - 1.2914855480 * c.z;
				float l = l_ * l_ * l_;
				float m = m_ * m_ * m_;
				float s = s_ * s_ * s_;
				return float3(
				+ 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
				- 1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
				- 0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
				);
			}
			float3 hueShiftOKLab(float3 color, float shift, float selectOrShift)
			{
				float3 oklab = linear_srgb_to_oklab(color);
				float chroma = length(oklab.yz);
				oklab.y = selectOrShift > 0.5 ? oklab.y : chroma;
				oklab.z = selectOrShift > 0.5 ? oklab.z : 0;
				float s, c;
				sincos(shift * TWO_PI, s, c);
				oklab.yz = float2(c * oklab.y - s * oklab.z, s * oklab.y + c * oklab.z);
				return oklab_to_linear_srgb(oklab);
			}
			float3 hueShiftHSV(float3 color, float hueOffset, float selectOrShift)
			{
				float3 hsvCol = RGBtoHSV(color);
				hsvCol.x = hsvCol.x * selectOrShift + hueOffset;
				return HSVtoRGB(hsvCol);
			}
			float3 hueShift(float3 color, float shift, float ColorSpace, float selectOrShift)
			{
				switch(ColorSpace)
				{
					case 0.0:
					return hueShiftOKLab(color, shift, selectOrShift);
					case 1.0:
					return hueShiftHSV(color, shift, selectOrShift);
					default:
					return float3(1.0, 0.0, 0.0);
				}
			}
			float4 hueShift(float4 color, float shift, float ColorSpace, float selectOrShift)
			{
				return float4(hueShift(color.rgb, shift, ColorSpace, selectOrShift), color.a);
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
			float3 _VRChatMirrorCameraPos;
			float3 getCameraPosition()
			{
				#ifdef USING_STEREO_MATRICES
				return unity_StereoWorldSpaceCameraPos[0] * .5 + unity_StereoWorldSpaceCameraPos[1] * .5;
				#endif
				return _VRChatMirrorMode == 1 ? _VRChatMirrorCameraPos : _WorldSpaceCameraPos;
			}
			#ifdef POI_AUDIOLINK
			inline int poiALBandPass(int bandIdx)
			{
				bandIdx = clamp(bandIdx, 0, 3);
				return bandIdx == 0 ? ALPASS_AUDIOBASS : bandIdx == 1 ? ALPASS_AUDIOLOWMIDS : bandIdx == 2 ? ALPASS_AUDIOHIGHMIDS : ALPASS_AUDIOTREBLE;
			}
			#endif
			float2 calcPixelScreenUVs(half4 grabPos)
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
			float4 QuaternionFromMatrix(
			float m00, float m01, float m02,
			float m10, float m11, float m12,
			float m20, float m21, float m22)
			{
				float4 q;
				float trace = m00 + m11 + m22;
				if (trace > 0)
				{
					float s = sqrt(trace + 1) * 2;
					q.w = 0.25 * s;
					q.x = (m21 - m12) / s;
					q.y = (m02 - m20) / s;
					q.z = (m10 - m01) / s;
				}
				else if (m00 > m11 && m00 > m22)
				{
					float s = sqrt(1 + m00 - m11 - m22) * 2;
					q.w = (m21 - m12) / s;
					q.x = 0.25 * s;
					q.y = (m01 + m10) / s;
					q.z = (m02 + m20) / s;
				}
				else if (m11 > m22)
				{
					float s = sqrt(1 + m11 - m00 - m22) * 2;
					q.w = (m02 - m20) / s;
					q.x = (m01 + m10) / s;
					q.y = 0.25 * s;
					q.z = (m12 + m21) / s;
				}
				else
				{
					float s = sqrt(1 + m22 - m00 - m11) * 2;
					q.w = (m10 - m01) / s;
					q.x = (m02 + m20) / s;
					q.y = (m12 + m21) / s;
					q.z = 0.25 * s;
				}
				return q;
			}
			float4 MulQuat(float4 a, float4 b)
			{
				return float4(
				a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
				a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
				a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w,
				a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z
				);
			}
			float4 QuaternionFromBasis(float3 sx, float3 sy, float3 sz)
			{
				return QuaternionFromMatrix(
				sx.x, sy.x, sz.x,
				sx.y, sy.y, sz.y,
				sx.z, sy.z, sz.z
				);
			}
			float4 BuildQuatFromForwardUp(float3 forward, float3 up)
			{
				float3 f = normalize(forward);
				float3 u = normalize(up);
				float3 x = normalize(cross(u, f));
				float3 y = cross(f, x);
				return QuaternionFromBasis(x, y, f);
			}
			float3 QuaternionToEuler(float4 q)
			{
				float3 euler;
				float sinr_cosp = 2 * (q.w * q.z + q.x * q.y);
				float cosr_cosp = 1 - 2 * (q.z * q.z + q.x * q.x);
				euler.z = atan2(sinr_cosp, cosr_cosp) * 57.2958;
				float sinp = 2 * (q.w * q.x - q.y * q.z);
				if (abs(sinp) >= 1)
				euler.x = (sinp >= 0 ? 1 : - 1) * 90;
				else
				euler.x = asin(sinp) * 57.2958;
				float siny_cosp = 2 * (q.w * q.y + q.z * q.x);
				float cosy_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
				euler.y = atan2(siny_cosp, cosy_cosp) * 57.2958;
				return euler;
			}
			float4 EulerToQuaternion(float3 euler)
			{
				float3 eulerRad = euler * 0.0174533;
				float cx = cos(eulerRad.x * 0.5);
				float sx = sin(eulerRad.x * 0.5);
				float cy = cos(eulerRad.y * 0.5);
				float sy = sin(eulerRad.y * 0.5);
				float cz = cos(eulerRad.z * 0.5);
				float sz = sin(eulerRad.z * 0.5);
				float4 q;
				q.w = cx * cy * cz + sx * sy * sz;
				q.x = sx * cy * cz - cx * sy * sz;
				q.y = cx * sy * cz + sx * cy * sz;
				q.z = cx * cy * sz - sx * sy * cz;
				return q;
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
			float3 RotateByQuaternion(float4 q, float3 v)
			{
				float3 u = q.xyz;
				float s = q.w;
				return 2.0 * dot(u, v) * u
				+ (s * s - dot(u, u)) * v
				+ 2.0 * s * cross(u, v);
			}
			float4 SlerpQuaternion(float4 qa, float4 qb, float t)
			{
				float cosHalfTheta = dot(qa, qb);
				if (cosHalfTheta < 0.0)
				{
					qb = -qb;
					cosHalfTheta = -cosHalfTheta;
				}
				if (cosHalfTheta > 0.9995)
				{
					float4 qr = normalize(qa * (1 - t) + qb * t);
					return qr;
				}
				float halfTheta = acos(cosHalfTheta);
				float sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta);
				float a = sin((1 - t) * halfTheta) / sinHalfTheta;
				float b = sin(t * halfTheta) / sinHalfTheta;
				return qa * a + qb * b;
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
			float3 RotateAroundAxis(float3 original, float3 axis, float radian)
			{
				float s = sin(radian);
				float c = cos(radian);
				float one_minus_c = 1.0 - c;
				axis = normalize(axis);
				float3x3 rot_mat = {
					one_minus_c * axis.x * axis.x + c, one_minus_c * axis.x * axis.y - axis.z * s, one_minus_c * axis.z * axis.x + axis.y * s,
					one_minus_c * axis.x * axis.y + axis.z * s, one_minus_c * axis.y * axis.y + c, one_minus_c * axis.y * axis.z - axis.x * s,
					one_minus_c * axis.z * axis.x - axis.y * s, one_minus_c * axis.y * axis.z + axis.x * s, one_minus_c * axis.z * axis.z + c
				};
				return mul(rot_mat, original);
			}
			float3 poiThemeColor(in PoiMods poiMods, in float3 srcColor, in float themeIndex)
			{
				float3 outputColor = srcColor;
				if (themeIndex != 0)
				{
					themeIndex = max(themeIndex - 1, 0);
					if (themeIndex <= 3)
					{
						outputColor = poiMods.globalColorTheme[themeIndex];
					}
					else
					{
						#ifdef POI_AUDIOLINK
						if (poiMods.audioLinkAvailable)
						{
							outputColor = poiMods.globalColorTheme[themeIndex];
						}
						#endif
					}
				}
				return outputColor;
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
			float3 lilBlendColor(float3 dstCol, float3 srcCol, float3 srcA, int blendMode)
			{
				float3 ad = dstCol + srcCol;
				float3 mu = dstCol * srcCol;
				float3 outCol = float3(0, 0, 0);
				if (blendMode == 0) outCol = srcCol; // Normal
				if (blendMode == 1) outCol = ad; // Add
				if (blendMode == 2) outCol = max(ad - mu, dstCol); // Screen
				if (blendMode == 3) outCol = mu; // Multiply
				return lerp(dstCol, outCol, srcA);
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
				return (value - borderMin) / max(saturate(borderMax - borderMin + fwidth(value)), .0001);
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / max(saturate(borderMax - borderMin + fwidth(value)), .0001);
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
			float3 AdjustLitLuminance(float3 rgb, float targetLuminance)
			{
				float currentLuminance;
				#if defined(UNITY_COLORSPACE_GAMMA)
				currentLuminance = dot(rgb, float3(0.22, 0.707, 0.071));
				#else
				currentLuminance = dot(rgb, float3(0.0396819152, 0.458021790, 0.00609653955));
				#endif
				float luminanceRatio = targetLuminance / currentLuminance;
				return rgb * luminanceRatio;
			}
			float3 ClampLuminance(float3 rgb, float minLuminance, float maxLuminance)
			{
				float currentLuminance = dot(rgb, float3(0.299, 0.587, 0.114));
				float minRatio = (currentLuminance != 0) ? minLuminance / currentLuminance : 1.0;
				float maxRatio = (currentLuminance != 0) ? maxLuminance / currentLuminance : 1.0;
				float luminanceRatio = clamp(min(maxRatio, max(minRatio, 1.0)), 0.0, 1.0);
				return lerp(rgb, rgb * luminanceRatio, luminanceRatio < 1.0);
			}
			float3 MaxLuminance(float3 rgb, float maxLuminance)
			{
				float currentLuminance = dot(rgb, float3(0.299, 0.587, 0.114));
				float luminanceRatio = (currentLuminance != 0) ? maxLuminance / max(currentLuminance, 0.00001) : 1.0;
				return lerp(rgb, rgb * luminanceRatio, currentLuminance > maxLuminance);
			}
			float OpenLitGray(float3 rgb)
			{
				return dot(rgb, float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
			}
			void OpenLitShadeSH9ToonDouble(float3 lightDirection, out float3 shMax, out float3 shMin)
			{
				#if !defined(LIGHTMAP_ON)
				float3 N = lightDirection * 0.666666;
				float4 vB = N.xyzz * N.yzzx;
				float3 res = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w);
				res.r += dot(PoiSHBr, vB);
				res.g += dot(PoiSHBg, vB);
				res.b += dot(PoiSHBb, vB);
				res += PoiSHC.rgb * (N.x * N.x - N.y * N.y);
				float3 l1;
				l1.r = dot(PoiSHAr.rgb, N);
				l1.g = dot(PoiSHAg.rgb, N);
				l1.b = dot(PoiSHAb.rgb, N);
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
				#if !defined(LIGHTMAP_ON)
				float3 sh9Dir = PoiSHAr.xyz * 0.333333 + PoiSHAg.xyz * 0.333333 + PoiSHAb.xyz * 0.333333;
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
				float3 sh9Dir = PoiSHAr.xyz * 0.333333 + PoiSHAg.xyz * 0.333333 + PoiSHAb.xyz * 0.333333;
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
			inline float CorrectedLinearEyeDepth(float z, float correctionFactor)
			{
				return 1.f / (z / UNITY_MATRIX_P._34 + correctionFactor);
			}
			float evalRamp4(float time, float4 ramp)
			{
				return lerp(ramp.x, ramp.y, smoothstep(ramp.z, ramp.w, time));
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
				const float4 C = float4(0.211324865405187, // (3.0 - sqrt(3.0)) / 6.0
				0.366025403784439, // 0.5 * (sqrt(3.0) - 1.0)
				- 0.577350269189626, // - 1.0 + 2.0 * C.x
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
			float poiInvertToggle(in float value, in float toggle)
			{
				return (toggle == 0 ? value : 1 - value);
			}
			float3 PoiBlendNormal(float3 dstNormal, float3 srcNormal)
			{
				return float3(dstNormal.xy + srcNormal.xy, dstNormal.z * srcNormal.z);
			}
			float3 lilTransformDirOStoWS(float3 directionOS, bool doNormalize)
			{
				if (doNormalize) return normalize(mul((float3x3)unity_ObjectToWorld, directionOS));
				else            return mul((float3x3)unity_ObjectToWorld, directionOS);
			}
			float2 poiGetWidthAndHeight(Texture2D tex)
			{
				uint width, height;
				tex.GetDimensions(width, height);
				return float2(width, height);
			}
			float2 poiGetWidthAndHeight(Texture2DArray tex)
			{
				uint width, height, element;
				tex.GetDimensions(width, height, element);
				return float2(width, height);
			}
			bool SceneHasReflections()
			{
				float width, height;
				unity_SpecCube0.GetDimensions(width, height);
				return !(width * height < 2);
			}
			void applyUnityFog(inout float3 col, float2 fogData)
			{
				if (0.0 == 0)
				{
					float fogFactor = 1.0;
					float depth = UNITY_Z_0_FAR_FROM_CLIPSPACE(fogData.x);
					if (unity_FogParams.z != unity_FogParams.w)
					{
						fogFactor = depth * unity_FogParams.z + unity_FogParams.w;
					}
					else if (fogData.y)
					{
						float exponent_val = unity_FogParams.x * depth;
						fogFactor = exp2(-exponent_val * exponent_val);
					}
					else if (unity_FogParams.y != 0.0f)
					{
						float exponent = unity_FogParams.y * depth;
						fogFactor = exp2(-exponent);
					}
					fixed3 appliedFogColor = unity_FogColor.rgb;
					#if defined(UNITY_PASS_FORWARDADD)
					appliedFogColor = fixed3(0, 0, 0);
					#endif
					col.rgb = lerp(appliedFogColor, col.rgb, saturate(fogFactor));
				}
			}
			void applyReducedRenderClipDistance(inout VertexOut o)
			{
				if (o.pos.w < _ProjectionParams.y * 1.01 && o.pos.w > 0)
				{
					#if defined(UNITY_REVERSED_Z) // DirectX
					o.pos.z = o.pos.z * 0.0001 + o.pos.w * 0.999;
					#else // OpenGL
					o.pos.z = o.pos.z * 0.0001 - o.pos.w * 0.999;
					#endif
				}
			}
			VertexOut vert(appdata v)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				VertexOut o;
				PoiInitStruct(VertexOut, o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				#ifdef POI_TESSELLATED
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(v);
				#endif
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				#ifdef POI_AUDIOLINK
				float vertexAudioLink[5];
				vertexAudioLink[0] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 0))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 0))[0];
				vertexAudioLink[1] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 1))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 1))[0];
				vertexAudioLink[2] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 2))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 2))[0];
				vertexAudioLink[3] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 3))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 3))[0];
				vertexAudioLink[4] = AudioLinkData(ALPASS_GENERALVU + float2(8, 0))[0];
				#endif
				#ifdef AUTO_EXPOSURE
				float3 ALLocalTranslation = 0;
				float3 ALrotation = 0;
				float3 CTALRotation = 0;
				float3 ALScale = 0;
				float3 ALWorldTranslation = 0;
				float ALHeight = 0;
				float ALRoundingAmount = 0;
				float4 ALSpectrumLocalOffset = 0;
				#if defined(PROP_VERTEXBASICSMASK) || !defined(OPTIMIZER_ENABLED)
				float4 vertexMaskTex = _VertexBasicsMask.SampleLevel(sampler_linear_repeat, poiUV(vertexUV(v, 0.0), float4(1,1,0,0)) + float4(0,0,0,0).xy * _Time.x, 0);
				#else
				float4 vertexMaskTex = 1;
				#endif
				float vertexEffectsMask[8] = {
					vertexMaskTex.r,
					vertexMaskTex.g,
					vertexMaskTex.b,
					vertexMaskTex.a,
					v.color.r,
					v.color.g,
					v.color.b,
					v.color.a
				};
				float basicsMask = vertexEffectsMask[0.0];
				float4 rotation = float4(
				lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask) +
				float3(180, 0, 0) +
				lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask) * _Time.x +
				ALrotation +
				CTALRotation,
				float4(0,0,0,1).w
				);
				float4 localTranslation = lerp(float4(0, 0, 0, 0), float4(0,0,0,1), basicsMask) + float4(ALLocalTranslation, 0) + ALSpectrumLocalOffset;
				float4 manualScale = lerp(float4(1, 1, 1, 1), float4(1,1,1,1), basicsMask);
				float4 localScale = manualScale + float4(ALScale, 0);
				v.normal = rotate_with_quaternion(v.normal, rotation.xyz);
				v.tangent.xyz = rotate_with_quaternion(v.tangent.xyz, rotation.xyz);
				v.vertex = transform(v.vertex, localTranslation, rotation, localScale);
				o.normal = UnityObjectToWorldNormal(v.normal);
				float3 heightOffset = 0;
				if ((0.0 + ALHeight) != 0)
				{
					#if defined(PROP_VERTEXMANIPULATIONHEIGHTMASK) || !defined(OPTIMIZER_ENABLED)
					heightOffset = (_VertexManipulationHeightMask.SampleLevel(sampler_linear_repeat, poiUV(vertexUV(v, 0.0), float4(1,1,0,0)) + float4(0,0,0,0).xy * _Time.x, 0)[0.0] - 0.0) * (0.0 + ALHeight) * o.normal;
					#else
					heightOffset = (0.0 + ALHeight) * o.normal;
					#endif
					heightOffset *= vertexEffectsMask[0.0];
				}
				float3 worldTranslation = lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask);
				v.vertex.xyz += mul(unity_WorldToObject, worldTranslation + ALWorldTranslation + heightOffset).xyz;
				
				if (1.0)
				{
					float roundingMask = vertexEffectsMask[0.0];
					if (roundingMask > 0)
					{
						float3 preRoundingVertex = v.vertex.xyz;
						float divisionAmount = max(0.0025 + ALRoundingAmount, 0.0000001);
						if (0 == 0)
						{
							float4 worldPos = mul(unity_ObjectToWorld, float4(preRoundingVertex, 1));
							float3 worldRoundPosition = (ceil(worldPos.xyz / divisionAmount) * divisionAmount) - divisionAmount * .5;
							v.vertex = mul(unity_WorldToObject, float4(worldRoundPosition, worldPos.w));
						}
						else if (0 == 1)
						{
							v.vertex.xyz = (ceil(preRoundingVertex / divisionAmount) * divisionAmount) - divisionAmount * .5;
						}
						v.vertex.xyz = lerp(preRoundingVertex, v.vertex.xyz, roundingMask);
					}
				}
				#endif
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.tangent.xyz = UnityObjectToWorldDir(v.tangent);
				o.tangent.w = v.tangent.w;
				o.vertexColor = v.color;
				o.uv[0] = float4(v.uv0.xy, v.uv1.xy);
				o.uv[1] = float4(v.uv2.xy, v.uv3.xy);
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
				o.fogData.x = o.pos.z; // This is used for fog calculations, so we need to ensure it's in clip space
				#ifdef FOG_EXP2
				o.fogData.y = 1;
				#else
				o.fogData.y = 0;
				#endif
				#ifndef FORWARD_META_PASS
				#if !defined(UNITY_PASS_SHADOWCASTER)
				UNITY_TRANSFER_SHADOW(o, o.uv[0].xy);
				#else
				v.vertex.xyz = o.localPos.xyz;
				TRANSFER_SHADOW_CASTER_NOPOS(o, o.pos);
				#endif
				#endif
				o.worldDir = dot(o.pos, CalculateFrustumCorrection());
				if (0.0)
				{
					applyReducedRenderClipDistance(o);
				}
				#ifdef POI_PASS_META
				o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
				#endif
				#ifdef POI_PASS_LILFUR
				#endif
				return o;
			}
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, uv) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan)) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if !defined(_STOCHASTICMODE_NONE)
			float2 StochasticHash2D2D(float2 s)
			{
				return frac(sin(glsl_mod(float2(dot(s, float2(127.1, 311.7)), dot(s, float2(269.5, 183.3))), 3.14159)) * 43758.5453);
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
				float3(vxID, bary.z),
				float3(vxID + float2(0, 1), bary.y),
				float3(vxID + float2(1, 0), bary.x)
				);
				float3x3 neg = float3x3(
				float3(vxID + float2(1, 1), -bary.z),
				float3(vxID + float2(1, 0), 1.0 - bary.y),
				float3(vxID + float2(0, 1), 1.0 - bary.x)
				);
				return (bary.z > 0) ? pos : neg;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, float2 dx, float2 dy)
			{
				float3x3 UVBW = DeliotHeitzStochasticUVBW(uv);
				return mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[0].xy), dx, dy), UVBW[0].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[1].xy), dx, dy), UVBW[1].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[2].xy), dx, dy), UVBW[2].z) ;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv)
			{
				float2 dx = ddx(uv), dy = ddy(uv);
				return DeliotHeitzSampleTexture(tex, texSampler, uv, dx, dy);
			}
			#endif // defined(_STOCHASTICMODE_DELIOT_HEITZ)
			void applyAlphaOptions(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiMods poiMods)
			{
				poiFragData.alpha = saturate(poiFragData.alpha + 0.0);
				if (0.0 > 0)
				{
					poiFragData.alpha = maskBlend(poiFragData.alpha, poiMods.globalMask[0.0 - 1], 2.0);
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
			#ifdef VIGNETTE_MASKED
			#ifdef _LIGHTINGMODE_REALISTIC
			#if defined(LIGHTMAP_ON) && defined(SHADOWS_SCREEN)
			#if defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK)
			#define SUBTRACTIVE_LIGHTING 1
			#endif
			#endif
			float FadeShadows(float attenuation, inout PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				#if HANDLE_SHADOWS_BLENDING_IN_GI || ADDITIONAL_MASKED_DIRECTIONAL_SHADOWS
				#if ADDITIONAL_MASKED_DIRECTIONAL_SHADOWS
				attenuation = poiLight.attenuation;
				#endif
				float viewZ = dot(_WorldSpaceCameraPos - poiMesh.worldPos, UNITY_MATRIX_V[2].xyz);
				float shadowFadeDistance = UnityComputeShadowFadeDistance(poiMesh.worldPos, viewZ);
				float shadowFade = UnityComputeShadowFade(shadowFadeDistance);
				float bakedAttenuation = UnitySampleBakedOcclusion(poiMesh.lightmapUV.xy, poiMesh.worldPos);
				attenuation = UnityMixRealtimeAndBakedShadows(attenuation, bakedAttenuation, shadowFade);
				#endif
				return attenuation;
			}
			void ApplySubtractiveLighting(inout UnityIndirect indirectLight, inout PoiLight poiLight, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				#if SUBTRACTIVE_LIGHTING
				poiLight.attenuation = FadeShadows(poiLight.attenuation, poiLight, poiMesh, poiCam);
				float ndotl = saturate(dot(poiMesh.normals[0], _WorldSpaceLightPos0.xyz));
				float3 shadowedLightEstimate = ndotl * (1 - poiLight.attenuation) * _LightColor0.rgb;
				float3 subtractedLight = indirectLight.diffuse - shadowedLightEstimate;
				subtractedLight = max(subtractedLight, unity_ShadowColor.rgb);
				subtractedLight = lerp(subtractedLight, indirectLight.diffuse, _LightShadowData.x);
				indirectLight.diffuse = min(subtractedLight, indirectLight.diffuse);
				#endif
			}
			UnityIndirect CreateIndirectLight(in PoiMesh poiMesh, in PoiCam poiCam, in PoiLight poiLight)
			{
				UnityIndirect indirectLight;
				indirectLight.diffuse = 0;
				indirectLight.specular = 0;
				#if defined(LIGHTMAP_ON)
				indirectLight.diffuse = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, poiMesh.lightmapUV.xy));
				#if defined(DIRLIGHTMAP_COMBINED)
				float4 lightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, poiMesh.lightmapUV.xy);
				indirectLight.diffuse = DecodeDirectionalLightmap(indirectLight.diffuse, lightmapDirection, poiMesh.normals[1]);
				#endif
				ApplySubtractiveLighting(indirectLight, poiLight, poiMesh, poiCam);
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float3 dynamicLightDiffuse = DecodeRealtimeLightmap(
				UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, poiMesh.lightmapUV.zw)
				);
				#if defined(DIRLIGHTMAP_COMBINED)
				float4 dynamicLightmapDirection = UNITY_SAMPLE_TEX2D_SAMPLER(unity_DynamicDirectionality, unity_DynamicLightmap, poiMesh.lightmapUV.zw);
				indirectLight.diffuse += DecodeDirectionalLightmap(dynamicLightDiffuse, dynamicLightmapDirection, poiMesh.normals[1]);
				#else
				indirectLight.diffuse += dynamicLightDiffuse;
				#endif
				#endif
				#if !defined(LIGHTMAP_ON) && !defined(DYNAMICLIGHTMAP_ON)
				#if UNITY_LIGHT_PROBE_PROXY_VOLUME
				if (unity_ProbeVolumeParams.x == 1)
				{
					indirectLight.diffuse = SHEvalLinearL0L1_SampleProbeVolume(
					float4(poiMesh.normals[1], 1), poiMesh.worldPos
					);
					indirectLight.diffuse = max(0, indirectLight.diffuse);
					#if defined(UNITY_COLORSPACE_GAMMA)
					indirectLight.diffuse = LinearToGammaSpace(indirectLight.diffuse);
					#endif
				}
				else
				{
					indirectLight.diffuse += max(0, PoiShadeSH9(float4(poiMesh.normals[1], 1)));
				}
				#else
				indirectLight.diffuse += max(0, PoiShadeSH9(float4(poiMesh.normals[1], 1)));
				#endif
				#endif
				indirectLight.diffuse *= poiLight.occlusion;
				return indirectLight;
			}
			#endif
			float GetRemapMinValue(float scale, float offset)
			{
				return clamp(-offset / scale, -0.01f, 1.01f); // Remap min
			}
			float GetRemapMaxValue(float scale, float offset)
			{
				return clamp((1.0f - offset) / scale, -0.01f, 1.01f); // Remap Max
			}
			sampler2D_float unity_NHxRoughness;
			half3 BRDF3_Direct(half3 diffColor, half3 specColor, half rlPow4, half smoothness)
			{
				half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp
				half specular = tex2D(unity_NHxRoughness, half2(rlPow4, 1 - smoothness)).r * LUT_RANGE;
				#if defined(_SPECULARHIGHLIGHTS_OFF)
				specular = 0.0;
				#endif
				return diffColor + specular * specColor;
			}
			half3 BRDF3_Indirect(half3 diffColor, half3 specColor, UnityIndirect indirect, half grazingTerm, half fresnelTerm)
			{
				half3 c = indirect.diffuse * diffColor;
				c += indirect.specular * lerp(specColor, grazingTerm, fresnelTerm);
				return c;
			}
			half4 POI_BRDF_PBS(half3 diffColor, half3 specColor, half oneMinusReflectivity, half smoothness, float3 normal, float3 viewDir, UnityLight light, UnityIndirect gi)
			{
				float3 reflDir = reflect(viewDir, normal);
				half nl = saturate(dot(normal, light.dir));
				half nv = saturate(dot(normal, viewDir));
				half2 rlPow4AndFresnelTerm = Pow4(float2(dot(reflDir, light.dir), 1 - nv));  // use R.L instead of N.H to save couple of instructions
				half rlPow4 = rlPow4AndFresnelTerm.x; // power exponent must match kHorizontalWarpExp in NHxRoughness() function in GeneratedTextures.cpp
				half fresnelTerm = rlPow4AndFresnelTerm.y;
				half grazingTerm = saturate(smoothness + (1 - oneMinusReflectivity));
				half3 color = BRDF3_Direct(diffColor, specColor, rlPow4, smoothness);
				color *= light.color * nl;
				color += BRDF3_Indirect(diffColor, specColor, gi, grazingTerm, fresnelTerm);
				return half4(color, 1);
			}
			void calculateShading(inout PoiLight poiLight, inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam)
			{
				float shadowAttenuation = lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				float attenuation = 1;
				#if defined(POINT) || defined(SPOT)
				shadowAttenuation = lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				#endif
				#ifdef POI_PASS_ADD
				if (3.0 == 3)
				{
					#if defined(POINT) || defined(SPOT)
					#if defined(_LIGHTINGMODE_REALISTIC) || defined(_LIGHTINGMODE_CLOTH) || defined(_LIGHTINGMODE_WRAPPED)
					poiLight.rampedLightMap = max(0, poiLight.nDotL);
					poiLight.finalLighting = poiLight.directColor * attenuation * max(0, poiLight.nDotL) * poiLight.detailShadow * shadowAttenuation;
					return;
					#endif
					#endif
				}
				if (3.0 == 0)
				{
					poiLight.rampedLightMap = max(0, poiLight.nDotL);
					poiLight.finalLighting = poiLight.directColor * attenuation * max(0, poiLight.nDotL) * poiLight.detailShadow * shadowAttenuation;
					return;
				}
				if (3.0 == 1)
				{
					#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
					float passthrough = 0;
					#else
					float passthrough = 0.5;
					#endif
					float2 ToonAddGradient = float2(0.0, 0.5);
					if (ToonAddGradient.x == ToonAddGradient.y) ToonAddGradient.y += 0.0001;
					poiLight.rampedLightMap = smoothstep(ToonAddGradient.y, ToonAddGradient.x, 1 - (.5 * poiLight.nDotL + .5));
					#if defined(POINT) || defined(SPOT)
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.additiveShadow, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(ToonAddGradient.x, ToonAddGradient.y, 1 - (.5 * poiLight.nDotL + .5)));
					#else
					poiLight.finalLighting = lerp(poiLight.directColor * max(min(poiLight.attenuation, poiLight.detailShadow), passthrough), poiLight.indirectColor, smoothstep(ToonAddGradient.x, ToonAddGradient.y, 1 - (.5 * poiLight.nDotL + .5)));
					#endif
					return;
				}
				#endif
				float shadowStrength = 1.0 * poiLight.shadowMask;
				#ifdef POI_PASS_OUTLINE
				shadowStrength = lerp(0, shadowStrength, 0.0);
				#endif
				#ifdef _LIGHTINGMODE_REALISTIC
				UnityLight light;
				light.dir = poiLight.direction;
				light.color = max(0, _LightColor0.rgb) * saturate(shadowAttenuation * attenuation * poiLight.detailShadow);
				light.ndotl = poiLight.nDotLSaturated;
				UnityIndirect indirectLight = (UnityIndirect)0;
				#ifdef UNITY_PASS_FORWARDBASE
				indirectLight = CreateIndirectLight(poiMesh, poiCam, poiLight);
				#endif
				#ifdef UNITY_PASS_FORWARDBASE
				light.color = max(light.color * 1.0, 0);
				light.color = max(light.color + 0.0, 0);
				indirectLight.diffuse = max(indirectLight.diffuse * 1.0, 0);
				indirectLight.diffuse = max(indirectLight.diffuse + 0.0, 0);
				#endif
				poiLight.rampedLightMap = poiLight.nDotLSaturated;
				poiLight.finalLighting = max(POI_BRDF_PBS(1, 0, 0, 0, poiMesh.normals[1], poiCam.viewDir, light, indirectLight).xyz, _LightingMinLightBrightness);
				#ifdef UNITY_PASS_FORWARDBASE
				if (_UdonLightVolumeEnabled && 1.0)
				{
					float3 L0 = 0;
					float3 L1r = 0;
					float3 L1g = 0;
					float3 L1b = 0;
					#ifdef LIGHTMAP_ON
					LightVolumeAdditiveSH(poiMesh.worldPos, L0, L1r, L1g, L1b);
					poiLight.finalLighting += clamp(LightVolumeEvaluate(poiMesh.normals[1], L0, L1r, L1g, L1b), _LightingMinLightBrightness, _LightingCap);
					#endif
				}
				#endif
				#endif
				if (poiFragData.toggleVertexLights)
				{
					#if defined(VERTEXLIGHT_ON)
					float3 vertexLighting = float3(0, 0, 0);
					for (int index = 0; index < 4; index++)
					{
						float lightingMode = 3.0;
						if (lightingMode == 3)
						{
							#if defined(_LIGHTINGMODE_REALISTIC)
							lightingMode = 0;
							#else
							lightingMode = 1;
							#endif
						}
						if (lightingMode == 0)
						{
							vertexLighting = max(vertexLighting, poiLight.vColor[index] * poiLight.vSaturatedDotNL[index] * poiLight.detailShadow); // Realistic
						}
						if (lightingMode == 1)
						{
							float2 ToonAddGradient = float2(0.0, 0.5);
							if (ToonAddGradient.x == ToonAddGradient.y) ToonAddGradient.y += 0.0001;
							vertexLighting = max(vertexLighting, lerp(poiLight.vColor[index], poiLight.vColor[index] * 0.5, smoothstep(ToonAddGradient.x, ToonAddGradient.y, 1 - (.5 * poiLight.vDotNL[index] + .5))) * poiLight.detailShadow);
						}
					}
					float3 mixedLight = poiLight.finalLighting;
					poiLight.finalLighting = max(vertexLighting, poiLight.finalLighting);
					#endif
				}
			}
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
			float3 GetReflections(in PoiCam poiCam, in PoiLight pl, in PoiMesh poiMesh, float perceptualRoughness, float ForceFallback, float LightFallback, TextureCube reflectionCube, float4 hdrData, float3 reflectionDir)
			{
				float3 reflections = 0;
				float3 lighting = pl.finalLighting;
				if (ForceFallback == 0)
				{
					
					if (SceneHasReflections())
					{
						#ifdef UNITY_PASS_FORWARDBASE
						reflections = GetWorldReflections(reflectionDir, poiMesh.worldPos.xyz, perceptualRoughness);
						#endif
					}
					else
					{
						#ifdef UNITY_PASS_FORWARDBASE
						float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
						float mipLevel0 = floor(mipLevel);
						float mipLevel1 = mipLevel0 + 1;
						float mipLerp = frac(mipLevel);
						float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
						float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
						reflections = lerp(sample0, sample1, mipLerp);
						reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
						#endif
						#ifdef POI_PASS_ADD
						if (LightFallback)
						{
							float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
							float mipLevel0 = floor(mipLevel);
							float mipLevel1 = mipLevel0 + 1;
							float mipLerp = frac(mipLevel);
							float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
							float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
							reflections = lerp(sample0, sample1, mipLerp);
							reflections = DecodeHDR(float4(reflections, 1), hdrData) * pl.finalLighting;
						}
						#endif
					}
				}
				else
				{
					#ifdef UNITY_PASS_FORWARDBASE
					float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
					float mipLevel0 = floor(mipLevel);
					float mipLevel1 = mipLevel0 + 1;
					float mipLerp = frac(mipLevel);
					float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
					float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
					reflections = lerp(sample0, sample1, mipLerp);
					reflections = DecodeHDR(float4(reflections, 1), hdrData) * lerp(1, pl.finalLighting, LightFallback);
					#endif
					#ifdef POI_PASS_ADD
					if (LightFallback)
					{
						float mipLevel = perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
						float mipLevel0 = floor(mipLevel);
						float mipLevel1 = mipLevel0 + 1;
						float mipLerp = frac(mipLevel);
						float3 sample0 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel0);
						float3 sample1 = reflectionCube.SampleLevel(sampler_linear_clamp, reflectionDir, mipLevel1);
						reflections = lerp(sample0, sample1, mipLerp);
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
					float lambdaV = nDotL * (nDotV * (1 - roughness) + roughness);
					float lambdaL = nDotV * (nDotL * (1 - roughness) + roughness);
					visibilityTerm = 0.5f / (lambdaV + lambdaL + 1e-5f);
					float a = nDotH * roughness;
					float k = roughness / (1.0 - nDotH * nDotH + a * a+ 1e-5f);
					float dotTerm = k * k * UNITY_INV_PI;
					visibilityTerm *= dotTerm;
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
			float SFVisibility(float brdfRoughness, float3 directColor, float NDotV, float ExposureOcclusion)
			{
				float Visibility = saturate(length(directColor + EPSILON) * (1.0/(ExposureOcclusion))); //Using direct color because I think it should be generally more forgiving
				return saturate(pow(NDotV + Visibility, exp2(-16.0 * brdfRoughness - 1.0)) - 1.0 + Visibility);
			}
			#endif
			#ifdef MOCHIE_PBR
			void MetallicAndSpecularFragDataInit(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiMods poiMods)
			{
				float smoothness = 1.0;
				float smoothness2 = 1.0;
				float metallic = 1.0;
				float specularMask = 1;
				float reflectionMask = 1;
				smoothness *= poiFragData.smoothness;
				smoothness2 *= poiFragData.smoothness2;
				metallic *= poiFragData.metallic;
				specularMask *= poiFragData.specularMask;
				reflectionMask *= poiFragData.reflectionMask;
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
				reflectionMask *= 1.0;
				specularMask *= 1.0;
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
				poiFragData.smoothness *= smoothness;
				poiFragData.smoothness2 *= smoothness2;
				poiFragData.metallic *= metallic;
				poiFragData.specularMask *= specularMask;
				poiFragData.reflectionMask *= reflectionMask;
			}
			void MochieBRDF(inout PoiFragData poiFragData, in PoiCam poiCam, inout PoiLight poiLight, in PoiMesh poiMesh, inout PoiMods poiMods)
			{
				float smoothness = poiFragData.smoothness;
				float smoothness2 = poiFragData.smoothness2;
				float metallic = poiFragData.metallic;
				float specularMask = poiFragData.specularMask;
				float reflectionMask = poiFragData.reflectionMask;
				if (0.0 > 0)
				{
					metallic = maskBlend(metallic, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					smoothness = maskBlend(smoothness, poiMods.globalMask[0.0 - 1], 2.0);
					smoothness2 = maskBlend(smoothness2, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					reflectionMask = customBlend(reflectionMask, poiMods.globalMask[0.0 - 1], 2.0);
				}
				if (0.0 > 0)
				{
					specularMask = customBlend(specularMask, poiMods.globalMask[0.0 - 1], 2.0);
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
					float3 normals = lerp(poiMesh.normals[0], poiMesh.normals[1], 1.0);
					percepRough = GSAA_Filament(normals, percepRough, 0.15, 0.1);
					if (0.0 == 1 && 1.0 > 0)
					{
						percepRough2 = GSAA_Filament(normals, percepRough2, 0.15, 0.1);
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
				#if defined(POINT) || defined(SPOT)
				float attenuation = lerp(poiLight.additiveShadow, 1, 0.0);
				#else
				float attenuation = min(poiLight.nDotLSaturated, lerp(poiLight.attenuation, 1, 0.0));
				#endif
				float3 fresnelTerm = 1;
				float3 specularTerm = 1;
				float pbrNDotL = lerp(poiLight.vertexNDotL, poiLight.nDotL, 1.0);
				float pbrNDotV = lerp(poiLight.vertexNDotV, poiLight.nDotV, 1.0);
				float pbrNDotH = lerp(poiLight.vertexNDotH, poiLight.nDotH, 1.0);
				float3 pbrReflectionDir = lerp(poiCam.vertexReflectionDir, poiCam.reflectionDir, 1.0);
				GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness);
				specular = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation;
				if (poiFragData.toggleVertexLights)
				{
					#if defined(VERTEXLIGHT_ON)
					for (int index = 0; index < 4; index++)
					{
						fresnelTerm = 1;
						specularTerm = 1;
						float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
						float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
						GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness);
						vSpecular += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion;
					}
					#endif
				}
				if (0.0 == 1)
				{
					float3 fresnelTerm = 1;
					float3 specularTerm = 1;
					GetSpecFresTerm(pbrNDotL, pbrNDotV, pbrNDotH, poiLight.lDotH, specularTerm, fresnelTerm, specCol, brdfRoughness2);
					specular2 = poiLight.directColor * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * attenuation * 1.0;
					if (poiFragData.toggleVertexLights)
					{
						#if defined(VERTEXLIGHT_ON)
						for (int index = 0; index < 4; index++)
						{
							fresnelTerm = 1;
							specularTerm = 1;
							float pbrVDotNL = lerp(poiLight.vertexVDotNL[index], poiLight.vDotNL[index], 1.0);
							float pbrVDotNH = lerp(poiLight.vertexVDotNH[index], poiLight.vDotNH[index], 1.0);
							GetSpecFresTerm(pbrVDotNL, pbrNDotV, pbrVDotNH, poiLight.vDotLH[index], specularTerm, fresnelTerm, specCol, brdfRoughness2);
							vSpecular2 += poiLight.vColor[index] * specularTerm * fresnelTerm * specularMask * poiThemeColor(poiMods, float4(1,1,1,1), 0.0) * poiLight.occlusion * 1.0;
						}
						#endif
					}
				}
				float surfaceReduction = (1.0 / (brdfRoughness * brdfRoughness + 1.0));
				float grazingTerm = saturate(smoothness + (1 - omr));
				float3 reflCol = GetReflections(poiCam, poiLight, poiMesh, percepRough, 0.0, 1.0, _MochieReflCube, _MochieReflCube_HDR, pbrReflectionDir);
				reflections = surfaceReduction * reflCol * FresnelLerp(specCol, specCol + lerp(specCol, 1, 0.5) * 0.5, pbrNDotV) * SFVisibility(brdfRoughness, poiLight.directColor, pbrNDotV, 0.0);
				reflections *= poiThemeColor(poiMods, float4(1,1,1,1), 0.0);
				reflections *= reflectionMask;
				diffuse = lerp(diffuse, diffuse * omr, reflectionMask);
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
				PoiSHAr = unity_SHAr;
				PoiSHAg = unity_SHAg;
				PoiSHAb = unity_SHAb;
				PoiSHBr = unity_SHBr;
				PoiSHBg = unity_SHBg;
				PoiSHBb = unity_SHBb;
				PoiSHC =  unity_SHC;
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
				PoiFragData poiFragData;
				poiFragData.smoothness = 1;
				poiFragData.smoothness2 = 1;
				poiFragData.metallic = 1;
				poiFragData.specularMask = 1;
				poiFragData.reflectionMask = 1;
				poiFragData.emission = 0;
				poiFragData.baseColor = float3(0, 0, 0);
				poiFragData.finalColor = float3(0, 0, 0);
				poiFragData.alpha = 1;
				poiFragData.toggleVertexLights = 0;
				#ifdef POI_UDIMDISCARD
				applyUDIMDiscard(i, facing);
				#endif
				poiMesh.objectPosition = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				poiMesh.objNormal = mul(unity_WorldToObject, i.normal);
				poiMesh.normals[0] = i.normal;
				poiMesh.tangent[0] = i.tangent.xyz;
				poiMesh.binormal[0] = cross(i.normal, i.tangent.xyz) * (i.tangent.w * unity_WorldTransformParams.w);
				poiMesh.worldPos = i.worldPos.xyz;
				poiMesh.localPos = i.localPos.xyz;
				poiMesh.vertexColor = i.vertexColor;
				poiMesh.isFrontFace = facing;
				poiMesh.dx = ddx(poiMesh.uv[0]);
				poiMesh.dy = ddy(poiMesh.uv[0]);
				poiMesh.isRightHand = i.tangent.w > 0.0;
				#ifndef POI_PASS_OUTLINE
				if (!poiMesh.isFrontFace && 1)
				{
					poiMesh.normals[0] *= -1;
					poiMesh.tangent[0] *= -1;
					poiMesh.binormal[0] *= -1;
				}
				#endif
				poiCam.viewDir = !IsOrthographicCamera() ? normalize(_WorldSpaceCameraPos - i.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 tanToWorld0 = float3(poiMesh.tangent[0].x, poiMesh.binormal[0].x, poiMesh.normals[0].x);
				float3 tanToWorld1 = float3(poiMesh.tangent[0].y, poiMesh.binormal[0].y, poiMesh.normals[0].y);
				float3 tanToWorld2 = float3(poiMesh.tangent[0].z, poiMesh.binormal[0].z, poiMesh.normals[0].z);
				float3 ase_tanViewDir = tanToWorld0 * poiCam.viewDir.x + tanToWorld1 * poiCam.viewDir.y + tanToWorld2 * poiCam.viewDir.z;
				poiCam.tangentViewDir = normalize(ase_tanViewDir);
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				poiMesh.lightmapUV = i.lightmapUV;
				#endif
				poiMesh.parallaxUV = poiCam.tangentViewDir.xy / max(poiCam.tangentViewDir.z, 0.0001);
				poiMesh.uv[0] = i.uv[0].xy;
				poiMesh.uv[1] = i.uv[0].zw;
				poiMesh.uv[2] = i.uv[1].xy;
				poiMesh.uv[3] = i.uv[1].zw;
				poiMesh.uv[4] = poiMesh.uv[0];
				poiMesh.uv[5] = poiMesh.uv[0];
				poiMesh.uv[6] = poiMesh.uv[0];
				poiMesh.uv[7] = poiMesh.uv[0];
				poiMesh.uv[8] = poiMesh.uv[0];
				poiMesh.uv[4] = calculatePanosphereUV(poiMesh);
				poiMesh.uv[5] = calculateWorldUV(poiMesh);
				poiMesh.uv[6] = calculatePolarCoordinate(poiMesh);
				poiMesh.uv[8] = calculatelocalUV(poiMesh);
				float3 worldViewUp = normalize(float3(0, 1, 0) - poiCam.viewDir * dot(poiCam.viewDir, float3(0, 1, 0)));
				float3 worldViewRight = normalize(cross(poiCam.viewDir, worldViewUp));
				poiMesh.uv[9] = float2(dot(worldViewRight, poiMesh.normals[0]), dot(worldViewUp, poiMesh.normals[0])) * 0.5 + 0.5;
				poiMods.globalMask[0] = 1;
				poiMods.globalMask[1] = 1;
				poiMods.globalMask[2] = 1;
				poiMods.globalMask[3] = 1;
				poiMods.globalMask[4] = 1;
				poiMods.globalMask[5] = 1;
				poiMods.globalMask[6] = 1;
				poiMods.globalMask[7] = 1;
				poiMods.globalMask[8] = 1;
				poiMods.globalMask[9] = 1;
				poiMods.globalMask[10] = 1;
				poiMods.globalMask[11] = 1;
				poiMods.globalMask[12] = 1;
				poiMods.globalMask[13] = 1;
				poiMods.globalMask[14] = 1;
				poiMods.globalMask[15] = 1;
				ApplyGlobalMaskModifiers(poiMesh, poiMods, poiCam);
				float2 mainUV = poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0));
				if (0.0)
				{
					mainUV = sharpSample(float4(0.03125,0.03125,32,32), mainUV);
				}
				float4 mainTexture = POI2D_SAMPLER_PAN_STOCHASTIC(_MainTex, _MainTex, mainUV, float4(0,0,0,0), 0.0);
				mainTexture.a = max(mainTexture.a, 0.0);
				#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
				poiMesh.tangentSpaceNormal = UnpackScaleNormal(POI2D_SAMPLER_PAN_STOCHASTIC(_BumpMap, _MainTex, poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0)), float4(0,0,0,0), 0.0), 1.0);
				#else
				poiMesh.tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				#endif
				float3 tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				poiMesh.normals[0] = normalize(
				tangentSpaceNormal.x * poiMesh.tangent[0] +
				tangentSpaceNormal.y * poiMesh.binormal[0] +
				tangentSpaceNormal.z * poiMesh.normals[0]
				);
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
				poiCam.clipPos = i.pos;
				poiCam.distanceToVert = distance(poiMesh.worldPos, poiCam.worldPos);
				poiCam.posScreenSpace = poiTransformClipSpacetoScreenSpaceFrag(poiCam.clipPos);
				#if defined(POI_GRABPASS) && defined(POI_PASS_BASE)
				poiCam.screenUV = poiCam.clipPos.xy / poiGetWidthAndHeight(_PoiGrab2);
				#else
				poiCam.screenUV = poiCam.clipPos.xy / _ScreenParams.xy;
				#endif
				#ifdef UNITY_SINGLE_PASS_STEREO
				poiCam.posScreenSpace.x = poiCam.posScreenSpace.x * 0.5;
				#endif
				poiCam.posScreenPixels = calcPixelScreenUVs(poiCam.posScreenSpace);
				poiCam.vDotN = abs(dot(poiCam.viewDir, poiMesh.normals[1]));
				poiCam.worldDirection.xyz = poiMesh.worldPos.xyz - poiCam.worldPos;
				poiCam.worldDirection.w = i.worldDir;
				calculateGlobalThemes(poiMods);
				if (_UdonForceSceneLighting)
				{
					_LightingMinLightBrightness = 0;
					_LightingCapEnabled = 0;
					_LightingMonochromatic = 0;
				}
				poiLight.finalLightAdd = 0;
				#ifdef UNITY_PASS_FORWARDBASE
				float3 L0 = float3(0, 0, 0);
				float3 L1r = float3(0, 0, 0);
				float3 L1g = float3(0, 0, 0);
				float3 L1b = float3(0, 0, 0);
				if (_UdonLightVolumeEnabled && 1.0)
				{
					LightVolumeSH(poiMesh.worldPos, L0, L1r, L1g, L1b);
					PoiSHAr = float4(L1r, L0.r);
					PoiSHAg = float4(L1g, L0.g);
					PoiSHAb = float4(L1b, L0.b);
					PoiSHBr = 0;
					PoiSHBg = 0;
					PoiSHBb = 0;
					PoiSHC = 0;
				}
				#endif
				#if defined(PROP_LIGHTINGAOMAPS)
				float4 AOMaps = POI2D_SAMPLER_PAN(_LightingAOMaps, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0));
				poiLight.occlusion = min(min(min(lerp(1, AOMaps.r, 1.0), lerp(1, AOMaps.g, 0.0)), lerp(1, AOMaps.b, 0.0)), lerp(1, AOMaps.a, 0.0));
				#else
				poiLight.occlusion = 1;
				#endif
				if (0.0 > 0)
				{
					poiLight.occlusion = maskBlend(poiLight.occlusion, poiMods.globalMask[0.0 - 1], 2.0);
				}
				#if defined(PROP_LIGHTINGDETAILSHADOWMAPS)
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
				#if defined(PROP_LIGHTINGSHADOWMASKS)
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
					poiFragData.toggleVertexLights = 1;
				}
				if (IsInMirror() && 1.0 == 0)
				{
					poiFragData.toggleVertexLights = 0;
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
					poiLight.vSaturatedDotNL = saturate(poiLight.vDotNL);
					[unroll]
					for (int index = 0; index < 4; index++)
					{
						poiLight.vPosition[index] = float3(unity_4LightPosX0[index], unity_4LightPosY0[index], unity_4LightPosZ0[index]);
						float3 vertexToLightSource = poiLight.vPosition[index] - poiMesh.worldPos;
						poiLight.vDirection[index] = normalize(vertexToLightSource);
						poiLight.vColor[index] = 0.0 ? MaxLuminance(unity_LightColor[index].rgb * poiLight.vAttenuation[index], 1.0) : unity_LightColor[index].rgb * poiLight.vAttenuation[index];
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
					float3 magic = max(BetterSH9(normalize(PoiSHAr + PoiSHAg + PoiSHAb)), 0);
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
					poiLight.indirectColor = saturate(max(half3(0.05, 0.05, 0.05) * 1.0, max(PoiShadeSH9(half4(0.0, 0.0, 0.0, 1.0)), PoiShadeSH9(half4(0.0, -1.0, 0.0, 1.0)).rgb) * 1.0));
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
					poiLight.direction = calculateluminance(_LightColor0.rgb) * _WorldSpaceLightPos0.xyz + (PoiSHAr.xyz + PoiSHAg.xyz + PoiSHAb.xyz) / 3.0;
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
						lightMapMode = 1;
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
				if (0.0 == 5) // View Direction
				{
					float3 upViewDir = normalize(UNITY_MATRIX_V[1].xyz);
					float3 rightViewDir = normalize(UNITY_MATRIX_V[0].xyz);
					float yawOffset_Rads = radians(!IsInMirror() ? - 0.0 : 0.0);
					float3 rotatedViewYaw = normalize(RotateAroundAxis(rightViewDir, upViewDir, yawOffset_Rads));
					float3 rotatedViewCameraMeshOffset = RotateAroundAxis((getCameraPosition() - (poiMesh.worldPos)), upViewDir, yawOffset_Rads);
					float pitchOffset_Rads = radians(!IsInMirror() ? 0.0 : - 0.0);
					float3 rotatedViewPitch = RotateAroundAxis(rotatedViewCameraMeshOffset, rotatedViewYaw, pitchOffset_Rads);
					poiLight.direction = normalize(rotatedViewPitch);
				}
				if (!any(poiLight.direction))
				{
					poiLight.direction = float3(.4, 1, .4);
				}
				poiLight.direction = normalize(poiLight.direction);
				poiLight.attenuationStrength = 1.0;
				poiLight.attenuation = 1;
				#ifndef POI_PASS_LILFUR
				if (!all(_LightColor0.rgb == 0.0))
				{
					UNITY_LIGHT_ATTENUATION(attenuation, i, poiMesh.worldPos)
					poiLight.attenuation *= attenuation;
				}
				#endif
				#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
				half bakedAtten = UnitySampleBakedOcclusion(poiMesh.lightmapUV.xy, poiMesh.worldPos);
				float zDist = dot(_WorldSpaceCameraPos - poiMesh.worldPos, UNITY_MATRIX_V[2].xyz);
				float fadeDist = UnityComputeShadowFadeDistance(poiMesh.worldPos, zDist);
				poiLight.attenuation = UnityMixRealtimeAndBakedShadows(poiLight.attenuation, bakedAtten, UnityComputeShadowFade(fadeDist));
				#endif
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
				poiLight.nDotVCentered = abs(dot(poiMesh.normals[1], normalize(getCameraPosition() - i.worldPos.xyz)));
				poiLight.vertexNDotV = abs(dot(poiMesh.normals[0], poiCam.viewDir));
				poiLight.nDotH = dot(poiMesh.normals[1], poiLight.halfDir);
				poiLight.vertexNDotH = max(0.00001, dot(poiMesh.normals[0], poiLight.halfDir));
				poiLight.lDotv = dot(poiLight.direction, poiCam.viewDir);
				poiLight.lDotH = max(0.00001, dot(poiLight.direction, poiLight.halfDir));
				if (lightMapMode == 0)
				{
					float3 ShadeSH9Plus = GetSHLength();
					float3 ShadeSH9Minus = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w) + float3(PoiSHBr.z, PoiSHBg.z, PoiSHBb.z) / 3.0;
					float3 greyScaleVector = float3(.33333, .33333, .33333);
					float bw_lightColor = dot(poiLight.directColor, greyScaleVector);
					float bw_directLighting = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor * lerp(1, poiLight.attenuation, poiLight.attenuationStrength)) + dot(PoiShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_directLightingNoAtten = (((poiLight.nDotL * 0.5 + 0.5) * bw_lightColor) + dot(PoiShadeSH9(float4(poiMesh.normals[1], 1)), greyScaleVector));
					float bw_bottomIndirectLighting = dot(ShadeSH9Minus, greyScaleVector);
					float bw_topIndirectLighting = dot(ShadeSH9Plus, greyScaleVector);
					float lightDifference = ((bw_topIndirectLighting + bw_lightColor) - bw_bottomIndirectLighting);
					poiLight.lightMap = smoothstep(0, lightDifference, bw_directLighting - bw_bottomIndirectLighting);
					poiLight.lightMapNoAttenuation = smoothstep(0, lightDifference, bw_directLightingNoAtten - bw_bottomIndirectLighting);
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
				if (lightMapMode == 3)
				{
					poiLight.lightMapNoAttenuation = 1;
					poiLight.lightMap = lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
				}
				if (lightMapMode == 4)
				{
					#if defined(PROP_LIGHTDATASDFMAP)
					float2 lightDataSDFMap = 1;
					if (0.0 > 0)
					{
						float sdfLod = pow(0.0, 4.0);
						lightDataSDFMap = POI2D_SAMPLER_PANGRAD(_LightDataSDFMap, _linear_repeat, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0), max(poiMesh.dx, sdfLod), max(poiMesh.dy, sdfLod)).rg;
					}
					else
					{
						lightDataSDFMap = POI2D_SAMPLER_PAN(_LightDataSDFMap, _linear_repeat, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0)).rg;
					}
					poiLight.lightMapNoAttenuation = poiLight.nDotLSaturated;
					float3 faceR = mul((float3x3)unity_ObjectToWorld, float3(-1.0, 0.0, 0.0));
					float LdotR = dot(poiLight.direction.xz, faceR.xz);
					float sdf = LdotR < 0 ? lightDataSDFMap.g : lightDataSDFMap.r;
					float3 faceF = mul((float3x3)unity_ObjectToWorld, float3(0.0, 0.0, 1.0)).xyz;
					faceF.y *= 1.0;
					faceF = dot(faceF, faceF) == 0 ? 0 : normalize(faceF);
					float3 faceL = poiLight.direction;
					faceL.y *= 1.0;
					faceL = dot(faceL, faceL) == 0 ? 0 : normalize(faceL);
					float lnSDF = dot(faceL, faceF);
					poiLight.lightMapNoAttenuation = saturate(lnSDF * 0.5 + sdf * 0.5 + 0.25);
					poiLight.lightMap = saturate(lnSDF * 0.5 + sdf * 0.5 + 0.25) * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
					#else
					poiLight.lightMapNoAttenuation = poiLight.nDotLNormalized;
					poiLight.lightMap = poiLight.nDotLNormalized * lerp(1, poiLight.attenuation, poiLight.attenuationStrength);
					#endif
				}
				poiLight.lightMapNoAttenuation *= poiLight.detailShadow;
				poiLight.lightMap *= poiLight.detailShadow;
				poiLight.directColor = max(poiLight.directColor, 0.0001);
				poiLight.indirectColor = max(poiLight.indirectColor, 0.0001);
				if (0.0 == 3)
				{
					poiLight.directColor = max(poiLight.directColor, _LightingMinLightBrightness);
				}
				else
				{
					poiLight.directColor = max(poiLight.directColor, poiLight.directColor * min(10000, (_LightingMinLightBrightness * rcp(calculateluminance(poiLight.directColor)))));
					poiLight.indirectColor = max(poiLight.indirectColor, poiLight.indirectColor * min(10000, (_LightingMinLightBrightness * rcp(calculateluminance(poiLight.indirectColor)))));
				}
				poiLight.directColor = lerp(poiLight.directColor, dot(poiLight.directColor, float3(0.299, 0.587, 0.114)), _LightingMonochromatic);
				poiLight.indirectColor = lerp(poiLight.indirectColor, dot(poiLight.indirectColor, float3(0.299, 0.587, 0.114)), _LightingMonochromatic);
				if (_LightingCapEnabled)
				{
					poiLight.directColor = min(poiLight.directColor, _LightingCap);
					poiLight.indirectColor = min(poiLight.indirectColor, _LightingCap);
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
				poiLight.directColor = 0.0 ? MaxLuminance(_LightColor0.rgb * poiLight.attenuation, 1.0) : _LightColor0.rgb * poiLight.attenuation;
				#if defined(POINT_COOKIE) || defined(DIRECTIONAL_COOKIE)
				poiLight.indirectColor = 0;
				#else
				poiLight.indirectColor = lerp(0, poiLight.directColor, 0.5);
				poiLight.indirectColor = 0.0 ? MaxLuminance(poiLight.indirectColor, 1.0) : poiLight.indirectColor;
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
				if (0.0 == 0 || 0.0 == 1 || 0.0 == 2)
				{
					poiLight.lightMap = poiLight.nDotLNormalized;
				}
				if (0.0 == 3)
				{
					poiLight.lightMap = 1;
				}
				poiLight.lightMap *= poiLight.detailShadow;
				poiLight.lightMapNoAttenuation = poiLight.lightMap;
				poiLight.lightMap *= lerp(1, poiLight.additiveShadow, poiLight.attenuationStrength);
				#endif
				#if defined(MOCHIE_PBR)
				MetallicAndSpecularFragDataInit(poiFragData, poiMesh, poiMods);
				#endif
				poiFragData.baseColor = mainTexture.rgb;
				#if !defined(POI_PASS_BASETWO) && !defined(POI_PASS_ADDTWO)
				poiFragData.baseColor *= poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0);
				poiFragData.alpha = mainTexture.a * float4(1,1,1,1).a;
				#else
				poiFragData.baseColor *= poiThemeColor(poiMods, _TwoPassColor.rgb, _TwoPassColorThemeIndex);
				poiFragData.alpha = mainTexture.a * _TwoPassColor.a;
				#endif
				if (2.0)
				{
					#if defined(PROP_ALPHAMASK) || !defined(OPTIMIZER_ENABLED)
					float alphaMask = POI2D_SAMPLER_PAN(_AlphaMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0).xy).r;
					#else
					float alphaMask = 1;
					#endif
					alphaMask = saturate(alphaMask * 1.0 + (0.0 ? 0.0 * - 1 : 0.0));
					if (0.0) alphaMask = 1 - alphaMask;
					if (2.0 == 1) poiFragData.alpha = alphaMask;
					if (2.0 == 2) poiFragData.alpha = poiFragData.alpha * alphaMask;
					if (2.0 == 3) poiFragData.alpha = saturate(poiFragData.alpha + alphaMask);
					if (2.0 == 4) poiFragData.alpha = saturate(poiFragData.alpha - alphaMask);
				}
				applyAlphaOptions(poiFragData, poiMesh, poiCam, poiMods);
				#if defined(_LIGHTINGMODE_SHADEMAP) && defined(VIGNETTE_MASKED)
				#ifndef POI_PASS_OUTLINE
				#endif
				#endif
				#ifdef VIGNETTE_MASKED
				#ifdef POI_PASS_OUTLINE
				if (1.0)
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
				if (0.0 > 0)
				{
					applyToGlobalMask(poiMods, 0.0 - 1, 2.0, poiLight.rampedLightMap);
				}
				if (0.0 > 0)
				{
					applyToGlobalMask(poiMods, 0.0 - 1, 2.0, 1 - poiLight.rampedLightMap);
				}
				poiLight.directLuminance = dot(poiLight.directColor, float3(0.299, 0.587, 0.114));
				poiLight.indirectLuminance = dot(poiLight.directColor, float3(0.299, 0.587, 0.114));
				poiLight.finalLuminance = dot(poiLight.finalLighting, float3(0.299, 0.587, 0.114));
				#ifdef POI_GRABPASS
				poiLight.finalLighting = max(poiLight.finalLighting, 0.0001);
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
				#ifndef POI_PASS_LILFUR
				#if !defined(POI_PASS_BASETWO) && !defined(POI_PASS_ADDTWO)
				poiFragData.alpha = 1.0 ? 1 : poiFragData.alpha;
				#else
				poiFragData.alpha = _AlphaForceOpaque2 ? 1 : poiFragData.alpha;
				#endif
				#endif
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
				if (4.0 == 4)
				{
					poiFragData.alpha = saturate(poiFragData.alpha * 10.0);
				}
				if (0.0 != POI_MODE_TRANSPARENT)
				{
					poiFragData.finalColor *= poiFragData.alpha;
				}
				applyUnityFog(poiFragData.finalColor, i.fogData);
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

VertexOut spsVert(SpsInputs v) {
  sps_apply(v);
  return vert((appdata)v);
}

			ENDCG
		
}
		Pass
		{

			Name "ShadowCaster"
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

 #define AUTO_EXPOSURE 
 #define MOCHIE_PBR 
 #define POI_LTCGI 
 #define VIGNETTE_MASKED 
 #define _LIGHTINGMODE_REALISTIC 
 #define _STOCHASTICMODE_DELIOT_HEITZ 
 #define PROP_BUMPMAP 
 #define PROP_MOCHIEMETALLICMAPS 
 #define OPTIMIZER_ENABLED 
			#pragma target 5.0
			#pragma multi_compile_instancing
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_vertex _ FOG_EXP2
			#define POI_PASS_SHADOW
			#pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED _MIXED_LIGHTING_SUBTRACTIVE
			#pragma skip_variants DECALS_OFF DECALS_3RT DECALS_4RT DECAL_SURFACE_GRADIENT _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma skip_variants _ADDITIONAL_LIGHT_SHADOWS
			#pragma skip_variants PROBE_VOLUMES_OFF PROBE_VOLUMES_L1 PROBE_VOLUMES_L2
			#pragma skip_variants _SCREEN_SPACE_OCCLUSION
			// #pragma vertex vert
#pragma vertex spsVert

			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			SamplerState sampler_linear_clamp;
			SamplerState sampler_linear_repeat;
			SamplerState sampler_trilinear_clamp;
			SamplerState sampler_trilinear_repeat;
			SamplerState sampler_point_clamp;
			SamplerState sampler_point_repeat;
			#define DielectricSpec float4(0.04, 0.04, 0.04, 1.0 - 0.04)
			#define HALF_PI float(1.5707964)
			#define PI float(3.14159265359)
			#define TWO_PI float(6.28318530718)
			#define PI_OVER_2 1.5707963f
			#define PI_OVER_4 0.785398f
			#define EPSILON 0.000001f
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, samplertex, coord, dx, dy) tex.SampleGrad(sampler##samplertex, coord, dx, dy)
			#define POI2D_SAMPLE_TEX2D_SAMPLERGRADD(tex, samp, uv, pan, dx, dy) tex.SampleGrad(samp, POI_PAN_UV(uv, pan), dx, dy)
			#define POI_PAN_UV(uv, pan) (uv + _Time.x * pan)
			#define POI2D_SAMPLER_PAN(tex, texSampler, uv, pan) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, POI_PAN_UV(uv, pan)))
			#define POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, POI_PAN_UV(uv, pan), dx, dy))
			#define POI2D_SAMPLER(tex, texSampler, uv) (UNITY_SAMPLE_TEX2D_SAMPLER(tex, texSampler, uv))
			#define POI_SAMPLE_1D_X(tex, samp, uv) tex.Sample(samp, float2(uv, 0.5))
			#define POI2D_SAMPLER_GRAD(tex, texSampler, uv, dx, dy) (POI2D_SAMPLE_TEX2D_SAMPLERGRAD(tex, texSampler, uv, dx, dy))
			#define POI2D_SAMPLER_GRADD(tex, texSampler, uv, dx, dy) tex.SampleGrad(texSampler, uv, dx, dy)
			#define POI2D_PAN(tex, uv, pan) (tex2D(tex, POI_PAN_UV(uv, pan)))
			#define POI2D(tex, uv) (tex2D(tex, uv))
			#define POI_SAMPLE_TEX2D(tex, uv) (UNITY_SAMPLE_TEX2D(tex, uv))
			#define POI_SAMPLE_TEX2D_PAN(tex, uv, pan) (UNITY_SAMPLE_TEX2D(tex, POI_PAN_UV(uv, pan)))
			#define POI_SAMPLE_CUBE_LOD(tex, sampler, coord, lod) tex.SampleLevel(sampler, coord, lod)
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define POI_SAMPLE_SCREEN(tex, samp, uv)          tex.Sample(samp, float3(uv, unity_StereoEyeIndex))
			#else
			#define POI_SAMPLE_SCREEN(tex, samp, uv)          tex.Sample(samp, uv)
			#endif
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
			#ifndef UNITY_SPECCUBE_LOD_STEPS
			#define UNITY_SPECCUBE_LOD_STEPS (6)
			#endif
			#ifndef UNITY_LIGHTING_COMMON_INCLUDED
			#define UNITY_LIGHTING_COMMON_INCLUDED
			fixed4 _LightColor0;
			fixed4 _SpecColor;
			struct UnityLight
			{
				half3 color;
				half3 dir;
				half ndotl;
			};
			struct UnityIndirect
			{
				half3 diffuse;
				half3 specular;
			};
			struct UnityGI
			{
				UnityLight light;
				UnityIndirect indirect;
			};
			struct UnityGIInput
			{
				UnityLight light;
				float3 worldPos;
				half3 worldViewDir;
				half atten;
				half3 ambient;
				#if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION) || defined(UNITY_ENABLE_REFLECTION_BUFFERS)
				float4 boxMin[2];
				#endif
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
				float4 boxMax[2];
				float4 probePosition[2];
				#endif
				float4 probeHDR[2];
			};
			#endif
			float _GrabMode;
			float _Mode;
			struct Unity_GlossyEnvironmentData
			{
				half roughness;
				half3 reflUVW;
			};
			#ifndef _STOCHASTICMODE_NONE
			#ifdef _STOCHASTICMODE_DELIOT_HEITZ
			float _StochasticDeliotHeitzDensity;
			#endif
			#endif
			float4 _Color;
			float _ColorThemeIndex;
			UNITY_DECLARE_TEX2D(_MainTex);
			#ifdef UNITY_STEREO_INSTANCING_ENABLED
			#define STEREO_UV(uv) float3(uv, unity_StereoEyeIndex)
			Texture2DArray<float> _CameraDepthTexture;
			#else
			#define STEREO_UV(uv) uv
			Texture2D<float> _CameraDepthTexture;
			#endif
			float SampleScreenDepth(float2 uv)
			{
				uv.y = _ProjectionParams.x * 0.5 + 0.5 - uv.y * _ProjectionParams.x;
				return _CameraDepthTexture.SampleLevel(sampler_point_clamp, STEREO_UV(uv), 0);
			}
			bool DepthTextureExists()
			{
				#ifdef UNITY_STEREO_INSTANCING_ENABLED
				float3 dTexDim;
				_CameraDepthTexture.GetDimensions(dTexDim.x, dTexDim.y, dTexDim.z);
				#else
				float2 dTexDim;
				_CameraDepthTexture.GetDimensions(dTexDim.x, dTexDim.y);
				#endif
				return dTexDim.x > 16;
			}
			float _MainPixelMode;
			float4 _MainTex_ST;
			float2 _MainTexPan;
			float _MainTexUV;
			float4 _MainTex_TexelSize;
			float _MainTexStochastic;
			float _MainIgnoreTexAlpha;
			#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
			Texture2D _BumpMap;
			#endif
			float4 _BumpMap_ST;
			float2 _BumpMapPan;
			float _BumpMapUV;
			float _BumpScale;
			float _BumpMapStochastic;
			#if defined(PROP_ALPHAMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _AlphaMask;
			#endif
			float4 _AlphaMask_ST;
			float2 _AlphaMaskPan;
			float _AlphaMaskUV;
			float _AlphaMaskInvert;
			float _MainAlphaMaskMode;
			float _AlphaMaskBlendStrength;
			float _AlphaMaskValue;
			float _Cutoff;
			float _AlphaForceOpaque;
			float _AlphaMod;
			float _AlphaPremultiply;
			float _AlphaBoostFA;
			float _AlphaGlobalMask;
			float _AlphaGlobalMaskBlendType;
			float _IgnoreFog;
			float _RenderingReduceClipDistance;
			int _FlipBackfaceNormals;
			float _AddBlendOp;
			float _Cull;
			int _GlobalMaskVertexColorLinearSpace;
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
			#ifdef AUTO_EXPOSURE
			#if defined(PROP_VERTEXBASICSMASK) || !defined(OPTIMIZER_ENABLED)
			Texture2D _VertexBasicsMask;
			float4 _VertexBasicsMask_ST;
			float4 _VertexBasicsMaskUVPan;
			float VertexBasicsMaskUV;
			float _VertexBasicsMaskChannel;
			#endif
			float4 _VertexManipulationLocalTranslation;
			float4 _VertexManipulationWorldTranslation;
			float4 _VertexManipulationLocalRotation;
			float3 _VertexManipulationLocalRotationSpeed;
			float4 _VertexManipulationLocalScale;
			float _VertexRoundingEnabled;
			int _VertexRoundingSpace;
			float _VertexRoundingDivision;
			float _VertexRoundingMaskChannel;
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
			struct tessellatedAppData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 color : COLOR;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				float2 uv2 : TEXCOORD2;
				float2 uv3 : TEXCOORD3;
				uint vertexId : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			struct VertexOut
			{
				float4 pos : SV_POSITION;
				float4 uv[2] : TEXCOORD0;
				float3 normal : TEXCOORD2;
				float4 tangent : TEXCOORD3;
				float4 worldPos : TEXCOORD4;
				float4 localPos : TEXCOORD5;
				float4 vertexColor : TEXCOORD6;
				float4 lightmapUV : TEXCOORD7;
				float worldDir : TEXCOORD8;
				float2 fogData: TEXCOORD10;
				UNITY_SHADOW_COORDS(12)
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
				float2 uv[10];
				float2 parallaxUV;
				float2 dx;
				float2 dy;
				uint isRightHand;
			};
			struct PoiCam
			{
				float3 viewDir;
				float3 forwardDir;
				float3 worldPos;
				float distanceToVert;
				float4 clipPos;
				float4 screenSpacePosition;
				float3 reflectionDir;
				float3 vertexReflectionDir;
				float3 tangentViewDir;
				float4 posScreenSpace;
				float2 posScreenPixels;
				float2 screenUV;
				float vDotN;
				float4 worldDirection;
			};
			struct PoiMods
			{
				float4 Mask;
				float audioLink[5];
				float audioLinkAvailable;
				float audioLinkVersion;
				float4 audioLinkTexture;
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
				float nDotVCentered;
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
				float3 LTCGISpecular;
				float3 LTCGIDiffuse;
				float directLuminance;
				float indirectLuminance;
				float finalLuminance;
				#if defined(VERTEXLIGHT_ON)
				float4 vDotNL;
				float4 vertexVDotNL;
				float3 vColor[4];
				float4 vCorrectedDotNL;
				float4 vAttenuation;
				float4 vSaturatedDotNL;
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
				float smoothness;
				float smoothness2;
				float metallic;
				float specularMask;
				float reflectionMask;
				float3 baseColor;
				float3 finalColor;
				float alpha;
				float3 emission;
				float toggleVertexLights;
			};
			float4 poiTransformClipSpacetoScreenSpaceFrag(float4 clipPos)
			{
				float4 positionSS = float4(clipPos.xyz * clipPos.w, clipPos.w);
				positionSS.xy = positionSS.xy / _ScreenParams.xy;
				return positionSS;
			}
			static float4 PoiSHAr = 0;
			static float4 PoiSHAg = 0;
			static float4 PoiSHAb = 0;
			static float4 PoiSHBr = 0;
			static float4 PoiSHBg = 0;
			static float4 PoiSHBb = 0;
			static float4 PoiSHC  = 0;
			half3 PoiSHEval_L0L1(half4 normal)
			{
				half3 x;
				x.r = dot(PoiSHAr, normal);
				x.g = dot(PoiSHAg, normal);
				x.b = dot(PoiSHAb, normal);
				return x;
			}
			half3 PoiSHEval_L2(half4 normal)
			{
				half3 x1, x2;
				half4 vB = normal.xyzz * normal.yzzx;
				x1.r = dot(PoiSHBr, vB);
				x1.g = dot(PoiSHBg, vB);
				x1.b = dot(PoiSHBb, vB);
				half  vC = normal.x*normal.x - normal.y*normal.y;
				x2    = PoiSHC.rgb * vC;
				return x1 + x2;
			}
			half3 PoiShadeSH9 (half4 normal)
			{
				half3 res = PoiSHEval_L0L1(normal);
				res += PoiSHEval_L2(normal);
				#ifdef UNITY_COLORSPACE_GAMMA
				res = LinearToGammaSpace(res);
				#endif
				return res;
			}
			inline half4 Pow5(half4 x)
			{
				return x * x * x * x * x;
			}
			inline half3 FresnelLerp(half3 F0, half3 F90, half cosA)
			{
				half t = Pow5(1 - cosA);   // ala Schlick interpoliation
				return lerp(F0, F90, t);
			}
			inline half3 FresnelTerm(half3 F0, half cosA)
			{
				half t = Pow5(1 - cosA);   // ala Schlick interpoliation
				return F0 + (1 - F0) * t;
			}
			half perceptualRoughnessToMipmapLevel(half perceptualRoughness)
			{
				return perceptualRoughness * UNITY_SPECCUBE_LOD_STEPS;
			}
			half3 Unity_GlossyEnvironment(UNITY_ARGS_TEXCUBE(tex), half4 hdr, Unity_GlossyEnvironmentData glossIn)
			{
				half perceptualRoughness = glossIn.roughness /* perceptualRoughness */ ;
				#if 0
				float m = PerceptualRoughnessToRoughness(perceptualRoughness); // m is the real roughness parameter
				const float fEps = 1.192092896e-07F;        // smallest such that 1.0+FLT_EPSILON != 1.0  (+1e-4h is NOT good here. is visibly very wrong)
				float n = (2.0 / max(fEps, m * m)) - 2.0;        // remap to spec power. See eq. 21 in --> https://dl.dropboxusercontent.com/u/55891920/papers/mm_brdf.pdf
				n /= 4;                                     // remap from n_dot_h formulatino to n_dot_r. See section "Pre-convolved Cube Maps vs Path Tracers" --> https://s3.amazonaws.com/docs.knaldtech.com/knald/1.0.0/lys_power_drops.html
				perceptualRoughness = pow(2 / (n + 2), 0.25);      // remap back to square root of real roughness (0.25 include both the sqrt root of the conversion and sqrt for going from roughness to perceptualRoughness)
				#else
				perceptualRoughness = perceptualRoughness * (1.7 - 0.7 * perceptualRoughness);
				#endif
				half mip = perceptualRoughnessToMipmapLevel(perceptualRoughness);
				half3 R = glossIn.reflUVW;
				half4 rgbm = UNITY_SAMPLE_TEXCUBE_LOD(tex, R, mip);
				return DecodeHDR(rgbm, hdr);
			}
			half3 UnpackScaleNormalDXT5nm(half4 packednormal, half bumpScale)
			{
				half3 normal;
				normal.xy = (packednormal.wy * 2 - 1);
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				return normal;
			}
			half3 LerpWhiteTo(half3 b, half t)
			{
				half oneMinusT = 1 - t;
				return half3(oneMinusT, oneMinusT, oneMinusT) + b * t;
			}
			inline float GGXTerm(float NdotH, float roughness)
			{
				float a2 = roughness * roughness;
				float d = (NdotH * a2 - NdotH) * NdotH + 1.0f; // 2 mad
				return UNITY_INV_PI * a2 / (d * d + 1e-7f); // This function is not intended to be running on Mobile,
			}
			Unity_GlossyEnvironmentData UnityGlossyEnvironmentSetup(half Smoothness, half3 worldViewDir, half3 Normal, half3 fresnel0)
			{
				Unity_GlossyEnvironmentData g;
				g.roughness /* perceptualRoughness */ = 1 - Smoothness;
				g.reflUVW = reflect(-worldViewDir, Normal);
				return g;
			}
			half3 UnpackScaleNormalRGorAG(half4 packednormal, half bumpScale)
			{
				#if defined(UNITY_NO_DXT5nm)
				half3 normal = packednormal.xyz * 2 - 1;
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				return normal;
				#elif defined(UNITY_ASTC_NORMALMAP_ENCODING)
				half3 normal;
				normal.xy = (packednormal.wy * 2 - 1);
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				normal.xy *= bumpScale;
				return normal;
				#else
				packednormal.x *= packednormal.w;
				half3 normal;
				normal.xy = (packednormal.xy * 2 - 1);
				#if (SHADER_TARGET >= 30)
				normal.xy *= bumpScale;
				#endif
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				return normal;
				#endif
			}
			half3 UnpackScaleNormal(half4 packednormal, half bumpScale)
			{
				return UnpackScaleNormalRGorAG(packednormal, bumpScale);
			}
			half3 BlendNormals(half3 n1, half3 n2)
			{
				return normalize(half3(n1.xy + n2.xy, n1.z * n2.z));
			}
			inline float2 Pow4(float2 x)
			{
				return x * x * x * x;
			}
			inline float3 Unity_SafeNormalize(float3 inVec)
			{
				float dp3 = max(0.001f, dot(inVec, inVec));
				return inVec * rsqrt(dp3);
			}
			inline float3 BoxProjectedCubemapDirection(float3 worldRefl, float3 worldPos, float4 cubemapCenter, float4 boxMin, float4 boxMax)
			{
				
				if (cubemapCenter.w > 0.0)
				{
					float3 nrdir = normalize(worldRefl);
					#if 1
					float3 rbmax = (boxMax.xyz - worldPos) / nrdir;
					float3 rbmin = (boxMin.xyz - worldPos) / nrdir;
					float3 rbminmax = (nrdir > 0.0f) ? rbmax : rbmin;
					#else // Optimized version
					float3 rbmax = (boxMax.xyz - worldPos);
					float3 rbmin = (boxMin.xyz - worldPos);
					float3 select = step(float3(0, 0, 0), nrdir);
					float3 rbminmax = lerp(rbmax, rbmin, select);
					rbminmax /= nrdir;
					#endif
					float fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);
					worldPos -= cubemapCenter.xyz;
					worldRefl = worldPos + nrdir * fa;
				}
				return worldRefl;
			}
			inline half3 UnityGI_IndirectSpecular(UnityGIInput data, half occlusion, Unity_GlossyEnvironmentData glossIn)
			{
				half3 specular;
				#ifdef UNITY_SPECCUBE_BOX_PROJECTION
				half3 originalReflUVW = glossIn.reflUVW;
				glossIn.reflUVW = BoxProjectedCubemapDirection(originalReflUVW, data.worldPos, data.probePosition[0], data.boxMin[0], data.boxMax[0]);
				#endif
				#ifdef _GLOSSYREFLECTIONS_OFF
				specular = unity_IndirectSpecColor.rgb;
				#else
				half3 env0 = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE(unity_SpecCube0), data.probeHDR[0], glossIn);
				#ifdef UNITY_SPECCUBE_BLENDING
				const float kBlendFactor = 0.99999;
				float blendLerp = data.boxMin[0].w;
				
				if (blendLerp < kBlendFactor)
				{
					#ifdef UNITY_SPECCUBE_BOX_PROJECTION
					glossIn.reflUVW = BoxProjectedCubemapDirection(originalReflUVW, data.worldPos, data.probePosition[1], data.boxMin[1], data.boxMax[1]);
					#endif
					half3 env1 = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE_SAMPLER(unity_SpecCube1, unity_SpecCube0), data.probeHDR[1], glossIn);
					specular = lerp(env1, env0, blendLerp);
				}
				else
				{
					specular = env0;
				}
				#else
				specular = env0;
				#endif
				#endif
				return specular * occlusion;
			}
			inline half3 UnityGI_IndirectSpecular(UnityGIInput data, half occlusion, half3 normalWorld, Unity_GlossyEnvironmentData glossIn)
			{
				return UnityGI_IndirectSpecular(data, occlusion, glossIn);
			}
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
					return o.uv[0].xy;
					case 1:
					return o.uv[0].zw;
					case 2:
					return o.uv[1].xy;
					case 3:
					return o.uv[1].zw;
					default:
					return o.uv[0].xy;
				}
			}
			float2 vertexUV(in appdata v, int index)
			{
				switch(index)
				{
					case 0:
					return v.uv0.xy;
					case 1:
					return v.uv1.xy;
					case 2:
					return v.uv2.xy;
					case 3:
					return v.uv3.xy;
					default:
					return v.uv0.xy;
				}
			}
			float calculateluminance(float3 color)
			{
				return color.r * 0.299 + color.g * 0.587 + color.b * 0.114;
			}
			float dotToDegrees(float dot)
			{
				dot = clamp(dot, -1.0, 1.0);
				return degrees(acos(dot));
			}
			float dotToDegrees(float3 a, float3 b)
			{
				return dotToDegrees(dot(normalize(a), normalize(b)));
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
				float3 L0 = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w) + float3(PoiSHBr.z, PoiSHBg.z, PoiSHBb.z) / 3.0;
				indirect.r = shEvaluateDiffuseL1Geomerics_local(L0.r, PoiSHAr.xyz, normal.xyz);
				indirect.g = shEvaluateDiffuseL1Geomerics_local(L0.g, PoiSHAg.xyz, normal.xyz);
				indirect.b = shEvaluateDiffuseL1Geomerics_local(L0.b, PoiSHAb.xyz, normal.xyz);
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
				x.r = length(PoiSHAr);
				x.g = length(PoiSHAg);
				x.b = length(PoiSHAb);
				x1.r = length(PoiSHBr);
				x1.g = length(PoiSHBg);
				x1.b = length(PoiSHBb);
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
			float blendOverlay(float base, float blend)
			{
				return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
			}
			float3 blendOverlay(float3 base, float3 blend)
			{
				return float3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
			}
			float blendLighten(float base, float blend)
			{
				return max(blend, base);
			}
			float3 blendLighten(float3 base, float3 blend)
			{
				return float3(blendLighten(base.r, blend.r), blendLighten(base.g, blend.g), blendLighten(base.b, blend.b));
			}
			float blendLinearDodge(float base, float blend)
			{
				return min(base + blend, 1.0);
			}
			float3 blendLinearDodge(float3 base, float3 blend)
			{
				return base + blend;
			}
			float blendMultiply(float base, float blend)
			{
				return base * blend;
			}
			float3 blendMultiply(float3 base, float3 blend)
			{
				return base * blend;
			}
			float blendNormal(float base, float blend)
			{
				return blend;
			}
			float3 blendNormal(float3 base, float3 blend)
			{
				return blend;
			}
			float blendScreen(float base, float blend)
			{
				return 1.0 - ((1.0 - base) * (1.0 - blend));
			}
			float3 blendScreen(float3 base, float3 blend)
			{
				return float3(blendScreen(base.r, blend.r), blendScreen(base.g, blend.g), blendScreen(base.b, blend.b));
			}
			float blendSubtract(float base, float blend)
			{
				return max(base - blend, 0.0);
			}
			float3 blendSubtract(float3 base, float3 blend)
			{
				return max(base - blend, 0.0);
			}
			float blendMixed(float base, float blend)
			{
				return base + base * blend;
			}
			float3 blendMixed(float3 base, float3 blend)
			{
				return base + base * blend;
			}
			float3 customBlend(float3 base, float3 blend, float blendType, float alpha = 1)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 1: output = lerp(base, blendDarken(base, blend), alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 5: output = lerp(base, blendLighten(base, blend), alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 7: output = blendSubtract(base, blend * alpha); break;
					case 8: output = lerp(base, blendLinearDodge(base, blend), alpha); break;
					case 9: output = lerp(base, blendOverlay(base, blend), alpha); break;
					case 20: output = lerp(base, blendMixed(base, blend), alpha); break;
					default: output = 0; break;
				}
				return output;
			}
			float3 customBlend(float base, float blend, float blendType, float alpha = 1)
			{
				float3 output = base;
				switch(blendType)
				{
					case 0: output = lerp(base, blend, alpha); break;
					case 2: output = base * lerp(1, blend, alpha); break;
					case 5: output = lerp(base, blendLighten(base, blend), alpha); break;
					case 6: output = lerp(base, blendScreen(base, blend), alpha); break;
					case 7: output = blendSubtract(base, blend * alpha); break;
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
			float globalMaskBlend(float baseMask, float globalMaskIndex, float blendType, PoiMods poiMods)
			{
				if (globalMaskIndex == 0)
				{
					return baseMask;
				}
				else
				{
					return maskBlend(baseMask, poiMods.globalMask[globalMaskIndex - 1], blendType);
				}
			}
			inline float poiRand(float2 co)
			{
				float3 p3 = frac(float3(co.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.x + p3.y) * p3.z);
			}
			inline float4 poiRand4(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				float2 a = frac((p3.xx + p3.yz) * p3.zy);
				float2 s2 = seed + 37.0;
				float3 q3 = frac(float3(s2.xyx) * 0.1031);
				q3 += dot(q3, q3.yzx + 33.33);
				float2 b = frac((q3.xx + q3.yz) * q3.zy);
				return float4(a, b);
			}
			inline float2 poiRand2(float seed)
			{
				float2 x = float2(seed, seed * 1.3);
				float3 p3 = frac(float3(x.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			inline float2 poiRand2(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			inline float poiRand3(float seed)
			{
				float p = frac(seed * 0.1031);
				p *= p + 33.33;
				p *= p + p;
				return frac(p);
			}
			inline float3 poiRand3(float2 seed)
			{
				float3 p3 = frac(float3(seed.xyx) * 0.1031);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			inline float3 poiRand3(float3 seed)
			{
				float3 p3 = frac(seed * 0.1031);
				p3 += dot(p3, p3.zyx + 31.32);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			inline float3 poiRand3Range(float2 Seed, float Range)
			{
				float3 r = poiRand3(Seed);
				return (r * 2.0 - 1.0) * Range;
			}
			float3 randomFloat3WiggleRange(float2 Seed, float Range, float wiggleSpeed, float timeOffset)
			{
				float3 rando = (float3(
				frac(sin(dot(Seed.xy, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(Seed.yx, float2(12.9898, 78.233))) * 43758.5453),
				frac(sin(dot(float2(Seed.x * Seed.y, Seed.y + Seed.x), float2(12.9898, 78.233))) * 43758.5453)
				) * 2 - 1);
				float speed = 1 + wiggleSpeed;
				return float3(sin(((_Time.x + timeOffset) + rando.x * PI) * speed), sin(((_Time.x + timeOffset) + rando.y * PI) * speed), sin(((_Time.x + timeOffset) + rando.z * PI) * speed)) * Range;
			}
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
				float H = abs((Q.w - Q.y) / (6 * C + EPSILON) + Q.z);
				return float3(H, C, Q.x);
			}
			float3 RGBtoHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}
			float3 HSVtoRGB(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
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
			float4x4 brightnessMatrix(float brightness)
			{
				return float4x4(
				1, 0, 0, 0,
				0, 1, 0, 0,
				0, 0, 1, 0,
				brightness, brightness, brightness, 1
				);
			}
			float4x4 contrastMatrix(float contrast)
			{
				float t = (1.0 - contrast) / 2.0;
				return float4x4(
				contrast, 0, 0, 0,
				0, contrast, 0, 0,
				0, 0, contrast, 0,
				t, t, t, 1
				);
			}
			float4x4 saturationMatrix(float saturation)
			{
				float3 luminance = float3(0.3086, 0.6094, 0.0820);
				float oneMinusSat = 1.0 - saturation;
				float3 red = luminance.x * oneMinusSat;
				red += float3(saturation, 0, 0);
				float3 green = luminance.y * oneMinusSat;
				green += float3(0, saturation, 0);
				float3 blue = luminance.z * oneMinusSat;
				blue += float3(0, 0, saturation);
				return float4x4(
				red, 0,
				green, 0,
				blue, 0,
				0, 0, 0, 1
				);
			}
			float4 PoiColorBCS(float4 color, float brightness, float contrast, float saturation)
			{
				return mul(color, mul(brightnessMatrix(brightness), mul(contrastMatrix(contrast), saturationMatrix(saturation))));
			}
			float3 PoiColorBCS(float3 color, float brightness, float contrast, float saturation)
			{
				return mul(float4(color, 1), mul(brightnessMatrix(brightness), mul(contrastMatrix(contrast), saturationMatrix(saturation)))).rgb;
			}
			float3 linear_srgb_to_oklab(float3 c)
			{
				float l = 0.4122214708 * c.x + 0.5363325363 * c.y + 0.0514459929 * c.z;
				float m = 0.2119034982 * c.x + 0.6806995451 * c.y + 0.1073969566 * c.z;
				float s = 0.0883024619 * c.x + 0.2817188376 * c.y + 0.6299787005 * c.z;
				float l_ = pow(l, 1.0 / 3.0);
				float m_ = pow(m, 1.0 / 3.0);
				float s_ = pow(s, 1.0 / 3.0);
				return float3(
				0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
				1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
				0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
				);
			}
			float3 oklab_to_linear_srgb(float3 c)
			{
				float l_ = c.x + 0.3963377774 * c.y + 0.2158037573 * c.z;
				float m_ = c.x - 0.1055613458 * c.y - 0.0638541728 * c.z;
				float s_ = c.x - 0.0894841775 * c.y - 1.2914855480 * c.z;
				float l = l_ * l_ * l_;
				float m = m_ * m_ * m_;
				float s = s_ * s_ * s_;
				return float3(
				+ 4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
				- 1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
				- 0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
				);
			}
			float3 hueShiftOKLab(float3 color, float shift, float selectOrShift)
			{
				float3 oklab = linear_srgb_to_oklab(color);
				float chroma = length(oklab.yz);
				oklab.y = selectOrShift > 0.5 ? oklab.y : chroma;
				oklab.z = selectOrShift > 0.5 ? oklab.z : 0;
				float s, c;
				sincos(shift * TWO_PI, s, c);
				oklab.yz = float2(c * oklab.y - s * oklab.z, s * oklab.y + c * oklab.z);
				return oklab_to_linear_srgb(oklab);
			}
			float3 hueShiftHSV(float3 color, float hueOffset, float selectOrShift)
			{
				float3 hsvCol = RGBtoHSV(color);
				hsvCol.x = hsvCol.x * selectOrShift + hueOffset;
				return HSVtoRGB(hsvCol);
			}
			float3 hueShift(float3 color, float shift, float ColorSpace, float selectOrShift)
			{
				switch(ColorSpace)
				{
					case 0.0:
					return hueShiftOKLab(color, shift, selectOrShift);
					case 1.0:
					return hueShiftHSV(color, shift, selectOrShift);
					default:
					return float3(1.0, 0.0, 0.0);
				}
			}
			float4 hueShift(float4 color, float shift, float ColorSpace, float selectOrShift)
			{
				return float4(hueShift(color.rgb, shift, ColorSpace, selectOrShift), color.a);
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
			float3 _VRChatMirrorCameraPos;
			float3 getCameraPosition()
			{
				#ifdef USING_STEREO_MATRICES
				return unity_StereoWorldSpaceCameraPos[0] * .5 + unity_StereoWorldSpaceCameraPos[1] * .5;
				#endif
				return _VRChatMirrorMode == 1 ? _VRChatMirrorCameraPos : _WorldSpaceCameraPos;
			}
			#ifdef POI_AUDIOLINK
			inline int poiALBandPass(int bandIdx)
			{
				bandIdx = clamp(bandIdx, 0, 3);
				return bandIdx == 0 ? ALPASS_AUDIOBASS : bandIdx == 1 ? ALPASS_AUDIOLOWMIDS : bandIdx == 2 ? ALPASS_AUDIOHIGHMIDS : ALPASS_AUDIOTREBLE;
			}
			#endif
			float2 calcPixelScreenUVs(half4 grabPos)
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
			float4 QuaternionFromMatrix(
			float m00, float m01, float m02,
			float m10, float m11, float m12,
			float m20, float m21, float m22)
			{
				float4 q;
				float trace = m00 + m11 + m22;
				if (trace > 0)
				{
					float s = sqrt(trace + 1) * 2;
					q.w = 0.25 * s;
					q.x = (m21 - m12) / s;
					q.y = (m02 - m20) / s;
					q.z = (m10 - m01) / s;
				}
				else if (m00 > m11 && m00 > m22)
				{
					float s = sqrt(1 + m00 - m11 - m22) * 2;
					q.w = (m21 - m12) / s;
					q.x = 0.25 * s;
					q.y = (m01 + m10) / s;
					q.z = (m02 + m20) / s;
				}
				else if (m11 > m22)
				{
					float s = sqrt(1 + m11 - m00 - m22) * 2;
					q.w = (m02 - m20) / s;
					q.x = (m01 + m10) / s;
					q.y = 0.25 * s;
					q.z = (m12 + m21) / s;
				}
				else
				{
					float s = sqrt(1 + m22 - m00 - m11) * 2;
					q.w = (m10 - m01) / s;
					q.x = (m02 + m20) / s;
					q.y = (m12 + m21) / s;
					q.z = 0.25 * s;
				}
				return q;
			}
			float4 MulQuat(float4 a, float4 b)
			{
				return float4(
				a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,
				a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,
				a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w,
				a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z
				);
			}
			float4 QuaternionFromBasis(float3 sx, float3 sy, float3 sz)
			{
				return QuaternionFromMatrix(
				sx.x, sy.x, sz.x,
				sx.y, sy.y, sz.y,
				sx.z, sy.z, sz.z
				);
			}
			float4 BuildQuatFromForwardUp(float3 forward, float3 up)
			{
				float3 f = normalize(forward);
				float3 u = normalize(up);
				float3 x = normalize(cross(u, f));
				float3 y = cross(f, x);
				return QuaternionFromBasis(x, y, f);
			}
			float3 QuaternionToEuler(float4 q)
			{
				float3 euler;
				float sinr_cosp = 2 * (q.w * q.z + q.x * q.y);
				float cosr_cosp = 1 - 2 * (q.z * q.z + q.x * q.x);
				euler.z = atan2(sinr_cosp, cosr_cosp) * 57.2958;
				float sinp = 2 * (q.w * q.x - q.y * q.z);
				if (abs(sinp) >= 1)
				euler.x = (sinp >= 0 ? 1 : - 1) * 90;
				else
				euler.x = asin(sinp) * 57.2958;
				float siny_cosp = 2 * (q.w * q.y + q.z * q.x);
				float cosy_cosp = 1 - 2 * (q.x * q.x + q.y * q.y);
				euler.y = atan2(siny_cosp, cosy_cosp) * 57.2958;
				return euler;
			}
			float4 EulerToQuaternion(float3 euler)
			{
				float3 eulerRad = euler * 0.0174533;
				float cx = cos(eulerRad.x * 0.5);
				float sx = sin(eulerRad.x * 0.5);
				float cy = cos(eulerRad.y * 0.5);
				float sy = sin(eulerRad.y * 0.5);
				float cz = cos(eulerRad.z * 0.5);
				float sz = sin(eulerRad.z * 0.5);
				float4 q;
				q.w = cx * cy * cz + sx * sy * sz;
				q.x = sx * cy * cz - cx * sy * sz;
				q.y = cx * sy * cz + sx * cy * sz;
				q.z = cx * cy * sz - sx * sy * cz;
				return q;
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
			float3 RotateByQuaternion(float4 q, float3 v)
			{
				float3 u = q.xyz;
				float s = q.w;
				return 2.0 * dot(u, v) * u
				+ (s * s - dot(u, u)) * v
				+ 2.0 * s * cross(u, v);
			}
			float4 SlerpQuaternion(float4 qa, float4 qb, float t)
			{
				float cosHalfTheta = dot(qa, qb);
				if (cosHalfTheta < 0.0)
				{
					qb = -qb;
					cosHalfTheta = -cosHalfTheta;
				}
				if (cosHalfTheta > 0.9995)
				{
					float4 qr = normalize(qa * (1 - t) + qb * t);
					return qr;
				}
				float halfTheta = acos(cosHalfTheta);
				float sinHalfTheta = sqrt(1.0 - cosHalfTheta * cosHalfTheta);
				float a = sin((1 - t) * halfTheta) / sinHalfTheta;
				float b = sin(t * halfTheta) / sinHalfTheta;
				return qa * a + qb * b;
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
			float3 RotateAroundAxis(float3 original, float3 axis, float radian)
			{
				float s = sin(radian);
				float c = cos(radian);
				float one_minus_c = 1.0 - c;
				axis = normalize(axis);
				float3x3 rot_mat = {
					one_minus_c * axis.x * axis.x + c, one_minus_c * axis.x * axis.y - axis.z * s, one_minus_c * axis.z * axis.x + axis.y * s,
					one_minus_c * axis.x * axis.y + axis.z * s, one_minus_c * axis.y * axis.y + c, one_minus_c * axis.y * axis.z - axis.x * s,
					one_minus_c * axis.z * axis.x - axis.y * s, one_minus_c * axis.y * axis.z + axis.x * s, one_minus_c * axis.z * axis.z + c
				};
				return mul(rot_mat, original);
			}
			float3 poiThemeColor(in PoiMods poiMods, in float3 srcColor, in float themeIndex)
			{
				float3 outputColor = srcColor;
				if (themeIndex != 0)
				{
					themeIndex = max(themeIndex - 1, 0);
					if (themeIndex <= 3)
					{
						outputColor = poiMods.globalColorTheme[themeIndex];
					}
					else
					{
						#ifdef POI_AUDIOLINK
						if (poiMods.audioLinkAvailable)
						{
							outputColor = poiMods.globalColorTheme[themeIndex];
						}
						#endif
					}
				}
				return outputColor;
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
			float3 lilBlendColor(float3 dstCol, float3 srcCol, float3 srcA, int blendMode)
			{
				float3 ad = dstCol + srcCol;
				float3 mu = dstCol * srcCol;
				float3 outCol = float3(0, 0, 0);
				if (blendMode == 0) outCol = srcCol; // Normal
				if (blendMode == 1) outCol = ad; // Add
				if (blendMode == 2) outCol = max(ad - mu, dstCol); // Screen
				if (blendMode == 3) outCol = mu; // Multiply
				return lerp(dstCol, outCol, srcA);
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
				return (value - borderMin) / max(saturate(borderMax - borderMin + fwidth(value)), .0001);
			}
			float poiEdgeLinearNoSaturate(float value, float border, float blur, float borderRange)
			{
				float borderMin = saturate(border - blur * 0.5 - borderRange);
				float borderMax = saturate(border + blur * 0.5);
				return (value - borderMin) / max(saturate(borderMax - borderMin + fwidth(value)), .0001);
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
			float3 AdjustLitLuminance(float3 rgb, float targetLuminance)
			{
				float currentLuminance;
				#if defined(UNITY_COLORSPACE_GAMMA)
				currentLuminance = dot(rgb, float3(0.22, 0.707, 0.071));
				#else
				currentLuminance = dot(rgb, float3(0.0396819152, 0.458021790, 0.00609653955));
				#endif
				float luminanceRatio = targetLuminance / currentLuminance;
				return rgb * luminanceRatio;
			}
			float3 ClampLuminance(float3 rgb, float minLuminance, float maxLuminance)
			{
				float currentLuminance = dot(rgb, float3(0.299, 0.587, 0.114));
				float minRatio = (currentLuminance != 0) ? minLuminance / currentLuminance : 1.0;
				float maxRatio = (currentLuminance != 0) ? maxLuminance / currentLuminance : 1.0;
				float luminanceRatio = clamp(min(maxRatio, max(minRatio, 1.0)), 0.0, 1.0);
				return lerp(rgb, rgb * luminanceRatio, luminanceRatio < 1.0);
			}
			float3 MaxLuminance(float3 rgb, float maxLuminance)
			{
				float currentLuminance = dot(rgb, float3(0.299, 0.587, 0.114));
				float luminanceRatio = (currentLuminance != 0) ? maxLuminance / max(currentLuminance, 0.00001) : 1.0;
				return lerp(rgb, rgb * luminanceRatio, currentLuminance > maxLuminance);
			}
			float OpenLitGray(float3 rgb)
			{
				return dot(rgb, float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0));
			}
			void OpenLitShadeSH9ToonDouble(float3 lightDirection, out float3 shMax, out float3 shMin)
			{
				#if !defined(LIGHTMAP_ON)
				float3 N = lightDirection * 0.666666;
				float4 vB = N.xyzz * N.yzzx;
				float3 res = float3(PoiSHAr.w, PoiSHAg.w, PoiSHAb.w);
				res.r += dot(PoiSHBr, vB);
				res.g += dot(PoiSHBg, vB);
				res.b += dot(PoiSHBb, vB);
				res += PoiSHC.rgb * (N.x * N.x - N.y * N.y);
				float3 l1;
				l1.r = dot(PoiSHAr.rgb, N);
				l1.g = dot(PoiSHAg.rgb, N);
				l1.b = dot(PoiSHAb.rgb, N);
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
				#if !defined(LIGHTMAP_ON)
				float3 sh9Dir = PoiSHAr.xyz * 0.333333 + PoiSHAg.xyz * 0.333333 + PoiSHAb.xyz * 0.333333;
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
				float3 sh9Dir = PoiSHAr.xyz * 0.333333 + PoiSHAg.xyz * 0.333333 + PoiSHAb.xyz * 0.333333;
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
			inline float CorrectedLinearEyeDepth(float z, float correctionFactor)
			{
				return 1.f / (z / UNITY_MATRIX_P._34 + correctionFactor);
			}
			float evalRamp4(float time, float4 ramp)
			{
				return lerp(ramp.x, ramp.y, smoothstep(ramp.z, ramp.w, time));
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
				const float4 C = float4(0.211324865405187, // (3.0 - sqrt(3.0)) / 6.0
				0.366025403784439, // 0.5 * (sqrt(3.0) - 1.0)
				- 0.577350269189626, // - 1.0 + 2.0 * C.x
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
			float poiInvertToggle(in float value, in float toggle)
			{
				return (toggle == 0 ? value : 1 - value);
			}
			float3 PoiBlendNormal(float3 dstNormal, float3 srcNormal)
			{
				return float3(dstNormal.xy + srcNormal.xy, dstNormal.z * srcNormal.z);
			}
			float3 lilTransformDirOStoWS(float3 directionOS, bool doNormalize)
			{
				if (doNormalize) return normalize(mul((float3x3)unity_ObjectToWorld, directionOS));
				else            return mul((float3x3)unity_ObjectToWorld, directionOS);
			}
			float2 poiGetWidthAndHeight(Texture2D tex)
			{
				uint width, height;
				tex.GetDimensions(width, height);
				return float2(width, height);
			}
			float2 poiGetWidthAndHeight(Texture2DArray tex)
			{
				uint width, height, element;
				tex.GetDimensions(width, height, element);
				return float2(width, height);
			}
			bool SceneHasReflections()
			{
				float width, height;
				unity_SpecCube0.GetDimensions(width, height);
				return !(width * height < 2);
			}
			void applyUnityFog(inout float3 col, float2 fogData)
			{
				if (0.0 == 0)
				{
					float fogFactor = 1.0;
					float depth = UNITY_Z_0_FAR_FROM_CLIPSPACE(fogData.x);
					if (unity_FogParams.z != unity_FogParams.w)
					{
						fogFactor = depth * unity_FogParams.z + unity_FogParams.w;
					}
					else if (fogData.y)
					{
						float exponent_val = unity_FogParams.x * depth;
						fogFactor = exp2(-exponent_val * exponent_val);
					}
					else if (unity_FogParams.y != 0.0f)
					{
						float exponent = unity_FogParams.y * depth;
						fogFactor = exp2(-exponent);
					}
					fixed3 appliedFogColor = unity_FogColor.rgb;
					#if defined(UNITY_PASS_FORWARDADD)
					appliedFogColor = fixed3(0, 0, 0);
					#endif
					col.rgb = lerp(appliedFogColor, col.rgb, saturate(fogFactor));
				}
			}
			void applyReducedRenderClipDistance(inout VertexOut o)
			{
				if (o.pos.w < _ProjectionParams.y * 1.01 && o.pos.w > 0)
				{
					#if defined(UNITY_REVERSED_Z) // DirectX
					o.pos.z = o.pos.z * 0.0001 + o.pos.w * 0.999;
					#else // OpenGL
					o.pos.z = o.pos.z * 0.0001 - o.pos.w * 0.999;
					#endif
				}
			}
			VertexOut vert(appdata v)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				VertexOut o;
				PoiInitStruct(VertexOut, o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				#ifdef POI_TESSELLATED
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(v);
				#endif
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				#ifdef POI_AUDIOLINK
				float vertexAudioLink[5];
				vertexAudioLink[0] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 0))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 0))[0];
				vertexAudioLink[1] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 1))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 1))[0];
				vertexAudioLink[2] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 2))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 2))[0];
				vertexAudioLink[3] = 0.0 == 0 ? AudioLinkData(ALPASS_AUDIOLINK + float2(0, 3))[0] : AudioLinkData(ALPASS_FILTEREDAUDIOLINK + float2((1 - 0.0) * 15.95, 3))[0];
				vertexAudioLink[4] = AudioLinkData(ALPASS_GENERALVU + float2(8, 0))[0];
				#endif
				#ifdef AUTO_EXPOSURE
				float3 ALLocalTranslation = 0;
				float3 ALrotation = 0;
				float3 CTALRotation = 0;
				float3 ALScale = 0;
				float3 ALWorldTranslation = 0;
				float ALHeight = 0;
				float ALRoundingAmount = 0;
				float4 ALSpectrumLocalOffset = 0;
				#if defined(PROP_VERTEXBASICSMASK) || !defined(OPTIMIZER_ENABLED)
				float4 vertexMaskTex = _VertexBasicsMask.SampleLevel(sampler_linear_repeat, poiUV(vertexUV(v, 0.0), float4(1,1,0,0)) + float4(0,0,0,0).xy * _Time.x, 0);
				#else
				float4 vertexMaskTex = 1;
				#endif
				float vertexEffectsMask[8] = {
					vertexMaskTex.r,
					vertexMaskTex.g,
					vertexMaskTex.b,
					vertexMaskTex.a,
					v.color.r,
					v.color.g,
					v.color.b,
					v.color.a
				};
				float basicsMask = vertexEffectsMask[0.0];
				float4 rotation = float4(
				lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask) +
				float3(180, 0, 0) +
				lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask) * _Time.x +
				ALrotation +
				CTALRotation,
				float4(0,0,0,1).w
				);
				float4 localTranslation = lerp(float4(0, 0, 0, 0), float4(0,0,0,1), basicsMask) + float4(ALLocalTranslation, 0) + ALSpectrumLocalOffset;
				float4 manualScale = lerp(float4(1, 1, 1, 1), float4(1,1,1,1), basicsMask);
				float4 localScale = manualScale + float4(ALScale, 0);
				v.normal = rotate_with_quaternion(v.normal, rotation.xyz);
				v.tangent.xyz = rotate_with_quaternion(v.tangent.xyz, rotation.xyz);
				v.vertex = transform(v.vertex, localTranslation, rotation, localScale);
				o.normal = UnityObjectToWorldNormal(v.normal);
				float3 heightOffset = 0;
				if ((0.0 + ALHeight) != 0)
				{
					#if defined(PROP_VERTEXMANIPULATIONHEIGHTMASK) || !defined(OPTIMIZER_ENABLED)
					heightOffset = (_VertexManipulationHeightMask.SampleLevel(sampler_linear_repeat, poiUV(vertexUV(v, 0.0), float4(1,1,0,0)) + float4(0,0,0,0).xy * _Time.x, 0)[0.0] - 0.0) * (0.0 + ALHeight) * o.normal;
					#else
					heightOffset = (0.0 + ALHeight) * o.normal;
					#endif
					heightOffset *= vertexEffectsMask[0.0];
				}
				float3 worldTranslation = lerp(float3(0, 0, 0), float4(0,0,0,1).xyz, basicsMask);
				v.vertex.xyz += mul(unity_WorldToObject, worldTranslation + ALWorldTranslation + heightOffset).xyz;
				
				if (1.0)
				{
					float roundingMask = vertexEffectsMask[0.0];
					if (roundingMask > 0)
					{
						float3 preRoundingVertex = v.vertex.xyz;
						float divisionAmount = max(0.0025 + ALRoundingAmount, 0.0000001);
						if (0 == 0)
						{
							float4 worldPos = mul(unity_ObjectToWorld, float4(preRoundingVertex, 1));
							float3 worldRoundPosition = (ceil(worldPos.xyz / divisionAmount) * divisionAmount) - divisionAmount * .5;
							v.vertex = mul(unity_WorldToObject, float4(worldRoundPosition, worldPos.w));
						}
						else if (0 == 1)
						{
							v.vertex.xyz = (ceil(preRoundingVertex / divisionAmount) * divisionAmount) - divisionAmount * .5;
						}
						v.vertex.xyz = lerp(preRoundingVertex, v.vertex.xyz, roundingMask);
					}
				}
				#endif
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.tangent.xyz = UnityObjectToWorldDir(v.tangent);
				o.tangent.w = v.tangent.w;
				o.vertexColor = v.color;
				o.uv[0] = float4(v.uv0.xy, v.uv1.xy);
				o.uv[1] = float4(v.uv2.xy, v.uv3.xy);
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
				o.fogData.x = o.pos.z; // This is used for fog calculations, so we need to ensure it's in clip space
				#ifdef FOG_EXP2
				o.fogData.y = 1;
				#else
				o.fogData.y = 0;
				#endif
				#ifndef FORWARD_META_PASS
				#if !defined(UNITY_PASS_SHADOWCASTER)
				UNITY_TRANSFER_SHADOW(o, o.uv[0].xy);
				#else
				v.vertex.xyz = o.localPos.xyz;
				TRANSFER_SHADOW_CASTER_NOPOS(o, o.pos);
				#endif
				#endif
				o.worldDir = dot(o.pos, CalculateFrustumCorrection());
				if (0.0)
				{
					applyReducedRenderClipDistance(o);
				}
				#ifdef POI_PASS_META
				o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
				#endif
				#ifdef POI_PASS_LILFUR
				#endif
				return o;
			}
			#if defined(_STOCHASTICMODE_DELIOT_HEITZ)
			#define POI2D_SAMPLER_STOCHASTIC(tex, texSampler, uv, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, uv) : POI2D_SAMPLER(tex, texSampler, uv))
			#define POI2D_SAMPLER_PAN_STOCHASTIC(tex, texSampler, uv, pan, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan)) : POI2D_SAMPLER_PAN(tex, texSampler, uv, pan))
			#define POI2D_SAMPLER_PANGRAD_STOCHASTIC(tex, texSampler, uv, pan, dx, dy, useStochastic) (useStochastic ? DeliotHeitzSampleTexture(tex, sampler##texSampler, POI_PAN_UV(uv, pan), dx, dy) : POI2D_SAMPLER_PANGRAD(tex, texSampler, uv, pan, dx, dy))
			#endif
			#if !defined(_STOCHASTICMODE_NONE)
			float2 StochasticHash2D2D(float2 s)
			{
				return frac(sin(glsl_mod(float2(dot(s, float2(127.1, 311.7)), dot(s, float2(269.5, 183.3))), 3.14159)) * 43758.5453);
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
				float3(vxID, bary.z),
				float3(vxID + float2(0, 1), bary.y),
				float3(vxID + float2(1, 0), bary.x)
				);
				float3x3 neg = float3x3(
				float3(vxID + float2(1, 1), -bary.z),
				float3(vxID + float2(1, 0), 1.0 - bary.y),
				float3(vxID + float2(0, 1), 1.0 - bary.x)
				);
				return (bary.z > 0) ? pos : neg;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv, float2 dx, float2 dy)
			{
				float3x3 UVBW = DeliotHeitzStochasticUVBW(uv);
				return mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[0].xy), dx, dy), UVBW[0].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[1].xy), dx, dy), UVBW[1].z) +
				mul(tex.SampleGrad(texSampler, uv + StochasticHash2D2D(UVBW[2].xy), dx, dy), UVBW[2].z) ;
			}
			float4 DeliotHeitzSampleTexture(Texture2D tex, SamplerState texSampler, float2 uv)
			{
				float2 dx = ddx(uv), dy = ddy(uv);
				return DeliotHeitzSampleTexture(tex, texSampler, uv, dx, dy);
			}
			#endif // defined(_STOCHASTICMODE_DELIOT_HEITZ)
			void applyAlphaOptions(inout PoiFragData poiFragData, in PoiMesh poiMesh, in PoiCam poiCam, in PoiMods poiMods)
			{
				poiFragData.alpha = saturate(poiFragData.alpha + 0.0);
				if (0.0 > 0)
				{
					poiFragData.alpha = maskBlend(poiFragData.alpha, poiMods.globalMask[0.0 - 1], 2.0);
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
				PoiSHAr = unity_SHAr;
				PoiSHAg = unity_SHAg;
				PoiSHAb = unity_SHAb;
				PoiSHBr = unity_SHBr;
				PoiSHBg = unity_SHBg;
				PoiSHBb = unity_SHBb;
				PoiSHC =  unity_SHC;
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
				PoiFragData poiFragData;
				poiFragData.smoothness = 1;
				poiFragData.smoothness2 = 1;
				poiFragData.metallic = 1;
				poiFragData.specularMask = 1;
				poiFragData.reflectionMask = 1;
				poiFragData.emission = 0;
				poiFragData.baseColor = float3(0, 0, 0);
				poiFragData.finalColor = float3(0, 0, 0);
				poiFragData.alpha = 1;
				poiFragData.toggleVertexLights = 0;
				#ifdef POI_UDIMDISCARD
				applyUDIMDiscard(i, facing);
				#endif
				poiMesh.objectPosition = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
				poiMesh.objNormal = mul(unity_WorldToObject, i.normal);
				poiMesh.normals[0] = i.normal;
				poiMesh.tangent[0] = i.tangent.xyz;
				poiMesh.binormal[0] = cross(i.normal, i.tangent.xyz) * (i.tangent.w * unity_WorldTransformParams.w);
				poiMesh.worldPos = i.worldPos.xyz;
				poiMesh.localPos = i.localPos.xyz;
				poiMesh.vertexColor = i.vertexColor;
				poiMesh.isFrontFace = facing;
				poiMesh.dx = ddx(poiMesh.uv[0]);
				poiMesh.dy = ddy(poiMesh.uv[0]);
				poiMesh.isRightHand = i.tangent.w > 0.0;
				#ifndef POI_PASS_OUTLINE
				if (!poiMesh.isFrontFace && 1)
				{
					poiMesh.normals[0] *= -1;
					poiMesh.tangent[0] *= -1;
					poiMesh.binormal[0] *= -1;
				}
				#endif
				poiCam.viewDir = !IsOrthographicCamera() ? normalize(_WorldSpaceCameraPos - i.worldPos.xyz) : normalize(UNITY_MATRIX_I_V._m02_m12_m22);
				float3 tanToWorld0 = float3(poiMesh.tangent[0].x, poiMesh.binormal[0].x, poiMesh.normals[0].x);
				float3 tanToWorld1 = float3(poiMesh.tangent[0].y, poiMesh.binormal[0].y, poiMesh.normals[0].y);
				float3 tanToWorld2 = float3(poiMesh.tangent[0].z, poiMesh.binormal[0].z, poiMesh.normals[0].z);
				float3 ase_tanViewDir = tanToWorld0 * poiCam.viewDir.x + tanToWorld1 * poiCam.viewDir.y + tanToWorld2 * poiCam.viewDir.z;
				poiCam.tangentViewDir = normalize(ase_tanViewDir);
				#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
				poiMesh.lightmapUV = i.lightmapUV;
				#endif
				poiMesh.parallaxUV = poiCam.tangentViewDir.xy / max(poiCam.tangentViewDir.z, 0.0001);
				poiMesh.uv[0] = i.uv[0].xy;
				poiMesh.uv[1] = i.uv[0].zw;
				poiMesh.uv[2] = i.uv[1].xy;
				poiMesh.uv[3] = i.uv[1].zw;
				poiMesh.uv[4] = poiMesh.uv[0];
				poiMesh.uv[5] = poiMesh.uv[0];
				poiMesh.uv[6] = poiMesh.uv[0];
				poiMesh.uv[7] = poiMesh.uv[0];
				poiMesh.uv[8] = poiMesh.uv[0];
				poiMesh.uv[4] = calculatePanosphereUV(poiMesh);
				poiMesh.uv[5] = calculateWorldUV(poiMesh);
				poiMesh.uv[6] = calculatePolarCoordinate(poiMesh);
				poiMesh.uv[8] = calculatelocalUV(poiMesh);
				float3 worldViewUp = normalize(float3(0, 1, 0) - poiCam.viewDir * dot(poiCam.viewDir, float3(0, 1, 0)));
				float3 worldViewRight = normalize(cross(poiCam.viewDir, worldViewUp));
				poiMesh.uv[9] = float2(dot(worldViewRight, poiMesh.normals[0]), dot(worldViewUp, poiMesh.normals[0])) * 0.5 + 0.5;
				poiMods.globalMask[0] = 1;
				poiMods.globalMask[1] = 1;
				poiMods.globalMask[2] = 1;
				poiMods.globalMask[3] = 1;
				poiMods.globalMask[4] = 1;
				poiMods.globalMask[5] = 1;
				poiMods.globalMask[6] = 1;
				poiMods.globalMask[7] = 1;
				poiMods.globalMask[8] = 1;
				poiMods.globalMask[9] = 1;
				poiMods.globalMask[10] = 1;
				poiMods.globalMask[11] = 1;
				poiMods.globalMask[12] = 1;
				poiMods.globalMask[13] = 1;
				poiMods.globalMask[14] = 1;
				poiMods.globalMask[15] = 1;
				ApplyGlobalMaskModifiers(poiMesh, poiMods, poiCam);
				float2 mainUV = poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0));
				if (0.0)
				{
					mainUV = sharpSample(float4(0.03125,0.03125,32,32), mainUV);
				}
				float4 mainTexture = POI2D_SAMPLER_PAN_STOCHASTIC(_MainTex, _MainTex, mainUV, float4(0,0,0,0), 0.0);
				mainTexture.a = max(mainTexture.a, 0.0);
				#if defined(PROP_BUMPMAP) || !defined(OPTIMIZER_ENABLED)
				poiMesh.tangentSpaceNormal = UnpackScaleNormal(POI2D_SAMPLER_PAN_STOCHASTIC(_BumpMap, _MainTex, poiUV(poiMesh.uv[0.0].xy, float4(1,1,0,0)), float4(0,0,0,0), 0.0), 1.0);
				#else
				poiMesh.tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				#endif
				float3 tangentSpaceNormal = UnpackNormal(float4(0.5, 0.5, 1, 1));
				poiMesh.normals[0] = normalize(
				tangentSpaceNormal.x * poiMesh.tangent[0] +
				tangentSpaceNormal.y * poiMesh.binormal[0] +
				tangentSpaceNormal.z * poiMesh.normals[0]
				);
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
				poiCam.clipPos = i.pos;
				poiCam.distanceToVert = distance(poiMesh.worldPos, poiCam.worldPos);
				poiCam.posScreenSpace = poiTransformClipSpacetoScreenSpaceFrag(poiCam.clipPos);
				#if defined(POI_GRABPASS) && defined(POI_PASS_BASE)
				poiCam.screenUV = poiCam.clipPos.xy / poiGetWidthAndHeight(_PoiGrab2);
				#else
				poiCam.screenUV = poiCam.clipPos.xy / _ScreenParams.xy;
				#endif
				#ifdef UNITY_SINGLE_PASS_STEREO
				poiCam.posScreenSpace.x = poiCam.posScreenSpace.x * 0.5;
				#endif
				poiCam.posScreenPixels = calcPixelScreenUVs(poiCam.posScreenSpace);
				poiCam.vDotN = abs(dot(poiCam.viewDir, poiMesh.normals[1]));
				poiCam.worldDirection.xyz = poiMesh.worldPos.xyz - poiCam.worldPos;
				poiCam.worldDirection.w = i.worldDir;
				poiFragData.baseColor = mainTexture.rgb;
				#if !defined(POI_PASS_BASETWO) && !defined(POI_PASS_ADDTWO)
				poiFragData.baseColor *= poiThemeColor(poiMods, float4(1,1,1,1).rgb, 0.0);
				poiFragData.alpha = mainTexture.a * float4(1,1,1,1).a;
				#else
				poiFragData.baseColor *= poiThemeColor(poiMods, _TwoPassColor.rgb, _TwoPassColorThemeIndex);
				poiFragData.alpha = mainTexture.a * _TwoPassColor.a;
				#endif
				if (2.0)
				{
					#if defined(PROP_ALPHAMASK) || !defined(OPTIMIZER_ENABLED)
					float alphaMask = POI2D_SAMPLER_PAN(_AlphaMask, _MainTex, poiUV(poiMesh.uv[0.0], float4(1,1,0,0)), float4(0,0,0,0).xy).r;
					#else
					float alphaMask = 1;
					#endif
					alphaMask = saturate(alphaMask * 1.0 + (0.0 ? 0.0 * - 1 : 0.0));
					if (0.0) alphaMask = 1 - alphaMask;
					if (2.0 == 1) poiFragData.alpha = alphaMask;
					if (2.0 == 2) poiFragData.alpha = poiFragData.alpha * alphaMask;
					if (2.0 == 3) poiFragData.alpha = saturate(poiFragData.alpha + alphaMask);
					if (2.0 == 4) poiFragData.alpha = saturate(poiFragData.alpha - alphaMask);
				}
				applyAlphaOptions(poiFragData, poiMesh, poiCam, poiMods);
				poiFragData.finalColor = poiFragData.baseColor;
				#ifndef POI_PASS_LILFUR
				#if !defined(POI_PASS_BASETWO) && !defined(POI_PASS_ADDTWO)
				poiFragData.alpha = 1.0 ? 1 : poiFragData.alpha;
				#else
				poiFragData.alpha = _AlphaForceOpaque2 ? 1 : poiFragData.alpha;
				#endif
				#endif
				if (0.0 == POI_MODE_OPAQUE)
				{
					poiFragData.alpha = 1;
				}
				clip(poiFragData.alpha - 0.5);
				applyUnityFog(poiFragData.finalColor, i.fogData);
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

VertexOut spsVert(SpsInputs v) {
  sps_apply(v);
  return vert((appdata)v);
}

			ENDCG
		
}
	}
}
