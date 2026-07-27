# HUD Shader (`exegesis/HUD`)

A screen-space heads-up-display overlay for the ncho VRChat avatar (Unity BiRP). Composites
a compass, an artificial horizon, status bars, a paper-doll damage/touch indicator, and
image overlays onto a head-anchored quad, projected to a fixed screen location.

Based on [VRC-Cancerspace](https://github.com/AkaiMage/VRC-Cancerspace) by
[AkaiMage](https://github.com/AkaiMage). The inherited Cancerspace screen-grab machinery
was stripped (Step 1); the shader then gained a first-person **sensor scanner** (Step 2) —
a depth/normal-driven geometry visualization (normal-shade, edges, range, contours, sweep),
**no GrabPass and no added light**. It's off by default; with it off, a plain additive HUD
overlay. See docs for the scanner's depth (world-provided) constraints.

## Files

- `HUD.shader` — properties + a single Pass.
- `HUD_core.cginc` — vertex/fragment logic and the per-sub-effect sampling helpers.
- `CGInclude/CS*.cginc` — shared helpers (enums, HSV/blend, rotation, depth, UV
  projection, falloff, mirror/eye discrimination, uniform declarations, and the
  `CSScreenFX` sensor scanner).
- `Editor/HUD_inspector.cs` — custom `ShaderGUI`.
- `Tests/Editor/` — the EditMode + golden-image regression suite.

## Docs

Architecture, the render model, the animation-driven property contract (do-not-rename
list), and the sensor-scanner roadmap live in the project docs:
[`docs/hud-shader.md`](../../../docs/hud-shader.md) and
[`docs/testing.md`](../../../docs/testing.md).

## License

Licensed under [GPLv3](LICENSE).
