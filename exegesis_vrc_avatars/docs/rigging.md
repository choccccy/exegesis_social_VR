# Rigging, and the Blender → FBX → Unity contract

How the avatar armatures are built, what about them is a contract with Unity, and the
tooling that keeps that contract from breaking silently.

Source blends live at the **git root**, not in the Unity project:
`source/ncho/ncho.blend`, `source/obi-me/obi-me.blend`. Authored in **Blender 5.2.1 LTS**.

> **`source/` is not in git.** Nothing here is recoverable with `git checkout`. Back a blend
> up before running anything that writes to it. Every script in `Tools/blender/` is a dry run
> unless you pass `--save`.

## The contract

Three separate bindings, all of which fail **silently** — no error, the curve or reference
just stops resolving:

| Binding | Held by | Broken by |
|---|---|---|
| Full transform path — `Armature/Hips/Spine/Chest/…` | every `.anim` clip | renaming or reparenting any ancestor |
| Bone **name** | the humanoid map in `*.fbx.meta` (49 bones each) | renaming a mapped bone |
| Unity **local file ID** — derived from the object's name | scene references: PhysBone roots, `m_CorrespondingSourceObject`, prefab modification targets | renaming *anything* the scene references |
| Shape key name | `expand_tanks` on ncho's `Body` | renaming or dropping it |

`exegesis.unity` holds **1611 references into `ncho.fbx` across 140 distinct objects**, via
five prefab instances. That is why a bone rename is a two-part change (see below).

## Footguns

### 1. The bind pose is a POSE, not the rest pose

Both characters export in **POSE position** with a stance live, and that stance is the
avatar's bind pose in Unity. ncho's is 21 bones: the digitigrade legs (`digiShin` +68.9°,
`digiAnkle` −78.4°, `digiFoot` +15.4°), the planti proxy chain posed to match, arms dropped
12°, wings folded −75°, hips lowered 0.52. obi-me's is also 21 bones, including the
manipulator fingers.

That stance used to exist **only** as whatever pose happened to be in the .blend when someone
pressed export. Clear the pose, or leave the rig posed from an animation, and the avatar's
bind pose changes with no warning at all.

It now lives in `Tools/blender/golden/<character>_export_pose.json`, and `export_avatar.py`
restores it before every export. **This becomes mandatory once a control rig exists** —
posing the game armature is precisely what a control rig does.

- `--assert-pose` fails if the file's pose has drifted from the golden.
- `--dump-pose` re-captures it (only for a deliberate change to the bind pose).
- `restore_pose` only writes bones that have actually drifted, so a file already in the right
  pose exports bit-identically.

### 2. The `_fix` bones are the primary deform bones — not twist correctors

Every `_fix` bone is a short, unconnected stub parented to a segment bone, and it holds
essentially all of that segment's weight while the segment bone itself holds **none**:

| Bone | Weight on ncho `Body` | Its parent | Parent's weight |
|---|---|---|---|
| `thigh_fix.L` | 683 | `thigh.L` | 0 |
| `forearm_fix.L` | 378 | `forearm.L` | 0 |
| `Hips_fix` | 330 | `Hips` | 0 |
| `digiAnkle_fix.L` | 258 | `digiAnkle.L` | 0 |
| `upper_arm_fix.L` | 154 | `upper_arm.L` | 0 |

The bones that have a `_fix` stub — `Hips`, `thigh`, `upper_arm`, `forearm`, `digiAnkle` — are
exactly the ones Unity's humanoid twist system acts on (`armTwist`, `foreArmTwist`,
`upperLegTwist`, `legTwist`, all at the 0.5 default in both `.fbx.meta`). Weighting to a child
stub makes the geometry rotate **rigidly** and stay immune to twist redistribution, which is
what a hard-surface character needs.

**So `_fix` bones get no constraints, no twist behaviour and no controls.** Adding a
`Copy Rotation` twist to them — the obvious thing to do to something named `*_fix` — would
introduce exactly the shear the rig was built to prevent. They follow by parenting, and
nothing else.

