#ifndef CS_PROPS_CGINC
#define CS_PROPS_CGINC

// Composite-property macros. Unity can't animate vector / float3 material properties
// directly, so these reassemble them from per-component float properties.
#define _ObjectPosition (float3(_ObjectPositionX, _ObjectPositionY, _ObjectPositionZ) + _ObjectPositionA)
#define _ObjectRotation float3(_ObjectRotationX, _ObjectRotationY, _ObjectRotationZ)
#define _ObjectScale (float3(_ObjectScaleX, _ObjectScaleY, _ObjectScaleZ) * _ObjectScaleA)
#define _MainTexScrollSpeed float2(_MainTexScrollSpeedX, _MainTexScrollSpeedY)
#define _ProjectionRot float3(_ProjectionRotX, _ProjectionRotY, _ProjectionRotZ)
#define _OverlayCubemapRotation float3(_OverlayCubemapRotationX, _OverlayCubemapRotationY, _OverlayCubemapRotationZ)
#define _OverlayCubemapSpeed float3(_OverlayCubemapSpeedX, _OverlayCubemapSpeedY, _OverlayCubemapSpeedZ)

UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

// Projection
int _ProjectionType;
float _ProjectionRotX, _ProjectionRotY, _ProjectionRotZ;

// Distance / depth / vertex-color falloff
float _MinFalloff;
float _MaxFalloff;
int _FalloffCurve;
int _DepthFalloff;
float _DepthMinFalloff;
float _DepthMaxFalloff;
int _DepthFalloffCurve;

// Image overlay
int _OverlayImageType;
int _OverlayBoundaryHandling;

sampler2D _MainTex;
float4 _MainTex_TexelSize;
float4 _MainTex_ST;
float _MainTexScrollSpeedX, _MainTexScrollSpeedY;
float _MainTexRotation;

int _PixelatedSampling;

int _FlipbookRows, _FlipbookColumns;
int _FlipbookStartFrame;
int _FlipbookTotalFrames;
float _FlipbookFPS;

samplerCUBE _OverlayCubemap;
float _OverlayCubemapRotationX, _OverlayCubemapRotationY, _OverlayCubemapRotationZ;
float _OverlayCubemapSpeedX, _OverlayCubemapSpeedY, _OverlayCubemapSpeedZ;

float4 _OverlayColor;
float _BlendAmount;

// Target object transform
float _Puffiness;
float _ObjectPositionX, _ObjectPositionY, _ObjectPositionZ, _ObjectPositionA;
float _ObjectRotationX, _ObjectRotationY, _ObjectRotationZ;
float _ObjectScaleX, _ObjectScaleY, _ObjectScaleZ, _ObjectScaleA;

// Mirror / eye / platform discrimination
int _MirrorMode;
int _EyeSelector;
int _PlatformSelector;

// Masks
sampler2D _OverlayMask;
float4 _OverlayMask_ST;
float _OverlayMaskOpacity;
sampler2D _OverallEffectMask;
float4 _OverallEffectMask_ST;
float _OverallEffectMaskOpacity;
int _OverallEffectMaskBlendMode;
sampler2D _OverallAmplitudeMask;
float4 _OverallAmplitudeMask_ST;
float _OverallAmplitudeMaskOpacity;

// Particle system / lifetime falloff
int _ParticleSystem;
int _LifetimeFalloff;
float _LifetimeMinFalloff;
float _LifetimeMaxFalloff;
int _LifetimeFalloffCurve;

// Vertex-color falloff
float _ColorMinFalloff;
float _ColorMaxFalloff;
float _ColorFalloffCurve;
int _ColorFalloff;
uint _ColorChannelForFalloff;

#endif
