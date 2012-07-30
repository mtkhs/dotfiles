case ${OSTYPE} in
	darwin*)
		export LANG=ja_JP.UTF-8
		export EDITOR='vim'
		
		export CLICOLOR=1
		export LSCOLORS=DxGxcxdxCxegedabagacad
		
		# Wine
		#export PATH=/Applications/Wine.app/Contents/Resources/bin:$PATH
		
		# homebrew
		export PATH=$HOME/bin:/usr/local/bin:$PATH
		
		# review
		export PATH=$HOME/review/bin:$PATH
		
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
				tmux -l
			fi
		fi
	;;
esac

# nvm
if [[ -f $HOME/.nvm/nvm.sh ]]; then
	source $HOME/.nvm/nvm.sh
fi

# rvm
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
	export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
	source "$HOME/.rvm/scripts/rvm"
fi

# pythonbrew
if [[ -s "$HOME/.pythonbrew/etc/bashrc" ]]; then
	source "$HOME/.pythonbrew/etc/bashrc"
#	pybrew switch 2.7.2 > /dev/null
fi

[ -f $HOME/.zprofile.local ] && source $HOME/.zprofile.local

