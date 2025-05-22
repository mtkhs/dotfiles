#!/bin/zsh

source ~/.zsh/.zshrc

#anyenv update

zinit self-update
source ~/.zsh/.zshrc

compaudit

zinit update
zinit cclear

#if type nvim &> /dev/null; then
#    nvim +":call dein#update() | :q"
#fi

if type tmux &> /dev/null; then
    ~/.tmux/plugins/tpm/bin/update_plugins all
fi

