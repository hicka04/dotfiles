#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
name=$(jq -r '.name' <<< "$input")
base=$(jq -r '.cwd' <<< "$input")

dir="$base/.claude/worktrees/$name"

# origin/HEAD の実体を解決。なければローカル HEAD にフォールバック
base_ref=$(git -C "$base" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null || echo "HEAD")

# name に / が含まれる場合に備えて親ディレクトリを作成
mkdir -p "$(dirname "$dir")"

# 作成ログは stderr へ。stdout には worktree パスのみ出力（hook の出力要件）
git -C "$base" worktree add -b "$name" "$dir" "$base_ref" >&2

echo "$dir"
