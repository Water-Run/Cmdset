$ErrorActionPreference = 'Stop'

if ($args.Count -lt 1) {
    [Console]::Error.WriteLine('Usage: cx <command> [args...] [+ [args...]]...')
    exit 1
}

$base = $args[0]
$rest = @()
if ($args.Count -gt 1) { $rest = $args[1..($args.Count - 1)] }

$segments = New-Object System.Collections.Generic.List[object]
$current = New-Object System.Collections.Generic.List[string]
$hasPlus = $false

foreach ($a in $rest) {
    if ($a -eq '+') {
        $segments.Add(@($current.ToArray()))
        $current.Clear()
        $hasPlus = $true
    }
    else {
        $current.Add($a)
    }
}

if ($current.Count -gt 0) {
    $segments.Add(@($current.ToArray()))
}
elseif ($hasPlus) {
    $segments.Add(@())
}

if ($segments.Count -eq 0) {
    & $base
    if (-not $?) { if ($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }
    exit 0
}

foreach ($seg in $segments) {
    if ($seg.Count -eq 0) { & $base } else { & $base @seg }
    if (-not $?) { if ($LASTEXITCODE) { exit $LASTEXITCODE } else { exit 1 } }
}