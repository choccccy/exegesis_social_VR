# Accessories and slots

How ncho's wearable hardware is selected, hidden and shown. Built by
`Tools > Exegesis > Build ncho Slot Layers`
(`Assets/_exegesis/ncho/Editor/NchoSlotSetup.cs`).

## The idea: one int per mount point

Accessories that share a physical mount are selected by a single **int** — `0` = nothing worn,
`1` = first accessory, `2` = second — with one animator state per member.

Every accessory used to be an independent **bool** on its own layer writing its own dissolve
tile, and nothing stopped two accessories on the same mount being worn at once: the thruster
backpack and the arm backpack both rendered on the back, and the thigh hard-cases and thigh
thruster packs both on the thighs.

A state machine can only be in one state, so with a slot int **exclusivity is structural**.
There is no bookkeeping between parameters to get out of step, and adding a member cannot
reintroduce the clash. The pattern is lifted from the earlier ChoccyWicker avatar
(`ClothingNeutral` / `Outfits` / `Shirts` / `Pants`).

**ncho already had the other half of that pattern**, which is why the port was small. The
always-on `props_neutral` layer plays `[props]_neutral.anim`, which sets **all 16** Props
dissolve tiles to hidden; the accessory layers sit above it and override single tiles to
visible. That is exactly the `ClothingNeutral` role.

### Why "bare" needs no state

Every state in this controller is **Write Defaults OFF**, so a slot layer sitting in `idle`
(playing the no-op `_Empty.anim`) writes *nothing*, and its tiles fall through to
`props_neutral`'s hidden values. "Nothing worn" is therefore free — no clip, no state, no
value to maintain.

It also means **any unmapped value reads as bare**. A stale saved value from an accessory that
was later removed shows nothing rather than breaking the state machine.

> The flip side is the trap documented as footgun 2 in [rcs-thrusters.md](rcs-thrusters.md): a
> state that is *supposed* to write something but plays an empty clip also writes nothing, and
> looks identical to "stowed". `NchoSlotSetup` refuses to build if a member clip is missing,
> rather than producing a state with a null motion.

## The slots

| Parameter | Type | Default | Saved | Synced | 0 | 1 | 2 |
|---|---|---|---|---|---|---|---|
| `back_slot` | Int | 1 | yes | yes | bare | thruster backpack | arm backpack |
| `thigh_slot` | Int | 1 | yes | yes | bare | hard-cases | thruster packs |
| `loadout` | Int | 0 | no | **no** | idle | Bare | Full RCS (3 = Hard-Cases) |

Defaults reproduce the pre-migration appearance exactly — `thruster_backpack` and
`thigh_hard-cases` both used to default to on.

**Slot values are a contract once uploaded.** They are what the menu writes and what a saved
parameter restores. Append new members with new numbers; never renumber an existing one.

### Still bools

`hard-case_mounts`, `arm_hard-cases`, `wings_deployed` and `pouches`. Each is a lone item with
no exclusivity problem, and a bool costs 1 bit against an int's 8.

`arm_hard-cases` requires `hard-case_mounts` to be on; `thigh_hard-cases` (now `thigh_slot 1`)
does **not**. That asymmetry is deliberately preserved — it was not introduced by this
migration, and the arm cases mount to the rails while the thigh cases do not.

## Cost: this spends bits, it does not save them

A common assumption about slot ints is that they save parameter budget. **They do not.**
VRChat ints are always 8 bits, so a 2-member slot is more expensive than 2 bools:

| | Bits |
|---|---|
| 4 retired bools | −4 |
| `back_slot` + `thigh_slot` | +16 |
| `loadout` (unsynced) | 0 |
| **Net** | **+12 → 112 / 256** |

The win is correctness, not budget. A slot only breaks even on bits at 8 members.

`loadout` is **not synced and not saved**: the parameter driver runs on the local client and
the synced slot ints it writes are what replicate. Remote clients never see `loadout` change,
only its effects. If presets ever misbehave for remote viewers, sync it and pay the 8 bits.

Expect a small runtime cost too: VRCFury's `DirectTreeOptimizer` merges simple bool-toggle
layers into direct blend trees, and int-conditioned layers are generally not eligible.

## Layers

Owned by the tool, torn down and rebuilt by **prefix** (`slot_*`) so renames cannot orphan one:

| Layer | Does |
|---|---|
| `slot_back` | `idle` + one state per `back_slot` member |
| `slot_thigh` | `idle` + one state per `thigh_slot` member |
| `slot_loadout` | Driver-only preset states; animates nothing |

Each member state is entered on `Equals <value>` and left on `NotEqual <value>`. There are no
Any State transitions.

These layers must sit **above** `props_neutral`, or they have nothing to override.

### The fade

