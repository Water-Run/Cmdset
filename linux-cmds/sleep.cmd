@echo off
setlocal

if "%~1"=="" (
    echo Usage: sleep SECONDS
    exit /b 1
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "& { $ErrorActionPreference='Stop'; if($args.Count -ne 1){ [Console]::Error.WriteLine('Usage: sleep SECONDS'); exit 1 }; $sec=[double]::Parse($args[0],[System.Globalization.CultureInfo]::InvariantCulture); if($sec -lt 0){ [Console]::Error.WriteLine('sleep: seconds must be >= 0'); exit 1 }; Start-Sleep -Milliseconds ([int][Math]::Round($sec * 1000)) }" %*

exit /b %errorlevel%