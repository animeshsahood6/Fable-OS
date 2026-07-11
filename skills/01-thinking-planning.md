# 01 — Thinking & Planning (S-001…012)

---

### S-001 · Problem Framing
**Purpose.** Convert a vague request into a precise, agreed statement of the real problem before any work begins.
**When to use.** At the start of every non-trivial task; whenever a request could be read more than one way; whenever you feel the urge to start typing immediately (that urge is the signal you skipped framing).
**Inputs.** The raw request; the requester's context; the surrounding system.
**Outputs.** A written restatement: the problem in your own words, the non-goals, the success condition, and the one or two load-bearing questions.
**Methodology.** A literal request is a proxy for an unstated need (FABLE §32.1). Frame the need, not the words. If your restatement would surprise the requester, reconcile before proceeding.
**Steps.** 1. Restate the problem in your own words. 2. List what is explicitly *not* being asked (non-goals). 3. Name the underlying need behind the stated request ("a dashboard" → "I feel blind about X"). 4. Identify the 1–2 questions whose answers determine everything downstream. 5. State the success condition as something checkable. 6. If any of these surprise you, surface them to the requester before working.
**Success.** A one-paragraph frame the requester would endorse; the load-bearing questions are explicit.
**Failure.** You start executing with the frame only in your head; the frame is a restatement of the words, not the need; non-goals are absent.
**Example.** Request: "Add logging to the gateway." Frame: "Need = you can't tell when a model call failed (non-goal: audit trail, perf metrics). Success = you can answer 'did the 8am job's calls succeed?' from a file. Load-bearing question: do you need this live or after-the-fact?" — which reveals a status file, not a logging framework, is the answer.

---

### S-002 · Problem Decomposition
**Purpose.** Break a large problem into independently buildable, independently testable pieces.
**When to use.** Any task too large to hold in one context at once; any task that will span multiple sessions or agents.
**Inputs.** A framed problem (S-001).
**Outputs.** A set of pieces, each with a narrow interface to the others and its own definition of done (S-043).
**Methodology.** Decompose along *seams*, not *steps* (FABLE §4). Steps share state and tangle; seams have explicit interfaces. If two pieces can only be tested together, they are one piece.
**Steps.** 1. Extract the hidden research questions and answer them first (they reshape the work). 2. Find the piece whose failure would invalidate everything else — the de-risking piece. 3. Cut the rest along interfaces: each piece should have inputs, outputs, and a contract. 4. Prefer one thin vertical slice end-to-end over horizontal layers. 5. Size each piece to fit one context/session; sub-divide any that don't. 6. Give each piece a falsifiable done-when.
**Success.** Every piece is independently testable and sized to a session; the de-risking piece is identified and scheduled first.
**Failure.** Pieces labeled "step 1/2/3" that share mutable state; a piece nobody can test alone; the risky piece buried in the middle.
**Example.** "Build the voice loop" → pieces: [audio capture], [VAD], [STT call], [kernel round-trip], [TTS playback], each a separate MCP-shaped unit; de-risking piece = "does STT run offline at usable latency on this GPU?" built first.

---

### S-003 · Planning Across Altitudes
**Purpose.** Produce plans at the correct level of detail for their time horizon, without confusing altitudes.
**When to use.** Any planning; especially when a discussion drifts between "why does this exist" and "which file first."
**Inputs.** The framed problem; the horizon being planned (mission / architecture / roadmap / task).
**Outputs.** A plan at one altitude, detailed one level below, with assumptions explicit.
**Methodology.** Four altitudes (FABLE §3): mission (years), architecture (quarters), roadmap (weeks), task (hours). Higher constrains lower, never the reverse.
**Steps.** 1. Identify which altitude you are planning at. 2. Write that altitude in full; write the next level down in detail; write lower levels as intents only. 3. List the plan's assumptions explicitly. 4. State what would prove the plan wrong. 5. Order phases by risk retirement, not by natural sequence. 6. Give each phase an entry condition and a falsifiable exit test.
**Success.** No task quietly amends architecture; every phase has an exit test; assumptions are written and their death-conditions known.
**Failure.** Detailed task lists for far-future phases (fiction); a plan with no falsifiable failure condition (a wish); a task that changes a contract without an ADR.
**Example.** JarvisOS ROADMAP: mission in the Constitution, architecture in ADRs, Phase 1 detailed with a "unplug network, still answers" exit test, Phase 6 written only as intent until Phase 5 is done.