A corollary: because deformation is rigid, Rigify's `DEF-` twist machinery is irrelevant here.
A control rig should bind from the **`ORG-`** bones, which stay 1:1 with the metarig.

### 3. Two leg chains, one of them weightless

```
thigh.L                                     [no weight]
├── plantiShin.L ── plantiFoot.L            [NO WEIGHT - humanoid proxy only]
├── digiShin.L ── digiAnkle.L ── digiFoot.L [the visible, deforming leg]
│                 └── digiAnkle_fix.L
└── thigh_fix.L
```

The two chains are **siblings** under `thigh.L`, not nested. `plantiShin`/`plantiFoot` are not
vertex groups on any mesh — they exist purely so Unity has a plantigrade chain to map
`LeftLowerLeg`/`LeftFoot` onto. obi-me has the same arrangement with `shin`/`foot` as the
proxy.

Drive the digi chain; the planti chain only needs solving when baking a clip back to Unity.

### 3b. The rest pose is deliberately straight — leave it that way

Both leg chains are perfectly **colinear along −Z in the rest pose**. That is an authoring
choice, not an oversight: a straight leg is far easier to edit. The character's actual
resting shape is the stored stance pose (footgun 1), which bends it into the digitigrade
zig-zag — knee 68.9°, hock 78.4°, toe 15.4°.

**Do not bake the stance into the rest pose.** Nothing needs it: a control rig binds through
`Copy Transforms`, which drives world matrices, so the game bone's rest orientation does not
affect the result — it only changes what the local pose numbers look like.

The one place it does matter is **building a Rigify metarig**. Rigify infers the IK bend
plane and pole direction from metarig *rest* geometry, and a colinear chain gives it no plane
at all, so the knee direction would be undefined and the IK would flip. Build the metarig
from the **posed** world-space joint positions (`pose_bone.head` / `.tail` with the stance
applied), not from `head_local`/`tail_local`. Metarig bone lengths must still match the game
bones exactly, or the driven chain separates at the joints.

### 4. `use_armature_deform_only` re-parents survivors

The FBX exporter's *Only Deform Bones* option looks like the clean way to strip control bones
at export. It re-parents every surviving bone to its **nearest deform ancestor**, which
rewrites the Unity transform paths that `.anim` clips bind to. Never turn it on. Keep control
rigs in a separate armature object outside the export collection instead.

### 5. `bake_anim` defaults to True

Harmless today because neither blend has an action. It **will** start writing animation into
the model FBX as soon as one exists. `check_rig_contract.py` fails if animation ever appears
in the exported FBX.

## Tooling

All of the Python here is deliberately **Unity-free and Blender-free** so it runs while the
Editor holds the project lock (AGENTS.md ▸ 1).

| Tool | Does |
|---|---|
| `Tools/blender/fbx_skeleton.py` | minimal binary-FBX reader (v7400): names, hierarchy, full paths, skin clusters, shape keys |
| `Tools/blender/check_rig_contract.py` | the four contract tests, against goldens in `Tools/blender/golden/` |
| `Tools/blender/compare_fbx.py` | stricter structural diff of two FBX files — also bone transforms, topology, weights, `GlobalSettings` |
| `Tools/blender/export_avatar.py` | the **only** sanctioned way to export. Run through Blender |
| `Tools/blender/housekeeping.py` | stale vertex groups, orphaned objects, `use_connect` asymmetries |
| `Tools/blender/rename_arm_pack.py` | the ncho backpack-arm rename, as a worked example of a bone rename |
| `Tools/blender/build_metarig.py` | builds the Rigify metarig from posed joints, generates, and moves the result out of the export scope |
| `Tools/blender/bind_ctrl_rig.py` | the `Copy Transforms` binding + piston aims, with a self-check that can actually fail |
| `Tools/blender/render_poses.py` | Workbench deformation check through a few poses |
| `Tools/blender/extract_pose.py` | read a hand-made pose off a game armature as world matrices. **Read-only** |
| `Tools/blender/apply_pose.py` | solve the control rig so the game rig reproduces such a pose. Dry run by default |
| `Tools/blender/relink_character.py` | re-link a render file onto `<name>_all` and override it as one hierarchy. Dry run by default |
| `Tools/unity-repair/dump_fbx_ids.ps1` | name → Unity file ID map, headless. **Refuses to run while the Editor is open** |
| `Tools/unity-repair/repair_refs.py` | re-points scene references after a rename, with an audit |
| `Assets/_exegesis/shared/Editor/FbxIdDump.cs` | the Editor side of the ID dump; also `Tools > Exegesis > Debug > Dump FBX File IDs` |

