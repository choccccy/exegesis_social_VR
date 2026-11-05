// Standalone prototype of ncho's LED eye behaviour, for fast iteration without rebuilding /
// relocking Poiyomi. Albedo + simple lighting + LED emission. The behaviour itself lives in
// ncho_eyes_core.cginc and is what gets ported into the Poiyomi module. See docs/ncho-eyes.md.
Shader "Exegesis/ncho LED Eyes (proto)"
{
    Properties
    {
        [Header(Surface)]
        _MainTex ("Albedo", 2D) = "white" {}
        _Color ("Albedo Tint", Color) = (1,1,1,1)

        [Header(LED Emission)]
        [NoScaleOffset] _LedMap ("LED Map (baked)", 2D) = "black" {}
        [NoScaleOffset] _EmissionMask ("Emission Mask (optional)", 2D) = "white" {}
        [HDR] _EmissionColor ("Emission Color", Color) = (0.7187703, 0.57075465, 1, 1)
        _EmissionStrength ("Emission Strength", Float) = 1

        [Header(Inputs  driven by FX from VRCFT)]
        _EyeLidL ("Eye Lid Left (v2/EyeLidLeft)", Range(0, 1)) = 1
        _EyeLidR ("Eye Lid Right (v2/EyeLidRight)", Range(0, 1)) = 1
        _EyeSquintL ("Eye Squint Left (v2/EyeSquintLeft)", Range(0, 1)) = 0
        _EyeSquintR ("Eye Squint Right (v2/EyeSquintRight)", Range(0, 1)) = 0
        _EyeX ("Gaze X (v2/EyeX)", Range(-1, 1)) = 0
        _EyeY ("Gaze Y (v2/EyeY)", Range(-1, 1)) = 0
        [ToggleUI] _EyeTrackingActive ("Eye Tracking Active", Float) = 0

        [Header(Debug inputs  override the above when enabled)]
        [ToggleUI] _DbgOverride ("Use Debug Inputs", Float) = 0
        [ToggleUI] _DbgLinkEyes ("Link Eyes (Right follows Left)", Float) = 1
        _DbgLidL ("Lid Left", Range(0, 1)) = 0.75
        _DbgSquintL ("Squint Left", Range(0, 1)) = 0
        _DbgLidR ("Lid Right", Range(0, 1)) = 0.75
        _DbgSquintR ("Squint Right", Range(0, 1)) = 0
        _DbgX ("Gaze X", Range(-1, 1)) = 0
        _DbgY ("Gaze Y", Range(-1, 1)) = 0
        [ToggleUI] _DbgTrackingActive ("Tracking Active", Float) = 1
        // Chevron: red = ncho-left, blue = ncho-right, bright = front. Face Vertical: green = up.
        [Enum(Off,0,Chevron,1,Blink Off Frame,2,Face Vertical,3,Lit Mask,4)] _DebugView ("Debug View", Float) = 0

        [Header(Calibration)]
        [ToggleUI] _SwapSides ("Swap Sides (texture-left is ncho right)", Float) = 0
        [ToggleUI] _UpFlipL ("Flip Up Direction  Left", Float) = 0
        [ToggleUI] _UpFlipR ("Flip Up Direction  Right", Float) = 1
        _GazeXDeadzone ("Gaze X Deadzone", Range(0, 1)) = 0.25
        _GazeYMaxShift ("Gaze Y Max Shift (texels, 2 per LED)", Range(0, 8)) = 2

        [Header(Blink tuning  defaults match the old FX blink clips)]
        _LidOpenAt ("Lid Fully Open At", Range(0, 1)) = 0.5
        _LidStep ("Lid Step Per Frame", Range(0.01, 0.25)) = 0.1
        _SquintOn ("Squint On", Range(0, 1)) = 0.3
        _SquintFull ("Squint Full", Range(0, 1)) = 0.4
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }

        Pass
        {
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma target 4.5
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "ncho_eyes_core.cginc"

            sampler2D _MainTex; float4 _MainTex_ST;
            float4 _Color;
            Texture2D<float4> _LedMap; float4 _LedMap_TexelSize;
            sampler2D _EmissionMask;
            float4 _EmissionColor; float _EmissionStrength;

            float _EyeLidL, _EyeLidR, _EyeSquintL, _EyeSquintR, _EyeX, _EyeY, _EyeTrackingActive;
            float _DbgOverride, _DbgLinkEyes, _DbgLidL, _DbgSquintL, _DbgLidR, _DbgSquintR, _DbgX, _DbgY, _DbgTrackingActive, _DebugView;
            float _SwapSides, _UpFlipL, _UpFlipR, _GazeXDeadzone, _GazeYMaxShift;
            float _LidOpenAt, _LidStep, _SquintOn, _SquintFull;

            struct appdata { float4 vertex : POSITION; float3 normal : NORMAL; float2 uv : TEXCOORD0; };
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; float3 worldNormal : TEXCOORD1; };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            NchoEyeInputs GatherInputs()
            {
                NchoEyeInputs i;
                if (_DbgOverride > 0.5)
                {
                    bool link = _DbgLinkEyes > 0.5;
                    i.lidL = _DbgLidL;  i.squintL = _DbgSquintL;
                    i.lidR = link ? _DbgLidL : _DbgLidR;
                    i.squintR = link ? _DbgSquintL : _DbgSquintR;
                    i.gazeX = _DbgX; i.gazeY = _DbgY;
                    i.trackingActive = _DbgTrackingActive;
                }
                else
                {
                    i.lidL = _EyeLidL; i.lidR = _EyeLidR;
                    i.squintL = _EyeSquintL; i.squintR = _EyeSquintR;
                    i.gazeX = _EyeX; i.gazeY = _EyeY;
                    i.trackingActive = _EyeTrackingActive;
                }
                return i;
            }

            NchoEyeSettings GatherSettings()
            {
                NchoEyeSettings s;
                s.swapSides = _SwapSides; s.upFlipL = _UpFlipL; s.upFlipR = _UpFlipR;
                s.gazeXDeadzone = _GazeXDeadzone; s.gazeYMaxShift = _GazeYMaxShift;
                s.lidOpenAt = _LidOpenAt; s.lidStep = _LidStep;
                s.squintOn = _SquintOn; s.squintFull = _SquintFull;
                return s;
            }

            float4 frag(v2f IN) : SV_Target
            {
                float3 albedo = tex2D(_MainTex, TRANSFORM_TEX(IN.uv, _MainTex)).rgb * _Color.rgb;
                float3 n = normalize(IN.worldNormal);
                float3 light = _LightColor0.rgb * saturate(dot(n, _WorldSpaceLightPos0.xyz)) + ShadeSH9(float4(n, 1));
                float3 col = albedo * light;

                // Exact texel lookup: the LED grid must never filter or mip.
                int2 texel = clamp((int2)floor(frac(IN.uv) * _LedMap_TexelSize.zw), 0, (int2)_LedMap_TexelSize.zw - 1);
                NchoEyeSettings s = GatherSettings();
                NchoEyeInputs  i = GatherInputs();
                NchoEyeLed led = NchoEyeDecodeTexel(_LedMap.Load(int3(texel, 0)), s);

                float4 dbg = NchoEyeDebug((int)_DebugView, led, i, s, _LedMap);
                if (dbg.a > 0) return float4(dbg.rgb, 1);

                if (NchoEyeLit(led, i, s, _LedMap))
                    col += _EmissionColor.rgb * _EmissionStrength * tex2D(_EmissionMask, IN.uv).r;

                return float4(col, 1);
            }
            ENDCG
        }
    }
    Fallback "VertexLit"
}
