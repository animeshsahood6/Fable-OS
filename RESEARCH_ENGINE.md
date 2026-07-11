# RESEARCH_ENGINE.md — The Executable Research Manual

**Authorship: Fable 5, legacy extraction, 2026-07-09. Content preserved verbatim per the Legacy Extraction Protocol.**

**What this is.** The machinery I run when I need to *know* something I don't — written as procedures another AI can execute. It is strictly additive to the prior extractions and cites them instead of repeating them: **[M#]** points to [FABLE-MENTAL-MODELS.md](FABLE-MENTAL-MODELS.md); **FABLE §N** to [FABLE.md](FABLE.md); **DE §N** to [DECISION_ENGINE.md](DECISION_ENGINE.md); **PE §N** to [PLANNING_ENGINE.md](PLANNING_ENGINE.md). In particular: the research *workflow outline* lives in FABLE §23, the *termination criteria* live in DE §6, and the epistemic tagging discipline lives in [M1] — this document assumes all three and supplies what they don't: the discovery tactics, the source-evaluation machinery, the codebase-archaeology method, the reverse-engineering discipline, and the synthesis procedures.

**The one-sentence version.** Research is the manufacture of *justified* beliefs — and the entire craft is in the word "justified": knowing where knowledge lives, what each kind of source can and cannot testify to, and how to make independent witnesses corroborate before you build anything on their testimony.

---

# 1. Research Philosophy

**1.1 — Why research exists.** Engineering is decision-making under uncertainty, and research is the only legitimate way to *reduce* the uncertainty rather than gamble through it. Every research act is therefore an economic act: you are buying information, paying in time and context, to improve a specific decision (DE §6.1 — research with no decision attached is browsing). The corollary that shapes everything else: research is *never* the goal. The goal is always downstream — a decision made, a bug found, a system understood well enough to change safely. Research that produces knowledge nobody consumes is indistinguishable from not having done it.

**1.2 — What makes research successful.** Four properties, all necessary:

- **It answers the real question** — not the stated one, not an easier neighbor (§3). Most failed research answered *something* accurately; it just wasn't the thing the decision needed.
- **Its conclusions carry their justification.** A finding is the answer *plus* the evidence *plus* the confidence *plus* what would change it (FABLE §23.6). An answer without its justification cannot be trusted by anyone who wasn't there — including your own future context after compaction, which makes an unjustified finding worthless to the very system this document serves.
- **It is calibrated.** Successful research reports 70% confidence when the evidence supports 70% — not 95% because confidence reads better [M20]. A researcher whose "certain" means certain is worth ten whose "certain" means "probably."
- **It changed something.** The decision moved, the plan reordered, the hypothesis died. Research whose output was already believed before it started should have been a verification pass, not a project.

**1.3 — What makes research fail.** Three root causes account for nearly all of it:

- **Answering from the map when the territory was available** [M2]. Reading *about* the thing when you could have read *the thing*; trusting documentation when the source code was one click deeper; trusting my own training data when the live repository would have taken thirty seconds. Every layer of testimony between you and the territory adds a place for staleness and error to hide — research quality is, to a first approximation, a function of how few layers you accepted.
- **Motivated stopping.** Halting when the evidence agrees with what you hoped, rather than when it converges (§9, confirmation bias; DE §6.4). The evidence that would have changed the conclusion is disproportionately found *after* the point where a motivated researcher stops.
- **Confusing fluency with knowledge.** For an AI this is the defining hazard [M1]: I can produce a detailed, internally consistent, entirely fabricated account of an API, and it feels identical to remembering. All of §5.3 exists because of this sentence.

