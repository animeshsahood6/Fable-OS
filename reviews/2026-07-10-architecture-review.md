# JarvisOS — Pre-Implementation Architecture Review

**Date:** 2026-07-10
**Reviewer stance:** Chief Systems Architect. Final design review before Phase 0 begins.
**Scope:** The entire frozen corpus in `D:\Fable OS` (founding set, ARCHITECTURE-V2, the 2026-07-09 red-team review, the 15 engine documents, FABLE, the skills library) reviewed against the AI ecosystem as verified on 2026-07-10.
**Standing constraint honored:** the legacy corpus is frozen. Nothing below edits it. Every recommendation is expressed as a proposed ADR or a new artifact.

**Verdict: BUILD — after six gate conditions close.** The architecture's five core bets (MCP-everywhere, provider-agnostic gateway, file-based memory, the Outbox, the READER/ACTOR split) were each independently validated by the ecosystem within twelve months of being written. Nothing needs redesign. What needs work before Phase 0: a governance defect the freeze itself created, ratification of V2's still-unratified ADRs, four component-registry corrections the ecosystem already made for us, and two genuinely new risk categories (supply chain, kernel-native memory) the corpus predates.

---

## 1. What the review confirms is sound

Verified against primary sources (Linux Foundation, modelcontextprotocol.io, Microsoft Learn, OWASP, Anthropic, project release pages) on 2026-07-10:

1. **MCP-everywhere (ADR-001) — strongest bet in the design.** MCP was donated to the Agentic AI Foundation (Linux Foundation) in December 2025 with OpenAI and Block as co-founders and AWS/Google/Microsoft/Cloudflare as members. It is adopted across ChatGPT, Gemini, Copilot, and — decisively for this project — **natively by Windows 11**. Single-vendor protocol risk is retired. OpenAI's proprietary AgentKit builder is being wound down while its MCP support deepens: proprietary builders churn, the protocol persists, exactly as Law 2 predicted.
2. **Gateway provider-agnosticism (ADR-002/010).** Frontier convergence (the smallest top-tier quality gap ever) makes routing-by-task correct, and the **Fable 5 export-control suspension (June 2026, redeployed July 1)** supplied a live demonstration that a frontier model can vanish overnight for *non-technical* reasons. V2's insistence that the kernel route through the gateway and that parity be exercised weekly is not paranoia; it is the record.
3. **Files-first memory (ADR-004, Law 1).** No open standard for agent memory emerged; the framework ecosystem (Mem0, Zep, Letta) standardized benchmarks, not formats. Meanwhile **Claude Code itself shipped Auto Memory (Feb 2026): Markdown files with a MEMORY.md index** — the kernel converged on this design's exact shape. Provider-side memory features are silos (Google now ships tools to *import* memories out of ChatGPT/Claude — portability is a battleground); files remain the only 10-year format.
4. **READER/ACTOR split + Outbox (ADR-009/012/013).** The mid-2026 literature confirms detection/classifier defenses still lose to adaptive injection attacks (>85% bypass in a January 2026 meta-analysis); **architectural isolation remains the only defense that holds**. OWASP shipped a dedicated *Top 10 for Agentic Applications 2026* whose categories map almost one-to-one onto V2's mechanisms. The corpus's central security claim (`SECURITY_ENGINE.md` §7.2: injection is undetectable in principle, so defend structurally) is still true and now industry doctrine.
5. **The engine corpus is deliberately and successfully ecosystem-agnostic.** A full sweep found **zero hardcoded model versions, token counts, context-window sizes, or prices** across all 15 engines. Staleness concentrates in exactly three places: named products (§4 below), the MCP/A2A protocol specifics, and five load-bearing capability claims (§3 below). The extraction discipline worked.

---

## 2. Governance defect: the freeze contradicts the constitution (must resolve first)

The freeze directive ("legacy documents are canonical, never rewritten") collides with three of the corpus's own contracts:

