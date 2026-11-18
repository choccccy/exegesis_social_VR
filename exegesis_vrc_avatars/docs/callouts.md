# Status tooltips

`Shader "exegesis/Callout"` draws tooltips that everyone can see, each anchored to a bone, for
example a "chest panels removed" graphic centred on ncho's chest. They keep a constant size on
screen at any distance, the way a HUD does. Every tooltip shares **one material on one
renderer**.

Source: `Assets/_exegesis/callout_shader/`:

| File | What |
|---|---|
| `Callout.shader` | the shader |
| `callouts.mat` | ncho's material: Centered layout, `tooltip_atlas.png` |
| `tooltip_atlas.png` | **placeholder** square pixel-art tooltips; the real art is still to be drawn |
| `leader_callout_atlas.png` | example art for the optional Callout layout (wide labels + leader lines) |
| `Tests/Editor/CalloutTests.cs` | the render-model tests (docs/testing.md) |

**Setup per avatar copy:** assign `callouts.mat` to `ncho_callouts`. The model imports with no
materials (`materialImportMode: 0`), like `Body` and `Props`. On `ncho_[quest]`, disable or
delete `ncho_callouts`: Quest only allows VRChat's mobile shaders.

## Render model

- **Anchor:** each tooltip is a tiny quad (~1 mm once exported; see Mesh) skinned 100% to one bone. After skinning,
  all four vertices sit on the bone, so the vertex position *is* the anchor. A shader can't
  read bone positions; that's why the single big screen-space cube was rejected, since it
  could only ever anchor to its own origin.
- **A card that looks at the camera.** The vertex shader rebuilds each tooltip as a world-space
  card:
  - its normal points at the camera's **position**, so turning your head doesn't swing it.
    Only moving does, like a real object;
  - its up is the camera's up, made perpendicular to the line of sight, so it **matches camera
    roll**;
  - its right is the camera's right, made perpendicular to both, which keeps the art reading
    left-to-right, mirrors included.

  (The first version built the quad in clip space, parallel to the image plane, so it turned
  with the HMD. That's what "too well" meant.)
- **Constant size on screen:** the card is `2 · _LabelHeight · distance / cot(fov_y/2)` tall,
  which is `_LabelHeight` of the screen height when it's at the centre of view. Off-axis it
  projects a little larger, as any real object facing you does on a flat projection. Only the
  card's own pixels are shaded, so nothing gets cut off at range.
- **Depth push:** the card physically sits `_DepthPush` (default 0.35 m) closer to the viewer
  than its anchor, on the line from the eye to the anchor, so it stays in the same place on
  screen. It's capped at half the distance for very close viewers. With `ZTest LEqual`:
  - it always draws over ncho's own body;
  - it draws over world geometry and avatars **behind** the card;
  - anything **in front of** the card hides it, per pixel, including partial overlaps.
  - **Limitation:** another avatar within `_DepthPush` of the anchor (a hug) gets drawn over.
    Stencil was rejected: it needs the Poiyomi body materials re-locked, collides with other
    avatars' stencil bits, and still shows through avatars depending on draw order.
- **VR apparent depth (`_StereoDepth`).** The card is built once, from the centre-eye position
  (`unity_StereoWorldSpaceCameraPos` average) and an averaged `cot(fov_y/2)`. Where it then
  *appears* is separate from how it *depth-tests*. Both modes depth-test the card `_DepthPush`
  in front of the anchor.
  - **Card (default):** one world-space card that both eyes look at, so it fuses at its real
    (pushed) depth, in front of the body it covers. Each eye sees it from a slightly different
    angle, like a real object, which is why the tests compare each eye with the projected
    card, not eye with eye.
  - **Match HUD:** the ncho HUD positions every feature by its view-space direction in each
    eye's own frame (`view.xy / view.z`, using that eye's `_WorldSpaceCameraPos` and
    `UNITY_MATRIX_V`; `CSUV.cginc`). So it has zero disparity and appears at **optical
    infinity**, not on its cube. This mode does the same for the tooltips: the card's offset
    from the centre eye is placed at the same view-space position in each eye's frame, using
    each eye's own view rotation. **Tried in-headset (2026-11-10) and it was nauseating**: a
    tooltip at infinity drawn over a body and occluded by nearby geometry contradicts every
    other depth cue. Kept as an option; don't make it the default again.

  On desktop the centre eye is the camera, and the two modes render identically.
