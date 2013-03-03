" vi互換モードを切る
set nocompatible

" autocmdを初期化
autocmd!

" 環境変数
let s:is_mac = has('macunix') || ( executable('uname') && system('uname') =~? '^darwin' )
let s:is_windows = has('win32') || has('win64')

" =============================================================================
" for plugin settings
" =============================================================================
" NeoBundle {{{
filetype off

" githubで使用するプロトコルをhttpsに
let g:neobundle_default_git_protocol='https'

if has('vim_starting')
	if isdirectory( expand( $HOME . '/.vim/.neobundle/neobundle.vim' ) )
		set runtimepath+=$HOME/.vim/.neobundle/neobundle.vim
	else
		set runtimepath+=$HOME/.vim/neobundle.vim.git
	endif
	call neobundle#rc( expand( $HOME . '/.vim/.neobundle' ) )
endif

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \   },
      \ }
NeoBundle 'Shougo/vimshell', {
      \ 'depends' : 'Shougo/vimproc'
      \ }
NeoBundle 'Shougo/vimfiler', {
      \ 'depends' : 'Shougo/unite.vim'
      \ }

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/vinarise'

NeoBundleLazy 'Shougo/vim-vcs', {
      \ 'depends' : 'thinca/vim-openbuf',
      \ 'autoload' : {'commands' : 'Vcs'},
      \ }
NeoBundle 'choplin/unite-vim_hacks', {
      \ 'depends' : 
      \    [ 'mattn/webapi-vim',
      \      'thinca/vim-openbuf',
      \      'mattn/wwwrenderer-vim'
      \    ]
      \ }


" neocomplcache
NeoBundle "Shougo/neocomplcache"
NeoBundle 'ujihisa/neco-look'
NeoBundle 'ujihisa/neco-ruby'
NeoBundle 'ujihisa/neco-ghc'

" neosnippet
NeoBundle 'Shougo/neosnippet'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-ssh'
NeoBundle 'hrsh7th/vim-unite-vcs'
NeoBundle 'pasela/unite-webcolorname'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'ujihisa/unite-font'
" NeoBundle 'sgur/unite-qf'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'osyo-manga/unite-filetype'
if s:is_windows
	NeoBundle 'sgur/unite-everything'
endif

"
" Filetypes
"
" ruby
NeoBundle 'tpope/vim-rails'
" NeoBundle 'tpope/vim-rake'
NeoBundle 'ujihisa/unite-rake', {
      \ 'depends' : 'Shougo/unite.vim'
	  \ }
NeoBundle 'basyura/unite-rails', {
      \ 'depends' : 'Shougo/unite.vim'
	  \ }
NeoBundleLazy 'vim-ruby/vim-ruby', { 'autoload' : {
      \ 'mappings' : '<Plug>(ref-keyword)',
      \ 'filetypes' : [ 'ruby', 'eruby' ]
      \ }}
NeoBundleLazy 'tpope/vim-haml', { 'autoload' : {
	  \ 'filetypes' : 'haml'
	  \ }}
NeoBundle 'semmons99/vim-ruby-matchit'
NeoBundleLazy 'taichouchou2/unite-reek', {
      \ 'build' : {
      \    'mac': 'gem install reek',
      \    'unix': 'gem install reek',
      \ },
      \ 'autoload': { 'filetypes': ['ruby', 'eruby', 'haml'] },
      \ 'depends' : 'Shougo/unite.vim' }

" javascript
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', { 'autoload' : {
      \ 'filetypes' : 'javascript',
      \ }}
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'autoload' : {
      \ 'filetypes' : 'javascript',
      \ }}
NeoBundle 'kchmck/vim-coffee-script'

" html/css
NeoBundle 'othree/html5.vim'
NeoBundle "mattn/zencoding-vim"
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'groenewege/vim-less'
NeoBundle 'cakebaker/scss-syntax.vim'
NeoBundle 'Rykka/colorv.vim'
NeoBundle 'jcf/vim-latex'

" Syntax Check
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vim-scripts/javacomplete'

