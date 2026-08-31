"""Phase 0 housekeeping on the avatar source blends. Run through Blender.

    blender --background source/ncho/ncho.blend \
        --python Tools/blender/housekeeping.py -- --character ncho [--save]

DRY RUN BY DEFAULT. The .blend sources are not in git, so nothing is written
without --save. Back the file up before you pass it.

Note: run this WITHOUT --factory-startup if you want the file's own
preferences; the operations here don't depend on any add-on either way.

Tasks (each opt-in, --all runs the safe set):

  --stale-groups   drop vertex groups that name no bone in the armature.
                   ncho's Props carries 50 of obi-me's bone names and obi-me's
                   Body carries 24 of ncho's -- cross-contamination from
                   copying meshes between the two characters. A group naming
                   no bone contributes nothing to the FBX (Blender only
                   exports groups that match a bone), so this cannot change
                   the export; check_rig_contract.py proves it.

  --link-orphans   link objects that are in no collection at all into a "wip"
                   collection. obi-me's arms_temp is invisible in the Outliner
                   for exactly this reason -- no collection means no view
                   layer. The collection is created hidden so it doesn't
                   clutter the viewport, and it is outside the export scope.

  --fix-connect    normalise use_connect asymmetries between L and R. This
                   moves no geometry: every bone fixed here already sits
                   exactly where the connection would put it.

  --mirror-hand-tail   ncho only, and NOT part of --all. hand.R's tail sits at
                   y=0.14 instead of hand.L's 0.15, because f_middle.01.R was
                   connected to it. This is a real ~1.5 degree change to
                   hand.R's rest orientation, and it re-expresses all 15 finger
                   descendants in the new parent space. Run it on its own so
                   the diff is reviewable.
"""

import argparse
import sys

import bpy

# Vertex groups that are modelling selections, not bones. Never delete these.
MODELLING_GROUPS = {'panels', 'tanks', 'insides', 'socket_balls', 'core', 'Group'}

WIP_COLLECTION = 'wip'

CHARACTERS = {
    'ncho': {
        'armature': 'Armature',
        'connect_fixes': {
            # (bone, use_connect) -- match the L side, which is the clean one.
            'f_middle.01.R': False,
        },
        'hand_tail_mirror': ('hand.R', 'hand.L'),
    },
    'obi-me': {
        'armature': 'Armature',
        'connect_fixes': {
            'f_middle.01.R': False,
            # head already sits exactly on big_manipulator.04.R's tail
            'big_manipulator.05.R': True,
        },
        'hand_tail_mirror': None,
    },
}


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def bone_names():
    names = set()
    for armature in bpy.data.armatures:
        names |= {bone.name for bone in armature.bones}
    return names


def group_weights(obj):
    """Total weight per vertex group, so a delete can report what it removes."""
    totals = {group.name: 0.0 for group in obj.vertex_groups}
    index_to_name = {group.index: group.name for group in obj.vertex_groups}
    for vertex in obj.data.vertices:
        for entry in vertex.groups:
            name = index_to_name.get(entry.group)
            if name is not None:
                totals[name] += entry.weight
    return totals


def task_stale_groups(apply_changes):
    bones = bone_names()
    changed = False
    for obj in bpy.data.objects:
        if obj.type != 'MESH' or not obj.vertex_groups:
            continue
        totals = group_weights(obj)
        stale = sorted(g.name for g in obj.vertex_groups
                       if g.name not in bones and g.name not in MODELLING_GROUPS)
        if not stale:
            print('  %s: no stale groups' % obj.name)
            continue
        carrying = [(n, totals[n]) for n in stale if totals[n] > 1e-4]
        print('  %s: %d stale group(s) name no bone' % (obj.name, len(stale)))
        if carrying:
            # These are already dead in the FBX -- Blender only exports groups
            # that match a bone -- but say so out loud rather than quietly
            # discarding weights.
            print('    %d of them still carry weight, and that weight is already'
                  ' dropped at export:' % len(carrying))
            for name, weight in carrying:
                print('      %-28s %.1f' % (name, weight))
        print('    %s' % ', '.join(stale))
        if apply_changes:
            for name in stale:
                obj.vertex_groups.remove(obj.vertex_groups[name])
            changed = True
    return changed


def task_link_orphans(apply_changes):
    orphans = [o for o in bpy.data.objects if not o.users_collection]
    if not orphans:
        print('  no orphaned objects')
        return False
    for obj in orphans:
        print('  orphan: %s (%s, scale=%s) -> collection %r'
              % (obj.name, obj.type, tuple(round(v, 3) for v in obj.scale), WIP_COLLECTION))
    if not apply_changes:
        return False

    collection = bpy.data.collections.get(WIP_COLLECTION)
    if collection is None:
        collection = bpy.data.collections.new(WIP_COLLECTION)
        bpy.context.scene.collection.children.link(collection)
    for obj in orphans:
        collection.objects.link(obj)

    # Visible in the Outliner, but the eye is off so a 2x-scale WIP mesh does
    # not sit on top of the character in the viewport.
    for layer in bpy.context.view_layer.layer_collection.children:
        if layer.collection is collection:
            layer.hide_viewport = True
    return True


