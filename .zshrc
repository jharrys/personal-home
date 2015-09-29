function _commonsetup() {
  # Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

  # Set name of the theme to load.
  # Look in ~/.oh-my-zsh/themes/
  # Optionally, if you set this to "random", it'll load a random theme each
  # time that oh-my-zsh is loaded.
  ZSH_THEME="robbyrussell"

  # Uncomment the following line to use case-sensitive completion.
  # CASE_SENSITIVE="true"

  # Uncomment the following line to use hyphen-insensitive completion. Case
  # sensitive completion must be off. _ and - will be interchangeable.
  # HYPHEN_INSENSITIVE="true"

  # Uncomment the following line to disable bi-weekly auto-update checks.
  # DISABLE_AUTO_UPDATE="true"

  # Uncomment the following line to change how often to auto-update (in days).
  # export UPDATE_ZSH_DAYS=13

  # Uncomment the following line to disable colors in ls.
  # DISABLE_LS_COLORS="true"

  # Uncomment the following line to disable auto-setting terminal title.
  # DISABLE_AUTO_TITLE="true"

  # Uncomment the following line to enable command auto-correction.
  # ENABLE_CORRECTION="true"

  # Uncomment the following line to display red dots whilst waiting for completion.
  # COMPLETION_WAITING_DOTS="true"

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
  setopt HIST_IGNORE_DUPS
  setopt HIST_IGNORE_SPACE
  setopt SHARE_HISTORY

  # Would you like to use another custom folder than $ZSH/custom?
  # ZSH_CUSTOM=/path/to/new-custom-folder

  # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
  # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
  # Example format: plugins=(rails git textmate ruby lighthouse)
  # Add wisely, as too many plugins slow down shell startup.
  plugins=(git)

  # User configuration

  export PATH=$HOME/bin:/usr/local/bin:$PATH
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

  export EDITOR='vim'

  # Compilation flags
  # export ARCHFLAGS="-arch x86_64"

  # ssh
  # export SSH_KEY_PATH="~/.ssh/dsa_id"

  # SET options
  unsetopt INC_APPEND_HISTORY

  # Setup aliases
  . ~/.aliases

  # My Functions
  . ~/bin/john_functions.sh
}

function _linuxsetup() {
  # Proxy setup
	http_proxy="http://username:password@proxylp.ihc.com:8080"
	HTTP_PROXY=$http_proxy
	https_proxy=$http_proxy
	HTTPS_PROXY=$http_proxy
	no_proxy=localhost,127.0.0.0/8,*.local
	NO_PROXY=$no_proxy
	export http_proxy HTTP_PROXY https_proxy HTTPS_PROXY no_proxy NO_PROXY

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
	SQLPATH=~/configuration/sqlplus

	# SSH Environment
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		SESSION_TYPE=remote/ssh
	else
		case $(ps -o comm= -p $PPID) in
			sshd|*/sshd) SESSION_TYPE=remote/ssh;;
		esac
	fi
}

function _darwinsetup() {
  # nothing to do here yet
}

function _cygwinsetup() {
  # Path Setup
  CDPATH='~:~/winhome/Documents:~/winhome/Documents/SourceControl'
  export CDPATH

  # Powerline Environment - nice prompt for commandline and VIM
  . /home/lpjharri/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
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