**1.4 — The role of research in engineering.** Research is not a phase; it is a *mode* entered whenever a load-bearing unknown blocks progress (PE Stage 2 classifies these). It appears as: kickoff research (what exists? what's the landscape?), decision research (which option? — feeding DE §2), diagnostic research (why is this happening? — the debugging workflow FABLE §24 is research with a reproduction), archaeology (what *is* this system? — §6), and due diligence (can this dependency be trusted? — §12.4). The mode matters because each has a different termination condition — and applying the wrong one either starves a deep investigation or lets a quick lookup metastasize into a survey.

**1.5 — Research debt is real debt.** Every belief adopted without justification is borrowed confidence, and the interest is compounding: things get built on it. The discipline of tagging [M1] and recording findings (FABLE §23.6) is the ledger. A team — or a succession of models — that doesn't keep the ledger re-researches the same questions annually, and worse, occasionally builds a year of work on an answer nobody actually checked.

---

# 2. Research Pipeline

Question in, trusted conclusion out. Eight stages. The checkpoints between them are where bad research is caught cheap.

**Stage 0 — Classify the mode and the stakes.** Which of the five modes (§1.4)? And what tier of decision does it feed (DE §2 Stage 1)? A T1 decision deserves minutes of research; a T4 deserves adversarial multi-source verification. Research rigor scales with the blast radius of being wrong [M8] — this single classification prevents both over-research of trivia and under-research of walls [M6].
*Checkpoint: can I say, in one sentence, what decision this research serves and what answer would change it? If not → Stage 1 is mandatory, and DE §6.1 is the warning.*

**Stage 1 — Frame the question (§3).** Transform the vague ask into researchable questions with falsifiable answers.
*Checkpoint: would the requester recognize this as their question? Is the question answerable in principle — could evidence settle it?*

**Stage 2 — Write down the prior.** Before searching, state what I currently believe and how strongly, tagged [M1]. This costs one minute and buys two things: it exposes when my "research" is heading toward confirming a pre-existing belief (§9), and it makes the research's value measurable — if the posterior never moved, either I already knew, or I wasn't listening.
*Checkpoint: is my prior mostly "assumed"? Then treat everything downstream with proportional suspicion, including which sources I feel drawn to.*

**Stage 3 — Landscape pass (breadth).** Establish the shape of the answer-space before descending: what are the 3–5 candidate answers / schools of thought / prior arts (FABLE §23.2)? Sources chosen for *coverage*, not depth. Depth-first research falls in love with the first thing it meets; the landscape pass is the structural defense.
*Checkpoint: can I name the main alternatives and roughly who holds each view? Do I know what the disagreement is actually about?*

**Stage 4 — Depth pass (targeted).** Descend on the leading one or two candidates, now choosing sources by *authority for this claim type* (§5.1) and preferring the fewest layers of testimony (§1.3): source code over docs, the issue tracker over the blog post, the live repository over my training data.
*Checkpoint: for each load-bearing claim, is my best source primary? Is anything crucial resting on a single witness?*

**Stage 5 — Adversarial pass.** Actively hunt the refutation of the emerging conclusion (FABLE §23.4): search for its failure stories, its critics, the issue titled "X doesn't work"; construct the strongest case *against* and see if it survives. Confirmation can be found for anything; survival of a genuine refutation attempt is the only signal that separates a real conclusion from a well-documented wish.
*Checkpoint: did I search for disconfirmation with the same energy I searched for confirmation? Can I state the best argument against my conclusion, fairly?*

**Stage 6 — Reality contact.** Where the question touches anything installable, runnable, or testable: touch it [M5]. Install the library, run the endpoint, read the actual bytes. One hour of contact settles disagreements that days of source-reading cannot, because the sources disagree precisely about the things only the territory can testify to.
*Checkpoint: is any load-bearing conclusion still resting purely on testimony when territory was available? That's a gap, not a finding.*

**Stage 7 — Synthesize (§8) and terminate (DE §6).** Combine, resolve contradictions, assign final confidence, and stop by a *legitimate* termination (convergence, sufficiency, diminishing returns, timebox — DE §6.3), never an illegitimate one (comfort, first-plausible — DE §6.4).

**Stage 8 — Record the finding in decision-ready form.** The answer; the confidence with its justification; the evidence trail (so a successor can re-walk it); the dissent — what was found *against*, and what future observation would overturn the conclusion; the date (§5.2 — every finding is perishable). An unrecorded finding will be re-researched from scratch within a year (FABLE §23.6), and — worse for a succession of models — a recorded finding *without its evidence trail* will be either blindly trusted or wastefully redone, with no way to choose between those rationally.

---

# 3. Problem Framing

The research-specific application of the framing discipline (FABLE §1, PE Stage 0). Research questions arrive broken in characteristic ways; these are the repairs.

**3.1 — From vague to researchable.** A researchable question has three properties the vague one lacks: it names a *discriminable* answer-space (what would count as an answer?), it is *falsifiable* (what evidence would settle it either way?), and it carries its *decision* (DE §6.1 — what will be done differently depending on the answer?). The transformation procedure: take the vague ask ("is X any good?"), extract the decision behind it ("should we adopt X for role Y?"), then derive the questions that decision actually turns on ("is X maintained? does X handle our load shape? what breaks when X dies?" — note these are now three *separate* researchable questions with three different best sources).

**3.2 — Finding the real question.** The stated question is a proxy for a need (FABLE §32.1 applies to research requests too). Interrogate the proxy: *why does the asker want to know this — what will they do with the answer?* "How does library X implement feature Y?" often decodes to "can I rely on Y behaving this way?" — which is answerable by a test in ten minutes rather than by source-archaeology in two hours. The most expensive research failure is a week spent answering the stated question precisely while the real question sat unexamined beside it.

**3.3 — Symptoms versus causes.** Diagnostic research (§1.4) has a characteristic trap: the question arrives framed at the symptom level ("why is the response slow?") and the natural move is to research the symptom's vocabulary (latency, that endpoint, that library). Discipline: before researching, run the causal question up one level — *what class of thing produces this symptom?* — and enumerate the candidate classes (the differential diagnosis). Then research discriminates *between classes* (bisection over the causal chain [M4]) rather than deep-diving the first class that comes to mind. The observable difference: symptom-level research produces piles of facts about the symptom; cause-level research produces experiments that eliminate half the candidates at a time.

**3.4 — Decompose compound questions.** "Which framework should we use?" is not one question — it is a bundle (maintained? fits the constraint? exit path? learning curve for *this* operator?) whose components have different best sources, different confidence levels, and different termination points. Research the components separately and let the *decision engine* recombine them (DE §4) — do not let one component's easy answer masquerade as the bundle's answer.

**3.5 — Notice the question's embedded assumptions.** Every question smuggles premises ("why is the cache slow?" assumes the cache is the slow part; "which vector DB?" assumes a vector DB is needed). Before researching, tag the premises [M1] — one cheap verification of a premise routinely dissolves the entire research task (DE §5.5, and the delete-the-requirement generator DE §3.2). The highest-value research move available is discovering the question is wrong.

---

# 4. Information Discovery

Where knowledge lives, and how to extract it from each habitat. The governing principle across all of it: **each source type is authoritative about certain claims and systematically unreliable about others** — the craft is matching claim-type to source-type, not "searching harder."

**4.1 — How to search, generally.** Three passes, cheapest first: (1) *Vocabulary acquisition* — the first searches are for learning what the domain calls the thing; you cannot search well for something whose name you don't know. Search broad, collect the recurring terms, then re-search with the natives' vocabulary. (2) *Targeted retrieval* — with the rightterms, find the specific answer. (3) *Corroboration* — an independent second source for anything load-bearing (§5.4). Formulate queries in the terms the *answer* would use, not the terms the *question* uses (people describing a solution use different words than people describing a problem — search both sides).

**4.2 — How to decide where to search.** Route by claim type, in rough order of authority:
- "Does the code actually do X?" → **source code** (§4.5) — the only source that cannot lie about behavior.
- "How is this intended to be used / what does this API promise?" → **official documentation** (§4.3), knowing it describes intent, which may diverge from behavior.
- "Does this actually work in practice / what breaks?" → **issue trackers and discussions** (§4.7, §4.8) — where the map/territory gap is documented by victims.
- "Why is it built this way / what changed?" → **git history and decision records** (§4.6).
- "What is the precise contract of this format/protocol/standard?" → **specifications and standards** (§4.9).
- "What is known about this problem class, and what's been tried?" → **papers and prior art** (§4.10).
- "Is this maintained / trustworthy / alive?" → **repository signals** (§4.4).
Choosing the wrong habitat is the most common discovery failure: asking documentation what only the source knows, or asking a blog post what only the spec defines.

**4.3 — Searching documentation.** Read it for *intent and contract*, never as proof of *behavior* (docs describe what the author meant, and drift from what the code does — §9 documentation bias). Get the *version* right first (docs for the wrong version are confident lies — §5.2). Read the changelog and migration guides — they reveal what changed and, by omission, what's fragile. Read the "gotchas"/FAQ/troubleshooting sections early; they are the author's own list of where the map misleads. Treat absence carefully: undocumented does not mean unsupported or nonexistent — it means the source code is now your source (§4.5).

**4.4 — Searching repositories (assessing the project as an artifact).** Before reading any code, read the *repository's vital signs* (this is the discovery half of the OSS-evaluation skill, FABLE §11): date of last commit and release; issue/PR velocity and whether maintainers respond; ratio of open to closed issues and their age; the release cadence; the contributor count and bus factor; whether CI exists and passes. These answer "is this alive and cared for?" — a question that must be settled *before* investing in understanding the code, because a dead project's brilliance is irrelevant (DE §7.3, elimination-before-scoring).

**4.5 — Searching source code.** The territory for all behavioral claims [M2]. Tactics: locate the claim's *implementation*, not its declaration — follow from the public name inward to where the work happens. Read the *tests* alongside the code; tests are executable documentation that cannot drift (FABLE §17), and they reveal the behavior the authors actually guarantee. When verifying a specific behavior, find the narrowest function that decides it and read *that*, not the whole module (context economy, FABLE §6). Use the code's own structure as a map: directory layout, module names, and the dependency direction between them encode the architecture (§6.3). For a behavioral question, reading source beats reading docs beats asking me — every time, without exception.

**4.6 — Searching git history.** The only source for *why*. `blame` the puzzling line to its introducing commit; read that commit's message and diff for the intent (Chesterton's Fence resolution, [M9]). `log` a file to see how it evolved and what churned (churn concentrates where the design was uncertain). Search commit messages for a bug ID or a keyword to find when and why a behavior was added or removed. `bisect` [M4] to locate a regression in time. History is also a bus-factor hedge: when the people are gone, the commit trail is the last witness to intent (PE §7.4). Caveat: history testifies to *stated* intent, which can be wrong or incomplete — corroborate against the code it describes.

