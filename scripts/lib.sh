# 共通変数・ヘルパー関数（setup.sh から source して使用）
# REPO_DIR はエントリポイントで定義済みであること

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

pkg_install() {
  case "$PKG_MGR" in
    brew) brew install "$1" ;;
    apt)  sudo apt-get install -y "$1" ;;
    dnf)  sudo dnf install -y "$1" ;;
    yum)  sudo yum install -y "$1" ;;
    *)    echo "! パッケージマネージャが見つかりません。手動でインストールしてください: $1"; return 1 ;;
  esac
}

_backup() {
  local file="$1"
  if [[ -e "$file" || -L "$file" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$file" "$BACKUP_DIR/$(basename "$file")"
    echo "  バックアップ: $BACKUP_DIR/$(basename "$file")"
  fi
}

link() {
  local src="$HOME_DIR/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ "$(readlink "$dst" 2>/dev/null)" == "$src" ]]; then
    echo "✓ $dst"; return
  fi
  _backup "$dst"
  ln -sfn "$src" "$dst" && echo "✓ $dst" || echo "✗ $dst (失敗)"
}

# dotfilesをsourceする実ファイルを生成する
# インストーラーによる追記はこの実ファイルに溜まり、リポジトリを汚さない
source_file() {
  local src="$HOME_DIR/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -f "$dst" ]] && grep -qF "source \"$src\"" "$dst" 2>/dev/null; then
    echo "✓ $dst"; return
  fi
  _backup "$dst"
  printf '# dotfiles共通設定を読み込む（このファイルはリポジトリ管理外）\n# マシン固有の設定・インストーラーによる追記はこのファイルの末尾に溜まります\nsource "%s"\n' "$src" > "$dst" \
    && echo "✓ $dst" || echo "✗ $dst (失敗)"
}

copy_file() {
  local src="$HOME_DIR/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if cmp -s "$src" "$dst" 2>/dev/null; then
    echo "✓ $dst"; return
  fi
  _backup "$dst"
  cp "$src" "$dst" && echo "✓ $dst" || echo "✗ $dst (失敗)"
}
