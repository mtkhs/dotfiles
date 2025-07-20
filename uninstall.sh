#!/bin/sh

rm -f ~/.config/nvim/init.vim
rm -f ~/.config/nvim
rm -rf ~/.cache/dein
rm -rf ~/dein.log
rm -rf ~/.local/share/nvim

rm -f ~/.config/bat

rm -f ~/.vimrc
rm -f ~/.viminfo
rm -f ~/.vim

mise implode -y
#mise uninstall python
#mise uninstall node
#rm -rf ~/.cache/mise

rm -f ~/.zshenv
rm -f ~/.zsh
rm -f ~/.zsh_history
rm -rf ~/.zinit
rm -rf ~/.enhancd

rm -rf ~/.tmux
rm -f ~/.tmux.conf

rm -f ~/.latexmkrc
rm -f ~/.gitconfig
rm -f ~/.tigrc
rm -f ~/.gemrc
rm -f ~/.railsrc
rm -f ~/.hgrc
rm -f ~/.bundle

chsh -s $(which bash)

