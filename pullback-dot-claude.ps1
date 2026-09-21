# pullback-dot-claude.ps1 - Sync the tracked subset of ~/.claude back into dotfiles/.claude
#
# install.ps1 deploys dotfiles/.claude -> ~/.claude by plain copy (not symlink),
# because ~/.claude also holds caches/history/projects that must NOT be tracked.
# As a result, edits made under ~/.claude after deployment never flow back.
# This script is the REVERSE direction: it mirrors the tracked subset of
# ~/.claude into dotfiles/.claude so the diff can be reviewed & committed.
#
# The tracked set comes from git ls-files, so the repository itself decides what
# belongs to it. ~/.claude also carries files nobody here owns: the account sync
# bucket under skills/synced, and skills shipped inside an MCP package. Those
# rewrite themselves without our involvement. Working from the tracked set
# leaves them out with no list of exclusions to maintain. Whatever is present
# but untracked is reported, never written.
#
# It is intentionally NOT wired into update.zsh / install.*: those copy
# dotfiles -> home (forward). Pull-back is the opposite direction and is a
# deliberate, review-then-commit action. Run it by hand when ~/.claude changed.
#
# Comparison is content-based (SHA-256), not timestamp-based: the forward copy
# rewrites mtimes, so a timestamp diff would flag every file as changed. Hashing
# reports only real content changes, which is what ends up in the commit.
#
# Usage:
#   pwsh pullback-dot-claude.ps1                      # apply, using the defaults below
#   pwsh pullback-dot-claude.ps1 -DryRun              # show what would change, touch nothing
#   pwsh pullback-dot-claude.ps1 -ToDotClaude <path>  # write into another clone

[CmdletBinding()]
param(
    [switch]$DryRun,
    [string]$FromDotClaude = "$env:USERPROFILE\.claude",        # source of truth (the live config)
    [string]$ToDotClaude   = "$env:USERPROFILE\dotfiles\.claude" # destination (git-tracked)
)

$ErrorActionPreference = "Stop"

# --- Scanned subset -------------------------------------------------------
# Where in the live config to look. Tracked files found here are synced;
# untracked ones are reported. Everything outside (cache/, projects/,
# history.jsonl, plugins/, sessions/, ...) is never examined.
$ScanDirs  = @("agents", "commands", "languages", "rules", "skills")
$ScanFiles = @("CLAUDE.md", "settings.json")

# Machine-specific keys. Claude Code reads these only from ~/.claude/settings.json
# (settings.local.json is ignored for them), so they cannot be separated by file.
# They are dropped on the way back instead, which keeps them out of the repo.
$MachineSpecificKeys = @("tui", "model", "autoMode")

# --- Pre-flight -----------------------------------------------------------
if (-not (Test-Path $FromDotClaude)) {
    throw "Source not found: $FromDotClaude"
}

$dstParent = Split-Path -Parent $ToDotClaude
if (-not (Test-Path $dstParent)) {
    throw "Destination parent not found: $dstParent"
}

# git decides where the repository starts, rather than assuming .claude sits
# directly at its root.
$toplevel = & git -C $dstParent rev-parse --show-toplevel 2>$null
if ([string]::IsNullOrWhiteSpace($toplevel)) {
    throw "Not inside a git repo: $dstParent (need git to review/revert)"
}

if (-not (Test-Path $ToDotClaude)) {
    New-Item -ItemType Directory -Path $ToDotClaude -Force | Out-Null
}

# Absolute from here on, so every reported path names one place.
$REPO = (Resolve-Path $toplevel).Path
$SRC  = (Resolve-Path $FromDotClaude).Path
$DST  = (Resolve-Path $ToDotClaude).Path

if (-not $DST.StartsWith($REPO)) {
    throw "Destination is not inside $REPO`: $DST"
}
$DST_REL = $DST.Substring($REPO.Length).TrimStart('\', '/') -replace '\\', '/'

$applied = -not $DryRun
$counts  = @{ new = 0; mod = 0; del = 0; untracked = 0 }

# --- The tracked set ------------------------------------------------------

function Get-TrackedPaths {
    $listed = & git -C $REPO ls-files -- $DST_REL

    $paths = @{}
    foreach ($line in $listed) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        $paths[($line -replace "^$([regex]::Escape($DST_REL))/", '')] = $true
    }

    return $paths
}

