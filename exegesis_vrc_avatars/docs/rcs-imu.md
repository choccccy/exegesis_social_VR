# The pendulum IMU (pitch and roll)

Build spec for the PhysBone accelerometer that gives the [RCS thrusters](rcs-thrusters.md)
pitch and roll. Split out from that doc because it is a rig-building document, not a shader
one, and because it is currently **optional**.

> **Status: not built on ncho.** The avatar runs without it and looks good; translation and
> yaw come from built-in parameters and cover most of what reads as thruster work. With no
> receivers driving them, `_RCS_ImuDeflect` sits at 0 and the IMU term contributes nothing —
> the system degrades to translation + yaw with no special-casing. Build this only if pitch
> and roll are actually missed.

## Why a pendulum at all

VRChat exposes no pitch or roll parameter — `AngularY` is yaw only. A PhysBone with gravity
zeroed is an accelerometer: the tip lags behind whatever carries it, and that lag *is* the
acceleration. Its natural overshoot and ringing read as counter-burns for free.

Only **one** pendulum is needed, not a differencing pair. It sees `a_linear + (α × r)`, and
`a_linear` is already known from `VelocityX/Y/Z`, so subtracting it leaves `α × r` — which for
`r = (0, h, 0)` resolves straight into roll and pitch.

This also fails gracefully: a viewer who disables Avatar Dynamics loses pitch and roll only,
while translation and yaw keep working. A design that read *everything* from pendulums would
go completely dead for that viewer.

This rig is documented rather than scripted on purpose. Building it needs the VRChat SDK
dynamics assemblies, and referencing those from `Exegesis.RcsThruster.Editor` would let an SDK
version bump break the shader inspector and the animator script along with it.

## Hierarchy

Mount it on **Hips**, offset upward — not on Chest (see below). Three new transforms:

```
Hips
 └── rcs_imu_mount     (0, h, z), rot (7.15, 0, 0)   4x ContactReceiver   STATIC
      └── rcs_imu_anchor  (0, 0, 0), rot identity    VRCPhysBone          rotates
           └── rcs_imu_tip (0, -L, 0)                ContactSender        swings
```

**The mount is not optional, and leaving it out fails silently.** VRCPhysBone expresses the
simulated tip position by *rotating the chain root to aim at it*, so `rcs_imu_anchor` turns as
the pendulum swings. Receivers placed on the anchor would turn with it, leaving the sender at
a fixed position relative to them and every channel frozen at its rest value — an instrument
that reads a constant and never errors. The receivers must sit on a transform the PhysBone
does not touch.

