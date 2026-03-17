@echo off
setlocal

if "%~1"=="" (
    echo Usage: realpath PATH [PATH...]
    exit /b 1
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop'; foreach($p in $args){ if(Test-Path -LiteralPath $p){ foreach($rp in Resolve-Path -LiteralPath $p){ $rp.Path } } else { [System.IO.Path]::GetFullPath([System.IO.Path]::Combine((Get-Location).Path, $p)) } }" %*

exit /b %errorlevel%