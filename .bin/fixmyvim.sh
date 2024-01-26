#!/bin/sh
VIMDIR="~/.vim"
if [ -d $VIMDIR ]; then
  mkdir -p ${VIMDIR}/.swp
  mkdir -p ${VIMDIR}/.backup
  mkdir -p ${VIMDIR}/.undo
  echo "$VIMDIR exists and I added .swp, .backup and .undo directories."
else
  echo "Nothing to do; $VIMDIR already exists and so do the swp, backup and undo directories."
fi
