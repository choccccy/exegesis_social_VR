"""Deterministic FBX export for the avatars. Run through Blender, headless.

    blender --background --factory-startup source/ncho/ncho.blend \
        --python Tools/blender/export_avatar.py -- --character ncho

Every setting is pinned here on purpose. The settings that produced the
committed FBX were never recorded anywhere, so "which checkboxes did I have
set last time" used to be part of the failure surface; it no longer is.
Verify any change with Tools/blender/compare_fbx.py, which is stricter than
the contract checker (it compares bone transforms too).

THE BIND POSE IS A POSE, NOT THE REST POSE
------------------------------------------
ncho ships with a 21-bone stance baked into the export: the digitigrade legs
(digiShin +68.9, digiAnkle -78.4, digiFoot +15.4), the zero-weight planti
proxy chain posed to match, arms dropped 12, wings folded, hips lowered. The
committed FBX was exported in POSE position with that stance live, and it is
the avatar's bind pose in Unity.

That stance used to exist *only* as whatever pose happened to be in the .blend
at export time. It now lives in golden/<character>_export_pose.json and this
script restores it before every export, so the export no longer depends on the
file's current pose. Phase 1's control rig makes that mandatory: posing the
game armature is exactly what a control rig does.

    --dump-pose    capture the file's current pose into the golden
    --assert-pose  fail if the file's pose has drifted from the golden
    --rest         export from the rest pose (diagnostic; NOT the shipping state)

Source blends live at the *git root* (../source), not inside the Unity project.
"""

import argparse
import json
import os
import sys

import bpy
from mathutils import Matrix

# Tools/blender/ -> exegesis_vrc_avatars -> git root
UNITY_PROJECT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
GIT_ROOT = os.path.dirname(UNITY_PROJECT)
GOLDEN_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'golden')

POSE_TOLERANCE = 1e-5

CHARACTERS = {
    'ncho': {
        'blend': 'source/ncho/ncho.blend',
        'collection': 'ncho',
        'armature': 'Armature',
        'out': 'exegesis_vrc_avatars/Assets/_exegesis/ncho/ncho.fbx',
        'ctrl_rig': 'ncho_ctrl',
    },
    'obi-me': {
        'blend': 'source/obi-me/obi-me.blend',
        'collection': 'obi-me',
        'armature': 'Armature',
        'out': 'exegesis_vrc_avatars/Assets/_exegesis/obi-me/obi-me.fbx',
        'ctrl_rig': 'obi_me_ctrl',
    },
}

# Everything here is Blender's own default except the three overrides below.
# Keeping the rest at default is deliberate: it is what produced the committed
# FBX, verified byte-for-byte by compare_fbx.py.
#
#   apply_scale_options='FBX_SCALE_ALL'
#       puts the 100x metric conversion in the FBX UnitScaleFactor. The default
#       'FBX_SCALE_NONE' instead bakes scale 100 onto every root object.
#   add_leaf_bones=False
#       the default True injects an _end leaf under every bone, changing the
#       skeleton Unity sees.
#   use_selection=True
#       scopes the export to the character collection so it cannot depend on
#       what happens to be visible.
#
# Two defaults we keep but should be aware of:
#   use_armature_deform_only=False - True re-parents survivors to their nearest
#       deform ancestor, silently rewriting the Unity transform paths .anim
#       clips bind to. Never turn this on.
#   bake_anim=True - harmless today because neither blend has an action, but it
#       WILL start writing animation into the export once Phase 1 creates one.
#       check_rig_contract.py fails if animation ever appears in the FBX.
EXPORT_SETTINGS = {
    'use_selection': True,
    'add_leaf_bones': False,
    'apply_scale_options': 'FBX_SCALE_ALL',
}


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def pose_golden_path(character):
    return os.path.join(GOLDEN_DIR, '%s_export_pose.json' % character.replace('-', '_'))


def get_armature(config):
    armature = bpy.data.objects.get(config['armature'])
    if armature is None or armature.type != 'ARMATURE':
        raise SystemExit('armature %r not found in %s' % (config['armature'], bpy.data.filepath))
    return armature


def _is_identity(matrix):
    return all(abs(matrix[r][c] - (1.0 if r == c else 0.0)) <= POSE_TOLERANCE
               for r in range(4) for c in range(4))


def capture_pose(armature):
    """Non-identity pose-bone basis matrices, as plain nested lists."""
    pose = {}
    for bone in armature.pose.bones:
        matrix = bone.matrix_basis
        if not _is_identity(matrix):
            pose[bone.name] = [list(row) for row in matrix]
    return pose


def dump_pose(character, armature):
    pose = capture_pose(armature)
    os.makedirs(GOLDEN_DIR, exist_ok=True)
    with open(pose_golden_path(character), 'w', encoding='utf-8') as fh:
        json.dump({'armature': armature.name, 'pose': pose}, fh, indent=1, sort_keys=True)
        fh.write('\n')
    print('captured %d posed bones -> %s' % (len(pose), pose_golden_path(character)))
    for name in sorted(pose):
        print('    %s' % name)


def load_pose_golden(character):
    path = pose_golden_path(character)
    if not os.path.exists(path):
        return None
    with open(path, encoding='utf-8') as fh:
        return json.load(fh)['pose']


