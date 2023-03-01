#---------------------------------------------------------------------------
# .zprofile
#---------------------------------------------------------------------------

ARCH=$(uname -m | sed 's/x86_\|aarch//;s/i[3-6]86/32/')
#VER=$(lsb_release -sr)

umask 002

export LV="-c -l"
export LESS="-R"
export FZF_DEFAULT_OPTS="--no-sort --exact --cycle --multi --ansi --reverse --border --sync --bind=ctrl-t:toggle --bind=ctrl-k:kill-line --bind=?:toggle-preview --bind=down:preview-down --bind=up:preview-up"

case ${OSTYPE} in
    darwin*)
        unset LC_ALL
        export LANG=en_US.UTF-8
#        export LC_ALL=ja_JP.UTF-8
#        export LANG=ja_JP.UTF-8
        export EDITOR='vim'
        export PAGER='lv'
        
        export CLICOLOR=1
        export LSCOLORS=DxGxcxdxCxegedabagacad
        
        # Java
        export JAVA_HOME=$(/usr/libexec/java_home)
        export PATH=$JAVA_HOME/bin:$PATH
        export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
        
        # homebrew
        export PATH=/snap/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
#        export HOMEBREW_MAKE_JOBS=3
#        export HOMEBREW_CACHE=~/Library/Caches/Homebrew
        
        # command
        dict () { open dict://"$@"; }

#        if type brew >/dev/null 2>&1; then
#        fi
        eval "$(/opt/homebrew/bin/brew shellenv)"

    ;;
    linux*|cygwin*|msys*)
        OS=$(lsb_release -si)
        unset LC_ALL
#        export LC_ALL=ja_JP.UTF-8
        export LANG=en_US.UTF-8

        export GOPATH=$HOME/go
        export GOBIN=$GOPATH/bin
        export PATH=/snap/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:/usr/sbin:/sbin:$GOBIN:$PATH
        export EDITOR='vim'

        if [ -e /etc/os-release ]; then
            DISTRIBUTION_NAME=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'`

            if [ "$DISTRIBUTION_NAME" = "Ubuntu" ]; then
                # Skip the not really helping Ubuntu global compinit
                skip_global_compinit=1
            fi
        fi
        # WSL
#        if ( which wslfetch > /dev/null 2>&1 ); then
#            alias nmap='"/mnt/c/Program Files (x86)/Nmap/nmap.exe"'
#        fi
        
        if [ "${OS}" != "WLinux" ]; then
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
                    TERM=xterm-256color tmux new-session -s "0"
                fi
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

# for docker-compose
export UID=${UID}
export GID=${GID}

[ -f $HOME/.zprofile_local ] && source $HOME/.zprofile_local

