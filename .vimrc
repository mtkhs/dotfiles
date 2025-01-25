"---------------------------------------------------------------------------
" .vimrc
"---------------------------------------------------------------------------

" TODO: use legacy .vimrc if vim version <= 7.4

"---------------------------------------------------------------------------
" Initialize:
"

if &compatible
  set nocompatible
endif

function! s:source_rc(path, ...) abort
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand('~/.vim/rc/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
"  let content = map(readfile(abspath),
"        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
"  let tempfile = tempname()
"  try
"    call writefile(content, tempfile)
"    execute 'source' fnameescape(tempfile)
"  finally
"    if filereadable(tempfile)
"      call delete(tempfile)
"    endif
"  endtry
endfunction

syntax off
filetype plugin indent off

augroup MyAutoCmd
  autocmd!
augroup END

if has('vim_starting')
  call s:source_rc('init.rc.vim')
endif

call s:source_rc('dein.rc.vim')

"if has('vim_starting') && !empty(argv())
"  call vimrc#on_filetype()
"endif

"if !has('vim_starting')
"  call dein#call_hook('source')
"  call dein#call_hook('post_source')

"  syntax enable
"  filetype plugin indent on
"endif

"---------------------------------------------------------------------------
" Encoding:
"

call s:source_rc('encoding.rc.vim')

"---------------------------------------------------------------------------
" Search:
"

call s:source_rc('search.rc.vim')

"---------------------------------------------------------------------------
" Edit:
"

call s:source_rc('edit.rc.vim')

"---------------------------------------------------------------------------
" View:
"

call s:source_rc('view.rc.vim')

"---------------------------------------------------------------------------
" FileType:
"

"---------------------------------------------------------------------------
" Mappings:
"

call s:source_rc('mappings.rc.vim')

" sudo write
cmap w!! w !sudo tee > /dev/null %

"---------------------------------------------------------------------------
" Commands:
"

"autocmd MyAutoCmd BufEnter * silent! lcd %:p:h
"autocmd MyAutoCmd BufEnter * execute ":lcd " . expand("%:p:h")

function! s:ChangeCurrentDirectory()
  let l:dir = expand("%:p:h")
  if isdirectory(fnamemodify(l:dir, ":p"))
    execute printf('lcd `=%s`', string(fnamemodify(l:dir, ":p")))
  endif
endfunction
autocmd BufEnter * call s:ChangeCurrentDirectory()

"---------------------------------------------------------------------------
" Platform:
"

if has('nvim')
  call s:source_rc('neovim.rc.vim')
endif

if IsWindows()
  call s:source_rc('windows.rc.vim')
else
  call s:source_rc('unix.rc.vim')
endif

if !has('nvim') && has('gui_running')
  call s:source_rc('gui.rc.vim')
endif

"---------------------------------------------------------------------------
" Syntax On:
"

filetype plugin indent on
syntax enable

"---------------------------------------------------------------------------
" Others:
"

" If true Vim master, use English help file.
set helplang& helplang=ja,en

" Default home directory.
let t:cwd = getcwd()

set secure

" colorscheme_transparent
"if !has('gui_running')
"  augroup colorscheme_transparent
"    autocmd!
"    autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
"    autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
"    autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
"    autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
"    autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none
"    autocmd VimEnter,ColorScheme * highlight Identifier ctermbg=none
"  augroup END
"endif

augroup SkeletonAu
  autocmd!
  autocmd BufNewFile *.html 0r $HOME/.vim/template/skel.html
  autocmd BufNewFile *.rb 0r $HOME/.vim/template/skel.rb
augroup END

