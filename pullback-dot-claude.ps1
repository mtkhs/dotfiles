# pullback-dot-claude.ps1 - Sync the managed subset of ~/.claude back into dotfiles/.claude
#
# install.ps1 deploys dotfiles/.claude -> ~/.claude by plain copy (not symlink),
# because ~/.claude also holds caches/history/projects that must NOT be tracked.
# As a result, edits made under ~/.claude after deployment never flow back.
# This script is the REVERSE direction: it mirrors only the version-controlled
# subset of ~/.claude into dotfiles/.claude so the diff can be reviewed & committed.
#
# It is intentionally NOT wired into update.bash / install.*: those copy
# dotfiles -> home (forward). Pull-back is the opposite direction and is a
# deliberate, review-then-commit action. Run it by hand when ~/.claude changed.
#
# Comparison is content-based (SHA-256), not timestamp-based: the forward copy
# rewrites mtimes, so a timestamp diff would flag every file as changed. Hashing
# reports only real content changes, which is what ends up in the commit.
#
# Usage:
#   pwsh pullback-dot-claude.ps1            # apply
#   pwsh pullback-dot-claude.ps1 -DryRun    # show what would change, touch nothing

[CmdletBinding()]
param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$DOTFILES = "$env:USERPROFILE\dotfiles"
$SRC = "$env:USERPROFILE\.claude"   # source of truth (the live config)
$DST = "$DOTFILES\.claude"          # destination (git-tracked)

# --- Managed subset -------------------------------------------------------
# Only these are version-controlled. Everything else in ~/.claude (cache/,
# projects/, history.jsonl, plugins/, sessions/, ...) is intentionally ignored.
# Keep this list in sync with what install.ps1 is expected to deploy.
$ManagedDirs  = @("agents", "commands", "languages", "rules", "skills")
$ManagedFiles = @("CLAUDE.md", "settings.json")

# Excludes, mirroring .gitignore (personal/local/log artifacts).
$ExcludeFilePatterns = @("settings.local.json", "*.log", "audit-*.log")
$ExcludeDirNames     = @("local")   # commands/local, hooks/local, ...

# Machine-specific keys. Claude Code reads these only from ~/.claude/settings.json
# (settings.local.json is ignored for them), so they cannot be separated by file.
# They are dropped on the way back instead, which keeps them out of the repo.
$MachineSpecificKeys = @("tui", "model", "autoMode")

# --- Pre-flight -----------------------------------------------------------
if (-not (Test-Path $SRC))             { throw "Source not found: $SRC" }
if (-not (Test-Path "$DOTFILES\.git")) { throw "Not a git repo: $DOTFILES (need git to review/revert)" }
if (-not (Test-Path $DST))             { New-Item -ItemType Directory -Path $DST -Force | Out-Null }

# --- Helpers --------------------------------------------------------------
function Test-Excluded([string]$relPath) {
    $segments = $relPath -split '[\\/]'
    $leaf = $segments[-1]
    foreach ($p in $ExcludeFilePatterns) { if ($leaf -like $p) { return $true } }
    foreach ($seg in $segments[0..($segments.Count - 2)]) {
        if ($ExcludeDirNames -contains $seg) { return $true }
    }
    return $false
}

