# 077 would be more secure, but 022 is more useful.
umask 022

# Save more history
export HISTSIZE="100000"
export SAVEHIST="100000"

# OS variables
[ "$(uname -s)" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "$(uname -s)" = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1
[ "$LINUX" ] && grep -qEi "(Microsoft|WSL)" /proc/version && export WSL=1

# Fix systems missing $USER
[ -z "$USER" ] && export USER="$(whoami)"

# Count CPUs for Make jobs
if [ $MACOS ]; then
  export CPUCOUNT="$(sysctl -n hw.ncpu)"
elif [ $LINUX ]; then
  export CPUCOUNT="$(getconf _NPROCESSORS_ONLN)"
else
  export CPUCOUNT=1
fi

if [ "$CPUCOUNT" -gt 1 ]; then
  export MAKEFLAGS="-j$CPUCOUNT"
  export BUNDLE_JOBS="$CPUCOUNT"
fi

# Setup Homebrew
PATH="/home/linuxbrew/.linuxbrew/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"
if which brew &>/dev/null; then
  eval "$(brew shellenv)"
fi

# Enable Terminal.app folder icons
[ "$TERM_PROGRAM" = "Apple_Terminal" ] && export TERMINALAPP=1
if [ $TERMINALAPP ]; then
  set_terminal_app_pwd() {
    # Tell Terminal.app about each directory change.
    printf '\e]7;%s\a' "$(echo "file://$HOST$PWD" | sed -e 's/ /%20/g')"
  }
fi
[ -s ~/.lastpwd ] && [ "$PWD" = "$HOME" ] &&
  builtin cd "$(cat ~/.lastpwd)" 2>/dev/null
[ $TERMINALAPP ] && set_terminal_app_pwd

SHPROFILE_LOADED=1
