####################################################################
#################################
#############
#
# Johnnie Harris
# 2016-12-20
#
# This runs after zshenv and before all the rest of the rc files.
# It is used to figure out what platform I'm on and setting the
# ZDOTDIR and other key environment files.
#
#############
#################################
####################################################################

export ZSTART=~/.zstart

darwin=false
cygwin=false
linux=false

case "`uname`" in
    Darwin*) ZSTARTPLATFORM=${ZSTART}/mac
        ;;
    CYGWIN*) ZSTARTPLATFORM=${ZSTART}/cygwin
        ;;
    *) ZSTARTPLATFORM=${ZSTART}/linux
        ;;
esac

export ZSTARTPLATFORM

export ZDOTDIR=${ZSTARTPLATFORM}

source "$HOME/.cargo/env"
