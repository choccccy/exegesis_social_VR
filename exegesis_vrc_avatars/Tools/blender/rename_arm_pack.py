"""Rename ncho's backpack-arm bones from the `.001` suffix to a `pack_` prefix.

    blender --background source/ncho/ncho.blend \
        --python Tools/blender/rename_arm_pack.py -- [--save]

DRY RUN BY DEFAULT.

WHY THIS IS NOT A TIDY-UP
-------------------------
Unity derives a model sub-object's local file ID from its NAME, and the scene
references ncho.fbx sub-objects 1611 times across 140 distinct objects -- five
prefab instances, plus m_CorrespondingSourceObject on every instantiated
GameObject and Transform that carries an added component. The PhysBone setups
under "Extra Arm Dynamics" are exactly that. Renaming a bone changes its file
ID, and every reference to it goes missing with no error at all.

So this is one half of a two-part change:
  1. Tools/unity-repair/dump_fbx_ids.ps1  BEFORE the rename  (cannot be redone later)
  2. this script, then export_avatar.py
  3. dump_fbx_ids.ps1 again
  4. Tools/unity-repair/repair_refs.py to re-point the scene

The naming mirrors obi-me's existing `minor_*` convention for its second arm
pair. `arm_pack_root` keeps its name: it is already descriptive, and leaving it
alone keeps one stable anchor in the hierarchy.

See docs/rigging.md.
"""

import argparse
import sys

import bpy

ARMATURE = 'Armature'
SUFFIX = '.001'
PREFIX = 'pack_'

# The one bone under arm_pack_root that keeps its name.
KEEP = {'arm_pack_root'}


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def new_name(old):
    """upper_arm.L.001 -> pack_upper_arm.L,  f_index.01.L.001 -> pack_f_index.01.L"""
    return PREFIX + old[:-len(SUFFIX)]


def build_table(armature):
    """Only bones that are actually descendants of arm_pack_root, so a stray
    `.001` elsewhere in the rig can never be swept up by accident."""
    root = armature.data.bones.get('arm_pack_root')
    if root is None:
        raise SystemExit('arm_pack_root not found -- is this ncho?')

    table = {}
    for bone in [root] + list(root.children_recursive):
        if bone.name in KEEP:
            continue
        if not bone.name.endswith(SUFFIX):
            print('  WARNING: %s is under arm_pack_root but has no %s suffix; leaving it'
                  % (bone.name, SUFFIX))
            continue
        table[bone.name] = new_name(bone.name)

    existing = {b.name for b in armature.data.bones}
    collisions = sorted(n for n in table.values() if n in existing)
    if collisions:
        raise SystemExit('rename would collide with existing bones: %s' % ', '.join(collisions))
    if len(set(table.values())) != len(table):
        raise SystemExit('rename table is not one-to-one')

    stray = sorted(b.name for b in armature.data.bones
                   if b.name.endswith(SUFFIX) and b.name not in table)
    if stray:
        print('  note: %d bone(s) end in %s but are NOT under arm_pack_root, and are left '
              'alone: %s' % (len(stray), SUFFIX, ', '.join(stray)))
    return table


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--save', action='store_true', help='write the .blend (default: dry run)')
    args = parser.parse_args(script_args())

    armature = bpy.data.objects.get(ARMATURE)
    if armature is None or armature.type != 'ARMATURE':
        raise SystemExit('no armature named %r' % ARMATURE)

    table = build_table(armature)
    print('%s %d bone(s)\n' % ('RENAMING' if args.save else 'DRY RUN:', len(table)))
    for old in sorted(table):
        print('  %-24s -> %s' % (old, table[old]))

    # Vertex groups must follow the bones or the skin silently unbinds. Blender's
    # bone-rename does this for us; we verify rather than assume.
    skinned = [o for o in bpy.data.objects
               if o.type == 'MESH' and any(m.type == 'ARMATURE' and m.object == armature
                                           for m in o.modifiers)]
    print('\nskinned meshes that must follow: %s' % ', '.join(o.name for o in skinned))
    for obj in skinned:
        affected = sorted(g.name for g in obj.vertex_groups if g.name in table)
        print('  %s: %d matching vertex group(s)' % (obj.name, len(affected)))

    if not args.save:
        print('\nDRY RUN -- nothing written. Re-run with --save to apply.')
        return

    for old in sorted(table):
        armature.data.bones[old].name = table[old]

    problems = []
    bones_now = {b.name for b in armature.data.bones}
    for old, new in table.items():
        if old in bones_now:
            problems.append('bone %s was not renamed' % old)
        if new not in bones_now:
            problems.append('bone %s does not exist after rename' % new)
    for obj in skinned:
        groups = {g.name for g in obj.vertex_groups}
        for old, new in table.items():
            if old in groups:
                problems.append('%s vertex group %s did not follow the bone' % (obj.name, old))
    if problems:
        print('\nRENAME INCOMPLETE, not saving:')
        for problem in problems:
            print('  - %s' % problem)
        raise SystemExit(1)

    print('\nverified: %d bones renamed, vertex groups followed on %s'
          % (len(table), ', '.join(o.name for o in skinned)))
    bpy.ops.wm.save_mainfile()
    print('saved %s' % bpy.data.filepath)


if __name__ == '__main__':
    main()
