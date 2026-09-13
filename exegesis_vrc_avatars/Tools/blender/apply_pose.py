"""Reproduce a hand-made game-rig pose on the Rigify control rig.

    blender --background source/ncho/ncho.blend \
        --python Tools/blender/apply_pose.py -- --pose pose.json [--save]

DRY RUN BY DEFAULT (it reports the accuracy without writing).

Takes the JSON from extract_pose.py -- world matrices per game bone -- and
solves the control rig so the game rig lands back in that pose. This is how a
pose posed by hand, before the control rig existed, gets carried forward
instead of re-done.

HOW THE MAPPING IS FOUND
------------------------
Not hardcoded. Every ORG- bone in a Rigify rig is driven by Copy Transforms
from the control that owns it, so the rig tells us the mapping:

    ORG-digiFoot.L      <- digiFoot.L                        direct
    ORG-thigh.L         <- thigh_fk.L / MCH-thigh_ik.L       limb (FK + IK blend)
    ORG-Tail.001        <- tweak_TailRoot                    tail tweak
    ORG-Hips            <- (no constraint; parented to tweak_Hips)

Rule: take the first non-MCH Copy Transforms subtarget; failing that, a control
with the bone's own name; failing that, `tweak_<name>`.

Limbs are switched to FK (`IK_FK = 1`) first. FK is a direct 1:1 match to the
original pose; solving IK targets instead would have to guess a pole angle that
the hand pose never specified. Snap a limb back to IK afterwards from the Rig
Main Properties panel if you want it on IK.

Applied parent-first over several passes: setting a parent moves its children,
so one pass leaves descendants short of target. It converges in two or three.

CHAIN TIPS
----------
A Rigify chain (basic_tail, simple_tentacle) drives ORG-<bone> with Copy
Transforms from the tweak at its head AND a Stretch To the tweak at its tail.
Every tweak is therefore positioned as the *next* bone's control -- except the
one past the end of the chain, which no game bone maps to. Left where it sits,
the last bone stretches to reach it: ncho's tail tip came out 208 deg off and
14x long while its head was still exact to 1e-5. Those orphan tweaks are found
by comparing Stretch To targets against Copy Transforms targets, and placed at
the game bone's world TAIL.

UNREACHABLE TWIST
-----------------
A `super_finger` chain orients each bone by a Stretch To the next control --
the per-bone control supplies only location and scale. The first phalanx of a
finger is therefore rolled by the hand and by where the second phalanx sits,
and nothing can twist it about its own axis. ncho's thumbs land 1.3 and 3.0 deg
off in roll for that reason, with every other finger bone exact. It is a
property of the rig type, not a solver failure, so ROTATION_GATE is set to
catch a broken chain (the tail tip was 208 deg) rather than this.

DERIVED BONES
-------------
The pistons are aimed by a Damped Track, never keyed, so their rotation is
computed rather than posed -- and `CTRL_piston_aim` is muted during extraction,
so the recorded rotation is whatever the hand file happened to hold. They are
reported apart from the pose and excluded from the accuracy gate.
"""

import argparse
import json
import math
import re
import sys

import bpy
from mathutils import Matrix, Vector

SPINE_MASTER = 'torso'

ROTATION_GATE = 5.0  # degrees; see UNREACHABLE TWIST

MCH = 'MCH-'
ORG = 'ORG-'


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def resolve_control(ctrl, name):
    """The control the rig's own binding says positions game bone `name`.

    Every ORG- bone is driven by Copy Transforms from the control that owns it,
    so the rig tells us the mapping. Setting these reproduces the pose exactly.
    """
    org = ctrl.pose.bones.get(ORG + name)
    if org is not None:
        subtargets = [c.subtarget for c in org.constraints
                      if c.type == 'COPY_TRANSFORMS' and c.subtarget]
        for subtarget in subtargets:
            if not subtarget.startswith(MCH) and subtarget in ctrl.pose.bones:
                return subtarget
    for guess in (name, 'tweak_' + name):
        if guess in ctrl.pose.bones:
            return guess
    return None


def primary_controls(ctrl, name, binding):
    """Controls an ANIMATOR grabs for `name`, outermost first, minus the binding.

    A chain rig binds `ORG-Tail.005` from `tweak_Tail.004`, so solving the
    bindings alone lands the whole pose on tweaks and leaves `Tail.005`,
    `Spine_fk`, `hips` and the rest sitting at rest -- the character looks posed
    and the rig looks untouched, which is not something you can animate from.

    Driving these INSTEAD of the bindings does not work: the tail's direction
    comes from its Stretch To, so the FK controls alone left tail bones up to
    12 deg out and the spine 0.4 units out. They are driven FIRST and the
    bindings applied on top, which restores the exact pose while leaving the
    primary controls where the pose actually is.

    Several can apply to one bone -- `Hips` owns `torso`, `hips` AND `Hips_fk` --
    so they come back outermost first, because each is the parent of the next.
    """
    candidates = []
    for guess in (name.lower(), name, name + '_fk'):
        if guess in ctrl.pose.bones and guess != binding and guess not in candidates:
            candidates.append(guess)
    # Rigify's basic_spine master sits above `hips` and carries the whole torso.
    if candidates and candidates[0] == 'hips' and SPINE_MASTER in ctrl.pose.bones:
        candidates.insert(0, SPINE_MASTER)
    return candidates