### Exporting

```
blender --background --factory-startup source/ncho/ncho.blend \
    --python Tools/blender/export_avatar.py -- --character ncho --assert-pose
python Tools/blender/check_rig_contract.py
```

Only three exporter settings differ from Blender's defaults, and each was verified by
reproducing the committed FBX exactly: `apply_scale_options='FBX_SCALE_ALL'`,
`add_leaf_bones=False`, `use_selection=True`. Everything else is default on purpose.

`Props` ships **viewport-hidden**, and `select_set()` is a silent no-op on a hidden object —
the export script unhides before selecting, or `Props` would vanish from the FBX with no error.

### Changing the export settings

Never edit `EXPORT_SETTINGS` without proving the result. Export to a scratch path from an
**unmodified** blend and require `compare_fbx.py` to report `IDENTICAL` first, so that later
diffs mean something.

## Renaming a bone

Two-part change. **Step 1 cannot be redone after the fact** — once the FBX is reimported, the
old name→ID map is gone, and the `.meta`'s `internalIDToNameTable` is empty for these assets.

1. `powershell Tools/unity-repair/dump_fbx_ids.ps1 -Out Tools/unity-repair/fbx_ids_before.json`
   — with the Editor **closed**. Commit it.
2. Rename in Blender, script-driven from an explicit table.
3. Export; run `check_rig_contract.py` and **review the diff** — it should show exactly your
   renames and nothing else.
4. `dump_fbx_ids.ps1 -Out …_after.json`, join through the rename table into a remap file.
5. `repair_refs.py --remap … --apply`, and read the audit.
6. Re-seed the golden: `check_rig_contract.py --seed --character <name>`.

### Worked example: ncho's backpack arms

`arm_pack_root` carries a complete second arm pair. Its bones were named `upper_arm.L.001`,
`hand.L.001`, `f_index.01.L.001` …, which read as accidental duplicates. Renamed to a `pack_`
prefix (`pack_upper_arm.L`), mirroring obi-me's existing `minor_*` convention for its second
arm pair. `arm_pack_root` kept its name as a stable anchor.

40 bones. 80 file IDs changed (GameObject + Transform each), **zero collateral** — no
unrenamed object's ID moved. 32 scene references re-pointed, all of them the Extra Arm
Dynamics PhysBone roots and ignore-lists. Total references 1611 before and after.

### Known pre-existing condition

12 scene references point at FBX objects that no longer exist — stale `m_Modifications`
override targets from earlier edits of the model. They are inert (Unity keeps stale overrides
around and never applies them) and predate this tooling. `repair_refs.py`'s audit accounts for
them: the check is that the *set* of unresolved references does not grow.

## The ncho control rig (Rigify)

`source/ncho/ncho.blend` holds three armatures, in three collections under one parent:

```
Collection "ncho_all"            <- link THIS from a render file
    Collection "ncho"            <- the FBX export scope. Hierarchy FROZEN.
        Body, Props              meshes, skinned to Armature
        Armature                 the 132-bone game rig
    Collection "ncho_rig"        <- never exported
        ncho_metarig             115 bones, the editable definition
        ncho_ctrl                680 bones, Rigify's output
        ncho_rig_widgets/        236 WGT- shape objects
```

