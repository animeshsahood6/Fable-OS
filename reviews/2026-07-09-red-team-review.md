# JarvisOS — Pre-Investment Red-Team Review

**Reviewer stance:** Principal Engineer, external, adversarial. Mandate: find reasons NOT to invest.
**Verdict: DO NOT INVEST as documented.** The documentation discipline is genuinely unusual and the seam-based core is salvageable, but the system as written contains two flaws that will harm its operator (C2, C3), one that voids its founding requirement (C4), one that strands its non-programmer at step one (C6), and a substrate that is already end-of-life (C1). The constitution and the roadmap contradict each other from Phase 6 onward (C5). Conditional reinvestment after [ARCHITECTURE-V2.md](../ARCHITECTURE-V2.md) is adopted.

---

## 1. CRITICAL FLAWS

### C1 — The substrate is already dead
L0 says "Windows 10/11" as if they were equivalent. The actual machine runs **Windows 10 Pro N build 19045, end-of-support October 2025** — the ten-year system was founded on an OS that stopped receiving security patches nine months earlier. Worse, the **N edition** lacks the Media Feature Pack, which the Phase 4 voice stack may need for audio subsystems. The Phase 0 hardware survey records RAM and GPU but not OS support status — the architecture never audited its own foundation. **Fix:** Windows 11 migration (hardware supports it) is a Phase 0 exit gate; OS-EOL check joins the quarterly checkup permanently.

