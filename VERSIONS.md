# VERSIONS — Pinned Component Manifest

> Living document (ADR-016 registry tier). **Rule:** every install, upgrade, or removal updates this file in the same session (Law 8 / red-team I2). Disaster recovery installs *these* versions, not "latest." Upgrades are deliberate acts at the quarterly checkup or in response to a security advisory — never automatic (ADR-018).

## Implementation baseline — recorded 2026-07-11 (Phase 0, T3)

| Component | Pinned version | Installed via | Verified |
|---|---|---|---|
| Windows | 10 Pro N, build 19045 (22H2) — **pre-gate**; becomes Windows 11 at T6 (ADR-014) | — | T1 survey |
| PowerShell | 5.1.19041.7417 (ships with OS; scripts target 5.1 semantics) | OS | T1 survey |
| winget | v1.29.280 | OS / Store | T1 survey |
| git | 2.54.0.windows.1 | pre-existing (winget-managed) | T3 |
| uv | 0.11.28 (2026-07-07 build) — pre-1.0: treat upgrades as breaking until proven otherwise (ADR-014) | pre-existing | T3 |
| gitleaks | 8.30.1 | winget (installer hash verified by winget) | T3 |

## Forward pins & notations (obligations inherited by later phases)

| Phase | Item | Notation |
|---|---|---|
| 0 (T6) | Windows 11 | Record edition + build here at upgrade; OS-EOL check is a standing quarterly item (ADR-014) |
| 0 (T6) | Tailscale | Pin client version at install on Brain + both consoles (ADR-026); successor: plain WireGuard |
| 1 | Ollama + models | Pin Ollama version and exact model tags (sized to 12 GB VRAM per T1 survey) at install |
| 1 | Frontier direct adapter | Record provider + API version; **marked for deletion at Phase 2** (ADR-027) |
| 2 | Gateway | Evaluation order Bifrost → LiteLLM (≥1.83.10 + ADR-017 controls) → superior alternative (ADR-027); pin winner here |
| 2 | MCP spec | Target **2026-07-28**; pin in `config\mcp.json`; no deprecated sampling/logging (ADR-019) |

## Change log

- **2026-07-11** — Baseline recorded at T3. gitleaks 8.30.1 installed (the only new install; git and uv were already present, adopted as-found and pinned).
