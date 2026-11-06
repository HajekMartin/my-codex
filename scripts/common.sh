# Shared conflict handling for Bash 3.2+ on macOS and Linux.
choose_file_action() {
    local action=$1
    file_action=keep
    [[ "$non_interactive" = false ]] || die "Existing instructions preserved: $target. Run interactively to choose how to proceed."
    printf 'Existing instructions: %s\n' "$target"
    printf '1) Keep file and cancel (default)\n2) %s with backup\n3) %s without backup\n' "$action" "$action"
    printf 'Choose [1/2/3]: '
    local answer=
    if ! IFS= read -r answer; then answer=; fi
    case "$answer" in
        2) file_action=backup ;;
        3) file_action=replace ;;
    esac
}

backup_current_file() {
    local backup_path
    backup_path=$(mktemp "$codex_dir/AGENTS.backup-$(date +%Y%m%d-%H%M%S)-XXXXXXXX")
    if ! cp -- "$target" "$backup_path"; then
        rm -f -- "$backup_path"
        die 'Could not back up existing instructions; operation cancelled.'
    fi
    printf 'Original instructions backed up to: %s\n' "$backup_path"
}
