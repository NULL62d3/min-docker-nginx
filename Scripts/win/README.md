# [Windows] How to Access from an external device

## Change Windows' setting
* Open settings in windows.
* Open Network & internet > Ethernet
* Change Network profile type to "Private network".

## [WSL2] Set port forwarding in Host Windows

If you are using wsl2 and want to access from
an external device (such as smartPhone) in your local network,
you need to set port forwarding in the host Windows.

### Set port forwarding
```ps1
    # Before running, input port numbers you want to open into $open_ports=@(***);
    ./Script/wsl_port_util.ps1 -open
```

### Unset port forwarding
```ps1
    ./Script/wsl_port_util.ps1 -close
```

### Check current port forwarding
```ps1
    ./Script/wsl_port_util.ps1 -show
```