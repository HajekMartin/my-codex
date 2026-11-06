# Codex settings

The [config.toml template](config.toml) holds portable response preferences for the
Codex client. It complements the instruction modules rather than replacing them.
It contains no credentials, project trust entries, machine paths, model selection,
or permission changes. Keep those separate from portable response settings.

## Settings and limits

| Key | Template value | Purpose |
| --- | --- | --- |
| `personality` | `"none"` | Omit the built-in Personality section through the supported compatibility setting. |
| `model_verbosity` | Commented out | Optionally request shorter answers from models that support the verbosity parameter. |
| `model_reasoning_summary` | Commented out | Optionally request concise reasoning summaries. |
| `hide_agent_reasoning` | Commented out | Optionally hide reasoning events in CLI TUI and exec output. |

The official [configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference),
checked on 2026-11-06, marks `personality` as deprecated. `friendly` and `pragmatic`
no longer choose a style; `none` omits the built-in Personality section. It does
not remove other client instructions or grant `AGENTS.md` higher priority.

The reference describes `model_verbosity` as a GPT-5 Responses API override.
Its effect on the selected model and client must be checked separately. These
settings do not guarantee exact response length, headings, markers, or language.
The optional reasoning controls are distinct from user-facing progress reports.
`hide_agent_reasoning` is documented for CLI output, not as a VS Code UI guarantee.

Start with only `personality = "none"` active. Compare fresh chats using the same
model before enabling `model_verbosity = "low"`. Change one preference at a time
so differences can be attributed to that change. Use the
[output evaluation guide](../../docs/output-style-evaluation.md) for comparison.

Use [communication instructions](../communication/instructions.md) for language
and terminology, and [output-style instructions](../output-style/instructions.md)
for Personal Codex Style formatting. This TOML file is not concatenated into `AGENTS.md`.

## Install and update

Run the normal `scripts/install.ps1` or `bash scripts/install.sh` on a new PC.
For an existing managed installation, use `scripts/update.ps1` or
`bash scripts/update.sh`. Both platforms review active template keys one by one:

```text
config.toml: personality "pragmatic" -> "none". Apply? [y/N]
```

Answer `y` or `yes` to apply a value. Enter, EOF, or any other answer keeps it
unchanged. A missing key is shown as `<unset>` and is added only if accepted.
Values already matching the template need no prompt. Commented template keys are
ignored; uncomment an optional preference to make it part of future reviews.
After approved edits to an existing file, setup offers a whole-file backup once.
The default is no backup. The selected changes are staged before instructions
are installed and published after a successful instruction operation. Cancelling
an AGENTS.md conflict also discards the staged TOML choices.

Automation (`-NonInteractive` or `--non-interactive`) adds missing active keys,
keeps equal values, and reports differing existing values without overwriting
them. Use interactive setup to approve those changes. No backup is made in
automation. The same behavior applies when `AGENTS.md` already matches its source.

Only the four response preferences in the table above are supported by this
template editor. Other active template keys are rejected. The editor preserves
unrelated settings, tables, comments, UTF-8 BOM, and existing line endings. It
does not reserialize the full document. Edits stay at the top level; project and
profile values in tables are not changed. Symlinked config files, duplicate
managed keys, escaped/complex root keys, and multiline root values require
manual review instead of a guessed edit. Multiline values inside existing tables
are kept untouched. This conservative subset avoids extra runtime dependencies.

Source or parse errors stop setup before instruction publication. Publishing the
instructions and TOML is not one transaction: a later filesystem or concurrent-edit
failure can leave updated instructions with the old TOML. Read the result and
retry after resolving the cause. See [installation details](../../docs/installation.md).

The destination is `config.toml` under `CODEX_HOME`, otherwise the user's `.codex`
directory. Start a new Codex session after applying changes and check an actual answer.

Codex supports global and trusted project configuration layers; explicit client
or session settings can override file defaults. See the official
[configuration basics](https://learn.chatgpt.com/docs/config-file/config-basic).
To undo preferences, restore previous values manually or use a backup you chose
to create. Uninstall leaves `config.toml` untouched, including preferences added
by setup. It never removes unrelated settings or assumes their original values.

## Article context

[Flavio Copes's article](https://flaviocopes.com/concise-coding-agents/) separates
model-written prose from interface output such as reasoning summaries and tool
logs. That distinction is useful: output instructions cannot hide interface events.
Its `pragmatic` recommendation differs from the current official reference, so this
template does not copy the article's sample unchanged. Neither a TOML setting nor
re-reading instructions guarantees the complete Personal Codex Style format.
