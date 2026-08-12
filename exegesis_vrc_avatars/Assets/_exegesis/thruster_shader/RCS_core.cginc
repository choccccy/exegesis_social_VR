#ifndef EXEGESIS_RCS_CORE_INCLUDED
#define EXEGESIS_RCS_CORE_INCLUDED

// Allocation math + emission composite for Shader "exegesis/RCSThruster".
// See docs/rcs-thrusters.md for the system as a whole and for the animator side.

#include "UnityCG.cginc"

sampler2D _CoreMask;  float4 _CoreMask_ST;
sampler2D _GlowMask;  float4 _GlowMask_ST;
float4 _CoreColor;
float4 _GlowColor;
float  _CoreThreshold;
float  _GlowGamma;

// Animation contract - driven by name from ncho_fx.controller. Renaming any of
// these silently breaks the avatar (see docs/project.md).
float4 _RCS_Vel;
float4 _RCS_VelSmoothed;
float4 _RCS_AngVel;
float4 _RCS_AngVelSmoothed;
float4 _RCS_ImuDeflect;
float  _RCS_Master;

float4 _CoM;
float  _AccelGain;
float  _AngAccelGain;
float  _SustainWeight;
float  _Deadzone;
float  _Sharpness;
float  _MinThrottle;
float  _AccelTimeCorrect;

float  _ImuHeight;
float  _ImuGain;
float  _ImuLinearReject;
float  _ImuClamp;

float  _FlickerAmp;
float  _FlickerSpeed;

// Declared float, not int: BiRP constant-buffer packing of integer uniforms is a
// known footgun, and the [Enum] drawer works identically on a Float property.
float  _VelSpace;
float  _ThrustDirSource;
float  _ThrustDirFlip;
float  _CapNormalFlip;
float  _BellFlare;
float  _BellFlareProps;
float  _RotThrusterLinGain;
float  _TransThrusterRotGain;
float  _DebugView;
float4 _GroupEnable;
float  _GroupGateEnabled;

struct appdata
{
    float4 vertex  : POSITION;
    float3 normal  : NORMAL;
    float4 tangent : TANGENT;
    float4 color   : COLOR;
    float2 uv      : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float4 pos    : SV_POSITION;
    float2 uvCore : TEXCOORD0;
    float2 uvGlow : TEXCOORD1;
    // x = final throttle, y = flicker phase, z = RAW vertex green, w = raw allocation
    // before master and gate. All constant across a flat-shaded nozzle face, so
    // interpolation costs nothing.
    float4 drive  : TEXCOORD2;
    float4 dbgDir : TEXCOORD3;  // xyz = posed thrust direction, w = rotation bias
    UNITY_VERTEX_OUTPUT_STEREO
};

// ---------------------------------------------------------------------------
// Command vectors
// ---------------------------------------------------------------------------

// VelocityX/Y/Z are believed to be player-local, which is why stock locomotion
// blend trees work. _VelSpace is the escape hatch if that turns out to be wrong;
// note the inverse matrix carries inverse scale, which the gains absorb.
float3 rcsToObjectSpace(float3 v)
{
    return (_VelSpace < 0.5) ? v : mul((float3x3)unity_WorldToObject, v);
}

// Frame-rate compensation.
//
// rcs_smooth applies its lag once per animator UPDATE, not per second - an animator
// has no delta time to work with. So under a constant acceleration a, the steady-state
// difference between live and lagged settles at  a * dt * L/(1-L)  where L is the lag
// constant. That dt means the reading scales with frame time: at 90fps the same real
// acceleration produces half the value it does at 45fps, and thruster brightness would
// track the user's framerate rather than their motion. Multiplying by 1/dt cancels it.
//
// Uses SMOOTHED delta time (unity_DeltaTime.w = 1/smoothDeltaTime) rather than the raw
// frame delta: dividing by a per-frame-jittery dt would convert frame-pacing noise
// straight into brightness flicker.
//
// This fixes the pulse AMPLITUDE. The pulse DURATION still varies with framerate,
// because the lag's time constant is -dt/ln(L) and there is no way to feed dt back into
// the animator. Amplitude is the part you actually see.
//
// Note the IMU path is deliberately not corrected - PhysBones simulate against real
// time, so pitch/roll never had this problem.
float rcsTimeCorrection()
{
    float invDt = max(unity_DeltaTime.w, 1.0);
    return lerp(1.0, invDt, saturate(_AccelTimeCorrect));
}

