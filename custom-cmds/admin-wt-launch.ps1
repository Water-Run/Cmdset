param(
    [ValidateSet('Auto', 'Cmd', 'PowerShell', 'Pwsh')]
    [string]$Shell = 'Auto',

    [string]$TargetPath = '.'
)

$ErrorActionPreference = 'Stop'

function Die([string]$msg, [int]$code = 1) {
    [Console]::Error.WriteLine("Error: $msg")
    exit $code
}

# 检查 Windows Terminal
$wtCmd = Get-Command wt -ErrorAction SilentlyContinue
if (-not $wtCmd) {
    Die "Windows Terminal (wt.exe) not found in PATH. Please install Windows Terminal."
}

# 解析路径
try {
    $resolvedPath = (Resolve-Path -LiteralPath $TargetPath -ErrorAction Stop).Path
}
catch {
    Die "Path not found: $TargetPath"
}

if (-not (Test-Path -LiteralPath $resolvedPath -PathType Container)) {
    Die "Not a directory: $resolvedPath"
}

# 选择 shell
$shellExe = $null
switch ($Shell) {
    'Cmd' {
        $shellExe = $env:ComSpec
    }
    'PowerShell' {
        $shellExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    }
    'Pwsh' {
        $pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
        if (-not $pwsh) { Die "pwsh not found in PATH." }
        $shellExe = $pwsh.Source
    }
    'Auto' {
        $pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
        if ($pwsh) {
            $shellExe = $pwsh.Source
        }
        else {
            $shellExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        }
    }
}

if (-not $shellExe) {
    Die "Failed to resolve shell executable."
}

# 以管理员启动 Windows Terminal，并把首 tab 目录设为目标目录
# new-tab 显式写出，兼容性更稳
$wtArgs = @('new-tab', '-d', $resolvedPath, $shellExe)

Start-Process -Verb RunAs -FilePath $wtCmd.Source -ArgumentList $wtArgs | Out-Null
exit 0