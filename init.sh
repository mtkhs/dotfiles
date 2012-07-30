#!/bin/sh

DOTFILES="$HOME/dotfiles"

cd $DOTFILES

git submodule update --init

ln -s $DOTFILES/.zshrc $HOME/.zshrc
ln -s $DOTFILES/.zshenv $HOME/.zshenv
ln -s $DOTFILES/.zprofile $HOME/.zprofile
ln -s $DOTFILES/.vim $HOME/.vim
ln -s $DOTFILES/.vimrc $HOME/.vimrc
ln -s $DOTFILES/.tmux.conf $HOME/.tmux.conf

vim -c ':NeoBundleInstall'

ZSH=`which zsh`

echo ZSH
echo ZSH
echo ZSH

