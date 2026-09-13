"""Re-link a render file onto the character's `<name>_all` collection, overridden.

    blender --background <render-file>.blend \
        --python Tools/blender/relink_character.py -- --character ncho [--save]

DRY RUN BY DEFAULT.

A file that links only the export collection (`ncho`) gets the control rig as a
read-only indirect dependency: the `CTRL_` bindings target the linked rig, and
nothing in that file can pose it. Linking the parent collection instead puts the
game rig and the control rig in ONE override hierarchy, and Blender remaps the
bindings onto the override itself -- which is the only way they persist. See
docs/rigging.md > Linking ncho into a render file.

This REPLACES the existing link, so the hand pose stored on the old override is
discarded. Extract it first and put it back through the control rig afterwards:

    blender --background <render-file>.blend \
        --python Tools/blender/extract_pose.py -- --out pose.json
    blender --background <render-file>.blend \
        --python Tools/blender/relink_character.py -- --character ncho --save
    blender --background <render-file>.blend \
        --python Tools/blender/apply_pose.py -- --pose pose.json --save
"""

import argparse
import os
import sys

import bpy

CHARACTERS = {
    'ncho': {'blend': 'source/ncho/ncho.blend', 'old': 'ncho', 'new': 'ncho_all',
             'exclude': ['ncho_rig_widgets'],
             'hide': ['ncho_metarig']},
}


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def repo_root():
    """The repo root, from this script's location."""
    here = os.path.dirname(os.path.abspath(__file__))
    return os.path.abspath(os.path.join(here, '..', '..', '..'))


def layer_collection(root, name):
    """Find a layer collection by name, depth-first."""
    if root.name == name:
        return root
    for child in root.children:
        found = layer_collection(child, name)
        if found is not None:
            return found
    return None


def find(collections, name, linked):
    for collection in collections:
        if collection.name == name and bool(collection.library) == linked:
            return collection
    return None


def snapshot_visibility(config):
    """How the outgoing override displayed and rendered.

    Re-linking rebuilds the override from the library, so any per-object
    visibility this shot had set goes back to the library's value --
    `orbital_insertion_01` kept `Props` out of its renders, and without this it
    would silently start rendering.
    """
    state = {}
    view_layer = bpy.context.view_layer
    objects = []
    for name in (config['old'], config['new']):
        override = find(bpy.data.collections, name, linked=False)
        if override is not None:
            objects.extend(override.objects)
            objects.extend(o for child in override.children for o in child.objects)
    if not objects:
        return state
    for obj in objects:
        eye = obj.hide_get() if obj.name in view_layer.objects else None
        state[obj.name] = (obj.hide_render, obj.hide_viewport, eye)
    return state


def restore_visibility(state):
    restored = []
    view_layer = bpy.context.view_layer
    for name, (hide_render, hide_viewport, eye) in state.items():
        obj = bpy.data.objects.get((name, None))
        if obj is None:
            continue
        changed = []
        if obj.hide_render != hide_render:
            obj.hide_render = hide_render
            changed.append('render')
        if obj.hide_viewport != hide_viewport:
            obj.hide_viewport = hide_viewport
            changed.append('viewport')
        if eye is not None and name in view_layer.objects and obj.hide_get() != eye:
            obj.hide_set(eye)
            changed.append('eye')
        if changed:
            restored.append('%s (%s)' % (name, '+'.join(changed)))
    return restored


def teardown(scene, config):
    """Drop any existing link, whether this file was migrated before or not.

    Both names have to be handled: a file that still links `ncho` the old way,
    AND one already on `ncho_all` being re-run. Missing the second leaves the
    previous linked collection in the scene and the character ends up in it
    twice.
    """
    removed = []
    for name in (config['old'], config['new']):
        override = find(bpy.data.collections, name, linked=False)
        if override is not None and override.override_library:
            override.override_library.destroy()
            removed.append('override collection %r' % name)
        linked = find(bpy.data.collections, name, linked=True)
        if linked is not None and linked.name in scene.collection.children:
            scene.collection.children.unlink(linked)
            removed.append('linked collection %r' % name)
    stem = os.path.basename(config['blend'])
    for obj in list(bpy.data.objects):
        reference = obj.override_library.reference if obj.override_library else None
        if reference and reference.library and stem in (reference.library.filepath or ''):
            bpy.data.objects.remove(obj)
            removed.append('leftover override object %r' % obj.name)
    return removed


