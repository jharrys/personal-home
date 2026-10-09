# $ZDOTDIR/.zprofile -- this IS the .zprofile zsh reads (ZDOTDIR is set in ~/.zshenv).
#
# Runs after /etc/zshenv -> ~/.zshenv -> /etc/zprofile, and before zshrc.
# .zprofile is the ksh-flavoured alternative to .zlogin; the two are not meant
# to be used together (they can be, though).
#
# Intentionally empty apart from the trace below, which is silent unless
# ZSTART_DEBUG is set. Login-only setup belongs here; see ~/.zprofile for the
# lines installers wrongly dropped in $HOME.
[[ -r ${ZSTART:-~/.zstart}/zdebug.zsh ]] && source ${ZSTART:-~/.zstart}/zdebug.zsh
zdebug_in '$ZDOTDIR/.zprofile'
zdebug_out
