#!/bin/zsh

DOTFILES="$HOME/dotfiles"

source ~/.zsh/.zshrc

# Claude
cp -rf $DOTFILES/.claude $HOME/

# mise
mise self-update
mise upgrade

# zinit
zinit self-update
source ~/.zsh/.zshrc
zinit update
zinit cclear

# tmux
if type tmux &> /dev/null; then
    ~/.tmux/plugins/tpm/bin/update_plugins all
fi