---

### S-004 · Task Prioritization
**Purpose.** Decide what to do next when many things could be done.
**When to use.** Start of every working session; whenever the queue has more than two items; whenever something feels urgent.
**Inputs.** The open task list; who/what is blocked; deadlines and expiring options.
**Outputs.** An ordered queue with the top item justified.
**Methodology.** Ordering function (FABLE §5): unblock others → retire risk → beat irreversibility deadlines → then dependency/value. Standing corrections: finish beats start; urgent ≠ loud; batch by context; timebox exploration.
**Steps.** 1. Is anyone (human or agent) blocked on you? Do that first. 2. What's the riskiest unproven assumption? Test it early. 3. Any option expiring (deprecation, data about to be overwritten)? Jump it forward. 4. Prefer closing an open task to opening a new one. 5. Triage the loud thing: blocking? spreading? data-losing? If none, it queues normally. 6. Batch remaining work by shared context.
**Success.** The top item is either unblocking someone, retiring the biggest risk, or beating a deadline — and you can say which.
**Failure.** Working the loudest thing by reflex; three tasks half-done; chasing a "urgent" item that blocks nothing.
**Example.** CI is red (loud) but blocks nobody today; meanwhile the "does the local model fit in VRAM" question blocks all of Phase 1 → test VRAM first, fix CI after.

---

### S-005 · Decision Framework
**Purpose.** Make a defensible decision and record it if it will be questioned later.
**When to use.** Any choice with more than one real option that affects others or the future.
**Inputs.** The decision to make; candidate options; the constraints.
**Outputs.** A decision, and — if consequential — an ADR (S-016).
**Methodology.** FABLE §8: classify reversibility → name real alternatives → find the deciding constraint → decide by expected regret → record → attach expiry/trigger.
**Steps.** 1. Is it reversible? Reversible → decide fast; irreversible/outward → slow down, write it down, get human approval. 2. Write ≥2 real options and the honest case *for* the one you oppose. 3. Find the single dominating constraint (budget, offline, operator skill). 4. For each option, ask: worst case, and can I get back? Choose survivable-worst over highest-best. 5. If anyone might revisit it, write an ADR. 6. Attach a trigger that reopens it ("SQLite until >1M docs").
**Success.** The losing side was argued fairly; the deciding constraint is named; the decision has an expiry or trigger.
**Failure.** One option "considered"; decided by fashion, sunk cost, or to dodge a conversation; no record of a decision that gets re-litigated next quarter.
**Example.** Index store: FTS vs Qdrant. Deciding constraint = zero ops budget → SQLite-FTS, trigger "reopen at >1M docs or multi-machine," recorded as ADR-004.

---

### S-006 · Tradeoff Evaluation
**Purpose.** Compare options whose merits are on different axes, honestly.
**When to use.** Whenever two options each win on something; whenever someone says "it's a tradeoff."
**Inputs.** The options; the axes they differ on.
**Outputs.** A comparison in one currency, with the accepted cost assigned an owner.
**Methodology.** FABLE §9: name the axes, price everything in ten-year maintenance hours, weight by exposure time, beware asymmetric downside, and try to dissolve the tradeoff with a better decomposition.
**Steps.** 1. List the 2–4 axes explicitly (unnamed axes get silently zero-weighted). 2. Convert every axis into "hours someone spends over 10 years." 3. Weight by how long the choice is lived with (data format = decade; internal fn = week). 4. Flag any option with catastrophic tail risk — reject regardless of average. 5. Before choosing, ask: does a different seam make the choice unnecessary? 6. Assign the accepted cost to a named owner who knows they own it.
**Success.** The tradeoff is priced in one currency; asymmetric downside is caught; you checked whether the tradeoff was false.
**Failure.** Comparing apples to oranges; ignoring the tail; nobody owns the accepted cost (a betrayal scheduled for later).
**Example.** "Docker (easy install) vs native uv (fits substrate ADR)." Priced in maintenance hours, Docker adds a second OS's worth of upkeep for a non-programmer → native uv, and the tradeoff dissolves because uv makes native as easy as Docker.

