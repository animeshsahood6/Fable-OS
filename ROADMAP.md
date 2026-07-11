# Roadmap — the operator's build plan

**How to use this file (you, the human):** work top to bottom, one phase at a time. For each phase, open a session with your AI assistant and paste the *hand-off prompt* shown in the box. The AI does the work; you copy, paste, and approve. Never start a phase until the previous phase's **"Done when"** test passes. There is no deadline — a phase a weekend is a fine pace.

**How to use this file (you, the AI):** execute the phase you were handed, obeying [CONSTITUTION.md](CONSTITUTION.md). Verify component choices against [COMPONENTS.md](COMPONENTS.md) and current reality — if a listed project is dead, pick its listed replacement and record an ADR. Update COMPONENTS.md and this file's checkboxes as you go (Law 8). Put every install script you generate in `install\` so it can be rerun after a disaster.

---

## Phase 0 — Foundation ✦ *(current)*

Give the system a versioned home and the basic tools.

- [x] Founding document set written (this repo)
- [ ] Git installed; this folder made a git repository; first commit
- [ ] Directory skeleton created (`config\ memory\ journal\ projects\ vault\ install\`)
- [ ] `.gitignore` covering `config\secrets.env` and caches
- [ ] Hardware survey recorded in `config\hardware.md` (RAM, GPU, disk — determines local model sizes)

> **Hand-off prompt:** "Execute Phase 0 of D:\Fable OS\ROADMAP.md. Run install\phase-0.ps1 with me, record my hardware, and commit."

**Done when:** `git log` shows a founding commit and every directory in the README map exists.

## Phase 1 — Mind

One gateway, cloud + local models behind it, a chat window.

- [x] Ollama installed; general + small + coding models pulled (sized to 12 GB VRAM)
- [~] `config\models.yaml` created with capability routes + local fallback chains — **gateway software (LiteLLM/Bifrost) deferred to Phase 2 per ADR-027** (seam binding from Day 1; software later)
- [~] Cloud API keys — **Task 3A archived** (local-first chosen); Law 9 scaffold ready to activate later
- [x] Open WebUI installed, pointed at the Runtime's single interface (JARVIS)
- [x] Interface + UI start registered as logon tasks (Task Scheduler)

**Done when:** ~~chat with a cloud model~~ → **[COMPLETE 2026-07-11]** chat with JARVIS in the UI, then **unplug the network and still get answers** from the local model. *Offline finale passed on the Tab S7+.* Revised local-first path recorded in [PROJECT_STATUS.md](PROJECT_STATUS.md), ADR-027, and the 2026-07-11 journal.

## Phase 2 — Hands

The agent kernel, wired to files, terminal, browser, and GitHub.

- [ ] Agent kernel installed (Claude Code today; check COMPONENTS.md for current choice)
- [ ] `config\mcp.json` created; filesystem + Playwright (browser) + GitHub MCP servers registered
- [ ] Kernel instructed (via its project instructions file) to read `memory\MEMORY.md` at start and journal to `journal\`
- [ ] Successor kernel (Goose/OpenCode) installed once, smoke-tested against the same `config\mcp.json`, then left dormant — this proves ADR-003 while it's cheap

**Done when:** you ask the kernel to research a topic online, write the findings to a file, and push a repo to GitHub — and it does all three.

## Phase 3 — Memory

- [ ] `memory\` tree seeded (operator profile, preferences, standing instructions; one fact per file, indexed in `MEMORY.md`)
- [ ] SQLite FTS + vector index built over `memory\` + `journal\`, embeddings local (ADR-005); rebuild script in `install\`
- [ ] Nightly Task Scheduler job: kernel summarizes the day into `journal\`, updates memory, `git commit`s the system folder
- [ ] Backup: external-drive copy job + (optional) encrypted cloud via restic

**Done when:** you ask "what did we decide last Tuesday?" and get the right answer; and you can delete the index file, run the rebuild script, and search still works.

## Phase 4 — Senses (voice)

- [ ] faster-whisper (STT) + Piper (TTS) installed as MCP servers / helpers
- [ ] Push-to-talk loop: hotkey → transcribe → kernel → spoken reply
- [ ] Morning-brief job from ARCHITECTURE.md §3 created in `config\jobs\` *(requires Phase 6 email/calendar; wire voice-only version now)*

**Done when:** you hold a spoken conversation with the system, offline.

## Phase 5 — Creation

- [ ] ComfyUI installed; one image workflow + one video workflow saved into `config\`
- [ ] Image/video generation exposed to the kernel (MCP server)
- [ ] Documents: Pandoc + LibreOffice headless installed; kernel produces docx/pdf/pptx/xlsx on request
- [ ] Figma MCP connected (design read/write)

**Done when:** one prompt to the kernel yields a designed, illustrated PDF in `projects\`.

## Phase 6 — Communication

- [ ] Email via IMAP/SMTP MCP (ADR-007); send always requires approval (Law 7)
- [ ] Calendar via CalDAV MCP, read + write-with-approval
- [ ] Social media via Postiz; posting always requires approval
- [ ] Morning brief upgraded to full email+calendar+voice version

**Done when:** the 8 a.m. brief speaks your inbox and day to you, and the system drafts (but never sends unapproved) replies.

## Phase 7 — Autonomy

- [ ] Recurring jobs library in `config\jobs\` (weekly project review, memory consolidation, quarterly checkup from MAINTENANCE.md as a scheduled prompt)
- [ ] Multi-agent patterns in use for big tasks (research → build → review), per ADR-008
- [ ] Project management convention live: every `projects\<name>\` has a `PLAN.md` + `TASKS.md` the kernel maintains
- [ ] First full disaster-recovery drill passed (MAINTENANCE.md) — **the system is not "done" until it has died once in rehearsal and come back**

**Done when:** the system runs a multi-day project (research, build, report) with you only approving checkpoints — and the quarterly checkup runs itself.

---

*After Phase 7 there are no more phases; there is only [MAINTENANCE.md](MAINTENANCE.md).*
