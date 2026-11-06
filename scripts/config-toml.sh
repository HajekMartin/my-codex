# Stage per-key choices under the existing setup lock; publish only after AGENTS.
prepare_preferences() {
    local config_path=$codex_dir/config.toml
    [[ ! -L "$config_path" ]] || die 'Refusing linked config.toml.'
    [[ ! -e "$config_path" || -f "$config_path" ]] || die 'Expected a regular config.toml file.'
    config_existed=false
    config_changed=false
    config_backup=false
    if [[ -f "$config_path" ]]; then
        config_existed=true
        cp -- "$config_path" "$lock/config-original.toml"
        cp -- "$config_path" "$lock/config-next.toml"
    else : > "$lock/config-next.toml"; fi
    local editor=$repo_dir/scripts/config-toml.awk
    LC_ALL=C awk -v mode=read -v template=1 -f "$editor" "$repo_dir/config/codex/config.toml" > "$lock/config-desired.tsv" || die 'Cannot read preference template.'
    LC_ALL=C awk -v mode=read -f "$editor" "$lock/config-next.toml" > "$lock/config-existing.tsv" || die 'Cannot safely edit config.toml; no instructions were changed.'
    local key recommended current answer apply add crlf final_newline
    while IFS=$'\t' read -r key recommended <&3; do
        current=$(awk -F '\t' -v key="$key" '$1 == key { print $2 }' "$lock/config-existing.tsv")
        if [[ "$current" = "$recommended" ]]; then
            printf 'config.toml: %s is already %s\n' "$key" "$recommended"
            continue
        fi
        apply=false
        if [[ "$non_interactive" = false ]]; then
            printf 'config.toml: %s %s -> %s. Apply? [y/N]: ' "$key" "${current:-<unset>}" "$recommended"
            answer=
            if ! IFS= read -r answer; then answer=; fi
            case "$answer" in y|Y|yes|YES|Yes) apply=true ;; esac
        elif [[ -z "$current" ]]; then apply=true
        else printf 'config.toml: kept different value for %s; run interactively to change it.\n' "$key"; fi
        [[ "$apply" = true ]] || continue
        add=0
        [[ -n "$current" ]] || add=1
        crlf=$(awk 'NR == 1 { print (/\r$/ ? 1 : 0); exit }' "$lock/config-next.toml")
        final_newline=0
        if [[ -s "$lock/config-next.toml" && -z "$(tail -c 1 "$lock/config-next.toml")" ]]; then final_newline=1; fi
        LC_ALL=C awk -v mode=write -v wanted="$key" -v replacement="$recommended" -v add="$add" -v crlf="${crlf:-0}" -v final_newline="$final_newline" -f "$editor" "$lock/config-next.toml" > "$lock/config-edit.toml" || die 'Cannot stage config.toml changes.'
        mv -f -- "$lock/config-edit.toml" "$lock/config-next.toml"
        config_changed=true
    done 3< "$lock/config-desired.tsv"
    if [[ "$config_changed" = true && "$config_existed" = true && "$non_interactive" = false ]]; then
        printf 'Save a backup of config.toml before applying these choices? [y/N]: '
        answer=
        if ! IFS= read -r answer; then answer=; fi
        case "$answer" in y|Y|yes|YES|Yes) config_backup=true ;; esac
    fi
}

publish_preferences() {
    if [[ "$config_changed" = false ]]; then printf 'config.toml: no changes.\n'; return; fi
    local config_path=$codex_dir/config.toml backup_path
    [[ ! -L "$config_path" ]] || die 'Refusing linked config.toml.'
    if [[ "$config_existed" = true ]]; then
        [[ -f "$config_path" ]] && cmp -s -- "$config_path" "$lock/config-original.toml" || die 'config.toml changed during setup; it was preserved.'
        if [[ "$config_backup" = true ]]; then
            backup_path=$(mktemp "$codex_dir/config.toml.backup-XXXXXXXX")
            cp -- "$config_path" "$backup_path" || die 'Cannot back up config.toml.'
            printf 'config.toml backup: %s\n' "$backup_path"
        fi
        mv -f -- "$lock/config-next.toml" "$config_path"
    else
        [[ ! -e "$config_path" ]] || die 'config.toml appeared during setup; it was preserved.'
        ln -- "$lock/config-next.toml" "$config_path" || die 'Cannot publish new config.toml.'
    fi
    printf 'Applied selected preferences to: %s\n' "$config_path"
}
