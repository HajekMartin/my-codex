# Output style guide

Runtime instructions: [output-style.md](output-style.md).

The independently written adaptation of Busy Lukas prioritizes readable wording,
a direct summary, visible blockers, optional sections, and evidence. It does not
copy the original style file, impose strict word counts, or require colored markers.
Formatting must support engineering work, never replace it.

## Modes and sections

The runtime module defines ANSWER for direct questions, OPTIONS for consequential
comparisons, FINDINGS for investigations and reviews, and REPORT for implementation
results. Mode names normally stay hidden. Meaningful comparisons recommend one
option first; review findings prioritize severity and provide evidence.

Use a direct one-to-three-sentence summary first. The optional section order is
NEEDS YOU, DONE, OPEN, PROGRESS, WATCH OUT, DETAIL. The exact Czech equivalents
and section purposes live in the [runtime table](output-style.md). Localize all
labels and prose consistently, while preserving code and technical identifiers.

Simple answers use plain prose. Omit empty sections and unnecessary headings.
Progress updates communicate useful milestones and blockers without inventing
percentages. Completed work and actual verification remain distinguishable from
assumptions, remaining work, and tests not run.

## Examples

These illustrative REPORT outputs have the same structure. They do not describe
work actually performed by this repository. Identifiers and commands are unchanged.

English request: "Fix concurrent refreshToken calls."

```markdown
Concurrent `refreshToken` calls now share one pending request.

### DONE

- Updated `src/auth.ts` and added a concurrency regression test.
- `npm test`: 18 tests passed.

### OPEN

- Integration tests were not run; the test service was unavailable.

### DETAIL

- The regression test checks that concurrent callers receive the same result.
```

Czech request: "Oprav souběžná volání refreshToken."

```markdown
Souběžná volání `refreshToken` nyní sdílejí jeden probíhající požadavek.

### HOTOVO

- Upraven `src/auth.ts` a přidán regresní test souběžných volání.
- `npm test`: všech 18 testů prošlo.

### NEDOŘEŠENO

- Integrační testy nebyly spuštěny; testovací služba nebyla dostupná.

### DETAILY

- Regresní test ověřuje, že souběžní volající dostanou stejný výsledek.
```

ANSWER examples: "Use `git status --short` to list changed files." / "Změněné
soubory zobrazíš příkazem `git status --short`." No heading is necessary.

## Codex and Claude Code

The [original article](https://kellerstein.org/blog/the-model-got-better-and-i-stopped-reading-it/)
describes Claude Code output-style files, `outputStyle` in `settings.json`,
`CLAUDE_CONFIG_DIR`, and `keep-coding-instructions` frontmatter. These are not
used here. The reviewed official Codex
[configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference)
does not document an equivalent named Output Styles facility. The deprecated
`personality` compatibility setting is not that facility.

This repository embeds style rules in global `AGENTS.md`. It assumes neither
system-prompt replacement nor Claude-specific commands, terminal rendering, or
subagent inheritance. Model guidance cannot guarantee editorial judgment or
perfect compliance; a tidy report still needs evidence.
