# check if this is a login shell
[ "$0" = "-bash" ] && export LOGIN_BASH=1

# run bash_profile if this is not a login shell
[ -z "$LOGIN_BASH" ] && source ~/.bash_profile

# load shared shell configuration
source ~/.shrc

# History
export HISTFILE="$HOME/.bash_history"
export HISTCONTROL="ignoredups"
export PROMPT_COMMAND="history -a"
export HISTIGNORE="&:ls:[bf]g:exit"

# More colours with grc
# shellcheck disable=SC1090
GRC_SH="$HOMEBREW_PREFIX/etc/grc.sh"
[ -f "$GRC_SH" ] && source "$GRC_SH"

# to avoid non-zero exit code
true
