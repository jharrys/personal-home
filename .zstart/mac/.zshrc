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
if [ -z "$ZSTART" ]
    then
        ZSTART=~/.zstart
        ZSTARTPLATFORM=${ZSTART}/mac
fi

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
CDPATH="${CDPATH}:/Volumes"
CDPATH="${CDPATH}:~/Documents"
CDPATH="${CDPATH}:~/git"
CDPATH="${CDPATH}:~/Google Drive/Development"
CDPATH="${CDPATH}:~/Google Drive/Development/Archive"
export CDPATH

cdpath=(~/ /Volumes ~/Documents ~/git ~/Google\ Drive/Development ~/Google\ Drive/Development/Archive)

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

export JAVA_HOME=$(/usr/libexec/java_home -v 15)
#export JAVA_TOOL_OPTIONS="-Dapple.awt.UIElement=true"    # keeps the java icon out of the mac os x dock

export GROOVY_HOME=/usr/local/opt/groovy/libexec

#******************************************
# additional path settings
#******************************************

export PATH=$PATH:/usr/local/opt/python@2/libexec/bin:$JAVA_HOME/bin

# setup rust environment
source "$HOME/.cargo/env"
#******************************************
# docker: check if docker-machine is up (using VirtualBox in headless mode)
#******************************************
#DMPID=$(pgrep -f sofi)
#[ $? -eq 0 ] && eval $(docker-machine env sofi)

#******************************************
# source platform aliases
#******************************************
# Global aliases
if [ -d $ZSTART/aliases.d ];
then
    for a in $(\ls $ZSTART/aliases.d/*.mac-aliases)
    do
        source $a
    done
fi

