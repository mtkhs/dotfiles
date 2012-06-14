" for macvim-kaoriya http://code.google.com/p/macvim-kaoriya/

set nocompatible " vim の機能を使う
		" 元から入ってるvimなら~/.vimrcがあれば自動で有効になるらしいけど
		" kaoriyaだとそれが無いっぽい

let s:iswin = has('win32') || has('win64')

" =============================================================================
" for plugin settings
" =============================================================================
" NeoBundle {{{
filetype off

if has('vim_starting')
"	set rtp+=~/.vim/neobundle.vim.git
	set runtimepath+=~/.vim/.neobundle/neobundle.vim/
	call neobundle#rc('~/.vim/.neobundle/')
endif


NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'thinca/vim-localrc'
NeoBundle 'Shougo/vimproc'
"after install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
" $ cd ~/.vim/.neobundle/vimproc
" $ make -f make_mac.mak

" Explore/FileSystem
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/vimfiler'
"NeoBundle 'project-1.4.1'

" Filetypes
NeoBundle 'vim-ruby/vim-ruby'
if !s:iswin
  NeoBundle 'tpope/vim-rvm'
endif
NeoBundle 'tpope/vim-rails'
NeoBundle 'tpope/vim-rake'
NeoBundle 'tpope/vim-haml'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'othree/html5.vim'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'groenewege/vim-less'
NeoBundle 'JavaScript-syntax'
NeoBundle 'vim-creole'
" Syntax Check
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vim-scripts/javacomplete'

NeoBundle "Shougo/neocomplcache"
NeoBundle 'Shougo/neocomplcache-snippets-complete'

NeoBundle "Shougo/unite.vim"
NeoBundle "thinca/vim-ref"

NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'Align'

" colorschemes
"NeoBundle "altercation/vim-colors-solarized"

" }}}

" NeoComplcache {{{
	" 補完ウィンドウの設定
	set completeopt=menuone
	" 起動時に有効化
	let g:neocomplcache_enable_at_startup = 1
	" 大文字が入力されるまで大文字小文字の区別を無視する
	let g:neocomplcache_enable_smart_case = 1
	" _(アンダースコア)区切りの補完を有効化
	let g:neocomplcache_enable_underbar_completion = 1
	" ポップアップメニューで表示される候補の数
	let g:neocomplcache_max_list = 20
	" シンタックスをキャッシュするときの最小文字長
	let g:neocomplcache_min_syntax_length = 3
	" 挿入モードのカーソル移動であんまり補完しないように
	let g:NeoComplCache_EnableSkipCompletion = 1
	let g:NeoComplCache_SkipInputTime = '0.5'
	inoremap <expr><Up> pumvisible() ? neocomplcache#close_popup()."\<Up>" : "\<Up>"
	inoremap <expr><Down> pumvisible() ? neocomplcache#close_popup()."\<Down>" : "\<Down>"

	" ディクショナリ定義
	let g:neocomplcache_dictionary_filetype_lists = {
		\ 'default' : '',
		\ 'ruby' : $HOME . '/.vim/dict/ruby.dict',
		\ 'nb' : $HOME . '/.vim/dict/ruby.dict',
		\ 'c' : $HOME . '/.vim/dict/c.dict',
		\ 'cpp' : $HOME . '/.vim/dict/cpp.dict',
		\ 'php' : $HOME . '/.vim/dict/php.dict',
		\ 'ctp' : $HOME . '/.vim/dict/php.dict',
		\ 'javascript' : $HOME . '/.vim/dict/javascript.dict',
		\ 'perl' : $HOME . '/.vim/dict/perl.dict',
		\ 'java' : $HOME . '/.vim/dict/java.dict',
		\ }
	
	if !exists('g:neocomplcache_keyword_patterns')
	        let g:neocomplcache_keyword_patterns = {}
	endif
	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

	" スニペット
	" 配置場所
	let g:neocomplcache_snippets_dir = '~/.vim/snippets'
	" スニペットを展開する。スニペットが関係しないところでは行末まで削除
	imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"
	smap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-o>D"

	" TABでスニペットを展開
"	imap  neocomplcache#plugin#snippets_complete#expandable() ? "\(neocomplcache_snippets_expand)" : "\"
"	smap  (neocomplcache_snippets_expand)

	" 前回行われた補完をキャンセルします
	inoremap <expr><C-g> neocomplcache#undo_completion()
	" 補完候補のなかから、共通する部分を補完します
	inoremap <expr><C-l> neocomplcache#complete_common_string()
	" 改行で補完ウィンドウを閉じる
	inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
	" tabで補完候補の選択を行う
	inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
	" <C-h>や<BS>を押したときに確実にポップアップを削除します
	inoremap <expr><C-h> neocomplcache#smart_close_popup().”\<C-h>”
	" 現在選択している候補を確定します
"	inoremap <expr><C-y> neocomplcache#close_popup()
	" 現在選択している候補をキャンセルし、ポップアップを閉じます
