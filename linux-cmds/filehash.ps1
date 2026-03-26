$ErrorActionPreference = 'Stop'

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('SHA256', 'SHA1', 'MD5')]
    [string]$Algorithm,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Paths
)

if (-not $Paths -or $Paths.Count -eq 0) {
    $name = $Algorithm.ToLowerInvariant()
    [Console]::Error.WriteLine("Usage: $name FILE [FILE...]")
    exit 1
}

function Get-HashHexLegacy([string]$LiteralPath, [string]$AlgoName) {
    $stream = $null
    $algo = $null
    try {
        $stream = [System.IO.File]::OpenRead($LiteralPath)
        $algo = [System.Security.Cryptography.HashAlgorithm]::Create($AlgoName)
        if (-not $algo) { throw "Unsupported algorithm: $AlgoName" }
        $bytes = $algo.ComputeHash($stream)
        return ( -join ($bytes | ForEach-Object { $_.ToString('x2') }))
    }
    finally {
        if ($algo) { $algo.Dispose() }
        if ($stream) { $stream.Dispose() }
    }
}

$hasGetFileHash = $null -ne (Get-Command Get-FileHash -ErrorAction SilentlyContinue)
$failed = $false

foreach ($p in $Paths) {
    try {
        $full = (Get-Item -LiteralPath $p -ErrorAction Stop).FullName
        if ($hasGetFileHash) {
            $hash = (Get-FileHash -LiteralPath $full -Algorithm $Algorithm -ErrorAction Stop).Hash.ToLowerInvariant()
        }
        else {
            $hash = Get-HashHexLegacy -LiteralPath $full -AlgoName $Algorithm
        }
        '{0}  {1}' -f $hash, $full
    }
    catch {
        [Console]::Error.WriteLine("{0}: {1}" -f $Algorithm.ToLowerInvariant(), $_.Exception.Message)
        $failed = $true
    }
}

if ($failed) { exit 1 }
exit 0