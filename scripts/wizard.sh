# 個人情報の入力ウィザード（テンプレートから実ファイルを生成）
# lib.sh を source 済みの環境で実行すること

echo -e "\n=== 個人設定ウィザード ==="

# --- git 設定 ---
GIT_CONFIG="$HOME/.gitconfig"
if [[ -f "$GIT_CONFIG" ]]; then
  echo "✓ ~/.gitconfig (既存ファイルあり・スキップ)"
else
  echo -e "\n[git 設定]"
  read -rp "  user.name  : " git_name
  read -rp "  user.email : " git_email
  sed -e "s/{{GIT_NAME}}/$git_name/" \
      -e "s/{{GIT_EMAIL}}/$git_email/" \
      "$REPO_DIR/home/.gitconfig.template" > "$GIT_CONFIG"
  echo "✓ ~/.gitconfig を生成しました"
fi

# --- SSH キー設定（macOS のみ）---
if [[ "$OS" == "Darwin" ]]; then
  SSH_PLIST="$HOME/Library/LaunchAgents/com.user.ssh-add.plist"
  mkdir -p "$(dirname "$SSH_PLIST")"
  if [[ -f "$SSH_PLIST" ]]; then
    echo "✓ ~/Library/LaunchAgents/com.user.ssh-add.plist (既存ファイルあり・スキップ)"
  else
    echo -e "\n[SSH キー設定]"
    read -rp "  SSH キーのパス (例: $HOME/.ssh/id_rsa): " ssh_key_path
    sed "s|{{SSH_KEY_PATH}}|$ssh_key_path|" \
        "$REPO_DIR/home/Library/LaunchAgents/com.user.ssh-add.plist.template" > "$SSH_PLIST"
    echo "✓ ~/Library/LaunchAgents/com.user.ssh-add.plist を生成しました"
  fi
fi
