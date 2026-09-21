#!/bin/bash
# pullback-dot-claude.bash - Sync the tracked subset of ~/.claude back into dotfiles/.claude
#
# Bash port of pullback-dot-claude.ps1 (see its header for the design rationale):
# install.bash / update.zsh deploy dotfiles/.claude -> ~/.claude by plain copy,
# so edits made under ~/.claude never flow back. This script is the REVERSE
# direction: it mirrors the tracked subset of ~/.claude into dotfiles/.claude so
# the diff can be reviewed & committed.
#
# The tracked set comes from git ls-files, so the repository itself decides what
# belongs to it. ~/.claude also carries files nobody here owns: the account sync
# bucket under skills/synced, and skills shipped inside an MCP package. Those
# rewrite themselves without our involvement. Working from the tracked set
# leaves them out with no list of exclusions to maintain. Whatever is present
# but untracked is reported, never written.
#
# Comparison is content-based (cmp), not timestamp-based: the forward copy
# rewrites mtimes, so a timestamp diff would flag every file as changed.
#
# Usage:
#   bash pullback-dot-claude.bash                     # apply, using the defaults below
#   bash pullback-dot-claude.bash --dry-run           # show what would change, touch nothing
#   bash pullback-dot-claude.bash --to-dot-claude <p> # write into another clone

set -euo pipefail

DRY_RUN=0
FROM_DOT_CLAUDE="$HOME/.claude"            # source of truth (the live config)
TO_DOT_CLAUDE="$HOME/dotfiles/.claude"     # destination (git-tracked)

usage() {
    echo "Usage: bash pullback-dot-claude.bash [--dry-run] [--from-dot-claude <path>] [--to-dot-claude <path>]"
    echo "  --dry-run                 report what would change, write nothing"
    echo "  --from-dot-claude <path>  live config to read   (default: \$HOME/.claude)"
    echo "  --to-dot-claude <path>    tracked copy to write (default: \$HOME/dotfiles/.claude)"
}

require_value() {
    local option="$1"
    local value="$2"

    if [ -z "$value" ]; then
        echo "$option needs a path" >&2
        usage >&2
        exit 1
    fi
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --from-dot-claude)
            require_value "$1" "${2:-}"
            FROM_DOT_CLAUDE="$2"
            shift 2
            ;;
        --to-dot-claude)
            require_value "$1" "${2:-}"
            TO_DOT_CLAUDE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

# --- Scanned subset -------------------------------------------------------
# Where in the live config to look. Tracked files found here are synced;
# untracked ones are reported. Everything outside (cache/, projects/,
# history.jsonl, plugins/, sessions/, ...) is never examined.
SCAN_DIRS=(agents commands languages rules skills)
SCAN_FILES=(CLAUDE.md settings.json)

# Machine-specific keys. Claude Code reads these only from ~/.claude/settings.json
# (settings.local.json is ignored for them), so they cannot be separated by file.
# They are dropped on the way back instead, which keeps them out of the repo.
MACHINE_SPECIFIC_KEYS=(tui model autoMode)

# --- Locating python ------------------------------------------------------
# Python is named python3 on Unix and python on Windows, and a bare `python`
# can still be Python 2, so python3 is tried first.
find_python() {
    local name
    local found

    for name in python3 python; do
        found="$(command -v "$name" 2>/dev/null)"
        if [ -n "$found" ]; then
            echo "$found"
            return 0
        fi
    done

    return 1
}

PYTHON="$(find_python || true)"

# --- Pre-flight -----------------------------------------------------------
if [ ! -d "$FROM_DOT_CLAUDE" ]; then
    echo "Source not found: $FROM_DOT_CLAUDE" >&2
    exit 1
fi

DST_PARENT="$(dirname "$TO_DOT_CLAUDE")"
if [ ! -d "$DST_PARENT" ]; then
    echo "Destination parent not found: $DST_PARENT" >&2
    exit 1
fi

# git decides where the repository starts, rather than assuming .claude sits
# directly at its root. pwd normalises the answer to this shell's path style so
# it can be compared with the destination.
REPO="$(cd "$DST_PARENT" && git rev-parse --show-toplevel 2>/dev/null)" || true
if [ -z "$REPO" ]; then
    echo "Not inside a git repo: $DST_PARENT (need git to review/revert)" >&2
    exit 1
fi
REPO="$(cd "$REPO" && pwd)"

if [ -z "$PYTHON" ]; then
    echo "neither python3 nor python found on PATH (needed to drop machine-specific keys from settings.json)" >&2
    exit 1
fi

mkdir -p "$TO_DOT_CLAUDE"

# Absolute from here on, so every reported path names one place.
SRC="$(cd "$FROM_DOT_CLAUDE" && pwd)"
DST="$(cd "$TO_DOT_CLAUDE" && pwd)"
DST_REL="${DST#"$REPO"/}"

if [ "$DST_REL" = "$DST" ]; then
    echo "Destination is not inside $REPO: $DST" >&2
    exit 1
fi

count_mod=0
count_new=0
count_del=0
count_untracked=0

# --- The tracked set ------------------------------------------------------

declare -A TRACKED

load_tracked() {
    local rel

    while IFS= read -r rel; do
        if [ -n "$rel" ]; then
            TRACKED["${rel#"$DST_REL"/}"]=1
        fi
    done < <(git -C "$REPO" ls-files -- "$DST_REL")
}

is_tracked() {
    local rel="$1"

    [ -n "${TRACKED[$rel]:-}" ]
}

# --- Helpers --------------------------------------------------------------

