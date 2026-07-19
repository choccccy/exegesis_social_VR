# docs

Project documentation for the exegesis ncho VRChat avatar (Unity 2022.3.22f1, BiRP).

- **[project.md](project.md)** — repo layout, Unity/render pipeline, VRChat property
  contract, and the "check the lockfile before headless Unity" rule. Start here.
- **[testing.md](testing.md)** — the HUD shader regression test suite: EditMode +
  golden-image tests, the headless-clone workflow, and hard-won gotchas.
- **[hud-shader.md](hud-shader.md)** — HUD shader architecture, render model,
  animation-contract properties, cleanup targets, and the IR/radar roadmap.

`AGENTS.md` at the project root is the tool-agnostic entry point that points here.
`CLAUDE.md` is a thin file that `@import`s `AGENTS.md` (Claude Code auto-loads
`CLAUDE.md`); edit `AGENTS.md`, not `CLAUDE.md`.
