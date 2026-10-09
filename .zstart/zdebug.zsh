#############
#
# Johnnie Harris
#
# Startup tracing helper for zsh. Sourced first thing from ~/.zshenv, so every
# later startup file can call into it.
#
# Everything here is silent unless ZSTART_DEBUG is set to something other than 0.
#
#   ZSTART_DEBUG=1 zsh -i -c exit          # trace one interactive startup
#   ZSTART_DEBUG=1 zsh -l -i -c exit       # ... including the login files
#   export ZSTART_DEBUG=1                  # trace every new shell
#
# Knobs (all optional):
#   ZSTART_DEBUG          0/unset = off, anything else = on
#   ZSTART_DEBUG_LOG      also append the trace to this file
#   ZSTART_DEBUG_XTRACE   1 = turn on `setopt xtrace` with a useful PS4
#   ZSTART_DEBUG_PROFILE  1 = collect zprof and dump the top entries at the end
#
# API:
#   zdebug_in  <label>    open a stage (indents everything until closed)
#   zdebug_out [label]    close the innermost stage, reporting its elapsed time
#   zdebug     <message>  one-off note inside the current stage
#   zdebug_var <name>...  report the current value of one or more variables
#   zdebug_finish         final total + optional zprof dump (end of last rc file)
#
#############

# Guard against double-sourcing (e.g. nested/exec'd shells re-reading .zshenv).
(( ${+ZSTART_DEBUG_LOADED} )) && return 0
typeset -g ZSTART_DEBUG_LOADED=1

zmodload -F zsh/datetime p:EPOCHREALTIME 2>/dev/null

: ${ZSTART_DEBUG:=0}
: ${ZSTART_DEBUG_LOG:=}
: ${ZSTART_DEBUG_XTRACE:=0}
: ${ZSTART_DEBUG_PROFILE:=0}

typeset -gF ZSTART_DEBUG_T0=${EPOCHREALTIME:-0}
typeset -ga ZSTART_DEBUG_STACK=()

zdebug_enabled() { [[ -n $ZSTART_DEBUG && $ZSTART_DEBUG != 0 ]] }

# ---- internals -------------------------------------------------------------

# Colors only when stderr is a terminal, so a redirected trace stays greppable.
_zdebug_colors() {
    if [[ -t 2 ]]; then
        _zdebug_c_dim=$'\e[2;90m'
        _zdebug_c_open=$'\e[36m'
        _zdebug_c_close=$'\e[32m'
        _zdebug_c_note=$'\e[33m'
        _zdebug_c_off=$'\e[0m'
    else
        _zdebug_c_dim= _zdebug_c_open= _zdebug_c_close= _zdebug_c_note= _zdebug_c_off=
    fi
}
_zdebug_colors

_zdebug_emit() {
    print -ru2 -- "$1"
    [[ -n $ZSTART_DEBUG_LOG ]] && print -r -- "${1//$'\e'\[[0-9;]#m/}" >>| "$ZSTART_DEBUG_LOG"
    return 0
}

# _zdebug_line <color> <sigil> <text> [suffix]
# Builds the line with `printf -v` rather than $(...) so tracing costs no forks
# and the reported times stay honest.
_zdebug_line() {
    local color=$1 sigil=$2 text=$3 suffix=$4
    local -F elapsed=$(( (${EPOCHREALTIME:-0} - ZSTART_DEBUG_T0) * 1000 ))
    local pad='' line i
    for (( i = 1; i <= $#ZSTART_DEBUG_STACK; i++ )); do pad+='  '; done
    printf -v line '%szsh %8.1fms%s %s%s%s %s%s%s%s%s' \
        "$_zdebug_c_dim" "$elapsed" "$_zdebug_c_off" \
        "$pad" "$color" "$sigil" "$text" "$_zdebug_c_off" \
        "$_zdebug_c_dim" "$suffix" "$_zdebug_c_off"
    _zdebug_emit "$line"
}

# ---- public API ------------------------------------------------------------

zdebug_in() {
    zdebug_enabled || return 0
    _zdebug_line "$_zdebug_c_open" '->' "${1:-?}"
    ZSTART_DEBUG_STACK+=( "${1:-?}|${EPOCHREALTIME:-0}" )
}

zdebug_out() {
    zdebug_enabled || return 0
    if (( ! $#ZSTART_DEBUG_STACK )); then
        _zdebug_line "$_zdebug_c_note" '!!' "zdebug_out with no open stage: ${1:-?}"
        return 0
    fi
    local frame=${ZSTART_DEBUG_STACK[-1]}
    local label=${frame%|*} start=${frame##*|}
    ZSTART_DEBUG_STACK[-1]=()   # pop first so the closer aligns with its opener
    local -F took=$(( (${EPOCHREALTIME:-0} - start) * 1000 ))
    local took_s
    printf -v took_s '  %.1fms' "$took"
    _zdebug_line "$_zdebug_c_close" '<-' "${1:-$label}" "$took_s"
}

zdebug() {
    zdebug_enabled || return 0
    _zdebug_line "$_zdebug_c_note" '..' "$*"
}

zdebug_var() {
    zdebug_enabled || return 0
    local name
    for name in "$@"; do
        zdebug "$name=${(P)name}"
    done
}

zdebug_finish() {
    zdebug_enabled || return 0
    while (( $#ZSTART_DEBUG_STACK )); do zdebug_out; done
    local -F total=$(( (${EPOCHREALTIME:-0} - ZSTART_DEBUG_T0) * 1000 ))
    local total_s
    printf -v total_s 'startup complete in %.1fms' "$total"
    _zdebug_line "$_zdebug_c_close" '==' "$total_s"
    if [[ -n $ZSTART_DEBUG_PROFILE && $ZSTART_DEBUG_PROFILE != 0 ]] && (( $+builtins[zprof] )); then
        _zdebug_emit ''
        zprof | head -25 >&2
    fi
    return 0
}

# ---- opt-in extras ---------------------------------------------------------

if zdebug_enabled; then
    if [[ -n $ZSTART_DEBUG_PROFILE && $ZSTART_DEBUG_PROFILE != 0 ]]; then
        zmodload zsh/zprof 2>/dev/null
    fi
    if [[ -n $ZSTART_DEBUG_XTRACE && $ZSTART_DEBUG_XTRACE != 0 ]]; then
        PS4='+ %N:%i > '
        setopt xtrace
    fi
fi
