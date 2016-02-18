#!/bin/sh 

NAMEOFMYGITSITES_DIRECTORY="mygits"
FULLPATH_TOMYGITSITESDIR="/Users/john/Sites/${NAMEOFMYGITSITES_DIRECTORY}"
GIT_EXECUTABLE="/usr/local/git/bin/git"

###########################################################################
## Function to set HTML Header
##
## param: $1 is title
## param: $2 is h1
##
function set_header() {
	## Header (Content-type always followed by a blank line)
	echo "Content-type: text/html"
	echo
	echo "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">"
	echo "<html>"
	echo "<head>"
	echo "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
	echo "<title>$1</title>"
	echo "</head>"
	echo "<body>"
	echo "<h1>$2</h1>"
}

###########################################################################
## Function to set HTML Footer and Close tags
##
function set_footer_close() {
	echo "</body>"
	echo "</html>"
}

###########################################################################
## Function to set row and columns
##
## param: $1 is the text for column 1
## param: $2 is the text for column 2
## param: $n is the text for column n
## param: $someN may contain the string "hilight-this-row-color" - you specify which "color", and the row will be hilighted that color
##	  the argument containing this text will not show up as a column
##
function set_row() {
	local row="<tr"
	local content=""
	local alreadylit

	for passed_in in "$@"
	do
		if [ "${passed_in%-*}" = "hilight-this-row" ]; then
			if [ ! $alreadylit ]; then
				row="${row} style=\"background-color : ${passed_in##*-}\""
				alreadylit=true
			fi
		else
			content="${content}\n<td>\n${passed_in}\n</td>"
		fi
	done
	row="${row}>\n${content}\n</tr>"
	echo $row
}

###########################################################################
## Main
set_header "My Git Repositories on Ziggyx.local" "John's Git Repositories on Ziggyx.local"

## HTML Body

## Create a table for this info
echo "<table border=\"1\">"
echo "<tr>"
echo "<th style=\"width : 5%\"><b>Git Repository</b></th>"
echo "<th style=\"width : 25%\"><b>Description</b></th>"
echo "<th style=\"width : 18%\"><b>Status</b></th>"
echo "<th style=\"width : 12%\"><b>Stash</b></th>"
echo "<th style=\"width : 25%\"><b>Last Log</b></th>"
echo "<th style=\"width : 15%\"><b>Remotes</b></th>"
echo "</tr>"

OLDIFS=$IFS
export IFS=$'\t\n'
for _directory in $(
	IFS=$'\t\n'
	for _a_possible_directory in $( locate "/.git/" )
	do
		echo ${_a_possible_directory%/\.git*}
	done |uniq )
do
	NAME=${_directory##*/}

	if [ ! -d ${FULLPATH_TOMYGITSITESDIR}/${NAME} ]; then
		# Create the new symlink
		ln -s \"${_directory}\" \"${FULLPATH_TOMYGITSITESDIR}/${NAME}\"
		if [ $? -gt 0 ]; then
			LINKSTRING="$LINKSTRING<br>ln -s \"${_directory}\" \"${FULLPATH_TOMYGITSITESDIR}/${NAME}\""
		fi
		set_row "${NAME}" "not symlinked" "not symlinked" "not symlinked" "hilight-this-row-red"
		continue
	fi

	FULLYRESOLVEDPATH="${FULLPATH_TOMYGITSITESDIR}/${NAME}"

	# Column:Git Repo
	RELEASE=$(
		cd $FULLYRESOLVEDPATH
		${GIT_EXECUTABLE} tag --contains HEAD
	)
	if [ $RELEASE ]; then
		COLUMN_REPO="<a href=\"/~john/${NAMEOFMYGITSITES_DIRECTORY}/${NAME}\">${NAME}</a><br>($RELEASE)"
		COLUMNHILIGHT="hilight-this-row-lightgreen"
	else
		COLUMN_REPO="<a href=\"/~john/${NAMEOFMYGITSITES_DIRECTORY}/${NAME}\">${NAME}</a>"
	fi

	# Column:Last Log
	COLUMN_LAST=$( 
		cd $FULLYRESOLVEDPATH 
		${GIT_EXECUTABLE} branch -v | textutil -convert html -excludedelements "(html,head,body,xml,p,font,span)" -stdout -stdin
	)
	COLUMN_LAST=$(
		echo $COLUMN_LAST | sed 's!\*.*!<b>&</b>!g'
	)
	# Column:Status
	COLUMN_STATUS=$(
		cd $FULLYRESOLVEDPATH
		${GIT_EXECUTABLE} status -s | textutil -convert html -excludedelements "(html,head,body,xml,p,font,span)" -stdout -stdin 2>/dev/null
	)
	if [ "$COLUMN_STATUS" != "" ]; then
		COLUMNHILIGHT="hilight-this-row-yellow"
	fi

	# Column:Description
	COLUMN_DESCRIPTION=$(
		textutil -convert html -excludedelements "(html,head,body,xml,p,font,span)" -stdout ${FULLYRESOLVEDPATH}/.git/description
	)
	
	# Column:Remotes
	COLUMN_REMOTES=$(
		cd $FULLYRESOLVEDPATH
		${GIT_EXECUTABLE} remote -v | textutil -convert html -excludedelements "(html,head,body,xml,p,font,span)" -stdout -stdin 2>/dev/null
	)

	# Column:Stash
	COLUMN_STASH=$(
		cd $FULLYRESOLVEDPATH
		${GIT_EXECUTABLE} stash list | textutil -convert html -excludedelements "(html,head,body,xml,p,font,span)" -stdout -stdin 2>/dev/null
	)

	set_row "$COLUMN_REPO" "$COLUMN_DESCRIPTION" "$COLUMN_STATUS" "$COLUMN_STASH" "$COLUMN_LAST" "$COLUMN_REMOTES" $COLUMNHILIGHT

	# Reset vars just in case
	COLUMNHILIGHT=""
	COLUMN_STATUS=""
done

## Close table
echo "</table>"
export IFS=$OLDIFS

if [ "$LINKSTRING" != "" ]; then
	echo "<p>"
	echo "<hr>"
	echo "Until I figure out how to ln as me (trying to fine alternatives other than running suexec), you'll need to use this:"
	echo "<pre>$LINKSTRING</pre>"
	echo "</p>"
fi

set_footer_close
