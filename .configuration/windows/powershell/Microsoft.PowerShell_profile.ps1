<#
    ================================================================================================================

        JJ-08-27-2012
        John Harris, ESA, 05/01/2011

        Version 3.0 - Updated 12/10/2016
        Version 2.0 - Updated 3/24/2014
        Version 1.0 - Created 05/01/2011

        How PowerShell loads modules
        1. \Windows\System32\WindowsPowerShell\v1.0\Modules - only the 64-bit Powershell will load modules from here
        2. \Windows\SysWOW64\WindowsPowerShell\v1.0\Modules - only the 32-bit Powershell will load modules from here
        3. ~\Documents\WindowsPowerShell\v1.0\Modules - either Powershell will load from here

        Copy the Pscx directory [as of 3.2.0 the msi installs it in \Program Files (x86)\PowerShell Community Extensions\Pscx3\Pscx] to one of the 3 above.

        How PowerShell loads profiles

        You can have four different profiles in Windows PowerShell. The profiles are listed in load order. The most specific profiles have precedence over less specific profiles where they apply.
        1. %windir%\system32\WindowsPowerShell\v1.0\profile.ps1
            This profile applies to all users and all shells.
        2. %windir%\system32\WindowsPowerShell\v1.0\ Microsoft.PowerShell_profile.ps1
            This profile applies to all users, but only to the Microsoft.PowerShell shell.
        3. %UserProfile%\My Documents\WindowsPowerShell\profile.ps1
            This profile applies only to the current user, but affects all shells.
        4. %UserProfile%\My Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
            This profile applies only to the current user and the Microsoft.PowerShell shell.

    ================================================================================================================
#>

<#
    ================================================================================================================
        Imports / Modules
    ================================================================================================================
#>

# Pscx version 3.2.2 (http://pscx.codeplex.com/) - Upgraded by JJ on 12/9/2016
Import-Module Pscx -arg ~\Documents\WindowsPowerShell\Pscx.UserPreferences.ps1

<#
    ================================================================================================================
        Variables
    ================================================================================================================
#>
$SOURCE="${env:userprofile}\Development\source_control"
$CONFIG="${env:userprofile}\.configuration"
$BIN="${env:userprofile}\.bin"
$CHOME="c:\Cygwin\home\lpjharri"
$APPS="${env:userprofile}\Documents\Applications"
$WLDOMAIN="${env:userprofile}\local\wldomains"

New-Variable -name ProfileFolder -Value (Split-Path $PROFILE -Parent)
New-Variable -name temp -value $([io.path]::gettemppath()) -Description "Temp directory"
New-Variable -name vboxdevmachine -value "ESA Application Design" -Description "holds the name of the VirtualBox machine I use"

<#
    ================================================================================================================
        PS-Drive
    ================================================================================================================
#>

#New-PSDrive -PSProvider filesystem -Root ${env:programw6432}\Oracle\VirtualBox -Name VBox | Out-Null
#New-PSDrive -PSProvider filesystem -Root E:\ -Name papps | Out-Null
New-PSDrive -PSProvider filesystem -Root X:\ -Name shome | Out-Null
New-PSDrive -PSProvider filesystem -Root C:\Users\lpjharri -Name home | Out-Null
New-PSDrive -PSProvider filesystem -Root $SOURCE -Name source | Out-Null
New-PSDrive -PSProvider filesystem -Root $CONFIG -Name config | Out-Null
New-PSDrive -PSProvider filesystem -Root $BIN -Name bin | Out-Null
New-PSDrive -PSProvider filesystem -Root $CHOME -Name chome | Out-Null
New-PSDrive -PSProvider filesystem -Root $APPS -Name apps | Out-Null
New-PSDrive -PSProvider filesystem -Root $WLDOMAIN -Name wldomain | Out-Null

<#
    ================================================================================================================
        Aliases
    ================================================================================================================
#>

<#
    //////////////////////////////////////////////////////
    
    cmdlet's are named Verb-Noun, this sets an alias for 
    each cmdlet to VerbNoun (without the dash)
    
    /////////////////////////////////////////////////////
#>

<#
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Disable for now

Get-Command -CommandType cmdlet |
Foreach-Object {
 Set-Alias -name ( $_.name -replace "-","") -value $_.name -description MrEd_Alias
} #end Get-Command
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#>

<#
    /////////////////////////////////////////////////////
    
    aliases
    
    /////////////////////////////////////////////////////
#>

