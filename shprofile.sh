[ -s ~/.lastpwd ] && [ "$PWD" = "$HOME" ] && \
	builtin cd `cat ~/.lastpwd` 2>/dev/null
