# Animator generation

The avatars' FX controllers, their animator parameters, the VRChat expression parameters and
the expression menus are all **generated from code**, using
[Animator As Code](https://github.com/hai-vr/av3-animator-as-code) (AAC). VRCFury components stay
as modular additions on top.

> **Making a change?** Read [working-on-the-animators.md](working-on-the-animators.md) first. It
> covers the workflow, an API reference, recipes, and what to do when the build or a test
> refuses. This page is the design reference: how the generation is organised, why, and the
> invariants the tests pin.

## The builder

One entry point: **`Tools > Exegesis > Build FX Controllers`** (`Exegesis.Fx.FxBuilder`, in
`Assets/_exegesis/fx/Editor/`). It builds every avatar listed in `FxControllers`
(`Exegesis.Shared`):

| Avatar | Controller | Definition |
|---|---|---|
| ncho | `ncho/ncho_anim/ncho_fx.controller` | `fx/Editor/Avatars/NchoAvatar.cs` |
| lemaitre | `lemaitre/lemaitre_fx.controller` | `fx/Editor/Avatars/LemaitreAvatar.cs` |
| obi-me | `obi-me/obi-me_fx.controller` | `fx/Editor/Avatars/ObiMeAvatar.cs` |

FX is the only playable layer these avatars customise. Base, Additive, Gesture, Action and the
rest are VRChat defaults on every descriptor.

Headless, for the clone (see [testing.md](testing.md)):

```
Unity.exe -batchmode -projectPath <clone> -executeMethod Exegesis.Fx.FxBuilder.BuildAllFromCommandLine [-fxOnly ncho,obi-me]
```

It exits 1 if any avatar failed to load or refused to build, so a script can't mistake a
partial build for a complete one.

### What a build does, per avatar

1. **Checks, and changes nothing if any check fails** (`FxBuilder.Preflight`):
   - **the avatar's definition** (`AvatarDefinition.Problems`);
   - **the slot tool's clips;**
   - **anything in the controller that no code declares:** a layer, or a parameter. Building
     from empty would delete it, and its presence almost always means someone edited the
     controller in Unity. So the builder **refuses and names it**.

   Allowed exceptions: layers prefixed `slot_` or `rcs_` belong to those tools, which includes
   the RCS debug probe layers, and parameters in `CommonParameters.Retired` are ones code says
   to delete.
2. **Empties the controller:** every layer and every parameter (`ExegesisAac.ClearController`).
   The asset itself stays, so its GUID, which the avatar descriptors reference, never changes.
3. **Declares the avatar's parameters**, in its definition's order.
4. **Appends the avatar's layers**, in its definition's order (`AvatarLayers`).
5. **Runs the slot tool, then the RCS tool.** Each appends its layers and declares its own
   parameters. Slots go first because the RCS group layers condition on the slot ints.
6. **Writes clip editor curves out** (`AnimatorAssets.SyncEditorCurves`) and saves. Without
   this, the generated clips' bytes depend on whether anything read them before the next save,
   and the committed file churns.
7. **Writes the expression parameters and menus** (`FxBuilder.BuildExpressions`), after its
   own checks against the freshly built controller. See
   [Expression parameters and menus](#expression-parameters-and-menus).

The whole thing is idempotent: two builds in a row produce identical files.

### Why one builder for every avatar

lemaitre_fx and obi-me_fx began as **copies of ncho_fx**. The old per-tool menu items only ever
targeted ncho's path, so the other two silently froze at whatever ncho looked like the day each
copy was made. Now the builder and every per-avatar test iterate the same list, so an avatar
can't fall out of the build without a test noticing. The run order (avatar layers, then slots,
then RCS) also lives in one place, `FxBuilder.Build`.

## Order

**Layer order matters in FX:** when two layers write the same property, the lower one wins.
The order is declared in code: the avatar's layers top to bottom, as its definition lists them,
then the `slot_*` layers, then the `rcs_*` layers. The slot and RCS layers only write
`Body`/`Props` material properties and their own animator parameters, which no avatar layer
touches, so being last costs nothing.

**Parameter order doesn't matter for behaviour.** Animators, VRChat and VRCFury all address
parameters by name. It's declared in the same way, though (the avatar's, then the slot tool's,
then the RCS tool's), so snapshot diffs stay readable. Each tool declares its own parameters
(`NchoSlotSetup.ParameterNames`, `RcsAnimatorSetup.ParameterNames`), with their defaults, so
nothing is declared in two places.

**Defaults matter.** `rcs` must default to **true**: it isn't saved, so its default is its value
on every load. Since the controller is emptied first, the default a tool passes is always the one
that ends up in the controller.

## The generators

| Tool | Owns | Assembly |
|---|---|---|
| `AvatarLayers.cs` + the avatar definitions | every layer an `AvatarDefinition` lists | `Exegesis.Fx.Editor` |
| `NchoSlotSetup.cs` | `slot_*`: accessory mount points (see [accessories.md](accessories.md)) | `Exegesis.Ncho.Editor` |
| `RcsAnimatorSetup.cs` | `rcs_*`: thruster plumes (see [rcs-thrusters.md](rcs-thrusters.md)) | `Exegesis.RcsThruster.Editor` |
| `ExpressionsBuilder.cs` | the expression parameter and menu assets | `Exegesis.Fx.Editor` |

None has a menu item of its own; everything runs through the builder.

**Assemblies.** They're split on purpose:
- **The slot tool and the expressions writer need the VRChat SDK** (`VRCAvatarParameterDriver`,
  `VRCExpressionsMenu`).
- **The shader and RCS tooling must not take that dependency:** an SDK version bump would
  otherwise break the shader inspector too.
- **`Exegesis.Fx.Editor` references both,** which is why the builder lives in its own assembly.
  Its SDK-dependent files are wrapped in `#if VRC_SDK_VRCSDK3`. The data models (`LayerSpec`,
  `ParamSpec`, `ExpressionSpec`) have no SDK types, so definitions and their validation compile
  without it.
- **Two support assemblies:** `Exegesis.Shared.Editor` (no AAC, no SDK: `ControllerSnapshot`,
  `AnimatorParameters`, `AnimatorAssets`, `FxControllers`) and `Exegesis.Aac.Editor`
  (`ExegesisAac`, `ExegesisDefaultsProvider`).

### Avatar definitions

Each avatar's definition (`fx/Editor/Avatars/<Name>Avatar.cs`) has three parts:
`Parameters()`, `Expressions()` and `Layers()`. Apart from the slot and RCS layers, it **is** the
controller. Shared material lives beside it:

| File | Contents |
|---|---|
| `CommonLayers.cs` | baselines (`*_neutral`), overlays, panels, props, wings, HUD, transponder, touch, eyeshadow |
| `CommonLayers.Heat.cs` | the heat system and `batt_control`; per-avatar rates in `HeatRates` |
| `CommonLayers.Body.cs` | `blink`, `tool_holstering`, `blushie`, `eyes`, `ears`, `tail_state`, `panel_tool_control` |
| `CommonParameters.cs` | animator parameter blocks (built-ins, face tracking, body state); `Retired` |
| `CommonExpressions.cs` | expression parameters every avatar has; the shared menus; `Icons` |
| `Clips.cs` | clip paths by folder |

Where avatars differ, the difference is an argument (a clip, a rate) or an avatar-only layer,
never a branch on the avatar's name. Layer counts: 49 each for ncho and lemaitre, and 55 for
obi-me, before the slot and RCS layers.

**Validation** (`AvatarDefinition.Problems`) runs before every build and in
`AvatarDefinitionTests`. It catches:
- missing clips;
- unknown states, and a missing or unknown default state;
- duplicate layer, state or parameter names;
- layer names using the tools' prefixes;
- retired parameters declared again;
- **a layer using a parameter the avatar doesn't declare, or with the wrong type.**

The last check matters most. AAC quietly declares any parameter a layer mentions, with a default
of zero, so without it a typo in a spec becomes a new parameter nothing ever sets, and an Int
tested with `If` never matches.

**Drivers.** Parameter drivers (`.Drives(...)`) write every field of every driven parameter
explicitly, because the SDK's defaults (`valueMax` and `chance` of 1) differed from the
hand-built drivers' 0. Neither field is read by Set or Add.

## Expression parameters and menus

Each avatar's `Expressions()` declares:
- **its expression parameters:** what syncs, what saves, and the defaults VRChat applies;
- **its main menu and the whole tree under it;**
- **any other menus it owns:** ncho's tail menu isn't on the main menu, because ncho's VRCFury
  prefab `ncho_verypoor_features` installs it.

**Assets are filled in place, never replaced.** The GUIDs that the avatar descriptors and the
VRCFury prefab reference never change, and the scene needs no edits. A menu or parameters asset
that doesn't exist yet is created at the path the definition names.

**Shared menus.** Three menus are single assets used by several avatars:
- Config (`ncho_config_menu`);
- Expression (`ncho_cuddle_menu`);
- ncho's Panels (`ncho_panels_menu`, used by ncho and lemaitre).

They're defined once in `CommonExpressions`, and the builder refuses to write if two avatars
describe a shared menu differently.

**Checks** (`ExpressionsBuilder.Problems`, also run by `ExpressionTests`). They run after the
controller is built, because several compare against it:
- every menu control's parameter (and sub-parameter) is one of the avatar's expression parameters;
- every expression parameter exists on the FX controller with the matching type;
- no menu has more than 8 controls (Config and ncho's Panels are full);
- every icon exists;
- shared menus agree.

`ExpressionTests` also fills a throwaway copy of every asset from code, through the same
`ExpressionsBuilder.Fill` the build uses, and compares it with the committed asset. A pass means
a build would change nothing.

**Expression defaults beat animator defaults**, and a few differ. For example,
`right_arm_panels` defaults on in the expression parameters and off in the animator, and
`thigh_slot` is 2 versus 1. VRChat applies the expression value. These were kept as found.

Kept exactly as found, each worth a look on its own:
- **Config** has a parameterless `snub` toggle and a `Page 2 (snub)` submenu that opens nothing.
- **Expression** has an `SPS` submenu that opens nothing.
- **lemaitre's `TEU Core` menu** is empty.
- **Every shared menu's inspector-only `Parameters` reference** points at `ncho_params.asset`,
  even in lemaitre's and obi-me's trees. VRChat ignores it at runtime.
- **`ncho/ncho_anim/ncho_tail_param.asset`** is referenced by nothing and isn't generated.

## Notes on particular layers

- **blink:** the second `[ncho]_slutty_eyes → blink` transition needs `EyeLid < 0.5` **and**
  `EyeLid > 0.9`, so it never fires. Once squinting, the eyes stay in slutty eyes until squint
  drops below 0.3, whatever the lid does. Left alone on purpose: eye tracking is due for its own
  overhaul.
- **heat_radiation:** cooling is slow below 0.85 and fast from 0.85 up.
  - **Why 0.8499999:** the fast condition is `> 0.8499999` because conditions are strict, so
    `> 0.85` would leave exactly 0.85 with neither state firing. Slow is checked first, so the
    sliver between the two thresholds cools slowly.
  - **The 1.1 s pulse:** every heat layer pulses about once every 1.1 s, measured, and
    independent of frame rate. The pulse states play the zero-length `_Empty.anim`, which Unity
    times as 1 s long, so "exit time 0" waits for its loop, and the pulse itself lasts 0.1.
  - **Rates per pulse** are in `HeatRates`.
- **tool_holstering:** `screwdriver_holster` is a contact receiver (the wearer's right hand at the
  holster), not a toggle. Point at the holster to draw, slap the hand back on to return. In both
  directions the hand has to leave the holster before the next action arms; see the comment on
  `CommonLayers.ToolHolstering`.
- **wing_deploy:** answers to `wings_deployed` and **never** to `rcs`. `rcs` is 1 on every load,
  and the wings used to come out with their plumes off; see
  [accessories.md](accessories.md#the-rcs--wings-decoupling). `WingDeployTests` guards it. ncho's
  version has the contact-sensor "wings up" state; lemaitre's and obi-me's are stowed / deployed
  only.

## The invariants

Everything below is load-bearing and non-obvious. Any reimplementation has to satisfy it; each
entry names the test that pins it.

### Write Defaults OFF, everywhere

Every state in every controller has `writeDefaultValues = false`. That's what lets the layers
stack: a layer sitting in a state that writes nothing lets lower layers win.

Two consequences that have each cost real time:

- **A state playing an empty clip writes nothing**, so the property keeps whatever it last held.
  A gate clip that should force a value to 0 but has *no curve* silently holds the material's
  saved value instead. → `GeneratedClipTests`
- **"Bare" needs no clip.** A slot layer in `idle` writes nothing, so the accessory tiles fall
  through to `props_neutral`'s hidden values. This is why slots have no state for 0.

`ExegesisDefaultsProvider` passes `writeDefaults: false` to AAC, which applies it to every state
it creates, and `LayerSpec` has no option to turn it on. → `WriteDefaultsTests`, which checks
every state in every controller.

### Every generated clip writes something

`VerifyGeneratedClips()` reloads the controller **from disk** after the RCS build and reports any
clip the `rcs_*` layers reference that carries no curves. Reloading is the point: it checks what
was actually serialized, which is the only version the animator will ever play. This caught a real
failure once: one clip out of 38 written with `m_FloatCurves: []`, while every other clip in the
same build came out correct. → `GeneratedClipTests`

The audit is scoped by **reachability from the `rcs_*` layers**, not "every clip in the file".
The controllers used to carry orphaned clips from an old duplicate-the-controller operation, one
legitimately empty. The build's sweep has since removed them, but the scoping stays, so a stray
sub-asset can never pass for a generation failure.

### Direct blend trees sum their children

`rcs_smooth`, the publish layers and `rcs_imu` all depend on a Direct blend tree with
**Normalize Blend Values OFF**, which makes it *sum* rather than average. Children writing
different properties coexist in one tree; children writing the same property form a lerp (the
smoother) or a signed pair (the IMU).

No public scripting property exposes this, and **AAC never touches it**: a grep of all three
hai-vr packages finds no reference to `m_NormalizedBlendValues`. Unity defaults it off, but the
design depends on it far too much to leave to a default, so
`AnimatorAssets.SetNormalizedBlendValues` sets it through `SerializedObject` on every Direct tree.
→ `Snapshot_DetectsInjectedDifference`

### Publish is eight 1D layers, not one Direct tree

One Direct tree holding all eight children is tidier, and was tried. It measured **dead** on the
live material: master and the group gates were correct, while `_RCS_Vel` stayed at 0.000 through
any amount of motion, because the weight parameter `RCS_One` didn't arrive at its default of 1.
A 1D tree reads its blend parameter directly, so there's no weight left to arrive as zero. The
extra layers cost nothing: the VRCFury optimiser merges them straight back.

`rcs_imu` still leans on `RCS_One` for its neutral base child. It hasn't misbehaved, but if the
IMU ever reads as stuck at zero, start there.

### Clips can drive Animator parameters

Not just component properties. That's what lets `rcs_smooth` feed a parameter back into itself
to produce the exponential lag, with no arithmetic anywhere in the animator. In AAC this is
`AnimatesAnimator`.

### Slot exclusivity is structural

One int per mount point, one state per member, entered on `Equals <value>` and left on
`NotEqual <value>`. A state machine can only be in one state, so two accessories on one mount are
unrepresentable rather than merely prevented. → `SlotParameterTests`

Int conditions **must** use `Equals`/`NotEqual`. An `If`/`IfNot` against an Int parameter never
matches, and nothing logs it. → `SlotParameterTests`, and the type check in
`AvatarDefinition.Problems`

### Accessories fade, and swap sequentially

- **0.25 s transition duration**, `hasFixedDuration` true. The fade is **not in the clips**, which
  are two-key constants. It comes entirely from the transition duration, blending the dissolve
  alpha against `props_neutral`'s value on the layer below. A rebuild with a default duration of
  0 would remove the fade silently. → `SlotTransitions_KeepTheFade`
- **No member-to-member transitions.** Swaps route through `idle`, so the old accessory is fully
  gone before the new one appears. Direct transitions would take half the time but crossfade,
  dissolving two pieces of solid hardware into each other. This is the intended look, inherited
  from ChoccyWicker. → `SlotMembers_SwapViaIdleNotDirectly`

The second is a test asserting the *absence* of an optimisation, because the shortcut is
tempting and nothing in the code says the extra hop is deliberate. It was implemented as a
crossfade once and had to be reverted.

Transition **order** is creation order, in AAC as in the raw API. The two loops in
`BuildSlotLayer` stay separate for that reason: all of `idle`'s entry transitions first, then one
exit transition per member.

### Presets are one-shot

Each `slot_loadout` state hosts a `VRCAvatarParameterDriver` that Sets several slot ints **and
resets `loadout` to 0**. Without the self-reset the state re-enters continuously, re-fires the
driver every frame, and pins the slot ints, so per-slot toggles can never win. That's the bug
the ChoccyWicker `Outfits` layer has. Preset transitions are duration 0: they carry no visuals.

### The build refuses rather than deleting

Building from empty would silently delete anything nobody declared, so preflight refuses
instead, and changes nothing. Removing a parameter is a reviewed change in code
(`CommonParameters.Retired`), never a side effect.
→ `Build_RefusesAndChangesNothing_WhenTheControllerHasSomethingUndeclared`

## What AAC does, and the four things it doesn't

AAC owns layers, states, transitions, conditions, clips, blend trees and parameter drivers.
The four things below are handled by this project because AAC doesn't do them, and each has a
comment in the source saying what breaks without it.

### 1. Parameter declaration (`AnimatorParameters`, `ParamSpec`)

AAC's `CreateParamIfNotExists` matches **by name only**. A parameter already declared with the
wrong type is silently left alone, and an `Equals` condition against something the controller
believes is a Bool never matches and never logs. That's this project's recurring failure shape.

The avatars' parameters are declared up front from `ParamSpec`s, so AAC never needs to create
one. The tools' own parameters go through `AnimatorParameters.Ensure`/`EnsureBool`/`EnsureInt`/
`EnsureFloat`, which correct a wrong type and warn.

Driver targets and clip bindings in the slot tool use `aac.NoAnimator()`, which returns parameter
handles without registering anything. A preset names parameters the slot tool doesn't own
(`hard-case_mounts`, `arm_hard-cases`), and `layer.FloatParameter` would silently declare any that
were missing, with a guessed type.

### 2. Emptying the controller (`ExegesisAac.ClearController`)

Run **before** AAC sees the controller, so AAC always takes its append-a-new-layer path. Its
other path, clearing a layer that already exists, empties the state machine by assigning empty
arrays over `states` and `anyStateTransitions`. That *detaches* those sub-assets without
destroying them, so they'd accumulate in the committed file on every rebuild. `ClearController`
destroys every layer's state machine, transitions, behaviours and blend trees properly, then
empties the layer and parameter lists.

### 3. Sub-asset cleanup (`AnimatorAssets.SweepUnreachableSubAssets`)

AAC's own `ClearPreviousAssets()` only ever removes `AnimationClip`, `BlendTree` and
`AvatarMask`, never an `AnimatorState`, transition or behaviour. It also matches on the
`zAutogenerated/{AssetKey}__` name prefix, which stops working the moment an asset is renamed to
something readable.

The sweep works on **reachability** instead: anything in the controller file that nothing in
`controller.layers` points at is destroyed. That's strictly stronger, it doesn't care what
anything is called, and it means renaming generated assets and cleaning up after them stop
fighting each other.

**This is the one failure `ControllerSnapshot` can't see.** The snapshot walks the reachable
graph, so an orphan is invisible to it, and the file could double in size with every test still
green. `RebuildingTwice_DoesNotAccumulateSubAssets` is what holds that line.

### 4. Stable asset names (`ExegesisAac.Clip` / `DirectTree` / `Tree1D`)

AAC names generated sub-assets `zAutogenerated/{AssetKey}__{name}_{Random.Range(0, int.MaxValue)}`,
with the integer drawn fresh on every call. `NewBlendTree()` has no named overload at all, so its
middle segment is a `Guid`. Left alone, the committed controller's diff would churn on every
rebuild even when nothing changed, and reviewing that diff is the whole reason a generated asset
is kept in git. These helpers rename past the decoration immediately. Clip names are also a
contract `GeneratedClipTests` asserts on.

AAC also creates one throwaway empty clip per layer as a default motion. Every state the
definitions write has its own motion, so those end up unreferenced and the sweep removes them.

## Where the generated clips live

**Inside each FX controller, as sub-assets.** Only the RCS clips are generated; they used to be
38 `.anim` files in `ncho_anim/rcs_generated/`, a folder that's now gone. Every other clip is a
hand-authored `.anim` asset that the definitions reference by path (`Clips.*`). The controller
stores them by GUID, so moving a clip in Unity keeps the controller working until the next build,
when the definition's path has to match.

## `ExegesisDefaultsProvider`

Three of AAC's virtual members are overridden, plus the Write Defaults constructor argument:

- **`ConvertLayerName`** returns the system name unchanged. A layer is named exactly what the
  spec says.
- **`ConvertLayerNameWithSuffix`** returns `{system}_{suffix}`, with a single underscore where
  AAC's default is double: `rcs_group_packs`, not `rcs__group_packs`. The tests, the docs and the
  builder's prefix ownership (`slot_*`, `rcs_*`) all hardcode these names.
- **`ConfigureTransition`** reproduces what Unity's `AddTransition` leaves behind, which differs
  from AAC's defaults in two fields: `exitTime` is **0.9**, not 0, and `canTransitionToSelf` is
  **true**, not false. Both were measured off the committed controller through
  `ControllerSnapshot`, and both would have been guessed wrong.

Neither transition field changes behaviour here: `exitTime` is unreachable while `hasExitTime` is
false, and `canTransitionToSelf` only matters for Any-State transitions, which no layer has. They're
reproduced anyway. An equivalence diff that's genuinely empty is worth much more than one that's
empty except for two differences with a footnote about why they're fine: next time, the footnote
is what someone reaches for. `AvatarLayers` sets every timing field of a transition explicitly for the same
reason.

The same reasoning covers `ExegesisAac.FinishTree1D`, which restores the `directBlendParameter`
of `"Blend"` that Unity puts on 1D blend tree children and AAC leaves empty. It's dead data on a
1D tree, reproduced so the diff stays honest.

## Scene-less by construction

`AacConfiguration.AnimatorRoot` and `DefaultValueRoot` are both null. `AnimatorRoot` is only ever
dereferenced by AAC's `Transform`, `GameObject` and `Component` clip overloads and by
`ResolveAvatarMask`; `DefaultValueRoot` is documented as unused in AAC's own source. Using only the
string-path overloads (`Animates(path, type, property)` and `AnimatesAnimator`) keeps the build
runnable with no scene loaded, which is what lets it work in the headless clone.

`GeneratedClips_BindOnlyByStringPath` pins it from the other side: every generated curve must bind
an Animator parameter at the empty path, or a material property at `Body` or `Props`.

## What not to change

- **Generated clip names** (`rcs_group_packs_covered`, `rcs_group_thighs_worn`, …) and the
  `_GroupEnable` component mapping: asserted by `GeneratedClipTests`.
- **Slot int values:** a saved-parameter contract with every user who has worn the avatar.
- **Group indices:** baked into **vertex green on the meshes**. See
  [rcs-thrusters.md](rcs-thrusters.md) and [accessories.md](accessories.md).
- **Parameter names in general:** renaming one resets everyone's saved value and breaks anything
  outside the controller that uses it (VRCFury, contacts, OSC).

## History

How the controllers came to be generated, because some of it explains what you'll see in the
diffs and the comments.

**Porting.** Every layer was originally built by hand in the Animator window. The layers moved
into code family by family in November 2026, under one rule: **the controller snapshot must not
change.** Each port reproduced the original exactly (state order, transition order, durations,
even `exitTime` where `hasExitTime` is off), and behaviour changes came afterwards as their own
reviewable diffs. Exceptions, each reviewed:
- **Write Defaults** was switched off in six states that had it on: lemaitre's `base`, and obi-me's
  `lock_manipulators_neutral`, `lock_manipulator_L/R` and both `lower_head_cam` states.
  **Still to be checked in game.**
- **Two stale speed-parameter names** were dropped. blink's `[ncho]_slutty_eyes` and eyes' `voice`
  had `speedParameter = "Voice"` with `speedParameterActive` off, which is dead data Unity
  ignores.
- **Fixes made after porting:**
  - `tool_holstering` gained its re-arm states. Before, the screwdriver bounced straight back
    unless the hand left the holster within 1.5 s, and pointing at the holster looped
    draw / return / draw.
  - lemaitre's `eyeshadow` speed went from 100 to 1. Both clips are single poses, so it never had
    an effect.

**Building from empty.** Before this, the slot and RCS tools tore down their own layers by
prefix, the slot tool deleted the four hand-built accessory layers it had replaced, and it
stripped `rcs` from the hand-built `wing_deploy` on every build. Ported layers were put back at
their old indices. Emptying the controller made all of that unnecessary. It also exposed that
the RCS tool declared `rcs` without a default, which had only worked because the hand-built
controller already had it true. The parameter list was reordered once at this point: avatar-only
parameters moved from the very end to just before the slot and RCS ones, with every name, type
and default unchanged.

**The retired accessory bools.** `thruster_backpack`, `arm_backpack`, `thigh_hard-cases` and
`thigh_thrusters` were replaced by the slot ints and removed once the expressions were generated.
Nothing referenced them: no layer, expression parameter, menu, contact or VRCFury component. The
scene still contains those names, but only as slot *state* names in Gesture Manager's state
cache. They're listed in `CommonParameters.Retired`, and `SlotParameterTests` fails if one is
declared again.

**Expressions.** The first generation reproduced every menu and parameter asset's content
exactly. It did rewrite two things: the parameter assets gained four fields per parameter that
the installed SDK serializes (`bitWidth: 8` and so on, all defaults), and three older menus gained
a trailing space after `m_EditorClassIdentifier:`.

## Note for a fresh clone

`Packages/*` is gitignored, so AAC's source isn't committed. The headless clone is populated by
robocopy from the working tree rather than by git, so it gets AAC. A fresh `git clone`, though,
needs VPM resolution before the first compile, or the generator assemblies fail to build.
