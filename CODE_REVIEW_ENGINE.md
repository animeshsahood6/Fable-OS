# CODE_REVIEW_ENGINE.md — The Executable Review Manual

**Authorship: Fable 5, legacy extraction, 2026-07-09. Content preserved verbatim per the Legacy Extraction Protocol.**

**What this is.** The machinery I run when I evaluate someone else's engineering work — code, an architecture, a prompt, an orchestration, a change of any kind — and must decide whether it is fit to proceed, and why. Written as procedures another AI can execute. It is the ninth engine of the extraction set and strictly additive to the eight before it: **[M#]** points to [FABLE-MENTAL-MODELS.md](FABLE-MENTAL-MODELS.md); **FABLE §N** to [FABLE.md](FABLE.md); **DE §N** to [DECISION_ENGINE.md](DECISION_ENGINE.md); **PE §N** to [PLANNING_ENGINE.md](PLANNING_ENGINE.md); **RE §N** to [RESEARCH_ENGINE.md](RESEARCH_ENGINE.md); **AE §N** to [ARCHITECTURE_ENGINE.md](ARCHITECTURE_ENGINE.md); **OE §N** to [AI_ORCHESTRATION_ENGINE.md](AI_ORCHESTRATION_ENGINE.md); **BE §N** to [BUILD_ENGINE.md](BUILD_ENGINE.md); **DBG §N** to [DEBUGGING_ENGINE.md](DEBUGGING_ENGINE.md). This document assumes and does not repeat: the code-review *priority order and conduct* (FABLE §25 — does-it-do-what-was-asked, edges, blast radius, readability, simplification, tests-as-code, every-finding-has-a-failure-scenario), the standards being reviewed *against* (naming FABLE §16, testing §17, refactoring §18, repository §19, architecture AE, build BE), how reviewers are *spawned and made independent* in a fleet (OE §8, §9.2), and the failure catalog reviews hunt for (DBG §3, AE §10). FABLE §25 is the seed of *how to conduct a code review*; this engine is the full discipline across every kind of engineering work, at every scale, including the AI-native artifacts that had no review tradition when I was written.

**Where this sits.** BE produces the work; DBG repairs it when it breaks; this engine is the *gate between producing and trusting* — the independent judgment that catches defects before they ship, verifies the work is what it claims, and decides whether it proceeds. It is the human/independent-verifier side of OE §8 (verification architecture) made into a complete method: OE §8 says *that* high-stakes work is independently verified and *how the fleet is structured* to verify it; this engine is *what the verifier actually does* when it reads the work.

**The one-sentence version.** Review is the independent judgment of whether work is correct, sound, and fit to trust — and its entire value comes from *independence*, because the one thing the producer structurally cannot do is see the blind spot that produced the defect, so a review that merely re-confirms the producer's reasoning has verified nothing.

---

# 1. Review Philosophy

**1.1 — What review actually is.** Review is *independent judgment applied to finished work before it is trusted* — a second mind, failing differently than the first (OE §1.2, §8.1), checking that the work is correct, sound, and fit to proceed. Its essence is the independence: the producer built the work from a model of the problem, and any error in that model is invisible *to that model* (DBG §1.1 — you cannot see your own blind spot). Review exists to bring a *different* model to bear, one whose blind spots are elsewhere, so that between the two models the defects have nowhere left to hide. This is why self-review is structurally weak (§10.2, OE §8.1) and why the reviewer's value is not "being smarter than the producer" but "being *different* from the producer" — a less capable independent reviewer catches errors a more capable producer cannot see in itself.

**1.2 — Why review exists.** Three reasons, in order of importance:

- **To catch what the producer couldn't see** (§1.1) — the correlated-error escape (OE §1.2). This is the irreducible reason; everything else is secondary.
- **To verify the work is what it claims** — that it does what was asked (FABLE §25 — the most expensive review failure is perfect scrutiny of the wrong thing), that "done" means done (BE §7.7, not "compiles" or "looks right," DBG §1.1), that the claimed behavior is the actual behavior [M2].
- **To transfer knowledge and standards** — review is how a codebase stays coherent (one set of standards applied across many producers, FABLE §19), how producers learn (a good review teaches), and how systemic issues are caught before they replicate (§5.6-class thinking applied at the gate). In a fleet of AI producers (OE), review is *the* mechanism that keeps many independent builders producing one coherent system (OE §9.8).

**1.3 — What review is not.** Review is *not* re-doing the work (a reviewer who would have built it differently but not better has found nothing — §10.1 nitpicking, §10.5 style obsession). It is *not* a style enforcement pass (machines do style, §7 of BE — FABLE §19; a human/AI reviewer spending attention on formatting a linter should catch is wasting the scarce resource on the cheap problem while the expensive ones go unexamined, §10.5). It is *not* a rubber stamp (approving without genuine examination, §10.2 — which is worse than no review, because it manufactures false confidence, [M20]). It is *not* a gate for the reviewer's ego or aesthetic preferences (§10.1 — "I'd have done it differently" is not a finding unless "differently" is *better* on a dimension that matters). Review is the disciplined, independent judgment of *fitness*, and everything that isn't that is noise that dilutes it.

**1.4 — The responsibilities of a reviewer.** Six, non-delegable:
1. **Judge fitness, not preference** (§1.3) — is this correct, sound, and fit to proceed, by objective dimensions (§4–§8), not by whether it matches how you'd have done it.
2. **Read what actually changed and what it touches** (§3) — including the blast radius beyond the diff (FABLE §25, [M8]).
3. **Verify claims against reality** [M2] — does it do what was asked? does it actually work (BE §7.4)? — not take the producer's word (§4).
4. **Prioritize attention by stakes** (§3.6, FABLE §25) — spend rigor on the walls [M6] and the irreversible, skim the furniture; a review that examines everything equally examines the important things insufficiently.
5. **Report findings actionably** — each with its failure scenario (FABLE §25 — a finding without a concrete consequence is a style opinion), ranked by severity, so the producer knows what must change and why.
6. **Own the approval** — approving means *staking your judgment* that the work is fit; an approval is not "I didn't find anything," it is "I examined this and it is sound" ([M20], §12). A reviewer who approves work they didn't genuinely examine has spent trust they'll lose when it fails (§10.2).

**1.5 — The relationship between review and engineering quality.** Review is a *quality gate*, not a quality *source* — it catches defects but doesn't create good work (good work comes from BE, AE, DBG; review verifies it). This matters: a team cannot review its way to quality (§10 — review has limits, and over-relying on it produces reviewer fatigue §10.8 and rubber-stamping §10.2 while quality stays low). Review's leverage is *catching the expensive defects cheaply* — the correctness bug before it ships (DBG), the architecture violation before it's built upon (AE §6.3 drift), the security hole before it's exploited (§6). Its value is asymmetric [M16] — one caught critical defect can be worth thousands of reviews, and one *missed* critical defect (a security hole rubber-stamped, §10.2) can be catastrophic — which is why review rigor scales to stakes (§3.6, §1.4.4) and why the reviewer's honesty about what they did and didn't examine is load-bearing (§1.4.6, [M20]).

---

# 2. Review Pipeline

Work in, approval or change-request out. Eight stages. FABLE §25 gives the priority order for the reading; this is the full pipeline around it. The pipeline is disciplined because review under time pressure tempts the skim-and-approve (§10.2) that defeats its purpose.

**Stage 0 — Preparation.** Establish what this review is *for* and at what stakes: what does the work claim to do (the requirement/intent it serves)? what tier is it (reversibility × blast radius, DE §2, [M8] — a config tweak vs a data-format change vs a security boundary)? what would being wrong cost? This sets the *depth* of the review (§3.6) — the single most important calibration, because a review pitched at the wrong depth either wastes effort on the trivial or under-examines the critical.
*Checkpoint: do I know what this work is supposed to do and what being wrong would cost? If not, the review has no standard to judge against.*

**Stage 1 — Context gathering.** Understand enough of the surrounding system to judge the change (§3.1) — the architecture it lives in (AE, so you can see boundary violations §5), the contracts it must honor (AE §4), the conventions it should match (FABLE §16, §19), the requirement it serves (RE §3, so you can check it does what was asked). Review without context is style-checking (§1.3, §10.5) — you can only judge *fitness* against a standard, and the context *is* the standard.
*Checkpoint: do I understand the system this change lives in well enough to judge its fitness — or am I about to review a diff in a vacuum?*

