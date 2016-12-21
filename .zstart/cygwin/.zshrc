#******************************************#
# Cygwin zshrc

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

. ${ZSTARTPLATFORM}/.aliases

#******************************************
# other options
#******************************************

# CD Path Setup
export CDPATH='~:~/winhome/Documents:~/winhome/Development/source_control:~/winhome/Development/source_control/hwcir:~/winhome/Development/source_control/hwcir/git:~/winhome/Development/source_control/openshift:~/winhome/Development/source_control/bitbucket-cloud'

# Modify path to place cygwin/bin at the front
export PATH=/bin:$PATH

# Java is set through Windows - no need to set it here

# Maven is set through Windows - no need to set it here

cd ~lpjharri
