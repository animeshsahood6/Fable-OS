# Phase 2 — Model Gateway Evaluation (ADR-027)

**Date:** 2026-07-11 · **Decision:** select the L2 model-gateway software.
**Method:** live web verification (mid-2026) against the frozen role contract (ARCHITECTURE.md §2) plus Law 6, ADR-006/014 (native Windows, no Docker), ADR-017 (controls), ADR-024 (failover). Decision order fixed by ADR-027: **Bifrost preferred if it passes the role contract → else LiteLLM under ADR-017 controls → else a clearly-superior alternative.**

## Role-contract verdict (both candidates)

| # | Criterion (mandatory 1–7; 8 ideal) | Bifrost | LiteLLM |
|---|---|---|---|
| 1 | OpenAI `/v1/chat/completions` on localhost | Pass | Pass |
| 2 | Routing + fallback in one config file | Pass (`config.json`) | Pass (`config.yaml`) |
| 3 | Keys from secrets/env | Pass | Pass |
| 4 | Native Windows, no Docker/WSL | Pass (`npx @maximhq/bifrost` = precompiled Go binary via Node; Node v24 already present) | Pass (`uv`/pip; uv already present) |
| 5 | Local Ollama + offline | Pass | Pass |
| 6 | Automatic fallback chains | Pass | Pass |
| 7 | Localhost bind + master-key/auth | Pass (virtual keys; bind via `-host`) | Pass (`master_key` + bind) |
| 8 | *(ideal)* budgets **and** Ollama `think` passthrough | Partial — budgets Pass; `think` reachable via extra-params passthrough, **not** first-class (empirical test required) | Pass — first-class `reasoning_effort`→Ollama `think` mapping |

## Decisive factors for THIS deployment (Windows, single non-programmer operator, local-first, 10-year horizon)

- **Security posture — the deciding axis.** LiteLLM's 2026 record is heavy: ~16 CVEs incl. criticals, an unauth-RCE-class MCP bug, a CISA-KEV entry (June 2026), and a **PyPI supply-chain compromise (March 2026)** on the exact `pip`/`uv` path this operator would use. Running it safely demands disciplined pinning + ongoing patching — real burden for a non-programmer. Bifrost (Apache-2.0 Go binary) surfaced **no advisories**; far smaller attack surface and patch treadmill.
- **Substrate cost — neutralized.** Bifrost's earlier presumed downside (a new runtime) is moot: **Node.js v24 is already installed**, so `npx @maximhq/bifrost` adds nothing new. Both candidates run on runtimes already on the machine.
- **Footprint.** Bifrost: small Go binary, negligible overhead. LiteLLM: Python process, heavier.
- **The one Bifrost caveat:** per-request `think` passthrough to Ollama is *available* (extra-params body + `x-bf-passthrough-extra-params`) but not a documented first-class mapping. **Must be smoke-tested** before cutover, because the router's thinking-policy (T3B) depends on it.

## Decision

**Bifrost** — it passes the mandatory role contract, its security/footprint advantage is decisive for a non-programmer's 10-year system, and its substrate cost is zero (Node already present). This executes ADR-027's fixed ordering (Bifrost-first-if-passes).

**Conditional gate (ADR-027 fallback branch):** if the `think`-passthrough smoke test fails or is unreliable, fall back to **LiteLLM latest 1.91.x** under ADR-017 controls (pin, hash-verify, `master_key`, 127.0.0.1 bind, quarterly advisory check) — its first-class `reasoning_effort`→`think` mapping is the one place it is cleaner.

**Rollout discipline (MAINTENANCE §2):** install Bifrost *alongside* the working direct-Ollama path (Bifrost on `localhost:4000` per ADR-002; JARVIS keeps using Ollama `11434` until proven), validate against the role contract + `think` passthrough, then cut the seam over and re-run `tests\phase-1.ps1`. Formalized in ADR-030.

*Full research (sources, per-attribute findings) captured in the 2026-07-11 session record.*
