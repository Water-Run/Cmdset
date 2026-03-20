@echo off
setlocal EnableExtensions DisableDelayedExpansion

if /I "%~1"=="-h" goto :help
if /I "%~1"=="--help" goto :help

if "%~1"=="" (
    start "" "."
    exit /b %errorlevel%
)

:loop
if "%~1"=="" exit /b 0
start "" "%~1"
if errorlevel 1 exit /b %errorlevel%
shift
goto :loop

:help
echo Usage: open [TARGET...]
echo.
echo Open file/folder/URL with default Windows association.
echo Examples:
echo   open
echo   open .
echo   open README.md
echo   open https://example.com
echo   open a.txt b.txt
exit /b 0