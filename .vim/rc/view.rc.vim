"---------------------------------------------------------------------------
" View:
"

" Anywhere SID.
function! s:SID_PREFIX() abort
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Show line number.
set number
" Show <TAB>
set list
set listchars=tab:>-,trail:-
" Always display statusline.
set laststatus=2
" Height of command line.
set cmdheight=2
" Not show command on statusline.
set noshowcmd

" The value of this option specifies when the line with tab page labels
" will be displayed:
"   0: never
"   1: only if there are at least two tab pages
"   2: always
set showtabline=2

" Set statusline.
"let &g:statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
"      \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
"      \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
"      \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?
"      \ '['.(&filetype!=''?&filetype.',':'')"
"      \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
"      \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"

" Turn down a long line appointed in 'breakat'
set linebreak
set showbreak=\
set breakat=\ \	;:,!?
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
if exists('+breakindent')
   set breakindent
   set wrap
else
   set nowrap
endif

" Disable folding
set nofoldenable

" Display candidate supplement.
set nowildmenu
set wildmode=list:longest,full
" Increase history amount.
set history=1000
" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
" Maintain a current line at the time of movement as much as possible.
set nostartofline
" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
" set winheight=20
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways

" Adjust window size of preview and help.
set previewheight=8
set helpheight=12

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
"set display+=uhex

function! WidthPart(str, width) abort
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = strwidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= strwidth(char)
  endwhile

  return ret
endfunction

" Highlight parenthesis.
set showmatch

" Highlight <>.
set matchpairs+=<:>

" Highlight when CursorMoved.
set cpoptions-=m
set matchtime=1

" Enable virtualedit in visual block mode.
set virtualedit=block

"
" auto cursorline
" https://thinca.hatenablog.com/entry/20090530/1243615055
"
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

