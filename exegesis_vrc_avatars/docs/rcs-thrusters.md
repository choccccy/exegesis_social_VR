# RCS thrusters

`Shader "exegesis/RCSThruster"` — reaction-control thrusters for the ncho avatar.
Source: `Assets/_exegesis/thruster_shader/`. Material:
`Assets/_exegesis/ncho/ncho_tex/thrusters.mat`.
The pendulum IMU that supplies pitch and roll has its own doc: [rcs-imu.md](rcs-imu.md).

## The idea

Thrusters fire when the avatar **accelerates**, and the *correct* thrusters fire for both
translation and rotation.

The obvious way to build this — six UV regions, one per axis, each animated up and down by the
FX layer — has two dead ends. A thruster on a limb is authored assuming one facing, so moving
the limb makes it fire for the wrong direction; and per-axis emission curves can only ever
express translation, leaving small outboard attitude thrusters with nothing to hook into. Both
come from the same root cause: the decision of *how hard to fire* was being made at author
time, in UV space, when it can only be answered at runtime, in geometry space.

So the decision lives in the shader. Skinning runs before the vertex stage, which means
`v.vertex` and `v.normal` arrive **already posed**. Every thruster therefore knows its own
current exhaust direction and its own current lever arm, for free, every frame:

```
thrust   = -normal                     // reaction is opposite the exhaust
lever    = position - centreOfMass
torque   = cross(lever, thrust)        // what firing this would rotate the avatar about

throttle = dot(thrust, linearAccel) + dot(torque, angularAccel)
```

The first term is translation. The second is rotation, and it costs one cross product: a
thruster far off-axis has a large lever arm, so it answers strongly to commanded rotation and
weakly to translation — exactly what a small outboard attitude thruster should do. No
per-thruster authoring anywhere.

The animator's whole job shrinks to publishing commanded motion as a few vectors.

## Footguns

Four traps have each cost hours. Three of them have the same shape: **something reads as
"the whole system is broken" when one new thing is misconfigured.** Check this list before
investigating anything else.

| Symptom | Almost certainly | Check |
|---|---|---|
| A feature is added and the avatar goes dark, or a *different* feature stops working | A vertex-channel default that is not a no-op | The new property's default — see below |
| A gate does nothing; thrusters fire with the bool off | A generated clip that writes no curve | Clip curve counts — see below |
| An editor readout says a value is 0 while your eyes say otherwise | The readout, not the avatar | Use `_DebugView`, not editor scripts |
| Half of every cone lights at once | Direction read from the cone's radial normals | `_ThrustDirSource` must be 3 or 4, not 0 |

### 1. Every vertex-channel feature must default to a no-op

A mesh with no colour attribute reports vertex colour **white**, and an unpainted channel on a
mesh that has one reports **0**. Either way the shader receives a value nobody chose, so a
feature whose default is "active" is a feature firing against garbage on every unpainted mesh.

This bit three times:

| Channel | Feature | What the default did |
|---|---|---|
| G | Visibility groups | Unpainted → white → group 2 → gated by `wings_deployed`, off → **dark** |
| B | Rotation bias | Blue 0 with a hard split → torque × 0 → **rotation dead avatar-wide** |
| — | Group gating | No way to rule gating out mid-debug; `_GroupGateEnabled` retrofitted as an off-switch |

**So: ship the neutral value and make the behaviour opt-in.** `_RotThrusterLinGain` and
`_TransThrusterRotGain` default to **1** (no split); lower them only once the paint exists.
`_GroupEnable` defaults to all-on.

`NeutralDefaultTests` now enforces this against the compiled shader, so a non-neutral default
fails the suite rather than the avatar. Add any new vertex-keyed property to it.

**Corollary for debugging:** a feature that appears to break the system the moment it is added
is usually defaulting to "on" against unpainted data, not malfunctioning.

### 2. A generated clip that writes nothing

Every RCS state runs with **Write Defaults off** — that is what lets these layers stack without
fighting each other. The cost is that *a state playing an empty clip does not reset anything*:
the property keeps whatever it last held, which on a freshly-loaded avatar is the value saved
in `thrusters.mat`.

