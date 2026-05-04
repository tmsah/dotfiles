#!/bin/bash
# 設定ファイルをシンボリックリンクでホームディレクトリに配置するスクリプト
# 使い方: git clone git@github.com:tmsah/dotfiles.git ~/dotfiles && ~/dotfiles/setup.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$REPO_DIR/home"
BACKUP_DIR="$REPO_DIR/backup/$(date +%Y%m%d_%H%M%S)"

# OS・環境判定
OS="$(uname -s)"
IS_WSL=false
grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=true

# パッケージマネージャ判定
if [[ "$OS" == "Darwin" ]]; then
  PKG_MGR="brew"
elif command -v apt-get &>/dev/null; then
  PKG_MGR="apt"
elif command -v dnf &>/dev/null; then
  PKG_MGR="dnf"
elif command -v yum &>/dev/null; then
  PKG_MGR="yum"
else
  PKG_MGR="unknown"
fi

# パッケージインストールヘルパー
pkg_install() {
  case "$PKG_MGR" in
    brew) brew install "$1" ;;
    apt)  sudo apt-get install -y "$1" ;;
    dnf)  sudo dnf install -y "$1" ;;
    yum)  sudo yum install -y "$1" ;;
    *)    echo "! パッケージマネージャが見つかりません。手動でインストールしてください: $1"; return 1 ;;
  esac
}

# 既存ファイルをバックアップ
_backup() {
  local file="$1"
  if [[ -e "$file" || -L "$file" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$file" "$BACKUP_DIR/$(basename "$file")"
    echo "  バックアップ: $BACKUP_DIR/$(basename "$file")"
  fi
}

# シンボリックリンク作成ヘルパー (home/ 以下のパスを受け取る)
link() {
  local src="$HOME_DIR/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  # すでに正しいシンボリックリンクならスキップ
  if [[ "$(readlink "$dst" 2>/dev/null)" == "$src" ]]; then
    echo "✓ $dst"; return
  fi
  _backup "$dst"
  ln -sfn "$src" "$dst" && echo "✓ $dst" || echo "✗ $dst (失敗)"
}

# ファイルコピーヘルパー (plistなどシンボリックリンク不可のファイル用)
copy_file() {
  local src="$HOME_DIR/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  # 内容が同じならスキップ
  if cmp -s "$src" "$dst" 2>/dev/null; then
    echo "✓ $dst"; return
  fi
  _backup "$dst"
  cp "$src" "$dst" && echo "✓ $dst" || echo "✗ $dst (失敗)"
}

echo "=== セットアップ開始: $REPO_DIR ==="

# --- zsh インストール ---
echo -e "\n[zsh]"
if ! command -v zsh &>/dev/null; then
  pkg_install zsh
else
  echo "✓ zsh (インストール済み)"
fi
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  echo "デフォルトシェルをzshに変更します"
  chsh -s "$(which zsh)"
fi

# --- vim インストール ---
echo -e "\n[vim]"
if ! command -v vim &>/dev/null; then
  pkg_install vim
else
  echo "✓ vim (インストール済み)"
fi

# --- oh-my-zsh インストール ---
# RUNZSH=no: インストール後にzshを起動しない
# CHSH=no: デフォルトシェル変更は上記で行うためスキップ
echo -e "\n[oh-my-zsh]"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "インストール中..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✓ oh-my-zsh (インストール済み)"
fi

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
link .oh-my-zsh/custom/themes/main.zsh-theme \
     "$HOME/.oh-my-zsh/custom/themes/main.zsh-theme"

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

# --- macOS 専用設定 ---
if [[ "$OS" == "Darwin" ]]; then
  # LaunchAgents
  echo -e "\n[LaunchAgents]"
  link Library/LaunchAgents/com.user.ssh-add.plist \
       "$HOME/Library/LaunchAgents/com.user.ssh-add.plist"
  PLIST_LABEL="com.user.ssh-add"
  if launchctl list | grep -q "$PLIST_LABEL" 2>/dev/null; then
    echo "✓ $PLIST_LABEL (読み込み済み)"
  else
    launchctl load "$HOME/Library/LaunchAgents/$PLIST_LABEL.plist" \
      && echo "✓ $PLIST_LABEL (読み込み完了)" \
      || echo "✗ $PLIST_LABEL (読み込み失敗)"
  fi

  # iTerm2 設定
  echo -e "\n[iTerm2]"
  ITERM2_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
  copy_file Library/Preferences/com.googlecode.iterm2.plist "$ITERM2_PLIST"
  # 設定をすぐ反映させるためにキャッシュをリセット
  killall cfprefsd 2>/dev/null || true
fi

# --- oh-my-zsh プラグイン ---
echo -e "\n[oh-my-zsh プラグイン]"
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

# --- completion ディレクトリのパーミッション修正 ---
echo -e "\n[completion パーミッション]"
if command -v compaudit &>/dev/null; then
  local_insecure=$(compaudit 2>/dev/null)
  if [[ -n "$local_insecure" ]]; then
    echo "$local_insecure" | xargs chmod g-w,o-w
    echo "✓ パーミッション修正完了"
  else
    echo "✓ 問題なし"
  fi
fi

echo -e "\n=== セットアップ完了 ==="
echo "  ※ シェルを再起動して設定を反映してください: exec zsh"
