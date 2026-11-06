# Merge the small supported top-level preference set without rewriting other TOML.
function Get-PreferenceEntries {
    param([string]$Text, [switch]$Template)
    $entries = [ordered]@{}
    $allowed = @('personality', 'model_verbosity', 'model_reasoning_summary', 'hide_agent_reasoning')
    $lines = [regex]::Matches($Text, '[^\r\n]+|[\r\n]+')
    foreach ($line in $lines) {
        $body = $line.Value.Trim()
        if (!$body -or $body.StartsWith('#')) { continue }
        if ($body.StartsWith('[')) {
            if ($Template) { throw 'The preference template must contain top-level scalar keys only.' }
            break
        }
        # A deliberately narrow editor: fail safely on ambiguous top-level TOML.
        if ($body.Contains('"""') -or $body.Contains("'''")) { throw 'Multiline top-level TOML needs manual editing; config.toml was preserved.' }
        $assignment = [regex]::Match($line.Value, '^\s*(?<key>[\w.-]+|"[^"\\]+"|''[^''\\]+'')\s*=\s*(?<value>.*)$')
        if (!$assignment.Success) { throw 'Unsupported top-level TOML syntax; config.toml was preserved. Use simple unescaped keys and single-line values.' }
        $key = $assignment.Groups['key'].Value.Trim('"', "'")
        if ($key -match '^(personality|model_verbosity|model_reasoning_summary|hide_agent_reasoning)\.') { throw 'A managed preference is defined as a table; config.toml was preserved.' }
        $value = $assignment.Groups['value'].Value
        if ($value.TrimStart().StartsWith('[') -and $value -notmatch '\]\s*(#.*)?$') { throw 'Multiline top-level TOML arrays need manual editing; config.toml was preserved.' }
        if ($key -cnotin $allowed) {
            if ($Template) { throw "Unsupported preference in template: $key" }
            continue
        }
        if ($entries.Contains($key)) { throw "Duplicate top-level preference: $key" }
        $scalar = [regex]::Match($value, '^(?<token>"[a-z_]+"|''[a-z_]+''|true|false)(?<suffix>\s*(#.*)?)$')
        if (!$scalar.Success) { throw "Unsupported scalar value for $key; config.toml was preserved." }
        $token = $scalar.Groups['token'].Value
        $canonical = if ($token.StartsWith("'")) { '"' + $token.Trim("'") + '"' } else { $token }
        if ($Template) {
            $valid = switch ($key) {
                'personality' { $canonical -in @('"none"', '"friendly"', '"pragmatic"') }
                'model_verbosity' { $canonical -in @('"low"', '"medium"', '"high"') }
                'model_reasoning_summary' { $canonical -in @('"auto"', '"concise"', '"detailed"', '"none"') }
                'hide_agent_reasoning' { $canonical -in @('true', 'false') }
            }
            if (!$valid) { throw "Unsupported template value for $key" }
        }
        $entries.Add($key, @{ Value = $canonical; Start = $line.Index + $assignment.Groups['value'].Index; Length = $token.Length })
    }
    return $entries
}

function New-PreferencePlan {
    param([string]$Repository, [string]$Directory, [switch]$Interactive)
    $path = Join-Path $Directory 'config.toml'
    Assert-RegularEntry $path
    $exists = Test-Entry $path
    if ($exists -and !(Test-Path -LiteralPath $path -PathType Leaf)) { throw "Expected a regular file: $path" }
    $utf8 = New-Object Text.UTF8Encoding($false, $true)
    $original = [byte[]]@()
    if ($exists) { $original = [IO.File]::ReadAllBytes($path) }
    $text = $utf8.GetString($original)
    $bom = $text.StartsWith([string][char]0xFEFF, [StringComparison]::Ordinal)
    if ($bom) { $text = $text.Substring(1) }
    $template = [IO.File]::ReadAllText((Join-Path $Repository 'config/codex/config.toml'), $utf8)
    $desired = Get-PreferenceEntries -Text $template -Template
    $existing = Get-PreferenceEntries -Text $text
    $edits = @()
    $prefix = ''
    $newline = [regex]::Match($text, '\r\n|\n|\r').Value
    if (!$newline) { $newline = "`n" }
    foreach ($key in $desired.Keys) {
        $value = $desired[$key].Value
        if ($existing.Contains($key) -and $existing[$key].Value -eq $value) {
            Write-Host "config.toml: $key is already $value"
            continue
        }
        $current = if ($existing.Contains($key)) { $existing[$key].Value } else { '<unset>' }
        $apply = !$existing.Contains($key)
        if ($Interactive) {
            $answer = Read-SetupInput "config.toml: $key $current -> $value. Apply? [y/N]"
            $apply = $null -ne $answer -and $answer.Trim() -match '^(?i:y|yes)$'
        } elseif (!$apply) { Write-Host "config.toml: kept different value for $key; run interactively to change it." }
        if (!$apply) { continue }
        if ($existing.Contains($key)) {
            $edits += @{ Start = $existing[$key].Start; Length = $existing[$key].Length; Value = $value }
        } else { $prefix += "$key = $value$newline" }
    }
    foreach ($edit in @($edits | Sort-Object { $_.Start } -Descending)) {
        $text = $text.Remove($edit.Start, $edit.Length).Insert($edit.Start, $edit.Value)
    }
    $changed = $edits.Count -gt 0 -or $prefix.Length -gt 0
    $backup = $false
    if ($changed -and $exists -and $Interactive) {
        $answer = Read-SetupInput 'Save a backup of config.toml before applying these choices? [y/N]'
        $backup = $null -ne $answer -and $answer.Trim() -match '^(?i:y|yes)$'
    }
    if ($bom) { $prefix = [string][char]0xFEFF + $prefix }
    return @{ Path = $path; Exists = $exists; Original = $original; Bytes = $utf8.GetBytes($prefix + $text); Changed = $changed; Backup = $backup }
}

function Publish-PreferencePlan {
    param($Plan, [string]$Lock)
    if (!$Plan.Changed) { Write-Output 'config.toml: no changes.'; return }
    Assert-RegularEntry $Plan.Path
    if ($Plan.Exists) {
        if (!(Test-Path -LiteralPath $Plan.Path -PathType Leaf) -or
            [Convert]::ToBase64String([IO.File]::ReadAllBytes($Plan.Path)) -ne [Convert]::ToBase64String($Plan.Original)) {
            throw 'config.toml changed during setup. It was preserved; retry after reviewing it.'
        }
    } elseif (Test-Entry $Plan.Path) { throw 'config.toml appeared during setup. It was preserved.' }
    $staged = Join-Path $Lock 'config-next.toml'
    Write-NewFile -Path $staged -Bytes $Plan.Bytes
    if ($Plan.Exists) {
        if ($Plan.Backup) {
            $backupPath = $Plan.Path + '.backup-' + [Guid]::NewGuid().ToString('N')
            [IO.File]::Replace($staged, $Plan.Path, $backupPath)
            Write-Output "config.toml backup: $backupPath"
        } else { [IO.File]::Replace($staged, $Plan.Path, [NullString]::Value) }
    } else { [IO.File]::Move($staged, $Plan.Path) }
    Write-Output "Applied selected preferences to: $($Plan.Path)"
}
