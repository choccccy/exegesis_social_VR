# Testing

Four EditMode suites, all run together from the same Test Runner or the same headless
invocation:

| Suite | Assembly | Covers |
|---|---|---|
| HUD shader | `Exegesis.HudShader.Tests.Editor` | the HUD shader — compile, material state, golden images |
| RCS thruster | `Exegesis.RcsThruster.Tests.Editor` | the RCS shader, **and the generated animator layers** |
| Callouts | `Exegesis.Callout.Tests.Editor` | the status-callout shader, rendered on the real `ncho.fbx`: screen-space size, the look-at billboard (faces the camera position, matches roll), depth push vs. walls, Centered vs. Callout layout, pixel-art sampling, mirrors (simulated planar mirror, `_VRChatMirrorMode`), two-eye stereo (default Card mode: against the projected shared card; Match HUD mode: same view direction in both eyes), the stereo-instanced compile, and the `ncho_callouts` mesh contract. See [callouts.md](callouts.md) |
| — | — | see [Animator generation tests](#animator-generation-tests) below |

Most of this page is about the HUD suite, which came first. The animator tests are the
newer half and are summarised in their own section; the full account of what they pin and
why lives in [animator-generation.md](animator-generation.md).

## HUD shader testing

A regression test suite that **pins the current behavior** of the HUD shader so
future edits (cleanup, then the IR/radar features) can't silently break it. Written
because the shader is being refactored and we want backend-style TDD confidence on a
graphics asset.

- **Unity:** 2022.3.22f1 LTS, Built-in Render Pipeline (BiRP).
- **Framework:** Unity Test Framework (NUnit), pinned in `Packages/manifest.json`
  (`com.unity.test-framework`). EditMode only.
- **Tests live in:** `Assets/_exegesis/HUD_shader/Tests/Editor/`
  (assembly `Exegesis.HudShader.Tests.Editor`).

## What the tests cover

| File | Pins |
|---|---|
| `ShaderCompileTests.cs` | Shader is found, `isSupported`, **zero compile errors** (`ShaderUtil.GetShaderMessages`), single pass. Catches any cginc/shader edit that breaks compilation. |
| `MaterialStateTests.cs` | `ncho_HUD.mat` binds the HUD shader, render queue = `Transparent+3` (3003), all 12 **animation-contract** properties exist by name, and a slice of saved float defaults. |
| `GoldenImage/` | Renders the HUD to a RenderTexture in several material states and diffs against checked-in baseline PNGs. The only layer that catches *visual* regressions that still compile. |

`MaterialStateTests` deliberately does **not** assert `_Cutoff` etc. — those are stale
values serialized in the `.mat` from an old template and are **not declared by the
shader**, so `Material.HasProperty` is (correctly) false for them.

## Animator generation tests

In `Assets/_exegesis/thruster_shader/Tests/Editor/`, alongside the RCS shader tests. They
inspect `ncho_fx.controller` — the committed asset, not an avatar built in memory — which is
the whole reason the generator tools write into a real file rather than generating at build
time. See [animator-generation.md](animator-generation.md) for what each invariant is for.

| File | Pins |
|---|---|
| `SlotParameterTests.cs` | Slot layers exist, slot ints are typed `Int`, gates use `Equals`/`NotEqual` only, the 0.25 s fade with `hasFixedDuration`, swaps route through `idle`, Write Defaults off, no two members share a value. |
| `GeneratedClipTests.cs` | Every generated clip writes at least one curve, and each `_GroupEnable` gate pair drives its component to both 0 and 1 on **both** `Body` and `Props`. |
| `ControllerSnapshotTests.cs` | Each committed FX controller matches its golden snapshot (one case per avatar in `FxControllers`), **and** the snapshot itself can detect each of 17 specific breakages. |
| `GeneratorIdempotenceTests.cs` | Rebuilding each committed controller reproduces it exactly (one case per avatar), rebuilding twice does not grow the file, and a fresh build saves generated clips with their editor curves written out (so the file doesn't change the next time anything saves it). |
| `WingDeployTests.cs` | No avatar's `wing_deploy` conditions on `rcs`, which would deploy the wings on every load with their plumes off. |
| `WriteDefaultsTests.cs` | Every state in every FX controller is Write Defaults OFF, hand-built layers included. |
| `AvatarDefinitionTests.cs` | Every controller has an avatar definition, and it is valid: clips exist, states and defaults resolve, no duplicate names, every parameter a layer or menu uses is declared with the right type, and no retired parameter is declared. |
| `ExpressionTests.cs` | Each avatar's committed expression parameters and menus are exactly what its definition generates, every expression parameter exists on the FX controller with the right type, and shared menus agree. |

### The controller snapshot

`ControllerSnapshot` (in `Exegesis.Shared.Editor`) serialises an `AnimatorController` to
canonical text: parameters, layer weights and blending, every state field, every transition
field including interruption settings, conditions with their modes, blend trees including
`m_NormalizedBlendValues`, state machine behaviours, and full clip curve data. It excludes
node positions, GUIDs and the random suffix Animator As Code puts on generated asset names —
each exclusion is commented in the source with its reason.

There is one committed baseline per FX controller, `Tests/Editor/Baselines/<avatar>_fx.snapshot.txt`,
for every entry in `FxControllers` (ncho, lemaitre, obi-me). A missing baseline **fails** rather than
being ignored: a controller with no baseline is how lemaitre and obi-me drifted unnoticed. Baselines are
written in *Compact* detail: clip curve data is hashed rather than inlined, because the controller references over
a hundred clips and a baseline nobody can read is a baseline nobody reviews. A changed
keyframe still fails — `CompactDetail_StillNoticesAChangedKeyframe` pins that.

Re-bless with `Tools > Exegesis > Debug > Capture Controller Snapshot Baselines` (all of them), or headlessly
by setting `EXEGESIS_CAPTURE_SNAPSHOT=1`. It is deliberately **not** wired to the
`HUD_CAPTURE_BASELINES` variable the run script's `-Capture` switch sets: the golden-image
suites share that one, and re-blessing the controller as a side effect of recapturing a render
would be silent, since a rewritten baseline never fails.

Re-bless *deliberately*. Every layer is generated now, so a baseline diff should come only from
a change you made to a layer's code, and should contain only that change. Anything else in the
diff means something moved that should not have.

### The negative control

`Snapshot_DetectsInjectedDifference` builds a small synthetic controller, breaks it in one
specific way, and requires the snapshot to notice. Seventeen cases, each named for the failure
it stands guard against: *layers stop stacking*, *the accessory fade is dropped*, *Equals
becomes If and never matches an Int*, *Direct trees average instead of summing*, *a preset
stops self-resetting loadout*, and so on.

This exists because a snapshot that quietly captures nothing compares equal to everything and
passes forever, which is indistinguishable from a perfect result right up until something
breaks in the headset. **If one of these cases ever starts passing without its mutation, the
snapshot has gone blind — add the property to `ControllerSnapshot`, do not delete the case.**

## Golden-image workflow

1. **Capture baselines on the CURRENT (known-good) shader**, then eyeball them, then
   commit. Two ways:
   - In-Editor: `Tools > Exegesis > Debug > Capture HUD Golden Baselines`.
   - Headless: run the suite with env `HUD_CAPTURE_BASELINES=1` (the run script's
     `-Capture` switch) — the golden test writes the baseline instead of comparing.
2. Baselines are committed PNGs in `Tests/Editor/GoldenImage/Baselines/`. They are the
   source of truth.
3. Every later run **compares**; a pixel change beyond tolerance fails the test.
4. Re-capture only for an **intentional** visual change — and say why in the commit.

Determinism (see `HudRenderHarness.cs`): fixed perspective, mono, **non-oblique** camera
(orthographic breaks the HUD's `xy/z` screen projection; an oblique/mirror projection
makes `_MirrorMode=1` cull it), fixed RenderTexture size (aspect ratio affects the
screen-space UVs), and all time-based effects zeroed (`_HUDDriftRadius`,
`_StatusBarNJitter`, shakes/wobbles). Tolerances (`HudGoldenImageTests`): per-channel
delta ≤ 8/255, ≤ 0.5% of pixels may differ — absorbs GPU/driver noise without hiding
real changes. Failing renders are dumped to `%TEMP%/hud_golden_failures/` for inspection.

The states rendered are defined once in `GoldenImage/HudGoldenStates.cs` (used by both
the tests and the capture menu): `default_all` (the primary pin), plus status-bars
on/off/full, paper-doll off/touch, secondary-overlay on, and half-opacity — all rendered
over a solid clear (no `Background`). The scanner states (`scan_normals`, `scan_edges`,
`scan_range`, `scan_all`) set `Background = true`, which makes `HudRenderHarness` render a
few fixed **shadow-casting** cubes (Standard shader) plus a shadow-casting directional light
behind the HUD — this forces `_CameraDepthTexture` to populate in-editor (only shadow-caster
geometry appears in depth), giving the depth-driven scanner real geometry to read. Scanner
states must therefore be captured/compared with depth forced; scanner-off states leave
`Background` false so their baselines stay valid over the plain clear.

## Running the tests

### In the Editor (simplest)
`Window > General > Test Runner` → **EditMode** → Run All. Golden capture/compare works
here because the Editor has a GPU.

### Headless (no need to touch an open Editor) — the clone workflow

**You cannot run headless against the project folder while the Editor has it open** —
Unity takes an exclusive lock (`Temp/UnityLockfile`) and a second `Unity.exe -batchmode`
on the same folder fails (and concurrent instances can corrupt `Library/`). So headless
runs go against a **separate clone** with its own `Library/`.

Script: [`Tools/headless-tests/run_headless_tests.ps1`](../Tools/headless-tests/run_headless_tests.ps1).
It (1) mirrors the project into the clone (robocopy `/MIR`, excluding `Library/Temp/Logs`
so the clone keeps its warm import cache), (2) launches Unity `-runTests`, (3) waits on
the result artifact, (4) summarizes pass/fail.

```powershell
# compare against committed baselines (normal regression run)
powershell Tools/headless-tests/run_headless_tests.ps1

# (re)capture baselines from the current shader
powershell Tools/headless-tests/run_headless_tests.ps1 -Capture

# reuse the clone as-is (skip the mirror), or filter, or extend the wait
powershell Tools/headless-tests/run_headless_tests.ps1 -SkipSync
powershell Tools/headless-tests/run_headless_tests.ps1 -TestFilter Exegesis.HudShader.Tests.ShaderCompileTests
powershell Tools/headless-tests/run_headless_tests.ps1 -MaxMinutes 45
```

- **Clone location** (default): `<...>/unity/exegesis_headless_clone` (sibling of the
  git repo). First run does a full asset import (slow, one-time; this project is ~360 MB
  so it's minutes, not tens of minutes). Later runs reuse the warm `Library/` and are fast.
- **Baselines captured in the clone** must be copied back into the working tree to be
  committed: `robocopy <clone>/…/Baselines <repo>/…/Baselines *.png`. Once they're in the
  working tree, the mirror keeps them in sync (it won't purge them).
- Results XML: `<clone>/hud_test_results.xml`. Unity log: `<clone>/hud_headless.log`.

### Generating `.meta` files headlessly

New assets under `Assets/` need Unity-generated `.meta` files before they're committed
(committing a `.cs`/`.png`/`.asmdef` without its `.meta` causes GUID churn and
"missing meta" noise). Normally the open Editor writes these on focus / `Assets > Refresh`.
To do it without the GUI:

```powershell
powershell Tools/headless-tests/refresh_assets.ps1          # refresh MAIN (Editor must be CLOSED)
powershell Tools/headless-tests/refresh_assets.ps1 -Clone   # refresh the headless clone
```

It runs `Unity -batchmode -quit -projectPath <target>`, which imports pending assets and
writes their `.meta`, then quits (fork-aware wait, same as the test runner).

**Same lock constraint as the tests:** it refuses to run against a project a live Editor
already has open (it would fail on the lock). So it covers the **clone** (never opened in
the Editor) and **MAIN only while its Editor is closed**. While the Editor holds MAIN,
that Editor is the only thing that can refresh MAIN — focus it or hit `Assets > Refresh`.

## Clean-room install test

Checks that a release `.unitypackage` imports cleanly into a fresh project that has **only the
README requirements**. That covers what the regression suites can't: a README missing a
requirement, a reference to a file that doesn't ship, a step that doesn't work. Run it before
tagging a release that adds dependencies or moves assets. Safe while the Editor is open; it never
touches this project.

Script: [`Tools/install-test/run_install_test.ps1`](../Tools/install-test/run_install_test.ps1).

```powershell
# build the package to test (or download a published one with: gh release download <tag>)
python Tools/release/build_unitypackage.py --root Assets/_exegesis --root Assets/Editor/Poi_PS1 --out $env:TEMP\exegesis.unitypackage

# full package against the main README's requirements, plus the PS1 install step
powershell Tools/install-test/run_install_test.ps1 -Package $env:TEMP\exegesis.unitypackage -EnablePS1

# props package against only the props README's requirements (its own baseline via -Name)
powershell Tools/install-test/run_install_test.ps1 -Package <props>.unitypackage `
    -Name exegesis_install_test_props -FinalIkPackage "" `
    -VpmPackages com.vrchat.core.vpm-resolver,com.vrchat.base,com.vrchat.avatars,com.vrcfury.vrcfury
```

What it does:

1. **Deps baseline** (`<dev>/exegesis_install_test_deps_baseline`, built once, `-RebuildDeps` to
   redo): the VCC *Avatar* template, the README's VPM packages copied from this project's
   `Packages/` as embedded packages (what VCC/ALCOM does), then Poi Pro 11.0.27 and the VRLabs
   FinalIK stub by `-importPackage` from `~/Downloads`. It must compile with zero errors, or the
   test setup itself is broken. Note the packages are this project's installed versions, which
   meet the README minimums but aren't exactly them.
2. **Test project** (`<dev>/exegesis_install_test`), mirrored fresh from the baseline each run.
3. **Import + check.** [`checker/InstallCheck.cs`](../Tools/install-test/checker/InstallCheck.cs)
   reports, for everything under `Assets/_exegesis` and `Assets/Editor/Poi_PS1`:
   - every `guid:` that resolves to nothing
   - materials on a missing or error shader
   - missing scripts and missing prefabs, in every prefab and every scene
   - the avatars found in each scene
4. **`-EnablePS1`**: [`poi_step/`](../Tools/install-test/poi_step/InstallCheckPs1Step.cs) does README
   step *Poi > Installed Modules > PS1 > Apply & Rebuild Shaders*. It lists the PS1 materials
   before (all `MISS`) and after (all `OK`).

Output (report and every Unity log) goes to `<dev>/exegesis_install_test_out/`. Reading the
report: an unresolved GUID that also resolves to nothing in *this* project was already broken
here (the release preview lists these as `unknown`). That's a bug, but not an install hole. One
that resolves here but not there is a hole: a missing requirement, or a file that doesn't ship.

**Negative control.** A checker that finds nothing has to be shown it *can* find something.
Run once with a dependency left out (e.g. `-Name exegesis_install_test_negctl` with VRCFury dropped
from `-VpmPackages`). It must report missing scripts on the screwdrivers, `rober_sps` and the
avatars. Done 2026-11; it did.

Gotchas specific to this setup:

- **Use the VCC template, not `Unity -createProject`.** The bare project has no
  `com.unity.test-framework`, and the VRChat SDK's own tests then fail to compile with NUnit errors.
- **A compile error silently skips `-importPackage` and `-executeMethod`.** Batchmode still exits
  normally and nothing is imported. The script fails on any `error CS` in a log for this reason.
- **The FinalIK stub needs a second load.** It ships its scripts as `*.no` and an installer that
  renames them on the next domain load.
- **Poi's `ModularShadersGeneratorWindow.RebuildShaders` does nothing in batchmode.** It defers
  through `EditorApplication.delayCall`, which never fires before `-quit`. Call
  `ShaderGenerator.GenerateShader` directly, as Poi's Modules Toggles does.
- **Deleting packages from a project with a built `Library/`** gives a burst of `CS2001` (source
  file not found) on the next open. It's harmless and clears on the following open. Build a
  separate baseline (`-Name`) instead of trimming one.
- Each test project is ~2-3 GB with its `Library/`. Delete `<dev>/exegesis_install_test*` when done.

## Gotchas learned the hard way (don't rediscover these)

- **`Unity.exe` forks and the launcher returns immediately.** A synchronous
  `& Unity …` call returns (often with a nonzero code like 3) while the real editor
  keeps running. Never trust the launcher's exit code — wait on the **results artifact**
  (or a `Unity.exe` process whose command line contains the clone path). The run script
  already does this.
- **Detach the RenderTexture before releasing it.** In the render harness, set
  `camera.targetTexture = null` and destroy the camera *before* `rt.Release()`, else
  Unity logs `Releasing render texture that is set as Camera.targetTexture!` — and the
  Test Framework **fails any test that logs an unexpected error**, even though the image
  was fine.
- **Batchmode rendering works** on Windows with a GPU — do **not** pass `-nographics`
  if any test renders (it would blank the goldens).
- **PowerShell 5.1 reads `.ps1` as ANSI.** Non-ASCII characters (em dash, curly quotes)
  become mojibake and cause parse errors. Keep scripts ASCII-only.
- **robocopy exit codes < 8 are success** (1 = files copied, 3 = copied + extras purged).
  PowerShell surfaces any nonzero as a failure — check for `>= 8`, not `!= 0`.
- **`.asmdef` test assemblies can't reference the predefined `Assembly-CSharp-Editor`.**
  To unit-test the `HUD_inspector` ShaderGUI logic, the inspector must be moved into its
  own asmdef first (planned for the cleanup refactor).
