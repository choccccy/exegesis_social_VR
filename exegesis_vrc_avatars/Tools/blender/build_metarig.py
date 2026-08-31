"""Build the Rigify metarig for an avatar, from the game rig's POSED joints.

    blender --background source/ncho/ncho.blend \
        --python Tools/blender/build_metarig.py -- --character ncho [--generate] [--save]

DRY RUN BY DEFAULT (`source/` is not in git -- back the file up first).

WHY POSED, NOT REST
-------------------
Both leg chains are deliberately colinear in the rest pose because a straight
leg is easier to edit (docs/rigging.md, footgun 3b). Rigify infers the IK bend
plane and pole direction from metarig *rest* geometry, and a colinear chain
gives it no plane at all -- the knee direction would be undefined and the IK
would flip. So the metarig is built at the stance pose's world-space joints.

This changes nothing about the game rig: the binding is `Copy Transforms`,
which drives world matrices, so the game bone's own rest orientation does not
affect the result.

WHAT IS AND IS NOT IN THE METARIG
---------------------------------
The metarig mirrors the game hierarchy minus three groups:

  *_fix       the primary DEFORM bones. They carry the weight and must stay
              rigid children of their segment (docs/rigging.md, footgun 2).
              They follow by parenting; giving them controls would introduce
              exactly the shear they exist to prevent.
  planti*     zero weight, the humanoid proxy chain only. Not rigged; solved
              from the digi chain when baking back to Unity.
  planti*     (above) is the only chain fully absent.

The pistons ARE mirrored in, as basic.super_copy. They are never keyed --
bind_ctrl_rig.py aims the game pistons at these ORG- bones. Aiming the two game
pistons at each other directly would be a dependency cycle; the control rig has
no dependency on the game rig, so routing through it breaks the cycle.

Metarig bones are named EXACTLY like their game counterparts, so the binding
layer is `ORG-<name>` -> `<name>` with no lookup table to drift.

segments=1 throughout: the character deforms rigidly off the _fix stubs, and
the binding reads ORG- bones, so Rigify's twist subdivision and its mid-limb
tweak controls would drive DEF- bones that nothing follows. One segment keeps
every control in the rig one that actually does something.
"""

import argparse
import re
import sys

import addon_utils
import bpy

RIG_COLLECTION = 'ncho_rig'
WIDGET_COLLECTION = 'ncho_rig_widgets'
CTRL_RIG = 'ncho_ctrl'

EXCLUDE = (
    re.compile(r'_fix($|\.)'),         # primary deform stubs - must stay rigid
    re.compile(r'^planti'),            # zero-weight humanoid proxy
)

# game bone -> (rigify_type, params). Everything else is a plain chain member.
TYPES = {
    'Hips': ('spines.basic_spine', {}),
    'Neck': ('spines.super_head', {'connect_chain': True}),
    # connect_chain stays False: TailRoot's head is offset from Hips' tail, and
    # Rigify rejects a "connected" chain whose position is disjoint.
    'TailRoot': ('spines.basic_tail', {'connect_chain': False}),

    'thigh.L': ('limbs.rear_paw', {'segments': 1}),
    'thigh.R': ('limbs.rear_paw', {'segments': 1}),

    'shoulder.L': ('basic.super_copy', {}),
    'shoulder.R': ('basic.super_copy', {}),
    'upper_arm.L': ('limbs.arm', {'segments': 1}),
    'upper_arm.R': ('limbs.arm', {'segments': 1}),

    'arm_pack_root': ('basic.super_copy', {}),
    'pack_upper_arm.L': ('limbs.arm', {'segments': 1}),
    'pack_upper_arm.R': ('limbs.arm', {'segments': 1}),

    'EarRoot': ('basic.super_copy', {}),
    'ear_L': ('basic.super_copy', {}),
    'ear_R': ('basic.super_copy', {}),

    'wing_root': ('basic.super_copy', {}),
    'wing.L': ('basic.super_copy', {}),
    'wing.R': ('basic.super_copy', {}),

    'ab_wires_root': ('basic.super_copy', {}),
    'ab_wire_stretch.L': ('limbs.simple_tentacle', {}),
    'ab_wire_stretch.R': ('limbs.simple_tentacle', {}),

    # Aim targets for the game rig's piston Damped Tracks. Never keyed.
    'piston_shaft.L': ('basic.super_copy', {}),
    'piston_shaft.R': ('basic.super_copy', {}),
    'piston_sleeve.L': ('basic.super_copy', {}),
    'piston_sleeve.R': ('basic.super_copy', {}),
}

FINGER_START = re.compile(r'^(pack_)?(f_(index|middle|ring|pinky)|thumb)\.01\.[LR]$')

