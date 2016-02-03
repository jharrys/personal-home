function _commonsetup() {
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

  # User configuration

  # fix for atom not being able to download (redirect is not being followed)
  export ATOM_NODE_URL=http://gh-contractor-zcbenz.s3.amazonaws.com/atom-shell/dist

  export PATH=$HOME/bin:/usr/local/bin:$PATH

  export EDITOR='vim'

  # Less options
  export LESS="-S -n -r"

  # SET options
  unsetopt INC_APPEND_HISTORY

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

function _darwinsetup() {

  # ls color
  export CLICOLOR=1
  export CLICOLOR_FORCE=1       # Force colors through non-tty streams such as less
  export LSCOLORS=exfxcxdxbxegedabagacad

  # Proxy setup
  http_proxy="http://username:password@proxylp.ihc.com:8080"
  HTTP_PROXY=$http_proxy
  https_proxy=$http_proxy
  HTTPS_PROXY=$http_proxy
  no_proxy=localhost,127.0.0.0/8,*.local
  NO_PROXY=$no_proxy
  export http_proxy HTTP_PROXY https_proxy HTTPS_PROXY no_proxy NO_PROXY

  CDPATH='/Volumes:~/development:~/development/buildarea:~/development/source_control:~/development/source_control/hwcir:~/development/source_control/hwcir/git:~/development/source_control/hwcir/svn'
  export CDPATH

  # for weblogic
  MW_HOME=~/local/appservers/wls-12.1.3
  export MW_HOME

  # for weblogic
  USER_MEM_ARGS="-Xmx1024m -XX:MaxPermSize=256m"
  export USER_MEM_ARGS

  # Where to default store the screen shots (make sure the directory exists)
  # defaults write com.apple.screencapture location ~/Dekstop/Screenshots

  # my weblogic instance
  DOMAIN_HOME=~/local/wldomains/hwapp
  export DOMAIN_HOME

  # JAVA environment setup use /usr/libexec/java_home executable - default to jdk 8
  JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
  export JAVA_HOME

  MAVEN_HOME=/usr/local/Cellar/maven/3.3.9
  export MAVEN_HOME

  PATH=~/bin:/usr/local/sbin:~/Library/Python/2.7/bin:/usr/local/bin:~/Applications/subit-3.0.0/bin:$JAVA_HOME/bin:$MAVEN_HOME/bin:$MW_HOME/wlserver/server/bin:$PATH
  export PATH

  # Run powerline for zsh
  # Identify Python site-packages site
  PYTHONSITE=$(python -m site --user-site)
  . $PYTHONSITE/powerline/bindings/zsh/powerline.zsh
  #. /Users/lpjharri/Library/Python/2.7/lib/python/site-packages/powerline/bindings/zsh/powerline.zsh
}

function _cygwinsetup() {
  # Path Setup
  CDPATH='~:~/winhome/Documents:~/winhome/Documents/SourceControl'
  export CDPATH

  # Powerline Environment - nice prompt for commandline and VIM
  # Identify Python site-packages site
  PYTHONSITE=$(python -m site --user-site)
  . $PYTHONSITE/powerline/bindings/zsh/powerline.zsh
  #. /home/lpjharri/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
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

# Powerline Environment - nice prompt for commandline and VIM
# Below doesn't work if executed from within a function
sitepackagespath=$(python -c "import site; print(site.getsitepackages()[0])")
if [ -n "$sitepackagespath" -a -d "$sitepackagespath/powerline" ]; then
  . ${sitepackagespath}/powerline/bindings/zsh/powerline.zsh
fi

# oh-my-zsh adds a deprecated environment variable. this disables it.
unset GREP_OPTIONS
