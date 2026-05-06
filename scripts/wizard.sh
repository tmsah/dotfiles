# 個人情報の入力ウィザード（home/.local/ 以下にローカル設定を生成）
# lib.sh を source 済みの環境で実行すること

LOCAL_DIR="$REPO_DIR/home/.local"
mkdir -p "$LOCAL_DIR"

echo -e "\n=== 個人設定ウィザード ==="

# --- git 設定（home/.local/gitconfig）---
if [[ -f "$LOCAL_DIR/gitconfig" ]]; then
  echo "✓ home/.local/gitconfig (既存ファイルあり・スキップ)"
else
  echo -e "\n[git 設定]"
  read -rp "  user.name  : " git_name
  read -rp "  user.email : " git_email
  printf '[user]\n    name = %s\n    email = %s\n' "$git_name" "$git_email" \
    > "$LOCAL_DIR/gitconfig"
  echo "✓ home/.local/gitconfig を生成しました"
fi

# --- SSH キー設定（home/.local/ssh_key・macOS のみ）---
if [[ "$OS" == "Darwin" ]]; then
  if [[ -f "$LOCAL_DIR/ssh_key" ]]; then
    echo "✓ home/.local/ssh_key (既存ファイルあり・スキップ)"
  else
    echo -e "\n[SSH キー設定]"
    read -rp "  SSH キーのパス (例: $HOME/.ssh/id_rsa): " ssh_key_path
    printf '%s\n' "$ssh_key_path" > "$LOCAL_DIR/ssh_key"
    echo "✓ home/.local/ssh_key を生成しました"
  fi
fi
