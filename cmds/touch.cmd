@echo off
setlocal

if "%~1"=="" (
    echo Usage: touch FILE [FILE...]
    exit /b 1
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "& { $ErrorActionPreference='Stop'; $now=Get-Date; foreach($p in $args){ if(Test-Path -LiteralPath $p){ $item=Get-Item -LiteralPath $p -Force; $item.LastWriteTime=$now; $item.LastAccessTime=$now } else { $null=New-Item -ItemType File -Path $p -Force } } }" %*

exit /b %errorlevel%