# RCS thrusters

`Shader "exegesis/RCSThruster"` — reaction-control thrusters for the ncho avatar.
Source: `Assets/_exegesis/thruster_shader/`. Material:
`Assets/_exegesis/ncho/ncho_tex/thrusters.mat`.

## The idea

Thrusters fire when the avatar **accelerates**, and the *correct* thrusters fire for both
translation and rotation.

The obvious way to build this — six UV regions, one per axis, each animated up and down by
the FX layer — has two dead ends. A thruster on a limb is authored assuming one facing, so
moving the limb makes it fire for the wrong direction; and per-axis emission curves can only
ever express translation, leaving small outboard attitude thrusters with nothing to hook
into. Both come from the same root cause: the decision of *how hard to fire* was being made
at author time, in UV space, when it can only be answered at runtime, in geometry space.

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
thruster far off-axis has a large lever arm, so it answers strongly to commanded rotation
and weakly to translation — exactly what a small outboard attitude thruster should do. No
per-thruster authoring anywhere.

The animator's whole job shrinks to publishing commanded motion as a few vectors.

## Where the motion comes from

| Degree of freedom | Source | Notes |
|---|---|---|
| Linear X/Y/Z | Built-in `VelocityX/Y/Z`, differentiated | Deterministic, no contacts |
| Yaw | Built-in `AngularY`, differentiated | Ditto |
| Pitch / roll | PhysBone pendulum + contact receivers | VRChat exposes no parameter for these |

Acceleration is obtained by publishing both the live signal and an exponentially lagged copy
of it, and letting the **shader** subtract them. That keeps the animator free of arithmetic:
it only has to produce the lag, which a blend tree does natively.

Pitch and roll have no VRChat parameter at all, hence the pendulum. Because linear
acceleration is already known from the built-ins, only *one* pendulum is needed rather than
a differencing pair: it sees `a_linear + (α × r)`, and subtracting the known `a_linear`
leaves `α × r`, which for `r = (0, h, 0)` resolves straight into roll and pitch.

This split also fails gracefully. A viewer who disables Avatar Dynamics in their safety
settings loses pitch and roll only — translation and yaw keep working. A design that read
everything from pendulums would go completely dead for that viewer.

## Files

| File | Role |
|---|---|
| `RCSThruster.shader` | Properties + a single additive pass. |
| `RCS_core.cginc` | Allocation maths, throttle curve, emission composite. |
| `Editor/RCSThrusterInspector.cs` | `ShaderGUI`, grouped in tuning order. |
| `Editor/RcsAnimatorSetup.cs` | Builds the FX layers. `Tools > Exegesis > Build RCS Animator Layers`. |
| `Tests/Editor/` | Compile, material-contract and golden-image tests. |

The inspector and setup script live in their own asmdef (`Exegesis.RcsThruster.Editor`)
because, per [testing.md](testing.md), a test asmdef cannot reference the predefined
`Assembly-CSharp-Editor`.

## Rendering

Additive (`Blend One One`), `ZWrite Off`, no lighting, no fog, single pass, queue
Transparent. Additive is order-independent, so unlike the Poiyomi transparent prototype
this pays nothing for sorting. There is deliberately **no `Fallback`**: a fallback would
add a ShadowCaster pass and an emissive plume face must not cast shadows.

`_Cull` defaults to **Off**, matching the Poiyomi prototype. Throttle is unaffected by cull
mode — a back face still evaluates the outward normal, so it fires with its front face
rather than against it — but note that with `Cull Off` and `ZWrite Off`, faces on the far
side of a closed nozzle add through the near ones and roughly double the brightness. Set it
to Back if that reads wrong. (The golden rig forces Back for a separate reason; see below.)

`DisableBatching` is on, because the allocation reads object-space position and batching
would rewrite it.

The material sits in slot **[1]** of both the `Body` and `Props` skinned mesh renderers,
covering a submesh of dedicated emissive faces. Those faces are **truncated cones** extending
off each thruster point — similar in structure on both meshes. Cone housings and painted
panels stay on the base materials (`ncho.mat`, `ncho_props.mat`).

## Where the exhaust direction comes from

**Not the surface normal — that only works for a flat nozzle disc.** The emissive thrusters
are truncated cones, and a cone's side wall normals point **radially outward**, perpendicular
to the axis. Feeding those in lights the half of every cone whose normals face away from the
commanded acceleration — all cones at once, regardless of masking. If you ever see "half of
everything is firing", this is the cause.

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

Each plume is a cone **bell** plus a flat **octagonal diaphragm**. The diaphragm is not a cap
at the far end — it sits a short way out from the nozzle, offset to avoid z-fighting with the
thruster surface, and the plume continues past it. Think of a cup with its base at the
thruster: water would stay in a plume pointing at the sky and pour out of one pointing at the
ground.

