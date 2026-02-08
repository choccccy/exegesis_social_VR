#ifndef CANCERCORE_CGINC
#define CANCERCORE_CGINC

#include "AutoLight.cginc"

struct appdata {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float4 uv : TEXCOORD0;
    float4 uv2 : TEXCOORD1;
    float4 color : COLOR;
    
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f {
    float4 pos : SV_POSITION;
    float3 posWorld : TEXCOORD0;
    float4 projPos : TEXCOORD1;
    float4 depthPos : TEXCOORD2;
    float3 cubemapSampler : TEXCOORD3;
    float4 uv : TEXCOORD4;
    float4 worldDir : TEXCOORD5;
    float4 color : TEXCOORD6;
    
    UNITY_VERTEX_OUTPUT_STEREO
};

#include "CGInclude/CSProps.cginc"
#include "CGInclude/CSEnums.cginc"
#include "CGInclude/CSBlending.cginc"
#include "CGInclude/CSUV.cginc"
#include "CGInclude/CSTransform.cginc"
#include "CGInclude/CSDepth.cginc"
#include "CGInclude/CSDiscriminate.cginc"
#include "CGInclude/CSFalloff.cginc"

#include "CGInclude/CSFalloff.cginc"

// -----------------------------------------------------------------------------
// HUD uniforms
// -----------------------------------------------------------------------------
float _HUDScale;
float _HUDOpacity;

float _HUDDriftRadius;
float _HUDDriftPeriod;

// Secondary overlay
float  _Overlay2Enabled;
sampler2D _Overlay2Tex;
float4 _Overlay2Tex_TexelSize;
float4 _Overlay2Color;
float  _Overlay2Rotation;
float  _Overlay2ScrollSpeedX;
float  _Overlay2ScrollSpeedY;
float  _Overlay2Pixelated;
float  _Overlay2Opacity;

// -----------------------------------------------------------------------------
// HUD Compass uniforms
// -----------------------------------------------------------------------------
sampler2D _CompassTex;
float4 _CompassTex_TexelSize;
float4 _CompassTint;
float  _CompassWidth;
float  _CompassHeight;
float  _CompassYOffset;
sampler2D _CompassMask;
float4 _CompassMask_TexelSize;

float  _CompassSnap;
float  _CompassHUDResX;
float  _CompassHUDResY;
float  _CompassTexResX;
float  _CompassTexResY;

// -----------------------------------------------------------------------------
// HUD Artificial Horizon uniforms
// -----------------------------------------------------------------------------
float4 _HorizonColor;
float4 _HorizonColorUp90;
float4 _HorizonColorDown90;

float _HorizonThickness;
float _HorizonPixelated;
float _HorizonHUDResX;
float _HorizonHUDResY;

sampler2D _HorizonMask;
float4 _HorizonMask_TexelSize;

float _HorizonPitch;
float _HorizonRollOffset;
float _HorizonBandsPerSide;
float _HorizonUpperBandsDotted;

// -----------------------------------------------------------------------------
// HUD Status Bars uniforms
// -----------------------------------------------------------------------------
float _StatusBarsEnabled;
float _StatusBarsPixelated;

sampler2D _StatusBarsMask;
float4    _StatusBarsMask_TexelSize;

float4 _StatusBar0Layout;
float4 _StatusBar1Layout;
float4 _StatusBar2Layout;

float _StatusBar0Fill;
float _StatusBar1Fill;
float _StatusBar2Fill;

sampler2D _StatusBar0Gradient;
sampler2D _StatusBar1Gradient;
sampler2D _StatusBar2Gradient;

float4 _StatusBar0Gradient_TexelSize;
float4 _StatusBar1Gradient_TexelSize;
float4 _StatusBar2Gradient_TexelSize;

float _StatusBar0BottomToTop;
float _StatusBar1BottomToTop;
float _StatusBar2BottomToTop;

float _StatusBarsJitterIntensity;
float _StatusBarsJitterFrequency;
float _StatusBar0Jitter;
float _StatusBar1Jitter;
float _StatusBar2Jitter;

float _StatusBarsHUDResX;
float _StatusBarsHUDResY;

// -----------------------------------------------------------------------------
// HUD Paper Doll uniforms
// -----------------------------------------------------------------------------
float     _PaperDollEnabled;
sampler2D _PaperDollMask;
float4    _PaperDollMask_TexelSize;
float4    _PaperDollBaseColor;
float4    _PaperDollTouchColor;
float4    _PaperDollDamageColor;

float _PD_HeadTouch,  _PD_ChestTouch,  _PD_AbdomenTouch,  _PD_HipsTouch;
float _PD_LArmTouch,  _PD_RArmTouch,   _PD_LLegTouch,     _PD_RLegTouch;

float _PD_HeadDamage, _PD_ChestDamage, _PD_AbdomenDamage, _PD_HipsDamage;
float _PD_LArmDamage, _PD_RArmDamage,  _PD_LLegDamage,    _PD_RLegDamage;

// -----------------------------------------------------------------------------
// Camera helpers for HUD
// -----------------------------------------------------------------------------
// forward in world space (from view matrix)
float3 getCameraForwardWS()
{
    // Unity view matrix: rows are camera basis in world space
    // Forward is -row2 of UNITY_MATRIX_V (row-major)
    float3 f = -UNITY_MATRIX_V[2].xyz;
    return normalize(f);
}

// yaw in [0,1) where 0 = world +Z, increasing around Y
float getYaw01()
{
    float3 fwd = getCameraForwardWS();
    float2 dir = normalize(fwd.xz);
    float angle = atan2(dir.x, dir.y); // 0 when looking +Z
    float yaw01 = (angle / UNITY_TWO_PI) + 0.5;
    return frac(yaw01);
}

float4 sampleCompass(float2 screenUV)  // sample compass strip in a horizontal band with adjustable vertical position
{
    float cw = saturate(_CompassWidth);
    float ch = saturate(_CompassHeight);

    float2 center   = float2(0.5, saturate(_CompassYOffset));
    float2 halfSize = 0.5 * float2(cw, ch);
    float2 minUV    = center - halfSize;
    float2 maxUV    = center + halfSize;

    // outside compass band -> no compass
    if (screenUV.x < minUV.x || screenUV.x > maxUV.x ||
        screenUV.y < minUV.y || screenUV.y > maxUV.y)
        return 0;

    // optional HUD pixel snapping in screen space
    float2 snappedScreenUV = screenUV;
    if (_CompassSnap != 0)
    {
        float2 hudRes = float2(max(_CompassHUDResX, 1.0), max(_CompassHUDResY, 1.0));
        float2 screenPx = screenUV * hudRes;
        screenPx = floor(screenPx);
        snappedScreenUV = screenPx / hudRes;
    }

    // local coords in band [-1,1] AFTER snapping
    float2 local = (snappedScreenUV - center) / halfSize;
    float  localX = local.x;
    float  localY = local.y;

    // camera yaw
    float yaw01    = getYaw01();
    float compassU = yaw01 + 0.5 * localX;

    // map band Y to texture V
    float compassV = saturate(0.5 * (localY + 1.0));

    // compass texture snapping to texel grid
    float2 compassUV = float2(frac(compassU), compassV);
    if (_CompassSnap != 0)
    {
        float2 texRes = float2(max(_CompassTexResX, 1.0), max(_CompassTexResY, 1.0));
        float2 compassPx = compassUV * texRes;
        compassPx = floor(compassPx);
        compassUV = compassPx / texRes;
    }

    float4 col = tex2D(_CompassTex, compassUV) * _CompassTint;

    // screen-space mask; use snapped screenUV so mask aligns to HUD grid too
    float2 maskUV = (_CompassSnap != 0) ? snappedScreenUV : screenUV;
    float  mask   = tex2D(_CompassMask, maskUV).r;
    col.rgb *= mask;
    col.a   *= mask;

    return col;
}

// -----------------------------------------------------------------------------
// Horizon helpers - derive pitch and roll relative to world XZ plane
// -----------------------------------------------------------------------------

// World up/down for pitch and gravity calculations
static const float3 WORLD_UP   = float3(0, 1, 0);
static const float3 WORLD_DOWN = float3(0,-1, 0);

// Camera forward in world space (from view matrix)
float3 camFwdWS()
{
    // Unity view matrix: rows are camera basis in world space
    // Forward is -row2 of UNITY_MATRIX_V (row-major)
    float3 f = -UNITY_MATRIX_V[2].xyz;
    return normalize(f + 1e-6);
}

// Gravity direction in view space (camera-local)
// Used to define "down" on the HUD and drive roll.
float3 gravityVS()
{
    float4 gWS  = float4(WORLD_DOWN, 0);
    float4 gVS4 = mul(UNITY_MATRIX_V, gWS);
    return normalize(gVS4.xyz + 1e-6);
}

// True pitch angle in degrees: 0 = horizon, +90 = straight up, -90 = straight down.
// This is the angular separation between camera forward and the horizon plane.
float getHorizonPitchDeg()
{
    float3 f     = camFwdWS();
    float  dotUp = clamp(dot(f, WORLD_UP), -1.0, 1.0); // dotUp = sin(pitch)
    return asin(dotUp) * (180.0 / UNITY_PI);
}

// Horizon direction in screen space driven by roll relative to gravity.
// Uses gravity's azimuth in the camera's X-Y plane as roll; yaw/pitch only
// change how much gravity points into Z, not its X-Y angle.
float2 getHorizonDirSS()
{
    float3 gVS = gravityVS(); // gravity in view space

    // Project gravity into the camera's X-Y plane (view plane)
    float2 g2D = float2(gVS.x, gVS.y);
    float  len = length(g2D);
    if (len < 1e-3)
    {
        // Degenerate: looking straight along gravity; just keep horizon horizontal
        return float2(1, 0);
    }

    g2D /= len;

    // In view space, when camera is level:
    //   gravityVS ≈ (0, -1, 0) -> g2D = (0, -1)
    // We want horizon to be horizontal (dir = (1,0)) in that case.
    //
    // Take a vector perpendicular to g2D as horizon direction.
    // gravity (0,-1) -> perp (1,0) (horizontal)
    float2 dir = float2(-g2D.y, g2D.x);

    // Optional: apply a small calibration offset from _HorizonRollOffset (deg)
    float rollOffsetRad = radians(_HorizonRollOffset);
    float c = cos(rollOffsetRad), s = sin(rollOffsetRad);
    float2 dirRot = float2(dir.x * c - dir.y * s, dir.x * s + dir.y * c);

    return normalize(dirRot + 1e-6);
}

// Gravity direction in screen space (view plane), pointing "down".
// Used as the axis along which pitch bands are offset.
// Returns a normalized 2D vector in screen UV space.
float2 getGravityDirSS()
{
    float3 gVS = gravityVS();                // gravity in view space (xyz)
    float2 g2D = float2(gVS.x, gVS.y);      // project into view plane (x,y)
    float  len = length(g2D);
    if (len < 1e-3)
    {
        // Degenerate: looking straight along gravity; just treat gravity as down
        return float2(0, -1);
    }

    return g2D / len;                       // "down" direction in screen space
}

// Convert a pitch angle in degrees to a linear distance in normalized screen units along the gravity axis.
// This defines the ladder spacing of horizon bands.
float pitchDegToScreenDist(float pitchDeg)
{
    float pitchNorm = clamp(pitchDeg / 90.0, -1.0, 1.0);  // -1..1
    return -pitchNorm;
}

// Dotted mask along a horizon line at this screenUV, using the same geometry.
// center     : center of the specific band in screen UV
// dirHorizon : normalized direction of the band in screen space
// Returns 0..1: 1 where the dot is "on".
float horizonDottedMask(float2 screenUV, float2 center, float2 dirHorizon)
{
    // Project current pixel onto the horizon direction, in HUD pixels
    float2 hudRes       = float2(max(_HorizonHUDResX, 1.0), max(_HorizonHUDResY, 1.0));
    float2 offset       = screenUV - center;
    float2 offsetPixels = offset * hudRes;

    float along = dot(offsetPixels, dirHorizon);

    // Simple 1D pattern: 4px on, 4px off
    float patternLen  = 8.0;
    float patternPos  = frac((along / patternLen) + 1.0);
    float patternMask = step(0.5, patternPos); // 0..0.5 -> 0, 0.5..1 -> 1

    return patternMask;
}

// Compute band color by interpolating between horizon, +90 and -90 colors
// based on band offset from the horizon in degrees.
// offsetDeg > 0 => sky side; offsetDeg < 0 => ground side.
float4 getHorizonBandColor(float offsetDeg)
{
    float zenith = saturate(offsetDeg / 90.0);   // +up (sky side)
    float nadir  = saturate(-offsetDeg / 90.0);  // +down (ground side)
    float horizon = 1.0 - max(zenith, nadir);    // center (horizon)

    float4 col = 0;
    col += _HorizonColor      * horizon;
    col += _HorizonColorDown90 * zenith; // above horizon
    col += _HorizonColorUp90   * nadir;  // below horizon
    return col;
}


// Sample a horizon line at a given pitch angle (degrees).
//   pitchDeg       : 0 = geometric horizon, +up, -down
//   lineThicknessPx: line thickness in pixels (approx; 1 = ~1px, 2 = ~2px, etc).
//   dotted         : if true, apply dotted mask along the horizon direction.
// This function:
//   - Defines a "ladder" centered at screen center.
//   - Offsets along gravity by pitchDeg using pitchDegToScreenDist.
//   - Draws a band perpendicular to horizon direction with given thickness.
//   - Optionally applies a dotted pattern, then masks by _HorizonMask.
float4 sampleHorizonAtPitchDeg(float2 screenUV, float pitchDeg, float bandOffsetDeg, float lineThicknessPx, bool dotted)
{
    // Optional HUD pixel snapping (snaps sampling grid for stability)
    float2 snappedUV = screenUV;
    if (_HorizonPixelated != 0)
    {
        float2 hudRes = float2(max(_HorizonHUDResX, 1.0), max(_HorizonHUDResY, 1.0));
        float2 hudPx  = screenUV * hudRes;
        hudPx         = floor(hudPx);
        snappedUV     = hudPx / hudRes;
    }

    // 2D directions in view plane
    float2 dirHorizon = getHorizonDirSS(); // along horizon line
    float2 dirGravity = getGravityDirSS(); // downwards

    // Ladder center at screen center; offset along gravity by pitchDeg
    float2 baseCenter = float2(0.5, 0.5);
    float  distNorm   = pitchDegToScreenDist(pitchDeg);
    float2 center     = baseCenter - dirGravity * distNorm;

    // Signed distance from this line (in HUD pixels)
    float2 offset = snappedUV - center;
    float2 normal = float2(-dirHorizon.y, dirHorizon.x);

    float2 hudResForThickness = float2(max(_HorizonHUDResX, 1.0), max(_HorizonHUDResY, 1.0));
    float  distPx             = abs(dot(offset * hudResForThickness, normal));

    // Use explicit thickness for band / main horizon classification
    float thicknessPx   = max(lineThicknessPx * _HorizonThickness, 0.0);
    float halfThickness = max(thicknessPx, 0.0) * 0.5;
    float coverage      = saturate(step(distPx, halfThickness));
    if (coverage <= 0.0)
        return 0;

    float4 col = getHorizonBandColor(bandOffsetDeg);

    // Dotted masking for "dotted" lines (upper bands)
    if (dotted)
    {
        float dotMask = horizonDottedMask(snappedUV, center, dirHorizon);
        col *= dotMask;
        if (col.a <= 0.0)
            return 0;
    }

    // Mask by B channel in screen space; use snapped UVs so mask aligns to HUD grid
    float maskB = tex2D(_HorizonMask, snappedUV).b;
    col *= maskB;

    return col;
}

// -----------------------------------------------------------------------------
// HUD Artificial Horizon sampling
//
// Draws a 2px main horizon band at the camera's true pitch,
// plus additional 1px bands at ±30°, ±60°, ±90°.
// Upper bands (above horizon) are dotted; lower bands are solid.
// -----------------------------------------------------------------------------
float4 sampleHorizon(float2 screenUV)
{
    float4 col = 0;

    // Current camera pitch angle in degrees
    float pitchDeg = getHorizonPitchDeg();

    // Main horizon: base thickness (offset = 0)
    col += sampleHorizonAtPitchDeg(screenUV, pitchDeg, 0.0, 2.0, false);

    int bandsPerSide = (int)round(saturate(_HorizonBandsPerSide / 6.0) * 6.0);

    for (int side = 0; side < 2; ++side)
    {
        float sign = (side == 0) ? 1.0 : -1.0;

        for (int i = 0; i < bandsPerSide; ++i)
        {
            float t = (bandsPerSide <= 1) ? 1.0 : ((float)(i + 1) / (float)bandsPerSide);
            float offsetDeg = t * 90.0 * sign;       // band offset from horizon
            float bandPitch = pitchDeg + offsetDeg;  // absolute band pitch

            bool isAbove = (offsetDeg > 0.0);
            bool dotted  = (_HorizonUpperBandsDotted != 0.0) ? isAbove : false;  // above: dotted, below: solid
            float thickness = 1.0;

            col += sampleHorizonAtPitchDeg(screenUV, bandPitch, offsetDeg, thickness, dotted);
        }
    }

    col.a = saturate(col.a);
    return col;
}

// Cheap 1D hash-based noise in [-1,1]
float jitterNoise01(float seed, float t)
{
    // Combine seed and time; 17.0 is arbitrary to decorrelate t a bit
    float x = seed * 43758.5453123 + t * 17.0;
    float s = sin(x) * 43758.5453123;
    return frac(s) * 2.0 - 1.0; // [-1,1]
}

// Sample a single vertical status bar.
// layout: xy = center (screen UV), zw = size (width, height) in screen UV.
// fill: 0..1 bottom->top.
// maskChannel: 0=R,1=G,2=B in _StatusBarsMask.
float4 sampleStatusBar(
    float2 screenUV,
    float4 layout,
    float fill,
    sampler2D gradTex,
    int maskChannel,
    float bottomToTop,  // 1 = bottom→top, 0 = top→bottom
    float jitterEnabled, // 0/1
    float jitterSeed     // unique per bar
) {
    if (_StatusBarsEnabled == 0) return 0;

    float2 center = layout.xy;
    float2 size   = layout.zw;
    float2 half   = 0.5 * size;

    float2 minUV = center - half;
    float2 maxUV = center + half;

    if (screenUV.x < minUV.x || screenUV.x > maxUV.x ||
        screenUV.y < minUV.y || screenUV.y > maxUV.y)
        return 0;

    // Optional HUD pixel snapping for bar geometry
    float2 snappedUV = screenUV;
    if (_StatusBarsPixelated != 0) {
        float2 hudRes = float2(max(_StatusBarsHUDResX, 1.0), max(_StatusBarsHUDResY, 1.0));
        float2 hudPx  = screenUV * hudRes;
        hudPx         = floor(hudPx);
        snappedUV     = hudPx / hudRes;
    }

    float2 local = (snappedUV - minUV) / (maxUV - minUV); // [0,1] in bar space

    // Fill direction: bottom→top vs top→bottom
    float yForFill = (bottomToTop != 0.0) ? local.y : (1.0 - local.y);

    // Optional jitter on fill value
    if (jitterEnabled != 0.0 && _StatusBarsJitterIntensity > 0.0 && _StatusBarsJitterFrequency > 0.0)
    {
        float t = _Time.y * _StatusBarsJitterFrequency;
        float noise = jitterNoise01(jitterSeed, t); // [-1,1]
        float jitter = noise * _StatusBarsJitterIntensity;
        fill = saturate(fill + jitter);
    }

    float filled = step(1.0 - fill, yForFill);
    if (filled <= 0.0) return 0;

    // Gradient sampling: align gradient with fill direction
    // bottom→top: V = yForFill; top→bottom: V = 1 - yForFill
    float gradV = (bottomToTop != 0.0) ? yForFill : (1.0 - yForFill);
    float2 gradUV = float2(0.5, saturate(gradV));

    // Pixelate gradient in V (and U for consistency) to create visible bands
    if (_StatusBarsPixelated != 0) {
        // Use Unity's auto _TexelSize for this gradient
        float4 texelSize = float4(0,0,0,0);
        if (maskChannel == 0) texelSize = _StatusBar0Gradient_TexelSize;
        if (maskChannel == 1) texelSize = _StatusBar1Gradient_TexelSize;
        if (maskChannel == 2) texelSize = _StatusBar2Gradient_TexelSize;

        float2 texRes = texelSize.zw; // width, height
        float2 gradPx = gradUV * texRes;
        gradPx        = floor(gradPx);
        gradUV        = gradPx / texRes;
    }

    float4 col = tex2D(gradTex, gradUV);

    // Mask by chosen channel
    float3 maskRGB = tex2D(_StatusBarsMask, snappedUV).rgb;
    float maskSample = (maskChannel == 0) ? maskRGB.r :
                       (maskChannel == 1) ? maskRGB.g : maskRGB.b;

    col *= maskSample * filled;
    return col;
}

// -----------------------------------------------------------------------------
// Status Bars
// -----------------------------------------------------------------------------
float4 sampleStatusBars(float2 screenUV) {
    if (_StatusBarsEnabled == 0) return 0;

    float4 col0 = sampleStatusBar(screenUV, _StatusBar0Layout, _StatusBar0Fill, _StatusBar0Gradient, 0,
                                  _StatusBar0BottomToTop, _StatusBar0Jitter, 0.123);
    float4 col1 = sampleStatusBar(screenUV, _StatusBar1Layout, _StatusBar1Fill, _StatusBar1Gradient, 1,
                                  _StatusBar1BottomToTop, _StatusBar1Jitter, 0.456);
    float4 col2 = sampleStatusBar(screenUV, _StatusBar2Layout, _StatusBar2Fill, _StatusBar2Gradient, 2,
                                  _StatusBar2BottomToTop, _StatusBar2Jitter, 0.789);

    float4 col = 0;
    col = lerp(col, col0, col0.a);
    col = lerp(col, col1, col1.a);
    col = lerp(col, col2, col2.a);
    return col;
}

// -----------------------------------------------------------------------------
// Secondary Overlay
// -----------------------------------------------------------------------------
float4 sampleSecondaryOverlay(float2 screenSpaceOverlayUV, float2 distortion)
{
    if (_Overlay2Enabled == 0) return 0;

    // Start from screen UV
    float2 uv = screenSpaceOverlayUV;

    // Optional distortion
    uv += distortion;

    // Center at 0, rotate, then re-center (same pattern as main overlay)
    uv -= 0.5;
    float rotRad = radians(_Overlay2Rotation);
    float s = sin(rotRad), c = cos(rotRad);
    float2x2 rotM = float2x2(c, -s, s, c);
    uv = mul(rotM, uv);
    uv += 0.5;

    // Optional scrolling
    uv += float2(_Overlay2ScrollSpeedX, _Overlay2ScrollSpeedY) * _Time.y;

    // Optional pixelation using texel size
    if (_Overlay2Pixelated != 0)
    {
        float2 texRes = _Overlay2Tex_TexelSize.zw;
        float2 texPx  = uv * texRes;
        texPx = floor(texPx);
        uv = texPx / texRes;
    }

    // Clamp to screen
    uv = saturate(uv);

    float4 col = tex2D(_Overlay2Tex, uv) * _Overlay2Color;
    col.a *= _Overlay2Opacity;
    return col;
}

// -----------------------------------------------------------------------------
// Paper Doll
// -----------------------------------------------------------------------------
// Returns which region this pixel belongs to (0 = none, 1..8 = body parts).
int getPaperDollRegion(float3 maskRGB)
{
    float3 c = maskRGB;
    const float eps = 0.01;

    if (all(abs(c - float3(1,1,1)) < eps))      return 1; // Head
    if (all(abs(c - float3(1,0,0)) < eps))      return 2; // Chest
    if (all(abs(c - float3(0,1,0)) < eps))      return 3; // Abdomen
    if (all(abs(c - float3(0,0,1)) < eps))      return 4; // Hips
    if (all(abs(c - float3(1,1,0)) < eps))      return 5; // Left Arm
    if (all(abs(c - float3(0,1,1)) < eps))      return 6; // Right Arm
    if (all(abs(c - float3(0.5,0.5,0)) < eps))  return 7; // Left Leg (808000)
    if (all(abs(c - float3(0,0.5,0.5)) < eps))  return 8; // Right Leg (008080)

    return 0;
}

// Sample paper doll indicator at this HUD UV.
// Damage overrides touch; indicator color comes from _PaperDollIndicatorColor.
float4 samplePaperDoll(float2 screenUV)
{
    if (_PaperDollEnabled == 0) return 0;

    float4 maskSample = tex2D(_PaperDollMask, screenUV);
    int region = getPaperDollRegion(maskSample.rgb);
    if (region == 0) return 0;

    float touch = 0.0;
    float damage = 0.0;

    if (region == 1) { touch = _PD_HeadTouch; damage = _PD_HeadDamage; }
    else if (region == 2) { touch = _PD_ChestTouch; damage = _PD_ChestDamage; }
    else if (region == 3) { touch = _PD_AbdomenTouch;  damage = _PD_AbdomenDamage; }
    else if (region == 4) { touch = _PD_HipsTouch; damage = _PD_HipsDamage; }
    else if (region == 5) { touch = _PD_LArmTouch; damage = _PD_LArmDamage; }
    else if (region == 6) { touch = _PD_RArmTouch; damage = _PD_RArmDamage; }
    else if (region == 7) { touch = _PD_LLegTouch; damage = _PD_LLegDamage; }
    else if (region == 8) { touch = _PD_RLegTouch; damage = _PD_RLegDamage; }

    // Decide which color to use; damage overrides touch
    float hasDamage = damage > 0.5 ? 1.0 : 0.0;
    float hasTouch  = (touch > 0.5 && hasDamage == 0.0) ? 1.0 : 0.0;

    float4 col = _PaperDollBaseColor;
    if (hasTouch  > 0.0) col = _PaperDollTouchColor;
    if (hasDamage > 0.0) col = _PaperDollDamageColor;

    return col;
}

//CANCERFREE
float4 sampleBumpMap(float4 uv) {
#ifdef CANCERFREE
    return ((float4)0);
#else
    return tex2Dlod(_BumpMap, uv);
#endif
}
float4 sampleMeltMap(float4 uv) {
#ifdef CANCERFREE
    return ((float4)0);
#else
    return tex2Dlod(_MeltMap, uv);
#endif
}
float4 sampleDistortionMask(float4 uv) {
#ifdef CANCERFREE
    return ((float4)0);
#else
    return tex2Dlod(_DistortionMask, uv);
#endif
}

float2 hash23(float3 p) {
    if (_AnimatedSampling) p.z += frac(_Time.z) * 4;
    p = frac(p * float3(400, 450, .1));
    p += dot(p, p.yzx + 20);
    return frac((p.xx + p.yz) * p.zy);
}

float2 calculateUVsWithFlipbookParameters(float2 uv, float2 distortion, bool pixelated, bool flipbook, float4 texelSizes, float startFrame, float fps, float totalFrames, float2 cr, float uvRot, float2 uvScrollSpeed, float4 uvST, int boundaryHandling) {
    float currentFrame = 0;
    float2 invCR = 1;
    
    float2 res = texelSizes.zw, invRes = texelSizes.xy;
    
    if (flipbook) {
        currentFrame = floor(fmod(startFrame + fmod(_Time.y * fps, totalFrames), totalFrames));
        invCR = 1 / cr;
        res *= invCR;
        invRes *= cr;
    }
    
    if (pixelated) uv = pixelateSamples(res, invRes, uv);
    
    if (_DistortionTarget == DISTORT_TARGET_OVERLAY || _DistortionTarget == DISTORT_TARGET_BOTH) uv += distortion;
    
    uv -= .5;
    uv = mul(createRotationMatrix(uvRot), uv);
    uv = uv * uvST.xy + uvST.zw + .5;
    
    switch (boundaryHandling) {
        case BOUNDARYMODE_CLAMP:
            uv = saturate(uv);
            break;
        case BOUNDARYMODE_REPEAT:
            uv = frac(uv + frac(_Time.yy * uvScrollSpeed));
            break;
    }
    
    if (flipbook) {
        float row = floor(currentFrame * invCR.x);
        float2 offset = float2(currentFrame - row * cr.x, cr.y - row - 1);
        
        uv = frac((uv + offset) * invCR);
    }
    
    return uv;
}

fixed calculateFalloffAmplitude(float dist, float2 screenUV, float4 color, float depth, float particleAge01) {
    screenUV -= .5;
    fixed4 amplitudeMaskContribution = tex2Dlod(_OverallAmplitudeMask, float4(TRANSFORM_TEX(screenUV, _OverallAmplitudeMask) + .5, 0, 0));
    
    fixed ageContribution = 1;
    if (_LifetimeFalloff) {
        ageContribution = calculateEffectAmplitudeFromFalloff(particleAge01, _LifetimeFalloffCurve, _LifetimeMinFalloff, _LifetimeMaxFalloff);
    }
    
    fixed depthContribution = 1;
    if (_DepthFalloff && depth != -1234) {
        depthContribution = calculateEffectAmplitudeFromFalloff(depth, _DepthFalloffCurve, _DepthMinFalloff, _DepthMaxFalloff);
    }

    fixed colorContribution = 1;
    if (_ColorFalloff) {
        colorContribution = calculateEffectAmplitudeFromFalloff(color[_ColorChannelForFalloff], _ColorFalloffCurve, _ColorMinFalloff, _ColorMaxFalloff);
    }
    
    return calculateEffectAmplitudeFromFalloff(dist, _FalloffCurve, _MinFalloff, _MaxFalloff) * amplitudeMaskContribution.r * amplitudeMaskContribution.a * _OverallAmplitudeMaskOpacity * depthContribution * ageContribution * colorContribution;
}

float2 calculateDistortion(float falloffAmplitude, float2 screenSpaceOverlayUV) {
    float2 distortion = 0;
    UNITY_BRANCH switch (_DistortionType) {
        case DISTORT_NORMAL:
            {
                float2 distortionUV = calculateUVsWithFlipbookParameters(
                    screenSpaceOverlayUV,
                    0,
                    false,
                    _DistortFlipbook,
                    _BumpMap_TexelSize,
                    _DistortFlipbookStartFrame,
                    _DistortFlipbookFPS,
                    _DistortFlipbookTotalFrames,
                    float2(_DistortFlipbookColumns, _DistortFlipbookRows),
                    _DistortionMapRotation,
                    _BumpMapScrollSpeed,
                    _BumpMap_ST,
                    BOUNDARYMODE_REPEAT);
                distortion = UnpackNormal(sampleBumpMap(float4(distortionUV, 0, 0))).xy * _DistortionAmplitude;
            }
            break;
        case DISTORT_MELT:
            {
                float2 distortionUV = calculateUVsWithFlipbookParameters(
                    screenSpaceOverlayUV,
                    0,
                    false,
                    _DistortFlipbook,
                    _MeltMap_TexelSize,
                    _DistortFlipbookStartFrame,
                    _DistortFlipbookFPS,
                    _DistortFlipbookTotalFrames,
                    float2(_DistortFlipbookColumns, _DistortFlipbookRows),
                    _DistortionMapRotation,
                    0,
                    _MeltMap_ST,
                    BOUNDARYMODE_REPEAT);
                float4 meltVal = sampleMeltMap(float4(distortionUV, 0, 0));
                float2 motionVector = normalize(2 * meltVal.rg - 1);
                float activation_Time = meltVal.b * _MeltActivationScale;
                float speed = meltVal.a * _DistortionAmplitude;
                if (_MeltController >= activation_Time) {
                    distortion = ((_MeltController - activation_Time) * speed) * motionVector;
                }
            }
            break;
    }
    
    distortion *= falloffAmplitude * _DistortionMaskOpacity * sampleDistortionMask(float4((TRANSFORM_TEX((screenSpaceOverlayUV - .5), _DistortionMask) + .5), 0, 0)).r;
    distortion = mul(createRotationMatrix(_DistortionRotation), distortion);
    return distortion;
}

float4 calculateOverlayColor(float2 screenSpaceOverlayUV, float2 distortion, float3 cubemapSampler) {
    float4 color = 0;
    UNITY_BRANCH switch (_OverlayImageType) {
        case OVERLAY_IMAGE:
        case OVERLAY_FLIPBOOK:
            {
                float2 uv = calculateUVsWithFlipbookParameters(
                    screenSpaceOverlayUV, 
                    distortion, 
                    _PixelatedSampling,
                    _OverlayImageType == OVERLAY_FLIPBOOK, 
                    _MainTex_TexelSize, 
                    _FlipbookStartFrame, 
                    _FlipbookFPS, 
                    _FlipbookTotalFrames, 
                    float2(_FlipbookColumns, _FlipbookRows), 
                    _MainTexRotation, 
                    _MainTexScrollSpeed, 
                    _MainTex_ST,
                    _OverlayBoundaryHandling);
                
                if (_OverlayBoundaryHandling == BOUNDARYMODE_SCREEN && (saturate(uv.x) != uv.x || saturate(uv.y) != uv.y)) {
                    return 0;
                } else {
                    return tex2Dlod(_MainTex, float4(uv, 0, 0)) * _OverlayColor;
                }
            }
        case OVERLAY_CUBEMAP:
            return texCUBE(_OverlayCubemap, cubemapSampler) * _OverlayColor;
        default:
            return 0;
    }
}

v2f vert (appdata v) {
    v2f o;
    
    // SPS-I setup
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(v2f, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    
    float2 uv = v.uv.xy;
    float3 particleCenter = float3(v.uv.zw, v.uv2.x);
    float particleAge01 = v.uv2.y;
    
    bool inMirror = isInMirror();
    bool noRender = 
        _MirrorMode == MIRROR_DISABLE && inMirror
        || _MirrorMode == MIRROR_ONLY && !inMirror
        #if defined(USING_STEREO_MATRICES)
        || _PlatformSelector == PLATFORM_DESKTOP
        || _EyeSelector == EYE_LEFT && !isEye(0, inMirror)
        || _EyeSelector == EYE_RIGHT && !isEye(1, inMirror)
        #else
        || _PlatformSelector == PLATFORM_VR
        #endif
        ;
    
    
    if (noRender) {
        v.vertex.xyz = 1.0e25;
        o = (v2f) 0;
        o.pos = UnityObjectToClipPos(v.vertex);
        return o;
    }
    
    v.vertex.xyz = rotateXYZ(v.vertex.xyz, _ObjectRotation);
    v.vertex.xyz *= _ObjectScale;
    v.vertex.xyz += _Puffiness * v.normal;
    
    v.vertex.xyz += _ObjectPosition;
    
    o.posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;
    float4 vertexIntended = UnityObjectToClipPos(v.vertex);
    o.projPos = ComputeGrabScreenPos(vertexIntended);
    o.depthPos = ComputeScreenPos(vertexIntended);
    o.worldDir.xyz = o.posWorld - _WorldSpaceCameraPos;
    o.worldDir.w = dot(vertexIntended, CalculateFrustumCorrection());
    
    float4 viewPos = float4(UnityWorldToViewPos(float4(o.posWorld, 1)), 1);
    
    float distanceForFalloff = 0;
    if (_ParticleSystem) {
        distanceForFalloff = distance(_WorldSpaceCameraPos, particleCenter);//mul(unity_ObjectToWorld, float4(particleCenter, 1)).xyz);
    } else {
        distanceForFalloff = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz);
    }
    
#ifndef CANCERFREE
    UNITY_BRANCH if (!_ScreenReprojection)
#endif
    {
        int projectionType = _ProjectionType;
        if (projectionType == PROJECTION_TRIPLANAR) projectionType = PROJECTION_FLAT;
        
        float2 screenUV = calculateScreenUVs(
            _ProjectionType, 
            rotateProjectionWorld(o.posWorld, _ProjectionRot), 
            v.uv, 
            0, 
            0, 
            SCREEN_SIZE.zw
        );
        
        float rotation = calculateFalloffAmplitude(distanceForFalloff, screenUV, v.color, -1234, particleAge01) * _ScreenRotationAngle;
        viewPos.xy = rotate(viewPos.xy, rotation);
        o.posWorld = rotateAxis(o.posWorld, UNITY_MATRIX_IT_MV[2].xyz, rotation);
    }
    
    o.pos = UnityViewToClipPos(viewPos);
    o.cubemapSampler = rotateXYZ(o.posWorld - _WorldSpaceCameraPos, _OverlayCubemapRotation + fmod(_Time.y * _OverlayCubemapSpeed, 360));
    
    o.uv.xy = v.uv.xy;
    o.uv.z = distanceForFalloff;
    o.uv.w = particleAge01;
    o.color = v.color;
    return o;
}

fixed4 frag (v2f i) : SV_Target {
    // SPS-I setup
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

    float timeCircularMod = fmod(_Time.y, UNITY_TWO_PI);
    
    float3 viewVec = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz - _WorldSpaceCameraPos;
    float effectDistance = i.uv.z;
    float particleAge01 = i.uv.w;
    
    float depth = calculateCameraDepth(i.depthPos.xy, i.worldDir, rcp(i.pos.w));
    
    float VRFix = 1;
#if defined(UNITY_SINGLE_PASS_STEREO)
    VRFix = .5;
#endif
    
    float3 triplanarWorld = depth * normalize(i.posWorld - _WorldSpaceCameraPos) + _WorldSpaceCameraPos;
    
    float3 triplanarNormal;
    if (isInMirror()) triplanarNormal = cross(ddx(triplanarWorld), ddy(triplanarWorld));
    else triplanarNormal = cross(-ddx(triplanarWorld), ddy(triplanarWorld));
    triplanarNormal = normalize(triplanarNormal);

    float2 screenSpaceOverlayUV = calculateScreenUVs(
        _ProjectionType, 
        rotateProjectionWorld(i.posWorld, _ProjectionRot), 
        i.uv.xy, 
        triplanarWorld, 
        triplanarNormal, 
        SCREEN_SIZE.zw
    );

    // Global HUD scale around screen center
    float2 hudCenter = float2(0.5, 0.5);
    screenSpaceOverlayUV = (screenSpaceOverlayUV - hudCenter) * _HUDScale + hudCenter;

    // Slow circular HUD drift to reduce burn-in
    if (_HUDDriftRadius > 0.0 && _HUDDriftPeriod > 0.0) {
        float t = _Time.y / _HUDDriftPeriod;  // cycles per 1 period
        float angle = t * UNITY_TWO_PI;
        float s = sin(angle);
        float c = cos(angle);
        float2 drift = float2(c, s) * _HUDDriftRadius;
        screenSpaceOverlayUV += drift;
    }

    fixed allAmp = calculateFalloffAmplitude(effectDistance, screenSpaceOverlayUV, i.color, depth, particleAge01);
    float2 distortion = calculateDistortion(allAmp, screenSpaceOverlayUV);

    // Start from black (no overlay yet)
    float4 color = 0;

    // Secondary overlay first (background)
    float4 overlay2Col = sampleSecondaryOverlay(screenSpaceOverlayUV, distortion);
    color.rgb = lerp(color.rgb, overlay2Col.rgb, overlay2Col.a);
    color.a   = saturate(color.a + overlay2Col.a);

    // Main overlay on top
    float4 primaryCol = calculateOverlayColor(screenSpaceOverlayUV, distortion, i.cubemapSampler);
    color.rgb = lerp(color.rgb, primaryCol.rgb, primaryCol.a);
    color.a   = saturate(color.a + primaryCol.a);

    // --- HUD Compass blend ---
    // Treat compass as an additive overlay that also contributes to alpha
    float4 compassCol = sampleCompass(screenSpaceOverlayUV);
    color.rgb = lerp(color.rgb, compassCol.rgb, compassCol.a);
    color.a   = saturate(color.a + compassCol.a);

    // HUD Artificial Horizon compositing
    float4 horizonCol = sampleHorizon(screenSpaceOverlayUV);
    color.rgb = lerp(color.rgb, horizonCol.rgb, horizonCol.a);
    color.a   = saturate(color.a + horizonCol.a);

    // HUD status bars
    float4 barsCol = sampleStatusBars(screenSpaceOverlayUV);
    color.rgb = lerp(color.rgb, barsCol.rgb, barsCol.a);
    color.a   = saturate(color.a + barsCol.a);

    // Paper Doll indicators
    float4 dollCol = samplePaperDoll(screenSpaceOverlayUV);
    color.rgb = lerp(color.rgb, dollCol.rgb, dollCol.a);
    color.a   = saturate(color.a + dollCol.a);
    
    // Rest of frag
    float2 grabUV = _ScreenReprojection ? screenSpaceOverlayUV : (i.projPos.xy / i.projPos.w);
    
    float3 originPos = ComputeGrabScreenPos(UnityObjectToClipPos(float4(0,0,0,1))).xyw;
    originPos.xy /= originPos.z;
    if (distance(originPos.xy, saturate(originPos.xy)) == 0) {
        grabUV -= originPos.xy;
        float zoomAmt = lerp(1, _Zoom, saturate(-dot(normalize(viewVec), UNITY_MATRIX_V[2].xyz)));
        grabUV *= lerp(1, zoomAmt, allAmp);
        grabUV += originPos.xy;
    }
    
    float pixelationAmt = _Pixelation * allAmp;
    if (pixelationAmt > 0) grabUV = floor(grabUV / pixelationAmt) * pixelationAmt;
    
    float2 displace = _Shake * sin(timeCircularMod * _ShakeSpeed) * _ShakeAmplitude;
    displace += _WobbleAmount * sin(timeCircularMod * _WobbleSpeed + i.pos.xy * _WobbleTiling);
    if (_DistortionTarget == DISTORT_TARGET_SCREEN || _DistortionTarget == DISTORT_TARGET_BOTH) displace += distortion;
    grabUV += allAmp * displace * float2(VRFix, 1);
    
    float4 grabCol = float4(0, 0, 0, 1);
    
#ifndef CANCERFREE
    for (int blurPass = 0; blurPass < _BlurSampling; ++blurPass) {
        float2 blurNoiseRand = hash23(float3(grabUV, (float) blurPass));
        
        float s, c;
        sincos(blurNoiseRand.x * UNITY_TWO_PI, s, c);
        
        // FIXME: does this line need VRFix? i think it might.
        float2 sampleUV = grabUV + (blurNoiseRand.y * allAmp * _BlurRadius * float2(s, c)) / (SCREEN_SIZE.zw);
        
        float4 col = 0;
        
        UNITY_UNROLL for (int j = 0; j < 3; ++j) {
            float2 multiplier = float2(_ScreenXMultiplier[j] * _ScreenXMultiplier.a, _ScreenYMultiplier[j] * _ScreenYMultiplier.a);
            float2 shift = float2(_ScreenXOffset[j] + _ScreenXOffset.a, _ScreenYOffset[j] + _ScreenYOffset.a);
            shift.x *= VRFix;
            
            float2 uv = sampleUV - .5;
            
            UNITY_BRANCH if (_ScreenReprojection) {
                uv = rotate(uv, _ScreenRotationAngle * allAmp);
            }
            uv = lerp(uv, shift + multiplier * uv, allAmp) + .5;
            
            switch (_ScreenBoundaryHandling) {
                case BOUNDARYMODE_CLAMP:
                    /*
                     * technically not necessary since this should happen automatically,
                     * but I feel better about it by explicitly making sure it happens.
                     */
                    uv = saturate(uv);
                    break;
                case BOUNDARYMODE_REPEAT:
                    uv = frac(uv);
                    break;
            }
            
            if (_ScreenBoundaryHandling == BOUNDARYMODE_OVERLAY && (saturate(uv.x) != uv.x || saturate(uv.y) != uv.y)) {
                col[j] = color[j];
                col.a = max(col.a, color.a);
            } else {
                UNITY_BRANCH if (_ScreenReprojection) {
                    float4 testColor = UNITY_SAMPLE_SCREENSPACE_TEXTURE(SCREENTEXNAME, uv * float2(VRFix, 1));
                    col[j] = testColor[j];
                    col.a = max(col.a, testColor.a);
                } else {
                    float4 testColor = UNITY_SAMPLE_SCREENSPACE_TEXTURE(SCREENTEXNAME, uv);
                    col[j] = testColor[j];
                    col.a = max(col.a, testColor.a);
                }
            }
        }
        
        grabCol = lerp(grabCol, col, 1 / (float) (blurPass + 1));
    }
#endif

    //CANCERFREE
    float overlayMask = _OverlayMaskOpacity * tex2Dlod(_OverlayMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverlayMask), 0, 0)).r;
    float overallMask = _OverallEffectMaskOpacity * tex2Dlod(_OverallEffectMask, float4(.5+TRANSFORM_TEX((screenSpaceOverlayUV-.5), _OverallEffectMask), 0, 0)).r;
