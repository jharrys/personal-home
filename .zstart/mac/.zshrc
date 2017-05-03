#******************************************#
# Mac OS X zshrc

# Johnnie Harris
# 2016-12-20
#
# Runs after zshenv//.zshenv//zprofile//.zprofile//zshrc.
# It is used for interactive shells.
#
# It's the main one used by all.
#
#******************************************#

#******************************************
# execute the common zshrc
#******************************************
. ${ZSTART}/zshrc

#******************************************
# ls settings
#******************************************

export CLICOLOR=1
export CLICOLOR_FORCE=1                                         # Force colors through non-tty streams such as less
export LSCOLORS=exfxcxdxbxegedabagacad

#******************************************
# cdpath settings
#******************************************

CDPATH="~/"
CDPATH="${CDPATH}:~/mounts"
CDPATH="${CDPATH}:/Volumes"
CDPATH="${CDPATH}:~/development"
CDPATH="${CDPATH}:~/development/source_control"
CDPATH="${CDPATH}:~/development/source_control/bitbucket-cloud"
CDPATH="${CDPATH}:~/development/source_control/contracts"
CDPATH="${CDPATH}:~/development/source_control/general"
CDPATH="${CDPATH}:~/development/source_control/hwcir"
CDPATH="${CDPATH}:~/development/source_control/hwcir/git"
CDPATH="${CDPATH}:~/development/source_control/hwcir/svn"
CDPATH="${CDPATH}:~/development/source_control/mike-git"
CDPATH="${CDPATH}:~/development/source_control/openshift"
export CDPATH

#******************************************
# weblogic settings
#******************************************

MW_HOME=~/local/appservers/wls-12.1.3
USER_MEM_ARGS="-Xmx1024m -XX:MaxPermSize=256m"
DOMAIN_HOME=~/local/wldomains/carma

export MW_HOME DOMAIN_HOME USER_MEM_ARGS

#******************************************
# nodejs settings
#******************************************

export NODE_PATH="/usr/local/lib/node_modules"

#******************************************
# screen capture settings - Where to default store the screen shots (make sure the directory exists)
#******************************************

defaults write com.apple.screencapture location ~/Desktop/Screenshots

#******************************************
# java/groovy/maven settings
# Java - installed via Oracle dmg
# Java environment setup use /usr/libexec/java_home executable - default to jdk 8
# Groovy - installed via brew
# Maven - installed via brew
#******************************************

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
#export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"    # keeps the java icon out of the mac os x dock

export GROOVY_HOME=/usr/local/opt/groovy/libexec
export MAVEN_HOME=/usr/local/Cellar/maven/3.3.9
export MAVEN_OPTS="-Xmx1024m"

#******************************************
# tomcat settings
#******************************************

CATALINA_HOME=/usr/local/Cellar/tomcat/8.5.8

#******************************************
# additional path settings
#******************************************

export PATH=~/.bin:/usr/local/sbin:~/Library/Python/2.7/bin:/usr/local/bin:~/Applications/subgit-3.0.0/bin:$JAVA_HOME/bin:$MAVEN_HOME/bin:$MW_HOME/wlserver/server/bin:$CATALINA_HOME/bin:$PATH

#******************************************
# source platform aliases
#******************************************

. ${ZSTARTPLATFORM}/.aliases

