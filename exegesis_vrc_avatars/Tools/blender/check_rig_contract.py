#!/usr/bin/env python3
"""Pin the Blender -> FBX -> Unity skeleton contract for the avatars.

VRChat binds animation to bones by *full transform path* and the humanoid
avatar binds by bone *name*, so a rename or reparent in Blender breaks the
avatar silently -- the curve simply stops resolving. These checks make that
loud.

    python Tools/blender/check_rig_contract.py            # check everything
    python Tools/blender/check_rig_contract.py --seed     # (re)write goldens
    python Tools/blender/check_rig_contract.py --fbx X.fbx --character ncho

Deliberately Unity-free and Blender-free: the Editor usually holds the project
lock, so this has to run without either. See docs/rigging.md.
"""

import argparse
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import fbx_skeleton  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
GOLDEN_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'golden')

CHARACTERS = {
    'ncho': {
        'fbx': 'Assets/_exegesis/ncho/ncho.fbx',
        'shape_keys': ['expand_tanks'],
    },
    'obi-me': {
        'fbx': 'Assets/_exegesis/obi-me/obi-me.fbx',
        'shape_keys': [],
    },
}

ANIM_ROOT = 'Assets/_exegesis'


class Result:
    def __init__(self):
        self.failures = []
        self.notes = []

    def fail(self, test, message):
        self.failures.append('%s: %s' % (test, message))

    def note(self, message):
        self.notes.append(message)

    @property
    def ok(self):
        return not self.failures


def golden_path(character):
    return os.path.join(GOLDEN_DIR, '%s_skeleton.json' % character.replace('-', '_'))


def load_skeleton(fbx_path):
    return fbx_skeleton.read_skeleton(os.path.join(ROOT, fbx_path))


def seed(character, fbx_path):
    skel = load_skeleton(fbx_path)
    payload = {
        'fbx': fbx_path,
        'bones': skel['bones'],
        'order': skel['order'],
        'weighted': skel['weighted'],
        'shape_keys': skel['shape_keys'],
    }
    os.makedirs(GOLDEN_DIR, exist_ok=True)
    with open(golden_path(character), 'w', encoding='utf-8') as fh:
        json.dump(payload, fh, indent=1, sort_keys=True)
        fh.write('\n')
    print('seeded %s (%d objects, %d weighted, shape keys %s)'
          % (golden_path(character), len(skel['bones']), len(skel['weighted']),
             skel['shape_keys'] or '-'))


def check_skeleton_golden(character, skel, result):
    path = golden_path(character)
    if not os.path.exists(path):
        result.fail('skeleton-golden', 'no golden at %s -- run --seed first' % path)
        return
    with open(path, encoding='utf-8') as fh:
        want = json.load(fh)

    have_bones, want_bones = skel['bones'], want['bones']
    added = sorted(set(have_bones) - set(want_bones))
    removed = sorted(set(want_bones) - set(have_bones))
    if added:
        result.fail('skeleton-golden', 'new objects: %s' % ', '.join(added))
    if removed:
        result.fail('skeleton-golden', 'MISSING objects: %s' % ', '.join(removed))

    for name in sorted(set(have_bones) & set(want_bones)):
        if have_bones[name]['parent'] != want_bones[name]['parent']:
            result.fail('skeleton-golden', '%s reparented: %s -> %s'
                        % (name, want_bones[name]['parent'], have_bones[name]['parent']))
        elif have_bones[name]['path'] != want_bones[name]['path']:
            result.fail('skeleton-golden', '%s path changed: %s -> %s'
                        % (name, want_bones[name]['path'], have_bones[name]['path']))

    if skel['order'] != want['order'] and not (added or removed):
        result.note('%s: bone order changed (harmless for path binding)' % character)


def check_anim_paths(skeletons, result):
    """Every Armature/... path in every clip must still resolve.

    Scene GameObjects get parented under bones (HUD, contact senders), so a
    trailing non-bone component is legitimate -- what must hold is that the
    bone-shaped prefix resolves and nothing after it names a bone.
    """
    valid_paths, bone_names = set(), set()
    for skel in skeletons.values():
        for info in skel['bones'].values():
            valid_paths.add(info['path'])
        bone_names |= set(skel['bones'])

    checked = 0
    for dirpath, _dirs, files in os.walk(os.path.join(ROOT, ANIM_ROOT)):
        for filename in files:
            if not filename.endswith('.anim'):
                continue
            full = os.path.join(dirpath, filename)
            with open(full, encoding='utf-8', errors='replace') as fh:
                text = fh.read()
            rel = os.path.relpath(full, ROOT).replace('\\', '/')
            for raw in sorted(set(re.findall(r'^\s+path: (Armature/\S+)$', text, re.M))):
                checked += 1
                parts = raw.split('/')
                depth = 0
                for i in range(len(parts), 0, -1):
                    if '/'.join(parts[:i]) in valid_paths:
                        depth = i
                        break
                if depth == 0:
                    result.fail('anim-paths', '%s: unresolvable %s' % (rel, raw))
                    continue
                stray = [p for p in parts[depth:] if p in bone_names]
                if stray:
                    result.fail('anim-paths', '%s: %s -- %s is a bone but not where the '
                                'path expects it' % (rel, raw, ', '.join(stray)))
    result.note('anim-paths: %d distinct bone paths checked' % checked)


