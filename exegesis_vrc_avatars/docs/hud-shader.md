# HUD shader

`Shader "exegesis/HUD"` — a heads-up-display overlay for the ncho VRChat avatar.
Source: `Assets/_exegesis/HUD_shader/`. Material: `Assets/_exegesis/HUD/ncho_HUD.mat`.

## What it draws

A screen-space HUD composited from several sub-effects: an **image overlay**, a
**secondary overlay**, a **compass** strip (heading), an **artificial horizon**
(pitch/roll), three **status bars** (labeled gauges like "core temp" / "H2O"), and a
**paper doll** (humanoid body-region touch/damage indicators). Corner brackets frame it.

## Provenance & license

- **GPLv3** (`LICENSE`). Fork of [VRC-Cancerspace](https://github.com/AkaiMage/VRC-Cancerspace)
  by AkaiMage. Preserve the license and attribution. Copyleft only bites if the avatar
  is distributed publicly.
- The inherited Cancerspace `CANCERFREE` machinery (screen-grab compositing, blur,
  wobble, distortion, screen-color adjustment) was **stripped in Step 1**. The shader is
  a clean additive HUD overlay, **plus** the Step-2 depth-driven sensor scanner below
  (no GrabPass). See [Sensor scanner](#sensor-scanner-step-2).

## File structure

| File | Role |
|---|---|
| `HUD.shader` | Properties + a single Pass; includes `HUD_core.cginc`. |
| `HUD_core.cginc` | The bulk: uniforms, `vert`, `frag`, and per-sub-effect sampling helpers. |
| `CGInclude/CS*.cginc` | Shared helpers: enums, HSV/blend, rotation, depth, UV projection, falloff, mirror/eye discrimination, uniform/macro declarations (`CSProps`), and the screen effects (`CSScreenFX`). |
| `Editor/HUD_inspector.cs` | Custom `ShaderGUI` (~20 collapsible categories). A copy-paste fork of the orphaned `Cancerspace/Editor/CancerspaceInspector.cs`. |

## Render model (important for tests and for reasoning about it)

- **Geometry is world/head-anchored**: the mesh is a built-in **Cube** (local scale 4)
  parented to the Head bone. `vert` transforms it normally through
  ObjectToWorld -> view -> clip.
- **Content is screen-space projected**: with `_ProjectionType=0` (Flat),
  `CSUV.cginc::computeScreenSpaceOverlayUV` maps world position to a fixed screen
  location using `_WorldSpaceCameraPos` and `UNITY_MATRIX_V`, with an `xy/z` perspective
  divide. Consequences:
  - Requires a **perspective** camera; an **orthographic** camera degenerates the HUD.
  - **Aspect ratio / `_ScreenParams`** affect the UVs, so render resolution matters.
- **Culling** (`CSDiscriminate.cginc`): `_MirrorMode=1` (MIRROR_DISABLE) hides it in
  mirrors, detected via an oblique projection matrix (`proj[2][0]/[2][1] != 0`); a plain
  non-oblique camera renders it. `_EyeSelector=0` / `_PlatformSelector=0` = no eye/
  platform culling. `_ScreenReprojection=0`.
- **Time-based** paths: HUD drift (`_HUDDriftRadius`/`_HUDDriftPeriod`), status-bar
  jitter (`_StatusBarNJitter`). Zero these for deterministic renders.

## Animation-contract properties (DO NOT rename)

VRChat drives these by name from `.anim` clips and an embedded curve in
`Assets/_exegesis/ncho/ncho_anim/ncho_fx.controller`. Renaming any of them silently
breaks the avatar; `MaterialStateTests` pins their existence.

```
_PD_HeadTouch _PD_ChestTouch _PD_AbdomenTouch _PD_HipsTouch
_PD_LArmTouch _PD_RArmTouch _PD_LLegTouch _PD_RLegTouch
_StatusBar0Fill _StatusBar1Fill _StatusBar2Fill _Overlay2Enabled
```

The other ~140 properties are free to reorganize/rename. Related VRC params:
`hud` (on/off, toggles the GameObject's active state, not a shader prop) and the
`*_touch` bools in `ncho_params.asset` / `ncho_main_menu.asset`.

## Usage in the project

- Live renderer: `Assets/_exegesis/HUD/ncho_HUD.prefab` (one MeshRenderer). The prefab
  root is inactive in the saved scene; the FX layer toggles it on at runtime.
- `Assets/_exegesis/exegesis.unity` is a multi-avatar photo studio with ~7 ncho copies
  and dev/test duplicates; its cameras are orthographic studio rigs (NOT how the HUD is
  seen in-game). It also contains a stray inactive `Cube` with the HUD material — scratch.

## Sensor scanner (Step 2)

A first-person, PC-focused geometry visualization, integrated into the same shader/material
(no extra slot, **no GrabPass**, no added light). It is driven by **real scene geometry** —
the frag already reconstructs `depth`, world position, and a world-space normal from
`_CameraDepthTexture` (see the render model above), and the scanner reads those. Runs in
`frag()` **before** the HUD layers (HUD draws on top). Off by default (`_ScanEnabled = 0`);
when off the render is byte-identical to the plain HUD (golden-pinned).

Why this replaced the first IR/radar attempt: that one read the **color image** (thermal
ramp on luminance, Sobel on albedo), so it couldn't sense 3D structure and felt fake. The
scanner reads depth/normals, so it responds to actual geometry.

Composable modes (`CSScreenFX::csScanCompose`), each a toggle + knobs:
- **`_ScanNormalShade`** — facing-ratio shading from the reconstructed normal (albedo-independent "3D reconstruction" base).
- **`_ScanEdges`** — silhouette + crease edges from `fwidth(depth)` / `fwidth(normal)` (true geometry wireframe, **no extra texture taps**).
- **`_ScanRange`** — near→far color by real distance (lidar/radar range).
- **`_ScanContours`** — iso-depth bands (`frac(depth/spacing)`) hugging geometry.
- **`_ScanSweep`** — animated depth band (`_Time`-driven).
Plus `_ScanColor`/`_ScanBrightness` and per-mode colors/thresholds.

Constraints: **depth is world-provided** — present in worlds with a realtime shadow-casting
light (and on shadow-caster props/avatars), **blank in fullbright/no-depth worlds** (honest
"no signal"). Only shadow-caster-pass geometry appears in depth (misses transparents/some
avatars). PC-focused. Gated off in mirrors (`isInMirror()`) and the VRChat camera
(`_VRChatCameraMode`). `HudGoldenImageTests` pins `scan_normals`/`scan_edges`/`scan_range`/
`scan_all` against a shadow-casting background scene (the harness forces depth for tests).

## Roadmap

Step 1 (cleanup) and Step 2 (sensor scanner) are done and pinned. Possible follow-ups: tune
the look after in-headset play (which modes, colors, thresholds); wire the VRChat expression
menu/params/animator to toggle the scanner + modes (touches `ncho_params.asset`,
`ncho_main_menu.asset`, `ncho_fx.controller`); optionally convert runtime feature branches to
`shader_feature` keywords for a leaner variant.
