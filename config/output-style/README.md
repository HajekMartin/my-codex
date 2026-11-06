# Personal Codex Style

Runtime instructions: [instructions.md](instructions.md).

Personal Codex Style adapts the complete [Busy Lukas style](https://blog.kellerstein.org/output-styles/busy-lukas.md)
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
- Put the Codex adapter before the complete style. It selects the response and
  layout, defines the pre-send check, and gives complete flat-layout examples.
  Keep the complete source text after the adapter, including both parts,
  the substitution table, sentence limits, and the original heading-layout example.

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

If a higher-priority rule restricts or discourages headings, use flat list items.
Each item contains a marker, localized label, and one fact or question. Repeat a
label for more facts in the same group. Never nest the report under a label.
For example:

```markdown
- 🟢 **DONE:** Updated `src/auth.ts`.
- 🟢 **DONE:** The concurrency check passed.
- 🟠 **OPEN:** Integration checks were not run because the service was unavailable.
```

The equivalent Czech labels are `🟢 **HOTOVO:**` and `🟠 **NEDOŘEŠENO:**`.
Keep applicable labels in their usual order. Tables, code, and the progress bar
stay outside the list, without indentation. The bar has an unlabelled fence.
The progress steps form their own flat list. Do not put the report in a code
fence or quote. This fallback changes the layout while retaining compatible rules.
If another element conflicts with higher-priority guidance, change only that element.

Simple answers use plain prose. Omit empty sections and unnecessary headings.
For open tasks with steps, show a 20-cell progress bar with actual counts and
percentage. Round the percentage and filled-cell count to the nearest whole number.
If the total is unknown, show only the known count, without a percentage or bar.
Never invent percentages. Use `[done]`, `[active]`, and `[pending]` for step states.
Open multi-step tasks retain progress even in short updates. Completed tasks omit it.
Keep checked results separate from assumptions, remaining work, and tests not run.

The communication module owns language selection. This module owns response
layout and plain-language writing. The adapter resolves Codex layout choices
before the complete original rules below it. It does not replace built-in
engineering guidance or change permissions.

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

The installed [Codex adapter](instructions.md#codex-application) also contains
complete flat-layout examples for a completed report, a finding, and an open
task with progress. These examples are installed with the rules so they remain
available outside this repository. Their file paths and check results are
illustrative, not evidence about the current task.

## Check the behavior

Follow the [evaluation procedure](../../docs/output-style-evaluation.md) to compare
the same prompts in fresh chats in the actual client. Record the client, model,
loaded guidance, observed conflicts, and per-case results. Keep installation
checks separate from response checks. A passing template check does not prove
that the model follows it in new chats.

## Codex and Claude Code

The [original article](https://blog.kellerstein.org/blog/the-model-got-better-and-i-stopped-reading-it/)
describes Claude Code output-style files, `outputStyle` in `settings.json`,
`CLAUDE_CONFIG_DIR`, and `keep-coding-instructions` frontmatter. These are not
used here. This repository uses its existing global `AGENTS.md` installer.

This repository embeds style rules in global `AGENTS.md`. It assumes neither
system-prompt replacement nor Claude-specific commands, terminal rendering, or
subagent inheritance. Model guidance cannot guarantee editorial judgment or
perfect compliance; a tidy report still needs evidence.
This repository does not control higher-priority client instructions or run a
response validator. A style check is an instruction to the model, not an enforced
test. Repeated noncompliance remains possible. A new session loads updated rules
but does not guarantee adherence. When diagnosing a failure, separate loading,
instruction conflicts, and noncompliance, and state only what the evidence supports.
Run `./scripts/update.ps1` on Windows, or `bash scripts/update.sh` on macOS/Linux,
after source changes, then start a new Codex session. The combined instructions
must remain below the installer's 32 KiB limit.
