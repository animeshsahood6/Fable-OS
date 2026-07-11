# Architecture Decision Records

Append-only. Never edit or delete an entry — supersede it with a new one. Format: context → decision → consequences. Date everything.

---

## ADR-001 — MCP is the integration standard for all capabilities
**2026-07-09 · Accepted**

**Context.** The system needs ~15 capabilities (browser, email, image gen, …) that must each be independently replaceable, and must work with any present or future agent kernel.

**Decision.** Every capability is packaged as a Model Context Protocol (MCP) server, registered in `config\mcp.json`. MCP is an open standard adopted across the industry (Anthropic, OpenAI, Google, Microsoft tooling), with thousands of existing servers.

**Consequences.** Capabilities become plug-shaped: adding/removing one is a config edit. Risk: MCP could be superseded within 10 years. Mitigation: MCP servers are thin wrappers around underlying tools (Playwright, IMAP, ComfyUI…); if the plug standard changes, only the wrappers are re-generated — the tools and all data survive.

---

## ADR-002 — One local model gateway; no component ever talks to a provider directly
**2026-07-09 · Accepted**

**Context.** Models must be swappable (Claude/GPT/Gemini/local/future) and the system must run offline.

**Decision.** LiteLLM runs as a local proxy at `localhost:4000/v1`. All components speak the OpenAI-compatible dialect to that one endpoint. `config\models.yaml` defines named routes by *task* (`reasoning`, `fast`, `embedding`, `offline`) rather than by model, plus fallback chains ending in a local Ollama model.

**Consequences.** A new model in 2029 is a two-line YAML edit. The gateway is a single point of failure — accepted because it's stateless, restartable, and replaceable by any OpenAI-compatible proxy (Law 4). Exception: the agent kernel may natively use its own provider *in addition*, provided losing that provider only degrades quality, not function (Law 6).

---

## ADR-003 — The agent kernel is a commodity, chosen for capability, designed for replacement
**2026-07-09 · Accepted**

**Context.** Agentic harnesses are the fastest-churning part of the ecosystem. Betting the system's survival on any one of them violates the 10-year horizon; refusing the best one available wastes capability today.

**Decision.** Use the most capable MCP-native harness at any given time (today: Claude Code) **under a strict containment rule**: the kernel may hold no exclusive state. Memory, jobs, project files, MCP registry, and model routing all live in `D:\Fable OS\` in kernel-neutral formats. A kernel-swap playbook is maintained in MAINTENANCE.md and the designated successor (currently Goose or OpenCode) is sanity-checked at each quarterly checkup.

**Consequences.** We get frontier capability without lock-in. Cost: some kernel-specific conveniences (skills, hooks) must be treated as disposable sugar, and any content put into them must also exist in neutral files.

---

## ADR-004 — Files first: Markdown + SQLite are the only durable formats
**2026-07-09 · Accepted**

**Context.** Ten-year survival with a non-programmer operator rules out anything that requires a running service or a schema migration to read one's own data.

**Decision.** All durable state is Markdown (human/AI-readable text), YAML/JSON (config), or SQLite (single-file indexes, always rebuildable from the text). Backup is folder copy; restore is folder copy.

**Consequences.** Some elegance is lost (no fancy memory graph database). Gained: every model ever made can read the system's entire memory, and the operator can too.

---

## ADR-005 — Offline baseline via Ollama
**2026-07-09 · Accepted**

**Context.** Law 6 requires the system to think with the network cut.

**Decision.** Ollama serves a general local model and a small fast model; every routing chain in `models.yaml` ends in a local fallback; embeddings for the memory index are local-only so memory search never depends on the cloud.

**Consequences.** Quality degrades gracefully offline instead of failing. Hardware note (2026): a usable local model wants ≥16 GB RAM; a good one wants a GPU. The roadmap sizes model choices to the actual machine at install time.

---

## ADR-006 — Windows-native substrate; no Docker, no WSL, until forced
**2026-07-09 · Accepted**

**Context.** The operator is a non-programmer on Windows. Container stacks and WSL add a second operating system's worth of maintenance.

**Decision.** Everything installs natively via winget or official Windows installers. Scheduling uses Task Scheduler. Secrets use Credential Manager. If a future component truly requires Linux, that need must be recorded here as a superseding ADR before WSL is introduced.

**Consequences.** A few Linux-first projects are off the menu; acceptable, since every role in COMPONENTS.md has a Windows-native filler.

---

## ADR-007 — Standards-based email/calendar (IMAP/SMTP/CalDAV), never provider-exclusive
**2026-07-09 · Accepted**

**Context.** Email and calendar integrations are where systems quietly get locked to one vendor.

**Decision.** The load-bearing integrations speak IMAP/SMTP and CalDAV/ICS. Provider-specific MCPs (Gmail, Outlook) may be added for convenience but nothing may depend on them exclusively.

**Consequences.** Works with any mail host, forever. Cost: OAuth setup for the big providers' IMAP access is fiddlier than their native APIs — paid once, at setup.

---

## ADR-008 — Multi-agent = kernel orchestration over shared files, not an agent framework
**2026-07-09 · Accepted**

**Context.** Multi-agent frameworks (message buses, agent registries) are heavy, young, and churn fast.

**Decision.** Sub-agents are spawned by the kernel; they coordinate through the file system (shared memory tree, project files, journals). No standing agent infrastructure.

**Consequences.** Zero extra services to maintain (Law 10). If a future kernel has weaker orchestration, the pattern degrades to sequential runs over the same files — slower, never broken.

---

*(Next entry: ADR-009. Append below. Never delete.)*
