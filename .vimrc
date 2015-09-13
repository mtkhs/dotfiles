" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

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

if has('vim_starting')
	if &compatible
		set nocompatible               " Be iMproved
	endif
	if !isdirectory(expand( $HOME . "/.vim/.neobundle/neobundle.vim/"))
		echo "install neobundle..."
		:call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/.neobundle/neobundle.vim")
	endif
	set runtimepath+=$HOME/.vim/.neobundle/neobundle.vim/
endif

call neobundle#begin( expand( $HOME . "/.vim/.neobundle/") )

" githubで使用するプロトコルをhttpsに
let g:neobundle_default_git_protocol='https'

NeoBundleFetch 'Shougo/neobundle.vim'

function! s:meet_neocomplete_requirements()
	return has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
endfunction

if s:meet_neocomplete_requirements()
	NeoBundleLazy 'Shougo/neocomplete.vim', {
      \ 'depends' : 'Shougo/context_filetype.vim',
      \ 'insert' : 1
      \ }
	NeoBundleFetch 'Shougo/neocomplcache'
else
	NeoBundleLazy 'Shougo/neocomplcache', {
	  \   'autoload' : {
	  \     'commands' : 'NeoComplCacheEnable'
	  \   }
	  \ }
	NeoBundleFetch 'Shougo/neocomplete'
endif
NeoBundle 'ujihisa/neco-look'

NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \   },
      \ }


" neosnippet
NeoBundle 'Shougo/neosnippet.vim', {
      \ 'lazy' : 1,
      \ 'depends' : ['Shougo/neosnippet-snippets', 'Shougo/context_filetype.vim'],
      \ 'insert' : 1,
      \ 'filetypes' : 'snippet',
      \ 'unite_sources' : [
      \ 'neosnippet', 'neosnippet/user', 'neosnippet/runtime'],
      \ }
NeoBundle 'Shougo/unite.vim', {
      \ 'lazy' : 1,
      \ 'commands' : [{ 'name' : 'Unite',
      \ 'complete' : 'customlist,unite#complete_source'}],
      \ 'depends' : 'Shougo/neomru.vim',
      \ }
NeoBundle 'Shougo/unite-build', {
      \ 'lazy' : 1
      \ }
NeoBundleLazy 'Shougo/neossh.vim', {
      \ 'filetypes' : 'vimfiler',
      \ 'sources' : 'ssh',
      \ }
NeoBundleLazy 'ujihisa/vimshell-ssh', {
      \ 'filetypes' : 'vimshell',
      \ }
NeoBundleLazy 'Shougo/vim-vcs', {
      \ 'depends' : 'thinca/vim-openbuf',
      \ }
NeoBundle 'tpope/vim-fugitive'
NeoBundleLazy 'Shougo/vimfiler.vim', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'commands' : [
      \ { 'name' : ['VimFiler', 'Edit', 'Write'],
      \ 'complete' : 'customlist,vimfiler#complete' },
      \ 'Read', 'Source'],
      \ 'mappings' : '<Plug>',
      \ 'explorer' : 1,
      \ }
NeoBundleLazy 'Shougo/vimshell.vim', {
      \ 'commands' : [{ 'name' : 'VimShell',
      \ 'complete' : 'customlist,vimshell#complete'},
      \ ],
      \ 'mappings' : '<Plug>'
      \ }
NeoBundleLazy 'yomi322/vim-gitcomplete', {
      \ 'filetype' : 'vimshell'
      \ }
NeoBundleLazy 'Shougo/vinarise.vim', {
      \ 'commands' : [{
      \ 'name' : 'Vinarise', 'complete' : 'file'
      \ }]
      \ }
NeoBundle 'Shougo/unite-sudo'
NeoBundle 'pasela/unite-webcolorname', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'unite_sources' : 'webcolorname',
      \ }}
NeoBundle 'ujihisa/unite-colorscheme', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'unite_sources' : 'colorscheme',
      \ }}
