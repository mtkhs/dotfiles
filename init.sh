#!/bin/zsh

DOTFILES="$HOME/dotfiles"

cd $DOTFILES

case ${OSTYPE} in
	darwin*)
		ln -s    $DOTFILES/.zshrc      $HOME/.zshrc
		ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
		ln -s    $DOTFILES/.zprofile   $HOME/.zprofile
		ln -s -h $DOTFILES/.vim        $HOME/.vim
		ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
		ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
		ln -s -h $DOTFILES/.bundler    $HOME/.bundler
		;;
	linux*)
		ln -s    $DOTFILES/.zshrc      $HOME/.zshrc
		ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
		ln -s    $DOTFILES/.zprofile   $HOME/.zprofile
		ln -s -T $DOTFILES/.vim        $HOME/.vim
		ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
		ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
		ln -s -T $DOTFILES/.bundler    $HOME/.bundler
		;;
esac

# vim
git submodule update --init --recursive
vim -c ':NeoBundleInstall' -c q

# chsh
ZSH=`which zsh`
chsh -s $ZSH

# rvm
#curl -L https://get.rvm.io | bash

# pybrew
#curl -kL http://xrl.us/pythonbrewinstall | bash

