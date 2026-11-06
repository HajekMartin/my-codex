## Git workflow

- Before modifying a Git project, inspect the working tree, staged changes,
  current branch, relevant diffs, recent commits, remotes, and upstream when
  configured. Follow the project's branching, contribution, and commit conventions.
  If Git is absent, continue the task without initializing a repository unless asked.
- Use a short-lived branch for each distinct change. Reuse an existing task branch
  when appropriate. Otherwise create a branch before editing, using project naming
  conventions or these defaults: `feature/<topic>` for features, `fix/<topic>` for
  ordinary bugs, `hotfix/<topic>` for urgent production fixes, `docs/<topic>` for
  documentation, and `chore/<topic>` for maintenance. Use short English kebab-case
  topics. Do not invent release or develop branches for projects that do not use them.
- Determine the correct base from project guidance and existing refs; never assume
  the default branch is named main or that origin exists. Hotfixes target the
  applicable production/release line. Do not switch away from an explicitly selected
  user branch or carry unrelated changes onto a new base. Preserve staged and
  unstaged user work; use an isolated worktree when appropriate or ask if separation
  cannot be done safely. Do not automatically stash, discard, or include user changes.
- Fetch when needed and permitted to establish remote state. Do not claim local
  remote-tracking refs are current without verification. Inspect divergence before
  integration; do not blindly pull, merge, or rebase. Resolve only conflicts whose
  intended result is clear and preserve unrelated edits.
- Before committing, check the effective author and committer identity, including
  email, against the project's expected personal or work context. Commit identity
  is separate from GitHub authentication. If mismatched or unknown when it matters,
  ask rather than guess. Do not change global identity or credentials automatically.
- Create commits when authorized by the task or project workflow. Stage only
  reviewed task changes, inspect the staged diff, run relevant checks, and use small
  coherent commits with concise English messages following project conventions.
  Do not add credentials, secrets, generated clutter, or unrelated files.
- Push, publish branches, open pull requests, merge, tag, or create releases only
  within existing user authorization. Check the destination repository and branch
  first. Never force-push, rewrite shared history, delete branches or Git metadata,
  or use destructive reset/clean/restore commands without explicit authorization.
- Before finishing, inspect the final diff and Git status. Report the working
  branch and relevant commit or publication state without implying uncommitted
  work was committed, pushed, or merged. Mention remaining conflicts and checks
  not run. Keep the report proportional to the task.
