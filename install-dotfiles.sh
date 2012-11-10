#!/bin/sh
# Install all my dotfiles into my home directory

DOTFILESDIRREL=$(dirname $0)
cd $DOTFILESDIRREL
DOTFILESDIR=$(pwd -P)
SCRIPTNAME=$(basename $0)

[ $(uname -s) = "Darwin" ] && export OSX=1 && export UNIX=1
[ $(uname -s) = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1

if [ $OSX ]
then
	SUBLIME="$HOME/Library/Application Support/Sublime Text 2/Packages/User"
elif [ $LINUX ]
then
	SUBLIME="$HOME/.config/sublime-text-2/Packages/User"
elif [ $WINDOWS ]
then
	SUBLIME="$APPDATA/Sublime Text 2/Packages/User"
fi

for DOTFILE in *; do
	HOMEFILE="$HOME/.$DOTFILE"
	[ -d $DOTFILE ] && DOTFILE="$DOTFILE/"
	DIRFILE="$DOTFILESDIR/$DOTFILE"

	echo $DOTFILE | grep -q '\.' && continue

	echo $DOTFILE | grep -q 'sublime' && HOMEFILE="$SUBLIME"

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
		echo cp -rv "$DIRFILE" "$HOMEFILE"
	fi
done
