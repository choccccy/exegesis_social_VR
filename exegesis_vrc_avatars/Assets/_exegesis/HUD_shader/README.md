# HUD Shader (`exegesis/HUD`)

A screen-space heads-up-display overlay for the ncho VRChat avatar (Unity BiRP). Composites
a compass, an artificial horizon, status bars, a paper-doll damage/touch indicator, and
image overlays onto a head-anchored quad, projected to a fixed screen location.

Based on [VRC-Cancerspace](https://github.com/AkaiMage/VRC-Cancerspace) by
[AkaiMage](https://github.com/AkaiMage). `#define CANCERFREE` is set unconditionally, so
this is a pure additive overlay with **no GrabPass / no screen read** — the inherited
Cancerspace screen-grab machinery has been stripped.

## Files

- `HUD.shader` — properties + the single Pass.
- `HUD_core.cginc` — vertex/fragment logic and the per-sub-effect sampling helpers.
- `CGInclude/CS*.cginc` — shared helpers (enums, HSV/blend, rotation, depth, UV
  projection, falloff, mirror/eye discrimination, uniform declarations).
- `Editor/HUD_inspector.cs` — custom `ShaderGUI`.
- `Tests/Editor/` — the EditMode + golden-image regression suite.

## Docs

Architecture, the render model, the animation-driven property contract (do-not-rename
list), and the IR/radar roadmap live in the project docs:
[`docs/hud-shader.md`](../../../docs/hud-shader.md) and
[`docs/testing.md`](../../../docs/testing.md).

## License

Licensed under [GPLv3](LICENSE).
