@echo off
chcp 65001 >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Failed to set code page to UTF-8.
    exit /b 1
)
echo Active code page: 65001
exit /b 0