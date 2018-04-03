#******************************************#
# Linux zshrc

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
## source platform aliases
##******************************************

# Global aliases
if [ -d $ZSTART/aliases.d ];
then
    for a in $(\ls $ZSTART/aliases.d/*.linux-aliases)
    do
        source $a
    done
fi

#******************************************
# other options
#******************************************

# Path setup
export CDPATH='.:~/:..:../..:~/Pictures/Wallpaper:~/Desktop:~/Documents:~/Downloads:~/Documents/Google Drive:~/Documents/Life Documents:~/Workspaces'

# JAVA Environment
export JAVA_HOME=/usr/java/jdk1.6.0_18
export JDK_HOME=/usr/java/jdk1.6.0_18

# Maven Environment
export MAVEN_HOME=~/Applications/apache-maven-2.2.1

# Path Setup
export PATH=$MAVEN_HOME/bin:/sbin:/usr/sbin:$PATH

# Library Path Setup
export LD_LIBRARY_PATH=/usr/lib64:/usr/local/lib:$LD_LIBRARY_PATH

# Help/MAN Setup
export MANPATH=/usr/share/man:/usr/share/man/en:/usr/kerberos/man:/usr/local/share/man:/usr/java/jdk1.6.0_17/man

# SQL Plus Environment
export SQLPATH=~/.configuration/sqlplus

# SSH Environment
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi
