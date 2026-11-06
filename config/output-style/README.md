# Output style guide

Runtime instructions: [instructions.md](instructions.md).

This module incorporates the complete [Busy Lukas style](https://blog.kellerstein.org/output-styles/busy-lukas.md)
by Lukas Kellerstein, retrieved on 2026-11-06. Both parts, the full substitution
table, sentence limits, examples, and small-answer exception are included.
Formatting must support engineering work, never replace it.

## Local changes

- Remove Claude Code frontmatter. The installer embeds the module in global `AGENTS.md`.
- Describe a busy engineer without assuming the author's years of experience.
- Localize headings as well as prose, preserving the existing Czech translations.
- Allow only the six colored section markers. Ban all other emoji in authored prose and updates.
  Replace step emoji with `[done]`, `[active]`, and `[pending]`, including examples.
  Preserve literal technical content when exact copying is required.
- Describe Markdown rendering without asserting Claude Code measurements apply to Codex.
- Keep ANSWER, OPTIONS, FINDINGS, and REPORT conventions and evidence requirements.

Communication, autonomy, and Git modules remain in effect. They keep language
selection, English technical artifacts, autonomous routine decisions, permission
checks, preservation of user work, verification, task branches, commit identity,
and publication authorization. History establishes these rules already exist,
not the exact wording of earlier user requests.

## Modes and sections

The runtime module defines ANSWER for direct questions, OPTIONS for consequential
comparisons, FINDINGS for investigations and reviews, and REPORT for implementation
results. Mode names normally stay hidden. Meaningful comparisons recommend one
option first; review findings prioritize severity and provide evidence.

Use a direct one-to-three-sentence summary first. The optional section order is
🔴 NEEDS YOU, 🟢 DONE, 🟠 OPEN, 🔵 PROGRESS, 🟡 WATCH OUT, ⚪ DETAIL.
Use level-two headings with the marker first, and `---` between sections.
The Czech equivalents and section purposes live in the [runtime module](instructions.md).
Localize labels and prose consistently, preserving code and technical identifiers.

Simple answers use plain prose. Omit empty sections and unnecessary headings.
For open tasks with steps, show a 20-cell progress bar with actual counts and
percentage. If the total is unknown, show only the known count. Never invent
percentages. Use `[done]`, `[active]`, and `[pending]` for step states.
Keep checked results separate from assumptions, remaining work, and tests not run.

## Words and sentences

The full module keeps simple vocabulary, consistent terms, active voice,
conditions before actions, direct commands, and concrete examples.
Most sentences have at most 15 words. Instructions have a 20-word limit and
descriptions a 25-word limit. A technical name counts as one word.
Preserve technical identifiers, facts, exact numbers, precision, and uncertainty.
Remove filler before facts. The complete English substitution table remains in
the module. Other languages follow the same intent with natural wording.
Chat sections do not belong in ordinary code, comments, or documentation.

## Examples

These illustrative REPORT outputs have the same structure. They do not describe
work actually performed by this repository. Identifiers and commands are unchanged.

English request: "Fix concurrent refreshToken calls."

```markdown
Concurrent `refreshToken` calls now share one pending request.

---

## 🟢 DONE

- Updated `src/auth.ts` and added a concurrency regression test.
- `npm test`: 18 tests passed.

---

## 🟠 OPEN

- Integration tests were not run; the test service was unavailable.

---

## ⚪ DETAIL

- The regression test checks that concurrent callers receive the same result.
```

Czech request: "Oprav souběžná volání refreshToken."

```markdown
Souběžná volání `refreshToken` nyní sdílejí jeden probíhající požadavek.

---

## 🟢 HOTOVO

- Upraven `src/auth.ts` a přidán regresní test souběžných volání.
- `npm test`: všech 18 testů prošlo.

---

## 🟠 NEDOŘEŠENO

- Integrační testy nebyly spuštěny; testovací služba nebyla dostupná.

---

## ⚪ DETAILY

- Regresní test ověřuje, že souběžní volající dostanou stejný výsledek.
```

ANSWER examples: "Use `git status --short` to list changed files." / "Změněné
soubory zobrazíš příkazem `git status --short`." No heading is necessary.

## Codex and Claude Code

The [original article](https://blog.kellerstein.org/blog/the-model-got-better-and-i-stopped-reading-it/)
describes Claude Code output-style files, `outputStyle` in `settings.json`,
`CLAUDE_CONFIG_DIR`, and `keep-coding-instructions` frontmatter. These are not
used here. This repository uses its existing global `AGENTS.md` installer.

This repository embeds style rules in global `AGENTS.md`. It assumes neither
system-prompt replacement nor Claude-specific commands, terminal rendering, or
subagent inheritance. Model guidance cannot guarantee editorial judgment or
perfect compliance; a tidy report still needs evidence.
Run `./scripts/update.ps1` on Windows, or `bash scripts/update.sh` on macOS/Linux,
after source changes, then start a new Codex session. The combined instructions
must remain below the installer's 32 KiB limit.