" test
NeoBundle 'janx/vim-rubytest'
"NeoBundleLazy 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/vim-quickrun'

"
" misc
"
NeoBundle 'gtags.vim'
NeoBundle 'thinca/vim-ref', { 'autoload' : {
      \ 'commands' : 'Ref'
      \ }}
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'Align'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-endwise'
"NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'sudo.vim'
"NeoBundle 'othree/eregex.vim'
"NeoBundle 'kana/vim-smartchr'
"NeoBundle 'mileszs/ack.vim'
NeoBundle 'sjl/gundo.vim'
"NeoBundle 'anekos/char-counter-vim'
"NeoBundle 'thinca/vim-localrc'
"NeoBundle 'LeafCage/foldCC'
"NeoBundle 'kana/vim-fakeclip'
NeoBundle 'vim-scripts/Highlight-UnMatched-Brackets'

NeoBundle 'syngan/vim-pukiwiki'


" colorschemes
NeoBundle 'fugalh/desert.vim'
NeoBundle 'rainux/vim-desert-warm-256'
NeoBundle 'matthewtodd/vim-twilight'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'jnurmine/Zenburn'
NeoBundle 'jonathanfilip/vim-lucius'
NeoBundle 'vim-scripts/mrkn256.vim'
NeoBundle 'vim-scripts/Railscasts-Theme-GUIand256color'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'croaker/mustang-vim'
NeoBundle 'therubymug/vim-pyte'

NeoBundle 'Lokaltog/vim-powerline' " The ultimate vim statusline utility.

" recognize_charcode
if !has('kaoriya')
	NeoBundle 'banyan/recognize_charcode.vim'
endif
" }}}

" quickrun {{{
	nmap <Leader>r <Plug>(quickrun)
	let g:quickrun_config = {}
	let g:quickrun_config.javascript = { 'command': 'node' }
" }}}

" syntastic {{{
	" http://d.hatena.ne.jp/heavenshell/20120109/1326089510
	let g:syntastic_mode_map = {
		\ 'mode': 'active',
		\ 'active_filetypes': [ 'ruby', 'javascript', 'python', 'php', 'perl', 'css', 'html', 'json' ],
		\ 'passive_filetypes': []
		\ }
	let g:syntastic_auto_loc_list = 1
	let g:syntastic_echo_current_error = 1
	let g:syntastic_auto_jump = 0
	let g:syntastic_loc_list_height = 5
	let g:syntastic_javascript_checker = 'jshint'
" }}}

" unite.vim {{{
	" file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
	let g:unite_source_file_mru_filename_format = ''

	" バッファ一覧
	nnoremap <Leader>b :<C-u>Unite buffer<CR>
	" ファイル一覧
"	nnoremap <Leader>f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
	" レジスタ一覧
"	nnoremap <Leader>r :<C-u>Unite -buffer-name=register register<CR>
	" 最近使用したファイル一覧
"	nnoremap <Leader>m :<C-u>Unite file_mru<CR>
	" 常用セット
"	nnoremap <Leader>u :<C-u>Unite buffer file_mru<CR>
	" 全部乗せ
"	nnoremap <Leader>a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

	nnoremap <Leader>u :<C-u>Unite 

" }}}

" vimshell {{{
"	nnoremap <C-1> :VimShellPop<CR>
	nnoremap <silent><Leader>] :VimShellPop<CR>
" }}}

" vimfiler {{{
	"vimデフォルトのエクスプローラをvimfilerで置き換える
	let g:vimfiler_as_default_explorer = 1
	"セーフモードを無効にした状態で起動する
	let g:vimfiler_safe_mode_by_default = 0
	" カレントディレクトリを自動で同期
	let g:vimfiler_enable_auto_cd = 1

	autocmd! FileType vimfiler call g:my_vimfiler_settings()
	function! g:my_vimfiler_settings()
		nmap     <buffer>O             <Plug>(vimfiler_sync_with_current_vimfiler)
		nmap     <buffer>o             <Plug>(vimfiler_sync_with_another_vimfiler)
		nmap     <buffer><backspace>   <Plug>(vimfiler_switch_to_parent_directory)
		nmap     <buffer><Nul>         <Plug>(vimfiler_toggle_mark_current_line_up)
		nmap     <buffer><Left>        <Plug>(vimfiler_switch_to_other_window)
		nmap     <buffer><Right>       <Plug>(vimfiler_switch_to_other_window)