// Acceleration is the difference between the live signal and a lagged copy of
// itself; the animator supplies both and the subtraction happens here, so the
// animator never needs a difference operation.
float3 rcsLinearAccel()
{
    float3 vel = rcsToObjectSpace(_RCS_Vel.xyz);
    float3 lag = rcsToObjectSpace(_RCS_VelSmoothed.xyz);
    // Sustain is a velocity follow, not a derivative, so it is NOT time-corrected.
    return (vel - lag) * (_AccelGain * rcsTimeCorrection()) + vel * _SustainWeight;
}

// Yaw comes from AngularY, which is inherently avatar-local and so is never
// space-converted. Pitch and roll have no VRChat parameter at all and come from
// the pendulum: it sees a_linear + (alpha x r), and with r = (0, h, 0) the
// residual after removing a_linear resolves straight into roll and pitch.
float3 rcsAngularAccel(float3 linAccel)
{
    // Yaw comes through the same per-frame lag as the linear axes, so it needs the
    // same frame-time correction.
    float3 a = (_RCS_AngVel.xyz - _RCS_AngVelSmoothed.xyz) * (_AngAccelGain * rcsTimeCorrection());

    // NEGATED, and it matters: a pendulum lags. Accelerate the anchor toward +X and the
    // tip falls behind toward -X, so raw deflection points OPPOSITE the acceleration.
    // _RCS_ImuDeflect is wired positionally (+X receiver drives the positive side), so
    // the flip happens here, before anything else touches it. Without it the rejection
    // below would add the linear component instead of cancelling it.
    //
    // Clamp the raw reading first: teleports and station mounts spike the pendulum hard
    // enough to swamp the rejection term otherwise.
    float3 imu = clamp(-float3(_RCS_ImuDeflect.x, 0, _RCS_ImuDeflect.z) * _ImuGain,
                       -_ImuClamp, _ImuClamp);
    imu -= linAccel * _ImuLinearReject;

    float invH = 1.0 / max(1e-3, _ImuHeight);
    a.z += -imu.x * invH;   // roll
    a.x +=  imu.z * invH;   // pitch
    return a;
}

// ---------------------------------------------------------------------------
// Visibility groups
// ---------------------------------------------------------------------------

// Authored green -> group index.
//
// Measured, not assumed: _DebugView 6 showed this pipeline applies NO colour-space
// conversion to vertex colour. An authored 1.0 arrives as 1.0, 0 as 0, and 0.5 as 0.498
// - byte 127/255, integer quantisation only. Evenly spaced levels are therefore safe,
// and every value below sits about 0.125 from its nearest boundary.
//
// Index 3 is deliberately out of numeric order. Keeping 0.5 -> 1 and 1.0 -> 2 preserves
// what the existing paint already means, so adding the thigh group repaints nothing. Both
// Props levels (0.25 and 1.0) land at index >= 2, which is what the flare selector tests,
// so they keep getting the Props flare automatically.
//
//   0.00 -> 0   never gated
//   0.25 -> 3   thigh packs              _GroupEnable.z
//   0.50 -> 1   Body back thrusters      _GroupEnable.x
//   1.00 -> 2   backpack plumes          _GroupEnable.y   (also unpainted white)
float rcsGroupIndex(float g)
{
    if (g < 0.125) return 0.0;
    if (g < 0.375) return 3.0;
    if (g < 0.750) return 1.0;
    return 2.0;
}