def reset_controls(ctrl):
    """Clear the control rig back to rest before solving.

    Without this a second run stacks on top of the first: the tweak offsets from
    the previous solve are still there while the new one drives the FK controls,
    and the pose comes out doubled.
    """
    cleared = 0
    for pose_bone in ctrl.pose.bones:
        if pose_bone.matrix_basis != Matrix.Identity(4):
            pose_bone.matrix_basis = Matrix.Identity(4)
            cleared += 1
    bpy.context.view_layer.update()
    return cleared


def orphan_tip_tweaks(ctrl):
    """{ORG bone: tweak} for chain tips that nothing else positions.

    See CHAIN TIPS above. A Stretch To target that is never a Copy Transforms
    target is one bone past the end of its chain.
    """
    stretch, copied = {}, set()
    for pose_bone in ctrl.pose.bones:
        if not pose_bone.name.startswith(ORG):
            continue
        for constraint in pose_bone.constraints:
            if not constraint.subtarget:
                continue
            if constraint.type == 'COPY_TRANSFORMS':
                copied.add(constraint.subtarget)
            elif constraint.type == 'STRETCH_TO':
                stretch[pose_bone.name] = constraint.subtarget
    return {org[len(ORG):]: tweak for org, tweak in stretch.items()
            if tweak not in copied}


def derived_bones(game):
    """Game bones positioned by an aim rather than copied from a control.

    Their rotation is computed, so the recorded value is not a pose to match.
    """
    derived = set()
    for pose_bone in game.pose.bones:
        constraints = [c for c in pose_bone.constraints if c.name.startswith('CTRL_')]
        if constraints and not any(c.type == 'COPY_TRANSFORMS' for c in constraints):
            derived.add(pose_bone.name)
    return derived


def place_tip(ctrl, tweak, point, to_ctrl):
    """Move a tip tweak to a world point, leaving its orientation alone."""
    pose_bone = ctrl.pose.bones[tweak]
    matrix = pose_bone.matrix.copy()
    matrix.translation = to_ctrl @ point
    pose_bone.matrix = matrix


def world_tail(game, name, matrix):
    """World-space tail of a game bone posed to `matrix`."""
    return matrix @ Vector((0.0, game.data.bones[name].length, 0.0))


SNAP_CALL = re.compile(
    r"operator\('pose\.(rigify_limb_ik2fk_[0-9a-z]+)'[^\n]*\n"
    r"((?:\s*props\.\w+ = '[^']*'\n)+)")


def snap_ik_controls(ctrl):
    """Park the IK controls on the solved pose, with Rigify's own IK->FK snap.

    The solve drives the FK chain, so without this the IK controls stay where
    the rig was generated: `hand_ik` and `digiAnkle_ik` sitting out at the rest
    pose while the character is posed. They are inert while the limb is on FK,
    so the pose is right and the rig still reads as half in T-pose -- and
    switching a limb to IK would snap it.

    Rigify's generated UI carries the exact bone lists per limb, so parse them
    out of the text datablock instead of hardcoding them; they stay correct if
    the rig is regenerated. Its operator also handles the pole target, which is
    not worth reimplementing.

    Needs `blender --enable-autoexec`. The operators are registered by the rig's
    UI script, and without autoexec they are simply absent -- so say so loudly
    rather than quietly skipping.
    """
    text = next((t for t in bpy.data.texts if t.name.endswith('_rig_ui.py')), None)
    if text is None:
        print('WARNING: no *_rig_ui.py in this file; IK controls left at rest')
        return 0

    calls = []
    for match in SNAP_CALL.finditer(text.as_string()):
        params = dict(re.findall(r"props\.(\w+) = '([^']*)'", match.group(2)))
        if params not in [c[1] for c in calls]:
            calls.append((match.group(1), params))
    if not calls:
        print('WARNING: no IK->FK snap calls found in %s' % text.name)
        return 0
    if not hasattr(bpy.ops.pose, calls[0][0]):
        print('WARNING: %s is not registered -- re-run with --enable-autoexec, '
              'or the IK controls stay at the rest pose' % calls[0][0])
        return 0

    previous = bpy.context.object
    bpy.context.view_layer.objects.active = ctrl
    bpy.ops.object.mode_set(mode='POSE')
    snapped = []
    for op_name, params in calls:
        try:
            getattr(bpy.ops.pose, op_name)(**params)
            snapped.append(params.get('prop_bone', '?'))
        except Exception as error:            # noqa: BLE001 - report and carry on
            print('   snap failed for %s: %s' % (params.get('prop_bone'), error))
    bpy.ops.object.mode_set(mode='OBJECT')
    if previous is not None:
        bpy.context.view_layer.objects.active = previous
    bpy.context.view_layer.update()
    return snapped


