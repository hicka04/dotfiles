#!/bin/bash

input=$(cat)

# ANSI color codes
CYAN=$'\033[0;36m'
PURPLE=$'\033[0;35m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
GREEN=$'\033[0;32m'
RESET=$'\033[0m'

# Extract values from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')

# Format token count in human-readable form (k units)
format_tokens() {
    local tokens=$1
    if [ "$tokens" -ge 1000 ] 2>/dev/null; then
        awk "BEGIN {printf \"%.1fk\", $tokens/1000}"
    else
        echo "$tokens"
    fi
}

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

# Format token info
if [ -n "$total_input" ] && [ -n "$total_output" ]; then
    total_tokens=$((total_input + total_output))
    formatted=$(format_tokens "$total_tokens")
    if [ -n "$total_cost" ]; then
        token_info=" | ${GREEN}Tokens: ${formatted} (\$${total_cost})${RESET}"
    else
        token_info=" | ${GREEN}Tokens: ${formatted}${RESET}"
    fi
else
    token_info=""
fi

# Output status line
printf "%s%s%s%s | %s%s%s%s%s" "$CYAN" "$cwd_display" "$RESET" "$git_info" "$BLUE" "$model" "$RESET" "$context_info" "$token_info"
