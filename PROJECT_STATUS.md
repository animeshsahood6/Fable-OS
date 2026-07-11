# PROJECT_STATUS — JarvisOS

**Product:** JARVIS Runtime · **Project:** JarvisOS ([ADR-029](decisions/ADR-029.md) — architecture frozen; implementation only from here)

> The single project status page. Living document (ADR-016 tier: operational registry). Updated in the same session as any status change (Law 8). One glance answers: where are we, what's next, what's in the way.

| Field | Value |
|---|---|
| **Current Phase** | **Phase 0 — COMPLETE** (2026-07-11) |
| **Current Task** | Phase 1 — **machine-side COMPLETE and validated** (`tests\phase-1.ps1` all green); only the operator offline-finale remains |
| **Last Completed** | T1, T2, T3B, T4 (UI adapter), T5 (single JARVIS interface), **T6 confirmed by operator** (JARVIS default on tablet + phone over tailnet), **T7 machine-side** (watchdog every ~3h + `tests\phase-1.ps1`; Arena Model disabled so only JARVIS shows). Three tiers + three logon/periodic scheduled tasks. Doctrine skill live. T3A archived. |
| **Next Task** | **Operator:** the offline finale — chat with JARVIS on the tablet, disconnect the Internet, confirm it keeps answering (structurally already proven; this is the human demonstration). Then Phase 1 closes and Phase 2 (gateway) begins. |
| **Blocked By** | Nothing. |

## Completed Milestones

- **2026-07-09** — Founding corpus written; red-team review; ARCHITECTURE-V2.
- **2026-07-10** — Pre-implementation architecture review (`reviews\2026-07-10-architecture-review.md`); ADR-009…024 ratified; architectural baseline complete.
- **2026-07-11** — Phase 0 T1 complete (verified backup, full readiness report, Win11 eligibility confirmed). T2 complete (ADR-025 repo mapping, ADR-026 distributed consoles, ADR-027 gateway strategy).
- **2026-07-11** — **PHASE 0 COMPLETE**, T1→T6 in one day: three repos founded with proven guards, tooling pinned, ADR-028 ratified, tailnet live across Brain + both consoles, 33/33 validation, verified completion backup.

## Phase 0 task board

| Task | Status |
|---|---|
| T1 — Backup + pre-flight | ✅ 2026-07-11 |
| T2 — ADR-025/026/027 + status page | ✅ 2026-07-11 |
| T3 — Tooling (gitleaks, git identity, VERSIONS.md pins) | ✅ 2026-07-11 |
| T4 — Author + rehearse `install\phase-0b.ps1` + `tests\phase-0.ps1` | ✅ 2026-07-11 (rehearsed on scratch root: full run, idempotent re-run, 33/33 checks, 3/3 guard canaries) |
| T5 — Found the system (skeleton, repos, hooks, commits, survey) | ✅ 2026-07-11 (3 repos founded: docs `9ea7508`, config `ae87c26`, data `fbeac2b`; 33/33 checks; idempotency confirmed; `landing\` relocated to `projects\landing`) |
| T6 — Connect and secure: posture check, ADR-028, tailnet, final validation (**Phase 0 exit**) | ✅ 2026-07-11 (tailnet: Brain 100.68.168.95 · tablet 100.98.100.58 · phone 100.91.162.27; no public exposure; 33/33 + 1 accepted PEND) |

## Known Issues

1. ~~Git identity mismatch~~ — **resolved at T3 (2026-07-11):** operator chose `Animesh Sahoo / animeshsahood6@gmail.com`; configured and verified.
2. **`landing\` project in corpus root** — relocates to `projects\landing\` at T5 (ADR-025 §5).
3. **Windows 11 deferred under [ADR-028](decisions/ADR-028.md)** — hard ceiling: migrate before **2026-10-01** or before any Phase 6 outward capability, whichever first. Compensating controls verified at T6a (2026-07-11): ESU-class security updates arriving through June 2026 (KB5094127 et al.), firewall on all profiles, Defender real-time + current signatures, browsers current (Chrome/Edge 150), no public exposure (tailnet-only, ADR-026). Eligibility already proven at T1. **Accepted risk, on the record.**
4. **No dedicated backup drive** — D: is itself the (likely external) ORICO SSD; baseline lives cross-disk on C:. Acquire one backup drive before Phase 3 (restic offsite is mandatory then, ADR-011).
5. **D: is exFAT** (discovered at T5) — no ownership records or NTFS ACLs. `git safe.directory` exceptions added for `D:/Fable OS` and children (baked into phase-0b.ps1 for DR). Consequence for Phase 2: ADR-020's ACTOR filesystem scoping cannot rely on NTFS ACLs *on D:* — enforce scope via the Agent Workspace / account boundary instead.
6. **RDP listening on all interfaces (port 3389)** — flagged at T6a. Recommendation: once the tailnet is confirmed as the access path, restrict RDP to the tailnet interface or disable it. Operator decision — may be a current access path, so not changed automatically.
7. **"RemoteServerWin" listening on 0.0.0.0:9512** (Remote Mouse–class remote-control helper) — flagged at T6a. If unused, uninstall it; if used, prefer replacing with tailnet access.

## Standing references

- Decisions ledger: [decisions\README.md](decisions/README.md) (ADR-001…008 in frozen [DECISIONS.md](DECISIONS.md))
- Current phase blueprint: session record of 2026-07-11 (revised Phase 0, six tasks) — to be mirrored into `tests\phase-0.ps1` + T4 artifacts
- Architecture review: [reviews\2026-07-10-architecture-review.md](reviews/2026-07-10-architecture-review.md)