"		nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
"		nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
"		nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
	endfunction

	nnoremap <silent><leader>f :VimFiler<CR>

	" 現在開いているバッファのディレクトリを開く
"	nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir<CR>
"	nnoremap <silent> <Leader>fi :<C-u>VimFiler -split -simple -winwidth=35 -no-quit<CR>
	

" }}}

" neocomplcache {{{
	" 補完ウィンドウの設定
	set completeopt=menuone
	" 起動時に有効化
	let g:neocomplcache_enable_at_startup = 1
	" 大文字が入力されるまで大文字小文字の区別を無視する
	let g:neocomplcache_enable_smart_case = 1
	" _(アンダースコア)区切りの補完を有効化
	let g:neocomplcache_enable_underbar_completion = 1
	let g:neocomplcache_enable_camel_case_completion = 1
	" ポップアップメニューで表示される候補の数
	let g:neocomplcache_max_list = 20
	" シンタックスをキャッシュするときの最小文字長
	let g:neocomplcache_min_syntax_length = 3
	" 挿入モードのカーソル移動であんまり補完しないように
	let g:NeoComplCache_EnableSkipCompletion = 1
	let g:NeoComplCache_SkipInputTime = '0.5'
	" ディクショナリ定義
	let g:neocomplcache_dictionary_filetype_lists = {
		\ 'default' : '',
		\ 'ruby' : $HOME . '/.vim/dict/ruby.dict',
		\ 'c' : $HOME . '/.vim/dict/c.dict',
		\ 'cpp' : $HOME . '/.vim/dict/cpp.dict',
		\ 'php' : $HOME . '/.vim/dict/php.dict',
		\ 'javascript' : $HOME . '/.vim/dict/javascript.dict',
		\ 'perl' : $HOME . '/.vim/dict/perl.dict',
		\ 'java' : $HOME . '/.vim/dict/java.dict',
		\ }
	
	if !exists('g:neocomplcache_keyword_patterns')
		let g:neocomplcache_keyword_patterns = {}
	endif
	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'


	" カーソル上下で補完選択
	inoremap <expr><Up> pumvisible() ? neocomplcache#close_popup()."\<Up>" : "\<Up>"
	inoremap <expr><Down> pumvisible() ? neocomplcache#close_popup()."\<Down>" : "\<Down>"
	
	" 前回行われた補完をキャンセルします
	inoremap <expr><C-g> neocomplcache#undo_completion()
	
	" 補完候補のなかから、共通する部分を補完します
	inoremap <expr><C-l> neocomplcache#complete_common_string()
	
	" 改行で確定して補完ウィンドウを閉じる
"	inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"
	" endwiseと干渉するので http://d.hatena.ne.jp/tacahiroy/20111006/1317851233
	function! s:CrInInsertModeBetterWay()
		return pumvisible() ? neocomplcache#close_popup()."\<CR>" : "\<CR>"
	endfunction
"	inoremap <silent> <Cr> <C-R>=<SID>CrInInsertModeBetterWay()<Cr>
	inoremap <expr><silent><CR> CrInInsertModeBetterWay()

	" <TAB>で補完候補の選択
	inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
	inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
	
	" <C-h>や<BS>を押したときに確実にポップアップを削除します
	inoremap <expr><BS> neocomplcache#smart_close_popup() . "\<C-h>"
	
	" 現在選択している候補をキャンセルし、ポップアップを閉じます
"	inoremap <expr><C-e> neocomplcache#cancel_popup()
" }}}

" neosnippet {{{
	" 配置場所
	let g:neosnippet#snippets_directory = '~/.vim/snippets'
	" スニペットを展開する。スニペットが関係しないところでは行末まで削除
	imap <expr><C-k> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-o>D"
	smap <expr><C-k> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-o>D"
