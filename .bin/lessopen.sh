#!/bin/sh
case "$1" in
  *.gz) gunzip -c $1 >/tmp/less.$$ 2>/dev/null
        if [ -s /tmp/less.$$ ]; then
          echo /tmp/less.$$
        else
          rm -f /tmp/less.$$
        fi
        ;;
    esac