def check_humanoid_map(character, skel, result):
    meta = os.path.join(ROOT, CHARACTERS[character]['fbx'] + '.meta')
    if not os.path.exists(meta):
        result.fail('humanoid-map', 'no %s' % meta)
        return
    with open(meta, encoding='utf-8', errors='replace') as fh:
        text = fh.read()
    mapped = re.findall(r'^\s+- boneName: (\S+)$', text, re.M)
    if not mapped:
        result.fail('humanoid-map', '%s: no humanoid bones found in meta' % character)
        return
    missing = sorted({b for b in mapped if b not in skel['bones']})
    if missing:
        result.fail('humanoid-map', '%s: humanoid bones absent from FBX: %s'
                    % (character, ', '.join(missing)))
    result.note('humanoid-map: %s %d bones mapped' % (character, len(mapped)))

    listed = set(re.findall(r'^\s+- name: (\S+)$', text, re.M))
    drifted = sorted(listed - set(skel['bones']))
    if drifted:
        result.note('%s: meta skeleton list is stale, names not in the FBX: %s'
                    % (character, ', '.join(drifted[:8]) + (' ...' if len(drifted) > 8 else '')))


def check_no_animation(character, fbx_path, result):
    """The FBX must carry geometry and a skeleton, never animation.

    The exporter's bake_anim default is True. It writes nothing today because
    neither blend has an action, but Phase 1's control rig will create them --
    at which point animation would start silently riding along in the model
    FBX. Catch that here rather than in VRChat.
    """
    root = fbx_skeleton.parse(os.path.join(ROOT, fbx_path))
    objects = next((n for n in root.children if n.name == 'Objects'), None)
    if objects is None:
        return
    kinds = {}
    for child in objects.children:
        if 'Anim' in child.name:
            kinds[child.name] = kinds.get(child.name, 0) + 1
    if kinds:
        result.fail('no-animation', '%s: FBX contains animation objects (%s) -- set '
                    'bake_anim=False in export_avatar.py'
                    % (character, ', '.join('%s x%d' % kv for kv in sorted(kinds.items()))))


def check_shape_keys(character, skel, result):
    """Pinned twice over: against the golden, and against an explicit list here.

    The golden moves when it is re-seeded after an intentional change; the
    explicit list does not, so a shape key cannot be lost by re-blessing.
    """
    have = set(skel['shape_keys'])

    missing = [k for k in CHARACTERS[character]['shape_keys'] if k not in have]
    if missing:
        result.fail('shape-keys', '%s: missing %s' % (character, ', '.join(missing)))

    path = golden_path(character)
    if not os.path.exists(path):
        return
    with open(path, encoding='utf-8') as fh:
        want = set(json.load(fh).get('shape_keys', []))
    if have != want:
        added, removed = sorted(have - want), sorted(want - have)
        detail = []
        if removed:
            detail.append('lost %s' % ', '.join(removed))
        if added:
            detail.append('gained %s' % ', '.join(added))
        result.fail('shape-keys', '%s: %s vs the golden' % (character, '; '.join(detail)))


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--seed', action='store_true', help='(re)write the goldens')
    parser.add_argument('--character', choices=sorted(CHARACTERS), help='limit to one character')
    parser.add_argument('--fbx', help='check this FBX instead of the committed one '
                                      '(requires --character)')
    args = parser.parse_args()

    if args.fbx and not args.character:
        parser.error('--fbx requires --character')

    names = [args.character] if args.character else sorted(CHARACTERS)

    if args.seed:
        for name in names:
            seed(name, args.fbx or CHARACTERS[name]['fbx'])
        return 0

    result = Result()
    skeletons = {}
    for name in names:
        fbx = args.fbx or CHARACTERS[name]['fbx']
        if not os.path.exists(os.path.join(ROOT, fbx)):
            result.fail('load', '%s: no such FBX %s' % (name, fbx))
            continue
        skeletons[name] = load_skeleton(fbx)

    for name, skel in skeletons.items():
        check_skeleton_golden(name, skel, result)
        check_humanoid_map(name, skel, result)
        check_shape_keys(name, skel, result)
        check_no_animation(name, args.fbx or CHARACTERS[name]['fbx'], result)
    if skeletons:
        check_anim_paths(skeletons, result)

    for note in result.notes:
        print('  note: %s' % note)
    if result.ok:
        print('OK  rig contract intact (%s)' % ', '.join(sorted(skeletons)))
        return 0
    print('\nFAIL  %d problem(s):' % len(result.failures))
    for failure in result.failures:
        print('  - %s' % failure)
    return 1


if __name__ == '__main__':
    sys.exit(main())
