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

	# Used by many command line apps
	VISUAL=vim
	export VISUAL

    # Add my own colors
    # use the following command to generate your LS_COLORS environment variable: dircolors -b ~/configuration/linux/dircolors.txt
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
    GIT_PS1_SHOWUPSTREAM="auto verbose"         # < behind, > ahead, <> diverged
	PS1='[\W$(__git_ps1 " (%s)")]\n\u@\h: <\!>]\$ '

	#
	## ALIASES
	#

	# General
    alias ls='ls --color'
	alias mv='mv -i'
	alias cp='cp -i'
	alias ll='ls -l'
	alias vi='vim'
	alias la='ls -Al'
	alias lld='ls -Al |grep ^d'
	alias elias='vim ~/.bashrc'
	alias ralias='. ~/.bashrc'
	alias getw='wget -N -r -nH -nd --no-parent'

    # Rsync
    # [a](rlptogD) [v]erbose [u]pdate [z]compress [h]umanreadable [P]partial,progress
	alias rsync='rsync -avuzhP'						# rsync SOURCE DEST; for excluding to --exclude=PATTERN
	alias rsyncjohnbk='rsync -avuz --progress --exclude=*.vdi --exclude=Work\ Center/BioInformatics\ Center/UDOH* --exclude=Work\ Center/BioInformatics\ Center/smpi* --exclude=Workspaces/* --exclude=.Trash/* /Users/john john@zax:/mnt/nethome'
    alias rsyncPicToshibaAsSource='rsync -avuzhP ${HOME}/winhome/Mounts/toshiba/pictures/'

    # Time savers
    alias a='alias | cut -d " " -f 2-; echo "---------- TIME SAVERS --------"; alias | cut -d " " -f 2- | egrep "^_ts"'
    alias _tsLargestDirs='find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn'
    alias _tsLargeFiles='find . -size +1000000 -ls'
    alias _tsWhoHasFileOpen?='fuser'
    
        ## commands that will require sudo
    if [ $UID -ne 0 ]; then
        alias reboot='sudo reboot'
        alias useradd='sudo /usr/sbin/useradd'
        alias adduser='sudo /usr/sbin/useradd'
        alias userdel='sudo /usr/sbin/userdel -f'
        alias deluser='sudo /usr/sbin/userdel -f'
        alias newgroupnogid='sudo /usr/sbin/groupadd'
        alias newgroupgid='read -p "gid? " GID;sudo /usr/sbin/groupadd --gid ${GID}'
        alias adduser2group='read -p "groups(separate by ,)? " GR;sudo /usr/sbin/usermod --append --groups ${GR}'
        alias mntesa='sudo mkdir -p /mnt/eisa-share; sudo mount //co-lp-vmpfile1/eisa-share /mnt/eisa-share/ -o user=lpjharri'
        alias umntesa='cd /tmp;sudo umount /mnt/eisa-share/;cd -'
    fi

	# History
	alias r='fc'				# "r 10" or "r 10 20"; rerun 10 or rerun 10 through 20 (can also be given as string)
	alias rl='fc -l'			# "rl 10 20" - lists history 10 to 20
	alias rr='fc -s'			# "rr old=new 10" - rerun command 10 sub old with new (instead of 10, can use string)
	alias hsync='history -a ; history -n'

	alias web='python -m SimpleHTTPServer'						# with no arg, the server is listening on 8000
	alias fnung='find / \( -nouser -o -nogroup \) -print'		# find files/dirs with no user or no group
	alias uneven='findUnevenPermissions.py'						# find uneven permissions

	# Wget aliases
	alias wget-asfirefox='wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3"'
	alias wget-back='wget -b'									# Backgrounds wget download: "get-back http://my.favorite.com/file.zip"
	alias wget-verify='wget --spider'							# Verifies that url works: "get-verify http://my.favorite.com/file.zip"
	alias wget-resume='wget -c'									# Resume partially downloaded file: "wget-resume http://my.favorite.com/file.zip"
	alias wget-retry='wget --tries=30'							# Default retries is 20, this ups it to 30: "wget-retry http://my.favorite.com/file.zip"
	alias wget-mirror='wget --mirror -p --convert-links -P'		# Download full website; -p download all to properly display html; --convert-links for local viewing; -P tell it where to save
																# "wget-mirror ./DIR-OF-MY-FAV-SITE-MIRRORED http://my.favorite.com"
	alias wget-reject='wget --reject='							# Specify types to Reject such as gif: "wget-reject gif http://my.favorite.com"
	alias wget-log-err='wget -o'								# Log stderr to specified file: "wget-log-err ./err.log http://my.favorite.com"
	alias wget-accept='wget -r -A'								# Download recursively, Accept types specified: "wget-accept pdf http://pdf.favorites.com"

	# Tidy up xml
	alias tidyxml='tidy -i -q -w 0 -xml'

	# Update Locate database
	alias locupd='cd /; sudo /usr/libexec/locate.updatedb'

	# Strings and Binary files
	alias binstr='strings -a'		# binstr binfile (searches full file and certain sections from TK_STRINGS_DEFAULT_SECTIONS)
	alias binstrn='strings -n'		# binstrn 2 binfile (returns strings >=2)
	alias binstrm='strings -f'		# binstrf /bin/* (searches all bin files)
	alias binstro='strings -o'		# binstro binfile (returns strings with their octal offset)

	# Convert deb to rpm and rpm to deb
	alias alien='alien -r'			# To convert deb to rpm

	###########################
	###### Development ########
	###########################
	
	# Patching
	alias dry='patch -Np1 --dry-run'							# Do a dry run of the patch - add the "< file.patch"
	alias dp='LC_ALL=C TZ=UTC diff -aNru'						# Create a unified patch from diff - add the "original target > file.patch"

	# GIT stuff
	alias gitinit='git init'									# gitinit - creates bare git (use "git add .")
	alias gitinitbare='git init --bare'							# gitinitbare /some/dirproject.git - creates git repo without work local files
	alias gitrepo='git clone'									# gitrepo ~/existing/repo ~/new/repo -OR- gitrepo ssh://john@host/srv/git/some.git
	alias gitrh='git reset --hard'								# Reset working local (wl), index and HEAD ref to all be the same - to HEAD if no arg
	alias gitrs='git reset --soft'								# Reset HEAD ref to arg you give - leaves wl and index as is (wl and index may not match)
	alias gitcln='git clean -d -n'								# Clean wl (dry-run), deleting unstage files also (reset --hard doesn't anymore)
	alias gitcl='git clean -d'									# Clean wl (real), deleting unstage files also (reset --hard doesn't anymore)
	alias gitdf='git diff --name-only'							# Diff, producing only names that changed (provide branch name for diff between current and other branch - remote/branch also)
	alias gitdfstat='git diff --numstat'						# Diff, producing number stats
	alias gitdfstaged='git diff --cached'						# Diff what you've staged
	alias gitcleancheckout='git checkout -f'					# Throws away ALL UN-committed work, leaving new files untouched (never committed before) - and checks out CLEAN.
	alias gitconfig='git config --global'						# Apply aliases or other configs globally: gitconfig alias.co checkout - sets up co for checkout
	alias gitlistcommittedfiles='git ls-files'
	alias gitstashlist='git stash list'
	alias gitstashsave='git stash save'							# gitsavestash "Put message here to remind you of what you stashed"
	alias gitstashclear='git stash clear'						# delete stash
	alias gitstash='git stash apply'							# Load back the stash
	alias gitbrlist='git branch -a'								# List both remote & local branches
	alias gitchp='git cherry-pick'								# gitchp SHA1-COMMIT - merges SHA1-COMMIT into current branch
	alias gitaddp='git add -p'									# gitaddp - let's you pick the changes interactively as your shown diffs
	alias gitrebasei='git rebase -i'							# gitrebasei HEAD~3 - interactively rewrite history; delete pick to remove commit, 'edit' & 'squash' 
    alias gitrmbr='read -p "branch: " BR;git push origin :$BR'  # delete remote branch on origin - git push origin :remotebranch 
    alias gitrmtag='read -p "tag: " BR;git push origin :refs/tags/$BR'  # delete remote tag on origin - git push origin :remotetag 
    alias gru='read -p "remote: " RM;git remote update ${RM:-origin}'        # remote update without pulling, then git status will show appropriate info

	# Maven stuff
	alias mvnhelp='mvn help:help -Ddetail=true' 					# helpmemaven
	alias mvnc='mvn clean'											# mvn clean
	alias mvncp='mvn clean package'									# mvn clean package
	alias mvncpskip='mvn clean package -Dmaven.test.skip=true'		# mvn clean package and skip all the tests
	alias mvnci='mvn clean install'									# mvn clean install
	alias mvnciskip='mvn clean install -Dmaven.test.skip=true'		# mvn clean package and skip all the tests
	alias mvnp='mvn package'										# mvn package without the clean
	alias mvnpskip='mvn package -Dmaven.test.skip=true'				# mvn package and skip all the tests
	alias mvni='mvn install'										# mvn install without the clean
	alias mvniskip='mvn install -Dmaven.test.skip=true'				# mvn install and skip all the tests
	alias mvnfurther='mvn --settings ~/.m2/further-settings.xml'	# Run further's mvn
	alias mvntest='mvn test'										# mntest -Dtest=fqclassname - run a single test, give the fqcn
	alias mvninstfile='mvn install:install-file'					# mvninstfile -Dfile=myfile.jar -DgroupId=xxxx -DartifactId=yyyy 
																	# -Dversion=1 -Dpackaging=jar -DgeneratePom=true
	alias mvnreleaseprep='mvn release:prepare -DpreparationGoals="clean install"'

    # tomcat/esaui work (lpv-ideadev07)
    alias esapush='scp /home/lpjharri/winhome/Documents/SourceControl/sts-workspace/esa-ui/esa-ui.war lpv-ideadev07:tmp'

    # screen or tmux commands
    alias screen='screen ${SHELL} -l'

    # ip performance testing
    alias testperfasserver='iperf -s'                               # runs as a server
    alias testperfasclient='iperf -c'                               # needs host name to test against

    alias trycolors='eval $( dircolors -b ~/configuration/linux/dircolors.txt ); ls'

	# my functions
	. ~/bin/john_functions.sh
}