// Some thrusters must go quiet regardless of what the allocation says - the Props
// plumes when the backpack is stowed, and the Body thrusters the backpack covers when
// it is deployed. Poiyomi's UV tile dissolve hides the prop GEOMETRY but not this
// material, so without a gate those plumes would light up out of thin air.
//
// Membership rides in vertex GREEN as levels rather than one channel per group, so
// blue stays free for the translation-vs-rotation weighting. Band edges are above, in
// rcsGroupIndex; they are evenly spaced because the conversion question was MEASURED
// and came back "no conversion" - see the note there, and re-measure with _DebugView 6
// if the FBX export settings or Unity's colour space ever change.
//
// FOOTGUN: a mesh with NO colour attribute reports WHITE, so unpainted thruster geometry
// lands in group 2 - which is gated by wings_deployed, off by default. Unpainted geometry
// is therefore DARK, not ungated. Paint every thruster mesh explicitly. (The group_gated
// golden state exists to keep this from being forgotten a fourth time.)
float rcsGroupGate(float g)
{
    // Off-switch as a material property rather than commented-out code: it can be flipped
    // without a recompile, so gating can be ruled out as the cause of a dark avatar in one
    // click, and the golden suite keeps exercising the real logic instead of a stub. Ships
    // at 1; NeutralDefaultTests pins that, since 0 here silently disables every group.
    if (_GroupGateEnabled < 0.5) return 1.0;

    float gi = rcsGroupIndex(g);
    if (gi < 0.5) return 1.0;             // 0 - never gated
    if (gi < 1.5) return _GroupEnable.x;  // 1 - Body back thrusters, under the packs
    if (gi < 2.5) return _GroupEnable.y;  // 2 - backpack plumes, with the wings
    return _GroupEnable.z;                // 3 - thigh packs
}


// ---------------------------------------------------------------------------
// Per-thruster allocation
// ---------------------------------------------------------------------------

