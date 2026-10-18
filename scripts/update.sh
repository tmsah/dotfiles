#!/bin/bash
# dotfiles の自動更新（.zshrc の _dotfiles_update から実行）
# 1. git pull（3秒タイムアウト）
# 2. link.sh を実行し、新しく必要になったシンボリックリンクを作成（配置済みのものは何もしない）

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
[[ -d "$REPO_DIR/.git" ]] || exit 0

pull_with_timeout() {
  local before after code
  before=$(git -C "$REPO_DIR" rev-parse HEAD 2>/dev/null)

  # タイムアウト判定用フラグファイル
  local timeout_flag="${TMPDIR:-/tmp}/.dotfiles_timeout_${USER}"
  rm -f "$timeout_flag"

  git -C "$REPO_DIR" pull --quiet --ff-only 2>/dev/null &
  local git_pid=$!
  { sleep 3 && touch "$timeout_flag" && kill "$git_pid" 2>/dev/null; } &>/dev/null &
  local timer_pid=$!
  wait "$git_pid" 2>/dev/null
  code=$?
  kill "$timer_pid" 2>/dev/null
  wait "$timer_pid" 2>/dev/null

  if [[ -f "$timeout_flag" ]]; then
    rm -f "$timeout_flag"
    echo "dotfiles: タイムアウト"
    return
  fi

  if (( code != 0 )); then
    echo "dotfiles: pull 失敗 (オフラインまたはコンフリクトの可能性があります)"
    return
  fi

  after=$(git -C "$REPO_DIR" rev-parse HEAD 2>/dev/null)
  if [[ "$before" != "$after" ]]; then
    echo "dotfiles: 更新しました ✓"
  else
    echo "dotfiles: 最新です ✓"
  fi
}

# link.sh を実行する
# 配置済みのものは表示せず、新規作成・バックアップ・失敗だけを表示する
sync_links() {
  local out
  source "$REPO_DIR/scripts/lib.sh"
  QUIET_UNCHANGED=1
  out=$(source "$REPO_DIR/scripts/link.sh" 2>&1 | grep -E '^(✓|✗|  バックアップ)')
  if [[ -n "$out" ]]; then
    echo "dotfiles: 設定ファイルを配置しました（新しいシェルで反映されます）"
    echo "$out" | sed 's/^/  /'
  fi
}

pull_with_timeout
sync_links