"	inoremap <expr><C-e> neocomplcache#cancel_popup()
" }}}

" NERDTree {{{
	"引数なしでvimを開いたらNERDTreeを起動、
	"引数ありならNERDTreeは起動しない、引数で渡されたファイルを開く。
	autocmd vimenter * if !argc() | NERDTree | endif
	"他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

	nnoremap <silent> <C-e>      :NERDTreeToggle<CR>
	vnoremap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
	onoremap <silent> <C-e>      :NERDTreeToggle<CR>
	inoremap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
	cnoremap <silent> <C-e> <C-u>:NERDTreeToggle<CR>

	"NERDTreeIgnore 無視するファイルを設定する。
	let g:NERDTreeIgnore = ['\.swp$', '\~$']
	"NERDTreeShowHidden 隠しファイルを表示するか？
	let g:NERDTreeShowHidden = 1
	"ブックマークや、ヘルプのショートカットをメニューに表示する。
	let g:NERDTreeMinimalUI = 1
	"NERDTreeを+|`などを使ってツリー表示をする。
	let g:NERDTreeDirArrows = 0

" }}}

" Ref.vim {{{
	let g:ref_alc_cmd = 'w3m -dump %s'
" }}}

" basic
syntax on
colorscheme desert
filetype plugin on
filetype indent on

"let mapleader = ","            " キーマップリーダー
set nobackup                   " バックアップ取らない
set hidden                     " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq         " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                   " ビープをならさない
set backspace=indent,eol,start " バックスペースでなんでも消せるように
set autoread                   " 他で書き換えられたら自動で読み直す
set whichwrap=b,s,h,l,<,>,[,]  " カーソルを行頭、行末で止まらないようにする
set scrolloff=5                " スクロール時の余白確保
set clipboard+=unnamed
set matchpairs=(:),{:},[:],<:> " %で移動できる対応括弧

" ステータスライン
set laststatus=2 " 常にステータスラインを表示
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" ステータスラインに日時を表示する
function! g:Date()
	return strftime("%x %H:%M")
endfunction

set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).'\|'.&ff.']'}\ \ %v,%l/%L\ (%P)\ %{b:charCounterCount}%m%=%{g:Date()}
"set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).'\|'.&ff.']'}\ \ %v,%l/%L\ (%P)%m%=%{strftime(\"%Y/%m/%d\ %H:%M\")}

" エンコーディング
set encoding=utf-8
set fileencodings=euc-jp,cp932,iso-2022-jp

" 画面表示
set showmatch         " 括弧の対応をハイライト
set matchtime=1       " 括弧の始めを表示する時間
set number            " 行番号表示
set list              " 不可視文字表示
set listchars=tab:>-,trail:- " 不可視文字の表現設定
"set listchars=tab:>-,trail:-,eol:<

" インデント
" set expandtab     " tab をスペースに展開
set shiftwidth=4  " 自動インデントの幅
set tabstop=4     " タブ幅

" 検索
set wrapscan     " 最後まで検索したら先頭へ戻る
set ignorecase   " 大文字小文字無視
set smartcase    " 大文字ではじめたら大文字小文字無視しない
set noincsearch  " インクリメンタルサーチOFF
set hlsearch     " 検索文字をハイライト

" 補完
set wildmenu           " コマンド補完を強化
set wildmode=list:full " リスト表示，最長マッチ
set history=100        " コマンド・検索パターンの履歴数

" キーマップ
" 行単位で移動(1行が長い場合に便利)
nnoremap j gj
nnoremap k gk
" Esc2回押しでハイライト解除
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

" 行頭,行末移動
"map! <C-a> <Home>
"map! <C-e> <End>

"inoremap <S-CR> <End>
"map! <S-Return> <End>

" ヘルプ
nnoremap <C-h> :<C-u>help<Space>
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><CR>

" US配列向け
nnoremap ; :
nnoremap : ;

" yank, paste with os clipboard http://relaxedcolumn.blog8.fc2.com/blog-entry-125.html
noremap <Space>y "+y
noremap <Space>p "+p

" 括弧の自動補完
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"vnoremap { "zdi^V{<C-R>z}<ESC>
"vnoremap [ "zdi^V[<C-R>z]<ESC>
"vnoremap ( "zdi^V(<C-R>z)<ESC>
"vnoremap " "zdi^V"<C-R>z^V"<ESC>
"vnoremap ' "zdi'<C-R>z'<ESC>

" 対応するカッコに移動
nnoremap [ %
nnoremap ] %

" Ctrl-hjklでウィンドウ移動
nnoremap <C-h> ;<C-h>j
nnoremap <C-j> ;<C-w>j
nnoremap <C-k> ;<C-k>j
nnoremap <C-l> ;<C-l>j

" F2で前のバッファ
"map <F2> <ESC>;bp<CR>
" F3で次のバッファ
"map <F3> <ESC>;bn<CR>
" F4でバッファを削除する
"map <F4> <ESC>;bw<CR>

" <command>
" insert mode
" \date で日付
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d (%a)')<CR>