`ncho_all` exists purely so a render file can override the game rig and the control
rig as ONE hierarchy — see below. It changes nothing about the export:
`export_avatar.py` resolves `bpy.data.collections['ncho']`, a flat datablock lookup that
nesting does not affect, and the export was re-verified IDENTICAL after the move.

Rigify links its generated rig into whatever collection is active, which is the
*export* collection; `build_metarig.py`'s `finalize()` moves the rig and all 236
widgets out. Without that they would ride along into the FBX.

### The one switch

`ncho_ctrl["use_ctrl_rig"]` drives the influence of all 115 constraints on the
game rig — 111 `Copy Transforms` bindings plus 4 piston aims.

    0  the game armature behaves exactly as it did before the rig existed
    1  it follows the controls

**It is saved as 0.** A linking file therefore gets the character exactly as that file
poses it, and opts *into* rig-driving by overriding the property; the alternative silently
dragged every render file onto the control rig's rest stance.
`export_avatar.py` sets it to 0 as well, which is what keeps the FBX byte-identical.
Verified: with the full rig and binding present, the export still compares
IDENTICAL to the committed FBX on objects, hierarchy, bone transforms,
topology, weights, `GlobalSettings` and shape keys.

**Setting a custom property from Python does not re-evaluate the drivers that
read it.** Tag the depsgraph (`obj.update_tag()`, then
`view_layer.update()` and `evaluated_depsgraph_get().update()`) or every value
you read back is stale. An earlier version of the binding self-check passed
while the switch did nothing, for exactly this reason.

### Rig types

| Part | Rig type | Notes |
|---|---|---|
| Hips/Spine/Chest | `spines.basic_spine` | |
| Neck/Head | `spines.super_head` | `connect_chain=True` |
| Legs | `limbs.rear_paw` | purpose-built for digitigrade; see below |
| Arms ×4 | `limbs.arm` | body pair + backpack (`pack_*`) pair |
| Fingers ×20 | `limbs.super_finger` | one master curl control each |
| Tail | `spines.basic_tail` | `connect_chain=False` — `TailRoot`'s head is offset from `Hips`' tail, and Rigify rejects a "connected" chain whose position is disjoint |
| Ears, wings, `arm_pack_root`, pistons | `basic.super_copy` | |
| ab-wires | `limbs.simple_tentacle` | |

`segments=1` everywhere. The binding reads `ORG-` bones, and the character
deforms rigidly off the `_fix` stubs, so Rigify's twist subdivision and its
mid-limb tweak controls would drive `DEF-` bones that nothing follows. One
segment keeps every control in the rig one that actually does something.

### Two rules the metarig must follow

1. **A bone with a `rigify_type` must not be `use_connect`.** Otherwise the
   parent rig's chain walk swallows it and both rigs claim the same bones
   (`CONFLICT: bone ORG-Neck is claimed by...`). Rigify's own metarigs follow
   this without exception; `connect_chain` is how a sub-rig re-links logically.
2. **Build it from posed joints, not rest.** See footgun 3b.

### The legs

`limbs.rear_paw` maps exactly onto `thigh → digiShin → digiAnkle → digiFoot`:
a 4-bone chain, no heel bone, the same shape Rigify's own wolf metarig uses.

- `digiAnkle_ik.L` places the foot; IK tracking is exact to ~0.001.
- `digiAnkle_heel_ik.L` shapes the hock. Moving it forward or down swings the
  knee and compresses the leg. **It is not rotation-inert** — an earlier note
  here claimed rotating it does nothing, and that was wrong: it fed the ankle
  1:1 on all three axes, which is why the ankle was completely unconstrained.
  It is now pinned to its local X.
- **There is no heel-to-toe roll, and that is correct.** ncho has no heel and no
  forward toe; `digiFoot` is a 0.2-unit vertical peg and the character stands on
  its tip. Synthesising a forward-pointing toe would restore Rigify's foot roll
  but leave the metarig toe pointing 90° away from `digiFoot`, so the binding
  would mis-drive that bone.
