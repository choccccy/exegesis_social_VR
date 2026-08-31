<#
.SYNOPSIS
    Dump every model-asset sub-object with its Unity local file ID, headlessly.

.DESCRIPTION
    Unity derives a model sub-object's local file ID from its NAME. Renaming a bone in
    Blender therefore changes its file ID, and every scene reference to it goes missing
    without an error. Repairing that needs the name -> fileID map from BOTH sides of the
    rename, and the "before" side CANNOT be reconstructed once the FBX is reimported.

    Run this before renaming anything, commit the output, then run it again after.
    Tools/unity-repair/repair_refs.py joins the two through the rename table.

    HARD CONSTRAINT, same as refresh_assets.ps1: Unity locks a project to a single
    instance. This refuses to run while the Editor has the project open.

.EXAMPLE
    powershell Tools/unity-repair/dump_fbx_ids.ps1 -Out Tools/unity-repair/ncho_fbx_ids_before.json
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Out,
    [string[]]$Asset = @(),     # default: ncho + obi-me, per FbxIdDump.DefaultAssets
    [int]$MaxMinutes = 20,
    [string]$UnityExe = "C:\Program Files\Unity\Hub\Editor\2022.3.22f1\Editor\Unity.exe"
)

$ErrorActionPreference = "Stop"

# Tools/unity-repair/ -> project root
$Project = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path

if (-not (Test-Path (Join-Path $Project "ProjectSettings\ProjectVersion.txt"))) {
    Write-Output "ERROR: '$Project' is not a Unity project."; exit 1
}
if (-not (Test-Path $UnityExe)) {
    Write-Output "ERROR: Unity not found at '$UnityExe'."; exit 1
}

# Refuse if a live Unity process already holds this project (it would fail on the lock).
$openProc = Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" -ErrorAction SilentlyContinue |
            Where-Object { $_.CommandLine -like "*$Project*" }
if ($openProc) {
    Write-Output "ERROR: '$Project' is open in a Unity Editor (PID $($openProc.ProcessId))."
    Write-Output "       Close it, or run Tools > Exegesis > Debug > Dump FBX File IDs from that Editor."
    exit 2
}
if (Test-Path (Join-Path $Project "Temp\UnityLockfile")) {
    Write-Output "WARNING: Temp\UnityLockfile exists but no Unity.exe holds the project."
    Write-Output "         Treating it as a stale lock from an unclean shutdown and continuing."
}

if (-not [System.IO.Path]::IsPathRooted($Out)) { $Out = Join-Path $Project $Out }
$log = Join-Path $Project "fbx_id_dump.log"
if (Test-Path $log) { Remove-Item $log -Force }
if (Test-Path $Out) { Remove-Item $Out -Force }

$uArgs = @("-batchmode", "-quit", "-projectPath", $Project,
           "-executeMethod", "Exegesis.Shared.FbxIdDump.DumpFromCommandLine",
           "-fbxIdOut", $Out, "-logFile", $log, "-accept-apiupdate")
foreach ($a in $Asset) { $uArgs += @("-fbxAsset", $a) }

Write-Output "[$(Get-Date -Format HH:mm:ss)] Unity -executeMethod FbxIdDump (log: $log)"
$proc = Start-Process -FilePath $UnityExe -ArgumentList $uArgs -PassThru -Wait -NoNewWindow
Write-Output "[$(Get-Date -Format HH:mm:ss)] Unity exited with code $($proc.ExitCode)"

if (-not (Test-Path $Out)) {
    Write-Output "ERROR: no output at '$Out'. Tail of the Unity log:"
    if (Test-Path $log) { Get-Content $log -Tail 40 }
    exit 1
}

$size = (Get-Item $Out).Length
Write-Output "Wrote $Out ($size bytes)"
