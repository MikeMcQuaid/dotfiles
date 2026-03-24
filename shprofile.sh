# 077 would be more secure, but 022 is more useful.
umask 022

# Save more history
export HISTSIZE="100000"
export SAVEHIST="100000"

# OS variables
UNAME_S="${UNAME_S:-$(uname -s)}"
[ "${UNAME_S}" = "Darwin" ] && export MACOS=1 && export UNIX=1
[ "${UNAME_S}" = "Linux" ] && export LINUX=1 && export UNIX=1
[[ "${UNAME_S}" == *_NT-* ]] && export WINDOWS=1
if [ -n "${LINUX}" ] && [ -r /proc/version ]; then
  PROC_VERSION="$(< /proc/version)"
  [[ "${PROC_VERSION}" == *Microsoft* || "${PROC_VERSION}" == *WSL* ]] && export WSL=1
fi

# Fix systems missing $USER
[ -z "$USER" ] && export USER="${LOGNAME:-$(id -un 2>/dev/null)}"
[ "${USER:0:9}" = "sandvault" ] && export SANDVAULT=1

# Count CPUs for Make jobs
if [ -n "${MACOS}" ]; then
  export CPUCOUNT="$(sysctl -n hw.ncpu 2>/dev/null)"
elif [ -n "${LINUX}" ]; then
  export CPUCOUNT="$(getconf _NPROCESSORS_ONLN)"
fi
if [ -z "$CPUCOUNT" ]; then
  export CPUCOUNT=1
fi

if [ "$CPUCOUNT" -gt 1 ]; then
  export MAKEFLAGS="-j$CPUCOUNT"
  export BUNDLE_JOBS="$CPUCOUNT"
fi
NOW_EPOCH="${NOW_EPOCH:-$(date +%s)}"

SHELL_CACHE_DIR="${HOME}/.cache/shell"
HOMEBREW_SHELLENV_CACHE="${SHELL_CACHE_DIR}/homebrew-shellenv.sh"
GITHUB_TOKEN_CACHE="${SHELL_CACHE_DIR}/github-token"

ensure_shell_cache_dir() {
  [ -d "${SHELL_CACHE_DIR}" ] || mkdir -p -m 700 "${SHELL_CACHE_DIR}"
}

shell_cache_older_than_week() {
  local cache_mtime

  [ -s "${1}" ] || return 0
  if [ -n "${MACOS}" ]; then
    cache_mtime="$(stat -f %m "${1}" 2>/dev/null)" || return 0
  else
    cache_mtime="$(stat -c %Y "${1}" 2>/dev/null)" || return 0
  fi

  [ "$(( NOW_EPOCH - cache_mtime ))" -ge 604800 ]
}

setup_homebrew() {
  local brew_bin

  [ -n "${HOMEBREW_PREFIX}" ] && return

  [ -s "${HOMEBREW_SHELLENV_CACHE}" ] && source "${HOMEBREW_SHELLENV_CACHE}"
  if [ -n "${HOMEBREW_PREFIX}" ] &&
     [ -x "${HOMEBREW_PREFIX}/bin/brew" ] &&
     ! shell_cache_older_than_week "${HOMEBREW_SHELLENV_CACHE}"; then
    return
  fi

  if [ -n "${HOMEBREW_PREFIX}" ] && [ -x "${HOMEBREW_PREFIX}/bin/brew" ]; then
    brew_bin="${HOMEBREW_PREFIX}/bin/brew"
  else
    if [ -x /opt/homebrew/bin/brew ]; then
      export HOMEBREW_PREFIX="/opt/homebrew"
    elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
      export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    elif [ -x /usr/local/bin/brew ]; then
      export HOMEBREW_PREFIX="/usr/local"
    elif command -v brew >/dev/null; then
      brew_bin="$(command -v brew)"
      case "${brew_bin}" in
        */bin/brew)
          export HOMEBREW_PREFIX="${brew_bin%/bin/brew}"
          ;;
      esac
    fi
    [ -z "${brew_bin}" ] && [ -n "${HOMEBREW_PREFIX}" ] && brew_bin="${HOMEBREW_PREFIX}/bin/brew"
  fi

  [ -n "${brew_bin}" ] || return

  ensure_shell_cache_dir
  "${brew_bin}" shellenv bash >| "${HOMEBREW_SHELLENV_CACHE}" || return
  source "${HOMEBREW_SHELLENV_CACHE}"
}

# Enable Terminal.app folder icons
[ "$TERM_PROGRAM" = "Apple_Terminal" ] && export TERMINALAPP=1
if [ -n "${TERMINALAPP}" ]; then
  set_terminal_app_pwd() {
    local terminal_app_pwd="file://$HOST$PWD"
    terminal_app_pwd="${terminal_app_pwd// /%20}"

    # Tell Terminal.app about each directory change.
    printf '\e]7;%s\a' "${terminal_app_pwd}"
  }
fi
[ -s ~/.lastpwd ] && [ "$PWD" = "$HOME" ] &&
  builtin cd "$(< ~/.lastpwd)" 2>/dev/null
[ -n "${TERMINALAPP}" ] && set_terminal_app_pwd

SHPROFILE_LOADED=1
