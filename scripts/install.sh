# パッケージ・ツールのインストール（lib.sh を source 済みの環境で実行）

# --- zsh ---
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

# --- vim ---
echo -e "\n[vim]"
if ! command -v vim &>/dev/null; then
  pkg_install vim
else
  echo "✓ vim (インストール済み)"
fi

# --- direnv ---
echo -e "\n[direnv]"
if ! command -v direnv &>/dev/null; then
  pkg_install direnv
else
  echo "✓ direnv (インストール済み)"
fi

# --- pyenv ---
echo -e "\n[pyenv]"
if ! command -v pyenv &>/dev/null; then
  pkg_install pyenv
else
  echo "✓ pyenv (インストール済み)"
fi

# --- oh-my-zsh ---
# RUNZSH=no: インストール後にzshを起動しない
# CHSH=no: デフォルトシェル変更は上記で行うためスキップ
echo -e "\n[oh-my-zsh]"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "インストール中..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✓ oh-my-zsh (インストール済み)"
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

# --- completion パーミッション修正 ---
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