// Which way does this thruster's exhaust point, in posed object space?
//
// The obvious answer - the surface normal - is only right for a FLAT nozzle disc.
// These thrusters are truncated cones, and a cone's side wall normals point radially
// outward, perpendicular to the axis. Using them makes the half of each cone facing
// away from the commanded acceleration light up, on every cone at once, which looks
// like "half of everything is firing" no matter what the masks do.
//
// The cone axis is instead recoverable from the tangent frame. The masks run their
// gradient along the cone's length, so V is the axial UV direction, which makes the
// BITANGENT - the direction of increasing V - the axis. Unity skins tangents along
// with normals, so this stays correct through any pose, exactly like the normal did.
float3 rcsExhaustDir(appdata v)
{
    float3 bitangent = cross(v.normal, v.tangent.xyz) * v.tangent.w;
    float3 fromColor = v.color.rgb * 2.0 - 1.0;   // static: never skinned, rest pose only

    // Two knobs, deliberately factored as RELATIVE and GLOBAL rather than one per source.
    //
    // _CapNormalFlip is relative: it only makes the diaphragm agree with the bell around
    // it, since the two derive their axis from different quantities whose signs need not
    // match.
    //
    // _ThrustDirFlip is global: it reverses the whole resolved direction, after the source
    // has been picked. That is the knob for "everything fires backwards", and because it
    // applies last it flips bell and diaphragm together, so their agreement survives.
    float capSign    = (_CapNormalFlip < 0.5) ? 1.0 : -1.0;
    float globalSign = (_ThrustDirFlip < 0.5) ? 1.0 : -1.0;
    float3 capNormal = v.normal * capSign;

    // Flare correction. A truncated cone's wall is SLANTED, so V - and therefore the
    // bitangent - runs along the slant rather than the axis, tilted outward by the flare
    // half-angle. Crucially each facet tilts along its OWN radial direction, so around
    // the circumference the facets leaning toward the commanded acceleration score a
    // larger dot product than those leaning away, and the cone lights brightest on the
    // side facing the thrust instead of uniformly.
    //
    // The true axis is recoverable exactly, because for half-angle a:
    //     axis = cos(a) * bitangent + sin(a) * normal
    // Sign is left to the user via a signed angle rather than guessed, since which way
    // the correction leans depends on the winding and the UV direction.
    // Body and Props bells are modelled with different flare angles, so the correction
    // needs two values. It selects on GROUP 2 membership, which piggybacks on the green
    // paint purely because "group 2" and "the Props plumes" are currently the same set of
    // geometry - it costs no extra authoring. If those two ever stop coinciding, move the
    // selector to vertex alpha, which is still free.
    float flareDeg = (rcsGroupIndex(v.color.g) >= 1.5) ? _BellFlareProps : _BellFlare;
    float fa = radians(flareDeg);
    float3 bellDir = bitangent * cos(fa) + v.normal * sin(fa);

    float3 dir;
    if      (_ThrustDirSource < 0.5) dir = capNormal;            // 0 - flat nozzle discs
    else if (_ThrustDirSource < 1.5) dir = fromColor;            // 1 - baked vertex colour
    else if (_ThrustDirSource < 2.5) dir = v.tangent.xyz;        // 2 - axis along U
    else if (_ThrustDirSource < 3.5) dir = bellDir;              // 3 - axis along V (cones)
    // 4 - mixed geometry. A thruster made of a cone BELL plus a flat cap needs both:
    // the bell's axis is its bitangent, but a flat cap's tangent and bitangent both lie
    // in its own plane, so no UV layout can ever point them along its normal - for the
    // cap the axis simply IS the normal. Vertex colour red selects between them, so one
    // thruster resolves to one direction across all of its faces.
    //   R = 1 (white, the default when a mesh has no colours) -> bitangent, for bells
    //   R = 0 (painted)                                       -> normal,    for caps
    // Defaulting white to the bell case means only the caps need painting.
    else                             dir = lerp(capNormal, bellDir, v.color.r);

    return dir * globalSign;
}

// The core of the system.
//   thrust  - reaction force, opposite the exhaust
//   lever   - displacement from the centre of mass
//   torque  - what firing this thruster would rotate the avatar about
// Dotting each against its commanded counterpart gives translation authority and
// rotation authority. A thruster far off-axis has a large lever arm, so it answers
// strongly to commanded rotation and weakly to translation - exactly what a small
// outboard attitude thruster should do, with no per-thruster authoring.
// rotBias comes from vertex BLUE: 0 = translation thruster, 1 = rotation thruster.
//
// This biases which job a thruster serves. It reinforces what the allocation already
// does rather than fighting it - rotation authority is dot(cross(lever, thrust), angA),
// so the wingtips, wrists and ankles have the largest lever arms and the strongest
// torque terms before any weighting is applied.
//
// The two gains are how much authority a thruster keeps in the OTHER job. Both default
// to 0, giving a hard split; raise either if the separation reads too stark, since a
// real RCS quad does contribute to both.
//
// Unpainted geometry reports vertex WHITE, so blue arrives as 1 and everything becomes
// rotation-only. Paint new thruster meshes explicitly.
float rcsThrottle(float3 posOS, float3 exhaustOS, float rotBias)
{
    float3 linA = rcsLinearAccel();
    float3 angA = rcsAngularAccel(linA);

    float3 thrust = -normalize(exhaustOS);
    float3 lever  = posOS - _CoM.xyz;
    float3 torque = cross(lever, thrust);

    float wLin = lerp(1.0, _RotThrusterLinGain, rotBias);
    float wRot = lerp(_TransThrusterRotGain, 1.0, rotBias);
    float u = dot(thrust, linA) * wLin + dot(torque, angA) * wRot;

    u = saturate((u - _Deadzone) / max(1e-4, 1.0 - _Deadzone));
    u = pow(u, max(1e-3, _Sharpness));
    // Optional floor so a thruster that lights at all lights visibly. Default 0.
    u = (u > 0.0) ? lerp(_MinThrottle, 1.0, u) : 0.0;

    // Returns the ALLOCATION alone. Master authority and the group gate are applied by
    // the caller so that _DebugView 4 can show the three factors separately - when
    // nothing fires, the whole question is which of them is zero.
    return u;
}