These need different sources and there is no way around it: a flat face's tangent *and*
bitangent both lie in its own plane, so no UV layout can point either along its normal. For
the diaphragm the axis simply **is** the normal; for the bell it is the bitangent.

**They also need opposite signs.** Because the diaphragm sits at the base of the cup, its
outward normal points back down the axis at the nozzle, while the bell around it points
outward. Hence `_CapNormalFlip` is a separate control from `_ThrustDirFlip` — one shared flip
could never make the two agree. On ncho, `_CapNormalFlip = 1`.

Mode 4 selects between the two sources per vertex:

- **R = 1** — bitangent (bells). This is the default a mesh reports when it has no colour
  attribute at all, so untouched geometry behaves as mode 3.
- **R = 0** — normal (caps). Only the caps need painting.

Until the caps are painted, mode 4 is identical to mode 3, so it is safe to select early.

R is a **continuous blend**, not a binary flag, and that is useful beyond caps. A truncated
cone's wall is slanted, so its bitangent runs along the *slant* rather than the axis and is
off by the flare half-angle — a few degrees on a narrow nozzle, but noticeable on a wide
bell. Easing R down from 1 mixes in the normal and tilts the result back toward the axis.
Judge it with `_DebugView 1`: a bell should end up the same colour as its own cap.

#### Exactly what to paint

Only the **red** channel of vertex colour is read, and only on the thruster emissive
submeshes (material slot [1] on Body and Props). Green, blue and alpha are ignored.

| Geometry | R | Meaning |
|---|---|---|
| Cone **bell** walls | **1.0** | Use the bitangent |
| Octagonal **cap** | **0.0** | Use the normal |
| Wide bells that still read wrong | 0.7–0.95 | Tilt off the slant toward the axis |

In Blender:

1. On the thruster mesh add a **Color Attribute** — domain **Face Corner**, type **Byte
   Color**. Face Corner rather than Vertex so the cap/bell boundary can hold a hard step
   even where they share an edge loop.
2. Fill the whole attribute **white**. Bells are then already correct and you never touch
   them. (This also matches what Unity reports for a mesh with no colour attribute at all,
   which is why untouched geometry behaves as mode 3.)
3. Select **only the octagonal cap faces** and set their colour to **black**. Only R
   matters, so pure black is simply the convenient way to write R = 0.
4. Export FBX with **Geometry ▸ Vertex Colors** set to sRGB (anything except *None*).

Repeat for both the Body and Props thruster meshes.

Two cautions:

- **The diaphragm shares vertices with the tube walls**, which is precisely why the domain
  must be **Face Corner** and not Vertex. Face Corner stores a value per face *per corner*,
  so one shared vertex can read black on its diaphragm corner and white on its wall corners
  at the same time; Vertex domain has one value per vertex and physically cannot hold the
  step. Paint with **face selection masking** enabled so only the selected faces' corners
  are written. Unity's importer de-duplicates on the whole attribute tuple, colour included,
  so it splits those vertices automatically on import — the same mechanism that already
  splits UV seams and hard edges. (Fallback: Edge Split the boundary loop in Blender so the
  verts genuinely duplicate, after which Vertex domain works. Costs nothing in the exported
  mesh, since Unity would have split them regardless.)
- **The diaphragm/wall boundary should be a sharp edge.** Those faces need very different
  normals — axial versus radial — and a smooth-shaded boundary averages them, which corrupts
  the diaphragm *and* the bell at the seam, the bell included because its bitangent derives
  from the normal.
- **0 and 1 are safe under any colour conversion**; intermediate values may be gamma-shifted
  on import. Tune those by eye with `_DebugView 1` rather than computing a number.

If the base materials (`ncho.mat`, `ncho_props.mat`) read vertex colours for anything, note
that adding the attribute gives the rest of the mesh white — usually neutral, but worth
checking.

#### Alternative: a caps material instead of painting

If vertex colours are more trouble than they are worth, assign the octagonal caps to a
**third material slot** using a second material on the same shader with
`_ThrustDirSource = 0` (normal), leaving the bells on `thrusters.mat` at mode 3. No vertex
attribute, no export settings, and **no extra animator work** — material animation applies
to every material on a renderer that declares the property, so the existing clips drive both.

The trade is one extra draw call per renderer. Vertex painting is the leaner runtime; the
extra slot is the faster authoring path.

### Reading the debug colours

`_DebugView 1` outputs `direction * 0.5 + 0.5`, so in **object space**:

| Exhaust | Colour |
|---|---|
| +X | salmon | 
| −X | teal |
| +Y | mint green |
| −Y | magenta |
| +Z | periwinkle |
| −Z | olive |

