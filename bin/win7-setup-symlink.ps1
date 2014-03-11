# Copyright 2012 
# by johnnie.a.harris@gmail.com
# 
# Creates all the missing symlinks for a Johnnie Harris new Windows 7 system 

Write-Output "New system, you must run PowerShell as Administrator."
Write-Output "Then 'set-executionpolicy unrestricted'"
Write-Output "Ensure Powershell version 3.0 and Powershell Community Extensions 3.1"

# ************************************************************** #
#
#		Set the Microsoft Windows versions
#
# ************************************************************** #

$windows8Version = new-object 'Version' 6,2
$windowsServer2012Version = new-object 'Version' 6,2
$windows7Version = new-object 'Version' 6,1,7601,65536
$windowsServer2008R2Version = new-object 'Version' 6,1
$windowsServer2008Version = new-object 'Version' 6,0
$windowsVistaVersion = new-object 'Version' 6,0
$windowsServer2003R2Version = new-object 'Version' 5,2
$windowsServer2003Version = new-object 'Version' 5,2
$windowsXP64bitVersion = new-object 'Version' 5,2
$windowsXPVersion = new-object 'Version' 5,1
$windows2000Version = new-object 'Version' 5,0

$windowsVersion_1way = [Environment]::OSVersion
$windowsVersion_2way = [Environment]::OSVersion.Version
$windowsVersion_3way = (Get-WmiObject -class Win32_OperatingSystem).Caption

# Make sure we are Windows 7 (because all the symlinks have been coded to specific paths in Windows 7 that may change in newer releases)
if ($windowsVersion_2way -ne ($windows7Version)) {
	Write-Output "Version is reported as $windowsVersion_2way...looking for $windows7Version; not able to proceed"
	exit
}

# ************************************************************** #
#
#		Define the global variables the represent where the real configuration 
#		folders exist & test those containers to ensure they exist.
#			I keep everything under my cygwin home directory, so cygwin
#			is very much an integral part of this solution!
#
# ************************************************************** #

# myCygwinHomeConfiguration is only needed by the first symlink to configuration. Once setup, the rest should use myHomeConfiguration
$myCygwinHome = 'c:\cygwin\home\lpjharri'
$myCygwinHomeConfiguration = $myCygwinHome + '\configuration'
$myHome = $Env:userprofile
$myHomeConfiguration = $myHome + '\configuration'
$myWin7Configuration = $myHome + '\configuration\win7'
$myWinGitConfiguration = $myHome + '\configuration\git.windows'
$myGtk20Configuration = $myHome + '\configuration\gtk-2.0'

# verify that all containers exist and are, indeed, containers

if (!(Test-Path -Path $myCygwinHome -PathType Container)) { 
	Write-Output "$myCygwinHome does not exist or is of type file"
	exit
}

if (!(Test-Path -Path $myCygwinHomeConfiguration -PathType Container)) { 
	Write-Output "$myCygwinHomeConfiguration does not exist or is of type file"
	exit
}

if (!(Test-Path -Path $myHome -PathType Container)) { 
	Write-Output "$myHome does not exist or is of type file"
	exit
}


# ************************************************************** #
#
#		Now define the variables to the actual/real locations of each specific
#		configuration file or directory. 
#
# ************************************************************** #

# bin symlink target path (the real location)
$myBin = $myCygwinHome + '\bin'

# .ssh symlink target path (the real location)
# not placing .ssh into configuration directory because I don't want my keys exposed in git repository
$mySsh = $myCygwinHome + '\.ssh'

# .ssh config file target path (the real location)
$mySshConfig = $myHomeConfiguration + '\ssh_config'

# Themes symlink target path (the real location)
$myThemes = $myWin7Configuration + '\Themes'

# Favorites - Explorer (actually called Links)
$myLinks = $myWin7Configuration + '\Links'

# Libraries symlink target path (the real location)
$myLibraries = $myWin7Configuration + '\Libraries'

# WindowsPowerShell symlink target path (the real location)
$myWindowsPowerShell = $myWin7Configuration + '\powershell'

# Sublime Text 2 symlink target path (the real location)
$mySublimeText2 = $myHomeConfiguration + '\Sublime Text 2'

# Wallpaper symlink target (the real path)
$myWallPaper = $myHome + '\Google Drive\Wallpaper'

# Icons symlink target (the real path)
$myIcons = $myHome + '\Google Drive\Icons'

# Git global configuration paths
$myGitConfig = $myWinGitConfiguration + '\.gitconfig'
$myGitIgnore = $myWinGitConfiguration + '\.gitignore'
$myGitIgnoreGlobal = $myWinGitConfiguration + '\.gitignore_global'

# Gtk-2.0 configuration (used by things like pidgin)
$myGtkrc20File = $myGtk20Configuration + '\gtkrc-2.0'

