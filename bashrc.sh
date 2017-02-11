# load shared shell configuration
if [ "$(uname -s)" = "Darwin" ] || grep -q "Microsoft" /proc/version 2>/dev/null
then
  source ~/.bash_profile
fi
source ~/.shrc

# History
export HISTFILE=~/.bash_history
export HISTCONTROL=ignoredups
export PROMPT_COMMAND='history -a'
export HISTIGNORE="&:ls:[bf]g:exit"
