"""Build a .unitypackage from git-tracked files, without Unity.

A .unitypackage is a gzipped tar of one directory per asset, named by the asset's GUID:

    <guid>/pathname     the project-relative path ("Assets/...")
    <guid>/asset.meta   the .meta file
    <guid>/asset        the file itself (omitted for folders)

Starting from --root, this follows `guid:` references in Unity YAML (and .meta files)
transitively, the way Export Package's "Include dependencies" does -- but ONLY into
Assets/_exegesis/. References into Poiyomi, the VRChat SDK, VPM packages etc. are reported
and left out: those are requirements the user installs, and Poiyomi in particular must not
be redistributed.

Only files tracked by git are packaged, so anything uncommitted does not ship.

    python Tools/release/build_unitypackage.py --root Assets/_exegesis/props/screwdriver \
        --root Assets/_exegesis/props/README.md --out exegesis_props_v1.2.0.unitypackage

Paths given to --root are relative to the Unity project (exegesis_vrc_avatars/). A root
outside Assets/_exegesis/ is for bundling a third-party dependency we have permission to
redistribute (Assets/Editor/Poi_PS1); it is packaged whole, and references into it are
followed.
"""

import argparse
import collections
import gzip
import io
import os
import re
import subprocess
import sys
import tarfile

PROJECT_DIR = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
FOLLOW_PREFIX = "Assets/_exegesis/"

# Defense in depth: check_poiyomi_unlocked.sh already fails the release on these.
FORBIDDEN = re.compile(r"(^|/)(OptimizedShaders|_LockedShaderCache)(/|\.meta$)")

GUID_REF = re.compile(rb"guid: ([0-9a-f]{32})")
META_GUID = re.compile(rb"^guid: ([0-9a-f]{32})", re.M)
YAML_HEADER = b"%YAML"

# Fixed so rebuilding the same commit gives byte-identical output.
MTIME = 0


def tracked_files():
    out = subprocess.run(
        ["git", "ls-files", "-z", "--", "Assets"],
        cwd=PROJECT_DIR, check=True, capture_output=True,
    ).stdout
    return [p for p in out.decode("utf-8").split("\0") if p]


def read(rel):
    with open(os.path.join(PROJECT_DIR, rel), "rb") as f:
        return f.read()


def meta_guid(meta_rel):
    m = META_GUID.search(read(meta_rel))
    if not m:
        raise SystemExit(f"error: no guid in {meta_rel}")
    return m.group(1).decode()