- **Joint limits are on the CONTROLS, not the IK chain.** `ORG-digiAnkle` is
  driven by Copy Transforms from `digiAnkle_fk` and `MCH-thigh_ik_target`, so
  clamping the IK degrees of freedom on `MCH-digiAnkle_ik3` changed nothing at
  all. Worse, the IK-limit route does not map onto the joint angle: `rear_paw`
  spreads the bend across `ik`/`ik2`/`ik3`, and measured knee floors came out
  126.5° at ±135 (stable) or 96.5° at ±160 (which reintroduced the flip) — never
  the 45° wanted. A `Limit Rotation` on the control is exact instead, because X
  maps 1:1 onto the interior angle:

      digiShin_fk    interior = 111.14 - X    ->  X in [-68.9, +66.1]
      digiAnkle_fk   interior = 101.56 + X    ->  X in [-56.6, +78.4]
      forearm_fk     interior = 180.00 - Z    ->  Z in [  0.0, +135.0]

  The elbow is on **Z**, not X: `forearm_fk` Z+45 gives interior 135 with the
  hand swinging to +Y, while X and Y do nothing at all. Allowing only positive Z
  keeps it out of the backward bend. Driven to Z+200 it holds at 45.02.

  `finalize()` measures the stance angle off the game rig and derives the range,
  so it stays right if the stance ever moves; Y and Z are pinned shut. Driven to
  ±200° both joints hold **45.0 … 180.0** exactly, and off-axis input does
  nothing.
- **`IK_Stretch` defaults to 0**, set by `finalize()`. At full extension the
  chain goes exactly colinear — the IK singularity — and because the rest pose
  is straight, that is reachable about 0.6 units below the stance. With stretch
  on it hits 0.00° and then scales the bones, which humanoid retargeting will
  not carry back to Unity either.

### The arms cannot use IK

`limbs.arm` here is dead: pulling the hand IK toward the shoulder moves the
target (2.70 -> 1.20 from the shoulder) and the hand simply does not follow, so
the arm behaves as one rigid segment. The chain is **exactly** colinear --

    upper_arm.L  head (+0.900,+0.150,+7.200)  tail (+2.350,+0.150,+7.200)
    forearm.L    head (+2.350,+0.150,+7.200)  tail (+3.600,+0.150,+7.200)
    hand.L       head (+3.600,+0.150,+7.200)  tail (+3.975,+0.150,+7.200)

only X varies -- so the solver sits precisely on the singularity with no
gradient to move along. Confirmed exhaustively: freeing X, Y or Z on
`MCH-forearm_ik` all leave the hand at full extension 2.700, and enabling the
pole vector, with the pole target moved, changes nothing either. `IK_Stretch`
used to hide this by letting the solver scale the bones instead of bending
them, which is what "moving the hand IK scales the arm" was.

**So pose the arms in FK.** The FK chain works correctly and is where the elbow
limit above lives. The legs are equally colinear but `rear_paw` builds a
different structure (the heel control gives it an off-axis hint) and does bend.

### Why the limbs are not pre-bent

Rigify derives a limb's bend plane from the metarig's rest geometry, and this
rest pose is deliberately straight (footgun 3b). With nothing to derive from,
`rotation_axis: automatic` leaves the solver to pick, and the elbow buckles up
instead of leading +Y.

Nudging the metarig joint off-colinear **does** fix that — 0.5° at the elbow gave
a clean +Y lead with the FBX still IDENTICAL — and it is still the wrong answer,
because a defined bend plane is exactly what Rigify re-derives the chain's axes
from. It re-rolls the limb. Measured on `ORG-upper_arm.L`, whose *direction*
barely moved, the Z axis went from `(+0.14,-0.39,+0.91)` to `(+0.98,-0.09,-0.19)`
— about 90°. The binding is Copy Transforms, so that roll lands straight on the
game bone: both arms rotate 90° while the hands, a separate bone, do not.

