# Git workflow guide

Runtime instructions: [instructions.md](instructions.md). These defaults apply across projects;
each project's own contribution and branching rules take precedence.

## Branches

Use a short-lived branch for one change. Reuse the current branch when it already
belongs to the task. Creating and naming a local task branch is an autonomous
implementation decision; ordinary work should not be developed on the default
or protected branch unless the user or project explicitly requests that workflow.

| Default prefix | Purpose | Example |
| --- | --- | --- |
| `feature/` | New capability | `feature/pdf-presentations` |
| `fix/` | Ordinary bug fix | `fix/windows-paths` |
| `hotfix/` | Urgent production correction | `hotfix/login-failure` |
| `docs/` | Documentation | `docs/setup-guide` |
| `chore/` | Configuration or maintenance | `chore/update-dependencies` |

These names are this repository's fallback convention, not a Git requirement.
There is no requirement to adopt Git Flow, add a `develop` branch, or create
release branches. Choose the base using project guidance and existing refs.
A hotfix belongs to the affected production or release line. Read-only questions
and reviews do not require a new branch.

This follows the general idea of [topic branches](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows)
and a lightweight [branch-based workflow](https://docs.github.com/en/get-started/using-github/github-flow).

## Preserve work and verify identity

Inspect status, staged and unstaged diffs, branch, history, remotes, and upstream
before changing files. Existing local changes may belong to the user. Do not stash,
discard, move them to another base, or commit them merely to simplify the task.
If safe isolation is necessary, use a worktree or ask about the specific conflict.
Do not initialize Git in an unmanaged folder without a request.

Before committing, inspect the effective author and committer identities. A personal
repository can inherit a corporate email from global configuration even while
GitHub credentials use a personal account. Correct a confirmed mismatch through
explicitly authorized repository-local settings; do not silently alter global
identity or sign the user out. Ask for the intended email if it cannot be established.

## Commit, publish, and finish

When committing is part of the authorized work, stage only reviewed task changes,
inspect the staged diff, and run relevant verification. Match existing commit
conventions, using concise English messages and coherent commits. Creating a branch
does not by itself authorize committing or publishing its contents.

Fetch only when useful and permitted, and inspect divergence before integration.
Local tracking refs alone do not prove the server's current state. Publishing,
pull requests, merges, tags, and releases need authorization through the task or
existing workflow. Destructive cleanup and shared-history rewrites need explicit
authorization. Check the remote destination before any publication.

End with the branch, relevant verification, and actual commit/push/merge state.
Do not claim publication merely because local work is complete. These are agent
instructions, not Git hooks or branch-protection enforcement.
