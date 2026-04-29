#!/bin/sh

rm -f ~/.config/nvim
rm -f ~/.config/bat
rm -f ~/.config/mise

rm -f ~/.vimrc
rm -f ~/.viminfo

mise implode -y
#mise uninstall python
#mise uninstall node
#rm -rf ~/.cache/mise

rm -f ~/.zshenv
rm -f ~/.zsh
rm -f ~/.zsh_history
rm -rf ~/.zinit

rm -rf ~/.tmux
rm -f ~/.tmux.conf

rm -f ~/.latexmkrc
rm -f ~/.gitconfig

chsh -s $(which bash)

