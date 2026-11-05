#!/bin/sh
# Fails if any Poiyomi material is LOCKED, or if any generated (locked) shader output is
# tracked. Poiyomi's Terms of Service forbid redistributing locked shaders, and every commit
# to this public repo is a redistribution.
#
#   --staged  check what is about to be committed (pre-commit hook)
#   --all     check every tracked file (CI, release workflow)
#
# Keep this POSIX sh: it runs under Git for Windows' bash and on Ubuntu CI.

set -u

mode="${1:---all}"
cd "$(git rev-parse --show-toplevel)" || exit 2

case "$mode" in
    --staged) files=$(git diff --cached --name-only --diff-filter=ACMR) ;;
    --all)    files=$(git ls-files) ;;
    *) echo "usage: $0 [--staged|--all]" >&2; exit 2 ;;
esac

show() {
    if [ "$mode" = "--staged" ]; then git show ":$1"; else cat "$1"; fi
}

locked=""
generated=""

# Newline-separated list; paths may contain spaces but not newlines.
IFS='
'
for f in $files; do
    case "$f" in
        */OptimizedShaders/*|*/OptimizedShaders.meta|*/_LockedShaderCache/*|*/_LockedShaderCache.meta)
            generated="$generated
  $f" ;;
        *.mat)
            if show "$f" | grep -q '_ShaderOptimizerEnabled: 1'; then
                locked="$locked
  $f"
            fi ;;
    esac
done

if [ -z "$locked" ] && [ -z "$generated" ]; then
    exit 0
fi

# "a\n  b\n  c" -> "a, b, c", project-relative. Git GUIs (VS Code, GitHub Desktop) show only
# the first line of hook output in their error dialog, so the paths have to be on it.
join() {
    printf '%s\n' "$1" | sed -e '/^$/d' -e 's/^  //' -e 's|^exegesis_vrc_avatars/||' |
        awk 'NR > 1 { printf ", " } { printf "%s", $0 }'
}
summary="Poiyomi check FAILED (locked shaders must not be committed):"
[ -n "$locked" ] && summary="$summary locked: $(join "$locked")"
[ -n "$locked" ] && [ -n "$generated" ] && summary="$summary;"
[ -n "$generated" ] && summary="$summary generated: $(join "$generated")"
echo "$summary" >&2

if [ -n "$locked" ]; then
    echo "" >&2
    echo "Locked materials:$locked" >&2
    echo "" >&2
    echo "Fix: in Unity, right-click Assets/_exegesis/ > Thry > Materials > Unlock Folder," >&2
    echo "     save, then stage the materials again." >&2
fi
if [ -n "$generated" ]; then
    echo "" >&2
    echo "Generated shader files (should be gitignored):$generated" >&2
    echo "" >&2
    echo "Fix: git rm --cached <file>" >&2
fi
exit 1
