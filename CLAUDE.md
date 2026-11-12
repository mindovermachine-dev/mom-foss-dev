# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repository is

The strategy and proposed architecture for a managed, sovereign open-source development platform: Forgejo, Synapse, and an identity provider on Kubernetes, one isolated environment per customer. The repository is **public**, so do not add secrets, customer names, or internal pricing beyond what is already published.

| Path                                 | Holds                                                                                                               |
| :----------------------------------- | :------------------------------------------------------------------------------------------------------------------ |
| `docs/content/`                      | The documentation site, published at <https://docs.mindovermachine.dev/mom-foss-dev/>. One sidebar group per folder |
| `docs/content/decisions/register.md` | The decision register: every decision and open question. Use the `decision-register` skill to change it             |
| `docs/site.config.mjs`               | Site configuration for `remote-astro-theme`, including the sidebar                                                  |
| `src/<topic>/`                       | Research and infrastructure code, for example `src/authentik/` and `src/opentofu/`. Not published on the docs site  |

Pages in `docs/content/` link to files in `src/` with full GitHub URLs on `main`, because `src/` is not part of the site.

## Workflow

The repository follows the TakT flow, using the `gh tt` extension:

1. Every change starts from a GitHub issue, using the MoM issue template (Problem, Solution, Value, Deliverables).
2. `gh tt workon -i <issue>` creates an issue branch, named `<issue>-<title>`.
3. `gh tt wrapup` commits and pushes; `gh tt deliver` delivers through a `ready/**` branch.

Commit or push only when the user asks.

## Quality gates

The pre-commit hook runs `gh insitu run trunk-worthy`: cspell, markdownlint, and `prettier --check`. AI edits bypass format-on-save, so after editing files run:

```sh
gh insitu run fix-all
```

- If cspell reports a correct word, add it to `.dict/repo.dictionary`. Do not reword to avoid the check.
- Prettier reformats Markdown tables. Read a file again before editing it after `fix-all` has run.
- markdownlint skips `docs/`, but cspell and prettier do not.

To check that the docs site builds, run `remote-astro-theme build` from the repository root. The output goes to `dist/`, which Git ignores.

## Writing

- Plain language, short sentences, ISO dates (`2026-11-12`).
- Present proposals as proposals. Pricing, provider capabilities, and compliance claims are planning assumptions to validate.
- Write "authentik" in lower case, as the project does.
- Do not state a fact about a product without a source. Link the source in the document.
