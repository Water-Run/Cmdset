#Requires -Version 5.1
# ────────────────────────────────────────────────────
#  cmdset · test suite
#  Usage:  pwsh  ./_test/test.ps1
#          powershell ./_test/test.ps1
# ────────────────────────────────────────────────────

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

#region ── Paths ───────────────────────────────────────────────
$Root       = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$DirLinux   = Join-Path $Root 'linux-cmds'
$DirCustom  = Join-Path $Root 'custom-cmds'
$DirBinTool = Join-Path $Root 'binary-tools'
$DirBin     = Join-Path $Root 'binaries'
#endregion

#region ── Temp workspace & fixtures ───────────────────────────
$Tmp = Join-Path ([IO.Path]::GetTempPath()) "cmdset-test-$PID"
if (Test-Path $Tmp) { Remove-Item $Tmp -Recurse -Force }
[void](New-Item -ItemType Directory -Path $Tmp -Force)

$Fixture = Join-Path $Tmp 'fixture.txt'
[IO.File]::WriteAllText($Fixture, 'hello')
#endregion

#region ── State ───────────────────────────────────────────────
$script:nPass = 0
$script:nFail = 0
$script:nSkip = 0
$script:Rows  = [Collections.Generic.List[PSCustomObject]]::new()
$sw = [Diagnostics.Stopwatch]::StartNew()
#endregion

#region ── Helpers ─────────────────────────────────────────────

function Record([string]$Group, [string]$Name, [string]$Status, [string]$Detail) {
    switch ($Status) {
        'PASS' { $script:nPass++; $color = 'Green'  }
        'FAIL' { $script:nFail++; $color = 'Red'    }
        'SKIP' { $script:nSkip++; $color = 'Yellow' }
    }
    $script:Rows.Add([PSCustomObject]@{
        Group  = $Group
        Name   = $Name
        Status = $Status
        Detail = $Detail
    })
    Write-Host ("  [{0,-4}] {1,-34} {2}" -f $Status, $Name, $Detail) -ForegroundColor $color
}

function Invoke-Sub([string]$File, [string]$Arguments = '', [int]$TimeoutMs = 30000) {
    $psi = [Diagnostics.ProcessStartInfo]::new()
    $psi.FileName               = 'cmd.exe'
    $psi.Arguments              = "/c `"`"$File`" $Arguments`""
    $psi.UseShellExecute        = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.CreateNoWindow         = $true
    $psi.WorkingDirectory       = $Tmp

    $p = [Diagnostics.Process]::Start($psi)
    $outTask = $p.StandardOutput.ReadToEndAsync()
    $errTask = $p.StandardError.ReadToEndAsync()

    if (-not $p.WaitForExit($TimeoutMs)) {
        try { $p.Kill() } catch { }
        return @{ Code = -1; Out = ''; Err = 'TIMEOUT' }
    }
    @{ Code = $p.ExitCode; Out = $outTask.Result; Err = $errTask.Result }
}

function Test-Cmd {
    param(
        [string]$Group,
        [string]$Name,
        [string]$File,
        [string]$Arguments    = '',
        [int]   $ExpectedExit = 0,
        [string]$OutputMatch  = '',
        [int]   $TimeoutMs    = 30000
    )
    if (-not (Test-Path -LiteralPath $File)) {
        Record $Group $Name 'FAIL' "Missing: $File"; return
    }
    try {
        $r = Invoke-Sub -File $File -Arguments $Arguments -TimeoutMs $TimeoutMs
        if ($r.Code -eq -1) { Record $Group $Name 'FAIL' 'Timeout'; return }
        if ($r.Code -ne $ExpectedExit) {
            $d = "Exit $($r.Code) (expected $ExpectedExit)"
            $e = if ($r.Err) { $r.Err.Trim() } else { '' }
            if ($e) {
                if ($e.Length -gt 80) { $e = $e.Substring(0, 80) + '...' }
                $d += "  [$e]"
            }
            Record $Group $Name 'FAIL' $d; return
        }
        if ($OutputMatch -and ($r.Out -notmatch $OutputMatch)) {
            Record $Group $Name 'FAIL' "Output !~ /$OutputMatch/"
            return
        }
        Record $Group $Name 'PASS' ''
    }
    catch {
        Record $Group $Name 'FAIL' $_.Exception.Message
    }
}

function Skip-Cmd([string]$Group, [string]$Name, [string]$File, [string]$Reason) {
    if (Test-Path -LiteralPath $File) { Record $Group $Name 'SKIP' $Reason }
    else                               { Record $Group $Name 'FAIL' "Missing: $File" }
}

