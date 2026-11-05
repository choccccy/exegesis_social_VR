# Releasing

Releases are `.unitypackage`s built by GitHub Actions (`.github/workflows/release.yml`) when
a tag is pushed. No Unity is involved: the builder reads git-tracked files directly.

| Tag | Package | Contents | README |
|---|---|---|---|
| `props-vX.Y.Z` | `exegesis_props_vX.Y.Z.unitypackage` | `props/screwdriver/` + `props/README.md` + `Assets/Editor/Poi_PS1/` | `Assets/_exegesis/props/README.md` |
| `exegesis-vX.Y.Z` | `exegesis_vX.Y.Z.unitypackage` | all of `Assets/_exegesis/` + `Assets/Editor/Poi_PS1/` | `Assets/_exegesis/README.md` |

Each package also has a changelog in [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
format: [changelog/props.md](changelog/props.md) and [changelog/exegesis.md](changelog/exegesis.md).
The release notes are that version's changelog section, followed by the package README (minus
its `## License` section, whose relative link breaks on a release page). **A tag whose version
has no changelog section fails before anything is built.**

Log changes under `## [Unreleased]` as you make them, in the usual groups (`### Added`,
`Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`). Props changes go in both changelogs,
since the props ship in the full package too.

## Cutting a release

1. **Unlock Poiyomi.** In Unity, right-click `Assets/_exegesis/` > **Thry > Materials >
   Unlock Folder**, then *File > Save Project*. (The release refuses to build otherwise.)
2. **Pick the version.** See existing ones with `git tag -l "props-v*"` /
   `git tag -l "exegesis-v*"`. Bump patch for fixes, minor for new features, major for
   anything that breaks an existing install (renamed/moved assets, removed menu items).
3. **Cut the changelog.** In the package's changelog, rename `## [Unreleased]` to
   `## [1.2.0] - YYYY-MM-DD`, add a fresh empty `## [Unreleased]` above it, and update the
   link definitions at the bottom (`[1.2.0]: .../releases/tag/props-v1.2.0`, and point
   `[Unreleased]` at `compare/props-v1.2.0...HEAD`).
4. **Update the README's Requirements** (table above) if any versions moved. To see which
   packages the release actually depends on, run the preview in
   [Only committed files ship](#only-committed-files-ship); its "external references" list
   is the requirements list.
5. **Commit and push everything that should ship.** Check `git status` for untracked
   assets: anything not committed is silently left out. Wait for the *Poiyomi unlocked*
   check on GitHub to go green.
6. **Tag and push the tag:**

   ```sh
   git tag props-v1.2.0          # or exegesis-v1.0.0
   git push origin props-v1.2.0
   ```

7. **Watch it** at the repo's *Actions* tab, or `gh run watch`. A couple of minutes later the
   release is at `https://github.com/choccccy/exegesis_social_VR/releases`. Edit its notes
   there if you want to add anything release-specific.

### If it fails

- **"has no '## [X.Y.Z]' section"**: the changelog wasn't cut (step 3). Cut it, commit,
  push, then move the tag to the new commit (below).
- **"Poiyomi check FAILED"**: a committed material is locked. Unlock, commit, push, then
  move the tag to the new commit (below).
- **Moving / redoing a tag** (it built from the wrong commit, or you want to rebuild):
  delete the release and tag, then tag again.

  ```sh
  gh release delete props-v1.2.0 --yes      # only if a release was created
  git push --delete origin props-v1.2.0
  git tag -f props-v1.2.0 && git push origin props-v1.2.0
  ```

- **"release already exists"**: the tag was pushed twice. Delete the release as above, or
  pick a new version.

## Only committed files ship

The workflow builds from a fresh checkout, so an untracked or unstaged file is not in the
package. Preview locally (this reads tracked files from your working tree, so uncommitted
*edits* to tracked files do show up here but not in CI):

```sh
cd exegesis_vrc_avatars
python Tools/release/build_unitypackage.py -v --root Assets/_exegesis/props/screwdriver \
    --root Assets/_exegesis/props/README.md --out /tmp/props.unitypackage
```

It prints every packaged path and then every **external** reference: GUIDs that point outside
`Assets/_exegesis/` (Poiyomi, VRChat SDK, VRCFury, ...). That list is the requirements list:
if a new package shows up there, add it to the READMEs. Run locally, it can name the package
each GUID belongs to; in CI third-party code isn't present, so everything shows as unknown.
It also warns about references to `_exegesis` files that aren't committed.

## What the builder follows

`Tools/release/build_unitypackage.py` mirrors Export Package's *Include dependencies*, with
one boundary:

- It follows `guid:` references (in Unity YAML and in `.meta` files) transitively, **only into
  `Assets/_exegesis/`**. That's how the props package picks up `icons/icons8-screwdriver-64.png`
  for its menu.
- It never packages anything outside `Assets/_exegesis/` unless that path is given as a
  `--root` itself. The one case is `Assets/Editor/Poi_PS1/`, TheCodeWarrior's PS1 Poiyomi
  module, which the materials depend on and which we have the author's permission to
  redistribute with credit (credited in both READMEs). Don't add other third-party roots
  without that permission.
- It refuses `OptimizedShaders/`
  and `_LockedShaderCache/` paths outright. Redistributing Poiyomi is the thing this
  boundary exists to prevent; the materials reference Poiyomi, which the user installs.
- Every ancestor folder gets an entry with its own GUID, so folders import with the same GUIDs
  as here.
- Output is reproducible: building the same commit twice gives byte-identical packages.

## Poiyomi materials must be unlocked

Poiyomi's [Terms of Service](https://www.poiyomi.com/terms-of-service/) forbid
redistributing locked (optimized) shaders, and every commit to this public repo is a
redistribution. `Tools/ci/check_poiyomi_unlocked.sh` fails on:

- any `.mat` with `_ShaderOptimizerEnabled: 1`, and
- any file in `OptimizedShaders/` or `_LockedShaderCache/` (also gitignored).

It runs in three places:

| Where | Mode | Enabled by |
|---|---|---|
| `.githooks/pre-commit` | `--staged` (what's being committed) | `git config core.hooksPath .githooks`, once per clone |
| `.github/workflows/poiyomi-unlocked.yml` | `--all` | every push / PR |
| `release.yml`, before building | `--all` | every release tag; a locked material aborts the release |

To fix a failure, in Unity right-click `Assets/_exegesis/` > **Thry > Materials > Unlock
Folder**, save, and re-stage. Lock again locally before uploading to VRChat if you want the
optimized shaders; just don't commit that state.