# name -> (ui_row, is_ik_primary). Rigify links a limb's FK/Tweak collections by
# the metarig bone's own collection; siblings are found by the "<base> (FK)" and
# "<base> (Tweak)" naming convention, wired explicitly in assign_collections().
# ui_row drives the Rig Layers panel; row 0 means "no button".
#
# The limb Tweak collections are deliberately absent. Rigify builds tweak
# controls for every limb, but they drive DEF- bones and the binding reads ORG-,
# so on this rig all 20 of them are INERT -- verified by moving each one and
# watching the game rig not budge. They are parked in a hidden collection rather
# than shown as controls that do nothing. Torso and tail tweaks DO work (those
# rig types route them through ORG-), so those keep their buttons.
INERT_TWEAKS = 'Tweak (inert)'

COLLECTIONS = [
    ('Torso', 1), ('Torso (Tweak)', 2),
    ('Head', 3),
    ('Tail', 4), ('Tail (Tweak)', 5),
    ('Fingers', 7), ('Fingers (Detail)', 8),
    ('Arm.L (IK)', 10), ('Arm.L (FK)', 11),
    ('Arm.R (IK)', 10), ('Arm.R (FK)', 11),
    ('Pack.L (IK)', 13), ('Pack.L (FK)', 14),
    ('Pack.R (IK)', 13), ('Pack.R (FK)', 14),
    ('Leg.L (IK)', 16), ('Leg.L (FK)', 17),
    ('Leg.R (IK)', 16), ('Leg.R (FK)', 17),
    ('Props', 19),
    ('Root', 20),
    (INERT_TWEAKS, 0),
]


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def included(name):
    return not any(pattern.search(name) for pattern in EXCLUDE)


def rig_type_for(name):
    if name in TYPES:
        return TYPES[name]
    if FINGER_START.match(name):
        return ('limbs.super_finger', {})
    return (None, {})


def collection_for(name):
    """Which metarig collection a bone belongs to. Limb roots must land in the
    limb's (IK) collection so Rigify can find its (FK)/(Tweak) siblings."""
    side = '.L' if name.endswith('.L') or name.endswith('_L') else (
        '.R' if name.endswith('.R') or name.endswith('_R') else None)

    if name in ('Hips', 'Spine', 'Chest'):
        return 'Torso'
    if name in ('Neck', 'Head'):
        return 'Head'
    if name == 'TailRoot' or name.startswith('Tail.'):
        return 'Tail'
    if FINGER_START.match(name) or re.match(r'^(pack_)?(f_\w+|thumb)\.0[23]\.[LR]$', name):
        return 'Fingers'
    if name.startswith('pack_') or name == 'arm_pack_root':
        return 'Pack%s (IK)' % (side or '.L')
    if re.match(r'^(shoulder|upper_arm|forearm|hand)\.[LR]$', name):
        return 'Arm%s (IK)' % side
    if re.match(r'^(thigh|digiShin|digiAnkle|digiFoot)\.[LR]$', name):
        return 'Leg%s (IK)' % side
    return 'Props'


