// Status tooltips: art anchored to bones and visible to everyone, kept at a constant size on
// screen. Every tooltip shares this one material. See docs/callouts.md.
//
// Mesh contract (one tiny quad per tooltip, weighted 100% to its bone):
//   UV0 = the tooltip's cell in the atlas; its corners sit exactly on the cell's corners.
//   UV1 = the quad's own corner, 0..1. The shader rebuilds the quad as a card from it.
// The tooltip ID comes from the atlas cell, counted row-major from the top left. It indexes
// _CalloutOnA..D (and _Nudge* in Callout layout).
//
// Each tooltip is a world-space card that faces the camera's POSITION (head rotation does not
// swing it) and takes its roll from the camera's up axis. It's sized so its height on screen is
// _LabelHeight of the screen at any distance. In VR the card is built from the centre-eye
// position. By default (_StereoDepth = Card) both eyes look at that one card, so it fuses at its
// real depth, _DepthPush in front of its anchor. Match HUD (each eye sees it in the same view
// direction, at optical infinity like the ncho HUD) is available but was nauseating in-headset.
Shader "exegesis/Callout"
{
    Properties
    {
        [Header(Art)]
        _MainTex ("Tooltip Atlas", 2D) = "white" {}
        _AtlasGrid ("Atlas Grid (columns, rows)", Vector) = (4, 4, 0, 0)
        [HDR] _Color ("Tint", Color) = (1, 1, 1, 1)
        [ToggleUI] _PixelArt ("Pixel Art Sampling (crisp texels at any size; import the texture as Bilinear)", Float) = 1

        [Header(Size and layout  sizes are fractions of screen height)]
        _LabelHeight ("Tooltip Height", Range(0.005, 0.3)) = 0.06
        [Enum(Centered,0,Callout,1)] _LayoutMode ("Layout (Centered: art centred on its anchor | Callout: offset label + leader line)", Float) = 0

        [Header(Callout layout only)]
        [ToggleUI] _AutoSide ("Auto Side (push labels away from the body's centre line)", Float) = 1
        _AutoSideDeadzone ("Auto Side Deadzone (m)", Float) = 0.05
        // Each label's centre offset from its anchor, in label heights; xy = even ID, zw = odd ID.
        _Nudge01 ("Nudge  chest | abdomen", Vector) = (3, 1.3, -3, 1.3)
        _Nudge23 ("Nudge  groin | face", Vector) = (3, -1.3, 3, 2.6)
        _Nudge45 ("Nudge  L arm | R arm", Vector) = (3, 0, -3, 0)
        _Nudge67 ("Nudge  L thigh | R thigh", Vector) = (3, -2.6, -3, -2.6)
        _Nudge89 ("Nudge  pouches | spare", Vector) = (-3, -1.3, 3, 0)
        _NudgeAB ("Nudge  spare | spare", Vector) = (3, 0, 3, 0)
        _NudgeCD ("Nudge  spare | spare", Vector) = (3, 0, 3, 0)
        _NudgeEF ("Nudge  spare | spare", Vector) = (3, 0, 3, 0)
        [HDR] _LineColor ("Leader Line Color", Color) = (1, 0.72, 0.2, 1)
        _LineWidth ("Leader Line Width", Range(0, 0.01)) = 0.0015
        _DotSize ("Anchor Dot Radius", Range(0, 0.02)) = 0.004

        [Header(Depth)]
        _DepthPush ("Depth Push Toward Viewer (m)", Range(0, 1)) = 0.35
        [Enum(Match HUD (infinity),0,Card (pushed depth),1)] _StereoDepth ("VR Apparent Depth", Float) = 1

        [Header(Distance)]
        _FadeStart ("Fade Start (m)", Float) = 20
        _FadeEnd ("Fade End (m)", Float) = 30

        [Header(Mirrors)]
        [ToggleUI] _HideInMirror ("Hide In Mirrors", Float) = 0
        [ToggleUI] _MirrorFlip ("Mirror The Art Like A Real Reflection", Float) = 0

        [Header(Animated  driven by FX panel clips  DO NOT RENAME)]
        _CalloutOnA ("On  chest, abdomen, groin, face", Vector) = (0, 0, 0, 0)
        _CalloutOnB ("On  L arm, R arm, L thigh, R thigh", Vector) = (0, 0, 0, 0)
        _CalloutOnC ("On  pouches, spare x3", Vector) = (0, 0, 0, 0)
        _CalloutOnD ("On  spare x4", Vector) = (0, 0, 0, 0)
    }

    SubShader
    {
        // VRCFallback Hidden: a viewer who blocks shaders sees nothing, not the raw quads in a fallback shader.
        Tags { "Queue"="Transparent+50" "RenderType"="Transparent" "IgnoreProjector"="True" "PreviewType"="Plane" "VRCFallback"="Hidden" }

        Pass
        {
            // Normal depth test against the world and other avatars. The card sits _DepthPush
            // closer to the viewer than its anchor, so ncho's own body never hides it.
            ZTest LEqual
            ZWrite Off
            Cull Off
            Blend One OneMinusSrcAlpha   // premultiplied alpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.5
            #include "UnityCG.cginc"

            sampler2D _MainTex; float4 _MainTex_TexelSize;
            float4 _AtlasGrid;
            float4 _Color;
            float _PixelArt;
            float _LabelHeight, _LayoutMode, _AutoSide, _AutoSideDeadzone;
            float4 _Nudge01, _Nudge23, _Nudge45, _Nudge67, _Nudge89, _NudgeAB, _NudgeCD, _NudgeEF;
            float4 _LineColor;
            float _LineWidth, _DotSize;
            float _DepthPush, _StereoDepth, _FadeStart, _FadeEnd;
            float _HideInMirror, _MirrorFlip;
            float4 _CalloutOnA, _CalloutOnB, _CalloutOnC, _CalloutOnD;

            // VRChat globals. _VRChatMirrorMode: 0 = normal, 1 = mirror in VR, 2 = mirror on desktop.
            // _VRChatMirrorCameraPos: the mirror camera's eye-independent (centred) position.
            float _VRChatMirrorMode;
            float3 _VRChatMirrorCameraPos;
            // Test hook (CalloutTests): w > 0.5 overrides the centre-eye position, because two mono
            // cameras can't reach the stereo-instanced path. Never set outside tests.
            float4 _CalloutTestEyeCentre;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 p : TEXCOORD0;                     // label-height units, origin at the anchor, +y up the card
                nointerpolation float4 rect : TEXCOORD1;  // art rectangle: min.xy, max.xy
                nointerpolation float4 info : TEXCOORD2;  // atlas cell.xy, alpha, reveal (the animated on value)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            // Primary: VRChat's global. Fallback (outside VRChat): a mirror camera's oblique
            // projection puts x/y terms in its z row. The fallback alone, which the HUD's
            // isInMirror() uses, MISSES a mirror viewed exactly head-on: the clip plane's normal is
            // then (0, 0, 1) in camera space and both terms are exactly 0 (CalloutTests pins this).
            bool calloutInMirror()
            {
                return _VRChatMirrorMode > 0.5
                    || unity_CameraProjection[2][0] != 0 || unity_CameraProjection[2][1] != 0;
            }

            // The point the cards face: the centre eye in VR, so both eyes share one card.
            float3 calloutEyeCentre()
            {
            #if defined(USING_STEREO_MATRICES)
                float3 p = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) * 0.5;
            #else
                float3 p = _WorldSpaceCameraPos;
            #endif
                if (_VRChatMirrorMode > 0.5) p = _VRChatMirrorCameraPos;
                if (_CalloutTestEyeCentre.w > 0.5) p = _CalloutTestEyeCentre.xyz;
                return p;
            }

            // cot(vertical FOV / 2), shared by both eyes so the card is the same size in each.
            float calloutProjY()
            {
            #if defined(USING_STEREO_MATRICES)
                return 0.5 * (abs(unity_StereoMatrixP[0]._m11) + abs(unity_StereoMatrixP[1]._m11));
            #else
                return abs(UNITY_MATRIX_P._m11);
            #endif
            }

            float pick4(float4 v, uint c)
            {
                return c == 0 ? v.x : c == 1 ? v.y : c == 2 ? v.z : v.w;
            }

            float calloutOn(uint id)
            {
                uint b = id >> 2;
                float4 v = b == 0 ? _CalloutOnA : b == 1 ? _CalloutOnB : b == 2 ? _CalloutOnC : _CalloutOnD;
                return pick4(v, id & 3);
            }

            float2 calloutNudge(uint id)
            {
                uint b = id >> 1;
                float4 v = b == 0 ? _Nudge01 : b == 1 ? _Nudge23 : b == 2 ? _Nudge45 : b == 3 ? _Nudge67
                         : b == 4 ? _Nudge89 : b == 5 ? _NudgeAB : b == 6 ? _NudgeCD : _NudgeEF;
                return (id & 1) ? v.zw : v.xy;
            }

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                float2 grid = max(_AtlasGrid.xy, 1);
                float2 cell = floor(v.uv0 * grid - v.uv1 + 0.5);
                uint id = (uint)((grid.y - 1 - cell.y) * grid.x + cell.x);

                // Skinning has already put this vertex on its bone; it is the tooltip's anchor.
                float3 anchor = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;
                float3 eye = calloutEyeCentre();
                float3 toEye = eye - anchor;
                float dist = max(length(toEye), 1e-4);
                toEye /= dist;

                float fade = 1 - saturate((dist - _FadeStart) / max(_FadeEnd - _FadeStart, 1e-3));
                float alpha = fade * ((_HideInMirror > 0.5 && calloutInMirror()) ? 0 : 1);
                float on = saturate(calloutOn(id));
                if (on * alpha <= 0.001 || id > 15)
                {
                    // Hidden: all four corners collapse to one point off-screen, so no pixels are shaded.
                    o.pos = float4(2, 2, 2, 1);
                    return o;
                }

                // Card orientation: its normal points at the eye (so it LOOKS AT the camera rather
                // than copying the camera's rotation), and its up follows the camera's up (so it
                // matches camera roll). Right is the camera's right made orthogonal to both; that
                // keeps +x to screen-right, mirrors included.
                float3 camRight = UNITY_MATRIX_V[0].xyz;
                float3 camUp = UNITY_MATRIX_V[1].xyz;
                float3 up = normalize(camUp - toEye * dot(camUp, toEye));
                float3 right = camRight - toEye * dot(camRight, toEye);
                right = normalize(right - up * dot(right, up));

                // Depth push: the card sits closer to the viewer, on the line from the eye to the
                // anchor, so it lands in the same place on screen and depth-tests _DepthPush in front of
                // the anchor. (Where it APPEARS in VR is _StereoDepth's job, below.)
                float pushed = max(dist - _DepthPush, dist * 0.5);
                float3 centre = eye - toEye * pushed;
                float unit = 2 * _LabelHeight * pushed / max(calloutProjY(), 1e-4);   // metres per label height

                // Layout, in label-height units around the anchor.
                float cellAspect = (_MainTex_TexelSize.z / grid.x) / (_MainTex_TexelSize.w / grid.y);
                float2 halfSize = float2(cellAspect, 1) * 0.5;
                float2 n = 0;
                float pad = 0;
                if (_LayoutMode > 0.5)
                {
                    n = calloutNudge(id);
                    if (_AutoSide > 0.5)
                    {
                        // Side of the body centre, along the camera's right axis. The object origin
                        // of a SkinnedMeshRenderer is its root bone. Eye-independent, so both VR
                        // eyes always pick the same side.
                        float side = dot(anchor - unity_ObjectToWorld._m03_m13_m23, camRight);
                        if (abs(side) > _AutoSideDeadzone) n.x = abs(n.x) * sign(side);
                    }
                    // The quad also covers the anchor dot and the leader line.
                    pad = max(_DotSize, _LineWidth) / max(_LabelHeight, 1e-4) + 0.05;
                }
                float2 rmin = n - halfSize;
                float2 rmax = n + halfSize;
                float2 lo = rmin, hi = rmax;
                if (_LayoutMode > 0.5) { lo = min(rmin, -pad); hi = max(rmax, pad); }
                float2 corner = lerp(lo, hi, v.uv1);

                float3 world = centre + (right * corner.x + up * corner.y) * unit;
                if (_StereoDepth > 0.5)
                {
                    // Card: one world-space card that both eyes look at, so it fuses at its real
                    // (pushed) depth, in front of the body it covers.
                    o.pos = UnityWorldToClipPos(world);
                }
                else
                {
                    // Match the HUD: the HUD's content is positioned by each eye's own view-space
                    // direction (xy/z of view - the eye's camera; CSUV.cginc), so it has zero disparity
                    // and appears at optical infinity. Do the same: put the card at the SAME view-space
                    // position in every eye's own frame (its offset from the centre eye, expressed in
                    // this eye's view rotation). Both eyes then see it in the same direction (infinity),
                    // while its depth for the depth test is still the pushed card's, _DepthPush in front of
                    // the anchor. On desktop the centre eye IS the camera, so this changes nothing.
                    float3 viewPos = mul((float3x3)UNITY_MATRIX_V, world - eye);
                    o.pos = mul(UNITY_MATRIX_P, float4(viewPos, 1));
                }
                o.p = corner;
                o.rect = float4(rmin, rmax);
                o.info = float4(cell, alpha, on);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
                float2 p = i.p;
                float2 rmin = i.rect.xy;
                float2 rmax = i.rect.zw;
                float alpha = i.info.z;
                float reveal = i.info.w;
                float px = max(fwidth(p.x), fwidth(p.y));   // one pixel, in label units

                // Art. Sampled unconditionally (it needs derivatives), then masked.
                float2 grid = max(_AtlasGrid.xy, 1);
                float2 luv = (p - rmin) / (rmax - rmin);
                float inside = all(luv >= 0) && all(luv <= 1) && luv.x <= reveal;
                float2 u = luv;
                if (_MirrorFlip > 0.5 && calloutInMirror()) u.x = 1 - u.x;
                float2 cellTexels = _MainTex_TexelSize.zw / grid;
                u = clamp(u, 0.5 / cellTexels, 1 - 0.5 / cellTexels);   // keep filtering inside the cell
                float2 uv = (i.info.xy + u) / grid;

                // Pixel-art sampling: snap to texel centres, blending only across a one-pixel band at
                // each texel edge. Crisp texels at any (non-integer) scale, without shimmer. It needs
                // the texture imported as Bilinear.
                float2 texel = uv * _MainTex_TexelSize.zw;
                float2 seam = floor(texel + 0.5);
                float2 perPixel = max(fwidth(texel), 1e-5);
                float2 crispUV = (seam + clamp((texel - seam) / perPixel, -0.5, 0.5)) * _MainTex_TexelSize.xy;
                uv = _PixelArt > 0.5 ? crispUV : uv;

                float4 art = tex2D(_MainTex, uv) * _Color;
                float la = saturate(art.a) * inside;

                // Leader line (Callout layout): from the anchor to the nearest point of the label;
                // it grows with reveal.
                float2 seg = clamp(float2(0, 0), rmin, rmax) * reveal;
                float t = saturate(dot(p, seg) / max(dot(seg, seg), 1e-6));
                float halfWidth = 0.5 * _LineWidth / max(_LabelHeight, 1e-4);
                float lineA = saturate((halfWidth - length(p - seg * t)) / px + 0.5);
                float dotA = saturate((_DotSize / max(_LabelHeight, 1e-4) - length(p)) / px + 0.5);
                float leader = (_LayoutMode > 0.5) ? max(lineA, dotA) * _LineColor.a : 0;

                // Premultiplied: art over leader.
                float4 c;
                c.rgb = art.rgb * la + _LineColor.rgb * leader * (1 - la);
                c.a = la + leader * (1 - la);
                c *= alpha;
                clip(c.a - 0.002);
                return c;
            }
            ENDCG
        }
    }
}
