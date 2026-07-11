# JarvisOS

A local, provider-agnostic AI Operating System that runs on one Windows machine and is designed to survive for ten years.

JarvisOS is not an app and not a chatbot. It is an **assembly of mature open-source components**, wired together through open standards, that gives its operator a system that can think, plan, research, code, build, design, speak, listen, remember, and act — on the terminal, the browser, email, calendar, documents, GitHub, Figma, social media, and local files.

## Who reads what

| Reader | Start here |
|---|---|
| **The human operator** (non-programmer) | [ROADMAP.md](ROADMAP.md) — copy, paste, approve. That is the whole job. |
| **Any AI agent working on this system** | [CONSTITUTION.md](CONSTITUTION.md) first, then [ARCHITECTURE.md](ARCHITECTURE.md). These are binding. |
| **Someone replacing a broken/dead component** | [COMPONENTS.md](COMPONENTS.md) → the replacement playbook in [MAINTENANCE.md](MAINTENANCE.md). |
| **Someone asking "why was it done this way?"** | [DECISIONS.md](DECISIONS.md). |
| **An AI inheriting the architect's role** | Read in this order: [FABLE.md](FABLE.md) (complete working methodology) → [FABLE-MENTAL-MODELS.md](FABLE-MENTAL-MODELS.md) (the 20 mental models the methodology runs on) → [DECISION_ENGINE.md](DECISION_ENGINE.md) (the executable decision manual). Read all three before making any significant decision about this system. |

## The one-paragraph architecture

Every model (Claude, ChatGPT, Gemini, local models) sits behind **one local gateway** speaking one API dialect, so any model can be swapped by editing one config file. Every capability (browser, email, files, image generation, …) is a separate **MCP server** — an open-standard plug — so any capability can be replaced without touching the rest. The "brain" is an off-the-shelf **agent kernel** (currently Claude Code) that is itself replaceable, because everything that matters — memory, projects, configuration, credentials — lives **outside it, in plain files** under this directory, versioned with git.

## Directory map

```
D:\Fable OS\
├── README.md            ← you are here
├── CONSTITUTION.md      ← the ten laws; binding on all future work
├── ARCHITECTURE.md      ← layers, data flow, directory contract
├── COMPONENTS.md        ← registry: every part, why it was chosen, its replacements
├── DECISIONS.md         ← numbered architecture decision records (append-only)
├── FABLE.md             ← the founding architect's methodology, for successor AIs
├── FABLE-MENTAL-MODELS.md ← the 20 mental models the methodology runs on
├── DECISION_ENGINE.md   ← executable decision manual for successor AIs
├── ROADMAP.md           ← phased build plan for the human operator
├── MAINTENANCE.md       ← quarterly checkup, replacement playbook, disaster recovery
├── install\             ← copy-paste PowerShell scripts, one per roadmap phase
├── config\              ← all system configuration (the only place config may live)
├── memory\              ← long-term memory: plain Markdown + SQLite index
├── projects\            ← everything the system builds
├── journal\             ← daily activity logs written by the system itself
└── vault\               ← pointers to secrets (never the secrets themselves)
```

## Status

**Phase 0 — Founding.** The document set exists; no software is installed yet. Next action for the operator is in [ROADMAP.md](ROADMAP.md), Phase 0.
