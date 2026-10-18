# Docker 用のエイリアス・関数

alias dim='docker images'
alias dp='docker ps'

# Docker Desktop の CLI（docker desktop start/stop）が使えるか
_docker_has_desktop_cli() {
  command docker desktop version >/dev/null 2>&1
}

# Docker が使えない状態なら Docker Desktop を起動し、使える状態になるまで待つ
_docker_ensure_running() {
  command docker info >/dev/null 2>&1 && return 0
  if ! _docker_has_desktop_cli; then
    echo "Docker が起動していません（Docker Desktop の CLI が見つからないため自動起動できません）"
    return 1
  fi
  echo "Docker Desktop を起動しています..."
  command docker desktop start --timeout 180 >/dev/null
  # アプリは動いているのにエンジンだけ止まっている場合は、再起動して立て直す
  if ! command docker info >/dev/null 2>&1; then
    echo "Docker エンジンが応答しないため、Docker Desktop を再起動しています..."
    command docker desktop restart --timeout 180 >/dev/null
  fi
  if ! command docker info >/dev/null 2>&1; then
    echo "Docker Desktop の起動に失敗しました"
    return 1
  fi
  echo "Docker Desktop の起動が完了しました"
}

# docker compose up -d（Docker が使えなければ Docker Desktop を起動してから実行）
dcu() {
  _docker_ensure_running || return
  command docker compose up -d "$@"
}

# docker compose down（他に動いているコンテナがなければ Docker Desktop も終了）
dcd() {
  if ! command docker info >/dev/null 2>&1; then
    echo "Docker は起動していません"
    return 0
  fi
  command docker compose down "$@" || return
  if ! _docker_has_desktop_cli; then
    echo "Docker Desktop の CLI が見つからないため、Docker Desktop の自動終了はスキップします"
    return 0
  fi
  if [[ -n "$(command docker ps -q)" ]]; then
    echo "他のコンテナが動いているため Docker Desktop は終了しません"
    return 0
  fi
  echo "Docker Desktop を終了します"
  command docker desktop stop --timeout 60 >/dev/null
}
