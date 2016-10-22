#!/bin/sh
[ $# -lt 1 ] && echo "usage: $0 working|not-working" && exit 1

logger=/usr/bin/logger

PROPERTY="include when getting new mail"

# Applescript 'tell' will open the application; I don't want it opened unless it was opened before so this saves the state of Mail.app
BEFORESTATE=$(pgrep Mail)

if [ "$1" = "working" ]; then
  osascript -e "tell application \"Mail\"" -e "set ${PROPERTY} of account \"Work\" to true" -e "set ${PROPERTY} of account \"HWCIR\" to true" -e "set ${PROPERTY} of account \"Johnnie\" to false" -e "end tell"
  $logger -t changemacmailchecker "Changed Mail to Work setup."
else
  osascript -e "tell application \"Mail\"" -e "set ${PROPERTY} of account \"Work\" to false" -e "set ${PROPERTY} of account \"HWCIR\" to false" -e "set ${PROPERTY} of account \"Johnnie\" to true" -e "end tell"
  $logger -t changemacmailchecker "Changed Mail to Not-Working setup."
fi

AFTERPID=$(pgrep Mail)

if [[ -z $BEFORESTATE ]]
then
  kill -TERM $AFTERPID
  $logger -t changemacmailchecker "Mail process id ${AFTERPID} killed as Mail was not running before this script."
else
  $logger -t changemacmailchecker "Mail process id ${AFTERPID} was NOT killed as Mail was already running before this script."
fi
