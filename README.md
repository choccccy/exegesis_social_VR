# [Exegesis](https://exegesis.space)
**Exegesis** is a hard sci-fi, zone-fiction setting about strange people and stranger AI in mechanical bodies on an existentially important mission to investigate a Dyson sphere that is eating at their minds, 112.21 light-years from home. You can read more about it at the [main website](https://exegesis.space).

## NSFW content warning
**Certain Exegesis content includes explicit features, typically tagged as `[evil]`. These elements are opt-in and can be ignored if not outright disabled, but please be aware of their presence. *If you are underage, you obviously shouldn't touch this stuff. Go away.***

# VRChat avatars and assets

## Notes for contributors

### Poiyomi Shaders
To make sure that we're respecting Poiyomi Shaders' [Terms of Service](https://www.poiyomi.com/terms-of-service/), ***all Poiyomi materials should be 'unlocked' before they are committed***.

This can be done fairly trivially by right-clicking the `Assets/_exegesis/` folder (or just the background when in the `Assets/` folder) and clicking `Thry > Materials > Unlock Folder`.

`_PoiyomiShaders/` and any `OptimizedShaders/` folders are already in the .gitignore, so they simply won't be committed.

## Requirements

Hard requirements for opening and working on this project. You can and probably should get most of these via [ALCOM/VCC repositories](#recommended-alcomvcc-repositories)

- [Unity 2022.3.22f1](https://unity.com/releases/editor/whats-new/2022.3.22) ([VRChat recommended version](https://creators.vrchat.com/sdk/upgrade/current-unity-version/))
- [ALCOM](https://vrc-get.anatawa12.com/alcom/) (preferred) or [VRChat Creator Companion](https://vcc.docs.vrchat.com/#download-it)
- [Poiyomi Pro v9.3](https://www.poiyomi.com/download#poiyomi-pro)
- [FinalIK 1.9](http://root-motion.com/#final-ik) (1.9 is no longer publically available) or [VRLabs](https://vrlabs.dev)' [FinalIK stub](https://github.com/VRLabs/Final-IK-Stub)
- [VRCFury 1.1279.0](https://vrcfury.com/download)
<!-- add Animator As Code and GoGoLoco, when they become requirements, here -->
<!-- - [Animator As Code V1](https://docs.hai-vr.dev/docs/products/animator-as-code/install) -->
<!-- - [GoGoLoco](https://gogoloco.net/) -->

### Recommended ALCOM/VCC repositories

- **Poiyomi's [Poiyomi Pro v9.3](https://www.poiyomi.com/download#vcc-version)**
- **VRLabs' [FinalIK stub](https://github.com/VRLabs/Final-IK-Stub)**
- **Senky's [VRCFury](https://vrcfury.com/download)**
- **Haï's [Animator As Code V1](https://docs.hai-vr.dev/docs/products/animator-as-code/install)**
- **Haï's [Animator As Code V1 - VRChat](https://docs.hai-vr.dev/docs/products/animator-as-code/install)**
- **Lyuma's [Av3Emulator](https://github.com/lyuma/Av3Emulator?tab=readme-ov-file) (also available as a 'Curated' repo in ALCOM/VCC)**
- **BlackStartx's [Gesture Manager](https://github.com/BlackStartx/VRC-Gesture-Manager) (also available as a 'Curated' repo in ALCOM/VCC)**
- **VRLabs' [Avatars 3.0 Manager](https://github.com/VRLabs/Avatars-3.0-Manager) (also available as a 'Curated' repo in ALCOM/VCC)**
- **Franada's [GoGoLoco](https://gogoloco.net/)**
- **[Audiolink](https://audiolink.dev/) (available as a 'Curated' repo in ALCOM/VCC)**
- BluWizard's [Enhanced Hierarchy System](https://vpm.bluwizard.net/)
- Haï's [Animation Viewer](https://docs.hai-vr.dev/docs/products/animation-viewer)
- Haï's [Blendshape Viewer](https://docs.hai-vr.dev/docs/products/blendshape-viewer)
- Haï's [BlendTree Viewer](https://docs.hai-vr.dev/docs/products/blendtree-viewer)
- Haï's [Auto-reset OSC config](https://docs.hai-vr.dev/docs/products/auto-reset-osc-config) (probably not required anymore, but it doesn't hurt)
- Haï's [LetMeSee](https://docs.hai-vr.dev/docs/products/let-me-see)
- Haï's [Lightbox Viewer](https://docs.hai-vr.dev/docs/products/lightbox-viewer)
- Haï's [Property Finder](https://docs.hai-vr.dev/docs/products/property-finder)
- Pumkin's [Avatar Tools](https://rurre.github.io/vpm/)
- Pumkin's [Editor Screenshot](https://rurre.github.io/vpm/)
- Pumkin's [VRC SDK Patches](https://rurre.github.io/vpm/)
- Dreadrith's [VRCSDK+](https://github.com/VRLabs/VRCSDKPlus)
- Dreadrith's [Controller Cleaner](https://github.com/VRLabs/ControllerCleaner)
- Markcreator's [Size Profiler](https://github.com/Markcreator/SizeProfiler)

## Setup

1. Clone the repository
2. Add the project to ALCOM/VCC
3. Install your choice of [ALCOM/VCC repositories](#recommended-alcomvcc-repositories)
4. Open the project. this will take a long time on first boot, as Unity is generating a bunch of files for the first time
5. Install Poiyomi shaders
    - if installing through ALCOM/VCC, you will need to authenticate as described in the [Poiyomi docs](https://www.poiyomi.com/download#vcc-version)
6. Open the `exegesis` scene in `Assets/_exegesis/`.