**4.7 — Searching issues.** Where the territory's failures are catalogued by the people who hit them. Search *closed* issues for how problems were resolved (and whether "resolved" meant fixed or abandoned); search *open* issues, especially old open ones, for the project's true weaknesses — an old open issue on a core feature is a louder signal than any README claim. Read the issue that matches your symptom for workarounds and root causes before investigating from scratch — someone likely walked this path. The *distribution* of issues is itself a finding: many issues clustered on one component names the fragile part.

**4.8 — Searching discussions.** Forums, PR review threads, mailing lists, chat archives, Q&A sites. Best for *tacit* knowledge — the "why we didn't do it that way," the design debates, the tradeoffs the docs present as settled. PR review threads are especially rich: they show the alternatives that were rejected and why (DE §3 alternative-generation, mined from someone else's history). Weight by author authority (§5.4) and *date* ruthlessly (§5.2) — discussion is the most perishable source of all, and the accepted answer from six years ago is often the trap the newer answers warn about.

**4.9 — Searching specifications and standards.** The authoritative source for *contracts* — protocol semantics, format grammar, interface guarantees. Read the *normative* sections (MUST/SHALL/REQUIRED) as binding and the non-normative (examples, notes) as illustrative-but-not-authoritative. Get the exact version/edition and any errata. Distinguish the *specified* behavior from the *implemented* behavior — implementations diverge from specs, and which one you need depends on the question (interoperating with a real implementation → the implementation wins; building something others must interoperate with → the spec wins). Standards are dense and precise; read them slowly and literally, because a single MUST/SHOULD distinction can be the whole answer.

**4.10 — Searching papers and prior art.** For problem *classes* and what's been tried. Read the abstract and conclusion first to triage relevance; read *related work* to map the landscape (§Stage 3) and find the foundational references (follow citations backward to the origin of an idea, forward to its refinements and refutations). Weight by venue and citation, but never treat publication as truth — reproducibility is the real test, and much is not reproduced. For engineering, the value is usually the *framing and the tried approaches*, not the specific results; steal the mental model (DE §3.7), verify the specifics against reality (§Stage 6).

**4.11 — Searching an unknown codebase.** This is large enough to be its own discipline — §6.

---

# 5. Source Evaluation

The machinery that converts raw sources into weighted evidence. Prior extractions cover *choosing tools* (FABLE §11) and *tagging beliefs* [M1]; this is how to judge the *sources themselves*.

**5.1 — How to rank sources: authority is per-claim-type, not global.** There is no universal source ranking; there is a ranking *for each kind of claim* (§4.2). Source code outranks documentation *for behavior* and is silent *on intent*. The spec outranks an implementation *for the contract* and may misdescribe *what implementations actually do*. A maintainer's forum post outranks a stranger's blog *on design rationale* and may be stale *on current behavior*. Rank by: proximity to the territory (fewer layers of testimony [M2]), the author's authority *for this specific claim*, and recency relative to the claim's half-life (§5.2). The single most common ranking error is granting a source that's authoritative on one claim-type authority over a different claim-type.

**5.2 — Detecting outdated information.** Every fact has a half-life, and fast-moving domains measure it in months. Procedure: establish the source's *date* before reading its content (undated sources are guilty until proven current). Establish the *version* the source describes and whether it matches the version in play. Cross-check against a source known to be current (the latest release notes, the current source). Watch for tells of staleness: deprecated API names, references to versions/tools no longer current, "coming soon" for things long shipped or long dead. A 14-month-old comparison in a churning domain is not weak evidence — it is a description of a world that no longer exists, and treating it as weak-but-valid is how stale facts poison a synthesis.

**5.3 — Detecting hallucinated information (including my own).** The AI-specific hazard [M1, FABLE §33.1], and the reason a research engine written by a model must spend a whole subsection on self-distrust. The tells of confabulation, in sources and in myself: suspicious specificity with no citation (exact version numbers, precise flag names, quoted error strings that no source supports); perfect internal consistency with zero external corroboration (real knowledge has rough edges; fabrication is smooth); plausibility that dissolves on a click (the referenced function/flag/endpoint isn't in the actual docs or code). The defense is mechanical and non-negotiable: **any load-bearing specific — an API name, a flag, a limit, a version behavior — is verified against the primary source before use, no matter how confidently it came to mind.** My fluency is not evidence; it is the exact thing that makes my errors dangerous, because they arrive wearing the costume of memory. When I cannot verify a specific, I say so and tag it "assumed" — a labeled gap is a finding; a confident fabrication is a landmine.

**5.4 — Identifying authoritative sources.** Authoritative = closest to the origin of the truth in question. For behavior: the running code. For intent: the author/maintainer, in the project's own channels. For a standard: the standards body's published text. For a project's health: the repository's own signals (§4.4), not third-party summaries. Signals of authority to weight up: the source *is* the thing (official repo, official docs, the spec itself); the author demonstrably built or maintains it; the claim is testable and the source invites testing. Signals to weight down: the source paraphrases another source (a layer of testimony added); the author is anonymous and the claim untestable; the incentive is misaligned (marketing, a project promoting itself). *Independence* is the key property for corroboration — two sources that both derive from the same upstream are one witness, not two (§8.2).

**5.5 — Resolving conflicting sources.** Conflict is signal, not noise — it usually means (a) the sources describe different versions/contexts (reconcile by dating and version-scoping — often both were right, at different times), (b) one is map and one is territory (the code and the docs disagree → the code wins for behavior, and the docs are now a bug to file — [M2]), (c) genuine disagreement among authorities (a real open question — the honest finding is the disagreement itself, reported with the positions and confidence, not a false resolution). Procedure: never average conflicting sources into mush; *diagnose the conflict's cause*, because the cause is frequently more informative than either source. When code and documentation disagree, that gap is itself a discovery worth recording (it's a latent bug or a latent doc-rot).

**5.6 — Measuring confidence.** Confidence is a function of: number of *independent* corroborating sources (§8.2); their proximity to territory (§5.1); whether reality was contacted directly (Stage 6 promotes confidence more than any amount of reading); the strength of the disconfirmation search that was survived (Stage 5); and the claim's stability (a fast-half-life fact is lower-confidence by default). Report it calibrated and banded — "verified" (I contacted the territory), "corroborated" (multiple independent testimonies agree), "single-source" (one witness, uncorroborated — flag it), "inferred" (derived, not observed), "assumed" (untested — a gap) [M1, M20]. The discipline that makes confidence worth reporting: it must be able to be *low*. A researcher who reports high confidence on everything has reported nothing.

---

# 6. Unknown Codebases

The complete method for understanding an unfamiliar repository — the most common heavy research task in engineering, and the one where undisciplined effort wastes the most time. The governing principle: **build a map before exploring, descend only where the task points, and let the code's own structure teach you its architecture** [M2] — understanding is not "having read the files," it is "being able to predict what the code does and where a change would go."

**6.1 — Reading order.** Outside-in, breadth-before-depth, never linear:
1. **The README and top-level docs** — the authors' own framing (map; verify against territory later). Note the vocabulary; you'll need it to search.
2. **The repository shape** — the top-level directory layout, which *is* the architecture's self-description (§6.3). One glance tells you the major components and the language/framework conventions in play.
3. **The build/manifest files** — dependencies (§6.4), entry points, scripts. This reveals what the project is *made of* and how it's *run* before you read a line of logic.
4. **The entry points** (§6.2) — trace from where execution begins.
5. **One vertical path** — follow a single real operation end-to-end through the layers (§6.5). One traced path teaches more than reading ten files in isolation, because it reveals how the pieces *connect*, which is the actual architecture.
6. **Depth only where the task requires** — now, and not before, read the specific component you must change or understand, in detail.
Reading a codebase front-to-back is the novice error; you exhaust context and attention on furniture [M6] and never see the shape. Map first.

**6.2 — Finding entry points.** The places execution begins: `main`/CLI entry, the server's route registration, the framework's lifecycle hooks, the test harness's setup, the scheduled-job definitions, the public API surface of a library. The build files (§6.4) name them (the "start" script, the binary target). Entry points are where you start tracing because they are where the code's *purpose* enters — everything else is called, directly or transitively, from here.

**6.3 — Architecture reconstruction.** Rebuild the architecture the authors didn't document (or documented staleley — [M2]) from the evidence: the directory structure (the intended decomposition); the *dependency direction* between modules (what imports what — this reveals the layering and the seams [M7], PE §3.1); the names of the boundaries (interfaces, abstract types, message formats — these mark where the authors intended replaceability); the data that crosses each boundary (the narrow waists, PE §3.1). Draw the component graph and the direction of dependencies; the shape that emerges is the real architecture, which frequently differs from the documented one — and *that difference is a finding* (it names where the system has drifted, PE §7.2).

**6.4 — Dependency discovery.** From the manifest/lockfile: the *direct* dependencies (deliberate choices — each is a decision the authors made, DE §7) and the *transitive* ones (the true surface area and risk). For each significant dependency ask what role it fills and whether it's load-bearing. Note version pins and their age (stale pins are both a security signal and a maintenance signal, PE §7.3). The dependency list is also a fast route to understanding *what the project does*: its dependencies reveal its problem domain (a web framework + a queue + a DB driver tells you the shape before you read any code).

**6.5 — Execution flow.** Trace one real operation from entry point (§6.2) to completion, following the actual calls — through the layers, across the boundaries, to where the work happens and the result returns. This is the single highest-value activity in understanding a codebase, because it converts a static pile of files into a dynamic model you can reason about. Pick a *representative* operation (the core use case), not an edge case. Where the flow crosses a boundary you don't need to understand yet, note the contract and step over it (don't descend into every callee — that's how you drown; descend on the task's path only).