# Relative paths of all (non-excluded) files under a root, or @() if absent.
function Get-RelFiles([string]$root) {
    if (-not (Test-Path $root)) { return @() }
    Get-ChildItem -Path $root -Recurse -File -Force | ForEach-Object {
        $rel = $_.FullName.Substring($root.Length).TrimStart('\', '/')
        if (-not (Test-Excluded $rel)) { $rel }
    }
}

function Test-SameContent([string]$a, [string]$b) {
    if (-not (Test-Path $b)) { return $false }
    (Get-FileHash -Algorithm SHA256 $a).Hash -eq (Get-FileHash -Algorithm SHA256 $b).Hash
}

$applied = -not $DryRun
$counts  = @{ new = 0; mod = 0; del = 0 }

function Sync-One([string]$srcFile, [string]$dstFile, [string]$label) {
    if (Test-Path $srcFile) {
        if (Test-SameContent $srcFile $dstFile) { return }
        $kind = if (Test-Path $dstFile) { "mod" } else { "new" }
        $script:counts[$kind]++
        Write-Host ("  [{0}] {1}" -f $kind.ToUpper(), $label)
        if ($script:applied) {
            $parent = Split-Path -Parent $dstFile
            if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
            Copy-Item $srcFile $dstFile -Force
        }
    } elseif (Test-Path $dstFile) {
        $script:counts.del++
        Write-Host ("  [DEL] {0}" -f $label)
        if ($script:applied) { Remove-Item $dstFile -Force }
    }
}

# settings.json is special-cased: machine-specific keys are dropped before it is
# written back. Output is 2-space JSON with LF endings, byte-identical to what
# pullback-dot-claude.bash writes, so the two platforms never fight over format.
function Sync-SettingsJson([string]$srcFile, [string]$dstFile, [string]$label) {
    if (-not (Test-Path $srcFile)) { Sync-One $srcFile $dstFile $label; return }

    $obj = Get-Content -Raw $srcFile | ConvertFrom-Json
    foreach ($k in $MachineSpecificKeys) { $obj.PSObject.Properties.Remove($k) }
    $srcText = (($obj | ConvertTo-Json -Depth 100) -replace "`r`n", "`n") + "`n"

    $dstText = if (Test-Path $dstFile) { [System.IO.File]::ReadAllText($dstFile) } else { $null }
    if ($dstText -eq $srcText) { return }

    $kind = if ($null -ne $dstText) { "mod" } else { "new" }
    $script:counts[$kind]++
    Write-Host ("  [{0}] {1} (machine-specific keys dropped: {2})" -f $kind.ToUpper(), $label, ($MachineSpecificKeys -join ", "))
    if ($script:applied) { [System.IO.File]::WriteAllText($dstFile, $srcText) }
}

# --- Run ------------------------------------------------------------------
Write-Host "=== pull-back ~/.claude -> dotfiles/.claude ===" -ForegroundColor Cyan
if ($DryRun) { Write-Host "(dry-run: no files will be changed)" -ForegroundColor Yellow }
Write-Host ""

# Managed directories: union of src + dst relative files, compared by content.
foreach ($d in $ManagedDirs) {
    $sDir = Join-Path $SRC $d
    $tDir = Join-Path $DST $d
    $rels = @(Get-RelFiles $sDir) + @(Get-RelFiles $tDir) | Sort-Object -Unique
    foreach ($rel in $rels) {
        Sync-One (Join-Path $sDir $rel) (Join-Path $tDir $rel) "$d/$rel"
    }
}

# Managed top-level files.
foreach ($f in $ManagedFiles) {
    $s = Join-Path $SRC $f
    $t = Join-Path $DST $f
    if ($f -eq "settings.json") { Sync-SettingsJson $s $t $f } else { Sync-One $s $t $f }
}

# Tidy: drop directories left empty by deletions (git tracks files, not dirs).
if ($applied) {
    foreach ($d in $ManagedDirs) {
        $tDir = Join-Path $DST $d
        if (Test-Path $tDir) {
            Get-ChildItem -Path $tDir -Recurse -Directory -Force |
                Sort-Object { $_.FullName.Length } -Descending |
                Where-Object { @(Get-ChildItem $_.FullName -Force).Count -eq 0 } |
                ForEach-Object { Remove-Item $_.FullName -Force }
        }
    }
}

# --- Summary & review hint ------------------------------------------------
$total = $counts.new + $counts.mod + $counts.del
Write-Host ""
Write-Host ("Summary: {0} new, {1} modified, {2} deleted" -f $counts.new, $counts.mod, $counts.del)
Write-Host ""

if ($total -eq 0) {
    Write-Host "Already in sync. Nothing to do." -ForegroundColor Green
    return
}

if ($DryRun) {
    Write-Host "Dry-run only. Re-run without -DryRun to apply." -ForegroundColor Yellow
    return
}

Write-Host "=== git status (.claude) ===" -ForegroundColor Cyan
& git -C $DOTFILES status --short -- .claude
Write-Host ""
Write-Host "Review: git -C `"$DOTFILES`" diff -- .claude" -ForegroundColor Green
Write-Host "Commit: git -C `"$DOTFILES`" add -A -- .claude; git -C `"$DOTFILES`" commit" -ForegroundColor Green
