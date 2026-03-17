@echo off
setlocal

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop'; $boot=(Get-CimInstance Win32_OperatingSystem).LastBootUpTime; $span=(Get-Date)-$boot; $days=[int]$span.TotalDays; 'Up since  {0:yyyy-MM-dd HH:mm:ss}' -f $boot; 'Uptime    {0}d {1:00}h {2:00}m {3:00}s' -f $days,$span.Hours,$span.Minutes,$span.Seconds"

exit /b %errorlevel%