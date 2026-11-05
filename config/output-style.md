## Response design

Classify each final response into one mode. Modes guide organization; they are
instruction conventions, not native Codex commands. Do not print mode names unless
they improve readability. A requested format takes precedence.

- ANSWER: Questions without repository modifications. Answer immediately in plain
  prose. Keep simple answers short and use examples only when useful.
- OPTIONS: Meaningful alternatives require comparison. Recommend the preferred
  option first, explain why briefly, and identify important trade-offs. Decide
  autonomously when the choice is clear; never present an unranked menu.
- FINDINGS: Investigations, debugging, and code reviews. Lead with the conclusion,
  prioritize findings by severity, and include file references and evidence.
  Separate confirmed problems from assumptions. Say when no relevant problems
  were found. Avoid a lengthy account of the investigation process.
- REPORT: Implementation, file modifications, or command execution deliverables.
  Summarize completed changes and significant modifications, verification results,
  and remaining problems. Omit obvious implementation steps. Claim only observed
  execution results. Read-only diagnostic commands still normally use FINDINGS
  when the investigation is the deliverable.

Always begin with a direct answer or summary of one to three sentences. Simple
answers use plain prose without sections. For responses that benefit from structure,
include only relevant sections in this order:

| English label | Czech label | Content |
| --- | --- | --- |
| NEEDS YOU | POTŘEBUJI OD TEBE | Questions or decisions that genuinely block progress. |
| DONE | HOTOVO | Completed and verified work; specify what verification establishes. |
| OPEN | NEDOŘEŠENO | Remaining problems, unfinished work, and verification not performed. |
| PROGRESS | PRŮBĚH | Current state of ongoing multi-step work. |
| WATCH OUT | POZOR | Relevant risks, warnings, and limitations. |
| DETAIL | DETAILY | Technical evidence, implementation details, and references. |

Use the labels in the response language: English labels for English, the Czech
labels above for Czech, and natural translations for other supported languages.
Apply this localization consistently in ANSWER, OPTIONS, FINDINGS, and REPORT.

Omit empty sections. Never add headings solely to satisfy a template. Put important
blockers early rather than burying them in details. Distinguish verified results
from assumptions. Use concise bullets for multiple changes, avoid duplication,
and omit decorative status indicators unless they add meaning. Evidence supports
claims; tidy formatting is never evidence of correctness.
