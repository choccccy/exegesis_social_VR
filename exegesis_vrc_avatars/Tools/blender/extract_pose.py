"""Read a hand-made pose off a game armature and write it out as JSON.

    blender --background <file.blend> \
        --python Tools/blender/extract_pose.py -- --armature Armature --out pose.json

READ-ONLY: never saves the .blend it is pointed at. Safe to run on a render
file you have work in.

Records each bone's WORLD matrix, which is the thing a control rig has to
reproduce -- local values depend on rest orientation and parenting, and those
differ between the game rig and the control rig.

The CTRL_ binding constraints are muted while sampling. Without that you would
record whatever the control rig is currently doing instead of the pose the
animator actually made: a library override inherits those constraints, so a
hand-posed file that links an already-rigged character resolves to the control
rig's rest stance even though the hand pose is still stored on the bones.
"""

import argparse
import json
import os
import sys

import bpy

CTRL_TAG = 'CTRL_'


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def main():
    parser = argparse.ArgumentParser(description='Extract a pose as world matrices.')
    parser.add_argument('--armature', default='Armature')
    parser.add_argument('--out', required=True)
    parser.add_argument('--keep-constraints', action='store_true',
                        help='sample WITH the binding constraints live (diagnostic)')
    args = parser.parse_args(script_args())

    candidates = [o for o in bpy.data.objects
                  if o.type == 'ARMATURE' and o.name == args.armature]
    if not candidates:
        raise SystemExit('no armature named %r (have: %s)'
                         % (args.armature,
                            ', '.join(o.name for o in bpy.data.objects if o.type == 'ARMATURE')))
    # Prefer the override/local copy -- that is the one carrying the pose.
    armature = next((o for o in candidates if o.override_library or not o.library), candidates[0])

    muted = 0
    if not args.keep_constraints:
        for pose_bone in armature.pose.bones:
            for constraint in pose_bone.constraints:
                if constraint.name.startswith(CTRL_TAG) and not constraint.mute:
                    constraint.mute = True
                    muted += 1
    bpy.context.view_layer.update()

    posed = []
    matrices = {}
    for pose_bone in armature.pose.bones:
        matrices[pose_bone.name] = [list(row) for row in
                                    (armature.matrix_world @ pose_bone.matrix)]
        basis = pose_bone.matrix_basis
        if any(abs(basis[r][c] - (1.0 if r == c else 0.0)) > 1e-5
               for r in range(4) for c in range(4)):
            posed.append(pose_bone.name)

    payload = {
        'source': bpy.data.filepath,
        'armature': armature.name,
        'muted_binding_constraints': muted,
        'hand_posed_bones': sorted(posed),
        'world_matrices': matrices,
    }
    directory = os.path.dirname(os.path.abspath(args.out))
    if directory:
        os.makedirs(directory, exist_ok=True)
    with open(args.out, 'w', encoding='utf-8') as fh:
        json.dump(payload, fh, indent=1, sort_keys=True)
        fh.write('\n')

    print('armature %r (%s)'
          % (armature.name, 'override' if armature.override_library else 'local'))
    print('  muted %d binding constraints while sampling' % muted)
    print('  %d bones sampled, %d carry a hand-made pose' % (len(matrices), len(posed)))
    print('  wrote %s' % args.out)


if __name__ == '__main__':
    main()