So a gate clip that should force `_GroupEnable.z` to 0 but contains **no curve at all** does
not fail loudly. The component holds the material's `1`, the group never gates, and the symptom
is *"the thrusters fire even when the bool is false"* — which reads as a shader or vertex-paint
bug and sends the search a long way from the cause.

Not hypothetical: in one otherwise-clean build, exactly one clip out of 38
(`rcs_group_thighs_stowed.anim`) serialized with `m_FloatCurves: []`, while every other clip in
the same run — including the identically-built `rcs_group_wings_stowed` — was correct. Three
defences now exist:

1. `MaterialClip`/`ParamClip` author curves on the in-memory clip and call `PersistClip`
   **afterwards**, so the asset is serialized with its curves already present rather than
   depending on a later `SetDirty`/`SaveAssets` flush.
2. `VerifyGeneratedClips()` runs at the end of every build, reloads each clip **from disk** and
   logs an error naming any with no curves. Reloading is the point — it checks what was
   serialized, not what the in-memory object believes.
3. `GeneratedClipTests` pins it from the other side: no generated clip may be curve-less, and
   each gate pair must drive its component to 0 in the off state and 1 in the on state, on
   **both** `Body` and `Props`.

To check by hand — an empty clip is ~1.3 KB against ~4.3 KB for a two-path gate clip:

```bash
for f in Assets/_exegesis/ncho/ncho_anim/rcs_generated/*.anim; do
  printf "%-42s %s\n" "$(basename $f)" "$(grep -c 'attribute: material' $f)"
done
```

Zero is expected **only** for the `*_smoothed_hi/lo` clips, which drive Animator *parameters*
rather than material properties. Any other zero is this bug.

### 3. Measure with the shader, never from an editor script

An editor-side readout of the live material was wrong in four separate ways in one evening, and
*every one produced plausible zeros rather than an error*:

| Mistake | Why it looks like a real fault |
|---|---|
| Read `renderer.material` | That is slot **[0]**, the Poiyomi base. `thrusters.mat` is slot [1]. |
| Read the material instance | Animated properties can live in a **MaterialPropertyBlock**; the instance still holds the asset's saved value. |
| Scene-wide search for the renderer | Av3Emulator spawns Clone / ShadowClone / MirrorReflection copies whose animator state is unrelated to the avatar you are looking at. |
| `Animator.GetFloat` for parameters | The emulator drives controllers through a **PlayableGraph**, so `runtimeAnimatorController` is null and parameters are unreachable that way. |

The trap underneath all four: **`Material.GetFloat`/`GetVector` return 0 for a property the
material does not declare.** A zero means either "the value is zero" or "you asked the wrong
object", and nothing distinguishes them.

The shader cannot be fooled by any of this — it reads whatever the renderer actually has. So
`_DebugView` is the source of truth, and `Tools > Exegesis > RCS Test Driver` deliberately only
*drives* the system rather than reporting on it.

**Meta-rule:** when a measurement says something is impossible and your eyes say otherwise,
suspect the measurement. The panel insisted the group gates never changed while the plumes were
visibly switching colour on screen. The eyes were right.

## Where the motion comes from

| Degree of freedom | Source | Notes |
|---|---|---|
| Linear X/Y/Z | Built-in `VelocityX/Y/Z`, differentiated | Deterministic, no contacts |
| Yaw | Built-in `AngularY`, differentiated | Ditto |
| Pitch / roll | PhysBone pendulum — [rcs-imu.md](rcs-imu.md) | VRChat exposes no parameter; **optional, not currently built** |

Acceleration is obtained by publishing both the live signal and an exponentially lagged copy of
it, and letting the **shader** subtract them. That keeps the animator free of arithmetic: it
only has to produce the lag, which a blend tree does natively.

## Files

| File | Role |
|---|---|
| `RCSThruster.shader` | Properties + a single additive pass. |
| `RCS_core.cginc` | Allocation maths, throttle curve, emission composite. |
| `Editor/RCSThrusterInspector.cs` | `ShaderGUI`, grouped in tuning order. |
| `Editor/RcsAnimatorSetup.cs` | Builds the FX layers. `Tools > Exegesis > Build RCS Animator Layers`. |
| `Editor/RcsTestDriver.cs` | Physically wiggles the avatar for testing. Drives only — see footgun 3. |
| `Tests/Editor/` | Compile, material-contract, generated-clip and golden-image tests. |

