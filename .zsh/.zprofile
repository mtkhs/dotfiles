#---------------------------------------------------------------------------
# .zprofile
#---------------------------------------------------------------------------

# Helper to see if a command exists
command_exists () {
  type "$1" &> /dev/null ;
}

# Use neovim if it's installed
if command_exists nvim ; then
  alias vim='nvim'
fi

umask 002

# xtermだとtmuxでlsした日本語ファイル名がおかしくなった
#[[ $TMUX = "" ]] && export TERM="xterm-256color"

export LV="-c -l"
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
		export JAVA_HOME=$(/usr/libexec/java_home)
		export PATH=$JAVA_HOME/bin:$PATH
		export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8 # javacの出力文字コードがなぜかShift_JISで化けるので
		
		# homebrew
		export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
		export HOMEBREW_MAKE_JOBS=3
		export HOMEBREW_CACHE=~/Library/Caches/Homebrew
		
		# command
		dict () { open dict://"$@"; }
	;;
	linux*|cygwin*|msys*)
		export GOPATH=$HOME/go
		export GOBIN=$GOPATH/bin
		export PATH=$HOME/bin:/usr/sbin:/sbin:$GOBIN:$PATH
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
				tmux new-session -s "0"
			fi
		fi
	;;
esac

if [[ -d "$HOME/.anyenv" ]]; then
	export PATH="$HOME/.anyenv/bin:$PATH"
	eval "$(anyenv init - --no-rehash zsh)"
fi

if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# zsh config
export ENHANCD_DISABLE_DOT=1
export ENHANCD_DISABLE_HOME=1

# for docker-compose
export UID=${UID}
export GID=${GID}

[ -f $HOME/.zprofile_local ] && source $HOME/.zprofile_local