function _darwinsetup() {

	if [ -z "$JAVA_VERSION" ]; then
		JAVA_VERSION="CurrentJDK"
		export JAVA_VERSION
	else
		echo "Using Java version: $JAVA_VERSION"
	fi
	if [ -z "$JAVA_HOME" ]; then
		JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
		export JAVA_HOME
	fi

	PATH=/usr/local/git/bin:$PATH
	export PATH

	MANPATH=/usr/local/git/share/man:$MANPATH
	export MANPATH

	# MAVEN ENVIRONMENT
	M2_HOME="/usr/share/maven"
	MAVEN_OPTS="-Xmx256m"
	export MAVEN_OPTS M2_HOME

	# ALIASES
	alias text='open /Applications/TextEdit.app'

	# MacVim Editor
	alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'				# MacVim
	alias gvim-diff='/Applications/MacVim.app/Contents/MacOS/Vim -g -d'		# MacVim in diff mode like vimdiff

	# Emacs Editor
	alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'				# Emacs

	# Virtual Box applications
	export DEFAULTVM="Fedora 13"		# Set the default VM to work against
	alias v='VBoxManage --nologo'
	alias vlist='VBoxManage --nologo list runningvms'
	alias vc='echo "DefaultVM: $DEFAULTVM";VBoxManage --nologo controlvm "$DEFAULTVM"'
	alias vs='echo "DefaultVM: $DEFAULTVM";VBoxManage --nologo startvm "$DEFAULTVM"'


	# Query AddressBook
	alias qadd="sqlite3 -separator ',' ~/Library/Application\ Support/AddressBook/AddressBook-v22.abcddb \"select e.ZADDRESSNORMALIZED,p.ZFIRSTNAME,p.ZLASTNAME,p.ZORGANIZATION from ZABCDRECORD as p, ZABCDEMAILADDRESS as e WHERE e.ZOWNER=p.Z_PK;\""

	. /sw/bin/init.sh

}