function Section([string]$Title) {
    Write-Host ''
    Write-Host "  -- $Title --" -ForegroundColor DarkCyan
}

#endregion

# ==============================================================
#  Banner
# ==============================================================
Write-Host ''
Write-Host '  +========================================+' -ForegroundColor Cyan
Write-Host '  |       cmdset  -  Test Suite            |' -ForegroundColor Cyan
Write-Host '  +========================================+' -ForegroundColor Cyan

# ==============================================================
#  linux-cmds
# ==============================================================
Section 'linux-cmds'

# Destructive: file-existence only
Skip-Cmd 'linux' 'reboot'   (Join-Path $DirLinux 'reboot.cmd')   'Destructive'
Skip-Cmd 'linux' 'shutdown' (Join-Path $DirLinux 'shutdown.cmd') 'Destructive'
Skip-Cmd 'linux' 'halt'     (Join-Path $DirLinux 'halt.cmd')     'Destructive'
Skip-Cmd 'linux' 'logout'   (Join-Path $DirLinux 'logout.cmd')   'Destructive'

# which
Test-Cmd 'linux' 'which (found)' `
    (Join-Path $DirLinux 'which.cmd') `
    -Arguments 'cmd' -ExpectedExit 0 -OutputMatch 'cmd'

Test-Cmd 'linux' 'which (not found)' `
    (Join-Path $DirLinux 'which.cmd') `
    -Arguments '__no_such_cmd_x__' -ExpectedExit 1

# touch
$touchTarget = Join-Path $Tmp 'newfile.txt'
Test-Cmd 'linux' 'touch (create)' `
    (Join-Path $DirLinux 'touch.cmd') `
    -Arguments "`"$touchTarget`""

if (Test-Path -LiteralPath $touchTarget) { Record 'linux' 'touch (verify)' 'PASS' '' }
else                                      { Record 'linux' 'touch (verify)' 'FAIL' 'File not created' }

Test-Cmd 'linux' 'touch (existing)' `
    (Join-Path $DirLinux 'touch.cmd') `
    -Arguments "`"$Fixture`""

# realpath
Test-Cmd 'linux' 'realpath' `
    (Join-Path $DirLinux 'realpath.cmd') `
    -Arguments '.' -OutputMatch '^\w:\\'

# Hashes
Test-Cmd 'linux' 'sha256' `
    (Join-Path $DirLinux 'sha256.cmd') `
    -Arguments "`"$Fixture`"" -OutputMatch '^[0-9a-f]{64}\s'

Test-Cmd 'linux' 'sha1' `
    (Join-Path $DirLinux 'sha1.cmd') `
    -Arguments "`"$Fixture`"" -OutputMatch '^[0-9a-f]{40}\s'

Test-Cmd 'linux' 'md5' `
    (Join-Path $DirLinux 'md5.cmd') `
    -Arguments "`"$Fixture`"" -OutputMatch '^[0-9a-f]{32}\s'

# sleep
Test-Cmd 'linux' 'sleep 0' `
    (Join-Path $DirLinux 'sleep.cmd') `
    -Arguments '0' -TimeoutMs 5000

Test-Cmd 'linux' 'sleep 0.1' `
    (Join-Path $DirLinux 'sleep.cmd') `
    -Arguments '0.1' -TimeoutMs 5000

# System info
Test-Cmd 'linux' 'uptime' `
    (Join-Path $DirLinux 'uptime.cmd') `
    -OutputMatch 'Up'

Test-Cmd 'linux' 'free' `
    (Join-Path $DirLinux 'free.cmd') `
    -OutputMatch 'Memory'

Test-Cmd 'linux' 'uname' `
    (Join-Path $DirLinux 'uname.cmd') `
    -OutputMatch 'Windows'

Test-Cmd 'linux' 'uname -a' `
    (Join-Path $DirLinux 'uname.cmd') `
    -Arguments '-a' -OutputMatch 'Windows_NT'

Test-Cmd 'linux' 'hostname' `
    (Join-Path $DirLinux 'hostname.cmd') `
    -OutputMatch '\S'

Test-Cmd 'linux' 'hostname -I' `
    (Join-Path $DirLinux 'hostname.cmd') `
    -Arguments '-I' -OutputMatch '\d+\.\d+'

Test-Cmd 'linux' 'pwd' `
    (Join-Path $DirLinux 'pwd.cmd') `
    -OutputMatch '^\w:\\'

# printenv
Test-Cmd 'linux' 'printenv PATH' `
    (Join-Path $DirLinux 'printenv.cmd') `
    -Arguments 'PATH' -OutputMatch '\S'

Test-Cmd 'linux' 'printenv (all)' `
    (Join-Path $DirLinux 'printenv.cmd') `
    -OutputMatch 'PATH='

# ==============================================================
#  custom-cmds
# ==============================================================
Section 'custom-cmds'

Test-Cmd  'custom' 'utf8' `
    (Join-Path $DirCustom 'utf8.cmd') `
    -OutputMatch '65001'

Skip-Cmd  'custom' 'lock' `
    (Join-Path $DirCustom 'lock.cmd') 'Destructive'

