#!/bin/bash

DOTFILES="$HOME/dotfiles"
cd "$DOTFILES" || exit 1

# Helper: create symlink (force overwrite)
make_link() {
    local target="$1"
    local link="$2"

    if [ -d "$target" ]; then
        case ${OSTYPE} in
            darwin*) ln -sfh "$target" "$link" ;;
            linux*)  ln -sfT "$target" "$link" ;;
        esac
    else
        ln -sf "$target" "$link"
    fi
    echo "  [LINK] $link -> $target"
}

echo "=== dotfiles installer ==="
echo ""

# --------------------------------------------------
# Symlinks
# --------------------------------------------------
echo "[Symlinks]"
mkdir -p "$HOME/.config"
make_link "$DOTFILES/.zsh"          "$HOME/.zsh"
make_link "$DOTFILES/.zshenv"       "$HOME/.zshenv"
make_link "$DOTFILES/.vimrc"        "$HOME/.vimrc"
make_link "$DOTFILES/.config/bat"   "$HOME/.config/bat"
make_link "$DOTFILES/.config/nvim"  "$HOME/.config/nvim"
make_link "$DOTFILES/.config/mise"  "$HOME/.config/mise"
make_link "$DOTFILES/.tmux.conf"    "$HOME/.tmux.conf"
make_link "$DOTFILES/.gitconfig"    "$HOME/.gitconfig"

# --------------------------------------------------
# Claude
# --------------------------------------------------
echo ""
echo "[Claude]"
if [ -d "$HOME/.claude" ]; then
    echo "  [UPDATE] Copying .claude -> $HOME/.claude"
else
    echo "  [COPY] .claude -> $HOME/.claude"
fi
cp -rf "$DOTFILES/.claude" "$HOME/.claude"

# --------------------------------------------------
# zinit
# --------------------------------------------------
echo ""
echo "[zinit]"
if [ -d "$HOME/.zinit" ]; then
    echo "  [SKIP] Already installed."
else
    echo "  [INSTALL] zinit..."
    mkdir "$HOME/.zinit"
    git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
fi

# --------------------------------------------------
# mise
# --------------------------------------------------
echo ""
echo "[mise]"
if [ -f "$HOME/.local/bin/mise" ]; then
    echo "  [SKIP] Already installed."
else
    echo "  [INSTALL] mise..."
    curl https://mise.run | sh

    mise completion zsh > "$HOME/.zinit/completions/_mise"
    mise settings add idiomatic_version_file_enable_tools python
    mise settings add idiomatic_version_file_enable_tools node

    mise use -g node@latest
    mise use -g pnpm@latest
    mise use -g python@latest
    mise use -g uv@latest

    eval "$(mise activate bash)"
    pip install --upgrade pip
    pip install terminaltexteffects
fi

# --------------------------------------------------
# tmux tpm
# --------------------------------------------------
echo ""
echo "[tmux tpm]"
if [ -d "$HOME/.tmux/plugins" ]; then
    echo "  [SKIP] Already installed."
else
    echo "  [INSTALL] tpm..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "  [INSTALL] tpm plugins..."
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
fi

# --------------------------------------------------
# chsh
# --------------------------------------------------
echo ""
echo "[chsh]"
ZSH=$(which zsh)
if [ "$SHELL" = "$ZSH" ]; then
    echo "  [SKIP] Already using zsh."
else
    echo "  [SET] Default shell -> $ZSH"
    chsh -s "$ZSH"
fi

echo ""
echo "=== Done ==="