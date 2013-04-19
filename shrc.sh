# 077 would be more secure, but 022 is more useful.
umask 022

# Save more history
export HISTSIZE=100000
export SAVEHIST=100000

# OS variables
[ $(uname -s) = "Darwin" ] && export OSX=1 && export UNIX=1
[ $(uname -s) = "Linux" ] && export LINUX=1 && export UNIX=1
uname -s | grep -q "_NT-" && export WINDOWS=1

# Fix systems missing $USER
[ -z "$USER" ] && export USER=$(whoami)

# Colourful manpages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Set to avoid `env` output from changing console colour
export LESS_TERMEND=$'\E[0m'

# Count CPUs for Make jobs
if [ $OSX ]
then
	export CPUCOUNT=$(sysctl -n hw.ncpu)
elif [ $LINUX ]
then
	export CPUCOUNT=$(getconf _NPROCESSORS_ONLN)
else
	export CPUCOUNT="1"
fi

if [ "$CPUCOUNT" -gt 1 ]
then
	export MAKEFLAGS="-j$CPUCOUNT"
fi

# Load GitHub token
[ -s ~/.github_password ] && export GITHUB_PASSWORD=$(cat ~/.github_password)

# Print field by number
field() {
	awk {print\ \$$1}
}

# Setup paths
remove_from_path() {
	[ -d $1 ] || return
	# Doesn't work for first item in the PATH but don't care.
	export PATH=$(echo $PATH | sed -e "s|:$1||") 2>/dev/null
}

add_to_path_start() {
	[ -d $1 ] || return
	remove_from_path "$1"
	export PATH="$1:$PATH"
}

add_to_path() {
	[ -d "$1" ] || return
	remove_from_path "$1"
	export PATH="$PATH:$1"
}

force_add_to_path() {
	remove_from_path "$1"
	export PATH="$PATH:$1"
}

add_to_path_start "$HOME/.homebrew/bin"
add_to_path_start "$HOME/.homebrew/sbin"
add_to_path_start "/usr/local/bin"
add_to_path_start "/usr/local/sbin"
add_to_path "$HOME/Documents/Scripts"
add_to_path "$HOME/Scripts"
add_to_path "$HOME/Library/Python/2.7/bin"
add_to_path "$HOME/.gem/ruby/1.8/bin"
add_to_path "$HOME/.rbenv/bin"
add_to_path "$HOME/Applications/Sublime Text 2"
add_to_path "/c/Program Files/Sublime Text 2"
force_add_to_path ".bundle/bin"

quiet_which() {
	which $1 1>/dev/null 2>/dev/null
}

quiet_which ack-grep && alias ack=ack-grep
export DIFF=diff
quiet_which colordiff && export DIFF=colordiff && alias diff=colordiff

# Aliases
alias mkdir="mkdir -vp"
alias df="df -H"
alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -irv"
alias du="du -sh"
alias make="nice make"
alias less="less --ignore-case --raw-control-chars"
alias rsync="rsync --partial --progress --human-readable --compress"
alias rake="noglob rake"
alias be="noglob bundle exec"

export HOMEBREW_SOURCEFORGE_USERNAME="$(git config sourceforge.username)"
alias upbrew="scp-to-http.sh $HOMEBREW_SOURCEFORGE_USERNAME,machomebrew frs.sourceforge.net /home/frs/project/m/ma/machomebrew/Bottles /Library/Caches/Homebrew/"

alias svn="svn-git.sh"

# Platform-specific stuff
if quiet_which brew
then
	export BREW_PREFIX=$(brew --prefix)
	export ANDROID_SDK_ROOT=$BREW_PREFIX/opt/android-sdk
	export ANDROID_HOME=$ANDROID_SDK_ROOT
	export HOMEBREW_DEVELOPER=1
	alias brew="nice brew"
	alias bpi="brew pull --install"
fi

if [ $OSX ]
then
	export GREP_OPTIONS="--color=auto"
	export CLICOLOR=1

	add_to_path /Applications/Xcode.app/Contents/Developer/usr/bin
	add_to_path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin

	alias ls="ls -F"
	alias ql="qlmanage -p 1>/dev/null"
	alias locate="mdfind -name"
	alias cpwd="pwd | tr -d '\n' | pbcopy"
	alias vmware-shrink="sudo /Library/Application\ Support/VMware\ Tools/vmware-tools-cli disk shrinkonly"
	alias remove-open-with-duplicates="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user"

	# Old default Curl is broken for Git on Leopard.
	[ "$OSTYPE" = "darwin9.0" ] && export GIT_SSL_NO_VERIFY=1
elif [ $LINUX ]
then
	quiet_which keychain && eval `keychain -q --eval --agents ssh id_rsa`

	alias su="/bin/su -"
	alias ls="ls -F --color=auto"
	alias open="xdg-open"
	alias agdu="sudo apt-get dist-upgrade"
elif [ $WINDOWS ]
then
	quiet_which plink && alias ssh="plink -l $(git config shell.username)"

	alias ls="ls -F --color=auto"

	open() {
		cmd /C"$@"
	}
fi

# Set up editor
if [ -n "${SSH_CONNECTION}" ] && quiet_which rmate
then
	export EDITOR="rmate"
	export GIT_EDITOR="$EDITOR -w"
	export SVN_EDITOR=$GIT_EDITOR
elif quiet_which mate
then
	export EDITOR="mate"
	export GIT_EDITOR="$EDITOR -w"
	export SVN_EDITOR="$GIT_EDITOR"
elif quiet_which subl || quiet_which sublime_text
then
	quiet_which subl && export EDITOR="subl"
	quiet_which sublime_text && export EDITOR="sublime_text" \
		&& alias subl="sublime_text"

	export GIT_EDITOR="$EDITOR -w"
	export SVN_EDITOR="$GIT_EDITOR"
elif quiet_which vim
then
	export EDITOR="vim"
elif quiet_which vi
then
	export EDITOR="vi"
fi

# Run dircolors if it exists
quiet_which dircolors && eval $(dircolors -b)

# Run rbenv if it exists
if quiet_which rbenv
then
	# Don't duplicate my PATH
	remove_from_path "$(rbenv root)/shims"
	eval "$(rbenv init -)"
fi

# Aliases using variables
alias ed="$EDITOR"

# Save directory changes
cd() {
	builtin cd "$@" || return
	[ $TERMINALAPP ] && set_terminal_app_pwd
	pwd > ~/.lastpwd
	ls
}

# Provide quick access to Rails dump database
dump() {
	RAILS_DEVELOPMENT_DATABASE=dump $@
}

# Remove multiple Git remote branches at once
git-remove-remote-branches() {
	REMOTE="$1"
	for BRANCH in "$@"
	do
		[ "$BRANCH" = "$REMOTE" ] && continue
		git push "$REMOTE" ":$BRANCH"
	done
}
alias grrb="git-remove-remote-branches"