$Tracked = Get-TrackedPaths

# --- Helpers --------------------------------------------------------------

# Relative paths of all files under a root, slash-separated, or @() if absent.
function Get-RelFiles([string]$root) {
    if (-not (Test-Path $root)) {
        return @()
    }

    Get-ChildItem -Path $root -Recurse -File -Force | ForEach-Object {
        $rel = $_.FullName.Substring($root.Length).TrimStart('\', '/')
        $rel -replace '\\', '/'
    }
}

function Test-SameContent([string]$a, [string]$b) {
    if (-not (Test-Path $b)) {
        return $false
    }

    (Get-FileHash -Algorithm SHA256 $a).Hash -eq (Get-FileHash -Algorithm SHA256 $b).Hash
}

function Sync-One([string]$srcFile, [string]$dstFile, [string]$label) {
    if (Test-Path $srcFile) {
        if (Test-SameContent $srcFile $dstFile) {
            return
        }

        $kind = if (Test-Path $dstFile) { "mod" } else { "new" }
        $script:counts[$kind]++
        Write-Host ("  [{0}] {1}" -f $kind.ToUpper(), $label)

        if ($script:applied) {
            $parent = Split-Path -Parent $dstFile
            if (-not (Test-Path $parent)) {
                New-Item -ItemType Directory -Path $parent -Force | Out-Null
            }
            Copy-Item $srcFile $dstFile -Force
        }
    }
    elseif (Test-Path $dstFile) {
        $script:counts.del++
        Write-Host ("  [DEL] {0}" -f $label)

        if ($script:applied) {
            Remove-Item $dstFile -Force
        }
    }
}

# Order object keys by code point, matching what Python's sort_keys=True does in
# pullback-dot-claude.bash, so both ports keep writing the same bytes.
function Sort-JsonKeys($value) {
    if ($value -is [System.Management.Automation.PSCustomObject]) {
        $names = [string[]]@($value.PSObject.Properties.Name)
        [Array]::Sort($names, [System.StringComparer]::Ordinal)

        $ordered = [ordered]@{}
        foreach ($name in $names) {
            $ordered[$name] = Sort-JsonKeys $value.$name
        }

        return [PSCustomObject]$ordered
    }

    if ($value -is [System.Collections.IList]) {
        $items = [System.Collections.ArrayList]::new()
        foreach ($item in $value) {
            [void]$items.Add((Sort-JsonKeys $item))
        }

        return , $items.ToArray()
    }

    return $value
}

# settings.json is special-cased: machine-specific keys are dropped before it is
# written back. Claude Code rewrites the file in whatever key order it likes, so
# the keys are sorted here and only real edits show up as a diff. Output is
# 2-space JSON with LF endings, byte-identical to what pullback-dot-claude.bash
# writes, so the two platforms never fight over format.
function Sync-SettingsJson([string]$srcFile, [string]$dstFile, [string]$label) {
    if (-not (Test-Path $srcFile)) {
        Sync-One $srcFile $dstFile $label
        return
    }

    $obj = Get-Content -Raw $srcFile | ConvertFrom-Json
    foreach ($key in $MachineSpecificKeys) {
        $obj.PSObject.Properties.Remove($key)
    }
    $srcText = ((Sort-JsonKeys $obj | ConvertTo-Json -Depth 100) -replace "`r`n", "`n") + "`n"

    $dstText = if (Test-Path $dstFile) { [System.IO.File]::ReadAllText($dstFile) } else { $null }
    if ($dstText -eq $srcText) {
        return
    }

    $kind = if ($null -ne $dstText) { "mod" } else { "new" }
    $script:counts[$kind]++
    Write-Host ("  [{0}] {1} (machine-specific keys dropped: {2})" -f $kind.ToUpper(), $label, ($MachineSpecificKeys -join ", "))

    if ($script:applied) {
        [System.IO.File]::WriteAllText($dstFile, $srcText)
    }
}

# --- Untracked reporting --------------------------------------------------

# Untracked files are grouped at <dir>/<child>, so a vendor-delivered tree of
# hundreds of files takes one line instead of burying the real findings.
function Get-Group([string]$rel) {
    $segments = $rel -split '/'

    if ($segments.Count -le 2) {
        return $rel
    }

    return "$($segments[0])/$($segments[1])"
}

function Write-Untracked {
    $groups = @{}

    foreach ($dir in $ScanDirs) {
        foreach ($rel in Get-RelFiles (Join-Path $SRC $dir)) {
            if ($Tracked.ContainsKey("$dir/$rel")) {
                continue
            }

            $group = Get-Group "$dir/$rel"
            $groups[$group] = 1 + $(if ($groups.ContainsKey($group)) { $groups[$group] } else { 0 })
        }
    }

    foreach ($file in $ScanFiles) {
        if ((Test-Path (Join-Path $SRC $file)) -and -not $Tracked.ContainsKey($file)) {
            $groups[$file] = 1
        }
    }

    foreach ($group in ($groups.Keys | Sort-Object)) {
        $script:counts.untracked++

        if (Test-Path -PathType Leaf (Join-Path $SRC $group)) {
            Write-Host ("  [SKIP] {0} (untracked)" -f $group)
        }
        else {
            $noun = if ($groups[$group] -eq 1) { "file" } else { "files" }
            Write-Host ("  [SKIP] {0}/ ({1} {2}, untracked)" -f $group, $groups[$group], $noun)
        }
    }
}

# --- Run ------------------------------------------------------------------
Write-Host ("=== pull-back {0} -> {1} ===" -f $SRC, $DST) -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "(dry-run: no files will be changed)" -ForegroundColor Yellow
}

