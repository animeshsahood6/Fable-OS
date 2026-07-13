# Decisions Ledger — `decisions\`

The append-only ADR ledger, continued from [DECISIONS.md](../DECISIONS.md) (ADR-001…008, byte-frozen per ADR-016). One file per ADR, numbered continuously. Never edit an accepted ADR — supersede it with a new one. Format follows DECISIONS.md, extended with **Alternatives considered** and **Future review criteria** (mandatory from ADR-009 onward).

| ADR | Title | Status | Origin |
|---|---|---|---|
| [001–008](../DECISIONS.md) | Founding decisions (MCP, gateway, kernel, files-first, offline, substrate, email/calendar standards, multi-agent) | Accepted 2026-07-09 | Founding set |
| [ADR-009](ADR-009.md) | Kernel splits into READER and ACTOR trust contexts | Accepted 2026-07-10 | ARCHITECTURE-V2 §12 |
| [ADR-010](ADR-010.md) | Kernel routes through the gateway; weekly successor parity | Accepted 2026-07-10 | ARCHITECTURE-V2 §12 (revokes ADR-002's kernel exception) |
| [ADR-011](ADR-011.md) | Privacy partition: four repos; personal data never leaves unencrypted | Accepted 2026-07-10 | ARCHITECTURE-V2 §12 |
| [ADR-012](ADR-012.md) | The Outbox: draft → approve → execute | Accepted 2026-07-10 | ARCHITECTURE-V2 §12 |
| [ADR-013](ADR-013.md) | Trust tiers, egress allowlist, memory quarantine | Accepted 2026-07-10 | ARCHITECTURE-V2 §12 |
| [ADR-014](ADR-014.md) | Windows 11 + uv-managed Python substrate (amends ADR-006) | Accepted 2026-07-10 | ARCHITECTURE-V2 §12 |
| [ADR-015](ADR-015.md) | Graphify as enhancing recall tier over the FTS baseline | Accepted 2026-07-10 | ARCHITECTURE-V2 §12 |
| [ADR-016](ADR-016.md) | Corpus freeze and the living-document boundary | Accepted 2026-07-10 | [2026-07-10 review](../reviews/2026-07-10-architecture-review.md) §2 |
| [ADR-017](ADR-017.md) | Gateway hardening; Bifrost named successor | Accepted 2026-07-10 | 2026-07-10 review §3.1/§6 |
| [ADR-018](ADR-018.md) | MCP & skill supply-chain policy | Accepted 2026-07-10 | 2026-07-10 review §4.2 |
| [ADR-019](ADR-019.md) | MCP spec versioning (2026-07-28 target; stdio; no deprecated features) | Accepted 2026-07-10 | 2026-07-10 review §6 |
| [ADR-020](ADR-020.md) | ACTOR runs in an OS-level sandbox (Agent Workspace / non-admin account) | Accepted 2026-07-10 | 2026-07-10 review §5.1 |
| [ADR-021](ADR-021.md) | Kernel-native memory is a cache; canonical memory in `memory\` | Accepted 2026-07-10 | 2026-07-10 review §5.4 |
| [ADR-022](ADR-022.md) | Voice is a session-adapter seam beside the gateway | Accepted 2026-07-10 | 2026-07-10 review §4.3 (resolves I11) |
| [ADR-023](ADR-023.md) | Skills library completion as post-freeze artifacts | Accepted 2026-07-10 | 2026-07-10 review §4.1 |
| [ADR-024](ADR-024.md) | Availability-failover routing: three-tier chains per route | Accepted 2026-07-10 | 2026-07-10 review §5.5 |
| [ADR-025](ADR-025.md) | Physical repository mapping (implements ADR-011 on disk) | Accepted 2026-07-11 | Phase 0 T2 |
| [ADR-026](ADR-026.md) | Distributed console architecture (Brain + stateless consoles + tailnet) | Accepted 2026-07-11 | Operator directive 2026-07-11 · Phase 0 T2 |
| [ADR-027](ADR-027.md) | Gateway strategy: seam Day 1, software Phase 2 (supersedes-in-part ADR-017) | Accepted 2026-07-11 | Operator directive 2026-07-11 · Phase 0 T2 |
| [ADR-028](ADR-028.md) | ADR-014 timing revised: Windows 11 deferred with hard ceiling (2026-10-01 / pre-Phase 6) | Accepted 2026-07-11 | Operator directive 2026-07-11 · Phase 0 T6 |
| [ADR-029](ADR-029.md) | The JARVIS Runtime: identity and host-independence contract (final pre-Phase-1 decision; architecture frozen) | Accepted 2026-07-11 | Operator directive 2026-07-11 |
| [ADR-030](ADR-030.md) | Model gateway = LiteLLM (ADR-027 fallback branch; Bifrost failed the thinking-control gate) under ADR-017 controls; Bifrost = named successor | Accepted 2026-07-12 | Phase 2 gateway evaluation |
| [ADR-031](ADR-031.md) | Glass Overlay: always-on-top HUD as a replaceable L5 adapter (tkinter+ctypes stdlib glue; PySide6 = named successor) | Accepted 2026-07-12 | Priority 2, JARVIS-feel directive |
| [ADR-032](ADR-032.md) | Visual Awareness: on-demand desktop-context probe, never a monitor (6 consent-gated sources; single-glance retention; mss; MCP-wrappable later) | Accepted 2026-07-13 | Priority 3, JARVIS-feel directive |
| [ADR-033](ADR-033.md) | Presence: on-demand probe of honest signals (idle/lock/tailnet-reachability; BLE+webcam scaffolded); consumes ADR-029's reservation by operator directive | Accepted 2026-07-13 | Priority 4, operator resume directive 2026-07-13 |

*(Next entry: ADR-034 — new file in this directory. Never delete, never edit accepted entries.)*
