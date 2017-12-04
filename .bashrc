# .bashrc

#
#   Bash login (interactive) does the following:
#       <bold>login shell</bold> : is one whose first character of arg[0] is a '-' or '--login'
#       <bold>interactive shell</bold> : is one started without non-option args or without the -c or started with -i
#
#       As Interactive, Login shell -OR- Non-Interactive with --login option
#       1. Reads /etc/profile if it exists
#       2. Searches for (a) ~/.bash_profile, (b) ~/.bash_login, (c) ~/.profile in this order
#       3. Executes only one of a, b or c <- the first one that it finds in the search order above
#
#       As Interactive but NOT Login shell
#       1. Reads ~/.bashrc
#
#       Non-Interactive (usually running a shell script) - read the manual. Looks for BASH_ENV for the file to read.
#
#

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

function _commonsetup() {

	# Set bash options
	shopt -s histappend lithist
	set INPUTRC='~/.inputrc'

	# History options
	# "messes up with command numbering" export HISTCONTROL=ignoreboth:erasedups
	export HISTSIZE=2000
	export HISTFILESIZE=2000
	export HISTTIMEFORMAT="%d/%m/%y %T "
	# don't record any commands that start with a space
	export HISTIGNORE=' *'

	# setup cd path
	CDPATH="~/"
	CDPATH="${CDPATH}:/Volumes"
	CDPATH="${CDPATH}:~/Documents"
	CDPATH="${CDPATH}:~/git"
	CDPATH="${CDPATH}:~/Google Drive/Development"
	CDPATH="${CDPATH}:~/Google Drive/Development/Archive"
	export CDPATH

	# Used by many command line apps
	VISUAL=vim
	export VISUAL

	# Add my own colors
	# use the following command to generate your LS_COLORS environment variable: dircolors -b ~/.configuration/linux/dircolors.txt
	#LS_COLORS='rs=0:di=01;33:ln=01;32:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
	LS_COLORS='di=38;5;22:ln=38;5;28:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=31;43:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=38;5;25:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
	export LS_COLORS

	# Give color to my man pages
	# see http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
	export LESS_TERMCAP_mb=$(printf '\e[01;31m') # enter blinking mode
	export LESS_TERMCAP_md=$(printf '\e[01;38;5;74m') # enter double-bright mode
	export LESS_TERMCAP_me=$(printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
	export LESS_TERMCAP_se=$(printf '\e[0m') # leave standout mode
	export LESS_TERMCAP_so=$(printf '\e[38;5;246m') # enter standout mode
	export LESS_TERMCAP_ue=$(printf '\e[0m') # leave underline mode
	export LESS_TERMCAP_us=$(printf '\e[04;38;5;146m') # enter underline mode

	# The prompt I like
	#PS1='\w\n\u@\h \!|\$> '
	# This path contains the git branch, if the dir is part of a git repo (requires git-completion for bash)
	GIT_PS1_SHOWDIRTYSTATE=true         # * unstaged, + staged
	GIT_PS1_SHOWSTASHSTATE=true         # $ stashed
	GIT_PS1_SHOWUNTRACKEDFILES=true     # % untracked
	GIT_PS1_SHOWCOLORHINTS=true         # colored output based on 'git status -sb'
	GIT_PS1_DESCRIBE_STYLE=describe
	GIT_PS1_SHOWUPSTREAM="auto verbose"         # < behind, > ahead, <> diverged
	PS1='[\W$(__git_ps1 " (%s)")]\n\u@\h: <\!>]\$ '

	# Setup python environment
	if [ -d ~/.pyenv ]; then
		export PYENV_ROOT="$HOME/.pyenv"
		export PYENV_VERSION=2.7.9
		export PATH="$PYENV_ROOT/bin:$PATH"
		eval "$(pyenv init -)"
	fi

	# Setup aliases
	. ~/.bash-aliases

	# Source the git prompt script
	if [ -f "$HOME/.configuration/bash-git-prompt/share/gitprompt.sh" ]; then
		GIT_PROMPT_THEME=Solarized_Extravagant
	  __GIT_PROMPT_DIR=$HOME/.configuration/bash-git-prompt/share
	  source "$HOME/.configuration/bash-git-prompt/share/gitprompt.sh"
	fi
	. ~/.bash-git-prompt.sh

	# my functions
	#. ~/.bin/bash_john_functions.sh
}

function _darwinsetup() {

	# Figure out JAVA environment
	export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

	# Path setup
	PATH=/usr/local/bin:$PATH
	export PATH

	# Help/MAN Pages
	MANPATH=/usr/local/git/share/man:$MANPATH
	export MANPATH

	# MAVEN ENVIRONMENT
	MAVEN_HOME="/usr/local/Cellar/maven/3.3.9"
	MAVEN_OPTS="-Xmx1024m"
	export MAVEN_OPTS M2_HOME

	# SSH Environment
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		SESSION_TYPE=remote/ssh
	else
		case $(ps -o comm= -p $PPID) in
			sshd|*/sshd) SESSION_TYPE=remote/ssh;;
		esac
	fi
}

function _linuxsetup() {

	# Path Setup
	PATH=/sbin:/usr/sbin:$PATH
	export PATH

	# Library Path Setup
	LD_LIBRARY_PATH=/usr/lib64:/usr/local/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH

	# Help/MAN Setup
	MANPATH=/usr/share/man:/usr/share/man/en:/usr/kerberos/man:/usr/local/share/man:/usr/java/jdk1.6.0_17/man
	export MANPATH

	# SSH Environment
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		SESSION_TYPE=remote/ssh
	else
		case $(ps -o comm= -p $PPID) in
			sshd|*/sshd) SESSION_TYPE=remote/ssh;;
		esac
	fi

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
