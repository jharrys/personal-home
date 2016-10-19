#!/bin/sh
[ $# -lt 1 ] && echo "usage: $0 working|not-working" && exit 1

PROPERTY="include when getting new mail"

if [ "$1" = "working" ]; then
  osascript -e "tell application \"Mail\"" -e "set ${PROPERTY} of account \"Work\" to true" -e "set ${PROPERTY} of account \"HWCIR\" to true" -e "end tell"
else
  osascript -e "tell application \"Mail\"" -e "set ${PROPERTY} of account \"Work\" to false" -e "set ${PROPERTY} of account \"HWCIR\" to false" -e "end tell"
fi
