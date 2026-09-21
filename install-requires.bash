#!/bin/bash

DOTFILES="$HOME/dotfiles"
source "${DOTFILES}/envs.bash"

echo "Install dependencies"
case ${OSTYPE} in
    linux*)
        case $OS_NAME in
            Debian | Ubuntu | Raspbian )
                sudo apt update
                # Ubuntu 18.04
                # golang-go # direnv
                # libncurses5-dev # tig
                # libncurses5-dev libevent-dev # tmux
                sudo apt install -y software-properties-common language-pack-en build-essential unzip
                sudo apt install -y autoconf golang-go libncurses5-dev libevent-dev libclang-dev \
                    zlib1g-dev libffi-dev libbz2-dev libreadline-dev libssl-dev libsqlite3-dev \
                    bison \
                    fonts-liberation fonts-noto-cjk fonts-ipafont-gothic fonts-ipafont-mincho \
                    luarocks

                # cargo
                #curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
                #
                #cargo install tree-sitter-cli
                ;;
            CentOS )
                ;;
            'Amazon Linux' )
                sudo dnf install -y util-linux-user libevent-devel sqlite-devel gnupg2 ncurses-devel utf8proc-devel --allowerasing
                sudo dnf groupinstall -y "Development Tools"
                ;;
        esac
        ;;
    darwin*)
        echo "Hello, darwin!"
        ;;
    *)
        echo "Unexpected system! Nothing to do!"
        ;;
esac

# --------------------------------------------------
# Claude Code
# --------------------------------------------------
curl -fsSL https://claude.ai/install.sh | bash

# required CLIs (~/.claude/CLAUDE.md)
npm install -g agent-browser

# MCP servers
claude mcp add serena -s user -- uvx --from git+https://github.com/oraios/serena serena start-mcp-server --context claude-code --enable-web-dashboard false
claude mcp add context7 -s user -- npx -y @upstash/context7-mcp@latest
claude mcp add playwright -s user -- npx @playwright/mcp@latest

# plugins
claude plugin marketplace add DietrichGebert/ponytail
claude plugin install ponytail@ponytail
