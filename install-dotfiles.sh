#!/bin/sh
# Install all my dotfiles into my home directory

DOTFILESDIRREL=$(dirname $0)
cd $DOTFILESDIRREL
DOTFILESDIR=$(pwd -P)
SCRIPTNAME=$(basename $0)

[ $(uname -s) = "Darwin" ] && export OSX=1 && export UNIX=1
[ $(uname -s) = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1

for DOTFILE in *; do
	HOMEFILE="$HOME/.$DOTFILE"
	[ -d $DOTFILE ] && DOTFILE="$DOTFILE/"
	DIRFILE="$DOTFILESDIR/$DOTFILE"

	if echo $DOTFILE | grep -q 'Preferences.sublime-settings'
	then
		if [ $OSX ]
		then
			SUBLIME="$HOME/Library/Application Support/Sublime Text 2/Packages/User"
			ln -sfv "$DIRFILE" "$SUBLIME/$DOTFILE"
		elif [ $LINUX ]
		then
			SUBLIME="$HOME/.config/sublime-text-2/Packages/User"
			ln -sfv "$DIRFILE" "$SUBLIME/$DOTFILE"
		elif [ $WINDOWS ]
		then
			SUBLIME="$APPDATA/Sublime Text 2/Packages/User"
			cp -rv  "$DIRFILE" "$SUBLIME/$DOTFILE"
		fi
		continue
	fi

	echo $DOTFILE | grep -q '\.' && continue

	if [ $UNIX ]
	then
		if [ -L "$HOMEFILE" ] && ! [ -d $DOTFILE ]
		then
			ln -sfv "$DIRFILE" "$HOMEFILE"
		else
			rm -rv "$HOMEFILE"
			ln -sv "$DIRFILE" "$HOMEFILE"
		fi
	else
		cp -rv "$DIRFILE" "$HOMEFILE"
	fi
done