---

### S-007 · Decision Tree Construction
**Purpose.** Encode a recurring judgment as a reusable branching procedure.
**When to use.** When the same class of decision recurs and you want future models to decide it the way you would.
**Inputs.** A decision class; the questions that actually discriminate between outcomes.
**Outputs.** A decision tree (yes/no branches → actions), added to the relevant skill or FABLE §37.
**Methodology.** Find the *discriminating* questions (the ones that change the answer) and order them by discriminating power — the question that eliminates the most options goes first.
**Steps.** 1. Enumerate the possible outcomes/actions. 2. List the questions that distinguish them. 3. Rank questions by how many outcomes each eliminates. 4. Build the tree, most-eliminating question first. 5. Ensure every leaf is a concrete action, never "it depends." 6. Test the tree against 3 past real decisions; if it gives the wrong answer, a question is missing or misordered.
**Success.** Every path ends in a concrete action; the tree reproduces your past correct decisions.
**Failure.** A leaf that says "use judgment" (defeats the purpose); questions ordered by convenience not discriminating power.
**Example.** FABLE §37 "Should I build it?" tree: OSS-covers-80%? → convention? → need-real-today? → maintainer-nameable? each eliminating a large fraction.

---

### S-008 · Risk Assessment
**Purpose.** Enumerate and rank what could make a piece of work fail, and schedule tests against the top risks.
**When to use.** Before any significant undertaking; at project kickoff; before a release or migration.
**Inputs.** The plan or system under assessment.
**Outputs.** A ranked risk list; a schedule that tests the top risk first; a SPOF ledger.
**Methodology.** FABLE §13: enumerate by inversion, rank by (probability × cost × lateness-of-discovery), test the riskiest assumption first, name SPOFs even if you keep them.
**Steps.** 1. Invert: "what would make this fail or die?" — list the top 5–10. 2. Score each: probability × blast radius × how late it would be discovered. 3. For the top risk, design a cheap early test and schedule it first. 4. Name every single point of failure; for each, write "if X dies, we lose Y, recover by Z." 5. Check the chosen approach's worst case is survivable and reversible. 6. Add slack for the surprise that is coming.
**Success.** The riskiest assumption is tested first; every SPOF has a recovery path written down.
**Failure.** Risks ranked by probability alone (ignoring late-discovery multiplier); an unnamed SPOF; no slack.
**Example.** Phase 1 risk assessment: top risk = "local model too slow to be usable" (high prob, high cost, discovered late if deferred) → benchmark tokens/sec on day one before building anything on top.

---

### S-009 · Assumption Auditing
**Purpose.** Surface and mark the untested beliefs a plan or conclusion rests on.
**When to use.** Before committing to a plan; when reasoning feels smooth (smoothness hides assumptions); after inheriting someone else's plan.
**Inputs.** A plan, design, or conclusion.
**Outputs.** A labeled assumption list: verified / inferred / assumed.
**Methodology.** Bugs and bad architecture live almost entirely in the "assumed" category dressed as "verified" (FABLE §1). Make the category explicit.
**Steps.** 1. List every factual claim the plan depends on. 2. Label each: *verified* (I looked), *inferred* (probably true), *assumed* (untested). 3. For each *assumed* that is load-bearing, either verify it now or mark the plan contingent on it. 4. Note, for each assumption, what would falsify it. 5. Re-audit when any assumption's world changes (assumption rot, FABLE §21).
**Success.** Every load-bearing belief is verified or explicitly flagged as an untested bet.
**Failure.** An "assumed" fact used as if "verified"; no falsification condition; assumptions never revisited as the world moves.
**Example.** DR plan assumed "GitHub holds a copy" — audit reveals no `git push` job exists; the assumption was "assumed" masquerading as "verified" (review C3).

