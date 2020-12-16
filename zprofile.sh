# load shared shell configuration
source ~/.shprofile

# Enable completions
autoload -U compinit && compinit

if which brew &>/dev/null
then
  [ -w "$HOMEBREW_PREFIX/bin/brew" ] && \
    [ ! -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew" ] && \
    mkdir -p "$HOMEBREW_PREFIX/share/zsh/site-functions" &>/dev/null && \
    ln -s "$HOMEBREW_PREFIX/Library/Contributions/brew_zsh_completion.zsh" \
          "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew"
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

# Enable regex moving
autoload -U zmv

# Style ZSH output
zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case insensitive globbing
setopt no_case_glob

# Expand parameters, commands and aritmatic in prompts
setopt prompt_subst

# Colorful prompt with Git and Subversion branch
autoload -U colors && colors

git_branch() {
  GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  [ -n "$GIT_BRANCH" ] && echo "($GIT_BRANCH) "
}

if [ "$USER" = "root" ]
then
  export PROMPT='%{$fg_bold[magenta]%}%m %{$fg_bold[blue]%}# %b%f'
elif [ -n "${SSH_CONNECTION}" ]
then
  export PROMPT='%{$fg_bold[cyan]%}%m %{$fg_bold[blue]%}# %b%f'
else
  export PROMPT='%{$fg_bold[green]%}%m %{$fg_bold[blue]%}# %b%f'
fi
export RPROMPT='%{$fg_bold[red]%}$(git_branch)%b[%{$fg_bold[blue]%}%~%b%f]'

# more macOS/Bash-like word jumps
export WORDCHARS=""
