# Docker Compose 用のショートカット（Docker Desktop の自動起動・終了付き）

# Docker Desktop が停止中なら起動し、使える状態になるまで待つ
_docker_ensure_running() {
  command docker info >/dev/null 2>&1 && return 0
  echo "Docker Desktop を起動しています..."
  open -a Docker || return 1
  until command docker info >/dev/null 2>&1; do sleep 1; done
  echo "Docker Desktop の起動が完了しました"
}

# docker compose up -d（停止中なら Docker Desktop を起動してから実行）
dcu() {
  _docker_ensure_running || return
  command docker compose up -d "$@"
}

# docker compose down（他に動いているコンテナがなければ Docker Desktop も終了）
dcd() {
  if ! command docker info >/dev/null 2>&1; then
    echo "Docker Desktop は起動していません"
    return 0
  fi
  command docker compose down "$@" || return
  # Docker Desktop の終了は macOS のみ対応（osascript を使うため）
  if [[ "$OSTYPE" != darwin* ]]; then
    echo "Docker Desktop の自動終了は macOS のみ対応のためスキップします"
    return 0
  fi
  if [[ -z "$(command docker ps -q)" ]]; then
    echo "Docker Desktop を終了します"
    osascript -e 'quit app "Docker"'
  else
    echo "他のコンテナが動いているため Docker Desktop は終了しません"
  fi
}