The inspector and setup script live in their own asmdef (`Exegesis.RcsThruster.Editor`) because,
per [testing.md](testing.md), a test asmdef cannot reference the predefined
`Assembly-CSharp-Editor`.

## Rendering

Additive (`Blend One One`), `ZWrite Off`, no lighting, no fog, single pass, queue Transparent.
Additive is order-independent, so unlike the Poiyomi transparent prototype this pays nothing
for sorting. There is deliberately **no `Fallback`**: a fallback would add a ShadowCaster pass,
and an emissive plume face must not cast shadows.

`_Cull` defaults to **Off**, matching the Poiyomi prototype. Throttle is unaffected by cull mode
— a back face still evaluates the outward normal, so it fires with its front face rather than
against it — but with `Cull Off` and `ZWrite Off`, faces on the far side of a closed nozzle add
through the near ones and roughly double the brightness. Set it to Back if that reads wrong.
(The golden rig forces Back for a separate reason; see [Testing](#testing).)

`DisableBatching` is on, because the allocation reads object-space position and batching would
rewrite it.

The material sits in slot **[1]** of both the `Body` and `Props` skinned mesh renderers, covering
a submesh of dedicated emissive faces. Those faces are **truncated cones** extending off each
thruster point. Cone housings and painted panels stay on the base materials (`ncho.mat`,
`ncho_props.mat`).

Masks are imported as **R8**; the shader samples `.r`.

## Where the exhaust direction comes from

**Not the surface normal — that only works for a flat nozzle disc.** The emissive thrusters are
truncated cones, and a cone's side wall normals point **radially outward**, perpendicular to the
axis. Feeding those in lights the half of every cone whose normals face away from the commanded
acceleration — all cones at once, regardless of masking. If you ever see "half of everything is
firing", this is the cause.

The axis comes from the **tangent frame** instead. The masks run their gradient along each
cone's length, so V is the axial UV direction, which makes the bitangent — the direction of
increasing V — the cone axis. Unity skins tangents along with normals, so this stays correct
through any pose, preserving the limb-tracking property that motivates the whole design.

| `_ThrustDirSource` | Source | Use for |
|---|---|---|
| 0 | Skinned normal | Flat nozzle discs only |
| 1 | Vertex colour | Baked axis. **Never skinned** — rest pose only, so not for limbs |
| 2 | Tangent (U) | Cones whose axis runs along U |
| 3 | Bitangent (V) | Cone bells alone |
| 4 | **Mixed, by vertex red** | **ncho** — cone bells *plus* flat caps |

### Mixed geometry (mode 4)

Each plume is a cone **bell** plus a flat **octagonal diaphragm**. The diaphragm is not a cap at
the far end — it sits a short way out from the nozzle, offset to avoid z-fighting, and the plume
continues past it. Think of a cup with its base at the thruster: water would stay in a plume
pointing at the sky and pour out of one pointing at the ground.

These need different sources and there is no way around it: a flat face's tangent *and*
bitangent both lie in its own plane, so no UV layout can point either along its normal. For the
diaphragm the axis simply **is** the normal; for the bell it is the bitangent.

**They also need opposite signs.** The diaphragm sits at the base of the cup, so its outward
normal points back down the axis at the nozzle while the bell around it points outward. Hence
`_CapNormalFlip` is a separate control from `_ThrustDirFlip` — one shared flip could never make
the two agree. On ncho, `_CapNormalFlip = 1`.

Mode 4 selects per vertex on **red**:

- **R = 1** — bitangent (bells). This is what a mesh with no colour attribute reports, so
  untouched geometry behaves as mode 3 and mode 4 is safe to select early.
- **R = 0** — normal (caps). Only the caps need painting.

R is a **continuous blend**, not a binary flag, which is useful beyond caps: a truncated cone's
wall is slanted, so its bitangent runs along the *slant* and is off by the flare half-angle.
Easing R down from 1 mixes in the normal and tilts the result back toward the axis. Prefer
`_BellFlare` for that (below) — it needs no repainting — and keep R as the bell/diaphragm
selector.

#### What to paint

Only **red** is read for direction, and only on the thruster emissive submeshes (slot [1] on
Body and Props).

| Geometry | R | Meaning |
|---|---|---|
| Cone **bell** walls | **1.0** | Use the bitangent |
| Octagonal **cap** | **0.0** | Use the normal |

In Blender:

1. Add a **Color Attribute** — domain **Face Corner**, type **Byte Color**.
2. Fill the whole attribute **white**. Bells are then already correct and you never touch them.
3. Select **only the octagonal cap faces** and set them **black**. Only R matters, so black is
   simply the convenient way to write R = 0.
4. Export FBX with **Geometry ▸ Vertex Colors** set to sRGB (anything except *None*).

Repeat for both the Body and Props thruster meshes.

Two cautions:

- **The diaphragm shares vertices with the tube walls**, which is exactly why the domain must be
  **Face Corner**, not Vertex. Face Corner stores a value per face *per corner*, so one shared
  vertex can read black on its diaphragm corner and white on its wall corners simultaneously;
  Vertex domain has one value per vertex and physically cannot hold the step. Paint with **face
  selection masking** on. Unity's importer de-duplicates on the whole attribute tuple, colour
  included, so it splits those vertices automatically — the same mechanism that already splits
  UV seams and hard edges. (Fallback: Edge Split the boundary loop in Blender, after which
  Vertex domain works. Costs nothing in the exported mesh, since Unity would have split them
  anyway.)
- **The diaphragm/wall boundary must be a sharp edge.** Those faces need very different normals
  — axial versus radial — and a smooth-shaded boundary averages them, corrupting the diaphragm
  *and* the bell at the seam, the bell included because its bitangent derives from the normal.

If the base materials read vertex colours for anything, note that adding the attribute gives the
rest of the mesh white — usually neutral, but worth checking.

> Alternative to painting: assign the caps to a **third material slot** using a second material
> on the same shader with `_ThrustDirSource = 0`. No vertex attribute, no export settings, and
> no extra animator work — material animation applies to every material on a renderer that
> declares the property. The trade is one extra draw call per renderer.

### Flat-shade the cones

Smooth-shaded cones do not work. Smooth shading averages vertex normals across facets and across
the wall/diaphragm boundary, tilting the normals near the throat and dragging the derived
bitangent off-axis by an amount that varies around the circumference — visible as a gradient
across the bell, with one side lighting before the other. Flat shading gives each facet its own
radial normal and circumferential tangent, whose cross product is cleanly axial.

This needs tangents on the mesh — check `Import Tangents` is Calculate (the default) and not
None on the FBX, or the bitangent is garbage.

### Reading the direction debug colours

`_DebugView 1` outputs `direction * 0.5 + 0.5`, so in **object space**:

| Exhaust | Colour | | Exhaust | Colour |
|---|---|---|---|---|
| +X | salmon | | −X | teal |
| +Y | mint green | | −Y | magenta |
| +Z | periwinkle | | −Z | olive |

If every axis shows its **complement**, the tangent frame is inverted — set
`_ThrustDirFlip = 1`. That was ncho's case: V runs tip→throat.

Colours should **not** change if you rotate the avatar root, since this is object space. They
*should* change if you rotate a bone such as Hips — the thrusters genuinely moved relative to
the root, which is the pose tracking working.

The two sign controls are factored as **relative** and **global**, which makes them independent
to tune:

- **`_CapNormalFlip`** (relative) — makes the diaphragm agree with the bell around it. Set this
  first, judged by the two reading the same colour.
- **`_ThrustDirFlip`** (global) — reverses the whole resolved direction, applied *after* the
  source is picked. The "everything fires backwards" knob. Because it applies last it flips bell
  and diaphragm together, so their agreement survives.

`_ThrustDirFlip` deliberately applies to the **tangent-frame sources only**, not the raw normal:
the tangent sign depends on arbitrary UV authoring, whereas a surface normal always points out
of the mesh, which for a nozzle cap is already the exhaust direction. Flipping both would make
mode 4 impossible, since its two sources have to agree.

Both are 0/1 flags rather than ±1 multipliers because ShaderLab's `[Enum]` cannot express a
negative literal — a `-1` in there is a **parse error that fails the entire Properties block**,
and the material silently falls back to the magenta error shader.

### `_BellFlare` — correcting for the cone's slant

A truncated cone's wall is **slanted**, so V, and therefore the bitangent, runs along the slant
rather than the axis, tilted outward by the flare half-angle. Each facet tilts along its *own*
radial direction, so around the circumference the facets leaning toward the commanded
acceleration score a higher dot product than those leaning away. The symptom is a cone that
lights **brightest on the side facing the thrust** rather than uniformly, plus thrusters faintly
firing for directions they are not really part of.

The true axis is recoverable exactly, for half-angle `a`:

```
axis = cos(a) * bitangent + sin(a) * normal
```

`_BellFlare` is that angle in degrees, applied to the bitangent-derived sources (modes 3 and 4).
**Sign depends on the winding and UV direction**, so set it near your actual flare half-angle
and then adjust in `_DebugView 1` until each bell reads as **one flat colour** matching its own
diaphragm. If the gradient worsens, go negative.

There are two, because the Body and Props bells have different flare: **`_BellFlare` for groups
0–1, `_BellFlareProps` for group ≥ 2.** On ncho, 1.9° and 2.5° respectively. Both are typed
`Float`s rather than sliders because the useful values are small and need entering exactly.

Expect the correction to change *which* thrusters fire at the margins — the direction is more
accurate afterwards, so borderline cones may switch on or off. That is the fix working.

## Visibility groups

Some thrusters must go quiet regardless of what the allocation wants. Poiyomi's UV tile dissolve
on `ncho_props.mat` hides the backpack *geometry* but not `thrusters.mat`, so without a gate the
Props plumes fire with the pack stowed; and the Body thrusters the backpack physically covers
must go quiet while it is deployed.

The full vertex-colour budget:

| Channel | Use |
|---|---|
| **R** | Direction source — normal (diaphragm) versus bitangent (bell) |
| **G** | Visibility group |
| **B** | Translation versus rotation bias |
| A | Unused |

Membership rides in **green**, encoded as levels rather than one channel per group, which keeps
blue free:

| Painted G | Band | Group | Gated by | Live when | Used for |
|---|---|---|---|---|---|
| `0.00` | `< 0.125` | 0 | never gated | always | every ordinary thruster |
| `0.25` | `0.125 … 0.375` | **3** | `_GroupEnable.z` | `thigh_thrusters` on | thigh pack plumes |
| `0.50` | `0.375 … 0.75` | 1 | `_GroupEnable.x` | **neither** `thruster_backpack` **nor** `arm_backpack` on | Body back thrusters the packs cover |
| `1.00` | `≥ 0.75` | 2 | `_GroupEnable.y` | `wings_deployed` on | backpack plumes |

Index 3 is out of numeric order on purpose: keeping `0.5 → 1` and `1.0 → 2` preserves what
existing paint already means, so adding a group repaints nothing.

**Convention worth keeping:** Body groups take indices 0–1, Props groups 2 and up. The flare
selector is `index >= 1.5 → _BellFlareProps`, so following that convention keeps flare selection
correct as props are added, with no per-group maintenance — both Props levels (`0.25` and `1.0`)
already land at index ≥ 2.

The gate multiplies the finished throttle, so it is unaffected by deadzone and sharpness shaping
and fades rather than pops if the toggle blends.

**Unpainted geometry is DARK, not ungated** — white → group 2 → `wings_deployed`, off by
default. Paint every thruster mesh explicitly; see footgun 1. (`group_gated` in the golden suite
exists to keep this from being forgotten a fourth time.)

**Colour-space conversion: measured, not assumed.** This was the design's biggest unknown,
because an authored `0.5` could in principle arrive as `0.214` (sRGB→linear) or `0.735`
(linear→sRGB) — a spread wider than any usable band, which is why the encoding originally
allowed only two gated groups. `_DebugView 6` settled it: **this pipeline applies no conversion
at all.** Authored `1.0` arrives as `1.0`, `0` as `0`, and `0.5` as `0.498` — byte 127/255,
integer quantisation only. Evenly spaced levels are therefore safe, every level sits ~0.125 from
its nearest boundary, and green has room for **5–6 levels** if more prop groups are needed.

Re-run that calibration if the FBX export settings or Unity's colour space ever change, and
confirm membership with `_DebugView 3`.

**When painting G, preserve R** — it still carries the bell-versus-diaphragm selection, so lock
the red channel rather than flood-filling. Until a mesh is repainted it sits at whatever it had;
G = 0 (group 0, never gated) is the benign direction to be wrong in.

## Translation versus rotation bias

Vertex **blue** biases a thruster toward one job: `0` = translation, `1` = rotation. Rotation
thrusters are the outboard ones — wingtips, wrists, ankles — where the lever arm is long.

The two gains are how much authority a thruster keeps in the *other* job:

| Property | Applies to | At 1 | At 0 |
|---|---|---|---|
| `_RotThrusterLinGain` | blue = 1 thrusters | keep full linear response | pure attitude thrusters |
| `_TransThrusterRotGain` | blue = 0 thrusters | keep full torque response | pure translation thrusters |

Both **ship at 1, meaning no split at all** — see footgun 1, because shipping
`_TransThrusterRotGain = 0` against unpainted blue multiplied the torque term by zero on every
thruster and killed rotation avatar-wide. Lower them toward 0 only once the blue paint exists.

## `_CoM` lives in a different space to the IMU

`_CoM` is the centre of mass in the **Body / Props renderer's object space** — the same space as
the posed mesh vertices, since the shader computes `lever = posOS - _CoM`. For a human-scale
avatar whose renderers sit at the root with identity transforms, that is metres with the origin
at the feet, so the hips land around `(0, 0.9, 0)`.

It is **not** the IMU anchor's position, and **not** Hips-local space. Those are easy to conflate
because both describe "a point up the body", but the bone hierarchy on this avatar is scaled
(~0.1) while renderer object space is not. Pasting the anchor's local `(0, 4.38, 0.55)` into
`_CoM` puts the centre of mass four metres above the avatar, which lengthens and flips every
lever arm and quietly wrecks the whole torque allocation.

Quick unit check: `View Position` on the VRC Avatar Descriptor is in avatar-root space, so if it
reads roughly `1.6` the root really is in metres and `_CoM` belongs in that range.

## Animation-contract properties (DO NOT rename)

Driven by name from the `rcs_*` layers of `ncho_fx.controller`. Renaming any of them silently
breaks the avatar — the same trap described in [project.md](project.md). `ShaderCompileTests` and
`MaterialStateTests` pin their existence.

```
_RCS_Vel  _RCS_VelSmoothed  _RCS_AngVel  _RCS_AngVelSmoothed
_RCS_ImuDeflect  _RCS_Master
```

`_RCS_Vel` and `_RCS_VelSmoothed` are **normalised to ±1** by the publish layer so the shader's
gains stay unitless. The full-scale values are `VelMax` / `AngMax` in `RcsAnimatorSetup` — read
them there rather than trusting a number quoted here. Everything else on the shader is free to
rename.

## FX layers

Built by `Tools > Exegesis > Build RCS Animator Layers`, which is idempotent: it deletes and
rebuilds every layer whose name starts `rcs_` and wipes `ncho_anim/rcs_generated/`. Teardown
matches on that **prefix**, not a name list — an earlier rename left an orphan layer behind
because its old name was no longer in the list. Prefer re-running the tool over hand-editing;
the controller has far too many layers to edit safely by hand.

| Layer | Does |
|---|---|
| `rcs_smooth` | `smoothed = Lag*smoothed + (1-Lag)*live` per axis, per frame. |
| `rcs_pub_*` (one per axis, live and lagged) | Normalises each value onto the material. |
| `rcs_imu` | Sums the four contact proximities into a signed `_RCS_ImuDeflect`. |
| `rcs_master` | Two-state menu toggle on the `rcs` bool. |
| `rcs_group_packs` | `_GroupEnable.x` |
| `rcs_group_wings` | `_GroupEnable.y` |
| `rcs_group_thighs` | `_GroupEnable.z` |

Two Unity behaviours make this compact:

- **A Direct blend tree with "Normalize Blend Values" off sums its children.** Children writing
  *different* properties coexist in one tree; children writing the *same* property sum, which is
  how the smoother's lerp and the IMU's signed pairs work.
- **Animation clips can drive Animator parameters**, not just component properties. That is what
  lets `rcs_smooth` feed a parameter back into itself.

All states are Write Defaults **OFF**, matching the rest of the controller — which is what makes
footgun 2 possible, so read it before adding a layer. The `rcs_imu` tree carries a
constant-weight base child writing zero, so its output is defined even when every receiver reads
zero (including when Avatar Dynamics is off entirely).

`RCS_Lag` / `RCS_LagInv` / `RCS_One` are animator-only floats that are never animated; with
Write Defaults off they simply sit at their defaults.

## Debugging with `_DebugView`

Emission alone cannot distinguish a wrong *direction* from a wrong *command*, and guessing
between the two is how the cone-normal bug survived as long as it did.

| View | Shows | Read it as |
|---|---|---|
| **1** | Thrust direction as RGB | Each cone one **flat** colour; opposite cones complementary. A rainbow around the circumference means radial normals, not the axis. |
| **2** | Raw throttle, greyscale | Before masks and flicker. |
| **3** | Visibility group | grey 0 · green 1 · blue 2 · magenta 3 |
| **4** | Factors | See below — the one that says *why* a thruster is dark. |
| **5** | Rotation bias | From vertex blue. |
| **6** | Raw green | The colour-space calibration view. |

**View 4** decomposes `throttle = allocation × master × gate` into channels:

| Channel | Factor | Dark means |
|---|---|---|
| **Red** | `_RCS_Master` | the master toggle is off |
| **Green** | group gate | that group is gated off |
| **Blue** | raw allocation | no commanded motion is reaching it |

White means all three are live. Read it **while moving** — blue is supposed to be dark at rest,
since a stationary avatar commands no acceleration, so **yellow at rest is correct, not a
fault.** Magenta means the allocation *is* arriving and the gate is what is stopping it, which is
the single most useful reading in the whole system: it proves the animator chain works.

## Tuning order

Each step isolates one thing; out of order means chasing your own tail.

1. `_SustainWeight = 1`, gains 0 → thrusters follow raw velocity. Confirms the publish layer and
   settles **whether `VelocityX/Y/Z` are player-local or world**: strafe while facing different
   directions and watch which thrusters fire. Flip `_VelSpace` if wrong.
2. Back to `_SustainWeight = 0`. Tune `_AccelGain`, `_Deadzone`, `_Sharpness` by walking,
   stopping hard, and reversing. Braking burns should appear when you stop.
3. Turn in place to tune `_AngAccelGain`. Outboard thrusters should fire in opposed pairs.
4. `_BellFlare` / `_BellFlareProps` per bell mesh, judged in `_DebugView 1`.
5. If the IMU is built, calibrate it per [rcs-imu.md](rcs-imu.md).
6. Raise an arm and translate. Limb thrusters should stay correct through the whole arc — the
   check the naive UV-region design could not pass.
7. Check in a mirror and from a second client: contacts and PhysBones simulate per-client, so
   remote viewers should see it fire.

### Frame-rate compensation

`rcs_smooth` applies its lag once per animator **update**, not per second. Under a constant
acceleration `a` the live-minus-lagged difference settles at `a * dt * L/(1-L)`, so the raw
reading scales with frame time — at 90fps it is half what it is at 45fps, and thruster
brightness would track the viewer's framerate rather than the avatar's motion.

`_AccelTimeCorrect` (on by default) multiplies the estimate by `1/dt` from `unity_DeltaTime.w`,
cancelling that term. It uses *smoothed* delta time deliberately: dividing by a per-frame-jittery
`dt` would turn frame-pacing noise straight into brightness flicker.

This fixes pulse **amplitude**, which is the part you see. Pulse **duration** still varies, per
[Known limits](#known-limits). The IMU path is not corrected and never needed to be — PhysBones
simulate against real time, so pitch and roll were always framerate-independent.

Because the estimate is multiplied by roughly `1/dt` (~90 at 90fps), `_AccelGain` and
`_AngAccelGain` are around 60× smaller than they would be with compensation off. The golden
harness forces `_AccelTimeCorrect = 0`, since `unity_DeltaTime` is not deterministic across
renders and the baselines pin allocation, not timing.

### `_SustainWeight`

The system is tuned for physically honest **acceleration-only** firing. The known risk: in
VRChat you hold a constant velocity most of the time, so pure-accel thrusters idle a lot and can
read as broken. It is a material float rather than a code path precisely so that dialling in some
velocity-follow is a slider drag in-headset, not a rebuild.

## Testing

See [testing.md](testing.md) for the headless clone workflow; the RCS suite plugs into it.

| File | Pins |
|---|---|
| `ShaderCompileTests` | Found, supported, zero compile errors, one pass, all contract properties declared. |
| `MaterialStateTests` | `thrusters.mat` binds the RCS shader, transparent queue, contract properties resolve, `_RCS_Master` saved at 1. |
| `MaterialBindingTests` | That a **slot-[1]** material is reachable by the plain `material._Prop` binding the clips use. |
| `NeutralDefaultTests` | Footgun 1 — vertex-keyed features ship a no-op default. |
| `GeneratedClipTests` | Footgun 2 — no generated clip is curve-less; every gate pair drives 0 and 1 on both renderers. |
| `GoldenImage/` | The allocation maths, rendered. |

**The golden rig is a cube**, which is close to ideal: its six faces have exactly the six
±X/±Y/±Z normals, so each face behaves as one thruster pointing down one axis. Firing a commanded
acceleration and checking which faces light tests the maths through the real shader without
duplicating it in C#. The camera sits on a diagonal and sees three faces (+X, +Y, −Z); states
that should light a *hidden* face are the sign-convention pins and are expected to render black.

Two assertion layers, deliberately. A **semantic** check (states flagged `ExpectDark` must render
nothing, the rest must render something) runs even in capture mode — a freshly captured baseline
would otherwise happily enshrine a flipped sign, because a pixel diff can only tell you the
render changed, never that it was ever right. Then the usual pixel diff catches everything else.

Unlike the HUD harness, this does **not** clone the live material: `thrusters.mat` is meant to be
re-tuned constantly, and goldens built on it would fail every time a colour moved. The canonical
test values live in `RcsRenderHarness`.

```powershell
# capture baselines (also honours the shared -Capture switch), eyeball, then commit
powershell Tools/headless-tests/run_headless_tests.ps1 -Capture -TestFilter Exegesis.RcsThruster.Tests
# regression
powershell Tools/headless-tests/run_headless_tests.ps1 -TestFilter Exegesis.RcsThruster.Tests
```

`RCS_CAPTURE_BASELINES=1` captures this suite alone; the run script's `-Capture` sets
`HUD_CAPTURE_BASELINES=1`, which both suites honour.

## Known limits

- **PC only.** Custom shaders are not permitted on Quest/Android.
- **Pulse duration is still framerate-dependent** (amplitude is not — see above). The lag's time
  constant is `-dt/ln(L)`, and there is no way to feed `dt` back into an animator, so the tail of
  each burn is shorter at high framerates. Only the decay length varies.
- Thrusters do not react to a limb's *own* acceleration (waving an arm). That needs per-limb
  temporal state, which a stateless fragment shader cannot hold.
- The allocation assumes renderer-object space is avatar-root space, which holds while `Body` and
  `Props` have identity local transforms under the root.

## Deferred

- **Growing plume geometry.** Throttle is already computed per-vertex, so the vertex path only
  needs `v.vertex.xyz += plumeAxis * u * _PlumeLength` gated on a mask channel — a Blender job,
  not a shader rewrite. PS1-style vertex rounding on the plumes belongs with it.
- The pendulum IMU, if pitch and roll are missed — [rcs-imu.md](rcs-imu.md) is a complete spec.
- A second pendulum, if pitch/roll redundancy is ever wanted. Additive; `_RCS_ImuDeflect` already
  carries the readout.
- Hover/idle behaviour off the existing `Grounded` parameter: downward thrusters ticking over to
  "hold" the avatar up.