If every axis shows its **complement** (+Y magenta, +Z lime, −X red-orange), the tangent
frame is inverted — set `_ThrustDirFlip = 1`. That was ncho's case: V runs tip→throat.

`_ThrustDirFlip` deliberately applies to the **tangent-frame sources only**, not to the raw
normal. The tangent sign depends on arbitrary UV authoring, whereas a surface normal always
points out of the mesh — which for a nozzle cap is already the exhaust direction. Flipping
both would make mode 4 impossible, since its two sources have to agree.

Colours should **not** change if you rotate the avatar root, since this is object space. They
*should* change if you rotate a bone such as Hips, because the thrusters genuinely moved
relative to the root — that is the pose tracking working.

The two sign controls are factored as **relative** and **global**, which makes them
independent to tune:

- **`_CapNormalFlip`** (relative) — makes the diaphragm agree with the bell around it.
  Set this first, judged by the two reading the same colour in `_DebugView 1`.
- **`_ThrustDirFlip`** (global) — reverses the whole resolved direction, applied *after*
  the source is picked. This is the "everything fires backwards" knob. Because it applies
  last it flips bell and diaphragm together, so their agreement survives.

Both are 0/1 flags rather than ±1 multipliers because ShaderLab's `[Enum]` attribute cannot
express a negative literal — a `-1` in there is a **parse error that fails the entire
Properties block**, and the material silently falls back to the magenta error shader.

### Flat-shade the cones

Smooth-shaded cones do not work. Smooth shading averages vertex normals across facets and
across the wall/diaphragm boundary, which tilts the normals near the throat and drags the
derived bitangent off-axis by an amount that varies around the circumference — visible as a
gradient across the bell and one side lighting before the other. Flat shading gives each
facet its own radial normal and circumferential tangent, whose cross product is cleanly
axial. Keep the wall/diaphragm boundary sharp too.

This requires tangents on the mesh — check `Import Tangents` is Calculate (the default) and
not None on the FBX, or the bitangent is garbage.

### Debugging with `_DebugView`

Emission alone cannot distinguish a wrong *direction* from a wrong *command*, and guessing
between the two is how the cone-normal bug survived as long as it did.

- **1 — Thrust direction as RGB.** Each cone should read as **one flat colour**, and two
  cones pointing opposite ways should be complementary. A cone showing a rainbow around its
  circumference means the direction source is reading radial normals rather than the axis.
- **2 — Raw throttle**, greyscale, before masks and flicker.

Masks are imported as **R8**; the shader samples `.r`, so that is the right format.

## Visibility groups

Some thrusters must go quiet regardless of what the allocation wants. Poiyomi's UV tile
dissolve on `ncho_props.mat` hides the backpack *geometry* but not `thrusters.mat`, so
without a gate the Props plumes fire with the pack stowed; and the Body thrusters the
backpack physically covers must go quiet while it is deployed.

Membership rides in **vertex green**, encoded as levels rather than one channel per group,
so blue stays free for the planned translation-vs-rotation weighting.

| Painted G | Band | Group | Gated by | Used for |
|---|---|---|---|---|
| `0.0` | `< 0.1` | 0 | never gated | every ordinary thruster |
| `0.5` | `0.1 … 0.9` | 1 | `_GroupEnable.x` | Body back thrusters the packs cover |
| `1.0` | `≥ 0.9` | 2 | `_GroupEnable.y` | Props plumes |

| Group | Live when |
|---|---|
| 1 | **neither** `thruster_backpack` **nor** `arm_backpack` is on |
| 2 | `wings_deployed` is on |

The gate multiplies the finished throttle, so it is unaffected by deadzone and sharpness
shaping and fades rather than pops if the toggle blends.

**A mesh with no colour attribute reports WHITE**, so unpainted thruster geometry lands in
group **2**, not group 0 — and group 2 is gated by `wings_deployed`, which defaults to
**off**. Unpainted thruster geometry is therefore **dark by default**. Paint every thruster
mesh explicitly; do not rely on the default. (`group_gated` in the golden suite exists to
keep this fact from being forgotten again — it was a real bug caught by that test.)

**One wide middle band, on purpose.** Vertex colours may or may not be colour-space
converted on import, and the direction is unknown — an authored `0.5` can arrive as `0.214`
(sRGB→linear) or `0.735` (linear→sRGB). A single band spanning `0.1 … 0.9` swallows all of
those, while `0` and `1` are fixed points under any conversion. Splitting the middle into
two narrower bands would leave an authored value a whisker from a boundary, so **two groups
is the honest maximum for one channel**. Confirm with `_DebugView 3` rather than assuming —
it paints each group a flat colour (grey / green / blue).

#### Painting the groups

