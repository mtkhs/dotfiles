#---------------------------------------------------------------------------
# .zshrc
#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
# init:
#

#disable r

autoload -Uz colors && colors
autoload -Uz compinit
autoload -Uz add-zsh-hook

# for WSL
setopt no_bg_nice
unsetopt bg_nice

#---------------------------------------------------------------------------
# keybind:
#

bindkey -e

typeset -A key

bindkey "^[[3~" delete-char

# for cygwin
#bindkey "\e[H" beginning-of-line
#bindkey "\e[F" end-of-line
# for linux
#bindkey "\eOH" beginning-of-line
#bindkey "\eOF" end-of-line
# for rxvt and kconsole
#bindkey "\e[7~" beginning-of-line
#bindkey "\e[8~" end-of-line
# for screen
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line

if [[ -n "${terminfo}" ]]; then
#    if [[ $TERM = "xterm-256color" ]]; then
#    elif [[ $TERM = "screen-256color" ]]; then
#    fi
    key[Home]=${terminfo[khome]}
    key[End]=${terminfo[kend]}
    key[Insert]=${terminfo[kich1]}
    key[Delete]=${terminfo[kdch1]}
    key[Up]=${terminfo[kcuu1]}
    key[Down]=${terminfo[kcud1]}
    key[Left]=${terminfo[kcub1]}
    key[Right]=${terminfo[kcuf1]}
    key[PageUp]=${terminfo[kpp]}
    key[PageDown]=${terminfo[knp]}

    [[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
    [[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
    [[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
    [[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
    [[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
    [[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
    [[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
    [[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
    [[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
    [[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history
fi

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

#---------------------------------------------------------------------------
# zinit:
#

source ~/.zinit/bin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice wait"!0" lucid blockf silent
zinit light "zsh-users/zsh-completions"

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light "zsh-users/zsh-autosuggestions"

zinit ice lucid
zinit load "romkatv/zsh-defer"

zinit ice wait lucid from"gh-r" as"program"
zinit light "junegunn/fzf-bin"

#zinit ice wait lucid from"gh-r" as"program" mv"direnv* -> direnv"
#zinit light "direnv/direnv"

# tmux
zinit ice wait lucid from"gh-r" as"program" bpick"tmux-*.tar.gz" atclone"cd tmux*/; ./configure --enable-utf8proc; make" atpull"%atclone" pick"*/tmux" atload"alias tl='tmux list-sessions'"
zinit light "tmux/tmux"

# gh
zinit ice wait lucid from"gh-r" as"program" id-as"gh" has"git" atclone'**/gh completion -s zsh > _gh' atpull'%atclone' pick'**/gh'
zinit light "cli/cli"

# lazygit
zinit ice wait lucid from"gh-r" as"program" has"git"
zinit light "jesseduffield/lazygit"

# cat
zinit ice wait lucid from"gh-r" as"program" pick"*/bat" atload"alias cat='bat'"
zinit light "sharkdp/bat"

# find
zinit ice wait lucid from"gh-r" as"program" pick"*/fd"
zinit light "sharkdp/fd"

# grep
zinit ice wait lucid from"gh-r" as"program" mv"ripgrep* -> rg" pick"rg/rg" atload"alias grep='rg'"
zinit light "BurntSushi/ripgrep"

# diff
zinit ice wait lucid from"gh-r" as"program" pick"*/delta"
zinit light "dandavison/delta"

# curl
#zinit ice wait lucid from"gh-r" as"program" pick"*/xh"
#zinit light "ducaale/xh"

# dig
#zinit ice wait lucid from"gh" as"program" atclone"cargo build --release" atpull"%atclone" pick"target/release/dog"
#zinit light "ogham/dog"

# zoxide
#zinit ice wait lucid from"gh-r" as"command" mv"zoxide -> zoxide" atclone"./zoxide init zsh > init.zsh" atpull"%atclone" src"init.zsh" nocompile'!'
#zinit light "ajeetdsouza/zoxide"

case ${OSTYPE} in
    Rasp*)
        zinit ice wait lucid from"gh-r" as"program" bpick"*linux_arm64*" pick"*/peco"
        zinit light "peco/peco"

        ;;
    Manjaro*)
        
        ;;
    darwin*)
        zinit ice wait lucid from"gh-r" as"program" pick"*/peco"
        zinit light "peco/peco"

        zinit ice wait lucid from"gh-r" as"program" bpick"*macos-x86_64.tar.gz" pick"*/bin/nvim" atload"alias vi='nvim'"
        zinit light "neovim/neovim"

        ;;
    linux*)
        zinit ice wait lucid from"gh-r" as"program" pick"*/peco"
        zinit light "peco/peco"
        # du
        #zinit ice wait lucid from"gh-r" as"program" pick"*/diskus"
        #zinit light "sharkdp/diskus"

        # ghq
        zinit ice wait lucid from"gh-r" as"program" bpick"ghq_linux_amd64.zip" pick"*/ghq"
        zinit light "x-motemen/ghq"

        # ls
        zinit ice wait lucid from"gh-r" as"program" pick"eza" atload"export EZA_ICON_SPACING=2; alias ls='eza --git --bytes --group --group-directories-first --time-style=long-iso --icons'"
        zinit light "eza-community/eza"

        # vi
        zinit ice wait lucid from"gh-r" as"program" bpick"*linux-x86_64.tar.gz" pick"*/bin/nvim" atload"alias vi='nvim'"
        zinit light "neovim/neovim"

        # lua-language-server
        zinit ice wait lucid from"gh-r" as"program" bpick"*linux-x64.tar.gz" pick"*/lua-language-server"
        zinit light "LuaLS/lua-language-server"

        # tree-sitter
        zinit ice wait lucid from"gh-r" as"program" bpick"*linux-x64.gz" mv"tree-sitter* -> tree-sitter"
        zinit light "tree-sitter/tree-sitter"

        
        ;;
esac

zsh-defer compinit -Cu

#---------------------------------------------------------------------------
# completion:
#

# 補完時に大文字小文字を無視する。
#compctl -M 'm:{a-z}={A-Z}'

# killコマンドのPID補完
#zstyle ':completion:*:processes' command "ps a -u $USER -o user,pid,stat,%cpu,%mem,cputime,command"
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# 超補完
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# 詳細を表示
zstyle ':completion:*' verbose yes

# 補完候補をキャッシュしてみたり
zstyle ':completion:*' use-cache yes

# 補完に色付け
zstyle ':completion:*:default' list-colors ""

#---------------------------------------------------------------------------
# prompt:
#

# コピペしやすいようにコマンド実行後は右プロンプトを消す
setopt transient_rprompt
# 出力の文字列末尾に改行コードが無い場合でも表示
#unsetopt promptcr

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
# ※PROMPTへの代入文字列がシングルクォートで括らないとダメになるらしい
setopt prompt_subst

function face() {
    echo '%(?.%F{green}(^-^)%f.%F{red}(`-`%)%f)'
}

case ${UID} in
0)
    PROMPT='`face` %n@%m:%~# '
    PROMPT2='`face` %n@%m:%_# '
    RPROMPT='%1v'
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${PROMPT}%{[m%}"
    ;;
*)
     PROMPT='`face` %n@%m:%~$ '
     PROMPT2='`face` %n@%m:%_$ '
     RPROMPT='%1v'
     [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${PROMPT}%{[m%}"
     ;;
 esac

#---------------------------------------------------------------------------
# basic:
#

KEYTIMEOUT=1

# フロー制御無効 (Ctrl+s/Ctrl+qを解放)
setopt noflowcontrol
# cd を入力しなくてもディレクトリに遷移
setopt auto_cd
# cd -[tab]で履歴表示
setopt auto_pushd
# auto_pushdで重複ディレクトリを追加しないように
setopt pushd_ignore_dups
# 補完可能な一覧を表示
setopt auto_list
# 補完候補一覧でファイルの種別を記号で表示（ls -Fと同じ記号）
setopt list_types
# ディレクトリ名の補完で末尾に / を自動付加
setopt auto_param_slash
# 括弧の対応を補完
setopt auto_param_keys
# 補完キー連打で補完候補を自動補充
setopt auto_menu
# aliasを補完候補に含める
setopt complete_aliases
# --PREFIX=/USRなどの=以降でも補完できる
setopt magic_equal_subst
# コマンド名に / が含まれているときPATHの中のサブディレクトリを探す
setopt path_dirs
# 補完候補をできるだけ詰めて表示
setopt list_packed
# 数字を数値として解釈してソート
setopt numeric_glob_sort
# 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
setopt multios
# ファイル名の展開でディレクトリにマッチした場合は末尾に / を自動付加
setopt mark_dirs
# jobsでプロセスIDも表示する
setopt long_list_jobs
# 補完候補リストの日本語を適正表示
setopt print_eight_bit
# no beep
setopt no_beep
setopt nolistbeep
# =COMMANDでCOMMANDのパス名に展開
setopt equals
# FOR, REPEAT, SELECT, IF, FUNCTIONなどで簡略文法が使えるようになる
setopt short_loops

#---------------------------------------------------------------------------
# history:
#

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=$HISTSIZE
# ヒストリファイルに実行時間とかも記録
setopt extended_history
# 同じコマンドラインが続くときは記録しない
setopt hist_ignore_dups
# スペースで始まるコマンドラインはヒストリに追加しない
setopt hist_ignore_space
# 余分な空白は詰める
setopt hist_reduce_blanks
# zsh の開始/ 終了時刻をヒストリファイルに記録
setopt extended_history
# シェルを横断して.zsh_historyに記録
setopt inc_append_history
# ヒストリを共有
setopt share_history
# ヒストリを呼び出してから実行するまでに一旦編集できるようにする
setopt hist_verify
# ヒストリファイルを上書きせずに追加
setopt append_history
# 補完時にヒストリを展開
setopt hist_expand

#---------------------------------------------------------------------------
# command:
#

# mkdir, cd into it
function mkcd() {
    mkdir -p "$*"
    cd "$*"
}

# TODO: 
function mkbk() {
}

#---------------------------------------------------------------------------
# peco:
#

# history
function peco_history_selection() {
#    BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
    BUFFER=$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco_history_selection
#bindkey '^R' peco_history_selection

# ghq
function peco_ghq_look() {
    local ghq_roots="$(git config --path --get-all ghq.root)"
    local selected_dir=$(ghq list --full-path | \
        xargs -I{} ls -dl --time-style=+%s {}/.git | sed 's/.*\([0-9]\{10\}\)/\1/' | sort -nr | \
        sed "s,.*\(${ghq_roots/$'\n'/\|}\)/,," | \
        sed 's/\/.git//' | \
        peco --prompt="cd-ghq >" --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq list --full-path | grep --color=never -E "/$selected_dir$")"
        zle accept-line
    fi
}
zle -N peco_ghq_look
bindkey '^G' peco_ghq_look

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco_cdr() {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco_cdr
bindkey '^E' peco_cdr

#---------------------------------------------------------------------------
# fzf:
#

function fzf_history_search() {
    BUFFER=$(history -n -r 1 | awk '!a[$0]++' | fzf --query "$LBUFFER" --reverse --border --inline-info)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf_history_search
bindkey '^r' fzf_history_search

#function fzf_history_search() {
#    local selected_command
#    selected_command=$(history -n 1 | tac | awk '!a[$0]++' | fzf --height 40% --layout=reverse --border --inline-info)
#    if [ -n "$selected_command" ]; then
#        BUFFER=$selected_command
#        CURSOR=$#BUFFER
#        zle reset-prompt
#    fi
#}
#zle -N fzf_history_search
#bindkey '^R' fzf_history_search

function fzf_cdr(){
    local selected_dir=$(cdr -l | awk '{ print $2 }' | \
      fzf --preview 'f() { sh -c "ls -hFGl $1" }; f {}')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N fzf_cdr
#bindkey '^E' fzf_cdr

#---------------------------------------------------------------------------
# zcompile:
#

if [ ! -s $ZDOTDIR/.zprofile.zwc ] || [ $ZDOTDIR/.zprofile -nt $ZDOTDIR/.zprofile.zwc ]; then
   zcompile $ZDOTDIR/.zprofile
fi

if [ ! -s $ZDOTDIR/.zshenv.zwc ] || [ $ZDOTDIR/.zshenv -nt $ZDOTDIR/.zshenv.zwc ]; then
   zcompile $ZDOTDIR/.zshenv
fi

if [ ! -s $ZDOTDIR/.zshrc.zwc ] || [ $ZDOTDIR/.zshrc -nt $ZDOTDIR/.zshrc.zwc ]; then
   zcompile $ZDOTDIR/.zshrc
fi

if [ ! -s $ZDOTDIR/.zlogin.zwc ] || [ $ZDOTDIR/.zlogin -nt $ZDOTDIR/.zlogin.zwc ]; then
   zcompile $ZDOTDIR/.zlogin
fi

[ -f $HOME/.zshrc_local ] && source $HOME/.zshrc_local