def main():
    parser = argparse.ArgumentParser(description='Re-link a character as one override hierarchy.')
    parser.add_argument('--character', required=True, choices=sorted(CHARACTERS))
    parser.add_argument('--save', action='store_true')
    args = parser.parse_args(script_args())
    config = CHARACTERS[args.character]

    scene = bpy.context.scene
    library = os.path.join(repo_root(), config['blend'].replace('/', os.sep))
    if not os.path.exists(library):
        raise SystemExit('library not found: %s' % library)

    visibility = snapshot_visibility(config)
    print('remembered visibility for %d objects' % len(visibility))
    for note in teardown(scene, config):
        print('removed %s' % note)

    with bpy.data.libraries.load(library, link=True, relative=True) as (src, dst):
        if config['new'] not in src.collections:
            raise SystemExit('%r has no %r collection -- is it the restructured file?'
                             % (library, config['new']))
        dst.collections = [config['new']]
    linked = find(bpy.data.collections, config['new'], linked=True)
    scene.collection.children.link(linked)
    print('linked %r (%d child collections)' % (config['new'], len(linked.children)))

    override = linked.override_hierarchy_create(scene, bpy.context.view_layer,
                                                do_fully_editable=True)
    bpy.context.view_layer.update()
    print('overrode the hierarchy -> %r' % override.name)

    # The override is linked into the scene alongside the collection it was made
    # from, which leaves the character in the scene TWICE -- read-only originals
    # underneath the editable copies. The UI swaps them; doing this from Python
    # does not, so drop the linked one by hand.
    if linked.name in scene.collection.children:
        scene.collection.children.unlink(linked)
        print('unlinked the read-only %r so the character is not in the scene twice'
              % linked.name)

    # The 236 WGT- bone shapes are meshes. They are display-only in ncho.blend,
    # but a fresh view layer here would show AND render them.
    for name in config.get('exclude', ()):
        lc = layer_collection(bpy.context.view_layer.layer_collection, name)
        if lc is not None:
            lc.exclude = True
            print('excluded %r from the view layer (%d objects)' % (name, len(lc.collection.objects)))
    bpy.context.view_layer.update()

    for note in restore_visibility(visibility):
        print('restored visibility: %s' % note)
    # The metarig is never posed -- it sits in rest position looking exactly like
    # a T-posed skeleton laid over the character. It is useless in a render file
    # (editing it does nothing without regenerating the rig), so keep it out of
    # the way rather than have it read as "the rig is not following".
    for name in config.get('hide', ()):
        obj = bpy.data.objects.get((name, None))
        if obj is not None:
            obj.hide_render = True
            if obj.name in bpy.context.view_layer.objects:
                obj.hide_set(True)
            print('hid %r (rest-position metarig, not needed here)' % name)

    bpy.context.view_layer.update()

    game = bpy.data.objects.get(('Armature', None))
    ctrl = bpy.data.objects.get(('ncho_ctrl', None))
    if game is None or ctrl is None:
        raise SystemExit('expected an editable Armature and control rig after the override')
    bound = sum(1 for pose_bone in game.pose.bones for constraint in pose_bone.constraints
                if constraint.name.startswith('CTRL_') and constraint.target is ctrl)
    stranded = sum(1 for pose_bone in game.pose.bones for constraint in pose_bone.constraints
                   if constraint.name.startswith('CTRL_') and constraint.target
                   and constraint.target.library)
    print('bindings on the override: %d ; still on linked data: %d' % (bound, stranded))
    if stranded or not bound:
        raise SystemExit('the bindings did not remap -- refusing to save')

    meshes = [o.name for o in scene.objects if o.type == 'MESH']
    if len(meshes) != len(set(meshes)):
        raise SystemExit('duplicate meshes in the scene -- the linked collection is '
                         'still present alongside its override; refusing to save')
    print('scene holds %d meshes, %d armatures'
          % (len(meshes), sum(1 for o in scene.objects if o.type == 'ARMATURE')))

    if args.save:
        bpy.ops.wm.save_mainfile()
        print('\nsaved %s' % bpy.data.filepath)
        print('now put the pose back: apply_pose.py -- --pose <pose>.json --save')
    else:
        print('\nDRY RUN -- nothing written. Re-run with --save.')


if __name__ == '__main__':
    main()
