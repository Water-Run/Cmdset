@echo off
setlocal

if "%~1"=="" (
    powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "Start-Process ."
    exit /b %errorlevel%
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath $args[0]" %*
exit /b %errorlevel%