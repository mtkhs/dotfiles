#!/bin/sh

DOTFILES="$HOME/dotfiles"

cd $DOTFILES

git submodule update --init

ln -s $DOTFILES/.zshrc $HOME/.zshrc
ln -s $DOTFILES/.vim $HOME/.vim
ln -s $DOTFILES/.vimrc $HOME/.vimrc

