---
name: decision-register
description: Add, update, accept, or answer entries in the decision register at docs/content/decisions/register.md. Use when the user wants to record a decision, raise or answer an open question, change a decision's status, or asks what has been decided or is still open.
---

# Decision register

The register in `docs/content/decisions/register.md` is the shared source of truth for what has been decided about the platform, and what is still open. It is published on the docs site.

## Structure

The register has one section per area. Each section has an `### Open questions` table and a `### Decisions` table.

| Area            | Prefix |
| :-------------- | :----- |
| Identity        | `idn`  |
| Platform        | `plt`  |
| Network         | `net`  |
| Data and backup | `dr`   |
| Engineering     | `eng`  |
| Operations      | `ops`  |

Table formats, with fixed column order:

```markdown
| ID       | Question                                          |
| :------- | :------------------------------------------------ |
| `idn-q1` | What is not known, and what depends on the answer |

| ID       | Decision                          | Alternatives                                | Rationale                  | Status   |
| :------- | :-------------------------------- | :------------------------------------------ | :------------------------- | :------- |
| `idn-d1` | What is decided, in present tense | Options considered, separated by semicolons | Why, with links to sources | Proposed |
```

## Rules

- Identifiers are `<prefix>-q<n>` for questions and `<prefix>-d<n>` for decisions, always in backticks.
- Numbers count per prefix and type, starting at 1. To find the next number, search the register for the highest existing one, for example `grep -o 'idn-d[0-9]*' docs/content/decisions/register.md | sort -V | tail -1`.
- An identifier never changes, and a number is never reused, even if a row is moved.
- A decision takes the prefix of the area it mainly constrains, even if it touches others.
- Status is **Proposed** or **Accepted**. Only Accepted decisions are in force. Never set a decision to Accepted unless the user says it has been decided.
- Rows are never deleted. To reverse a decision, change its wording and rationale. Git keeps the history.
- Write the decision in the present tense. Keep the rationale short, and link research documents for longer reasoning. Link files in `src/` with full GitHub URLs on `main`, for example `https://github.com/mindovermachine-dev/mom-foss-dev/blob/main/src/authentik/authentik-research.md`.
- Do not state facts about products without a source. If the user asks for a rationale that the evidence does not support, say so before writing it.

## Tasks

**Raise an open question.** Add a row to the area's open questions table with the next `q` number. Say what depends on the answer, and reference affected identifiers.

**Record a decision.** Add a row to the area's decisions table with the next `d` number and status Proposed, unless the user says it is accepted. Fill in Alternatives. If no alternatives were considered, write `None considered`.

**Answer a question.** Record the decision as above. Then append to the question's row: `Answered by` followed by the decision identifier, for example ``Answered by `idn-d2`.``. Keep the question row.

**Accept a decision.** Change its status to Accepted. Mention the issue or discussion where it was decided in the rationale, if there is one.

**Add an area.** Add a row to the area table under "How the register works", then a section with both tables. Choose a short, unused prefix.

## After editing

1. Run `gh insitu run fix-all`. Prettier realigns the tables.
2. Add any words cspell rejects to `.dict/repo.dictionary`.
3. Run `gh insitu run trunk-worthy` and confirm all checks pass.
4. If other docs present the options that a decision settles, link them to the register entry, for example `[decision register](../../decisions/register/#identity)`.