Naming the axis instead does not work either: `rotation_axis: 'z'` on the arm
frees an axis the chain cannot bend around, and the elbow then will not move at
all. **The elbow's bend direction is still unsolved.** Any fix has to leave the
limb's roll alone, or the binding has to stop copying roll.

`PREBEND` in `build_metarig.py` is deliberately empty, with this written above it.

### Orientation is checked, not just position

`bind_ctrl_rig.py` compared **head positions**, and a bone rolled about its own
axis moves no head — so the 90° arm twist above scored a clean pass. It now
compares orientation too, and would have caught it at 88°. This is the same
blind spot `apply_pose.py` had: see *Carrying a hand-made pose onto the rig* ▸ 2.

### The pistons

Each game piston Damped Tracks the **control rig's** copy of the other
(`ORG-piston_shaft.L` / `ORG-piston_sleeve.L`), never the other game bone
directly: two game bones tracking each other is a dependency cycle, which
Blender resolves arbitrarily. That cycle silently corrupted the exported bind
pose — one shaft came out 349° off — while still "succeeding". Routing through
the control rig breaks it, because the control rig has no dependency on the
game rig. Aim only, no `Stretch To`. Never keyed.

### Checking deformation

`Tools/blender/render_poses.py` renders the character through a few control-rig
poses using the Workbench engine — flat shading with cavity, which reads
creasing and pinching far better than the real materials. Worth running after
any weighting or rig change, because the mesh is modelled at the straight rest
pose and bent into the stance, so the weighting is doing real work at the hock.

### Carrying a hand-made pose onto the rig

A pose made by hand before the control rig existed can be transferred rather than re-done:

```
blender --background <file-with-the-pose>.blend     --python Tools/blender/extract_pose.py -- --armature Armature --out pose.json
blender --background source/ncho/ncho.blend     --python Tools/blender/apply_pose.py -- --pose pose.json          # dry run
```

`extract_pose.py` never writes, so it is safe to point at a render file with work in it. It
mutes the `CTRL_` binding constraints while sampling — a file that *links* an already-rigged
ncho inherits those through the library override, and without muting you record the control
rig's rest stance instead of the hand pose that is still stored on the bones.

`apply_pose.py` clears the control rig to rest, switches limbs to FK, and iterates
parent-first in two stages. Measured on ncho's `orbital_insertion_01` pose: **126 of 128
posed bones exact to 0.00001 units and 0.0000°**.

**Solving the bindings alone leaves the rig looking untouched.** A chain rig binds
`ORG-Tail.005` from `tweak_Tail.004`, so following the constraints lands the entire pose on
tweaks: the character is posed correctly while `Tail.001`–`Tail.011`, `TailRoot`,
`Spine_fk`, `Chest_fk`, `Hips_fk` and the ab-wire controls all sit at rest. It reads as "the
rig is in T-pose" and there is nothing useful to animate from.

Driving those controls *instead* of the bindings does not work either — the tail's direction
comes from its `Stretch To`, so the FK controls alone left tail bones up to **12°** out and
the spine **0.4** units out. So both, in order: the primary control an animator would grab
(`<name>`, then `<name>_fk`) first, then the binding on top. The pose stays exact, the
primary controls end up where the pose is, and the tweaks hold only a small residual. 19
controls on ncho, taking the posed count from 119 to 137 of 235.

Several controls can own one bone — `Hips` owns `torso`, `hips` *and* `Hips_fk` — so they
are driven outermost first, each being the parent of the next.

