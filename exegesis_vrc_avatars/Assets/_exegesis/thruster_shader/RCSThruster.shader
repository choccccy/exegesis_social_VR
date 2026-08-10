// RCS thruster shader for the ncho VRChat avatar.
//
// The whole point of this shader: the decision of how hard each thruster fires is
// made HERE, per thruster, from geometry — not baked into UV regions at author time.
// Skinning runs before the vertex stage, so v.vertex / v.normal arrive already posed.
// A thruster therefore knows its own CURRENT exhaust direction and its own CURRENT
// lever arm, which is what makes limb-mounted thrusters stay correct through any pose
// and makes outboard attitude thrusters work at all.
//
// The animator publishes commanded motion (see docs/rcs-thrusters.md); this shader
// solves the allocation.
Shader "exegesis/RCSThruster"
{
    Properties
    {
        [Header(Emission layers)]
        _CoreMask ("Core Mask", 2D) = "white" {}
        _GlowMask ("Glow Edge Mask", 2D) = "white" {}
        [HDR] _CoreColor ("Core Color", Color) = (1.0, 0.72, 0.45, 1)
        [HDR] _GlowColor ("Glow Color", Color) = (0.35, 0.55, 1.0, 1)
        _CoreThreshold ("Core Ignition Threshold", Range(0, 1)) = 0.35
        _GlowGamma ("Glow Gamma", Range(0.1, 4)) = 1.0

        [Header(RCS command   animator driven   do not rename)]
        _RCS_Vel ("Velocity", Vector) = (0,0,0,0)
        _RCS_VelSmoothed ("Velocity lagged", Vector) = (0,0,0,0)
        _RCS_AngVel ("Angular Velocity", Vector) = (0,0,0,0)
        _RCS_AngVelSmoothed ("Angular Velocity lagged", Vector) = (0,0,0,0)
        _RCS_ImuDeflect ("IMU Deflection", Vector) = (0,0,0,0)
        _RCS_Master ("Master Authority", Range(0, 1)) = 1

        [Header(Allocation)]
        _CoM ("Center of Mass object space", Vector) = (0, 0.9, 0, 0)
        _AccelGain ("Linear Accel Gain", Float) = 0.1
        _AngAccelGain ("Angular Accel Gain", Float) = 0.1
        // On: divide the accel estimate by frame time so brightness tracks motion
        // rather than the viewer's framerate. Gains are ~60x smaller with this on.
        // ToggleUI, not Toggle: Toggle would emit a _ACCELTIMECORRECT_ON shader keyword
        // that nothing declares, which lands in the material as an invalid keyword. The
        // value is read as a plain float, so no keyword is wanted.
        [ToggleUI] _AccelTimeCorrect ("Frame Rate Compensation", Float) = 1
        _SustainWeight ("Velocity Sustain", Range(0, 2)) = 0
        _Deadzone ("Deadzone", Range(0, 0.99)) = 0.05
        _Sharpness ("Throttle Sharpness", Range(0.1, 8)) = 1.5
        _MinThrottle ("Min Lit Throttle", Range(0, 1)) = 0

        [Header(Pendulum IMU   pitch and roll)]
        _ImuHeight ("IMU Lever Height", Float) = 0.45
        _ImuGain ("IMU Gain", Float) = 1
        _ImuLinearReject ("IMU Linear Rejection", Range(0, 2)) = 0
        _ImuClamp ("IMU Clamp", Float) = 4

        [Header(Flicker)]
        _FlickerAmp ("Flicker Amount", Range(0, 1)) = 0.12
        _FlickerSpeed ("Flicker Speed", Float) = 30

        [Header(Escape hatches)]
        // The Poiyomi prototype rendered double-sided, so this defaults to Off to match.
        // Throttle is unaffected either way: a back face still evaluates the outward
        // normal, so it fires with its front face rather than against it.
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 0
        [Enum(AvatarLocal, 0, World, 1)] _VelSpace ("Velocity Space", Float) = 0
        // Cones need Bitangent: a truncated cone's side normals point radially, not
        // along the axis, so SkinnedNormal lights half of every cone at once.
        [Enum(SkinnedNormal, 0, VertexColor, 1, TangentU, 2, BitangentV, 3, MixedByVertexRed, 4)] _ThrustDirSource ("Thrust Direction Source", Float) = 0
        // 0/1 rather than +1/-1: ShaderLab's [Enum] parser rejects a negative literal
        // and fails the whole Properties block with a parse error. Sign is applied in HLSL.
        [Enum(Forward, 0, Reversed, 1)] _ThrustDirFlip ("Reverse Tangent Frame", Float) = 0
        // Separate from the above on purpose: a plume diaphragm at the base of the cup has
        // its normal pointing back at the nozzle, opposite the bell that surrounds it.
        [Enum(Forward, 0, Reversed, 1)] _CapNormalFlip ("Reverse Cap Normal", Float) = 0

        [Header(Visibility groups)]
        // Membership rides in vertex GREEN: 0 = never gated, 0.5 = group 1 (x),
        // 1.0 = group 2 (y). Defaults all-on so unpainted geometry always fires.
        _GroupEnable ("Group Enable xy", Vector) = (1,1,1,1)
        [ToggleUI] _GroupGateEnabled ("Group Gating Enabled", Float) = 1

        [Header(Debug)]
        [Enum(Off, 0, ThrustDirection, 1, Throttle, 2, Groups, 3, Factors, 4)] _DebugView ("Debug View", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "DisableBatching" = "True"
        }

        // Additive is order-independent, so unlike the Poiyomi transparent prototype
        // this pays nothing for sorting and needs no depth write.
        Blend One One
        ZWrite Off
        ZTest LEqual
        Cull [_Cull]
        Lighting Off
        Fog { Mode Off }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #pragma target 3.0
            #include "RCS_core.cginc"
            ENDCG
        }
    }

    CustomEditor "Exegesis.RcsThruster.RCSThrusterInspector"
}
