# Copyright 2012 
# by johnnie.a.harris@gmail.com
# 
# Creates all the missing symlink for a new system for Windows 7

$windows8Version = new-object 'Version' 6,2
$windowsServer2012Version = new-object 'Version' 6,2
$windows7Version = new-object 'Version' 6,1
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

if ($windowsVersion_2way -ne ($windows7Version)) {
	exit
}

# myCygwinHomeConfiguration is only needed by the first symlink to configuration. Once setup, the rest should use myHomeConfiguration
$myCygwinHome = 'c:\cygwin\home\lpjharri'
$myCygwinHomeConfiguration = $myCygwinHome + '\configuration'
$myHome = $Env:userprofile
$myHomeConfiguration = $myHome + '\configuration'
$myWin7Configuration = $myHome + '\configuration\win7'
$myWinGitConfiguration = $myHome + '\configuration\win7'

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

if (!(Test-Path -Path $myHomeConfiguration -PathType Container)) { 
	Write-Output "$myHomeConfiguration does not exist or is of type file"
	exit
}

if (!(Test-Path -Path $myWin7Configuration -PathType Container)) { 
	Write-Output "$myWin7Configuration does not exist or is of type file"
	exit
}

if (!(Test-Path -Path $myWinGitConfiguration -PathType Container)) { 
	Write-Output "$myWinGitConfiguration does not exist or is of type file"
	exit
}

# bin symlink target path (the real location)
$myBin = $myCygwinHome + '\bin'

# .ssh symlink target path (the real location)
# not placing .ssh into configuration directory because I don't want my keys exposed in git repository
$mySsh = $myCygwinHome + '\.ssh'

# .ssh config file target path (the real location)
$mySshConfig = $myHomeConfiguration + '\ssh_config'

# Themes symlink target path (the real location)
$myThemes = $myWin7Configuration + '\Themes')

# Favorites - Explorer (actually called Links)
$myLinks = $myWin7Configuration + '\Links')

# Libraries symlink target path (the real location)
$myLibraries = $myWin7Configuration + '\Libraries'

# WindowsPowerShell symlink target path (the real location)
$myWindowsPowerShell = $myWin7Configuration + '\powershell'

# Wallpaper symlink target (the real path)
$myWallPaper = $myHome + '\Documents\Google Drive\Wallpaper'

# Icons symlink target (the real path)
$myIcons = $myHome + '\Documents\Google Drive\Icons'

# my .git global configuration paths
$myGitConfig = $myWinGitConfiguration + '\.gitconfig'
$myGitIgnore = $myWinGitConfiguration + '\.gitignore'
$myGitIgnoreGlobal = $myWinGitConfiguration + '\.gitignore_global'



# SET THIS UP FIRST! - most of the configurations rely on this one
cd $myHome
$symlinkExists = Get-ReparsePoint configuration
if (!$symlinkExists -and (Test-Path -Path $myCygwinHomeConfiguration -PathType Container )) {
	New-SymLink configuration $myCygwinHomeConfiguration
}

# bin
cd $myHome
$symlinkExists = Get-ReparsePoint bin
if (!$symlinkExists -and (Test-Path -Path $myBin -PathType Container )) {
	New-SymLink bin $myBin
}

# ssh
cd $myHome
$symlinkExists = Get-ReparsePoint .ssh
if (!$symlinkExists -and (Test-Path -Path $mySsh -PathType Container )) {
	New-SymLink .ssh $mySsh
}

cd .ssh
$symlinkExists = Get-ReparsePoint config
if (!$symlinkExists -and (Test-Path -Path $mySshConfig -PathType Leaf )) {
	New-SymLink config $mySshConfig
}

# explorer favorites (Links)
cd $myHome
$symlinkExists = Get-ReparsePoint Links
if (!$symlinkExists -and (Test-Path -Path $myLinks -PathType Container )) {
	New-SymLink Links $myLinks
}

# .git stuff
cd $myHome
$symlinkExists = Get-ReparsePoint .gitconfig
if (!$symlinkExists -and (Test-Path -Path $myGitConfig -PathType Leaf )) {
	New-Hardlink .gitconfig $myGitConfig
}

$symlinkExists = Get-ReparsePoint .gitignore
if (!$symlinkExists -and (Test-Path -Path $myGitIgnore -PathType Leaf )) {
	New-Hardlink .gitignore $myGitIgnore
}

$symlinkExists = Get-ReparsePoint .gitignore_global
if (!$symlinkExists -and (Test-Path -Path $myGitIgnoreGlobal -PathType Leaf )) {
	New-Hardlink .gitignore_global $myGitIgnoreGlobal
}

# Themes
cd $Env:localappdata
cd 'Microsoft\Windows'
$symlinkExists = Get-ReparsePoint Themes
if (!$symlinkExists -and (Test-Path -Path $myThemes -PathType Container )) {
	mv 'Themes' 'Original-Themes'
	New-SymLink Themes $myThemes
}

# Libraries
cd $Env:appdata
cd 'Microsoft\Windows'
$symlinkExists = Get-ReparsePoint Libraries
if (!$symlinkExists -and (Test-Path -Path $myLibraries -PathType Container )) {
	mv 'Libraries' 'Original-Libraries'
	New-SymLink Libraries $myLibraries
}

# Wallpaper
cd $myHome
cd 'Pictures'
$symlinkExists = Get-ReparsePoint Wallpaper
if (!$symlinkExists -and (Test-Path -Path $myWallPaper -PathType Container )) {
	New-SymLink Wallpaper $myWallPaper
}

# Icons
cd $myHome
cd 'Documents'
$symlinkExists = Get-ReparsePoint Icons
if (!$symlinkExists -and (Test-Path -Path $myIcons -PathType Container )) {
	New-SymLink Icons $myIcons
}

# WindowsPowerShell
cd $myHome
cd 'Documents'
$symlinkExists = Get-ReparsePoint WindowsPowerShell
if (!$symlinkExists -and (Test-Path -Path $myWindowsPowerShell -PathType Container )) {
	New-SymLink WindowsPowerShell $myWindowsPowerShell
}

# Create my other standard directories
cd $myHome
if (!(Test-Path -Path Mount -PathType Container)) { 
	Write-Output "Creating $myHome\Mount"
	mkdir Mount
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'Applications\Cyginstall' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\Applications\Cyginstall"
	mkdir 'Applications\Cyginstall'
}

if (!(Test-Path -Path 'Applications\SpringSource' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\Applications\SpringSource"
	mkdir 'Applications\SpringSource'
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'Google Drive' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\Google Drive"
	mkdir 'Google Drive'
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'MailArchives' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\MailArchives"
	mkdir 'MailArchives'
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'OneNote Notebooks' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\OneNote Notebooks"
	mkdir 'OneNote Notebooks'
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'SourceControl' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\SourceControl"
	mkdir 'SourceControl'
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'Sysinternal Tools' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\Sysinternal Tools"
	mkdir 'Sysinternal Tools'
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'VirtualBox VMs' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\VirtualBox VMs"
	mkdir 'VirtualBox VMs'
}

cd $myHome
cd 'Documents'
if (!(Test-Path -Path 'Enterprise Solutions Architecture' -PathType Container)) { 
	Write-Output "Creating $myHome\Documents\Enterprise Solutions Architecture"
	mkdir 'Enterprise Solutions Architecture'
}