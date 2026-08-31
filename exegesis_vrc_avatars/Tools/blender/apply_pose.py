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
"""

import argparse
import json
import sys

import bpy
from mathutils import Matrix

MCH = 'MCH-'
ORG = 'ORG-'


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def resolve_control(ctrl, name):
    """Which control bone positions the game bone `name`."""
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

    ctrl = bpy.data.objects.get(args.ctrl)
    game = bpy.data.objects.get(args.game)
    if ctrl is None or game is None:
        raise SystemExit('need both %r and %r in this file' % (args.ctrl, args.game))

    if 'use_ctrl_rig' in ctrl:
        ctrl['use_ctrl_rig'] = 1.0
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

    to_ctrl = ctrl.matrix_world.inverted()
    for index in range(args.passes):
        for name in order:
            control = mapping.get(name)
            if control is None:
                continue
            ctrl.pose.bones[control].matrix = to_ctrl @ targets[name]
            bpy.context.view_layer.update()
        error = measure(game, targets, order)
        print('   pass %d: max error %.5f, median %.5f' % (index + 1, error[0], error[1]))

    worst = report(game, targets, order, hand_posed)

    if args.save and worst < 0.02:
        bpy.ops.wm.save_mainfile()
        print('\nsaved %s' % bpy.data.filepath)
    elif args.save:
        raise SystemExit('max error %.4f is too large to save' % worst)
    else:
        print('\nDRY RUN -- nothing written. Re-run with --save.')


def measure(game, targets, order):
    bpy.context.view_layer.update()
    errors = sorted(((game.matrix_world @ game.pose.bones[name].matrix).translation
                     - targets[name].translation).length for name in order)
    return errors[-1], errors[len(errors) // 2]


def report(game, targets, order, hand_posed):
    bpy.context.view_layer.update()
    rows = []
    for name in order:
        got = (game.matrix_world @ game.pose.bones[name].matrix).translation
        rows.append((((got - targets[name].translation).length), name))
    rows.sort(reverse=True)
    worst = rows[0][0] if rows else 0.0
    print('\nreproduction accuracy (world head position, %d bones):' % len(rows))
    for error, name in rows[:8]:
        flag = ' (hand-posed)' if name in hand_posed else ''
        print('   %-22s %.5f%s' % (name, error, flag))
    within = sum(1 for e, _ in rows if e < 1e-3)
    print('   %d of %d bones within 0.001; worst %.5f' % (within, len(rows), worst))
    return worst


if __name__ == '__main__':
    main()