- **Hidden tooltips cost nothing:** when a tooltip is off, past `_FadeEnd`, or hidden in a
  mirror, the vertex shader collapses its four corners to a single point off-screen.
- **Mirrors:** art reads forwards in VRChat mirrors by default. `_MirrorFlip` flips it like a
  real reflection; `_HideInMirror` hides tooltips in mirrors. In mirrors the card faces
  `_VRChatMirrorCameraPos`. Detection reads VRChat's `_VRChatMirrorMode` global first, and
  falls back to the oblique-projection test (the HUD's `isInMirror()`, rewritten locally
  rather than including the GPL'd Cancerspace file).
  **The fallback alone misses a mirror viewed exactly head-on:** the clip plane's normal is
  then (0, 0, 1) in camera space, so the projection's oblique x/y terms are exactly zero.
  `CalloutTests` pins both behaviours. The HUD's `isInMirror()` has the same blind spot.
- **Test hook:** `_CalloutTestEyeCentre` (a global; `w > 0.5` overrides the centre-eye
  position). Two mono test cameras can't reach the stereo-instanced path, so the stereo test
  pins the centre eye through it. Never set outside tests.

## Layouts

`_LayoutMode`:

- **Centered** (default; ncho): the art is centred on its anchor, with no leader line. Whatever
  marks the exact point, such as a crosshair or bracket, is part of the art, at the centre of
  its cell.
- **Callout** (optional, kept for anyone reusing the shader): the label is offset from its
  anchor by `_Nudge*` (in label heights), with a leader line (`_LineColor`, `_LineWidth`) and an
  anchor dot (`_DotSize`). The default nudges form two columns, x = ±3 and 1.3 apart
  vertically, so labels don't overlap from far away, when every anchor converges on one point.
  `_AutoSide` mirrors x to whichever side of the body centre the anchor is on, measured along
  the camera's right axis. That's eye-independent, so both VR eyes pick the same side. The body
  centre is the renderer's object origin, which for a SkinnedMeshRenderer is its root bone.
  `_AutoSideDeadzone` (m) keeps centre-line labels on their authored side.
  `leader_callout_atlas.png` is example art for this layout.

## Tooltip slots

The ID comes from the tooltip's atlas cell, counted row-major from the **top left** of a 4×4 grid.

| ID | Panel | On property | Atlas cell | Anchor bone |
|---|---|---|---|---|
| 0 | chest | `_CalloutOnA.x` | row 0, col 0 | `Chest` |
| 1 | abdomen | `_CalloutOnA.y` | row 0, col 1 | `Spine` |
| 2 | groin | `_CalloutOnA.z` | row 0, col 2 | `Hips_fix` |
| 3 | face | `_CalloutOnA.w` | row 0, col 3 | `Head` |
| 4 | left arm | `_CalloutOnB.x` | row 1, col 0 | `forearm_fix.L` |
| 5 | right arm | `_CalloutOnB.y` | row 1, col 1 | `forearm_fix.R` |
| 6 | left thigh | `_CalloutOnB.z` | row 1, col 2 | `thigh_fix.L` |
| 7 | right thigh | `_CalloutOnB.w` | row 1, col 3 | `thigh_fix.R` |
| 8 | pouches | `_CalloutOnC.x` | row 2, col 0 | `Hips_fix` |
| 9–15 | spare | `_CalloutOnC.yzw`, `_CalloutOnD` | — | — |

The anchor bones were picked by taking each panel's UV tile on `Body` (the `discard` UV map;
the tile is the one each panel's off clip dissolves), weighting its vertices, and keeping the
dominant deform bone. `panels` is a vertex group, not a bone. Anchor positions are the
tiles' posed centroids, in Blender units:

| Panel | Centroid (x, y, z) | Panel | Centroid |
|---|---|---|---|
| face | (0, −0.33, 7.35) | L/R arm | (±2.69, −0.06, 6.59) |
| chest | (0, −0.28, 6.42) | L/R thigh | (±0.54, −0.37, 3.55) |
| abdomen | (0, −0.03, 5.48) | pouches | (−0.13, −0.03, 5.19) |
| groin | (0, 0, 4.28) | | |

## Animation contract (DO NOT rename)

`_CalloutOnA`, `_CalloutOnB`, `_CalloutOnC`, `_CalloutOnD` are driven by name, on path
`ncho_callouts` (SkinnedMeshRenderer, classID 137), from:

- each `[panels]_<panel>_off.anim`, which sets that panel's component to **1**;
- `[panels]_neutral.anim`, which sets all nine used components to **0**. That's the baseline:
  the panel layers are write-defaults-off, and the neutral layer sits beneath them, exactly as
  for the existing `_UVTileDissolveAlpha_*` curves.

The on value is also the **reveal**: values between 0 and 1 wipe the art in from the left (and
grow the leader line, in Callout layout). Panel transitions are instant today. Give a
transition a duration and the wipe animates for free.

## Mesh

`ncho_callouts`, at the **avatar root** (the curves bind to that path), one SkinnedMeshRenderer
with `callouts.mat`:

- one quad per tooltip, ~1 mm **in the FBX**, at the anchor centroid, weighted **100%** to its
  anchor bone;
- **UV0:** the quad's corners exactly on its atlas cell's corners, e.g. chest = u 0..0.25,
  v 0.75..1 (v = 0 is the bottom, so row 0 sits at the top);
- **UV1:** the same corners as 0..1, in matching orientation.

The shader recovers the cell as `floor(uv0 * grid - uv1 + 0.5)`, so UV0 and UV1 must agree
corner for corner.

In Blender it's the object `ncho_callouts`, in the `ncho` export collection, parented to
`Armature` with an Armature modifier and one vertex group per anchor bone. The quads are placed
in **rest** space so that the **export pose** puts each one on its panel centroid. Each rest
position is `(pose_bone.matrix @ bone.matrix_local⁻¹)⁻¹ @ centroid`, which must be computed with
the file in its export state (`export_avatar.prepare()`).

**Quad size: editable in the `.blend`, tiny in the FBX.** In `ncho.blend` the quads are 0.5 BU
squares, facing front, so they can be seen, selected and moved. The shader reads every vertex
as its tooltip's anchor, so they must ship ~1 mm: `export_avatar.py` (`shrink_quads`, configured
per character) scales each face about its own centre to 0.001 BU, in memory, and self-checks
that every posed centre stayed put. Exporting any other way ships big quads, which add their
real size to each tooltip and turn with the bone; `CalloutTests` fails on that
(`Mesh_QuadsShipTiny_SoEachVertexIsItsAnchor`). So:

