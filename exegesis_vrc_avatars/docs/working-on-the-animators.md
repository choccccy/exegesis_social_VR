# Working on the animators

**Start here** if you're about to change anything about how an avatar behaves: a toggle, a
layer, a parameter, a menu entry. This is the practical guide. The design reference, covering
why things are the way they are and the invariants the tests pin, is
[animator-generation.md](animator-generation.md).

## The one-minute version

- The avatars' **FX controllers, their parameters, the VRChat expression parameters and the
  expression menus are all generated from C#**, under `Assets/_exegesis/fx/Editor/`.
- **Never edit them in Unity**: not in the Animator window, and not in the menu or parameter
  inspectors. Edit the code, then run **`Tools > Exegesis > Build FX Controllers`**.
- **Every build starts from an empty controller.** Anything not declared in code is gone after
  the next build. To stop work being lost that way, the builder **refuses to build** if it finds
  a layer or parameter it doesn't know about, and tells you what it found.
- **Tests compare the committed controllers against text snapshots.** A deliberate change means
  re-capturing ("re-blessing") the snapshot and reviewing its diff, which should contain your
  change and nothing else.

## What is code and what isn't

| Generated from code (don't edit by hand) | Still authored by hand |
|---|---|
| `*_fx.controller`: every layer, state, transition and parameter | Animation clips (`.anim`): poses, toggles, material values |
| `*_params.asset`: expression parameters (sync, save, defaults) | Meshes, materials, shaders |
| `*_menu.asset`: every expression menu | The scene: avatar descriptors, contacts, PhysBones |
| | VRCFury components and their prefabs, which add things at upload |
| | The other playable layers (Base, Gesture, Action…): VRChat defaults |

The RCS thruster clips are the one exception in the clip column: `RcsAnimatorSetup` generates
them, as sub-assets of each controller.

## Where things are

```
Assets/_exegesis/fx/Editor/
  FxBuilder.cs              the menu item and the build: check, empty, rebuild, write expressions
  LayerSpec.cs              how a layer is written: states, transitions, drivers; Shapes.Toggle / Neutral
  ParamSpec.cs              how an animator parameter is written
  ExpressionSpec.cs         how expression parameters and menus are written
  AvatarLayers.cs           turns LayerSpecs into layers (Animator As Code)
  ExpressionsBuilder.cs     turns ExpressionSpecs into the .asset files
  Avatars/
    NchoAvatar.cs           ncho:     Parameters(), Expressions(), Layers()
    LemaitreAvatar.cs       lemaitre: same shape
    ObiMeAvatar.cs          obi-me:   same shape, plus its manipulator / head-cam layers
    CommonLayers.cs         layers more than one avatar has: baselines, panels, props, HUD, touch…
    CommonLayers.Heat.cs    the heat system and batt_control (rates per avatar: HeatRates)
    CommonLayers.Body.cs    blink, eyes, ears, blushie, tail, tool holster, panel tool
    CommonParameters.cs     animator parameter blocks every avatar declares; Retired
    CommonExpressions.cs    expression parameters every avatar has; shared menus; Icons
    Clips.cs                clip paths by folder
    AvatarDefinition.cs     what ties an avatar together, and its validation

Assets/_exegesis/ncho/Editor/NchoSlotSetup.cs              the slot_* layers (accessory mounts)
Assets/_exegesis/thruster_shader/Editor/RcsAnimatorSetup.cs the rcs_* layers (thrusters)
Assets/_exegesis/shared/Editor/FxControllers.cs            the list of avatars and their controllers
Assets/_exegesis/thruster_shader/Tests/Editor/             the tests and Baselines/
```

To find where a layer comes from, search its name in `fx/Editor/Avatars/`. `slot_*` and `rcs_*`
layers come from the two tools above.

## The loop

### In the Editor (a human, or anyone with the project open)

1. **Edit the code.**
2. **`Tools > Exegesis > Build FX Controllers`.** If the Console shows "not built" or
   "expressions not written", see [When the build refuses](#when-the-build-refuses).
3. **Run the tests:** `Window > General > Test Runner`, EditMode, Run All. Expect
   `CommittedController_MatchesGolden` to fail for every avatar your change touched. The
   snapshot still holds the old controller.
4. **Re-bless:** `Tools > Exegesis > Debug > Capture Controller Snapshot Baselines`.
5. **Review the baseline diff in git**
   (`Assets/_exegesis/thruster_shader/Tests/Editor/Baselines/*_fx.snapshot.txt`). It should show
   your change and only your change. If something else moved, stop and find out why.
6. **Run the tests again.** All green, apart from known failures (the HUD scan golden images,
   issue #53).
7. **Commit together:** code, controllers, `.asset` files, baselines, and any new `.meta` files.

A change to a layer in `CommonLayers` reaches every avatar that uses it, so expect all three
baselines to change.

### Headless, through the clone (an agent, or when the Editor is open)

The Unity Editor is usually open on this project, and you **cannot** run Unity in batch mode
against an open project. Use the separate clone instead; [testing.md](testing.md) has the full
details. Short version, in PowerShell:

```powershell
$t = "exegesis_vrc_avatars\Tools\headless-tests"
$u = "C:\Program Files\Unity\Hub\Editor\2022.3.22f1\Editor\Unity.exe"
$c = "C:\Users\choccy\dev\exegesis_headless_clone"

# 1. sync your working tree into the clone, compile, run the animator tests
& "$t\run_headless_tests.ps1" -TestFilter "Exegesis.RcsThruster.Tests"

# 2. build the controllers and expressions IN THE CLONE
& $u -batchmode -projectPath $c -executeMethod Exegesis.Fx.FxBuilder.BuildAllFromCommandLine -logFile "$env:TEMP\fxb.log"

# 3. re-capture the controller baselines in the clone (NOT -Capture: that one is the HUD images)
$env:EXEGESIS_CAPTURE_SNAPSHOT = "1"
& "$t\run_headless_tests.ps1" -SkipSync -TestFilter "ControllerSnapshotTests"
Remove-Item Env:EXEGESIS_CAPTURE_SNAPSHOT

# 4. full suite against the built clone
& "$t\run_headless_tests.ps1" -SkipSync
```

Then:
- **Copy the new baselines back** from the clone's `Baselines/` folder into the working tree and
  review their diff.
- **Copy the `.meta` file of any new `.cs` file back too.** Unity creates it in the clone, and it
  has to be committed with the file.
- **Don't copy controllers or `.asset` files into a project that has the Editor open.** Ask
  whoever has it open to run Build FX Controllers there; it produces the same result.
- **Watch the next run.** Syncing the clone overwrites it with the working tree, so an unbuilt
  working tree fails the snapshot tests again until the Editor build happens.

Other headless tips:
- The build exits with code 1 if any avatar failed.
- `-fxOnly ncho` builds only one avatar.
- The test script writes its log to the clone's `hud_headless.log`. Search it for `error CS`
  when a run "passes" suspiciously quickly or compiles nothing.

## Writing layers

A layer is a `LayerSpec`. Write it the way the Animator window would show it: states, then
transitions, then the default state.

```csharp
using static Exegesis.Fx.Cond;     // If, IfNot, IntEq, Gt, …
using static Exegesis.Fx.Shapes;   // Toggle, Neutral, S

new LayerSpec("transponder")
    .State("transponder_off", Clips.Ncho("transponder_off"))
    .State("transponder_on", Clips.Ncho("transponder_on"))
    .Go("transponder_off", "transponder_on", 0f, If("transponder"), If("IsOnFriendsList"))
    .Go("transponder_on", "transponder_off", 0f, IfNot("transponder"))
    .Default("transponder_off");
```

Then add it to the avatar's `Layers()` with a `yield return …;` at the position it should have,
since **list order is layer order** (lower layers win). For a layer more than one avatar needs,
put a method in `CommonLayers` and call it from each avatar file.

### LayerSpec reference

| Call | Meaning |
|---|---|
| `new LayerSpec(name)` | A layer. Names must be unique and must not start `slot_` or `rcs_` (those prefixes belong to the two tools). |
| `.WithWeight(w)` | Layer weight. Default 1. |
| `.State(name, clip, speed: 1, mirror: false, motionTime: null)` | A state playing `clip` (a path; use `Clips.*`). `motionTime: "param"` makes a float parameter drive the clip's normalized time, turning the clip into a lookup table. States are created in this order. |
| `.Drives(localOnly, Drive.Set(p, v), Drive.Add(p, v))` | Gives the **last added state** a VRChat parameter driver, which runs once on entering the state. `localOnly` runs it for the wearer only. |
| `.Go(from, to, seconds, conditions…)` | A transition. All conditions must hold (AND). Several `Go`s from one state are checked **in the order written**; the first that passes wins. |
| `.Exit(from, seconds, conditions…)` | A transition to Exit, which re-enters at the default state. |
| `.AfterExitTime(t)` | Gives the **last added transition** an exit time. `t` is **normalized** (1.0 = one full play of the clip), not seconds. |
| `.NotFixedDuration()` | Makes the last transition's duration normalized instead of seconds. Rarely wanted. |
| `.Default(state)` | Required whenever the layer has states. |

Conditions (`Exegesis.Fx.Cond`): `If(bool)`, `IfNot(bool)`, `IntEq(int, n)`, `IntNe(int, n)`,
`IntGt`, `IntLt`, `Gt(float, x)`, `Lt(float, x)`. There's no OR inside one transition; write two
`Go`s for an OR.

Shapes (`Exegesis.Fx.Shapes`):
- **`Neutral(layer, state, clip, mirror:, motionTime:)`:** one always-on state, the baseline other
  layers override.
- **`Toggle(layer, param, fadeSeconds, whenTrue: S(...), whenFalse: S(...), trueFirst:, startTrue:)`:**
  two states on one bool, one transition each way. `S(name, clip, speed:, mirror:, motionTime:)`
  describes a state. `trueFirst` and `startTrue` only fix state order and the default state; the
  existing layers aren't consistent about either.

There is **no Write Defaults option**; every state is Write Defaults off. See the gotchas below.

## Declaring parameters

Two separate lists per avatar. They're different things, and both are needed for anything
driven from a menu:

| | Animator parameter | Expression parameter |
|---|---|---|
| What it is | A variable the FX controller reads | What VRChat syncs, saves and shows to menus and OSC |
| Declared in | the avatar's `Parameters()`, mostly via `CommonParameters` | the avatar's `Expressions()`, mostly via `CommonExpressions.Parameters()` |
| Written as | `ParamSpec.Bool("name", default)` / `Int` / `Float` | `ExpressionParam.Bool("name", default, saved: true, synced: true)` / `Int` / `Float` |
| Default that applies in VRChat | only if there's no expression parameter | **this one** |

The build checks that every expression parameter exists as an animator parameter with the same
type, and that every parameter a layer uses is declared.

Some parameters aren't in either list:
- **The slot and RCS tools declare their own** (`back_slot`, `thigh_slot`, `loadout`, `rcs`,
  `RCS_*`, …). Don't add those to an avatar's `Parameters()`; they still need expression
  parameters if a menu drives them.
- **VRChat built-ins** (`IsLocal`, `GestureRight`, `Voice`, …) are declared as animator
  parameters in `CommonParameters.BuiltIns()`, never as expression parameters.

## Writing menus

```csharp
new MenuSpec("Assets/_exegesis/ncho/ncho_anim/ncho_back_menu.asset")
    .Toggle("Thruster Backpack", "back_slot", 1f)              // sets back_slot = 1 while on
    .Toggle("Arm Backpack", "back_slot", 2f)
    .Button("Bare", "loadout", 1f)                             // sets it while held
    .SubMenu("Thighs", thighsMenu, Icons.Get("icons8-gear-96"));
```

- **`MenuSpec(path, parametersAsset)`** names the menu's `.asset`. It's created if missing,
  otherwise filled in place. `parametersAsset` is only what the inspector uses for dropdowns;
  VRChat ignores it.
- **The icon argument** is a path; use `Icons.Get("file-name-without-.png")` for files in
  `Assets/_exegesis/icons/`.
- **VRChat shows at most 8 controls per menu**, and the build refuses more. **Config and ncho's
  Panels are already full**, so a new entry needs another menu or a new submenu.
- **Some menus are shared assets:** `CommonExpressions.Config()`, `Expression()` and `NchoPanels()`
  appear in more than one avatar's tree. Change them in `CommonExpressions`, and every avatar
  using them changes too.

## Recipes

### Add a new on/off toggle (say, a visor)

1. **Author the clips:** `visor_on.anim` and `visor_off.anim`, each setting the property
   explicitly. With Write Defaults off, "off" has to *set* off unless a neutral layer below
   already does.
2. **Animator parameter:** add `ParamSpec.Bool("visor")` to `CommonParameters.Body()` (every
   avatar) or to one avatar's `Parameters()` extras.
3. **Expression parameter:** add `ExpressionParam.Bool("visor", saved: true)` to
   `CommonExpressions.Parameters()` or to one avatar's `Expressions()` parameter list.
4. **Menu entry:** add `.Toggle("Visor", "visor")` to a menu with room (not Config or Panels).
5. **Layer:**
   ```csharp
   Toggle("visor", "visor", 0.25f,
          whenTrue:  S("visor_on",  Clips.Ncho("visor_on")),
          whenFalse: S("visor_off", Clips.Ncho("visor_off")),
          trueFirst: false, startTrue: false)
   ```
   Add it as `yield return` in each avatar's `Layers()`, or as a `CommonLayers` method called from
   each.
6. **Run the loop.** Expect the baseline diff to show the new parameter and the new layer.

### Change a timing, threshold or rate

Edit the number in the spec: a `Go` duration, a `Gt`/`Lt` threshold, an `AfterExitTime`, or
`HeatRates` for heating and cooling speeds (obi-me has its own in `ObiMeAvatar.Rates`). Run the
loop. The baseline diff should be that one value.

### Give one avatar something different

- **A different clip or rate:** pass it as an argument. That's why many `CommonLayers` methods
  take a clip.
- **A layer only one avatar has:** write it in that avatar's file. See `ObiMeAvatar.Manipulator`.
- **A different version of a shared layer:** add a second method. See `WingDeploy()` and
  `WingDeployWithSensors()`.

Don't branch on the avatar's name inside `CommonLayers`.

### Move or remove a layer

- **To move a layer,** move its `yield return` line.
- **To remove a layer,** delete its line.

Either way, run the loop. The builder deletes a layer that's no longer declared without
complaint, because it's rebuilding from empty and nothing declares it.

### Remove a parameter

1. Delete its `ParamSpec`, and its `ExpressionParam` and menu entries if any.
2. Add its name to `CommonParameters.Retired`. Otherwise the builder refuses to delete it from
   the existing controllers, by design.
3. Run the loop, then commit.

Before removing one, check nothing else uses it: VRCFury components, contacts and PhysBones in
the scene and prefabs, and OSC. Search `Assets/` for the bare name (the `.unity`, `.prefab` and
`.asset` files are text). Matches in the scene's Gesture Manager cache are animator *state*
names, not parameters. That's how the four retired accessory bools were cleared.

### Add an accessory to a mount point

Accessories are the slot tool's job, not a `LayerSpec`. Follow
[accessories.md ▸ Adding an accessory](accessories.md#adding-an-accessory).

### Change the thrusters

Edit `RcsAnimatorSetup.cs` and read [rcs-thrusters.md](rcs-thrusters.md) first; its Footguns
section has cost real hours.

### Add a new avatar

1. **Register it:** add an `FxController` line to `FxControllers` (`shared/Editor/FxControllers.cs`).
2. **Define it:** add `<Name>Avatar.cs` in `fx/Editor/Avatars/`, copying an existing one, and list
   it in `Avatars.All` (`AvatarDefinition.cs`).
3. **Make sure its assets exist:** a controller asset (an empty one is fine), and its descriptor in
   the scene pointing at that controller, its params asset and its main menu. The builder
   creates a missing parameters asset or menu asset at the path the definition names, but not the
   controller, and it never touches the scene: wire the descriptor to the assets yourself after
   the first build.
4. **Before the first build, capture a baseline** if the controller already has content, so its
   first rebuild shows a reviewable diff instead of a fresh snapshot you'd just accept.
5. **Run the loop.**

## Gotchas

- **Write Defaults is off everywhere.** A state writes only what its clip animates; everything
  else keeps its last value, or falls through to a lower layer. "Off" states either play a clip
  that sets the value, or rely on a `*_neutral` layer below.
- **An empty clip writes nothing.** `Clips.Empty` (`_Empty.anim`) is the "do nothing" state.
  It's zero-length, which Unity times as **1 second** for exit-time purposes. That's why the heat
  pulses tick about every 1.1 s.
- **Int parameters need `IntEq`/`IntNe`.** `If`/`IfNot` on an Int never matches and nothing
  warns you. The build's type check catches it in `LayerSpec`s.
- **Transition order is evaluation order.** Several `Go`s from one state are tried top to bottom.
- **Exit times are normalized,** not seconds: `AfterExitTime(9f)` on a 0.17 s clip waits 1.5 s.
- **Conditions are strict.** `Gt("heat", 0.85f)` is false at exactly 0.85. See `heat_radiation`
  for how the existing layers close that gap.
- **Expression defaults beat animator defaults** in VRChat. Several differ on purpose, or at
  least on record (see animator-generation.md).
- **Parameter names are a contract** with saved user values, VRCFury and OSC. Renaming one resets
  everyone's saved value. Grep the scene before renaming.
- **Material property names are a contract too.** Animations drive shader properties by name.
  See the project's AGENTS.md.
- **The builder deletes anything undeclared, but only after a check.** If it refuses, read the
  message (see below) instead of working around it.
- **A new `.cs` file needs its `.meta` committed.** Unity creates the `.meta`; headless, it
  appears in the clone and has to be copied back.

## When the build refuses

The build changes nothing when it refuses. The Console (or the headless log) lists every
problem; the menu dialog lists which avatars weren't built.

| Message contains | Meaning | Fix |
|---|---|---|
| `layer 'X' is in the controller but no code declares it` | Someone added a layer in the Animator window, or a layer was renamed in code. | Write it as a `LayerSpec` (port it), or discard it with `git checkout` on the controller. |
| `parameter 'X' is in the controller but no code declares it` | Same, for a parameter. | Declare it, or add it to `CommonParameters.Retired` to delete it. |
| `uses 'X', which the avatar does not declare` | A layer references a parameter missing from `Parameters()`. Often a typo. | Fix the name, or declare it. |
| `uses 'X' as Int, but it is declared Bool` (or similar) | Wrong condition helper, or wrong declaration. | `If`/`IfNot` are for bools, `IntEq`… for ints, `Gt`/`Lt` for floats. |
| `plays a missing clip` / `slot tool: missing clip` | A clip path is wrong, or the clip was moved or deleted. | Fix the path (`Clips.*`), or restore the clip. |
| `has states but no default state` / `default state 'X' does not exist` | Missing or misspelled `.Default(...)`. | Fix it. |
| `transition from/to unknown state` | A `Go` names a state that wasn't added. | Fix the name. |
| `is declared, but CommonParameters.Retired says it was removed` | A retired parameter came back. | Pick a new name, or remove it from `Retired` deliberately. |
| `menu … has N controls; VRChat shows 8` | Too many controls. | Split into a submenu. |
| `is not an expression parameter, so the control does nothing` | A menu control's parameter isn't in the expression parameters. | Add an `ExpressionParam`. |
| `expression parameter 'X' is not declared on the FX controller` | It's in the expression list but not in `Parameters()`. | Declare it, or remove it from the expression list. |
| `menu … is shared by A and B, but they define it differently` | Two avatars build a shared menu asset with different contents. | Make the shared menu one `CommonExpressions` method; give an avatar its own menu asset if it really must differ. |

## When a test fails

| Test | Usually means | Fix |
|---|---|---|
| `CommittedController_MatchesGolden` | The committed controller differs from its snapshot. | Intended change: re-bless and review the diff. Otherwise: find out what changed. |
| `RebuildingTheCommittedController_ReproducesIt` | The committed controller isn't what the code builds: code changed without a build, or the controller was edited by hand. | Run Build FX Controllers. |
| `CommittedMenus_MatchTheDefinition` / `CommittedExpressionParameters_MatchTheDefinition` | Same, for the menus and expression parameters. | Run Build FX Controllers. |
| `EveryController_HasAValidDefinition` / `Expressions_AgreeWithTheController` | The same problems as the refusal table above. | See that table. |
| `Build_RefusesAndChangesNothing_…` | The builder's safety check stopped working. | Fix `FxBuilder.Preflight`, never the test. |
| `WriteDefaultsTests` | A state has Write Defaults on. | Find who turned it on; `LayerSpec` can't. |
| `WingDeploy_NeverConditionsOnRcs` | `wing_deploy` reads `rcs` again (wings out on every load). | Remove the condition. See [accessories.md](accessories.md). |
| `SlotParameterTests`, `GeneratedClipTests` | Slot or RCS invariants. | See [accessories.md](accessories.md), [rcs-thrusters.md](rcs-thrusters.md). |
| `HudGoldenImageTests` scan cases | Known failure, issue #53. | Not related to animators. |

Snapshot diffs written by the rebuild test land in `%TEMP%\rcs_controller_diff\` as
`<avatar>_committed` and `<avatar>_rebuilt`; diff those two files to see exactly what differs.
