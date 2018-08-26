#!/bin/sh

rm -f ~/.config/nvim/init.vim
rm -f ~/.config/nvim
rm -rf ~/.cache/dein
rm -rf ~/dein.log
rm -rf ~/.local/share/nvim

rm -f ~/.vimrc
rm -f ~/.viminfo
rm -f ~/.vim

rm -rf ~/.anyenv

rm -f ~/.zshenv
rm -f ~/.zsh
rm -f ~/.zsh_history
rm -rf ~/.zplug
rm -rf ~/.enhancd

rm -rf ~/.tmux
rm -f ~/.tmux.conf

rm -f ~/.gitconfig
rm -f ~/.gemrc
rm -f ~/.hgrc
rm -f ~/.bundle

chsh -s $(which bash)

