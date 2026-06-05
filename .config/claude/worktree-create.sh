#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
name=$(jq -r '.name' <<< "$input")
cwd=$(jq -r '.cwd' <<< "$input")

# サブディレクトリ起動でも正しくルートを基準にする
root=$(git -C "$cwd" rev-parse --show-toplevel)

dir="$root/.claude/worktrees/$name"

# 公式と同じ worktree.baseRef を settings.json から読む。
# スコープの小さい順（Local > Project > User）に探索し、最初に見つかった値を採用。
base_setting=""
for settings_file in \
  "$root/.claude/settings.local.json" \
  "$root/.claude/settings.json" \
  "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json"; do
  if [ -f "$settings_file" ]; then
    value=$(jq -r '.worktree.baseRef // empty' "$settings_file" 2>/dev/null || true)
    if [ -n "$value" ]; then
      base_setting="$value"
      break
    fi
  fi
done

# 値を base ref に変換（公式セマンティクスに一致）。
# head: ローカル HEAD / fresh(既定): origin/HEAD、なければローカル HEAD にフォールバック。
case "${base_setting:-fresh}" in
  head)
    base_ref="HEAD"
    ;;
  fresh)
    base_ref=$(git -C "$root" symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null || echo "HEAD")
    ;;
  *)
    echo "worktree.baseRef must be \"fresh\" or \"head\", got: \"$base_setting\"" >&2
    exit 1
    ;;
esac

# 対応する worktree がすでに存在する場合はそのまま返す
if git -C "$root" worktree list --porcelain | grep -qF "worktree $dir"; then
  echo "$dir"
  exit 0
fi

# name に / が含まれる場合に備えて親ディレクトリを作成
mkdir -p "$(dirname "$dir")"

# 作成ログは stderr へ。stdout には worktree パスのみ出力（hook の出力要件）
if git -C "$root" show-ref --verify --quiet "refs/heads/$name"; then
  # 既存ブランチをチェックアウト（base_ref は使わない）
  git -C "$root" worktree add "$dir" "$name" >&2
else
  git -C "$root" worktree add -b "$name" "$dir" "$base_ref" >&2
fi

echo "$dir"
