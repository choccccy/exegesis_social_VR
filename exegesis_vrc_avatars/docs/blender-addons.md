# Blender add-ons

The Blender add-ons used on this project's `.blend` sources (`exegesis_social_VR/source/`).
None are needed for the export. `Tools/blender/export_avatar.py` runs with
`--factory-startup`, which loads **no** user add-ons, so nothing here changes what ends up in
an FBX. They are authoring conveniences.

| Add-on | Version | Kind | What it's for | Get it |
|---|---|---|---|---|
| **Pribambase** | 2.6.1 | legacy add-on | Paint pixel-art textures in Blender using Aseprite, live-synced both ways. Pairs with the `.aseprite` sources | [github.com/lampysprites/pribambase](https://github.com/lampysprites/pribambase) (also needs its Aseprite-side plugin) |
| **Texel Density Checker** | 2026.1.1 | extension (blender.org) | Measure / match texel density across UV islands, so pixel art stays one scale across meshes | Preferences ▸ Get Extensions ▸ search "Texel Density" ([source](https://github.com/mrven/Blender-Texel-Density-Checker)) |
| **Auto Reload** | 3.1.2 | extension (blender.org) | Reloads images and other external files when they change on disk, e.g. after saving a texture in Aseprite | Preferences ▸ Get Extensions ▸ search "Auto Reload" ([source](https://github.com/samytichadou/Auto_Reload_Blender_addon)) |
## Where they live

Blender keeps a **separate settings folder per version**:
`%APPDATA%\Blender Foundation\Blender\<major.minor>\`

```
<ver>\config\userpref.blend          which add-ons are enabled, plus all other preferences
<ver>\config\texel_density\          Texel Density Checker's own settings
<ver>\scripts\addons\                legacy add-ons (Pribambase)
<ver>\extensions\blender_org\        blender.org extensions (Texel Density Checker, Auto Reload)
```

Steam and blender.org builds of the same version share that folder.

## After upgrading Blender: the add-ons "disappear"

A new minor version starts with an empty folder. On first launch the splash offers
**Load <previous> Settings**. Take it **before** changing any preference, because once the new
version saves its own `userpref.blend`, the offer is gone. Missed it? With Blender closed, copy
`config\`, `scripts\` and `extensions\` from the previous version's folder into the new
one, then re-check Preferences ▸ Add-ons for anything that failed to load.

Legacy add-ons (those under `scripts\addons\`) declare a Blender 2.80 minimum and are not
version-checked. If one breaks after an upgrade, its error appears in Preferences ▸ Add-ons
and in the system console (Window ▸ Toggle System Console).

## Blender crashes on launch

If every Blender version dies instantly on this machine, see the `TBB_MALLOC_DISABLE_REPLACEMENT`
note in [rigging.md ▸ Exporting](rigging.md#exporting). It is a Windows-update problem, not an
add-on problem.
