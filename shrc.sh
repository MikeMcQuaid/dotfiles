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
  PATHSUB=":$PATH:"
  PATHSUB=${PATHSUB//:$1:/:}
  PATHSUB=${PATHSUB#:}
  PATHSUB=${PATHSUB%:}
  export PATH="$PATHSUB"
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
  command -v "$1" >/dev/null
}

add_to_path_start "/usr/local/bin"
add_to_path_start "/usr/local/sbin"

add_to_path_end "$HOME/.dotfiles/bin"
add_to_path_end "$HOME/.gem/ruby/2.6.0/bin"

# Setup Go development
export GOPATH="$HOME/.gopath"
add_to_path_end "$GOPATH/bin"

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
alias sha256="shasum -a 256"

# Command-specific stuff
if quiet_which brew
then
  export HOMEBREW_PREFIX="$(brew --prefix)"
  export HOMEBREW_REPOSITORY="$(brew --repo)"
  export HOMEBREW_AUTO_UPDATE_SECS=3600
  export HOMEBREW_BINTRAY_USER=mikemcquaid
  export HOMEBREW_DEVELOPER=1
  export HOMEBREW_UPDATE_REPORT_ONLY_INSTALLED=1
  export HOMEBREW_BUNDLE_BREW_SKIP="rakudo-star nss aws-iam-authenticator docker docker-machine awscli awssume imagemagick kubernetes-cli kubectl kubectl@1.14 kustomize@2.0 kustomize@3.1 container-diff"
  export HOMEBREW_BUNDLE_CASK_SKIP="zulu8 github/bootstrap/zulu8"
  export HOMEBREW_GIT_FILTER_TREE_ZERO=1
  export HOMEBREW_BOOTSNAP=1

  alias hbc='cd $HOMEBREW_REPOSITORY/Library/Taps/homebrew/homebrew-core'
fi

if quiet_which diff-so-fancy
then
  # shellcheck disable=SC2016
  export GIT_PAGER='diff-so-fancy | less -+$LESS -RX'
else
  # shellcheck disable=SC2016
  export GIT_PAGER='less -+$LESS -RX'
fi

if quiet_which exa
then
  alias ls="exa --classify --group --git"
elif [ "$MACOS" ]
then
  alias ls="ls -F"
else
  alias ls="ls -F --color=auto"
fi

if quiet_which bat
then
  export BAT_THEME="ansi"
  alias cat="bat"
fi

if quiet_which prettyping
then
  alias ping="prettyping --nolegend"
fi

if quiet_which htop
then
  alias top="sudo htop"
fi

if quiet_which ncdu
then
  alias du="ncdu --color dark -rr"
fi

# Configure environment
export CLICOLOR=1
export HEROKU_ORGANIZATION="github-enterprise"
export GITHUB_PROFILE_BOOTSTRAP=1

# OS-specific configuration
if [ "$MACOS" ]
then
  export GITHUB_USE_HOMEBREW_BINARIES=1
  export HOMEBREW_GITHUB_USE_HOMEBREW_BINARIES=1
  export GITHUB_NO_AUTO_BOOTSTRAP=1
  export GREP_OPTIONS="--color=auto"
  export VAGRANT_DEFAULT_PROVIDER="vmware_fusion"

  add_to_path_end "$HOMEBREW_PREFIX/opt/git/share/git-core/contrib/diff-highlight"
  add_to_path_end "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

  alias fork="/Applications/Fork.app/Contents/Resources/fork_cli"
  alias vmrun="/Applications/VMware Fusion.app/Contents/Public/vmrun"

  alias locate="mdfind -name"
  alias finder-hide="setfile -a V"

  # make no-argument find Just Work.
  find() {
    local arg
    local path_arg
    local dot_arg

    for arg
    do
      [[ $arg =~ "^-" ]] && break
      path_arg="$arg"
    done

    [ -z "$path_arg" ] && dot_arg="."

    command find $dot_arg "$@"
  }

  # Only run rbenv-nodenv-homebrew-sync if it's not already running
  pgrep -fq rbenv-nodenv-homebrew-sync || rbenv-nodenv-homebrew-sync
elif [ "$LINUX" ]
then
  quiet_which keychain && eval "$(keychain -q --eval --agents ssh id_rsa)"

  add_to_path_end "/data/github/shell/bin"

  alias su="/bin/su -"
  alias open="xdg-open"
elif [ "$WINDOWS" ]
then
  open() {
    # shellcheck disable=SC2145
    cmd /C"$@"
  }
fi

# Set up editor
if quiet_which code
then
  export EDITOR="code"
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
  [ "$TERMINALAPP" ] && command -v set_terminal_app_pwd >/dev/null \
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
  cat "$1" | jq .
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

# GitHub API shortcut
github-api-curl() {
  noglob curl -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/$1"
}
