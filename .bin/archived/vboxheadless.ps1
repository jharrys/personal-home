$startappname="VBoxHeadless"
$stopappname="VBoxManage"
$path="C:\Program Files\Oracle\VirtualBox"
$startcommand = "${path}\${startappname}"
$stopcommand = "${path}\${stopappname}"

$proc = Get-Process -ErrorAction SilentlyContinue $startappname

if (($proc -eq $null) -or ($proc -eq "")) {
	$arglist = "--startvm `"ESA Application Design`" --vrde on --vrdeproperty TCP/Ports=60001 --vrdeproperty TCP/Address=127.0.0.1"
	Start-Process -WindowStyle Hidden -FilePath $startcommand -ArgumentList $arglist
} else {
	$arglist = "controlvm `"ESA Application Design`" acpipowerbutton"
	Start-Process -WindowStyle Hidden -FilePath "${path}\VBoxManage" -ArgumentList $arglist
}