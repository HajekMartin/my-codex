#!/usr/bin/env bash
# Remove only an unchanged installation owned by this repository's installer.
set -euo pipefail
umask 077

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
[[ $# -eq 0 ]] || die 'Usage: bash scripts/uninstall.sh (use the same CODEX_HOME as installation)'
codex_dir=${CODEX_HOME:-${HOME:?HOME is required when CODEX_HOME is unset}/.codex}
[[ "$codex_dir" = /* ]] || die 'CODEX_HOME must be an absolute path.'
[[ -e "$codex_dir" ]] || { printf 'Nothing installed: %s\n' "$codex_dir"; exit 0; }
codex_dir=$(cd -- "$codex_dir" && pwd -P)
target=$codex_dir/AGENTS.md
state=$codex_dir/.my-codex
lock=$codex_dir/.my-codex.lock
mkdir -- "$lock" 2>/dev/null || die "Installation is locked: $lock. If no installer is running, inspect and remove the empty lock directory."
trap 'rmdir -- "$lock" 2>/dev/null || true' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

[[ ! -L "$target" && ! -L "$state" ]] || die 'Refusing symlinked AGENTS.md or installation state.'
[[ -e "$state" ]] || { printf 'No managed installation; existing configuration preserved.\n'; exit 0; }
[[ -d "$state" && -f "$state/installed.md" && ! -L "$state/installed.md" ]] ||
    die "Unrecognized installation state: $state. Inspect it manually."
[[ -f "$target" ]] && cmp -s -- "$target" "$state/installed.md" ||
    die "Installed AGENTS.md is missing or changed: $target. Nothing removed; preserve your edits and resolve manually."

rm -- "$target"
rm -- "$state/installed.md"
# Preserve unexpected files, and never recursively delete configuration directories.
if ! rmdir -- "$state" 2>/dev/null; then
    printf 'Preserved additional files in: %s\n' "$state"
fi
printf 'Removed managed instructions: %s\nSkills and other Codex settings were not changed.\n' "$target"