Skip-Cmd  'custom' 'hibernate' `
    (Join-Path $DirCustom 'hibernate.cmd') 'Destructive'

Test-Cmd  'custom' 'open -h' `
    (Join-Path $DirCustom 'open.cmd') `
    -Arguments '-h' -OutputMatch 'Usage'

Test-Cmd  'custom' 'mywin' `
    (Join-Path $DirCustom 'mywin.cmd') `
    -OutputMatch 'Windows'

Test-Cmd  'custom' 'winenv PATH' `
    (Join-Path $DirCustom 'winenv.cmd') `
    -Arguments 'PATH' -OutputMatch '\S'

# admin helpers: help flag only (no UAC)
Test-Cmd  'custom' 'admin -h' `
    (Join-Path $DirCustom 'admin.cmd') `
    -Arguments '-h' -OutputMatch 'Usage'

Test-Cmd  'custom' 'admincmd -h' `
    (Join-Path $DirCustom 'admincmd.cmd') `
    -Arguments '-h' -OutputMatch 'Usage'

Test-Cmd  'custom' 'adminpowershell -h' `
    (Join-Path $DirCustom 'adminpowershell.cmd') `
    -Arguments '-h' -OutputMatch 'Usage'

Test-Cmd  'custom' 'adminpwsh -h' `
    (Join-Path $DirCustom 'adminpwsh.cmd') `
    -Arguments '-h' -OutputMatch 'Usage'

# cx
Test-Cmd  'custom' 'cx (single)' `
    (Join-Path $DirCustom 'cx.cmd') `
    -Arguments 'echo hello' -OutputMatch 'hello'

Test-Cmd  'custom' 'cx (multi)' `
    (Join-Path $DirCustom 'cx.cmd') `
    -Arguments 'echo aaa + bbb' -OutputMatch '(?s)aaa.*bbb'

Test-Cmd  'custom' 'cx (no args)' `
    (Join-Path $DirCustom 'cx.cmd') `
    -ExpectedExit 1

# doxygenning: needs external tools
Skip-Cmd  'custom' 'doxygenning' `
    (Join-Path $DirCustom 'doxygenning.cmd') 'Needs doxygen + firefox'

# ==============================================================
#  binary-tools
# ==============================================================
Section 'binary-tools'

foreach ($tool in 'pmc', 'treepp') {
    $found = $false
    foreach ($dir in $DirBinTool, $DirBin) {
        if ((Test-Path $dir) -and
            (Get-ChildItem $dir -Filter "$tool*" -File -ErrorAction SilentlyContinue)) {
            $found = $true; break
        }
    }
    if (-not $found -and (Get-Command $tool -ErrorAction SilentlyContinue)) {
        $found = $true
    }
    $detail = if ($found) { 'External binary (present)' } else { 'External binary (not found)' }
    Record 'binary' $tool 'SKIP' $detail
}

# ==============================================================
#  Summary
# ==============================================================
$sw.Stop()
$total = $script:nPass + $script:nFail + $script:nSkip
$bar   = '  ============================================'

Write-Host ''
Write-Host $bar -ForegroundColor Cyan
Write-Host ("  Total    : {0}" -f $total)
Write-Host ("  Passed   : {0}" -f $script:nPass)  -ForegroundColor Green
Write-Host ("  Failed   : {0}" -f $script:nFail)  -ForegroundColor $(if ($script:nFail -gt 0) { 'Red' } else { 'Green' })
Write-Host ("  Skipped  : {0}" -f $script:nSkip)  -ForegroundColor Yellow
Write-Host ("  Duration : {0:N2}s" -f $sw.Elapsed.TotalSeconds)
Write-Host $bar -ForegroundColor Cyan

if ($script:nFail -gt 0) {
    Write-Host ''
    Write-Host '  Failed tests:' -ForegroundColor Red
    foreach ($r in $script:Rows) {
        if ($r.Status -eq 'FAIL') {
            Write-Host ("    x [{0}] {1} -- {2}" -f $r.Group, $r.Name, $r.Detail) -ForegroundColor Red
        }
    }
}

Write-Host ''

# Cleanup
Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue

exit $(if ($script:nFail -gt 0) { 1 } else { 0 })