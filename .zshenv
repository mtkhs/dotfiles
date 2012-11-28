
alias sl='ls'
alias la='ls -l -A -v -F'
alias ll='ls -l'

alias sha1='openssl sha1'
alias su='su -l'
alias du='du -h'
alias df='df -h'
alias duh='du -h -d 1 .'
alias cl='clear'

## GNU grepがあったら優先して使う。
if type ggrep > /dev/null 2>&1; then
	alias grep=ggrep
fi

alias v='vim'
alias vf='vimfiler'

alias vimfiler='vim -c VimFiler'

case ${OSTYPE} in
	darwin*)
		alias ls='LSCOLORS=gxfxxxxxcxxxxxxxxxxxxx ls -G'

		alias gv='/Applications/MacVim.app/Contents/MacOS/mvim "$@"'

		#alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim -u $HOME/.vimrc "$@"'
		#alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
		alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
		alias ctags='/Applications/MacVim.app/Contents/MacOS/ctags "$@"'
		alias emacs='/usr/local/Cellar/emacs/23.3a/Emacs.app/Contents/MacOS/Emacs -nw'
		alias mfiler3='/usr/local/bin/mfiler3'
		alias rmdolipocache='rm -rf ~/Library/Application\ Support/dolipo/Cache/*'
		#alias updatedb='sudo /usr/libexec/locate.updatedb'
		#alias updatedb='/usr/libexec/locate.updatedb'
		;;
	linux*)
		alias ls='ls -F --color=auto'
		;;
esac

[ -f $HOME/.zshenv.local ] && source $HOME/.zshenv.local

