#!/bin/bash
export EDITOR=nano
export VISUAL="$EDITOR"

# Homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# The fuck
export PATH="$PATH:~/.local/bin/"
eval $(thefuck --alias)

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# ngrok
if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi
# ngrok end