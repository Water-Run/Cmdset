$ErrorActionPreference = 'Stop'

function Get-HostIPs {
    $all = [System.Net.Dns]::GetHostAddresses([System.Net.Dns]::GetHostName()) |
    Where-Object {
        $_.IPAddressToString -ne '127.0.0.1' -and
        $_.IPAddressToString -ne '::1'
    }

    $v4 = $all | Where-Object { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork } |
    ForEach-Object { $_.IPAddressToString }

    $v6 = $all | Where-Object { $_.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetworkV6 } |
    ForEach-Object { $_.IPAddressToString }

    # 去重并保持顺序：IPv4 优先，再 IPv6
    $list = New-Object System.Collections.Generic.List[string]
    foreach ($ip in @($v4 + $v6)) {
        if (-not $list.Contains($ip)) { $list.Add($ip) }
    }
    return $list
}

if ($args.Count -eq 0) {
    $env:COMPUTERNAME
    exit 0
}

switch -Exact ($args[0]) {
    '-i' {
        $ips = Get-HostIPs
        if ($ips.Count -gt 0) { $ips[0] }
        exit 0
    }
    '-I' {
        $ips = Get-HostIPs
        if ($ips.Count -gt 0) { $ips -join ' ' }
        exit 0
    }
    '--help' {
        'Usage: hostname [OPTION]'
        '  (no option)   print host name'
        '  -i            print first host IP address'
        '  -I            print all host IP addresses'
        exit 0
    }
    default {
        [Console]::Error.WriteLine("hostname: invalid option -- $($args[0])")
        exit 1
    }
}