| Geometry | G | Resulting colour, given the existing R |
|---|---|---|
| Props thruster plumes (all) | **1.0** | walls `(1,1,0)`, diaphragms `(0,1,0)` |
| Body back thrusters the packs cover | **0.5** | walls `(1,0.5,0)`, diaphragms `(0,0.5,0)` |
| Every other thruster | **0** | unchanged |

**Preserve R when painting G** — it still carries the bell-versus-diaphragm direction
selection, so lock the red channel rather than flood-filling.

Until the Props mesh is repainted it sits at G = 0, i.e. group 0, and its plumes fire
regardless of the wings. That is the benign direction to be wrong in, and it is the
expected state between the direction paint and the group paint.

The `rcs_groups` FX layer, generated by the setup tool, drives both components from the
existing `thruster_backpack` bool — writing both on both renderer paths, so which renderer
a thruster sits on decides nothing and the painting decides everything.

## `_CoM` lives in a different space to the IMU

`_CoM` is the centre of mass in the **Body / Props renderer's object space** — the same
space as the posed mesh vertices, since the shader computes `lever = posOS - _CoM`. For a
human-scale avatar whose renderers sit at the root with identity transforms, that is metres
with the origin at the feet, so the hips land around `(0, 0.9, 0)`.

It is **not** the IMU anchor's position, and it is **not** in Hips-local space. Those are
easy to conflate because both describe "a point up the body", but the bone hierarchy on this
avatar is scaled (~0.1) while renderer object space is not. Pasting the anchor's local
`(0, 4.38, 0.55)` into `_CoM` puts the centre of mass over four metres above the avatar,
which lengthens and flips every lever arm and quietly wrecks the whole torque allocation.

Quick way to confirm the units: check `View Position` on the VRC Avatar Descriptor. It is in
avatar-root space, so if it reads roughly `1.6` the root really is in metres and `_CoM`
belongs in that same range.

## Animation-contract properties (DO NOT rename)

Driven by name from the `rcs_*` layers of `ncho_fx.controller`. Renaming any of them
silently breaks the avatar — the same trap described in [project.md](project.md).
`ShaderCompileTests` and `MaterialStateTests` pin their existence.

```
_RCS_Vel  _RCS_VelSmoothed  _RCS_AngVel  _RCS_AngVelSmoothed
_RCS_ImuDeflect  _RCS_Master
```

`_RCS_Vel` and `_RCS_VelSmoothed` are **normalised** to ±1 at ±6 m/s by the publish layer,
so the shader's gains stay unitless. Everything else on the shader is free to rename.

## FX layers

Built by `Tools > Exegesis > Build RCS Animator Layers`, which is idempotent — it deletes
and rebuilds anything named `rcs_*` and wipes `ncho_anim/rcs_generated/`. Prefer re-running
it over hand-editing: the controller has 52 layers and 117 states.

| Layer | Does |
|---|---|
| `rcs_smooth` | `smoothed = 0.85*smoothed + 0.15*live` per axis, per frame. |
| `rcs_publish` | Normalises live + lagged values onto the material. |
| `rcs_imu` | Sums the four contact proximities into a signed `_RCS_ImuDeflect`. |
| `rcs_master` | Two-state menu toggle on the `rcs` bool. |
| `rcs_group_packs` | `_GroupEnable.x` — off while `thruster_backpack` **or** `arm_backpack` is on. |
| `rcs_group_wings` | `_GroupEnable.y` — on while `wings_deployed` is on. |

Two things make this fit in four layers instead of a dozen:

- **A Direct blend tree with "Normalize Blend Values" off sums its children.** Children
  writing *different* properties coexist in one tree; children writing the *same* property
  sum, which is how the smoother's lerp and the IMU's signed pairs work.
- **Animation clips can drive Animator parameters**, not just component properties. That is
  what lets `rcs_smooth` feed a parameter back into itself.

All states are Write Defaults **OFF**, matching the other 117. The `rcs_imu` tree carries a
constant-weight base child writing zero, so the output is defined even when every receiver
reads zero (including when Avatar Dynamics is off entirely).

`RCS_Lag` / `RCS_LagInv` / `RCS_One` are animator-only floats that are never animated; with
Write Defaults off they simply sit at their defaults.

## Building the pendulum IMU

Mount it on **Hips**, offset upward — not on Chest. Three new transforms:

```
Hips
 └── rcs_imu_mount     (0, h, z), rot (7.15, 0, 0)   4x ContactReceiver   STATIC
      └── rcs_imu_anchor  (0, 0, 0), rot identity    VRCPhysBone          rotates
           └── rcs_imu_tip (0, -L, 0)                ContactSender        swings
```

