# Notes for agents

Notes for any AI agent (or human) working on this repo. Tool-agnostic — read this
regardless of which assistant you are. Full docs live in [`docs/`](docs/).

VRChat avatar Unity project ("ncho"), **Unity 2022.3.22f1 LTS, Built-in Render Pipeline**.

## Read these

- **[docs/project.md](docs/project.md)** — repo layout, Unity/BiRP, build/test entry points.
- **[docs/hud-shader.md](docs/hud-shader.md)** — the custom HUD shader (current focus).
- **[docs/rcs-thrusters.md](docs/rcs-thrusters.md)** — the RCS thruster shader + its FX layers.
- **[docs/testing.md](docs/testing.md)** — regression test suite + headless-clone workflow.

## Two things that will bite you if you forget

1. **The Unity Editor is usually open on this project.** You CANNOT run a headless
   `Unity.exe -batchmode` against this folder while it's open (exclusive lock; risks
   `Library/` corruption). Check `exegesis_vrc_avatars/Temp/UnityLockfile` / running
   `Unity.exe` first. Headless tests and asset refreshes run against a separate clone —
   see docs/testing.md (`Tools/headless-tests/`).
2. **Material properties are a VRChat contract.** Animations drive shader properties by
   name; renaming a driven one silently breaks the avatar. The HUD shader's do-not-rename
   list is in docs/hud-shader.md. Grep `.anim`/`.controller` before renaming anything.

## Repo layout

Git root is one level up (`exegesis_social_VR/.git`); the Unity project is the
`exegesis_vrc_avatars/` subdirectory.

---
*Claude Code auto-loads `CLAUDE.md`, which just `@import`s this file. Edit **this** file
(`AGENTS.md`), not `CLAUDE.md`.*
