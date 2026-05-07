#!/bin/bash
# 使い方: git clone git@github.com:tmsah/dotfiles.git ~/dotfiles && ~/dotfiles/setup.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$REPO_DIR/scripts/lib.sh"
source "$REPO_DIR/scripts/wizard.sh"

echo -e "\n=== セットアップ開始: $REPO_DIR ==="

source "$REPO_DIR/scripts/install.sh"
source "$REPO_DIR/scripts/link.sh"

[[ "$OS" == "Darwin" ]] && source "$REPO_DIR/scripts/macos.sh"

echo -e "\n=== セットアップ完了 ==="
echo ""
read -rp "設定を反映するためにシェルを再起動しますか？ (exec zsh) [y/N]: " _reply
if [[ "$_reply" =~ ^[Yy]$ ]]; then
  exec zsh
else
  echo "  ※ 後で手動で実行してください: exec zsh"
fi
