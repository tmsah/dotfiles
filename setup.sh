#!/bin/bash
# 使い方: git clone git@github.com:tmsah/dotfiles.git ~/dotfiles && ~/dotfiles/setup.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$REPO_DIR/scripts/lib.sh"

echo "=== セットアップ開始: $REPO_DIR ==="

source "$REPO_DIR/scripts/install.sh"
source "$REPO_DIR/scripts/link.sh"

[[ "$OS" == "Darwin" ]] && source "$REPO_DIR/scripts/macos.sh"

echo -e "\n=== セットアップ完了 ==="
echo "  ※ シェルを再起動して設定を反映してください: exec zsh"
