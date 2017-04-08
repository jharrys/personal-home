#!/bin/sh

###########################################################
# Johnnie Harris
# 2017-04-07
#
# To use, source this file within your script
#
# Setup my colors
###########################################################
screen_clear='tput clear'                 # clear screen
colored_fg_red='tput setaf 1'             # set foreground colors to ANSI color code
colored_fg_green='tput setaf 2'
colored_fg_yellow='tput setaf 3'
colored_fg_blue='tput setaf 4'
colored_fg_magenta='tput setaf 5'
colored_fg_cyan='tput setaf 6'
colored_fg_white='tput setaf 7'
colored_bg_red='tput setab 1'             # set background colors to ANSI color code
colored_bg_green='tput setab 2'
colored_bg_yellow='tput setab 3'
colored_bg_blue='tput setab 4'
colored_bg_magenta='tput setab 5'
colored_bg_cyan='tput setab 6'
colored_bg_white='tput setab 7'
type_bold='tput bold'                     # set bold on
type_dim='tput dim'                       # half bright mode
type_ul_start='tput smul'                 # begin underline mode
type_ul_stop='tput rmul'                  # exit underline mode
type_rev='tput rev'                       # reverse mode on
type_reset='tput sgr0'                    # clear all attributes
cursor_hide='tput civis'                  # hide cursor
cursor_normal='tput cnorm'                # normal cursor