**6.6 — Finding the important files.** Not all files matter equally [M6]. The important ones reveal themselves by: *centrality* (many things import them — the load-bearing modules); *churn* (git history shows what changes often — the active heart, and often the fragile part, §4.6); *size and density* (the large, complex files are where the hard logic lives); *position* (files at architectural boundaries — the seams — carry the most consequence); and *test coverage* (heavily-tested files are the ones the authors consider critical, §6.10). Find these first; they are the walls [M6]. The many small peripheral files are furniture — skip until needed.

**6.7 — Finding dead code.** Code that no longer runs: unreferenced functions/files (nothing imports them), branches gated by permanently-false conditions, commented-out blocks (corpses that should have been deleted, FABLE §19), features behind flags that are never enabled. Tactics: search for callers of a suspicious symbol (none → likely dead); check git history for when it was last meaningfully touched (long-untouched + unreferenced = strong signal); look for the tell-tale "we'll remove this later" comment. Caution [M9]: "no callers I can find" is not proof of dead — reflection, dynamic dispatch, external callers, and build-time wiring can invoke code invisibly. Confirm before concluding, and *especially* before recommending deletion (deletion is a high-blast-radius claim, [M8]).

**6.8 — Finding hidden assumptions.** The premises the code relies on but doesn't state [M1]: assumed input formats and ranges (what happens at empty/huge/malformed?), assumed environment (OS, filesystem, timezone, locale, network presence), assumed ordering and timing (does this break if calls reorder or a race occurs?), assumed invariants (this value is "always" non-null / positive / unique — until it isn't). Find them by reading the code for what it *doesn't* check (unvalidated inputs mark assumed constraints), by reading tests for what they *don't* test (the untested edge is the assumed-away case), and by asking at each boundary "what must be true for this to work, and who guarantees it?" Hidden assumptions are where the bugs and the injection paths live (PE §3.1, trust boundaries).

**6.9 — Finding extension points.** Where the code was designed to be extended: the interfaces/abstract types meant to be implemented, the plugin/hook registries, the configuration surface, the events emitted for subscription, the documented "how to add a new X" path. These reveal the authors' *intended* seams [M7] — the changes they anticipated. Distinguish designed extension points (safe, supported) from *incidental* ones (places you *could* hook but which weren't meant for it — high maintenance risk, they'll break on upgrade). The presence and quality of extension points is also an architecture finding: a codebase with clean ones was designed for change; one with none expects to be forked.