1. **`rcs_imu_mount`** under Hips, raised to `h` above the Hips origin measured in **world**
   space. Higher gives more tangential signal per unit of angular acceleration; above the head
   is fine and preferable. Hips is tilted, so the local offset is not simply `(0, h, 0)` — see
   [Aligning the mount](#aligning-the-mount). Both corrections belong here, on the mount,
   because the receiver offsets are expressed in mount space.
2. **`rcs_imu_anchor`** as its child at `localPosition = (0, 0, 0)`, identity rotation. It is
   co-located with the mount and exists purely so the PhysBone has something it may freely
   rotate.
3. **`rcs_imu_tip`** as *its* child at `localPosition = (0, -L, 0)`, with the **VRCPhysBone**
   on `rcs_imu_anchor` so the tip is what swings.
4. **VRCContactSender** on the tip; **four VRCContactReceivers** as components on the *mount*,
   using their own `Position` offset fields rather than four child GameObjects.

Leave `Root Transform` empty — the component then uses its own GameObject as the chain root,
which is the arrangement the readout assumes.

Vertical is deliberately omitted: `VelocityY` already covers it, saving two contacts.

## Sender — on `rcs_imu_tip`

| Field | Value |
|---|---|
| `Shape` | Sphere |
| `Radius` | **0** |
| `Position` | `(0, 0, 0)` |
| `Collision Tags` | one custom tag, `ncho_rcs_imu` |

Radius **0** makes the sender a point, so the receiver reads a clean centre-to-centre distance
and the `r = 2s` maths holds; a sender with a radius inflates toward the receiver and
saturates it early. If a zero-radius sender fails to register, use `0.005`.

The tag is a plain string and must match on all five components. Keep it avatar-specific — a
generic tag risks colliding with ncho's existing `*_touch` contacts, or with another player's.

## Receivers — four components on `rcs_imu_mount`

All four: `Receiver Type` **Proximity**, `Shape` Sphere, `Radius` **`r`**, `Collision Tags`
`ncho_rcs_imu`, **`Allow Self` ON**, **`Allow Others` OFF**, **`Local Only` OFF**.

| Parameter | `Position` (local to the mount) |
|---|---|
| `rcs_imu_xp` | `( s,  -L,  0 )` |
| `rcs_imu_xn` | `(-s,  -L,  0 )` |
| `rcs_imu_zp` | `( 0,  -L,  s )` |
| `rcs_imu_zn` | `( 0,  -L, -s )` |

`Allow Self` **on** or your own sender cannot drive them at all. `Allow Others` **off** so
nobody else's contacts can inject into your instrument. `Local Only` **off** so remote viewers
see pitch and roll fire.

Two silent mistakes:

- **The `-L` on every receiver.** They sit at the *tip's rest height*, not at the mount. Leave
  Y at 0 and all four sit a pendulum-length above the sender, reading nothing useful.
- **X versus Z.** Put all four on one axis and `_RCS_ImuDeflect.x` and `.z` carry identical
  values, collapsing roll and pitch into a single diagonal that no amount of gain tuning
  separates.

Deflection is **opposite** the acceleration — the tip lags, so accelerating toward +X deflects
it toward −X and raises `rcs_imu_xn`. Wire the receivers positionally anyway; the shader
negates `_RCS_ImuDeflect` when it converts deflection to acceleration, so do not compensate by
swapping them over.

## Sizing

| Symbol | What | Start (world) | Local on ncho (scale ≈ 0.1) |
|---|---|---|---|
| `L` | anchor → tip, the pendulum length | **0.20 m** | **2.0** |
| `s` | receiver offset from the tip's rest position, ±X and ±Z | **0.03 m** | **0.3** |
| `r` | receiver radius, all four | **0.06 m** | **0.6** |

**These are world-space targets but the fields take local units.** ncho's armature carries a
lossy scale near 0.1 — the anchor sits at a local Y of ~4.38 for ~0.44 m of world height — so
typing the world numbers straight in gives a 2 cm pendulum with 6 mm receivers, small enough
to be jittery. Check the mount's lossy scale and multiply all three. The **ratios** are what
matter and they scale as a set, so `r = 2s` and `L ≈ 6.7s` hold in either space.

The **receiver geometry sets the scale, not the length.** A proximity receiver reads
`1 - distance/radius`, so with four receivers offset by `s` around the tip's rest position:

- **`r = 2s`** puts every receiver at `0.5` at rest, giving equal headroom both ways. The
  signed pair `(xp - xn)` then reads `0` at rest and `2δ/r` for a tip deflection `δ`.
- **`δ_max ≈ s`** is full scale. Pick `s` to match the largest deflection you want to resolve;
  everything past it clips harmlessly, and `_ImuClamp` bounds it anyway.

`L` does **not** set sensitivity — it only keeps the geometry honest. The tip swings on an arc,
lifting out of the receiver plane by `L(1 - cos θ)` where `θ ≈ δ/L`. Keeping **`L` at 5–10× `s`**
keeps that rise small: at `L = 0.20`, `s = 0.03` the tip rises ~2 mm at full deflection against
a 30 mm offset, while shortening `L` to 0.05 would push `θ` past 30° and make the readout
visibly non-linear. Anywhere in **0.15–0.30 m** is fine. The bone is invisible and collision is
off, so it does not matter that it hangs inside the torso.

Sensitivity is set by **`Pull`**, not by any dimension.

## PhysBone settings

Set **`Integration Type` = Advanced first** — it changes which fields exist. Advanced exposes
`Pull` / `Momentum` / `Stiffness`; Simplified exposes `Pull` / `Spring` / `Stiffness`. There is
no `Damping` field in either. Advanced is right here because this is an instrument, and
`Momentum` gives direct control over how long it keeps moving.

| Setting | Value | Why |
|---|---|---|
| `Integration Type` | **Advanced** | Determines the whole parameter set below |
| `Pull` | 0.2 | The sensitivity knob — lower lags more and reads smaller accelerations |
| `Momentum` | 0.1 | Inertia retention, damping inverted. Low settles fast; raise for more ring |
| `Stiffness` | 0 | Free to swing rather than holding its angle to the parent |
| `Gravity` | 0 | Otherwise it measures "down" instead of acceleration |
| `Gravity Falloff` | 0 | Greys out once Gravity is 0 |
| `Immobile Type` | All Motion | |
| **`Immobile`** | **0** | See below |
| `Limit Type` | Angle, `Max Angle` ~30° | Hardware clamp on teleport spikes, complementing `_ImuClamp` |
| `Allow Collision` | **False** | Nothing should be able to shove the instrument |
| `Allow Grabbing` / `Allow Posing` | False | It is an instrument, not decoration |
| `Ignore Other Phys Bones` | checked | Keeps tail / ear / ab-wire dynamics out of the reading |

**The `Immobile` trap.** `Immobile` controls how much the bone resists being carried by player
movement. At `1` the tip tries to hold its world position, so its displacement tracks how far
you have *travelled* — that is a velocity sensor, and it would quietly destroy the
acceleration-only behaviour the whole system is built on. It must be **0**, so the bone rides
along and lags only through its own inertia.

## Aligning the mount

Hips does not sit axis-aligned — on ncho it points back by roughly 7.15°. Both corrections go
on `rcs_imu_mount`, since that is the frame the receiver offsets live in; `rcs_imu_anchor`
stays at identity beneath it.

- **Position:** offset the mount in Z so it sits directly above the Hips origin in world space
  rather than trailing behind it. Sanity check: `localY × tan(tilt)` should equal your Z — on
  ncho, `4.38 × tan(7.15°) = 0.55`.
- **Rotation:** counter-rotate the mount (~7.15° in X) so its own axes are world-aligned at
  rest. Verify with the transform gizmo rather than trusting the sign.

The rotation matters because ContactReceiver `Position` offsets are **local to the transform
they sit on**, so the ±X/±Z being probed are the mount's axes — meaning `_RCS_ImuDeflect`
arrives in mount space while the shader consumes it as avatar-root space. A tilt about X leaves
roll alone (X is the rotation axis) but makes the Z receivers read `sin 7.15° ≈ 12%` of
*vertical* deflection as pitch. Nothing downstream cancels that: the ±Y receivers were dropped,
and `_ImuLinearReject` subtracts `linAccel.z` from the z channel, not `linAccel.y`.
Uncorrected, walking bob and jumps produce phantom pitch.

Rotating the mount costs nothing else — `α × r` depends on the anchor's *position*, not its
orientation, and with gravity at 0 the pendulum only cares about deflection from rest.

**Residual this does not fix:** in full-body tracking the hips yaw against the avatar root by
tens of degrees, partially swapping roll and pitch. No fixed rotation corrects a dynamic one;
reach for `_Deadzone` if it reads badly.

## Calibrating

Deflection per unit acceleration depends on PhysBone's solver, which is not a documented
physical model, so the numbers above are a starting point rather than a derivation. Read the
sensor directly rather than guessing:

1. Temporarily drive a HUD status bar from a receiver — bind `rcs_imu_xp` to `_StatusBar0Fill`
   (see [hud-shader.md](hud-shader.md)). Now you can watch the raw contact value in-headset
   instead of inferring it from thruster brightness.
2. Strafe hard and stop hard. The bar should swing across most of its range without pinning.
3. Never gets far from 0.5 → lower `Pull`, or shrink `s` and `r` together.
4. Pins constantly → raise `Pull`, or grow `s` and `r` together.
5. Unbind the status bar, then set `_ImuGain` with `_ImuLinearReject` at 0 until a deliberate
   lean reads full scale, *then* raise `_ImuLinearReject` until walking straight stops
   producing roll.

**`_ImuHeight` is a second gain, not a measurement.** The physical derivation (`α = residual/h`)
assumes the residual is a real acceleration in m/s², but the contact readout is a normalised
0–1 proximity, so the chain is empirical end to end. `_ImuGain` and `_ImuHeight` scale the same
quantity. Put the approximate world height in it for documentation value and tune with
`_ImuGain` alone; precision here buys nothing.

## Failure modes

All bounded, none silent-but-wrong:

- Viewers with Avatar Dynamics disabled lose pitch/roll; translation and yaw survive.
- Teleports and station mounts spike the pendulum. `_ImuClamp` bounds the raw reading before
  rejection is applied.
- Proximity receivers saturate if the tip leaves the radius — size `r` against the hardest lean
  you can actually perform.

## Why Hips rather than Chest

- **The lever arm is exact.** Hips rotates about its own origin, so `h` is literally the
  anchor's local Y. On Chest the pivot is ambiguous — it both rotates and translates as the
  spine bends, making `_ImuHeight` a fudge factor.
- **Linear rejection works better.** `_ImuLinearReject` subtracts acceleration derived from
  `VelocityX/Y/Z`, which is *player capsule* velocity. Hips tracks the capsule closely, so the
  subtraction cancels cleanly. Chest motion includes spine articulation the capsule knows
  nothing about, leaving crosstalk that shows up as phantom roll.
- **Less articulation noise.** Chest carries `wing_root`, `hum` and the chest panels, and is
  driven by upper-body IK. Hips is the quietest bone near the root.

The trade: a Hips-mounted sensor sees pelvis attitude only, so with 3-point tracking (where
Hips is held upright) the pitch/roll signal is small. That is arguably correct — the body is not
pitching, your spine is bending — but if you want thrusters to answer spine lean, mount on
Chest and accept the messier rejection.
