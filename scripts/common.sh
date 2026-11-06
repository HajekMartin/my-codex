# Shared interaction for Bash 3.2+ on macOS and Linux.
confirm_operation() {
    local operation=$1
    printf '\nmy-codex %s\nDestination: %s\n' "$operation" "$target"
    if [[ -e "$state/installed.md" ]]; then
        printf 'Status: managed installation found.\n'
        if ! cmp -s -- "$target" "$state/installed.md"; then
            printf 'AGENTS.md differs from the saved installation. A separate conflict choice will protect your edits.\n'
        fi
    elif [[ -e "$target" || -L "$target" ]]; then
        printf 'Status: existing AGENTS.md is not managed by this installer.\n'
    else
        printf 'Status: no installed AGENTS.md found.\n'
    fi
    case "$operation" in
        install)
            printf 'Install creates %s from the five source modules.\n' "$target"
            printf 'It also creates %s/installed.md to track this installation.\n' "$state"
            printf 'Existing unmanaged or manually edited instructions require a separate keep/backup/replace choice.\n'
            printf 'An unchanged managed installation is kept. Use update.sh to apply new source instructions.\n'
            ;;
        update)
            printf 'Update replaces %s and %s/installed.md with the current source instructions.\n' "$target" "$state"
            printf 'The previous managed contents are replaced. Manual edits require a separate keep/backup/replace choice.\n'
            printf 'Update requires an existing managed installation. It does not create one.\n'
            ;;
        uninstall)
            printf 'Uninstall deletes %s and %s/installed.md only if this installation owns them.\n' "$target" "$state"
            printf 'Manual edits require a separate keep/backup/remove choice. Unmanaged instructions are kept.\n'
            printf 'Existing backups and other files in the Codex directory are kept.\n'
            ;;
    esac
    printf 'Credentials, sessions, Skills, and other settings are kept.\n'
    if [[ "$non_interactive" = false ]]; then
        printf 'Are you sure you want to %s? [y/N]: ' "$operation"
        local answer=
        if ! IFS= read -r answer; then answer=; fi
        case "$answer" in
            y|Y|yes|YES|Yes) ;;
            *) printf 'Cancelled. No files changed.\n'; exit 0 ;;
        esac
    fi
    printf 'Checking files and running %s...\n' "$operation"
}

choose_file_action() {
    local action=$1
    file_action=keep
    [[ "$non_interactive" = false ]] || die "Existing instructions preserved: $target. Run interactively to choose how to proceed."
    printf 'Existing instructions: %s\n' "$target"
    printf 'This file already exists. Your next choice controls whether its contents are kept or lost.\n'
    printf '1) Keep file and cancel (default)\n2) %s with backup\n3) %s without backup\n' "$action" "$action"
    printf 'Backup saves a separate copy beside AGENTS.md. Without backup, the old contents are lost.\n'
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