**Stage 2 — Reading.** Read the work in priority order (§3, FABLE §25) — does-it-do-what-was-asked first, then correctness at the edges, then blast radius, then the rest. Read to *understand what it actually does* [M2], not to confirm it does what it claims (§10.3 confirmation bias — the producer's description is a map; the code is the territory). Read the whole change and what it touches (§3.5, blast radius beyond the diff).
*Checkpoint: do I understand what the code actually does, distinct from what it's described as doing? Have I read what it touches, not just the diff?*

**Stage 3 — Verification.** Check the work against reality (§4, [M2]) — does it actually do what was asked? does the behavior hold at the edges (§4.3)? does it actually run/work (BE §7.4 — verify by exercising where the stakes warrant, not just by reading)? For high-stakes work, this is where the review *exercises* the claim, not just inspects it (DBG §1.1 — the gap between "looks right" and "is right"). Verification distinguishes review from mere reading — a review that only reads and reasons can miss what running would reveal.
*Checkpoint: have I verified the load-bearing claims against reality, or only reasoned about them? For high stakes, did I exercise it (BE §7.4)?*

**Stage 4 — Questioning.** Interrogate the work adversarially (§4, DBG §6, RE §9.5) — where does this break? what input wasn't handled? what happens when this dependency fails? what did the producer assume that might be false [M1]? Questioning is the reviewer's version of inversion [M16] — actively hunting for what's wrong rather than confirming what's right (§10.3). The strongest reviews *attack* the work (§9, adversarial review) — not hostilely, but rigorously, because a defect not sought is a defect not found.
*Checkpoint: have I actively hunted for what's wrong, or passively confirmed it looks right (§10.3)? Can I state the strongest case against approving this?*

**Stage 5 — Decision.** Decide: approve, request changes, or block (§11.1). The decision follows from the findings and their severity (§1.4.5) — blockers (correctness on a wall, security, irreversible risk) require changes before proceeding; suggestions (improvements that aren't blocking) are offered but don't gate. The decision is *proportional to stakes* (§3.6) — the bar for approving a security boundary (§6) is far higher than for internal furniture [M6]. The decision is *owned* (§1.4.6) — approving stakes your judgment.
*Checkpoint: is my decision justified by the findings, proportional to the stakes, and something I'd stake my judgment on ([M20])?*

**Stage 6 — Feedback.** Report findings actionably (§1.4.5, FABLE §25) — each with its *failure scenario* (the concrete consequence — a finding without one is a style opinion), ranked by severity (blockers first, so they land; twenty mixed findings get skimmed, FABLE §25), verified against the actual code (a reviewer who cries wolf loses their only currency, FABLE §25). Feedback is *for the producer* — clear enough to act on, specific enough to locate, and honest about confidence (this is definitely wrong vs this might be worth checking, [M20]).
*Checkpoint: does each finding have a failure scenario, a location, and a severity? Would the producer know exactly what to do with it?*

**Stage 7 — Knowledge capture.** For systemic findings (a recurring defect class, a pattern worth preventing, §5.6-class thinking), capture beyond this review: a ratchet [M12] (a lint rule, a test pattern, a checklist line) that catches the class automatically so it need not be caught by review again (FABLE §19 — machine-enforce what machines can). Review's highest leverage is *converting a caught defect into a class that can't recur* — the review that finds a bug helps once; the review that produces the ratchet against the bug's class helps forever (§1.5, OE §6.7).
*Checkpoint: is this finding an instance of a class worth preventing systematically? If so, is there a ratchet, not just a fix?*

**Standing discipline — review is bounded by attention, so spend it where it matters.** The reviewer's attention is finite and degrades (§10.8, fatigue), so the pipeline concentrates it (§3.6) — deep on the walls and the irreversible, light on the furniture, and *never* wasted on what a machine should check (§10.5, style). A review that spreads attention evenly examines the critical things at the same shallow depth as the trivial, which is the same as not reviewing the critical things.

---

# 3. Reading Strategy

How to read the work efficiently and see what matters — the reviewer's version of RE §6 (understanding unknown code) focused on *judging a change* rather than *comprehending a system*. The governing principle: **read in priority order, understand what the code actually does before judging it, and concentrate attention where being wrong is expensive — because a review's quality is set by where its limited attention was spent, not by how many lines it passed over.**

**3.1 — How I read unknown repositories (for review).** When reviewing a change in a repository I don't fully know, I gather *just enough* context to judge the change (§2 Stage 1, RE §6.1 — descend only where the task points) — the architecture the change lives in (AE §3, to see boundary violations §5), the contracts it touches (AE §4), the conventions it should match (FABLE §16, §19). I do *not* try to understand the whole repository (RE §6.1 — that's for a different task); I understand the *neighborhood* of the change deeply enough to judge whether the change fits it. The reading is change-centered: start from what changed, expand outward to what it touches (§3.5), stop when I understand the change's fitness in its context.

**3.2 — How I read pull requests.** A PR is a unit of change with an intent (FABLE §25 — read the requirement first, then the diff). Read it as: *what is this trying to do* (the intent/requirement, §2 Stage 0) → *does the change actually do that* (§4, verification) → *at what cost/risk to the rest* (§5 architecture, §3.5 blast radius). Read the PR's *description as a map* [M2] (it claims what the change does) and the *diff as the territory* (what it actually does) — and when they disagree, the diff is the truth and the description is either stale or misleading (a finding in itself). A well-scoped PR (BE §13.3 — one purpose, refactor separated from behavior) is readable; a PR that mixes concerns is a review hazard (§10 — the reviewer can't isolate what to judge) and often the first finding is "split this."

