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

`source/ncho/ncho.blend` holds three armatures, in three collections:

```
Collection "ncho"            <- the FBX export scope. Hierarchy FROZEN.
    Body, Props              meshes, skinned to Armature
    Armature                 the 132-bone game rig
Collection "ncho_rig"        <- never exported
    ncho_metarig             115 bones, the editable definition
    ncho_ctrl                680 bones, Rigify's output
    ncho_rig_widgets/        236 WGT- shape objects
```

Rigify links its generated rig into whatever collection is active, which is the
*export* collection; `build_metarig.py`'s `finalize()` moves the rig and all 236
widgets out. Without that they would ride along into the FBX.

### The one switch

`ncho_ctrl["use_ctrl_rig"]` drives the influence of all 115 constraints on the
game rig — 111 `Copy Transforms` bindings plus 4 piston aims.

    0  the game armature behaves exactly as it did before the rig existed
    1  it follows the controls

`export_avatar.py` sets it to 0, which is what keeps the FBX byte-identical.
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
- `digiAnkle_heel_ik.L` is a **positional** control that shapes the hock — it is
  consumed via `COPY_LOCATION`, so rotating it does nothing. Moving it forward
  or down swings the knee and compresses the leg.
- **There is no heel-to-toe roll, and that is correct.** ncho has no heel and no
  forward toe; `digiFoot` is a 0.2-unit vertical peg and the character stands on
  its tip. Synthesising a forward-pointing toe would restore Rigify's foot roll
  but leave the metarig toe pointing 90° away from `digiFoot`, so the binding
  would mis-drive that bone.
- **`IK_Stretch` defaults to 0**, set by `finalize()`. At full extension the
  chain goes exactly colinear — the IK singularity — and because the rest pose
  is straight, that is reachable about 0.6 units below the stance. With stretch
  on it hits 0.00° and then scales the bones, which humanoid retargeting will
  not carry back to Unity either.

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

## Current state of the rigs

Both armatures are **FK-only with zero constraints** — no IK, no controls, no Rigify. ncho is
132 bones with four arms (two on the body, two on the backpack), an 11-bone tail, ears,
a `Chest`↔`Hips_fix` piston pair and wing/ab-wire/tank props. obi-me is 124 bones with four
arms and two 5-bone `big_manipulator` chains carrying their own 2-segment fingers.

ncho is authored ~8 Blender units tall, obi-me ~26 with a 38-unit arm span. Both import at
`globalScale: 1, useFileScale: 1`. **Do not change the source scale** — it would move every
bone and disturb the rest pose. Compensate rig-side instead.

Since Phase 0 both rigs are fully L/R mirror-symmetric (0 bones failing a mirror check).
