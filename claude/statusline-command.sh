#!/bin/sh
input=$(cat)

model=$(echo "$input" | jq -r '.model.id // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=$(git -C "${cwd:-.}" branch --show-current 2>/dev/null)
changes=$(git -C "${cwd:-.}" status --short 2>/dev/null | wc -l | tr -d ' ')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
approval_mode=$(echo "$input" | jq -r '.approval_mode // .permission_mode // .permissionMode // empty')
version=$(echo "$input" | jq -r '.version // .claude_version // empty')

yellow=$(printf '\033[33m')
green=$(printf '\033[32m')
blue=$(printf '\033[34m')
reset=$(printf '\033[0m')

parts=""

append_part() {
  if [ -n "$parts" ]; then
    parts="$parts · $1"
  else
    parts="$1"
  fi
}

# model + effort
if [ -n "$model" ]; then
  if [ -n "$effort" ]; then
    append_part "${yellow}${model} ${effort}${reset}"
  else
    append_part "${yellow}${model}${reset}"
  fi
fi

# branch changes
if [ -n "$changes" ] && [ "$changes" -gt 0 ] 2>/dev/null; then
  append_part "${blue}±${changes}${reset}"
fi

# 5-hour rate limit remaining
if [ -n "$five_pct" ]; then
  append_part "${yellow}5h $(printf '%.0f' "$(echo "100 - $five_pct" | bc -l)")%${reset}"
fi

# weekly rate limit remaining
if [ -n "$week_pct" ]; then
  append_part "${yellow}weekly $(printf '%.0f' "$(echo "100 - $week_pct" | bc -l)")%${reset}"
fi

# branch name
if [ -n "$branch" ]; then
  append_part "${green}${branch}${reset}"
fi

# approval mode
if [ -n "$approval_mode" ]; then
  append_part "$approval_mode"
fi

# version
if [ -n "$version" ]; then
  append_part "$version"
fi

echo "$parts"
