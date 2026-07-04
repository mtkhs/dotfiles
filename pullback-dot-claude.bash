#!/bin/bash
# pullback-dot-claude.bash - Sync the managed subset of ~/.claude back into dotfiles/.claude
#
# Bash port of pullback-dot-claude.ps1 (see its header for the design rationale):
# install.bash / update.bash deploy dotfiles/.claude -> ~/.claude by plain copy,
# so edits made under ~/.claude never flow back. This script is the REVERSE
# direction: it mirrors only the version-controlled subset of ~/.claude into
# dotfiles/.claude so the diff can be reviewed & committed.
#
# Comparison is content-based (cmp), not timestamp-based: the forward copy
# rewrites mtimes, so a timestamp diff would flag every file as changed.
#
# Usage:
#   bash pullback-dot-claude.bash            # apply
#   bash pullback-dot-claude.bash --dry-run  # show what would change, touch nothing

set -euo pipefail

DRY_RUN=0
if [ "${1:-}" = "--dry-run" ]; then
    DRY_RUN=1
fi

DOTFILES="$HOME/dotfiles"
SRC="$HOME/.claude"          # source of truth (the live config)
DST="$DOTFILES/.claude"      # destination (git-tracked)

# --- Managed subset -------------------------------------------------------
# Only these are version-controlled. Everything else in ~/.claude (cache/,
# projects/, history.jsonl, plugins/, sessions/, ...) is intentionally ignored.
# Keep this list in sync with pullback-dot-claude.ps1.
MANAGED_DIRS=(agents commands languages rules skills)
MANAGED_FILES=(CLAUDE.md settings.json)

# --- Pre-flight -----------------------------------------------------------
if [ ! -d "$SRC" ]; then
    echo "Source not found: $SRC" >&2
    exit 1
fi
if [ ! -d "$DOTFILES/.git" ]; then
    echo "Not a git repo: $DOTFILES (need git to review/revert)" >&2
    exit 1
fi
mkdir -p "$DST"

count_new=0
count_mod=0
count_del=0

# --- Helpers --------------------------------------------------------------

# Excludes, mirroring .gitignore (personal/local/log artifacts).
is_excluded() {
    local rel="$1"
    local leaf="${rel##*/}"
    case "$leaf" in
        settings.local.json | *.log) return 0 ;;
    esac
    case "/$rel" in
        */local/*) return 0 ;;   # commands/local, hooks/local, ...
    esac
    return 1
}

# Relative paths of all files under a root (empty if the root is absent).
rel_files() {
    local root="$1"
    [ -d "$root" ] || return 0
    (cd "$root" && find . -type f | sed 's|^\./||')
}

same_content() {
    [ -f "$2" ] && cmp -s "$1" "$2"
}

sync_one() {
    local src_file="$1"
    local dst_file="$2"
    local label="$3"

    if [ -f "$src_file" ]; then
        if same_content "$src_file" "$dst_file"; then
            return 0
        fi
        local kind
        if [ -f "$dst_file" ]; then
            kind="MOD"
            count_mod=$((count_mod + 1))
        else
            kind="NEW"
            count_new=$((count_new + 1))
        fi
        echo "  [$kind] $label"
        if [ "$DRY_RUN" -eq 0 ]; then
            mkdir -p "$(dirname "$dst_file")"
            cp -f "$src_file" "$dst_file"
        fi
    elif [ -f "$dst_file" ]; then
        count_del=$((count_del + 1))
        echo "  [DEL] $label"
        if [ "$DRY_RUN" -eq 0 ]; then
            rm -f "$dst_file"
        fi
    fi
}

# --- Run ------------------------------------------------------------------
echo "=== pull-back ~/.claude -> dotfiles/.claude ==="
if [ "$DRY_RUN" -eq 1 ]; then
    echo "(dry-run: no files will be changed)"
fi
echo ""

# Managed directories: union of src + dst relative files, compared by content.
for d in "${MANAGED_DIRS[@]}"; do
    while IFS= read -r rel; do
        [ -n "$rel" ] || continue
        is_excluded "$rel" && continue
        sync_one "$SRC/$d/$rel" "$DST/$d/$rel" "$d/$rel"
    done < <({ rel_files "$SRC/$d"; rel_files "$DST/$d"; } | sort -u)
done

# Managed top-level files.
for f in "${MANAGED_FILES[@]}"; do
    sync_one "$SRC/$f" "$DST/$f" "$f"
done

# Tidy: drop directories left empty by deletions (git tracks files, not dirs).
if [ "$DRY_RUN" -eq 0 ]; then
    for d in "${MANAGED_DIRS[@]}"; do
        if [ -d "$DST/$d" ]; then
            find "$DST/$d" -depth -type d -empty -delete
        fi
    done
fi

# --- Summary & review hint ------------------------------------------------
total=$((count_new + count_mod + count_del))
echo ""
echo "Summary: $count_new new, $count_mod modified, $count_del deleted"
echo ""

if [ "$total" -eq 0 ]; then
    echo "Already in sync. Nothing to do."
    exit 0
fi

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry-run only. Re-run without --dry-run to apply."
    exit 0
fi

echo "=== git status (.claude) ==="
git -C "$DOTFILES" status --short -- .claude
echo ""
echo "Review: git -C \"$DOTFILES\" diff -- .claude"
echo "Commit: git -C \"$DOTFILES\" add -A -- .claude && git -C \"$DOTFILES\" commit"