# ************************************************************** #
#		Create link function
#		linkbase = full path of new link directory or filename excluding linknode
#		linknode = name of final directory or file
#		targetpath = full path including name of directory or file
#		targettype = String of either "Container" or "Leaf"
# ************************************************************** #
Function Set-Link($linkbase, $linknode, $targetpath, $targettype) {
	cd $linkbase
	$symlinkExists = Get-ReparsePoint $linknode
	if(!$symlinkExists) {
		if (Test-Path -Path $targetpath -PathType $targettype) {
			Try {
				New-SymLink $linknode $targetpath
			} Catch [System.Exception] {
				Write-Output "Got error trying to create symbolic link $targetpath at $linkbase\$linknode"
			}
		} else {
			Write-Output "$targetpath does not exist, unable to create the symbolic link."
		}
		
	} else {
		Write-Output "Symbolic link for $targetpath at $linkbase\$linknode already exists, not re-creating it."
	}
}

Function Create-Node($base, $node, $type) {
	cd $base
	if(!(Test-Path -Path $node -PathType $type)) {
		Write-Output "Creating $base\$node"
		mkdir $node
	} else {
		Write-Output "$base\$node already exists."
	}
}

# ************************************************************** #
#
#		Using the defined variables above for the real locations
#		of each configuration file and/or directory, create the
#		symbolic link where the system will expect the file to be.
#
# ************************************************************** #


Set-Link $script:myHome "configuration" $script:myCygwinHomeConfiguration "Container"			# !!!!!! SET THIS UP FIRST! - most of the configurations rely on this one
Set-Link $script:myHome "bin" $script:myBin "Container"								#  bin
Set-Link $script:myHome ".ssh" $script:mySsh "Container"								# ssh
Set-Link "$script:myHome\.ssh" "config" $script:mySshConfig "Leaf" 						# ssh_config
Set-Link $script:myHome "Links" $script:myLinks "Container"								# explorer favorites (Links)
Set-Link $script:myHome ".gitconfig" $script:myGitConfig "Leaf"							# Git Config file
Set-Link $script:myHome ".gitignore" $script:myGitIgnore "Leaf"							# Git Ignore file
Set-Link $script:myHome ".gitignore_global" $script:myGitIgnoreGlobal "Leaf"					# Git Ignore Global file
Set-Link "$Env:localappdata\Microsoft\Windows" "Themes"	$script:myThemes "Container"			# Themes
Set-Link "Env:appdata\Microsoft\Windows" "Libraries" $script:myLibraries "Container" 				# Libraries
Set-Link "$script:myHome\Pictures" "Wallpaper" $script:myWallPaper "Container"				# Wallpaper
Set-Link "$script:myHome\Documents" "Icons" $script:myIcons "Container"					# Icons
Set-Link "$script:myHome\Documents" "WindowsPowerShell" $script:myWindowsPowerShell "Container"	# WindowsPowerShell
Set-Link $Env:appdata "Sublime Text 2" $script:mySublimeText2 "Container"					# Sublime Text 2
Set-Link $script:myHome ".gtkrc-2.0" $script:myGtkrc20File "Leaf"							# Gtk-2.0 personal resource file
Set-Link "$script:myHome\configuration\pidgin\home" "gtkrc-2.0" $script:myGtkrc20File "Leaf"		# Gtk-2.0 personal resource file for home
Set-Link "$script:myHome\configuration\pidgin\work" "gtkrc-2.0" $script:myGtkrc20File "Leaf"			# Gtk-2.0 personal resource file for work
Create-Node $script:myHome "Mount" "Container"									# Create my Mount directory
Create-Node "$script:myHome\Documents" "Applications\Cyginstall" "Container"					# Create my Cyginstall directory
Create-Node "$script:myHome\Documents" "Applications\SpringSource" "Container"				# Create my SpringSource directory
Create-Node "$script:myHome" "Google Drive" "Container"								# Create my Google Drive directory
Create-Node "$script:myHome\Documents" "MailArchives" "Container"						# Create my MailArchives directory
Create-Node "$script:myHome\Documents" "OneNote Notebooks" "Container"					# Create my OneNote Notebooks directory
Create-Node "$script:myHome\Documents" "SourceControl" "Container"						# Create my SourceControl directory
Create-Node "$script:myHome\Documents" "Sysinternal Tools" "Container"					# Create my Sysinternal Tools directory
Create-Node "$script:myHome\Documents" "VirtualBox VMs" "Container"						# Create my VirtualBox VMs directory
Create-Node "$script:myHome\Documents" "Enterprise Solutions Architecture" "Container"			# Create my Enterprise Solutions Architecture directory

Write-Output "Finished."