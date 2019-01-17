#!/bin/sh

##################################################
# usage
##################################################
function usage() {
  echo 'usage: ' $1 '[-r] [-d] [-u] [-h]

  -r reset to original theme with slack
  -d set to dark theme by relinking to existing files
  -u update the files from https://raw.githubusercontent.com/valiander/slackdark

  EXIT CODES:
  126 = this usage help screen
  125 = invalid options
  1 = basic error
  '
  exit 126
}

# Check that we have at least 1 argument
if [ $# -lt 1 ];
then
  usage $0
fi

file="/Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js"
filedark="${file}.darktheme"
filebackup="${file}.backup"

while getopts "rdhu" opt; do
  case $opt in
    r)
      reset=true
      ;;
    d)
      darken=true
      ;;
    u)
      update=true
      ;;
    h)
      usage $0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      return 125
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      return 125
      ;;
  esac
done

if [ ! -e "${filebackup}" ]; then
  \cp $file $filebackup
fi

if [ "$reset" = "true" ]; then
  # To start, always make sure your file is clean and not modified. Paste this into your command prompt:
  osascript -e 'quit app "slack"'
  if [ "$update" = "true" ]; then
    curl 'https://raw.githubusercontent.com/valiander/slackdark/master/reset' > $filebackup
  fi

  \cp $filebackup $file
elif [ "$darken" = "true" ]; then
  # This command will quit slack and overwrite the file needed to change your css entries.
  # This will also return your slack app back to normal, aside from the theme changes.
  # To set the dark theme, paste this into your command prompt:
  osascript -e 'quit app "slack"'
  if [ ! -e $filedark -o "$update" = "true" ]; then
    \cp $filebackup $filedark
    curl 'https://raw.githubusercontent.com/valiander/slackdark/master/darktheme' >> $filedark
  fi

  \cp $filedark $file

  # This is going to quit slack and append the changes to the end of the file.
  # Its important to quit and restart slack every time we change this file so that the changes take effect.
  # Last step is to paste this into a chat with yourself or slackbot, and click "switch sidebar theme"

  echo "type this into slack: #3b383b,#b8cbe6,#ffffff,#ffffff,#4A5664,#ffffff,#00f7ff,#3b383b"
fi

