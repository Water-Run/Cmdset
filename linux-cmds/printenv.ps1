$ErrorActionPreference = 'Stop'

if ($args.Count -eq 0) {
    Get-ChildItem Env: |
    Sort-Object Name |
    ForEach-Object { '{0}={1}' -f $_.Name, $_.Value }
    exit 0
}

$failed = $false
foreach ($n in $args) {
    $v = [Environment]::GetEnvironmentVariable($n)
    if ($null -eq $v) {
        $failed = $true
    }
    else {
        $v
    }
}

if ($failed) { exit 1 }
exit 0