# Parameter options
#param
#	(
#		$eventRecordID,
#		$eventChannel,
#		[Parameter(Mandatory=$true)]
#		[AllowNull()]
#		[AllowEmptyString()]
#		[string]$networkName,
#		$eventState
#	)
##########################################################
# define a hashtable
#[hashtable] $homeMounts = @{
#	share="\\zax\mnt\nethome\john"
#	drive="z:"
#}
##########################################################
#$ipAddress = @()
#$ipAddress = gwmi win32_NetworkAdapterConfiguration |
#	? { $_.IPEnabled -eq $true } |
#	% { $_.IPAddress } |
#	% { [IPAddress]$_ } |
#	? { $_.AddressFamily -eq 'internetwork' } |
#	% { $_.IPAddressToString }
#
#Write-Host -fore cyan "Your current network is $ipAddress."
##########################################################
# Popup Types 
# 0 Show OK button.
# 1 Show OK and Cancel buttons.
# 2 Show Abort, Retry, and Ignore buttons.
# 3 Show Yes, No, and Cancel buttons.
# 4 Show Yes and No buttons.
# 5 Show Retry and Cancel buttons
#$hey = new-object -comobject wscript.shell
#$answer = $hey.popup($script:popupMsg,0,$script:popupTitle,$script:popupType)
##########################################################
#$homeNet = "10.1.4.*", "OfficePrinter"
#$remoteNet = "10.1.6.*", "W382_HP_Printer"
#
#function Set-DefaultPrinter([string]$printerPath) {
#	$printers = gwmi -class Win32_Printer -computer .
#	Write-Host -fore cyan "Default Printer: $printerPath"
#	$dp = $printers | ? { $_.deviceID -match $printerPath }
#	$dp.SetDefaultPrinter() | Out-Null
#}
#
#$ipAddress = @()
#$ipAddress = gwmi win32_NetworkAdapterConfiguration |
#	? { $_.IPEnabled -eq $true } |
#	% { $_.IPAddress } |
#	% { [IPAddress]$_ } |
#	? { $_.AddressFamily -eq 'internetwork' } |
#	% { $_.IPAddressToString }
#
#Write-Host -fore cyan "Your current network is $ipAddress."
#
#switch -wildcard ($ipAddress) {
#	$homeNet[0] { Set-DefaultPrinter $homeNet[1] }
#	$remoteNet[0] { Set-DefaultPrinter $remoteNet[1] }
#	default { Set-DefaultPrinter $homeNet[1] }
#}
##########################################################
# get printer object (System.Management.ManagementObject#root\cimv2\Win32_Printer)
#$printer = Get-WmiObject -Class Win32_Printer
# (gwmi -computername . -class win32_printer -filter "name like 'Dad%'").setdefaultprinter()
##########################################################
# personalize desktop for restricted user
#function CreateRestrictedDesktopGPO 
#{
#Param
#   (
#    [string]$gpoName,
#    [string]$themeFileName,
#    [string]$wallpaperFileName
#    )
#
#    $gpo = New-GPO -Name $gpoName
#
#    #set the policy to specify a theme
#    $gpo | Set-GPRegistryValue -Key "HKCU\Software\Policies\Microsoft\Windows\Personalization" -Type String `
#    -ValueName ThemeFile -Value $themeFileName
#
#    #set the policy to prevent the user from changing the theme
#    $gpo | Set-GPRegistryValue -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
#    -Type Dword -ValueName NoThemesTab -Value 1
#
#    #set the policy to specify a wallaper. This policy also prevents the user from changing the wallpaper
#    $gpo | Set-GPRegistryValue -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
#    -Type String -ValueName Wallpaper -Value $wallpaperFileName
#}
##########################################################
# How to load assembly
#[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
##########################################################
# get battery status
#(Get-WmiObject -Class Win32_Battery -ea 0).BatteryStatus
##########################################################
#powershell -nologo -command (invoke-command -scriptblock {"C:\Users\lpjharri\AppData\Local\Microsoft\Windows\Themes\john.theme"})