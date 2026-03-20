@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "PS_EXE="

where pwsh >nul 2>nul
if %errorlevel%==0 (
    set "PS_EXE=pwsh"
) else (
    set "PS_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
)

"%PS_EXE%" -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; function fmt([double]$b){ if($b -ge 1TB){ '{0:N2} TiB' -f ($b/1TB) } elseif($b -ge 1GB){ '{0:N2} GiB' -f ($b/1GB) } elseif($b -ge 1MB){ '{0:N2} MiB' -f ($b/1MB) } elseif($b -ge 1KB){ '{0:N2} KiB' -f ($b/1KB) } else { '{0:N0} B' -f $b } }; $os=Get-CimInstance Win32_OperatingSystem; $cpu=(Get-CimInstance Win32_Processor)[0]; $cv=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'; $display=if($cv.DisplayVersion){$cv.DisplayVersion}elseif($cv.ReleaseId){$cv.ReleaseId}else{'N/A'}; $build='{0}.{1}' -f $cv.CurrentBuild,$cv.UBR; $boot=$os.LastBootUpTime; $up=(Get-Date)-$boot; $days=[int]$up.TotalDays; $total=[double]$os.TotalVisibleMemorySize*1KB; $free=[double]$os.FreePhysicalMemory*1KB; $used=$total-$free; Write-Host '=== My Windows ===' -ForegroundColor Cyan; Write-Host ('Computer      : {0}' -f $env:COMPUTERNAME); Write-Host ('User          : {0}\{1}' -f $env:USERDOMAIN,$env:USERNAME); Write-Host ('OS            : {0}' -f $os.Caption); Write-Host ('Version       : {0} (Build {1})' -f $display,$build); Write-Host ('Architecture  : {0}' -f $os.OSArchitecture); Write-Host ('CPU           : {0}' -f $cpu.Name.Trim()); Write-Host ('Memory        : Total {0} / Used {1} / Free {2}' -f (fmt $total),(fmt $used),(fmt $free)); Write-Host ('Boot Time     : {0:yyyy-MM-dd HH:mm:ss}' -f $boot); Write-Host ('Uptime        : {0}d {1:00}h {2:00}m {3:00}s' -f $days,$up.Hours,$up.Minutes,$up.Seconds)"

exit /b %errorlevel%