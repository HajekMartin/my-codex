# Reusable Skills

No Skills are included initially. General response preferences belong in the
installed `AGENTS.md`; add a Skill only for a repeatable, task-specific workflow.

## Add a reusable source

Create `skills/<name>/SKILL.md` with a unique, descriptive name:

```markdown
---
name: review-migrations
description: Review database migration safety when a task changes schema migrations.
---

Read the changed migrations and the project's database conventions.
Check compatibility with the previous deployed application version.
Report confirmed risks with file references and evidence.
```

This example is documentation, not an installed Skill. Add optional `scripts/`,
`references/`, or `assets/` inside the Skill folder only when needed. Keep source
and documentation under version control, describe activation boundaries precisely,
and test representative matching and non-matching requests before reuse.

## Install a global Skill safely

The official [Skills guide](https://learn.chatgpt.com/docs/build-skills) identifies
`$HOME/.agents/skills` as the user-level discovery location. From this repository,
after actually creating and reviewing the Skill, run:

```bash
(
    set -eu
    skill_name=review-migrations
    source_dir="skills/$skill_name"
    destination="$HOME/.agents/skills/$skill_name"
    test -f "$source_dir/SKILL.md" || { printf 'Missing Skill source\n' >&2; exit 1; }
    mkdir -p "$HOME/.agents/skills"
    # mkdir refuses an existing file, directory, or symlink, including a dangling one.
    mkdir "$destination" || { printf 'Skill conflict: %s\n' "$destination" >&2; exit 1; }
    cp -R "$source_dir/." "$destination/"
)
```

On Windows, use the equivalent native PowerShell commands after creating the source:

```powershell
& {
    $ErrorActionPreference = 'Stop'
    $skillName = 'review-migrations'
    $source = Join-Path (Get-Location) "skills/$skillName"
    $destination = Join-Path $HOME ".agents/skills/$skillName"
    if (!(Test-Path -LiteralPath (Join-Path $source 'SKILL.md') -PathType Leaf)) {
        throw 'Missing Skill source'
    }
    $null = [IO.Directory]::CreateDirectory((Split-Path $destination -Parent))
    # No -Force: fail rather than merge into an existing Skill directory.
    $null = New-Item -ItemType Directory -Path $destination -ErrorAction Stop
    Get-ChildItem -LiteralPath $source -Force |
        Copy-Item -Destination $destination -Recurse -ErrorAction Stop
}
```

These explicit commands never merge into an existing Skill. A failed copy can leave
a partial new directory; inspect it before retrying. The configuration install,
update, and uninstall scripts do not execute these commands or manage Skills.
There is no implicit Skill update.

For updates, compare the source and installed copies first, preserve local changes,
and deliberately move the installed directory to a backup **outside all Skill
discovery directories**. Then rerun the installation commands. For removal, move
only the chosen Skill out of discovery; keep the backup until no longer needed.
Do not overwrite or remove other installed Skills.

## Project-specific Skills

Create or explicitly copy the same folder into
`<project>/.agents/skills/<name>/SKILL.md` and commit it with the project. Use the
same exclusive-directory creation approach as above to avoid overwriting existing
content. Repository discovery scans `.agents/skills` from the working directory
up to the repository root. Keep project-specific conventions with that project;
maintain portable workflows here. Avoid duplicate names across installed scopes.

Skills can be selected explicitly through `$skill-name` or `/skills`, or matched
by their description. Full instructions are read when the Skill is used, unlike
always-applicable `AGENTS.md` guidance. If changes are not visible, restart Codex.
The `skills/` directory in this repository is a source collection, not itself a
discovery directory. `CODEX_HOME` should not be treated as a relocation mechanism
for the documented `$HOME/.agents/skills` path.
