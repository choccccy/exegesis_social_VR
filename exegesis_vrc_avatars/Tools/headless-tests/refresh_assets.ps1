<#
.SYNOPSIS
    Headlessly import/refresh a Unity project's AssetDatabase, which generates missing
    .meta files (and imports new/changed assets) without opening the Editor GUI.

.DESCRIPTION
    Runs `Unity.exe -batchmode -quit -projectPath <target>`. On startup Unity performs an
    AssetDatabase refresh: any asset lacking an up-to-date .meta gets imported and its
    .meta written. Then it quits.

    HARD CONSTRAINT: Unity locks a project to a single instance. This CANNOT refresh a
    project that is currently open in the Editor (it holds the lock). It is meant for:
      - the headless CLONE (never opened in the Editor), and
      - the MAIN project only while its Editor is closed.
    While the Editor has MAIN open, that Editor is what refreshes MAIN (on window focus /
    Assets > Refresh) - no external process can.

    See docs/testing.md.

.EXAMPLE
    pwsh Tools/headless-tests/refresh_assets.ps1            # refresh MAIN (must be closed)
    pwsh Tools/headless-tests/refresh_assets.ps1 -Clone     # refresh the headless clone
#>
[CmdletBinding()]
param(
    [switch]$Clone,             # target the headless clone instead of the main project
    [string]$ProjectPath = "",  # explicit project path (overrides -Clone / default)
    [int]$MaxMinutes = 20,
    [string]$UnityExe = "C:\Program Files\Unity\Hub\Editor\2022.3.22f1\Editor\Unity.exe"
)

$ErrorActionPreference = "Stop"

$mainRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if ($ProjectPath -ne "") {
    $Target = (Resolve-Path $ProjectPath).Path
} elseif ($Clone) {
    $unityBase = Split-Path (Split-Path $mainRoot -Parent) -Parent
    $Target = Join-Path $unityBase "exegesis_headless_clone"
} else {
    $Target = $mainRoot
}

if (-not (Test-Path (Join-Path $Target "ProjectSettings\ProjectVersion.txt"))) {
    Write-Output "ERROR: '$Target' is not a Unity project."; exit 1
}

# Refuse if a live Unity process already has this project open (would fail on the lock).
$openProc = Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" -ErrorAction SilentlyContinue |
            Where-Object { $_.CommandLine -like "*$Target*" }
if ($openProc) {
    Write-Output "ERROR: '$Target' is already open in a Unity Editor (PID $($openProc.ProcessId))."
    Write-Output "       Cannot refresh a locked project headlessly. Either close that Editor,"
    Write-Output "       or (for MAIN) just focus the Editor / use Assets > Refresh to let it import."
    exit 2
}

$log = Join-Path $Target "hud_refresh.log"
if (Test-Path $log) { Remove-Item $log -Force }

Write-Output "Refreshing (headless import) : $Target"
Start-Process -FilePath $UnityExe -ArgumentList @(
    "-batchmode","-quit","-projectPath",$Target,"-logFile",$log,"-accept-apiupdate"
) | Out-Null

# Unity.exe forks; wait for any Unity process on this project to disappear.
$deadline = (Get-Date).AddMinutes($MaxMinutes)
Start-Sleep -Seconds 10
$gone = $false
while ((Get-Date) -lt $deadline) {
    $p = Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" -ErrorAction SilentlyContinue |
         Where-Object { $_.CommandLine -like "*$Target*" }
    if (-not $p) { $gone = $true; break }
    Start-Sleep -Seconds 10
}

if (-not $gone) { Write-Output "WARN: Unity still running after $MaxMinutes min (refresh may be incomplete)." }

# Report compile/import errors if any surfaced.
$errs = @()
if (Test-Path $log) {
    $errs = Get-Content $log | Where-Object { $_ -match "error CS|Failed to import|Fatal Error|Aborting batchmode" }
}
if ($errs.Count -gt 0) {
    Write-Output "Refresh finished WITH errors:"
    $errs | Select-Object -First 20 | ForEach-Object { Write-Output "  $_" }
    exit 3
}
Write-Output "Refresh finished OK (log: $log)"
exit 0
