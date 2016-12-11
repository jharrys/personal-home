#######################################################################################
#                 common setup
#######################################################################################
function _commonsetup() {
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# HISTORY SETTINGS
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
export HIST_STAMPS="mm/dd/yyyy"
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export HISTCONTROL=ignoredups
export SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Set mail notifier variables
MAILCHECK=15
mailpath=(/var/mail/lpjharri)
export mailpath MAILCHECK

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(lol common-aliases git sudo mvn history brew extract python tmux osx zsh-syntax-highlighting web-search zsh-navigation-tools scd copyfile johnnie-colored-man-pages man copydir dircycle jsontools docker encode64)

# User configuration

# fix for atom not being able to download (redirect is not being followed)
export ATOM_NODE_URL=http://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist

export PATH=/usr/local/sbin:$HOME/.bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='gvim'
export GIT_EDITOR='gvim -f'

# Less options
export LESS="-S -n -r"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# SET options
unsetopt INC_APPEND_HISTORY
setopt EXTENDED_GLOB

# setting EXTENDED_GLOB breaks git-rev syntax (i.e., HEAD^ ... you'd have to escape ^ -> HEAD\^) the proper fix is to set NO_NOMATCH
setopt NO_NOMATCH

# Setup python environment, if there is a virtual one installed inside home directory
if [ -d ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PYENV_VERSION=2.7.9
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# Setup aliases
. ~/.aliases

# My Functions
fpath=(~/.zfuncs $fpath)
for d in ~/.zfuncs
do autoload `\ls $d`
done

# Setup my zsh help files - as described in http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Accessing-On_002dLine-Help
export HELPDIR=~/.zsh_help
unalias run-help
autoload run-help

# Setup H2
H2HOME="/Users/lpjharri/Applications/h2"
export H2HOME

PATH=$PATH:$H2HOME/bin
export PATH

export HOMEBREW_GITHUB_API_TOKEN=363214089b27eb70e2ac015ddf93cf9b5738864a

# Am I at Intermountain/work?; works with ~/.bin/atwork.sh script and some trigger (on mac os x I used ControlPlane to trigger atwork.sh when connected to IHC)
if [ -f ~/.ssh/at-ihc-work ]; then
  setProxy set
else
  setProxy unset
fi
}

#######################################################################################
#       linux setup
#######################################################################################
function _linuxsetup() {
# Path setup
CDPATH='.:~/:..:../..:~/Pictures/Wallpaper:~/Desktop:~/Documents:~/Downloads:~/Documents/Google Drive:~/Documents/Life Documents:~/Workspaces'
export CDPATH

# JAVA Environment
JAVA_HOME=/usr/java/jdk1.6.0_18
export JAVA_HOME

JDK_HOME=/usr/java/jdk1.6.0_18
export JDK_HOME

# Maven Environment
M2_HOME=~/Applications/apache-maven-2.2.1
export M2_HOME

# Path Setup
PATH=$M2_HOME/bin:/opt/subversion/bin:$PATH
PATH=/sbin:/usr/sbin:$PATH
export PATH

# Library Path Setup
LD_LIBRARY_PATH=/usr/lib64:/usr/local/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

# Help/MAN Setup
MANPATH=/usr/share/man:/usr/share/man/en:/usr/kerberos/man:/usr/local/share/man:/usr/java/jdk1.6.0_17/man
export MANPATH

# SQL Plus Environment
SQLPATH=~/.configuration/sqlplus

# Add powerline environment
#powerline-daemon
PYTHONSITE=$(python -m site --user-site)
. $PYTHONSITE/powerline/bindings/zsh/powerline.zsh

# SSH Environment
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi

}

#######################################################################################
#       darwin setup
#######################################################################################
function _darwinsetup() {

# ls color
export CLICOLOR=1
export CLICOLOR_FORCE=1       # Force colors through non-tty streams such as less
export LSCOLORS=exfxcxdxbxegedabagacad

CDPATH="~/mounts:/Volumes:~/development:~/development/buildarea:~/development/source_control"
CDPATH="${CDPATH}:~/development/source_control/hwcir:~/development/source_control/hwcir/git:~/development/source_control/hwcir/svn"
CDPATH="${CDPATH}:~/development/source_control/playground:~/development/source_control/openshift:~/development/source_control/esa"
export CDPATH

# Weblogic
MW_HOME=~/local/appservers/wls-12.1.3
USER_MEM_ARGS="-Xmx1024m -XX:MaxPermSize=256m"
DOMAIN_HOME=~/local/wldomains/jland

export MW_HOME DOMAIN_HOME USER_MEM_ARGS

# Node environment
export NODE_PATH="/usr/local/lib/node_modules"

# Where to default store the screen shots (make sure the directory exists)
# defaults write com.apple.screencapture location ~/Dekstop/Screenshots

# Java - installed via Oracle dmg
# Java environment setup use /usr/libexec/java_home executable - default to jdk 8
JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
export JAVA_HOME

# Groovy - installed via brew
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# Maven - installed via brew
MAVEN_HOME=/usr/local/Cellar/maven/3.3.9
MAVEN_OPTS="-Xmx1024m"
export MAVEN_HOME MAVEN_OPTS

# Tomcat app server
CATALINA_HOME=/usr/local/Cellar/tomcat/8.5.8

# My Path statement
PATH=~/.bin:/usr/local/sbin:~/Library/Python/2.7/bin:/usr/local/bin:~/Applications/subit-3.0.0/bin:$JAVA_HOME/bin:$MAVEN_HOME/bin:$MW_HOME/wlserver/server/bin:$CATALINA_HOME/bin:$PATH
export PATH

# Run powerline for zsh - powerline is installed as 'pip install --user powerline-status'
# Identify Python site-packages site
#powerline-daemon
PYTHONSITE=$(python -m site --user-site)
. $PYTHONSITE/powerline/bindings/zsh/powerline.zsh

}

#######################################################################################
#         cygwin setup
#######################################################################################
function _cygwinsetup() {

# CD Path Setup
CDPATH='~:~/winhome/Documents:~/winhome/Development/source_control:~/winhome/Development/source_control/hwcir:~/winhome/Development/source_control/hwcir/git:~/winhome/Development/source_control/openshift:~/winhome/Development/source_control/bitbucket-cloud'
export CDPATH

# Modify path to place cygwin/bin at the front
PATH=/bin:$PATH
export PATH

# Java is set through Windows - no need to set it here

# Maven is set through Windows - no need to set it here

cd ~lpjharri
}

#
## main (start here)
#

darwin=false
cygwin=false
linux=false

case "`uname`" in
  Darwin*) darwin=true
    ;;
  CYGWIN*) cygwin=true
    ;;
  *) linux=true
    ;;
esac

# Execute pre common setup
_commonsetup

# Execute specific setups, override any from common
if $darwin; then
  _darwinsetup
elif $cygwin; then
  _cygwinsetup
else
  _linuxsetup
fi

# oh-my-zsh adds a deprecated environment variable. this disables it.
unset GREP_OPTIONS

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Setup my ZSH syntax highlighting options
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern) # by default only main is turned on
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue'
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('sudo *' 'fg=white,bg=red')
ZSH_HIGHLIGHT_PATTERNS+=('ssh *' 'fg=white,bg=blue')
