// ncho LED eyes — the whole behaviour, as a function over the point-sampled LED map.
// Kept free of any lighting/pipeline code so the Poiyomi module (phase 2) can include it as-is.
// Layout, LED-map encoding and calibration are documented in docs/ncho-eyes.md; the map is
// baked by NchoEyeLedMapBaker.cs.

#ifndef NCHO_EYES_CORE_INCLUDED
#define NCHO_EYES_CORE_INCLUDED

struct NchoEyeInputs
{
    float lidL, lidR;         // VRCFT v2/EyeLidLeft/Right: 0 closed, 0.75 neutral, 1 wide
    float squintL, squintR;   // VRCFT v2/EyeSquintLeft/Right: 0..1
    float gazeX, gazeY;       // VRCFT v2/EyeX/EyeY: -1..1 (positive X = toward ncho's left, per in-editor testing)
    float trackingActive;     // VRCFT EyeTrackingActive: 0 => neutral static
};

struct NchoEyeSettings
{
    float swapSides;          // 0: texture-left half is ncho's left. 1: swapped.
    float upFlipL, upFlipR;   // 0: face-up is toward the chevron's texture-right end. 1: toward texture-left.
    float gazeXDeadzone;
    float gazeYMaxShift;      // texel columns the blink window moves at |gazeY| = 1 (an LED is 2)
    float lidOpenAt, lidStep;
    float squintOn, squintFull;
};

struct NchoEyeLed
{
    bool  isLed;
    bool  isNchoLeft;
    bool  isFront;
    int   chevronId;          // 0 texL rear, 1 texL front, 2 texR rear, 3 texR front
    int   offFrame;           // first blink frame (1..5) at which this LED is dark; 6 = never
    int   fromTexLeft;        // column index from the chevron's texture-left end
    int   fromTexRight;
    bool  bottomIsTexLeft;    // face-down end of this chevron is its texture-left end
};

int NchoEyeDecode(float v) { return (int)round(v * 255.0 / 8.0); } // byte = n * 8

NchoEyeLed NchoEyeDecodeTexel(float4 t, NchoEyeSettings s)
{
    NchoEyeLed led;
    int r = NchoEyeDecode(t.r);
    led.isLed = r > 0;
    led.chevronId = max(r - 1, 0);
    bool texLeft = led.chevronId < 2;
    led.isNchoLeft = (s.swapSides > 0.5) ? !texLeft : texLeft;
    led.isFront = (led.chevronId & 1) == 1;
    led.offFrame = NchoEyeDecode(t.g);
    led.fromTexLeft = NchoEyeDecode(t.b) - 1;
    led.fromTexRight = NchoEyeDecode(t.a) - 1;
    float upFlip = led.isNchoLeft ? s.upFlipL : s.upFlipR;
    led.bottomIsTexLeft = upFlip < 0.5;
    return led;
}

// The blink is a 1-D profile per chevron: a texel's off frame depends only on its texel column
// (not LED column: the blink art's last lit pair straddles two 2-texel LEDs).
// The baker stores it in the map's top-left corner: top-down row = chevron id, x = column.
int NchoEyeProfileOffFrame(Texture2D<float4> map, int chevronId, int column)
{
    uint w, h;
    map.GetDimensions(w, h);
    return NchoEyeDecode(map.Load(int3(column, (int)h - 1 - chevronId, 0)).g);
}

// Blink frame 0 (open) .. 5 (closed). Lid mirrors the old [ncho]_blink clip exactly. Squint
// raises the frame to 1 (squint < squintFull) or 2, like [ncho]_slutty_eyes — but stateless:
// the FX layer only *entered* squint while 0.5 < lid < 0.9 and then ignored lid until squint
// dropped below 0.3 (its lid exit condition can never be true). Here the eye simply takes
// whichever of the two is more closed.
int NchoEyeBlinkFrame(float lid, float squint, NchoEyeSettings s)
{
    int lidFrames = (int)round(s.lidOpenAt / s.lidStep);
    int frame = clamp(lidFrames - (int)floor(lid / s.lidStep + 1e-4), 0, 5);
    if (squint > s.squintOn)
        frame = max(frame, squint < s.squintFull ? 1 : 2);
    return frame;
}

bool NchoEyeLit(NchoEyeLed led, NchoEyeInputs i, NchoEyeSettings s, Texture2D<float4> map)
{
    if (!led.isLed) return false;
    if (i.trackingActive < 0.5) return led.isFront;

    // Gaze X: the side being looked toward swaps to its rear chevron.
    bool wantRear = led.isNchoLeft ? (i.gazeX > s.gazeXDeadzone) : (i.gazeX < -s.gazeXDeadzone);
    if (led.isFront == wantRear) return false;

    // Gaze Y moves the blink window along the strip: this LED shows the open/closed state of
    // the column `shift` below it. Columns shifted in from beyond the end are dark.
    int shift = (int)round(clamp(i.gazeY, -1, 1) * s.gazeYMaxShift);
    int src = led.bottomIsTexLeft ? led.fromTexLeft - shift : led.fromTexLeft + shift;
    if (src < 0 || src > led.fromTexLeft + led.fromTexRight) return false;

    float lid    = led.isNchoLeft ? i.lidL : i.lidR;
    float squint = led.isNchoLeft ? i.squintL : i.squintR;
    return NchoEyeBlinkFrame(lid, squint, s) < NchoEyeProfileOffFrame(map, led.chevronId, src);
}

// Debug visualisations (0 = off). Returns rgb; alpha = 1 when the debug view owns the pixel.
float4 NchoEyeDebug(int view, NchoEyeLed led, NchoEyeInputs i, NchoEyeSettings s, Texture2D<float4> map)
{
    if (view == 0 || !led.isLed) return 0;
    if (view == 1) // chevron: red = ncho-left, blue = ncho-right; bright = front, dim = rear
    {
        float b = led.isFront ? 1.0 : 0.3;
        return float4(led.isNchoLeft ? float3(b, 0, 0) : float3(0, 0, b), 1);
    }
    if (view == 2) // blink off-frame: dark = goes out first, white = stays lit longest
        return float4((led.offFrame / 6.0).xxx, 1);
    if (view == 3) // face-vertical: black at the bottom, green at the top
    {
        int fromBottom = led.bottomIsTexLeft ? led.fromTexLeft : led.fromTexRight;
        return float4(0, fromBottom / max(1.0, (float)(led.fromTexLeft + led.fromTexRight)), 0, 1);
    }
    if (view == 4) // lit mask
        return float4(NchoEyeLit(led, i, s, map) ? 1.0.xxx : 0.05.xxx, 1);
    return 0;
}

#endif
