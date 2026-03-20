$ErrorActionPreference = 'Stop'

if ($args.Count -eq 0) {
    foreach ($it in Get-ChildItem Env:) {
        '{0}={1}' -f $it.Name, $it.Value
    }
    exit 0
}

$failed = $false
foreach ($n in $args) {
    $v = [Environment]::GetEnvironmentVariable($n)
    if ($null -eq $v) {
        [Console]::Error.WriteLine("winenv: not found: $n")
        $failed = $true
    }
    else {
        $v
    }
}

if ($failed) { exit 1 }