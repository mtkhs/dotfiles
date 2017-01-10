"---------------------------------------------------------------------------
" .vimrc
"---------------------------------------------------------------------------

"---------------------------------------------------------------------------
" Initialize:
"

if &compatible
  set nocompatible
endif

function! s:source_rc(path, ...) abort "{{{
  let use_global = get(a:000, 0, !has('vim_starting'))
  let abspath = resolve(expand('~/.vim/rc/' . a:path))
  if !use_global
    execute 'source' fnameescape(abspath)
    return
  endif

  " substitute all 'set' to 'setglobal'
  let content = map(readfile(abspath),
        \ 'substitute(v:val, "^\\W*\\zsset\\ze\\W", "setglobal", "")')
  " create tempfile and source the tempfile
  let tempfile = tempname()
  try
    call writefile(content, tempfile)
    execute printf('source %s', fnameescape(tempfile))
  finally
    if filereadable(tempfile)
      call delete(tempfile)
    endif
  endtry
endfunction"}}}

augroup MyAutoCmd
  autocmd!
augroup END

if has('vim_starting')
  call s:source_rc('init.rc.vim')
endif

call s:source_rc('dein.rc.vim')

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')

  syntax enable
  filetype plugin indent on
endif


"---------------------------------------------------------------------------
" Encoding:
"

call s:source_rc('encoding.rc.vim')


"---------------------------------------------------------------------------
" Search:
"

" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
set incsearch
" Don't highlight search result.
set nohlsearch

" Searches wrap around the end of the file.
set wrapscan


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

autocmd MyAutoCmd FileType,Syntax,BufNewFile,BufNew,BufRead
      \ * call s:my_on_filetype()
function! s:my_on_filetype() abort "{{{
  if &l:filetype == '' && bufname('%') == ''
    return
  endif

  redir => filetype_out
  silent! filetype
  redir END
  if filetype_out =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction "}}}
call s:my_on_filetype()

" Add file types.
augroup filetypedetect
"  autocmd!
  autocmd BufNewFile,BufRead *.nb set filetype=ruby
  autocmd BufNewFile,BufRead *.json set filetype=json
  autocmd BufNewFile,BufRead *.haml set filetype=haml
  autocmd BufNewFile,BufRead *.tex set filetype=tex
  autocmd BufNewFile,BufRead *.scala set filetype=scala
  autocmd BufNewFile,BufRead *.mkd,*.markdown,*.md set filetype=markdown
  autocmd FileType ruby setlocal tabstop=2 shiftwidth=2
  autocmd FileType eruby setlocal tabstop=2 shiftwidth=2
augroup END

"---------------------------------------------------------------------------
" Mappings:
"

call s:source_rc('mappings.rc.vim')


"---------------------------------------------------------------------------
" Commands:
"

" Display diff with the file.
command! -nargs=1 -complete=file Diff vertical diffsplit <args>
" Disable diff mode.
command! -nargs=0 Undiff setlocal nodiff noscrollbind wrap


"---------------------------------------------------------------------------
" Platform:
"

"if has('nvim')
"  call s:source_rc('neovim.rc.vim')
"endif

if IsWindows()
  call s:source_rc('windows.rc.vim')
else
  call s:source_rc('unix.rc.vim')
endif

if !has('nvim') && has('gui_running')
  call s:source_rc('gui.rc.vim')
endif


"---------------------------------------------------------------------------
" Others:
"

" If true Vim master, use English help file.
set helplang& helplang=en,ja

" Default home directory.
let t:cwd = getcwd()

set secure

" colorscheme_transparent
if !has('gui_running')
  augroup colorscheme_transparent
    autocmd!
    autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
    autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
    autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
    autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
    autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none
    autocmd VimEnter,ColorScheme * highlight Identifier ctermbg=none
  augroup END
endif

augroup BufferAu
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter * if isdirectory( expand( "%:p:h" ) ) | cd %:p:h | endif
augroup END

augroup SkeletonAu
  autocmd!
  autocmd BufNewFile *.html 0r $HOME/.vim/template/skel.html
  autocmd BufNewFile *.rb 0r $HOME/.vim/template/skel.rb
augroup END