**3.3 — How I read large diffs.** A large diff exceeds the attention that can be spent evenly (§2 standing discipline), so it must be *triaged*, not read linearly. Triage: identify the *critical files* (§3.4) and read those deeply; identify the *mechanical/repetitive* parts (a rename across many files, generated code) and verify the pattern once then spot-check; identify the *architectural* changes (§3.5) and judge those hardest. A large diff should often *not be reviewed as one* — the first finding is frequently "this is too large to review well; split it" (BE §13.3, PE §5.3 — small increments are reviewable, big-bang changes aren't), because a diff too large to hold [M6] is reviewed shallowly everywhere, which means the critical parts are under-examined.

**3.4 — How I identify critical files.** The files where being wrong is expensive [M6, M8] — reviewed deeply, while the rest are skimmed (§3.6). Critical files are identified by: *what they touch* (a change to a shared contract AE §4, a data format AE §5, a security boundary §6, a core algorithm — walls [M6]); *centrality* (files many things depend on, RE §6.6 — a bug here has wide blast radius [M8]); *irreversibility* (changes to persisted data, public interfaces, anything that once shipped can't be taken back, [M11], AE §4.7); and *change concentration* (where the diff is densest and most novel — the mechanical parts are low-risk, the novel logic is where bugs live). Attention flows to the critical files (§3.6); the rest gets proportional-to-risk skimming.

**3.5 — How I identify architectural impact (blast radius beyond the diff).** The most-missed review dimension (§10.4 architecture blindness): a change's effect extends beyond the lines it touches (FABLE §25, [M8]) — it can violate a boundary (§5.1), break a contract callers depend on (§5.3, AE §4.7), introduce hidden coupling (§5.2, AE §10.8), or shift an invariant (AE §2.6). Identify architectural impact by asking: *what does this change touch that isn't in the diff?* — the callers of a changed interface, the consumers of a changed format, the assumptions elsewhere that this change invalidates (DBG §5.5 hidden dependencies). This requires the context (§2 Stage 1) — you can't see blast radius in a diff read in isolation. Architectural impact is where the *expensive* review findings live (a boundary violation built upon becomes a rewrite, AE §6.3), so it's examined hardest for anything touching a wall [M6].

**3.6 — How I prioritize attention.** The master discipline (§2 standing, §1.4.4, FABLE §25): attention is finite, so spend it by *stakes* — deep on the walls [M6] (correctness of the irreversible, the security boundary §6, the shared contract §5.3, the core logic §4), light on the furniture (internal reversible code, where a bug is cheap to find and fix later). The priority order within the reading (FABLE §25): does-it-do-what-was-asked → correctness at the edges → blast radius → readability → simplification → tests. Prioritization is *the* review skill — a reviewer who spends equal attention on a formatting nit and a security boundary (§10.5) has mis-allocated exactly where it hurts, examining the catastrophic-if-wrong thing at the same depth as the trivial-if-wrong thing. Calibrate depth to blast radius [M8], always.

---

# 4. Correctness Review

Whether the work does the right thing — the first and most important dimension (FABLE §25). This is the reviewer applying DBG's failure-classification lens *proactively* — hunting for the bugs before they manifest. The governing principle: **verify correctness against reality and at the edges, not against the producer's description and the happy path — because the description is a map [M2] and the happy path is where bugs hide least.**

**4.1 — How I verify correctness.** First, *does it do what was asked* (FABLE §25 — check the intent §2 Stage 0 against what the code actually does §3.2, [M2]) — because correctly implementing the wrong thing is the most expensive review miss. Then, *does it do it correctly* — trace the logic against intent (DBG §3.1), check the edges (§4.3), the failures (§4.4), the state (§4.5). Verify against *reality* where stakes warrant (§2 Stage 3, BE §7.4 — exercise it, don't just read it) — the gap between "looks correct" and "is correct" (DBG §1.1) is where the review earns its keep. The reviewer's correctness question is not "does this look right?" (the producer thought so, that's why they submitted it) but "under what input does this do the wrong thing?" (§4, the adversarial framing §9).

**4.2 — Logic validation.** Check the logic does what it intends — the conditions are right, the calculations correct, the branches complete (DBG §3.1). Trace a representative input through by hand and compare to the intended behavior. Suspect: off-by-one and boundary conditions (§4.3), inverted conditions, missing branches (a case unhandled), and logic that's *correct for the case the producer thought of* but wrong for cases they didn't (§4.3 edges). Logic bugs are the most tractable to catch in review because they're deterministic and local (DBG §3.1) — a careful read against intent finds most of them.

**4.3 — Boundary conditions and edge cases.** Where bugs concentrate (DBG §1.3 — the edge is where the usual case ends and the assumed-away case begins). Check: empty (empty input, empty collection, zero, null/absent), maximal (huge input, overflow, limits), and malformed (invalid, unexpected shape, wrong type). The reviewer's discipline: *the producer built and tested the happy path* (that's why it's submitted), so the review's attention goes to the edges *they didn't* (§3.6 — the center is probably fine, the edges are where the review adds value). For each edge, ask: what does this do at the boundary, and is that correct? An unchecked edge is an assumed-away case (DBG §1.4) — a latent bug wearing "it works."

**4.4 — Error handling.** How the code behaves when things go wrong (AE §8.1 — fail loud and safe). Check: every external call's failure is handled (the network fails, the dependency errors, the file's absent — DBG §3.6, §3.7); failures are *loud*, not silent (AE §8.1, §10 silent-fallback — a swallowed error is a bug that will surface later, untraceable); failures leave the system in a *safe* state (AE §8.1 — fail into denial/safety, not into a corrupted half-state §4.6). The most common error-handling defect: the happy path is complete and the failure paths are absent or wrong (because they're not exercised in normal testing, DBG §3.6) — so the reviewer examines the failure paths *harder* than the happy path.

**4.5 — State management.** Whether the code maintains valid state through all operations (DBG §3.2, BE §5.3). Check: state transitions are valid (no path leaves the state invalid); shared state has a single owner and no races (AE §3.3, §10.4, DBG §3.3); assumed-fresh state is actually fresh (the reset happens, the cache invalidates, DBG §13.1); and invariants are preserved (AE §2.6 — the thing that must always be true stays true through every operation). State bugs are subtle (work in isolation, fail in sequence, DBG §3.2), so the reviewer traces the *sequences*, not just individual operations — what happens on the second call, after a failure, under concurrency.

**4.6 — Data integrity.** Whether durable data stays valid — the highest-stakes correctness dimension because corruption is silent, persistent, and poisons downstream (AE §5.6, DBG §3.10, [M16]). Check: writes are consistent (all-or-nothing, no half-states on crash, AE §5.6); data is validated as it becomes durable (at the trust boundary §6, AE §8.2 — corruption caught at entry, not discovered at read); concurrent writes can't corrupt (single-writer or proper coordination, AE §10.4); and the source of truth is protected (BE §5.2 — transient can be sloppy, durable cannot). Data-integrity findings are near-always blockers (§11.4) — the asymmetric tail [M16] makes them worth stopping for regardless of the change's other merits.

**4.7 — Regression risk.** Whether the change breaks something that worked (BE §7.5, DBG §11.5). Check: what existing behavior does this change touch (§3.5 blast radius), and could it break? are there tests pinning the behavior this might break (§4.8, FABLE §17)? does the change preserve the contracts callers depend on (§5.3, AE §4.7 — you may add, never break)? Regression risk is assessed by blast radius [M8] — a change to a widely-depended-on thing (§3.4 critical files) has high regression risk and warrants deep examination of what it might break, while an isolated change has low risk. The reviewer confirms the regression net exists (tests, §4.8) before trusting a change to widely-used code.

**4.8 — Tests as part of correctness review.** Review the tests as rigorously as the code (FABLE §25 — tests are code). Check: do the tests pin the *contract* (what callers rely on) or the *implementation* (welded to internals, punishing refactoring, FABLE §17)? would they *catch the bug this change could plausibly have* (DBG §6.3, OE §8 — a test that only exercises the happy path catches nothing at the edges §4.3)? can they actually *fail* (a green test that can't fail is worse than none — false confidence, FABLE §17, [M20])? is the fix for a bug pinned by a regression test (BE §7.5, DBG §2 Stage 7 — the fix without the test will return)? Tests are where correctness is *maintained* over time (BE §7.5) — so a change with weak tests is a change whose correctness will erode, and "add tests that would catch the plausible bug" is a common and important review finding.

---

# 5. Architecture Review

Whether the implementation matches and respects the architecture — the dimension most often missed (§10.4 architecture blindness) and among the most expensive when it is (a violation built upon becomes a rewrite, AE §6.3). AE establishes what the architecture *is*; this is how the reviewer checks the work *conforms* to it. The governing principle: **judge the change against the architecture's seams, contracts, and invariants — because a locally-correct change that violates the architecture is a correct-looking defect that will cost a structural fix later.**

**5.1 — How I determine whether implementation matches architecture.** Reconstruct what the change does structurally (RE §6.3 — from the code, not the description [M2]) and compare to what the architecture specifies (AE §3, §4 — the change should land in the right component, respect the right boundaries, honor the right contracts). The check: *does this change fit the architecture, or does it fight it?* A change that requires a workaround, that reaches across a boundary, that special-cases around a seam — these are signs the implementation is diverging from the architecture (AE §6.3 drift), and the review catches the divergence while it's one change, before it's the new normal (AE §6.3 — drift caught at the gate is cheap, drift found in year two is a rewrite). Where the change *reveals* the architecture is wrong (BE §1.4, §8.5 — construction teaching design), that's an architecture escalation (AE §6), not a rejection of the change.

**5.2 — Boundary violations.** A change that crosses a boundary it shouldn't (AE §3, §4.1) — a component reaching into another's internals, a layer depending on the wrong direction (AE §3.4), untrusted input reaching a privileged context (§6, AE §9.6). Check the change's *dependencies* — what does it now depend on, and is that dependency architecturally permitted? Boundary violations are often invisible in the local diff (the code looks fine) and only visible against the architecture (§3.5, §2 Stage 1 context) — which is why architecture blindness (§10.4) misses them. A boundary violation is usually a blocker (§11.4) — it erodes the seam the architecture depends on (AE §6.3), and letting one through normalizes the next.

**5.3 — Contract violations.** A change that breaks a contract callers depend on (AE §4.3, §4.7). Check: does the change alter an interface's behavior, remove a field, tighten an input, change an output — in a way existing callers rely on? Because a contract with callers is frozen (AE §4.7 — you may add, never break), a contract-breaking change is a high-blast-radius defect [M8] (it breaks callers not in the diff, §3.5) and near-always a blocker unless it's a deliberate, versioned, migration-managed change (AE §4.7). The reviewer checks contract changes against the callers (§3.5 — who depends on this, and does the change break them?) — a dimension only visible with the context (§2 Stage 1), invisible in the isolated diff.

**5.4 — Hidden coupling.** A change that introduces invisible dependencies (AE §10.8, DBG §5.5) — a shared global, an implicit ordering, an assumption two components now silently share. Check for coupling the change creates that isn't explicit in an interface (§5.3) — does this change make two things now depend on each other without a contract between them? Hidden coupling is the most insidious architecture defect (AE §10.8 — it breaks in ways that seem impossible, DBG §5.5) because it's invisible until it breaks. The reviewer hunts for it by asking *what does this change now assume about the rest of the system that isn't stated?* (DBG §1.4) — the answer names the hidden coupling.

**5.5 — Abstraction quality.** Whether the change's abstractions are right (AE §4, BE §5, [M13] rule of three). Check: is an abstraction being built for one caller (premature, [M13], BE §11.3 — a wrong abstraction is costlier than the duplication it replaced)? is an abstraction leaking its implementation (AE §10.3, BE §11.8 — a "seam" that mirrors what it wraps changes nothing)? is there genuine duplication that should be abstracted (the third instance, [M13], BE §11.4)? Abstraction findings are usually *suggestions* not blockers (§11.4 — a suboptimal abstraction in furniture is cheap to fix later) *unless* the abstraction is a wall [M6] (a public interface, a shared contract) where getting it wrong is expensive (AE §4.7 frozen once it has callers).

**5.6 — Future evolution.** Whether the change helps or hinders the system's ability to change (AE §1.3, §6). Check: does the change place seams where change will arrive (AE §6.1, PE §3.1), or does it weld things that should stay separate (AE §10.2)? does it make the *next* change easier or harder (BE §8.1 — "make the change easy")? does it respect replaceability (AE §6.4 — is the new component swappable, or does it lock in)? Future-evolution review is judging the change by its *ten-year carrying cost* [M15], not just its present correctness — a change that works now but ossifies the system is a defect that manifests later (AE §1.3, the cost-of-change rising with age). This dimension requires the architectural lens (§10.4) and is where a senior reviewer adds the most value a junior can't.

**5.7 — Long-term maintainability (architectural).** Whether the change keeps the system maintainable (AE §2.4 — serving the year-three maintainer). Check: does the change add carrying cost [M15] disproportionate to its value (a dependency AE §7.6, a config option BE §5.6, a special case, an abstraction §5.5 — each charges rent forever)? does it respect the boring-choice principle (AE §1.6, FABLE Law 10 — the clever moving part is a future failure)? does it leave the campsite documented (BE §4.9, docs current AE §6.2, FABLE Law 8)? Maintainability findings are the ones producers most resist (they feel like polish) and reviewers most owe (the maintainer isn't in the room, §1.4 — the reviewer represents them, AE §2.4).

---

# 6. Security Review

Whether the work is safe against misuse — the dimension with the most asymmetric stakes [M16] (a rare failure with catastrophic cost, §1.5) and therefore reviewed with the highest bar regardless of the change's other merits. AE §8 (failure-oriented design) and §9.6 (AI-native security) establish the structures; this is how the reviewer checks a change respects them. The governing principle: **think adversarially — not "does this work?" but "how would an attacker make this misbehave?" — because security defects have no symptom in normal operation (DBG §3.9), so they're found only by actively hunting them, never by confirming the work functions.**

**6.1 — Trust boundaries.** The most important security check (AE §8.2, §9.6). Identify where the change involves data or control crossing between trust levels (untrusted input → privileged action, external → internal, one component → another). Check: is the crossing *validated* (§6.2)? is the higher-trust side *structurally protected* from the lower (AE §8.2 — enforced by structure, not by the code being careful, [M12])? For AI systems, is untrusted content kept out of acting contexts (AE §9.6, the READER/ACTOR split, §9.4)? A change that blurs a trust boundary — lets untrusted data reach a privileged path, merges a reading and acting context — is a critical finding (§11.4, §11.8), because trust boundaries are where breaches happen (AE §8.2, DBG §3.9).

**6.2 — Input validation.** Whether input from outside is validated before use (AE §8.2 — every input from user, network, file, or model output is untrusted at the boundary). Check: is external input validated against its expected shape/range/type *before* it's trusted (§4.3 edges, from the security angle)? is validation at the boundary (so bad input is caught at entry, not discovered deep inside, §4.6)? Unvalidated input is the root of most injection (§6.6) and corruption (§4.6) — so a change that consumes external input without validating it is a security finding, its severity scaled by what the unvalidated input can reach (§6.1 blast radius).

**6.3 — Authentication.** Whether the change correctly establishes *who* is acting. Check: is authentication required where it should be (no unauthenticated path to protected action)? is it done correctly (not bypassable, not spoofable)? are credentials handled safely (§6.5)? Authentication findings are usually blockers (§11.4) — an authentication gap is an open door.

**6.4 — Authorization.** Whether the change correctly enforces *what the authenticated actor may do* (AE §8.6 least privilege). Check: is authorization enforced for every protected action (not just the obvious ones — the gap is usually the forgotten path)? is it *least privilege* (the actor gets the minimum access needed, so a compromise is contained, §6.7, AE §8.4)? For AI agents, does the agent have exactly the tools its role needs and no more (AE §9.3, OE §7 — an agent with more capability than its task needs is blast radius waiting)? Authorization gaps are blockers scaled by what the missing check protects.

**6.5 — Secrets.** Whether secrets are handled safely (AE §8.6, FABLE Law 9). Check: no secret in code, in config-committed-to-version-control, in logs, in error messages, or — for AI systems — in model context or memory (AE §9.6, §5.3; Law 9). Secrets belong only in a dedicated store, referenced not embedded. A secret in the diff (a hardcoded key, a password in a config file) is an immediate blocker (§11.4) and often requires rotation (the secret is now compromised by being committed, [M8] — it's in the history even if removed). This is a check a machine can partly do (secret-scanning, a ratchet [M12], §2 Stage 7) — but the reviewer checks the cases the scanner misses (a secret in an unusual form, a secret reaching a log).

**6.6 — Injection risks.** Whether untrusted input can be interpreted as commands (AE §8.2, and for AI the dominant class §6.9). Check: is untrusted input ever used to construct a command, query, path, or instruction without proper separation (data treated as data, never as code)? For AI systems, this is *prompt injection* (§6.9, AE §9.6) — the dominant AI security class. Injection findings are blockers scaled by what the injection can reach (§6.1) — and the structural defense (parameterization, the READER/ACTOR split AE §9.6) is preferred over the careful-coding defense [M12], so the review pushes for the structural fix, not a patch.

**6.7 — Privilege escalation.** Whether the change lets an actor gain access beyond their level (AE §8.4, §8.6). Check: can a lower-privilege actor reach a higher-privilege action through this change (the confused-deputy — a privileged component doing an unprivileged actor's bidding, AE §9.6)? does the change widen any actor's privilege beyond need (§6.4 least privilege)? Escalation paths are often subtle (a chain of individually-permitted actions that jointly escalate, [M8] radius creep) — the reviewer traces what an actor could *reach* through the change, not just what it's *meant* to do.

**6.8 — Supply-chain risks.** Whether the change introduces risk through its dependencies (AE §7.6, RE §5). Check: is a new dependency trustworthy (maintained, reputable, RE §4.4, FABLE §11)? is it pinned (so a malicious update can't silently enter, BE §I2)? does it bring transitive risk (its dependencies, its permissions)? A new dependency is a new trust relationship and a new attack surface (AE §7.6 — hiring, not shopping [M15]) — so adding one is a review-worthy decision (DE §7), and adding an unvetted or unpinned one is a finding.

**6.9 — AI-specific security.** The newest and, for AI-native systems, dominant security dimension (AE §9.6, DBG §3.9). Check: *prompt injection* — can untrusted content reach a context that can act (AE §9.6 — the READER/ACTOR split respected §9.4)? *memory poisoning* — can untrusted-derived content become trusted memory without quarantine (AE §5.3, §9.6, DBG §8.6)? *excessive agency* — does an agent have more tool access/blast radius than its task needs (§6.4, AE §9.3)? *missing human gate* — does an irreversible/outward action proceed without approval (AE §9.5, OE §9.2)? *egress* — can data exfiltrate to an unapproved destination (AE §8.2, the egress allowlist)? AI-specific security is where the review adds value no prior tradition covers — these are the failures (AE §9.6, DBG §3.9) that a classically-trained reviewer misses because they don't look like classical vulnerabilities. Reviewed with the highest bar (§1.5, [M16]) because AI systems with tools have real-world blast radius.

---

# 7. Performance Review

Whether the work performs acceptably — reviewed with the discipline of *not* optimizing prematurely (BE §10.1) while catching the performance defects that will actually bite. BE §10 establishes the build-time performance discipline; this is how the reviewer judges a change's performance. The governing principle: **judge performance against real requirements and real scale, not against a maximum — flag the algorithmic and scalability defects that will bite, and resist demanding optimization the requirement doesn't need (which trades clarity for speed nobody uses).**

**7.1 — Algorithmic complexity.** The performance dimension most worth reviewing because it's the one that bites at scale (DBG §3.8, §13.6). Check: what's the complexity of this change's operations, and how does it scale with the input? An O(n²) that's fine at today's n and catastrophic at tomorrow's is a latent performance bug (DBG §13.6 — the algorithmic assumption that was true when written). The reviewer checks complexity *against the realistic input size* (§7.2) — flagging the quadratic-on-growing-input, the N+1, the nested loop over large collections. This is high-value review because complexity defects are cheap to catch in review (visible in the code) and expensive to catch in production (DBG §13.6, a regression bisect after it's slow).

**7.2 — Scalability.** Whether the change holds up as load/data/usage grows (AE §5.4 scale-shift). Check: does the change assume a scale that won't hold (this fits in memory, this completes in time, this handles the concurrency)? does it scale with the dimension that will actually grow? Scalability review is judging against the *future* realistic scale, not the present test scale — a change that works at test scale and fails at production scale (DBG §9.3 — the class that only appears in production) is a defect the review can catch by asking "what happens at 100× this?"

**7.3 — Memory usage.** Whether the change uses memory acceptably (DBG §3.4). Check: does it leak (memory held that should be freed, DBG §3.4 — degradation over time §8.10)? does it hold more than needed (loading everything when streaming would do)? does it scale memory with input unboundedly? Memory findings scale with the system's constraints (a memory leak in a long-running system is critical, DBG §8.10; in a short-lived process, minor).

**7.4 — Concurrency.** Whether concurrent code is correct *and* performant (DBG §3.3). The correctness of concurrency is a §4.5 state check (races, AE §10.4); the *performance* of concurrency is here — does the change serialize what could be parallel (a lock held too long, a bottleneck [M10])? does it create contention (many things competing for one resource, PE §4.1)? Concurrency review is hard (DBG §3.3 — the bugs are non-deterministic) so the reviewer examines concurrent changes with extra rigor (§3.6), checking both that it's correct (§4.5) and that it doesn't create a bottleneck (§7.1).

**7.5 — Resource usage.** Whether the change uses other resources (connections, file handles, API budget, disk) acceptably. Check: are resources released (not leaked, the connection/handle closed)? is a limited resource (rate-limited API, connection pool) respected (§7.4 contention)? For AI systems, is the *cost* acceptable (OE §10 — a change that routes expensive-tier inference where cheap would do, or loops without bound OE §12.5, is a cost defect)? Resource findings scale with the resource's scarcity and cost.

**7.6 — Latency.** Whether the change meets latency requirements (BE §10, where a human or a critical path waits, OE §4.4). Check: does the change add latency on a path where it matters (interactive, critical-path PE §4.2)? is the latency within the requirement? Latency review is against the *requirement* (§7.8 — is there a latency need this violates?), not against "faster is better" (§10.5 — optimizing latency nobody needs is waste).

**7.7 — Caching.** Whether caching (if present) is correct and worthwhile. Check: is the cache *correct* (invalidated when the source changes — the stale-cache bug DBG §13.1 is a top defect, and a caching change warrants a §4.5 state review of its invalidation)? is it *worthwhile* (the cache's carrying cost [M15] — the complexity, the invalidation risk — justified by the performance it buys)? Caching is a classic premature-optimization (BE §10.1) and a classic correctness hazard (invalidation, DBG §13.1) — so the reviewer checks both that it's needed and that it's correct.

**7.8 — Profiling assumptions (resisting premature optimization).** The reviewer's performance-discipline check (BE §10.1, [M10]): is the change optimizing something *measured* to be a bottleneck, or *assumed* to be one? A change that adds complexity for performance without a measurement showing the need (BE §10.2, [M10] — intuition about bottlenecks is usually wrong) is *premature optimization* — and the review should flag it (the complexity is real, the benefit is unproven). Conversely, the reviewer doesn't *demand* optimization the requirement doesn't need (§10.1, §10.5 — that's the reviewer imposing premature optimization). The discipline is symmetric: catch the performance defects that will bite (§7.1 measured or clearly-scaling), and resist both adding and demanding optimization that no requirement justifies (BE §10, [M10]).

---

# 8. Maintainability Review

Whether the work can be understood and changed by the future stranger [M18] — the dimension that determines the system's long-term cost (FABLE §21, AE §2.4) and the one producers most resist (it feels like polish) and reviewers most owe (the maintainer isn't in the room). FABLE §16 (naming), §18 (refactoring), §19 (repository), BE §4–§5 establish the standards; this is how the reviewer judges against them. The governing principle: **judge whether the year-three maintainer [M18] could safely change this — because maintainability is the system's dominant lifetime cost (FABLE §21), and the reviewer is the only one representing the maintainer who isn't in the room.**

**8.1 — Readability.** Whether the code communicates its intent to the stranger (BE §5.8, [M18]). Check: can I understand what this does without the producer explaining it? are the names truthful (§8.2)? does the structure mirror the problem (BE §5.8)? are comments where the code can't speak (the *why*, not narrating the *what* — FABLE §25, BE §5.8)? A readability finding is justified when the code is *harder to understand than the problem warrants* (BE §5.7 accidental complexity) — not when it's merely different from how the reviewer would write it (§10.1). The test: *would the year-three maintainer understand this under pressure?* [M18].

**8.2 — Naming.** Whether names are truthful and clear (FABLE §16). Check: do names mean what they say (a name that lies is active misinformation, FABLE §16)? is one concept named one way consistently (not drifting synonyms, FABLE §16 — each synonym doubles vocabulary load)? do names make wrong usage look wrong (FABLE §16)? Naming findings are high-value-low-cost (a name is the cheapest documentation, read the most, FABLE §16) — so "rename this to what it actually is" is a common, worthwhile finding, especially for anything that will be referenced for years (a public name, §8.1 readability).

**8.3 — Documentation.** Whether the durable record is updated with the change (FABLE Law 8, AE §6.2, BE §9.6). Check: are the docs/decisions/registry updated *in this change* (not deferred, FABLE Law 8 — deferred docs don't happen, BE §14 documentation-bankruptcy)? does the change record its *why* (AE §6.2, [M18] — the what is the diff, the why is what the maintainer needs)? are stale docs the change should have updated left stale (a wrong doc is worse than none, FABLE §26)? Documentation findings are owed because the reviewer represents the future reader who has only the record (§1.4, [M18]).

**8.4 — Module cohesion.** Whether the change keeps modules cohesive (AE §3.5, BE §5.4 — one reason to change). Check: does the change add to a module something that doesn't belong (reducing cohesion — the module now changes for another reason)? or scatter across modules something that should be together (BE §12.6)? Cohesion findings judge whether the change respects the decomposition (AE §3) — a change that puts logic in the wrong place is a maintainability defect (the next maintainer looks in the cohesive place and doesn't find it).

**8.5 — Coupling.** Whether the change minimizes coupling (AE §3.4, BE §5.7). Check: does the change add coupling (a new dependency between things that should be independent)? is the coupling explicit and one-directional (AE §3.4 — or hidden §5.4, which is the dangerous kind)? Coupling findings overlap with architecture (§5.4 hidden coupling) — the maintainability angle is that coupling is what makes future change propagate (AE §3.4), so a change that adds coupling raises the system's future cost of change (AE §1.3).

**8.6 — Technical debt.** Whether the change takes debt responsibly (BE §4.8, PE §7.3). Check: does the change take a shortcut, and if so, is it *recorded with a trigger* (BE §4.8 — unrecorded shortcuts are landmines [M12])? is the debt on furniture (acceptable) or a wall (must be flagged as blocking, BE §4.8, [M6])? does the change *add* to existing debt around it (making a bad situation worse) or reduce it (campsite rule, FABLE §18)? Debt findings distinguish *recorded* debt (legitimate, FABLE §12) from *silent* debt (a defect) — the review's job is to ensure shortcuts are recorded and triggered, not to forbid all shortcuts (which would forbid legitimate speed).

**8.7 — Testability.** Whether the change is testable (FABLE §17, AE §3 — hard to test means the seams are wrong). Check: can this change be tested in isolation, or does it require standing up the world (a sign of poor seams, AE §3, PE §3.1)? are there tests, and do they pin the contract (§4.8)? A change that's hard to test is a change whose correctness can't be maintained (§4.8) — so "this is hard to test, which suggests the design needs a seam" is both a testability and an architecture finding (§5).

**8.8 — Refactoring opportunities.** Whether the change should include a refactoring, or whether it *is* an inappropriate one (FABLE §18, BE §8). Check: does the change make a nearby thing better while it's here (campsite rule, FABLE §18 — a suggestion, not a blocker)? or does it mix refactoring with behavior change (BE §8.2 — a finding: separate them, so each is reviewable)? or does it refactor for beauty alone (FABLE §18, BE §8.2 — a finding: refactoring needs a purpose)? Refactoring findings are usually suggestions (§11.4) unless the change dangerously mixes refactoring with behavior (BE §8.2 — that's a blocker to the reviewability, "split this").

**8.9 — Repository hygiene.** Whether the change keeps the repository clean (FABLE §19, BE §4.7). Check: no dead code, no commented-out corpses (delete, don't comment, FABLE §19), no stale docs left by the change (§8.3), no debris (BE §4.7 — the repository contains only what's true and live). Hygiene findings are often machine-catchable (a ratchet [M12], §2 Stage 7, FABLE §19) — so the reviewer flags what the machine missed and, for recurring hygiene issues, pushes for the ratchet rather than catching it by hand each time.

---

# 9. AI-Native Review

Reviewing the artifacts that had no review tradition when I was written — AI-generated code, prompts, MCP servers, orchestrations, and the rest. This gets the most depth because a successor will find the least prior art. The governing principle: **AI-native artifacts fail in AI-native ways (DBG §8, OE §12), so they're reviewed for AI-native defects — and AI-generated code specifically is reviewed *more* skeptically, not less, because its fluency masks its errors (RE §5.3, [M1]).**

**9.1 — Reviewing AI-generated code.** Code produced by a model (including by me) is reviewed *more* skeptically than human code, for a specific reason: it is *fluent* — plausible, well-structured, confident — in a way that masks its errors (RE §5.3, [M1] — confabulation feels identical to correctness from the outside). The specific defects to hunt: *confabulated specifics* (an API/flag/method that doesn't exist, RE §5.3 — verify against reality [M2], the fluent code may call a plausible-but-nonexistent thing); *happy-path completeness with edge-case absence* (AI code often handles the center beautifully and the edges §4.3 not at all, because it pattern-matched the common case); *subtle correctness errors in plausible-looking logic* (§4.2 — trace it, don't trust that it looks right); *overengineering* (BE §11.2 — AI code tends to add abstraction and generality nobody asked for, §5.5); and *plausible-but-wrong integration* (it looks like it fits, verify it actually does, §5). The discipline: *AI-generated code's fluency is not evidence of correctness — it's the exact thing that makes its errors dangerous* [M1], so review it by verifying against reality (§2 Stage 3, [M2]), not by being reassured by how right it looks.

**9.2 — Reviewing prompts.** A prompt is an interface with a nondeterministic component (RE §30) — reviewed as a contract (AE §4) and as an instruction. Check: is it *explicit* (states what to do, not just what to avoid, RE §30)? is the load-bearing instruction where attention is highest (RE §30 — not buried mid-list)? does it handle the awkward cases (RE §30 — tested on the edge inputs, not just the happy path)? is it *model-agnostic* (RE §30, FABLE §15 — not exploiting one model's quirks, so it survives model replacement)? does it leak trust boundaries (§6.9 — does it place untrusted content where it can override instructions, AE §9.6)? Review prompts by reading the *assembled* prompt (DBG §8.2 — the actual text, not the template [M2]) and, for high-stakes prompts, testing them on real inputs (RE §30 — a prompt untested on the awkward case fails on it).

**9.3 — Reviewing MCP servers.** An MCP server is a capability behind a protocol (AE §9.10) — reviewed as an *integration* (§5.3 contract) and as *ordinary software* (§4–§8) and for *AI-specific security* (§6.9). Check: does it honor the MCP contract (AE §4.3, §9.10)? is its tool surface *scoped* (least privilege, §6.4, AE §9.3 — does it expose more capability than needed)? are its tools correctly *tagged* by trust/blast-radius (read vs write vs send, AE §9.6, OE §7 — so the READER/ACTOR split can enforce)? does it validate its inputs (§6.2 — an MCP server consumes what an agent sends, which may be driven by untrusted content §6.9)? MCP servers are a trust boundary (§6.1) and a capability grant (§6.4) — reviewed with security rigor because they're what give agents their power to act (AE §9.3).

**9.4 — Reviewing A2A systems.** Agent-to-agent coordination (AE §9.10) — reviewed for the coordination failures (OE §12.3–12.9) and the trust boundaries between agents. Check: do agents coordinate through inspectable durable state or through opaque messaging (OE §3.5, §7.4 — state-mediation preferred, mesh-messaging is a coordination-collapse risk OE §12.8)? is ownership clear (OE §7.6, AE §3.3 — ambiguous ownership is the multi-agent shared-mutable-state §5.4)? is trust between agents appropriate (an agent shouldn't blindly trust another agent's output any more than it trusts a model's, OE §8 — verification independence)? A2A review checks the *coordination architecture* (AE §9.3), not just the individual agents.

**9.5 — Reviewing orchestration.** An orchestration (OE) — reviewed for the orchestration failures (OE §12) and the orchestrator's responsibilities (OE §1.4). Check: is verification independent and scaled to stakes (OE §8, §8.1 — high-stakes output not self-certified §1.1)? are human gates at the blast-radius boundaries (OE §9.2, AE §9.5)? is routing sensible (OE §4 — right capability for the task, cost-appropriate OE §10)? is context managed (OE §5 — assembled deliberately, not accumulated, isolated per-agent §5.2)? is state preserved for continuity and recovery (OE §5.3, §11.4)? Orchestration review judges whether the *system of intelligences* is sound (OE §1.1) — a well-built individual agent in a badly-orchestrated fleet produces the coordination failures (OE §12) that the review must catch.

**9.6 — Reviewing Graphify integrations.** A knowledge-graph integration (AE §9.8, OE §6.2) — reviewed for correct placement in the recall architecture and correct query use. Check: is the graph a *rebuildable index over a neutral store* (AE §5.4, §9.8 — not the sole source of truth, Law 4), so it's replaceable and its loss isn't data loss? is it used for the right question-shape (relationship/connectivity questions, OE §6.3 — not for lookups full-text would serve, §11.8)? is there a baseline fallback (AE §9.8 — full-text, so the system degrades gracefully if the graph is unavailable, AE §8.7)? does the graph carry provenance/trust (AE §5.3 — so graph-derived answers are traceable)? Graphify review checks it's an *enhancement* over a guaranteed baseline (AE §9.8), never a lock-in or a single point of recall failure.

**9.7 — Reviewing memory systems.** An AI memory system (AE §5.3, DBG §8.6) — reviewed for the memory failures (DBG §8.6, OE §12.7) and the store/index separation. Check: is the store neutral and the index rebuildable (AE §5.3 — memory survives technology replacement)? does memory carry *provenance, confidence, and dating* (AE §5.3, [M1] — so recalled memory is known to be trusted/current, RE §5.2)? is untrusted-derived memory *quarantined* (AE §5.3, §9.6 — so it can't silently become trusted instruction, the persistent-injection failure DBG §8.6)? is there consolidation (FABLE §7 — so memory doesn't rot, DBG §8.10)? Memory review checks the system won't poison itself over time (DBG §8.6, §8.10) — the highest-stakes long-running AI failure.

**9.8 — Reviewing autonomous workflows.** Workflows that act without real-time human oversight (OE §15.6, DBG §8.9) — reviewed with the highest bar because failures aren't caught in the moment (DBG §8.9). Check: are irreversible/outward actions *gated* (OE §9.2, AE §9.5 — the outbox, nothing catastrophic without approval)? are there *guardrails* against the autonomous failures (loop bounds OE §12.5, drift checks OE §12.6, escalation on uncertainty OE §8.5, §9.1)? does the workflow *journal* its actions and reasoning (DBG §8.9, OE §11.7 — so post-hoc debugging is possible)? is the blast radius of the *worst* autonomous behavior bounded (AE §8.4 — what's the worst this can do unsupervised, and is that survivable [M16])? Autonomous-workflow review is where the reviewer most represents the human who bears the downside (OE §9, DE §10.6) — the bar is "would I let this act unsupervised on my behalf?"

---

# 10. Review Anti-Patterns

Named for in-flight detection. Each carries its signal and cure. These are how review fails — and several are seductive because they *feel* like reviewing while defeating its purpose.

**10.1 — Nitpicking.** Flooding the review with trivial findings while missing the important ones. *Signal:* many low-severity findings (style, preference, minor naming) and few or no findings on correctness/architecture/security. *Cure:* prioritize by stakes (§3.6) — spend attention on the walls [M6], not the furniture; a finding must have a real failure scenario (§1.4.5, FABLE §25) to be worth raising. Nitpicking is dangerous because it *feels* thorough while examining the trivial — and it buries any real finding among the noise (§10.5), and it exhausts the producer's attention on the unimportant.

**10.2 — Rubber-stamping.** Approving without genuine examination. *Signal:* fast approval with no findings on work complex enough to warrant them; approval you couldn't defend (§1.4.6 — you didn't examine it enough to stake your judgment). *Cure:* an approval is a claim that you examined it and it's sound (§1.4.6, [M20]) — if you can't make that claim honestly, you haven't reviewed it. Rubber-stamping is *worse than no review* — it manufactures false confidence [M20] (everyone believes it was checked; it wasn't), which is how defects reach production with a green checkmark.

**10.3 — Confirmation bias.** Reading to confirm the work is correct rather than to find where it's wrong (DBG §10.1, RE §9.5). *Signal:* you read the code, it looked reasonable, you approved — without hunting for the failure (§4). *Cure:* review adversarially (§4, §9 — hunt for what's wrong, [M16] inversion); the producer already believes it's right (that's why they submitted it), so the review's value is bringing the *disconfirming* mind (§1.1). Confirmation bias produces reviews that catch nothing because they never looked for anything.

**10.4 — Architecture blindness.** Reviewing only the local correctness of the diff, missing the architectural impact (§3.5, §5). *Signal:* findings only on the lines changed, none on what the change touches, violates, or couples (§3.5, §5). *Cure:* review the blast radius (§3.5, [M8]) against the architecture (§5, §2 Stage 1 context) — the expensive defects (boundary violations §5.2, contract breaks §5.3, hidden coupling §5.4) are invisible in the isolated diff and visible only against the architecture. Architecture blindness is the most *expensive* review miss because the defects it misses become structural (AE §6.3 drift → rewrite).

**10.5 — Style obsession.** Spending review attention on formatting and style a machine should check (§1.3, FABLE §19). *Signal:* findings about formatting, brace placement, import order — things a linter catches (BE §7.2). *Cure:* machines do style (FABLE §19 — a ratchet [M12], §2 Stage 7); the reviewer's scarce attention goes to what machines *can't* check (correctness, architecture, security, §4–§6). Style obsession wastes the expensive resource (human/AI judgment) on the cheap problem (formatting) while the expensive problems (correctness) go under-examined — a mis-allocation exactly like §3.6 inverted.

**10.6 — Ignoring systemic issues.** Catching instances while missing the class (§5.6-thinking, DBG §5.6, §10.10). *Signal:* the same kind of finding recurs across reviews and nothing is done to prevent the class. *Cure:* for a recurring defect, capture the class and ratchet it (§2 Stage 7, [M12] — a lint rule, a test pattern, a checklist line, or an architecture fix AE §6). Ignoring systemic issues means reviewing the same defect forever, one instance at a time (DBG §10.10 — a losing game) — the review's leverage is *preventing* the class, not catching its instances.

**10.7 — Late review.** Reviewing after the work is deeply built upon, when changing it is expensive (PE §5.3, AE §1.5). *Signal:* the review happens after much is built on the reviewed work, so findings are costly to act on and pressure mounts to approve-anyway. *Cure:* review *early and incrementally* (PE §5.3, BE §3.7 — small increments reviewed as they're built, when changing them is cheap); review the architecture *before* it's built upon (AE — the cheapest defect to fix is a design defect, PE Stage 9). Late review produces rubber-stamping (§10.2 — it's too expensive to change now) — the review's power is proportional to how early it happens.

**10.8 — Review fatigue.** Attention degrading over a long review or many reviews, so later parts get less scrutiny (§2 standing discipline). *Signal:* the first files reviewed carefully, the last skimmed; quality dropping as the review lengthens. *Cure:* bound the review (§3.3 — a diff too large to review well should be split, BE §13.3); prioritize (§3.6 — if attention is finite, spend it on the critical files §3.4 first, so fatigue hits the furniture not the walls); and recognize fatigue as a signal to stop and resume fresh rather than push through (DBG §2 stall protocol applied to review). Review fatigue is why large diffs get shallow reviews (§10.7) — the discipline is to keep reviews small enough to review well.

**10.9 — Overconfidence.** Approving with more certainty than the examination justifies ([M20], DBG §10.7). *Signal:* confident approval of complex/high-stakes work examined quickly; no acknowledgment of what wasn't verified. *Cure:* calibrate — an approval carries the confidence the examination earned ([M20]), and honest review says what was and wasn't examined (§1.4.6 — "I verified the logic and edges; I did not exercise the concurrency under load"). Overconfidence in review is the trust-destroying failure ([M20]) — it's the rubber stamp (§10.2) wearing the costume of thoroughness, and its cost lands when the confidently-approved work fails.

**10.10 — The reviewer-as-rewriter.** Rejecting work because it's not how the reviewer would have done it, absent any dimension on which it's actually worse (§1.3). *Signal:* findings that amount to "I'd have done this differently" with no failure scenario, no objective dimension (§4–§8) on which the work is worse. *Cure:* review fitness, not preference (§1.3, §1.4.1) — if the work is correct, sound, and fit (§4–§8), it's approvable regardless of matching the reviewer's style; "different from how I'd do it" is not a finding unless "differently" is *better* on a dimension that matters. This anti-pattern demoralizes producers, wastes cycles rewriting working code, and reveals the reviewer confused their aesthetic for a standard.

---

# 11. Review Decision Trees

Built per [M7 → skill S-007]. Review-specific; defer to prior engines where the decision is theirs.

**11.1 — Approve vs Request Changes vs Block**
```
Are there BLOCKER findings? (correctness on a wall §4, security §6, irreversible risk, data integrity §4.6, contract break §5.3)
  ├─ yes → REQUEST CHANGES / BLOCK; the blockers must be resolved before proceeding (§1.4.5, §11.4)
  └─ no → are there non-blocking findings (suggestions, minor improvements)?
            ├─ yes → APPROVE WITH SUGGESTIONS (offer them; they don't gate — §11.4) if the work is fit (§4–§8)
            └─ no → APPROVE — but only if I examined it enough to stake my judgment (§1.4.6, [M20]); if not, that's the finding
```

**11.2 — Architecture vs Implementation (which lens for this finding)**
```
Does the concern involve a seam / contract / boundary / invariant / format? (§5, AE)
  ├─ yes → ARCHITECTURE finding (§5) — higher stakes [M6], likely blocker if violated (§11.4); may escalate to AE (§5.1, BE §8.5)
  └─ no → IMPLEMENTATION finding (§4, §7, §8) — judged by its own severity; correctness on a wall blocks, furniture doesn't
```

**11.3 — Minor vs Major**
```
What is the finding's blast radius × reversibility? ([M8], [M11], §3.6)
  ├─ high blast radius OR irreversible (wall §6/§4.6/§5.3) → MAJOR; likely blocker (§11.4)
  └─ contained AND reversible (furniture) → MINOR; suggestion, not blocker — cheap to fix later, don't gate on it
```

**11.4 — Blocker vs Suggestion**
```
If this ships unfixed, what happens?
  ├─ correctness failure / security hole / data loss / broken contract / irreversible harm → BLOCKER (must fix before merge)
  ├─ degraded maintainability / performance-that-doesn't-yet-bite / suboptimal-but-working → SUGGESTION (offer, don't gate)
  └─ pure preference, no failure scenario → NOT A FINDING (§10.1, §10.10 — drop it)
   (rule: a BLOCKER has a concrete failure scenario at stakes that justify stopping; everything else is a suggestion, FABLE §25)
```

**11.5 — Refactor-now vs Accept-with-debt**
```
Is the code's current structure a problem NOW (blocks correctness/security) or LATER (maintainability)?
  ├─ now → REFACTOR required before merge (it's a blocker, §11.4)
  └─ later → is it on a wall (built-upon, hard to change later) or furniture? [M6]
              ├─ wall → refactor now or the debt compounds structurally (BE §4.8, §5.6) — lean toward requiring it
              └─ furniture → ACCEPT WITH RECORDED DEBT (BE §4.8 — a ticket + trigger), don't block working code for later-polish
```

**11.6 — Risk vs Reward (approving imperfect work)**
```
Does the work's value justify its residual risk, and is the risk reversible? ([M11], [M16])
  ├─ risk irreversible/catastrophic (data, security) → the asymmetric tail [M16] dominates; don't approve on "probably fine"
  └─ risk reversible/contained → approve if value justifies it and the residual risk is recorded (BE §4.8);
        perfect is the enemy of shipped (FABLE §20 — don't block reversible good-enough work for unreachable perfect)
```

**11.7 — Performance vs Simplicity**
```
Is there a MEASURED performance need this simplicity violates? (§7.8, BE §10, [M10])
  ├─ yes → the performance need wins for that specific bottleneck; but demand only what's measured, not speculative (§7.8)
  └─ no → SIMPLICITY wins (BE §5.7, §10.1 — don't approve added complexity for unmeasured performance §7.8, and don't
          demand optimization no requirement needs §10.5)
```

**11.8 — Security vs Convenience**
```
Does the convenient approach weaken a trust boundary / validation / least-privilege / gate? (§6)
  ├─ yes → SECURITY wins (§1.5, [M16] — the asymmetric tail; convenience never justifies an exploitable hole);
  │         push for the structural defense (§6.6, AE §9.6), not a careful-coding patch [M12]
  └─ no → the convenience is fine; not every convenience is a security tradeoff (don't invent security findings §10.1)
```

---

# 12. Review Checklists

The engine compressed. Run the long form (§2–§9) until reflex.

**12.1 — Before approving work (the approval gate)**
- [ ] Does it do what was ASKED — verified against intent, not just against the description? (§4.1, FABLE §25)
- [ ] Correctness at the EDGES — empty/huge/malformed, error paths, state sequences? (§4.3, §4.4, §4.5)
- [ ] Data integrity and regression risk assessed for anything touching durable data or widely-used code? (§4.6, §4.7)
- [ ] Blast radius beyond the diff examined against the architecture — boundaries, contracts, coupling? (§3.5, §5)
- [ ] Security: trust boundaries, input validation, secrets, injection, least privilege, AI-specific (§6, §6.9)?
- [ ] Performance defects that will bite (complexity, scale) — without demanding unmeasured optimization? (§7.1, §7.8)
- [ ] Maintainability: readable, named truthfully, documented, testable — could the year-three maintainer change it? (§8, [M18])
- [ ] For AI-generated code: reviewed MORE skeptically, specifics verified against reality, edges checked? (§9.1, [M1])
- [ ] Did I examine it enough to STAKE MY JUDGMENT on this approval? (§1.4.6, §10.2, [M20])
- [ ] Was my attention spent on the walls, not the furniture? (§3.6 — or did I nitpick §10.1 / go architecture-blind §10.4?)

**12.2 — Before requesting changes**
- [ ] Does each finding have a concrete FAILURE SCENARIO — or is it a style opinion? (§1.4.5, FABLE §25, §10.1)
- [ ] Is each finding verified against the actual code — am I sure, or crying wolf? (FABLE §25, §10.9)
- [ ] Are findings ranked by severity — blockers first, so they land? (§2 Stage 6, FABLE §25)
- [ ] Is each finding located and specific enough to act on? (§2 Stage 6)
- [ ] Am I requesting fitness, not preference — is each finding actually BETTER, not just different? (§10.10, §1.3)
- [ ] For blockers: is this genuinely blocking (§11.4), or am I gating reversible good-enough work on perfect? (§11.6, FABLE §20)

**12.3 — Before merging**
- [ ] Are all BLOCKERS resolved (not just discussed)? (§11.4)
- [ ] Does it actually build/pass/work — verified, not assumed (BE §7, [M2])?
- [ ] Is recorded debt actually recorded with triggers (not just promised)? (§8.6, BE §4.8)
- [ ] Are docs/decisions/registry updated in this change, not deferred? (§8.3, FABLE Law 8)
- [ ] No secrets, no dead code, no unrelated drive-by changes riding along? (§6.5, §8.9, BE §13.3)

**12.4 — After merge**
- [ ] For systemic findings: is there a RATCHET so the class can't recur, not just this instance fixed? (§2 Stage 7, §10.6, [M12])
- [ ] Did the review miss anything that surfaced later — and what would have caught it? (feed the next review, RE §1.5)
- [ ] Is any follow-up (recorded debt §8.6, deferred suggestion) tracked so it's not lost? (BE §4.8)
- [ ] For high-stakes merges: is it observable — will I know quickly if it's misbehaving in production? (FABLE §20, DBG §9.3)

---

# 13. Real Engineering Examples

Complete reviews, showing the engine running — every decision, concern, approval, and requested change. Read as the review proceeding.

**13.1 — A desktop application (a feature PR).**
- *Preparation (§2 Stage 0):* the PR claims to add data export; tier is moderate (a feature, reversible, but touches the data layer §3.4). Depth: careful on the data handling, light on the UI.
- *Context (§2 Stage 1):* the app's architecture (AE §13.1 — inward dependencies); the export touches the data layer (a critical file §3.4).
- *Reading (§3, FABLE §25):* does-it-export-what-was-asked (§4.1 — yes, verified against intent); then edges (§4.3) — what does it do with empty data, huge data, data containing special characters (the export format's escaping §4.6)?
- *Findings:* BLOCKER (§11.4) — the export doesn't escape special characters, corrupting the output file for certain data (§4.6 data integrity, with a concrete failure scenario FABLE §25). SUGGESTION — the export runs on the UI thread, freezing the app for large data (§7.4, a performance concern, but reversible §11.6, offered not gated). 
- *Decision:* request changes (the escaping blocker §11.1). *Approval* after the escaping is fixed and pinned by a test (§4.8).

**13.2 — A large pull request.**
- *First finding, often (§3.3, BE §13.3):* "this is too large to review well — split it." A PR mixing a refactor with a feature (BE §8.2) can't be reviewed cleanly (the reviewer can't isolate what to judge §3.3) — the first request is to separate them.
- *If it can't be split:* triage (§3.3) — identify the critical files (§3.4, the architectural and data changes) and review those deeply; verify the mechanical parts (a bulk rename) by checking the pattern once and spot-checking; skim the furniture.
- *Attention discipline (§10.8):* review the critical files *first* (§3.4), so fatigue hits the furniture, not the walls. Bound the review; resume fresh if fatiguing.
- *The risk (§10.7):* a large PR pressures rubber-stamping (§10.2 — too much to examine, so approve-anyway). The discipline is to resist — a large PR examined shallowly everywhere has its critical parts under-reviewed, so either it's split (reviewable) or the critical parts get real depth even if the furniture is skimmed.

**13.3 — A distributed system (a change to inter-node communication).**
- *Stakes (§2 Stage 0):* high — inter-node communication is a wall [M6] (contract §5.3, and the distributed failure modes DBG §3.11 have wide blast radius).
- *Architecture review (§5):* does the change alter a contract nodes depend on (§5.3, AE §4.7 — a contract change breaks nodes not in the diff §3.5)? Is it backward compatible (§5.3 — can old and new nodes coexist during rollout)?
- *Correctness at the distributed edges (§4.4, DBG §3.11):* what happens on partial failure, retry, reorder, duplication (DBG §3.7 — the network-is-reliable assumption)? Is the change idempotent where retries can occur (DBG §13.2)?
- *Findings:* BLOCKER — the change isn't backward compatible, so a rolling deploy breaks (§5.3, a concrete failure at rollout). BLOCKER — a retry path isn't idempotent (§4.5, DBG §13.2 — duplication under retry).
- *Decision:* request changes; both are walls with irreversible-at-scale consequences (§11.3, §11.6 — the asymmetric tail [M16]).

**13.4 — A multi-agent AI platform (an orchestration change).**
- *AI-native review (§9.5):* is verification independent and scaled to stakes (OE §8 — is high-stakes agent output self-certified §1.1, a defect)? Are human gates at the blast-radius boundaries (OE §9.2 — does an irreversible action proceed without approval)?
- *Coordination (§9.4, OE §12):* do agents coordinate through inspectable durable state or opaque messaging (OE §7.4 — mesh messaging is a coordination-collapse risk §10.6 systemic)? Is ownership clear (OE §7.6 — ambiguous ownership → duplicate/conflicting work)?
- *Findings:* BLOCKER — an agent with `send` capability also reads untrusted web content (§6.9, AE §9.6 — the READER/ACTOR split violated, a critical injection vector). SUGGESTION — verification is single-vote where the stakes warrant a panel (OE §8.4).
- *Decision:* request changes (the trust-boundary blocker §6.9, §11.8 — security over convenience). *Knowledge capture (§2 Stage 7):* this READER/ACTOR violation is a *class* — ratchet it (an injection canary suite, BE §14.2, [M12]) so it's caught automatically, not by review each time (§10.6).

**13.5 — An open-source project (a community contribution).**
- *Context (§2 Stage 1):* the project's conventions and architecture (FABLE §19, AE) — the contribution must fit them, and the reviewer represents the project's standards (§1.2).
- *Fitness, not preference (§10.10):* the contributor's style may differ from the maintainer's; review whether it's *fit* (§4–§8, correct and sound), not whether it matches the maintainer's taste — rejecting working, fitting code for style is the reviewer-as-rewriter anti-pattern (§10.10).
- *Contract stability (§5.3, AE §4.7):* does the contribution change a public interface the project's users depend on (frozen, §5.3 — additions only)? 
- *Findings:* SUGGESTION — align naming with the project's convention (§8.2, one-concept-one-name FABLE §16). BLOCKER — the change breaks a public contract without versioning (§5.3, AE §4.7 — breaks downstream users §3.5).
- *Decision:* request changes (the contract break); the naming is a suggestion (§11.4). *Feedback (§2 Stage 6):* clear and welcoming — the contributor is a volunteer, and the feedback teaches the project's standards (§1.2).

**13.6 — A reverse-engineering project (a change based on a reverse-engineered model).**
- *Context (§9, RE §7):* the change integrates with a reverse-engineered protocol (RE §7.3) — the change is only as correct as the *model* of the protocol (DBG §9.8 — the model may be wrong, not the change).
- *Correctness against reality (§4.1, [M2]):* is the change verified against the *actual* target behavior (RE §7.1 predict-and-test), or only against the reverse-engineered model (which may have gaps DBG §9.8)?
- *Findings:* the change assumes a protocol field is optional based on the reverse-engineered model; the review asks — was this verified against the real target, or assumed from incomplete observation (§9.1, RE §9.4, [M1] — the reverse-engineered model is a hypothesis, RE §7.1)?
- *Decision:* request verification against the real target before approving (§4.1 — a claim resting on an unverified model, [M2]). *The review's value here:* catching that the change's correctness depends on a model that was never confirmed (DBG §9.8, §10.6 systemic — the whole integration rests on the model's accuracy).

**13.7 — A security-sensitive change.**
- *Highest bar (§1.5, §6, [M16]):* security's asymmetric stakes mean this is reviewed with maximum rigor regardless of the change's size — a one-line security change can be more consequential than a thousand-line feature.
- *Adversarial review (§4, §9):* not "does this work?" but "how would an attacker defeat this?" (§6 — security has no symptom in normal operation DBG §3.9, so it's found only by hunting).
- *The full §6 sweep:* trust boundaries (§6.1), input validation (§6.2), auth (§6.3, §6.4), secrets (§6.5), injection (§6.6), escalation (§6.7), supply chain (§6.8), AI-specific (§6.9).
- *Independent verification (OE §8, §9):* a security-sensitive change gets *cross-model* or *multiple independent* review (OE §8.3, §8.4 — the asymmetric stakes justify the strongest verification), and the reviewer prefers *structural* defenses (§6.6, AE §9.6 [M12]) over careful-coding patches.
- *Decision bar (§11.8):* security wins over convenience, always; approval requires the reviewer to have *hunted* for the vulnerability and not found it (§10.9 — not merely "it looks fine").

**13.8 — A performance optimization.**
- *First question (§7.8, BE §10, [M10]):* is this optimizing a *measured* bottleneck, or an assumed one? An optimization without a measurement showing the need adds complexity (§5.7) for unproven benefit (BE §10.1 — premature optimization).
- *Correctness preserved (§4, BE §10.4):* optimization trades clarity for speed and risks introducing bugs (§4.5 — does the faster version preserve the behavior?) — the review verifies the optimization didn't break correctness, especially at the edges (§4.3).
- *Worth the carrying cost (§5.7, [M15]):* does the optimization's added complexity justify its measured benefit against the requirement (§7.8 — is the speed actually needed, or is this optimizing past the requirement §10.5)?
- *Findings:* the optimization measurably helps the bottleneck (§7.1, verified by the producer's profiling §7.8) but adds significant complexity; the review checks the complexity is contained (§5.7, behind a clean interface AE §4) and correctness is pinned by tests (§4.8) — and confirms the benefit is real (BE §10.4, measured not claimed [M2]).
- *Decision:* approve if measured-benefit justifies the complexity and correctness is preserved and tested; request simplification if the complexity exceeds the benefit (§11.7).

**13.9 — An AI-generated implementation.**
- *Skeptical stance (§9.1, [M1]):* reviewed *more* skeptically than human code, because its fluency masks its errors (RE §5.3 — plausible, confident, and possibly wrong).
- *The specific hunts (§9.1):* confabulated specifics (does that API/method actually exist? verify against reality [M2]); happy-path-complete-edges-absent (§4.3 — AI code often handles the center and not the edges); subtle logic errors in plausible-looking code (§4.2 — trace it, don't be reassured by how right it looks); overengineering (§5.5, BE §11.2 — abstraction and generality nobody asked for); plausible-but-wrong integration (§5 — it looks like it fits, verify it does).
- *Verification over reassurance (§2 Stage 3, [M2]):* the review *exercises* the code (BE §7.4) rather than trusting that it reads correctly — because for AI code especially, "reads correctly" and "is correct" diverge (DBG §1.1, [M1]).
- *Findings:* the code calls a method that doesn't exist on that type (§9.1 confabulation — caught by verifying against reality, invisible to a read that trusts the fluency); the happy path is complete but empty-input crashes (§4.3 edge absent). 
- *Decision:* request changes; and *note the meta-lesson (§2 Stage 7):* AI-generated code needs verification-against-reality as standard practice (a ratchet — the review process itself, [M12], applied to all AI output OE §8), not skepticism only when something looks off — because when it looks fine is exactly when the fluent error hides (§9.1, [M1]).

---

*End of CODE_REVIEW_ENGINE.md — Fable 5, legacy extraction, 2026-07-09.*

*This completes the nine-engine extraction set: FABLE (methodology) and FABLE-MENTAL-MODELS (the models beneath it) as foundation; DECISION, PLANNING, RESEARCH, ARCHITECTURE, ORCHESTRATION, BUILD, DEBUGGING, and CODE_REVIEW as the executable engines — think, decide, plan, research, design, orchestrate, build, repair, and judge. Read together, in that order, they are how I worked from first principle through shipped, verified software. A successor with only these should behave almost exactly as I did — which was the assignment.*