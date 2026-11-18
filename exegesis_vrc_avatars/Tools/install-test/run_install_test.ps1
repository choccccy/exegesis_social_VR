<#
.SYNOPSIS
    Clean-room install test: import a release .unitypackage into a fresh project that has
    only the README requirements, then report what's broken.

.DESCRIPTION
    1. Builds a "deps baseline" project once (VCC Avatar template + the VPM packages copied
       from this project's Packages/ + Poiyomi + the FinalIK stub), and checks it compiles.
    2. Mirrors the baseline into the test project (so every run starts clean).
    3. Imports -Package, then runs checker/InstallCheck.cs, which reports unresolved GUIDs,
       broken materials, missing scripts and missing prefabs.
    4. With -EnablePS1, also scripts README step "enable the PS1 module" and checks the
       PS1 materials before and after.

    Projects live next to the git repo (like the headless clone), never inside it. Safe to
    run while the Editor has the real project open. See docs/testing.md > Clean-room install test.

.EXAMPLE
    # full package, README requirements
    powershell Tools/install-test/run_install_test.ps1 -Package exegesis_v1.0.0.unitypackage -EnablePS1

    # props package with only its own README requirements (separate baseline via -Name)
    powershell Tools/install-test/run_install_test.ps1 -Package exegesis_props_v1.1.1.unitypackage `
        -Name exegesis_install_test_props -FinalIkPackage "" `
        -VpmPackages com.vrchat.core.vpm-resolver,com.vrchat.base,com.vrchat.avatars,com.vrcfury.vrcfury
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Package,   # the .unitypackage under test
    [string]$Name = "exegesis_install_test",           # test project dir; baseline is <Name>_deps_baseline
    [string[]]$VpmPackages = @(
        "com.vrchat.core.vpm-resolver", "com.vrchat.base", "com.vrchat.avatars",
        "com.vrcfury.vrcfury", "dev.hai-vr.animator-as-code.v1", "dev.hai-vr.animator-as-code.v1.vrchat",
        "gogoloco", "com.llealloo.audiolink", "nadena.dev.ndmf", "lyuma.av3emulator"),
    [string]$PoiPackage = "$env:USERPROFILE\Downloads\Poi.Pro.11.0.27.unitypackage",
    [string]$FinalIkPackage = "$env:USERPROFILE\Downloads\dev.vrlabs.final-ik-stub-1.9.3.unitypackage",  # "" to skip
    [switch]$RebuildDeps,    # rebuild the baseline even if it exists
    [switch]$EnablePS1,      # also script + verify README step "enable the PS1 module"
    [int]$MaxMinutes = 45,
    [string]$UnityExe = "C:\Program Files\Unity\Hub\Editor\2022.3.22f1\Editor\Unity.exe",
    [string]$Template = "$env:LOCALAPPDATA\VRChatCreatorCompanion\VRCTemplates\Avatar"
)

$ErrorActionPreference = "Stop"

# 'powershell -File' hands "-VpmPackages a,b,c" over as ONE string, not an array.
$VpmPackages = @($VpmPackages | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })

