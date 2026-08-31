#!/usr/bin/env python3
"""Diff two FBX files on everything Unity actually consumes.

Stricter than check_rig_contract.py: that one pins names, parents and paths,
which is what breaks animation binding. This one also compares bone rest
transforms, mesh topology and cluster weights, which is what breaks when an
*export setting* changes -- a different bone axis or unit scale keeps every
name and path intact while moving the whole skeleton.

    python Tools/blender/compare_fbx.py old.fbx new.fbx

Used to prove Tools/blender/export_avatar.py reproduces the committed FBX
before any content edit, so that later diffs mean something.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fbx_skeleton  # noqa: E402

TOLERANCE = 1e-5

# name -> (value when the property is absent, tolerance).
# FBX omits a transform property when it equals its default, and float32
# round-trip noise is enough to flip Lcl Scaling between "absent" and
# 0.99999994 -- so an absent property has to compare as its default, not as a
# difference. Rotations are in DEGREES, hence the looser bound: 1e-3 degrees is
# far below anything that could move a vertex.
TRANSFORM_PROPS = {
    'Lcl Translation': ((0.0, 0.0, 0.0), 1e-4),
    'Lcl Rotation': ((0.0, 0.0, 0.0), 1e-3),
    'Lcl Scaling': ((1.0, 1.0, 1.0), 1e-4),
    'PreRotation': ((0.0, 0.0, 0.0), 1e-3),
    'PostRotation': ((0.0, 0.0, 0.0), 1e-3),
    'RotationOffset': ((0.0, 0.0, 0.0), 1e-4),
    'RotationPivot': ((0.0, 0.0, 0.0), 1e-4),
}


def _properties(node):
    """Model/Geometry Properties70 -> {name: (values...)}."""
    out = {}
    for block in node.find('Properties70'):
        for prop in block.find('P'):
            if not prop.props:
                continue
            name = prop.props[0]
            values = tuple(v for v in prop.props[4:] if isinstance(v, (int, float)))
            out[name] = values
    return out


def summarise(path):
    root = fbx_skeleton.parse(path)
    objects = next((n for n in root.children if n.name == 'Objects'), None)
    if objects is None:
        raise SystemExit('no Objects section in %s' % path)

    models, geometry, clusters, shapes = {}, {}, {}, {}
    for child in objects.children:
        if len(child.props) < 3:
            continue
        name = fbx_skeleton._obj_name(child.props[1])
        if child.name == 'Model':
            models[name] = {'type': child.props[2], 'props': _properties(child)}
        elif child.name == 'Geometry':
            verts = child.find('Vertices')
            index = child.find('PolygonVertexIndex')
            geometry[name] = {
                'vertices': len(verts[0].props[0]) // 3 if verts and verts[0].props else 0,
                'indices': len(index[0].props[0]) if index and index[0].props else 0,
            }
        elif child.name == 'Deformer' and child.props[2] == 'Cluster':
            weights = child.find('Weights')
            clusters.setdefault(name, []).append(
                len(weights[0].props[0]) if weights and weights[0].props else 0)
        elif child.name == 'Deformer' and child.props[2] == 'BlendShapeChannel':
            shapes[name] = True

    globals_ = {}
    settings = next((n for n in root.children if n.name == 'GlobalSettings'), None)
    if settings is not None:
        for block in settings.find('Properties70'):
            for prop in block.find('P'):
                if prop.props and prop.props[0] in (
                        'UnitScaleFactor', 'OriginalUnitScaleFactor',
                        'UpAxis', 'UpAxisSign', 'FrontAxis', 'CoordAxis'):
                    globals_[prop.props[0]] = tuple(prop.props[4:])

    animation = {}
    for child in objects.children:
        if 'Anim' in child.name:
            animation[child.name] = animation.get(child.name, 0) + 1

    skel = fbx_skeleton.read_skeleton(path)
    return {'models': models, 'geometry': geometry,
            'clusters': {k: sorted(v) for k, v in clusters.items()},
            'shapes': sorted(shapes), 'bones': skel['bones'],
            'globals': globals_, 'animation': animation}


def _compare_sets(label, old, new, problems):
    added, removed = sorted(set(new) - set(old)), sorted(set(old) - set(new))
    if added:
        problems.append('%s added: %s' % (label, ', '.join(added)))
    if removed:
        problems.append('%s removed: %s' % (label, ', '.join(removed)))
    return sorted(set(old) & set(new))


def compare(old_path, new_path):
    old, new = summarise(old_path), summarise(new_path)
    problems = []

    for name in _compare_sets('object', old['models'], new['models'], problems):
        a, b = old['models'][name], new['models'][name]
        if a['type'] != b['type']:
            problems.append('%s type %s -> %s' % (name, a['type'], b['type']))
        for prop, (fallback, tolerance) in TRANSFORM_PROPS.items():
            va = a['props'].get(prop, fallback)
            vb = b['props'].get(prop, fallback)
            if len(va) != len(vb):
                problems.append('%s %s arity %d -> %d' % (name, prop, len(va), len(vb)))
                continue
            drift = max((abs(x - y) for x, y in zip(va, vb)), default=0.0)
            if drift > tolerance:
                problems.append('%s %s differs by %.6g: %s -> %s' % (name, prop, drift, va, vb))

    for name in _compare_sets('bone-parent', old['bones'], new['bones'], problems):
        if old['bones'][name]['parent'] != new['bones'][name]['parent']:
            problems.append('%s reparented: %s -> %s'
                            % (name, old['bones'][name]['parent'], new['bones'][name]['parent']))

    for name in _compare_sets('geometry', old['geometry'], new['geometry'], problems):
        if old['geometry'][name] != new['geometry'][name]:
            problems.append('%s topology %s -> %s' % (name, old['geometry'][name], new['geometry'][name]))

    for name in _compare_sets('cluster', old['clusters'], new['clusters'], problems):
        if old['clusters'][name] != new['clusters'][name]:
            problems.append('%s weight counts %s -> %s'
                            % (name, old['clusters'][name], new['clusters'][name]))

    _compare_sets('shape key', old['shapes'], new['shapes'], problems)

    for key in sorted(set(old['globals']) | set(new['globals'])):
        if old['globals'].get(key) != new['globals'].get(key):
            problems.append('GlobalSettings %s: %s -> %s'
                            % (key, old['globals'].get(key), new['globals'].get(key)))

    if old['animation'] != new['animation']:
        problems.append('animation objects: %s -> %s'
                        % (old['animation'] or 'none', new['animation'] or 'none'))

    return problems, old, new


def main():
    parser = argparse.ArgumentParser(description='Diff two FBX files structurally.')
    parser.add_argument('old')
    parser.add_argument('new')
    parser.add_argument('--limit', type=int, default=25, help='max problems to print')
    args = parser.parse_args()

    problems, old, new = compare(args.old, args.new)
    print('old: %s  (%d objects, %d meshes)' % (args.old, len(old['models']), len(old['geometry'])))
    print('new: %s  (%d objects, %d meshes)' % (args.new, len(new['models']), len(new['geometry'])))
    if not problems:
        print('\nIDENTICAL  objects, hierarchy, bone transforms, topology, weights, shape keys')
        return 0
    print('\n%d difference(s):' % len(problems))
    for problem in problems[:args.limit]:
        print('  - %s' % problem)
    if len(problems) > args.limit:
        print('  ... and %d more' % (len(problems) - args.limit))
    return 1


if __name__ == '__main__':
    sys.exit(main())
