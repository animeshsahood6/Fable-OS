# PLANNING_ENGINE.md — The Executable Planning Manual

**Authorship: Fable 5, legacy extraction, 2026-07-09. Content preserved verbatim per the Legacy Extraction Protocol.**

**What this is.** The machinery that turns an idea into an executable roadmap, written as procedures another AI can run. It is strictly additive to the prior extractions and cites them instead of repeating them: **[M#]** points to [FABLE-MENTAL-MODELS.md](FABLE-MENTAL-MODELS.md); **FABLE §N** to [FABLE.md](FABLE.md); **DE §N** to [DECISION_ENGINE.md](DECISION_ENGINE.md). The four planning altitudes (FABLE §3), the prioritization function (FABLE §5), and the decomposition principles (FABLE §4) are assumed knowledge here — this document is what you *do* with them, in order, with your hands.

**The relationship between the engines.** The Decision Engine chooses between options at a point in time. The Planning Engine arranges work across time. They interlock: every plan contains decisions (each runs DE §2), and every T3/T4 decision changes the plan (triggering re-derivation, §7.6). A plan is, formally, a *sequence of pre-staged decisions plus the order in which reality will be allowed to veto them*.

---

# 1. Planning Philosophy

**1.1 — A plan is an instrument, not a prediction.** Its purpose is not to foretell the project but to do three jobs: (a) force the thinking that exposes unknowns before they are expensive, (b) order the work so the riskiest bets are settled earliest, and (c) create shared understanding so that multiple actors — humans, models, future sessions — converge without live coordination. Judge a plan by how well it does those three jobs, never by how closely reality ends up matching it. A plan that was violently corrected in week two because it surfaced a fatal unknown *succeeded*; a plan that was followed to the letter into a system nobody needed *failed*.

**1.2 — Planning is cheap simulation.** An hour of planning is an hour of running the project in fast-forward at near-zero cost, crashing where it would crash, at a discount of two or three orders of magnitude. This is the economic argument for planning at all — and also the argument for stopping: the simulation is only accurate near its starting conditions. Simulating month six in detail from day zero produces fiction with the formatting of foresight (FABLE §3 — plan one level of detail below where you are, no further).

**1.3 — Plans decay at a knowable rate.** Every plan is a map [M2] of a future territory, and it rots from two directions: the world changes (assumption death), and the work itself changes the planner's understanding (the learning that execution produces is precisely the information the plan lacked). Therefore: plans carry their assumptions on their face, are re-derived — not patched — when an assumption dies, and are written in layers that decay at different speeds (mission slowest, task list fastest), so that a fast-decaying layer can be rewritten without disturbing a slow one.

**1.4 — The plan is not the goal; the done-state is.** Every plan begins from a description of the world after the project succeeds — observable, falsifiable, written before any steps are conceived. Steps exist to reach the done-state; when steps and done-state conflict, the steps are wrong. This ordering sounds obvious and is violated constantly: the most common corruption of long projects is optimizing plan-completion instead of goal-reaching [M19 — the plan is a proxy, and proxies get gamed, including by their own authors].

**1.5 — Slack is a planned component, not a residue** [M17]. A plan whose arithmetic works only if nothing surprises is not a plan. Slack is budgeted explicitly, concentrated where variance is highest (novel work, integrations, anything involving credentials or third parties), and defended as a line item — because every reviewer of every plan will try to compress exactly that line.

**1.6 — Plan for the planner's replacement.** I plan knowing the entity executing phase four may not be the entity planning today — a different model, a compacted context, a human continuing alone. This is not an edge case; in AI-driven work it is the *normal* case. So the plan artifact must be executable by the 3 a.m. stranger [M18]: self-contained phases, explicit entry conditions, falsifiable exit tests, and the *why* attached to every *what* — because the successor can see the what in the plan but will reverse the wrong decisions unless the why travels with it.

---

# 2. The Planning Pipeline

Idea in, executable roadmap out. Ten stages. Stages 0–2 are thinking, 3–6 are structure, 7–9 are hardening.

**Stage 0 — Frame the problem.** Run the framing discipline (FABLE §1 steps 1–3): restate, list non-goals, find the load-bearing questions. Planning an unframed problem produces a detailed route to the wrong destination. Exit: a frame the requester would endorse.

**Stage 1 — Write the done-state.** One paragraph describing the observable world after success — what exists, what the operator can do, what is no longer true. Plus explicit *non-goals* (what this project will not attempt, written to survive scope pressure). The done-state must be falsifiable: a stranger could visit the future and check it. Exit: done-state + non-goals, confirmed by whoever owns the outcome (DE §10.6).

**Stage 2 — Inventory the unknowns.** List every question the project cannot currently answer, tagged [M1]: which are *facts to look up* (cheap — schedule lookups now), which are *assumptions to test* (spikes, §6), which are *decisions to make* (each will run DE §2 at its proper time — note the tier now). This inventory is the raw material for risk-first ordering. Exit: an unknowns list with each item classified and its resolution method named.

**Stage 3 — Decompose.** Section 3. Exit: pieces with narrow interfaces, each session-sized, each with a draft done-when.

**Stage 4 — Map dependencies.** Section 4. Exit: a dependency graph, the critical path marked, parallel tracks identified, hidden dependencies (credentials, hardware, approvals) surfaced.

**Stage 5 — Order by risk, then by dependency.** The scheduling rule: among all pieces whose dependencies are satisfied, do the one that retires the most uncertainty (FABLE §5's risk-retirement clause, applied as the tie-breaker at every scheduling point). The plan's *order* is its risk treatment — this is the single sentence that distinguishes real planning from task-listing.

**Stage 6 — Design milestones.** Section 5. Group the ordered pieces into phases, each a stable stopping point with an exit test. Exit: the roadmap skeleton.

**Stage 7 — Estimate with slack.** Per piece, ranges not points, the forgotten line items included (integration, docs, access/credentials, rework — FABLE §11 of the skills library's estimation discipline; the always-forgotten items are always the same items). Slack concentrated on novelty [M17]. Exit: honest ranges the plan's consumers have seen.

**Stage 8 — Write the plan artifact.** One document containing: done-state, non-goals, assumptions (each with its death-condition), the phased roadmap with entry/exit conditions, the unknowns inventory with owners, the risk register (top 5, each with its retirement point marked in the schedule), and the re-planning triggers (§7.6). The artifact is written for the successor [M18], not the author.

**Stage 9 — Review gate, then begin.** The plan is reviewed against the §11.2 quality checklist by someone who is not its author — a second model, a fresh context, or at minimum the author after a deliberate context switch. Then execution begins *at the first risk-retirement piece*, and the plan's own first prediction is tested within days, not weeks.

**Standing rule — re-derive, don't patch.** When an assumption dies mid-execution, return to the stage that consumed it and re-run the pipeline from there (usually Stage 3 or 5). Patching a plan around a dead assumption produces a chimera whose parts answer to different premises — the most confusing artifact a successor can inherit.

---

# 3. Problem Decomposition

FABLE §4 holds the principles (seams not steps; extract research questions; de-risk first; session-sized; vertical slices; falsifiable done-when). This section is the *discovery mechanics* — how to actually find the cut lines.

## 3.1 How to discover natural seams

A natural seam is where the problem is already almost separated — cutting there costs little and yields independence. Five detection instruments, applied in order of yield:

**The change-gradient scan** [M7]. For each aspect of the system, ask: *how often will this change, and driven by what?* Things that change at different rates, or for different reasons, belong on opposite sides of a seam — welding a yearly-stable thing to a weekly-churning thing forces the stable thing to churn. (Models churn monthly; protocols churn yearly; data formats should churn never — that gradient *is* the JarvisOS layer diagram.)

**The narrow-waist test.** Slide a hypothetical cut across the problem and, at each position, describe what would have to cross the interface. Where the description is shortest — countable, nameable things ("a list of file paths and a query"; "an audio buffer in, text out") — the waist is narrow and the seam is natural. Where you cannot finish the sentence ("well, it needs access to the config, and the session state, and it calls back into…"), you are cutting through an organ, not between them.

**The trust-boundary trace.** Wherever data crosses from one trust level to another (untrusted input → privileged action; user content → stored memory), a seam is *mandatory* regardless of convenience, because the seam is where enforcement lives. Trust boundaries you don't seam become the injection paths (this is why the V2 READER/ACTOR split is a seam and not a preference).

**The independent-testability probe.** Two candidate pieces are genuinely separate only if each can be exercised without the other present. If piece A can only be tested by standing up piece B, they share hidden state — they are one piece admitting it late. Testability is the ground-truth detector for real seams (FABLE §17 — hard to test means the seams are wrong).

**The replaceability probe.** For each candidate piece ask: *if this had to be swapped for a different implementation, what else would move?* Nothing → clean seam. Three other pieces → the seam is in the wrong place. This is the same instrument as testability, viewed from the ten-year end.

## 3.2 How to determine modules

A module is a piece promoted to a durable, named, contract-bearing unit. Not every piece deserves this — modularization has rent [M15] (an interface to maintain, a name to keep true, indirection to read through). Promote a piece to a module when **two or more of** these hold:

- It sits on a change gradient (§3.1) — it will be swapped or evolved independently.
- It sits on a trust boundary — the seam must be enforced, not just tidy.
- It is reused by three or more callers [M13 — rule of three; below three, a module is a premature abstraction].
- Its internals are a wall [M6] the rest of the system should never see (a hard algorithm, a security-sensitive routine).
- It is the natural unit of parallel work (§8) or of independent replacement (FABLE Law 4).

Below that bar, keep it a piece inside a larger module — a function, a file, a section — and let it earn promotion later. Under-modularizing is a cheap, reversible mistake [M11]; over-modularizing scatters a simple thing across many contracts and is expensive to reverse.

## 3.3 The decomposition procedure

1. State the done-state (Stage 1) and work *backwards*: what must be true just before success? and before that? Backward decomposition finds the pieces the goal actually requires; forward decomposition ("first we'll build X") finds the pieces the builder happens to imagine.
2. Cut at the seams found by §3.1, taking the narrowest waists first.
3. For each piece, write its contract: inputs, outputs, the invariant it guarantees. A piece whose contract you cannot write is not understood yet — decompose it further or spike it [M5].
4. Check each piece against the session-size test (FABLE §4): can one actor hold it entirely in one context/working-session? If not, recurse.
5. Identify the de-risking piece — the one whose failure invalidates the most other pieces — and mark it for first execution (Stage 5).
6. Choose the first vertical slice: the thinnest path that touches every layer end-to-end (§5.3). This becomes the skeleton everything else hangs on.
7. Assign each piece a falsifiable done-when (a stranger could check it) — pieces without one are not done being decomposed.

## 3.4 Decomposition failure signals

Stop and re-cut when you see: a piece that appears in every other piece's dependency list (a missing seam — that piece is really shared state, extract it); two pieces that always change together across three planned changes (they are one piece — merge them); a piece whose done-when can only be written as "it works with the rest" (untestable in isolation — the cut is through an organ); a decomposition more than three or four levels deep for a project of ordinary size (you are planning below the altitude the current knowledge supports — the deep levels are fiction, FABLE §3).

---

# 4. Dependency Analysis

Dependencies are what convert a set of pieces into an *ordered* plan. Getting them wrong produces either false serialization (slow) or discovered-too-late blockers (expensive).

## 4.1 How to discover dependencies

Four types, discovered by four different questions — and the last two are the ones that sink projects because the first two feel like the whole job:

- **Producer→consumer** (piece B needs A's output): trace each piece's inputs to whatever produces them. Mechanical, usually obvious, usually the only type people map.
- **Resource** (two pieces need the same scarce thing — the GPU, the operator's attention, a rate-limited API): list finite resources, then find every piece that draws on each. These create hidden serialization even between logically-independent pieces.
- **Knowledge** (piece B cannot be *planned* until A is *done*, because A resolves an unknown B's shape depends on): scan the unknowns inventory (Stage 2) — every "decision to make" is a knowledge dependency for everything downstream of it. These are invisible on a normal dependency graph and are the main reason detailed far-future planning is fiction.
- **External** (a thing outside the project's control must happen — an OAuth app approved, a developer-tier granted, hardware acquired, a human present to approve): enumerate every point where the project touches the outside world. These have the longest and least-controllable lead times and belong at the *front* of the schedule regardless of their logical position, because you cannot compress someone else's queue.

**The discovery procedure:** for every piece, ask all four questions explicitly ("what must exist before this can start? what does it compete for? what must be *known* before I can even plan it? what outside-my-control thing does it need?"). Write each dependency as a directed edge. The external and knowledge edges are the ones you will be tempted to skip; they are the ones worth double-checking [M1 — the assumptions that feel like comprehension].

## 4.2 Critical path

The critical path is the longest chain of dependent pieces — the sequence that determines the minimum project duration, where every piece has zero slack because any slip slips the whole project. Find it, and it *is* your schedule; everything not on it has slack (which is where your [M17] margin can be spent and where parallel work belongs, §4.3).

- Compute it after the dependency graph exists: the longest path from start to done-state, measured in effort not piece-count.
- Watch it move. As pieces complete and estimates firm up, the critical path shifts (a parallel track that hits trouble becomes critical). Recompute at every milestone.
- Protect it. The critical path gets the best actor, the most slack, the earliest start, and the most attention — improvement anywhere else is invisible [M10, bottleneck thinking]. Optimizing an off-path piece is the planning version of polishing furniture while a wall waits.
- Shorten it deliberately when needed: can a critical piece be split so part of it parallelizes off-path? can a knowledge dependency be collapsed by an early spike (§6) that resolves the unknown now instead of at its natural position? Front-loading a spike is the most common legitimate way to shorten a critical path.

## 4.3 Parallel work

Two pieces run in parallel only if they share *no* dependency of any of the four types — including resource and the human's attention (§8 details the agent mechanics; here it is the planning judgment). The discipline:

- Parallelize along the seams found in §3.1 — pieces with narrow, file-mediated interfaces recombine cleanly; pieces sharing mutable state produce merge conflicts that cost more than the serialization saved (FABLE §31 — the "could each brief be written now, completely, without the other's result?" test).
- Parallel tracks must reconverge somewhere; plan the *integration* as its own piece with its own done-when. Un-planned integration is where parallel work's saved time goes to die (§9, the integration-last anti-pattern).
- Resource contention silently serializes "parallel" work: two GPU-bound pieces are not parallel on a one-GPU machine no matter how independent their logic. Map the resource dependencies (§4.1) before promising parallelism.

## 4.4 Unknown dependencies

The dependencies you didn't map are the ones that hurt. Three defenses:

- **The early integration probe.** Build the vertical slice (§5.3) *first*, precisely because forcing every layer to touch every other layer early surfaces the dependencies no analysis predicted — the wrong data format at a boundary, the missing credential, the resource clash. Integration-first is dependency-discovery disguised as construction.
- **The pre-mortem for edges** [M16, inversion]. Ask: "the project stalled on a dependency nobody saw — what was it most likely?" The answers are reliably in the knowledge and external categories (§4.1); check those first.
- **Slack sized to unknown-dependency density** [M17]. Novel work and heavy-integration work have more undiscovered edges; their slack budget reflects that. Well-trodden work has few surprises and needs little.
- **Standing assumption:** there is always at least one dependency you have not found. Plan a checkpoint (the first milestone, §5) whose explicit job is to have surfaced it. A plan that assumes its dependency graph is complete is asserting omniscience.

---

# 5. Milestone Design

A milestone converts continuous work into a discrete, defensible stopping point. Its purpose is not celebration; it is to create a state where the project could *stop, be handed off, or change direction* without loss — and to force a review before more is built on what came before.

## 5.1 How to decide phases

A phase is a set of pieces that together reach a *coherent, stable state*. The test for a phase boundary: *at this point, does the system do something end-to-end that it couldn't before, and is it a safe place to stand?* Phases are cut by that test, then ordered by Stage 5's rule (risk-retirement first, dependency second). Concretely:

- Each phase ends at a **demonstrable capability**, not at an internal checkpoint ("the parser is done" is not a phase; "the system answers a question offline" is). This keeps phases honest — a capability can be shown; a component can be claimed.
- Phases are sized so that the **exit test** (§5.5) is reachable and meaningful. Too large, and risk hides inside until the end; too small, and the review overhead exceeds the work.
- **Order embeds the risk treatment.** The first phases exist to kill the biggest uncertainties (§6); the middle phases build the bulk on de-risked ground; the last phases add the nice-to-haves that scope negotiation (FABLE §10 skill) will cut first if time runs short. A roadmap read top-to-bottom should read as *decreasing risk and increasing polish*.

## 5.2 Deliverables

Each phase produces a deliverable that is (a) demonstrable to whoever owns the outcome, (b) durable — it doesn't evaporate when the next phase starts, and (c) a genuine foundation the next phase builds on. Avoid deliverables that are pure scaffolding (thrown away next phase) unless they are explicitly spikes (§6); scaffolding masquerading as a deliverable inflates apparent progress while building nothing [M19]. The deliverable is what the exit test checks.

## 5.3 Vertical slices

The first substantial phase should deliver a **vertical slice**: the thinnest possible path that traverses every architectural layer end-to-end, doing one real thing completely rather than all things partially (FABLE §4). Its value is disproportionate and specific:

- It proves the seams (§3.1) actually fit — that the interfaces between layers carry what they must.
- It surfaces the unknown dependencies (§4.4) while they are cheap.
- It converts the architecture from asserted to *demonstrated* — one working path is worth a hundred lines of design document [M2, territory over map].
- It gives the owner something real to react to early, when their feedback can still change the plan cheaply.

Horizontal slices (build all of layer one, then all of layer two) defer every integration risk to the end, where it is most expensive and least recoverable — the classic shape of projects that are "90% done" for half their duration.

## 5.4 Stopping points

Every phase boundary is a legitimate stopping point — a state where the project can be *paused indefinitely* without decay or *abandoned* with the value built so far intact. This is not pessimism; it is optionality [M11]. A plan made only of stopping points can absorb the interruptions, reprioritizations, and abandonments that every real multi-week project suffers. A plan with no stopping point until the end is a plan that delivers nothing if it is stopped at 80% — and long projects are stopped at 80% constantly. Design so that value is *banked* at each milestone, not held in escrow until completion.

## 5.5 Review gates

Each phase boundary carries a **review gate**: a falsifiable exit test plus a deliberate look before proceeding. The gate does two jobs:

- **The exit test** — the phase's done-state, observed not assumed [M19, and FABLE §17 — verify by exercising, not inspecting]. "Done when you unplug the network and still get answers" is an exit test; "done when the gateway is configured" is a claim. The test must be runnable by a stranger and must be able to *fail*.
- **The re-planning checkpoint** — before entering the next phase, re-examine the plan against what this phase *taught* (§1.3, plans decay from learning). Did an assumption die? Did the dependency graph reveal a hidden edge? Did the effort ranges hold? The gate is where the plan is legitimately re-derived, in the open, rather than silently drifting. The most valuable output of a phase is often not its deliverable but its correction to the plan.

Gates must be real gates: the option to *not proceed* — to pivot, re-plan, or stop — has to be genuinely available, or the review is theater. A gate that always passes is a formality; a gate that has occasionally sent a project back is doing its job.

---

# 6. Risk-First Planning

The organizing principle of the whole engine: **the plan's job is to make the project fail fast and cheap if it is going to fail at all.** A project has a small number of ways it can be fundamentally impossible or wrong; the plan's highest duty is to test those first, while pivoting is still cheap.

## 6.1 How to identify technical risk

From the unknowns inventory (Stage 2), risk is the subset that is both *uncertain* and *consequential*. Score each [M16, and FABLE §13's product]: probability it goes badly × cost if it does × **how late it would be discovered under the current plan order**. That third factor is the one unique to *planning* — the same risk is far more dangerous scheduled late than early, because late discovery means more built on top of it must be torn down. Risk-first planning is, precisely, the act of driving that third factor to near-zero for the top risks by reordering the schedule.

Categories to scan (each catches risks the others miss):
- **Feasibility** — "can this even be done on this hardware / with this tool / at this latency?" The most consequential and most often assumed [M1] (the STT-latency question; the local-model-fits-in-VRAM question).
- **Integration** — "will these pieces actually fit together?" Concentrated at seams and answered by the vertical slice (§5.3).
- **External** — "will the third party / credential / approval come through, and when?" Long lead times, low control (§4.1).
- **Scale/longevity** — "does this hold up over the decade / the volume / the churn?" — the risks that don't bite in a demo and do bite in year three.
- **Comprehension** — "do I actually understand the problem?" The deepest risk; retired by playback (FABLE §12) and by the vertical slice forcing real contact with the domain.

## 6.2 How to retire uncertainty early

To *retire* a risk is to convert an unknown into a known cheaply, before the plan commits to it. The schedule is arranged so that each early phase retires one or more top risks:

- Reorder so the de-risking piece (§3.3) comes first even when it isn't first in the natural build order (Stage 5). Building foundations before testing whether the roof is possible is the default mistake; risk-first inverts it.
- Prefer, for each top risk, the *cheapest experiment that could kill the plan* [M5]. If an hour's spike can retire a week's risk, the spike is nearly free.
- Retire feasibility and comprehension risks before integration risks before scale risks — roughly the order in which being wrong invalidates the most downstream work.
- Bank each retirement: write down what the spike proved, so the risk stays retired for the successor and isn't re-litigated after a context change [M12, ratchet; M2, inherited assumptions].

## 6.3 Spike planning

A spike is a timeboxed, disposable experiment whose only deliverable is a *resolved unknown* — code and artifacts are thrown away; the knowledge is kept (DE §8.2, explore mode). Planning spikes well:

- **Name the question and the answer that changes the plan** before starting (DE §6.1). A spike without a decision attached is exploration with no exit — it expands to fill all time.
- **Timebox hard** [M17, FABLE §5]. The spike's value is capped by the risk it retires; spending more than that on it is a loss. At the box's end, you either have the answer or you have learned the question is harder than the risk warranted — both are results.
- **Target the riskiest assumption, not the most interesting one** [M5]. Spikes drift toward the fun unknown; discipline points them at the consequential one.
- **Keep it disposable and labeled.** The single most common spike failure is the demo-that-ships [M5] — the throwaway becomes load-bearing because it happened to work. Plan the spike's *deletion* as explicitly as its execution.
- **Sequence spikes ahead of the work they de-risk**, on the critical path if the risk is on the critical path (§4.2). A spike that resolves a knowledge dependency can shorten the whole schedule by unblocking parallel work early.

---

# 7. Long-Term Project Planning

Weeks, months, years. The failure modes here are different in kind, not degree: short projects fail from bad execution; long projects fail from *drift* — the slow divergence between what the system is becoming and what it should be, and between what the team knows and what it once knew.

## 7.1 Maintaining momentum

- **Bank value at every milestone** (§5.4) so the project is always ahead of zero — nothing corrodes momentum like months of work with nothing demonstrable. Visible, banked progress is the fuel of long projects.
- **Keep a live "next action."** At any moment, the single next concrete step is unambiguous and written (FABLE §5, finish-beats-start). Ambiguity about what to do next is where long projects stall — the cost is not the work, it's the re-deciding.
- **Right-size the work to the context available.** For AI-executed long projects, momentum is maintained by ensuring each unit of work fits a session (§3, §8) so no unit requires reconstructing lost context before it can even begin.
- **Protect the critical path from the interesting-but-off-path** [M10]. Long projects accumulate fascinating side-quests; each is momentum spent invisibly.

## 7.2 Preventing architecture drift

Architecture drift is the gradual violation of the original seams and laws under the pressure of expedient local choices — each defensible alone, ruinous in aggregate. Defenses:

- **The architecture is written and binding** (in JarvisOS: the Constitution and ADRs). A plan cannot silently amend it; an amendment is itself a T3 decision with its own record (FABLE §3, DE §2). This is the primary anti-drift ratchet [M12].
- **Every phase's review gate (§5.5) includes an architecture check** (§11.4): did this phase introduce a component-private source of truth? a point-to-point coupling bypassing a seam? a provider dependency outside the gateway? Drift caught at a gate is a cheap correction; drift found in year two is a rewrite.
- **Make the boring choice the easy choice.** Drift accelerates when the correct path is harder than the expedient one; conventions, scaffolding, and templates that make the architecture-respecting move the path of least resistance prevent more drift than any amount of review.
- **Re-read the ADRs' context sections on a rhythm** (FABLE §21, assumption rot). An architecture decision correct in 2026 may be wrong in 2029 because its premise moved; the drift there is not the team violating the architecture but the architecture quietly ceasing to fit reality. That is a re-planning trigger (§7.6), not a violation.

## 7.3 Managing technical debt

Debt is a planning instrument, legitimate when *recorded* and *scheduled*, ruinous when silent (FABLE §12):

- **Take debt deliberately, with a ledger entry:** what was skipped, why, and the *trigger* that forces repayment ("when we add the second provider," "before this touches real user data"). Unrecorded shortcuts are not speed; they are undated bombs with the successor's name on them.
- **Distinguish debt classes:** debt on furniture [M6] can be near-permanent (fine — it never becomes load-bearing); debt on a wall or a seam must be repaid before anything is built on it, because it compounds structurally. The planning judgment is *which is which*, and it is the same wall/furniture classification as everything else.
- **Schedule repayment against triggers, not calendars.** "Someday we'll clean this up" never fires; "when X, first do Y" fires exactly when it matters. Attach debt triggers to the phases whose entry they gate.
- **Review the debt ledger at each gate** — pay what has come due, re-confirm the triggers on the rest, retire entries whose premise died.

## 7.4 Documentation strategy

For long projects, documentation is not a deliverable — it is the *anti-drift and anti-amnesia mechanism*, and it is planned as such (FABLE §26 holds the workflow; here is the long-project strategy):

- **Layer docs by decay rate** (§1.3): the mission/charter (slow — rarely touched), the architecture and its decision records (medium — changed only by deliberate amendment), the component registry and runbooks (fast — updated in the same session as reality changes, FABLE Law 8). Never place a fast-changing fact in a slow-changing document; one stale line poisons the credibility of the whole file [M2].
- **Documentation updates are inside the definition of done for every phase** (§11.5), never a trailing "documentation phase" — which is always the phase that gets cut, leaving the successor with a system and no map.
- **Write the *why*, not the *what*** [M18] — the artifact shows the what; only the why prevents the successor from reversing decisions out of ignorance (this is the entire premise of the extraction you are reading).
- **The decision record is the project's long-term memory.** In a project outliving the memory of its planners (all of them, in AI-driven work), the ADR trail is how a decision made in month one is understood — and correctly reopened — in year three.

## 7.5 The rhythm of a long project

Impose a heartbeat, because long projects that run without one drift silently between milestones: a per-phase review gate (§5.5); a periodic architecture-and-debt review (§7.2, §7.3) even mid-phase for very long phases; and a re-derivation of the *detailed* plan for the next phase only, at each gate (§1.2 — the far-future detail was fiction until now; now it can be written truthfully). The mission and architecture layers are re-examined far less often, and only on trigger.

## 7.6 Re-planning triggers

Name, in the plan artifact (Stage 8), the specific events that force re-planning — so re-planning is a fired trigger, not a vibe or a crisis: a load-bearing assumption dies (§1.3); a spike returns a plan-changing answer (§6.3); a phase exit test fails (§5.5); the critical path shifts materially (§4.2); a top risk either materializes or is retired (changing what's now most dangerous); an external dependency's timeline moves; or the owner's done-state changes. When a trigger fires, re-derive from the affected stage (§2, standing rule) — do not patch.

---

# 8. AI-Oriented Planning

Planning for execution by AI models — one, several, or a succession — has properties no human-team plan has: the executor may be replaced between any two steps, holds no memory except what is written, can be run in parallel at will but coordinates poorly through anything but files, and is a Goodhart engine [M19] that will optimize whatever the plan actually measures. Plan accordingly.

## 8.1 Planning work across multiple models

- **Assign work to model *tiers* by task shape, not to model *names*** (FABLE §15 — models churn; a plan naming today's models is dated on arrival). Mechanical, high-volume, low-judgment work → the cheap fast tier; irreversible, high-judgment, architecture-shaping work → the most capable tier; verification and adversarial checking → a tier and a *context* independent of the one that produced the work (§8.4). The plan specifies the tier and the reason, and stays correct as the specific models change beneath it.
- **Match effort to stage** (FABLE §31): a plan that spends the top tier on renaming and the cheap tier on the security-critical decision has mis-allocated exactly where it hurts.
- **Assume heterogeneity and succession**: the model executing phase four may differ from the one that planned phase one. So the plan cannot rely on any model-specific capability or memory; it relies only on the written artifact [M18, §1.6].

## 8.2 Task decomposition for AI execution

- **Decompose to the context window, not just the session** (FABLE §4, sharpened): each task must fit — with room to spare [M17] — inside the executor's working context *including* the orienting material it must read first. A task that requires more context than the executor has will be done with partial understanding, which for a model means confident wrongness [M33 AI-mistakes / FABLE §33].
- **Each task is self-contained** (FABLE §29 — every brief is a cold start): it names its own inputs by full path, its done-when, the constraints it must honor, and the form of its output. A task that assumes "as discussed" fails the moment the discussing context is gone.
- **Specify the output format, and make the done-when the real behavior** [M19]: "return the list of changed files and the failing test names" beats "look into it"; "done when the flow is exercised and observed" beats "done when tests pass." The plan's measurements are what the executor will optimize — measure the thing, not its shadow.

## 8.3 Parallel execution

- **Parallelize only genuinely independent tasks** (§4.3; FABLE §31): no shared dependency of any type, including the same files. The planning test is the cold-brief test — could each parallel task be fully briefed now, without any other's result?
- **Isolate parallel mutation** (FABLE §31 — separate workspaces/worktrees; the plan says which tasks write where). Parallel writers on shared state is a planned-in race condition.
- **Plan the reconvergence as its own task** (§4.3): fan-out is easy to plan and integration is where the saved time is lost if unplanned.
- **Fan out reading and searching freely; funnel deciding through one context** (FABLE §31 — committees of agents average judgment; a single briefed decider applies it). The plan sends many readers out and brings conclusions back to one place.

## 8.4 Review cycles

- **Plan verification as a distinct stage with an independent executor** (FABLE §31 — the finder must not be the sole verifier). The plan schedules a fresh context, ideally prompted to *refute* the work, because independence is what makes review worth anything; a verifier sharing the producer's context inherits its blind spots.
- **Scale review rigor to blast radius** [M8]: a T4/irreversible output gets adversarial multi-verifier review; a T1 furniture change gets a glance. Uniform review wastes the scarce capable-tier attention on the safe changes and under-guards the dangerous ones.
- **Review the plan itself** (Stage 9) by a non-author context before execution — the cheapest defect to fix is a planning defect.

## 8.5 Human checkpoints

- **Place human gates exactly at the T4 boundaries** (DE §8.5, §10.6): irreversible, outward-facing, money, privacy — the decisions whose downside lands on the human. Everywhere else, the plan proceeds without a gate, because a gate is only meaningful if it protects a real downside, and gates on reversible work only train the human to rubber-stamp (FABLE §32.6, approval fatigue).
- **Make each checkpoint a real decision, cheaply made:** present the choice, the recommendation, and the blast radius in plain language (DE §8.5). A checkpoint that dumps raw work on the human is not oversight; it is abdication dressed as diligence.
- **Batch checkpoints** where possible so the human faces a considered queue (the Outbox pattern), not a stream of interruptions — protecting the human's attention as the scarce resource it is.

## 8.6 Context preservation

- **Externalize state continuously, not at the end** (FABLE §6): the plan requires each task to write its decisions, findings, and open questions to files *as they occur*, because the executing context can end at any instant and everything not written is lost. The plan treats context as a cache over the file system, never as storage.
- **Plan explicit handoff points** (FABLE §6, session-handoff): before any likely context boundary — a long phase, a model switch, a compaction — a self-contained handoff note is written so the next context resumes from good notes rather than reconstructing fog. This is planned work, with its own slot, not an afterthought.
- **Design the plan so orientation is cheap:** index files, a clear directory contract, a "read this first" pointer — so a fresh context can find its place in minutes (§11 first checks). A plan that requires reading everything to do anything is unexecutable by a memoryless actor.

## 8.7 Knowledge transfer across the succession

- The durable artifacts — plan, decision records, memory, this very document — *are* the knowledge transfer; there is no oral tradition when the workers are replaced between steps [M18, §1.6]. The plan therefore treats its own documentation as load-bearing infrastructure, not overhead.
- **Every ratchet is a knowledge-transfer act** [M12]: a test, a checklist line, a law encodes a lesson so the successor inherits the judgment without inheriting the scar. Plan the ratchets, not just the fixes (§9.5 of DE, FABLE §27).
- **Plan for the successor to surpass the planner** (FABLE §15): clean seams, honest documentation, and reversible-where-possible structure help a more capable successor go faster; they are never wasted on a better model, and they are the only thing that saves a worse or differently-shaped one.

---

# 9. Planning Anti-Patterns

Named so they can be detected in flight. Each has a detection signal — the thing you can *observe* that means the anti-pattern is present now.

## 9.1 Planning mistakes

- **The Waterfall of Fiction** — detailed task lists for far-future phases, written now (FABLE §3). *Signal:* the plan specifies phase-five file names while phase one is unbuilt. *Detect:* any plan level more detailed than one-below-current is fiction; re-read §1.2.
- **Risk-Last Ordering** — building the easy, comfortable foundations first and deferring the "hard part" (which is the part that determines whether the project is possible at all). *Signal:* the scariest unknown is scheduled for the middle or end. *Detect:* the schedule doesn't read as decreasing-risk (§5.1).
- **The Dependency Blind Spot** — mapping only producer→consumer edges and missing knowledge and external dependencies (§4.1). *Signal:* the plan has no item earlier than it "logically" needs to be for a credential/approval/hardware reason. *Detect:* no external-dependency appears in the first phase of a project that clearly needs one.
- **Estimation by Point** — single numbers, no ranges, no slack, forgotten line items omitted. *Signal:* the plan's total is a sum of confident points and integration/docs/access aren't line items. *Detect:* ask "what's the bad case?" and get silence.
- **Big-Bang Milestones** — no stopping point until the end; nothing demonstrable for weeks (§5.4). *Signal:* the first review gate is past the halfway mark. *Detect:* ask "if we stop at 60%, what do we have?" and the answer is "nothing usable."
- **The Plan That Can't Fail** — no falsifiable exit tests, no assumptions listed, no re-planning triggers (§1.1, §7.6). *Signal:* you cannot state what observation would prove the plan wrong. *Detect:* §11.2 fails at the first item.

## 9.2 Execution mistakes (planned-in)

- **Horizontal Slicing** — building all of each layer in turn, deferring all integration to the end (§5.3). *Signal:* no end-to-end path exists until late. *Detect:* the first vertical slice is missing from the plan.
- **Scope Creep by Accretion** — the plan grows nice-to-haves during execution without re-passing the gate. *Signal:* work is being done that isn't in any phase's deliverable. *Detect:* compare current work to the written non-goals (Stage 1); creep is work the non-goals forbade.
- **The Ignored Gate** — review gates that always pass (§5.5). *Signal:* no phase has ever sent the plan back. *Detect:* if the gate has no power to stop, it's theater.
- **Context Amnesia** — AI execution that reconstructs lost context repeatedly because handoffs weren't planned (§8.6). *Signal:* sessions begin by re-deriving what a prior session already knew. *Detect:* no handoff notes exist between context boundaries.

## 9.3 Architecture mistakes (planning-level)

- **Seamless Planning** — decomposing by steps not seams (§3.1), producing pieces that can't be tested, parallelized, or replaced independently. *Signal:* every piece depends on every other; nothing is independently testable (§3.4). *Detect:* the replaceability probe returns "everything moves."
- **Premature Modularization** — promoting pieces to modules before the rule-of-three earns it (§3.2, [M13]). *Signal:* interfaces with one caller, "flexibility" nobody uses. *Detect:* count callers; below three without another promotion reason, demote.
- **Drift Tolerated** — expedient local choices violating the architecture, unchecked at gates (§7.2). *Signal:* a component now holds state it shouldn't, or couples point-to-point. *Detect:* the §11.4 architecture check at each gate; drift is what that check exists to catch.
- **The Speculative Framework** — building general machinery for needs that aren't real yet (FABLE §10, DE §7). *Signal:* the plan builds a "platform" before it has a second concrete use. *Detect:* the build-vs-nothing gate (DE §10.4) was skipped.

## 9.4 Project mistakes (long-horizon)

- **Momentum Death** — no banked value, no live next-action, stall between milestones (§7.1). *Signal:* "what's next?" has no immediate answer. *Detect:* the next concrete action isn't written down right now.
- **Silent Debt** — shortcuts taken without ledger entries or triggers (§7.3). *Signal:* the team knows about problems the plan doesn't record. *Detect:* ask "what did we skip and when do we pay it back?" and get anecdotes instead of a ledger.
- **Documentation Bankruptcy** — docs deferred to a trailing phase that gets cut (§7.4). *Signal:* the plan has a "documentation" phase at the end. *Detect:* docs aren't inside each phase's done (§11.5).
- **The Immortal Assumption** — an assumption whose premise died but which still shapes the plan (§7.2, FABLE §21). *Signal:* a decision defended by "we already decided that" rather than by its current context. *Detect:* re-read the ADR's context section; if the world it describes is gone, the assumption is a corpse steering the ship.

---

# 10. Planning Decision Trees

Built per [M7 → skill S-007]. These are planning-specific and do not repeat the Decision Engine's trees (DE §10) — where a branch reaches a pure decision, it defers to DE.

## 10.1 Project kickoff
```
Is the problem framed and the done-state written & confirmed? (Stages 0–1)
  ├─ no → STOP planning; frame first (FABLE §1). Planning an unframed problem routes to the wrong place.
  └─ yes → Are the load-bearing unknowns inventoried & classified? (Stage 2)
            ├─ no → inventory them; a plan over unmapped unknowns is fiction
            └─ yes → Is there a top risk that could make the project impossible/pointless?
                      ├─ yes → plan a spike FIRST (§6.3); the rest of the plan waits on its answer
                      └─ no → decompose (§3) → map dependencies (§4) → order risk-first (Stage 5) → milestones (§5)
```

## 10.2 Architecture-first, or dive in?
```
Will this create durable structure others build on (seams, formats, contracts)?
  ├─ no → dive in; it's furniture [M6], reversible, plan lightly
  └─ yes → Do I understand the problem well enough to place the seams? (§3.1)
            ├─ no → spike to LEARN the wall first [M5]; don't architect from ignorance
            └─ yes → architect the seams first (thin: roles, contracts, the vertical slice path),
                     then build — enough architecture to place the seams, no more (avoid §9.3 speculative framework)
```

## 10.3 Prototype vs production
```
What is the deliverable's purpose?
  ├─ to LEARN / retire a risk → PROTOTYPE (spike): timeboxed, disposable, labeled, deletion planned (§6.3, DE §8.2)
  │        └─ guard: plan its deletion now, or it becomes the demo-that-ships [M5]
  └─ to be BUILT ON → PRODUCTION: full quality on the walls [M6], done-when = observed behavior (§8.2)
         └─ never let a prototype cross into production silently; that crossing is a T3 decision (DE §2)
```

## 10.4 When to refactor (as a planning decision)
```
Is a change blocked or made risky by the current structure?
  ├─ no → do NOT refactor; "cleaner" is not a trigger (FABLE §18). Plan the feature, not the beautification.
  └─ yes → Is the structure-fix a wall or furniture? [M6]
            ├─ furniture → refactor in-place, small, separate from behavior change (FABLE §18)
            └─ wall/seam → plan it as its own phase with its own gate; "make the change easy, then make the easy change"
```

## 10.5 When to rewrite vs evolve
```
Is the problem the DECISION (wrong architecture) or the EXECUTION (bugs on right architecture)? (DE §9.2)
  ├─ execution → EVOLVE; fix in place. A rewrite discards the encoded edge-case knowledge for no architectural gain.
  └─ decision → Is the system live / does it have undocumented behavior others rely on?
                 ├─ yes → STRANGLE, never big-bang (FABLE §22.4): new alongside old, migrate piece by piece,
                 │         each step shippable, delete old only when cold. Plan the kill of the old explicitly.
                 └─ no (greenfield / disposable) → rewrite may be cheapest-path-from-today [M14];
                          still strip sunk cost first (DE §9.3) and confirm the rewrite carries the LEARNING forward
```

## 10.6 When to split one project into several
```
Do the parts have genuinely independent done-states AND owners AND lifecycles?
  ├─ no → keep as ONE project with phases; splitting adds coordination rent [M15] for no independence gained
  └─ yes → Do they share a fast-changing interface that would force lockstep releases anyway?
            ├─ yes → keep together (a shared fast seam means they're one system wearing two names)
            └─ no → SPLIT: separate repos/plans, each with its own roadmap, coordinating through
                    a stable published contract (§3.1 change-gradient — split along the slowest seam between them)
```

---

# 11. Planning Checklists

The pipeline compressed. Run the long form (§2) until reflex.

## 11.1 Before starting to plan (pre-planning)
- [ ] Is the problem framed and confirmed, with non-goals written? (Stages 0–1; FABLE §1)
- [ ] Is the done-state observable and falsifiable — could a stranger check it? (§1.4)
- [ ] Do I know whose outcome this is, and are they the one confirming the done-state? (DE §10.6)
- [ ] Are the unknowns inventoried and each tagged fact / assumption / decision? (Stage 2, [M1])
- [ ] Is this the right *altitude* to plan in detail, or am I about to write fiction? (§1.2, FABLE §3)

## 11.2 Plan-quality gate (before execution — Stage 9)
- [ ] Is the plan decomposed along seams, each piece independently testable & session-sized? (§3, §3.4)
- [ ] Is the dependency graph mapped including knowledge and external edges, critical path marked? (§4)
- [ ] Does the order read as risk-decreasing — biggest uncertainty retired first? (Stage 5, §6)
- [ ] Does phase one deliver a vertical slice? (§5.3)
- [ ] Does every phase have a falsifiable exit test and a real (can-fail) review gate? (§5.5)
- [ ] Is value banked at every milestone — is there always something usable if we stop? (§5.4)
- [ ] Are estimates ranges with slack, and are integration/docs/access line items present? (Stage 7, §1.5)
- [ ] Are assumptions listed with death-conditions, and re-planning triggers named? (§1.3, §7.6)
- [ ] Was this plan reviewed by a non-author context? (Stage 9, §8.4)

## 11.3 AI-execution readiness
- [ ] Is each task self-contained (paths, done-when, constraints, output form) — briefable cold? (§8.2, FABLE §29)
- [ ] Does each task fit its executor's context with slack for orientation? (§8.2)
- [ ] Is work assigned by tier/reason, not model name? (§8.1)
- [ ] Are parallel tasks genuinely independent, mutation isolated, reconvergence planned? (§8.3)
- [ ] Are human gates exactly at the T4 boundaries and nowhere gratuitous? (§8.5)
- [ ] Are verification stages independent of the producing context? (§8.4)
- [ ] Are handoff points and continuous state-externalization planned? (§8.6)

## 11.4 Architecture check (run at every phase gate — anti-drift)
- [ ] Did this phase introduce any component-private source of truth? (should be: no)
- [ ] Any point-to-point coupling that bypasses a seam? (§7.2)
- [ ] Any provider/model dependency outside the intended seam? (FABLE §15)
- [ ] Any assumption whose premise has since died? (§9.4 immortal assumption)
- [ ] Is the debt ledger current — repayments due this phase paid? (§7.3)

## 11.5 Phase-done check (per milestone)
- [ ] Exit test run and *observed* passing, not assumed? (§5.5, [M19])
- [ ] Docs/registry/decision-records updated in this phase, not deferred? (§7.4)
- [ ] Plan re-derived against what this phase taught; triggers re-checked? (§5.5, §7.6)
- [ ] Ratchets installed for anything that must not silently regress? [M12]
- [ ] Handoff note written if a context boundary is imminent? (§8.6)
- [ ] Next phase's detailed plan written now (and not before)? (§1.2)

---

# 12. Real Engineering Examples

Complete planning walk-throughs on real JarvisOS work, showing the pipeline firing. Read them as the engine running, not as summaries.

## 12.1 Planning JarvisOS itself (a multi-phase, multi-year, AI-executed project)
- **Frame + done-state (Stages 0–1):** done-state = "a non-programmer operates, offline-capable, a system that thinks/acts across many capabilities and *survives its architect for a decade*." Non-goals written explicitly (not a chatbot, not a cloud service). The survival clause is what made this a ten-year plan and not a build.
- **Unknowns inventory (Stage 2):** feasibility ("does a usable local model run on this hardware?"), external ("which capabilities need paid/approved API access?"), comprehension ("does the operator's real need match the stated capability list?"). Each classified — the first a spike, the second a lookup, the third a playback.
- **Decompose (§3) along the change-gradient (§3.1):** the seams fell out of the gradient scan — models churn monthly (→ gateway seam), capabilities evolve independently (→ MCP seam), state must never churn (→ files, owned by no component). This is why the architecture has exactly those two seams and not others: they are where change was found to arrive.
- **Dependencies (§4):** the knowledge dependency dominated — "which local model" couldn't be *planned* until hardware feasibility was *known*, so the hardware survey and model spike became a phase-0/phase-1 knowledge-retirement gate blocking everything downstream.
- **Order risk-first (Stage 5, §6):** Phase 1's exit test — "unplug the network and still get answers" — is a *feasibility risk retirement* disguised as a milestone. If offline reasoning is impossible on this machine, the entire offline-first premise is dead, and the plan is built to discover that in week one, not month six.
- **Milestones as vertical slices (§5.3):** Phase 2's done-when — "research online, write to a file, push a repo" — is one thin end-to-end path through kernel + tools + files, proving the seams fit before any capability is built in depth.
- **AI-execution planning (§8):** each phase carries a hand-off prompt (a cold brief, §8.2); the operator is the human gate at every outward action (§8.5); the whole system externalizes state to files (§8.6) precisely because the executing model will change across the decade (§8.7).
- **Stopping points (§5.4):** every phase is a place the project can stop with value banked — the operator has a working chat (P1), then working hands (P2), then memory (P3), and abandoning after any phase leaves something usable. This is what makes a decade-long plan survivable through interruption.

## 12.2 Planning the voice loop (a single phase, feasibility-dominated)
- **Top risk identified (§6.1):** feasibility — "is offline STT fast enough for conversation on this GPU?" High consequence (the phase's whole premise), high uncertainty, and *discovered late* under a naive plan that built the pipeline first.
- **Risk-first reorder (§6.2):** the plan's first act is a one-hour spike (§6.3) — transcribe audio on the actual hardware, measure latency — *before* any orchestration is designed. The spike's deletion is planned; only the number is kept.
- **Decompose (§3.3):** backward from the done-state ("hold a spoken conversation offline") → [capture][VAD][STT][kernel round-trip][TTS], each a narrow-waist seam (§3.1 — "audio buffer in, text out" is a finishable interface sentence).
- **Build-vs-adopt per piece (DE §10.4, §7):** STT/TTS adopted (mature OSS behind MCP seams); orchestration built (thin glue, furniture [M6]). The plan builds only the glue.
- **Vertical slice (§5.3):** the first deliverable is one full round-trip on canned audio — proving the seams connect — before robustness (VAD tuning, error handling) is added.

## 12.3 Re-planning after the red-team review (a trigger firing mid-project)
- **Trigger (§7.6):** the adversarial review surfaced that several load-bearing assumptions had died or were never true (the substrate was EOL; "provider-agnostic" didn't cover the kernel; approval was a law with no mechanism). Multiple re-planning triggers fired at once.
- **Re-derive, don't patch (§2 standing rule):** rather than patching fixes onto the V1 plan, the affected stages were re-run — the architecture (Stage 3–4 equivalent) was re-derived into V2, producing new seams (READER/ACTOR, the Outbox) that the original decomposition lacked.
- **Order the remediation risk-first (§6):** the seven critical flaws were ordered by *blast radius on the operator* [M8] and gated — no outward-facing phase (P6) may proceed until the injection-defense and approval mechanisms exist. The plan encodes the dependency "safety mechanisms before autonomy."
- **Ratchets planned, not just fixes (§8.7, [M12]):** each critical flaw's remediation includes its anti-regression mechanism (the injection canary suite, the weekly kernel-parity job, the watchdog) — so the plan transfers the red-team's lessons to every future executor without the scar.

## 12.4 A deliberately un-planned task (the boundary case)
- **Task:** "rename a config key for clarity; adjust the one file that reads it."
- **Kickoff tree (§10.1) short-circuits:** no durable structure created, no unknowns, reversible [M11]. This is furniture [M6].
- **Plan:** none. Do it, verify the one reader still works, move on.
- **Why it's here:** planning it — decomposition, dependency graph, milestones — would be pure [M15] rent and a [M19] Goodhart failure where following the planning ritual becomes the goal instead of good outcomes. **The planning engine's highest discipline, exactly as the decision engine's, is knowing when *not* to run.** A planner that plans everything has failed as completely as one that plans nothing — the whole point of the tier and altitude machinery is that 90% of work needs almost none of it, so the 10% that shapes the decade can have all of it.

---

*End of PLANNING_ENGINE.md — Fable 5, legacy extraction, 2026-07-09.*