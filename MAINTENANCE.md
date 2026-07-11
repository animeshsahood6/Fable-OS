# Maintenance & Survival Manual

The architecture's job was to make maintenance boring. This file is everything needed to keep the system alive for ten years, written so that a future AI can execute it and the operator only approves.

## 1. The quarterly checkup

Every ~3 months (Phase 7 schedules this as an automatic job; before that, the operator pastes this section into a session):

1. **Pulse check** — for each row in [COMPONENTS.md](COMPONENTS.md): is the project still maintained (release or commit within ~6 months)? If not, mark the row ⚠ and check that its listed replacement is still alive. Two dead entries in one row = swap now, while nothing is broken.
2. **Update pass** — update components via winget/official channels, one at a time, testing the relevant "Done when" from [ROADMAP.md](ROADMAP.md) after each. Never update everything at once.
3. **Backup verify** — restore one random file from the external-drive backup. A backup that has never been restored is a hope, not a backup.
4. **Model review** — are the routes in `config\models.yaml` still the right models for cost/quality? New frontier or local models appear constantly; swapping is a YAML edit (ADR-002).
5. **Write it down** — journal entry + git commit: what was updated, what was flagged, what was swapped (Law 8).

## 2. Component replacement playbook

When any component dies or is outgrown:

1. Read its row in COMPONENTS.md → candidate successor.
2. Verify the successor currently satisfies the role's **contract** in [ARCHITECTURE.md](ARCHITECTURE.md) §2 (not its 2026 reputation — its present reality).
3. Install the successor **alongside** the incumbent. Point a test config at it. Run the relevant roadmap "Done when" test.
4. Flip the real config (`mcp.json` / `models.yaml` / Task Scheduler task). Keep the incumbent installed for two weeks, then remove it.
5. Update COMPONENTS.md; append an ADR if the swap changes any assumption; commit.

Because of Laws 1/5, step 4 never involves migrating data. If a replacement *would* require data migration, that is the alarm that a law has been violated — fix the state location first.

### 2a. Kernel swap (the big one, ADR-003)

The kernel holds no exclusive state, so a swap is: install successor → point it at `config\mcp.json` and the gateway → give it a project-instructions file saying *"Read `memory\MEMORY.md` at session start; journal actions to `journal\`; obey `CONSTITUTION.md`"* → run the Phase 2 "Done when" test. Anything that only worked because of kernel-specific sugar (skills, hooks) gets re-created in the new kernel's dialect or dropped. Rehearsed once in Phase 2 precisely so it is never a first-time event during an emergency.

## 3. Disaster recovery

**Scenario: the machine is lost.** On any Windows machine:

1. Install git (winget). Clone/copy `D:\Fable OS\` from GitHub + external drive.
2. Run the scripts in `install\` in numeric order (each is idempotent and re-runnable).
3. Re-enter secrets from the password manager, guided by the inventory in `vault\`.
4. Run each phase's "Done when" test from ROADMAP.md, in order.

Expected time: an afternoon. **Drill this once at Phase 7 and after any major change.** The drill, not the plan, is what makes recovery real.

**Scenario: a bad update breaks something.** `git log` the config repo → `git revert` the config change → reinstall the previous component version. This is why every change commits (Law 8).

## 4. Failure-mode ledger

| If this dies… | The system loses… | And recovers by… |
|---|---|---|
| Internet / all cloud providers | Frontier quality | Local fallback routes (ADR-005) — automatic |
| LiteLLM (project abandoned) | Model routing | Any OpenAI-compatible proxy; same YAML idea, one afternoon |
| Claude Code / current kernel | The best hands | Kernel swap playbook §2a |
| MCP (standard superseded) | The plug format | Re-wrap tools in the new standard; tools and data untouched (ADR-001) |
| Figma / any SaaS capability | That capability | Listed open-source successor; core system unaffected |
| Anthropic / OpenAI / Google (any one) | One provider | Delete its routes; others + local remain |
| The operator's memory of how this works | Nothing | Every procedure is in these seven files; hand them to any AI |

## 5. Standing orders to future agents

- Re-verify before you install: this repo's recommendations age; the **laws** do not.
- When in doubt, choose the option that is easier to abandon.
- Never let a convenience become a dependency: if you use a kernel-specific feature, mirror the content into neutral files the same day.
- The operator is not a programmer. Every instruction you give them: one copy-paste block, one plain sentence of what it does, one sentence of what could go wrong.
- Leave the campsite documented: COMPONENTS.md and DECISIONS.md current, journal written, git committed — *in the same session as the change*.
