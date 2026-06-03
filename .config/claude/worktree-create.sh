#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
name=$(jq -r '.name' <<< "$input")
cwd=$(jq -r '.cwd' <<< "$input")

# サブディレクトリ起動でも正しくルートを基準にする
root=$(git -C "$cwd" rev-parse --show-toplevel)

dir="$root/.claude/worktrees/$name"

# origin/HEAD の実体を解決。なければローカル HEAD にフォールバック
base_ref=$(git -C "$root" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null || echo "HEAD")

# name に / が含まれる場合に備えて親ディレクトリを作成
mkdir -p "$(dirname "$dir")"

# 作成ログは stderr へ。stdout には worktree パスのみ出力（hook の出力要件）
git -C "$root" worktree add -b "$name" "$dir" "$base_ref" >&2

echo "$dir"