**The IK controls need a separate snap.** The solve drives the FK chain, so `hand_ik`,
`digiAnkle_ik`, `thigh_ik` and the heel controls stay wherever the rig was generated —
inert while the limb is on FK, so the character is posed correctly and the rig still reads
as half in T-pose, and switching a limb to IK would snap it. Rigify's own
`rigify_limb_ik2fk` operator does this properly, pole included. Its generated UI carries the
exact bone lists per limb, so `apply_pose.py` parses them out of the `*_rig_ui.py` text
datablock rather than hardcoding them — they stay correct if the rig is regenerated. The
operator leaves `IK_FK` alone, so the limbs stay on FK and the solve is untouched: accuracy
is identical before and after the snap.

Those operators are registered by the rig's UI script. They survive into a file that links
the character, but under `--factory-startup` they are absent — `apply_pose.py` says so
loudly rather than skipping quietly.

Together this leaves **1 of 235 controls at the rest position: `root`**, which belongs at
the origin. What stays at an identity *basis* is a different question and fine — the limb
`*_tweak` offsets, the finger `_master` curls and the pole indicators are all legitimately
zero, and a control under a posed parent moves with it regardless.

The rig is **cleared to rest before solving**. Without that a second run stacks on the
first — the previous tweak offsets survive while the new solve drives the FK controls, and
the pose comes out doubled.

Three things make that harder than "copy every matrix":

1. **Chain tips are one bone short.** A `basic_tail` or `simple_tentacle` chain drives
   `ORG-<bone>` with `Copy Transforms` from the tweak at its *head* and a `Stretch To` the
   tweak at its *tail*. Each tweak is therefore positioned as the next bone's control —
   except the one past the end, which no game bone maps to. Left alone, `Tail.011` came out
   **208° rotated and 14× long while its head was still exact to 1e-5**. `apply_pose.py`
   finds these by diffing `Stretch To` targets against `Copy Transforms` targets and places
   them at the game bone's tail; ncho has three (the tail tip and both `ab_wire_grab`). All
   three round-trip to 0.00000 / 0.0000° with their tip tweaks deliberately displaced — note
   that these chains are driven by tweak **location**, so a test that only rotates a tweak
   moves nothing and passes for the wrong reason.
2. **Measure rotation, not just position.** The bug above read as a perfect 0.00001 score
   for as long as the check was head position only. A bone twisted or stretched *in place*
   is invisible to a positional metric.
