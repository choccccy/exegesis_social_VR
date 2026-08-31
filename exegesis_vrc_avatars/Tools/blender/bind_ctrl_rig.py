"""Bind the game armature to the Rigify control rig, and derive the pistons.

    blender --background source/ncho/ncho.blend \
        --python Tools/blender/bind_ctrl_rig.py -- --character ncho [--save]

DRY RUN BY DEFAULT (`source/` is not in git -- back the file up first).
Idempotent: every constraint it adds is prefixed CTRL_TAG and removed before a
rebuild, so re-running is safe.

THE BINDING
-----------
One `Copy Transforms` per game bone, targeting `ORG-<same name>` on the control
rig -- the metarig deliberately uses the game bones' own names so there is no
lookup table to drift out of sync.

Bound from ORG- rather than DEF-: this character deforms RIGIDLY (all the weight
sits on the `_fix` stubs, see docs/rigging.md footgun 2), so Rigify's DEF- twist
subdivision has nothing to do. ORG- bones stay 1:1 with the metarig.

Every constraint's influence is driven by a single custom property,
`ncho_ctrl["use_ctrl_rig"]`:
    0 -> the game armature is exactly what it was before any of this existed
    1 -> it follows the control rig
`export_avatar.py` sets it to 0, which is what keeps the FBX byte-identical.

NOT BOUND, on purpose:
    *_fix     the actual deform bones; they must stay rigid children
    planti*   zero weight, humanoid proxy only. Solved from the digi chain when
              baking a clip back to Unity, not needed for rendering
    piston_*  derived below

THE PISTONS
-----------
`piston_shaft` hangs off Chest pointing down, `piston_sleeve` off Hips_fix
pointing up; they span the torso. Each Damped Tracks the CONTROL rig's copy of
the other (`ORG-piston_*`), so they stay aimed at one another as the spine
moves. Aiming the two game bones at each other directly is a dependency cycle.

Aim only, no `Stretch To`: the geometry is rigid and telescopes because the two
bones have different parents, and scaling a deform bone is exactly what humanoid
retargeting will not carry. These are never keyed.
"""

import argparse
import re
import sys

import bpy
from mathutils import Vector

CTRL_TAG = 'CTRL_'
ORG_PREFIX = 'ORG-'

CHARACTERS = {
    'ncho': {
        'game': 'Armature',
        'ctrl': 'ncho_ctrl',
        'switch': 'use_ctrl_rig',
        # (bone, aims at) -- mutually tracking pairs
        'pistons': [('piston_shaft.L', 'piston_sleeve.L'),
                    ('piston_sleeve.L', 'piston_shaft.L'),
                    ('piston_shaft.R', 'piston_sleeve.R'),
                    ('piston_sleeve.R', 'piston_shaft.R')],
    },
}

NEVER_BIND = (re.compile(r'_fix($|\.)'), re.compile(r'^planti'), re.compile(r'^piston_'))


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def bindable(name):
    return not any(p.search(name) for p in NEVER_BIND)


def clear(game):
    removed = 0
    for pose_bone in game.pose.bones:
        for constraint in list(pose_bone.constraints):
            if constraint.name.startswith(CTRL_TAG):
                pose_bone.constraints.remove(constraint)
                removed += 1
    return removed


def drive_influence(game, pose_bone, constraint, ctrl, switch):
    """Influence = ctrl['use_ctrl_rig']. One switch for the whole binding."""
    path = 'pose.bones["%s"].constraints["%s"].influence' % (pose_bone.name, constraint.name)
    game.animation_data_create()
    try:
        game.animation_data.drivers.remove(game.animation_data.drivers.find(path))
    except (RuntimeError, TypeError, AttributeError):
        pass
    fcurve = game.driver_add(path)
    driver = fcurve.driver
    driver.type = 'SCRIPTED'
    var = driver.variables.new()
    var.name = 'sw'
    var.type = 'SINGLE_PROP'
    var.targets[0].id_type = 'OBJECT'
    var.targets[0].id = ctrl
    var.targets[0].data_path = '["%s"]' % switch
    driver.expression = 'sw'