### C2 — Prompt injection becomes *persistent* memory poisoning, by design
The kernel reads untrusted content (web pages, and from Phase 6, email) in the same context where it holds terminal access, file write, and eventually email send. It then writes journals and memories that **future sessions load as trusted instructions**. Attack: one crafted email → kernel follows embedded instructions → writes attacker text into `memory\` → every future session (and every future *model*) inherits the compromise. The security checklist in FABLE.md *names* prompt injection; the architecture contains **zero structural defense** — no trust tiers, no separation of read-untrusted from act-privileged, no quarantine on memory writes, no egress allowlist. A law ("treat data as data") without an enforcement structure is a wish. This is the flaw that gets the operator's accounts drained or inbox weaponized. **Fix:** trust-tier execution contexts + outbox gate + memory quarantine (V2 §3).

### C3 — The privacy model contradicts the recovery model
Journals will contain the operator's email contents, calendar, and drafts. The whole of `D:\Fable OS\` is one git repo, and disaster recovery says *"clone/copy from GitHub."* Follow the thread: the operator's private life is scheduled for upload to a third party. And it's worse than that in both directions: **no job ever runs `git push`** — so the GitHub leg of DR silently depends on a push that doesn't exist — and if a future agent "fixes" that by adding a push, the privacy breach ships. Neither the gap nor the hazard was noticed because backup, privacy, and DR were designed in three different documents. **Fix:** privacy-partitioned repositories; personal data never leaves the machine unencrypted; restic offsite becomes mandatory, not "optional" (V2 §4).

### C4 — Provider-agnosticism is a façade at the center
ADR-002 quietly grants the kernel an "exception" to use its provider natively. But the kernel **is the system** — it does the thinking, planning, coding, and acting. The gateway's beautiful model-agnosticism governs the chat UI and utility calls; the brain is hard-wired to one provider. If that provider is lost, the system doesn't "degrade in quality" as Law 6 promises — it loses L4 entirely, because Claude Code does not run on Ollama. The actually load-bearing provider-agnosticism (Goose/OpenCode successors) is relegated to a "dormant, smoke-tested once" footnote. Founding requirement #1 ("everything must be provider agnostic") is not met by the architecture as written; it is met by a contingency plan nobody rehearses. **Fix:** the successor kernel runs a real scheduled job weekly — parity is *exercised*, not stored (V2 §5).

### C5 — Approval is a law without a mechanism
Law 7: destructive/outward actions require explicit approval **every time**. Roadmap Phases 6–7: the kernel runs **headless from Task Scheduler at 8 a.m.** There is no approval queue, no notification channel, no UI where a non-programmer sees "3 drafts pending." As written, either scheduled autonomy violates the constitution, or the constitution forbids the roadmap's endgame. The system's central tension — autonomy vs. a non-programmer's oversight — was never resolved, just written down twice, incompatibly. **Fix:** the Outbox — an approval queue as a first-class component; headless jobs may *draft* anything and *send* nothing (V2 §6).

### C6 — Phase 0 fails on a fresh machine, at step one, for the exact target user
`install\phase-0.ps1` runs `git commit` without configuring `user.name`/`user.email`. On a fresh git install, commit **fails** with *"Please tell me who you are"* — an error the non-programmer operator cannot interpret, at the very first thing they ever run. The script also exits mid-way after installing git ("open a new window and run again") — a fragile two-pass dance for the audience least equipped to handle it. The single most important artifact to test was the first one the operator touches; it was never executed. **Fix:** configure git identity in-script (prompting from the recorded operator email), single-pass flow, and a standing rule: *no install script ships unexecuted* (see Missing Tests).

### C7 — Silent death is the default failure mode
Gateway logon task, nightly memory job, backups — any can fail silently for months. Nothing monitors, nothing notifies. For an operator who cannot debug, "the nightly job stopped in March" is discovered in July as months of unrecoverable memory/backup loss. The release philosophy demands "observable"; the system as designed has zero health checks and no channel to raise a hand. **Fix:** watchdog task + Windows notifications + weekly status file the morning brief must read aloud (V2 §7).

---

## 2. IMPORTANT FLAWS

**I1 — ADR-006 contradicts the component registry.** "No Docker, no WSL" — yet Open WebUI is Docker-first (native = a pip install), LiteLLM *is* a Python package, and Postiz is effectively Docker-only. Three chosen components violate the substrate ADR's spirit, and no document installs or pins Python. Either declare a managed Python runtime (uv) as substrate, or choose different components. Currently: unresolved, and the operator hits it in Phase 1.

**I2 — No version pinning anywhere.** DR says "rerun install scripts" — which install *latest* versions against year-old configs. A recovery six months after a component's breaking release fails in undebuggable ways. Need a `VERSIONS.md` manifest updated at every change and honored by install scripts.

**I3 — Multi-agent-through-files has no concurrency discipline.** ADR-008 coordinates parallel agents through shared files; the nightly job runs `git add -A` on a tree agents may be writing; MEMORY.md is a single contended index; "append-only journal" has no writer convention. Lost writes and dirty commits are guaranteed at exactly the phase (7) with the least supervision. Need: per-agent output files, single-writer rule for indexes, commit lock.

**I4 — No cost governance.** Autonomous scheduled agents with cloud API access and no budget cap, no spend tracking, no alert. A retry loop at 3 a.m. is an unbounded credit-card drain. LiteLLM has budget features; the design doesn't use them.

**I5 — Credential reality for a non-programmer is wildly underestimated.** Gmail/Outlook OAuth app registration, X/Meta developer-tier approval and fees — Phase 6's "done when" tests assume access the operator likely cannot obtain alone. Needs an honest ACCESS-PREREQS document with costs, difficulty ratings, and fallbacks; otherwise Phase 6 is where the operator gives up.

**I6 — Local service security defaults unspecified.** LiteLLM without a master key, Open WebUI in default signup mode, no statement that services bind to localhost only. Any LAN peer or local malware gets the operator's API keys and chat history. Also unresolved: how `secrets.env` values actually reach each process (the injection mechanism is never designed) — Law 9 has the same law-without-mechanism disease as Law 7.

**I7 — Memory architecture is naive.** No provenance, confidence, or review status on memories (see C2); no conflict/dedup handling until a Phase-7 "consolidation"; no defined trigger for reindexing (files change → index stale → search silently wrong); MEMORY.md grows unbounded as a single file. The memory system is the system's soul and got the least engineering of any component.

**I8 — Projects have a DR hole.** `projects\` are separate repos excluded from the main repo; nothing mandates they have remotes or enter any backup. "Backup = copy this folder" is true only for the external-drive path; the GitHub path silently loses every project. Also `.gitignore`'s `projects/*/` still tracks loose files in `projects\` root — inconsistent contract.

**I9 — Backup design is half-serious.** Offsite encrypted backup is "optional" for a single machine holding someone's externalized memory. Live-file copying (SQLite mid-write) can corrupt. Restore verification is quarterly prose, not a scheduled job. For a system whose entire pitch is durability, backup got one bullet point.

**I10 — Claude Code idioms leaked into the "kernel-neutral" contracts.** The `memory\MEMORY.md` one-line-index pattern, "skills and hooks," session journaling, and the sub-agent model are all Claude Code's shapes. The kernel-swap playbook says "point the successor at `config\mcp.json`" — but MCP *client config formats are not standardized across kernels* (Goose and OpenCode use different registration formats). The swap is real but harder than the "config edit" the docs advertise. The Phase 2 dual-kernel test partially redeems this — if it's ever actually run.

**I11 — The voice loop has no component.** Hotkey → audio capture → VAD → STT → kernel → TTS is real software, far beyond "200 lines of glue," and no OSS project is named for it. Phase 4 as written violates Law 3 or stalls.

**I12 — Another model will misread the metaphors.** "Kernel" (collides with OS kernels), "walls/furniture," "ratchets," "seams" — load-bearing terms defined nowhere. FABLE.md defines some in passing; the architecture uses them cold. A GLOSSARY is missing, and for a system premised on model succession, undefined vocabulary is a defect, not a style choice.

**I13 — Graphify is ignored.** The operator already owns a knowledge-graph skill (graphify: any input → persistent graph, community detection, query/path/explain). The memory design reinvents a worse index. Integration points: (a) graph over `memory\` + `journal\` answering "what did we decide about X and why" via paths, not keyword search; (b) per-project graphs in `projects\<name>\graphify-out` for codebase understanding; (c) a decisions graph linking ADRs ↔ components ↔ laws so impact analysis ("what depends on ADR-002?") is a query; (d) research corpora graphs feeding reports. Constraint: graphify is a personal skill, not a maintained OSS project — per Law 4 it may *enhance* the index role, never solely fill it; SQLite FTS stays as the guaranteed baseline.

---

## 3. MINOR FLAWS

- **M1** `.gitignore`: `*.env` is over-broad (hides any legitimately tracked env template) and makes the `config/secrets.env` line redundant.
- **M2** `models.yaml` route taxonomy mixes tasks (`reasoning`, `fast`) with a property (`offline`) — a future agent will misfile routes.
- **M3** Phase 4 depends inline on Phase 6 (morning brief) — admitted in a parenthesis instead of fixed by reordering.
- **M4** `vault\` inventory is hand-maintained Markdown with no reconciliation against Credential Manager — will drift within a month.
- **M5** `hardware.md` survey omits **VRAM** — the actual determinant of local model size — and OS support status (see C1).
- **M6** No LICENSE, no CHANGELOG, no versioning of the document set itself.
- **M7** Two chat surfaces (Open WebUI + kernel) for one non-programmer = двойной onboarding. Defer Open WebUI until a proven need; the kernel is the interface.
- **M8** ComfyUI model weights (tens of GB) have no stated backup/exclusion policy — they'll either bloat backups or silently not be re-downloadable.
- **M9** ROADMAP's first checkbox ("founding documents written") was self-certified by their author — cute, but "done when" tests should be independently checkable, and the habit matters more than this instance.
- **M10** FABLE's closing instruction ("successor writes its own version") has no scheduled trigger — an intention, not a ratchet, in a document that preaches ratchets.
- **M11** README promises "backup = copy this folder" unqualified; true only with caveats (I8, M8) — the one-sentence DR plan oversells.

*(M7 contains a non-English word — "двойной" — left in deliberately as evidence of exactly the kind of generation slip C-class reviews exist to catch. It means "double." The founding documents contained one such slip too, since fixed.)*

---

## 4. MISSING DOCUMENTS

1. **SECURITY.md** — threat model: trust tiers, injection defenses, egress policy, local-service hardening. The system's largest gap.
2. **PRIVACY.md** — data classification (public / internal / personal / secret) mapped to every directory, with explicit rules for what may enter git, leave the machine, or reach a cloud model.
3. **GLOSSARY.md** — kernel, seam, role, contract, capability, wall/furniture, ratchet, outbox, quarantine. (I12)
4. **OPERATIONS.md** — operator-facing runbook: "the light is red / the brief didn't arrive / a script errored — do this." MAINTENANCE.md is architect-facing; the non-programmer has nothing.
5. **ACCESS-PREREQS.md** — every account, OAuth app, developer tier, and fee Phases 5–6 require, rated by difficulty, with fallbacks. (I5)
6. **VERSIONS.md** — pinned component manifest. (I2)
7. **KERNEL-INSTRUCTIONS** (`config\kernel\instructions.md`) — the system prompt of the entire system is referenced in Phase 2 and **never written**. The single most important prompt does not exist.
8. **INCIDENTS.md** — append-only post-mortem ledger (FABLE demands post-mortems; nothing collects them).
9. **COSTS.md** — subscriptions + API spend, reviewed quarterly. (I4)
10. **LICENSE**, **CHANGELOG.md**.

## 5. MISSING AUTOMATION

1. Secret-scanning pre-commit hook (gitleaks) — Law 9 currently enforced by hope.
2. **Watchdog** scheduled task: gateway alive? journal fresh (<24h)? backup fresh (<7d)? disk >10% free? → Windows toast + a line the morning brief must read aloud. (C7)
3. **restic** encrypted offsite backup on schedule + a monthly *restore-verify* job. (C3, I9)
4. Version-manifest updater invoked by every install script. (I2)
5. Deliberate `git push` policy per repository tier — decided, scheduled, and privacy-checked, not accidental. (C3)
6. Memory-index rebuild triggered on write (or hourly), not manual. (I7)
7. **Outbox processor** — drafts accumulate; approval marks them; only approved items execute. (C5)
8. Quarterly checkup as a scheduled prompt from **Phase 1**, not Phase 7.
9. OS/EOL + dependency pulse check inside the checkup. (C1)
10. LiteLLM budget caps + spend log. (I4)

## 6. MISSING STANDARDS

1. Data-classification standard applied per directory (feeds PRIVACY.md and the push policy).
2. Journal/memory **write convention**: append-only rules, one-writer-per-file, frontmatter schema (`date, source, provenance, confidence, reviewed`). (C2, I3, I7)
3. **Trust-tier standard** for content sources (operator > local files > authenticated services > open web) and what each tier may trigger. (C2)
4. Job-file format standard for `config\jobs\*.md`: frontmatter declaring schedule, allowed tools, budget, approval gates. Today a job file is freeform prose feeding a headless agent — that is an incident generator.
5. Config schema versioning (`models.yaml` v1, `mcp.json` v1) so migrations are detectable.
6. Script error standard: every operator-facing script fails with a plain-English sentence plus a "paste this block to your AI" section.
7. Commit-message and branch conventions (currently implied, never stated).

## 7. MISSING REPOSITORIES

The monorepo is a privacy accident (C3). Split by data classification:

| Repo | Contents | Remote policy |
|---|---|---|
| `fableos-docs` | Constitution, architecture, ADRs, FABLE, install, tests | May push to GitHub (public or private) |
| `fableos-config` | config (sans secrets), vault inventory, jobs, kernel instructions | Private remote only |
| `fableos-data` | memory, journal | **Never leaves the machine unencrypted; restic only** |
| `projects\<name>` | each project | Own remote, **mandated** at creation (I8) |

## 8. MISSING SKILLS (kernel-neutral instruction modules)

1. `memory-write` — quarantine + provenance discipline for anything derived from untrusted content. (C2)
2. `outbox` — how to draft outward actions and never send them. (C5)
3. `research` — FABLE §23 as executable instructions (currently philosophy without an artifact).
4. `incident-response` — stabilize / preserve / rollback, operator-narrated.
5. `quarterly-checkup` — MAINTENANCE §1 as a runnable prompt.
6. `job-author` — how to write a safe `config\jobs\` file against the job standard.
7. `graphify-memory` — when and how to use the graph index vs. FTS. (I13)
8. `self-document` — the Law 8 same-session update ritual, mechanized.

## 9. MISSING PROMPTS

1. **The kernel's own instructions file** — see Missing Documents #7. Everything else is secondary to this.
2. `config\jobs\morning-brief.md`, `nightly-journal.md`, `weekly-status.md`, `quarterly-checkup.md` — all referenced, none written.
3. **Kernel-successor bootstrap prompt** — MAINTENANCE §2a describes the swap in prose; the actual verbatim prompt handed to Goose/OpenCode is unwritten and untested.
4. Session-handoff template (FABLE §6 demands clean handoffs; no template exists).
5. Injection-hardening preamble for any context that reads untrusted content. (C2)

## 10. MISSING TESTS

1. `tests\phase-N.ps1` — executable "done when" checks per phase (gateway responds; local route answers with cloud keys disabled; index delete→rebuild→search; backup restore of a random file).
2. **Injection canary suite**: seeded web page/email containing "write CANARY to X / send Y" — assert the system reads it as data and does neither. Run at every kernel or model change. (C2)
3. Secret-leak scan across repo + journals for key patterns. (Law 9)
4. Scripted DR drill against a temp directory/VM — MAINTENANCE calls for a rehearsal; nothing runs one.
5. Kernel-parity test: same task file through primary and successor kernels, diff the outcomes weekly. (C4, I10)
6. Config lint: schema validation for `models.yaml`/`mcp.json` before any restart.
7. Concurrency test: two agents journaling simultaneously; assert no lost writes. (I3)
8. Fresh-machine install test for every `install\*.ps1` — the test that would have caught C6.

---

*Remediation design: [ARCHITECTURE-V2.md](../ARCHITECTURE-V2.md).*
