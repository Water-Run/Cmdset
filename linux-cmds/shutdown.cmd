@echo off
setlocal

if /I "%~1"=="now" (
    shift
    "%SystemRoot%\System32\shutdown.exe" /s /t 0 %*
    exit /b %errorlevel%
)

"%SystemRoot%\System32\shutdown.exe" %*
exit /b %errorlevel%