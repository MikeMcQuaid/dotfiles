# load shared shell configuration
[ -f ~/.shrc ] && . ~/.shrc

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
[ -f /etc/profile.d/bash-completion ] && . /etc/profile.d/bash-completion

# Colorful prompt
if [ $USER = "root" ]
then
	PS1='\[\033[01;35m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
elif [ -n "${SSH_CONNECTION}" ]
then
	PS1='\[\033[01;36m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
else
	PS1='\[\033[01;32m\]\h\[\033[01;34m\] \W #\[\033[00m\] '
fi

# History
HISTCONTROL=ignoredups
PROMPT_COMMAND='history -a'
HISTIGNORE="&:ls:[bf]g:exit"
export HISTCONTROL
export PROMPT_COMMAND
export HISTIGNORE

# allow the use of the Delete/Insert keys
bind '"\e[3~" delete-char'
bind '"\e[2~" quoted-insert'

# alternate mappings for Ctrl-U/V to search the history
bind '"^u" history-search-backward'
bind '"^v" history-search-forward'

# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
bind '"\e[1;5C" forward-word'
bind '"\e[1;5D" backward-word'
bind '"\e[5C" forward-word'
bind '"\e[5D" backward-word'
bind '"\e\e[C" forward-word'
bind '"\e\e[D" backward-word'
