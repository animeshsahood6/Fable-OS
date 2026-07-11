# JarvisOS — Architecture V2

**Status:** proposed remediation, responding to [reviews/2026-07-09-red-team-review.md](reviews/2026-07-09-red-team-review.md).
**What V2 keeps from V1:** the two seams (model gateway, MCP), files-first state, roles-not-products, the ADR/constitution discipline, offline baseline. Those were sound.
**What V2 changes:** it adds the structures that turn V1's *laws* into *mechanisms*. V1 said "treat data as data," "require approval," "keep secrets safe" — and provided no enforcement for any of them. V2's thesis: **a law without a mechanism is a wish, and this system had too many wishes.**

---

## 1. The core defect V2 fixes

V1 was a **document architecture** mistaken for a **system architecture**. It described correct policies and assumed correct behavior would follow. But the operator is a non-programmer and the executor is a stochastic model reading untrusted input — neither can be trusted to *voluntarily* comply with a policy at 3 a.m. V2 makes the safe path the *only* path by building it into structure: trust tiers, an outbox, quarantine, privacy-partitioned repos, watchdogs, and executable tests.

## 2. Revised layer model (additions in **bold**)

```
┌──────────────────────────────────────────────────────────────────┐
│  L5  INTERFACES     chat · voice · scheduled jobs · **OUTBOX UI** │
├──────────────────────────────────────────────────────────────────┤
│  L4  AGENT KERNEL   split into TWO trust contexts:                │
│      **L4a READER**  reads untrusted content — NO send/delete/pay │
│      **L4b ACTOR**   privileged actions — NEVER reads raw untrust │
├──────────────────────────────────────────────────────────────────┤
│  **L3.5 GUARDS**    outbox gate · egress allowlist · memory       │
│                     quarantine · budget governor · secret broker  │
├──────────────────────────────────────────────────────────────────┤
│  L3  CAPABILITIES   MCP servers, each tagged READ / WRITE / SEND  │
├──────────────────────────────────────────────────────────────────┤
│  L2  MODEL GATEWAY  LiteLLM + master key + per-route budgets      │
├──────────────────────────────────────────────────────────────────┤
│  L1  MODELS         cloud + local; **kernel model routed here too**│
├──────────────────────────────────────────────────────────────────┤
│  L0  SUBSTRATE      **Windows 11** · winget · git · uv(Python) ·  │
│                     Task Scheduler · Credential Manager           │
└──────────────────────────────────────────────────────────────────┘
   STATE: privacy-partitioned repos (docs / config / data / projects)
```

## 3. Trust tiers + injection defense (fixes C2, I6)

The single most important structural change. Every piece of content carries a **trust tier**:

| Tier | Source | May trigger |
|---|---|---|
| T0 operator | direct human instruction, approved | anything |
| T1 system | this repo's own docs/config | read, plan |
| T2 authenticated | the operator's own files, authed services | read; writes to `data` **quarantined** |
| T3 open | web pages, inbound email bodies, tool output from the internet | **read only, in the READER context; cannot invoke SEND/WRITE/PAY tools** |

