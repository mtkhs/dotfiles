bindkey -e # キーバインドだけEmacs
bindkey "^[[3~" delete-char     # delete キーがチルダになるのを回避
disable r # rで最後に実行したコマンドを実行するのをやめる。

autoload -Uz colors
colors

autoload -Uz compinit
compinit -u # -u つけないとsuで怒られる。

autoload -Uz bashcompinit
bashcompinit
source $HOME/.zsh/git-completion.bash

autoload -Uz add-zsh-hook

autoload -Uz vcs_info

# zplug
source ~/.zplug/init.zsh

zplug "mollifier/anyframe"
zplug "mollifier/cd-gitroot"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:init.sh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

#zplug load --verbose
zplug load

# 補完時に大文字小文字を無視する。
#compctl -M 'm:{a-z}={A-Z}'

# killコマンドのPID補完
#zstyle ':completion:*:processes' command "ps a -u $USER -o user,pid,stat,%cpu,%mem,cputime,command"
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# 補完時の大文字小文字無視しつつ、超補完以下略
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z} r:|[-_.]=**'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# 詳細を表示
zstyle ':completion:*' verbose yes

# 補完候補をキャッシュしてみたり
zstyle ':completion:*' use-cache yes

# 補完に色付け
zstyle ':completion:*:default' list-colors ""

#
# prompt
#
## PROMPT内で「%」文字から始まる置換機能を有効にする。
#setopt prompt_percent
## コピペしやすいようにコマンド実行後は右プロンプトを消す。
setopt transient_rprompt
# 出力の文字列末尾に改行コードが無い場合でも表示
#unsetopt promptcr

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
# ※PROMPTへの代入文字列がシングルクォートで括らないとダメになるらしい
setopt prompt_subst

# define_vcs_info() {
	# # http://liosk.blog103.fc2.com/blog-entry-209.html
	# psvar=()
	# LANG=en_US.UTF-8 vcs_info
	# psvar[1]=$vcs_info_msg_0_
# }
# add-zsh-hook precmd define_vcs_info

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

# pure
#source $HOME/.zsh/pure/pure.zsh

#
# basic
#
# cd を入力しなくてもディレクトリに遷移
setopt auto_cd
# cd -[tab]で履歴表示
#setopt auto_pushd
# auto_pushdで重複ディレクトリを追加しないように
#setopt pushd_ignore_dups

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
# jobsでプロセスIDも表示する。
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

#
# ヒストリ
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
# ヒストリファイルにコマンドラインだけじゃなくて実行時間とかも記録する。
setopt extended_history
# 同じコマンドラインが続くときは記録しない。
setopt hist_ignore_dups
# スペースで始まるコマンドラインはヒストリに追加しない。
setopt hist_ignore_space
# 余分な空白は詰める
setopt hist_reduce_blanks
# シェルプロセスごとにヒストリを共有
setopt share_history
# ヒストリを呼び出してから実行するまでに一旦編集できるようにする。
setopt hist_verify
# ヒストリファイルを上書きせずに追加
setopt append_history


#
# functions
#

#function cd() {builtin cd $@ && ls -v -F --color=auto}

# http://homepage1.nifty.com/blankspace/zsh/zsh.html
typeset -A myabbrev
myabbrev=(
    "ll"    "| less"
    "lg"    "| grep"
)

my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^_a-zA-Z0-9]\([_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev

# cd時に自動ls
#function chpwd() { ls -v -F }

#
# Enter で ls と git status を表示すると便利
# http://qiita.com/yuyuchu3333/items/e9af05670c95e2cc5b4d
#
#function do_enter() {
#    if [ -n "$BUFFER" ]; then
#        zle accept-line
#        return 0
#    fi
#    echo
#    #ls
#    # ↓おすすめ
#    ls_abbrev
#    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
#        echo
#        echo -e "\e[0;33m--- git status ---\e[0m"
#        git status -sb
#    fi
#    zle reset-prompt
#    return 0
#}
#zle -N do_enter
#bindkey '^m' do_enter

#
# zshでEnterを連打したときにいろいろ実行する
# http://blog.n-z.jp/blog/2014-12-06-zsh-enter.html
#
function my_enter {
    if [[ -n "$BUFFER" ]]; then
        builtin zle .accept-line
        return 0
    fi
    if [ "$WIDGET" != "$LASTWIDGET" ]; then
        MY_ENTER_COUNT=0
    fi
    case $[MY_ENTER_COUNT++] in
        0)
            BUFFER=" ls"
            ;;
        1)
            if [[ -d .svn ]]; then
                BUFFER=" svn status"
            elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
                BUFFER=" git status -sb"
            fi
            ;;
        *)
            unset MY_ENTER_COUNT
            ;;
    esac
    builtin zle .accept-line
}
zle -N my_enter
bindkey '^m' my_enter

#
# chpwd内のlsでファイル数が多い場合に省略表示する
# http://qiita.com/yuyuchu3333/items/b10542db482c3ac8b059
#
#chpwd() {
#    ls_abbrev
#}
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-ACF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-ACFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

#
# extract http://d.hatena.ne.jp/jeneshicc/20110215/1297778049
#
extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2) tar xvjf $1 ;;
			*.tar.gz) tar xvzf $1 ;;
			*.tar.xz) tar xvJf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.rar) unrar x $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar xvf $1 ;;
			*.tbz2) tar xvjf $1 ;;
			*.tgz) tar xvzf $1 ;;
			*.zip) unzip $1 ;;
			*.Z) uncompress $1 ;;
			*.7z) 7z x $1 ;;
			*.lzma) lzma -dv $1 ;;
			*.xz) xz -dv $1 ;;
			*) echo "don't know how to extract '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}
alias ex='extract'

# # http://www.commandlinefu.com/commands/view/10889/hourglass
# hourglass 5
hourglass() {
	trap 'tput cnorm' EXIT INT;
	local s=$(($SECONDS +$1));
	(
		tput civis;
		while [[ $SECONDS -lt $s ]];
			do for f in '|' '\' '-' '/';
				do echo -n "$f" && sleep .2s && echo -n $'\b';
			done;
		done;
	);
	tput cnorm;
}

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

