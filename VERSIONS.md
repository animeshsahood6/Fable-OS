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
| Tailscale (Brain) | 1.98.8 | winget (installer hash verified by winget) | T6 |
| Ollama | 0.31.2 | winget (installer hash verified by winget) | Phase 1 T1 |
| Local model — general | qwen3.5:9b (Apache-2.0) | ollama pull (sha256-verified by ollama) | Phase 1 T1 |
| Local model — fast | qwen3.5:0.8b (Apache-2.0) | ollama pull (sha256-verified by ollama) | Phase 1 T1 |
| Local model — coding | qwen3-coder:30b (MoE 30B-A3B, Apache-2.0) | ollama pull (sha256-verified by ollama) | Phase 1 T3B |
| UI adapter | open-webui 0.10.2 (uv tool, native — no Docker) | uv tool install | Phase 1 T4 |
| Model gateway | litellm[proxy] 1.91.1 (uv tool, ADR-017 controls) | uv tool install (pinned) | Phase 2 (ADR-030) |
| Voice STT | realtimestt 1.0.2 + faster-whisper 1.2.1 + ctranslate2 4.8.1 (+ torch 2.13.0 CPU for VAD) | uv venv `config\voice\.venv` | Voice (ADR-022) |
| Voice wake word | openwakeword 0.6.0 (pretrained `hey_jarvis`, offline, keyless) | uv pip (voice venv) | Voice (ADR-022) |
| Voice TTS | kokoro-onnx 0.5.0 + onnxruntime 1.27.0 (Kokoro-82M, Apache-2.0) | uv pip + model files under `config\voice\models\` | Voice (ADR-022) |
| Voice audio I/O | sounddevice 0.5.5 + soundfile 0.13.1 | uv pip (voice venv) | Voice (ADR-022) |

## Forward pins & notations (obligations inherited by later phases)

| Phase | Item | Notation |
|---|---|---|
| infra (ADR-028) | Windows 11 | Deferred with hard ceiling 2026-10-01 / pre-Phase 6; record edition + build here at upgrade; ESU patch-pulse checked quarterly |
| 0 (T6) | Tailscale consoles | Record tablet + phone client versions when enrolled (ADR-026); successor: plain WireGuard |
| 1 | ~~Ollama + models~~ | Done — pinned above (Phase 1 T1) |
| 1 | Frontier direct adapter | Record provider + API version; **marked for deletion at Phase 2** (ADR-027) |
| 2 | Gateway | Evaluation order Bifrost → LiteLLM (≥1.83.10 + ADR-017 controls) → superior alternative (ADR-027); pin winner here |
| 2 | MCP spec | Target **2026-07-28**; pin in `config\mcp.json`; no deprecated sampling/logging (ADR-019) |

## Change log

- **2026-07-11** — Baseline recorded at T3. gitleaks 8.30.1 installed (the only new install; git and uv were already present, adopted as-found and pinned).
