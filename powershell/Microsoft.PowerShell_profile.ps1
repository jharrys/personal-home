#
#	JJ-08-27-2012
#	John Harris, ESA, 05/01/2011
#	Version 1.0
#

# *** Variables ***
New-Variable -Name ProfileFolder -Value (Split-Path $PROFILE -Parent)
New-Variable -name temp -value $([io.path]::gettemppath()) -Description "Temp directory"

# *** Aliases ***

# cmdlet's are named Verb-Noun, this sets an alias for each cmdlet to VerbNoun (without the dash)
Get-Command -CommandType cmdlet | 
Foreach-Object { 
 Set-Alias -name ( $_.name -replace "-","") -value $_.name -description MrEd_Alias
} #end Get-Command

New-Alias -name p -value Get-Profile -description "Open my powershell profile in Sublime"
New-Alias -name slog -value Start-Transcript -description "Start logging my powershell commands"
New-Alias -name plog -value Stop-Transcript -description "Stop logging my powershell commands"
New-Alias -name grep -value Select-String -description "grep for string"
New-Alias -name drives -value Get-PSDrive | sort provider

# *** PS Drive ***
New-PSDrive -PSProvider filesystem -Root ${env:programw6432}\Oracle\VirtualBox -Name VBox | Out-Null

# *** Function ***

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
	sublime_text $profile
}	# end function get-profile

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