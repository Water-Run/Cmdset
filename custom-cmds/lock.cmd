@echo off
"%SystemRoot%\System32\rundll32.exe" user32.dll,LockWorkStation
exit /b %errorlevel%