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
- `#define CANCERFREE` is set **unconditionally** in `HUD.shader`. In Cancerspace that
  flag selects the "no screen-grab" build; here it means the shader is a **pure additive
  screen-space overlay with no GrabPass / no screen read**. A large amount of the
  inherited Cancerspace machinery (screen-grab compositing, blur, wobble, distortion,
  screen-color adjustment) is therefore **dead code**.

## File structure

| File | Role |
|---|---|
| `HUD.shader` | Properties + single Pass; sets `CANCERFREE`, includes `HUD_core.cginc`. |
| `HUD_core.cginc` | The bulk: uniforms, `vert`, `frag`, and per-sub-effect sampling helpers. |
| `CGInclude/CS*.cginc` | Shared, well-factored helpers: enums, HSV/blend, rotation, depth, UV projection, falloff, mirror/eye discrimination, central uniform/macro declarations (`CSProps`). The cleanest part; the reusable foundation for future features. |
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

## Known cruft (cleanup targets)

Dead `CANCERFREE` branches in `frag` and `CSProps`; 102 commented-out properties in
`HUD.shader`; the orphaned `Cancerspace/` inspector; `!cancerfree`-gated dead inspector
categories + a file-writing "Render Queue Exporter"; triplicated status-bar and 16x
paper-doll code; a `BlendMode` enum duplicated between `HUD_inspector.cs` and
`CSEnums.cginc`; `CSFalloff.cginc` included twice; duplicate `getCameraForwardWS`/
`camFwdWS`; magic-number paper-doll region colors.

## Roadmap

Current: clean the shader to a professional BiRP standard while keeping behavior
pixel-identical (pinned by [testing.md](testing.md)). **Next (not built yet):**
fullscreen **IR vision** (greyscale world + bright avatars) and **radar** (wireframe
overlay). Both are *screen-grab* effects and will need a new **GrabPass**-based
screen-read path — the current shader has none, so that's greenfield, and the reusable
starting point is the `CGInclude/` utilities, not the dead Cancerspace frag code.