#ifdef CANCERFREE
    color.a *= _BlendAmount * overlayMask * overallMask * allAmp;

    // Blend in HUDOpacity
    color.rgb *= _HUDOpacity;
    color.a   *= _HUDOpacity;

    return float4(color.rgb, color.a);
#else
    float3 hsv = rgb2hsv(grabCol.rgb) * _HSVMultiply + _HSVAdd;
    hsv.r = frac(hsv.r);
    hsv.g = saturate(hsv.g);
    grabCol.rgb = lerp(grabCol.rgb, hsv2rgb(hsv), allAmp);
    
    // lol one-liner for exposure and shit, GOML
    if (_Burn) grabCol.rgb = lerp(grabCol.rgb, unboundedSmoothstep(_BurnLow, _BurnHigh, grabCol.rgb), allAmp);

    float finalScreenAlpha = grabCol.a;
    finalScreenAlpha *= _Color.a;
    finalScreenAlpha *= color.a;
    
    float3 finalScreenColor = lerp(grabCol, float4(1 - grabCol.rgb, grabCol.a), _InversionAmount * allAmp);
    finalScreenColor = blend(finalScreenColor, color.rgb, _BlendMode, _BlendAmount * color.a * overlayMask * allAmp);
    finalScreenColor = blend(finalScreenColor, _Color.rgb, _ScreenColorBlendMode, allAmp);
    float overallMaskFalloff = allAmp;
    if (_OverallEffectMaskBlendMode == BLENDMODE_NORMAL)  overallMaskFalloff = 1 - step(_MaxFalloff, effectDistance);
    finalScreenColor = blend(UNITY_SAMPLE_SCREENSPACE_TEXTURE(SCREENTEXNAME, i.projPos.xy / i.projPos.w).rgb, finalScreenColor, _OverallEffectMaskBlendMode, overallMask * overallMaskFalloff);
    
    // Blend in HUDOpacity
    finalScreenAlpha *= _HUDOpacity;
    finalScreenColor *= _HUDOpacity;

    return float4(finalScreenColor, finalScreenAlpha);
#endif
}

#endif
