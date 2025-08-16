"
" Basic
"
if &compatible
  set nocompatible
endif

set encoding=utf-8
set fileencoding=&encoding
set fileencodings=usc-bom,utf-8,iso-2022-jp,cp932,euc-jp,sjis,default,latin
set fileformats=unix
set fileformats=unix,dos,mac
if exists('&ambiwidth')
  set ambiwidth=double
endif

language message C

set autochdir
set hidden
set noundofile
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

set t_vb=
set novisualbell

"
" Search
"
set ignorecase
set infercase
set smartcase
set incsearch
set wrapscan

"
" Edit
"
set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

set indentexpr=
set autoindent smartindent
set modeline

set backspace=indent,eol,start
set showmatch
set cpoptions-=m
set matchtime=1

set matchpairs+=<:>
set virtualedit=block

"
" View
"
set number
set list
set listchars=tab:>-,trail:-
set laststatus=2
set cmdheight=2
set noshowcmd

let &g:statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
      \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
      \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
      \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?
      \ '['.(&filetype!=''?&filetype.',':'')"
      \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
      \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"

set showtabline=2

set linebreak
set showbreak=\
set breakat=\ \>;:,!?

set whichwrap+=h,l,<,>,[,],b,s,~
if exists('+breakindent')
  set breakindent
  set wrap
else
  set nowrap
endif

set nofoldenable

set nowildmenu
set wildmode=list:longest,full
set history=1000
set showfulltag
set nostartofline
set splitbelow
set splitright
set winwidth=30
set winheight=1
set cmdwinheight=5
set noequalalways

set keywordprg=:help
set previewheight=8
set helpheight=12

set ttyfast
set lazyredraw

set display=lastline

" auto-cursorline
let s:cl_disabled = 0
let s:cl_cursor = 1
let s:cl_win = 2
let s:cl_status = s:cl_disabled
function! s:auto_cursorline(e)
  if a:e ==# 'WinEnter'
    setlocal cursorline
    let s:cl_status = s:cl_win
  elseif a:e ==# 'WinLeave'
    setlocal nocursorline
  elseif a:e ==# 'CursorMoved'
    if s:cl_status == s:cl_disabled
      return
    elseif s:cl_status == s:cl_win
      let s:cl_status = s:cl_cursor
    else
      setlocal nocursorline
      let s:cl_status = s:cl_disabled
    endif
  elseif a:e ==# 'CursorHold'
    setlocal cursorline
    let s:cl_status = s:cl_cursor
  endif
endfunction

augroup auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')
augroup END

"
" Mappings
"
xnoremap <TAB>  >
xnoremap <S-TAB>  <
nnoremap Q  q
nnoremap ZZ  <Nop>

nnoremap <ESC><ESC> :nohlsearch<CR><ESC>
xnoremap s :s//g<Left><Left>

nmap <F2> <ESC>:bp<CR>
nmap <F3> <ESC>:bn<CR>
nmap <C-S-Tab> <ESC>:bp<CR>
nmap <C-Tab> <ESC>:bn<CR>

"
" Command
"
cmap w!! w !sudo tee > /dev/null %

"
" Unix
"
set shell=sh
let $PATH = expand('~/bin').':/usr/local/bin/:'.$PATH
set mouse=

if exists('+termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

colorscheme evening

"
" Syntax
"
filetype plugin indent on
syntax enable

