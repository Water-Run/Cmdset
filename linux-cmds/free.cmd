@echo off
setlocal

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "$ErrorActionPreference='Stop'; function fmt([double]$b){ if($b -ge 1TB){ '{0:N2} TiB' -f ($b / 1TB) } elseif($b -ge 1GB){ '{0:N2} GiB' -f ($b / 1GB) } elseif($b -ge 1MB){ '{0:N2} MiB' -f ($b / 1MB) } elseif($b -ge 1KB){ '{0:N2} KiB' -f ($b / 1KB) } else { '{0:N0} B' -f $b } }; $os=Get-CimInstance Win32_OperatingSystem; $total=[double]$os.TotalVisibleMemorySize * 1KB; $free=[double]$os.FreePhysicalMemory * 1KB; $used=$total-$free; 'Memory'; '  Total  {0}' -f (fmt $total); '  Used   {0}' -f (fmt $used); '  Free   {0}' -f (fmt $free)"

exit /b %errorlevel%