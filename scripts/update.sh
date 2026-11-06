#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 0 || ( $# -eq 1 && "$1" = --non-interactive ) ]] || { printf 'Usage: bash scripts/update.sh [--non-interactive]\n' >&2; exit 1; }
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
exec bash "$script_dir/install.sh" --update "$@"