Enforcement, not exhortation:
- **READER/ACTOR split (L4a/L4b).** The context that ingests T3 content is spawned with an MCP profile containing **only READ-tagged tools**. It produces a *proposal* (a file). A separate ACTOR context, which never sees raw T3 bytes (only the vetted proposal), holds WRITE/SEND tools. Injected instructions land in a context that structurally cannot act on them.
- **Memory quarantine.** Anything derived from T2/T3 is written to `data\memory\_quarantine\` with `reviewed: false` frontmatter. The recall index **excludes unreviewed quarantine** by default. Promotion to trusted memory requires an operator approval or a T1 rule. This breaks C2's persistence chain: a poisoned memory can never silently become a trusted instruction.
- **Egress allowlist.** A guard limits which hosts any capability may reach; exfiltration to an arbitrary attacker domain is blocked at L3.5, not trusted to the model.
- **Injection canary suite** (Missing Test #2) runs at every model/kernel change.

## 4. Privacy partition + real backup (fixes C3, I8, I9)

One monorepo becomes four repos by data classification (see review §7). The rule that resolves the C3 contradiction: **`fableos-data` (memory + journals) never leaves the machine unencrypted.** Its only offsite path is **restic** (encrypted, deduped) to an external drive and optionally an untrusted cloud bucket — mandatory, scheduled, with a monthly automated restore-verify. `git push` exists only for `docs` and (private) `config`; a pre-push guard blocks any personal-tier data. SQLite is backed up via `.backup` (consistent snapshot), never live file copy. **Backup = restic snapshot + docs/config push; Restore = documented, drilled, and scheduled** — no longer a one-liner that oversells.

## 5. Real provider-agnosticism (fixes C4)

ADR-002's kernel exception is revoked and replaced (ADR-009, ADR-010):
- The kernel's model runs **through the gateway** like everything else, so the reasoning brain can be repointed to a local or alternate model by config.
- The **successor kernel runs a real weekly parity job** (not "installed once, dormant"): the same task file through primary and successor kernels, outcomes diffed into the weekly status. Provider-agnosticism is thereby *continuously exercised* — the only kind that survives contact with a dead provider. If the primary provider vanishes on a Tuesday, the Monday parity run proves the successor still works.

## 6. The Outbox — approval as a mechanism (fixes C5)

Resolves the autonomy-vs-oversight contradiction that V1 wrote down twice. A first-class L3.5 component:
- Headless jobs (L4a/READER, scheduled) may **draft** anything — emails, posts, commits, file deletions — as entries in `outbox\pending\`, each with a plain-English summary, the exact action, and its blast radius.
- **Nothing in `pending\` executes.** The operator reviews via the Outbox UI (or the morning brief reads the queue aloud); approval moves an entry to `approved\`; the ACTOR processor executes only approved entries and logs to `outbox\done\`.
- Law 7 is now structural: autonomy drafts, humans approve, and the two cannot be confused. The 8 a.m. brief becomes: *"I read your inbox; 3 replies are drafted and waiting; approve to send."*

## 7. Observability + watchdog (fixes C7)

A watchdog Task Scheduler job (every few hours) checks: gateway responds, journal <24h old, backup <7d old, disk >10% free, no job in error state → **Windows toast on failure** + a `journal\weekly-status.md` line the morning brief **must** read aloud. Silent death becomes loud within hours. Added from Phase 1, not Phase 7.

## 8. Substrate correction (fixes C1, I1)

- **Windows 11** migration is a Phase 0 exit gate (hardware — RTX 4070 Ti, 31 GB — supports it). OS-EOL check joins the quarterly checkup permanently. Media Feature Pack installed for the N edition before Phase 4.
- **uv** (Astral) declared as the managed Python runtime substrate — LiteLLM, Open WebUI (native, not Docker), faster-whisper all run under a pinned uv environment. ADR-006 amended: native-Python-via-uv is permitted; Docker/WSL still require a superseding ADR. Postiz (Docker-only) is demoted to "optional, deferred" and per-platform MCPs are the default social path (they also churn less catastrophically).

## 9. Graphify as the memory query layer (fixes I13)

The recall role gains a graph tier **above** the guaranteed SQLite-FTS baseline (never replacing it — Law 4, graphify is a personal skill not maintained OSS):
- A graph over `data\memory\` + `journal\` answers *"what did we decide about X, and what depends on it"* by **path and community**, not keyword — the query V1's FTS could not serve.
- A **decisions graph** links laws ↔ ADRs ↔ components so impact analysis (*"what breaks if we drop ADR-002?"*) is a traversal.
- Per-project graphs (`projects\<name>\graphify-out\`) give the kernel codebase understanding on demand.
- If graphify is ever unavailable, recall falls back to FTS with degraded richness, never zero. Encoded as the `graphify-memory` skill.

## 10. Interface reduction (fixes M7)

The kernel is the primary interface. Open WebUI is deferred until a proven casual-chat need — one onboarding surface for the non-programmer, not two.

## 11. Revised roadmap deltas

- **Phase 0** gains: Windows 11 gate, git identity config, uv install, four-repo init, secret-scanning hook, executable `tests\phase-0.ps1` that runs on a fresh machine. C6's failure cannot recur — no install script ships unexecuted.
- **Phase 1** gains: gateway master key, localhost-only binding, budget caps, watchdog, quarterly-checkup job scheduled now.
- **Phase 2** gains: the kernel instructions file (written, not referenced), READER/ACTOR profiles, MCP tools tagged READ/WRITE/SEND, real successor-parity job, GLOSSARY.
- **Phase 3** gains: memory frontmatter schema + quarantine + provenance, graphify tier, restic + restore-verify, single-writer index discipline.
- **Phase 6** gains: the Outbox as its precondition — no outward capability ships without it. ACCESS-PREREQS drives realistic expectations.

## 12. New ADRs required (append to DECISIONS.md)

- **ADR-009** — Split kernel into READER (untrusted-input, unprivileged) and ACTOR (privileged, no raw untrusted input). Supersedes the implicit single-context kernel.
- **ADR-010** — Revoke ADR-002's kernel provider exception; kernel routes through the gateway; weekly successor-parity job replaces "dormant successor."
- **ADR-011** — Privacy partition: four repos by data classification; `data` never leaves unencrypted; restic mandatory.
- **ADR-012** — The Outbox: all outward/destructive actions flow through draft→approve→execute; headless never sends.
- **ADR-013** — Trust tiers + egress allowlist + memory quarantine as the injection-defense structure.
- **ADR-014** — Windows 11 + uv-managed Python as substrate; amend ADR-006.
- **ADR-015** — Graphify as an enhancing recall tier over the SQLite-FTS baseline.

## 13. Honest residual risks (V2 is not perfect either)

- The READER/ACTOR split raises orchestration complexity and token cost — it trades some of V1's simplicity for safety it genuinely needed. Watch that it doesn't ossify into Migration Purgatory.
- restic + four repos + uv + watchdog is materially more setup for the non-programmer; ACCESS-PREREQS and OPERATIONS.md must carry that weight, and the copy-paste discipline must hold.
- Graphify remains a bus-factor-one dependency (one person's skill); the FTS baseline is the insurance, and that insurance must be tested, not assumed.
- The Outbox introduces approval fatigue risk (FABLE §32.6); batching and good summaries are the mitigation, and they are unproven until real use.

**Bottom line for the investment committee:** V1 was a beautifully documented set of intentions with a soft, dangerous middle. V2 is buildable and defensible *if* the seven critical fixes ship before any outward-facing capability (Phase 6) does. Fund conditional on C1–C7 closed and the injection canary suite green.