def bind(config, dry_run):
    game = bpy.data.objects.get(config['game'])
    ctrl = bpy.data.objects.get(config['ctrl'])
    if game is None:
        raise SystemExit('no game armature %r' % config['game'])
    if ctrl is None:
        raise SystemExit('no control rig %r -- run build_metarig.py --generate first'
                         % config['ctrl'])

    org = {b.name[len(ORG_PREFIX):] for b in ctrl.data.bones if b.name.startswith(ORG_PREFIX)}
    game_names = [b.name for b in game.data.bones]

    targets = [n for n in game_names if bindable(n) and n in org]
    skipped_rule = [n for n in game_names if not bindable(n)]
    missing = [n for n in game_names if bindable(n) and n not in org]

    print('game bones: %d' % len(game_names))
    print('  bound to ORG-: %d' % len(targets))
    print('  deliberately not bound (%d): %s' % (len(skipped_rule), ', '.join(sorted(skipped_rule))))
    if missing:
        print('  NO ORG- COUNTERPART (%d): %s' % (len(missing), ', '.join(sorted(missing))))

    print('\npistons: %d aim constraints' % len(config['pistons']))
    for bone, target in config['pistons']:
        print('   %-18s Damped Track -> %s' % (bone, target))

    if dry_run:
        print('\nDRY RUN -- nothing written. Re-run with --save.')
        return None

    removed = clear(game)
    if removed:
        print('\ncleared %d existing %s constraints' % (removed, CTRL_TAG))

    if config['switch'] not in ctrl:
        ctrl[config['switch']] = 1.0

    for name in targets:
        pose_bone = game.pose.bones[name]
        constraint = pose_bone.constraints.new('COPY_TRANSFORMS')
        constraint.name = CTRL_TAG + 'bind'
        constraint.target = ctrl
        constraint.subtarget = ORG_PREFIX + name
        drive_influence(game, pose_bone, constraint, ctrl, config['switch'])

    for bone, target in config['pistons']:
        pose_bone = game.pose.bones.get(bone)
        if pose_bone is None:
            print('   WARNING: no bone %r' % bone)
            continue
        constraint = pose_bone.constraints.new('DAMPED_TRACK')
        constraint.name = CTRL_TAG + 'piston_aim'
        # Aim at the CONTROL rig's copy of the other piston, never at the game
        # bone itself: two game pistons tracking each other is a dependency
        # cycle, which Blender resolves arbitrarily and which corrupted the
        # exported bind pose (one shaft came out 349 degrees off).
        constraint.target = ctrl
        constraint.subtarget = ORG_PREFIX + target
        constraint.track_axis = 'TRACK_Y'
        constraint.head_tail = 0.0
        drive_influence(game, pose_bone, constraint, ctrl, config['switch'])

    print('\nbound %d bones + %d piston aims, all influence driven by %s["%s"]'
          % (len(targets), len(config['pistons']), ctrl.name, config['switch']))
    return game


def verify(config):
    """Prove the binding does something, and that the switch undoes it.

    Both halves matter. Checking only that the rig matches the stance at rest
    would pass even if nothing were wired up at all -- the control rig resolves
    to the stance when it is itself at rest, so that comparison is free. So we
    pose a control, require the game rig to MOVE, then flip the switch and
    require it to come back.

    Setting a custom property from Python does not re-evaluate the drivers that
    read it; the depsgraph has to be tagged explicitly or every reading here is
    stale (which is exactly how an earlier version of this check passed while
    the switch did nothing).
    """
    import math

    game = bpy.data.objects[config['game']]
    ctrl = bpy.data.objects[config['ctrl']]
    probes = ['digiAnkle.L', 'digiShin.L', 'Chest', 'Tail.006', 'pack_hand.R']

    def set_switch(value):
        ctrl[config['switch']] = float(value)
        ctrl.update_tag()
        game.update_tag()
        bpy.context.view_layer.update()
        bpy.context.evaluated_depsgraph_get().update()

    def sample():
        bpy.context.view_layer.update()
        return {n: game.pose.bones[n].head.copy() for n in probes}

    set_switch(1)
    stance = sample()

    control = ctrl.pose.bones['digiAnkle_ik.L']
    original = control.matrix_basis.copy()
    matrix = control.matrix.copy()
    matrix.translation = matrix.translation + Vector((0.0, -0.8, 0.9))
    control.matrix = matrix
    posed = sample()

    moved = max((posed[n] - stance[n]).length for n in probes)
    print('\nbinding check (control rig ON, foot IK displaced):')
    for name in probes:
        print('   %-14s %-24s -> %-24s moved %.4f'
              % (name, tuple(round(v, 3) for v in stance[name]),
                 tuple(round(v, 3) for v in posed[name]), (posed[name] - stance[name]).length))
    print('   %s the game rig follows the controls (max %.4f)'
          % ('OK  ' if moved > 1e-3 else 'FAIL', moved))

    shaft = game.pose.bones['piston_shaft.L']
    sleeve = game.pose.bones['piston_sleeve.L']
    aim_error = math.degrees((sleeve.head - shaft.head).normalized()
                             .angle((shaft.tail - shaft.head).normalized()))
    print('   %s pistons stay aimed while posed (%.4f deg off)'
          % ('OK  ' if aim_error < 0.5 else 'FAIL', aim_error))

    set_switch(0)
    released = sample()
    drift = max((released[n] - stance[n]).length for n in probes)
    print('   %s use_ctrl_rig = 0 releases the rig back to the stance (max %.6f)'
          % ('OK  ' if drift < 1e-3 else 'FAIL', drift))

    control.matrix_basis = original
    set_switch(1)
    return moved > 1e-3 and aim_error < 0.5 and drift < 1e-3


def main():
    parser = argparse.ArgumentParser(description='Bind the game rig to the control rig.')
    parser.add_argument('--character', default='ncho', choices=sorted(CHARACTERS))
    parser.add_argument('--save', action='store_true', help='write the .blend (default: dry run)')
    args = parser.parse_args(script_args())

    config = CHARACTERS[args.character]
    if bind(config, dry_run=not args.save) is None:
        return
    if not verify(config):
        raise SystemExit('verification FAILED -- not saving')
    bpy.ops.wm.save_mainfile()
    print('\nsaved %s' % bpy.data.filepath)


if __name__ == '__main__':
    main()