##### REGULAR #####
New-Alias -name p -value Get-Profile -description "Open my powershell profile in brackets"
New-Alias -name al -value Edit-CmdAliases -description "Edit my windows cmd alias file"
Set-Alias ll dir
Set-Alias l dir
New-Alias -name slog -value Start-Transcript -description "Start logging my powershell commands"
New-Alias -name plog -value Stop-Transcript -description "Stop logging my powershell commands"
New-Alias -name grep -value Select-String -description "grep for string"
New-Alias -name drives -value Get-PSDrive | sort provider
New-Alias -name vvm -value Save-VBoxMachine -description "Save the state of the current running virtual box machine by name of $vboxdevmachine"
New-Alias -name svm -value Start-VBoxMachine -description "Start the virtual box machine by name of $vboxdevmachine"
New-Alias -name pvm -value Stop-VBoxMachine -description "Stop the current running virtual box machine by name of $vboxdevmachine"
New-Alias -name hvm -value Show-VBoxMachine -description "Show details of the virtual box machine by name of $vboxdevmachine"
New-Alias -name papp -value Start-PortableApps -description "Start the PortableApps from USB Thumbdrive"
New-Alias -name jcp -value Do-Checkpoint -description "Create a Windows 7 Restore Point"
New-Alias -name lcp -value Get-ComputerRestorePoint -description "List the Windows 7 Restore Points"

<#
    ================================================================================================================
        Miscellaneous Functions
    ================================================================================================================
#>

Function Do-Checkpoint([String] $Description="John Checkpoint")
{
	Checkpoint-Computer -Description $Description
}

<#
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
No longer using portable apps

Function Start-PortableApps
{
	cd papps:
	.\Start.exe
}
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
#>

<# 
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 
Not using vbox right now

Function Show-VBoxMachine
{
	cd vbox:
	.\VBoxManage.exe showvminfo $vboxdevmachine --details
}

Function Save-VBoxMachine
{
	cd vbox:
	.\VBoxManage.exe controlvm $vboxdevmachine savestate
}

Function Start-VBoxMachine
{
	cd vbox:
	.\VBoxManage.exe startvm $vboxdevmachine --type headless
}

Function Stop-VBoxMachine
{
	cd vbox:
	.\VBoxManage.exe controlvm $vboxdevmachine acpipowerbutton
}
XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
#>

Function Tips
{
	Write-Host 'To split array or string do:		$b=$a.split(",")'
	Write-Host 'To join array or string do: 		$c="h","e","l","l","o"; $c -join "" OR [string]::Join("",$c)'
	Write-Host 'To get list of static members:		[string] | get-member -static'
	Write-Host
	Write-Host 'If $error[0] reports no information, no error has occurred'
	Write-Host
	Write-Host '$? -eq $true then command completed successfully'
	Write-Host
	Write-Host '% is the alias for the Foreach-Object'
	Write-Host
	Write-Host '.. is the range operator used as x..y'
	Write-Host
	Write-Host 'put % and .. together: 1..20 | % {md "Folder $_"}'
	Write-Host
	Write-Host '** check out robocopy (very fast copy operations) **'
	Write-Host
	Write-Host 'PSCX: tail, touch, su, srts, call, e (edit file), fhex, fxml, cvxml, gcb (get clipboard), ocb (out clipboard), ln'
	Write-Host 'Enable Explorer Context Menu "Open Powershell Here": Enable-OpenPowerShellHere'
	Write-Host
	Write-Host 'You can send email to. Use Send-MailMessage'
}

<#
    The -Attachment parameter expects a string that is the /path/to/file
#>
Function emailme([string] $To = "johnnie.harris@imail.org", [string] $Subject = "From Powershell 3.0 cmdlet", [string] $Body = "Forgot to include body to the email", [string] $Attachment = $null)
{

	Process {
		$Attachment = $_
		if(($Attachment -eq $null) -or ($Attachment -eq "")) {
			Send-MailMessage -To $To -SmtpServer "smtp.co.ihc.com" -Port 25 -From "johnnie.harris@imail.org" -Subject $Subject -Body $Body
		} else {
			Send-MailMessage -To $To -SmtpServer "smtp.co.ihc.com" -Port 25 -From "johnnie.harris@imail.org" -Subject $Subject -Body $Body -Attachment $Attachment
		}
	}
}

Function eme([string] $To = "harris.johnny@gmail.com", [string] $Subject = "Info from work", [string] $Body = "Forgot to include body to the email")
{
	Send-MailMessage -To $To -SmtpServer "smtp.co.ihc.com" -Port 25 -From "john.harris@imail.org" -Subject $Subject -Body $Body
}

