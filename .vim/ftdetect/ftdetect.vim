autocmd BufNewFile,BufRead *.jbuilder setf ruby
autocmd BufNewFile,BufRead */nginx* setf nginx
autocmd BufNewFile,BufRead *.m setf objc
autocmd BufNewFile,BufRead *.h setf objc
autocmd BufNewFile,BufRead *.psgi setf perl
autocmd BufNewFile,BufRead *.pu,*.uml,*.plantuml setf plantuml
"autocmd BufNewFile,BufRead * :if getline(1) =~ '^.*startuml.*$'|  setf plantuml | endif
autocmd BufNewFile,BufRead *.tt2 setf tt2html
autocmd BufNewFile,BufRead *.tt setf tt2html
autocmd BufNewFile,BufRead .zpreztorc setf zsh
autocmd BufNewFile,BufRead *.plist,*.ttx setf xml
autocmd BufNewFile,BufRead *.applescript setf applescript
autocmd BufNewFile,BufRead *.tsx,*.jsx setf typescriptreact

function! s:detect_script_filetype()
  if len(&ft) == 0
    let s:matched = matchstr(getline(1), '^#!\%(.*/bin/\%(env\s\+\)\?\)\zs[a-zA-Z]\+')
    if len(s:matched) > 0
      if s:matched =~# 'sh$'
        setf sh
      else
        execute 'setf' s:matched
      endif
    endif
  endif
endfunction
autocmd BufNewFile,BufRead * call s:detect_script_filetype()

