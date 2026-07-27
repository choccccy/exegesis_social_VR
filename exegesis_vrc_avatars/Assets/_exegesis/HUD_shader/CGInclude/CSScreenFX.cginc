#ifndef CS_SCREENFX_CGINC
#define CS_SCREENFX_CGINC

// -----------------------------------------------------------------------------
// Sensor scanner: a first-person screen effect driven by real scene geometry
// (reconstructed DEPTH + world-space NORMAL), not the color image. The caller
// passes the per-pixel values the frag already reconstructs (depth, world pos,
// world normal); this composes the enabled modes into an opaque RGB "scan".
//
// Depth is world-provided (a world's realtime shadow light generates
// _CameraDepthTexture for free). Where there is no depth the reconstructed normal
// degenerates -> we guard it and the scan reads flat/dim ("no signal").
//
// Geometry edges use screen-space derivatives (fwidth) of depth/normal, so they
// cost no extra texture taps. Grab-free -> no GrabPass, no extra samplers.
// -----------------------------------------------------------------------------

float  _ScanEnabled;   // master toggle (read by frag)
float4 _ScanColor;
float  _ScanBrightness;

float  _ScanNormalShade;
float  _ScanNormalContrast;

float  _ScanEdges;
float4 _ScanEdgeColor;
float  _ScanEdgeDepthThreshold;
float  _ScanEdgeNormalThreshold;

float  _ScanRange;
float4 _ScanRangeNearColor;
float4 _ScanRangeFarColor;
float  _ScanRangeNear;
float  _ScanRangeFar;

float  _ScanContours;
float4 _ScanContourColor;
float  _ScanContourSpacing;

float  _ScanSweep;
float4 _ScanSweepColor;
float  _ScanSweepSpeed;
float  _ScanSweepRange;
float  _ScanSweepThickness;

// VRChat render-context global (0 = normal view, 1 = photo camera, 2 = screenshot).
// Set by VRChat; defaults to 0 elsewhere. Used by frag to gate the scan out of cameras.
float _VRChatCameraMode;

// Compose the enabled scanner modes.
//   depth      : corrected linear eye depth (metres) of the scene behind this pixel
//   worldPos   : reconstructed world-space position of that surface
//   worldNormal: reconstructed world-space normal (may be degenerate w/o depth)
//   viewDir    : normalized surface -> camera direction
float3 csScanCompose(float depth, float3 worldPos, float3 worldNormal, float3 viewDir)
{
    // Guard the normal: cross(ddx,ddy) is ~0 (or NaN) where there is no depth.
    float nlen = length(worldNormal);
    float3 n = (nlen > 1e-4) ? worldNormal / nlen : float3(0.0, 0.0, 1.0);

    float facing = saturate(dot(n, viewDir)); // 1 = face-on, 0 = grazing/silhouette

    // --- base / normal shade -------------------------------------------------
    float3 col;
    if (_ScanNormalShade > 0.5)
        col = _ScanColor.rgb * pow(facing, _ScanNormalContrast);
    else
        col = _ScanColor.rgb * 0.15; // dim base so other modes have something to sit on

    // --- range tint ----------------------------------------------------------
    if (_ScanRange > 0.5)
    {
        float t = saturate((depth - _ScanRangeNear) / max(_ScanRangeFar - _ScanRangeNear, 1e-3));
        float3 rangeCol = lerp(_ScanRangeNearColor.rgb, _ScanRangeFarColor.rgb, t);
        float formMul = (_ScanNormalShade > 0.5) ? (0.35 + 0.65 * facing) : 1.0;
        col = lerp(col, rangeCol * formMul, 0.85);
    }

    // --- depth contour rings -------------------------------------------------
    if (_ScanContours > 0.5)
    {
        float phase = depth / max(_ScanContourSpacing, 1e-3);
        float ring  = frac(phase);
        float aa    = max(fwidth(phase), 1e-4);
        float contourLine = 1.0 - smoothstep(0.0, aa * 1.5, min(ring, 1.0 - ring));
        col += _ScanContourColor.rgb * contourLine;
    }

    // --- geometry edges (silhouettes + creases) ------------------------------
    if (_ScanEdges > 0.5)
    {
        float depthEdge  = fwidth(depth) * _ScanEdgeDepthThreshold;
        float normalEdge = length(fwidth(worldNormal)) * _ScanEdgeNormalThreshold;
        float e = saturate(max(depthEdge, normalEdge));
        col = lerp(col, _ScanEdgeColor.rgb, e);
    }

    // --- animated scan sweep (a thin band at an advancing distance) ----------
    if (_ScanSweep > 0.5)
    {
        float sweepPos = fmod(_Time.y * _ScanSweepSpeed, max(_ScanSweepRange, 1e-3));
        float band = 1.0 - smoothstep(0.0, max(_ScanSweepThickness, 1e-3), abs(depth - sweepPos));
        col += _ScanSweepColor.rgb * band;
    }

    return col * _ScanBrightness;
}

#endif
