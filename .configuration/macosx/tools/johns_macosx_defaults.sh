#!/bin/sh

# Show icons for drives, servers and removable media on desktop by default
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

# Show file extensions by default in finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar in finder by default
defaults write com.apple.finder ShowStatusBar -bool true

# Don't show .DS_Store files on network volumes by default
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Allow text selection in Quick Look/Preview in Finder by default
defaults write com.apple.finder QLEnableTextSelection -bool true

# Set dock animation fast and group by app
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

# Set dock to autohide and make delay fast
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Quit printer queue view after printing finished
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Check for software updates daily
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Dim keyboard backlight after 5 minutes non-use
defaults write com.apple.BezelServices kDimTime -int 300

# Enable locate.updatedb to run automatically
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist