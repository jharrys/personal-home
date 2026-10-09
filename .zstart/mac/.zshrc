# TO DEBUG use "ZSTART_DEBUG=1 /bin/zsh"
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
#******************************************#
# Mac OS X zshrc

# Johnnie Harris
# 2016-12-20
#
# Runs after zshenv//.zshenv//zprofile//.zprofile//zshrc.
# It is used for interactive shells.
#
# It's the main one used by all.
#
#******************************************#
[[ -r ${ZSTART:-~/.zstart}/zdebug.zsh ]] && source ${ZSTART:-~/.zstart}/zdebug.zsh
zdebug_in '$ZDOTDIR/.zshrc (personal)'

#******************************************
# execute the common zshrc
#******************************************
if [ -z "$ZSTART" ]
    then
        ZSTART=~/.zstart
        ZSTARTPLATFORM=${ZSTART}/mac
fi

. ${ZSTART}/zshrc

#******************************************
# ls settings
#******************************************

export CLICOLOR=1
export CLICOLOR_FORCE=1                                         # Force colors through non-tty streams such as less
export LSCOLORS=exfxcxdxbxegedabagacad

#******************************************
# cdpath settings
#******************************************

CDPATH="~/"
CDPATH="${CDPATH}:~/Applications"
CDPATH="${CDPATH}:~/Desktop"
CDPATH="${CDPATH}:~/Documents"
CDPATH="${CDPATH}:~/claude-cowork"
CDPATH="${CDPATH}:~/workspace/engineering"
CDPATH="${CDPATH}:~/workspace/engineering/devcontainers"
CDPATH="${CDPATH}:~/workspace/engineering/notebooks"
CDPATH="${CDPATH}:~/workspace/engineering/pa"
CDPATH="${CDPATH}:~/workspace/engineering/cftf"
CDPATH="${CDPATH}:~/workspace/engineering/worktrees"
CDPATH="${CDPATH}:~/workspace/business"
CDPATH="${CDPATH}:~/workspace/screenshots"
CDPATH="${CDPATH}:~/Google Drive/My Drive"
CDPATH="${CDPATH}:~/Google Drive/Other computers"
CDPATH="${CDPATH}:~/Library"
CDPATH="${CDPATH}:/Volumes"
export CDPATH

cdpath=(~/ ~/Applications ~/Desktop ~/Documents ~/claude-cowork ~/workspace/engineering ~/workspace/engineering/devcontainers ~/workspace/engineering/notebooks ~/workspace/engineering/pa ~/workspace/engineering/cftf ~/workspace/engineering/worktrees ~/workspace/business ~/workspace/screenshots ~/Google\ Drive/My\ Drive ~/Google\ Drive/Other\ computers ~/Library /Volumes)
#*****************************************
# screen capture settings - Where to default store the screen shots (make sure the directory exists)
#******************************************

defaults write com.apple.screencapture location ~/workspace/screenshots

# set gradle
export GRADLE_HOME=/opt/homebrew/opt/gradle
export PATH="$PATH:$GRADLE_HOME/bin"

# set groovy home
export GROOVY_HOME=/opt/homebrew/opt/groovy/libexec

# Rust/Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# node settings - XXX should this be set?
export NODE_PATH="/usr/local/lib/node_modules"

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

