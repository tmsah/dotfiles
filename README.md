# dotfiles

個人の環境設定ファイル管理リポジトリ。  
`setup.sh` を実行するだけで全設定がシンボリックリンクで配置される。

## 構成

```
dotfiles/
├── setup.sh        # セットアップスクリプト
├── backup/         # 既存ファイルのバックアップ（git管理外）
└── home/           # ~/に配置されるファイル群
    ├── .zshrc
    ├── .gitconfig
    ├── .vimrc
    ├── .claude/
    ├── .vscode/
    ├── .oh-my-zsh/
    └── Library/
        ├── LaunchAgents/
        └── Preferences/   # iTerm2設定など
```

## セットアップ

### 1. clone

```bash
git clone git@github.com:tmsah/dotfiles.git ~/dotfiles
```

### 2. .gitconfig を編集

`home/.gitconfig` の以下の項目を自分の情報に書き換える。

```bash
vim ~/dotfiles/home/.gitconfig
```

```ini
[user]
    name = your-name       # ← 変更
    email = your@mail.com  # ← 変更
```

### 3. setup.sh を実行

```bash
~/dotfiles/setup.sh
```

以下が自動で行われる。

- zsh / vim / oh-my-zsh のインストール（未インストールの場合）
- oh-my-zsh プラグイン（zsh-syntax-highlighting, zsh-completions）のインストール
- `home/` 以下の設定ファイルを対応するパスにシンボリックリンクで配置
- デフォルトシェルを zsh に変更
- LaunchAgents の読み込み（macOS）
- iTerm2 設定の復元（macOS）
- completion ディレクトリのパーミッション修正

何度実行しても安全。調子が悪い時も再実行でOK。

**既存ファイルがある場合**は上書き前に `backup/<timestamp>/` へ自動バックアップされる。  
すでに正しく配置済みのファイルはスキップされる。

## 日常の使い方

ターミナルを開くたびに自動で `git pull` が走るため、基本的に何もしなくてよい。

```
dotfiles: 最新です ✓          # 更新なし
dotfiles: 更新しました ✓      # 新しい設定が反映された
dotfiles: pull 失敗 (...)     # オフライン時など
```

設定を変更した場合は編集・コミット・プッシュすれば他の環境に反映される。

### iTerm2 設定を更新する場合

iTerm2 の設定はシンボリックリンクではなくコピーで管理しているため、  
GUI で設定を変更した後に手動でリポジトリへ反映する必要がある。

```bash
cp ~/Library/Preferences/com.googlecode.iterm2.plist \
   ~/dotfiles/home/Library/Preferences/com.googlecode.iterm2.plist
```