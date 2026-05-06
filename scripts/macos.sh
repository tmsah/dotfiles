# macOS 専用セットアップ（lib.sh を source 済みの環境で実行）

# --- nodebrew ---
echo -e "\n[nodebrew]"
if ! command -v nodebrew &>/dev/null; then
  brew install nodebrew
  nodebrew setup
else
  echo "✓ nodebrew (インストール済み)"
fi

# --- LaunchAgents ---
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

# --- iTerm2 設定 ---
echo -e "\n[iTerm2]"
ITERM2_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
copy_file Library/Preferences/com.googlecode.iterm2.plist "$ITERM2_PLIST"
# 設定をすぐ反映させるためにキャッシュをリセット
killall cfprefsd 2>/dev/null || true
