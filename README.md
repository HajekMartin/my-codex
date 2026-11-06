# my-codex

Personal, portable and version-controlled configuration for OpenAI Codex.

This repository manages global Codex behavior across projects. It keeps reusable
instructions and specialized workflows in Git, with safe installation and updates.

## Features

| Component | Description |
| --- | --- |
| [Communication](config/communication/README.md) | Automatic response language detection, concise writing, consistent technical terminology |
| [Autonomy](config/autonomy/README.md) | Independent decisions, fewer unnecessary questions, task completion and verification |
| [Output Style](config/output-style/README.md) | Structured, readable responses inspired by Busy Lukas |
| [Git Workflow](config/git/README.md) | Task branches, repository checks, correct commit identity, and safe publication |
| [Skills](skills/README.md) | Reusable workflows for specialized tasks |
| [Installation](docs/installation.md) | Safe deployment and updates on macOS, Linux, and Windows |

## Repository Structure

```text
my-codex/
|-- README.md
|-- AGENTS.md
|-- .gitattributes
|-- config/
|   |-- communication/
|   |   |-- instructions.md
|   |   `-- README.md
|   |-- autonomy/
|   |   |-- instructions.md
|   |   `-- README.md
|   |-- output-style/
|   |   |-- instructions.md
|   |   `-- README.md
|   `-- git/
|       |-- instructions.md
|       `-- README.md
|-- docs/
|   `-- installation.md
|-- skills/
|   `-- README.md
`-- scripts/
    |-- install.sh
    |-- install.ps1
    |-- update.sh
    |-- update.ps1
    |-- uninstall.sh
    |-- uninstall.ps1
    `-- common.ps1
```

`AGENTS.md` and the four instruction modules produce one global `AGENTS.md`.
The adjacent guides are human documentation and are not installed as instructions.
`scripts/` contains installation, update, and removal scripts; `skills/` holds reusable Skill
sources when added. No Skills are installed automatically.

## Installation

Clone the repository and run these commands from its root.

**macOS** (Bash 3.2 or newer):

```bash
bash scripts/install.sh
```

**Linux** (Bash 3.2 or newer):

```bash
bash scripts/install.sh
```

**Windows PowerShell** (5.1 or 7; no WSL, Git Bash, or administrator privileges):

```powershell
.\scripts\install.ps1
```

The destination is `AGENTS.md` in `CODEX_HOME`, or `~/.codex` by default
(`$HOME\.codex` on Windows). Existing unmanaged instructions, overrides, and
manually edited installations are preserved and reported as conflicts.
Start a new Codex session after installing.

For custom profiles, PowerShell execution-policy guidance, and conflict resolution,
see [installation details](docs/installation.md).

## Updating

After editing source modules or pulling Git updates, run:

```bash
# macOS / Linux
bash scripts/update.sh
```

```powershell
# Windows
.\scripts\update.ps1
```

Use the same `CODEX_HOME` as installation, then start a new Codex session.
Updates require an unchanged managed installation; no uninstall/reinstall is needed.

## Uninstallation

```bash
# macOS / Linux
bash scripts/uninstall.sh
```

```powershell
# Windows
.\scripts\uninstall.ps1
```

Use the same profile. Removal preserves credentials, sessions, Skills, unrelated
settings, and manually modified instructions.

## Customization

Edit [communication](config/communication/instructions.md),
[autonomy](config/autonomy/instructions.md),
[output formatting](config/output-style/instructions.md), or
[Git workflow](config/git/instructions.md),
then run the update command.
Keep project conventions in each project's own `AGENTS.md`.
For reusable global and project Skills, follow [Skills management](skills/README.md).

## Attribution

Response-style design inspired by Lukas Kellerstein's article *The model got better, and I stopped reading it*: https://kellerstein.org/blog/the-model-got-better-and-i-stopped-reading-it/

The output style is independently adapted for OpenAI Codex. This does not imply
endorsement, collaboration, or official affiliation with the author or OpenAI.