def references(rel):
    """GUIDs an asset points at: from its own YAML, plus its .meta (importer remaps)."""
    refs = set()
    data = read(rel) if os.path.isfile(os.path.join(PROJECT_DIR, rel)) else b""
    if data.startswith(YAML_HEADER):
        refs.update(g.decode() for g in GUID_REF.findall(data))
    meta = read(rel + ".meta")
    own = meta_guid(rel + ".meta")
    refs.update(g.decode() for g in GUID_REF.findall(meta))
    refs.discard(own)
    return refs


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--root", action="append", required=True,
                    help="folder or file to package (repeatable), relative to the Unity project")
    ap.add_argument("--out", required=True, help="output .unitypackage path")
    ap.add_argument("-v", "--verbose", action="store_true",
                    help="list which assets make each external reference")
    args = ap.parse_args()

    files = tracked_files()
    tracked = set(files)
    roots = [r.replace("\\", "/").rstrip("/") for r in args.root]

    # A --root outside Assets/_exegesis (a bundled third-party dependency we're allowed to
    # redistribute) is indexed too, so it can be packaged and referenced into.
    follow = [FOLLOW_PREFIX] + [r + "/" for r in roots if not (r + "/").startswith(FOLLOW_PREFIX)]

    # Assets (files and folders) under those prefixes that have a tracked .meta.
    guid_to_path = {}
    path_to_guid = {}
    for p in files:
        asset = p[:-len(".meta")]
        if p.endswith(".meta") and any((asset + "/").startswith(f) for f in follow):
            if FORBIDDEN.search(p):
                continue
            g = meta_guid(p)
            guid_to_path[g] = asset
            path_to_guid[asset] = g

    def is_folder(asset):
        return os.path.isdir(os.path.join(PROJECT_DIR, asset))

    # A tracked .meta whose asset isn't tracked would ship a dangling entry.
    for asset in [a for a in path_to_guid if a not in tracked and not is_folder(a)]:
        print(f"warning: {asset}.meta is tracked but {asset} is not; skipping", file=sys.stderr)
        del guid_to_path[path_to_guid.pop(asset)]

    # Seed: everything tracked under each root.
    pending = []
    for root in roots:
        if root not in path_to_guid:
            raise SystemExit(f"error: --root {root} is not a tracked asset (is its .meta committed?)")
        pending.append(root)
        prefix = root + "/"
        pending.extend(a for a in path_to_guid if a.startswith(prefix))

    included = set()
    external = collections.defaultdict(set)  # guid -> set of assets referencing it
    while pending:
        asset = pending.pop()
        if asset in included:
            continue
        included.add(asset)
        if is_folder(asset):
            continue
        for g in references(asset):
            if g in guid_to_path:
                pending.append(guid_to_path[g])
            else:
                external[g].add(asset)

    # Every ancestor folder needs its own entry, or Unity imports with fresh folder GUIDs.
    for asset in list(included):
        parts = asset.split("/")
        for i in range(2, len(parts)):
            parent = "/".join(parts[:i])
            if parent in path_to_guid:
                included.add(parent)

    for asset in included:
        if FORBIDDEN.search(asset):
            raise SystemExit(f"error: refusing to package generated shader output: {asset}")

    buf = io.BytesIO()
    with tarfile.open(fileobj=buf, mode="w", format=tarfile.GNU_FORMAT) as tar:
        def add(name, data=None):
            info = tarfile.TarInfo(name)
            info.mtime = MTIME
            info.mode = 0o755 if data is None else 0o644
            if data is None:
                info.type = tarfile.DIRTYPE
                tar.addfile(info)
            else:
                info.size = len(data)
                tar.addfile(info, io.BytesIO(data))

        for asset in sorted(included, key=lambda a: path_to_guid[a]):
            g = path_to_guid[asset]
            add(g)
            if not is_folder(asset):
                add(f"{g}/asset", read(asset))
            add(f"{g}/asset.meta", read(asset + ".meta"))
            add(f"{g}/pathname", asset.encode("utf-8"))

    out = os.path.abspath(args.out)
    with open(out, "wb") as f:
        # mtime=0 and no filename in the gzip header, for reproducibility.
        with gzip.GzipFile(fileobj=f, mode="wb", filename="", mtime=0) as gz:
            gz.write(buf.getvalue())

    n_files = sum(1 for a in included if not is_folder(a))
    print(f"wrote {out}: {n_files} files, {len(included) - n_files} folders")
    for asset in sorted(included):
        print(f"  {asset}{'/' if is_folder(asset) else ''}")

    if external:
        # Resolve what we can to a location, so the requirements list can be checked.
        where = locate_external(set(external))
        print(f"\nexternal references (not packaged; must be installed by the user):")
        by_place = collections.defaultdict(set)
        for g, users in external.items():
            by_place[where.get(g, "unknown (missing, or built-in)")].update(users)
        for place in sorted(by_place):
            print(f"  {place}  <- {len(by_place[place])} asset(s)")
            if args.verbose:
                for user in sorted(by_place[place]):
                    print(f"      {user}")
            if FORBIDDEN.search(place):
                print(f"warning: {place} is a locked shader; unlock the material using it",
                      file=sys.stderr)
            elif place.startswith(FOLLOW_PREFIX):
                print(f"warning: {place} is referenced but not committed, so it will not ship",
                      file=sys.stderr)


def locate_external(guids):
    """Best effort: find which top-level Assets/ folder or package a GUID lives in, by
    scanning .meta files on disk (works locally; in CI third-party code isn't present)."""
    found = {}
    for base in ("Assets", "Packages"):
        top = os.path.join(PROJECT_DIR, base)
        if not os.path.isdir(top):
            continue
        for dirpath, _, names in os.walk(top):
            for n in names:
                if not n.endswith(".meta"):
                    continue
                try:
                    with open(os.path.join(dirpath, n), "rb") as f:
                        m = META_GUID.search(f.read(512))
                except OSError:
                    continue
                if m and m.group(1).decode() in guids:
                    rel = os.path.relpath(os.path.join(dirpath, n[:-len(".meta")]), PROJECT_DIR)
                    rel = rel.replace("\\", "/")
                    # Our own files by full path (they're uncommitted); third-party by folder.
                    found[m.group(1).decode()] = (
                        rel if rel.startswith(FOLLOW_PREFIX) else "/".join(rel.split("/")[:2]))
    return found


if __name__ == "__main__":
    sys.exit(main())
