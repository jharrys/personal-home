#!/bin/zsh
brew cask ls -1 |xargs brew cask info |sed -n -f ~/.bin/brewcask.sed
