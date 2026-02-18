#!/bin/zsh

source ~/.zsh/.zshrc

mise self-update
mise upgrade

zinit self-update
source ~/.zsh/.zshrc

zinit update
zinit cclear

if type tmux &> /dev/null; then
    ~/.tmux/plugins/tpm/bin/update_plugins all
fi