# Relative paths of all files under a root (nothing if the root is absent).
rel_files() {
    local root="$1"

    if [ ! -d "$root" ]; then
        return 0
    fi

    (cd "$root" && find . -type f | sed "s|^\./||")
}

same_content() {
    local a="$1"
    local b="$2"

    [ -f "$b" ] && cmp -s "$a" "$b"
}

sync_one() {
    local src_file="$1"
    local dst_file="$2"
    local label="$3"
    local kind

    if [ -f "$src_file" ]; then
        if same_content "$src_file" "$dst_file"; then
            return 0
        fi

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

# settings.json is special-cased: machine-specific keys are dropped before it is
# written back. Output is 2-space JSON with LF endings, byte-identical to what
# pullback-dot-claude.ps1 writes, so the two platforms never fight over format.
sync_settings_json() {
    local src_file="$1"
    local dst_file="$2"
    local label="$3"
    local stripped
    local kind

    if [ ! -f "$src_file" ]; then
        sync_one "$src_file" "$dst_file" "$label"
        return 0
    fi

    stripped="$(mktemp)"
    "$PYTHON" -c "
import json, sys
src, out, keys = sys.argv[1], sys.argv[2], sys.argv[3:]
d = json.load(open(src))
for k in keys:
    d.pop(k, None)
with open(out, 'w', newline='\n') as f:
    f.write(json.dumps(d, indent=2, ensure_ascii=False) + '\n')
" "$src_file" "$stripped" "${MACHINE_SPECIFIC_KEYS[@]}"

    if same_content "$stripped" "$dst_file"; then
        rm -f "$stripped"
        return 0
    fi

    if [ -f "$dst_file" ]; then
        kind="MOD"
        count_mod=$((count_mod + 1))
    else
        kind="NEW"
        count_new=$((count_new + 1))
    fi

    echo "  [$kind] $label (machine-specific keys dropped: ${MACHINE_SPECIFIC_KEYS[*]})"

    if [ "$DRY_RUN" -eq 0 ]; then
        mkdir -p "$(dirname "$dst_file")"
        cp -f "$stripped" "$dst_file"
    fi

    rm -f "$stripped"
}

# --- Untracked reporting --------------------------------------------------

# Untracked files are grouped at <dir>/<child>, so a vendor-delivered tree of
# hundreds of files takes one line instead of burying the real findings.
group_of() {
    local rel="$1"
    local slashes

    slashes="$(printf '%s' "$rel" | tr -cd '/' | wc -c)"

    if [ "$slashes" -le 1 ]; then
        echo "$rel"
        return 0
    fi

    printf '%s\n' "$rel" | cut -d/ -f1,2
}

list_untracked_groups() {
    local dir
    local file
    local rel

    for dir in "${SCAN_DIRS[@]}"; do
        while IFS= read -r rel; do
            if [ -n "$rel" ] && ! is_tracked "$dir/$rel"; then
                group_of "$dir/$rel"
            fi
        done < <(rel_files "$SRC/$dir")
    done

    for file in "${SCAN_FILES[@]}"; do
        if [ -f "$SRC/$file" ] && ! is_tracked "$file"; then
            echo "$file"
        fi
    done
}

report_untracked() {
    local group
    local files

    while read -r files group; do
        if [ -z "$group" ]; then
            continue
        fi

        count_untracked=$((count_untracked + 1))

        if [ -f "$SRC/$group" ]; then
            echo "  [SKIP] $group (untracked)"
        elif [ "$files" -eq 1 ]; then
            echo "  [SKIP] $group/ (1 file, untracked)"
        else
            echo "  [SKIP] $group/ ($files files, untracked)"
        fi
    done < <(list_untracked_groups | sort | uniq -c)
}

# --- Run ------------------------------------------------------------------
echo "=== pull-back $SRC -> $DST ==="

if [ "$DRY_RUN" -eq 1 ]; then
    echo "(dry-run: no files will be changed)"
fi

echo ""

load_tracked

while IFS= read -r rel; do
    if [ "$rel" = "settings.json" ]; then
        sync_settings_json "$SRC/$rel" "$DST/$rel" "$rel"
    else
        sync_one "$SRC/$rel" "$DST/$rel" "$rel"
    fi
done < <(printf '%s\n' "${!TRACKED[@]}" | sort)

report_untracked

# Tidy: drop directories left empty by deletions (git tracks files, not dirs).
if [ "$DRY_RUN" -eq 0 ]; then
    for dir in "${SCAN_DIRS[@]}"; do
        if [ -d "$DST/$dir" ]; then
            find "$DST/$dir" -depth -type d -empty -delete
        fi
    done
fi

# --- Summary & review hint ------------------------------------------------
total=$((count_new + count_mod + count_del))

echo ""
echo "Summary: $count_new new, $count_mod modified, $count_del deleted, $count_untracked untracked"
echo ""

if [ "$count_untracked" -gt 0 ]; then
    echo "Untracked paths are reported, not copied. To bring one in:"
    echo "  cp -r \"$SRC/<path>\" \"$DST/<path>\" && git -C \"$REPO\" add -- \"$DST_REL/<path>\""
    echo ""
fi

if [ "$total" -eq 0 ]; then
    echo "Already in sync. Nothing to do."
    exit 0
fi

if [ "$DRY_RUN" -eq 1 ]; then
    echo "Dry-run only. Re-run without --dry-run to apply."
    exit 0
fi

echo "=== git status ($DST_REL) ==="
git -C "$REPO" status --short -- "$DST_REL"
echo ""
echo "Review: git -C \"$REPO\" diff -- \"$DST_REL\""
echo "Commit: git -C \"$REPO\" add -A -- \"$DST_REL\" && git -C \"$REPO\" commit"
