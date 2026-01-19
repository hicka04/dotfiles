#!/bin/bash

input=$(cat)

# ANSI color codes
CYAN=$'\033[0;36m'
PURPLE=$'\033[0;35m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
RESET=$'\033[0m'

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Replace $HOME with ~
cwd_display="${cwd/#$HOME/~}"

# Get git branch (skip optional locks for performance)
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_info=" on ${PURPLE}${branch}${RESET}"
    else
        git_info=""
    fi
else
    git_info=""
fi

# Format context usage
if [ -n "$used_pct" ]; then
    context_info=" | ${YELLOW}Context: ${used_pct}% used${RESET}"
else
    context_info=""
fi

# Output status line
printf "%s%s%s%s | %s%s%s%s" "$CYAN" "$cwd_display" "$RESET" "$git_info" "$BLUE" "$model" "$RESET" "$context_info"
