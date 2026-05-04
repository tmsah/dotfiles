#!/bin/bash
# 設定ファイルをシンボリックリンクでホームディレクトリに配置するスクリプト
# 使い方: git clone git@github.com:tmsah/dotfiles.git ~/dotfiles && ~/dotfiles/setup.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$REPO_DIR/home"

# OS・環境判定
OS="$(uname -s)"
IS_WSL=false
grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=true

# シンボリックリンク作成ヘルパー (home/ 以下のパスを受け取る)
link() {
  local src="$HOME_DIR/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst" && echo "✓ $dst" || echo "✗ $dst (失敗)"
}

echo "=== セットアップ開始: $REPO_DIR ==="

# --- dotfiles ---
echo -e "\n[dotfiles]"
link .zshrc            "$HOME/.zshrc"
link .bash_profile     "$HOME/.bash_profile"
link .bashrc           "$HOME/.bashrc"
link .gitconfig        "$HOME/.gitconfig"
link .gitignore_global "$HOME/.gitignore_global"
link .vimrc            "$HOME/.vimrc"

# --- oh-my-zsh テーマ ---
echo -e "\n[oh-my-zsh テーマ]"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  link .oh-my-zsh/custom/themes/main.zsh-theme \
       "$HOME/.oh-my-zsh/custom/themes/main.zsh-theme"
else
  echo "! oh-my-zsh 未インストール。スキップ。"
fi

# --- Claude 設定 ---
echo -e "\n[Claude]"
link .claude/settings.json "$HOME/.claude/settings.json"
link .claude/CLAUDE.md     "$HOME/.claude/CLAUDE.md"

# --- VSCode 設定 ---
echo -e "\n[VSCode]"
if [[ "$OS" == "Darwin" ]]; then
  VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
elif $IS_WSL; then
  WIN_USER="$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')"
  VSCODE_USER_DIR="/mnt/c/Users/$WIN_USER/AppData/Roaming/Code/User"
else
  VSCODE_USER_DIR="$HOME/.config/Code/User"
fi
link .vscode/settings.json    "$VSCODE_USER_DIR/settings.json"
link .vscode/keybindings.json "$VSCODE_USER_DIR/keybindings.json"

# --- LaunchAgents (macOS のみ) ---
if [[ "$OS" == "Darwin" ]]; then
  echo -e "\n[LaunchAgents]"
  link Library/LaunchAgents/com.user.ssh-add.plist \
       "$HOME/Library/LaunchAgents/com.user.ssh-add.plist"
  echo "  ※ 有効化: launchctl load ~/Library/LaunchAgents/com.user.ssh-add.plist"
fi

# --- oh-my-zsh プラグイン ---
echo -e "\n[oh-my-zsh プラグイン]"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  PLUGIN_DIR="$HOME/.oh-my-zsh/custom/plugins"
  for repo in "zsh-users/zsh-syntax-highlighting" "zsh-users/zsh-completions"; do
    name="${repo##*/}"
    if [[ ! -d "$PLUGIN_DIR/$name" ]]; then
      echo "インストール中: $name"
      git clone "https://github.com/$repo.git" "$PLUGIN_DIR/$name"
    else
      echo "✓ $name (インストール済み)"
    fi
  done
else
  echo "! oh-my-zsh 未インストール。スキップ。"
fi

echo -e "\n=== セットアップ完了 ==="
