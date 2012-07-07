# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin
DESKTOP=KDE

export PATH DESKTOP

test -r /sw/bin/init.sh && . /sw/bin/init.sh

#case "`uname`" in
#	Darwin*) touch ~/.login_to_darwin
#	;;
#esac