Write-Host ""

foreach ($rel in ($Tracked.Keys | Sort-Object)) {
    $srcFile = Join-Path $SRC $rel
    $dstFile = Join-Path $DST $rel

    if ($rel -eq "settings.json") {
        Sync-SettingsJson $srcFile $dstFile $rel
    }
    else {
        Sync-One $srcFile $dstFile $rel
    }
}

Write-Untracked

# Tidy: drop directories left empty by deletions (git tracks files, not dirs).
if ($applied) {
    foreach ($dir in $ScanDirs) {
        $target = Join-Path $DST $dir
        if (Test-Path $target) {
            Get-ChildItem -Path $target -Recurse -Directory -Force |
                Sort-Object { $_.FullName.Length } -Descending |
                Where-Object { @(Get-ChildItem $_.FullName -Force).Count -eq 0 } |
                ForEach-Object { Remove-Item $_.FullName -Force }
        }
    }
}

# --- Summary & review hint ------------------------------------------------
$total = $counts.new + $counts.mod + $counts.del

Write-Host ""
Write-Host ("Summary: {0} new, {1} modified, {2} deleted, {3} untracked" -f $counts.new, $counts.mod, $counts.del, $counts.untracked)
Write-Host ""

if ($counts.untracked -gt 0) {
    Write-Host "Untracked paths are reported, not copied. To bring one in:"
    Write-Host ("  Copy-Item -Recurse `"{0}\<path>`" `"{1}\<path>`"; git -C `"{2}`" add -- `"{3}/<path>`"" -f $SRC, $DST, $REPO, $DST_REL)
    Write-Host ""
}

if ($total -eq 0) {
    Write-Host "Already in sync. Nothing to do." -ForegroundColor Green
    return
}

if ($DryRun) {
    Write-Host "Dry-run only. Re-run without -DryRun to apply." -ForegroundColor Yellow
    return
}

Write-Host ("=== git status ({0}) ===" -f $DST_REL) -ForegroundColor Cyan
& git -C $REPO status --short -- $DST_REL
Write-Host ""
Write-Host ("Review: git -C `"{0}`" diff -- `"{1}`"" -f $REPO, $DST_REL) -ForegroundColor Green
Write-Host ("Commit: git -C `"{0}`" add -A -- `"{1}`"; git -C `"{0}`" commit" -f $REPO, $DST_REL) -ForegroundColor Green