Function Ascii-Table
{
	0..127 | % {"{0} {1}" -f $_, [char]$_}
}

Function Generate-AsciiFolders([string] $folderName, [int] $numberOfFolders)
{
	$start=65
	$end=$start + $numberOfFolders
	$start..$end | % {md ("${folderName}_{0}" -f [char]$_)}
}

Function Play-SystemSounds
{
	Foreach($sound in ([media.systemsounds] | gm -static -MemberType property))
	{
		$sound.Name
		[media.SystemSounds]::($sound.name).play()
		start-sleep -s 1
	}
}

Function Get-Profile
{
	brackets $profile
}	# end function get-profile

Function Edit-CmdAliases
{
    Edit-File ${CONFIG}\windows\aliases.cmd
}

Function Get-CmdletsWithMoreThanOneAlias
{
	Get-Alias |
	Group-Object -Property definition |
	Sort-Object -Property count -Descending |
	Where-Object { $_.count -gt 2 }
}

Function Get-DefaultPrinter
{
	Get-WMIObject -query "Select * From Win32_Printer Where Default = TRUE"
}

# requires -version 3.0
Function FormatDriveAndCopyFiles([string] $source, [string] $driveletter, [string] $newlabel)
{
	ipmo storage
	Format-Volume -DriveLetter $driveletter -NewFileSystemLabel $newlabel -FileSystem exfat -Confirm:$true
	robocopy "$source" "${driveletter}:" /S
	[media.SystemSounds]::("Hand").play()
}

function isadmin
 {
   # Returns true/false
   ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
 }
 
 function elevate-me
 {
    if (-NOT (isadmin)) {
        Start-Process powershell.exe -Verb runAs
    } else {
        Write-Host "Already elevated."
    }
 }
 
 function setproxy
 {
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
 }
 
<#
    ================================================================================================================
        Admin Functions
    ================================================================================================================
#>

function regfix {
    Start-Process regedit -ArgumentList "/i /s ${env:userprofile}\.configuration\windows\registry\disable-elevate-notifications.reg" -Verb runas
}
 
<#
    ================================================================================================================
        Mysql Functions
    ================================================================================================================
#>

function mysqlstart {
    if (-NOT (isadmin)) {
        Start-Process net -ArgumentList "start mysql" -Verb runas 
    } else {
        &net start mysql
    }
}

function mysqlstop {
    if (-NOT (isadmin)) {
        Start-Process net -ArgumentList "stop mysql" -Verb runas
    } else {
        &net stop mysql
    }
}
 
<#
    ================================================================================================================
        Maven Functions
    ================================================================================================================
#> 

function m {

    # The other functions passing their "$args" parameter comes in as a string on the final index
    # if this gets passed in to the executable it doesn't parse it as separate params
    # so doing this split will ensure each index string with a space in it is moved into its own
    # index in the new array arrayified
    $arrayified = $args.split(" ")
        
    & mvn $arrayified
}

function mc {
    m clean $args
}

function mcp {
    m clean package $args
}

function mcpskip {
    m clean package -DskipTests $args
}

function mci {
    m clean install $args
}

function mciskip {
    m clean install -DskipTests $args
}

function mi {
    m install $args
}

function miskip {
    m install -DskipTests $args
}

function mp {
    m package $args
}

function mpskip {
    m package -DskipTests $args
}

function mtest {
    m test $args
}

function minstallfile {
    &mvn install:install-file $args
}

function mpurge {
    m dependency:purge-local-repository $args
}

function hwdeployfile {
    &mvn deploy:deploy-file -Durl=http://lpv-hwmaven01.co.ihc.com:8081/nexus/content/repositories/HWCIR -DrepositoryId=hwcir-nexus $args
}

<#
    ================================================================================================================
        Git Functions
    ================================================================================================================
#>

function g {

    # The other functions passing their "$args" parameter comes in as a string on the final index
    # if this gets passed in to the executable it doesn't parse it as separate params
    # so doing this split will ensure each index string with a space in it is moved into its own
    # index in the new array arrayified
    $arrayified = $args.split(" ")
        
    & git $arrayified
}

function gclone {
    g clone --recursive $args
}

function gsubget {
    g submodule update --init --recursive $args
}

function gfu {
    g fetch upstream
}

function gph {
    g push fromhome master
}

function gst {
    g status
}

function gstl {
    g stash list
}

function gstv {
    g stash save
}

function gp {
    g pull
}

function gpu {
    g push
}
