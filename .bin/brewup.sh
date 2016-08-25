#!/bin/bash

# used to upgrade homebrew and clean it up
# note that this will not upgrade cask

# this is used in the following places:
# 1) some aliases
# 2) ControlPlane (to automatically run upgrades on a daily basis)

brew=/usr/local/bin/brew
logger=/usr/bin/logger

$brew update 2>&1  | $logger -t brewup.update
$brew upgrade 2>&1 | $logger -t brewup.upgrade
$brew cleanup 2>&1 | $logger -t brewup.cleanup