def persist_switch(ctrl):
    """Make `use_ctrl_rig` survive a save in a file that overrides the rig.

    A Python write to a custom property on a library override is NOT recorded as
    an override operation -- it holds for the session and reverts to the library
    value on reload, exactly like repointing `constraint.target`. The bone poses
    are picked up automatically; this one property has to be registered by hand,
    or the saved render file opens with the rig switched off and shows the
    character back in its rest stance. `operations_update()` does not catch it.
    """
    override = ctrl.override_library
    if override is None:
        return False
    path = '["use_ctrl_rig"]'
    if not any(prop.rna_path == path for prop in override.properties):
        override.properties.add(rna_path=path).operations.add(operation='REPLACE')
    return True


def resolve_object(name):
    """The EDITABLE object called `name`.

    A render file that links the character holds two datablocks under each name
    -- the read-only linked one and the local library override -- and a plain
    `bpy.data.objects[name]` can hand back either. Writing to the linked one
    raises nothing and changes nothing: the solve then reports the same error on
    every pass, which is the only sign anything is wrong. Blender's (name,
    library) key asks for the local one specifically.
    """
    return bpy.data.objects.get((name, None)) or bpy.data.objects.get(name)


def hierarchy_order(game):
    """Game bone names, parents before children."""
    order = []

    def walk(bone):
        order.append(bone.name)
        for child in bone.children:
            walk(child)

    for bone in game.data.bones:
        if bone.parent is None:
            walk(bone)
    return order


def switch_limbs_to_fk(ctrl):
    switched = []
    for pose_bone in ctrl.pose.bones:
        if 'IK_FK' in pose_bone.keys():
            pose_bone['IK_FK'] = 1.0
            switched.append(pose_bone.name)
    ctrl.update_tag()
    bpy.context.view_layer.update()
    bpy.context.evaluated_depsgraph_get().update()
    return switched