// ---------------------------------------------------------------------------
// Flicker
// ---------------------------------------------------------------------------

// Thruster islands share UVs, so UV cannot identify a thruster. A continuous hash
// of object-space position differs per island and drifts imperceptibly as limbs
// move - unlike a quantised hash, which would pop as it crossed buckets.
float rcsFlickerPhase(float3 posOS)
{
    return dot(posOS, float3(12.9898, 78.233, 37.719));
}

float rcsFlicker(float phase)
{
    // Two incommensurate sines: no texture tap, no visible repeat.
    float t = _Time.y * _FlickerSpeed;
    float n = sin(t + phase) * 0.6 + sin(t * 1.7 + phase * 2.3) * 0.4;
    return 1.0 + n * _FlickerAmp;
}

// ---------------------------------------------------------------------------
// Stages
// ---------------------------------------------------------------------------

v2f vert(appdata v)
{
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(v2f, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    float3 exhaust = rcsExhaustDir(v);

    o.pos    = UnityObjectToClipPos(v.vertex);
    o.uvCore = TRANSFORM_TEX(v.uv, _CoreMask);
    o.uvGlow = TRANSFORM_TEX(v.uv, _GlowMask);
    // The group gate scales the finished allocation, so it is unaffected by the deadzone
    // and sharpness shaping, and fades rather than pops if the toggle blends.
    float alloc = rcsThrottle(v.vertex.xyz, exhaust, v.color.b);
    float gate  = rcsGroupGate(v.color.g);
    // Raw green rather than the resolved index: the index is a pure function of it, so
    // the fragment stage can recover it, and passing the raw value additionally allows
    // _DebugView 6 to report what the colour-space conversion actually did to the paint.
    o.drive  = float4(alloc * _RCS_Master * gate,
                      rcsFlickerPhase(v.vertex.xyz),
                      v.color.g,
                      alloc);
    o.dbgDir = float4(normalize(exhaust), v.color.b);
    return o;
}

float4 frag(v2f i) : SV_Target
{
    float u = i.drive.x;

    // Debug views. Worth having: when a thruster fires wrongly the emission alone
    // cannot tell you whether the DIRECTION or the COMMAND is at fault, and guessing
    // between the two is how the cone-normal bug survived as long as it did.
    if (_DebugView > 0.5)
    {
        // 1 - thrust direction as RGB. Every cone should read as ONE flat colour,
        //     and two cones pointing opposite ways should be complementary. A cone
        //     showing a rainbow around its circumference means the direction source
        //     is picking up radial surface normals rather than the axis.
        if (_DebugView < 1.5) return float4(i.dbgDir.xyz * 0.5 + 0.5, 0.0);
        // 2 - raw throttle, before masks and flicker.
        if (_DebugView < 2.5) return float4(u, u, u, 0.0);
        // 3 - visibility group, as three flat colours. This is how you confirm the
        // green paint landed in the intended buckets, rather than inferring it from
        // behaviour - which matters because the colour-space conversion is unknown.
        float gi = rcsGroupIndex(i.drive.z);
        if (_DebugView < 3.5)
        {
            if (gi < 0.5) return float4(0.6, 0.6, 0.6, 0.0);   // 0 - never gated
            if (gi < 1.5) return float4(0.0, 1.0, 0.0, 0.0);   // 1 - authored G 0.5
            if (gi < 2.5) return float4(0.0, 0.4, 1.0, 0.0);   // 2 - authored G 1.0
            return float4(1.0, 0.0, 0.8, 0.0);                 // 3 - authored G 0.25
        }

        // 4 - the three factors of throttle, one per channel. Throttle is
        // allocation * master * gate, so when nothing fires the only question is which
        // of the three is zero, and staring at a black avatar cannot tell you.
        //   RED   = _RCS_Master        (dark red -> the master toggle is off)
        //   GREEN = group gate         (dark green -> this group is gated off)
        //   BLUE  = raw allocation     (dark blue -> no commanded motion reaches it)
        // White-ish means all three are live. Black means all three are dead.
        // Must honour _GroupGateEnabled exactly as rcsGroupGate does, or the readout
        // reports a group as gated off while the throttle is actually using an open
        // gate - a debug view that disagrees with the thing it is describing is worse
        // than none.
        if (_DebugView < 4.5)
        {
            float gate = rcsGroupGate(i.drive.z);
            return float4(saturate(_RCS_Master), saturate(gate), saturate(i.drive.w), 0.0);
        }

        if (_DebugView < 5.5)
        {
            // 5 - translation vs rotation bias from vertex blue. Orange = translation
            // (blue 0), cyan = rotation (blue 1), so the split is obvious at a glance and
            // the paint can be confirmed without inferring it from firing behaviour.
            float rb = saturate(i.dbgDir.w);
            return float4(lerp(1.0, 0.0, rb), lerp(0.5, 0.8, rb), lerp(0.0, 1.0, rb), 0.0);
        }

        // 6 - CALIBRATION. Raw vertex green in eight bands of 0.125, so the value the
        // shader actually receives can be read off directly. Adding a fourth group level
        // needs this: an authored 0.35 can arrive as 0.1, 0.35 or 0.63 depending on
        // which way the pipeline converts vertex colour, and that spread is wider than
        // any band would be - so the boundaries cannot be chosen without measuring first.
        //
        // Paint is already in place to calibrate against: the back thrusters were
        // authored at 0.5. Whichever band they land in tells us the conversion, and the
        // boundaries for four levels follow from it.
        //
        //   0.000-0.125 dark grey     0.500-0.625 green
        //   0.125-0.250 red           0.625-0.750 cyan
        //   0.250-0.375 orange        0.750-0.875 blue
        //   0.375-0.500 yellow        0.875-1.000 white
        float g = saturate(i.drive.z);
        if (g < 0.125) return float4(0.15, 0.15, 0.15, 0.0);
        if (g < 0.250) return float4(1.00, 0.00, 0.00, 0.0);
        if (g < 0.375) return float4(1.00, 0.45, 0.00, 0.0);
        if (g < 0.500) return float4(1.00, 1.00, 0.00, 0.0);
        if (g < 0.625) return float4(0.00, 1.00, 0.00, 0.0);
        if (g < 0.750) return float4(0.00, 1.00, 1.00, 0.0);
        if (g < 0.875) return float4(0.00, 0.30, 1.00, 0.0);
        return float4(1.00, 1.00, 1.00, 0.0);
    }

    // Two layers with different ramps: the core snaps in hot past its ignition
    // threshold, the halo swells smoothly. This is the two-emission look from the
    // Poiyomi prototype, now driven by throttle instead of by hand.
    float coreRamp = smoothstep(_CoreThreshold, max(_CoreThreshold + 1e-3, 1.0), u);
    float core = tex2D(_CoreMask, i.uvCore).r * coreRamp;
    float glow = tex2D(_GlowMask, i.uvGlow).r * pow(u, max(1e-3, _GlowGamma));

    float3 rgb = (_CoreColor.rgb * core + _GlowColor.rgb * glow) * rcsFlicker(i.drive.y);

    // Additive: alpha is left alone so this never disturbs the frame's alpha.
    return float4(max(rgb, 0.0), 0.0);
}

#endif // EXEGESIS_RCS_CORE_INCLUDED