NeoBundle 'ujihisa/unite-locate', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'unite_sources' : 'locate',
      \ }}
NeoBundle 'ujihisa/unite-font', {
      \ 'lazy' : 1,
      \ 'gui' : 1,
      \ 'autoload' : {
      \ 'unite_sources' : 'font'
      \ }}
" NeoBundle 'sgur/unite-qf'
NeoBundle 'osyo-manga/unite-quickfix', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'unite_sources' : 'quickfix',
      \ }}
NeoBundle 'osyo-manga/unite-filetype', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'unite_sources' : 'filetype',
      \ }}
if s:is_windows
	NeoBundle 'sgur/unite-everything'
endif

NeoBundle 'thinca/vim-quickrun', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['nxo', '<Plug>(quickrun)']],
      \ }}

"
" Filetypes
"
" ruby
"NeoBundle 'tpope/vim-rake'
"NeoBundle 'ujihisa/unite-rake'
"NeoBundle 'tpope/vim-rails'
"NeoBundle 'basyura/unite-rails'
NeoBundle 'vim-ruby/vim-ruby', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'mappings' : '<Plug>(ref-keyword)',
      \ 'filetypes' : [ 'ruby', 'eruby' ]
      \ }}
NeoBundle 'tpope/vim-haml', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : [ 'haml' ]
      \ }}
NeoBundle 'semmons99/vim-ruby-matchit', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : [ 'ruby', 'eruby']
      \ }}
NeoBundle 'evidens/vim-twig'

" javascript
NeoBundle 'jiangmiao/simple-javascript-indenter', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'javascript',
      \ }}
NeoBundle 'jelera/vim-javascript-syntax', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'javascript',
      \ }}
NeoBundle 'kchmck/vim-coffee-script', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetype' : 'coffee'
      \ }}

" html/css
NeoBundle 'othree/html5.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'html'
      \ }}
NeoBundle 'mattn/emmet-vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : ['html', 'php', 'twig']
      \ }}
NeoBundle 'hail2u/vim-css3-syntax', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'css'
      \ }}
NeoBundle 'groenewege/vim-less', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'less'
      \ }}
NeoBundle 'cakebaker/scss-syntax.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'scss'
      \ }}
NeoBundle 'Rykka/colorv.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : ['css', 'scss', 'sass', 'less', 'html', 'haml', 'javascript']
      \ }}

NeoBundle 'jcf/vim-latex', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'tex'
      \ }}

NeoBundle 'vim-jp/cpp-vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'cpp'
      \ }}
NeoBundle 'mattn/jscomplete-vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'filetypes' : 'javascript'
      \ }}

" Syntax Check
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vim-scripts/javacomplete'
NeoBundle 'janx/vim-rubytest'

"
" misc
"
if has("unix") || has("mac")
	NeoBundle 'vim-scripts/gtags.vim', 
		\ { "autoload" : { "filetypes" : [ "c", "cpp" ] } }
	NeoBundle 'vim-scripts/sudo.vim'
endif
NeoBundle 'thinca/vim-ref', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'commands' : 'Ref'
      \ }}
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'Align'
NeoBundle 'ntpeters/vim-better-whitespace'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'vim-scripts/DoxygenToolkit'
"NeoBundle 'Yggdroot/indentLine'
"NeoBundle 'tpope/vim-surround'
NeoBundle 'anyakichi/vim-surround', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'mappings' : [
      \ ['n', '<Plug>Dsurround'], ['n', '<Plug>Csurround'],
      \ ['n', '<Plug>Ysurround'], ['n', '<Plug>YSurround']
      \ ]}}
NeoBundleLazy 'tpope/vim-endwise', {
      \ 'autoload' : { 'insert' : 1 }
      \ }
NeoBundle 'Townk/vim-autoclose'
"NeoBundle 'h1mesuke/vim-alignta'
" NeoBundle 'othree/eregex.vim'
"NeoBundle 'kana/vim-smartchr'
"NeoBundle 'mileszs/ack.vim'
NeoBundle 'sjl/gundo.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \ 'commands' : 'GundoToggle'
      \ }}
