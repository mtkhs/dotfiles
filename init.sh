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
if [ -d ${HOME}/.anyenv ]; then
	echo "anyenv is already installed."
else
	echo "Install anyenv..."
	git clone https://github.com/riywo/anyenv ~/.anyenv
	mkdir -p ~/.anyenv/plugins
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyegnv-update
	git clone https://github.com/znz/anyenv-git.git ~/.anyenv/plugins/anyenv-git
fi

if ! type anyenv >/dev/null 2>&1; then
	export PATH="$HOME/.anyenv/bin:$PATH"
	eval "$(anyenv init - zsh)"
fi

# rbenv
if [ -d ${HOME}/.rbenv ]; then
	echo "rbenv is already installed."
else
	echo "Install rbenv"
	anyenv install rbenv
fi

# ndenv
if [ -d ${HOME}/.ndenv ]; then
	echo "ndenv is already installed."
else
	echo "Install ndenv"
	anyenv install ndenv
fi

# pyenv
if [ -d ${HOME}/.pyenv ]; then
	echo "pyenv is already installed."
else
	echo "Install pyenv"
	anyenv install pyenv
fi

# submodules
#git submodule update --init --recursive

# zsh
if [ -d ${HOME}/.zsh/.zplug ]; then
	echo "zplug is already installed."
else
	echo "Install zplug"
	git clone https://github.com/zplug/zplug ~/.zsh/.zplug
fi

# chsh
ZSH=`which zsh`
chsh -s $ZSH

