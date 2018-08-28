#!/bin/bash

DOTFILES="$HOME/dotfiles"

cd $DOTFILES

case ${OSTYPE} in
    darwin*)
        ln -s -h $DOTFILES/.zsh        $HOME/.zsh
        ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
        ln -s -h $DOTFILES/.vim        $HOME/.vim
        ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
        mkdir -p $HOME/.config
        ln -s -h $HOME/.vim            $HOME/.config/nvim
        ln -s    $HOME/.vimrc          $HOME/.config/nvim/init.vim
        ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
        ln -s    $DOTFILES/.gemrc      $HOME/.gemrc
        ln -s -h $DOTFILES/.bundle     $HOME/.bundle
        ln -s    $DOTFILES/.hgrc       $HOME/.hgrc
        ;;
    linux*)
        ln -s -T $DOTFILES/.zsh        $HOME/.zsh
        ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
        ln -s -T $DOTFILES/.vim        $HOME/.vim
        ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
        mkdir -p $HOME/.config
        ln -s -T $HOME/.vim            $HOME/.config/nvim
        ln -s    $HOME/.vimrc          $HOME/.config/nvim/init.vim
        ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
        ln -s    $DOTFILES/.gemrc      $HOME/.gemrc
        ln -s -T $DOTFILES/.bundle     $HOME/.bundle
        ln -s    $DOTFILES/.hgrc       $HOME/.hgrc
        ;;
    cygwin*)
        ln -s -T $DOTFILES/.zsh        $HOME/.zsh
        ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
        ln -s -T $DOTFILES/.vim        $HOME/.vim
        ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
        mkdir -p $HOME/.config
        ln -s -T $HOME/.vim            $HOME/.config/nvim
        ln -s    $HOME/.vimrc          $HOME/.config/nvim/init.vim
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
    PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
    mkdir -p $(anyenv root)/plugins
    git clone https://github.com/znz/anyenv-update $(anyenv root)/plugins/anyenv-update
    git clone https://github.com/znz/anyenv-git $(anyenv root)/plugins/anyenv-git
    anyenv install rbenv
    RBENV_ROOT="$(anyenv root)/envs/rbenv" # $(rbenv root)
    git clone https://github.com/sstephenson/rbenv-gem-rehash.git $RBENV_ROOT/plugins/rbenv-gem-rehash
    git clone https://github.com/rbenv/rbenv-default-gems.git $RBENV_ROOT/plugins/rbenv-default-gems
    cat > $RBENV_ROOT/default-gems << "EOF"
bundler
pry
EOF
fi

# zsh zplug
if [ -d ${HOME}/.zplug ]; then
    echo "zplug is already installed."
else
    echo "Install zplug..."
    git clone https://github.com/zplug/zplug ~/.zplug

    read -sp "ZPLUG_SUDO_PASSWORD: " input
    echo "ZPLUG_SUDO_PASSWORD=$input" > ~/.zsh/.ZPLUG_SUDO_PASSWORD
fi

# tmux tpm
if [ -d ${HOME}/.tmux/plugins ]; then
    echo "tpm is already installed."
else
    echo "Install tpm..."
    mkdir -p ~/.tmux
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# vim dein
if [ -d ${HOME}/.cache/dein ]; then
    echo "dein is already installed."
else
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ./installer.sh
    # For example, we just use `~/.cache/dein` as installation directory
    sh ./installer.sh ~/.cache/dein
    rm -f ./installer.sh
fi

# chsh
ZSH=`which zsh`
chsh -s $ZSH
