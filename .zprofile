umask 002

#
# https://github.com/clear-code/zsh.d/blob/master/zshenv
#
# ページャの設定
if type lv > /dev/null 2>&1; then
    ## lvを優先する。
    export PAGER="lv"
else
    ## lvがなかったらlessを使う。
    export PAGER="less"
fi

### lv
## -c: ANSIエスケープシーケンスの色付けなどを有効にする。
## -l: 1行が長くと折り返されていても1行として扱う。
##     （コピーしたときに余計な改行を入れない。）
export LV="-c -l"

# less
## -R: ANSIエスケープシーケンスのみ素通しする。
export LESS="-R"

case ${OSTYPE} in
	darwin*)
		export LC_ALL=ja_JP.UTF-8
		export LANG=ja_JP.UTF-8
		export EDITOR='vim'
		export PAGER='lv'
		
		export CLICOLOR=1
		export LSCOLORS=DxGxcxdxCxegedabagacad
		
		# Java
#		export JAVA_HOME=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
		export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_25.jdk/Contents/Home
		export PATH=$JAVA_HOME/bin:$PATH
		export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 # javacの出力文字コードがなぜかShift_JISで化けるので
		
		# Wine
		#export PATH=/Applications/Wine.app/Contents/Resources/bin:$PATH
		
		# homebrew
		export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
		export HOMEBREW_MAKE_JOBS=3
		export HOMEBREW_CACHE=~/Library/Caches/Homebrew
		
		# review
		export PATH=$HOME/review/bin:$PATH
		
		# tex
		export PATH=/usr/local/texlive/2013/bin/x86_64-darwin:$PATH
		
		# cairo
#		export DYLD_LIBRARY_PATH=/usr/local/opt/cairo/lib
		
		# command
		dict () { open dict://"$@"; }
	;;
	linux*|cygwin*|msys*)
		export PATH=/sbin:/usr/sbin:$PATH
		export EDITOR='vim'
		
		#
		# Attach tmux
		# http://d.hatena.ne.jp/nari_memo/20120129/1327822418
		#
		if ( ! test $TMUX ) && ( ! expr $TERM : "^screen" > /dev/null ) && which tmux > /dev/null; then
			if ( tmux has-session ); then
				session=`tmux list-sessions | grep -e '^[0-9].*]$' | head -n 1 | sed -e 's/^\([0-9]\+\).*$/\1/'`
				if [ -n "$session" ]; then
					echo "Attach tmux session $session."
					tmux attach-session -t $session
				else
					echo "Session has been already attached."
					tmux list-sessions
				fi
			else
				echo "Create new tmux session."
				tmux -2
			fi
		fi
	;;
esac

if [[ -d $HOME/.nodebrew ]]; then
	# nodebrew
	export PATH=$HOME/.nodebrew/current/bin:$PATH
elif [[ -s $HOME/.nvm/nvm.sh ]]; then
# nvm
	source $HOME/.nvm/nvm.sh
	export NODE_PATH=${NVM_PATH}_modules${NODE_PATH:+:}${NODE_PATH}
fi

if [[ -d "$HOME/.rbenv" ]]; then
	# rbenv
	export PATH=$HOME/.rbenv/bin:$PATH
	eval "$(rbenv init - --no-rehash zsh)"
elif [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
	# rvm
	export PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting
	source $HOME/.rvm/scripts/rvm
fi

if [[ -d "$HOME/.phpenv" ]]; then
	# pyenv
	export PATH=$PATH:$HOME/.phpenv/bin
	eval "$(phpenv init - --no-rehash zsh)"
fi

if [[ -d "$HOME/.pyenv" ]]; then
	# pyenv
	export PATH=$HOME/.pyenv/bin:$PATH
	if which pyenv > /dev/null; then eval "$(pyenv init - --no-rehash zsh)"; fi
elif [[ -s "$HOME/.pythonbrew/etc/bashrc" ]]; then
	# pythonbrew
	source $HOME/.pythonbrew/etc/bashrc
#	pybrew switch 2.7.3 > /dev/null
fi

if which plenv > /dev/null || [[ -d "$HOME/.plenv" ]]; then
	# plenv
	export PATH=$HOME/.plenv/bin:$PATH
	eval "$(plenv init - --no-rehash zsh)"
fi

[ -f $HOME/.zprofile.local ] && source $HOME/.zprofile.local
