# run bash_profile if this is not a login shell
if [ "$0" != "-bash" ]
then
  source ~/.bash_profile
fi

# load shared shell configuration
source ~/.shrc

# History
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoredups
export PROMPT_COMMAND='history -a'
export HISTIGNORE="&:ls:[bf]g:exit"
