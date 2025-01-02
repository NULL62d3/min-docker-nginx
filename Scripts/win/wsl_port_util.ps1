# wsl_util.ps1

Param(
    [switch]$show,
    [switch]$close,
    [switch]$open
)

# All the ports you want to forward separated by comma
# $ports=@(22,3000,3001,8080);
$open_ports=@(8080);

if (!$show -and !$open -and !$close) {
    echo "Warning: No option is set!"
    exit
}

$ArgumentList = New-Object System.Collections.ArrayList
if($show) { $ArgumentList.Add("-show") }
if($close) { $ArgumentList.Add("-close") }
if($open) { $ArgumentList.Add("-open") }

function open_wsl_port {
    echo $myInvocation.MyCommand.name

    $ip = bash.exe -c "ip r |tail -n1|cut -d ' ' -f9"
    if( ! $ip ){
        echo "The Script Exited, the ip address of WSL 2 cannot be found";
        exit;
    }

    $ports_a = $open_ports -join ",";

    # Add envvironment variable is port number
    [Environment]::SetEnvironmentVariable('PORT',$open_ports,"User");

    # Remove Firewall Exception Rules
    iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

    # Adding Exception Rules for inbound and outbound Rules
    iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
    iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

    for( $i = 0; $i -lt $open_ports.length; $i++ ){
        $port = $open_ports[$i];
        iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=* connectport=$port connectaddress=$ip";
    }
}

function close_wsl_port {
    echo $myInvocation.MyCommand.name
    
    # Get current portforwarding numbers from environment variable
    $ports = @([Environment]::GetEnvironmentVariable("PORT","User") -Split " ");

    if([System.String]::IsNullOrWhiteSpace($ports)) {
        echo "No port is opened."

    } else {
        echo $ports.length
        for( $i = 0; $i -lt $ports.length; $i++ ){
            $port = $ports[$i];
            iex "netsh interface portproxy delete v4tov4 listenport=$port";
            echo "closed Port:$port"
        }

        # Remove environment values is port number
        [Environment]::SetEnvironmentVariable('PORT',"","User")
    }
}

if (!$show) {
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
        if ($close) {
            close_wsl_port
        } elseif ($open) {
            open_wsl_port
        }
    } else {
        Start-Process powershell.exe "-File `"$PSCommandPath`" $ArgumentList" -Wait -Verb RunAs;
    }
}

# Show proxies
echo "____________________________________"
echo "Current opened ports:"
iex "netsh interface portproxy show v4tov4";


