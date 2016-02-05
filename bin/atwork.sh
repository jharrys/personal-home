#!/bin/sh
[ $# -lt 1 ] && echo "usage: $0 working|not-working" && return 1

if [ "$1" = "working" ]; then
  touch ~/.ssh/at-ihc-work
else
  rm -f ~/.ssh/at-ihc-work
fi
