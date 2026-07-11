# The JarvisOS Skills Library

**What this is.** 115 kernel-neutral engineering skills — the reusable expertise of the founding architect, written so any model driving any kernel can execute them identically. Each skill is a *procedure*, not a description. Skills are the mechanism by which judgment survives model replacement (FABLE §15): a good decision made once, written as a skill, is made well forever.

**Relationship to the rest of the system.** [FABLE.md](../FABLE.md) is the *why* (principles, philosophy, mental models). This library is the *how* (step-by-step procedures). When they overlap, FABLE states the belief and the skill executes it. A skill that contradicts a Constitution law is a bug in the skill.

## How to use this library

- **As an AI:** when a task matches a skill's *When to use*, open that skill and follow its *Steps* literally. Skills compose — most non-trivial work chains several (a project bootstrap invokes decomposition, architecture design, ADR writing, git strategy).
- **As the operator:** you never invoke these directly. Your AI does. They exist so that whatever model you talk to behaves like the one that built the system.
- **Stable IDs:** every skill has an `S-###` ID. Cite skills by ID in ADRs, jobs, and other skills so references survive renames.

## Skill template (every skill has exactly these fields)

`Purpose` · `When to use` · `Inputs` · `Outputs` · `Methodology` · `Steps` · `Success` · `Failure` · `Example`

## Index

| File | Range | Skills |
|---|---|---|
| [01 — Thinking & Planning](01-thinking-planning.md) | S-001…012 | Problem framing, decomposition, planning altitudes, prioritization, decisions, tradeoffs, decision trees, risk, assumptions, scope, estimation, requirements |
| [02 — Architecture](02-architecture.md) | S-013…024 | Arch review, arch design, seam ID, ADR writing, ADR reversal, impact analysis, model-survival design, state placement, contract design, MCP capability design, boundaries, data classification |
| [03 — Repository & Git](03-repository-git.md) | S-025…032 | Repo planning, project bootstrap, git strategy, commit hygiene, repo evolution, mono/poly decision, gitignore, conflict resolution |
| [04 — Code](04-code.md) | S-033…040 | Code review, naming, refactoring, deletion, abstraction timing, strangler migration, code reading, config design |
| [05 — Testing & Verification](05-testing-verification.md) | S-041…048 | Test strategy, test writing, done-when authoring, verification, regression pinning, injection canaries, concurrency testing, fresh-install testing |
| [06 — Debugging & Failure](06-debugging-failure.md) | S-049…055 | Debugging, root cause, performance investigation, failure recovery, post-mortem, reproduction, bisection |
| [07 — Security & Privacy](07-security-privacy.md) | S-056…063 | Security review, threat modeling, injection hardening, secret management, egress control, least privilege, privacy partition, dependency audit |
| [08 — Research & Knowledge](08-research-knowledge.md) | S-064…070 | Research, OSS evaluation, reverse engineering, knowledge extraction, source verification, landscape survey, spikes |
| [09 — Graphify & Memory](09-graphify-memory.md) | S-071…078 | Graphify analysis, graph construction, graph query design, memory design, memory write, consolidation, recall, graph maintenance |
| [10 — AI Orchestration](10-ai-orchestration.md) | S-079…090 | Context management, compression/handoff, delegation, parallelization, multi-agent, prompt review, prompt authoring, kernel instructions, job authoring, kernel swap, model selection, adversarial verification |
| [11 — Models & Infra](11-models-infra.md) | S-091…099 | LiteLLM routing, MCP integration, Windows automation, scheduler jobs, local model sizing, gateway config, backup/restore, watchdog, cost governance |
| [12 — Delivery & Lifecycle](12-delivery-lifecycle.md) | S-100…110 | Release planning, migration planning, deployment, long-running PM, documentation, glossary, quarterly checkup, component replacement, operator onboarding, outbox/approval, self-documentation |
| [13 — Meta](13-meta.md) | S-111…115 | Skill authoring, checklist authoring, communicating with humans, communicating with agents, anti-pattern detection |

**115 skills.** New skills append to the correct category file, take the next global ID, and add a row nowhere else — this README's table is per-file, so only add a file when a new category is born.
