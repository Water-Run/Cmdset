$ErrorActionPreference = 'Stop'

function Die([string]$m) {
    [Console]::Error.WriteLine("Error: $m")
    exit 1
}

function NeedCmd([string]$n) {
    if (-not (Get-Command $n -ErrorAction SilentlyContinue)) {
        Die "Missing command: $n"
    }
}

function SetKV([string]$file, [string]$key, [string]$value) {
    $raw = if (Test-Path -LiteralPath $file) { Get-Content -LiteralPath $file -Raw } else { '' }
    $pat = '(?m)^[\t ]*' + [regex]::Escape($key) + '[\t ]*=.*$'
    $line = "$key = $value"
    if ($raw -match $pat) {
        $raw = [regex]::Replace($raw, $pat, $line)
    }
    else {
        if ($raw.Length -gt 0 -and -not $raw.EndsWith([Environment]::NewLine)) { $raw += [Environment]::NewLine }
        $raw += $line + [Environment]::NewLine
    }
    Set-Content -LiteralPath $file -Value $raw -Encoding UTF8
}

if ($args.Count -ne 1) {
    [Console]::Error.WriteLine('Usage: doxygenning <target_dir>')
    exit 2
}

$target = $args[0]
if (-not (Test-Path -LiteralPath $target -PathType Container)) { Die "Not a directory: $target" }

NeedCmd 'doxygen'
NeedCmd 'firefox'

$target = (Resolve-Path -LiteralPath $target).Path
$docsDir = Join-Path $target 'docs'
$doxyfile = Join-Path $target 'Doxyfile'
$htmlIndex = Join-Path $docsDir 'html\index.html'

Write-Host "[1/5] Target: $target"
Write-Host '[2/5] Ensure Doxyfile'
if (-not (Test-Path -LiteralPath $doxyfile -PathType Leaf)) {
    Push-Location $target
    try { $null = & doxygen -g } finally { Pop-Location }
    Write-Host "  - Generated: $doxyfile"
}
else {
    Write-Host "  - Exists: $doxyfile"
}

$inputs = @()
if (Test-Path -LiteralPath (Join-Path $target 'include') -PathType Container) { $inputs += 'include' }
if (Test-Path -LiteralPath (Join-Path $target 'src') -PathType Container) { $inputs += 'src' }
if ($inputs.Count -eq 0) { $inputs += '.' }

$haveDot = if (Get-Command dot -ErrorAction SilentlyContinue) { 'YES' } else { 'NO' }

Write-Host '[3/5] Patch Doxyfile'
SetKV $doxyfile 'OUTPUT_DIRECTORY' 'docs'
SetKV $doxyfile 'GENERATE_HTML' 'YES'
SetKV $doxyfile 'RECURSIVE' 'YES'
SetKV $doxyfile 'EXTRACT_ALL' 'NO'
SetKV $doxyfile 'QUIET' 'YES'
SetKV $doxyfile 'WARN_IF_UNDOCUMENTED' 'YES'
SetKV $doxyfile 'WARN_NO_PARAMDOC' 'YES'
SetKV $doxyfile 'INPUT' ($inputs -join ' ')
SetKV $doxyfile 'HAVE_DOT' $haveDot
if ($haveDot -eq 'YES') {
    SetKV $doxyfile 'CLASS_DIAGRAMS' 'YES'
    SetKV $doxyfile 'CALL_GRAPH' 'NO'
    SetKV $doxyfile 'CALLER_GRAPH' 'NO'
    SetKV $doxyfile 'DOT_IMAGE_FORMAT' 'svg'
}

Write-Host '[4/5] Run doxygen'
Push-Location $target
try { & doxygen $doxyfile } finally { Pop-Location }

if (-not (Test-Path -LiteralPath $htmlIndex -PathType Leaf)) { Die "HTML not generated: $htmlIndex" }

Write-Host "[5/5] Open in Firefox: $htmlIndex"
$uri = (New-Object System.Uri($htmlIndex)).AbsoluteUri
$null = Start-Process firefox $uri
Write-Host 'Done.'