$Src      = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path   # exegesis_vrc_avatars
$Base     = Split-Path (Split-Path $Src -Parent) -Parent             # sibling of the git repo
$Baseline = Join-Path $Base "${Name}_deps_baseline"
$Proj     = Join-Path $Base $Name
$Package  = (Resolve-Path $Package).Path
$OutDir   = Join-Path $Base "${Name}_out"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Stamp($msg) { Write-Output ("[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $msg) }

# Unity.exe forks and the launcher returns early with a meaningless exit code, so wait for
# the Unity process whose command line names exactly this project (not a longer sibling path).
function Invoke-Unity([string]$project, [string]$log, [string[]]$extra) {
    $argv = @("-batchmode", "-logFile", $log, "-projectPath", $project) + $extra + @("-quit")
    & $UnityExe @argv | Out-Null
    Start-Sleep -Seconds 5
    $pat = [regex]::Escape($project) + '("|\s|$)'
    $deadline = (Get-Date).AddMinutes($MaxMinutes)
    while ((Get-Date) -lt $deadline) {
        $p = Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" |
             Where-Object { $_.CommandLine -match $pat }
        if (-not $p) { break }
        Start-Sleep -Seconds 5
    }
    if ($p) { throw "Unity still running on $project after $MaxMinutes min (log: $log)" }
    # A compile error makes batchmode skip -importPackage / -executeMethod but still "succeed".
    $errs = @(Select-String -Path $log -Pattern "error CS\d+" -ErrorAction SilentlyContinue)
    if ($errs.Count -gt 0) {
        $errs | Select-Object -First 15 | ForEach-Object { "    " + $_.Line.Trim() }
        throw "Compile errors in $project (log: $log). Batchmode skips the import/method when scripts don't compile."
    }
}

function Mirror([string]$from, [string]$to) {
    robocopy $from $to /MIR /NFL /NDL /NJH /NJS /NP /R:1 /W:1 | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy $from -> $to failed ($LASTEXITCODE)" }
}

foreach ($p in @($Proj, $Baseline)) {
    if (Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" |
        Where-Object { $_.CommandLine -match ([regex]::Escape($p) + '("|\s|$)') }) {
        throw "A Unity instance already has $p open. Close it first."
    }
}

# ---- 1. deps baseline -------------------------------------------------------------
if ($RebuildDeps -or -not (Test-Path (Join-Path $Baseline "Library"))) {
    Stamp "Building deps baseline at $Baseline"
    if (-not (Test-Path $Template)) { throw "VCC Avatar template not found at $Template" }
    if (Test-Path $Baseline) { Remove-Item -Recurse -Force $Baseline -Confirm:$false }
    # The VCC template, not 'Unity -createProject': the bare project lacks
    # com.unity.test-framework and the VRChat SDK then fails to compile (NUnit errors).
    Copy-Item -Recurse $Template $Baseline
    Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path $Baseline "package.json"), (Join-Path $Baseline "README.md")
    foreach ($pkg in $VpmPackages) {
        $from = Join-Path $Src "Packages\$pkg"
        if (-not (Test-Path $from)) { throw "VPM package $pkg not found in $Src\Packages" }
        Copy-Item -Recurse $from (Join-Path $Baseline "Packages\$pkg")
        $v = (Get-Content (Join-Path $from "package.json") -Raw | ConvertFrom-Json).version
        Stamp "  $pkg $v"
    }
    if ($PoiPackage) {
        if (-not (Test-Path $PoiPackage)) { throw "Poiyomi package not found: $PoiPackage" }
        Stamp "  first open + Poiyomi import"
        Invoke-Unity $Baseline (Join-Path $OutDir "deps_01_poi.log") @("-importPackage", $PoiPackage)
    } else {
        Invoke-Unity $Baseline (Join-Path $OutDir "deps_01_open.log") @()
    }
    if ($FinalIkPackage) {
        if (-not (Test-Path $FinalIkPackage)) { throw "FinalIK package not found: $FinalIkPackage" }
        Stamp "  FinalIK import"
        Invoke-Unity $Baseline (Join-Path $OutDir "deps_02_finalik.log") @("-importPackage", $FinalIkPackage)
        # The VRLabs stub ships its scripts renamed *.no and an installer that restores them on
        # the next load, so open once more.
        Invoke-Unity $Baseline (Join-Path $OutDir "deps_03_reopen.log") @()
    }
    Stamp "Deps baseline compiles cleanly"
} else {
    Stamp "Reusing deps baseline $Baseline (-RebuildDeps to rebuild)"
}

# ---- 2. fresh test project --------------------------------------------------------
Stamp "Mirroring baseline -> $Proj"
Mirror $Baseline $Proj
$chk = Join-Path $Proj "Assets\_InstallCheck\Editor"
New-Item -ItemType Directory -Force -Path $chk | Out-Null
Copy-Item (Join-Path $PSScriptRoot "checker\*") $chk
if ($EnablePS1) {
    $ps1 = Join-Path $Proj "Assets\_InstallCheckPoi\Editor"
    New-Item -ItemType Directory -Force -Path $ps1 | Out-Null
    Copy-Item (Join-Path $PSScriptRoot "poi_step\*") $ps1
}

# ---- 3. import + check ------------------------------------------------------------
Stamp "Importing $Package"
Invoke-Unity $Proj (Join-Path $OutDir "10_import.log") @("-importPackage", $Package)

$report = Join-Path $OutDir "report.txt"
$env:INSTALLCHECK_OUT = $report
Stamp "Running checker"
Invoke-Unity $Proj (Join-Path $OutDir "11_check.log") @("-executeMethod", "InstallCheck.Run")

# ---- 4. PS1 step ------------------------------------------------------------------
if ($EnablePS1) {
    $env:INSTALLCHECK_OUT = Join-Path $OutDir "ps1_before.txt"
    Invoke-Unity $Proj (Join-Path $OutDir "20_ps1_before.log") @("-executeMethod", "InstallCheckPs1Step.Verify")
    $env:INSTALLCHECK_OUT = Join-Path $OutDir "ps1_step.txt"
    Stamp "Enabling PS1 module and regenerating Poiyomi shaders (slow)"
    Invoke-Unity $Proj (Join-Path $OutDir "21_ps1_step.log") @("-executeMethod", "InstallCheckPs1Step.Run")
    # Verify in a fresh session so the regenerated shaders are imported.
    $env:INSTALLCHECK_OUT = Join-Path $OutDir "ps1_after.txt"
    Invoke-Unity $Proj (Join-Path $OutDir "22_ps1_after.log") @("-executeMethod", "InstallCheckPs1Step.Verify")
}

Stamp "Done. Report: $report"
Get-Content $report
if ($EnablePS1) {
    "`n--- PS1 step"; Get-Content (Join-Path $OutDir "ps1_step.txt")
    "`n--- PS1 materials before (MISS expected)"; Get-Content (Join-Path $OutDir "ps1_before.txt")
    "`n--- PS1 materials after (all OK expected)"; Get-Content (Join-Path $OutDir "ps1_after.txt")
}