Accessories **dissolve in and out over 0.25s** (`FadeSeconds` in `NchoSlotSetup.cs`), matching
the hand-built bool layers this replaced.

The fade is **not in the clips** — those are two-key constants. It comes entirely from the
**transition duration**: during a transition the animator blends the tile's dissolve alpha
between the two states, and because the `idle` side writes nothing, the blend runs against
`props_neutral`'s hidden value on the layer below. So a rebuild with a default duration of 0
silently removes the fade, with nothing failing and nothing logged — it is only visible by
wearing the avatar. That happened once; `SlotTransitions_KeepTheFade` pins it now.

`hasFixedDuration` is set explicitly, so 0.25 is **seconds**. Normalised against a one-frame
clip it would be about 4ms — a pop wearing the right number.

### Swapping members: sequential, on purpose

Every member has exactly **one** way out and it goes to `idle`. There are deliberately **no
member-to-member transitions**, so changing a slot from 1 → 2 fades the old accessory out over
0.25s and only then fades the new one in — total 0.5s, and the mount is briefly bare in between.

**One item goes away, then the next appears.** That is the intended look, inherited from the
ChoccyWicker clothing layers, whose round trip is always *garment → Exit → Entry → idle → next
garment*.

The tempting alternative is a direct member-to-member transition: half the swap time, and it
looks like a free win in the code. It is not. It **crossfades**, so two pieces of solid hardware
dissolve into each other, both half-transparent and interpenetrating for a moment — a glitch
rather than a transition. It was built that way once and reverted.

`SlotMembers_SwapViaIdleNotDirectly` therefore asserts the *absence* of that optimisation, since
nothing in the code itself would tell you the extra step is intentional.

The `slot_loadout` transitions are deliberately instant: they carry no visuals, only a driver.
The fade happens downstream when the slot layers react to the ints it writes.

> **Not faded:** the `rcs_group_*` gates are instant, so plumes cut rather than fading with the
> geometry. That was true before the migration too. If the mismatch ever reads badly, the gate
> multiplies the finished throttle, so giving those transitions a duration would fade plume
> brightness in step — see [rcs-thrusters.md](rcs-thrusters.md) ▸ Visibility groups.

The tool also removes the four hand-built layers it replaces (`thruster_backpack`, `arm_pack`,
`thigh_hard-cases`, `thigh_thrusters`). Their clips are ordinary asset files, reused unchanged
by the new states, so nothing is lost — but the layer removal is one-way, so rely on git rather
than on re-running the tool.

### Presets, and the bug not to copy

`slot_loadout` states animate nothing; each hosts a `VRCAvatarParameterDriver` that Sets several
slot ints at once. Because the layer only writes parameters, it can never fight the slot layers
over a property.

**Every preset must also set `loadout` back to 0.** The reference implementation on ChoccyWicker
omits this: nothing there ever resets `Outfit`, so its preset states re-enter continuously,
re-fire their drivers every frame, and permanently *pin* the slot ints — individual slot toggles
lose every fight with the preset. `NchoSlotSetup` appends the reset to every preset
automatically. The menu controls are **Buttons** (momentary) as a second line of defence.

The three seeded presets are a starting point, not a design; they are one table in the tool.

## How things are hidden and shown

Three mechanisms, in order of importance:

1. **Poiyomi UV tile dissolve** — the primary one.
   `material._UVTileDissolveAlpha_Row{0..3}_{0..3}_ncho_props` on the `Props` renderer, and
   `..._ncho` on `Body`. **The polarity is inverted from intuition: 1 = hidden, 0 = visible.**
2. **GameObject enable** — only `PhysBones/Extra Arm Dynamics`, off in the neutral clip and on
   in `[props]_arm_backpack_on.anim`.
3. **Bone rotation** — only the wings: `Armature/Hips/Spine/Chest/wing_root` euler X, −159.56
   stowed, −85 deployed. The wings have **no dissolve tile**, so they are posed rather than
   hidden.

No blendshapes and no renderer-`enabled` curves are used for accessories.

### Props tile census

| Tile | Owner |
|---|---|
| `Row0_0` | `hard-case_mounts` |
| `Row0_1` | `thigh_slot` 1 — hard-cases |
| `Row0_2` | `arm_hard-cases` |
| `Row3_0` | `back_slot` 1 — thruster backpack |
| `Row3_2` | `thigh_slot` 2 — thruster packs |
| `Row3_3` | `back_slot` 2 — arm backpack |
| `Row0_3`, `Row1_*`, `Row2_*`, `Row3_1` | **free — 9 tiles** |

Body tiles are the panels system: `Row0_1` pouches, `Row1_0/1_1` arm panels, `Row1_2/1_3` thigh
panels, `Row2_0…2_3` face/chest/abdomen/groin. Body and Props use different material suffixes,
so Body `Row0_1` and Props `Row0_1` do not collide.

