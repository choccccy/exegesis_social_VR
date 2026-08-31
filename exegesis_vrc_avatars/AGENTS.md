# Notes for agents

Notes for any AI agent (or human) working on this repo. Tool-agnostic — read this
regardless of which assistant you are. Full docs live in [`docs/`](docs/).

VRChat avatar Unity project ("ncho"), **Unity 2022.3.22f1 LTS, Built-in Render Pipeline**.

## Read these

- **[docs/project.md](docs/project.md)** — repo layout, Unity/BiRP, build/test entry points.
- **[docs/rcs-thrusters.md](docs/rcs-thrusters.md)** — the RCS thruster shader + its FX layers
  (current focus). Its **Footguns** section is the most useful page in the repo.
- **[docs/hud-shader.md](docs/hud-shader.md)** — the custom HUD shader.
- **[docs/animator-generation.md](docs/animator-generation.md)** — the FX controller is partly
  **generated**. Read this before editing any `rcs_*` or `slot_*` layer by hand: re-run the tool
  instead. Also carries the Animator As Code migration notes.
- **[docs/rigging.md](docs/rigging.md)** — the armatures and the Blender → FBX → Unity
  contract. Read this before touching a `.blend`, renaming a bone, or exporting.
- **[docs/testing.md](docs/testing.md)** — regression test suite + headless-clone workflow.

## Four things that will bite you if you forget

1. **The Unity Editor is usually open on this project.** You CANNOT run a headless
   `Unity.exe -batchmode` against this folder while it's open (exclusive lock; risks
   `Library/` corruption). Check `exegesis_vrc_avatars/Temp/UnityLockfile` / running
   `Unity.exe` first. Headless tests and asset refreshes run against a separate clone —
   see docs/testing.md (`Tools/headless-tests/`).
2. **Material properties are a VRChat contract.** Animations drive shader properties by
   name; renaming a driven one silently breaks the avatar. The HUD shader's do-not-rename
   list is in docs/hud-shader.md. Grep `.anim`/`.controller` before renaming anything.
3. **"Everything is broken" usually means one new thing has a bad default.** This project
   has lost hours to it repeatedly, always in the same shape: a feature added with an
   *active* default silently disables behaviour that already worked, somewhere unrelated.
   Before investigating a system-wide failure, check what changed last and what its default
   is. And do not diagnose from editor scripts reading live material state — they return a
   plausible `0` for anything you asked wrongly. Measure inside the shader. Both traps, with
   the specific cases, are in docs/rcs-thrusters.md ▸ Footguns.
4. **The avatars' bind pose is a POSE, not the rest pose**, and the `.blend` sources are
   **not in git**. Both characters export in POSE position with a 21-bone stance live; that
   stance *is* the bind pose in Unity. It is pinned in
   `Tools/blender/golden/*_export_pose.json` and restored by `Tools/blender/export_avatar.py`,
   which is the only sanctioned way to export. Renaming a bone additionally breaks every scene
   reference to it, silently, because Unity derives file IDs from names — that needs the
   two-part procedure in docs/rigging.md. Back a `.blend` up before writing to it.

## Repo layout

Git root is one level up (`exegesis_social_VR/.git`); the Unity project is the
`exegesis_vrc_avatars/` subdirectory.

---
*Claude Code auto-loads `CLAUDE.md`, which just `@import`s this file. Edit **this** file
(`AGENTS.md`), not `CLAUDE.md`.*