function _linuxsetup() {

	# The following command will get the first octet of the IP associated with eth0
	# myeth0ip=`ip -o -f inet addr |grep eth0 |awk '{ print $4 }' |cut -d . -f 1`

	# Currently disabled because U of U Research is whitelisted
	#if [ "$myeth0ip" = "3" ]; then
	#  HTTP_PROXY="http://gems.setpac.ge.com/pac.pac"
	#  export HTTP_PROXY
	#fi
    http_proxy="http://username:password@proxylp.ihc.com:8080"
    HTTP_PROXY=$http_proxy
    https_proxy=$http_proxy
    HTTPS_PROXY=$http_proxy
    no_proxy=localhost,127.0.0.0/8,*.local
    NO_PROXY=$no_proxy
    export http_proxy HTTP_PROXY https_proxy HTTPS_PROXY no_proxy NO_PROXY
    
    CDPATH='.:~/:..:../..:~/Pictures/Wallpaper:~/Desktop:~/Documents:~/Downloads:~/Documents/Google Drive:~/Documents/Life Documents:~/Workspaces'
	export CDPATH

	# Variables
	#JAVA_HOME=/etc/alternatives/java_sdk_1.6.0
	JAVA_HOME=/usr/java/jdk1.6.0_18
	export JAVA_HOME

	#JDK_HOME=/etc/alternatives/java_sdk_1.6.0
	JDK_HOME=/usr/java/jdk1.6.0_18
	export JDK_HOME

	M2_HOME=~/Applications/apache-maven-2.2.1
	export M2_HOME

	PATH=$M2_HOME/bin:/opt/subversion/bin:$PATH
	export PATH

    # Add sbin dirs
    PATH=/sbin:/usr/sbin:$PATH
    export PATH

	LD_LIBRARY_PATH=/usr/lib64:/usr/local/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH

	MANPATH=/usr/share/man:/usr/share/man/en:/usr/kerberos/man:/usr/local/share/man:/usr/java/jdk1.6.0_17/man
	export MANPATH

    # SQL Plus
    SQLPATH=~/configuration/sqlplus

	# ALIASES
	alias yl='yum list installed'
	alias yr='yum remove -y'
	alias yli='yum localinstall -y --nogpgcheck'

    # Bash completion on Fedora is at 2.1 (cygwin is behind) - the new one split to have a git-prompt.sh that needs to be sourced
    . ~/.git-prompt.sh

}

function _cygwinsetup() {

    CDPATH='.:~/:..:../..:~/winhome/Pictures/Wallpaper:~/winhome/Desktop:~/winhome/Documents:~/winhome/Downloads:~/winhome/Documents/Google Drive:~/winhome/Documents/SourceControl:~/winhome/Documents/SourceControl/sts-workspace'
	export CDPATH

	# Variables

	# ALIASES
    alias w7='cd ${HOME}/winhome/AppData/Roaming/Microsoft/Windows'
    alias w7libs='cd ${HOME}/winhome/AppData/Roaming/Microsoft/Windows/Libraries'

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

