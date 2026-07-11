# Component Registry

Every product currently filling a role in JarvisOS, why it was chosen, and what replaces it if it dies. **Law 4:** nothing gets adopted without a named successor. **Law 8:** any install, removal, or reconfiguration updates this file in the same session.

Choices reflect the ecosystem as of **mid-2026**. Any future agent should re-verify that a component is still maintained before installing it (see the quarterly checkup in [MAINTENANCE.md](MAINTENANCE.md)) and prefer a living project over a dead recommendation from this file.

## Core (Phases 0–2)

| Role | Chosen | Why | Replacements | Swap cost |
|---|---|---|---|---|
| Package manager | **winget** | Ships with Windows; survives as long as Windows does | Scoop, Chocolatey | Trivial |
| Version control | **git + GitHub** | Universal standard | Any git host (Codeberg, GitLab); git itself has no peer | Trivial |
| Model gateway | **LiteLLM** (proxy mode) — Phase 2, under ADR-017 controls (pin ≥1.91.x, hash-verify, master key, 127.0.0.1) | Chosen 2026-07-12 (ADR-030): passes the role contract AND cleanly maps `reasoning_effort`→Ollama `think` (preserves the router's thinking policy). Bifrost was evaluated first (ADR-027) but failed that thinking-control gate. | **Bifrost** (Apache-2.0 Go binary, smaller attack surface — named successor; revisit if it gains first-class Ollama `think` or if a LiteLLM advisory forces a swap); own ~50-line proxy as last resort | Low — every consumer only knows `localhost:4000/v1` |
| Local model runtime | **Ollama** | One-click Windows install, model pull by name, OpenAI-compatible API | LM Studio, llama.cpp server, vLLM (if GPU-rich) | Low — sits behind the gateway |
| Agent kernel | **Claude Code** (desktop + CLI) | Most capable agentic harness available; MCP-native; sub-agents, scheduling, skills built in | Goose (Block, open-source, MCP-native, any-model), OpenCode, OpenHands | Medium — see kernel-swap playbook in [MAINTENANCE.md](MAINTENANCE.md). By design (Law 5) only habits move, not data |
| Chat UI (casual use) | **Open WebUI** | Mature, local, talks to the gateway, non-programmer friendly | LibreChat, LobeChat | Low — stateless client |
| Terminal execution | kernel built-in | Already sandboxed + permissioned | Windows-MCP PowerShell server | None |
| File access | kernel built-in + **filesystem MCP server** | Standard reference server | Many equivalents | Trivial |

## Memory & state (Phase 3)

| Role | Chosen | Why | Replacements | Swap cost |
|---|---|---|---|---|
| Long-term memory | **Plain Markdown** in `memory\` (one fact per file + `MEMORY.md` index) | Law 1; readable by every model forever | None needed — it's just files | — |
| Search index | **SQLite + FTS5 + sqlite-vec** | Single-file, zero-service, rebuildable | LanceDB, Qdrant (if scale ever demands a service) | Low — index is disposable by contract |
| Embeddings | local model via Ollama (e.g. a nomic/bge-class model) | Offline (Law 6) | Any embedding model via the gateway | Trivial — reindex once |
| Backup | **git** + one external drive + optional encrypted cloud (restic) | Boring and proven | Any file-copy mechanism | Trivial |

## Capabilities (Phases 4–6)

| Role | Chosen | Why | Replacements | Swap cost |
|---|---|---|---|---|
| Browser automation | **Playwright MCP** | Microsoft-maintained, standard | browser-use, Claude-in-Chrome | Low |
| GitHub | **GitHub MCP + gh CLI** | Official on both counts | git + REST via terminal | Low |
| Email | **IMAP/SMTP MCP server** against any mail provider | Standards (Law 2) — never a Gmail-only integration | Provider MCPs (Gmail/Outlook) as convenience only | Low |
| Calendar | **CalDAV MCP server** | Standard (Law 2) | Provider MCPs | Low |
| Documents | **Pandoc + LibreOffice (headless) + office skills** | Convert/produce docx, pdf, pptx, xlsx locally | Cloud office APIs | Low |
| Figma | **Official Figma MCP** | First-party | Penpot (open-source design tool) if Figma access is ever lost | Medium — design files would need export |
| Social media | **Postiz** (open-source scheduler) via its API/MCP | One integration point for many platforms | Per-platform MCP servers | Medium — platform APIs churn; expect this row to change often |
| Image generation | **ComfyUI** | The open-source standard; runs SD/Flux-class models offline; also does video | InvokeAI, Fooocus; cloud APIs via gateway for quality peaks | Low |
| Video generation | **ComfyUI** (Wan/LTX/Hunyuan-class models) | Same install as image gen | Cloud video APIs | Low |
| Speech-to-text | **RealtimeSTT** (wraps faster-whisper + Silero/WebRTC VAD) | Streaming STT + VAD + wake-word gating in one Windows-native component (ADR-022) | whisper.cpp, Vosk (faster-whisper is the engine underneath) | Low |
| Wake word | **openWakeWord** (`hey_jarvis` pretrained) | Free, fully offline, no key (Law 6) | Porcupine (higher quality, needs a Picovoice key) | Low — config edit |
| Text-to-speech | **kokoro-onnx** (Kokoro-82M, Apache-2.0, onnxruntime — no torch) | ADR-022 chose Kokoro over Piper (quality; no torch); streaming synth | piper1-gpl (GPL-3; original Piper archived), XTTS | Low |
| Scheduler | **Windows Task Scheduler** | Ships with the OS (Law 10) | none needed | — |
| Secrets | **Windows Credential Manager** + git-ignored `config\secrets.env` | Ships with the OS | KeePassXC | Low |
| Project management | **Markdown task files** in `projects\` maintained by the kernel | Files first (Law 1) | Vikunja/Focalboard if a UI is ever truly needed | Low |

## Custom glue written for this system

*(Law 3: everything here must stay under ~200 lines and be documented where it lives.)*

| Script | Purpose | Location |
|---|---|---|
| — | none yet | — |
