# Project overview

A **VRChat avatar** Unity project. The avatar is "ncho".

- **Unity 2022.3.22f1 LTS** (`ProjectSettings/ProjectVersion.txt`). Match this exactly.
- **Built-in Render Pipeline (BiRP)** — not URP/HDRP. Shaders are `.shader` + `.cginc`
  with `CGPROGRAM` blocks. VRChat requires BiRP.
- Vendored in `Assets/`: **Poiyomi** shaders (`_PoiyomiShaders/`), VRChat SDK, Pumkin
  tools, BluWizard tools. Treat these as third-party — don't refactor them.

## Repo layout gotcha

- **The git root is one level up**: `exegesis_social_VR/.git`. The Unity project is the
  **`exegesis_vrc_avatars/` subdirectory** (its own `Assets/`, `Packages/`,
  `ProjectSettings/`). CI (`.github/workflows/`) would live at the git root and point
  `projectPath: exegesis_vrc_avatars`.
- There's an empty stray `Assets/` at the git root — ignore it.

## Building / running tests

- **The Unity Editor is often open on this project.** ALWAYS check for
  `exegesis_vrc_avatars/Temp/UnityLockfile` (or a running `Unity.exe`) before launching a
  headless Unity on this folder — a second instance on an open project fails on the lock
  and can corrupt `Library/`. Headless runs use a separate clone; see
  [testing.md](testing.md).
- **Unity Test Framework** is available (pinned in `Packages/manifest.json`,
  `com.unity.test-framework`). EditMode/PlayMode NUnit tests work.
- Run tests in the Editor: `Window > General > Test Runner`. Run headless:
  `Tools/headless-tests/run_headless_tests.ps1` (details in [testing.md](testing.md)).

## VRChat: material properties are a public contract

VRChat drives shader/material properties **by name** from AnimationClips (`.anim`),
AnimatorControllers (`.controller`), and VRC Expression Parameters/Menus. **Renaming a
driven property silently breaks the avatar** — the curve no longer binds. Before
renaming/removing any shader property, grep `.anim`/`.controller`/`.asset` for its name.
Reorganizing/adding is safe; renaming driven ones is not. The HUD shader's specific
contract list is in [hud-shader.md](hud-shader.md).

## Where to look next

- [hud-shader.md](hud-shader.md) — the custom HUD shader (current focus of work).
- [testing.md](testing.md) — the regression test suite and headless workflow.
