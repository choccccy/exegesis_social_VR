"""Render the character through a few control-rig poses, to check deformation.

    blender --background source/ncho/ncho.blend \
        --python Tools/blender/render_poses.py -- --out <dir>

Read-only: never saves the .blend.

Uses the WORKBENCH engine on purpose. This is a deformation check, not a look
test -- flat shading with cavity reads creases and pinching far better than the
real materials would, and it needs no shading setup at all.

Worth looking at because ncho's mesh is modelled at the STRAIGHT rest pose and
then bent into the digitigrade stance (docs/rigging.md footgun 3b), so the
weighting is doing real work at the hock: 78 degrees at rest, more when posed.
"""

import argparse
import math
import os
import sys

import bpy
from mathutils import Vector

POSES = {
    'stance': {},
    'leg_lift': {'digiAnkle_ik.L': (0.0, -0.9, 1.1)},
    # Dropping the feet EXTENDS the leg (the hips stay put), which is the
    # useful check: ~0.6 units down is where the chain approaches colinear.
    'extend': {'digiAnkle_ik.L': (0.0, 0.0, -0.5), 'digiAnkle_ik.R': (0.0, 0.0, -0.5)},
    'stride': {'digiAnkle_ik.L': (0.0, -1.3, 0.2), 'digiAnkle_ik.R': (0.0, 1.1, 0.0)},
}

VIEWS = {
    'side': Vector((1.0, -0.05, 0.0)),
    'front': Vector((0.05, -1.0, 0.0)),
    'quarter': Vector((0.85, -0.6, 0.12)),
}


def script_args():
    argv = sys.argv
    return argv[argv.index('--') + 1:] if '--' in argv else []


def frame_bounds(objects):
    lo = Vector((1e9, 1e9, 1e9))
    hi = Vector((-1e9, -1e9, -1e9))
    for obj in objects:
        for corner in obj.bound_box:
            world = obj.matrix_world @ Vector(corner)
            lo = Vector(map(min, lo, world))
            hi = Vector(map(max, hi, world))
    return lo, hi


def setup_scene(subject):
    scene = bpy.context.scene
    scene.render.engine = 'BLENDER_WORKBENCH'
    shading = scene.display.shading
    shading.light = 'STUDIO'
    shading.color_type = 'SINGLE'
    shading.single_color = (0.62, 0.63, 0.66)
    shading.show_cavity = True
    shading.cavity_type = 'BOTH'
    shading.curvature_ridge_factor = 1.0
    shading.curvature_valley_factor = 1.0
    shading.show_object_outline = True
    scene.display.render_aa = '8'
    scene.render.resolution_x = 520
    scene.render.resolution_y = 760
    scene.render.film_transparent = False
    scene.world.color = (0.11, 0.11, 0.13) if scene.world else None

    camera_data = bpy.data.cameras.new('qa_cam')
    camera = bpy.data.objects.new('qa_cam', camera_data)
    scene.collection.objects.link(camera)
    scene.camera = camera
    return camera


def aim_camera(camera, direction, lo, hi):
    centre = (lo + hi) * 0.5
    radius = max((hi - lo).length * 0.5, 1e-3)
    camera.data.lens = 60
    distance = radius * 2.9
    camera.location = centre + direction.normalized() * distance
    look = centre - camera.location
    camera.rotation_euler = look.to_track_quat('-Z', 'Y').to_euler()


def apply_pose(ctrl, pose):
    for bone in ctrl.pose.bones:
        bone.matrix_basis.identity()
    bpy.context.view_layer.update()
    for name, offset in pose.items():
        bone = ctrl.pose.bones.get(name)
        if bone is None:
            print('   WARNING: no control %r' % name)
            continue
        matrix = bone.matrix.copy()
        matrix.translation = matrix.translation + Vector(offset)
        bone.matrix = matrix
    bpy.context.view_layer.update()


def main():
    parser = argparse.ArgumentParser(description='Render pose checks.')
    parser.add_argument('--out', required=True)
    parser.add_argument('--ctrl', default='ncho_ctrl')
    parser.add_argument('--poses', default='stance,leg_lift,extend,stride')
    parser.add_argument('--views', default='side,quarter')
    args = parser.parse_args(script_args())

    ctrl = bpy.data.objects.get(args.ctrl)
    if ctrl is None:
        raise SystemExit('no control rig %r' % args.ctrl)
    ctrl['use_ctrl_rig'] = 1.0
    ctrl.update_tag()
    bpy.context.view_layer.update()

    # Hide everything that is not the character itself.
    subject = [o for o in bpy.data.objects if o.type == 'MESH' and o.name in ('Body', 'Props')]
    for obj in bpy.data.objects:
        obj.hide_render = obj not in subject
    for obj in subject:
        obj.hide_render = False
        obj.hide_viewport = False

    camera = setup_scene(subject)
    os.makedirs(args.out, exist_ok=True)

    for pose_name in args.poses.split(','):
        apply_pose(ctrl, POSES[pose_name])
        bpy.context.view_layer.update()
        lo, hi = frame_bounds(subject)
        for view_name in args.views.split(','):
            aim_camera(camera, VIEWS[view_name], lo, hi)
            path = os.path.join(args.out, '%s_%s.png' % (pose_name, view_name))
            bpy.context.scene.render.filepath = path
            bpy.ops.render.render(write_still=True)
            print('rendered %s' % path)


if __name__ == '__main__':
    main()
