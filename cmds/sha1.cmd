@echo off
setlocal

if "%~1"=="" (
    echo Usage: sha1 FILE [FILE...]
    exit /b 1
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "& { $ErrorActionPreference='Stop'; foreach($p in $args){ $full=(Get-Item -LiteralPath $p -ErrorAction Stop).FullName; $hash=(Get-FileHash -LiteralPath $full -Algorithm SHA1).Hash.ToLowerInvariant(); '{0}  {1}' -f $hash, $full } }" %*

exit /b %errorlevel%