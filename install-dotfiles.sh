#!/bin/sh
# Install all my dotfiles into my home directory

DOTFILESDIRREL=$(dirname $0)
cd $DOTFILESDIRREL
DOTFILESDIR=$(pwd -P)
SCRIPTNAME=$(basename $0)
for DOTFILE in *; do
	[ "$DOTFILE" = "$SCRIPTNAME" ] && continue
	HOMEFILE="$HOME/.$DOTFILE"
	[ -d $DOTFILE ] && DOTFILE="$DOTFILE/"
	DIRFILE="$DOTFILESDIR/$DOTFILE"
	# Matches Cygwin or MINGW
	if ! uname -s | grep -q "_NT-"
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
