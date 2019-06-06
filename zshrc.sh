# zplug fix implemented from https://github.com/zplug/zplug/issues/448.
unalias git &>/dev/null

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Clear packages
zplug clear

# Package list
zplug desyncr/auto-ls
zplug dracula/zsh, as:theme
zplug peterhurford/up.zsh
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-completions
zplug zsh-users/zsh-syntax-highlighting

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

# Configure history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY

# Make Homebrew safer
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# Set FZF command
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

# Aliases
alias ls='exa'
alias l='exa -l --git'

# Alias hub over git
eval "$(hub alias -s)"

# Initialize rbenv
eval "$(rbenv init -)"

# Initialize fuck
eval $(thefuck --alias)

# Add custom scripts to path
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.composer/vendor/bin"
