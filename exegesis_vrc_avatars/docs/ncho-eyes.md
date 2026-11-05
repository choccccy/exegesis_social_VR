# ncho LED eyes

ncho's "eyes" are not eyes. They are LED strips: on each side of the face, two chevrons sit
side by side, front to back. Seen from ncho's left they read `<<`, and from the right `>>`. They
are pure **emission**: individual LED pixels switch on or off on the avatar's 512,
point-filtered, unmipmapped grid. Nothing deforms.

**Status:** phase 1 is a standalone prototype shader for fast iteration. Phase 2 will port the
same logic into a Poiyomi 11 module, built from the official
[modular shader docs](https://www.poiyomi.com/modular-shader-system). Do **not** use the
third-party `Assets/Editor/Poi_PS1` module as a template; it is suspected of causing lag on some
machines.

## Behaviour

| Input (VRCFT) | Effect |
|---|---|
| `v2/EyeX` (combined) | Forward lights only the **front** chevron on each side. Looking to ncho's **own left** (X > +deadzone, per in-editor testing; to be confirmed with live VRCFT) swaps the left side to its **rear** chevron, and the right stays front. Looking right mirrors this. The result is effectively binary. |
| `v2/EyeY` (combined) | Moves the blink window along the strip by `round(Y × maxShift)` texel columns (2 per LED): up shifts the lit pixels up, down shifts them down. Columns shifted in from past the end are dark. This stays readable when the eye is nearly closed. |
| `v2/EyeLidLeft/Right`, `v2/EyeSquintLeft/Right` | Per-eye blink. This reproduces the old spritesheet frames exactly; see below. |
| `EyeTrackingActive` | False gives **neutral static**: front chevrons, open, no shift, no blink. |

The blink frame reuses the old clips' mapping, but is **stateless**:

- Lid, as `[ncho]_blink`: `frame = clamp(5 − floor(lid × 10), 0, 5)`.
- Squint, as `[ncho]_slutty_eyes`: above 0.3 it raises the frame to at least 1 (below 0.4) or 2.
- The result is the more closed of the two. An LED is dark once `frame >= its column's off
  frame`.

This intentionally does **not** copy the FX layer's state machine:

- FX only *entered* the squint state while 0.5 < lid < 0.9.
- Once in it, FX ignored lid entirely until squint fell below 0.3. Its lid-based exit needs
  lid < 0.5 **and** lid > 0.9 at once, which can never be true, so you couldn't blink while
  squinting.

A shader has no state, and that hysteresis was an animator artifact anyway.

> Neutral lights **two** chevrons, where the old open frame lit all four. That is the spec, not a
> regression. It is also why phase 2 must gate the whole module behind an enable toggle that
> defaults off (rcs-thrusters.md ▸ Footguns ▸ 1).

## Texture layout (the non-obvious part)

The UV island is **rotated about 90°**, so in the emission texture the chevrons *look* stacked
vertically:

- **Texture down = face forward.** In each texture half, the chevron lower in the texture is the
  **front** one. Rear chevrons span rows 82–88 and front ones rows 86–92 (top-down rows). Their
  row bands overlap, so a row split cannot separate them; that is why the LED map exists.
- **Texture horizontal = face vertical.** The direction is mirrored per side and can't be read
  from the PNGs. That's what the `Flip Up Direction` calibration toggles are for.
- Each LED is **2 texels wide × 1 tall**, even-aligned. There are 144 LED texels, 36 per chevron.
- **The blink is a 1-D profile along the strip.** A texel's off frame depends only on its
  **texel** column within its chevron, never its row: the blink is an eyelid window closing
  toward the tip. It is per texel, not per LED, because the art's last lit pair (frame 4) sits
  at x = 235–236 and straddles two LEDs. Gaze Y relies on this, and the baker refuses to bake if
  it ever stops being true.
- The old blink sheet (`ncho_eye_blink_mask.png`) holds frame k (0 open … 5 closed) at rows
  `80−16k … 95−16k`, and `_EmissionMap_ST.w` stepped by 1/32 to select it. Frame 0 equals
  `ncho_eye_glow_mask.png` exactly.

## LED map

`Assets/_exegesis/ncho_eyes/ncho_eye_led_map.png` is baked by
**Tools > Exegesis > ncho Eyes > Bake LED Map** (`NchoEyeLedMapBaker.cs`) from the glow mask
(which texels are LEDs), the blink sheet (when each goes dark) and 8-connected components (which
chevron). It is RGBA8, point filtered, no mips, uncompressed and linear; the baker sets the
importer.

Each channel stores a small integer n as the byte `n × 8`. Non-LED texels are all zero, and
every LED texel is non-zero in all channels.

| Ch | Value |
|---|---|
| R | chevron + 1: 1 texture-left rear, 2 texture-left front, 3 texture-right rear, 4 texture-right front |
| G | off frame: first blink frame (1–5) at which the LED is dark |
| B | texel-column index from the chevron's texture-left end, + 1 |
| A | texel-column index from the chevron's texture-right end, + 1 |

**Blink-profile block**: the top-left corner stores each chevron's profile. Top-down row =
chevron id, x = texel column from the chevron's texture-left end, G = off frame. R = 0 there, so
it never reads as an LED. The shader reads it to evaluate the column a gaze-Y shift brings
in.

It is plain pixels and can be hand-corrected in Aseprite. `NchoEyeLedMapTests` then fails until
the baker agrees, which is intentional, so fix the baker rather than the PNG.

## Prototype shader

`Exegesis/ncho LED Eyes (proto)` lives in `ncho_eyes_proto.shader`. Its behaviour is all in
`ncho_eyes_core.cginc` (`NchoEyeLit`), which has no lighting or pipeline code, so the Poiyomi
module can reuse it unchanged. The shader does a single `Load` of the LED map per fragment.

Material sections:

- **Inputs**: the properties FX will drive (`_EyeLidL/R`, `_EyeSquintL/R`, `_EyeX`, `_EyeY`,
  `_EyeTrackingActive`).
- **Debug inputs**: *Use Debug Inputs* overrides all of the above with inspector sliders: lid and
  squint per eye (or linked), gaze X/Y and tracking active. Use it to test any lid/squint/gaze
  combination without the HMD. It also keeps working once the animator owns the real inputs.
  *Debug View* shows:
  - **Chevron**: red = ncho-left, blue = ncho-right, bright = front.
  - **Blink Off Frame**.
  - **Face Vertical**: green = up.
  - **Lit Mask**.
- **Calibration**: *Swap Sides* (whether the texture-left half is ncho's right; off is correct), *Flip Up Direction* per side, gaze-X deadzone, and gaze-Y max shift
  (in texels).
- **Blink tuning**: thresholds. The defaults match the old FX layer.

### Testing it

Put `ncho_eyes_proto.mat` (or any material on this shader with the LED map assigned) on a
duplicate of ncho's `Body`. Calibrate with *Debug View = Chevron*: bright red should be on
ncho's left, front. Then use *Face Vertical*: green should be at the top on both sides.
Re-run **Tools > Exegesis > ncho Eyes > Bake LED Map** only if the source masks change.

## Phase 2 (outline)

- **Module.** Write a Poiyomi module (`VRLM_` + `VRLTC_`) whose FunctionCall runs in
  `FRAGMENT_BASE_INIT_LATE`.
  - It writes `NchoEyeLit` into a global mask via `applyToGlobalMask`.
  - `ncho.mat` Emission 0 consumes that mask through `_EmissionMask0GlobalMask` (Multiply), so
    Poiyomi's emission code stays untouched.
  - Guard it with `//ifex` + `shader_feature_local`, with no vertex or grab work.
- **Locking.** Mark the driven `_Eye*` properties **Animated** before locking, or the lock bakes
  them to constants.
- **FX.** A generated layer (see animator-generation.md) copies the FT params into the material
  floats. The old `blink` layer's `_EmissionMap_ST` driving is retired.
- **Params.** Sync `FT/v2/EyeLidLeft/Right`, `EyeSquintLeft/Right`, `EyeX`, `EyeY` and
  `EyeTrackingActive`, replacing the combined `EyeLid`/`EyeSquint`. Check the bit budget.
