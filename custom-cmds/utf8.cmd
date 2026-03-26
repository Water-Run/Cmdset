@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "OLD_CP="
for /f "tokens=2 delims=:." %%A in ('chcp') do set "OLD_CP=%%A"
if defined OLD_CP set "OLD_CP=%OLD_CP: =%"

set "CP_OK=1"
chcp 65001 >nul 2>nul
if errorlevel 1 set "CP_OK=0"

set "PS_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
where pwsh >nul 2>nul && set "PS_EXE=pwsh"

"%PS_EXE%" -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
"$ErrorActionPreference='SilentlyContinue';" ^
"$utf8 = [System.Text.UTF8Encoding]::new($false);" ^
"try { [Console]::InputEncoding  = $utf8 } catch {};" ^
"try { [Console]::OutputEncoding = $utf8 } catch {};" ^
"try { $OutputEncoding = $utf8 } catch {};" >nul 2>nul

echo === UTF-8 Terminal ===
if defined OLD_CP (
    echo Previous CP : %OLD_CP%
) else (
    echo Previous CP : N/A
)
echo Current  CP : 65001
if "%CP_OK%"=="1" (
    echo Status      : OK
) else (
    echo Status      : PARTIAL ^(chcp not available in this host^)
)

exit /b 0