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
    // x = final throttle, y = flicker phase, z = group index, w = raw allocation
    // before master and gate. All constant across a flat-shaded nozzle face, so
    // interpolation costs nothing.
    float4 drive  : TEXCOORD2;
    float3 dbgDir : TEXCOORD3;  // posed thrust direction, for _DebugView
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

    float3 dir;
    if      (_ThrustDirSource < 0.5) dir = capNormal;            // 0 - flat nozzle discs
    else if (_ThrustDirSource < 1.5) dir = fromColor;            // 1 - baked vertex colour
    else if (_ThrustDirSource < 2.5) dir = v.tangent.xyz;        // 2 - axis along U
    else if (_ThrustDirSource < 3.5) dir = bitangent;            // 3 - axis along V (cones)
    // 4 - mixed geometry. A thruster made of a cone BELL plus a flat cap needs both:
    // the bell's axis is its bitangent, but a flat cap's tangent and bitangent both lie
    // in its own plane, so no UV layout can ever point them along its normal - for the
    // cap the axis simply IS the normal. Vertex colour red selects between them, so one
    // thruster resolves to one direction across all of its faces.
    //   R = 1 (white, the default when a mesh has no colours) -> bitangent, for bells
    //   R = 0 (painted)                                       -> normal,    for caps
    // Defaulting white to the bell case means only the caps need painting.
    else                             dir = lerp(capNormal, bitangent, v.color.r);

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
float rcsThrottle(float3 posOS, float3 exhaustOS)
{
    float3 linA = rcsLinearAccel();
    float3 angA = rcsAngularAccel(linA);

    float3 thrust = -normalize(exhaustOS);
    float3 lever  = posOS - _CoM.xyz;
    float3 torque = cross(lever, thrust);

    float u = dot(thrust, linA) + dot(torque, angA);

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
// Visibility groups
// ---------------------------------------------------------------------------

// Some thrusters must go quiet regardless of what the allocation says - the Props
// plumes when the backpack is stowed, and the Body thrusters the backpack covers when
// it is deployed. Poiyomi's UV tile dissolve hides the prop GEOMETRY but not this
// material, so without a gate those plumes would light up out of thin air.
//
// Membership rides in vertex GREEN as levels rather than one channel per group, so
// blue stays free for the planned translation-vs-rotation weighting.
//
// ONE wide middle band, on purpose. Vertex colours may or may not be colour-space
// converted on import, and the direction of any conversion is unknown - an authored 0.5
// can arrive as 0.214 (sRGB->linear) or 0.735 (linear->sRGB). A single band spanning
// 0.1..0.9 swallows every one of those, while 0 and 1 are fixed points under any
// conversion. Splitting the middle into two narrower bands would put an authored value
// within a whisker of a boundary, so two groups is the honest maximum for one channel.
// Confirm with _DebugView 3 rather than assuming.
//
// Note a mesh with NO colour attribute reports WHITE, so unpainted geometry lands in
// group 2, not group 0. That is survivable here only because thruster_backpack defaults
// to on, which enables group 2 - but paint any new thruster geometry rather than relying
// on it, or it will vanish the moment the backpack is stowed.
float rcsGroupGate(float g)
{
    // Off-switch as a material property rather than commented-out code: it can be
    // flipped without a recompile, and the golden suite can keep exercising the real
    // logic instead of a stub. Currently 0 on thrusters.mat while the velocity path is
    // debugged - though the gate was verified NOT to be the cause of thrusters not
    // firing, since the renderer census read master 1.00 and grp (1,1) on both Body and
    // Props, meaning it was already fully open.
    if (_GroupGateEnabled < 0.5) return 1.0;

    if (g < 0.1) return 1.0;              // group 0 - authored 0, never gated
    if (g < 0.9) return _GroupEnable.x;   // group 1 - authored 0.5
    return _GroupEnable.y;                // group 2 - authored 1, and unpainted white
}

// Matching index for the debug view only.
float rcsGroupIndex(float g)
{
    if (g < 0.1) return 0.0;
    if (g < 0.9) return 1.0;
    return 2.0;
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
    float alloc = rcsThrottle(v.vertex.xyz, exhaust);
    float gate  = rcsGroupGate(v.color.g);
    o.drive  = float4(alloc * _RCS_Master * gate,
                      rcsFlickerPhase(v.vertex.xyz),
                      rcsGroupIndex(v.color.g),
                      alloc);
    o.dbgDir = normalize(exhaust);
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
        if (_DebugView < 1.5) return float4(i.dbgDir * 0.5 + 0.5, 0.0);
        // 2 - raw throttle, before masks and flicker.
        if (_DebugView < 2.5) return float4(u, u, u, 0.0);
        // 3 - visibility group, as three flat colours. This is how you confirm the
        // green paint landed in the intended buckets, rather than inferring it from
        // behaviour - which matters because the colour-space conversion is unknown.
        float gi = i.drive.z;
        if (_DebugView < 3.5)
        {
            if (gi < 0.5) return float4(0.6, 0.6, 0.6, 0.0);   // group 0 - never gated
            if (gi < 1.5) return float4(0.0, 1.0, 0.0, 0.0);   // group 1 - authored G 0.5
            return float4(0.0, 0.4, 1.0, 0.0);                 // group 2 - authored G 1.0
        }

        // 4 - the three factors of throttle, one per channel. Throttle is
        // allocation * master * gate, so when nothing fires the only question is which
        // of the three is zero, and staring at a black avatar cannot tell you.
        //   RED   = _RCS_Master        (dark red -> the master toggle is off)
        //   GREEN = group gate         (dark green -> this group is gated off)
        //   BLUE  = raw allocation     (dark blue -> no commanded motion reaches it)
        // White-ish means all three are live. Black means all three are dead.
        float gate = (gi < 0.5) ? 1.0 : ((gi < 1.5) ? _GroupEnable.x : _GroupEnable.y);
        return float4(saturate(_RCS_Master), saturate(gate), saturate(i.drive.w), 0.0);
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
