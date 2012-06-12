" Tue Apr 22 07:21:00 JST 2008
"
" b:charCounterCount $B$KJ8;z?t$r%;%C%H$9$k%9%/%j%W%H(B
" $B%P%C%U%!$rJ]B8$7$?$j$7$?$H$-$K!"99?7$5$l$k!#(B
"
" $B%9%F!<%?%9%i%$%s$KF~$l$F;H$&Nc"-(B
" set statusline=%{b:charCounterCount}

if exists("anekos_charCounter")
	finish
endif
let anekos_charCounter=1

augroup CharCounter
	autocmd!
	autocmd BufCreate,BufEnter * call <SID>Initialize()
	autocmd BufUnload,FileWritePre,BufWritePre * call <SID>Update()
augroup END

function! s:Initialize()
	if exists('b:charCounterCount')
	else
		return s:Update()
	endif
endfunction

function! s:Update()
	let b:charCounterCount = s:CharCount()
endfunction

function! s:CharCount()
	let l:result = 0
	for l:linenum in range(0, line('$'))
		let l:line = getline(l:linenum)
		let l:result += strlen(substitute(l:line, ".", "x", "g"))
	endfor
	return l:result
endfunction

function! AnekoS_CharCounter_CharCount()
	return s:CharCount()
endfunction


