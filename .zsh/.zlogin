#---------------------------------------------------------------------------
# .zlogin
#---------------------------------------------------------------------------

if type git &> /dev/null; then
    alias gb="git branch"
    alias gd="git diff"
    alias gs="git status"
fi

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'

alias sudo='sudo -E '

# zinit turbo でロードされるツールは zsh-defer で遅延設定
function _setup_tool_aliases() {
    if type nvim &> /dev/null; then
        alias vi='nvim'
    fi

    if type tmux &> /dev/null; then
        alias tl='tmux list-sessions'
    fi

    if type bat &> /dev/null; then
        alias cat='bat'
    fi

    if type rg &> /dev/null; then
        alias grep='rg'
    fi

    if type eza &> /dev/null; then
        export EZA_ICON_SPACING=2
        alias ls='eza --git --bytes --group --group-directories-first --time-style=long-iso --icons'
    else
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
    fi
}
zsh-defer _setup_tool_aliases


#---------------------------------------------------------------------------
# dotfiles update check (async)
#
_dotfiles_check_result="$HOME/.cache/dotfiles_check_result"
_dotfiles_check_ts="$HOME/.cache/dotfiles_check_ts"
_dotfiles_dir="$HOME/dotfiles"

function _dotfiles_notify() {
    if [[ -f "$_dotfiles_check_result" ]]; then
        cat "$_dotfiles_check_result"
        rm -f "$_dotfiles_check_result"
    fi
}
add-zsh-hook precmd _dotfiles_notify

function _dotfiles_check_async() {
    # 1分以内に実行済みならスキップ
    if [[ -f "$_dotfiles_check_ts" ]]; then
        local last=$(cat "$_dotfiles_check_ts")
        local now=$(date +%s)
        (( now - last < 60 )) && return
    fi

    # タイムスタンプ更新
    mkdir -p "${_dotfiles_check_ts:h}"
    date +%s > "$_dotfiles_check_ts"

    # バックグラウンドで確認
    (
        cd "$_dotfiles_dir" || exit
        git fetch origin --quiet 2>/dev/null || exit

        local local_head=$(git rev-parse HEAD)
        local remote_head=$(git rev-parse origin/master)

        if [[ "$local_head" != "$remote_head" ]]; then
            local behind=$(git rev-list HEAD..origin/master --count)
            echo "\e[33m[dotfiles]\e[0m ${behind} commit(s) behind origin/master. Run \e[36mgit pull\e[0m in $_dotfiles_dir" \
                > "$_dotfiles_check_result"
        fi
    ) &!
}

_dotfiles_check_async

[ -f $HOME/.zlogin_local ] && source $HOME/.zlogin_local

