set nocompatible              " be iMproved, required
filetype off                  " required

" 画面表示の設定
set number         " 行番号を表示する
set cursorline     " カーソル行にアンダーライン
set showmatch      " 対応する括弧を強調表示
set helpheight=999 " ヘルプを画面いっぱいに開く

" カーソル移動関連の設定
set backspace=indent,eol,start " Backspaceキーの影響範囲に制限を設けない
set whichwrap=b,s,h,l,<,>,[,]  " 行頭行末の左右移動で行をまたぐ
set scrolloff=8                " 上下8行の視界を確保
set sidescrolloff=16           " 左右スクロール時の視界を確保
set sidescroll=1               " 左右スクロールは一文字づつ行う
set virtualedit=onemore	" 行末の1文字先までカーソル移動可能

" ファイル処理関連の設定
set confirm    " 保存されていないファイルがあるときは終了前に保存確認
set hidden     " 保存されていないファイルがあるときでも別のファイルを開くことが出来る
set autoread   "外部でファイルに変更がされた場合は読みなおす
set nobackup   " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない

" 検索/置換の設定
set hlsearch   " 検索文字列をハイライトする
nmap <Esc><Esc> :nohlsearch<CR><Esc>	" <Esc>2回で検索ハイライト解除
set incsearch  " インクリメンタルサーチを行う
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 大文字と小文字が混在した言葉で検索を行った場合に限り、大文字と小文字を区別する
set wrapscan   " 最後尾まで検索を終えたら次の検索で先頭に移る
set gdefault   " 置換の時 g オプションをデフォルトで有効にする

" タブ/インデントの設定
set expandtab     " インデントにタブを利用しない
set tabstop=2     " タブがスペース2文字になる
set shiftwidth=2  " スペース2文字ずつインデントを増やすする
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に入力された行の末尾に合わせて次の行のインデントを増減する

" 動作環境との統合関連の設定
" OSのクリップボードをレジスタ指定無しで Yank, Put 出来るようにする
set clipboard=unnamed,unnamedplus
" マウスの入力を受け付ける
set mouse=a
" Windows でもパスの区切り文字を / にする
set shellslash

" コマンドラインの設定
" コマンドラインモードでTABキーによるファイル名補完を有効にする
set wildmenu wildmode=list:longest,full
" コマンドラインの履歴を10000件保存する
set history=2000

" ビープの設定

"ビープ音すべてを無効にする
set visualbell t_vb=
set noerrorbells "エラーメッセージの表示時にビープを鳴らさない

" 折りたたみ関連
set foldenable
set foldmethod=indent
set foldopen=all  " fold内に移動すれば自動で開く
" set foldclose=all  " fold外に移動しfoldlevelより深ければ閉じる
set foldlevel=0   " 折りたたみの具合
set foldnestmax=2  " 最大折りたたみ深度$
set foldcolumn=2  " 左側に折りたたみガイド表示$

set showcmd	" 入力中のコマンドを右下に表示する
set ruler	" カーソルの位置表示を行う
syntax on	" シンタックスハイライトを有効にする　onにしない意味が分からない
set encoding=utf-8
nmap <F1> :w <Return> :! gcc -o "%:r".exe % && ./"%:r".exe <Return>
nmap <F3> :! sh compile.sh<CR><Esc>
nmap <F12> :vsplit ~/.vimrc<CR><Esc>
nmap sh <C-w>h
nmap sj <C-w>j
nmap sk <C-w>k
nmap sl <C-w>l
nmap sw <C-w>w
nmap sx <C-w>x " 現在の画面の位置を一つ前の画面と入れ替え
nmap :w<Return> gg=G <Return> :w <Return>
nmap :we<Return> :w <Return>