"	imap <C-k> <Plug>(neosnippet_start_unite_snippet)
"	smap <C-k> <Plug>(neosnippet_start_unite_snippet)
" }}}

" ColorV {{{
	let g:colorv_preview_ftype = 'css,scss,sass,less,html,javascript'
" }}}

" colorizer {{{
	" pluginによるmap設定をしない
"	let g:colorizer_nomap = 1
" }}}

" Gtags {{{
	map <F3> :GtagsCursor<CR>
"	map <C-n> :cn<CR>
"	map <C-p> :cp<CR>
" }}}

" Gundo {{{
	nnoremap U :<C-u>GundoToggle<CR>
" }}}

" buftabs {{{
	"バッファタブにパスを省略してファイル名のみ表示する
	let g:buftabs_only_basename=1
	" バッファタブをステータスライン内に表示する
"	let g:buftabs_in_statusline=1
	" 現在のバッファをハイライト
	let g:buftabs_active_highlight_group="Visual"
	" ステータスライン
"	set statusline=%=\ [%{(&fenc!=''?&fenc:&enc)}/%{&ff}]\[%Y]\[%04l,%04v][%p%%]
	" ステータスラインを常に表示
"	set laststatus=2
" }}}

" NERDTree {{{
	"引数なしでvimを開いたらNERDTreeを起動、
	"引数ありならNERDTreeは起動しない、引数で渡されたファイルを開く。
"	autocmd vimenter * if !argc() | NERDTree | endif
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
	
	let g:NERDTreeHijackNetrw = 0

" }}}

" NERDCommenter {{{
	let g:NERDCreateDefaultMappings = 0
	let NERDSpaceDelims = 1

	nmap <Leader>/ <Plug>NERDCommenterToggle
	vmap <Leader>/ <Plug>NERDCommenterToggle

"	nmap <Leader>/a <Plug>NERDCommenterAppend
"	nmap <leader>/9 <Plug>NERDCommenterToEOL
"	vmap <Leader>/s <Plug>NERDCommenterSexy
"	vmap <Leader>/b <Plug>NERDCommenterMinimal
" }}}

" Ref.vim {{{
	let g:ref_alc_cmd = 'w3m -dump %s'
" }}}

" smartchr {{{
"	inoremap <buffer> <expr> <S-=> smartchr#loop(' + ', '++')
"	inoremap <buffer> <expr> - smartchr#loop(' - ', '--')
"	inoremap <buffer> <expr> , smartchr#loop(', ', ',,')
" }}}

" vim-latex {{{
	set shellslash
	set grepprg=grep\ -nH\ $*
	let g:tex_flavor='latex'
	let g:Imap_UsePlaceHolders = 1
	let g:Imap_DeleteEmptyPlaceHolders = 1
	let g:Imap_StickyPlaceHolders = 0
	let g:Tex_DefaultTargetFormat = 'pdf'
	let g:Tex_FormatDependency_ps = 'dvi,ps'
	let g:Tex_FormatDependency_pdf = 'dvi,pdf'
	let g:Tex_CompileRule_dvi = '/usr/texbin/platex -synctex=1 -interaction=nonstopmode $*'
	let g:Tex_CompileRule_ps = '/usr/texbin/dvips -Ppdf -o $*.ps $*.dvi'
	let g:Tex_CompileRule_pdf = '/usr/texbin/dvipdfmx $*.dvi'
"	let g:Tex_CompileRule_pdf = '/usr/texbin/pdflatex $*.tex'
"	let g:Tex_CompileRule_pdf = '/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode $*'
	let g:Tex_BibtexFlavor = '/usr/texbin/pbibtex'
	let g:Tex_MakeIndexFlavor = '/usr/texbin/mendex $*.idx'
	let g:Tex_UseEditorSettingInDVIViewer = 1
	let g:Tex_ViewRule_dvi = '/usr/bin/open -a PictPrinter.app'
"	let g:Tex_ViewRule_dvi = '/usr/bin/open -a Skim.app'
	let g:Tex_ViewRule_ps = '/usr/local/bin/gv --watch'
	let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview.app'
