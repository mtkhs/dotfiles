#---------------------------------------------------------------------------
# .zlogin
#---------------------------------------------------------------------------

if type nvim &> /dev/null; then
    alias vi='nvim'
fi

if type tmux &> /dev/null; then
    alias tl='tmux list-sessions'
fi

if type git &> /dev/null; then
    alias gb="git branch"
    alias gd="git diff"
    alias gs="git status"
fi

if type eza &> /dev/null; then
    export EZA_ICON_SPACING=2; alias ls='eza --git --bytes --group --group-directories-first --time-style=long-iso --icons'
fi

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

alias sudo='sudo -E '

case ${OSTYPE} in
    darwin*)
        if type gls &> /dev/null; then
            alias ls='gls --color=always --group-directories-first --group'
        fi
        ;;
    linux*)
        alias ls='ls --color=always --group-directories-first --group'
        ;;
esac

[ -f $HOME/.zlogin_local ] && source $HOME/.zlogin_local

