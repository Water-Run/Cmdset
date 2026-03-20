@echo off
setlocal EnableExtensions DisableDelayedExpansion

if /I "%~1"=="-h" goto :help
if /I "%~1"=="--help" goto :help

set "PS_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
set "TARGET=."
if not "%~1"=="" set "TARGET=%~1"

"%PS_EXE%" -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0admin-wt-launch.ps1" Cmd "%TARGET%"
exit /b %errorlevel%

:help
echo Usage: admincmd [DIR]
echo Open elevated Windows Terminal with cmd at DIR.
echo Default DIR is current directory.
exit /b 0