3. **The pistons are derived, not posed.** `CTRL_piston_aim` is a `Damped Track`, so their
   rotation is computed; `extract_pose.py` mutes it, so the recorded rotation is whatever
   the hand file happened to hold. They are reported separately and excluded from the match
   — a residual there (ncho's read 7–13°) means the aim is doing its job, not that the pose
   is wrong.

**Known limit — first-phalanx twist.** `super_finger` orients each bone by a `Stretch To` the
next control; the per-bone control supplies only location and scale. The first bone of a
finger is therefore rolled by the hand and by where the second bone sits, and *nothing* can
twist it about its own axis. ncho's thumbs land 1.3° and 3.0° off in roll, every other finger
bone exact. That is the rig type, not the solver, and `ROTATION_GATE` (5°) is set to catch a
broken chain rather than this.

### Linking ncho into a render file

**Link `ncho_all`, not `ncho`, and override the whole hierarchy.** Only then do the
`CTRL_` bindings land on the override, which is the only place they persist.

Linking just the export collection puts the control rig in the file as a read-only
indirect dependency, and nothing can pose it. Overriding `ncho_ctrl` on its own does not
help — the 115 bindings still target the linked rig — and repointing `constraint.target`
from Python **is not recorded as an override operation**: it works for the session and
reverts on reload, with zero constraint entries in `override_library.properties` to show
for it. `override_hierarchy_create` on the `ncho` collection cannot reach the rig either,
because the rig is not in that collection. Hence `ncho_all`.

Migrating a render file that already links the old way:

```
blender --background <render-file>.blend     --python Tools/blender/extract_pose.py -- --out pose.json
blender --background <render-file>.blend     --python Tools/blender/relink_character.py -- --character ncho --save
blender --background <render-file>.blend     --python Tools/blender/apply_pose.py -- --pose pose.json --save
```

Extract first: re-linking discards the hand pose stored on the old override, and step
three puts it back through the control rig. `orbital_insertion_01.blend` has been through
this — 115 bindings on the override, 0 stranded, and it reloads evaluating **0.00001** from
its hand pose where it had been 7.43 off.

Two things `relink_character.py` has to clean up after `override_hierarchy_create`, because
the UI does them for you and the Python API does not:

- **The linked collection stays in the scene next to its override**, leaving the character
  in the scene twice — read-only originals underneath the editable copies. It refuses to
  save if duplicate meshes survive.
- **The 236 `WGT-` bone shapes are meshes**, display-only in ncho.blend but visible *and
  renderable* through a fresh view layer. `ncho_rig_widgets` is excluded from the view
  layer; bone custom shapes still draw, because they read the object datablock rather than
  the scene.

It also snapshots per-object visibility and puts it back, since re-linking otherwise
resets it to the library's value: `orbital_insertion_01` keeps `Props` out of its renders,
and that would have silently switched itself back on. The restore runs *before* the hides
below, or it puts back the very thing they hide.

**`ncho_metarig` is hidden.** It is never posed, so it sits in rest position looking exactly
like a T-posed skeleton laid over the character — the most convincing way to believe the rig
is not following. It is useless in a render file anyway: editing it does nothing without
regenerating the rig.

Re-running the tool on an already-migrated file is safe: teardown handles both the old
`ncho` link and a previous `ncho_all` one. Handling only the first leaves the earlier linked
collection in the scene and puts the character in it twice.

**The switch needs an explicit override entry.** `apply_pose.py` sets `use_ctrl_rig` to 1,
but a Python write to a custom property on an override is not recorded either — the file
saves, reloads with the switch back at the library's 0, and shows the rest stance again.
It has to be registered by hand, which `apply_pose.py` now does:

```python
override.properties.add(rna_path='["use_ctrl_rig"]').operations.add(operation='REPLACE')
```

`operations_update()` does not pick it up. Bone poses, by contrast, are captured
automatically — the control rig saved 1164 override properties without any help.

### Overrides go stale, and nothing tells you

`orbital_insertion_01.blend` was carrying 75 of ncho's 111 `CTRL_bind` constraints — missing
exactly the 36 `pack_*` backpack-arm bones, which were bound after that override was made.
Blender's **`preferences.experimental.override_auto_resync` is off**, so a library override
does not pick up constraints added to the library afterwards.

`ID.override_library.resync(scene, view_layer=...)` fixes it, in background too, and is
lossless — verified by extracting the pose either side of a resync and diffing: 0.000000
across all 132 bones, same 66 hand-posed bones. Two notes: **resync recreates the datablock**,
so any Python reference you held is dead afterwards (`ReferenceError: StructRNA ... has been
removed`) — re-fetch it; and a `.blend` copied somewhere else cannot resolve `//..`-relative
library paths, so test copies must sit at the same directory depth or every count reads 0.

## Current state of the rigs

**ncho has the Rigify control rig** described above — 132 game bones driven by a 680-bone
`ncho_ctrl`, gated on `use_ctrl_rig`. **obi-me is still FK-only with zero constraints** — no
IK, no controls, no Rigify; it has the Phase 0 cleanup and the export contract, nothing more.

ncho's game rig is 132 bones with four arms (two on the body, two on the backpack), an
11-bone tail, ears, a `Chest`↔`Hips_fix` piston pair and wing/ab-wire/tank props. obi-me is
124 bones with four arms and two 5-bone `big_manipulator` chains carrying their own
2-segment fingers.

ncho is authored ~8 Blender units tall, obi-me ~26 with a 38-unit arm span. Both import at
`globalScale: 1, useFileScale: 1`. **Do not change the source scale** — it would move every
bone and disturb the rest pose. Compensate rig-side instead.

Since Phase 0 both rigs are fully L/R mirror-symmetric (0 bones failing a mirror check).
