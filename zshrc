# load shared shell configuration
source ~/.shrc

# Enable advanced completion
autoload -U compinit && compinit

# Style ZSH output
zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case insensitive globbing
setopt no_case_glob

# Change to directory by just entering name
setopt auto_cd

# Don't show duplicate history entires
setopt hist_find_no_dups

# Remove unnecessary blanks from history
setopt hist_reduce_blanks

# Share history between instances
setopt share_history

# Don't hang up background jobs
setopt no_hup

# Expand parameters, commands and aritmatic in prompts
setopt prompt_subst

# Colorful prompt with git branc
autoload -U colors && colors

git_branch() {
	BRANCH_REFS=$(git symbolic-ref HEAD 2>/dev/null) || return
	echo "(${BRANCH_REFS#refs/heads/}) "
}

if [[ $(whoami) == "root" ]]
then
	PROMPT='%{$fg_bold[magenta]%}%m %{$fg_bold[blue]%}# %b%f'
else
	PROMPT='%{$fg_bold[green]%}%m %{$fg_bold[blue]%}# %b%f'
fi
RPROMPT='%{$fg_bold[red]%}$(git_branch)%b[%{$fg_bold[blue]%}%~%b%f]'

# History
export HISTSIZE=2000
export HISTFILE=~/.zsh_history
export SAVEHIST=$HISTSIZE

# use emacs bindings even with vim as EDITOR
bindkey -e

# allow the use of the Delete/Insert keys
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert

# alternate mappings for "page up" and "page down" to search the history
bindkey "\e[5~" history-beginning-search-backward
bindkey "\e[6~" history-beginning-search-forward

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
