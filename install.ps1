# install.ps1 - Windows dotfiles installer
# Run as Administrator or with Developer Mode enabled (for symlinks)

$DOTFILES = "$env:USERPROFILE\dotfiles"

# Helper: create symlink (file or directory)
function New-Symlink {
    param(
        [string]$Target,
        [string]$Link
    )

    if (Test-Path $Link) {
        $item = Get-Item $Link -Force
        if ($item.LinkType -eq "SymbolicLink") {
            Write-Host "  [SKIP] Already linked: $Link"
            return
        }
        $backup = "$Link.bak"
        Write-Host "  [BACKUP] $Link -> $backup"
        Move-Item -Path $Link -Destination $backup -Force
    }

    $parentDir = Split-Path -Parent $Link
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    $targetItem = Get-Item $Target -Force
    if ($targetItem.PSIsContainer) {
        New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null
    } else {
        New-Item -ItemType SymbolicLink -Path $Link -Target $Target | Out-Null
    }
    Write-Host "  [LINK] $Link -> $Target"
}

Write-Host "=== Windows dotfiles installer ==="
Write-Host ""

# --------------------------------------------------
# Symlinks: Windows-specific files
# --------------------------------------------------
Write-Host "[Windows configs]"
New-Symlink "$DOTFILES\windows\.wslconfig"                     "$env:USERPROFILE\.wslconfig"
New-Symlink "$DOTFILES\windows\.config\wezterm\wezterm.lua"    "$env:USERPROFILE\.config\wezterm\wezterm.lua"

# --------------------------------------------------
# Symlinks: Shared dotfiles
# --------------------------------------------------
Write-Host ""
Write-Host "[Shared configs]"
Remove-Item -Path "$env:USERPROFILE\.gitconfig"
New-Symlink "$DOTFILES\.gitconfig"                             "$env:USERPROFILE\.gitconfig"
New-Symlink "$DOTFILES\.config\nvim"                           "$env:USERPROFILE\AppData\Local\nvim"

# --------------------------------------------------
# PowerShell profile
# --------------------------------------------------
Write-Host ""
Write-Host "[PowerShell profile]"
$psProfileSource = "$DOTFILES\windows\Microsoft.PowerShell_profile.ps1"
if (Test-Path $psProfileSource) {
    # PowerShell 7.x
    New-Symlink $psProfileSource "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    # Windows PowerShell 5.x
    New-Symlink $psProfileSource "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
} else {
    Write-Host "  [SKIP] $psProfileSource not found"
}

# --------------------------------------------------
# Claude
# --------------------------------------------------
Write-Host ""
Write-Host "[Claude]"
$claudeDest = "$env:USERPROFILE\.claude"
if (Test-Path $claudeDest) {
    Write-Host "  [UPDATE] Copying .claude -> $claudeDest"
} else {
    Write-Host "  [COPY] .claude -> $claudeDest"
}
Copy-Item -Path "$DOTFILES\.claude" -Destination $claudeDest -Recurse -Force

Write-Host ""
Write-Host "=== Done ==="
