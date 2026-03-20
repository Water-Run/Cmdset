$ErrorActionPreference = 'Stop'

$show = [ordered]@{ s = $false; n = $false; r = $false; v = $false; m = $false; o = $false }

if ($args.Count -eq 0) { $show.s = $true }

foreach ($a in $args) {
    if ($a -eq '--help') {
        'Usage: uname [OPTION]...'
        '  -a   print all information'
        '  -s   kernel name'
        '  -n   node name'
        '  -r   kernel release'
        '  -v   kernel version / Windows display version'
        '  -m   machine hardware name'
        '  -o   operating system'
        exit 0
    }
    elseif ($a -eq '--version') {
        'uname (cmdset) 1.0.0'
        exit 0
    }
    elseif ($a -eq '-a') {
        foreach ($k in @('s', 'n', 'r', 'v', 'm', 'o')) { $show[$k] = $true }
    }
    elseif ($a.StartsWith('-')) {
        foreach ($c in $a.Substring(1).ToCharArray()) {
            switch ($c) {
                's' { $show.s = $true }
                'n' { $show.n = $true }
                'r' { $show.r = $true }
                'v' { $show.v = $true }
                'm' { $show.m = $true }
                'o' { $show.o = $true }
                default {
                    [Console]::Error.WriteLine("uname: invalid option -- $c")
                    exit 1
                }
            }
        }
    }
    else {
        [Console]::Error.WriteLine("uname: extra operand: $a")
        exit 1
    }
}

$cv = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
$display = if ($cv.DisplayVersion) { $cv.DisplayVersion } elseif ($cv.ReleaseId) { $cv.ReleaseId } else { '' }
$build = '{0}.{1}' -f $cv.CurrentBuild, $cv.UBR

$vals = [ordered]@{
    s = 'Windows_NT'
    n = $env:COMPUTERNAME
    r = $build
    v = if ($display) { "Windows $display" } else { 'Windows' }
    m = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
    o = 'Windows'
}

$out = New-Object System.Collections.Generic.List[string]
foreach ($k in 's', 'n', 'r', 'v', 'm', 'o') {
    if ($show[$k]) { $out.Add($vals[$k]) }
}
if ($out.Count -eq 0) { $out.Add($vals['s']) }

$out -join ' '