# load shared shell configuration
source ~/.shprofile

# Enable completions
autoload -U compinit && compinit

if which brew &>/dev/null
then
  [ -w "$BREW_PREFIX/bin/brew" ] && \
    [ ! -f "$BREW_PREFIX/share/zsh/site-functions/_brew" ] && \
    mkdir -p "$BREW_PREFIX/share/zsh/site-functions" &>/dev/null && \
    ln -s "$BREW_PREFIX/Library/Contributions/brew_zsh_completion.zsh" \
          "$BREW_PREFIX/share/zsh/site-functions/_brew"
  export FPATH="$BREW_PREFIX/share/zsh/site-functions:$FPATH"
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

svn_branch() {
  [ -d .svn ] || return
  SVN_INFO=$(svn info 2>/dev/null) || return
  SVN_BRANCH=$(echo "$SVN_INFO" | grep URL: | grep -oe '\(trunk\|branches/[^/]\+\|tags/[^/]\+\)')
  [ -n "$SVN_BRANCH" ] || return
  # Display tags intentionally so we don't write to them by mistake
  echo "(${SVN_BRANCH#branches/}) "
}

if [ "$USER" = "root" ]
then
  PROMPT='%{$fg_bold[magenta]%}%m %{$fg_bold[blue]%}# %b%f'
elif [ -n "${SSH_CONNECTION}" ]
then
  PROMPT='%{$fg_bold[cyan]%}%m %{$fg_bold[blue]%}# %b%f'
else
  PROMPT='%{$fg_bold[green]%}%m %{$fg_bold[blue]%}# %b%f'
fi
RPROMPT='%{$fg_bold[red]%}$(git_branch)%{$fg_bold[yellow]%}$(svn_branch)%b[%{$fg_bold[blue]%}%~%b%f]'

# more OS X/Bash-like word jumps
export WORDCHARS=''

# use emacs bindings even with vim as EDITOR
bindkey -e

# fix backspace on Debian
[ $LINUX ] && bindkey "^?" backward-delete-char

# fix delete key on OSX
[ $OSX ] && bindkey "\e[3~" delete-char

# alternate mappings for Ctrl-U/V to search the history
bindkey "^u" history-beginning-search-backward
bindkey "^v" history-beginning-search-forward
