#!/bin/sh
# shellcheck disable=SC2155

# Colourful manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Set to avoid `env` output from changing console colour
export LESS_TERMEND=$'\E[0m'

# Print field by number
field() {
  ruby -ane "puts \$F[$1]"
}

# Setup paths
remove_from_path() {
  [ -d "$1" ] || return
  # Doesn't work for first item in the PATH but I don't care.
  export PATH=${PATH//:$1/}
}

add_to_path_start() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

add_to_path_end() {
  [ -d "$1" ] || return
  remove_from_path "$1"
  export PATH="$PATH:$1"
}

force_add_to_path_start() {
  remove_from_path "$1"
  export PATH="$1:$PATH"
}

quiet_which() {
  which "$1" &>/dev/null
}

add_to_path_end "/sbin"
add_to_path_end "$HOME/Documents/Scripts"
add_to_path_end "$HOME/Documents/Scripts/thirdparty"
add_to_path_end "$HOME/Scripts"
add_to_path_end "$HOME/Scripts/thirdparty"
add_to_path_end "$HOME/Library/Python/2.7/bin"
add_to_path_end "$HOME/.gem/ruby/2.3.0/bin"
add_to_path_end "$HOME/.gem/ruby/2.0.0/bin"
add_to_path_end "$HOME/.gem/ruby/1.8/bin"
add_to_path_end "$HOME/.rbenv/bin"
add_to_path_end "$HOME/.cabal/bin"
add_to_path_end "/Applications/Fork.app/Contents/Resources"
add_to_path_end "/Applications/TextMate.app/Contents/Resources"
add_to_path_end "/data/github/shell/bin"
add_to_path_start "/usr/local/bin"
add_to_path_start "/usr/local/sbin"
add_to_path_start "$HOME/Homebrew/bin"
add_to_path_start "$HOME/Homebrew/sbin"

# Run rbenv if it exists
quiet_which rbenv && add_to_path_start "$(rbenv root)/shims"

# Aliases
alias mkdir="mkdir -vp"
alias df="df -H"
alias rm="rm -iv"
alias mv="mv -iv"
alias zmv="noglob zmv -vW"
alias cp="cp -irv"
alias du="du -sh"
alias make="nice make"
alias less="less --ignore-case --raw-control-chars"
alias rsync="rsync --partial --progress --human-readable --compress"
alias rake="noglob rake"
alias rg="rg --colors 'match:style:nobold' --colors 'path:style:nobold'"
alias be="noglob bundle exec"
alias gist="gist --open --copy"
alias svn="svn-git.sh"
alias sha256="shasum -a 256"

# Platform-specific stuff
if quiet_which brew
then
  export BINTRAY_USER="$(git config bintray.username)"
  export HOMEBREW_PREFIX="$(brew --prefix)"
  export HOMEBREW_REPOSITORY="$(brew --repo)"
  export HOMEBREW_DEVELOPER=1
  export HOMEBREW_ENV_FILTERING=1

  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
  if [ "$USER" = "brewadmin" ]
  then
    export HOMEBREW_CASK_OPTS="$HOMEBREW_CASK_OPTS --binarydir=$HOMEBREW_PREFIX/bin"
  fi

  alias hbc='cd $HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core'

  # Output whether the dependencies for a Homebrew package are bottled.
  brew_bottled_deps() {
    for DEP in "$@"; do
      echo "$DEP deps:"
      brew deps "$DEP" | xargs brew info | grep stable
      [ "$#" -ne 1 ] && echo
    done
  }

  # Output the most popular unbottled Homebrew packages
  brew_popular_unbottled() {
    brew deps --all |
      awk '{ gsub(":? ", "\n") } 1' |
      sort |
      uniq -c |
      sort |
      tail -n 500 |
      awk '{print $2}' |
      xargs brew info |
      grep stable |
      grep -v bottled
  }
fi

if [ "$MACOS" ]
then
  export GREP_OPTIONS="--color=auto"
  export CLICOLOR="1"
  export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"
  export RESQUE_REDIS_URL="redis://localhost:6379"
  export HEROKU_ORGANIZATION="github-enterprise"

  if quiet_which diff-highlight
  then
    # shellcheck disable=SC2016
    export GIT_PAGER='diff-highlight | less -+$LESS -RX'
  else
    # shellcheck disable=SC2016
    export GIT_PAGER='less -+$LESS -RX'
  fi

  if quiet_which exa
  then
    alias ls="exa -F"
  else
    alias ls="ls -F"
  fi

  add_to_path_end /Applications/Xcode.app/Contents/Developer/usr/bin
  add_to_path_end /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
  add_to_path_end "$HOMEBREW_PREFIX/opt/git/share/git-core/contrib/diff-highlight"

  alias ql="qlmanage -p 1>/dev/null"
  alias locate="mdfind -name"
  alias cpwd="pwd | tr -d '\n' | pbcopy"
  alias finder-hide="setfile -a V"
  alias fork="fork_cli"
  alias github="fork"

  # Old default Curl is broken for Git on Leopard.
  [ "$OSTYPE" = "darwin9.0" ] && export GIT_SSL_NO_VERIFY=1
elif [ "$LINUX" ]
then
  quiet_which keychain && eval "$(keychain -q --eval --agents ssh id_rsa)"

  alias su="/bin/su -"
  alias ls="ls -F --color=auto"
  alias open="xdg-open"
elif [ "$WINDOWS" ]
then
  quiet_which plink && alias ssh='plink -l $(git config shell.username)'

  alias ls="ls -F --color=auto"

  open() {
    # shellcheck disable=SC2145
    cmd /C"$@"
  }
fi

# Set up editor
if [ -n "${SSH_CONNECTION}" ] && quiet_which rmate
then
  export EDITOR="rmate"
  export GIT_EDITOR="$EDITOR -w"
  export SVN_EDITOR=$GIT_EDITOR
elif quiet_which mate
then
  export EDITOR="mate"
  export GIT_EDITOR="$EDITOR -w"
  export SVN_EDITOR="$GIT_EDITOR"
elif quiet_which vim
then
  export EDITOR="vim"
elif quiet_which vi
then
  export EDITOR="vi"
fi

# Run dircolors if it exists
quiet_which dircolors && eval "$(dircolors -b)"

# More colours with grc
# shellcheck disable=SC1090
[ -f "$HOMEBREW_PREFIX/etc/grc.bashrc" ] && source "$HOMEBREW_PREFIX/etc/grc.bashrc"

# Save directory changes
cd() {
  builtin cd "$@" || return
  [ "$TERMINALAPP" ] && which set_terminal_app_pwd &>/dev/null \
    && set_terminal_app_pwd
  pwd > "$HOME/.lastpwd"
  ls
}

# Use ruby-prof to generate a call stack
ruby-call-stack() {
  ruby-prof --printer=call_stack --file=call_stack.html -- "$@"
}

# Pretty-print JSON files
json() {
  [ -n "$1" ] || return
  jsonlint "$1" | jq .
}

# Pretty-print Homebrew install receipts
receipt() {
  [ -n "$1" ] || return
  json "$HOMEBREW_PREFIX/opt/$1/INSTALL_RECEIPT.json"
}

# Move files to the Trash folder
trash() {
  mv "$@" "$HOME/.Trash/"
}

# Look in ./bin but do it last to avoid weird `which` results.
force_add_to_path_start "bin"