def main():
    parser = argparse.ArgumentParser(description='Apply a hand pose to the control rig.')
    parser.add_argument('--pose', required=True)
    parser.add_argument('--ctrl', default='ncho_ctrl')
    parser.add_argument('--game', default='Armature')
    parser.add_argument('--passes', type=int, default=3)
    parser.add_argument('--save', action='store_true')
    args = parser.parse_args(script_args())

    with open(args.pose, encoding='utf-8') as fh:
        payload = json.load(fh)
    targets = {name: Matrix(rows) for name, rows in payload['world_matrices'].items()}
    hand_posed = set(payload.get('hand_posed_bones', []))

    ctrl = resolve_object(args.ctrl)
    game = resolve_object(args.game)
    if ctrl is None or game is None:
        raise SystemExit('need both %r and %r in this file' % (args.ctrl, args.game))
    for role, obj in (('control rig', ctrl), ('game rig', game)):
        if obj.library is not None:
            raise SystemExit(
                'the %s %r is LINKED, not a library override -- it cannot be posed '
                'in this file. Make a library override of it first (writes to linked '
                'data are discarded silently).' % (role, obj.name))

    bound = sum(1 for pose_bone in game.pose.bones for constraint in pose_bone.constraints
                if constraint.name.startswith('CTRL_') and constraint.target is ctrl)
    if not bound:
        raise SystemExit(
            '%r has no CTRL_ constraint pointing at %r in this file, so posing it would '
            'change nothing. In a file that LINKS the character, the bindings target the '
            'linked rig and cannot be repointed (setting constraint.target from Python is '
            'not recorded as an override and reverts on reload) -- the rig has to be part '
            'of the linked hierarchy.' % (game.name, ctrl.name))
    print('%d CTRL_ constraints bind %r to %r' % (bound, game.name, ctrl.name))

    if 'use_ctrl_rig' in ctrl:
        ctrl['use_ctrl_rig'] = 1.0
        if persist_switch(ctrl):
            print('recorded use_ctrl_rig as a library override so it survives saving')
    cleared = reset_controls(ctrl)
    if cleared:
        print('cleared %d already-posed control bones back to rest' % cleared)
    switched = switch_limbs_to_fk(ctrl)
    print('switched %d limbs to FK' % len(switched))

    order = [n for n in hierarchy_order(game) if n in targets]
    mapping, unmapped = {}, []
    for name in order:
        control = resolve_control(ctrl, name)
        if control:
            mapping[name] = control
        else:
            unmapped.append(name)

    print('mapped %d game bones to controls; %d unmapped' % (len(mapping), len(unmapped)))
    if unmapped:
        print('   unmapped: %s' % ', '.join(unmapped))

    primary = {}
    for name in order:
        controls = primary_controls(ctrl, name, mapping.get(name))
        if controls:
            primary[name] = controls
    if primary:
        flat = sorted({c for controls in primary.values() for c in controls})
        print('primary controls driven before the bindings: %d (%s%s)'
              % (len(flat), ', '.join(flat[:6]), ', ...' if len(flat) > 6 else ''))

    tips = {n: t for n, t in orphan_tip_tweaks(ctrl).items() if n in targets}
    if tips:
        print('chain tips placed from bone tails: %s'
              % ', '.join('%s->%s' % (n, t) for n, t in sorted(tips.items())))
    derived = derived_bones(game) & set(order)
    if derived:
        print('aim-driven, excluded from the pose match: %s' % ', '.join(sorted(derived)))
    posed = [n for n in order if n not in derived]

    to_ctrl = ctrl.matrix_world.inverted()
    for index in range(args.passes):
        for name in order:
            for control in primary.get(name, ()):
                ctrl.pose.bones[control].matrix = to_ctrl @ targets[name]
                bpy.context.view_layer.update()
        for name in order:
            control = mapping.get(name)
            if control is None:
                continue
            ctrl.pose.bones[control].matrix = to_ctrl @ targets[name]
            bpy.context.view_layer.update()
        for name, tweak in tips.items():
            place_tip(ctrl, tweak, world_tail(game, name, targets[name]), to_ctrl)
            bpy.context.view_layer.update()
        error = measure(game, targets, posed)
        print('   pass %d: max error %.5f, median %.5f, max rot %.4f deg'
              % (index + 1, error[0], error[1], error[2]))

    snapped = snap_ik_controls(ctrl)
    if snapped:
        print('snapped the IK controls onto the pose: %s' % ', '.join(snapped))

    worst, worst_rot = report(game, targets, posed, hand_posed)
    if derived:
        report_derived(game, targets, sorted(derived))

    if args.save and worst < 0.02 and worst_rot < ROTATION_GATE:
        bpy.ops.wm.save_mainfile()
        print('\nsaved %s' % bpy.data.filepath)
    elif args.save:
        raise SystemExit('max error %.4f / %.3f deg is too large to save'
                         % (worst, worst_rot))
    else:
        print('\nDRY RUN -- nothing written. Re-run with --save.')


def deltas(game, targets, name):
    """(head distance, rotation error in degrees) for one bone."""
    got = game.matrix_world @ game.pose.bones[name].matrix
    want = targets[name]
    distance = (got.translation - want.translation).length
    angle = got.to_quaternion().rotation_difference(want.to_quaternion()).angle
    return distance, math.degrees(angle)


def measure(game, targets, order):
    """Head position alone will not catch a bone that is twisted or stretched
    in place -- the tail-tip bug read as 0.00001 until rotation was checked."""
    bpy.context.view_layer.update()
    rows = [deltas(game, targets, name) for name in order]
    distances = sorted(row[0] for row in rows)
    return distances[-1], distances[len(distances) // 2], max(row[1] for row in rows)


def report(game, targets, order, hand_posed):
    bpy.context.view_layer.update()
    rows = sorted((deltas(game, targets, name) + (name,) for name in order),
                  key=lambda row: (row[1], row[0]), reverse=True)
    worst = max(row[0] for row in rows) if rows else 0.0
    worst_rot = rows[0][1] if rows else 0.0
    print('\nreproduction accuracy (%d bones, world head + rotation):' % len(rows))
    for distance, angle, name in rows[:8]:
        flag = ' (hand-posed)' if name in hand_posed else ''
        print('   %-22s %.5f   %7.4f deg%s' % (name, distance, angle, flag))
    within = sum(1 for d, a, _ in rows if d < 1e-3 and a < 0.01)
    print('   %d of %d bones within 0.001 and 0.01 deg; worst %.5f / %.4f deg'
          % (within, len(rows), worst, worst_rot))
    return worst, worst_rot


def report_derived(game, targets, names):
    print('\naim-driven bones (rotation is computed, not posed -- for information):')
    for name in names:
        distance, angle = deltas(game, targets, name)
        print('   %-22s %.5f   %7.4f deg' % (name, distance, angle))


if __name__ == '__main__':
    main()