"NeoBundle 'anekos/char-counter-vim'
"NeoBundle 'thinca/vim-localrc'
"NeoBundle 'LeafCage/foldCC'
"NeoBundle 'kana/vim-fakeclip'
NeoBundle 'vim-scripts/Highlight-UnMatched-Brackets'
NeoBundle 'mattn/benchvimrc-vim'
"NeoBundle 'syngan/vim-pukiwiki'

" colorschemes
"NeoBundle 'fugalh/desert.vim'
"NeoBundle 'rainux/vim-desert-warm-256'
"NeoBundle 'matthewtodd/vim-twilight'
"NeoBundle 'altercation/vim-colors-solarized'
"NeoBundle 'jnurmine/Zenburn'
"NeoBundle 'jonathanfilip/vim-lucius'
"NeoBundle 'vim-scripts/mrkn256.vim'
"NeoBundle 'vim-scripts/Railscasts-Theme-GUIand256color'
"NeoBundle 'jpo/vim-railscasts-theme'
"NeoBundle 'nanotech/jellybeans.vim'
"NeoBundle 'croaker/mustang-vim'
"NeoBundle 'therubymug/vim-pyte'
"NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'

" statusline
"NeoBundle 'Lokaltog/vim-powerline' " The ultimate vim statusline utility.
"NeoBundle 'bling/vim-airline'
NeoBundle 'itchyny/lightline.vim'


" indentLine {{{
	let g:indentLine_faster = 1
	nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
" }}}

" lightline {{{
let g:lightline = {
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? "\ue0a2" : ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
        \  &ft == 'unite' ? unite#get_status_string() : 
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? "\ue0a0 "._ : ''
  endif
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction
" }}}

" recognize_charcode {{{
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
let g:syntastic_php_checkers = ['phpcs']
let g:syntastic_check_on_open = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_auto_jump = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_javascript_checker = 'jshint'
let g:syntastic_c_include_dirs = [ '../include', 'include' ]
let g:syntastic_php_php_args = '-l'
let g:syntastic_php_phpcs_args='--standard=psr2'
let g:syntastic_php_checkers = ['phpcs']
" }}}

" unite.vim {{{
" file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される
let g:unite_source_file_mru_filename_format = ''

" バッファ一覧
nnoremap <Leader>b :<C-u>Unite buffer<CR>
" ファイル一覧
"nnoremap <Leader>f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
"nnoremap <Leader>r :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
"nnoremap <Leader>m :<C-u>Unite file_mru<CR>
" 常用セット
"nnoremap <Leader>u :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
"nnoremap <Leader>a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

nnoremap <Leader>u :<C-u>Unite 
" }}}

" vimshell {{{
"nnoremap <C-1> :VimShellPop<CR>
nnoremap <silent><Leader>] :VimShellPop<CR>
nnoremap <silent><Leader>s :VimShell<CR>
" }}}

" vimfiler {{{
"vimデフォルトのエクスプローラをvimfilerで置き換える
let g:vimfiler_as_default_explorer = 1
"セーフモードを無効にした状態で起動する
let g:vimfiler_safe_mode_by_default = 0
" カレントディレクトリを自動で同期
let g:vimfiler_enable_auto_cd = 1

autocmd! FileType vimfiler call g:My_vimfiler_settings()
function! g:My_vimfiler_settings()
	nmap     <buffer>O             <Plug>(vimfiler_sync_with_current_vimfiler)
	nmap     <buffer>o             <Plug>(vimfiler_sync_with_another_vimfiler)
	nmap     <buffer><backspace>   <Plug>(vimfiler_switch_to_parent_directory)
	nmap     <buffer><Nul>         <Plug>(vimfiler_toggle_mark_current_line_up)
	nmap     <buffer><Left>        <Plug>(vimfiler_switch_to_other_window)
	nmap     <buffer><Right>       <Plug>(vimfiler_switch_to_other_window)
