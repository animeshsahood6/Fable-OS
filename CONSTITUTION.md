# The JarvisOS Constitution

These ten laws are binding on every agent, human or AI, that ever works on this system. They exist because the founding architect will not. When a future decision conflicts with convenience, the laws win. Amending a law requires a new entry in [DECISIONS.md](DECISIONS.md) explaining why the old law failed.

## Law 1 — Files over databases

All durable state — memory, projects, journals, configuration — lives in **plain files** (Markdown, JSON, YAML, SQLite) inside `D:\Fable OS\`. A Markdown file written today will still open in 2036. Any component may keep a private cache or index, but the cache must be **rebuildable from the files** and its loss must never lose information.

## Law 2 — Standards over products

Integrate through open standards, never through a product's private API when a standard exists: **MCP** for tools, **OpenAI-compatible chat API** for models, **IMAP/SMTP** for email, **CalDAV/ICS** for calendars, **git** for versions, **Markdown** for text. Products die; standards get reimplemented.

## Law 3 — Never build what exists

Before writing any software, search for a mature open-source project that already does it. "Mature" means: active in the last 6 months, meaningful adoption, installable without compiling. Custom code is a last resort and must be under ~200 lines of glue, stored in this repo, and documented.

## Law 4 — Every component names its successor

No component may be adopted until [COMPONENTS.md](COMPONENTS.md) lists at least one viable replacement for it and what the swap would cost. A component with no alternative is a hostage situation; don't enter one.

## Law 5 — State lives outside components

No component may be the sole holder of anything valuable. If any single program were uninstalled tonight, the system must lose only a capability — never memory, projects, credentials, or configuration. This is what makes Law 4 executable.

## Law 6 — Offline is the baseline, cloud is the upgrade

With the network cable cut, the system must still think (local model), read and write files, search its memory, and speak/listen. Cloud models and services are quality upgrades layered on top, never load-bearing walls.

## Law 7 — The human approves; the system explains

The operator is not a programmer. Every action the operator must take arrives as a **copy-paste block plus a plain-English sentence saying what it does and what could go wrong**. Anything destructive (delete, overwrite, send, publish, pay) requires explicit approval every time.

## Law 8 — The system documents itself as it changes

Any change to what is installed, how it is configured, or how components connect must update [COMPONENTS.md](COMPONENTS.md) and, if it reverses or extends a decision, append to [DECISIONS.md](DECISIONS.md) — in the same session as the change. An undocumented change is a future outage.

## Law 9 — One config surface, one secrets rule

All configuration lives under `config\`. Secrets (API keys, passwords) live **only** in Windows Credential Manager or `config\secrets.env` — a file that is git-ignored, listed by name in `vault\`, and never quoted in any document, journal, or chat log.

## Law 10 — Minimize future maintenance, not present effort

Prefer the boring choice: the built-in Windows scheduler over a daemon, a file over a service, a script over an app, one dependency over three. Every clever moving part added today is a 3 a.m. failure in 2029 with nobody who remembers why it exists.
