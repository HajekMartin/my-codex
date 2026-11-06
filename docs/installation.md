# Installation details

Use the [overview commands](../README.md#installation) from the repository root.
Bash 3.2+ and standard Unix utilities are required on macOS/Linux. Windows uses
PowerShell 5.1 or 7 and .NET, without administrator privileges or a Unix shell.

## Profiles and supported mechanisms

Both implementations use `CODEX_HOME`, otherwise the user's `.codex` directory.
On Windows this is the user profile directory, normally `$HOME\.codex`.
The installer creates the directory; Codex expects an explicitly configured
home directory to exist. Use an absolute drive or UNC path on Windows and an
absolute Unix path elsewhere. Use the same environment for all operations:

```bash
CODEX_HOME="$HOME/.codex-personal" bash scripts/install.sh
CODEX_HOME="$HOME/.codex-personal" bash scripts/update.sh
CODEX_HOME="$HOME/.codex-personal" bash scripts/uninstall.sh
```

```powershell
$env:CODEX_HOME = Join-Path $HOME '.codex-personal'
.\scripts\install.ps1
.\scripts\update.ps1
.\scripts\uninstall.ps1
```

If PowerShell blocks a downloaded script, review it and follow your machine's
execution policy. For a machine you control, a process-scoped RemoteSigned policy
can allow local scripts: `Set-ExecutionPolicy -Scope Process RemoteSigned`.
For downloaded files, review them before using `Unblock-File` on selected scripts.
Organization policy still applies; these scripts do not change it.

Official documentation checked on 2026-11-05:

- [Environment variables](https://learn.chatgpt.com/docs/config-file/environment-variables):
  `CODEX_HOME` defaults to `~/.codex` and relocates Codex state.
- [AGENTS.md discovery](https://learn.chatgpt.com/docs/agent-configuration/agents-md):
  global override/instructions are followed by project guidance from repository
  root to working directory. More specific guidance takes precedence. Discovery
  occurs at startup; the default instruction-size limit is 32 KiB.

No `config.toml` properties are added. The installer concatenates `AGENTS.md`, then
the `instructions.md` files under `config/communication/`, `config/autonomy/`,
`config/output-style/`, and `config/git/`, in that order. All required rules are
embedded. Each area's `README.md` is human documentation and is excluded from
generated instructions along with its examples; arbitrary Markdown
imports are not assumed. Generation normalizes UTF-8 BOM and CRLF source endings
to UTF-8 without BOM and LF, with a final newline for each non-empty module.
Both platforms refuse generated files at or above 32 KiB. Project instructions
can still consume additional context, so keep global modules compact.

## Install, update, and ownership

Fresh installation refuses an existing unmanaged `AGENTS.md`, even an empty or
identical file. Review and back it up outside the target path before deliberately
moving it aside. Global `AGENTS.override.md` also blocks installation and update
because it can shadow these instructions. No automatic merge or force option exists.

An unchanged managed installation can be installed again without changes. Run
`update.sh` or `update.ps1` after editing or pulling source changes. Update requires
a managed installation, verifies it has not been edited, then replaces its instructions
and ownership snapshot. Existing installations from the original Bash installer
use the same snapshot format and can be updated directly.

The ownership snapshot is `.my-codex/installed.md` in Codex home. It is independent
of the installed instructions. Manual edits, missing managed files, unrecognized
state, and linked instruction/state entries cause a refusal. Windows also refuses
reparse points at these entries, including junctions. Preserve edits before
resolving conflicts manually; do not delete ownership state merely to bypass checks.

Uninstall removes only the unchanged managed instructions and snapshot. It leaves
the Codex directory, credentials, sessions, Skills, unrelated settings, and unexpected
state files intact. Without a managed installation it preserves existing files.
Restore any previous configuration you moved aside yourself after successful removal.

## Filesystem mechanics and interruptions

A shared `.my-codex.lock` directory serializes operations from these scripts.
Unix installation publishes new files with hard links, so its target filesystem
must support them. Windows uses exclusive file moves/copies and managed updates
use .NET file replacement, requiring a filesystem supporting that operation
(normally local NTFS). Both platforms stage update content on the target filesystem.

Target and snapshot replacement are separate operations, not a single transaction.
A failure between them can leave mismatched state. The old snapshot is retained
until the new target is published. Inspect both files after an interrupted update
and preserve any version you need before manual recovery. Scripts refuse a mismatch
on the next operation rather than guessing. They do not guarantee crash recovery.
Do not edit these paths or run other configuration managers during an operation.

After interruption, inspect `AGENTS.md`, `.my-codex/`, and `.my-codex.lock/`.
Remove a stale lock only after confirming no script is running. Runtime instructions
and their snapshot must agree before further managed operations. No configuration
directory is recursively deleted by installation, update, or uninstallation.