**The mount is not optional.** VRCPhysBone expresses the simulated tip position by
*rotating the chain root to aim at it*, so `rcs_imu_anchor` turns as the pendulum swings.
Receivers placed on the anchor would turn with it, leaving the sender at a fixed position
relative to them and every channel frozen at its rest value — an instrument that reads a
constant and never errors. The receivers must sit on a transform the PhysBone does not
touch, which is what `rcs_imu_mount` is for.

1. `rcs_imu_mount` as a child of Hips, raised to `h` above the Hips origin measured **in
   world space**. Higher gives more tangential signal per unit of angular acceleration —
   above the head is fine and preferable. Because the Hips bone is tilted, the local offset
   is not simply `(0, h, 0)` and the mount needs a corrective rotation; see
   [Aligning the anchor](#aligning-the-anchor). The corrective rotation belongs **here**,
   on the mount, because the receiver offsets are expressed in mount space.
2. `rcs_imu_anchor` as its child at `localPosition = (0, 0, 0)` with identity rotation —
   it is co-located with the mount and exists purely so the PhysBone has something it may
   freely rotate.
3. `rcs_imu_tip` as *its* child at `localPosition = (0, -L, 0)`, with **VRCPhysBone** on
   `rcs_imu_anchor` so the tip is what swings. With gravity zeroed, deflection is purely
   the mount's acceleration — a real accelerometer. Its natural overshoot and ringing read
   as counter-burns for free.
4. **VRCContactSender** on `rcs_imu_tip`, **four VRCContactReceivers** as components on
   `rcs_imu_mount` using their own `Position` offset fields rather than four child
   GameObjects. They drive local floats `rcs_imu_xp`, `rcs_imu_xn`, `rcs_imu_zp`,
   `rcs_imu_zn`. Tables below.

#### Sender — on `rcs_imu_tip`

| Field | Value |
|---|---|
| `Shape` | Sphere |
| `Radius` | **0** |
| `Position` | `(0, 0, 0)` |
| `Collision Tags` | one custom tag, `ncho_rcs_imu` |

Radius **0** makes the sender a point, so the receiver reads a clean centre-to-centre
distance and the `r = 2s` maths holds. A sender with a radius inflates toward the receiver
and saturates it early. If a zero-radius sender fails to register, use `0.005` and accept
that full scale arrives 5 mm sooner.

The tag is a plain string and must match on all five components. Use something
avatar-specific — a generic tag risks colliding with the avatar's existing `*_touch`
contacts or with another player's.

#### Receivers — four components on `rcs_imu_mount`

On the **mount**, never on the anchor — see the warning above.

All four: `Receiver Type` **Proximity**, `Shape` Sphere, `Radius` **`r`**,
`Collision Tags` `ncho_rcs_imu`, **`Allow Self` ON**, **`Allow Others` OFF**,
**`Local Only` OFF**.

| Parameter | `Position` (local to the mount) |
|---|---|
| `rcs_imu_xp` | `( s,  -L,  0 )` |
| `rcs_imu_xn` | `(-s,  -L,  0 )` |
| `rcs_imu_zp` | `( 0,  -L,  s )` |
| `rcs_imu_zn` | `( 0,  -L, -s )` |

Two easy mistakes here, both silent:

- **The `-L` on every receiver.** They sit at the *tip's* rest height, not at the mount.
  Leave Y at 0 and all four sit a pendulum-length above the sender, reading nothing useful.
- **X versus Z.** `rcs_imu_xp/xn` go on the **X** axis, `zp/zn` on **Z**. Put all four on
  one axis and `_RCS_ImuDeflect.x` and `.z` carry identical values, collapsing roll and
  pitch into a single diagonal axis that no amount of gain tuning will separate.

`Allow Self` **on** or your own sender cannot drive them at all. `Allow Others` **off** so
nobody else's contacts can inject into your instrument. `Local Only` **off** so the receiver
is computed on every client — with it on, remote viewers would never see pitch or roll fire.

Vertical is deliberately omitted — `VelocityY` already covers it, saving two contacts.

### Sizing the pendulum

Start here, then calibrate:

| Symbol | What | Start (world) | Local on ncho (scale ≈ 0.1) |
|---|---|---|---|
| `L` | anchor → tip, the pendulum length | **0.20 m** | **2.0** |
| `s` | receiver offset from the tip's rest position, ±X and ±Z | **0.03 m** | **0.3** |
| `r` | receiver radius, all four | **0.06 m** | **0.6** |

**These are world-space targets; the fields take local units.** ncho's armature carries a
lossy scale near 0.1, so typing the world numbers straight in gives a 2 cm pendulum with
6 mm receivers — small enough to be jittery. Check the mount's lossy scale and convert. The
ratios are what matter and they scale as a set, so `r = 2s` and `L ≈ 6.7s` hold either way.

The receiver geometry is what sets the scale, not the length. A proximity receiver reads
`1 - distance/radius`, so with four receivers offset by `s` around the tip's rest position:

- **`r = 2s`** puts every receiver at `0.5` at rest, giving equal headroom in both
  directions. The signed pair `(xp - xn)` then reads `0` at rest and `2δ/r` for a tip
  deflection `δ`.
- **`δ_max ≈ s`** is therefore full scale. Pick `s` to match the largest deflection you
  want to resolve, and everything past it clips (harmlessly — `_ImuClamp` bounds it anyway).

Note the deflection is **opposite** the acceleration — the tip lags behind, so accelerating
toward +X deflects it toward −X and raises `rcs_imu_xn`. The receivers are wired
positionally regardless (`rcs_imu_xp` on the +X side); the shader negates
`_RCS_ImuDeflect` when it converts deflection into acceleration, so do not try to
compensate by swapping the receivers over.

`L` does **not** set sensitivity; it only keeps the geometry honest. The tip swings on an
arc, so it lifts out of the receiver plane by `L(1 - cos θ)` where `θ ≈ δ/L`. Keeping
**`L` at 5–10x `s`** keeps that rise small against `s` — at `L = 0.20`, `s = 0.03` the tip
rises about 2 mm at full deflection, against a 30 mm offset. Shortening `L` to 0.05 would
put `θ` past 30° and make the readout visibly non-linear. Anywhere in **0.15–0.30 m** is
fine. The bone is invisible and collision is off, so it does not matter that it hangs
inside the torso.

Sensitivity is set by **`Pull`**, not by any dimension.

### PhysBone settings

Set **`Integration Type` = Advanced** first — it changes which fields exist. Advanced
exposes `Pull` / `Momentum` / `Stiffness`; Simplified exposes `Pull` / `Spring` / `Stiffness`
instead. There is no `Damping` field in either. Advanced is the right choice here because
this is an instrument: `Momentum` gives direct control over how long it keeps moving.

| Setting | Value | Why |
|---|---|---|
| `Integration Type` | **Advanced** | Determines the whole parameter set below |
| `Pull` | 0.2 | The sensitivity knob — lower pulls back less, so it lags more and reads smaller accelerations |
| `Momentum` | 0.1 | Inertia retention, effectively damping inverted. Low settles quickly; raise it for more ring / counter-burn |
| `Stiffness` | 0 | Free to swing rather than holding its angle to the parent |
| `Gravity` | 0 | Otherwise it measures "down" instead of acceleration |
| `Gravity Falloff` | 0 | Greys out once Gravity is 0 |
| `Immobile Type` | All Motion | |
| **`Immobile`** | **0** | See the trap below |
| `Limit Type` | Angle, `Max Angle` ~30° | A hardware clamp on teleport spikes, complementing `_ImuClamp` |
| `Allow Collision` | **False** | Nothing should be able to shove the instrument. Radius 0 makes it mostly inert anyway, but False also skips the check |
| `Allow Grabbing` / `Allow Posing` | False | It is an instrument, not decoration |
| `Ignore Other Phys Bones` | checked | Keeps the tail / ear / ab-wire dynamics out of the reading |

Leave `Root Transform` empty: the component then uses its own GameObject as the chain root,
so `rcs_imu_anchor` stays fixed and `rcs_imu_tip` is what swings — which is the arrangement
the readout assumes.

`Pull` and `Momentum` are the two you will actually touch. `Pull` sets how much deflection a
given acceleration produces; `Momentum` sets what happens afterwards.

**The `Immobile` trap.** `Immobile` controls how much the bone resists being carried by
player movement. At `1` the tip tries to hold its world position, so its displacement
tracks how far you have *travelled* — that is a velocity/position sensor, and it would
quietly destroy the acceleration-only behaviour the whole system is built on. It must be
**0**, so the bone rides along and lags only through its own inertia.

### Calibrating it

Deflection per unit acceleration depends on PhysBone's solver, which is not a documented
physical model, so the numbers above are a starting point rather than a derivation. Read
the sensor directly rather than guessing:

1. Temporarily drive one of the HUD status bars from a receiver — bind `rcs_imu_xp` to
   `_StatusBar0Fill` (see [hud-shader.md](hud-shader.md)). Now you can watch the raw
   contact value in-headset instead of inferring it from thruster brightness.
2. Strafe hard and stop hard. The bar should swing across most of its range without
   pinning at either end for long.
3. Never gets far from 0.5 → lower `Pull`, or shrink `s` and `r` together.
4. Pins constantly → raise `Pull`, or grow `s` and `r` together.
5. Then unbind the status bar and continue with `_ImuGain` per the tuning order.

### Aligning the anchor

The Hips bone does not sit axis-aligned — on ncho it points back by roughly 7.15°. Two
corrections follow from that, and both are worth making:

Both corrections go on **`rcs_imu_mount`**, since that is the frame the receiver offsets are
expressed in. `rcs_imu_anchor` stays at identity local position and rotation beneath it.

- **Position:** offset the mount in Z so it sits directly above the Hips origin in world
  space, rather than trailing behind it. Sanity check: `localY × tan(tilt)` should equal
  your Z — on ncho, `4.38 × tan(7.15°) = 0.55`.
- **Rotation:** counter-rotate the mount (~7.15° in X) so its own axes are world-aligned
  at rest. Verify by eye with the transform gizmo rather than trusting the sign.

The rotation matters because ContactReceiver `Position` offsets are **local to the transform
they sit on**, so the ±X/±Z being probed are the *anchor's* axes — meaning
`_RCS_ImuDeflect` arrives in anchor space while the shader consumes it as avatar-root space.
A tilt about X leaves roll alone (X is the rotation axis) but makes the Z receivers read
`sin 7.15° ≈ 12%` of *vertical* deflection as pitch. Nothing cancels that leak: the ±Y
receivers were dropped, and `_ImuLinearReject` subtracts `linAccel.z` from the z channel,
not `linAccel.y`. Uncorrected, walking bob and jumps produce phantom pitch.

Rotating the anchor costs nothing else. `α × r` depends on the anchor's *position*, not its
orientation, so the lever arm is unchanged; and with gravity at 0 the pendulum only cares
about deflection from rest.

**`_ImuHeight` is effectively a second gain, not a measurement.** The physical derivation
(`α = residual / h`) assumes the residual is a real acceleration in m/s², but the contact
readout is a normalised 0-1 proximity, so the chain is empirical end to end. `_ImuGain` and
`_ImuHeight` scale the same quantity, and the linear rejection is applied before the
division. Put the approximate world-space height in it for documentation value and tune with
`_ImuGain` alone; precision here buys nothing.

**Watch the armature scale.** The bone hierarchy on this avatar is not in metres — the
anchor sits at a local Y of about 4.38 for roughly 0.44 m of world height, i.e. a lossy
scale near 0.1. `L`, `s` and `r` are all expressed in that same local space, so their ratios
survive untouched, but their *absolute* size does not: at face value the numbers above
would give a 2 cm pendulum with 6 mm receivers, small enough to be jittery. Check the
anchor's lossy scale and multiply all three together to keep the pendulum around 15-30 cm
in **world** terms.

Residual this does **not** fix: in full-body tracking the hips yaw against the avatar root
by tens of degrees, which partially swaps the roll and pitch channels. No fixed rotation
can correct a dynamic one; reach for `_Deadzone` if it reads badly.

### Why Hips rather than Chest

Hierarchy depth is the least of it; Hips is the better sensor mount on the merits:

- **The lever arm is exact.** Hips rotates about its own origin, so `h` is literally the
  anchor's local Y. Mounted on Chest, the "pivot" is ambiguous — the chest both rotates and
  translates as the spine bends, so `_ImuHeight` becomes a fudge factor.
- **Linear rejection works better.** `_ImuLinearReject` subtracts acceleration derived from
  `VelocityX/Y/Z`, which is *player capsule* velocity. Hips tracks the capsule closely, so
  the subtraction cancels cleanly. Chest motion includes spine articulation the capsule
  knows nothing about, leaving crosstalk that shows up as phantom roll.
- **Less articulation noise.** Chest carries `wing_root`, `hum` and the chest panels, and is
  driven by upper-body IK. Hips is the quietest bone near the root.

The trade: a Hips-mounted sensor sees pelvis attitude only, so with 3-point tracking (where
Hips is held upright) pitch/roll signal is small. That is arguably correct — the body is not
actually pitching, your spine is bending — but if you want thrusters to answer spine lean,
mount on Chest and accept the messier rejection.

This rig is documented rather than scripted on purpose: building it needs the VRChat SDK
dynamics assemblies, and referencing those from `Exegesis.RcsThruster.Editor` would mean an
SDK version bump could break the shader inspector and the animator script along with it.

### Failure modes (all bounded, none silent-but-wrong)

- Viewers with Avatar Dynamics disabled lose pitch/roll; translation and yaw survive.
- Teleports and station mounts spike the pendulum. `_ImuClamp` bounds the raw reading
  before rejection is applied.
- Proximity receivers saturate if the tip leaves the radius — size the radius against the
  hardest lean you can actually perform.

## Tuning order

Each step isolates one thing; doing them out of order means chasing your own tail.

1. `_SustainWeight = 1`, gains 0 → thrusters follow raw velocity. Confirms the publish layer
   and settles **whether `VelocityX/Y/Z` are player-local or world**: strafe while facing
   different directions and watch which thrusters fire. Flip `_VelSpace` if wrong.
2. Back to `_SustainWeight = 0`. Tune `_AccelGain`, `_Deadzone`, `_Sharpness` by walking,
   stopping hard, and reversing. Braking burns should appear when you stop.
3. Turn in place to tune `_AngAccelGain`. Outboard thrusters should fire in opposed pairs.
4. IMU: set `_ImuGain` with `_ImuLinearReject` at 0 until a deliberate lean reads full
   scale, *then* raise `_ImuLinearReject` until walking straight stops producing roll.
5. Raise an arm and translate. Limb thrusters should stay correct through the whole arc —
   this is the check the naive UV-region design could not pass.
6. Check in a mirror and from a second client: contacts and PhysBones simulate per-client,
   so remote viewers should see it fire.

### Frame-rate compensation

`rcs_smooth` applies its lag once per animator **update**, not per second. Under a constant
acceleration `a` the live-minus-lagged difference settles at `a * dt * L/(1-L)`, so the raw
reading scales with frame time — at 90fps it is half what it is at 45fps, and thruster
brightness would track the viewer's framerate rather than the avatar's motion.

`_AccelTimeCorrect` (on by default) multiplies the estimate by `1/dt` from
`unity_DeltaTime.w`, cancelling that term. It uses *smoothed* delta time deliberately:
dividing by a per-frame-jittery `dt` would turn frame-pacing noise straight into brightness
flicker.

This fixes pulse **amplitude**, which is the part you see. Pulse **duration** still varies,
per Known limits. The IMU path is not corrected and never needed to be — PhysBones simulate
against real time, so pitch and roll were always framerate-independent.

Because the estimate is now multiplied by roughly `1/dt` (~90 at 90fps), `_AccelGain` and
`_AngAccelGain` are around 60x smaller than they would be with compensation off; they ship
at 0.1. The golden harness forces `_AccelTimeCorrect = 0`, since `unity_DeltaTime` is not
deterministic across renders and the baselines pin allocation, not timing.

### `_SustainWeight`

The system is tuned for physically honest **acceleration-only** firing, so this ships at 0.
The known risk: in VRChat you hold a constant velocity most of the time, so pure-accel
thrusters idle a lot and can read as broken. It is a material float rather than a code path
precisely so that dialling in some velocity-follow is a slider drag in-headset, not a
rebuild.

## Testing

See [testing.md](testing.md) for the headless clone workflow; the RCS suite plugs into it.

| File | Pins |
|---|---|
| `ShaderCompileTests` | Found, supported, zero compile errors, one pass, all six contract properties declared. |
| `MaterialStateTests` | `thrusters.mat` binds the RCS shader, transparent queue, contract properties resolve, `_RCS_Master` saved at 1. |
| `GoldenImage/` | The allocation maths, rendered. |

**The golden rig is a cube**, which is close to ideal here: its six faces have exactly the
six ±X/±Y/±Z normals, so each face behaves as one thruster pointing down one axis. Firing a
commanded acceleration and checking which faces light tests the maths through the real
shader without duplicating it in C#. The camera sits on a diagonal and sees three faces
(+X, +Y, −Z); states that should light a *hidden* face are the sign-convention pins and are
expected to render black.

Two assertion layers, deliberately. A **semantic** check (states flagged `ExpectDark` must
render nothing, the rest must render something) runs even in capture mode — a freshly
captured baseline would otherwise happily enshrine a flipped sign, because a pixel diff can
only tell you the render changed, never that it was ever right. Then the usual pixel diff
catches everything else.

Unlike the HUD harness, this does **not** clone the live material: `thrusters.mat` is meant
to be re-tuned constantly, and goldens built on it would fail every time a colour moved. The
canonical test values live in `RcsRenderHarness`.

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
- **Pulse duration is still framerate-dependent** (amplitude is not — see below). The lag's
  time constant is `-dt/ln(L)`, and there is no way to feed `dt` back into an animator, so
  the tail of each burn is shorter at high framerates. Only the decay length varies.
- Thrusters do not react to a limb's *own* acceleration (waving an arm). That needs
  per-limb temporal state, which a stateless fragment shader cannot hold.
- The allocation assumes renderer-object space is avatar-root space, which holds while
  `Body` and `Props` have identity local transforms under the root.

## Deferred

- **Growing plume geometry.** Throttle is already computed per-vertex, so the vertex path
  only needs `v.vertex.xyz += plumeAxis * u * _PlumeLength` gated on a mask channel — a
  Blender job, not a shader rewrite.
- A second pendulum, if pitch/roll redundancy is ever wanted. Additive; `_RCS_ImuDeflect`
  already carries the readout.
- Hover/idle behaviour off the existing `Grounded` parameter: downward thrusters ticking
  over to "hold" the avatar up.
