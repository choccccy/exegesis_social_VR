Note: this fork goes against Dreadrith's, the Original Author, wishes. It is however compliant with the original OS license.
<div align="center">

# BlendTreeBuilder

[![Generic badge](https://img.shields.io/github/downloads/VRLabs/BlendTreeBuilder/total?label=Downloads)](https://github.com/VRLabs/BlendTreeBuilder/releases/latest)
[![Generic badge](https://img.shields.io/badge/License-MIT-informational.svg)](https://github.com/VRLabs/BlendTreeBuilder/blob/main/LICENSE)
[![Generic badge](https://img.shields.io/badge/Unity-2019.4.31f1-lightblue.svg)](https://unity3d.com/unity/whats-new/2019.4.31)
[![Generic badge](https://img.shields.io/badge/SDK-AvatarSDK3-lightblue.svg)](https://vrchat.com/home/download)

[![Generic badge](https://img.shields.io/discord/706913824607043605?color=%237289da&label=DISCORD&logo=Discord&style=for-the-badge)](https://discord.vrlabs.dev/)
[![Generic badge](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fshieldsio-patreon.vercel.app%2Fapi%3Fusername%3Dvrlabs%26type%3Dpatrons&style=for-the-badge)](https://patreon.vrlabs.dev/)

A Unity tool to make VRC Blendtree creation easier and faster.

![BlendTreeBuilder](https://i.imgur.com/QIDZTdq.png)

### ⬇️ [Download Latest Version](https://github.com/VRLabs/BlendTreeBuilder/releases/latest)


### 📦 [Add to VRChat Creator Companion](https://vrlabs.dev/packages?package=dev.vrlabs.blendtreebuilder)

</div>

---

## Features
- Simple toggles
- Single State layers, including motion time states.
- Exclusive Toggles

# How to use
1. Open the window by finding it in the toolbar: DreadTools > BlendTreeBuilder
2. Make sure that the FX Controller set is the controller you want to optimize and press Next.
3. Press 'Optimize!' at the bottom.
4. Done!

![Preview](https://github.com/user-attachments/assets/9097a96f-2f65-4d7b-b8bc-8dc45edfb0db)

# Details
On the second step, in the optimize tab, you're given details on what will be handled.
- 'Make Duplicate' will make a backup of your controller before proceeding.
- 'Replace' will delete the layer for the toggle that will be optimized.
- 'Active' will determine wether this toggle will be handled or not.
- Yellow warning icon appears if the toggle behaviour may change when optimized, such as with dissolve toggles.
- Red warning icon appears if optimizing this toggle may break some functionality, such as with exclusive toggles through parameter drivers.
- Foldout is to see or change what start and end motions will be used for this toggle.

![optimize window](https://i.imgur.com/QIDZTdq.png)

### Notes
You should almost always make backups in case something doesn't work right.  
After running the tool, you should test whether they work with [this emulator](https://github.com/lyuma/Av3Emulator).  
If something doesn't work, you can go back to optimize the original again and disable 'Active' for the toggles that didn't work.

### Warning
The optimizer does not take into account layer priority. If an optimized toggle has overlapping clips with another clip, there may be change in behaviour where properties get overwritten.

## Planned Features
- Implement float smoothing for clip blending. i.e: dissolves
- Make the builder for faster and easier tree building

![tree preview](https://i.imgur.com/M0L2E8G.png)
