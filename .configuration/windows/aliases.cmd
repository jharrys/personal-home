@echo off

:: Aliases for Windows cmd

DOSKEY l=dir $*
DOSKEY ll=dir $*
DOSKEY e=brackets %USERPROFILE%\.configuration\windows\aliases.env

:: Git aliases

DOSKEY gclone=git clone --recursive $*
DOSKEY gsubget=git submodule update --init --recursive $*
DOSKEY gfu=git fetch upstream
DOSKEY gph=git push fromhome master
DOSKEY gst=git status
DOSKEY gstl=git stash list
DOSKEY gstv=git stash save

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


