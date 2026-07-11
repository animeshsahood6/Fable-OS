# JarvisOS Architecture

This document defines the layer model, the data flow, and the directory contract. It describes **roles**, not products. Products fill roles and are listed in [COMPONENTS.md](COMPONENTS.md); any product can be replaced without changing this document.

## 1. Layer model

```
┌─────────────────────────────────────────────────────────────────┐
│  L5  INTERFACES         chat UI · voice loop · scheduled jobs    │
│                         (how the human reaches the system)      │
├─────────────────────────────────────────────────────────────────┤
│  L4  AGENT KERNEL       one MCP-capable agentic harness that     │
│                         thinks, plans, and calls tools          │
├─────────────────────────────────────────────────────────────────┤
│  L3  CAPABILITIES       independent MCP servers, one per skill: │
│                         files · terminal · browser · github ·   │
│                         email · calendar · docs · figma ·       │
│                         social · image-gen · video-gen · voice  │
├─────────────────────────────────────────────────────────────────┤
│  L2  MODEL GATEWAY      one local endpoint, OpenAI-compatible;  │
│                         routes to any provider by config        │
├─────────────────────────────────────────────────────────────────┤
│  L1  MODELS             Claude · GPT · Gemini · local models ·  │
│                         whatever exists in 2030                 │
├─────────────────────────────────────────────────────────────────┤
│  L0  SUBSTRATE          Windows 10/11 · winget · git ·          │
│                         Task Scheduler · Credential Manager     │
└─────────────────────────────────────────────────────────────────┘
        MEMORY & STATE (cross-cutting): plain files in D:\Fable OS\,
        versioned by git, indexed by SQLite — owned by NO layer.
```

**The two load-bearing seams** (everything else hangs off these):

1. **Model seam** — every component that needs intelligence talks to `http://localhost:4000/v1` (the gateway). No component ever embeds a provider SDK or a hardcoded model name. Swapping Claude for Gemini for a local model is a one-file config edit ([DECISIONS.md](DECISIONS.md) ADR-002).
2. **Tool seam** — every capability is an MCP server declared in `config\mcp.json`. The kernel discovers tools at startup; adding, removing, or replacing a capability is a config edit plus an install/uninstall (ADR-001).

## 2. Roles and their contracts

| Role | Contract (what any product filling it must provide) |
|---|---|
| **Model gateway** | OpenAI-compatible `/v1/chat/completions` on localhost; provider routing and fallback defined in one YAML; API keys read from the secrets store. |
| **Local model runtime** | Serves at least one general model and one small fast model, offline, via the gateway. |
| **Agent kernel** | Speaks MCP; reads its memory instructions from `memory\`; writes activity to `journal\`; holds **zero** exclusive state (Law 5). The kernel is a commodity: the system must survive its replacement (ADR-003). |
| **Capability (MCP server)** | Does one job; configured only via `config\mcp.json` + env vars; stores nothing durable outside `D:\Fable OS\`. |
| **Memory index** | Full-text + vector search over `memory\` and `journal\`; deletable and rebuildable at any time from the files (Law 1). |
| **Scheduler** | Windows Task Scheduler tasks that invoke the kernel headlessly with a prompt file. No custom daemon (Law 10). |
| **Interfaces** | Chat UI and voice loop are thin clients of the gateway/kernel; they render, they do not own state. |

## 3. Data flow — one worked example

*"Every morning at 8, read my email, check my calendar, and brief me by voice."*

1. **Task Scheduler** (L0) fires at 08:00 → runs the **kernel** (L4) headlessly with `config\jobs\morning-brief.md` as the prompt.
2. Kernel calls the **email MCP server** (IMAP) and **calendar MCP server** (CalDAV) — L3.
3. Kernel thinks via the **gateway** (L2), which routes to whatever `config\models.yaml` says "briefing" tasks use — cloud if online, local if not (Law 6).
4. Kernel writes the brief to `journal\2026-07-09-brief.md` (memory & state), then calls the **voice MCP server** to speak it (L3 → L5).
5. Nothing in this flow knows which model ran or which email product served IMAP. Every part is swappable.

## 4. Directory contract

The directory tree in [README.md](README.md) is a **contract**, not a suggestion. Components may be replaced; paths may not drift. Specifically:

- `config\mcp.json` — the single registry of capabilities.
- `config\models.yaml` — the single registry of models and routing rules.
- `config\jobs\` — one Markdown prompt file per scheduled job (the job *is* the file).
- `memory\MEMORY.md` — index of long-term memory; one fact per file beneath it.
- `journal\YYYY-MM-DD*.md` — append-only record of what the system did.
- `projects\<name>\` — each project self-contained, each its own git repo.
- `vault\` — a Markdown list of which secrets exist and where they are held. Never values.

The whole of `D:\Fable OS\` (minus `projects\` and git-ignored secrets) is one git repository. **Backup = copy this folder. Restore = copy it back and rerun `install\`.** That sentence is the disaster-recovery plan (details in [MAINTENANCE.md](MAINTENANCE.md)).

## 5. Multi-agent model

Multi-agent collaboration is an **orchestration pattern inside the kernel**, not extra infrastructure: the kernel spawns sub-agents (researcher, coder, reviewer, designer) that share the same gateway, the same MCP servers, and the same file-based memory. No message bus, no agent framework to maintain (Law 10). If a future kernel lacks sub-agents, the pattern degrades gracefully to sequential runs reading each other's files — because all coordination state is files.

## 6. What this architecture refuses to do

- No always-on custom services. Everything is either an on-demand process or a Task Scheduler job.
- No component-private databases holding original data (caches fine, sources of truth never).
- No direct provider SDKs anywhere but inside the gateway.
- No capability wired point-to-point to another capability; everything meets at the kernel.
- No code where configuration will do; no configuration where a convention will do.