def _edit_bones(armature_obj):
    if armature_obj.hide_get():
        armature_obj.hide_set(False)
    armature_obj.hide_viewport = False
    bpy.context.view_layer.objects.active = armature_obj
    bpy.ops.object.mode_set(mode='EDIT')
    return armature_obj.data.edit_bones


def task_fix_connect(config, apply_changes):
    armature_obj = bpy.data.objects[config['armature']]
    wanted = config['connect_fixes']
    for name, want in wanted.items():
        bone = armature_obj.data.bones.get(name)
        if bone is None:
            print('  %s: NOT FOUND' % name)
            continue
        print('  %s: use_connect %s -> %s%s'
              % (name, bone.use_connect, want,
                 '' if bone.use_connect != want else '  (already correct)'))
    if not apply_changes:
        return False

    edit_bones = _edit_bones(armature_obj)
    changed = False
    for name, want in wanted.items():
        bone = edit_bones.get(name)
        if bone is None or bone.use_connect == want:
            continue
        head_before = bone.head.copy()
        bone.use_connect = want
        if (bone.head - head_before).length > 1e-6:
            print('    NOTE %s head moved %s -> %s' % (name, head_before, bone.head))
        changed = True
    bpy.ops.object.mode_set(mode='OBJECT')
    return changed


def task_mirror_hand_tail(config, apply_changes):
    pair = config['hand_tail_mirror']
    if pair is None:
        print('  not applicable to this character')
        return False
    target_name, source_name = pair
    armature_obj = bpy.data.objects[config['armature']]
    bones = armature_obj.data.bones
    target, source = bones.get(target_name), bones.get(source_name)
    if target is None or source is None:
        print('  %s / %s not found' % (target_name, source_name))
        return False

    mirrored = source.tail_local.copy()
    mirrored.x = -mirrored.x
    print('  %s tail %s' % (target_name, tuple(round(v, 4) for v in target.tail_local)))
    print('  %s tail %s -> mirrored target %s'
          % (source_name, tuple(round(v, 4) for v in source.tail_local),
             tuple(round(v, 4) for v in mirrored)))
    delta = (target.tail_local - mirrored).length
    print('  asymmetry: %.5f' % delta)
    if delta <= 1e-6:
        print('  already symmetric')
        return False
    print('  %d child bones will be re-expressed in the new parent space'
          % len(target.children_recursive))
    if not apply_changes:
        return False

    edit_bones = _edit_bones(armature_obj)
    edit_bones[target_name].tail = mirrored
    bpy.ops.object.mode_set(mode='OBJECT')
    return True


def main():
    parser = argparse.ArgumentParser(description='Phase 0 housekeeping on an avatar blend.')
    parser.add_argument('--character', required=True, choices=sorted(CHARACTERS))
    parser.add_argument('--save', action='store_true', help='write the .blend (default: dry run)')
    parser.add_argument('--all', action='store_true',
                        help='run the safe set: stale-groups, link-orphans, fix-connect')
    parser.add_argument('--stale-groups', action='store_true')
    parser.add_argument('--link-orphans', action='store_true')
    parser.add_argument('--fix-connect', action='store_true')
    parser.add_argument('--mirror-hand-tail', action='store_true')
    args = parser.parse_args(script_args())

    config = CHARACTERS[args.character]
    tasks = []
    if args.all or args.stale_groups:
        tasks.append(('stale vertex groups', lambda a: task_stale_groups(a)))
    if args.all or args.link_orphans:
        tasks.append(('orphaned objects', lambda a: task_link_orphans(a)))
    if args.all or args.fix_connect:
        tasks.append(('use_connect asymmetries', lambda a: task_fix_connect(config, a)))
    if args.mirror_hand_tail:
        tasks.append(('hand tail mirror', lambda a: task_mirror_hand_tail(config, a)))
    if not tasks:
        parser.error('nothing to do -- pass --all or an individual task flag')

    print('%s %s (%s)' % ('APPLYING' if args.save else 'DRY RUN:',
                          args.character, bpy.data.filepath))
    changed = False
    for label, task in tasks:
        print('\n== %s ==' % label)
        changed |= bool(task(args.save))

    if args.save and changed:
        bpy.ops.wm.save_mainfile()
        print('\nsaved %s' % bpy.data.filepath)
    elif args.save:
        print('\nnothing changed; not saving')
    else:
        print('\nDRY RUN -- nothing written. Re-run with --save to apply.')


if __name__ == '__main__':
    main()
