
# [Exegesis](https://exegesis.space)
**Exegesis** is a hard sci-fi, zone-fiction setting about strange people and stranger AI in mechanical bodies on an existentially important mission to investigate a Dyson sphere that is eating at their minds, 112.21 light-years from home. You can read more about it at the [main website](https://exegesis.space).

## NSFW content warning
**Certain Exegesis content includes explicit features, typically tagged as `[evil]`. These elements are opt-in and can be ignored if not outright disabled, but please be aware of their presence. *If you are underage, you obviously shouldn't touch this stuff. Go away.***

# Exegesis VRChat avatars
The whole `Assets/_exegesis/` folder of the [Exegesis VRChat avatar project](https://github.com/choccccy/exegesis_social_VR): every avatar, prop, shader, animation and editor tool, plus the `exegesis` scene they're set up in.

- **onye Nchọgharị** (`ncho/`)
- **mkpụrụobi mepụta** (`obi-me/`)
- **Dr. Agnès Lemaître** telepresence frame (`lemaitre/`)
- **Props** (`props/`), also released on their own as `props-v*`
- The custom **HUD** and **RCS thruster** shaders (`HUD_shader/`, `thruster_shader/`)

## Requirements
Get these through [ALCOM](https://vrc-get.anatawa12.com/alcom/) or the [VRChat Creator Companion](https://vcc.docs.vrchat.com/) where possible.

- [Unity 2022.3.22f1](https://unity.com/releases/editor/whats-new/2022.3.22)
- [VRChat Avatars SDK 3.10.6](https://creators.vrchat.com/sdk/) or newer
- [Poiyomi Pro 11.0.27](https://www.poiyomi.com/download#poiyomi-pro) or newer (the avatars use Pro features; the props only need the free version)
- [TheCodeWarrior](https://github.com/thecodewarrior)'s [PS1 module for Poiyomi](https://discord.com/channels/550477546958094348/553319525387599910/1555713076618334228) ([thecodewarrior.dev](https://thecodewarrior.dev/); **included in this package** at `Assets/Editor/Poi_PS1/`, redistributed with permission)
- [VRCFury 1.1437](https://vrcfury.com/download/) or newer
- [Animator As Code V1 and Animator As Code V1 - VRChat](https://docs.hai-vr.dev/docs/products/animator-as-code/install) (the editor tools won't compile without them)
- [FinalIK 1.9](http://root-motion.com/#final-ik) or [VRLabs](https://vrlabs.dev)' [FinalIK stub](https://github.com/VRLabs/Final-IK-Stub) (ncho's tail)
- [GoGoLoco](https://gogoloco.net/)
- [AudioLink](https://audiolink.dev/)
- [NDMF](https://modular-avatar.nadena.dev/)
- [Av3Emulator](https://github.com/lyuma/Av3Emulator)

## Installation
1. Install the requirements
2. Download the package and drag it into your Unity *Project* tab
3. Enable the PS1 module (`Assets/Editor/Poi_PS1/`) in Poiyomi's module settings, so Poiyomi rebuilds its shaders with it; without it the PS1 effects on ncho, Lemaître and obi-me are missing
4. Open `Assets/_exegesis/exegesis.unity`; the avatars are set up in that scene

## License
Licensed under [GPLv3](https://github.com/choccccy/exegesis_social_VR/blob/main/LICENSE).
