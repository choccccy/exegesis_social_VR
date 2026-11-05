"""Print one version's section from a Keep a Changelog file.

    python Tools/release/changelog_section.py docs/changelog/props.md 1.2.0

Prints the body under `## [1.2.0]` (up to the next `## ` heading or the link definitions at
the bottom). Exits non-zero if the version has no section or the section is empty, so a
release can't go out without its changelog entry.
"""

import re
import sys


def main():
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    path, version = sys.argv[1], sys.argv[2]
    lines = open(path, encoding="utf-8").read().splitlines()

    heading = re.compile(r"^## \[" + re.escape(version) + r"\](\s|$)")
    start = next((i for i, l in enumerate(lines) if heading.match(l)), None)
    if start is None:
        raise SystemExit(
            f"error: {path} has no '## [{version}]' section.\n"
            f"Rename '## [Unreleased]' to '## [{version}] - YYYY-MM-DD', add a fresh empty\n"
            f"'## [Unreleased]' above it, commit, then tag.")

    body = []
    for l in lines[start + 1:]:
        if l.startswith("## ") or re.match(r"^\[[^\]]+\]: ", l):
            break
        body.append(l)
    text = "\n".join(body).strip()
    if not text:
        raise SystemExit(f"error: the '## [{version}]' section of {path} is empty")
    # UTF-8 regardless of platform: Windows defaults to cp1252, which can't encode the names.
    sys.stdout.reconfigure(encoding="utf-8")
    print(text)


if __name__ == "__main__":
    main()
