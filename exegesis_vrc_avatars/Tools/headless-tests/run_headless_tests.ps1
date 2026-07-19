<#
.SYNOPSIS
    Run the HUD shader EditMode tests headlessly against a project CLONE, so it works
    even while the Unity Editor has the real project open (Unity locks a project folder
    to a single instance).

.DESCRIPTION
    1. Mirrors the project into a clone (robocopy /MIR, excluding Library/Temp/Logs so
       the clone keeps its warm import cache).
    2. Launches Unity -runTests -batchmode against the clone.
    3. Waits on the results artifact (Unity.exe forks and the launcher returns early, so
       its exit code is unreliable - we wait for hud_test_results.xml / the clone's
       Unity process to exit).
    4. Summarizes pass/fail.

    See docs/testing.md for the full workflow and gotchas.

.EXAMPLE
    pwsh Tools/headless-tests/run_headless_tests.ps1            # compare vs baselines
    pwsh Tools/headless-tests/run_headless_tests.ps1 -Capture   # (re)capture baselines
#>
[CmdletBinding()]
param(
    [switch]$Capture,          # HUD_CAPTURE_BASELINES=1: write baselines instead of comparing
    [switch]$SkipSync,         # skip the robocopy mirror (reuse the clone as-is)
    [string]$TestFilter = "",  # optional NUnit filter, e.g. Exegesis.HudShader.Tests.ShaderCompileTests
    [int]$MaxMinutes = 45,     # how long to wait for the (forked) Unity run
    [string]$CloneDir = "",    # override clone location (default: sibling of the git repo)
    [string]$UnityExe = "C:\Program Files\Unity\Hub\Editor\2022.3.22f1\Editor\Unity.exe"
)

$ErrorActionPreference = "Stop"

# Project root = two levels up from this script (Tools/headless-tests/ -> project root).
$Src = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
if ($CloneDir -eq "") {
    $gitRoot   = Split-Path $Src -Parent      # exegesis_social_VR
    $unityBase = Split-Path $gitRoot -Parent  # ...\unity
    $CloneDir  = Join-Path $unityBase "exegesis_headless_clone"
}
$Dst       = $CloneDir
$cloneLeaf = Split-Path $Dst -Leaf
$Results   = Join-Path $Dst "hud_test_results.xml"
$UnityLog  = Join-Path $Dst "hud_headless.log"
$Status    = Join-Path $Dst "hud_run_status.txt"

function Stamp($msg) {
    $line = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $msg
    Write-Output $line
    Add-Content -Path $Status -Value $line -Encoding utf8 -ErrorAction SilentlyContinue
}
function CloneUnityRunning {
    $procs = Get-CimInstance Win32_Process -Filter "Name='Unity.exe'" -ErrorAction SilentlyContinue |
             Where-Object { $_.CommandLine -like "*$cloneLeaf*" }
    return [bool]$procs
}

New-Item -ItemType Directory -Force -Path $Dst | Out-Null
Set-Content -Path $Status -Value "" -Encoding utf8

# ---- 1. sync -----------------------------------------------------------------------
if (-not $SkipSync) {
    Stamp "Sync start (robocopy /MIR, excluding Library/Temp/Logs)"
    $exclude = @("Library","Temp","Logs","obj","Build",".vs") | ForEach-Object { Join-Path $Src $_ }
    robocopy $Src $Dst /MIR /XD $exclude /NFL /NDL /NJH /NJS /NP /R:1 /W:1 | Out-Null
    if ($LASTEXITCODE -ge 8) { Stamp "robocopy FAILED code $LASTEXITCODE"; exit 1 }
    Stamp "Sync done (robocopy code $LASTEXITCODE)"
} else { Stamp "Sync skipped" }

# ---- 2. run ------------------------------------------------------------------------
if (Test-Path $Results) { Remove-Item $Results -Force }
if (Test-Path $UnityLog) { Remove-Item $UnityLog -Force }

if ($Capture) { $env:HUD_CAPTURE_BASELINES = "1"; Stamp "Capture mode ON" }
else { Remove-Item Env:\HUD_CAPTURE_BASELINES -ErrorAction SilentlyContinue }

$uArgs = @("-runTests","-batchmode","-projectPath",$Dst,"-testPlatform","EditMode",
           "-testResults",$Results,"-logFile",$UnityLog,"-accept-apiupdate")
if ($TestFilter -ne "") { $uArgs += @("-testFilter",$TestFilter) }

Stamp "Unity -runTests launch (first run imports assets; may take a while)"
Start-Process -FilePath $UnityExe -ArgumentList $uArgs | Out-Null

$deadline = (Get-Date).AddMinutes($MaxMinutes)
Start-Sleep -Seconds 15  # let Unity spawn before checking
while ((Get-Date) -lt $deadline) {
    if (Test-Path $Results) { Start-Sleep -Seconds 3; break }
    if (-not (CloneUnityRunning)) { Start-Sleep -Seconds 5; break }
    Start-Sleep -Seconds 20
}

# ---- 3. summarize ------------------------------------------------------------------
$code = 3
if (Test-Path $Results) {
    $code = 0
    try {
        [xml]$xml = Get-Content $Results
        $r = $xml.'test-run'
        Stamp ("Results: total={0} passed={1} failed={2} skipped={3} inconclusive={4}" -f `
            $r.total,$r.passed,$r.failed,$r.skipped,$r.inconclusive)
        if ([int]$r.failed -gt 0) { $code = 2 }
        foreach ($f in $xml.SelectNodes("//test-case[@result='Failed']")) {
            $m = $f.SelectSingleNode(".//message")
            $mt = if ($m) { ($m.InnerText -replace "\s+"," ").Trim() } else { "" }
            if ($mt.Length -gt 300) { $mt = $mt.Substring(0,300) }
            Stamp ("FAIL: {0} :: {1}" -f $f.fullname, $mt)
        }
    } catch { Stamp "Could not parse results xml: $_" }
} else {
    Stamp "No results xml (compile/import error or timeout). Log tail:"
    if (Test-Path $UnityLog) { Get-Content $UnityLog -Tail 40 | ForEach-Object { Add-Content -Path $Status -Value $_ -Encoding utf8 } }
}

Stamp "DONE (exit $code)"
exit $code