#******************************************
# source platform aliases
#******************************************
# Global aliases
zdebug_in 'aliases.d/*.mac-aliases'
if [ -d $ZSTART/aliases.d ];
then
    for a in $(\ls $ZSTART/aliases.d/*.mac-aliases)
    do
        zdebug "source ${a:t}"
        source $a
    done
fi
zdebug_out


zdebug_in 'iterm2 shell integration'
test -e /Users/johnnie.harris/.zstart/mac/.iterm2_shell_integration.zsh && source /Users/johnnie.harris/.zstart/mac/.iterm2_shell_integration.zsh || true
zdebug_out
# it2git - placed after .iterm2_shell_integration.zsh
function iterm2_print_user_vars() {
    it2git

    # set based on day
    local day=$(date '+%A')
    case $day in
        Monday|Tuesday)
            iterm2_set_user_var funny ⚔️
            ;;
        Wednesday|Thursday)
            iterm2_set_user_var funny ⚓️
            ;;
        Friday)
            iterm2_set_user_var funny 🚁
            ;;
        Saturday|Sunday)
            iterm2_set_user_var funny 🛩
            ;;
        *)
            iterm2_set_user_var funny 🚧
    esac

}

#******************************************
# certain directories and their children can be set for specific java versions:
# jenv local VERSION
# list all
# jenv versions
# set globally
# jenv global VERSION
# The system default on my work laptop is openjdk 21 "system" when jenv versions is run.
# *********** =====> Also - don't forget to enable plugins: jenv enable-plugin export; do this for export, maven, gradle, groovy and springboot
#******************************************
export PATH="$HOME/.jenv/bin:$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
zdebug_in 'jenv init'
eval "$(jenv init -)"
zdebug_out

# python3 and pipx both installed by homebrew
export PATH="$HOME/.local/bin:$PATH"
# FORGIT
zdebug_in 'forgit'
[ -f $HOMEBREW_PREFIX/opt/forgit/share/forgit/forgit.plugin.zsh ] && source $HOMEBREW_PREFIX/opt/forgit/share/forgit/forgit.plugin.zsh
zdebug_out

#******************************************
# tmux autostart (iTerm2 only)
#******************************************
# Attach to the 'main' session, or create it, whenever an interactive shell
# is opened in iTerm2. exec so tmux replaces zsh -- quitting tmux closes the
# tab instead of dropping to a bare shell.
#
# Deliberately narrow so it never fires in the places that break:
#   $TMUX / $TMUX_PANE -- already inside tmux (pane shells would recurse)
#   TERM_PROGRAM       -- only iTerm2; not Terminal.app, VS Code, Kiro,
#                         JetBrains, or anything embedding a shell
#   interactive        -- scripts and `zsh -c` are untouched
#   SSH_CONNECTION     -- leave remote sessions alone
#   NO_TMUX=1          -- manual escape hatch: `NO_TMUX=1 zsh`
#
# Keep this LAST: exec never returns, so anything below it would not run.
if [[ -o interactive ]] \
    && [[ -z "$TMUX" && -z "$TMUX_PANE" ]] \
    && [[ "$TERM_PROGRAM" == "iTerm.app" ]] \
    && [[ -z "$SSH_CONNECTION" && -z "$NO_TMUX" && -z "$VSCODE_INJECTION" && -z "$INSIDE_EMACS" ]] \
    && command -v tmux >/dev/null 2>&1
then
    # One client per session. Attaching every window to one shared session
    # (`new-session -A -s main`) makes each new iTerm2 window mirror the others
    # and clamps all clients to the smallest one's size -- the "cloned window"
    # behaviour. Instead: reuse a session only when nothing is attached to it
    # (so quitting/crashing iTerm2 reattaches to that work), otherwise start a
    # fresh session for this window.
    #
    # CLICOLOR_FORCE is unset for the tmux server itself, matching the `tx` and
    # `tmuxcc` aliases: it forces color through non-tty streams, which garbles
    # `tmux capture-pane` and anything else that pipes tmux output. Pane shells
    # re-source this file and get it back.
    __tmux_detached=$(command tmux list-sessions -F '#{session_attached} #{session_name}' 2>/dev/null \
        | awk '$1 == 0 { print $2; exit }')

    if [[ -n "$__tmux_detached" ]]; then
        zdebug "tmux autostart: attaching to detached session \"$__tmux_detached\""
        exec env -u CLICOLOR_FORCE tmux attach-session -t "$__tmux_detached"
    fi
    unset __tmux_detached

    if ! command tmux has-session -t=main 2>/dev/null; then
        zdebug 'tmux autostart: creating session "main"'
        exec env -u CLICOLOR_FORCE tmux new-session -s main
    fi

    zdebug 'tmux autostart: every session attached -- creating another'
    exec env -u CLICOLOR_FORCE tmux new-session
fi

# Kiro CLI post block. Keep at the bottom of this file.
#[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
