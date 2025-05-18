#---------------------------------------------------------------------------
# .zlogin
#---------------------------------------------------------------------------

if type nvim &> /dev/null; then
    alias vi='nvim'
fi

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'


alias tl='tmux list-sessions'

alias gb="git branch"
alias gd="git diff"
alias gs="git status"

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

