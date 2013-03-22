#!/bin/sh
# Install all dotfiles into the home directory

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

	echo $DOTFILE | egrep -q '(dotfiles|\.txt|\.md)' && continue

	# Don't install gitconfig-user unless you're also called Mike.
	echo $DOTFILE | grep -q 'gitconfig-user' \
		&& echo $USER | grep -vq 'mike' && continue

	echo $DOTFILE | grep -q 'sublime' && HOMEFILE="$SUBLIME" \
		&& mkdir -p "$HOMEFILE"

	echo $DOTFILE | grep -q '\.sh' \
		&& HOMEFILE="$HOME/.$(echo $DOTFILE | sed -e 's/\.sh//')"

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
