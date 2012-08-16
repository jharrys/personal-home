$command = "C:\Program Files\Oracle\VirtualBox\VBoxHeadless"
$arglist = "--vrde on --vrdeproperty TCP/Ports=5029 --startvm a534c050-c301-44ae-a9c9-16899ff05379"
start-process -WindowStyle Hidden -FilePath $command -ArgumentList $arglist