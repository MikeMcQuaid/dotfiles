# load shared shell configuration
source ~/.shrc

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable history appending instead of overwriting.
shopt -s histappend

# Save multiline commands
shopt -s cmdhist

# Correct minor directory changing spelling mistakes
shopt -s cdspell

# Bash completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion

# Keypresses
export INPUTRC=~/.inputrc

# Colorful prompt
if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;35m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
fi

# History
export HISTCONTROL=ignoredups
export PROMPT_COMMAND='history -a'
export HISTIGNORE="&:ls:[bf]g:exit"

# allow the use of the Home/End keys
bind '"\e[1~" beginning-of-line'
bind '"\e[4~" end-of-line'

# allow the use of the Delete/Insert keys
bind '"\e[3~" delete-char'
bind '"\e[2~" quoted-insert'

# alternate mappings for "page up" and "page down" to search the history
bind '"\e[5~" history-search-backward'
bind '"\e[6~" history-search-forward'

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
bind '"\e[1;5C" forward-word'
bind '"\e[1;5D" backward-word'
bind '"\e[5C" forward-word'
bind '"\e[5D" backward-word'
bind '"\e\e[C" forward-word'
bind '"\e\e[D" backward-word'
