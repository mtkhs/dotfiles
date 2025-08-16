#!/bin/bash

DOTFILES="$HOME/dotfiles"
cd $DOTFILES

mkdir -p $HOME/.config/

case ${OSTYPE} in
    darwin*)
        ln -s -h $DOTFILES/.zsh         $HOME/.zsh
        ln -s    $DOTFILES/.zshenv      $HOME/.zshenv
        ln -s    $DOTFILES/.vimrc       $HOME/.vimrc
        ln -s -h $DOTFILES/.config/bat  $HOME/.config/bat
        ln -s -h $DOTFILES/.config/nvim $HOME/.config/nvim
        ln -s -h $DOTFILES/.config/mise $HOME/.config/mise
        ln -s    $DOTFILES/.tmux.conf   $HOME/.tmux.conf
        ln -s    $DOTFILES/.gitconfig   $HOME/.gitconfig
        ln -s    $DOTFILES/.latexmkrc   $HOME/.latexmkrc
        ;;
    linux*)
        ln -s -T $DOTFILES/.zsh         $HOME/.zsh
        ln -s    $DOTFILES/.zshenv      $HOME/.zshenv
        ln -s    $DOTFILES/.vimrc       $HOME/.vimrc
        ln -s -T $DOTFILES/.config/bat  $HOME/.config/bat
        ln -s -T $DOTFILES/.config/nvim $HOME/.config/nvim
        ln -s -T $DOTFILES/.config/mise $HOME/.config/mise
        ln -s    $DOTFILES/.tmux.conf   $HOME/.tmux.conf
        ln -s    $DOTFILES/.gitconfig   $HOME/.gitconfig
        ;;
esac

# zsh zinit
if [ -d ${HOME}/.zinit ]; then
    echo "zinit is already installed."
else
    echo "Install zinit..."
    mkdir ${HOME}/.zinit
    git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# mise
if [ -f ${HOME}/.local/bin/mise ]; then
    echo "mise is already installed."
else
    echo "Install mise..."
    curl https://mise.run | sh

    mise completion zsh > ${HOME}/.zinit/completions/_mise
    mise settings add idiomatic_version_file_enable_tools python
    mise settings add idiomatic_version_file_enable_tools node

    #LATEST_PYTHON=`mise latest python`
    #mise install python@${LATEST_PYTHON}
    #mise use python@${LATEST_PYTHON} --global

    #LATEST_NODE=`mise latest node`
    #mise install node@${LATEST_NODE}
    #mise use node@${LATEST_NODE} --global

    mise use -g node@latest
    mise use -g python@latest
    mise use -g uv@latest

    eval "$(mise activate bash)"
    pip install --upgrade pip
    pip install terminaltexteffects
fi

# tmux tpm
if [ -d ${HOME}/.tmux/plugins ]; then
    echo "tpm is already installed."
else
    echo "Install tpm..."
    mkdir -p ~/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "Install tpm plugins..."
    ${HOME}/.tmux/plugins/tpm/bin/install_plugins
fi

# chsh
ZSH=`which zsh`
chsh -s $ZSH

