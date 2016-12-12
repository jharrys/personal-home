@echo off

set SOURCE=%USERPROFILE%\Development\source_control
set APPS=%USERPROFILE%\Documents\Applications
set CONFIG=%USERPROFILE%\.configuration
set BIN=%USERPROFILE%\.bin
set CHOME=\Cygwin\home\lpjharri
set WLDOMAIN=%USERPROFILE%\local\wldomains

:: Aliases for Windows cmd

DOSKEY l=dir $*
DOSKEY ll=dir $*
DOSKEY al=brackets %USERPROFILE%\.configuration\windows\aliases.cmd
DOSKEY p=brackets %USERPROFILE%\.configuration\windows\powershell\Microsoft.PowerShell_profile.ps1
DOSKEY mysqlstart=powershell -command mysqlstart
DOSKEY mysqlstop=powershell -command mysqlstop

:: Directory aliases

DOSKEY src=cd %SOURCE%
DOSKEY hwcir=cd %SOURCE%\hwcir\git
DOSKEY chome=cd %CHOME%
DOSKEY bin=cd %BIN%
DOSKEY config=cd %CONFIG%
DOSKEY apps=cd %APPS%
DOSKEY wldomain=cd %WLDOMAIN%

:: Git aliases

DOSKEY gclone=git clone --recursive $*
DOSKEY gsubget=git submodule update --init --recursive $*
DOSKEY gfu=git fetch upstream
DOSKEY gph=git push fromhome master
DOSKEY gst=git status
DOSKEY gstl=git stash list
DOSKEY gstv=git stash save
DOSKEY gp=git pull
DOSKEY gpu=git push

:: Maven aliases

DOSKEY mh=mvn help:help -Ddetail=true
DOSKEY mc=mvn clean
DOSKEY mcp=mvn clean package $*
DOSKEY mcpskip=mvn clean package -Dmaven.test.skip=true $*
DOSKEY mci=mvn clean install $*
DOSKEY mciskip=mvn clean install -Dmaven.test.skip=true $*
DOSKEY mi=mvn install $*
DOSKEY miskip=mvn install -Dmaven.test.skip=true $*
DOSKEY mp=mvn package $*
DOSKEY mpskip=mvn package -Dmaven.test.skip=true $*
DOSKEY mtest=mvn test $*
DOSKEY minstallfile=mvn install:install-file $*
DOSKEY mpurge=mvn dependency:purge-local-repository $*
DOSKEY hwdeployfile=mvn deploy:deploy-file -Durl=http://lpv-hwmaven01.co.ihc.com:8081/nexus/content/repositories/HWCIR -DrepositoryId=hwcir-nexus $*