"	nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
"	nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
"	nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
endfunction

nnoremap <silent><leader>f :VimFiler -split -simple<CR>

"nnoremap <silent> <Leader>fe :<C-u>VimFilerBufferDir<CR>
"nnoremap <silent> <Leader>fi :<C-u>VimFiler -split -simple -winwidth=35 -no-quit<CR>
" }}}

if s:meet_neocomplete_requirements()
" neocomplete {{{

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" }}}

" neosnippet {{{
" 配置場所
let g:neosnippet#snippets_directory = '~/.vim/snippets'
" スニペットを展開する。スニペットが関係しないところでは行末まで削除
imap <expr><C-k> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-o>D"
smap <expr><C-k> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-o>D"
"imap <C-k> <Plug>(neosnippet_start_unite_snippet)
"smap <C-k> <Plug>(neosnippet_start_unite_snippet)
" }}}
else
" neocomplcache {{{

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" }}}
endif

" Emmet {{{
let g:user_emmet_settings = {
	\   'lang' : 'ja'
	\ }
" }}}

" ColorV {{{
let g:colorv_preview_ftype = 'css,scss,sass,less,html,javascript'
" }}}

" Gtags {{{
map <F3> :GtagsCursor<CR>
"map <C-n> :cn<CR>
"map <C-p> :cp<CR>
" }}}

" Gundo {{{
nnoremap U :<C-u>GundoToggle<CR>
" }}}

" NERDCommenter {{{
let g:NERDCreateDefaultMappings = 0
let NERDSpaceDelims = 1

nmap <Leader>/ <Plug>NERDCommenterToggle
vmap <Leader>/ <Plug>NERDCommenterToggle

"nmap <Leader>/a <Plug>NERDCommenterAppend
"nmap <leader>/9 <Plug>NERDCommenterToEOL
"vmap <Leader>/s <Plug>NERDCommenterSexy
"vmap <Leader>/b <Plug>NERDCommenterMinimal
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
"let g:Tex_CompileRule_pdf = '/usr/texbin/pdflatex $*.tex'
"let g:Tex_CompileRule_pdf = '/usr/texbin/pdflatex -synctex=1 -interaction=nonstopmode $*'
let g:Tex_BibtexFlavor = '/usr/texbin/pbibtex'
let g:Tex_MakeIndexFlavor = '/usr/texbin/mendex $*.idx'
let g:Tex_UseEditorSettingInDVIViewer = 1
let g:Tex_ViewRule_dvi = '/usr/bin/open -a PictPrinter.app'
"let g:Tex_ViewRule_dvi = '/usr/bin/open -a Skim.app'
let g:Tex_ViewRule_ps = '/usr/local/bin/gv --watch'
let g:Tex_ViewRule_pdf = '/usr/bin/open -a Preview.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a Skim.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXShop.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a TeXworks.app'
"let g:Tex_ViewRule_pdf = '/usr/bin/open -a "Adobe Reader.app"'
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

call neobundle#end()

NeoBundleCheck

"
" basic
"
if has("syntax")
	syntax on
endif
colorscheme Tomorrow-Night

filetype plugin indent on

" ファイルタイプ追加
autocmd BufNewFile,BufRead *.nb set filetype=ruby
autocmd BufNewFile,BufRead *.json set filetype=json
autocmd BufNewFile,BufRead *.haml set filetype=haml
autocmd BufNewFile,BufRead *.tex set filetype=tex

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

set t_Co=256
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

"
" コメントのオートインデントを止める
" http://d.hatena.ne.jp/dayflower/20081208/1228725403
"
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

"
" sudo.vimを使わないでvimでsudoを使ってのファイル保存
" http://secondlife.hatenablog.jp/entry/20050428/1114685380
"
cmap w!! w !sudo tee > /dev/null %

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

"
" quickfixを自動で開く
" http://webtech-walker.com/archive/2009/09/29213156.html
"
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

