#!/usr/bin/env python3
"""Re-point Unity YAML references after model sub-objects were renamed.

Unity derives a model sub-object's local file ID from its NAME, so renaming a
bone in Blender silently invalidates every reference to it: PhysBone roots,
m_CorrespondingSourceObject on instantiated GameObjects and Transforms, and
prefab modification targets. Unity reports nothing -- the references just go
missing.

This joins the before/after dumps from Tools/unity-repair/dump_fbx_ids.ps1
through the rename table and substitutes the file IDs in place, but ONLY where
the accompanying guid is the renamed asset's.

    python Tools/unity-repair/repair_refs.py --remap ncho_id_remap.json          # dry run
    python Tools/unity-repair/repair_refs.py --remap ncho_id_remap.json --apply

The audit afterwards is the point: the total reference count must not move, no
reference may still point at a retired ID, and each new ID must appear exactly
as often as its old one did.
"""

import argparse
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
SCAN_DIRS = ['Assets/_exegesis']
SCAN_EXTENSIONS = ('.unity', '.prefab', '.asset', '.controller', '.anim', '.mat', '.overrideController')


def yaml_files():
    for scan in SCAN_DIRS:
        for dirpath, _dirs, files in os.walk(os.path.join(ROOT, scan)):
            for filename in files:
                if filename.endswith(SCAN_EXTENSIONS):
                    yield os.path.join(dirpath, filename)


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--remap', required=True,
                        help='JSON with {guid, map: {old_id: new_id}, renames: {...}}')
    parser.add_argument('--apply', action='store_true', help='write the files (default: dry run)')
    args = parser.parse_args()

    remap_path = args.remap
    if not os.path.isabs(remap_path):
        candidate = os.path.join(os.path.dirname(os.path.abspath(__file__)), remap_path)
        remap_path = candidate if os.path.exists(candidate) else os.path.join(ROOT, remap_path)
    with open(remap_path, encoding='utf-8') as fh:
        remap = json.load(fh)

    guid = remap['guid']
    substitutions = remap['map']
    print('%s %d file ID substitution(s) for guid %s (%d bone renames)'
          % ('APPLYING' if args.apply else 'DRY RUN:', len(substitutions), guid,
             len(remap.get('renames', {}))))

    # Only ever rewrite an id that sits next to THIS guid.
    pattern = re.compile(r'fileID: (-?\d+), guid: ' + re.escape(guid))

    total_before = total_after = 0
    dead_before = dead_after = 0
    per_file, hits_by_id = {}, {}

    def rewrite(text, tally_only):
        nonlocal total_before, dead_before
        count = [0]

        def swap(match):
            old = match.group(1)
            total_counter[0] += 1
            if old in substitutions:
                count[0] += 1
                hits_by_id[old] = hits_by_id.get(old, 0) + 1
                if tally_only:
                    return match.group(0)
                return 'fileID: %s, guid: %s' % (substitutions[old], guid)
            return match.group(0)

        total_counter = [0]
        new_text = pattern.sub(swap, text)
        return new_text, count[0], total_counter[0]

    for path in yaml_files():
        with open(path, encoding='utf-8', errors='replace') as fh:
            text = fh.read()
        if guid not in text:
            continue
        new_text, replaced, total = rewrite(text, tally_only=not args.apply)
        total_before += total
        if replaced:
            rel = os.path.relpath(path, ROOT).replace('\\', '/')
            per_file[rel] = replaced
            if args.apply and new_text != text:
                with open(path, 'w', encoding='utf-8', newline='') as fh:
                    fh.write(new_text)

    if not per_file:
        print('\nno references matched -- nothing to do')
        return 0

    print('\nreferences re-pointed:')
    for rel, count in sorted(per_file.items(), key=lambda kv: -kv[1]):
        print('  %-52s %4d' % (rel, count))
    print('  %-52s %4d' % ('TOTAL', sum(per_file.values())))

    if not args.apply:
        print('\nDRY RUN -- nothing written. Re-run with --apply.')
        return 0

    # ---- audit -------------------------------------------------------------
    print('\naudit:')
    retired = set(substitutions)
    installed = {v: k for k, v in substitutions.items()}
    still_dead, new_counts, grand_total = 0, {}, 0
    for path in yaml_files():
        with open(path, encoding='utf-8', errors='replace') as fh:
            text = fh.read()
        if guid not in text:
            continue
        for found in pattern.findall(text):
            grand_total += 1
            if found in retired:
                still_dead += 1
            if found in installed:
                new_counts[found] = new_counts.get(found, 0) + 1

    print('  total references to the asset: %d before, %d after%s'
          % (total_before, grand_total, '  OK' if total_before == grand_total else '  MISMATCH'))
    print('  references still pointing at a retired ID: %d%s'
          % (still_dead, '  OK' if still_dead == 0 else '  BAD'))

    unbalanced = [(old, hits_by_id.get(old, 0), new_counts.get(substitutions[old], 0))
                  for old in substitutions
                  if hits_by_id.get(old, 0) != new_counts.get(substitutions[old], 0)]
    print('  new IDs appearing as often as the old ones: %s'
          % ('yes, all %d' % len(substitutions) if not unbalanced
             else 'NO -- %d mismatched' % len(unbalanced)))
    for old, was, now in unbalanced[:10]:
        print('      %s: was %d, now %d' % (old, was, now))

    ok = total_before == grand_total and still_dead == 0 and not unbalanced
    print('\n%s' % ('AUDIT PASSED' if ok else 'AUDIT FAILED'))
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