## Interaction with the RCS thrusters

The thruster shader gates whole groups of plumes on accessory state, via `_GroupEnable` — see
[rcs-thrusters.md](rcs-thrusters.md) ▸ Visibility groups. Those layers are built by a *different*
tool and read the slot ints:

| RCS layer | Condition | Meaning |
|---|---|---|
| `rcs_group_packs` | `back_slot != 0` → `_GroupEnable.x = 0` | Body back thrusters are covered by whatever is on the back |
| `rcs_group_thighs` | `thigh_slot == 2` → `_GroupEnable.z = 1` | only the thruster packs have plumes; the hard-cases share the mount and have none |
| `rcs_group_wings` | `wings_deployed` (bool, unchanged) | |

Note the asymmetry, because it is the point: the back gate asks *"is anything worn"* while the
thigh gate asks *"is this specific member worn"*. A bool per accessory could express the first
only as an OR that every new accessory had to be added to, and the second not at all.

> **Run order matters.** `Build ncho Slot Layers` first — it declares the ints — then
> `Build RCS Animator Layers`. `SlotParameterTests` fails with both menu paths in its message
> if either half is missing.

### The `rcs` / wings decoupling

`wing_deploy` used to enter its deployed state on `wings_deployed` **OR** `rcs`. Since `rcs`
defaults to 1 and is not saved, it was 1 on every load, so the wings were **always physically
deployed** — while `rcs_group_wings` gates the wing plumes on `wings_deployed` alone, which
defaults to 0. Wings out, plumes silent, every load.

The tool removes `rcs` from that layer. The subtle part, and the reason it is code rather than a
hand edit: **a transition whose conditions are all removed is always true.** Stripping `rcs`
from the standalone `If rcs` entry transition would leave an unconditional transition into the
deployed state — strictly worse than the bug. So a transition left with no conditions is deleted
outright, and only transitions with other conditions surviving are edited in place.

`wings_deployed` also gained the menu control it never had.

## Guards

| Test | Pins |
|---|---|
| `SlotParameterTests.SlotMigration_IsFullyApplied` | Slot layers exist, the ints are declared **Int**, the RCS gates read them with Equals/NotEqual, and no retired bool is still referenced anywhere. Deliberately does **not** `Ignore` when unmigrated — an ignoring guard passes forever if the work is never finished. |
| `SlotParameterTests.ThighGate_TargetsTheThrusterMemberSpecifically` | The thigh gate tests `== 2`, not `== 0`, which would light the plumes while the thighs are bare. |
| `SlotParameterTests.SlotLayers_AreMutuallyExclusiveByConstruction` | Every member is entered on `Equals` its own value and left on `NotEqual` the same value, no two members share a value, and none is Write-Defaults-on. |
| `SlotParameterTests.SlotTransitions_KeepTheFade` | Every slot transition is 0.25s with `hasFixedDuration`. The fade lives in the transition, not the clips, so a rebuild can drop it silently. |
| `SlotParameterTests.SlotMembers_SwapViaIdleNotDirectly` | Members route swaps through `idle` and have **no** direct transitions to each other, so accessories never dissolve into one another. Pins the absence of a tempting optimisation. |

`EnsureParameter` in both tools **corrects a type mismatch** rather than skipping an existing
parameter. This matters more than it looks: an `Equals` condition on a parameter the controller
believes is a `Bool` never matches, so a half-retyped parameter leaves layers silently inert.

## Adding an accessory

1. Author the geometry on the `Props` mesh and give it a free dissolve tile.
2. Add a `[props]_<name>_on.anim` clip setting that tile to **0**, and add the tile to
   `[props]_neutral.anim` as **1** if it is not already there.
3. Add a `Props(<value>, "<name>")` entry to the slot's `Members` table in `NchoSlotSetup.cs`,
   using a **new** value. Transitions and the fade are wired for you.
4. Add a Toggle to the slot's submenu with that value.
5. Re-run both generators, in order.
6. If it carries thrusters, paint the plume vertex green for a group and extend the RCS gate —
   see [rcs-thrusters.md](rcs-thrusters.md).

A whole new mount point additionally needs a new int in `ncho_params.asset`, a new `Slot` entry,
and a submenu.

## Known dead entries

Found while surveying, left alone: `ncho_config_menu` has a `snub` control with an empty
parameter and a `Page 2 (snub)` submenu pointing at `fileID: 0`, plus a Toggle on
`vertex_rounding` that also carries a `subMenu` guid and a `subParameters` entry (malformed but
harmless). `ncho_tail_menu` duplicates the `Tail in Hand` control that the gear menu also has.