- **move** a quad freely (in Edit Mode, all four vertices together): its centre is the anchor;
- keep each one a flat, single-bone **quad**; size and rotation don't matter, since export
  discards them;
- a new tooltip is a new quad, same rules as above, with its UVs on its own cell.

Enlarging them (2026-11-10, from 1 mm) moved the anchors by up to 0.00024 BU (float32
rounding); immaterial.

**Safety fallback:** the shader is tagged `"VRCFallback"="Hidden"`, so a viewer who has blocked
your shaders sees nothing, rather than the quads drawn in a fallback shader. Viewers who block
**animations** see nothing anyway: `_CalloutOn*` stays at its default 0.

**Culling:** Unity culls the renderer by its bounds, which only enclose the anchors. A tooltip
onscreen while all of ncho is just off it disappears. Enlarge the SkinnedMeshRenderer's
bounds if that ever shows up.

## Art

`tooltip_atlas.png` is a **placeholder** in the HUD's style: 128×128, 4×4 cells of 32×32,
1-px white on transparent, `+` corner marks, a centre `+` on the anchor point, tiny lowercase
text. Draw the real ones in Aseprite. Rules:

- **Square cells** give square tooltips. The shader reads each cell's aspect ratio from the
  texture size and `_AtlasGrid`, so any cell size works, but every cell in one atlas has the
  same size.
- **The cell's centre is the anchor point.**
- Keep the dimensions **power of two** (`nPOTScale: 0`): a rescale would change the cell
  aspect.
- Import it **Bilinear, no mipmaps, no compression** (the placeholder's `.meta` has this).
  `_PixelArt` (on by default) snaps sampling to texel centres and blends only across a
  one-pixel band at texel edges, so the art stays crisp at any non-integer scale. It needs
  bilinear filtering to do that; Point filtering would shimmer.
- Keep a transparent 1-texel gutter at cell edges where possible; sampling is also clamped
  half a texel inside the cell.
- Colour can be painted in, or the art kept white and tinted with `_Color`.

## Tuning

`_LabelHeight` (fraction of screen height, default 0.06), `_DepthPush` (m), `_FadeStart` /
`_FadeEnd` (m, default 20 / 30), `_PixelArt`, `_LayoutMode`, `_StereoDepth`; for Callout layout also
`_LineWidth`, `_DotSize`, `_Nudge*`, `_AutoSide*`.
