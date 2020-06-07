#!/bin/bash

DOTFILES="$HOME/dotfiles"

cd $DOTFILES

mkdir -p $HOME/.config/

case ${OSTYPE} in
    darwin*)
        ln -s -h $DOTFILES/.zsh        $HOME/.zsh
        ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
        ln -s -h $DOTFILES/.vim        $HOME/.vim
        ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
        ln -s -h $DOTFILES/.config/bat $HOME/.config/bat
        ln -s -h $HOME/.vim            $HOME/.config/nvim
        ln -s    $HOME/.vimrc          $HOME/.config/nvim/init.vim
        ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
        ln -s    $DOTFILES/.gitconfig  $HOME/.gitconfig
        ln -s    $DOTFILES/.tigrc      $HOME/.tigrc
        ln -s    $DOTFILES/.gemrc      $HOME/.gemrc
        ln -s    $DOTFILES/.railsrc    $HOME/.railsrc
        ln -s -h $DOTFILES/.bundle     $HOME/.bundle
        ln -s    $DOTFILES/.hgrc       $HOME/.hgrc
        ln -s    $DOTFILES/.latexmkrc  $HOME/.latexmkrc
        ;;
    linux*)
        ln -s -T $DOTFILES/.zsh        $HOME/.zsh
        ln -s    $DOTFILES/.zshenv     $HOME/.zshenv
        ln -s -T $DOTFILES/.vim        $HOME/.vim
        ln -s    $DOTFILES/.vimrc      $HOME/.vimrc
        ln -s -T $DOTFILES/.config/bat $HOME/.config/bat
        ln -s -T $HOME/.vim            $HOME/.config/nvim
        ln -s    $HOME/.vimrc          $HOME/.config/nvim/init.vim
        ln -s    $DOTFILES/.tmux.conf  $HOME/.tmux.conf
        ln -s    $DOTFILES/.gitconfig  $HOME/.gitconfig
        ln -s    $DOTFILES/.tigrc      $HOME/.tigrc
        ln -s    $DOTFILES/.gemrc      $HOME/.gemrc
        ln -s    $DOTFILES/.railsrc    $HOME/.railsrc
        ln -s -T $DOTFILES/.bundle     $HOME/.bundle
        ln -s    $DOTFILES/.hgrc       $HOME/.hgrc
        ln -s    $DOTFILES/.latexmkrc  $HOME/.latexmkrc
#        ln -s    $DOTFILES/.rubocop.yml $HOME/.rubocop.yml
#        ln -s    $DOTFILES/.pylintrc $HOME/.pylintrc
#        ln -s    $DOTFILES/.eslintrc.js $HOME/.eslintrc.js
        ;;
esac

# anyenv
if [ -d ${HOME}/.anyenv ]; then
    echo "anyenv is already installed."
else
    echo "Install anyenv..."
    git clone https://github.com/anyenv/anyenv ~/.anyenv
    export PATH="$HOME/.anyenv/bin:$PATH"
    yes | anyenv install --init
    eval "$(anyenv init - --no-rehash)"
    mkdir -p $(anyenv root)/plugins
    git clone https://github.com/znz/anyenv-update $(anyenv root)/plugins/anyenv-update
    git clone https://github.com/znz/anyenv-git $(anyenv root)/plugins/anyenv-git

    anyenv install rbenv
    RBENV_ROOT="$(anyenv root)/envs/rbenv" # $(rbenv root)
#    git clone https://github.com/sstephenson/rbenv-gem-rehash.git $RBENV_ROOT/plugins/rbenv-gem-rehash
    git clone https://github.com/rbenv/rbenv-default-gems.git $RBENV_ROOT/plugins/rbenv-default-gems
    cat > $RBENV_ROOT/default-gems << "EOF"
bundler
pry
EOF

    anyenv install pyenv
    PYENV_ROOT="$(anyenv root)/envs/pyenv" # $(pyenv root)
#    git clone https://github.com/yyuu/pyenv-pip-rehash.git $PYENV_ROOT/plugins/pyenv-pip-rehash
#    git clone https://github.com/yyuu/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv
#    pip3 install --user pipenv

    anyenv install phpenv
    PHPENV_ROOT="$(anyenv root)/envs/phpenv" # $(phpenv root)

    anyenv install nodenv
    NODENV_ROOT="$(anyenv root)/envs/nodenv" # $(nodenv root)
    git clone https://github.com/nodenv/nodenv-package-rehash.git $NODENV_ROOT/plugins/nodenv-package-rehash
    git clone https://github.com/nodenv/nodenv-default-packages.git $NODENV_ROOT/plugins/nodenv-default-packages
    cat > $NODENV_ROOT/default-packages << "EOF"
yarn
EOF

    anyenv install goenv
    GOENV_ROOT="$(anyenv root)/envs/goenv" # $(goenv root)
fi

# zsh zinit
if [ -d ${HOME}/.zinit ]; then
    echo "zinit is already installed."
else
    echo "Install zinit..."
    mkdir ~/.zinit
    git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# zsh zplug
#if [ -d ${HOME}/.zplug ]; then
#    echo "zplug is already installed."
#else
#    echo "Install zplug..."
#    git clone https://github.com/zplug/zplug ~/.zplug
#
#    read -sp "ZPLUG_SUDO_PASSWORD: " input
#    echo "ZPLUG_SUDO_PASSWORD=$input" > ~/.zsh/.ZPLUG_SUDO_PASSWORD
#fi

# tmux tpm
if [ -d ${HOME}/.tmux/plugins ]; then
    echo "tpm is already installed."
else
    echo "Install tpm..."
    mkdir -p ~/.tmux
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "Install tpm plugins..."
    ${HOME}/.tmux/plugins/tpm/bin/install_plugins
fi

# vim dein
if [ -d ${HOME}/.cache/dein ]; then
    echo "dein is already installed."
else
    echo "Install dein..."
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > ${HOME}/dein-installer.sh
    sh ${HOME}/dein-installer.sh ~/.cache/dein
    rm -f ${HOME}/dein-installer.sh
fi

# chsh
ZSH=`which zsh`
chsh -s $ZSH

