@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "PS_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
where pwsh >nul 2>nul && set "PS_EXE=pwsh"

"%PS_EXE%" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0printenv.ps1" %*
exit /b %errorlevel%