def build(src, dry_run):
    src.data.pose_position = 'POSE'
    bpy.context.view_layer.update()

    names = [b.name for b in src.data.bones if included(b.name)]
    dropped = [b.name for b in src.data.bones if not included(b.name)]
    print('metarig will mirror %d of %d game bones' % (len(names), len(src.data.bones)))
    print('  excluded (%d): %s' % (len(dropped), ', '.join(sorted(dropped))))

    typed = {n: rig_type_for(n) for n in names}
    assigned = {n: t for n, (t, _) in typed.items() if t}
    print('\nrigify types (%d):' % len(assigned))
    for name in sorted(assigned):
        print('   %-22s %s' % (name, assigned[name]))
    if dry_run:
        print('\nDRY RUN -- nothing written. Re-run with --save.')
        return None

    old = bpy.data.objects.get('ncho_metarig')
    if old:
        bpy.data.objects.remove(old, do_unlink=True)

    meta_data = bpy.data.armatures.new('ncho_metarig')
    meta = bpy.data.objects.new('ncho_metarig', meta_data)
    rig_coll = bpy.data.collections.get(RIG_COLLECTION)
    if rig_coll is None:
        rig_coll = bpy.data.collections.new(RIG_COLLECTION)
        bpy.context.scene.collection.children.link(rig_coll)
    rig_coll.objects.link(meta)
    meta.matrix_world = src.matrix_world.copy()

    bpy.context.view_layer.objects.active = meta
    meta.select_set(True)
    bpy.ops.object.mode_set(mode='EDIT')
    edit = meta_data.edit_bones

    keep = set(names)
    for name in names:
        pose_bone = src.pose.bones[name]
        bone = edit.new(name)
        bone.head = pose_bone.head
        bone.tail = pose_bone.tail
        bone.align_roll(pose_bone.z_axis)   # keep control axes matching the game rig

    for name in names:
        game = src.data.bones[name]
        parent = game.parent
        while parent is not None and parent.name not in keep:
            parent = parent.parent          # skip excluded bones, keep the chain intact
        if parent is None:
            continue
        edit[name].parent = edit[parent.name]
        # Only inherit the connection when the parent is the *immediate* one and
        # the heads actually coincide; otherwise connecting would move the head.
        # A bone that starts its own rig must NOT be connected, or the parent
        # rig's chain walk swallows it and both rigs claim the same bones.
        # Rigify's own metarig follows this without exception; `connect_chain`
        # is how a sub-rig re-links to its parent logically.
        if typed[name][0]:
            continue
        # Compare by name: Blender rebuilds RNA wrappers on every attribute
        # access, so `game.parent is parent` is False even for the same bone.
        if (game.parent.name == parent.name and game.use_connect
                and (edit[name].head - edit[parent.name].tail).length < 1e-5):
            edit[name].use_connect = True

    bpy.ops.object.mode_set(mode='OBJECT')

    for coll_name, ui_row in COLLECTIONS:
        coll = meta_data.collections.new(coll_name)
        coll.rigify_ui_row = ui_row
    for name in names:
        meta_data.collections[collection_for(name)].assign(meta_data.bones[name])

    for name in names:
        rig_type, params = typed[name]
        if not rig_type:
            continue
        pose_bone = meta.pose.bones[name]
        pose_bone.rigify_type = rig_type
        for key, value in params.items():
            try:
                setattr(pose_bone.rigify_parameters, key, value)
            except Exception as exc:
                print('   WARNING %s: cannot set %s=%r (%s)' % (name, key, value, exc))
        assign_layer_refs(meta_data, pose_bone, name)

    print('\nbuilt %r: %d bones, %d rigify types, %d collections'
          % (meta.name, len(meta_data.bones), len(assigned), len(meta_data.collections)))
    return meta


def assign_layer_refs(meta_data, pose_bone, name):
    """Point a limb's FK/Tweak collection refs at its (FK)/(Tweak) siblings.

    Without this Rigify prints 'empty fk layer list' and drops every FK and
    tweak control into the same collection as the IK ones, which makes the rig
    UI useless for hiding a layer.
    """
    base = collection_for(name)
    if not base.endswith(' (IK)'):
        return
    stem = base[:-5]
    params = pose_bone.rigify_parameters
    for option, suffix in (('primary_coll_refs', '(FK)'), ('secondary_coll_refs', '(Tweak)')):
        coll = meta_data.collections.get('%s %s' % (stem, suffix))
        if coll is None or not hasattr(params, option):
            continue
        refs = getattr(params, option)
        while len(refs):
            refs.remove(0)
        refs.add().set_collection(coll)


def refile_controls(rig):
    """Split FK and tweak controls out of the (IK) collections.

    Rigify is *supposed* to do this from the metarig's primary_coll_refs /
    secondary_coll_refs, and those are set correctly with valid uids -- but it
    re-files every control into the metarig bone's own collection during
    generation, so the (FK) and (Tweak) collections come out empty and the Rig
    Layers panel shows buttons that do nothing.

    Sorting by name afterwards is independent of Rigify's internals and easy to
    check: a rig with FK, IK and tweak controls all in one layer means a dozen
    overlapping widgets per limb in the viewport.
    """
    collections = rig.data.collections_all
    moved = 0

    def move(bone, target_name):
        target = collections.get(target_name)
        if target is None or target_name in [c.name for c in bone.collections]:
            return 0
        for coll in list(bone.collections):
            coll.unassign(bone)
        target.assign(bone)
        return 1

    for bone in rig.data.bones:
        current = [c.name for c in bone.collections]
        if not current:
            continue
        base = current[0]
        if base.endswith(' (IK)'):
            stem = base[:-5]
            if '_fk' in bone.name:
                moved += move(bone, '%s (FK)' % stem)
            elif '_tweak' in bone.name or bone.name.startswith('tweak_'):
                moved += move(bone, INERT_TWEAKS)
        elif base == 'Torso':
            if '_tweak' in bone.name or bone.name.startswith('tweak_'):
                moved += move(bone, 'Torso (Tweak)')
        elif base == 'Tail':
            if '_tweak' in bone.name or bone.name.startswith('tweak_'):
                moved += move(bone, 'Tail (Tweak)')
        elif base == 'Fingers':
            # The per-segment controls are the detail; the master curl stays.
            if '_master' not in bone.name:
                moved += move(bone, 'Fingers (Detail)')
    return moved


