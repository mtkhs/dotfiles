#---------------------------------------------------------------------------
# .zlogin
#---------------------------------------------------------------------------

if type nvim &> /dev/null; then
    alias vi='nvim'
fi

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

alias ls='ls --color=always --group-directories-first --group'

alias tl='tmux list-sessions'

alias gb="git branch"
alias gd="git diff"
alias gs="git status"

alias sudo='sudo -E '

case ${OSTYPE} in
    darwin*)
#        alias ls='LSCOLORS=gxfxxxxxcxxxxxxxxxxxxx ls -G'
#        alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        ;;
    linux*)
#        alias ls='ls -F --color=auto --show-control-char'
        ;;
esac


[ -f $HOME/.zlogin_local ] && source $HOME/.zlogin_local