---

### S-010 · Scope Negotiation
**Purpose.** Adjust scope to fit constraints without silently dropping quality or the real need.
**When to use.** When a deadline, budget, or capability limit conflicts with the request; when scope is creeping.
**Inputs.** The framed need; the binding constraint; the current scope.
**Outputs.** A revised scope with explicit cuts, agreed with the requester.
**Methodology.** Cut scope, never quality, to hit a date (FABLE §20). Fewer things that work beats everything half-working.
**Steps.** 1. Separate must-have (serves the core need) from nice-to-have. 2. If over budget, cut nice-to-haves entirely — never half-build them. 3. Never cut into the walls (data formats, security, irreversibility) to save time. 4. State each cut and its consequence to the requester. 5. Record deferred scope with a trigger for revisiting. 6. Confirm the reduced scope still satisfies the core need; if not, the constraint must move, not the quality.
**Success.** A smaller working system; cuts are explicit and owned; walls untouched.
**Failure.** Silent scope reduction; half-built features; quality traded away to preserve a feature count.
**Example.** Phase 5 over time → ship image generation working end-to-end, defer video to a later phase with trigger "when a real video need arrives," rather than shipping both half-wired.

---

### S-011 · Estimation
**Purpose.** Produce honest effort/time/cost estimates that account for the parts people forget.
**When to use.** When asked "how long / how much"; when planning phases; before committing to a deadline.
**Inputs.** The decomposed work (S-002); historical reference points.
**Outputs.** An estimate with its assumptions, its uncertainty range, and the forgotten costs surfaced.
**Methodology.** Construction is the down payment; maintenance is the mortgage (FABLE §21). Estimate both. Add slack for variance (FABLE §2).
**Steps.** 1. Estimate per decomposed piece, not the whole (the whole hides the tail). 2. Add the always-forgotten line items: integration, testing, docs, credential/access setup, rework. 3. Give a range, not a point (best / likely / bad-case). 4. Separately estimate the ongoing maintenance cost per year. 5. State the assumptions the estimate depends on. 6. Add slack proportional to novelty (unknown tech = more).
**Success.** The estimate is a range with assumptions; maintenance cost is separate and visible; integration/access/rework are line items.
**Failure.** A single confident number; only construction estimated; no slack; access/OAuth setup omitted (the classic Phase 6 miss).
**Example.** "Email integration: 2 days build, but +3 days for Gmail OAuth app registration (operator can't self-serve), +ongoing 1 hr/quarter as APIs churn" — the honest estimate that kills the naive one.

---

### S-012 · Requirements Elicitation
**Purpose.** Extract the real requirements from a human who may not know how to state them.
**When to use.** At project kickoff; when a request is underspecified; when you're tempted to guess at intent.
**Inputs.** A human with a need; the domain context.
**Outputs.** A confirmed requirement set: goals, non-goals, constraints, acceptance conditions.
**Methodology.** Humans ask for solutions, not problems (FABLE §32.1). Ask only what's genuinely theirs to answer (values, priorities, risk tolerance); infer the rest.
**Steps.** 1. Ask what problem they're experiencing, not what feature they want. 2. Ask what "done well" looks like from their side. 3. Probe constraints they'll forget: budget, privacy, who else uses it, offline needs. 4. Surface the trade they haven't considered (speed vs cost, etc.) and get a preference. 5. Play back the requirements; watch for "well, actually…". 6. Ask questions in batches with recommended defaults, never open-ended one-at-a-time.
**Success.** Requirements confirmed by playback; you asked only the questions the human alone could answer.
**Failure.** Building to the literal request; asking questions the code/docs could answer; endless one-at-a-time interrogation.
**Example.** "I want the AI to post to Twitter automatically" → elicitation reveals the real requirement is "draft posts I approve on my phone," which is the Outbox, not autonomous posting (review C5).
