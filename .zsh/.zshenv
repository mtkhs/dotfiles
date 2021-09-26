
if type nvim &> /dev/null; then
    alias vim='nvim'
fi

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

alias ls='exa --color=always --group-directories-first --group --bytes'
alias la='exa -halgF --git --color=always --group-directories-first'
alias l='la'
alias ll='\ls -n'

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

[ -f $HOME/.zshenv_local ] && source $HOME/.zshenv_local

