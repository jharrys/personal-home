function setihc() {
  sudo route add -net 74.125.0.0 netmask 255.255.0.0 dev wlan0
  sudo route add -net 209.85.0.0 netmask 255.255.0.0 dev wlan0
  local myip=`ip -o -f inet addr |grep wlan0 |awk '{ print $4 }' |cut -d / -f 1`
  wget -O - --bind-address=$myip --post-data "aupaccept=true" http://docs.google.com
}

function alternatives_java() {
# $1 = path to the alternate
[ $# -lt 1 ] && echo "Needs 1 param: \$1 - path to alternate java (i.e., /opt/java/current)" && return 1
local PATH=${1%%/}
alternatives --install /usr/bin/java java $PATH/bin/java 30000 \
  --slave /usr/bin/keytool keytool $PATH/bin/keytool \
  --slave /usr/bin/orbd orbd $PATH/bin/orbd \
  --slave /usr/bin/pack200 pack200 $PATH/bin/pack200 \
  --slave /usr/bin/rmid rmid $PATH/bin/rmid \
  --slave /usr/bin/rmiregistry rmiregistry $PATH/bin/rmiregistry \
  --slave /usr/bin/servertool servertool $PATH/bin/servertool \
  --slave /usr/bin/tnameserv tnameserv $PATH/bin/tnameserv \
  --slave /usr/bin/unpack200 unpack200 $PATH/bin/unpack200 \
  --slave /usr/bin/jvisualvm jvisualvm $PATH/bin/jvisualvm \
  --slave /usr/bin/jconsole jconsole $PATH/bin/jconsole \
  --slave /usr/bin/javaws javaws $PATH/bin/javaws \
  --slave /usr/share/man/man1/java.1 java.1 $PATH/man/man1/java.1 \
  --slave /usr/share/man/man1/keytool.1 keytool.1 $PATH/man/man1/keytool.1 \
  --slave /usr/share/man/man1/orbd.1 orbd.1 $PATH/man/man1/orbd.1 \
  --slave /usr/share/man/man1/pack200.1 pack200.1 $PATH/man/man1/pack200.1 \
  --slave /usr/share/man/man1/rmid.1 rmid.1 $PATH/man/man1/rmid.1 \
  --slave /usr/share/man/man1/rmiregistry.1 rmiregistry.1 $PATH/man/man1/rmiregistry.1 \
  --slave /usr/share/man/man1/servertool.1 servertool.1 $PATH/man/man1/servertool.1 \
  --slave /usr/share/man/man1/tnameserv.1 tnameserv.1 $PATH/man/man1/tnameserv.1 \
  --slave /usr/share/man/man1/unpack200.1 unpack200.1 $PATH/man/man1/unpack200.1 \
  --slave /usr/share/man/man1/javaws.1 javaws.1 $PATH/man/man1/javaws.1 \
  --slave /usr/share/man/man1/jconsole.1 jconsole.1 $PATH/man/man1/jconsole.1 \
  --slave /usr/share/man/man1/jvisualvm.1 jvisualvm.1 $PATH/man/man1/jvisualvm.1
}

function explode_ear() {
  mkdir tmp_$1
  cd tmp_$1
  jar xf ../$1
  mkdir WAR
  cd WAR
  jar xf ../*.war
  mkdir -p WEB-INF/lib/JAR
  cd WEB-INF/lib/JAR
  echo "ready for you..."
}

function expand_rpm() {
	rpm2cpio $1 | cpio -ivd
}

function fixhosts() {
	sed --in-place=.bk "/$1/d" ~/.ssh/known_hosts
}

function grepinjar() {
	for x in `find . -name "*.jar"`
	do 
		jar tf $x |grep -iq "$1"
		[ "$?" = "0" ] && echo "FOUND IN: $x"
	done
}

# Allow use of 'cd ...' to cd up 2 levels, 'cd ....' up 3, etc.
# Usage: cd ..., etc.
function cd {
	local option= length= count= cdpath= i=  # Local scope and start clean
	# If we have an -L or -P sym link option, save then remove it
	if [ "$1" = "-P" -o "$1" = "-L" ]; then
		option="$1"
		shift
	fi

	# Are we using the special syntax? Make sure $1 isn't empty, then
	# match the first 3 characters of $1 to see if they are '...' then
	# make sure there isn't a slash by trying a substitution; if it fails,
	# there's no slash. Both of these string routines require Bash 2.0+
	if [ -n "$1" -a "${1:0:3}" = '...' -a "$1" = "${1%/*}" ]; then
		# We are using special syntax
		length=${#1}  # Assume that $1 has nothing but dots and count them
		count=2	      # 'cd ..' still means up one level, so ifnore first two

		# While we haven't run out of dots, keep cd'ing up 1 level
		for ((i=$count;i<=$length;i++)); do
			cdpath="${cdpath}../"  # Build the cd path
		done

		# Actually do the cd
		builtin cd $option "$cdpath"
	elif [ -n "$1" ]; then
		# We are NOT using special syntax; just plain old cd by itself
		builtin cd $option "$*"
	else
		# We are NOT using special syntax; plain old cd by itself to home dir
		builtin cd $option
	fi
} # end of cd

function tarsize {
	# Estimate the tar archive size
	tar -cf - "${1}" |wc -c
}

function tarverify {
	# Verify tar with file system - if relative paths, you must be in relative path
	tar tvfW "${1}"
}

function tardiff {
	# Diff between tar and file system - if relative paths, you must be in relative path
	tar dfz "${1}"
}

function taraddfile {
	# Add file or directory to tar archive - $1 is tar, $2 is file or dir
	tar rvf "${1}" "${2}"
}

function tarxwithwild {
	# Extract group of files using wild cards
	tar -xvf "${1}" --wildcards ${2}
}

########################################
#	Yum/rpm Functions
########################################
function yumUtils {
	# installs yum-utils which contains a few things includer yumdownloader
	yum install -y yum-utils
}

function rpmListPackage {
	# $1 is full filename of package
	[ $# -lt 1 ] && echo "Lists files in uninstalled package: \$1 is package file name" && return 1
	rpm -q -p $1 -l
}

########################################
# CUPS Printer Functions
########################################
function listRemotePrinters {
	# $1 = remote print server with port (631)
	[ $# -lt 1 ] && echo "Needs 1 param: \$1 - remote print server & port (631 default)" && return 1
	lpstat -h $1 -a
}
function createRemotePrinter {
	# $1 = name of printer on this host, $2 = remote host with port (631), $3 = name of printer on remote (use lpstat)
	[ $# -lt 3 ] && echo "Needs 3 param: \$1 - name of printer on this host, \$2 - remote print server & port (631 default), \$3 - name of remote printer (use lpstat to find out)" && return 1
	lpadmin -p $1 -v ipp://${2}/printers/${3}
	cupsenable $1
	cupsaccept $1
}

########################################
#	Git Functions
########################################
function gitMakeRemoteBranchDeletable {
	# $1 is the actual git dir -- .git or project.git
	git --git-dir $1 config --bool hooks.allowdeletebranch true
}

function gitCreateTrackingBranch {
	# $1 = new branch, $2 = remote name, $3 = remote branch name to track

	[ $# -lt 3 ] && echo "Needs 3 params: \$1 - new branch, \$2 - remote repo, \$3 - remote branch name" && return 1

	git branch -r |grep $3 > /dev/null
	if [ $? -lt 1 ]; then
		echo "$3 already exists, not creating it again"
	else
		git push $2 master:$3
	fi

	# when starting point ($2/$3) is a remote default is to --track
	git checkout -tb $1 ${2}/${3}
}

function gitDiffWithRemote {
	# $1 = local, $2 = server/branch; could be just $1 in which case $1 is server/branch and diff assumes . is branch
	git diff $1 $2
}

function gitPush {
	# $1 = remotename, $2 = local branch name, $3 = remote branch name
	[ $# -lt 3 ] && echo "Needs 3 params: \$1 - remote name, \$2 - local branch name, \$3 - remote branch name" && return 1
	git push $1 $2:$3
}

function gitDeleteRemoteBranch {
	# $1 = remote name, $2 = remote branch name
	[ $# -lt 2 ] && echo "Needs 2 params: \$1 - remote name, \$2 - remote branch name" && return 1
	git push $1 :$2
}

function putOnSharepoint {
	# $1 = user, $2 = file to upload, $3 = sharepoint site
	# sample url =  https://projects.intermountainhealthcare.org/sites/ea/esa/Shared%20Documents/
	# make sure spaces are converted to %20
	curl --ntlm --user $1 --upload-file $2 ${3}/${2}
}

function gitFixDeletedRemoteBranch {
	# $1 = remote name
	[ $# -lt 1 ] && echo "To clean up a remote branch that still appears in git branch -a when you know it's been removed. \$1 = remote name" & return 1
	git remote prune $1
}
