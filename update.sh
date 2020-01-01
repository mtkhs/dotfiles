#!/bin/zsh

source ~/.zsh/.zshrc

anyenv update

zplugin self-update
zplugin update
zplugin cclear

if type nvim &> /dev/null; then
    nvim +":call dein#update() | :q"
fi

if type tmux &> /dev/null; then
    ~/.tmux/plugins/tpm/bin/update_plugins all
fi