"	let g:Tex_ViewRule_pdf = '/usr/bin/open -a Skim.app'
	"let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXShop.app'
	"let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXworks.app'
	"let g:Tex_ViewRule_pdf = '/usr/bin/open -a "Adobe Reader.app"'
" }}}

" vim-powerline {{{
	let g:Powerline_mode_n = 'NORMAL'
	" http://d.hatena.ne.jp/itchyny/20120609/1339249777
" }}}

" simple-javascript-indenter {{{
	let g:SimpleJsIndenter_BriefMode = 1
	let g:SimpleJsIndenter_CaseIndentLevel = -1
" }}}

"
" macros
"
source $VIMRUNTIME/macros/matchit.vim
let b:match_words = "if:endif,foreach:endforeach,\<begin\>:\<end\>"

"
" colorschemes
"
let g:jellybeans_overrides = {
\    'Todo': { 'guifg': '303030', 'guibg': 'f0f000',
\              'ctermfg': 'Black', 'ctermbg': 'Yellow',
\              'attr': 'bold' },
\}


"
" basic
"
syntax on
colorscheme jellybeans
filetype plugin indent on

" ファイルタイプ追加
autocmd BufNewFile,BufRead *.nb set filetype=ruby
autocmd BufNewFile,BufRead *.json set filetype=json

" Rubyのタブ幅を2にする。
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2
autocmd FileType eruby setlocal tabstop=2 shiftwidth=2

" デフォルトvimrc_exampleのtextwidth設定上書き
autocmd FileType text setlocal textwidth=0

"let mapleader = ','
"let mapleader = '\'

if has('kaoriya')
	set imdisable " IMEを制御させない
endif

set lazyredraw " スクリプト実行中に再描画しない
set ttyfast    " 高速ターミナル接続

set nobackup                   " バックアップ取らない
set hidden                     " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq         " テキスト整形オプション，マルチバイト系を追加
set formatoptions+=mM          " 日本語の行を連結時には空白を入力しない
set vb t_vb=                   " ビープをならさない
set backspace=indent,eol,start " バックスペースでなんでも消せるように
"set autoread                   " 他で書き換えられたら自動で読み直す
set whichwrap=b,s,h,l,<,>,[,]  " カーソルを行頭、行末で止まらないようにする
set scrolloff=5                " スクロール時の余白確保
set matchpairs+=<:> " %で移動できる対応括弧
"set foldtext=FoldCCtext()      " 畳み
" set foldmethod=marker
set clipboard=unnamed,autoselect

" https://github.com/amothic/dotfiles/blob/master/.vimrc
" キーコードはすぐにタイムアウトし、マッピングはタイムアウトしない
set notimeout ttimeout ttimeoutlen=200

" 全角記号が、半角幅で表示されるのを防ぐ
" MacでTerminal.appを使っている場合は、下記も必要
" https://kita.dyndns.org/wiki/?TerminalEastAsianAmbiguousClearer
" https://github.com/Nyoho/TerminalEastAsianAmbiguousClearer
if exists('&ambiwidth')
	set ambiwidth=double
endif

