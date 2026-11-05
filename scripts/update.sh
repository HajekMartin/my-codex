#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 0 ]] || { printf 'Usage: bash scripts/update.sh\n' >&2; exit 1; }
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
exec bash "$script_dir/install.sh" --update
