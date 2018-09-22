#!/bin/sh
case "$1" in
  *.gz) gunzip -c $1 2>/dev/null
    ;;
esac
