#!/bin/zsh

DOTFILES="$HOME/dotfiles"

cd $DOTFILES

case ${OSTYPE} in
	darwin*)
		ln -s -h $DOTFILES/.zsh        $HOME/.zsh
		ln -s    $DOTFILES/.zshrc      $HOME/.zshrc
		ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
		ln -s    $DOTFILES/.zprofile   $HOME/.zprofile
		ln -s -h $DOTFILES/.vim        $HOME/.vim
		ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
		ln -s    $DOTFILES/.gvimrc     $HOME/.gvimrc
		ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
		ln -s    $DOTFILES/.gemrc      $HOME/.gemrc
		ln -s -h $DOTFILES/.bundle     $HOME/.bundle
		ln -s    $DOTFILES/.hgrc       $HOME/.hgrc
		;;
	linux*)
		ln -s -T $DOTFILES/.zsh        $HOME/.zsh
		ln -s    $DOTFILES/.zshrc      $HOME/.zshrc
		ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
		ln -s    $DOTFILES/.zprofile   $HOME/.zprofile
		ln -s -T $DOTFILES/.vim        $HOME/.vim
		ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
		ln -s    $DOTFILES/.gvimrc     $HOME/.gvimrc
		ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
		ln -s    $DOTFILES/.gemrc      $HOME/.gemrc
		ln -s -T $DOTFILES/.bundle     $HOME/.bundle
		ln -s    $DOTFILES/.hgrc       $HOME/.hgrc
		;;
	cygwin*)
		ln -s -T $DOTFILES/.zsh        $HOME/.zsh
		ln -s    $DOTFILES/.zshrc      $HOME/.zshrc
		ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
		ln -s    $DOTFILES/.zprofile   $HOME/.zprofile
		ln -s -T $DOTFILES/.vim        $HOME/.vim
		ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
		ln -s    $DOTFILES/.gvimrc     $HOME/.gvimrc
		ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
		ln -s    $DOTFILES/.gemrc      $HOME/.gemrc
		ln -s -T $DOTFILES/.bundle     $HOME/.bundle
		ln -s    $DOTFILES/.hgrc       $HOME/.hgrc
		ln -s    $DOTFILES/.minttyrc   $HOME/.minttyrc
		;;
esac

# anyenv
git clone https://github.com/riywo/anyenv ~/.anyenv
mkdir -p ~/.anyenv/plugins
git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyegnv-update
git clone https://github.com/znz/anyenv-git.git ~/.anyenv/plugins/anyenv-git
#anyenv install rbenv
#anyenv install ndenv
#anyenv install pyenv

# submodules
#git submodule update --init --recursive

# vim
#vim -c ':NeoBundleInstall' -c q

# zsh
curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug

# chsh
ZSH=`which zsh`
chsh -s $ZSH