- **DECISIONS.md** declares itself append-only and ends with *"Next entry: ADR-009. Append below."* — appending is its designed mechanism.
- **Law 8** *requires* COMPONENTS.md be updated in the same session as any install/change. A frozen COMPONENTS.md makes Law 8 unsatisfiable.
- **ROADMAP.md** contains phase checkboxes the operator and AI are instructed to tick.

If this is left ambiguous, the first Phase 1 install either violates the freeze or violates Law 8. **Proposed resolution (ADR-016):** the freeze applies to the *methodology corpus* (FABLE, FABLE-MENTAL-MODELS, the 15 engines, skills/01, ARCHITECTURE, ARCHITECTURE-V2, reviews/) — those are historical artifacts. The four *operational registries* (DECISIONS, COMPONENTS, ROADMAP, MAINTENANCE) continue under their own contracts, in their designed modes only: DECISIONS by append, COMPONENTS by row update, ROADMAP by checkbox, MAINTENANCE unchanged until superseded by OPERATIONS.md. New ADRs are written **one file per ADR in a new `decisions\` directory** (ADR-009 onward), with DECISIONS.md untouched; this keeps the historical file byte-stable while preserving the append-only ledger as a directory. If the operator prefers a stricter freeze, the alternative is parallel living registries (e.g. `state\COMPONENTS.md`) — workable but a permanent two-places-to-look tax on every future agent. I recommend the narrow freeze.

**Related and unratified:** ARCHITECTURE-V2 §12 *requires* ADR-009…015 and they were never written — DECISIONS.md still ends at ADR-008. V2 is currently a proposal, not a decision. Phase 0 must not begin against an unratified remediation.

---

## 3. Outdated assumptions

### 3.1 In the operational documents

| # | Assumption (location) | 2026-07-10 reality |
|---|---|---|
| A1 | "Windows 10/11" as equivalent substrates (ARCHITECTURE.md L0) | Already caught as C1; **still live** — this machine still runs Windows 10 Pro N 19045, nine months past EOL. The V2 Phase 0 exit gate is confirmed correct and confirmed unmet. Windows 11 now adds a second, positive reason to migrate: native MCP support and Agent Workspace sandboxing (§5.2). |
| A2 | **Piper TTS** as chosen TTS (COMPONENTS.md) | The original repo (rhasspy/piper) was **archived October 2025** — dead before the corpus froze. Successor: OHF-Voice/**piper1-gpl** (v1.4.2, Apr 2026), relicensed MIT→GPL-3.0. **Kokoro TTS** (Apache-2.0) is the rising default. Registry row needs replacement, not just a successor note. |
| A3 | **LiteLLM** as an uncomplicated gateway choice (COMPONENTS.md, ADR-002) | Still maintained and still the right role-filler, but 2026 was severe: a suspected **PyPI supply-chain compromise (March 2026)**, a **pre-auth SQL injection (CVE-2026-42208**, fixed v1.83.7), and an **auth bypass via Host-header injection (CVE-2026-49468**, June 2026). Adoption is now conditional on hardening (§6, ADR-017). Named successor should become **Bifrost** (Go, OpenAI-compatible, smaller attack surface); the "~50-line own proxy" fallback stays. |
| A4 | **Open WebUI** as chat UI (COMPONENTS.md) | No longer OSI open source (custom license + CLA since April 2025). V2 §10 already deferred it; this review recommends **removing it from the plan** — the kernel is the interface (M7), and the license drift confirms the instinct. |
| A5 | "MCP client config formats differ per kernel" is the *only* kernel-swap friction (I10) | Understated. Claude Code has since grown **Auto Memory, background tasks, agent teams, and richer skills/hooks** — the kernel-specific-sugar gravity well is much deeper than when ADR-003 was written. Containment needs an explicit mechanism (ADR-021), not a standing order. |
| A6 | Successor kernel = "Goose or OpenCode," roughly equal (COMPONENTS.md, ADR-003) | No longer equal. **Goose was donated to the same Linux Foundation body that governs MCP** (Dec 2025) — structurally de-risked, MCP-native, model-agnostic including Ollama. OpenCode lost Claude subscription OAuth in January 2026 (a lesson in building on unofficial access). **Goose is now the sole designated successor**; OpenHands remains the sandboxed/headless alternate. |
| A7 | Local models on this hardware are a modest fallback (ADR-005 hardware note) | The open-weight gap narrowed to ~18–24 months. For the 12 GB RTX 4070 Ti: **Qwen3.5-9B** (Apache-2.0, Feb–Mar 2026) dense, **Qwen3.5-35B-A3B** MoE with offload, **Gemma 4** for low VRAM. The offline baseline (Law 6) is now genuinely useful, not a limp-home mode. Model names belong in the living registry, never in ADRs. |
| A8 | Postiz for social (COMPONENTS.md) | Alive and healthy (v2.21.7, Apr 2026) but still effectively Docker-only; V2's demotion to "optional, deferred" stands. |
| A9 | The voice loop has no viable component (red-team I11) | Partially resolved by the ecosystem: **RealtimeSTT** (VAD + streaming faster-whisper, Windows-native), **Kokoro/piper1-gpl** TTS, and LocalAI's OpenAI-Realtime-compatible local pipeline prove the shape. A polished turnkey product still doesn't exist; Phase 4 remains an assembly job, now of named parts (ADR-022). |
| A10 | The gateway abstraction covers all model interaction (ADR-002) | **Realtime voice does not fit it.** Speech-to-speech models (gpt-realtime-2.x, Gemini Live) are stateful WebRTC/WebSocket sessions with per-provider protocols and ~50× price spreads. Voice needs its own thin adapter seam beside the gateway, or Law 2's "one dialect" claim silently breaks in Phase 4 (ADR-022). |

### 3.2 The five load-bearing capability claims in the engines — audited

The corpus's deepest assumptions about what AI can and cannot do, tested against mid-2026:

| Claim | Status | Consequence |
|---|---|---|
| Injection is undetectable in principle; defend structurally (`SECURITY_ENGINE.md` §7.2) | **Still true.** Adaptive attacks beat every detector in 2026 evaluations. | READER/ACTOR stays load-bearing. One refinement available: the literature's **code-then-execute** pattern (agent emits an explicit checkable plan/program; unprivileged readers process untrusted text) is a strict upgrade the kernel increasingly supports. |
| Models are memoryless between invocations (`CONTEXT_ENGINE.md` §1) | **Now false in the letter, true in the spirit.** Kernels and consumer assistants ship native persistent memory. But provider memory is a silo; the architecture's answer (externalize to neutral files; context is a cache over memory) is *more* correct now, and needs one new rule: kernel-native memory is itself a cache (ADR-021). |
| Self-verification cannot beat correlated error; producer ≠ verifier (`AI_ORCHESTRATION_ENGINE.md` §8) | **Still standard doctrine.** Cross-model verification is cheaper than ever given frontier convergence. No change. |
| Vision is a separate capability gate (`AI_ORCHESTRATION_ENGINE.md` §4.1) | **Mostly stale at the frontier** (all frontier models are multimodal), still true for the local tier. Harmless: capability-profile routing already handles it. No action. |
| Context is hard-bounded and degrades as it fills (`CONTEXT_ENGINE.md` §1.8) | **Still true.** Windows grew (1M tokens at the frontier) but attention-quality degradation persists; long-horizon agentic endurance became a *model marketing axis* (Fable-class), which proves the constraint, not its absence. Compression discipline stays. |

Net: the methodology survives its first ecosystem audit essentially intact. The engines' self-installed reopen-triggers (e.g. `DECISION_ENGINE.md` §T3/T4 triggers) are the right mechanism; this review exercises them for the first time.

---

## 4. Missing components

Beyond the red-team's still-valid list (SECURITY.md, PRIVACY.md, GLOSSARY, OPERATIONS.md, ACCESS-PREREQS, VERSIONS.md, kernel instructions file, INCIDENTS.md, COSTS.md — all still missing, all still required), this review finds four new gaps:

1. **The skills library is 90% phantom.** `skills\README.md` indexes **115 skills across 13 files; only file 01 (S-001…012) exists.** S-013…S-115 are cited by ID across the corpus (ADR discipline, jobs, other skills) and dangle. Since the extraction phase is closed, these can never be "extracted" — they must be **authored as post-freeze implementation artifacts** at the indexed paths, frontmatter-marked (`provenance: post-freeze, 2026`), keeping the S-### IDs so citations resolve (ADR-023). Priority order: file 10 (AI orchestration — kernel instructions and job authoring live there), 07 (security), 05 (testing), then the rest as their phases arrive.
2. **MCP/skill supply-chain policy.** The corpus defends *outbound* actions (Outbox) and *inbound content* (trust tiers) but not **inbound code**: the MCP servers and skills themselves. 2026 delivered the warning shots — over a thousand malicious skills found in one marketplace, hundreds of MCP servers exposed with zero auth, and the LiteLLM PyPI incident. OWASP now ranks agentic supply chain as a top-10 category. Needed: a vetting-and-pinning standard (ADR-018) — only version-pinned, hash-verified servers; official-registry signing/trust scores once GA; no auto-update; injection canaries re-run after any server update.
3. **Voice session adapter** (resolves I11 with named parts, ADR-022): a thin swappable layer — VAD/STT/TTS stages locally (RealtimeSTT + Kokoro/piper1-gpl), optionally a cloud realtime session adapter — explicitly *outside* the gateway, with audio-derived text entering through the READER context like any T3 content.
4. **A fixed Phase 0 script.** The frozen `install\phase-0.ps1` still contains both C6 defects (two-pass git dance, no `user.name`/`user.email` configuration) and the frozen `.gitignore` still carries M1. These are operational artifacts; new superseding versions (e.g. `install\phase-0b.ps1`) must ship — and per V2, **no install script ships unexecuted** (fresh-VM test).

---

## 5. Opportunities created by new AI capabilities

1. **Windows 11 Agent Workspace as the ACTOR sandbox.** The OS now provides exactly the privilege boundary V2 hand-designed: agents in isolated sessions under distinct non-admin accounts, auditable, off by default. Adopting it (ADR-020) replaces hand-rolled isolation with a substrate primitive — Law 10 in its purest form. Caution: use it as a *sandbox*, don't couple to its APIs; it's a Microsoft preview feature and this system outlives previews. This also converts the Windows 11 migration from a debt (C1) into a capability gain.
2. **MCP Tasks (2025-11-25 spec, extension status in the 2026-07-28 spec)** — durable async requests with polling — maps directly onto JarvisOS's scheduled/long-running job model and can replace bespoke job-status plumbing.
3. **MCP Apps as the Outbox UI candidate.** The 2026-07-28 spec's server-rendered sandboxed UIs mean the Outbox could ship as *one MCP server with its own approval UI* — kernel-portable, no separate web app to maintain. Evaluate in Phase 2; fall back to the morning-brief-reads-the-queue design if immature.
4. **Kernel Auto Memory interop.** Claude Code's native memory is Markdown + MEMORY.md — the same shape as `memory\`. Configured correctly (kernel memory directory pointed into or mirrored from `D:\Fable OS\memory\`), the kernel's habit works *for* the canonical store instead of forking it (ADR-021).
5. **Long-horizon models (Fable-class) for Phase 7.** Days-long autonomous agentic endurance is now a first-class model axis. Multi-day projects need lighter checkpointing than the corpus assumed — though the checkpoint discipline stays, because model availability doesn't (see the June suspension).
6. **A genuinely useful offline tier.** Qwen3.5-class local models on this GPU make Law 6's offline baseline real for drafting, summarization, memory search, and voice — not merely a dignity-preserving fallback.
7. **Code-then-execute** as the eventual upgrade path for READER/ACTOR (§3.2) — same trust math, more capability per approval.

One strategic note, not a component: **the moat moved.** Claude Cowork (Jan–Jul 2026) productizes the harness for exactly this operator profile, and Windows is becoming an agentic OS. The execution layer is being commoditized from both sides. What no vendor product provides — and where the 10-year investment concentrates — is the **sovereign memory corpus, the decisions ledger, the approval policy, and provider portability**. The architecture already put its weight there; the ecosystem just confirmed the bet. Commoditized kernels make ADR-003 *stronger*, not weaker.

---

## 6. Implementation risks

| # | Risk | Mitigation |
|---|---|---|
| R1 | **LiteLLM is now a security-critical dependency with a 2026 rap sheet.** Localhost-only is not a full answer (browser SSRF/DNS-rebinding reaches localhost; the Host-header CVE is exactly that class). | ADR-017: pin the recommended stable (≥ v1.83.10), verify package hashes (post-supply-chain-incident, non-negotiable), master key on, bind 127.0.0.1, advisory check added to the quarterly checkup. Name Bifrost as successor and keep the swap rehearsable. |
| R2 | **MCP spec transition lands 2026-07-28** (~2.5 weeks out): stateless core, sessions/initialize removed, sampling and logging deprecated with a 12-month clock. | Good timing, if respected: Phases 0–1 touch no MCP. ADR-019: Phase 2 targets the 2026-07-28 spec, stdio transport for local servers, zero dependence on deprecated sampling/logging, spec version pinned in `config\mcp.json`. |
| R3 | **Kernel-sugar gravity** (A5): Auto Memory, skills, hooks, background tasks make Claude Code stickier every quarter; ADR-003's containment erodes silently. | ADR-021 (kernel memory = cache) + V2's weekly Goose parity job, which is the *enforcement mechanism* for containment — it fails loudly the week sugar becomes dependency. |
| R4 | **Complexity creep vs Priority 3 (simplicity).** V2 added guards; this review adds policies. The operator is still one non-programmer. | Rule for every addition: it must be a file, a config entry, or a scheduled job — never a resident service (Law 10). Everything recommended here passes that test. The phase scripts, not the operator, carry the setup burden. |
| R5 | **Approval fatigue** (V2 §13 residual, now with OWASP's "human–agent trust" category behind it). Over-gating trains reflexive approval — the failure mode that defeats the Outbox. | Outbox batching + blast-radius-proportional gating from day one; measure approvals/day in the weekly status; treat >10/day as an incident. |
| R6 | **Supply chain of the plug layer** (§4.2). Every MCP server is third-party code running with real capabilities. | ADR-018. Note the Outbox does not cover this — it gates what agents *send out*, not what code *comes in*. |
| R7 | **Freeze-governance ambiguity** (§2) — the highest-probability failure: the first working session either breaks the freeze or breaks Law 8, and precedent hardens. | ADR-016, ratified before any other work. |
| R8 | **The substrate gate is still open.** This machine remains on EOL Windows 10 N; every week of Phase work before migration builds on a foundation already condemned by the red team. | Windows 11 migration stays the Phase 0 exit gate; nothing past Phase 0 starts before it. |

---

## 7. Recommendations — proposed ADRs

**First act (governance):** ratify **ADR-016**, then ratify V2's **ADR-009…015 verbatim as drafted in ARCHITECTURE-V2 §12** (they survived this review unamended — one note: ADR-014's component names update via COMPONENTS.md rows, not ADR text). Then the new decisions from this review:

| ADR | Title | Substance |
|---|---|---|
| **ADR-016** | Corpus freeze & living-document boundary | Methodology corpus frozen; operational registries (DECISIONS/COMPONENTS/ROADMAP/MAINTENANCE) live under their own contracts; new ADRs one-file-each in `decisions\`; DECISIONS.md byte-frozen at ADR-008 with a pointer added only by this ADR's ratification. |
| **ADR-017** | Gateway hardening & succession | LiteLLM retained under: version pin + hash verification + master key + 127.0.0.1 binding + advisory check in quarterly checkup. Bifrost replaces OpenRouter as named successor. Reaffirms the ~50-line own-proxy floor. |
| **ADR-018** | MCP & skill supply-chain policy | Only version-pinned, hash- or signature-verified MCP servers; official-registry trust scores when GA; no auto-update of servers or skills; injection canary suite re-runs after any server/skill update (extends ADR-013's canary trigger from "model/kernel change" to "any trust-boundary code change"). |
| **ADR-019** | MCP spec versioning | Phase 2 targets spec 2026-07-28; stdio for local servers; no dependence on deprecated sampling/logging; spec version recorded in `config\mcp.json` and checked by config lint. |
| **ADR-020** | ACTOR sandbox on the substrate | The ACTOR context (ADR-009) runs under Windows 11 Agent Workspace / a dedicated non-admin account. Amends ADR-009's mechanism, not its structure; Agent Workspace treated as a sandbox primitive, never an API dependency. |
| **ADR-021** | Kernel-native memory is a cache | Canonical memory lives only in `D:\Fable OS\memory\` (+ quarantine per ADR-013). Kernel memory features are configured to point at, or be mirrored same-session into, the canonical store. Extends ADR-003 containment; the weekly parity job is its test. |
| **ADR-022** | Voice is a session-adapter seam | Voice does not route through the chat gateway. A thin adapter layer holds swappable VAD/STT/TTS stages (locally: RealtimeSTT + faster-whisper + Kokoro or piper1-gpl) and optionally a cloud realtime session adapter. All audio-derived text enters as T3 through the READER context. Resolves I11; documents the gateway-abstraction exception honestly. |
| **ADR-023** | Skills library completion | S-013…S-115 authored as post-freeze artifacts at the paths the frozen index declares, frontmatter provenance-marked, IDs preserved. Authoring order follows phase need (10, 07, 05 first). |
| **ADR-024** | Availability-failover routing | Every task route in `models.yaml` carries a three-tier chain: primary frontier → alternate-provider frontier → local. Rationale on the record: the June 2026 Fable 5 suspension. (Makes explicit what ADR-002/005 implied; model *names* live only in the living registry.) |

**Component-registry corrections** (COMPONENTS.md row updates under ADR-016, no ADR needed): Piper → piper1-gpl/Kokoro (A2); Open WebUI removed (A4); Goose sole successor kernel, OpenHands alternate (A6); local-model examples refreshed (A7); LiteLLM row annotated per ADR-017; llama.cpp `llama-server` noted as Ollama's drop-in successor.

**New documents required** (unchanged from the red team, plus): SECURITY.md now maps explicitly to the OWASP Agentic Top 10 2026 — the checklist is external and peer-reviewed; a non-programmer's system should borrow it rather than maintain a private taxonomy.

---

## 8. Gate conditions — Phase 0 may begin when

1. **ADR-016 ratified** (freeze boundary resolved) — everything else depends on where decisions may be written.
2. **ADR-009…015 ratified** as files in `decisions\` — V2 stops being a proposal.
3. **ADR-017…024 dispositioned** (accept/amend/reject each — rejection with reasons is a fine outcome; silence is not).
4. **`install\phase-0b.ps1` written and executed on a fresh VM** — C6 closed the only way it can be: by running it. (Machine evidence today: `D:\Fable OS` is still not a git repository; the founding commit has never been made. Clean slate — nothing to migrate.)
5. **Windows 11 migration scheduled** as the Phase 0 exit gate it already is (C1/R8) — and now also the prerequisite for ADR-020's sandbox.
6. **VERSIONS.md started** with the first pins (LiteLLM ≥1.83.10-stable, restic 0.19.1, uv 0.11.x, gitleaks 8.30.1, MCP spec 2026-07-28) — I2 closed at birth rather than retrofitted.

Nothing in this review reopens the layer model, the seams, the laws, or V2's mechanisms. The design is finished. What remains is the discipline the corpus itself prescribes: ratify decisions before acting on them, pin what you install, test what you ship, and let the frozen documents stay exactly what they now are — the reason the system knows why it is shaped this way.

---

*Research basis: three independent verification sweeps conducted 2026-07-10 (corpus assumption audit; component health check against primary release/advisory sources; ecosystem survey against Linux Foundation, OWASP, Microsoft, Anthropic, OpenAI, and modelcontextprotocol.io publications). Where sources were secondary or unverifiable (specific benchmark figures, some pricing), they were excluded from load-bearing recommendations.*
