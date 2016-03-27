#!/bin/sh

# Add a custom stack to the doc for recent apps, docs, etc
defaults write com.apple.dock persistent-others -array-add '{"tile-data" = {"list-type" = 1;}; "tile-type" = "recents-tile";}'

# Enable suck animation in Dock
defaults write com.apple.dock mineffect suck

# Reset Dock to default
#defaults delete com.apple.dock; killall Dock

killall Dock