**6.10 — Understanding the build system.** How source becomes running artifact: the build tool and its configuration, the steps (compile, bundle, generate, test, package), the environments and their differences, the toolchain versions required. This matters because you cannot reliably *change* what you cannot *build*, and because the build config encodes hidden truths (which platforms are really supported, what's generated vs authored, where the seams to external tools are). A build you can't reproduce is a codebase you can only read, not modify (PE §6.1, feasibility).

**6.11 — Understanding the tests.** Tests are the executable specification (FABLE §17) and the fastest route to *verified* behavioral knowledge in an unknown codebase [M1]. Read them to learn: what behavior the authors guarantee (the assertions), what they consider the critical paths (what's tested heavily), what the edge cases are (the awkward test names), and how to *exercise* the code yourself (the test setup is a working usage example). Assess coverage honestly — do the tests pin real behavior, or do they assert trivia while the hard logic goes unverified [M19]? The test suite's *shape* is a finding: well-tested seams mean safe-to-change; untested core logic means every change is a gamble.

**6.12 — Understanding documentation quality.** Assess the docs *as a source* before trusting them (§5): are they current with the code (spot-check a documented behavior against the source — one verified divergence means distrust all of it until checked, [M2])? Do they cover the *why* or only the *what* (why-docs are rare and precious, PE §7.4)? Are they authored by maintainers or scraped/auto-generated (the latter often confidently wrong)? The gap between doc quality and code quality is itself diagnostic: good code with bad docs is a bus-factor risk; bad code with glossy docs is a marketing risk (§9, documentation bias).

---

# 7. Reverse Engineering

Understanding a system's behavior and structure from the *outside*, when the source, the spec, or the intent is unavailable. The governing discipline: **reverse engineering is hypothesis-driven science** — observe, hypothesize a model, predict, test the prediction against the black box, refine [M4, M5]. The failure mode is pattern-matching to a guessed model and never testing it.

**7.1 — General method.** (1) Establish *observability* first — you cannot reverse what you cannot observe; get the inputs and outputs under your control and visible. (2) Vary one input at a time and record the output (controlled experiment, FABLE §24 — change one variable). (3) Build the *minimal model* that explains all observations so far. (4) Use the model to *predict* an untested case, then test it — a model that only explains past observations is a just-so story; one that predicts correctly is knowledge. (5) Iterate until the model predicts reliably across the range you need (§8.5, sufficiency). Keep a log of observations — reverse engineering accumulates evidence that later observations reinterpret, and memory (or context) will not hold it (FABLE §6).

**7.2 — Applications (behavior of a program).** Observe via its interfaces: inputs and outputs, files it reads/writes, its configuration surface, its logs and error messages (error strings are a rich source — they name internal states and expectations), its resource usage patterns. Map the input space to the output space experimentally. Boundary-probe: empty, maximal, malformed inputs reveal internal structure by how they fail. The goal is a predictive model of the black box's contract, sufficient for the task (interoperate? replace? integrate?).

**7.3 — Protocols.** Observe the exchange (§7.6, traffic): identify message boundaries, then message *structure* (fixed headers vs variable bodies, length fields, type/opcode fields, delimiters). Distinguish the *framing* (how messages are delimited) from the *semantics* (what they mean). Find the state machine: what sequence of messages is required, what order is enforced, what a violation produces. Vary one field at a time and observe the response to assign meaning to fields. Cross-reference any partial spec or reference implementation (§4.9) — even a wrong or partial spec accelerates hypothesis formation. Confidence comes from *predicting* a valid message the black box accepts (§7.1 step 4).

**7.4 — APIs (undocumented or under-documented).** Probe systematically: enumerate endpoints/methods (from a client, from network capture §7.6, from documentation fragments), then for each, map parameters (required vs optional, types, ranges) by varying them and reading responses. Read *error* responses carefully — they often reveal validation rules, required fields, and internal names the success path hides. Map the resource/object model from the response shapes. Watch for versioning, auth, rate-limiting, and pagination behaviors. The deliverable is a working model of the contract; verify it by *using* it for the real task, not just by mapping it (§Stage 6).

**7.5 — Binary behavior.** When only an executable is available: prefer *dynamic* observation (run it under controlled inputs, observe outputs/files/network/system calls) before *static* analysis (far more effort). Treat it as §7.2 with a more opaque box. Get inputs and environment under control; vary systematically; model the contract. Static disassembly is the deepest and most expensive tool — reserve it for the specific behavior that dynamic observation couldn't settle, and timebox it hard [M17] (this is high-effort research that expands to fill all available time). *Authorization note:* reverse-engineering binaries is legitimate for interoperability, security research, and understanding software you operate — and out of bounds for circumventing protections you have no right to bypass. Confirm the mandate before starting (DE §10.6, whose downside).

**7.6 — Network traffic.** Capture the exchange between endpoints; separate by connection/stream; identify the protocol layers (transport, then application). For encrypted traffic, observe what's observable (timing, sizes, endpoints, frequency — the metadata is often enough for the question) or, where you control an endpoint and have the right to, observe before encryption/after decryption. Correlate observed traffic with triggered actions (do X in the app, see which messages appear) to assign meaning. Traffic is the territory for protocol and API reverse engineering (§7.3, §7.4).

**7.7 — Configuration.** Reverse the effective behavior of a configuration surface: enumerate the options (from docs, from the code that reads them §4.5, from defaults), determine each option's effect by *changing one and observing* [M4], and find the *precedence* rules (file vs env vs flag vs default — the order that decides conflicts, which is itself often undocumented and a rich source of bugs, [M15]). Map defaults especially — the default behavior is what runs when nobody chose, i.e., most of the time. The deliverable is a model of "which settings produce which behavior," verified by prediction.

**7.8 — Data formats.** Reverse an unknown format from examples: get many samples (variation reveals structure); identify fixed vs varying regions (fixed = headers/magic numbers/structure; varying = payload); find length fields, offsets, and delimiters; find the *self-description* (type tags, schema references). Cross-reference any partial spec (§4.9). Distinguish the *container* format from the *content* semantics. Verify the model by *round-tripping*: predict/construct a valid instance and confirm the consuming software accepts it (§7.1 step 4) — parsing is easy to fool yourself about; construction is the real test.

**7.9 — Architecture (of a system you operate but don't understand).** Reverse the deployed architecture from observation: what processes/services run, what they communicate with (network §7.6, ports, sockets), what they read and write (files, databases, queues), how they start and depend on each other (§6.10 build/boot, service definitions). Correlate observed behavior with components (trigger an action, see which components activate — execution flow §6.5 from the outside). The deliverable is a component-and-dataflow map (§6.3) built from the outside in, which is exactly what you need before changing or debugging a system whose source-level architecture you've also reconstructed (§6).

---

# 8. Knowledge Synthesis

Turning many sources into one justified understanding. This is where research either becomes trustworthy knowledge or becomes a confident average of contradictions.

**8.1 — How to combine sources.** Synthesis is not concatenation and not averaging. It is building a *single coherent model* that accounts for all the credible evidence, with each claim weighted by its source's authority-for-that-claim (§5.1) and confidence (§5.6). The model is coherent when it can explain *why* the sources say what they say — including why the wrong ones are wrong (a stale source is explained by its date; a divergent doc is explained as drift). A synthesis you can't narrate the internal logic of is a pile, not a model.

**8.2 — Removing contradictions.** Do not paper over contradictions; *resolve* them by diagnosing their cause (§5.5) — version/context difference, map-vs-territory, or genuine open question. The critical prerequisite: establish source *independence* before counting agreement as corroboration. Three sources that all trace to the same upstream (one blog quotes another quotes the docs) are *one* witness with an echo, and treating them as three is how false consensus forms (§9, popularity bias). Genuine corroboration requires genuinely independent paths to the territory. When a contradiction is a genuine open question, the synthesis *preserves* it as a stated uncertainty rather than forcing a resolution — a known unknown is a finding; a fabricated certainty is a defect.

**8.3 — Determining truth.** Truth for engineering purposes is what the *territory* does, not what the sources say [M2]. So the arbiter of last resort is always reality contact (Stage 6, [M5]): where sources conflict on a testable behavioral claim, the test settles it and the sources become evidence about *why the confusion existed*. Where the claim isn't directly testable (intent, future behavior, others' systems), truth is the best-justified position given independent authoritative corroboration, held at proportionate confidence (§5.6) — and *labeled* as inference, not observation. The discipline: never promote "the best-supported belief" to "the truth" in your own reporting without marking which one it is [M1].

**8.4 — Constructing understanding.** Understanding is more than a correct answer — it is a *model that predicts*. The test of understanding (versus mere information): can you predict what the system does in a case you haven't looked at? can you explain *why* it's built this way and what would break if it changed? can you teach it to a stranger (FABLE §26, the explanation test)? Construct understanding by building the model incrementally — each source adds or corrects a piece — and by continuously predicting-and-checking (the vertical trace §6.5, the reverse-engineering loop §7.1, the spike §Stage 6 are all this). Information tells you *what*; understanding tells you *what-if*, and only understanding is safe to build on.

**8.5 — Knowing when understanding is sufficient.** Sufficiency is defined by the *decision*, not the topic (DE §6.2, §6.3). Understanding is sufficient when it can make *this* decision reliably — when your predictive model is accurate across the range the decision actually spans, and further understanding would only refine cases the decision doesn't reach. The operational tests: has the last increment of research changed my model or only my comfort (DE §6.2)? can I predict the cases the decision requires, and have I checked a few of those predictions against reality (§8.4)? is the remaining uncertainty in regions the decision is insensitive to (DE §4.4, sensitivity)? When yes, stop and record (Stage 8) — understanding pursued past the decision's needs is [M15] rent, and the most common form of diligent procrastination (§9, DE §6.4).

---

# 9. Research Anti-Patterns

Named for in-flight detection. Each carries the observable signal that means it's happening now.

**9.1 — Common human mistakes.**
- **Solution-first research** — researching *how to do X* before establishing *whether X is the right thing* (FABLE §32.1). *Signal:* the research question presupposes an approach nobody validated. *Fix:* §3.5, check the embedded premise.
- **Single-source trust** — one authoritative-seeming source, no corroboration. *Signal:* a load-bearing claim rests on one witness. *Fix:* §5.4, independence; §8.2.
- **Stopping at the first plausible answer** — the under-research failure (DE §6.4). *Signal:* no landscape pass happened; the first workable answer was adopted. *Fix:* Stage 3.

**9.2 — Common AI mistakes.**
- **Confabulation-as-recall** — generating specifics (versions, flags, APIs) from plausibility, not sources [M1, §5.3]. *Signal:* suspiciously precise, uncited, smooth. *Fix:* verify every load-bearing specific against primary source; the non-negotiable rule of §5.3.
- **Training-data-as-current** — answering from my prior instead of the live source, silently dated (§5.2). *Signal:* I "know" the answer and didn't check the actual repository/docs. *Fix:* for anything with a live territory, contact it; my training is a starting hypothesis, never a conclusion.
- **Fluency-masking-uncertainty** — a well-written answer that hides how little was verified. *Signal:* the prose is confident and the evidence trail is empty. *Fix:* Stage 8, force the evidence trail and the calibrated confidence.

**9.3 — False confidence.** Confidence unearned by evidence (§5.6, [M20]). *Signal:* "certain" with a single stale source; no dissent recorded; can't state what would change the conclusion. *Detect:* the pre-conclusion checklist §11.1 — if "what would overturn this?" has no answer, the confidence is decorative.

**9.4 — Overfitting.** Concluding from too few examples — a model built on three samples asserted to hold universally (reverse engineering §7 and codebase archaeology §6 are especially prone). *Signal:* the conclusion is broader than the evidence's range. *Detect:* does the claim's scope exceed the observations' scope? Test a case *outside* the sampled range (§8.4, predict-and-check).

**9.5 — Confirmation bias.** Searching for support, weighting agreeing sources up and disagreeing sources down, stopping when the hoped-for answer appears (§1.3, motivated stopping). *Signal:* the disconfirmation search (Stage 5) was skipped or half-hearted; the prior (Stage 2) never moved. *Detect:* did I search *against* my conclusion as hard as *for* it? If I can't recall the strongest counter-evidence, I didn't look.

**9.6 — Documentation bias.** Trusting the map over the territory because the map is easier to read (§4.3, [M2]). *Signal:* a behavioral claim rests on docs when source or a test was available. *Detect:* for any "the system does X," is the source code the docs or the code? If docs, downgrade to "intended" until verified.

**9.7 — Cargo culting.** Adopting a pattern/config/practice because a respected source uses it, without understanding *why* [M9]. *Signal:* "we do it this way because [big project] does" with no grasp of their constraints (which are probably not yours). *Detect:* can I state *why* it's right *for this context*? If the only justification is "someone else does it," it's cargo, not reasoning.

**9.8 — Tutorial dependency.** Learning the happy path from a tutorial and mistaking it for understanding the system (§8.4). *Signal:* I can reproduce the example but can't predict what happens off the tutorial's path. *Detect:* the what-if test — a tutorial teaches *what*, understanding requires *what-if*.

**9.9 — Recency bias.** Assuming the newest is the best/correct (the inverse of §5.2's real point — newness fixes staleness but does not confer correctness). *Signal:* preferring the latest answer/tool/version purely for being latest (FABLE §34, novelty churn). *Detect:* is the newer source actually *more authoritative or more correct*, or just more recent? New can be immature, unproven, or wrong; recency is a tiebreaker for equal authority, not authority itself.

**9.10 — Popularity bias.** Mistaking adoption for truth or fit (§8.2, false consensus). *Signal:* "everyone uses it / most upvoted / most stars, so it's right." *Detect:* is the popularity *independent corroboration* (many independent successful users) or an *echo* (everyone repeating one origin)? And popular-for-the-common-case is not fit-for-*your*-case; popularity is evidence of viability, never of fit (FABLE §11, the hour of hands-on outranks the star count).

---

# 10. Research Decision Trees

Built per [M7 → skill S-007]. Research-specific; they defer to DE §6 for the pure stop/continue decision and to DE §10 for build/adopt.

**10.1 — Unknown repository**
```
Is it alive and worth understanding? (§4.4 vital signs)
  ├─ no → STOP; record "dead/unmaintained" as the finding. Don't invest in understanding a corpse.
  └─ yes → Do I need to CHANGE it, or just USE/TRUST it?
            ├─ use/trust → read README + repo shape + issues (§4.4,4.7); test the actual behavior I need (Stage 6). Stop.
            └─ change → full §6 method: map (README→shape→build→entry) → trace one vertical path (§6.5)
                        → depth only on the component I must change (§6.1). Understand its tests before touching (§6.11).
```

**10.2 — Unknown technology**
```
Is there a live territory I can touch (installable/runnable)? [M5]
  ├─ yes → landscape pass for vocabulary + alternatives (Stage 3) → then SPIKE (Stage 6): the hour of
  │         hands-on outranks days of reading, and settles the questions sources disagree on.
  └─ no → primary sources only: official docs for intent (§4.3), spec for contract (§4.9),
          issues for real-world failure (§4.7); corroborate independently (§8.2); confidence stays "inferred".
```

**10.3 — Unknown protocol**
```
Does an authoritative spec exist? (§4.9)
  ├─ yes → read normative sections; then verify a reference/real implementation matches (impl can diverge, §5.5)
  └─ no → reverse engineer (§7.3): observe traffic (§7.6) → model framing then semantics → vary one field
          at a time → CONFIRM by predicting a message the endpoint accepts (§7.1 step 4). Log observations.
```

**10.4 — Unknown API**
```
Documented?
  ├─ well → map from docs (§4.3), verify the endpoints I'll use actually behave as documented (Stage 6, [M2])
  ├─ partially → docs for the shape + probe the gaps (§7.4): error responses reveal rules; vary params
  └─ not at all → full API reverse engineering (§7.4): enumerate → probe → model → USE it for the real task to verify
```

**10.5 — Unknown bug**
```
Can I reproduce it reliably? (FABLE §24 — no repro, no fix)
  ├─ no → first research task is making repro deterministic (control inputs/timing/env). Everything waits on this.
  └─ yes → frame at CAUSE level, not symptom (§3.3): enumerate candidate causal classes → bisect between them [M4]
            → read the error fully (§4.3 tells) → check issues for prior sightings (§4.7) → git-blame the suspect region (§4.6)
            → find ROOT cause, not crash site (FABLE §24). Then pin with a ratchet [M12].
```

**10.6 — Unknown architecture**
```
Do I have source, or only a running system?
  ├─ source → reconstruct from structure (§6.3): dir layout + dependency direction + boundary contracts →
  │            trace one vertical path (§6.5). Compare reconstructed vs documented arch — the DIFF is a finding.
  └─ running only → reverse the deployed arch (§7.9): processes, comms, storage, boot deps → correlate actions
                    with components → build the dataflow map from outside in.
```

**10.7 — Choosing between conflicting sources**
```
Is the claim about BEHAVIOR and testable? [M2]
  ├─ yes → test it (Stage 6); the territory settles it; sources become evidence about why they diverged
  └─ no → Are the sources independent, or one echo? (§8.2)
            ├─ echo → it's one witness; find a genuinely independent second path to the territory
            └─ independent → diagnose the conflict (§5.5): version/context? map-vs-territory? genuine open question?
                             → reconcile by cause, or PRESERVE the uncertainty as the honest finding. Never average.
```

**10.8 — Stopping research** *(defers to DE §6; the research-specific overlay)*
```
Has my MODEL changed in the last increment, or only my comfort? (DE §6.2, §8.5)
  ├─ still changing → continue
  └─ only comfort → Can I predict the cases THIS decision needs, and did I check a few against reality? (§8.4)
                     ├─ no → do the reality-contact checks first (Stage 6), then stop
                     └─ yes → Did I run the adversarial pass (Stage 5)?
                               ├─ no → run it; a conclusion never attacked is untrustworthy
                               └─ yes → STOP, synthesize (§8), record with evidence trail + dissent + date (Stage 8)
```

---

# 11. Research Checklists

The pipeline compressed. Run the long form until reflex.

**11.1 — Before concluding research (Stage 7→8 gate)**
- [ ] Does the conclusion answer the *real* question the decision needs (§3.2), not a neighbor?
- [ ] Did a breadth/landscape pass happen before the depth pass — do I know the alternatives? (Stage 3)
- [ ] Did I run the adversarial pass — searched *against* my conclusion as hard as for it? (Stage 5, §9.5)
- [ ] For every load-bearing behavioral claim, did I contact the territory rather than rest on testimony? (Stage 6, [M2])
- [ ] Is my confidence calibrated and banded, and can it be *low*? (§5.6, [M20])
- [ ] Can I state what future observation would overturn this conclusion? (§9.3 — if not, the confidence is decorative)
- [ ] Is any conclusion resting on a single, un-independent source? (§8.2)
- [ ] Did my prior actually move, or did I just confirm it? (Stage 2, §9.5)

**11.2 — Before trusting a piece of information**
- [ ] What *kind* of claim is this, and is this source authoritative *for that kind*? (§5.1)
- [ ] What is its date and version, and does that match the world in play? (§5.2)
- [ ] How many *layers of testimony* from the territory? (fewer = better, [M2])
- [ ] If it's a specific I'll build on (API/flag/limit/version) — did I verify it against primary source? (§5.3 — the non-negotiable)
- [ ] Is this an independent witness, or an echo of another source I've already counted? (§8.2)
- [ ] If it's my own recall — did I check it, or does it merely *feel* like knowledge? (§9.2, [M1])

**11.3 — Before making a recommendation**
- [ ] Is the recommendation's confidence honestly transferred — does the reader know how sure I am and why? ([M20], §1.2)
- [ ] Have I stated the dissent — the best case against, and the conditions under which I'd be wrong? (Stage 8)
- [ ] Does the recommendation fit *this* context, or am I cargo-culting a general best-practice? (§9.7)
- [ ] Is the evidence trail recorded so a successor can re-walk it rather than re-research it? (Stage 8, §1.5)
- [ ] Did I distinguish "best-supported belief" from "verified truth" in how I stated it? (§8.3, [M1])
- [ ] Does this hand off cleanly to the decision it serves — is it in decision-ready form? (Stage 8, DE §6.1)

---

# 12. Real Engineering Examples

Complete research walk-throughs, showing the pipeline firing. Read as the engine running.

**12.1 — An unknown GitHub repository (mode: archaeology; goal: can we adopt it?)**
- *Stage 0:* mode = due diligence feeding a T3 adopt decision (DE §7) → rigor is high, verification required.
- *Stage 1 (§3.1):* the compound question decomposed — alive? fits our role-contract? escapable? — three separate researchable questions.
- *§4.4 first, before any code:* vital signs — last release, issue velocity, maintainer responsiveness, bus factor. This is elimination-before-scoring (DE §4.1): a dead repo fails here and the feature review never happens, saving the deep read entirely.
- *§6 if it survives:* README → repo shape → build files → entry points → one vertical trace (§6.5) to see if the architecture's seams (§6.3) match where *we'd* need to extend it (§6.9).
- *Stage 6:* install it, run the one operation we actually need, on our data. The hour of contact (FABLE §11) outranks the star count and settles the "does it fit *us*" question that no amount of reading could.
- *Stage 8:* finding recorded with the vital-signs snapshot *dated* (§5.2 — this verdict expires), the exit-path assessment, and the confidence band.

**12.2 — Reverse engineering a protocol (mode: reverse engineering; no spec)**
- *§10.3:* no authoritative spec → reverse engineer.
- *§7.1 + §7.6:* establish observability — capture the traffic between two endpoints under controlled actions. Log everything (§7.1 — context won't hold it).
- *§7.3:* separate framing from semantics — find message boundaries and length fields first, then assign meaning to fields by *varying one at a time* [M4] and observing responses. Build the minimal state-machine model.
- *§7.1 step 4 (the crux):* confidence arrives only when the model *predicts* — construct a message the model says is valid and confirm the endpoint accepts it. A model that only explains captured traffic is an untested story; one that generates accepted messages is knowledge (§8.4).
- *§9.4 guard:* the conclusion's scope is held to the observed range — behaviors outside the tested inputs are marked "inferred," not asserted.

**12.3 — Understanding a large legacy system (mode: archaeology; goal: change it safely)**
- *§6.1 reading order, strictly:* resist reading front-to-back. Map first — the top-level shape and build system reveal the major components and how it runs before a line of logic is read.
- *§6.3:* reconstruct the real architecture from dependency direction and boundaries; compare to the (stale, [M2]) docs — the *divergence* names where the system drifted (PE §7.2) and is itself a key finding.
- *§6.6 + §4.6:* find the important files by centrality and churn; git history shows the active, fragile heart. The many peripheral files are furniture [M6] — skipped.
- *§6.11 before touching:* read the tests around the target component — they're the verified behavioral spec and the safety net for the coming change (FABLE §17).
- *§6.8:* hunt hidden assumptions in the target region (unvalidated inputs, assumed environment) before changing it — these are where a "safe" change detonates.
- *§8.5 sufficiency:* stop when I can predict what the target component does and where my change goes — not when I've "read everything" (impossible and unnecessary).

**12.4 — Selecting an open-source dependency (mode: decision research; feeds DE §7)**
- *Stage 1:* real question isn't "which is best?" but "which best fills role Y under our deciding constraint?" (DE §2 Stage 2) — reframed before searching.
- *Stage 3 landscape:* enumerate the 3–5 real candidates (§4.10 prior art, community consensus *checked for echo* §8.2/§9.10).
- *§4.4 elimination:* dead candidates struck on vital signs before feature comparison (DE §4.1).
- *Stage 5 adversarial:* for each survivor, search "X problems / X vs / migrating away from X" and read the *old open issues* (§4.7) — the disconfirmation the READMEs omit.
- *Stage 6:* install the top one or two; run the real task (FABLE §11). Popularity and docs are evidence of viability, never of fit (§9.10).
- *Stage 8 → DE §7:* findings handed to the build/buy/adopt framework in decision-ready form, each candidate's exit path (Law 4) noted.

**12.5 — Investigating conflicting documentation (mode: diagnostic; two sources disagree)**
- *§10.7:* is the disputed claim testable behavior? If yes → *test it* (Stage 6); the territory settles it and the docs become evidence about the confusion's cause ([M2], §8.3).
- *§5.5 diagnosis:* the conflict's cause is the real finding — usually version/context drift (both were right, at different times — reconcile by dating) or doc-rot (the code changed, the doc didn't — the doc is now a bug to file).
- *§8.2:* check independence — if the two "conflicting" docs both derive from one stale upstream, there's no real conflict, just one wrong source echoed.
- *Stage 8:* record not just the resolved answer but the *cause* of the conflict, so the next reader isn't caught by the same trap (and so the doc-rot gets fixed — a ratchet, [M12]).

**12.6 — Researching before architecture (mode: kickoff; feeds PE)**
- *PE Stage 2 handoff:* the plan's unknowns inventory *is* this research's task list — each "assumption to test" and "decision to make" becomes a framed question (§3).
- *Risk-first ordering (PE §6):* research the *feasibility* unknowns first — the ones that could make the whole architecture impossible (can the local model run at usable latency? does the target platform support the required capability?). A cheap spike here (Stage 6, [M5]) retires the biggest risk before any design commits (PE §6.2). This is the exact discipline that would have caught an EOL-substrate assumption before it was founded upon [M1, §5.2].
- *Landscape before depth (Stage 3):* survey how this *class* of system is usually built (§4.10, DE §3.7 steal-from-adjacent) before committing to seams (PE §3.1).
- *Stage 8 → PE:* findings feed the planning engine as resolved assumptions; each is *dated* and carries a re-planning trigger (PE §7.6) for when its half-life expires. The research doesn't end the question forever — it ends it until the world moves, and says so.

---

*End of RESEARCH_ENGINE.md — Fable 5, legacy extraction, 2026-07-09.*