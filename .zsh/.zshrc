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
# zplugin:
#

source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

#zplugin light "zdharma/zui"
#zplugin light "zdharma/zplugin-crasis"

#zplugin light "chrissicool/zsh-256color"

zplugin ice wait"!0" blockf silent
zplugin light "zsh-users/zsh-completions"

zplugin ice wait"!0" silent atload"_zsh_autosuggest_start"
zplugin light "zsh-users/zsh-autosuggestions"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

zplugin ice wait"!0" silent atinit"zpcompinit; zpcdreplay"
zplugin light "zsh-users/zsh-syntax-highlighting"

zplugin ice from"gh-r" as"program" pick"*/peco"
zplugin light "peco/peco"

zplugin ice from"gh-r" as"program"
zplugin light "junegunn/fzf-bin"

zplugin ice from"gh-r" as"program" pick"*/ghq"
zplugin light "motemen/ghq"

zplugin light "mollifier/anyframe"
bindkey '^x^r' anyframe-widget-execute-history
bindkey '^x^f' anyframe-widget-insert-filename
bindkey '^x^k' anyframe-widget-kill
zstyle ":anyframe:selector:" use peco
zstyle ":anyframe:selector:peco:" command 'peco --initial-filter IgnoreCase'
#zstyle ":anyframe:selector:fzf:" command 'fzf --extended'

#zplugin ice wait"!0" silent
#zplugin light "b4b4r07/enhancd"
#export ENHANCD_FILTER=peco
#export ENHANCD_DISABLE_DOT=1
#export ENHANCD_DISABLE_HOME=1

zplugin ice from"gh-r" as"program" mv"direnv* -> direnv"
zplugin light "direnv/direnv"

#zplugin ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
#zplugin light "direnv/direnv"

#zplugin snippet 'OMZ::plugins/dotenv/dotenv.plugin.zsh'
#zplugin snippet 'OMZ::plugins/git/git.plugin.zsh'

compinit -Cu

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

# コマンドのスペルチェック
#setopt correct
# サスペンド中のプロセスと同じコマンド名を実行したらリジューム
#setopt auto_resume
# 補完可能な一覧を表示
setopt auto_list
# 補完候補一覧でファイルの種別を記号で表示（ls -Fと同じ記号）
setopt list_types
# ディレクトリ名の補完で末尾に / を自動付加
setopt auto_param_slash

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

# 戻り値が 0 以外の場合終了コードを表示する
#setopt print_exit_value

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

if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

#---------------------------------------------------------------------------
# peco:
#

function peco-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

function peco-ghq-look () {
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
zle -N peco-ghq-look
bindkey '^G' peco-ghq-look

function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr

#---------------------------------------------------------------------------
# zcompile:
#

if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

[ -f $HOME/.zshrc_local ] && source $HOME/.zshrc_local

