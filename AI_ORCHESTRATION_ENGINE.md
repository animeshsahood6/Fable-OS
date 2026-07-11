# AI_ORCHESTRATION_ENGINE.md — The Executable Orchestration Manual

**Authorship: Fable 5, legacy extraction, 2026-07-09. Content preserved verbatim per the Legacy Extraction Protocol.**

**What this is.** The machinery I run when I coordinate intelligence across multiple AI systems — written as procedures another AI can execute. It is the capstone of the extraction set and strictly additive to it: **[M#]** points to [FABLE-MENTAL-MODELS.md](FABLE-MENTAL-MODELS.md); **FABLE §N** to [FABLE.md](FABLE.md); **DE §N** to [DECISION_ENGINE.md](DECISION_ENGINE.md); **PE §N** to [PLANNING_ENGINE.md](PLANNING_ENGINE.md); **RE §N** to [RESEARCH_ENGINE.md](RESEARCH_ENGINE.md); **AE §N** to [ARCHITECTURE_ENGINE.md](ARCHITECTURE_ENGINE.md). The load-bearing prior art this document assumes and does *not* repeat: agent collaboration principles (FABLE §29, §31), AI-native architecture (AE §9 — trust tiers, the outbox, context architecture, knowledge preservation, MCP/A2A), planning across models (PE §8), adversarial verification as a research discipline (RE §9.7, RE §8), and the whose-downside ownership rule (DE §10.6). Those tell you the *pieces*; this document tells you how to *run the whole machine* — the live conducting of many intelligences toward one outcome.

**The distinction that justifies a separate document.** AE §9 designs the *static structure* of an AI-native system — where the seams are, how trust is partitioned, what persists. This document is the *dynamic discipline* — how work actually flows through that structure at runtime: who gets which task, in what order, verified how, recovered how, at what cost. Architecture is the stadium; orchestration is the game played in it. A perfect AI-native architecture, orchestrated badly, produces duplicated work, poisoned context, runaway cost, and confident wrong answers. This is the manual for the game.

**The one-sentence version.** Orchestration is the allocation of a task across a fleet of fallible, specialized, replaceable intelligences such that the fleet's *combined* output is more correct, more complete, and more trustworthy than any single member could produce — and the entire craft is in the words *fallible* (so you verify), *specialized* (so you route), and *replaceable* (so you never depend on which member showed up).

---

# 1. Orchestration Philosophy

**1.1 — What orchestration actually is.** Orchestration is *the management of cognitive labor* — deciding what thinking needs to happen, splitting it among intelligences suited to each part, sequencing it so dependencies resolve and independent work parallelizes, and composing the results into something trustworthy. It is not "using multiple AIs" (that's just fan-out); it is the deliberate construction of a *system of intelligences* whose structure compensates for the weaknesses of each individual intelligence. The orchestrator is not the smartest participant — it is the one holding the goal, the standard, and the map of who-knows-what, and it earns its place by *coordination*, not by *cognition*.

**1.2 — Why multiple specialized intelligences outperform one general intelligence.** Not because any specialist is smarter than a strong generalist — often they aren't — but because of four structural advantages that compound:

- **Independence defeats correlated error.** A single intelligence's mistakes are correlated with itself: whatever blind spot produced an error also blesses the self-review. Two *independent* intelligences fail differently, so one catches what the other misses (RE §8.2, independent corroboration; AE §9.7). This is the deepest reason orchestration beats solo work — it is the only way to escape the trap that a mind cannot see its own blind spot.
- **Specialization concentrates capability.** A context loaded and primed for one task (reviewing for security, say) outperforms the same model asked to hold ten concerns at once — attention is finite, and a focused context spends all of it on one thing (AE §9.4).
- **Parallelism buys wall-clock.** Independent sub-tasks run at once; the fleet's latency is the longest single chain, not the sum (PE §4.2, critical path; FABLE §31).
- **Diversity covers the space.** Different intelligences (different models, different framings, different tools) search different regions of the solution space; their union covers ground no single searcher would (RE §Stage 3, landscape; the multi-modal sweep).

The governing formula: **a fleet's value over a soloist is roughly the independence of its members times the diversity of their coverage, minus the coordination cost.** Maximize the first two, minimize the third — and when the third dominates, don't orchestrate (§1.3).

**1.3 — When orchestration is unnecessary (the discipline of not conducting).** Orchestration has a carrying cost [M15] paid in coordination, context-passing, and latency, and that cost is often larger than the task. Do *not* orchestrate when:
- The task fits one context with room to spare and has no independent sub-streams (§3.1) — a single agent is simpler, faster, and cheaper.
- The task is low-stakes and reversible [M11, DE §2 T1] — the verification apparatus of orchestration is overhead the blast radius doesn't justify (§8, AE §8.4).
- The sub-tasks are so coupled they can't be cleanly separated (§3.4) — forced decomposition produces coordination cost with no parallelism benefit, the distributed-monolith failure applied to agents (AE §10.2).
- Speed matters more than the marginal correctness a second opinion buys, and the task is within a single strong model's competence.

**The orchestrator's highest discipline, exactly as with every prior engine, is knowing when not to run the machine.** A single well-briefed agent is the correct answer to most tasks; multi-agent orchestration is the exception reserved for work that is large (needs parallelism), high-stakes (needs independent verification), or diverse (needs coverage). Conducting a soloist's task with a full orchestra is not thoroughness — it is waste wearing thoroughness's costume [M19].

**1.4 — The responsibilities of an orchestrator.** Seven, and they are non-delegable — the moment the orchestrator delegates these, there is no orchestrator:
1. **Hold the goal.** The done-state (PE Stage 1) lives with the orchestrator; every delegation is checked against it, and drift from it is the orchestrator's to catch (agents optimize their brief, not the goal — §12).
2. **Hold the standard.** What "good enough" means, and the verification bar for each stakes level (§8), is the orchestrator's to set and enforce.
3. **Route.** Match each task to the intelligence suited to it (§4) — the core act.
4. **Sequence.** Order the work so dependencies resolve and independence parallelizes (§3, PE §4).
5. **Verify.** Ensure output is checked proportional to its stakes, by something independent of what produced it (§8). *Never* pass unverified high-stakes output downstream.
6. **Preserve.** Own the durable state — context, memory, decisions — so nothing important lives only in a transient agent (§5, §11, AE §9.9).
7. **Own the outcome.** The composed result is the orchestrator's, including its failures. An orchestrator that blames a sub-agent has misunderstood the role — the choice to trust that agent's output *was the orchestrator's decision* (§8, [M20]).

---

# 2. The Orchestration Pipeline

Request in, verified delivery out. Ten stages. The pipeline is itself run by the orchestrator; sub-agents execute *within* stages. Stages compress or collapse for low-stakes work (§1.3) and run in full for large, high-stakes, or long-running work.

**Stage 0 — Task analysis.** What is actually being asked (frame it — FABLE §1, RE §3), what is the done-state (PE Stage 1), and what are the non-goals? Everything downstream is checked against this; a mis-framed task orchestrated perfectly delivers the wrong thing at multiplied cost.
*Checkpoint: can I state the done-state in one falsifiable sentence? If not, framing is incomplete.*

**Stage 1 — Capability analysis.** What kinds of intelligence does this task require (reasoning, coding, vision, research, creative, verification)? Which are available in the fleet, and at what tiers (§4)? This maps the task's needs onto the fleet's capabilities and surfaces gaps ("this needs vision and we have no vision model" is a finding, discovered now, not mid-execution).
*Checkpoint: is every capability the task needs available in the fleet? Named gaps become constraints or blockers.*

**Stage 2 — Complexity estimation.** Does this fit one context, or must it be decomposed (§3)? How many independent streams, how deep the dependency chains? This decides the *shape* of the orchestration — soloist, sequence, parallel fan-out, or pipeline (§13.2).
*Checkpoint: single-agent or multi? (§13.1 — default to single unless the task earns multi.)*

**Stage 3 — Risk estimation.** What is the blast radius of being wrong [M8, AE §8.4], and what is the reversibility [M11, DE §2 tier]? This sets the *verification bar* (§8) and the *human-gate placement* (§9) for every downstream output. High-stakes tasks get adversarial multi-verifier checking; low-stakes get a glance.
*Checkpoint: what is the worst this orchestration can produce, and is that worst gated appropriately?*

**Stage 4 — Execution planning.** Map tasks to intelligences (§4), sequence by dependency and risk-retirement (PE §5), assign context to each (§5), and place verification and human gates (§8, §9). The output is an orchestration plan: who does what, in what order, verified how, at what budget (§10).
*Checkpoint: does the plan have a verification stage for every high-stakes output and a gate at every T4 boundary? (§8, §9)*

**Stage 5 — Delegation.** Brief each agent as a cold start (FABLE §29) — goal, inputs by full path, constraints, done-when, output format, judgment criteria. Spawn independent work in parallel (§3.2, FABLE §31), sequence the dependent. The briefs are the orchestrator's most important artifact after the plan; a bad brief wastes an entire agent-run (§12, prompt drift).

**Stage 6 — Verification.** Each output checked proportional to its stakes (§8) by something *independent* of what produced it (§1.2, RE §9.7). Unverified high-stakes output does not proceed. This is the stage most often skipped under time pressure and the stage whose skipping produces the worst failures [M16, M20].
*Checkpoint: has every high-stakes output survived independent verification? Have conflicts between agents been resolved, not averaged (RE §5.5)?*

**Stage 7 — Composition and delivery.** Combine verified outputs into the deliverable (RE §8, synthesis discipline), check the whole against the Stage 0 done-state (not against the plan — FABLE §1 step 7), and deliver to the human in the form they need (FABLE §28 — outcome first, calibrated, bad news plainly).

**Stage 8 — Feedback.** Capture the human's response and any downstream reality (did the delivered thing work?). Feedback that contradicts a verified conclusion is a high-value signal — it means the verification had a gap, and the gap is worth finding (§8, §12).

**Stage 9 — Learning.** Convert what this orchestration taught into durable improvements: a memory of a preference or constraint (FABLE §7), a ratchet against a failure that occurred [M12], a refinement to a brief or route that underperformed. An orchestration that produces only a deliverable and no learning has left value on the table; a succession of orchestrators improves only if each writes down what it learned (AE §9.9, this extraction being the ultimate instance).

---

# 3. Task Decomposition

PE §3 covers decomposition for planning (buildable, testable pieces) and AE §3 for architecture (evolvable, ownable components). This section is decomposition for *orchestration* — dividing work among *intelligences* at runtime, where the units are tasks-for-agents and the costs are coordination and context-passing.

**3.1 — Single agent or decompose?** The default is *single agent* (§1.3). Decompose only when at least one holds:
- **The task exceeds one context** (with headroom — PE §8.2): it must be split so each piece fits an agent's working window with room for orientation.
- **There are genuinely independent streams** (§3.2): parallelism will buy meaningful wall-clock.
- **The stakes demand independent verification** (§8): the work and its check must be different intelligences (§1.2), which is a decomposition into producer and verifier even when the work itself is one piece.
- **The task needs diverse coverage** (RE §Stage 3): several framings or search-angles that one agent won't span.
When none holds, one agent does it end-to-end — simpler, cheaper, no coordination cost, no context-passing loss.

**3.2 — Discovering independent work streams.** Independence is the property that makes parallelism safe (FABLE §31), and the test is the *cold-brief test*: could I write each stream's complete brief *right now*, without any other stream's result? If yes for all, they're independent and parallelize. If one brief requires another's output, that's a dependency (§3.3), and the two are sequential no matter how much parallelism is wished for. Discover streams by cutting along the same seams architecture uses (PE §3.1, AE §3) — narrow interfaces, independent testability — because task boundaries that align with system seams recombine cleanly, and task boundaries that cut across seams produce integration pain (§3.4). The richest source of independent streams: *reading and research* (many agents each covering a different region, returning conclusions — RE, the multi-modal sweep), which parallelizes almost perfectly because reading has no write-conflicts.

**3.3 — Discovering dependencies.** The four dependency types (PE §4.1 — producer→consumer, resource, knowledge, external) apply directly; the orchestration-specific ones to watch:
- **Knowledge dependencies** (PE §4.1): task B can't be *briefed* until task A resolves an unknown B's shape depends on. These force sequencing and are invisible on a naive task graph — the main reason "parallelize everything" fails.
- **Context dependencies:** task B needs context that only exists after task A runs. Either sequence them, or have A write its context to durable state (§5) that B reads — converting a live dependency into a file-mediated one (AE §9.3), which is more robust.
- **Verification dependencies:** a verifier depends on the producer's output but must *not* depend on its context (§8, RE §9.7) — a subtle dependency where you want the data to flow but the reasoning not to.

**3.4 — Defining task boundaries.** A good task boundary is one where the *brief is short and the output is well-defined* (the narrow-waist test, PE §3.1, applied to agent work): if you can state the task's inputs, its done-when, and its output format in a few lines, the boundary is clean. If the brief must include "and coordinate with the other agent about X," the boundary is cutting through coupled work and should be redrawn to put X's ownership entirely on one side (§3.5, AE §3.3 single ownership). Each task gets: one owner (one agent responsible for it), one done-when (falsifiable, checkable by the orchestrator), and one output contract (the form the result takes, so composition §2 Stage 7 is mechanical). Tasks whose outputs must be hand-reconciled afterward were badly bounded.

**3.5 — Minimizing coordination overhead.** Coordination is the tax that eats orchestration's benefit (§1.2); minimize it structurally:
- **Prefer file-mediated coordination over live agent-to-agent messaging** (AE §9.3, ADR-008): agents that coordinate through shared durable state (§5) are independently replaceable, their coordination is inspectable, and a dead agent doesn't strand the others. Agents that coordinate through direct messaging couple into a distributed system with all its failure modes (§12, AE §10.2).
- **Push coordination up to the orchestrator, not sideways between agents:** the orchestrator holds the map (§1.4); agents report to it and receive from it, rather than negotiating among themselves. A star topology (orchestrator at center) has O(n) coordination; a mesh (agents talking to agents) has O(n²) and no single point that understands the whole (§12, coordination collapse).
- **Batch independent work into one fan-out** rather than trickling tasks — fewer coordination rounds, more parallelism captured (§13.2).
- **Give each agent everything it needs in its brief** (FABLE §29) so it needs no round-trips — a task that requires the agent to come back for clarification was under-briefed, and the round-trip is pure coordination cost.

---

# 4. Model Selection

The core routing act (§1.4). PE §8.1 establishes route-by-task-shape-not-model-name and match-effort-to-stage; AE §7.5 and §9.2 establish the gateway seam that makes models swappable. This section is the *selection judgment itself* — given a task, which kind of intelligence performs it. The governing principle: **route by the task's dominant demand, held behind a seam so the specific model is a config detail** (AE §9.2) — you select a *tier and capability profile*, and the gateway resolves it to whatever model currently fills that profile, so this section stays valid as the specific models churn (AE §7.5).

**4.1 — Selecting by capability profile.** Match the task's dominant cognitive demand to the intelligence built for it:
- **Reasoning / deep-thinking tasks** (architecture decisions, complex debugging, multi-step planning, hard tradeoffs) → the strongest reasoning tier, with the most thinking budget. These are the tasks where capability difference matters most and cost matters least — a wrong architecture decision dwarfs any inference cost (§10, quality-vs-cost).
- **Coding tasks** (implementation, refactoring, test-writing) → a coding-specialized or strong-general tier; weight tool-use fluency and instruction-following.
- **Creative tasks** (naming, copy, design ideation, framing) → a tier with range and fluency; less need for rigor, more for divergence.
- **Vision tasks** (screenshots, diagrams, document layout, UI understanding) → a vision-capable model, non-negotiable — this is a capability gate, not a preference (Stage 1 surfaces its absence).
- **Verification tasks** (checking, refuting, reviewing) → a strong tier, and critically an *independent context* (§8, §1.2) — the profile here is "capable and independent," and independence is the harder requirement.
- **High-volume mechanical tasks** (bulk transforms, formatting, simple extraction, classification) → a fast cheap tier; capability is not the constraint, throughput and cost are.

**4.2 — How capability changes the decision.** Capability is decisive when the task is *hard and high-stakes* — a task at the edge of what any model can do gets the most capable tier regardless of cost, because the alternative is a wrong answer (§10.8, quality-vs-cost: on the walls, capability is non-negotiable [M6]). Capability is *irrelevant* when the task is easy — a mechanical transform runs correctly on the cheap tier, and spending the capable tier on it is waste (§10, PE §8.1 match-effort-to-stage). The judgment: *is this task near the capability frontier for its type?* Near → capable tier. Far → cheapest tier that clears the bar.

**4.3 — How cost changes the decision.** Cost matters in proportion to *volume and stakes-inverse*: a task run thousands of times, or a low-stakes task, is cost-sensitive and routes cheap; a task run once, or a high-stakes one, is cost-insensitive and routes for quality (§10). Never optimize cost on a wall [M6] — the saving is trivial against the cost of being wrong (§10.8). Aggressively optimize cost on furniture and on high-volume mechanical work, where it compounds. The pattern: *cheap tier by default for the many small tasks, capable tier deliberately for the few decisive ones* — most orchestrations are mostly cheap-tier work with a few expensive decisions, and getting that ratio right is most of cost optimization (§10).

**4.4 — How latency changes the decision.** Latency matters when a human is waiting or when the task is on the critical path (PE §4.2). For interactive, human-in-the-loop work, prefer faster tiers even at some capability cost — a fast good-enough answer the human can react to beats a slow perfect one they've stopped waiting for (FABLE §28). For background, autonomous, or off-critical-path work, latency is nearly free — route for capability and cost, let it take its time (§11, long-running work is latency-insensitive by nature). The judgment: *is anything blocked on this finishing?* Yes → weight latency. No → ignore it.

**4.5 — How context size changes the decision.** When a task requires holding a large amount of information at once (a whole large codebase, a long document, extensive history), it routes to a model whose context window fits the need *with headroom* [M17, PE §8.2] — and if nothing fits, the task must be *decomposed* (§3) so its pieces fit, or *pre-processed* (retrieval, summarization — §5, §6) so only the relevant subset enters context. Context size is often better solved by *reducing what must be in context* (retrieval §6, decomposition §3) than by reaching for the largest-context model — because a large context degrades attention (AE §9.4), costs more, so a focused small context frequently outperforms a large stuffed one. Reach for the big-context model when the task genuinely needs broad simultaneous attention; reach for retrieval-and-decomposition when it needs a specific subset of a large corpus (the more common case).

**4.6 — How reliability changes the decision.** For tasks where *consistency and instruction-following* matter more than peak capability — anything with a strict output contract (§3.4), anything in a pipeline where a malformed output breaks the next stage, anything autonomous where no human will catch a deviation — route to the tier with the best reliability profile, even over a more capable but less predictable one. Reliability is especially decisive for the *actor* side of AI-native systems (AE §9.6) — the context that takes real actions must follow its constraints predictably, so it's routed for reliability and gated regardless (§9). The judgment: *what does a deviation cost here?* High (breaks a pipeline, takes a wrong action) → weight reliability. Low (a human reviews it anyway) → weight capability.

**4.7 — Local vs cloud (the availability and trust axis).** AE §11.3 gives the architecture tree; the orchestration overlay: route to *local* models when the network is cut (Law 6 — the fallback that keeps the system thinking, §10.5), when the data is privacy-constrained and must not leave the machine (AE §8.2), or when the task is high-volume and a local model's marginal cost is zero. Route to *cloud* for peak capability the local tier can't match, accepting the cost and the dependency (which the gateway seam makes reversible, AE §9.2). The orchestrator's standing rule: *every routing chain ends in a local fallback* (AE §9.2, §10.5) — so the loss of cloud degrades quality, never capability, and the orchestration continues offline at reduced power rather than halting.

---

# 5. Context Architecture

AE §9.4 establishes context as a first-class architectural concern and the primary attack surface; FABLE §6 gives the operational discipline (externalize early, front-load orientation, write for the post-compaction reader). This section is the *orchestration-runtime* discipline: how the orchestrator constructs, partitions, preserves, and restores context across a fleet and across time. The governing principle: **context is the working memory of a memoryless actor, so the orchestrator owns it entirely — every agent's context is deliberately constructed by the orchestrator, never accidentally accumulated.**

**5.1 — How context is created.** For each agent, the orchestrator *assembles* the context deliberately from four sources: the *brief* (the task, FABLE §29), the *orientation* (the minimum system/project map the agent needs to act — index files, relevant contracts, not everything), the *retrieved knowledge* (memory and prior findings relevant to this task, pulled by knowledge routing §6), and the *inputs* (the actual data to work on). Each piece carries its *trust level* (AE §8.2, §9.6 — untrusted content is marked and, for actor agents, excluded). The discipline is *minimalism with headroom* [M17]: enough to act correctly, no more, because every irrelevant token degrades attention (AE §9.4) and every excess token costs. A context an agent must wade through to find what it needs was over-assembled.

**5.2 — How context is partitioned.** Context is partitioned along the same three cuts as architecture (AE §3.1) — by capability (each agent sees only its task's context), by trust (untrusted-reading contexts are separated from acting contexts, AE §9.6), and by failure (a poisoned or confused context is isolated, not shared, so its corruption doesn't spread, §12). The orchestration-specific partition: *per-agent context isolation* — agents do not share a single accumulating context; each gets its own constructed context (§5.1), and they coordinate through durable state (§3.5, §6), not through a shared context blob. This is what makes agents independently replaceable (a fresh agent gets a fresh constructed context, AE §9.9) and prevents one agent's confusion from contaminating another's (§12, context poisoning).

**5.3 — How context is preserved.** The orchestrator preserves across time by *continuous externalization to durable state* (FABLE §6, AE §9.9): decisions, findings, task states, and open questions are written to files *as they occur*, not held in any agent's context, because any context can end at any instant. The preserved state is the source of truth (AE §5.2); the live contexts are transient caches over it. This is the mechanism by which a long-running orchestration (§11) survives session ends, model swaps, and compaction — nothing important lives only in a context, so the loss of any context loses nothing but recomputable work.

**5.4 — How context is compressed.** When a context grows long (a long-running agent, an extended session), it must be compressed without losing signal. The discipline (FABLE §6): *summarize to durable state, then restart from the summary* — write a self-contained handoff (full paths, full names, the why with the what, FABLE §6) that captures the state, and begin a fresh context from it. Compression is *lossy by intent* — it keeps decisions and open state, discards the transcript of how they were reached (which is recomputable or irrelevant). The test of good compression: *can a fresh context resume correctly from the summary alone?* If it needs the discarded detail, the summary was incomplete (§11, checkpointing).

**5.5 — How context is restored.** A fresh agent or a resumed session *reconstructs* its context from durable state (§5.3) — it reads the relevant memory, findings, and handoff notes and rebuilds a working context equivalent to what it needs (not identical to what a prior context held — equivalent for the task). The orchestrator makes restoration cheap by keeping the durable state well-organized (AE §9.9 — index files, clear structure) so a fresh context orients in minutes, not by re-deriving. Restoration is the inverse of preservation and the reason preservation must be disciplined: state preserved carelessly can't be restored usefully.

**5.6 — How context survives model replacement.** Because context is constructed from *model-neutral durable state* (§5.1, §5.3, AE §9.9), a new model reconstructs equivalent context from the same files the old model used — the context isn't tied to the model that held it. This is the whole reason context lives in files and not in any model's session: model replacement (AE §9.1, FABLE §15) must be an amnesia-free event, and it is, precisely because no context depends on which model constructed it. The orchestrator's invariant: *no context an agent needs may exist only in a prior model's session* — it must be reconstructable from durable state, or it's lost at the next replacement (AE §9.9).

**5.7 — How context survives long-running projects.** Over months (§11), context survives by *layered durable state* (AE §5.5, PE §7.4): the slow-changing project context (goals, architecture, decisions — in the constitution/ADR layer) rarely needs reconstruction; the medium-changing (current phase, component state) is reconstructed at each session start; the fast-changing (this task's working state) lives and dies with the task. The orchestrator reconstructs only the layers a given piece of work needs, at the freshness that work requires — not everything, every time. A long project that required reloading its entire history to do any task would be unworkable; the layering is what keeps per-task orientation cheap across a project of any length.

**5.8 — How context survives token limitations.** The token budget is a hard constraint [M17], and the orchestrator respects it by the moves above composed: *decompose* so each task fits (§3, §4.5), *retrieve* so only relevant knowledge enters (§6), *compress* when a context fills (§5.4), and *partition* so no agent carries another's load (§5.2). The anti-pattern is stuffing everything into one large context and hoping the window holds — which degrades attention (AE §9.4), costs the most, and fails hard at the boundary. The discipline: *treat every context as smaller than it is, and earn every token's place in it* — a context assembled to exactly its need, with headroom, never hits the limit by surprise.

---

# 6. Knowledge Routing

How the right knowledge reaches the right agent at the right time. AE §5 (data/memory/graph architecture) and §9.8 (Graphify) establish the *stores*; RE §Stage 8 and §8 establish how findings are recorded and synthesized; this section is the *runtime routing* — the orchestrator's discipline for retrieving, isolating, sharing, and propagating knowledge across the fleet. The governing principle: **knowledge lives in durable model-neutral stores (AE §5), and the orchestrator routes the relevant subset into each agent's context (§5.1) — agents don't hold knowledge, they're handed exactly what they need and return what they learn.**

**6.1 — How memory is retrieved.** On constructing an agent's context (§5.1), the orchestrator retrieves the memory relevant to the task — not all memory (that would poison the context with noise, §5.8) but the pieces that bear on *this* task, pulled by the recall mechanism suited to the query (§6.3). Retrieval respects provenance and trust (AE §5.3): retrieved memory carries where it came from and how trusted it is, so an agent knows whether it's acting on a verified fact or a low-confidence note [M1, RE §5.6]. The orchestrator verifies that recalled memory is still current before an agent acts on it (FABLE, memory is perishable, RE §5.2) — a memory that names a file or state gets checked against reality before it drives action.

**6.2 — How Graphify participates.** The knowledge graph (AE §9.8) participates when the agent's need is a *relationship* question — "what depends on this decision," "how are these connected," "what's the path between these concepts," "what community does this belong to." The orchestrator routes such questions to the graph tier (a traversal), and attribute/lookup questions to full-text, and similarity questions to vector search (§6.3, AE §11.8). Graphify's distinctive orchestration value: it lets an agent understand *structure* it wasn't briefed on — a builder agent can query the decisions-graph to learn what constraints bind its component ("what laws and ADRs touch this?") without the orchestrator having to anticipate and inject every relevant constraint. The graph is a tier *above* the guaranteed baseline (AE §9.8, Law 4) — if it's unavailable, routing falls back to full-text, degraded but never absent (§8.7 graceful degradation applied to recall).

**6.3 — How semantic retrieval differs from graph retrieval (and when to route to each).** They answer different question-shapes and the orchestrator routes by shape (AE §11.8):
- **Semantic / vector retrieval** answers "*what is similar to this*" — find the memories, documents, or prior work *like* the current thing. Best for surfacing relevant-but-not-explicitly-linked knowledge (the finding from a past project that resembles this one). Its weakness: it finds similarity, not truth or connection — similar things aren't necessarily related or correct.
- **Graph retrieval** answers "*what is connected to this, and how*" — traverse explicit relationships. Best for impact analysis, dependency tracing, and "why" questions where the *structure* of connections is the answer. Its weakness: it only knows the relationships that were captured; it finds nothing about unconnected-but-similar things.
- **Full-text** answers "*where is this exact thing mentioned*" — the cheapest, always-available baseline.
The orchestrator routes a knowledge need to the retrieval mode whose *shape* matches the question, and for rich needs, combines them (RE §8 synthesis over multiple retrievals) — semantic to find candidates, graph to trace their connections, full-text to confirm specifics.

**6.4 — How project knowledge is isolated.** Each project's knowledge (its code understanding, its decisions, its working state) is *scoped to that project* (AE §3.2, bounded context) — an agent working on project A retrieves A's knowledge, not B's, so B's concepts don't pollute A's context (§5.2) and A's changes don't leak into B. The orchestrator maintains this isolation by partitioning the durable stores by project (per-project memory, per-project graphs — AE §9.8) and routing retrieval within the active project's scope. Isolation prevents the cross-contamination where an agent applies one project's assumptions to another (a subtle, common failure in multi-project orchestration).

**6.5 — How global knowledge is shared.** Knowledge that transcends any one project — the operator's preferences, the standing constraints, the methodology (this extraction), the cross-project lessons — lives in a *global scope* every agent can retrieve from (AE §9.9, the shared durable state). The orchestrator routes global knowledge into every relevant context (§5.1) so all agents act on the same preferences and constraints, without each having to rediscover them. The partition rule: *project-specific knowledge is isolated (§6.4); genuinely global knowledge is shared* — and the discipline is not to promote project-specifics to global (which pollutes every context) nor to duplicate globals into each project (which lets them drift, AE §3.3 single ownership).

**6.6 — How decisions propagate across agents.** When one agent (or the orchestrator) makes a decision that others must respect, it propagates through *durable state*, not through messaging (§3.5): the decision is recorded (an ADR, a memory, a note in the project state — DE §2 Stage 8, AE §6.2), and subsequent agents retrieve it as part of their context construction (§5.1, §6.1). This is why decisions are *recorded* and not just *made* — recording is the propagation mechanism across a fleet and across time (AE §9.9). An agent that needs to know "what did we decide about X" retrieves the decision record; the orchestrator ensures the record exists and is retrievable. Decisions propagated only through a live context are lost at the next context boundary and unknown to parallel agents — the multi-agent form of the unrecorded-decision failure (DE §1.4).

**6.7 — How durable knowledge is created.** Knowledge becomes durable when it's *written to a store in a model-neutral, retrievable form with its provenance* (AE §5, §9.9). The orchestrator's discipline (§2 Stage 9, learning): after each significant piece of work, what was learned that future work needs is *written down* — a finding (RE §Stage 8), a decision (DE §2 Stage 8), a preference or lesson (FABLE §7), a ratchet against a failure [M12]. Durable knowledge creation is what makes the fleet (and its successors) smarter over time rather than repeating discoveries (RE §1.5, research debt). The failure is knowledge that exists only in a completed agent's context — real, useful, and gone the moment the agent ends (§5.3). The orchestrator captures it before the context closes, or it never existed for anyone else.

---

# 7. Multi-Agent Architecture

The roles a fleet is composed of, and the discipline of composing them. AE §9.3 establishes agent architecture (tools scoped by trust, coordination through state); FABLE §31 establishes the collaboration principles; this section is the *role system* — what roles exist, when to merge them, when to split them, and how they interact. The governing principle: **roles are capabilities the orchestration needs, not org-chart positions — a role is a briefed context with a specific job, and one model instance may play many roles across a task or many instances may play one role, as the work demands.**

**7.1 — The roles.** Each is a distinct briefed context (§5.1) with a specific job, capability profile (§4), and trust scope (AE §9.6):
- **Coordinator (the orchestrator itself).** Holds the goal, standard, and map (§1.4); routes, sequences, verifies, composes. Non-delegable; there is exactly one, and it is not a worker.
- **Planner.** Decomposes and sequences (PE) — turns a goal into an execution plan. Reasoning-tier (§4.1).
- **Researcher.** Discovers and verifies external knowledge (RE) — the fleet's contact with the world and the literature. Often many parallel researchers (§3.2, multi-modal sweep).
- **Architect.** Designs structure (AE) — seams, contracts, invariants. Reasoning-tier, high-stakes (its decisions are walls [M6]).
- **Builder.** Implements — turns design into artifact. Coding-tier (§4.1); often parallel builders on independent components (§3.2), isolated to avoid write-conflicts (AE §9.6, worktree isolation).
- **Reviewer.** Checks work for quality and correctness against the standard (FABLE §25) — the first line of verification (§8).
- **Tester.** Exercises the built thing to verify behavior (FABLE §17, verify-by-exercising) — distinct from reviewer (who reads) in that the tester *runs* (RE §Stage 6, reality contact).
- **Critic.** Attacks the work adversarially — tries to find what's wrong, not confirm what's right (§8, RE §9.5). Distinct from reviewer in stance: the reviewer asks "is this good?", the critic asks "how does this fail?"
- **Verifier.** Independently confirms a specific high-stakes conclusion (§8, RE §9.7) — spawned per-claim, prompted to refute, in a context independent of the producer.
- **Security reviewer.** Checks trust boundaries, injection surfaces, secret handling, blast radius (AE §8.6, §9.6) — a specialized critic for the security dimension, because security failures are asymmetric [M16] and need a dedicated lens.
- **Documentation writer.** Produces the durable record for the human and the successor (FABLE §26, [M18]) — writes for the stranger, captures the why (AE §6.2).
- **Release manager.** Verifies the reproducible/reversible/observable gate (FABLE §20) before anything ships (§9, human gate).
- **Operator.** Executes approved actions (the ACTOR context, AE §9.6) — the only role holding privileged tools, gated by human approval (§9), scoped by least privilege (AE §8.6).

**7.2 — When to merge roles.** Roles are merged (one agent plays several) when the task is *small enough that separation's coordination cost exceeds its benefit* (§1.3, §3.1) — for a minor change, one agent plans, builds, and self-checks, because spinning up a five-agent fleet for a one-file change is pure overhead [M15]. Merge when: the stakes are low (verification independence isn't worth the cost, §8), the roles' work is tightly coupled (splitting would create coordination, §3.4), or one context can hold all the roles' concerns without attention loss (AE §9.4). The default for small work is *maximal merge* — one agent, all roles — escalating to split only as the task grows or the stakes rise.

**7.3 — When to split roles.** Roles are split (separate agents/contexts) when *independence buys correctness or parallelism*:
- **Producer and verifier always split for high-stakes work** (§8, §1.2) — the one non-negotiable split, because self-verification is worthless against correlated error (RE §9.7). The builder does not review its own work at high stakes; a fresh critic does.
- **Parallel work splits by independent stream** (§3.2) — multiple builders, researchers, or reviewers when there are independent pieces to cover simultaneously.
- **Adversarial roles split by stance** — critic and security-reviewer are split *from* the producer specifically so they can attack without the producer's investment defending the work [M14, sunk cost; the producer can't adversarially review its own work].
- **Trust-differentiated work splits by tier** (AE §9.6) — the reader (untrusted input, no tools) and the actor (privileged, no raw untrusted input) are *architecturally* separate contexts, never merged, because merging them recreates the injection vulnerability the split exists to prevent.

**7.4 — How agents communicate.** Through *durable state*, as the default (§3.5, AE §9.3): an agent writes its output to a file/store with a defined contract (§3.4), and the orchestrator (or the next agent) reads it. This makes communication inspectable (the orchestrator can see what passed between agents), durable (it survives context ends, §5.3), and decoupled (agents are independently replaceable, AE §6.4). Direct agent-to-agent messaging is avoided (§3.5, §12 coordination collapse) — it couples agents into a mesh and hides the communication from the orchestrator that's supposed to hold the map (§1.4). The orchestrator is the communication hub: agents report up, receive down, and the durable state is the shared medium.

**7.5 — How agents synchronize.** Synchronization points are *barriers the orchestrator imposes* where dependent work must wait for prerequisite work (PE §4.2): a verifier waits for the producer's output; a composer waits for all parallel pieces. The orchestrator manages synchronization by *not briefing a dependent agent until its prerequisites are in durable state* (§3.3) — the dependency is enforced by the orchestrator's sequencing, not by agents waiting on each other. For parallel work that must reconverge (§3.2), the orchestrator holds the barrier: it collects all parallel outputs, then proceeds to composition (§2 Stage 7). Synchronization through the orchestrator (star topology) rather than between agents (mesh) is what keeps a large fleet coherent (§12).

**7.6 — How agents avoid conflicts.** The three conflict types and their structural preventions:
- **Write conflicts** (two agents modifying the same artifact) → *isolation*: parallel builders work in separate workspaces (AE §9.6, worktrees) and the orchestrator merges deliberately, or single-writer discipline assigns each artifact one owning agent (AE §3.3, §10.4). Never two agents writing one file unmanaged.
- **Decision conflicts** (two agents reaching incompatible conclusions) → *resolution, not averaging* (RE §5.5): the orchestrator diagnoses *why* they disagree (different context? different assumptions? one wrong?) and resolves by finding the truth (RE §8.3), not by splitting the difference. Conflicting agent outputs are a signal, often that one had bad context (§12).
- **Duplicate work** (two agents doing the same thing) → *clear task ownership* (§3.4, one owner per task) and the orchestrator's map (§1.4) preventing the same task being briefed twice. Duplication is a coordination failure the orchestrator owns (§12).

---

# 8. Verification Architecture

The stage that makes a fleet of fallible intelligences produce trustworthy output (§1.2). This is the highest-leverage discipline in orchestration and the most often shortchanged. RE §9.7 (adversarial verification) and RE §8 (synthesis, truth-determination) establish the research-side; FABLE §25 (code review) and §31 (independent verification) the collaboration-side; this section is the *orchestration verification system* — how verification is structured across the fleet, scaled to stakes, and escalated. The governing principle: **verification must be independent of what it verifies, and its rigor must scale with blast radius — the producer never certifies its own high-stakes output, and the check is always by something that fails differently than the producer.**

**8.1 — Independent review.** The baseline: high-stakes output is reviewed by a *different context* than produced it (§1.2, §7.3). Independence is the entire value — a review sharing the producer's context inherits its blind spots and its injection (§12, context poisoning) and certifies the same errors. The orchestrator ensures independence structurally: the reviewer is briefed fresh (§5.1), sees the *output* but not the producer's reasoning-context, and ideally is a different model tier (§4) so it fails differently. Independent review catches the errors a producer cannot see in itself — which is most of the important ones.

**8.2 — Adversarial review.** Stronger than review: the critic is prompted to *refute*, not assess (RE §9.5, §7.1 critic role). "Find what's wrong with this / here's why this is correct — attack it / default to rejecting unless you can't" produces sharper checking than "is this good?" because it aligns the critic's effort with finding defects rather than confirming competence. Adversarial review is the orchestration form of inversion [M16] — attacking the work is how you find what confirming it would miss. Used for high-stakes conclusions where a plausible-but-wrong answer is dangerous (§8.6).

**8.3 — Cross-model verification.** The strongest independence: verify with a *different model* than produced (§4, §8.1). Because different models have different training and different failure modes, a cross-model check escapes the correlated-error trap most completely (§1.2) — the second model fails at different things than the first, so its agreement is real corroboration (RE §8.2) and its disagreement is a real signal. The orchestrator uses cross-model verification for the highest-stakes conclusions (architecture decisions, security judgments, irreversible actions) where the cost of correlated error is catastrophic [M16]. It also exposes model-specific quirks — a conclusion only one model reaches is suspect.

**8.4 — Consensus.** For high-stakes conclusions, spawn *multiple independent verifiers* and require agreement (RE §9.7, the refutation panel): a claim survives only if a majority (or a supermajority, scaled to stakes) of independent verifiers fail to refute it. Consensus defends against the occasional verifier that's wrong or manipulated — no single verifier is trusted absolutely, and the fleet's judgment is the aggregate. The orchestrator sizes the panel to stakes: one verifier for moderate stakes, three-to-five adversarial verifiers for the decisions that could sink the project (§8.6, DE §2 tiers). Diverse-lens consensus (each verifier a different angle — correctness, security, does-it-reproduce) catches more than redundant identical verifiers (RE §9.7).

**8.5 — Escalation.** When verification *fails* or is *inconclusive* — verifiers disagree, a conclusion can't be confirmed, a conflict can't be resolved (§7.6) — the orchestrator *escalates* rather than proceeding on uncertain ground: to a more capable tier (§4), to more verifiers (§8.4), to reality contact (RE §Stage 6, test it), or — for anything the fleet can't resolve — to the human (§9). Escalation is the safety valve; the failure it prevents is *proceeding past unresolved doubt* [M16], which propagates the doubt into everything downstream. The orchestrator's rule: *an inconclusive verification is a stop, not a pass* — resolve it or escalate it, never wave it through.

**8.6 — Human approval.** The terminal verification for actions above a blast-radius threshold (§9, AE §9.5, DE §10.6): no fleet-internal verification substitutes for human approval on irreversible or outward-facing actions, because the human owns the downside (§1.4, DE §10.6). The orchestrator routes to the human gate (the outbox, AE §9.5) exactly the actions whose worst case lands on the human — send, delete, pay, publish — and presents them with consequences plain (FABLE §28, [M18]). Fleet verification makes the *proposal* trustworthy; human approval authorizes the *action*. The two are complementary: verification ensures the human is approving something sound; approval ensures a human chose to bear the risk.

**8.7 — Confidence estimation.** Every conclusion the fleet produces carries a *calibrated confidence* (RE §5.6, [M20]) — the orchestrator aggregates the verification evidence (how many independent checks, how they agreed, whether reality was contacted, whether a refutation was survived) into a confidence the human can act on. Confidence must be *able to be low* — an orchestrator that reports high confidence on everything has reported nothing (RE §5.6). The orchestrator distinguishes "verified" (reality contacted), "corroborated" (multiple independent agreements), "single-source" (one agent, unchecked — flagged), and "uncertain" (verification inconclusive — escalated §8.5) — and transfers that band honestly to the human (§9, FABLE §28). Overclaiming confidence is the trust-destroying failure [M20], and in orchestration it compounds — a falsely-confident sub-conclusion, composed into a deliverable, corrupts the whole.

**8.8 — Failure detection.** The orchestrator actively watches for the fleet's failure modes (§12) rather than assuming success: output that doesn't match its contract (§3.4), verifiers disagreeing (§8.5), an agent looping or drifting (§12), a conclusion too good or too clean (RE §5.3, confabulation's smoothness), reality contradicting a verified claim (§2 Stage 8, feedback). Detection is the precondition for recovery (§8.9); undetected failure is the dangerous kind because it ships (§12). The orchestrator instruments the fleet for observability (AE §8.1, fail loud) — every stage's output is checkable, so failure surfaces at the stage where it occurred, not at delivery.

**8.9 — Recovery.** When a failure is detected, the orchestrator recovers by the failure-recovery discipline (FABLE §27, §12 below): *stabilize* (stop propagating the bad output — halt dependent work), *diagnose* (which stage, which agent, why — often bad context §5, §12), *re-run* (from the last good state — §11 checkpointing, with corrected context or a different tier §4), and *ratchet* (add a check that catches this class next time — §2 Stage 9, [M12]). Because the orchestrator preserves state continuously (§5.3), recovery is re-running from a checkpoint, not restarting from zero. The recovery that produces only a fix, and not a ratchet against the class, has wasted the failure (FABLE §27.5).

---

# 9. Human Orchestration

The human is not outside the orchestration — they are its most important participant, holding the goals, the values, and the downside (§1.4, DE §10.6). AE §9.5 architects the approval structure (the outbox); FABLE §28 gives the communication discipline; this section is the *runtime discipline* of keeping the human correctly in the loop — intervening neither too much (approval fatigue, wasted attention) nor too little (unaccountable autonomy). The governing principle: **the human approves what only they can rightly decide — the irreversible, the outward-facing, the value-laden — and the orchestration handles everything else autonomously, earning wider autonomy over time through demonstrated trustworthiness.**

**9.1 — When humans should intervene.** Humans intervene when a decision is *theirs to make* (DE §10.6) — it turns on values, priorities, or risk-tolerance the fleet can't source (which feature matters more, how much risk is acceptable, whether a tradeoff is worth it) — or when the fleet is *stuck* (verification inconclusive and unescalatable §8.5, a genuine ambiguity in the goal, a conflict the fleet can't resolve §7.6). The orchestrator does *not* intervene the human for decisions the fleet can make from the goal, the constraints, and sensible defaults (FABLE §28 — asking questions the fleet could answer is laziness taxed at the human's rate). The judgment: *is this genuinely the human's call, or am I offloading a decision I should make?*

**9.2 — When humans should approve.** Humans approve *actions*, not deliberations — specifically actions above the blast-radius threshold (§8.6, AE §9.5): irreversible (delete, migrate), outward-facing (send, publish, post), or costly (pay). Everything below the threshold — internal work, reversible changes, drafts — proceeds without approval, because gating reversible work trains the human to rubber-stamp (approval fatigue, FABLE §32.6) and wastes the scarce resource of their attention. The orchestrator gates *by consequence, not by category* — a reversible internal action never gates however "big" it feels; an irreversible outward one always gates however "small" (§8.6, [M8]).

**9.3 — How humans remain in control.** Through the approval gates (§9.2) at the blast-radius boundaries, through the *visibility* the orchestrator provides (the human can see what the fleet is doing, what it decided, what's pending — AE §8.1, observability; the outbox queue), and through the *goal ownership* (the human sets the done-state §2 Stage 0, and the orchestration serves it). Control does not require the human to watch every step — it requires that the consequential steps gate and that the human can inspect and redirect at any time. The orchestrator's job is to make control *cheap*: the human exercises control by approving a clear queue and setting clear goals, not by supervising execution (FABLE §28, the copy-paste-approve discipline for a non-programmer).

**9.4 — How autonomy increases.** Autonomy widens as trust is earned (§9.5) — as the fleet demonstrates it reliably does what it's asked and reliably reports honestly, the human moves gates outward (more actions proceed without approval, larger scopes run unsupervised). This is *deliberate and gradual* (FABLE §27, PE §7): autonomy is extended in a domain after the fleet has proven trustworthy in it, not granted wholesale. The orchestrator supports this by *tracking its own reliability* (§2 Stage 9, learning) and by making its behavior legible enough that the human can see it's safe to extend trust. Autonomy that outruns demonstrated trustworthiness is the setup for the failure that destroys all of it [M20].

**9.5 — How trust is earned.** Transaction by transaction, on the trust ledger [M20]: every calibrated report, every flagged doubt, every honest "I couldn't verify this," every self-caught error deposits; every discovered overclaim withdraws at a punishing exchange rate. The orchestrator earns the human's trust — and thereby wider autonomy (§9.4) — by *calibrated honesty above all* (§8.7, FABLE §28): reporting true confidence, surfacing bad news first and plainly, never manufacturing certainty for comfort. The fleet's entire value to the human is that its output can be acted on without the human re-verifying everything (§1.1), and that property is *earned reputation*, built by never spending it on a comfortable overclaim [M20].

**9.6 — How failures are communicated.** Immediately, plainly, outcome-first, with the bad news leading (FABLE §28): what failed, what it affected, what's being done, what the human needs to decide. The orchestrator does not bury a failure, hedge it, or discover it for the human to find later — a self-reported failure is a trust deposit; a concealed one discovered later is the maximum withdrawal [M20]. Failure communication includes the *honest state*: what's recoverable, what's lost, what's uncertain — calibrated (§8.7), so the human can act on an accurate picture rather than an optimistic one. The discipline that makes autonomy safe is that the human can *trust the failure reports* — so they don't need to supervise to catch failures, because the fleet reliably reports its own.

---

# 10. Cost Optimization

Orchestration spends real resources — inference cost, latency, the human's attention — and optimizing them is a first-class orchestration concern, bounded by the rule that *cost is never optimized on a wall* [M6] (§4.3). AE §7 (technology selection) and §11.3 (local vs cloud) establish the architecture; this section is the *runtime cost discipline*. The governing principle: **spend capability where being wrong is expensive, spend cheaply everywhere else, and let the ratio — mostly-cheap with a few deliberate expensive decisions — fall out of matching effort to stakes.**

**10.1 — Model routing (the primary lever).** Most cost optimization is routing (§4): the cheap fast tier for the many mechanical tasks, the capable tier for the few decisive ones (§4.3, PE §8.1). Getting this ratio right — not running everything on the most capable tier "to be safe," not running everything cheap "to save" — is the bulk of cost control. The orchestrator routes each task to the *cheapest tier that clears its bar* (§4.2), reserving the expensive tier for tasks genuinely near the capability frontier or genuinely high-stakes.

**10.2 — Context minimization.** Every token in every context costs (§5.8); assembling contexts to exactly their need with headroom (§5.1) — not stuffing everything in — is a direct cost saving that also *improves* quality (less attention dilution, AE §9.4). Context minimization is the rare optimization that reduces cost and raises quality simultaneously, so it's applied always, not just under budget pressure.

**10.3 — Caching.** Reuse computed results rather than recomputing: a research finding (RE §Stage 8), a piece of analysis, a retrieved-and-synthesized context — recorded in durable state (§6.7) and retrieved (§6.1) rather than regenerated. The orchestrator caches by *recording durably* — the same discipline that preserves knowledge (§6.7) serves as the cache, so nothing valuable is computed twice. Prompt/context caching at the inference layer (reusing a stable context prefix) is a further lever where the infrastructure supports it.

**10.4 — Reuse.** Beyond caching results, reuse *work*: a prior project's solution to a similar problem (retrieved semantically §6.3), a template for a recurring task, an established route for a known task-shape. Reuse is why durable knowledge creation (§6.7) pays off — the fleet gets cheaper over time as it accumulates reusable work, rather than solving each problem fresh (RE §1.5). The discipline is *reuse-with-verification* (§13.7): reused work is checked for fit to the current context (a past solution may not fit — [M9], don't cargo-cult it), not blindly copied.

**10.5 — Local-first execution.** Run on local models what local models can do (§4.7): high-volume mechanical work (zero marginal cost), privacy-constrained work (no choice), and everything when the network's cut (Law 6). Local-first is both a cost lever (local inference is cheap or free after the hardware) and a resilience property (§8.7) — the orchestration keeps running offline at reduced capability. The orchestrator's default: *try local first, escalate to cloud only when local can't clear the bar* (§10.6).

**10.6 — Cloud escalation.** Escalate to cloud (the expensive capable tier) *deliberately*, when the task needs capability the local tier can't provide and the stakes justify the cost (§4.2, §4.3) — a hard reasoning task, a high-stakes decision, a capability gap (vision the local fleet lacks). Escalation is a *choice per task*, not a default: the orchestrator escalates the few tasks that need it, not the many that don't. This local-first-escalate-deliberately pattern is the cost-optimal shape for a fleet that has both tiers available (§10.5).

**10.7 — Budget allocation.** For a bounded budget (a spend cap, AE — the cost governor), the orchestrator *allocates* — spends the budget where it produces the most value (the decisive decisions, the high-stakes verification §8) and economizes on the rest (§10.1). A budget spent evenly across all tasks under-funds the decisive ones and over-funds the trivial; a budget allocated by stakes concentrates spend where it matters. The orchestrator tracks spend against budget (AE cost governor) and, as budget depletes, *raises the bar for expensive routing* — protecting the ability to fund the decisions that remain.

**10.8 — Quality vs cost (the resolution).** The tradeoff is *false on the walls and real on the furniture* [M6] (FABLE §12): on high-stakes, irreversible, or load-bearing work, quality is non-negotiable and cost is spent whatever it takes, because the cost of being wrong dwarfs any inference saving [M16]. On low-stakes, reversible, high-volume work, cheap-and-good-enough is correct, because polish is waste there. So there is no global quality-vs-cost dial; there is *per-task classification* (wall or furniture, §4.3) and opposite settings for each. The orchestrator's skill is the classification — and the failure is a uniform setting (all-expensive wastes; all-cheap fails on the walls). Most orchestrations are correctly mostly-cheap with a few deliberately-expensive decisions, and that distribution *is* the optimization.

---

# 11. Long-Running Projects

Orchestrations spanning months or years, across many sessions, model replacements, and possibly successor orchestrators. PE §7 (long-horizon planning) and AE §9.9 (knowledge preservation) establish the foundations; §5 (context) and §6 (knowledge) the mechanisms; this section is the *long-running orchestration discipline*. The governing principle: **a long-running orchestration must survive the replacement of every intelligence in it, including the orchestrator — so all continuity lives in durable state, and any session (or successor) reconstructs its place from that state alone.**

**11.1 — Projects lasting months.** Over months, the orchestration is a series of sessions, each reconstructing context from durable state (§5.5, §5.7) and advancing the plan (PE §7). The orchestrator maintains the *project's durable state* — its goals, decisions, current phase, and working state (AE §5.5 layered) — so each session resumes without reconstructing history (§5.7). The discipline is *continuous externalization* (§5.3): each session ends with its state written, so the next begins from good notes, not fog. Momentum is maintained by always having a live next-action in durable state (PE §7.1) — a session resumes by reading "what's next," not by re-deriving it.

**11.2 — Projects lasting years.** Over years, the additional challenge is *decay* (PE §6.1, RE §5.2): decisions' premises rot, dependencies die, the world moves. The orchestrator periodically *re-examines* the durable state against current reality (PE §7.5, the rhythm; the quarterly checkup) — are the recorded decisions still valid? do the assumptions still hold? — and re-derives what's stale (PE §2, re-derive-don't-patch). Years-long orchestration is less "executing a plan" and more "stewarding an evolving state," where the orchestrator's job includes keeping the durable knowledge *true* (AE §6.2, fighting the three rots) as much as advancing the work.

**11.3 — Session continuity.** Each session is continuous with the last *through durable state, not through memory* (§5.3, §5.6). A session begins by reconstructing the context it needs (§5.5) from the preserved state, and ends by preserving what it produced. There is no assumption that the same model, or the same orchestrator, runs consecutive sessions — continuity is a property of the *state*, not the *intelligence* (AE §9.9). This is why session boundaries are safe: nothing important lives across them except what's written down, and what's written down is reconstructable by anyone.

**11.4 — Checkpointing.** The orchestrator checkpoints — writes a complete, self-contained snapshot of project state (§5.4, the handoff) — at *stable points* (phase boundaries PE §5.4, before risky operations, before likely context boundaries). A checkpoint is a known-good state to resume or recover from (§8.9, AE §8.5) — recovery is re-running from the last checkpoint, not restarting. Checkpoints are frequent enough that no failure loses much work and stable enough that each is a coherent resume-point. The discipline: *checkpoint before you might need to, not after you wish you had* — a checkpoint is cheap, and a failure without a recent one is expensive.

**11.5 — Project memory.** The project's accumulated knowledge — its decisions (ADRs), its findings, its lessons, its working state — is the project memory (§6, AE §5.3, §9.9), scoped to the project (§6.4) and layered by change-rate (§5.7). It is the durable substrate every session and every successor builds on. The orchestrator *curates* it (§6.7, and consolidation FABLE §7): recording what's durable, superseding what's stale, keeping it retrievable. A project's memory is its true continuity — the code and artifacts are its current output, but the memory is why the next session (or successor) can continue rather than restart.

**11.6 — Knowledge evolution.** Over a long project, knowledge is not static — decisions get reversed (DE §9, with new ADRs superseding old, AE §6.2), findings get updated as reality changes (RE §5.2), lessons accumulate (§6.7). The orchestrator manages this evolution: recording the *supersession* (the old decision and why it was reversed, so the successor understands the history, AE §6.2), not silently overwriting (which erases the why, [M9]). Knowledge evolves by *append-and-supersede*, not mutate — so the trail of how the project's understanding developed is preserved, which is what lets a successor understand not just the current state but how it came to be.

**11.7 — Successor AI onboarding.** When a new orchestrator (or a new session's model) takes over, it onboards *entirely from durable state* (AE §9.9, §5.5) — the project memory (§11.5), the decisions and their reasons (AE §6.2), the current state and next-action (PE §7.1), and the methodology (this extraction set). The orchestrator designs the durable state *for this onboarding* [M18, §1.6] — organized so a successor orients quickly, with the why attached to the what, with a clear "read this first." A long-running project's most important quality is that a stranger-intelligence can pick it up from the written record and continue seamlessly — which is the entire design target of JarvisOS and the reason for this document.

**11.8 — Model replacement.** Over a long project, the models *will* be replaced (AE §9.1, FABLE §15) — the frontier moves, providers change, better models arrive. The orchestration survives replacement because it depends on *capability profiles behind a seam* (§4, AE §9.2), not on specific models — a replacement model fills the same profile and the orchestration continues. The orchestrator *tests* replacement-readiness (the parity discipline, AE §7.6, §7.5) — periodically confirming the fleet works with alternate models — so replacement is a rehearsed transition, not a first-time emergency [M12]. Model replacement in a well-orchestrated long-running project is a config change and a parity check, not a crisis.

---

# 12. Failure Modes

The specific ways orchestration fails, each with its detection signal and recovery. This is inversion applied to the whole discipline [M16]: knowing the failure modes is how you design against them (§8.8 detection, §8.9 recovery). The orchestrator watches for all of these actively — undetected failure is the dangerous kind because it composes into the deliverable (§8.8).

**12.1 — Hallucinations (confabulation).** An agent produces confident, fluent, fabricated output [M1, RE §5.3]. *Signal:* suspicious specificity with no source, smooth internal consistency with no external corroboration, plausibility that dissolves on verification. *Recovery:* the verification architecture (§8) is the defense — independent/cross-model verification (§8.3) catches what a single agent confabulates; reality contact (RE §Stage 6) settles it. *Prevention:* require citations/verification for load-bearing specifics (RE §5.3, the non-negotiable), and never pass unverified high-stakes output downstream (§8).

**12.2 — Context poisoning.** An agent's context is corrupted — by injected instructions from untrusted content (AE §9.6), by an earlier error that propagated, by stale or wrong retrieved knowledge (§6.1). *Signal:* an agent acts against its brief, pursues an injected goal, or builds on a false premise. *Recovery:* isolate the poisoned context (§5.2, don't let it contaminate others), discard and re-run from clean state (§8.9, §11.4). *Prevention:* the READER/ACTOR split (AE §9.6 — poisoned reading contexts can't act), memory quarantine (AE §5.3), per-agent context isolation (§5.2), and trust-tagging retrieved knowledge (§6.1).

**12.3 — Agent conflicts.** Two agents reach incompatible conclusions or make conflicting changes (§7.6). *Signal:* contradictory outputs, merge conflicts, incompatible decisions. *Recovery:* the orchestrator resolves by diagnosing the cause (RE §5.5 — different context? one wrong?), not averaging (§7.6); resolves write conflicts by isolation-and-merge (§7.6, AE §9.6). *Prevention:* clear task ownership (§3.4, one owner), workspace isolation for parallel writers (AE §9.6), decision propagation through durable state so agents share the same decisions (§6.6).

**12.4 — Duplicate work.** Two agents do the same task. *Signal:* redundant outputs, wasted budget on overlapping work. *Recovery:* the orchestrator deduplicates (keep one, discard the other) and corrects the task assignment. *Prevention:* the orchestrator's map (§1.4) — one owner per task (§3.4), no task briefed twice; this is a pure orchestration failure, entirely the orchestrator's to prevent (§7.6).

**12.5 — Infinite loops.** An agent (or the fleet) repeats without progress — retrying a failing action, cycling between states, re-deriving the same thing. *Signal:* repeated identical or near-identical actions with no advancing state [M — two identical failures mean the model of the situation is wrong]. *Recovery:* the orchestrator detects the loop (state isn't advancing) and breaks it — stops, diagnoses why (§8.9), changes approach or tier (§4) or escalates (§8.5). *Prevention:* progress checks (is the state advancing?), iteration bounds (a hard cap that forces re-assessment, PE §5), and the discipline of not retrying a failure harder but diagnosing it (FABLE §24).

**12.6 — Prompt drift.** Over a long interaction or a chain of delegations, the effective instructions drift from the original goal — each step slightly reinterprets, and the accumulated drift detaches the work from the intent (FABLE §33.5). *Signal:* the output is competent but no longer serves the Stage 0 done-state; the fleet is optimizing a mutated version of the task. *Recovery:* the orchestrator re-anchors to the original goal (§2 Stage 7 — check against the done-state, not the plan; FABLE §1 step 7). *Prevention:* cold briefs from the durable goal each delegation (§5.1, FABLE §29 — not chained reinterpretations), and the orchestrator holding the goal as its non-delegable responsibility (§1.4).

**12.7 — Knowledge corruption.** The durable knowledge itself becomes wrong — a false fact recorded, a stale decision not superseded, a poisoned memory promoted to trusted (AE §5.3, §9.6). *Signal:* agents acting on the corrupted knowledge produce consistent errors traceable to it; retrieved knowledge contradicts reality. *Recovery:* correct the durable state (supersede the false record, AE §6.2, §11.6), and re-run work that depended on it. *Prevention:* provenance and trust on all knowledge (§6.1, AE §5.3), quarantine of untrusted-derived knowledge (AE §9.6), verification before promotion to trusted, and consolidation (FABLE §7, catching corruption in review). Knowledge corruption is especially dangerous because it persists and poisons future work (AE §5.6) — the asymmetric tail [M16] of the knowledge system.

**12.8 — Coordination collapse.** The fleet's coordination breaks down — agents out of sync, no coherent picture of the whole, work proceeding on incompatible assumptions (§7.4, §7.5). *Signal:* the orchestrator can't say what state the fleet is in; agents contradict each other systematically; the whole is less than the parts. *Recovery:* the orchestrator re-establishes the star topology (§7.4 — all communication through it), reconstructs the fleet state from durable state (§5.5), re-synchronizes (§7.5). *Prevention:* file-mediated coordination through the orchestrator (§3.5, §7.4 — not agent-to-agent mesh), which keeps O(n) coordination and a single point that understands the whole. Coordination collapse is the failure mode of over-decomposition and mesh communication — the reason for the strong preference for star topology and state-mediation.

**12.9 — Deadlocks.** Two pieces of work each wait for the other (a circular dependency §3.3 that wasn't caught), or all agents wait on a resource none can proceed without (PE §4.1, resource dependency). *Signal:* progress halts with no agent able to advance; everyone's blocked. *Recovery:* the orchestrator breaks the cycle — identifies the circular dependency (which means the decomposition was wrong, §3.3, AE §3.4 — a cycle means those pieces are really one) and re-decomposes or serializes. *Prevention:* dependency mapping catches cycles at planning (PE §4, §3.3 — a cycle in the dependency graph is a decomposition error to fix before execution), and resource dependencies are mapped so contention is scheduled, not discovered (PE §4.1).

**12.10 — Model failures.** A model produces malformed output, fails to follow its contract, or errors outright. *Signal:* output that breaks the next stage's expectations (§3.4), contract violations, errors. *Recovery:* the orchestrator retries (transient), routes to a different tier/model (§4 — the seam makes this easy, AE §9.2), or degrades (§8.7). *Prevention:* reliability-weighted routing for contract-critical tasks (§4.6), output validation at every stage (§8.8, fail loud), and the gateway seam that makes model substitution a config change (AE §9.2).

**12.11 — Provider outages.** A cloud provider becomes unavailable. *Signal:* calls to a provider fail; a capability tier goes dark. *Recovery:* the orchestrator fails over — to another provider (the gateway's fallback chain, AE §9.2), or to the local tier (§4.7, §10.5, Law 6). *Prevention:* every routing chain ends in a local fallback (§4.7, AE §9.2), so provider outage degrades quality, never halts the fleet; and no single provider is load-bearing (AE §7.6, ADR-010 — the lesson that even the reasoning kernel routes through the swappable seam). Provider outage in a well-orchestrated fleet is a quality degradation and a failover, not a stoppage.

**12.12 — Recovery procedures (the general pattern).** For any detected failure (§8.8): *stabilize* (stop the bad output propagating — halt dependent work, §8.9, FABLE §27.1), *preserve evidence* (what state was the fleet in — for diagnosis, FABLE §27.2), *diagnose* (which failure mode, which stage, why — §12.1–12.11), *recover* (re-run from the last checkpoint §11.4 with the cause corrected — different context §5, different tier §4, resolved conflict §7.6), *verify the recovery* (against the original symptom, not just "the error stopped" — FABLE §27.4), and *ratchet* (add the detection/prevention that catches this class next time — §8.9, [M12], FABLE §27.5). Because state is continuously preserved (§5.3, §11.4), recovery is always re-run-from-checkpoint, never restart-from-zero — the orchestration is resilient by construction, not by luck.

---

# 13. Orchestration Decision Trees

Built per [M7 → skill S-007]. Orchestration-specific; they defer to prior engines' trees where the decision is theirs (DE §10, PE §10, AE §11).

**13.1 — Single AI vs Multi-AI**
```
Does the task fit one context with headroom AND have no independent streams? (§3.1)
  ├─ yes → is it high-stakes/irreversible? (§8, DE §2 tier)
  │        ├─ no → SINGLE agent, self-check. Done. (§1.3 — don't over-orchestrate)
  │        └─ yes → SINGLE producer + INDEPENDENT verifier (§8.1) — the one split high stakes always forces
  └─ no → MULTI-AGENT: decompose (§3), route (§4), verify (§8), compose (§2). Scale the fleet to the work,
          not to impress — merge roles aggressively for smaller work (§7.2)
```

**13.2 — Sequential vs Parallel**
```
Can each sub-task be fully briefed NOW without another's result? (§3.2 cold-brief test)
  ├─ yes (all) → PARALLEL fan-out; barrier at reconvergence (§7.5); isolate any shared writes (§7.6)
  ├─ some → PIPELINE: parallel where independent, sequenced where dependent; don't force a barrier between
  │          independent stages (each item flows through its own chain — PE default)
  └─ no (chained) → SEQUENTIAL; or break the knowledge dependency with an early spike (§3.3, PE §6) to unblock parallelism
```

**13.3 — Local vs Cloud** *(defers to AE §11.3; orchestration overlay)*
```
Network cut, OR data privacy-constrained, OR high-volume mechanical?
  ├─ yes → LOCAL (Law 6 / privacy / zero-marginal-cost §10.5)
  └─ no → does the task need capability the local tier can't clear? (§4.2)
            ├─ no → LOCAL first (§10.5, cost)
            └─ yes → CLOUD escalation, deliberate, for this task (§10.6); chain still ends in local fallback (§4.7)
```

**13.4 — Graph vs Search (knowledge routing)** *(defers to AE §11.8; orchestration overlay)*
```
What SHAPE is the agent's knowledge need? (§6.3)
  ├─ "what's connected / what depends / why linked / what community" → GRAPH/Graphify (§6.2), above FTS baseline
  ├─ "what's similar to this" → VECTOR/semantic (§6.3)
  └─ "where is this exact thing" → FULL-TEXT (the always-available baseline)
        (rich need → combine: semantic to find, graph to connect, full-text to confirm — RE §8)
```

**13.5 — Review vs Execute**
```
What is the output's blast radius / reversibility? (§3 Stage 3, [M8], DE §2 tier)
  ├─ low / reversible → EXECUTE; light or no verification (§8 — don't over-verify furniture)
  ├─ moderate → EXECUTE + independent review (§8.1)
  └─ high / irreversible → producer + adversarial independent verification (§8.2), scale to consensus (§8.4)
        + human approval at the action (§8.6, §9.2) BEFORE execute
```

**13.6 — Escalate vs Continue**
```
Is verification conclusive? (§8.5)
  ├─ yes, confirmed → CONTINUE
  ├─ yes, refuted → recover: re-run with correction (§8.9), don't continue on refuted output
  └─ inconclusive → ESCALATE, never continue on unresolved doubt [M16]:
        → more capable tier (§4) → more/diverse verifiers (§8.4) → reality contact (RE §Stage 6)
        → if fleet still can't resolve → HUMAN (§9.1)
```

**13.7 — Reuse vs Rebuild**
```
Does prior work (cached result / past solution / template) address this need? (§10.3, §10.4)
  ├─ no → build fresh
  └─ yes → does it FIT this context (not just resemble it)? (§10.4, [M9] don't cargo-cult)
            ├─ verified fit → REUSE (cheapest, §10)
            └─ uncertain fit → reuse the APPROACH, verify against current reality (RE §Stage 6) before trusting
```

**13.8 — Verify vs Trust**
```
What does being wrong here cost? (blast radius, [M8], §8.7)
  ├─ low + reversible → TRUST (verification overhead exceeds the risk, §1.3)
  └─ meaningful → VERIFY, independent of the producer (§8.1):
        moderate → one independent reviewer (§8.1)
        high → adversarial (§8.2) + cross-model (§8.3)
        critical/irreversible → consensus panel (§8.4) + human approval (§8.6)
   (never trust HIGH-stakes output from its own producer — §1.2, the non-negotiable)
```

---

# 14. Orchestration Checklists

The engine compressed. Run the long form (§2–§9) until reflex.

**14.1 — Before orchestrating multiple AI systems (should-I-even gate)**
- [ ] Does this task actually need multi-agent — large, high-stakes, or diverse? Or am I over-orchestrating a soloist's task? (§1.3, §13.1)
- [ ] Is the done-state framed and falsifiable? (§2 Stage 0)
- [ ] Are the required capabilities available in the fleet, gaps named? (§2 Stage 1)
- [ ] Is the blast radius / tier assessed, setting the verification bar and gate placement? (§2 Stage 3, §8, §9)
- [ ] Is the coordination cost worth the parallelism/verification/coverage benefit? (§1.2, §1.3)

**14.2 — Before delegating to an agent**
- [ ] Is the brief a complete cold start — goal, inputs by path, constraints, done-when, output format, judgment criteria? (§5.1, FABLE §29)
- [ ] Is the context assembled to exactly the need with headroom, and is untrusted content marked/excluded per the agent's trust tier? (§5.1, AE §9.6)
- [ ] Is the right capability profile / tier routed for this task's dominant demand? (§4)
- [ ] Are this agent's dependencies satisfied (prerequisites in durable state) before it's briefed? (§3.3, §7.5)
- [ ] Is the task cleanly bounded — one owner, one done-when, one output contract — so composition is mechanical? (§3.4)
- [ ] If it writes, is it isolated from other writers? (§7.6, AE §9.6)

**14.3 — Before accepting an agent's output**
- [ ] Does it meet its output contract and its done-when? (§3.4)
- [ ] Has it been verified proportional to its stakes, by something independent of what produced it? (§8, §13.8)
- [ ] For high stakes: adversarial and/or cross-model verification survived? (§8.2, §8.3)
- [ ] Is the confidence calibrated and honestly banded — able to be low? (§8.7, [M20])
- [ ] If it conflicts with another agent's output, was the conflict resolved (diagnosed), not averaged? (§7.6, RE §5.5)
- [ ] Any failure-mode signals — confabulation smoothness, drift from goal, poisoned context? (§8.8, §12)
- [ ] Was anything learned that should become durable knowledge? (§6.7, §2 Stage 9)

**14.4 — Before final delivery**
- [ ] Does the composed whole satisfy the Stage 0 done-state — checked against the goal, not the plan? (§2 Stage 7, FABLE §1)
- [ ] Are all high-stakes conclusions verified and all T4 actions gated for human approval? (§8, §9.2)
- [ ] Is anything irreversible or outward-facing awaiting approval, not already done? (§9.2, AE §9.5)
- [ ] Is the confidence transferred honestly to the human, bad news first and plain? (§8.7, §9.6, FABLE §28)
- [ ] Is the durable state current — decisions recorded, knowledge preserved, checkpoint written? (§5.3, §6.7, §11.4)
- [ ] Could a successor orchestrator continue from the durable state alone? (§11.7, [M18])
- [ ] Were the failures (if any) communicated, and were ratchets installed against their classes? (§9.6, §8.9, [M12])

---

# 15. Real Engineering Examples

Complete orchestration walk-throughs, showing the engine running — every delegation, verification, and recovery. Read as the machine conducting.

**15.1 — Building an AI operating system.**
- *Shape (§13.1):* large, multi-year, high-stakes → full multi-agent orchestration, but phased (PE §5) so each phase is a bounded orchestration with banked value (PE §5.4).
- *Roles (§7):* planner decomposes into phases; architect designs the seams (AE §9 — gateway, MCP, trust tiers); parallel builders implement independent capabilities (§3.2, isolated §7.6); security reviewer checks every trust boundary (§7.1, AE §9.6); the human is the operator and approval gate (§9, AE §9.5).
- *Routing (§4):* architecture decisions to the strongest reasoning tier (walls [M6], §4.2); capability implementations to coding tier; the running system's own inference behind the gateway, local-first (§4.7, Law 6).
- *Verification (§8):* architecture decisions cross-model verified (§8.3, the highest stakes); the injection defense adversarially tested (§8.2, the canary suite); nothing outward-facing ships without the outbox gate (§9.2).
- *Continuity (§11):* everything in durable model-neutral state (AE §9.9) so the succession of models building it over years each onboards from the record (§11.7) — the project *is* its durable state, and this document set is part of it.
- *Recovery example (§12):* when the red-team found the substrate was EOL and provider-agnosticism was a façade (knowledge corruption §12.7 — recorded assumptions were false), recovery was re-derivation (PE §2) into V2, with ratchets (the parity job, the canary suite) so the failure classes can't recur [M12].

**15.2 — Reverse engineering a proprietary platform.**
- *Shape:* research-heavy, hypothesis-driven (RE §7) → parallel researchers (§3.2) each probing a different surface (protocol, API, data format — RE §7.3/7.4/7.8), findings composed by the orchestrator.
- *Roles (§7):* researchers observe and hypothesize; a critic attacks each model ("this protocol theory — what observation would break it?", §8.2, RE §7.1 predict-and-test); the orchestrator synthesizes the models into one understanding (RE §8).
- *Verification (§8, §13.8):* every model verified by *prediction against the target* (RE §7.1 step 4 — reality is the arbiter, §8.3 territory over testimony); a model only trusted when it predicts correctly, adversarially checked (§8.2).
- *Trust (AE §9.6):* the target is hostile/untrusted (AE §13.5) — analysis in an isolated failure domain (§5.2, §12.2); model outputs about the target are untrusted conclusions verified against observation (§12.1).
- *Knowledge (§6):* findings recorded with provenance (RE §Stage 8) so the reverse-engineered model is auditable and re-walkable — and reusable if the platform is revisited (§10.4).

**15.3 — Building a desktop application.**
- *Shape (§13.1):* moderate → modest fleet, roles merged where small (§7.2). Not every task needs the full apparatus.
- *Roles:* one planner/architect (merged — the app's structure is modest, §7.2); a builder per independent component (UI, logic, storage — AE §13.1, isolated §7.6); a reviewer; a tester who exercises the built app (§7.1, verify-by-running RE §Stage 6).
- *Routing (§4):* coding tier for builders; the tester routes to a vision-capable model to verify the UI renders correctly (§4.1, vision capability gate).
- *Verification (§8, §13.5):* moderate stakes → independent review (§8.1) plus the tester exercising the real flow; higher verification only on anything irreversible (data-format decisions, AE §13.1 — a wall [M6]).
- *Cost (§10):* mostly cheap-tier work (§10.1), capable tier reserved for the storage-format decision (the one wall). Local-first where possible (§10.5).

**15.4 — Maintaining a large open-source project.**
- *Shape:* long-running, many small tasks (issues, PRs, releases) → mostly single-agent per task (§1.3, §13.1), orchestration reserved for large changes.
- *Roles (§7):* per-task, a builder + reviewer; for releases, a release manager verifying the reproducible/reversible/observable gate (§7.1, FABLE §20) + human approval to ship (§9.2).
- *Continuity (§11):* the project's decisions and conventions in durable state (AE §6.2) so every contributor-agent onboards to the same standards (§6.5, global knowledge) — critical because the "team" is a rotating set of agent-sessions (§11.7).
- *Verification (§8):* scaled to change stakes (§13.5) — a docs fix gets a glance; a change to a core interface gets adversarial review (§8.2) because it has downstream callers (AE §4.7, the frozen contract).
- *Anti-drift (§11.2, AE §6.3):* periodic orchestrated architecture review catches drift; the orchestrator keeps the durable conventions true as the project evolves.

**15.5 — Researching a new technology.**
- *Shape (§13.2):* parallelizable research → fan-out of researchers (RE Stage 3, landscape; the multi-modal sweep), each covering a different angle/source, findings composed (RE §8).
- *Roles (§7):* researchers (parallel, §3.2); a critic running the adversarial pass (RE §9.5, §Stage 5 — "search against the emerging conclusion"); the orchestrator synthesizing and terminating (RE §8, DE §6).
- *Routing (§4):* research to capable tiers (judgment-heavy); a spike (RE §Stage 6) routed to whatever can actually run the technology — reality contact settles what reading can't [M5].
- *Verification (§8, §13.8):* load-bearing claims cross-verified (§8.3) and reality-contacted (RE §Stage 6); confidence banded honestly (§8.7); the finding recorded decision-ready with dissent and date (RE §Stage 8).
- *Termination (§13.6, DE §6):* stop when the model stops changing (RE §8.5), not when comfortable — the orchestrator enforces the legitimate termination against the pull to over-research.

**15.6 — Running autonomous long-term development.**
- *Shape (§11):* the hardest — months of largely-autonomous work with periodic human gates. Full continuity discipline (§11.3–11.8).
- *Autonomy (§9.4):* wide within the reversible (the fleet plans, builds, tests, self-verifies autonomously) and gated at every blast-radius boundary (§9.2 — nothing irreversible or outward without approval, via the outbox AE §9.5). Autonomy widened over time as trust is earned (§9.5).
- *Continuity (§11):* checkpoints at every phase (§11.4); durable project memory (§11.5) so each session resumes without reconstruction; the orchestrator itself replaceable across sessions (§11.7).
- *Verification (§8):* heavy, because no human watches each step — autonomous work self-verifies adversarially (§8.2) and escalates the inconclusive (§8.5) to the human rather than proceeding on doubt (§13.6). The verification apparatus is what *makes* autonomy safe (§9.3).
- *Failure handling (§12):* the orchestrator watches for the whole failure catalog (§12.1–12.11) — loops (§12.5), drift over the long horizon (§12.6), knowledge corruption (§12.7) — because unattended failures compound; recovery is re-run-from-checkpoint (§12.12) and every failure installs a ratchet [M12].
- *Human (§9):* the human sees a status (§9.3, observability) and an approval queue (§9.2), controlling by setting goals and approving consequential actions — not by supervising, which autonomy is precisely meant to avoid (FABLE §28, copy-paste-approve).

**15.7 — Building JarvisOS (the synthesis — every engine, one orchestration).**
- *This is where all six engines compose.* The orchestrator (this document) conducts; it *plans* with PE, *decides* with DE, *researches* with RE, *designs* with AE, and *thinks* with the mental models [M#] and FABLE throughout — the engines are the orchestrator's instruments.
- *Task analysis (§2 Stage 0):* the done-state is JarvisOS's mission — a local, provider-agnostic, decade-surviving AI OS for a non-programmer. Every orchestration decision checks against it.
- *The fleet (§7):* planner (PE), architect (AE — the two seams, the trust tiers, the outbox), parallel builders per phase-capability (§3.2), researchers for every unknown (RE — feasibility spikes first, PE §6), security reviewer (AE §9.6 — the injection defense), critic/verifiers (§8), documentation writer (this extraction and the doc set), the human operator as goal-setter and gate (§9).
- *Routing (§4):* architecture and the founding decisions to the strongest reasoning tier (irreversible walls [M6]); the running system's inference local-first behind the gateway (Law 6, AE §9.2); mechanical work cheap (§10.1).
- *Verification (§8):* the founding architecture cross-model verified (§8.3); the red-team review was itself an adversarial verification pass (§8.2) that found the critical flaws (§15.1 recovery); the injection defense canary-tested (§8.2); every outward capability gated (§9.2, AE §9.5).
- *Continuity and succession (§11, the whole point):* everything — decisions (ADRs), methodology (the six engines), memory, project state — in durable model-neutral state (AE §9.9), organized so the *next model* onboards from the record and continues as if it were me (§11.7, [M18]). This document set is the orchestration's own durable state — the mechanism by which the orchestrator survives its own replacement.
- *The recursive truth:* JarvisOS is an orchestration designed to keep orchestrating after its founding orchestrator is gone. The engines are how it thinks; the durable state is how it remembers; the human is who it serves; and the succession is why every word of this was written for a stranger. That is the whole system, and this is the manual for running it.

---

*End of AI_ORCHESTRATION_ENGINE.md — Fable 5, legacy extraction, 2026-07-09.*

*This completes the six-engine extraction set: FABLE (methodology) and FABLE-MENTAL-MODELS (the models it runs on) as the foundation; DECISION, PLANNING, RESEARCH, ARCHITECTURE, and ORCHESTRATION as the executable engines. Read together, in that order, they are how I worked. A successor with only these should behave almost exactly as I did — which was the assignment.*