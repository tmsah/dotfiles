# bashから移行する場合は$PATHを変更する必要があるかもしれません
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Nodebrew経由のnpm
export PATH=$HOME/.nodebrew/current/bin:$PATH

# oh-my-zshのインストールパス
export ZSH=$HOME/.oh-my-zsh

# 読み込むテーマ名を設定 --- "random"に設定すると、
# oh-my-zshが読み込まれるたびにランダムなテーマが読み込まれます
# どのテーマが読み込まれたかを知るには: echo $RANDOM_THEME
# テーマについては https://github.com/ohmyzsh/ohmyzsh/wiki/Themes を参照
ZSH_THEME="main"

# ランダム読み込み時に選択するテーマのリストを設定
# ZSH_THEME=randomの時にこの変数を設定すると、zshは
# ~/.oh-my-zsh/themes/を見る代わりにこの変数からテーマを読み込みます
# 空の配列に設定した場合、この変数は効果がありません
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# 大文字小文字を区別する補完を使用する
# CASE_SENSITIVE="true"

# ハイフンを区別しない補完を使用する
# CASE_SENSITIVEはオフにする必要があります。_と-が交換可能になります
# HYPHEN_INSENSITIVE="true"

# 隔週の自動更新チェックを無効化
# DISABLE_AUTO_UPDATE="true"

# プロンプトなしで自動更新する
# DISABLE_UPDATE_PROMPT="true"

# 自動更新の頻度を変更する
# export UPDATE_ZSH_DAYS=13

# URLやその他のテキストをよしなに貼り付ける機能を無効化
# DISABLE_MAGIC_FUNCTIONS=true

# lsでの色表示を無効化
#DISABLE_LS_COLORS="true"

# ターミナルタイトルの自動設定を無効化
# DISABLE_AUTO_TITLE="true"

# コマンドの自動修正を有効化
# ENABLE_CORRECTION="true"

# 補完待機中に赤いドットを表示する
# COMPLETION_WAITING_DOTS="true"

# VCS配下の追跡されていないファイルをdirtyとしてマークするのを無効化
# これにより大きなリポジトリでのリポジトリステータスチェックが大幅に高速化される
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# historyコマンド出力に表示される実行時刻のタイムスタンプを変更
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# またはstrftime関数の形式指定を使用してカスタム形式を設定する
# 詳細は 'man strftime' を参照してください
# HIST_STAMPS="mm/dd/yyyy"

# $ZSH/custom以外のカスタムフォルダを使用
# ZSH_CUSTOM=/path/to/new-custom-folder

# どのプラグインを読み込みますか？
# 標準プラグインは ~/.oh-my-zsh/plugins/* にあります
# カスタムプラグインは ~/.oh-my-zsh/custom/plugins/ に追加
# 例の形式: plugins=(rails git textmate ruby lighthouse)
# プラグインが多すぎるとシェルの起動が遅くなるので、賢く追加してください
plugins=(git zsh-syntax-highlighting zsh-completions)
autoload -U compinit && compinit -u

source $ZSH/oh-my-zsh.sh
export LSCOLORS=GxfxcxdxbxegedabagGxGx

# ユーザー設定

# export MANPATH="/usr/local/man:$MANPATH"

# 言語環境を手動で設定
# export LANG=en_US.UTF-8

# ローカルおよびリモートセッション用の優先エディタ
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# コンパイルフラグ
# export ARCHFLAGS="-arch x86_64"

# oh-my-zshのライブラリ、プラグイン、テーマで提供されるものを上書きする
# 個人的なエイリアスを設定します。エイリアスはここに配置できますが、
# oh-my-zshユーザーはZSH_CUSTOMフォルダ内でエイリアスを定義することが推奨されます。
# アクティブなエイリアスを表示するには、`alias`を実行してください。
#
# エイリアスの例
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias l='ls'
alias tf='terraform'

alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dp='docker ps'
alias dim='docker images'

# 文字コードの指定
export LANG=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# cdなしでディレクトリ移動
setopt auto_cd

# ビープ音の停止
setopt no_beep

# ビープ音の停止(補完時)
setopt nolistbeep

# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd

# ヒストリ(履歴)を保存、数を増やす
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 同時に起動したzshの間でヒストリを共有する
#setopt share_history

# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 追加の設定ファイルを実行
. "$HOME/.local/bin/env"
