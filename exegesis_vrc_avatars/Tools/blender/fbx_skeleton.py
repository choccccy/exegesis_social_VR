"""Minimal binary-FBX reader: enough to recover the skeleton contract.

Reads bone names, the parent hierarchy, full transform paths, skin-cluster
(weighted) bones and blend-shape channel names straight out of a .fbx.

Deliberately dependency-free and Unity-free: the Editor usually holds the
project lock, so the contract tests must not need Unity or Blender to run.
Handles FBX binary version 7400 (32-bit node records); 7500+ uses 64-bit
offsets and is rejected loudly rather than misparsed.
"""

import struct
import zlib


class FbxError(Exception):
    pass


_ARRAY_TYPES = {'f': 'f', 'd': 'd', 'l': 'q', 'i': 'i', 'b': 'b'}
_SCALAR_TYPES = {'Y': ('h', 2), 'C': ('?', 1), 'I': ('i', 4), 'F': ('f', 4),
                 'D': ('d', 8), 'L': ('q', 8)}


class Node:
    __slots__ = ('name', 'props', 'children')

    def __init__(self, name, props, children):
        self.name = name
        self.props = props
        self.children = children

    def find(self, name):
        return [c for c in self.children if c.name == name]

    def __repr__(self):
        return f'<Node {self.name} props={len(self.props)} kids={len(self.children)}>'


def _read_property(buf, pos):
    kind = chr(buf[pos])
    pos += 1
    if kind in _SCALAR_TYPES:
        fmt, size = _SCALAR_TYPES[kind]
        return struct.unpack_from('<' + fmt, buf, pos)[0], pos + size
    if kind in _ARRAY_TYPES:
        length, encoding, comp_len = struct.unpack_from('<III', buf, pos)
        pos += 12
        raw = buf[pos:pos + comp_len]
        pos += comp_len
        if encoding == 1:
            raw = zlib.decompress(raw)
        fmt = _ARRAY_TYPES[kind]
        return list(struct.unpack_from('<%d%s' % (length, fmt), raw, 0)), pos
    if kind in ('S', 'R'):
        length = struct.unpack_from('<I', buf, pos)[0]
        pos += 4
        raw = buf[pos:pos + length]
        pos += length
        return (raw.decode('utf-8', 'replace') if kind == 'S' else raw), pos
    raise FbxError('unknown property type %r at %d' % (kind, pos - 1))


def _read_node(buf, pos):
    """Return (node, next_pos). A null record yields (None, pos_after)."""
    end_offset, num_props, prop_len = struct.unpack_from('<III', buf, pos)
    name_len = buf[pos + 12]
    pos += 13
    if end_offset == 0:
        return None, pos
    name = buf[pos:pos + name_len].decode('utf-8', 'replace')
    pos += name_len

    props = []
    for _ in range(num_props):
        value, pos = _read_property(buf, pos)
        props.append(value)

    children = []
    while pos < end_offset:
        child, pos = _read_node(buf, pos)
        if child is None:
            break
        children.append(child)
    return Node(name, props, children), end_offset


def parse(path):
    with open(path, 'rb') as fh:
        buf = fh.read()
    if not buf.startswith(b'Kaydara FBX Binary'):
        raise FbxError('%s is not a binary FBX' % path)
    version = struct.unpack_from('<I', buf, 23)[0]
    if version >= 7500:
        raise FbxError('FBX %d uses 64-bit node records; this reader handles 7400' % version)
    pos = 27
    roots = []
    while pos < len(buf) - 16:
        node, pos = _read_node(buf, pos)
        if node is None:
            break
        roots.append(node)
    return Node('__root__', [], roots)


def _obj_name(prop):
    """'Hips\x00\x01Model' -> 'Hips'. FBX stores names reversed around \x00\x01."""
    return prop.split('\x00\x01')[0] if isinstance(prop, str) else str(prop)


def read_skeleton(path):
    """Extract the export contract from an FBX.

    Returns a dict with:
      bones      {name: {'parent': name|None, 'path': 'Armature/Hips/...',
                         'type': 'LimbNode'|'Null'|'Mesh'}}
      order      bone names in file order (stable, catches reordering)
      weighted   sorted names of bones with a skin cluster
      shape_keys sorted blend-shape channel names
    """
    root = parse(path)
    objects, connections = None, None
    for node in root.children:
        if node.name == 'Objects':
            objects = node
        elif node.name == 'Connections':
            connections = node
    if objects is None:
        raise FbxError('no Objects section in %s' % path)

    models, order = {}, []
    weighted, shape_keys = set(), set()
    for child in objects.children:
        if child.name == 'Model' and len(child.props) >= 3:
            uid, name, subtype = child.props[0], _obj_name(child.props[1]), child.props[2]
            models[uid] = {'name': name, 'type': subtype}
            order.append(name)
        elif child.name == 'Deformer' and len(child.props) >= 3:
            if child.props[2] == 'Cluster':
                weighted.add(_obj_name(child.props[1]))
            elif child.props[2] == 'BlendShapeChannel':
                shape_keys.add(_obj_name(child.props[1]))

    parent_of = {}
    if connections is not None:
        for conn in connections.children:
            # C: [kind, child_uid, parent_uid, (property_name)]
            if conn.name != 'C' or len(conn.props) < 3 or conn.props[0] != 'OO':
                continue
            child_uid, parent_uid = conn.props[1], conn.props[2]
            # A bone Model is also the *child* of every skin Cluster it links
            # to, so only Model -> Model links describe the hierarchy. Without
            # this filter a cluster link overwrites the real parent.
            if child_uid in models and (parent_uid in models or parent_uid == 0):
                parent_of[child_uid] = parent_uid

    by_name = {}
    for uid, info in models.items():
        parent_uid = parent_of.get(uid)
        parent = models[parent_uid]['name'] if parent_uid in models else None
        by_name[info['name']] = {'parent': parent, 'type': info['type']}

    def full_path(name, seen=None):
        seen = seen or set()
        if name in seen:
            return name  # cycle guard; malformed file
        parent = by_name[name]['parent']
        if parent is None or parent not in by_name:
            return name
        return full_path(parent, seen | {name}) + '/' + name

    for name, info in by_name.items():
        info['path'] = full_path(name)

    return {
        'bones': by_name,
        'order': order,
        'weighted': sorted(weighted),
        'shape_keys': sorted(shape_keys),
    }
