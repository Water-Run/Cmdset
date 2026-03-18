@echo off
setlocal

if "%~1"=="" (
    echo Usage: which COMMAND [COMMAND...]
    exit /b 1
)

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Command ^
  "& { $ErrorActionPreference='Stop'; $failed=$false; foreach($name in $args){ $cmds=Get-Command -All -Name $name -ErrorAction SilentlyContinue; if(-not $cmds){ [Console]::Error.WriteLine('which: command not found: ' + $name); $failed=$true; continue }; foreach($cmd in $cmds){ if($cmd.Path){ $cmd.Path } elseif($cmd.Definition){ '{0}: {1}' -f $cmd.CommandType, $cmd.Definition } else { '{0}: {1}' -f $cmd.CommandType, $cmd.Name } } }; if($failed){ exit 1 } }" %*

exit /b %errorlevel%