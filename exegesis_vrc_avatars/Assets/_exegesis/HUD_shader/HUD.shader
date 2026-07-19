Shader "exegesis/HUD" {
    Properties {
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", Int) = 8
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Int) = 1
        _ColorMask ("Color Mask", Int) = 15

        _StencilRef ("Ref", Int) = 0
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Compare Function", Int) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilPassOp ("Pass Operation", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilFailOp ("Fail Operation", Int) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilZFailOp ("ZFail Operation", Int) = 0
        _StencilReadMask ("Read Mask", Int) = 255
        _StencilWriteMask ("Write Mask", Int) = 255

        [Enum(Flat, 0, Sphere, 1, Mesh, 2, Walls, 3, Triplanar, 4)] _ProjectionType ("Projection Type", Int) = 0
        _ProjectionRotX ("Rotation X", Range(-360, 360)) = 0
        _ProjectionRotY ("Rotation Y", Range(-360, 360)) = 0
        _ProjectionRotZ ("Rotation Z", Range(-360, 360)) = 0

        _Puffiness ("Puffiness", Float) = 0
        _ObjectPositionX ("Object Position X", Float) = 0
        _ObjectPositionY ("Object Position Y", Float) = 0
        _ObjectPositionZ ("Object Position Z", Float) = 0
        _ObjectPositionA ("Object Position A", Float) = 0
        _ObjectRotationX ("Object Rotation X", Float) = 0
        _ObjectRotationY ("Object Rotation Y", Float) = 0
        _ObjectRotationZ ("Object Rotation Z", Float) = 0
        _ObjectRotationA ("Object Rotation A", Float) = 0
        _ObjectScaleX ("Object Scale X", Float) = 1
        _ObjectScaleY ("Object Scale Y", Float) = 1
        _ObjectScaleZ ("Object Scale Z", Float) = 1
        _ObjectScaleA ("Object Scale A", Float) = 1

        _MinFalloff ("Min Falloff", Float) = 30
        _MaxFalloff ("Max Falloff", Float) = 60
        [Enum(Sharp, 0, Linear, 1, Smooth, 2)] _FalloffCurve ("Curve", Int) = 0
        [Toggle(_)] _DepthFalloff ("Camera Depth Falloff", Int) = 0
        _DepthMinFalloff ("Min Distance", Float) = 30
        _DepthMaxFalloff ("Max Distance", Float) = 60
        [Enum(Sharp, 0, Linear, 1, Smooth, 2)] _DepthFalloffCurve ("Curve", Int) = 2
        [Toggle(_)] _ColorFalloff ("Vertex-Color Falloff", Int) = 0
        _ColorMinFalloff ("Min Falloff", Range(0, 1)) = 0
        _ColorMaxFalloff ("Max Falloff", Range(0, 1)) = 1
        [Enum(Sharp, 0, Linear, 1, Smooth, 2)] _ColorFalloffCurve ("Curve", Int) = 2
        [Enum(Red, 0, Green, 1, Blue, 2, Alpha, 3)] _ColorChannelForFalloff ("Color Channel to use", Int) = 3

        [Enum(Image, 0, Flipbook, 1, Cubemap, 2)] _OverlayImageType ("Overlay Type", Int) = 0
        [Enum(Clamp, 0, Repeat, 1, Screen, 2)] _OverlayBoundaryHandling ("Boundary Handling", Int) = 1
        [Toggle(_)] _PixelatedSampling ("Pixelate", Int) = 0
        _MainTex ("Image Overlay", 2D) = "white" {}
        _MainTexRotation ("Rotation", Range(0, 360)) = 0
        _MainTexScrollSpeedX ("Scroll Speed X", Range(-2, 2)) = 0
        _MainTexScrollSpeedY ("Scroll Speed Y", Range(-2, 2)) = 0
        [NoScaleOffset] _OverlayCubemap ("Cubemap Overlay", Cube) = "white" {}
        [HDR] _OverlayColor ("Overlay Color", Color) = (1,1,1,1)
        _FlipbookTotalFrames ("Total Frames", Int) = 0
        _FlipbookFPS ("Frames per second", Float) = 1
        _FlipbookStartFrame ("Start Frame", Int) = 0
        _FlipbookColumns ("Columns", Int) = 20
        _FlipbookRows ("Rows", Int) = 20
        _OverlayCubemapRotationX ("Rotation X", Range(0, 360)) = 0
        _OverlayCubemapRotationY ("Rotation Y", Range(0, 360)) = 0
        _OverlayCubemapRotationZ ("Rotation Z", Range(0, 360)) = 0
        _OverlayCubemapSpeedX ("Rotation Speed X", Range(-360, 360)) = 0
        _OverlayCubemapSpeedY ("Rotation Speed Y", Range(-360, 360)) = 0
        _OverlayCubemapSpeedZ ("Rotation Speed Z", Range(-360, 360)) = 0
        _BlendAmount ("Opacity", Range(0,1)) = 0.5

        [Toggle(_)] _ParticleSystem ("Is on Particle System?", Float) = 0
        [Toggle(_)] _LifetimeFalloff ("Lifetime Falloff", Int) = 0
        [Enum(Sharp, 0, Linear, 1, Smooth, 2)] _LifetimeFalloffCurve ("Curve", Int) = 1
        _LifetimeMinFalloff ("Min Falloff", Range(0,1)) = 0
        _LifetimeMaxFalloff ("Max Falloff", Range(0,1)) = 1

        _OverlayMask ("Overlay Mask", 2D) = "white" {}
        _OverlayMaskOpacity ("Opacity", Range(0, 1)) = 1
        _OverallEffectMask ("Entire Effect Mask", 2D) = "white" {}
        _OverallEffectMaskOpacity ("Opacity", Range(0, 1)) = 1
        _OverallAmplitudeMask ("Entire Effect Amplitude Mask", 2D) = "white" {}
        _OverallAmplitudeMaskOpacity ("Opacity", Range(0, 1)) = 1
        _OverallEffectMaskBlendMode ("Blend Mode", Int) = 9

        [Enum(Normal, 0, No Reflection, 1, Render Only In Mirror, 2)] _MirrorMode ("Mirror Reflectance", Int) = 0
        [Enum(Both, 0, Left, 1, Right, 2)] _EyeSelector ("Eye Discrimination", Int) = 0
        [Enum(Both, 0, Desktop, 1, VR, 2)] _PlatformSelector ("Platform Discrimination", Int) = 0
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendSource ("Blend Source", Int) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _BlendDestination ("Blend Destination", Int) = 10
        [Enum(UnityEngine.Rendering.BlendOp)] _BlendOp ("Blend Mode", Int) = 21

        // ------------------------------------------------------------------
        // Secondary Overlay
        // ------------------------------------------------------------------
        [Toggle(_)] _Overlay2Enabled    ("Enable Secondary Overlay", Int) = 0
        _Overlay2Tex                    ("Secondary Overlay", 2D) = "white" {}
        [HDR] _Overlay2Color            ("Secondary Overlay Color", Color) = (1,1,1,1)
        _Overlay2Rotation               ("Secondary Rotation", Range(0,360)) = 0
        _Overlay2ScrollSpeedX           ("Secondary Scroll Speed X", Range(-2,2)) = 0
        _Overlay2ScrollSpeedY           ("Secondary Scroll Speed Y", Range(-2,2)) = 0
        [Toggle(_)] _Overlay2Pixelated  ("Secondary Pixelate", Int) = 0
        _Overlay2Opacity                ("Secondary Overlay Opacity", Range(0,1)) = 1

        // ------------------------------------------------------------------
        // HUD
        // ------------------------------------------------------------------
        _HUDScale ("HUD Scale", Range(0.25, 2.0)) = 1.0
        _HUDOpacity ("HUD Opacity", Range(0.0, 1.0)) = 0.8

        _HUDDriftRadius ("HUD Drift Radius", Range(0.0, 0.1)) = 0.01
        _HUDDriftPeriod ("HUD Drift Period (sec)", Float) = 600.0

        // ------------------------------------------------------------------
        // HUD Compass
        // ------------------------------------------------------------------
        _CompassTex ("Compass Strip", 2D) = "white" {}
        [HDR]_CompassTint ("Compass Tint", Color) = (1,1,1,1)
        _CompassWidth ("Compass Width (0-1)", Range(0,1)) = 0.6
        _CompassHeight ("Compass Height (0-1)", Range(0,1)) = 0.12
        _CompassYOffset ("Compass Y Offset (0-1)", Range(0,1)) = 0.5
        _CompassMask ("Compass Mask (R)", 2D) = "white" {}

        [Toggle(_)] _CompassSnap ("Snap Compass Pixels", Int) = 1
        _CompassHUDResX ("HUD Snap Width", Float) = 512
        _CompassHUDResY ("HUD Snap Height", Float) = 512
        _CompassTexResX ("Compass Tex Width", Float) = 256
        _CompassTexResY ("Compass Tex Height", Float) = 16

        // ------------------------------------------------------------------
        // HUD Artificial Horizon
        // ------------------------------------------------------------------
        [Toggle(_)] _HorizonPixelated ("Pixelated (snap to HUD grid)", Int) = 1
        _HorizonHUDResX ("Horizon HUD Width", Float) = 512
        _HorizonHUDResY ("Horizon HUD Height", Float) = 512

        [HDR]_HorizonColor ("Horizon Color (0°)", Color) = (1,1,1,1)
        [HDR]_HorizonColorUp90 ("Zenith (+90°) Band Color", Color) = (0,1,0,1)
        [HDR]_HorizonColorDown90 ("Nadir (-90°) Band Color", Color) = (1,0,0,1)

        _HorizonThickness ("Base Horizon Thickness (px)", Range(0,10)) = 2

        // Number of bands between horizon and ±90° (per side)
        // 0 = only ±90°, 1 = 30/60/90, etc.
        _HorizonBandsPerSide ("Bands per Side (0-6)", Range(0,6)) = 3
        [Toggle(_)] _HorizonUpperBandsDotted ("Upper Bands Dotted", Int) = 1

        _HorizonMask ("Horizon Mask (B)", 2D) = "white" {}

        // Manual roll control in degrees
        _HorizonRollOffset ("Horizon Roll Offset (deg)",Float) = 0

        // ------------------------------------------------------------------
        // HUD Status Bars
        // ------------------------------------------------------------------
        [Toggle(_)] _StatusBarsEnabled ("Enable Status Bars", Int) = 0
        [Toggle(_)] _StatusBarsPixelated ("Status Bars Pixelated", Int) = 1

        // Shared mask: RGB = per-bar shapes in HUD space
        _StatusBarsMask ("Status Bars Mask (RGB)", 2D) = "white" {}

        // Per-bar layout: X = center X, Y = center Y, Z = width, W = height (in 0..1 screen space)
        _StatusBar0Layout ("Status Bar 0 Layout", Vector) = (0.1, 0.5, 0.04, 0.6)
        _StatusBar1Layout ("Status Bar 1 Layout", Vector) = (0.5, 0.5, 0.04, 0.6)
        _StatusBar2Layout ("Status Bar 2 Layout", Vector) = (0.9, 0.5, 0.04, 0.6)

        // Fill amounts, 0..1 bottom->top
        _StatusBar0Fill ("Status Bar 0 Fill", Range(0,1)) = 0
        _StatusBar1Fill ("Status Bar 1 Fill", Range(0,1)) = 0
        _StatusBar2Fill ("Status Bar 2 Fill", Range(0,1)) = 0

        // Per-bar gradient textures (sampled along vertical, middle in X)
        _StatusBar0Gradient ("Status Bar 0 Gradient", 2D) = "white" {}
        _StatusBar1Gradient ("Status Bar 1 Gradient", 2D) = "white" {}
        _StatusBar2Gradient ("Status Bar 2 Gradient", 2D) = "white" {}

        [Toggle(_)] _StatusBar0BottomToTop ("Status Bar 0 fill from top", Int) = 1
        [Toggle(_)] _StatusBar1BottomToTop ("Status Bar 1 fill from top", Int) = 1
        [Toggle(_)] _StatusBar2BottomToTop ("Status Bar 2 fill from top", Int) = 1

        // Jitter controls
        _StatusBarsJitterIntensity ("Status Bars Jitter Intensity", Range(0.0, 1.0)) = 0.1
        _StatusBarsJitterFrequency ("Status Bars Jitter Frequency", Float)           = 0.001

        [Toggle(_)] _StatusBar0Jitter ("Status Bar 0 Jitter", Int) = 0
        [Toggle(_)] _StatusBar1Jitter ("Status Bar 1 Jitter", Int) = 0
        [Toggle(_)] _StatusBar2Jitter ("Status Bar 2 Jitter", Int) = 0

        // Optional explicit "HUD res" for bar snapping
        _StatusBarsHUDResX ("Status Bars HUD Width",  Float) = 512
        _StatusBarsHUDResY ("Status Bars HUD Height", Float) = 512

        // ------------------------------------------------------------------
        // HUD Paper Doll
        // ------------------------------------------------------------------
        [Toggle(_)] _PaperDollEnabled ("Enable Paper Doll Indicators", Int) = 0
        _PaperDollMask                ("Paper Doll Mask", 2D) = "white" {}

        // Base doll fill when no touch/damage is active
        [HDR]_PaperDollBaseColor ("Indicators Base Color", Color) = (1,1,1,0)

        // Touch / damage colors (default to horizon nadir/zenith)
        [HDR]_PaperDollTouchColor  ("Touch Color",  Color) = (1,1,0,1)
        [HDR]_PaperDollDamageColor ("Damage Color", Color) = (1,0,0,1)

        // Per-region touch booleans
        [Toggle(_)] _PD_HeadTouch    ("Head Touch",      Int) = 0
        [Toggle(_)] _PD_ChestTouch   ("Chest Touch",     Int) = 0
        [Toggle(_)] _PD_AbdomenTouch ("Abdomen Touch", Int) = 0
        [Toggle(_)] _PD_HipsTouch    ("Hips Touch",      Int) = 0
        [Toggle(_)] _PD_LArmTouch    ("Left Arm Touch",  Int) = 0
        [Toggle(_)] _PD_RArmTouch    ("Right Arm Touch", Int) = 0
        [Toggle(_)] _PD_LLegTouch    ("Left Leg Touch",  Int) = 0
        [Toggle(_)] _PD_RLegTouch    ("Right Leg Touch", Int) = 0

        // Per-region damage booleans
        [Toggle(_)] _PD_HeadDamage    ("Head Damage",      Int) = 0
        [Toggle(_)] _PD_ChestDamage   ("Chest Damage",     Int) = 0
        [Toggle(_)] _PD_AbdomenDamage ("Abdomen Damage", Int) = 0
        [Toggle(_)] _PD_HipsDamage    ("Hips Damage",      Int) = 0
        [Toggle(_)] _PD_LArmDamage    ("Left Arm Damage",  Int) = 0
        [Toggle(_)] _PD_RArmDamage    ("Right Arm Damage", Int) = 0
        [Toggle(_)] _PD_LLegDamage    ("Left Leg Damage",  Int) = 0
        [Toggle(_)] _PD_RLegDamage    ("Right Leg Damage", Int) = 0
    }
    SubShader {
        Tags { "Queue" = "Transparent+3" "VRCFallback"="Hidden" }

        Stencil {
            Ref [_StencilRef]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
            Comp [_StencilComp]
            Pass [_StencilPassOp]
            Fail [_StencilFailOp]
            ZFail [_StencilZFailOp]
        }

        Cull [_CullMode]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        ColorMask [_ColorMask]

        BlendOp [_BlendOp]
        Blend [_BlendSource] [_BlendDestination]

        Pass {
            CGPROGRAM
            #define CANCERFREE
            #define SCREENTEXNAME _Garb
            #define SCREEN_SIZE (float4(rcp(_ScreenParams.xy), _ScreenParams.xy))
            #include "UnityCG.cginc"
            UNITY_DECLARE_SCREENSPACE_TEXTURE(_Garb);
            float4 _Garb_TexelSize;
            #include "HUD_core.cginc"
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            ENDCG
        }
    }
    CustomEditor "HUD_inspector"
}
