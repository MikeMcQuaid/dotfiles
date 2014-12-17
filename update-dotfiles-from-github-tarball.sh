#!/bin/sh
# Update dotfiles from GitHub tarball

# Exit on any command failures
set -e

# Extract GitHub username from gitconfig-user
GITHUB_USERNAME=$(grep "user =" gitconfig-user | sed -e 's/.*user = //')

DOTFILESDIRREL=$(dirname $0)
cd $DOTFILESDIRREL
if [ -e .git ]
then
  echo "This dotfiles directory was checked out from Git so I won't update it."
  echo "If you want it updated from a tarball anyway, please delete .git first."
  exit 1
fi

OUTFILE="dotfiles.tar.gz"
which curl &>/dev/null && DOWNLOAD="curl --progress-bar --location --output $OUTFILE"
[ -z "$DOWNLOAD" ] && which wget &>/dev/null && DOWNLOAD="wget --output-document=$OUTFILE"
[ -z "$DOWNLOAD" ] && echo "Could not find curl or wget" && exit 1

$DOWNLOAD https://nodeload.github.com/$GITHUB_USERNAME/dotfiles/tar.gz/master
tar --strip-components=1 -z -x -v -f $OUTFILE
rm $OUTFILE
