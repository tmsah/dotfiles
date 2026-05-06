# dotfiles のシンボリックリンク・実ファイル配置（lib.sh を source 済みの環境で実行）

# --- dotfiles ---
echo -e "\n[dotfiles]"
source_file .zshrc        "$HOME/.zshrc"
source_file .bash_profile "$HOME/.bash_profile"
source_file .bashrc       "$HOME/.bashrc"
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