" http://vim-users.jp/2009/06/hack32/
set directory-=.
" http://vim-users.jp/2010/07/hack162/
if has('persistent_undo')
	set undodir=~/.vimundo
	augroup vimrc-undofile
		autocmd!
		autocmd BufReadPre ~/* setlocal undofile
	augroup END
endif


"
" statusline
"
set cmdheight=2 " コマンド行の高さ
set laststatus=2 " 常にステータスラインを表示

" 日時を表示
function! g:Date()
	return strftime("%x %H:%M")
endfunction

"set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).'\|'.&ff.']'}\ \ %v,%l/%L\ (%P)\ %m%=%{g:Date()}
"set statusline=%<%F\ %r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).'\|'.&ff.']'}\ \ %v,%l/%L\ (%P)\ %{b:charCounterCount}%m%=%{g:Date()}
" 確認用
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]


"
" encoding
"
if s:is_windows
	set termencoding=sjis
else
	set encoding=utf-8
	set termencoding=utf-8
endif
set fileencodings=utf-8,euc-jp,cp932,iso-2022-jp
set fileformats=unix,dos,mac


"
" display
"
set textwidth=0       " 入力されているテキストの最大幅
set nowrap            " 行をウィンドウ幅で折り返さない
"set display+=lastline " 画面最後の行をできる限り表示する
"set showmatch         " 括弧の対応をハイライト
set matchtime=0       " 括弧の始めを表示する時間
set number            " 行番号表示
set list              " 不可視文字表示
"set listchars=tab:>-,trail:-,eol:<
set listchars=tab:>-,trail:- " 不可視文字の表現設定
set cmdheight=2       " コマンドラインの表示行数

"全角スペースを目立たせる
"以下の設定だと赤い下線になる
"highlight ZenkakuSpace cterm=underline ctermfg=red guibg=white
"match ZenkakuSpace /　/

"
" indent
"
"set smartindent
set shiftwidth=4  " 自動インデントの幅
set tabstop=4     " タブ幅
" コメントのオートインデントを止める
" http://d.hatena.ne.jp/dayflower/20081208/1228725403
if has("autocmd")
  autocmd FileType *
    \ let &l:comments
          \=join(filter(split(&l:comments, ','), 'v:val =~ "^[sme]"'), ',')
endif

"
" search
"
set wrapscan     " 最後まで検索したら先頭へ戻る
set ignorecase   " 大文字小文字無視
set smartcase    " 大文字ではじめたら大文字小文字無視しない
set noincsearch  " インクリメンタルサーチOFF
set hlsearch     " 検索文字をハイライト


"
" complement
"
set wildmenu           " コマンド補完を強化
set wildmode=list:full " リスト表示，最長マッチ
set history=100        " コマンド・検索パターンの履歴数


"
" keymap
"
" 行単位で移動
nnoremap j gj
nnoremap k gk

inoremap <C-b> <PageUp>
inoremap <C-f> <PageDown>

" 括弧の補完
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>

" Esc2回押しでハイライト解除
nmap <silent> <ESC><ESC> ;nohlsearch<CR><ESC>

"バッファ
noremap <Leader>n :bnext<CR>
noremap <Leader>p :bprevious<CR>

" 行頭、行末へ移動
map! <C-a> <Home>
map! <C-e> <End>

" ヘルプ
"nnoremap <C-h> :<C-u>help<Space>
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><CR>

" US配列向け
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Ctrl-hjklでウィンドウ移動
"nnoremap <C-h> ;<C-h>j
"nnoremap <C-j> ;<C-w>j
"nnoremap <C-k> ;<C-k>j
"nnoremap <C-l> ;<C-l>j

"
" autocmd
"
" ファイルを開くとそのファイルの位置にカレントディレクトリを変更
augroup BufferAu
	autocmd!
	" カレントディレクトリを自動的に移動
	autocmd BufNewFile,BufRead,BufEnter * if isdirectory(expand("%:p:h")) && bufname("%") !~ "NERD_tree" | cd %:p:h | endif
augroup END

augroup SkeletonAu
	autocmd!
	autocmd BufNewFile *.html 0r $HOME/.vim/template/skel.html
	autocmd BufNewFile *.rb 0r $HOME/.vim/template/skel.rb
augroup END

" quickfixを自動で開く
" http://webtech-walker.com/archive/2009/09/29213156.html
"autocmd QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | endif
"autocmd QuickFixCmdPost * Unite qf

"
" command
"
" 文字エンコーディングを指定して、ファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8

command! Jis Iso2022jp
command! Sjis Cp932

" https://github.com/ujihisa/config/blob/master/_vimrc
command! SplitNicely call s:split_nicely() " {{{
function! s:split_nicely()
	if 80*2 * 15/16 <= winwidth(0) " FIXME: threshold customization
		vsplit
	else
		split
	endif
endfunction
" }}}

" load ~/.vimrc.local
if filereadable(expand('$HOME/.vimrc.local'))
	source ~/.vimrc.local
endif

