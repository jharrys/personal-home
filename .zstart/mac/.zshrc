# Mac OS X zshrc

# Johnnie Harris
# 2016-12-20
#
# Runs after zshenv//.zshenv//zprofile//.zprofile//zshrc.
# It is used for interactive shells.

# execute the common zshrc
if [ -z "$ZSTART" ]
    then
        ZSTART=~/.zstart
        ZSTARTPLATFORM=${ZSTART}/mac
fi
source ${ZSTART}/zshrc

# ls settings
export CLICOLOR=1
export CLICOLOR_FORCE=1                                         # Force colors through non-tty streams such as less
export LSCOLORS=exfxcxdxbxegedabagacad

# cdpath settings
CDPATH="~/"
CDPATH="${CDPATH}:/Volumes"
CDPATH="${CDPATH}:~/Documents"
CDPATH="${CDPATH}:~/git"
CDPATH="${CDPATH}:~/Google Drive/Development"
CDPATH="${CDPATH}:~/Google Drive/Development/Archive"
export CDPATH
cdpath=(~/ /Volumes ~/Documents ~/git ~/Google\ Drive/Development ~/Google\ Drive/Development/Archive)

# go settings
export GOROOT="$(brew --prefix golang)/libexec"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN:$GOROOT/bin"

# python settings
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Rust/Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# node settings - XXX should this be set?
export NODE_PATH="/usr/local/lib/node_modules"

# set jenv
export PATH="$HOME/.jenv/bin:$PATH"¬
eval "$(jenv init -)"

# set gradle
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# set JAVA_HOME bin
export PATH=$PATH:$JAVA_HOME/bin

# set manpath
export MANPATH=$(manpath):$HOME/man

# set fzf key bindings and fuzzy completion
source <(fzf --zsh)

# br is a cool tui file explorer based on fzf
source /Users/johnnie.harris/.config/broot/launcher/bash/br

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/johnnie.harris/.docker/completions $fpath)
autoload -Uz compinit
compinit

# source platform aliases
if [ -d $ZSTART/aliases.d ];
then
    for a in $(\ls $ZSTART/aliases.d/*.mac-aliases)
    do
        source $a
    done
fi

