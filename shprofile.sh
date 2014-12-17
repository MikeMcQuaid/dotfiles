[ "$TERM_PROGRAM" = "Apple_Terminal" ] && export TERMINALAPP=1

if [ $TERMINALAPP ]
then
  set_terminal_app_pwd() {
    # Tell Terminal.app about each directory change.
    printf '\e]7;%s\a' "$(echo "file://$HOST$PWD" | sed -e 's/ /%20/g')"
  }
fi

[ -s ~/.lastpwd ] && [ "$PWD" = "$HOME" ] && \
  builtin cd `cat ~/.lastpwd` 2>/dev/null

[ $TERMINALAPP ] && set_terminal_app_pwd
