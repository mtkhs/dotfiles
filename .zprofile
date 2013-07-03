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

# grep
## grepのバージョンを検出。
grep_version="$(grep --version | head -n 1 | sed -e 's/^[^0-9.]*\([0-9.]*\)[^0-9.]*$/\1/')"
## デフォルトオプションの設定
export GREP_OPTIONS
### バイナリファイルにはマッチさせない。
GREP_OPTIONS="--binary-files=without-match"
case "$grep_version" in
	1.*|2.[0-4].*|2.5.[0-3])
		;;
	*)
		### grep 2.5.4以降のみの設定
		### grep対象としてディレクトリを指定したらディレクトリ内を再帰的にgrepする。
		GREP_OPTIONS="--directories=recurse $GREP_OPTIONS"
		;;
esac
### 拡張子が.tmpのファイルは無視する。
GREP_OPTIONS="--exclude=\*.tmp $GREP_OPTIONS"
## 管理用ディレクトリを無視する。
if grep --help 2>&1 | grep -q -- --exclude-dir; then
	GREP_OPTIONS="--exclude-dir=.svn $GREP_OPTIONS"
	GREP_OPTIONS="--exclude-dir=.git $GREP_OPTIONS"
	GREP_OPTIONS="--exclude-dir=.deps $GREP_OPTIONS"
	GREP_OPTIONS="--exclude-dir=.libs $GREP_OPTIONS"
fi
### 可能なら色を付ける。
if grep --help 2>&1 | grep -q -- --color; then
	GREP_OPTIONS="--color=auto $GREP_OPTIONS"
fi

case ${OSTYPE} in
	darwin*)
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
		export PATH=/usr/local/texlive/2011/bin/x86_64-darwin/:$PATH
		
		# cairo
		export DYLD_LIBRARY_PATH=/usr/local/opt/cairo/lib
		
		# command
		dict () { open dict://"$@"; }
	;;
	linux*)
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
				tmux
			fi
		fi
	;;
esac

# nvm
if [[ -s $HOME/.nvm/nvm.sh ]]; then
	source $HOME/.nvm/nvm.sh
	export NODE_PATH=${NVM_PATH}_modules${NODE_PATH:+:}${NODE_PATH}
fi

if [[ -s "$HOME/.rbenv" ]]; then
	# rbenv
	export PATH=$HOME/.rbenv/bin:$PATH
	eval "$(rbenv init - zsh --no-rehash)"
elif [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
	# rvm
	export PATH=$HOME/.rvm/bin:$PATH # Add RVM to PATH for scripting
	source $HOME/.rvm/scripts/rvm
fi

if [[ -s "$HOME/.pyenv" ]]; then
	# pyenv
	export PATH=$HOME/.pyenv/bin:$PATH
	eval "$(pyenv init - zsh --no-rehash)"
elif [[ -s "$HOME/.pythonbrew/etc/bashrc" ]]; then
	# pythonbrew
	source $HOME/.pythonbrew/etc/bashrc
#	pybrew switch 2.7.3 > /dev/null
fi

if which plenv > /dev/null || [[ -s "$HOME/.plenv" ]]; then
	# plenv
	export PATH=$HOME/.plenv/bin:$PATH
	eval "$(plenv init - zsh --no-rehash)"
fi

[ -f $HOME/.zprofile.local ] && source $HOME/.zprofile.local
