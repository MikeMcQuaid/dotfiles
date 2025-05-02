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

# Node version manager (git install): https://github.com/nvm-sh/nvm#git-install
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=/System/Library/Frameworks/Ruby.framework/Versions/2.6/usr/bin:$PATH
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
SSH_AUTH_SOCK=/var/folders/kz/mzk3jkrj3w37475q29gp416h0000gn/T//ssh-gi6D53Fb2biU/agent.43206; export SSH_AUTH_SOCK;
SSH_AGENT_PID=43207; export SSH_AGENT_PID;
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


#DOCKER
alias docker='podman'

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/pdss/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export GPG_TTY=$(tty)
