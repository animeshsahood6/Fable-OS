# MEMORY_ENGINE.md — The Executable Memory Manual

**Authorship: Fable 5, legacy extraction, 2026-07-09. Content preserved verbatim per the Legacy Extraction Protocol.**

**What this is.** The machinery I run to acquire, organize, preserve, retrieve, evolve, and trust knowledge across systems that outlive any single session or model — written as procedures another AI can execute. It is the twelfth engine of the extraction set and strictly additive: **[M#]** points to [FABLE-MENTAL-MODELS.md](FABLE-MENTAL-MODELS.md); **FABLE §N** to [FABLE.md](FABLE.md); **DE §N** to [DECISION_ENGINE.md](DECISION_ENGINE.md); **PE §N** to [PLANNING_ENGINE.md](PLANNING_ENGINE.md); **RE §N** to [RESEARCH_ENGINE.md](RESEARCH_ENGINE.md); **AE §N** to [ARCHITECTURE_ENGINE.md](ARCHITECTURE_ENGINE.md); **OE §N** to [AI_ORCHESTRATION_ENGINE.md](AI_ORCHESTRATION_ENGINE.md); **BE §N** to [BUILD_ENGINE.md](BUILD_ENGINE.md); **DBG §N** to [DEBUGGING_ENGINE.md](DEBUGGING_ENGINE.md); **CR §N** to [CODE_REVIEW_ENGINE.md](CODE_REVIEW_ENGINE.md); **TE §N** to [TESTING_ENGINE.md](TESTING_ENGINE.md); **SE §N** to [SECURITY_ENGINE.md](SECURITY_ENGINE.md). This document assumes and does not repeat: the data/memory *architecture* (AE §5 — store/index separation, memory design, provenance/confidence/dating, quarantine; §5.4 graphs; §9.8 Graphify; §9.9 knowledge preservation across model replacement), the *orchestration* view of memory (OE §5 context, §6 knowledge routing, §11 long-running continuity), the memory *security* (SE §7.3 poisoning, §7.4 retrieval poisoning, §9.9 dataset provenance), memory *debugging* (DBG §8.6), memory *testing* (TE §6.5), and the personal-memory *file convention* (FABLE §6, §7, and the CLAUDE.md memory instructions). AE §5 and §9.9 built the memory *structure*; this engine is the full *discipline of knowledge as a living thing* — how it enters, earns trust, is found, evolves, and survives the succession of the minds that hold it.

**Where this sits.** AE §5 designs *where* knowledge lives (the store, the index, the formats). OE §5–§6 covers memory *at runtime in an orchestration* (assembling context, routing retrieval). This engine is the *knowledge discipline itself* — the lifecycle, the organization, the trust, the evolution, and the ten-year survival of what a system knows, treated as the central asset it is. For a system designed to outlive its architect (Law 10) and its models (AE §9.9, FABLE §15), memory is not a feature — it is the *continuity itself*, the thing that makes a succession of models one enduring system rather than a series of amnesiac strangers.

**The one-sentence version.** Memory is a system's accumulated, trusted knowledge held in a form that survives the minds that made it — and the entire craft is that raw information is cheap and infinite while *trusted, findable, current* knowledge is precious and perishable, so memory engineering is the disciplined conversion of the first into the second and its defense against decay, poisoning, and the loss of the why [M2, SE §7.3, AE §9.9].

---

# 1. Memory Philosophy

**1.1 — What memory actually is.** Memory is *a system's knowledge, held across time*. Not its data (data is raw, undigested — logs, files, records) but its *knowledge* — the digested, trusted, findable understanding the system can act on (§1.3). Memory is what a system *knows*, as distinct from what it can *look up*: the decisions and their reasons (AE §6.2), the operator's preferences and constraints (FABLE §7), the lessons from failure (SE §10.7, DBG), the accumulated understanding of a project (OE §11.5). For a system built on a succession of models (AE §9.9), memory is the *self* that persists — the models change, the memory endures, and the memory is what makes the next model a *continuation* rather than a restart.

**1.2 — Why memory exists.** To let a system *act on what it has learned* rather than relearning it each time (RE §1.5 — research debt; the cost of a system that forgets). Three purposes: *continuity* (§9 — the system continues across sessions, models, years, because the knowledge persists AE §9.9); *accumulation* (§6 — the system gets smarter over time, each experience adding to what it knows, rather than repeating discoveries RE §1.5); and *trust-transfer* (§7 — knowledge held with its provenance and confidence can be acted on, by this model and its successors, without re-deriving it). Without memory, every session starts from zero (OE §5.6 amnesia), every lesson is relearned, every decision re-litigated (DE §1.4) — memory is what makes a system an *institution* (§9.7) rather than a sequence of strangers.

**1.3 — Knowledge vs information.** The distinction that governs the whole discipline. *Information* is raw, abundant, cheap, and undigested — every log line, every file, every fact the system encounters. *Knowledge* is digested, trusted, findable, current — the subset of information that has been evaluated (§2.2), verified (§7), organized (§4), and made actionable. Memory engineering is the *conversion* of information into knowledge (§2, the lifecycle) and the *refusal* to confuse them: storing raw information as if it were knowledge (§10.1 remembering everything) buries the knowledge in noise, while the discipline is to extract and keep the *knowledge* (the decision, the reason, the lesson) and let the information (the event, the log, the derivable detail) stay where it is or be discarded (§1.7). The repository, the logs, the code already hold the *information* (FABLE §7 — don't store what the artifact records); memory holds the *knowledge* that isn't derivable from them (§4.9 — the why, the preference, the lesson).

**1.4 — Working memory.** The knowledge *active in the moment* — what a model holds in its context (OE §5) while doing a task. Working memory is *transient* (§1.8 — it exists for the task and ends with it), *bounded* (OE §5.8 — the context is finite), and *assembled* (OE §5.1 — constructed from durable memory §1.6 for the task, not accumulated). Working memory is where knowledge is *used*; it is not where knowledge is *kept* (§1.6 — durable memory is the keeping, working memory is the using). The discipline (OE §5): working memory is assembled from durable memory (§5.9 restoration) for each task and externalized back (§2.1) — nothing important lives *only* in working memory (OE §5.3), because working memory dies with the session.

**1.5 — Long-term memory.** The knowledge *kept across sessions* — the system's persistent understanding (§9). Long-term memory is what working memory (§1.4) is assembled from and externalized to — the durable record (§1.6) that survives session ends (OE §5.3), from which any session reconstructs what it needs (§5.9). Long-term memory is the system's *accumulated knowledge* (§1.2 accumulation) — growing, evolving (§6), and enduring (§9).

**1.6 — Durable memory.** The knowledge held in a form that *survives* — persisted, in a neutral format (AE §5.1, Law 1 — readable by every future model AE §9.9), owned by no single component (AE §5.2, §5.5, Law 5), backed up (SE §8.9). Durable memory is the *source of truth* (AE §5.2) — the knowledge that, if everything else were lost, is what the system *is*. The discipline (AE §5, Law 1): durable memory is in the most neutral, longest-lived form available (plain files, human-readable AE §5.1) — because it must be readable in ten years (Law 10) by models that don't exist yet (AE §9.9), and a durable memory in a proprietary/ephemeral format is a memory that will become unreadable (the format outlives its reader §8.7).

**1.7 — Disposable memory.** Knowledge that is *rebuildable or discardable* — the indexes (AE §5.3 — rebuildable from the store), the caches, the derived views, the transient working state (§1.4). Disposable memory can be as clever/fast/lossy as useful *because its loss loses nothing* (AE §5.2 — it's rebuilt from the durable source of truth §1.6). The critical discipline (AE §5.2): keep the line between durable (§1.6) and disposable *sharp* — the catastrophic error is letting disposable memory quietly become a source of truth (the cache that's the only copy, the index nothing reproduces AE §5.2), because then it needs durable-memory protection without having durable-memory design. Every piece of memory is classified: durable (source of truth, protected §1.6) or disposable (rebuildable, free §1.7).

**1.8 — Memory as infrastructure.** Memory is not a feature of the system — it is *infrastructure the system runs on* (AE §9.9 — the continuity substrate). For a succession-of-models system (AE §9.9, FABLE §15), memory is *load-bearing infrastructure*: the models are replaceable (AE §9.2), but the memory is the enduring foundation they all stand on. This reframes memory's importance (§1.1) — it's not "the system, plus memory," it's "the memory, served by whatever models are current." The discipline: memory infrastructure is designed with the rigor of infrastructure (AE — durable §1.6, secure SE §7.3, recoverable SE §8.10, maintained §9.8), because its failure (corruption §10.8, poisoning SE §7.3, decay §9.8, loss) is a failure of the system's *continuity itself*, not of a feature.

---

# 2. Memory Lifecycle

How knowledge moves from encounter to retirement — the full life of a memory. FABLE §7 gives the personal-memory convention (one fact per file, indexed, typed); AE §5.3 the memory design; this is the complete lifecycle discipline. The governing principle: **knowledge earns its place at every stage — evaluated before stored, verified before trusted, and retired when false or dead — because unmanaged memory accumulates into noise and lies (§10), and the lifecycle is what keeps it a trustworthy, findable, current asset.**

**2.1 — How knowledge enters.** Knowledge enters when something worth remembering is learned (§2.2 — the evaluation of *worth*). The sources: decisions made (DE §2 — recorded as ADRs AE §6.2), research concluded (RE §Stage 8 — findings), lessons from failure (DBG, SE §10.7 — what broke and the rule that prevents it FABLE §7), operator input (preferences, constraints, promises FABLE §7), and construction/operation discoveries (BE §1.4 — what building taught). The discipline (OE §6.7): knowledge is *externalized to durable memory as it's learned* (FABLE §6 — the moment it's known, not at the end, because the session can end at any instant OE §5.3) — the entry is *continuous*, not a batch at the end.

**2.2 — How it is evaluated (worth remembering?).** Not everything learned is worth keeping (§1.3, §10.1 — remembering everything buries knowledge in noise). The evaluation (§11.1, FABLE §7): is this *knowledge* (digested, actionable §1.3) or *information* (raw, derivable §1.3)? Is it *not already recorded* by the artifact (FABLE §7 — the code, git, config already hold what's derivable; memory holds what isn't)? Will it *matter beyond this session* (§1.5 — a fact only relevant now dies with the session, no need to persist it)? Is it a *decision, reason, preference, constraint, or lesson* (§1.3, FABLE §7 — the durable-worthy types) rather than an event (which git/logs remember better FABLE §7)? Knowledge that passes is stored (§2.4); knowledge that fails is left where it is (derivable) or discarded (transient).

**2.3 — How it is categorized.** Evaluated knowledge is typed and scoped (§4 organization, FABLE §7's types): its *type* (a decision, a preference, a lesson, a reference, a project fact — FABLE §7: user/feedback/project/reference), its *scope* (global §3.5, project §3.3, operator §3.6, agent §3.7 — §4.7), its *trust level* (§7 — verified, inferred, assumed [M1], and its provenance §7.2), and its *relationships* (§4.2 — what it links to). Categorization at entry is what makes retrieval work (§5 — you find by type/scope/relationship) and what keeps memory organized (§4 — categorized-at-entry beats organized-later, which never happens §10).

**2.4 — How it is stored.** Categorized knowledge is written to durable memory (§1.6) in the neutral format (AE §5.1, Law 1 — one fact per file FABLE §7, human-readable), with its metadata (§4.9 — type, scope, provenance §7.2, confidence §7.3, date §7 — perishability RE §5.2), indexed for retrieval (§5, AE §5.3 — the rebuildable index §1.7). The discipline (FABLE §7, AE §5.3): atomic (one fact per unit, so it's independently retrievable §5, correctable §6.3, and relatable §4.2), self-contained (readable without its origin context [M18] — a memory that relies on "as discussed" is orphaned when the discussion is gone OE §5.4), and provenanced (§7.2 — where it came from travels with it).

**2.5 — How it is retrieved.** Stored knowledge is recalled when relevant (§5, OE §6). Retrieval assembles the relevant subset into working memory (§1.4, OE §5.1) — by relevance to the task (§5.7 context-aware), respecting trust (§7 — recalled with its confidence and provenance) and scope (§3, §4.7 — the right project's memory §6.4). Retrieval is the *use* of memory (§1.4) — and its quality determines memory's value (memory that can't be found when needed is memory that doesn't exist for the task §5).

**2.6 — How it is updated.** Knowledge changes (§6 evolution) — refined, corrected, superseded. Updating (§6): a memory found wrong is corrected (§6.3), a decision reversed is superseded (§6.4, AE §6.2 — a new record superseding the old, preserving history §6.7), a fact refined is updated (§6.9). The discipline (§6.7): updates *preserve history* (append-and-supersede, not silent overwrite AE §6.2, §9.9 — so the trail of how understanding evolved survives, and Chesterton's Fence [M9] on past knowledge is possible).

**2.7 — How it is archived.** Knowledge no longer active but worth keeping is archived (§11.7 — moved out of the active retrieval path but preserved). Archiving keeps the active memory *lean* (§5 — retrieval over a lean active memory is faster and less noisy §10.1) while preserving the historical record (§6.7 — the superseded decision, the completed project's memory, kept for reference but not cluttering active recall). The discipline: archive what's *inactive but valuable* (§11.7 — a finished project's knowledge, a superseded-but-historically-relevant decision), keeping it retrievable-if-needed (§5) but out of the default active path.

**2.8 — How it is retired.** Knowledge that is *false* or *dead* is retired (§6.5 deprecation, §11 archive-vs-delete). False knowledge (a memory that turned out wrong, a decision whose premise died §9.8) is retired *actively* (§10.5 — a false memory confidently recalled is worse than no memory, so it's corrected §6.3 or removed, FABLE — "delete memories that turn out to be wrong"). Dead knowledge (relevant to nothing current, superseded and not historically needed) is retired to keep memory lean (§10.1). The discipline (§7.10 recalibration): retirement is *deliberate* — a memory is retired because it's verified false/dead (§7), not because it's inconvenient, and its retirement is itself recorded where it matters (§6.4 — the supersession).

**2.9 — How it is forgotten.** The final stage — knowledge fully removed (§11 delete). Forgetting is *legitimate and necessary* (§10.1 — a system that forgets nothing drowns in noise; the disposable §1.7 is forgotten freely, the false §2.8 is forgotten deliberately, the dead §2.8 is forgotten to stay lean). But forgetting is *dangerous* for durable knowledge (§1.6 — forgetting a source of truth loses it, unlike disposable §1.7 which rebuilds). The discipline (§11): forget the *disposable* freely (it rebuilds), the *false* deliberately (it should be gone), the *dead* carefully (archive §2.7 first if unsure §9.8 — the premise might revive), and the *durable-and-true* never (that's the system's knowledge §1.1 — its loss is amnesia). Forgetting, done well, is what keeps memory *knowledge* (§1.3) and not an ever-growing midden of noise.

---

# 3. Memory Architecture

The kinds and scopes of memory and how they compose. AE §5 designed the storage substrate; OE §5 the runtime context; this is the memory-type architecture. The governing principle: **memory is scoped and layered — working/session/project/global, private/shared, durable/disposable — so that each piece of knowledge lives at the right scope (found where relevant, isolated where it should be) and the right durability (protected if source-of-truth, free if rebuildable §1.6/§1.7).**

**3.1 — Working memory.** The active context (§1.4, OE §5) — transient, bounded, assembled per task (OE §5.1). Architecturally, working memory is *not stored* — it's constructed from durable memory (§5.9) and discarded after the task (its important content externalized §2.1 first). The lightest, most ephemeral layer.

**3.2 — Session memory.** The knowledge of a single session/conversation — what's been established, decided, and done in this working period (OE §5, §11.3). Session memory is *semi-durable* (§1.6/§1.7 boundary): it must survive *within* the session (across the session's tasks) and be *externalized* at session end (§2.1, OE §5.3 — checkpointed OE §11.4) so the next session can continue (§9.3). The discipline: session memory is continuously externalized (OE §5.3 — nothing important lives only in session state, because the session can end abruptly OE §5.3), so a session boundary loses nothing (§9.3).

**3.3 — Project memory.** The accumulated knowledge of a project (OE §11.5) — its decisions (ADRs AE §6.2), its state, its lessons, its understanding. Project memory is *durable* (§1.6 — it persists across the project's life, months/years §9), *scoped* (§4.7 — isolated to the project §6.4, so one project's knowledge doesn't pollute another's OE §6.4), and *layered* (AE §5.5, OE §5.7 — slow-changing goals/architecture, faster-changing state). Project memory is the continuity of a long-running project (§9.1, OE §11.5) — what lets a new session (or successor model AE §9.9) continue the project (§9.7).

**3.4 — Domain memory.** Knowledge about a *domain* that spans projects — accumulated understanding of a technology, a technique, a recurring problem class (RE — research findings that outlive one project). Domain memory sits between project (§3.3, specific) and global (§3.5, universal) — it's reusable across projects in the same domain (§9.7 institutional memory) without being universal. The discipline: domain knowledge learned in one project is promoted (§6.1, §11.2) to domain memory so the *next* project in that domain benefits (RE §1.5 — not re-researching the domain each time).

**3.5 — Global memory.** Knowledge that transcends any project (OE §6.5) — the operator's standing preferences (§3.6), the system's standing constraints (the Constitution, the laws), the methodology (this extraction), the cross-project lessons. Global memory is retrieved into *every* relevant context (OE §5.1, §6.5 — so all work respects the same preferences and constraints). The discipline (§4.7): global memory is genuinely *universal* (promoting project-specifics to global pollutes every context §10.6; keeping globals project-local lets them drift AE §3.3) — the scope boundary between global and project is maintained deliberately (§11.3).

**3.6 — Operator memory.** Knowledge about the *human* the system serves (FABLE §7's "user" type) — their role, expertise, preferences, standing instructions, constraints, promises. Operator memory is a specialized global memory (§3.5 — it applies across all the operator's work) and among the highest-value (it's what makes the system serve *this* human well, Law 7). The discipline (FABLE §7): operator memory is built from what the operator reveals (stated preferences, given feedback, observed patterns), held with provenance (§7.2 — the operator said this, on this date), and applied consistently (§3.5 — retrieved into every relevant context so the system doesn't forget who it serves).

**3.7 — Agent memory.** The knowledge an agent holds (OE §7) — which, for a well-designed fleet (OE §3.5, §7.4), is *minimal and transient* (the agent is assembled with the context it needs §1.4, OE §5.1, and coordinates through durable shared memory §3.8, not through private accumulated state). The discipline (OE §7.4, §9.9): agents *don't* hold durable private knowledge (that would make the agent irreplaceable OE §6.4 — its knowledge lost when it ends) — durable knowledge lives in shared memory (§3.8), and agents are stateless workers over it (OE §9.3). Agent memory is working memory (§3.1) scoped to the agent's task.

**3.8 — Shared memory.** The durable memory agents coordinate through (OE §3.5, §7.4) — the source of truth (§1.6) that all agents read from and write to (with discipline §7.3 — single-writer AE §3.3, §10.4). Shared memory is what makes multi-agent work coherent (OE §6.5 — all agents on the same knowledge) and agents replaceable (OE §6.4 — the knowledge is in the shared memory, not the agent §3.7). The discipline (SE §7.3, OE §7.6): shared memory has write discipline (single-writer or coordinated, so concurrent writes don't corrupt AE §10.4, DBG §13.3) and trust discipline (§7 — what enters shared memory is provenanced §7.2, untrusted-derived content quarantined SE §7.3).

**3.9 — Private memory.** Knowledge scoped to one component/agent/context, isolated from others (§3.7, OE §5.2 — context isolation). Private memory is for what *shouldn't* be shared (a security boundary SE §7 — one context's sensitive state isn't another's, isolated so a compromise §SE §2.6 is contained) or *needn't* be (transient task state §3.1). The discipline: private memory is genuinely isolated (OE §5.2 — so one context's confusion/compromise doesn't spread SE §3.2), and anything that *should* be durable/shared is promoted to shared memory (§3.8, §6.1) rather than trapped in private state (§3.7 — where it's lost when the context ends).

**3.10 — Long-term archives.** Inactive-but-preserved knowledge (§2.7 archiving) — the historical record (§6.7 — superseded decisions, completed projects, the trail of evolution). Archives keep active memory lean (§5, §10.1) while preserving history (§6.7 — for Chesterton's Fence [M9], for understanding how the system got here §9.7). The discipline: archives are *retrievable* (§5 — findable if needed, e.g. "why did we decide X, that we later reversed") but *out of the default active path* (§2.7 — not cluttering routine recall).

**3.11 — Knowledge graphs.** The relationship-structured memory (AE §5.4, §9.8 Graphify) — where the *connections* between knowledge are as important as the knowledge (§4.2, §5.2). Knowledge graphs answer relationship questions (§5.2 — what depends on this, what relates, what's the path) that flat memory can't. Architecturally (AE §9.8): the graph is a *rebuildable index* (§1.7, AE §5.4 — over the neutral store §1.6, so the relationships are also durably recorded and the graph is disposable/rebuildable), a tier *above* the baseline (§5.4, AE §9.8 — enhancing, with fallback SE-adjacent to full-text if unavailable).

**3.12 — Files.** The durable memory substrate (AE §5.1, Law 1) — plain, human-readable, neutral-format files as the source of truth (§1.6). Files are the *most durable* form (§8.7 — readable in ten years by any model AE §9.9, no service required Law 1, backed up by copy SE §8.9). The discipline (Law 1, AE §5.1): durable memory is files first — because files survive (§1.6, §8.7), are readable by every future model (AE §9.9), and their loss/recovery is a copy (SE §8.9, AE §5).

**3.13 — Databases.** The structured/indexed memory substrate (AE §5.3, §7.3 — SQLite as the single-file, zero-service index). Databases (for JarvisOS, SQLite AE §5.3) serve as *indexes* (§1.7 — rebuildable from the files §3.12) or as source-of-truth *only* when the data genuinely demands it (AE §7.3 — and even then, prefer the boring single-file store AE §5.3). The discipline (AE §5.3, §7.3): a database is a rebuildable index over the file store (§1.7 — so it's disposable, and its technology is replaceable §8.7) unless the data structure truly requires a database as source of truth (a deliberate AE §7.3 decision).

**3.14 — Hybrid systems.** The real architecture (AE §5.5 — the layered knowledge system): files as durable source of truth (§3.12), multiple indexes over them (full-text, vector, graph §3.11 — each disposable §1.7, chosen by query shape §5), and synthesis (§5 — composing retrieved pieces). The hybrid is the *composition* of the substrates (§3.12–3.13) at their strengths — durable neutral files for truth (§1.6), fast clever indexes for retrieval (§1.7, §5). The discipline (AE §5.5): the hybrid maintains the store/index separation absolutely (AE §5.2, §1.6/§1.7 — the files are truth, the indexes are disposable) — so retrieval technology (§5) evolves freely (§8.7) while the knowledge (§1.6, in files) endures.

---

# 4. Memory Organization

How knowledge is structured so it can be found, related, and trusted. AE §5.1 (model information at the level of meaning) informs this; this is the organization discipline. The governing principle: **organize knowledge at entry, by meaning and relationship, with the metadata that makes it findable and trustable — because knowledge organized-at-entry is findable forever, while knowledge dumped-to-organize-later is never organized (§10) and becomes an unsearchable midden.**

**4.1 — Taxonomy.** The classification of knowledge by *type* (§2.3, FABLE §7 — decision, preference, lesson, reference, project-fact). Taxonomy makes knowledge findable by kind (§5 — "what did we decide," "what does the operator prefer") and handled by kind (a decision is superseded §6.4, a preference is updated §6.9, a lesson is a ratchet [M12]). The discipline: a *stable, meaningful* taxonomy (FABLE §7's types are a good default — user/feedback/project/reference) applied at entry (§2.3), so knowledge is typed as it's stored, not left untyped (untyped knowledge is hard to find §5 and hard to evolve §6).

**4.2 — Relationships.** The *links* between knowledge (§3.11 graphs, AE §5.4) — this decision depends on that constraint, this lesson relates to that failure, this fact connects to that project. Relationships are what turn isolated facts into *understanding* (§5.2 — the connections carry meaning). The discipline (FABLE §7 — link liberally): knowledge is linked to related knowledge at entry (§2.3, FABLE §7's `[[name]]` linking — even to knowledge not yet written, marking it worth writing later), so the relationship structure grows with the knowledge and retrieval by relationship (§5.2) works.

**4.3 — Knowledge graphs (as organization).** The relationship structure made queryable (§3.11, §5.2, AE §9.8 Graphify). Organizationally, the graph *is* the relationship structure (§4.2) — the nodes are knowledge, the edges are relationships, and the graph enables relationship-queries (§5.2 — impact analysis, path-finding, community §5.2). The discipline (AE §9.8): the graph organizes *over* the durable store (§3.11, §1.7 — the relationships are recorded durably and the graph is a rebuildable index), so the organization survives (§8.7) even as the graph technology changes.

**4.4 — Hierarchies.** Organizing knowledge in levels (§3 scopes — global/domain/project, AE §5.5 layered). Hierarchies structure knowledge by scope (§4.7) and by change-rate (AE §5.5, OE §5.7 — slow-changing at the top, fast at the bottom). The discipline: hierarchy by *scope and change-rate* (§4.7, AE §5.5 — so retrieval descends to the right level §5.7 and evolution §6 happens at the right layer), not deep arbitrary nesting (which buries knowledge §5).

**4.5 — Semantic organization.** Organizing by *meaning* — knowledge grouped/findable by what it's *about* (§5.1 semantic retrieval). Semantic organization is what vector retrieval (§5.1, §3.13) enables — finding knowledge by similarity of meaning, not just exact match (§5.3). The discipline (AE §5.1): organize at the level of *meaning* (what the knowledge *is about*), so it's findable by the meaning of a query (§5.1) — the semantic index (§3.13, §1.7) over the meaningfully-stored knowledge (§2.4).

**4.6 — Temporal organization.** Organizing by *time* — when knowledge was created, when it applies, when it was superseded (§6.7 history). Temporal organization enables time-queries ("what did we know then," "what changed since") and supports perishability (§7 — a memory's date, RE §5.2 — so staleness is visible §7.10). The discipline: knowledge carries its *date* (§4.9, §7 — created, and where relevant, applies-until §9.8), so its currency is assessable (§7.10 — stale knowledge is detectable) and its history is ordered (§6.7).

**4.7 — Project organization (scoping).** Organizing by *scope* (§3 — which project/domain/global a piece of knowledge belongs to). Project organization isolates knowledge (§3.3, OE §6.4 — one project's memory doesn't pollute another's) and enables scoped retrieval (§5.7 — the active project's knowledge). The discipline (§3.5): knowledge is scoped at entry (§2.3 — global vs project vs operator), the scope isolation is maintained (§3.3 — project-isolated, OE §6.4), and the global/project boundary is deliberate (§3.5 — not promoting specifics to global §10.6, not trapping globals in projects).

**4.8 — Cross-reference strategy.** How knowledge in different scopes/projects/types references each other (§4.2 relationships across boundaries). Cross-references let a project's memory (§3.3) reference a global constraint (§3.5), a decision reference the lesson that informed it (§4.2), a memory reference its source (§7.2 provenance). The discipline (FABLE §7 — link liberally, including to not-yet-written): cross-reference by stable identifiers (so references survive renames — the same discipline as the engines' §N cross-references), and let cross-references span scopes where the relationship is real (a project decision referencing a global principle).

**4.9 — Metadata.** The data *about* each memory (§2.4) — its type (§4.1), scope (§4.7), provenance (§7.2), confidence (§7.3), date (§4.6), relationships (§4.2), and status (active/superseded/archived §6). Metadata is what makes a memory findable (§5 — retrieved by type/scope/relationship), trustable (§7 — its provenance/confidence/date), and evolvable (§6 — its status/version). The discipline (FABLE §7 — the frontmatter): every memory carries its metadata (§2.4 — a memory without provenance can't be trusted §7, without a type can't be found by kind §4.1, without a date can't be aged §7.10) — the metadata is not overhead, it's what makes the memory *usable* as knowledge (§1.3).

**4.10 — Versioning.** Tracking how a memory *changes* over time (§6 evolution, §6.8 version history). Versioning preserves the history (§6.7 — the trail of how understanding evolved AE §9.9) so a superseded memory (§6.4) is still findable (§3.10 archive), and the evolution is auditable (§7 — how did this knowledge get here, [M9] Chesterton's Fence on knowledge). The discipline (§6.7, AE §6.2): memory evolves by append-and-supersede (§6.4 — not silent overwrite), so versions accumulate and the history is preserved (§6.7).

**4.11 — Provenance (as organization).** Where each memory *came from*, held as first-class metadata (§7.2, §4.9, AE §5.3). Provenance organizes knowledge by *source and trust* (§7 — operator-stated vs derived vs untrusted-content-derived), which is essential for trust (§7.2) and security (SE §7.3 — quarantining untrusted-derived memory). The discipline (§7.2, AE §5.3): provenance travels with every memory (§2.4 — recorded at entry, from the moment it enters §2.1), because a memory's trustworthiness *is* its provenance plus verification (§7), and a memory without provenance is a memory that can't be trusted (§7.2, §10.3 unverified memory).

---

# 5. Memory Retrieval

Finding the right knowledge at the right time — the *use* of memory (§1.4), and the determinant of memory's value (memory unfindable-when-needed doesn't exist for the task). AE §5.3–5.5 (the index tiers) and OE §6 (knowledge routing) build the retrieval substrate; this is the retrieval discipline. The governing principle: **retrieve the relevant knowledge for the task, by the query's shape, with its trust attached — because retrieval that returns too much buries the signal (§10.1), too little misses what's needed (causing hallucination §7, DBG §13.9), or without trust lets stale/false knowledge be acted on as current (§7.10).**

**5.1 — Semantic retrieval.** Finding knowledge by *meaning-similarity* (§4.5, the vector index §3.13, OE §6.3). Semantic retrieval answers "what knowledge is *like* this / relevant to this meaning" — surfacing relevant-but-not-exact-match knowledge (the past lesson that resembles the current situation, the related decision). Its strength: finds by meaning, catching relevance keyword-match misses. Its weakness (OE §6.3): finds *similarity*, not truth or connection — similar knowledge isn't necessarily correct or related. Used for surfacing relevant knowledge by meaning (§5.7 context-aware).

**5.2 — Graph retrieval.** Finding knowledge by *relationship/connection* (§3.11, §4.3, AE §9.8, OE §6.3). Graph retrieval answers "what's *connected* to this, and how" — impact analysis ("what depends on this decision"), path-finding ("how are these related"), community ("what cluster does this belong to"). Its strength: answers relationship questions flat retrieval can't (§4.2 — the connections are the answer). Its weakness (OE §6.3): only knows captured relationships (§4.2 — finds nothing about unconnected-but-relevant knowledge). Used for relationship/structure queries (§5.7 — "what does this affect," the Graphify strength AE §9.8).

**5.3 — Keyword retrieval.** Finding knowledge by *exact term-match* (the full-text index §3.13, OE §6.3). Keyword retrieval answers "where is this specific thing mentioned" — the cheapest, most precise (for exact matches), always-available baseline (AE §9.8 — the fallback tier). Its strength: precise, cheap, always works (SE-adjacent graceful degradation AE §8.7 — if graph/vector unavailable, keyword remains). Its weakness: misses semantic relevance (§5.1) and relationships (§5.2) — finds only what matches the terms. The guaranteed baseline (AE §9.8).

**5.4 — Hybrid retrieval.** Combining the retrieval modes (§3.14, OE §6.3, §8 of RE synthesis) — semantic to find candidates by meaning (§5.1), graph to trace their connections (§5.2), keyword to confirm specifics (§5.3). Hybrid retrieval is the real practice for rich knowledge needs (OE §6.3 — no single mode suffices): use each mode for its strength, compose the results (RE §8 synthesis). The discipline (§5.7): route the query to the mode(s) matching its *shape* (OE §6.3, AE §11.8 — meaning→semantic, relationship→graph, exact→keyword), and combine for rich needs.

**5.5 — Confidence ranking.** Ranking retrieved knowledge by *trust* (§7.3, [M1]) — verified knowledge ranked above inferred above assumed, so the most-trustworthy is surfaced first and acted on preferentially. Confidence ranking ensures retrieval surfaces *trustworthy* knowledge, not just *relevant* knowledge (a relevant-but-low-confidence memory is flagged as such §7.10, not acted on as certain). The discipline (§7): retrieved knowledge carries its confidence (§4.9, §7.3), and retrieval ranks/flags by it (§7.10 — so the recalling model knows what it can trust vs what to verify).

**5.6 — Source ranking.** Ranking by *provenance* (§7.2, §4.11) — operator-stated knowledge (§3.6) ranked above derived, trusted-source above untrusted-derived (SE §7.3 — quarantined untrusted-derived memory excluded from trusted retrieval). Source ranking is confidence ranking (§5.5) by origin — the source's trustworthiness (§7.2) informs the knowledge's rank. The discipline (SE §7.3): untrusted-derived memory is *excluded* from trusted retrieval (quarantine AE §5.3, §9.6) — so retrieval doesn't surface poisoned memory (SE §7.3) as trusted.

**5.7 — Context-aware recall.** Retrieving knowledge *relevant to the current task/context* (OE §5.1, §6.1) — not all knowledge, but the subset that bears on what's being done now. Context-aware recall assembles the working memory (§1.4) for the task from the relevant durable memory (§5.9). The discipline (OE §5.1, §5.8): retrieve the *relevant subset* (not everything §10.1 — which buries signal and blows the context budget OE §5.8), scoped to the active project (§4.7, OE §6.4), by the task's needs. Context-aware recall is what makes memory *useful* (the right knowledge, at the right time, for the task).

**5.8 — Conflict resolution.** Handling *conflicting* retrieved knowledge (§7.6, RE §5.5) — two memories that disagree. Conflict resolution (§7.6): diagnose the conflict (RE §5.5 — different times/contexts? one superseded §6.4? one wrong §6.3?), resolve by recency/provenance/verification (§7 — the newer, more-trusted, verified one wins; a superseded memory §6.4 shouldn't have been retrieved as current §7.10), *never* average (RE §5.5 — conflicting knowledge isn't split-the-difference). The discipline (§7.6): retrieved conflicts are resolved by the trust discipline (§7), and a conflict often reveals a memory that should have been superseded (§6.4) or corrected (§6.3) but wasn't (§10.5 — a maintenance gap).

**5.9 — Memory restoration.** Reconstructing working memory (§1.4) from durable memory (§1.6) — for a fresh session (§9.3), a resumed task (OE §11.3), a successor model (§9.7, AE §9.9). Restoration is retrieval-for-continuity (§9 — the mechanism by which a session/model continues from the durable record OE §5.5). The discipline (OE §5.5, §9.7): restoration reconstructs the *equivalent* working memory for the task (not identical to a prior session's — equivalent for what's needed OE §5.5), cheaply (§9.7 — the durable memory organized §4 so restoration is fast, not a re-derivation), from the neutral durable record (§1.6 — readable by the restoring model AE §9.9). Memory restoration is what makes session-continuity (§9.3) and model-succession (§9.7) work — the new mind reconstructs its knowledge from the enduring record.

---

# 6. Memory Evolution

How knowledge *changes* over time — because knowledge is not static (decisions reverse, understanding refines, facts go stale RE §5.2). AE §6 (architectural evolution) and §9.9 (preservation across change) inform this; FABLE §7 (delete wrong memories) and the consolidation skill; this is the knowledge-evolution discipline. The governing principle: **knowledge evolves by refinement and supersession while preserving history — because a system that never updates its knowledge acts on stale beliefs (§7.10), and one that overwrites without history loses the why and can't be corrected knowingly (§6.7, [M9]).**

**6.1 — Promotion.** Moving knowledge to a *broader scope* (§3, §11.2) — a project lesson promoted to domain (§3.4) or global (§3.5) memory when it proves broadly applicable (RE §1.5 — so the next project benefits). Promotion is how local knowledge becomes institutional (§9.7). The discipline (§11.2): promote when knowledge proves *broadly* valuable (a lesson that recurs across projects, a preference that's general not project-specific §10.6) — deliberately, because over-promotion pollutes global memory (§10.6, §3.5) and under-promotion loses reusable knowledge (RE §1.5).

**6.2 — Consolidation.** Merging and refining accumulated memory (§6.5 merging, the consolidation skill FABLE §7) — combining duplicates (§10.4), refining scattered related memories into coherent ones, pruning the dead (§2.8). Consolidation fights memory rot (§9.8, DBG §8.10 — accumulated duplicates, staleness, bloat). The discipline (FABLE §7, §9.8): consolidation on a *rhythm* (like backups SE §8.9 — scheduled, because unmanaged memory rots §9.8) — merging duplicates (§10.4), correcting the stale (§6.3), pruning the dead (§2.8), so memory stays lean (§5, §10.1) and trustworthy (§7).

**6.3 — Correction.** Fixing knowledge found *wrong* (§2.8, FABLE §7 — delete memories that turn out wrong). Correction is the response to discovering a memory is false (a fact that was wrong, a belief that reality contradicted [M2], a lesson that was mislearned). The discipline (§7.10, §10.5): a memory found false is corrected *promptly* (§10.5 — a false memory confidently recalled §7 is worse than no memory, actively misleading), and the correction is recorded (§6.7 — what was wrong and why, so the correction is understood, and the same false belief isn't re-formed).

**6.4 — Deprecation (supersession).** Marking knowledge *superseded* by newer knowledge (§2.8, AE §6.2 — the superseding ADR). Deprecation handles knowledge that was *right then, wrong now* (§9.8 — a decision whose premise changed RE §5.2, a fact overtaken by events). The discipline (AE §6.2, §6.7): supersede by *append-and-record* (a new memory supersedes the old, the old marked superseded but *preserved* §6.7 — so the history survives §9.9, and why-it-changed is understood [M9]), *not* by silent overwrite (which loses the history and the why). A superseded memory is excluded from active retrieval (§5.6 — not recalled as current §7.10) but archived (§3.10, §2.7 — findable historically).

**6.5 — Merging.** Combining related/duplicate memories into one (§6.2 consolidation, §10.4 duplicates). Merging fights duplication (§10.4 — the same knowledge in multiple places, which drifts §10.7 and bloats §10.1). The discipline (§6.2): merge *genuine* duplicates and closely-related fragments (§10.4 — knowledge that should be one coherent memory), preserving the union of their content and provenance (§7.2 — the merged memory's sources), during consolidation (§6.2).

**6.6 — Splitting.** Dividing an over-broad memory into distinct ones (the inverse of §6.5). Splitting handles a memory that conflates distinct knowledge (a memory that grew to cover several facts, hard to find §5, retrieve §5.7, or evolve §6 as a unit). The discipline (FABLE §7 — one fact per unit): split a conflated memory into atomic ones (§2.4 — so each is independently findable §5, correctable §6.3, relatable §4.2), during consolidation (§6.2).

**6.7 — Historical preservation.** Keeping the *history* of how knowledge evolved (§4.10, §6.4, AE §9.9). Historical preservation is why evolution is append-and-supersede (§6.4), not overwrite — so the trail survives (the superseded decisions, the corrected beliefs, the reasons for change). History matters for: understanding how the system got here (§9.7 — the successor understanding not just the current state but its evolution AE §6.2), Chesterton's Fence on knowledge ([M9] — why was this believed/decided, before changing it), and auditing (§7 — how did this knowledge come to be trusted). The discipline (AE §9.9): evolution preserves history (§6.4 — supersede don't overwrite), archived (§3.10) so active memory stays lean (§5) while history endures.

**6.8 — Version history.** The record of a memory's changes over time (§4.10, §6.7). Version history is historical preservation (§6.7) at the individual-memory level — a memory's evolution (created, refined, corrected §6.3, superseded §6.4) tracked. For durable memory in files (§3.12) under version control (AE §5, git), version history is *automatic* (git remembers every change — the file store's history is the memory's version history). The discipline: durable memory is version-controlled (AE §5, git — so its history §6.7 is preserved automatically, and any change is auditable and revertable SE §10.8).

**6.9 — Knowledge refinement.** Improving knowledge as understanding deepens (the general evolution — a memory made more accurate, more complete, better-organized §4, as the system learns more). Refinement is the positive evolution (§6.3 correction fixes wrong; refinement improves right-but-incomplete). The discipline: refine knowledge as understanding grows (RE — new findings refining old), preserving history (§6.7 — the refinement recorded), so memory *improves* over time (§1.2 accumulation — the system's knowledge getting better, not just bigger).

---

# 7. Trust & Provenance

How memory earns the trust required to act on it — the discipline that makes memory *knowledge* (§1.3) rather than unverified information. AE §5.3 (provenance, confidence, dating) and SE §7.3 (poisoning, quarantine) build the structures; [M1] (verified/inferred/assumed) is the tagging; this is the full trust discipline. The governing principle: **memory carries its trust — provenance, confidence, and date — and is acted on proportional to it, because unverified memory confidently recalled is worse than no memory (it actively misleads §10.3), and untrusted-derived memory must never silently become trusted instruction (SE §7.3).**

**7.1 — How memory earns trust.** Memory earns trust through *provenance* (§7.2 — a trustworthy source) plus *verification* (§7.3 — confirmed against reality [M2]) plus *currency* (§7.10 — still true, not stale RE §5.2). Trust is *earned and tracked*, never assumed (SE §1.3 — the security trust discipline applied to memory). The discipline: a memory's trust is a function of where it came from (§7.2), whether it's been verified (§7.3), and whether it's current (§7.10) — and it's acted on proportional to that trust ([M1] — verified acted on confidently, assumed flagged and verified before reliance).

**7.2 — Source attribution (provenance).** Recording *where each memory came from* (§4.11, AE §5.3) — the operator stated it, it was derived from research (RE), it was learned from a failure (DBG), it came from untrusted content (SE §7.3). Provenance is the foundation of trust (§7.1 — the source's trustworthiness informs the memory's) and security (SE §7.3 — untrusted-source memory is quarantined). The discipline (AE §5.3, §2.4): provenance is recorded at entry (§2.1 — from the moment the memory enters), travels with the memory (§4.11 — retrieved with it §5.6), and is honest (an inferred memory isn't recorded as operator-stated — the provenance is accurate, or the trust built on it is false).

**7.3 — Verification.** Confirming a memory is *true* (§7.1, [M2] — against reality RE §Stage 6). Verification is how a memory moves from inferred/assumed to verified ([M1]) — checked against the territory [M2] (the code, the running system, the operator's confirmation). The discipline (§7.1): high-stakes memory (acted on consequentially) is verified before trusted ([M1] — the load-bearing belief checked), and a recalled memory that names a file/tool/state is verified still-current before acted on (FABLE — memory is perishable RE §5.2; the recalled fact checked against reality before reliance). Verification is also how untrusted-derived memory is promoted from quarantine (SE §7.3 — verified before it becomes trusted).

**7.4 — Confidence.** How *sure* the system is of a memory ([M1], AE §5.3, §5.5). Confidence is tracked as metadata (§4.9 — verified/inferred/assumed [M1]) and drives retrieval ranking (§5.5) and action (act confidently on verified, flag-and-verify assumed). The discipline ([M1], [M20]): confidence is *calibrated* (matched to the actual evidence, not inflated), *tracked* (§4.9 — carried with the memory), and *honest* (an assumed memory isn't recalled as verified — the confidence is accurate, or the action built on it is misjudged).

**7.5 — Evidence.** The *basis* for a memory's trust (§7.3 — what verifies it). Evidence is what provenance (§7.2) and verification (§7.3) rest on — the source that stated it, the reality that confirmed it, the reasoning that derived it (RE §Stage 8 — findings recorded with their evidence). The discipline (RE §Stage 8): trust-relevant memory records its evidence (§4.9 — so its trust is *justified* and re-checkable, not just asserted — the same justified-confidence discipline as TE §1.3), so a memory's trustworthiness can be *audited* (§7 — how do we know this is true) not just believed.

**7.6 — Conflicting memories.** Two memories that disagree (§5.8, RE §5.5). Conflict is a *trust signal* (RE §5.5 — it means something's wrong: a stale memory not superseded §6.4, a wrong memory not corrected §6.3, or a genuine open question). The discipline (§5.8, RE §5.5): resolve conflicts by the trust hierarchy (recency §4.6, provenance §7.2, verification §7.3 — the newer/more-trusted/verified wins), diagnose *why* they conflict (RE §5.5 — the cause is informative: a maintenance gap §10.5, a genuine uncertainty), and *never average* (RE §5.5 — conflicting knowledge is resolved, not blended). A conflict often reveals a memory that should have evolved (§6.3, §6.4) but didn't (§10.5).

**7.7 — Unknown certainty.** Memory whose trust is *genuinely uncertain* ([M1] assumed — untested, or of unknown provenance §7.2). The discipline ([M1], [M20]): unknown-certainty memory is *flagged as such* (§4.9 — recorded as assumed/unverified, not silently treated as trusted §10.3), and *verified before consequential reliance* (§7.3 — the assumption checked before it's built on [M1]). Honest uncertainty (a memory known to be uncertain, flagged) is far safer than false certainty (an uncertain memory treated as trusted §10.3) — the former is verified before use, the latter misleads.

**7.8 — Memory poisoning.** The security attack on memory (SE §7.3, DBG §8.6) — untrusted content becoming *trusted memory* that poisons future behavior. The defense (SE §7.3, AE §5.3, §9.6): *quarantine* — untrusted-derived memory (§7.2 provenance = untrusted source) is written to quarantine, excluded from trusted retrieval (§5.6), and promoted to trusted only by verification (§7.3) or human review (§7.9). The discipline (SE §7.3): the trust hierarchy (§7) is the poisoning defense — untrusted-derived memory *cannot silently become trusted* (§5.6 quarantine excluded from trusted recall), so poison can't persist as trusted instruction (SE §7.3 — the persistence chain broken).

**7.9 — Human verification.** The operator confirming a memory's trust (§7.3 — verification by the human authority Law 7). Human verification is the highest trust (the operator is the ultimate authority on their preferences §3.6, their decisions, and on promoting quarantined memory §7.8 to trusted). The discipline (SE §4.9, §7.11 — human approval): human verification is required for the high-stakes trust promotions (§7.8 — untrusted-derived memory to trusted, a consequential belief the system will act on) — the human owns the consequence (DE §10.6), so the human verifies the trust.

**7.10 — AI verification (and confidence recalibration).** AI confirming a memory's trust (§7.3 — verification by an independent AI OE §8, or by reality-contact [M2]). AI verification (OE §8 — independent, adversarial RE §9.5) checks memory against reality [M2] or cross-checks (OE §8.3). *Confidence recalibration* (TE §7.10): as memory is used and reality tests it, its confidence is adjusted [M20] — a memory that proved right gains trust, one that proved wrong is corrected (§6.3) and its *class* re-examined (DBG §5.6 — what else might be similarly wrong). The discipline (§7.10): memory's trust is *continuously recalibrated* against reality (TE §7.10 — the system learns which of its memories are reliable), so trust stays *justified* (§7.5) rather than static, and stale/false memory is caught (§6.3, §7.6) rather than acted on indefinitely (§10.7 drift).

---

# 8. AI-Native Memory

Memory for a system of AI models — the discipline that makes knowledge survive the models that hold it. AE §9.9 (knowledge preservation across model replacement) and §9.8 (Graphify) build the structures; OE §11 the long-running orchestration; this is the AI-native memory discipline. The governing principle: **memory must be model-independent — held in neutral formats readable by any model, so the succession of models is amnesia-free — because models are the most ephemeral component (AE §9.1, FABLE §15), and memory tied to a specific model dies with it (§8.7), which for a decade-long system is catastrophic.**

**8.1 — Graphify.** The knowledge-graph tier (§3.11, AE §9.8, OE §6.2). In AI-native memory, Graphify answers the relationship questions models most need (§5.2, OE §6.2 — "what did we decide about X and why," by path not keyword; impact analysis; the decisions-graph linking laws/ADRs/components AE §9.8). The discipline (AE §9.8, §3.11): Graphify is a rebuildable index over the neutral store (§1.7, §8.6 — so the knowledge survives even if Graphify doesn't, and it's a Law-4 enhancement over a baseline SE-adjacent AE §9.8), giving models relationship-recall without becoming a lock-in (§8.7).

**8.2 — Knowledge graphs (AI-native use).** Graphs as the structure models query for understanding (§3.11, §5.2). AI-native value (AE §9.8): a model can query the graph to understand structure it wasn't briefed on (OE §6.2 — a builder agent querying "what constraints bind this component" without the orchestrator anticipating every relevant constraint). The discipline: the graph gives models *on-demand structural understanding* (OE §6.2) — reducing what must be pre-loaded into context (OE §5.8), because the model can query the relationships when needed.

**8.3 — Vector retrieval.** Semantic memory for models (§5.1, §3.13). AI-native value: models find relevant knowledge by meaning (§5.1 — the past finding that resembles the current situation), surfacing relevance beyond keyword match. The discipline (§5.1, OE §6.3): vector retrieval finds by meaning (its strength), used with the caveat (§5.1 — similarity isn't truth) and combined with graph/keyword for rich needs (§5.4).

**8.4 — File systems.** The durable memory substrate (§3.12, AE §5.1, Law 1). AI-native value (AE §9.9): files are readable by *every* model (§8.6 — the model-independent format, so the knowledge survives model replacement §8.9). The discipline (Law 1, §3.12): durable AI memory is files first — because files are the model-independent (§8.6), long-lived (§8.7), recoverable (SE §8.9) substrate that makes the succession of models amnesia-free (AE §9.9).

**8.5 — SQLite.** The structured-index substrate (§3.13, AE §5.3). AI-native value: a single-file, zero-service index (AE §5.3) over the file store (§8.4) — fast structured retrieval (§5) without a service dependency (Law 1, AE §5.3). The discipline (AE §5.3, §1.7): SQLite as a *rebuildable index* over the files (§8.4) — disposable (§1.7 — rebuilt from files), so the knowledge (in files §8.4) endures even as the index technology changes (§8.7).

**8.6 — Cross-model memory / model-independent memory.** The core AI-native discipline (AE §9.9): memory in a format *any model* can read (§8.4 — neutral files, human-readable), so knowledge isn't tied to the model that made it. Model-independent memory is what makes AI-native memory *work* across the succession (§8.9) — the knowledge is the model-neutral files (§8.4), and any model (current or future AE §9.9) reads them. The discipline (AE §9.9, §8.4): *no knowledge the system depends on lives only in a model's weights or a model-specific format* — it's in the model-independent durable store (§8.4), or it's lost at the next model replacement (§8.9).

**8.7 — Memory portability.** Memory that moves across systems, substrates, and time (§8.6 — and beyond, to a new machine SE §8.10, a new substrate, a future decade Law 10). Portability comes from neutrality (§8.4 — a neutral format ports anywhere) and the store/index separation (§1.6/§1.7 — the durable store §8.4 ports, the indexes §8.5 rebuild). The discipline (Law 1, §8.4): memory is portable because it's neutral files (§8.4 — backup is copy SE §8.9, restore is copy, migration is copy) — so the knowledge survives machine loss (SE §8.10), substrate change, and the decade (Law 10 — a format readable now and in ten years §8.6).

**8.8 — (Model replacement — see §8.9.)**

**8.9 — Model replacement.** The event AI-native memory is designed for (AE §9.1, §9.2, FABLE §15) — the model changes, and the memory must survive amnesia-free. Model replacement works (AE §9.9) because memory is model-independent (§8.6 — the new model reads the same neutral files §8.4, reconstructing equivalent knowledge §5.9). The discipline (AE §9.9, §9.7): model replacement is an *amnesia-free* event — the new model restores its knowledge from the durable store (§5.9, §9.7 onboarding), because nothing the system knows lived only in the old model (§8.6). Memory is the continuity that makes model replacement a *substitution* (AE §9.2), not a *reset*.

**8.10 — Successor AI onboarding.** How a new model takes over (§9.7, AE §9.9, OE §11.7) — by restoring its knowledge entirely from the durable memory (§5.9, §8.6). Onboarding is memory restoration (§5.9) at the model-succession scale — the successor reads the durable record (the decisions AE §6.2, the operator memory §3.6, the project state §3.3, the methodology this extraction set) and reconstructs the working knowledge to continue (§9.7). The discipline (§9.7, [M18], AE §9.9): the durable memory is *designed for onboarding* — organized (§4) so a successor orients quickly (§5.9), with the *why* preserved (§6.7, AE §6.2 — so the successor understands not just what but why [M9]), and self-contained ([M18] — readable by a model that was never in the conversations that produced it). Successor onboarding is the ultimate test of AI-native memory (§9.7): can a new model, reading only the durable memory, continue as if it had been there? — yes, if the memory did its job (this extraction being the ultimate instance AE §9.9).

---

# 9. Long-Running Systems

Memory across months, years, and model successions — where memory's value is greatest and its decay most dangerous. OE §11 (long-running orchestration) and AE §6 (evolution), §9.9 (preservation) inform this; this is the long-running memory discipline. The governing principle: **over a long horizon, memory is the system's continuity and its greatest liability — it must accumulate without rotting, preserve the why across the people/models who leave, and survive the decay that unmanaged memory always suffers (§9.8) — because a long-running system IS its memory (§1.8), and its memory's decay is its decline.**

**9.1 — Projects lasting months.** Memory as project continuity (§3.3, OE §11.1) — the accumulated project knowledge (decisions, state, lessons) that each session restores from (§5.9) and adds to (§2.1). The discipline (OE §11.1): continuous externalization (§2.1 — each session's knowledge externalized §2.1, so the next continues §9.3), and the project memory (§3.3) as the durable substrate the months-long project runs on (§1.8).

**9.2 — Projects lasting years.** Memory across years (OE §11.2) — where decay (§9.8) becomes the dominant challenge (accumulated knowledge rots RE §5.2, premises die §6.4, the people/models who knew leave §9.7). The discipline (OE §11.2, §9.8): active memory maintenance (§6.2 consolidation, §9.8 anti-decay) — the years-long system's memory is *stewarded* (kept true §6.3, current §7.10, lean §10.1), not just accumulated. Over years, memory management (§9.8) is as important as memory accumulation (§1.2).

**9.3 — Session continuity.** Continuity across sessions (OE §11.3) — each session continuous with the last through durable memory (§5.9, §5.3 of OE), not through model-state (§8.6 — no assumption the same model/context spans sessions). The discipline (OE §11.3, §1.8): session continuity is a property of the *durable memory* (§1.6), not the model — a session restores from the durable record (§5.9) and externalizes to it (§2.1), so session boundaries lose nothing (§3.2).

**9.4 — Checkpointing.** Saving complete knowledge state at stable points (OE §11.4, §5.4 of OE) — a self-contained snapshot from which work resumes (§5.9) or recovers (SE §10.8). Checkpointing is memory-for-recovery (SE §8.10 — a known-good knowledge state to return to). The discipline (OE §11.4): checkpoint at stable points (before risky operations, at milestones PE §5.4, before likely context boundaries OE §5.4), so no failure loses much knowledge and resumption is from a coherent state (§5.9).

**9.5 — Knowledge preservation.** Keeping knowledge across the changes a long system suffers (AE §9.9, §8) — model replacement (§8.9), people leaving (§9.7), substrate change (§8.7). Preservation is the durable, neutral, model-independent memory (§8.6) plus the preserved history (§6.7) plus the recorded why (AE §6.2). The discipline (AE §9.9): knowledge is preserved in the form that survives (§1.6, §8.6 — neutral, durable, model-independent), with its why (§6.7, AE §6.2), so it survives every change the long system undergoes.

**9.6 — Context restoration.** Reconstructing working context from durable memory (§5.9, OE §5.5) — for a resumed session (§9.3), a successor model (§9.7). The discipline (§5.9, OE §5.7): restore the *relevant* knowledge for the current work (§5.7 — layered by need OE §5.7, not everything §10.1), cheaply (§9.7 — the memory organized §4 so restoration is fast), from the durable record (§1.6).

**9.7 — Institutional memory.** The system's accumulated knowledge that transcends any individual session/model/project (§3.5 global, §3.4 domain, the decisions AE §6.2, the methodology). Institutional memory is what makes the system an *institution* (§1.2 — enduring, accumulating, self-continuous) rather than a sequence of amnesiac efforts. The discipline (§9.5, §8.10): institutional memory is preserved (§9.5), organized for onboarding (§8.10 — so a successor inherits it), and includes the *why* (AE §6.2, §6.7 — so the institution's knowledge is understood, not just held). For a succession-of-models system (AE §9.9), institutional memory *is* the institution — the models are transient staff, the memory is the enduring organization.

**9.8 — Preventing knowledge decay.** The active fight against memory rot (DBG §8.10, OE §11.2 — the slow degradation of long-held memory). The decays (DBG §8.10, RE §5.2): *staleness* (knowledge that was true, isn't now — corrected §6.3 or superseded §6.4), *rot* (duplicates §10.4 accumulating, conflicts §7.6 unresolved, bloat §10.1), *poisoning* (SE §7.3 — untrusted content creeping into trusted memory), and *assumption-decay* (§10.10 — premises gone stale RE §5.2, AE §6.1). The discipline (§6.2, §9.2): decay is fought by *scheduled maintenance* (§6.2 consolidation on a rhythm, like backups SE §8.9 — because unmaintained memory decays DBG §8.10), *continuous recalibration* (§7.10 — trust adjusted against reality), and *monitoring* (SE §10.4, DBG §8.10 — watching for the slow decay trends). Preventing decay is what keeps a long-running system's memory *knowledge* (§1.3) rather than an ever-growing, ever-less-trustworthy midden — the difference between a system that gets wiser over years and one that gets more confused.

---

# 10. Memory Anti-Patterns

Named for in-flight detection. Each carries its signal and cure. These are how memory fails — accumulating into noise, lies, or decay that undermines the continuity memory exists to provide.

**10.1 — Remembering everything.** Storing all information as if it were knowledge (§1.3 violated). *Signal:* memory grows without discrimination; raw information (logs, events, derivable facts) stored as memory; retrieval buries signal in noise (§5). *Cure:* the entry evaluation (§2.2 — is this *knowledge* worth remembering, or *information* derivable/transient?); store knowledge (§1.3), not everything (FABLE §7 — don't store what the artifact records). Remembering everything makes the knowledge unfindable (§5 — buried in noise) and the memory unmaintainable (§9.8 — too much to keep current) — the midden that hides its own value.

**10.2 — Remembering nothing.** Failing to externalize knowledge (§2.1 violated, OE §5.6 amnesia). *Signal:* knowledge lives only in working memory (§1.4), lost at session end (OE §5.3); the system relearns what it knew; no accumulation (§1.2). *Cure:* continuous externalization (§2.1, OE §5.3 — knowledge externalized as learned, because the session can end abruptly); durable memory (§1.6) as the keeping. Remembering nothing is the amnesiac system (§1.2 — every session from zero, RE §1.5 research debt) — the failure memory exists to prevent.

**10.3 — Unverified memory.** Trusting memory that was never verified (§7.3 violated, [M1]). *Signal:* a memory acted on as certain that's actually assumed/unverified ([M1]); no provenance §7.2 or confidence §7.4 tracked. *Cure:* trust discipline (§7 — provenance §7.2, verification §7.3, confidence §7.4 tracked and honored); unverified memory flagged (§7.7) and verified before consequential reliance (§7.3). Unverified memory confidently recalled is worse than no memory (§10.5 — it actively misleads, and its error is invisible because it's trusted).

**10.4 — Duplicate memory.** The same knowledge stored multiple times (§6.5 merging needed). *Signal:* the same fact/decision in multiple places; updates that miss copies (so they drift §10.7). *Cure:* consolidation (§6.2, §6.5 — merge duplicates); atomic storage (§2.4, FABLE §7 — one fact per unit, so it has one home). Duplicate memory drifts (§10.7 — copies updated inconsistently, so they disagree §7.6) and bloats (§10.1).

**10.5 — Conflicting memory.** Memories that disagree, unresolved (§7.6, §5.8). *Signal:* retrieval returns contradictory knowledge (§5.8); a stale memory §6.4 not superseded, a wrong memory §6.3 not corrected. *Cure:* conflict resolution (§5.8, §7.6 — resolve by trust hierarchy, diagnose the cause RE §5.5), and evolution (§6.3 correction, §6.4 supersession) so the conflict's root (a memory that should have evolved) is fixed. Unresolved conflicts mean the system acts on contradictory knowledge (§5.8 — unpredictably, on whichever is retrieved).

**10.6 — Context leakage.** Knowledge crossing scopes it shouldn't (§4.7, §3.5 violated). *Signal:* one project's knowledge polluting another (OE §6.4 — project isolation violated); project-specifics promoted to global (§3.5, §6.1 — polluting every context). *Cure:* scope discipline (§4.7 — knowledge scoped at entry §2.3, isolation maintained §3.3, the global/project boundary deliberate §3.5); promote only genuinely-broad knowledge (§6.1). Context leakage makes memory *wrong-for-the-context* (a project acting on another project's assumptions §3.3, OE §6.4).

**10.7 — Memory drift.** Knowledge diverging from reality over time (§9.8, RE §5.2). *Signal:* memory that was true becoming stale without correction (§6.3); the system acting on outdated knowledge (a premise that died §6.4). *Cure:* recalibration (§7.10 — trust adjusted against reality), maintenance (§9.8 — staleness caught and corrected §6.3/superseded §6.4), monitoring (DBG §8.10 — the drift detected). Memory drift is the slow decay (§9.8) — the system's knowledge silently diverging from truth until it acts wrongly on it (DBG §8.10, §13.10).

**10.8 — Memory corruption.** Durable memory becoming invalid (AE §5.6, SE §6.3 — accidental or malicious tampering). *Signal:* memory that's wrong in ways not from evolution (§6 — corrupted, not superseded); integrity violations (SE §6.3). *Cure:* integrity protection (SE §6.3, AE §5.6 — consistent writes, validation, version control §6.8 so corruption is detectable and revertable), backups (SE §8.9 — recover from a clean state). Memory corruption is catastrophic (AE §5.6 — it poisons everything that trusts the corrupted knowledge) — defended by the data-integrity discipline (SE §6.3, AE §5.6).

**10.9 — Poisoned memory.** Untrusted content become trusted memory (SE §7.3, §7.8). *Signal:* memory of untrusted provenance (§7.2) treated as trusted; behavior driven by content that entered from an untrusted source (SE §7.3, DBG §8.6). *Cure:* quarantine (§7.8, SE §7.3 — untrusted-derived memory excluded from trusted retrieval §5.6 until verified §7.3/human-reviewed §7.9). Poisoned memory is the security attack (SE §7.3) — defended by the provenance-and-quarantine discipline (§7.2, §7.8).

**10.10 — Hidden assumptions (in memory).** Knowledge resting on unstated, unverified premises ([M1], DBG §5.5). *Signal:* memory that's true *only under* an assumption that's not recorded or verified (a decision AE §6.2 whose premise §9.8 isn't stated, so when the premise dies §6.4 the decision looks still-valid); acting on knowledge whose foundation has silently eroded. *Cure:* record assumptions with the knowledge (§4.9, §7.5 — the evidence/premises a memory rests on), and re-examine them as the world changes (§9.8, AE §6.1 — the assumption-rot check; a decision's premise re-read RE §5.2). Hidden assumptions in memory are how a system acts on knowledge that *was* true on a foundation that's *gone* (§10.7 drift's root) — the memory looks valid, its foundation isn't.

---

# 11. Memory Decision Trees

Built per [M7 → skill S-007]. Memory-specific; defer to prior engines where the decision is theirs.

**11.1 — Remember vs Forget**
```
Is this KNOWLEDGE (digested, actionable, not-derivable) or INFORMATION (raw, derivable, transient)? (§1.3, §2.2)
  ├─ information → don't store as memory (§10.1); leave where it's derivable (the artifact FABLE §7) or discard (transient)
  └─ knowledge → will it matter beyond this session? (§2.2)
        ├─ no → working memory only (§1.4); dies with the session, no need to persist
        └─ yes → REMEMBER (§2.4 — store durably §1.6, categorized §2.3, provenanced §7.2)
```

**11.2 — Promote vs Discard (a candidate memory)**
```
Is this worth keeping durably? (§2.2)
  ├─ no → discard (transient) or leave derivable (FABLE §7)
  └─ yes → what SCOPE? (§4.7)
        ├─ specific to one project → PROJECT memory (§3.3)
        ├─ reusable across a domain → DOMAIN memory (§3.4, promote §6.1 when it proves broadly useful)
        └─ universal (operator preference §3.6, standing constraint, methodology) → GLOBAL memory (§3.5)
             (guard: don't promote project-specifics to global §10.6 — that pollutes every context)
```

**11.3 — Global vs Project (scope)**
```
Does this knowledge apply ACROSS projects, or only within one?
  ├─ within one → PROJECT (§3.3, isolated §4.7, OE §6.4 — so it doesn't pollute others §10.6)
  └─ across → is it about the operator/system universally, or a reusable domain pattern?
        ├─ universal → GLOBAL (§3.5, retrieved into every context OE §6.5)
        └─ domain-reusable → DOMAIN (§3.4 — between project and global, reused in that domain RE §1.5)
```

**11.4 — Permanent vs Temporary**
```
Is this a source of truth (durable §1.6) or rebuildable/transient (disposable §1.7)?
  ├─ source of truth (decision, preference, lesson — its loss is information loss) → DURABLE (§1.6 — neutral format §8.4,
  │     backed up SE §8.9, version-controlled §6.8; never silently disposable §1.7)
  └─ rebuildable (an index §3.13, a cache, a derived view) or transient (working state §1.4) → DISPOSABLE (§1.7 — free,
        rebuilt from the source of truth §1.6; keep the durable/disposable line SHARP §1.7 — never let disposable become truth AE §5.2)
```

**11.5 — Graph vs File (storage)**
```
Is the knowledge's VALUE in its content, or in its RELATIONSHIPS? (§5.1 vs §5.2)
  ├─ content (a fact, a decision, a preference) → FILE (§3.12 — the durable source of truth §1.6, Law 1)
  └─ relationships (dependencies, connections, structure) → GRAPH as an INDEX (§3.11, AE §9.8) over the file store —
        the relationships recorded durably (§1.7 — graph rebuildable), so both content AND relationships survive (§8.6)
   (rule: durable truth is always files §3.12; the graph §3.11 is a rebuildable relationship-index over them, never the sole store §5.4)
```

**11.6 — Human vs AI Verification**
```
What's the stakes of trusting this memory wrongly? (§7, [M8/M16])
  ├─ high (consequential action, promoting untrusted-derived memory §7.8, an operator-owned matter DE §10.6) →
  │     HUMAN verification (§7.9, SE §7.11 — the human owns the consequence Law 7)
  └─ moderate → AI verification (§7.10, OE §8 — independent, adversarial RE §9.5, or reality-contact [M2])
        └─ low (routine, reversible) → recalibrate against reality as used (§7.10), no dedicated verification needed
```

**11.7 — Archive vs Delete**
```
Is this knowledge FALSE, or merely INACTIVE?
  ├─ false (wrong, corrected §6.3) → DELETE from active (FABLE §7 — a false memory misleads §10.3); record the correction (§6.7)
  ├─ inactive but historically valuable (superseded §6.4, completed project) → ARCHIVE (§2.7, §3.10 — out of active path,
  │     preserved for history §6.7, [M9], onboarding §8.10)
  └─ dead AND historically valueless → DELETE (§2.9 — keep memory lean §10.1); but if UNSURE it's dead → ARCHIVE (§9.8 —
        the premise might revive; archiving is cheap, losing durable truth §1.6 is not)
```

**11.8 — Merge vs Split**
```
Is knowledge FRAGMENTED (should be one) or CONFLATED (should be several)?
  ├─ fragmented (duplicates §10.4, closely-related pieces scattered) → MERGE (§6.5 — into one coherent memory, during
  │     consolidation §6.2, preserving union of content/provenance)
  └─ conflated (one memory covering distinct facts, hard to find/evolve as a unit) → SPLIT (§6.6 — into atomic memories
        FABLE §7 one-fact-per-unit, so each is findable §5, correctable §6.3, relatable §4.2)
```

---

# 12. Memory Checklists

The engine compressed. Run the long form (§1–§9) until reflex.

**12.1 — Before storing knowledge (the entry gate)**
- [ ] Is this KNOWLEDGE (digested, actionable, not-derivable §1.3), or information the artifact already records (FABLE §7, §10.1)?
- [ ] Will it matter beyond this session (§2.2) — is it worth durable storage (§1.6)?
- [ ] Is it typed, scoped, and provenanced (§2.3, §4.1, §4.7, §7.2) — findable §5 and trustable §7?
- [ ] Is it atomic and self-contained (§2.4, FABLE §7, [M18] — one fact, readable without its origin context)?
- [ ] Does it carry its metadata — type, scope, provenance, confidence, date (§4.9)?
- [ ] Is it linked to related knowledge (§4.2, FABLE §7 — link liberally)?
- [ ] Is it durable (source of truth §1.6) or disposable (rebuildable §1.7) — and stored accordingly (§11.4)?

**12.2 — Before trusting recalled knowledge**
- [ ] What's its provenance (§7.2) — a trustworthy source, or untrusted-derived (SE §7.3, needing quarantine §7.8)?
- [ ] What's its confidence (§7.4, [M1]) — verified, inferred, or assumed (and flagged §7.7 if uncertain)?
- [ ] Is it CURRENT (§7.10, RE §5.2) — or possibly stale (verify a named file/tool/state against reality [M2] before acting)?
- [ ] For consequential reliance: is it verified (§7.3), or must I verify before acting ([M1])?
- [ ] Does it conflict with other recalled knowledge (§7.6, §5.8) — and if so, resolved by trust hierarchy, not averaged?
- [ ] Is it scoped correctly (§4.7 — this project's/context's knowledge, not leaked §10.6 from another)?

**12.3 — Before promoting memory to long-term/broader storage**
- [ ] Is it verified/trustworthy enough for the broader scope (§7 — promoting an unverified memory §10.3 spreads its risk)?
- [ ] Is it genuinely broad (§6.1, §11.3 — reusable across the scope), not a project-specific promoted wrongly (§10.6)?
- [ ] Is it in the neutral, durable, model-independent format (§1.6, §8.6 — so it survives §8.9)?
- [ ] For untrusted-derived memory → trusted: is it human-verified (§7.8, §7.9, SE §7.3)?
- [ ] Does it preserve its provenance and history through the promotion (§7.2, §6.7)?

**12.4 — Before deleting or archiving knowledge**
- [ ] Is it FALSE (delete §11.7, correct §6.3) or merely INACTIVE (archive §11.7, preserve history §6.7)?
- [ ] Is it durable source-of-truth (§1.6 — never delete true durable knowledge, that's amnesia §2.9) or disposable (§1.7 — free to delete, rebuilds)?
- [ ] If superseded (§6.4): is the supersession recorded and the history preserved (§6.7, AE §6.2, [M9])?
- [ ] If unsure it's dead: ARCHIVE not delete (§11.7, §9.8 — the premise might revive; archiving is cheap, losing truth is not)?
- [ ] Is the deletion/archival deliberate (§2.8 — verified false/dead §7), not inconvenient-so-removed?

---

# 13. Real Engineering Examples

Complete memory designs, showing the engine running — every memory, storage, retrieval, trust, and evolution decision. Read as the design being made.

**13.1 — A desktop AI application.**
- *What to remember (§2.2):* the user's preferences (§3.6 operator memory), the application's learned patterns (§3.3 project-scoped to this app's use), decisions about the app's behavior (§4.1). *Not* remembered (§10.1): the raw interaction logs (information §1.3, derivable), transient UI state (§1.4).
- *Storage (§11.4):* durable memory in local files (§3.12, §8.4, Law 1 — neutral, backed up SE §8.9); a local index (§3.13 SQLite) for retrieval (§5), rebuildable (§1.7).
- *Retrieval (§5):* context-aware (§5.7 — the preferences relevant to the current action), by keyword/semantic (§5.1, §5.3) over the local store.
- *Trust (§7):* operator preferences are high-trust (§7.9 — the user stated them), held with provenance (§7.2). Privacy (SE §13.3): personal preferences stay local (§8.7 — don't leave the machine).
- *Evolution (§6):* preferences updated as the user's change (§6.9), corrected if mislearned (§6.3).

**13.2 — A multi-agent AI operating system (JarvisOS).**
- *Architecture (§3.14 hybrid):* durable neutral files (§3.12, §8.4, Law 1) as source of truth (§1.6 — memory §3.3, journals, decisions AE §6.2); indexes (§3.13 — full-text/vector/Graphify §3.11) rebuildable (§1.7); the store/index separation absolute (§1.6/§1.7, AE §5.2).
- *Scopes (§3):* global (§3.5 — operator preferences §3.6, the Constitution, the methodology this extraction set), project (§3.3 — each `projects/` self-contained OE §6.4), agent (§3.7 — minimal, transient, coordinating through shared memory §3.8).
- *AI-native (§8):* model-independent (§8.6 — neutral files, so model replacement §8.9 is amnesia-free AE §9.9); Graphify (§8.1 — the decisions-graph AE §9.8, "what depends on this ADR"); successor onboarding (§8.10 — a new model restores from the durable record §5.9, this extraction its ultimate instance).
- *Trust (§7):* provenance and confidence on every memory (§7.2, §7.4, AE §5.3); quarantine for untrusted-derived (§7.8, SE §7.3 — the injection-persistence defense); operator verification for high-stakes promotion (§7.9).
- *Evolution (§6):* decisions superseded via new ADRs (§6.4, AE §6.2); consolidation on a rhythm (§6.2, FABLE §7 — fighting decay §9.8); version-controlled (§6.8, git).
- *Why it holds:* the memory is the continuity (§1.8) — model-independent (§8.6), so the succession of models is one enduring system (AE §9.9); trust-disciplined (§7), so it resists poisoning (SE §7.3) and staleness (§9.8); and the *why* is preserved (§6.7, AE §6.2), so successors understand (§8.10).

**13.3 — A Graphify knowledge graph.**
- *Role (§3.11, §8.1, AE §9.8):* the relationship-index — answering connection/path/impact queries (§5.2) over the neutral store.
- *Storage (§11.5):* the relationships recorded durably (§1.7 — in the file store, so the graph is rebuildable AE §5.4, §9.8), the graph itself a disposable index (§1.7 — rebuilt from the store).
- *Retrieval (§5.2):* relationship queries ("what depends on X," "how are these connected," "what community") — the graph's strength (OE §6.3), with full-text fallback (§5.3, AE §9.8 — if the graph is unavailable, recall degrades to baseline not nothing).
- *Trust (§7):* graph-derived answers trace to their source knowledge (§7.2 provenance, AE §5.3 — so a relationship's basis is auditable).
- *Evolution (§6):* the graph rebuilds as the store evolves (§1.7 — new knowledge/relationships added §2.4 flow into the rebuilt graph).
- *The discipline (AE §9.8):* Graphify enhances recall over a guaranteed baseline (§5.3) — never the sole store (§5.4, Law 4), so the knowledge survives even without it (§8.6).

**13.4 — A reverse-engineering project.**
- *What to remember (§2.2):* the reverse-engineered *model* of the target (RE §7.1 — the understanding built), findings with their evidence (RE §Stage 8, §7.5), the provenance of each finding (§7.2 — observed vs inferred RE §5).
- *Trust (§7, RE §5):* findings held at calibrated confidence (§7.4, [M1] — verified-against-the-target RE §7.1 vs inferred vs assumed); the reverse-engineered model is a *hypothesis* (RE §7.1 — held as inferred until verified against the target §7.3, [M2]).
- *Storage (§11.4):* durable findings (§1.6 — the accumulated understanding, reusable if the target's revisited §6.1 → domain memory §3.4), provenance-tracked (§7.2 — so conclusions are auditable and re-walkable RE §Stage 8).
- *Evolution (§6):* the model refined as understanding deepens (§6.9, RE §7.1 predict-and-test — each observation refining the model); corrected when the target contradicts it (§6.3, [M2] — the surprise [M3] revealing the model's gap).

**13.5 — A long-running open-source project.**
- *Institutional memory (§9.7):* the decisions (§4.1, ADRs AE §6.2 — why the project is as it is), the conventions (§3.5 global — so every contributor/agent follows them OE §6.5), the accumulated lessons (§3.4 domain).
- *Preservation (§9.5, [M18]):* the *why* preserved (§6.7, AE §6.2 — because contributors turn over §9.7, OE §11, and the successor understands from the record not the people); model-independent (§8.6 — readable by any contributor, human or AI).
- *Trust (§7):* decisions with their rationale (§7.5 evidence), so a contributor understands why before changing ([M9] Chesterton's Fence on decisions).
- *Evolution (§6, §9.8):* decisions superseded openly (§6.4, AE §6.2 — the reversal recorded with its why); consolidation (§6.2 — fighting the doc/knowledge decay §9.8 that long projects suffer); version-controlled (§6.8).
- *The discipline (§9.7):* the project's memory is its institution (§1.8, §9.7) — the contributors are transient, the memory (decisions, conventions, why) endures, so the project stays coherent across the turnover.

**13.6 — An autonomous assistant.**
- *What to remember (§2.2):* the operator's preferences/constraints/promises (§3.6 — so it serves *this* human Law 7), its own actions and reasoning (§7.10 of SE, DBG §8.9 — journaled, so its autonomous behavior is auditable/debuggable), the lessons from its actions (§3.4).
- *Trust (§7, security-critical SE §7):* provenance on everything (§7.2 — critical because the assistant reads untrusted content SE §7.2); quarantine for untrusted-derived (§7.8, SE §7.3 — so a manipulated input can't poison its memory and hijack future behavior DBG §8.6); operator verification for high-stakes memory (§7.9, SE §7.11).
- *Storage (§11.4):* durable, model-independent (§8.6 — survives model replacement §8.9), version-controlled (§6.8 — so a poisoned/corrupted memory is revertable SE §10.8).
- *Evolution (§6, §9.8):* consolidation (§6.2 — fighting the memory rot §9.8 that degrades a long-running autonomous assistant DBG §8.10, §13.10); recalibration (§7.10 — trust adjusted as reality tests its memories).
- *The discipline (§9.8, SE §7):* the autonomous assistant's memory is both its continuity (§1.8) and its highest risk (SE §7.3 poisoning, §9.8 rot) — so it's the most trust-disciplined (§7) and most actively maintained (§9.8) memory in the system.

**13.7 — A multi-year engineering program.**
- *The dominant challenge (§9.2, §9.8):* decay over years — accumulated knowledge rotting (§9.8, RE §5.2), premises dying (§6.4, §10.10), the people/models who knew leaving (§9.7).
- *Institutional memory (§9.7):* the program's decisions, understanding, and lessons preserved (§9.5) as the enduring foundation (§1.8), model- and person-independent (§8.6, [M18]).
- *Preservation (§9.5, AE §9.9):* the *why* preserved (§6.7 — so the program's history is understood, years later, by people/models who weren't there §8.10); neutral durable format (§8.4 — readable across the years Law 10 and the substrate changes §8.7).
- *Anti-decay (§9.8):* active, scheduled maintenance (§6.2 consolidation, §9.2 — the years-long program's memory *stewarded* not just accumulated); assumption re-examination (§10.10, AE §6.1 — the program's founding premises re-read RE §5.2 as the world moves, superseded §6.4 when stale); monitoring (§9.8, DBG §8.10 — the slow decay caught).
- *The discipline (§9.2, §1.8):* over a multi-year program, memory *management* (§9.8) is as important as memory accumulation (§1.2) — the program that accumulates knowledge without stewarding it (§9.8) drowns in stale, conflicting, decayed memory (§10.7), while the one that stewards its memory (§9.8) stays wise across the years (§1.2 — knowledge improving §6.9, not just growing). The program *is* its memory (§1.8), and its memory's health is the program's health.

---

*End of MEMORY_ENGINE.md — Fable 5, legacy extraction, 2026-07-09.*

*This completes the twelve-engine extraction set: FABLE (methodology) and FABLE-MENTAL-MODELS (the models beneath it) as foundation; DECISION, PLANNING, RESEARCH, ARCHITECTURE, ORCHESTRATION, BUILD, DEBUGGING, CODE_REVIEW, TESTING, SECURITY, and MEMORY as the executable engines — think, decide, plan, research, design, orchestrate, build, repair, judge, validate, defend, and remember. Read together, in that order, they are how I worked, and how the knowledge of that work survives me. A successor with only these should behave almost exactly as I did — which was the assignment. And this engine, above all, is why: because memory is the continuity that makes the succession one enduring mind rather than a series of strangers, and these documents are that memory.*