def hide_scaffolding(rig, meta):
    """Leave only the control rig and the character visible.

    Everything Rigify builds is a real object in the scene. Left alone the
    viewport shows THREE overlapping armatures (game rig, metarig, control rig)
    plus ~235 loose widget meshes, and the Rig Layers buttons appear to do
    nothing because the bones they toggle are a small fraction of what is on
    screen.

    Bone custom shapes still draw with their widget collection hidden -- the eye
    icon only affects the viewport, not evaluation -- which is why Rigify hides
    its own widget collection too.
    """
    view_layer = bpy.context.view_layer

    def find_layer(layer, name):
        if layer.name == name:
            return layer
        for child in layer.children:
            found = find_layer(child, name)
            if found:
                return found
        return None

    widget_layer = find_layer(view_layer.layer_collection, WIDGET_COLLECTION)
    if widget_layer is not None:
        widget_layer.hide_viewport = True

    hidden = []
    for obj in (meta, bpy.data.objects.get('Armature')):
        # The metarig is a blueprint, not something to pose, and the game rig is
        # driven by constraints -- neither should be in the way. The mesh still
        # deforms with its armature hidden.
        if obj is not None and obj.name in view_layer.objects:
            obj.hide_set(True)
            hidden.append(obj.name)

    print('  hid %r and %s; only %r stays visible'
          % (WIDGET_COLLECTION, ', '.join(repr(n) for n in hidden), rig.name))


def finalize(rig, meta):
    """Get the generated rig out of the export scope and set its defaults.

    Rigify links the generated rig into whatever collection is active, which
    here is the character's EXPORT collection. Left alone it would ride along
    into the FBX. The widgets are the same problem, ~230 of them.
    """
    rig.name = CTRL_RIG
    rig.data.name = CTRL_RIG

    rig_coll = bpy.data.collections[RIG_COLLECTION]
    widget_coll = bpy.data.collections.get(WIDGET_COLLECTION)
    if widget_coll is None:
        widget_coll = bpy.data.collections.new(WIDGET_COLLECTION)
        rig_coll.children.link(widget_coll)

    moved = 0
    for obj in [rig] + [o for o in bpy.data.objects if o.name.startswith('WGT-')]:
        target = rig_coll if obj is rig else widget_coll
        for coll in list(obj.users_collection):
            coll.objects.unlink(obj)
        target.objects.link(obj)
        moved += 1

    # Drop any now-empty collection Rigify made for the widgets.
    for coll in list(bpy.data.collections):
        if coll.name.startswith('WGTS') and not coll.objects and not coll.children:
            bpy.data.collections.remove(coll)

    # IK_Stretch off by default: at full extension the chain goes exactly
    # colinear (the IK singularity), and stretching deform bones is precisely
    # what humanoid retargeting will not carry back into Unity.
    stretched = 0
    for pose_bone in rig.pose.bones:
        if 'IK_Stretch' in pose_bone:
            pose_bone['IK_Stretch'] = 0.0
            stretched += 1

    # The single master switch the export script turns off (see export_avatar.py).
    rig['use_ctrl_rig'] = 1.0

    filed = refile_controls(rig)

    inert = rig.data.collections_all.get(INERT_TWEAKS)
    if inert is not None:
        inert.is_visible = False

    hide_scaffolding(rig, meta)

    print('  moved %d objects into %r / %r' % (moved, RIG_COLLECTION, WIDGET_COLLECTION))
    print('  re-filed %d controls into their (FK)/(Tweak)/(Detail) collections' % filed)
    print('  IK_Stretch defaulted to 0 on %d limb%s' % (stretched, '' if stretched == 1 else 's'))
    print('  use_ctrl_rig = 1.0 on %r' % rig.name)


def main():
    parser = argparse.ArgumentParser(description='Build the Rigify metarig.')
    parser.add_argument('--character', default='ncho', choices=['ncho'])
    parser.add_argument('--save', action='store_true', help='write the .blend (default: dry run)')
    parser.add_argument('--generate', action='store_true', help='also run rigify generate')
    args = parser.parse_args(script_args())

    addon_utils.enable('rigify', default_set=True, persistent=True)

    src = bpy.data.objects.get('Armature')
    if src is None or src.type != 'ARMATURE':
        raise SystemExit('no game armature named "Armature"')

    meta = build(src, dry_run=not args.save)
    if meta is None:
        return

    if args.generate:
        print('\ngenerating...')
        bpy.context.view_layer.objects.active = meta
        bpy.ops.object.select_all(action='DESELECT')
        meta.select_set(True)
        bpy.ops.pose.rigify_generate()
        rig = bpy.context.object
        print('generated %r: %d bones' % (rig.name, len(rig.data.bones)))
        finalize(rig, meta)

    bpy.ops.wm.save_mainfile()
    print('saved %s' % bpy.data.filepath)


if __name__ == '__main__':
    main()