def compare_pose(character, armature):
    """Return a list of human-readable drifts from the golden pose."""
    want = load_pose_golden(character)
    if want is None:
        return ['no pose golden at %s -- run --dump-pose' % pose_golden_path(character)]
    have = capture_pose(armature)
    drifts = []
    for name in sorted(set(want) | set(have)):
        if name not in have:
            drifts.append('%s is no longer posed' % name)
        elif name not in want:
            drifts.append('%s is posed but not in the golden' % name)
        else:
            worst = max(abs(have[name][r][c] - want[name][r][c])
                        for r in range(4) for c in range(4))
            if worst > POSE_TOLERANCE:
                drifts.append('%s differs by %.6g' % (name, worst))
    return drifts


def restore_pose(character, armature):
    """Force the armature to the golden export stance. Returns a note."""
    want = load_pose_golden(character)
    if want is None:
        return 'no pose golden -- exporting the file as posed (run --dump-pose to pin it)'
    identity = Matrix.Identity(4)
    touched = 0
    for bone in armature.pose.bones:
        target = Matrix(want[bone.name]) if bone.name in want else identity
        # Only write bones that have actually drifted. The golden stores
        # decomposed matrices, so re-applying one to a bone that already
        # matches would round-trip it through float32 and shift the exported
        # rotation by ~1e-5 degrees for no reason.
        current = bone.matrix_basis
        if all(abs(current[r][c] - target[r][c]) <= POSE_TOLERANCE
               for r in range(4) for c in range(4)):
            continue
        bone.matrix_basis = target
        touched += 1
    bpy.context.view_layer.update()
    if touched:
        return 'export pose restored from golden (%d of %d bones corrected)' % (touched, len(want))
    return 'pose already matches the golden export stance (%d bones)' % len(want)


def prepare(config, character, rest=False):
    """Put the file in its canonical export state and select the export scope."""
    notes = []

    # Phase 1 forward-compatibility: the control rig drives the game armature
    # through constraints whose influence is driven by this one property.
    ctrl = bpy.data.objects.get(config['ctrl_rig'])
    if ctrl is not None and 'use_ctrl_rig' in ctrl:
        ctrl['use_ctrl_rig'] = 0.0
        notes.append('control rig disabled (use_ctrl_rig = 0)')
        for obj in bpy.data.objects:
            obj.update_tag()
        bpy.context.view_layer.update()

    armature = get_armature(config)
    if rest:
        armature.data.pose_position = 'REST'
        notes.append('REST position (diagnostic export, not the shipping state)')
    else:
        armature.data.pose_position = 'POSE'
        notes.append(restore_pose(character, armature))
    bpy.context.view_layer.update()

    collection = bpy.data.collections.get(config['collection'])
    if collection is None:
        raise SystemExit('export collection %r not found in %s'
                         % (config['collection'], bpy.data.filepath))

    for obj in bpy.data.objects:
        obj.select_set(False) if obj.name in bpy.context.view_layer.objects else None

    exported, unhidden = [], []
    for obj in collection.objects:
        if obj.type not in ('ARMATURE', 'MESH'):
            continue
        # Props ships viewport-hidden; select_set() is a silent no-op on a
        # hidden object, which would drop it from the FBX without any error.
        if obj.hide_get():
            obj.hide_set(False)
            unhidden.append(obj.name)
        obj.hide_viewport = False
        obj.select_set(True)
        exported.append(obj.name)

    if unhidden:
        notes.append('temporarily unhidden for export: %s' % ', '.join(sorted(unhidden)))
    if not exported:
        raise SystemExit('nothing to export from collection %r' % config['collection'])
    bpy.context.view_layer.objects.active = bpy.data.objects[exported[0]]
    notes.append('exporting %d objects: %s' % (len(exported), ', '.join(sorted(exported))))
    return notes


def main():
    parser = argparse.ArgumentParser(description='Export an avatar to FBX.')
    parser.add_argument('--character', required=True, choices=sorted(CHARACTERS))
    parser.add_argument('--out', help='override the output path (absolute, or relative to '
                                      'the git root). Use for dry runs.')
    parser.add_argument('--rest', action='store_true',
                        help='export from the rest pose (diagnostic only)')
    parser.add_argument('--dump-pose', action='store_true',
                        help='capture this file\'s pose into the golden and exit')
    parser.add_argument('--assert-pose', action='store_true',
                        help='fail if the file\'s pose has drifted from the golden')
    args = parser.parse_args(script_args())

    config = CHARACTERS[args.character]

    if args.dump_pose:
        dump_pose(args.character, get_armature(config))
        return

    if args.assert_pose:
        drifts = compare_pose(args.character, get_armature(config))
        if drifts:
            print('POSE DRIFT in %s:' % bpy.data.filepath)
            for drift in drifts:
                print('  - %s' % drift)
            raise SystemExit(1)
        print('  pose matches the golden export stance')

    out = args.out or config['out']
    if not os.path.isabs(out):
        out = os.path.join(GIT_ROOT, out)
    out = os.path.abspath(out)

    for note in prepare(config, args.character, rest=args.rest):
        print('  %s' % note)

    os.makedirs(os.path.dirname(out), exist_ok=True)
    bpy.ops.export_scene.fbx(filepath=out, **EXPORT_SETTINGS)
    print('exported %s -> %s' % (args.character, out))


if __name__ == '__main__':
    main()
