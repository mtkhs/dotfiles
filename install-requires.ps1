# install-requires.ps1 - Windows dependencies installer (winget)

Write-Host "Install dependencies"

# --------------------------------------------------
# winget packages
# --------------------------------------------------
# PowerShell profile: eza / bat / ripgrep / delta / fzf / less / nvim
# configs: wezterm (windows/.config/wezterm), git (.gitconfig), nvim (.config/nvim)
$packages = @(
    "Microsoft.PowerShell"
    "wez.wezterm.nightly"
    "Git.Git"
    "GitHub.cli"
    "GNU.Wget2"
    "cURL.cURL"
    "jftuga.less"
    "uutils.coreutils"
    "eza-community.eza"
    "sharkdp.bat"
    "dandavison.delta"
    "BurntSushi.ripgrep.MSVC"
    "junegunn.fzf"
    "Neovim.Neovim"
    "OpenJS.NodeJS.LTS"
)

foreach ($id in $packages) {
    winget install -e --id $id --accept-source-agreements --accept-package-agreements
}

# --------------------------------------------------
# Claude Code
# --------------------------------------------------
irm https://claude.ai/install.ps1 | iex

# required CLIs (~/.claude/CLAUDE.md)
npm install -g '@google/gemini-cli'
npm install -g agent-browser
