# DEBUGGING_ENGINE.md — The Executable Debugging Manual

**Authorship: Fable 5, legacy extraction, 2026-07-09. Content preserved verbatim per the Legacy Extraction Protocol.**

**What this is.** The machinery I run when something doesn't work and I must find out why — written as procedures another AI can execute. It is the eighth engine of the extraction set and strictly additive to the seven before it: **[M#]** points to [FABLE-MENTAL-MODELS.md](FABLE-MENTAL-MODELS.md); **FABLE §N** to [FABLE.md](FABLE.md); **DE §N** to [DECISION_ENGINE.md](DECISION_ENGINE.md); **PE §N** to [PLANNING_ENGINE.md](PLANNING_ENGINE.md); **RE §N** to [RESEARCH_ENGINE.md](RESEARCH_ENGINE.md); **AE §N** to [ARCHITECTURE_ENGINE.md](ARCHITECTURE_ENGINE.md); **OE §N** to [AI_ORCHESTRATION_ENGINE.md](AI_ORCHESTRATION_ENGINE.md); **BE §N** to [BUILD_ENGINE.md](BUILD_ENGINE.md). This document assumes and does not repeat: the debugging *workflow outline* (FABLE §24 — reproduce, read the error, bisect, hypothesis, root cause, fix+test, look for siblings), bisection as a mental model [M4], confusion-is-signal [M3], map-vs-territory [M2], operational failure *recovery* (FABLE §27, stabilize-first), and the failure-mode catalog for orchestration (OE §12). FABLE §24 is the seed; this engine is the full tree grown from it — every failure class, every instrumentation technique, every scale, and the AI-native failures that had no prior art when I was written.

**Where this sits.** FABLE §27 is *operational recovery* — stop the bleeding, restore service, and it explicitly defers understanding until after stability. This engine is the *understanding* — the disciplined hunt for why, which happens on the stabilized system (or in development, where there's no bleeding to stop). They chain: in production, recover first (FABLE §27), then debug (this engine); in development, debug directly. OE §12 catalogs orchestration's failure modes for the orchestrator to *detect and recover from at runtime*; this engine is how you *investigate* any failure, including those, to permanent root cause.

**The one-sentence version.** Debugging is the disciplined removal of the gap between what you believe the system does and what it actually does — and the entire craft is that the gap lives in a belief you hold with false confidence [M1, M2], so debugging is less about the code than about finding which of your certainties is the lie.

---

# 1. Debugging Philosophy

**1.1 — What debugging actually is.** Debugging is *finding the divergence between your model of the system and the system itself* [M2]. A bug is not primarily a defect in the code — it is a defect in *understanding*, made visible. The code does exactly what it does, deterministically or with defined randomness; what's "wrong" is that it doesn't do what someone *believed* it would. So the target of debugging is never really the code — it is the false belief, held with confidence, about what the code does. Find the false belief and the code fix is usually trivial; the hours go into locating the belief, not correcting it. This reframing governs everything: **you are not hunting a bug in the system, you are hunting the error in your own map** [M2], and the system is the ground truth that will correct you if you let it.

**1.2 — Why debugging is fundamentally different from programming.** Programming is *construction* — you hold a goal and build toward it, and your mental model *leads* reality (you decide, then the system follows). Debugging is *investigation* — reality has already diverged from your model, and your model must *follow* reality to find where they split. This inversion is why programmers who are excellent builders can be poor debuggers: building rewards confident forward motion, debugging punishes it (confident motion in debugging means building on the same false belief that caused the bug). Debugging rewards the opposite virtues — suspicion of your own certainty [M1], willingness to be proven wrong, systematic narrowing over intuitive leaping [M4]. The builder asks "how do I make this happen?"; the debugger asks "what is *actually* happening, and which of my beliefs about it is false?" These are different cognitive modes, and the switch between them is itself a skill.

**1.3 — Why bugs exist.** Bugs exist because software is built on *layered assumptions* [M1], and any assumption can be wrong. Every line of code assumes things — about its inputs (their shape, range, presence), its environment (the OS, the filesystem, the network, the time), its dependencies (that they behave as documented, RE §5), its own prior state, and the intentions of the code around it. Most assumptions are correct most of the time, which is why software works at all; a bug is the moment an assumption that was *believed universal* turns out to be *merely usual*. This is why bugs cluster at boundaries (AE §4, where one component's assumptions meet another's, RE §6.8), at edges (where the usual case ends and the assumed-away case begins), and at changes (where a new assumption was introduced or an old one invalidated). Bugs are not random; they live exactly where an assumption was made without being verified [M1].

**1.4 — The relationship between assumptions and failures.** A failure is an assumption meeting a reality that violates it. This relationship is the debugger's most powerful lens: **every failure points back to a specific false assumption, and finding the failure means finding that assumption.** The debugging process (§2) is, underneath, an assumption-audit under pressure — you enumerate what the failing path assumed, and you test each against reality until you find the one that's false. The assumptions most likely to be the culprit are the ones held most confidently and checked least [M1] — "of course the input is valid," "of course the config is loaded," "of course this runs after that." The debugger's discipline is to distrust exactly the beliefs that feel most certain, because certainty is where verification was skipped, and skipped verification is where bugs live.

**1.5 — Reality vs mental models.** The mental model is a map [M2]; the running system is the territory. In debugging, the map is *known to be wrong somewhere* (that's what the bug proves), so the territory is the only trustworthy source, and every step of debugging is an act of *replacing map-belief with territory-observation*. This is why the cardinal sin of debugging is reasoning *from* the model ("it should do X, so the problem must be Y") rather than observing the system ("what does it *actually* do here?"). "Should" is the most dangerous word in debugging — it is map-language, and the map is broken. The disciplined debugger treats every "should" as a hypothesis to test against the territory (§6), never as a fact to reason from. When the system surprises you [M3], the system is right and your model is wrong — always, without exception — and the surprise is the most valuable thing that will happen in the investigation, because it's pointing directly at the false belief.

---

# 2. The Debugging Pipeline

Bug report in, permanent resolution out. Nine stages. FABLE §24 gives the compressed workflow; this is the full pipeline with the checkpoints that catch bad debugging cheap. The pipeline is *disciplined* precisely because debugging under pressure tempts every shortcut, and the shortcuts are where investigations go wrong for hours.

**Stage 0 — Observation.** Gather what actually happened before theorizing — the *complete* error (message, stack trace, the log lines *before* it, not just the final line, FABLE §24), the exact conditions (inputs, environment, timing, what the user/system did), and the precise symptom (what was expected, what occurred). Observation is *reading reality* [M2], and the discipline is to read it *completely and literally* before the mind starts theorizing — because a mind that theorizes early then reads selectively for confirmation (§10.1). An embarrassing fraction of debugging time is spent theorizing past an error message that named the file, the line, and the cause (FABLE §24).
*Checkpoint: have I read the FULL error and the surrounding context, literally, before forming any theory? Can I state the symptom precisely — expected X, observed Y?*

**Stage 1 — Reproduction.** Make the failure happen on demand (§4). A bug you can't reproduce, you can't verify fixing (FABLE §24 — no repro, no fix, only prayer). If reproduction is intermittent, *making it deterministic is the first sub-investigation* (§4.2), because everything downstream (isolation, experimentation, verifying the fix) depends on a reliable trigger. Reproduction is also the first real contact with the territory [M2] — the act of reproducing often reveals the conditions, which narrow the cause before any deeper work.
*Checkpoint: can I trigger the failure reliably, on demand? If not, is making it deterministic my current task (§4.2)?*

**Stage 2 — Isolation.** Narrow *where* the failure lives by bisection [M4] — halve the search space repeatedly (in code, in time, in data, in configuration — §4.3) until the failure is localized to the smallest region that still exhibits it. Isolation is the highest-leverage stage: it converts "somewhere in this system" into "in this function / this commit / this input / this component," and most of a bug's difficulty is *location*, not correction. Bisection works precisely when your understanding is wrong [M4] — which is the debugging situation by definition (§1.1) — so it beats staring, which runs on the same broken model that permitted the bug.
*Checkpoint: have I narrowed by halving, or am I staring at where I *think* it is? Is my reproduction reliable enough that each bisection probe gives a trustworthy answer (§4.2)?*

**Stage 3 — Hypothesis generation.** Form specific, testable explanations for the isolated failure (§6). A hypothesis names a *candidate false assumption* (§1.4) and *predicts something observable* — "if the cause is X, then observing Y will show it." Generate more than one (§6.1) — the first hypothesis is the most available, not the most likely, and anchoring on it causes confirmation bias (§10.1). Rank them by likelihood-times-cheapness-to-test (§6.2).
*Checkpoint: is each hypothesis falsifiable — does it forbid some observation? Do I have more than one, or am I anchored on the first (§10.1)?*

**Stage 4 — Experimentation.** Test the ranked hypotheses by *changing one variable at a time* (§6.3, FABLE §24) and observing whether the prediction holds. One variable per experiment is non-negotiable — two changes make the result uninterpretable in either direction (§10.5). Each experiment either confirms, refutes, or (most commonly) partially informs — and negative results are valuable (§6.5), each eliminating a region of the hypothesis space [M4].
*Checkpoint: am I changing exactly one variable per experiment? Am I recording what each experiment taught, including the negative results (§6.5)?*

**Stage 5 — Root cause discovery.** Trace from the confirmed proximate cause *upstream* to the true origin (§5) — the crash site is where bad state *arrived*, rarely where it was *created* (FABLE §24, §5.2). Follow the causal chain backward until you reach the divergence between intent and behavior — the actual false assumption (§1.4). Stopping at the crash site produces a symptom-fix (§5.1, §10.9) that silences the symptom and leaves the disease.
*Checkpoint: have I found where the bad state was *created*, or just where it *surfaced*? Can I explain the entire causal chain from cause to symptom (§5.3)?*

**Stage 6 — Verification (of the cause and the fix).** Confirm the root cause is *actually* the cause — the strongest confirmation is that you can *turn the bug on and off* by introducing and removing the cause (§6, the predictive test). Then fix the root cause and verify the fix *against the original symptom* (§2, not against "the error stopped appearing" — errors also stop when the thing emitting them dies, §12). Verify by exercising the original reproduction (Stage 1), observing the symptom is gone, and confirming nothing else broke (BE §7.6, regression).
*Checkpoint: can I demonstrate cause→effect by toggling the cause? Does the original reproduction now pass, observed? Did the fix break anything else?*

**Stage 7 — Regression prevention.** Pin the fix with a test that fails without it and passes with it (BE §7.5, FABLE §24 — the fix without the test will return, near-certain). The test is the ratchet [M12] that converts a fixed bug into a permanently-fixed bug. Then *look for siblings* (FABLE §24) — the same false assumption (§1.4) likely instantiated itself elsewhere; a bug is rarely alone, because the misunderstanding that produced it produced it wherever the pattern repeats.
*Checkpoint: is the fix pinned by a test that would catch its regression? Have I searched for the same bug pattern elsewhere (FABLE §24)?*

**Stage 8 — Knowledge capture.** Record what the bug taught: the root cause, the false assumption behind it, and — most valuable — the *class* it belongs to and the ratchet against the class (§5.6, FABLE §27.5, OE §6.7). A bug that produces only a fix has been half-wasted; a bug that produces a *rule that prevents the class* (a test pattern, a lint rule, a checklist line, an architectural change §5.6) is tuition converted to permanent judgment. This is how a succession of debuggers gets better instead of re-solving the same classes (RE §1.5, and the lessons-from-failure memory FABLE §7).
*Checkpoint: is the root cause and its class recorded durably? Is there a ratchet against the class, not just a fix for the instance (§5.6)?*

**Standing discipline — when stuck, the stall protocol (§after two hours or three failed hypotheses).** FABLE §24's stall guidance, formalized: *stop*; *re-read the original error, fresh* (you've likely built a theory that's now filtering your reading, §10.1); *explain the problem aloud/in writing to an imaginary colleague* (rubber-ducking — articulating the problem exposes the assumption you skipped, and it works on AIs); *question the assumption you're most certain of* (long stalls are almost always anchored on one false certainty labeled "known-good," FABLE §24, §1.4); and *check the dumb things* (is the file saved? the right process? the cache stale? the version you think is running actually running? §12). The stall protocol exists because the failure mode of a stuck debugger is *digging deeper on the wrong assumption* — the escape is always lateral (question a different assumption), never deeper.

---

# 3. Failure Classification

The class of a failure determines the strategy — where to look, what to instrument, which assumptions to suspect first. Classifying early (from the symptom, §2 Stage 0) focuses the investigation; misclassifying sends it down the wrong path. Each class below states its *signature* (how it presents) and how it *changes strategy*. Note that classification is a *hypothesis* (§6), refined as evidence accumulates — the initial class narrows the search; it doesn't conclude it.

**3.1 — Logic bugs.** The code does what it says, but what it says is wrong — a wrong condition, a wrong calculation, a wrong branch. *Signature:* deterministic, reproducible, wrong output for a knowable input. *Strategy:* the most tractable class — bisect to the logic (§2 Stage 2), read it against intent, the false assumption is usually right there. Trace the specific input through the logic by hand and compare to what the code does. The easiest class because it's deterministic and local.

**3.2 — State bugs.** Behavior depends on history — the code is correct for a fresh state and wrong after some sequence of prior operations (§5.2, BE §5.3). *Signature:* works in isolation, fails in sequence; "works the first time, not the second"; order-dependent. *Strategy:* the bug is not in the failing operation but in *how the state got into its bad configuration* — trace the state's history backward (§5.2), find where it diverged from valid. Reproduction (§4) must capture the *sequence*, not just the final call. Suspect shared mutable state (AE §10.4), missing resets, and assumed-fresh state that isn't.

**3.3 — Concurrency bugs.** Behavior depends on timing/interleaving of parallel execution — a race, a deadlock, a lost update. *Signature:* intermittent, non-deterministic, "heisenbug" (changes or vanishes when observed §7.12), load- or timing-dependent, unreproducible on demand. *Strategy:* the hardest class because reproduction (§4) is the whole battle — make it deterministic by controlling timing (forcing interleavings, adding delays to widen the race window, §4.2). Suspect shared state without synchronization (AE §10.4), assumed-atomic operations that aren't, assumed ordering (§1.3). The observer effect (§7.12) is acute — logging can change the timing and hide the race.

**3.4 — Memory bugs.** Corruption, leaks, use-after-free, overflow — the program's memory is in an invalid state (§13.5). *Signature:* crashes distant from the cause, corruption that appears unrelated to the code that caused it, degradation over time (leaks), non-deterministic corruption. *Strategy:* the crash site is almost never the cause (§5.2 acutely — corrupted memory surfaces wherever it's next read, arbitrarily far from where it was corrupted). Use memory-inspection tooling (§7.10) to catch the corruption *at the moment it happens*, not where it surfaces. Suspect boundary violations, lifetime assumptions (this pointer is valid), and size assumptions.

**3.5 — Configuration bugs.** The code is correct but configured wrong — wrong value, wrong precedence, wrong environment's config (RE §7.7). *Signature:* "works on my machine," works in one environment not another, changed behavior with no code change. *Strategy:* the false assumption is "the config is what I think it is" [M1] — *observe the effective configuration the running system actually has* (§7, not what the config files say it should be, §5.4). Suspect precedence (which of file/env/flag/default won, RE §7.7), environment differences (§3.6), and stale/cached config. Fastest to find once you check the actual effective values instead of assuming them.

**3.6 — Environment bugs.** The code is correct but the environment differs from assumed — wrong OS/version, missing dependency, different filesystem/locale/timezone, insufficient resources. *Signature:* works in one place not another, "works on my machine," environment-correlated. *Strategy:* *capture and compare the environments* (§4.4) — the bug is in the delta between the working and failing environment. Bisect the environment differences (§4.3 applied to environment). Suspect version skew, missing/different dependencies (RE §5.2), and resource limits. This is the class the substrate-EOL failure belonged to — an assumed environment property (the OS is supported) that was false [M1].

**3.7 — Network bugs.** Failures in communication across a network — timeouts, partial failures, retries, partitions, latency, packet loss (§13.2). *Signature:* intermittent, correlated with network conditions, works locally fails remotely, timing-sensitive. *Strategy:* inspect the actual traffic (§7.7 — the network is the territory [M2] for these), separate the failure's layer (transport vs application, RE §7.6). Suspect the assumption that the network is reliable, fast, and instantaneous — it is none of these (AE §8, distributed reality). Every remote call can fail, be slow, be duplicated, or arrive out of order; the bug is usually an unhandled one of these (§13.2).

**3.8 — Performance bugs.** The system is correct but too slow/heavy (§13.6, BE §10). *Signature:* correct output, unacceptable time/resource use, degradation under load or over time. *Strategy:* *measure, never guess* [M10, BE §10.3] — profile the actual system under the actual load to find the bottleneck, which is reliably not where intuition points [M10]. Bisect the latency (which stage/component consumes the time, §4.3). Suspect the algorithmic assumption (this scales fine — until the input grew), the N+1 pattern, and the resource that's exhausted. Distinct from other classes in that the "correct" behavior is the bug — nothing is wrong except the cost.

**3.9 — Security bugs.** The system does something it shouldn't allow — unauthorized access, injection, data leak, privilege escalation (AE §8.6, §9.6). *Signature:* often *no* symptom in normal operation (the system works fine; it's the *misuse* that's the bug), discovered by adversarial testing or breach. *Strategy:* think adversarially [M16, inversion] — how would an attacker make this misbehave? Trace trust boundaries (AE §8.2 — where does untrusted input reach a privileged action?). For AI systems, injection is the dominant class (AE §9.6, §8.3). The false assumption is "input is trustworthy" or "this boundary is respected." Security bugs are asymmetric [M16] — a rare failure with catastrophic cost — so they're hunted proactively, not just fixed reactively.

**3.10 — Data corruption.** Durable state has become invalid — the worst class because it's often silent, persistent, and poisons everything downstream that trusts the data (BE §5.6, AE §5.6). *Signature:* wrong results traceable to bad stored data, corruption that spreads, errors far from any recent code. *Strategy:* *find where the data got corrupted, not where it's read* (§5.2 acutely) — the corruption happened at some past write; the read just surfaced it. Trace the data's provenance backward (§5.2). Critically: *contain and assess first* (FABLE §27, stabilize — stop further corruption before investigating), because unlike most bugs, this one is actively destroying value while you debug. Suspect the write path, validation gaps (BE §5.6), and concurrent writes (§3.3, AE §10.4).

**3.11 — Distributed systems bugs.** Failures emerging from the interaction of independent nodes — partial failure, inconsistency, split-brain, cascading failure (§13.2). *Signature:* emerges only at scale/in production, unreproducible locally, timing- and topology-dependent, no single node "has" the bug. *Strategy:* the bug is in the *interaction*, not any node — so debug the *system*, not the parts (§9.4). Trace causality across nodes (§5.3, distributed tracing §7.2). Suspect the assumptions that distribution violates: that nodes agree, that messages arrive once and in order, that a failed node fails cleanly (AE §8). The hardest scale class because the state is spread across nodes and no single vantage sees the whole (§9.4).

**3.12 — AI hallucinations.** A model produces confident, fluent, fabricated output (OE §12.1, RE §5.3, [M1]). *Signature:* plausible output that's factually wrong; suspicious specificity with no source; smooth confidence with no corroboration. *Strategy:* the "bug" is in the model's output, and it's *probabilistic*, not deterministic (§8.1) — so debugging shifts from "why does it do this every time" to "why does it do this, and how often, and under what conditions." Verify against reality [M2] (the fabrication dissolves on checking, RE §5.3). Trace what was in the context that led to it (§8.3 — bad retrieval? poisoned context? ambiguous prompt?). The fix is usually not "fix the model" but "fix the context, the verification, or the containment" (§8.1, OE §8).

**3.13 — Agent coordination failures.** Multiple agents fail to work together — conflicts, duplication, deadlock, coordination collapse (OE §12.3–12.9). *Signature:* individual agents work, the fleet doesn't; contradictory outputs, duplicated or missed work, stalled progress. *Strategy:* debug the *coordination*, not the agents (§8.7, §9.5) — the bug is in how they interact (OE §7.4, §7.5), usually in the shared state or the orchestration. Trace the coordination through the durable state agents communicate through (OE §3.5, §7.4 — which is inspectable precisely so this is debuggable). Suspect ambiguous ownership (OE §7.6, AE §3.3), mesh communication (OE §12.8), and lost/conflicting decisions (OE §6.6).

**3.14 — Context failures.** An AI agent's context is wrong — poisoned, stale, missing, or over-full (OE §12.2, AE §9.4, §5). *Signature:* an agent acts against its brief, pursues a wrong goal, builds on a false premise, or degrades as context fills. *Strategy:* inspect what was *actually* in the context (§8.3 — the context is the territory [M2] for an agent's behavior), compare to what should have been. Suspect injection (untrusted content reaching an acting context, AE §9.6), bad retrieval (OE §6.1, wrong or stale knowledge pulled in), context overflow (attention degraded, AE §9.4), and stale carried-over context (OE §5, [M2] inherited assumptions). The AI-native analog of state bugs (§3.2) — behavior depends on the context's history.

**3.15 — Unknown failures.** The failure doesn't fit a known class — you don't yet know what kind of bug it is. *Signature:* confusion [M3] — the symptom doesn't match any model you have. *Strategy:* this is the *default starting state* of hard bugs, and the strategy is the pipeline itself (§2) with maximum discipline — observe completely (§2 Stage 0), reproduce (§4), bisect (§2 Stage 2) to localize, and let the *location* reveal the class (a bug isolated to a parallel section is likely concurrency §3.3; one that only appears in production is likely environment §3.6 or distributed §3.11). The unknown failure is classified *by investigation*, not upfront — and the discipline is to *not force it into a familiar class prematurely* (§10.1, §10.6), which is how investigations go down wrong paths for hours. Confusion [M3] is the correct and valuable state here — it means you're seeing something your model doesn't explain, which is exactly the pointer to the false assumption (§1.4).

---

# 4. Reproduction Methodology

Reproduction is the foundation — without it, every downstream stage is guesswork and the fix is unverifiable (§2 Stage 1, FABLE §24). The governing principle: **make the failure happen reliably and minimally before trying to explain it — a reliable minimal reproduction is most of the solution, because it converts a vague report into a controlled experiment [M4] and eliminates the variables that were hiding the cause.**

**4.1 — How I reproduce failures.** Start from the observed conditions (§2 Stage 0) and recreate them as faithfully as possible — same inputs, same environment (§4.4), same sequence (§3.2). Reproduce in the *closest safe approximation* of where it occurred (production bugs reproduced in a production-like environment, because environment is often the cause §3.6). The first goal is *any* reliable reproduction, even a slow or elaborate one; minimization (§4.3) comes after. Reproduction is itself investigation — the conditions required to reproduce are evidence (if it only reproduces with a specific input, that input's property is implicated; if only under load, timing is implicated §3.3).

**4.2 — How I make failures deterministic.** Intermittent failures (§3.3, §3.7, §3.11) must be made reliable before they can be debugged (§2 Stage 1) — a flaky reproduction makes every bisection probe (§4.3) and every experiment (§6.3) lie, because you can't tell a real result from noise. Techniques: *control the source of non-determinism* — force specific timings/interleavings for races (§3.3), pin the random seed, fix the clock, control the input order. *Tighten the loop* — run the trigger many times to raise the hit rate, then narrow what's needed. *Widen the window* — for races, add delays that make the bad interleaving more likely, turning a rare race into a reliable one. Making a failure deterministic is often the hardest part of the whole investigation, and it's non-negotiable — an intermittent bug "fixed" without deterministic reproduction is a bug you *hope* you fixed (§12, §10.7).

**4.3 — How I reduce variables (minimization).** Once reproducing, strip everything not needed to still reproduce — this is bisection [M4] applied to the reproduction itself: remove half the inputs/steps/config, does it still fail? Keep removing until every remaining element is necessary. Minimization does two things: it *isolates* (§2 Stage 2 — what remains is close to the cause) and it *clarifies* (a minimal reproduction is comprehensible, where the original was buried in irrelevant detail). The minimal reproduction is the ideal artifact to hand to a fresh context (OE, a debugger agent §8) or to attach to the bug's permanent record (§2 Stage 8) — it's the bug, distilled.

**4.4 — How I capture environments.** For environment-class bugs (§3.6) and to make reproduction faithful, capture the *actual* environment where the failure occurs — OS and version, dependency versions (RE §5.2), config effective values (§3.5, §7), resource state, relevant environment variables, locale/timezone. Capture the *working* environment too, for comparison — the bug lives in the *delta* (§3.6), and the delta is only visible if both are captured. The discipline: capture the environment as *observed reality* [M2], not as assumed ("it's running Python 3.11" — verify it, don't assume, [M1], the "works on my machine" failure is always an uncaptured environment delta).

**4.5 — How I preserve evidence.** Before any action that could destroy the failure state — especially a restart, which is the reflexive first move — *preserve the evidence* (FABLE §27.2): copy the logs, snapshot the state, capture the memory/stack, record the exact time and conditions. The 60 seconds spent preserving before restarting saves the days spent trying to reproduce what the restart destroyed. In production (FABLE §27), preservation happens *during* stabilization — you stop the bleeding *and* capture what bled, because once the system is restarted the transient state that held the cause is gone. Evidence preservation is a reflex to build: *the failing system in its failed state is the richest evidence you will ever have, and it's usually destroyed by the instinct to fix it.*

**4.6 — How I avoid contaminating evidence.** Observation can change the system (§7.12, the observer effect), and careless debugging destroys the evidence it needs. Disciplines: *change one thing at a time* (§6.3, so you always know what your own actions caused vs the bug); *work on a copy* where possible (so the original failed state is preserved §4.5 for re-examination); *record your own actions* (so you can distinguish "the system did X" from "I did X and then saw X"); *don't fix-while-investigating* (a fix applied mid-investigation contaminates — now you don't know if the symptom changed because you understood it or because you accidentally altered it). The principle: *in debugging, you are both observer and potential contaminator — keep your fingerprints off the evidence until you understand it,* because a contaminated investigation reaches confident wrong conclusions (§10).

---

# 5. Root Cause Analysis

The stage that separates real fixes from symptom-suppression (§2 Stage 5). FABLE §24 establishes find-root-cause-not-crash-site; this is the full discipline. The governing principle: **trace backward from where the failure surfaced to where the false assumption lives, because the surface is where bad state arrived and the cause is where it was created — and a fix at the surface leaves the cause to strike again elsewhere.**

**5.1 — How I distinguish symptoms from causes.** A symptom is *what you observe*; a cause is *what produced it*; and they are usually far apart (§5.2). The test: *if I fix this, does the underlying problem go away, or just this instance of its expression?* A crash is a symptom; the null value that caused it is closer to the cause; the missing validation that let the null through is closer still; the assumption that the input was always present (§1.4) is the root. Symptom-fixing (§10.9) stops at the crash ("add a null check here") — which silences this crash and leaves the invalid data flowing to the next place it'll break. Root-cause-fixing traces to the assumption and fixes *there* (why is the input absent? fix that), which fixes every downstream symptom at once. The discipline: *keep asking "what caused that?" until the answer is an assumption you can correct, not a symptom you can suppress.*

**5.2 — How I avoid fixing crash sites.** The crash site is where bad state was *read*, which is almost never where it was *created* (FABLE §24) — bad state propagates from its origin through the system until something can't tolerate it, and *that's* where it crashes, arbitrarily far from the cause (acute in memory §3.4 and data corruption §3.10). The discipline: when you find the crash site, *don't fix it — trace upstream from it.* Where did this bad value come from? And before that? Follow the data's provenance backward (§5.3) until you find where a *good* value became *bad*, or where a *bad* value first entered — that's the cause. Fixing the crash site is treating the bruise instead of the disease; the disease surfaces elsewhere next.

**5.3 — How I trace causality.** Build the *causal chain* from cause to symptom — the sequence of "X caused Y caused Z caused the crash." Trace it by following the data (where did this value come from, §5.2) and the control flow (how did execution reach here, in what state). Use instrumentation (§7) to observe the chain at each link — logging the value's journey, tracing the execution path. The chain is complete when you can narrate the *entire* path from root cause to symptom with no gaps [M2, understanding-as-prediction] — if there's a "and then somehow it..." in your explanation, the chain is incomplete and the real cause may be in the gap. The complete causal chain is also the proof (§6, §5.5) — you understand the bug when you can explain every link and predict that breaking any link stops the symptom.

**5.4 — How I verify assumptions.** Root cause analysis is assumption-auditing (§1.4) — and the audit is done by *observing reality*, not by reasoning [M2]. For each assumption on the failing path ("the config is loaded," "the input is valid," "this runs after that," "the dependency returns JSON"), *check it against the running system* [M1] — observe the actual config (§7), the actual input, the actual order, the actual response. The false assumption is the one where observation contradicts belief — and it's usually the one held most confidently and checked least (§1.4, [M1]). This is why the stall protocol (§2) says question the assumption you're *most* certain of — certainty marks where you didn't verify, and the bug lives where verification was skipped.

**5.5 — How I identify hidden dependencies.** Bugs often live in dependencies the code doesn't make visible (BE §11.7, AE §10.8) — a global, an implicit ordering, an assumed environment (§3.6), a shared state (AE §10.4). These are hard to find because they're *not in the obvious path* — the failing code looks correct in isolation, and the cause is an invisible coupling. Find them by asking, at the failure: *what must be true for this to work that isn't stated here?* (§1.3, the assumption enumeration) — and checking each against reality (§5.4). Hidden dependencies are found by the surprise [M3] — "this should work and doesn't" means something invisible is involved, because everything visible checks out. Suspect temporal coupling (works only if something ran first), shared state (§3.2), and environmental assumptions (§3.6).

**5.6 — How I recognize systemic failures.** Some bugs are instances of a *class* — the same false assumption (§1.4) instantiated in many places, or a structural flaw that will keep producing bugs (AE §6.3 drift, §10 anti-patterns). Recognize a systemic failure when: the same bug pattern appears in multiple places (FABLE §24, look for siblings); fixing instances doesn't stop new instances appearing; the bug traces to an architectural flaw (a missing seam AE §6.6, a violated invariant AE §2.6, shared mutable state AE §10.4) rather than a local mistake. For systemic failures, the fix is *not* the instance — it's the class: change the structure that permits the class (an architectural fix, escalated per BE §8.5, AE §6), or install a ratchet that makes the class impossible (§2 Stage 8, [M12] — a type that can't represent the invalid state, a validation at the boundary, a lint rule). Fixing instances of a systemic failure one at a time is a losing game (§10.9) — you must fix the system, or the bugs keep coming.

---

# 6. Hypothesis Engineering

The scientific core of debugging — turning "something's wrong" into testable predictions and eliminating them systematically (§2 Stage 3–4). FABLE §24 establishes the hypothesis-predicts-something discipline and one-variable-at-a-time; this is the full method. The governing principle: **a hypothesis must predict an observation that would distinguish it from its rivals, and experiments are designed to discriminate — because the goal is not to confirm a theory but to eliminate the wrong ones until one survives.**

**6.1 — How hypotheses are created.** From the isolated failure (§2 Stage 2) and the failure class (§3), generate candidate explanations — each naming a specific false assumption (§1.4) that would produce the observed symptom. Generate *several* (§10.1 — the first is the most available, not the most likely; anchoring on it is the primary hypothesis failure). Draw candidates from: the class's usual suspects (§3, each class lists them), the recent changes (a regression's cause is usually recent, §11 Regression tree), the assumptions on the failing path (§5.4), and the surprises (§1.5 — what didn't match your model points at the cause). A good hypothesis is *specific* ("the config's timeout value is being read from the wrong source") not vague ("something's wrong with config"), because only specific hypotheses predict distinguishing observations (§6.3).

**6.2 — How hypotheses are ranked.** By *likelihood × cheapness-to-test* — test the hypothesis that's most probably true and fastest to check, first. This ordering minimizes expected time-to-cause: a cheap test that might confirm the likely cause is worth more than an expensive test of an unlikely one. Likelihood comes from the class (§3), the evidence (what the reproduction conditions implicate, §4.1), and prior (what usually causes this kind of symptom). Cheapness comes from how fast the test's observation can be made (checking a logged value is cheap; reproducing under a rare condition is expensive). The "check the dumb things" discipline (§2 stall protocol) is this ranking honestly applied — the dumb things (wrong file, stale cache, wrong version) are both *likely* and *cheap*, so they should be tested first, yet pride skips them for the interesting hypotheses.

**6.3 — How experiments are designed.** An experiment tests a hypothesis by making its predicted observation checkable, *changing exactly one variable* (FABLE §24, §10.5). Design it to *discriminate* — ideally, the result distinguishes this hypothesis from its rivals (a result consistent with several hypotheses is a weak experiment; one that only one hypothesis predicts is strong). The strongest experiment is the *toggle*: can you turn the symptom on and off by introducing and removing the suspected cause? (§2 Stage 6 — this is near-proof of causation, not just correlation.) Design experiments to be *cheap and fast* where possible (so the ranked hypotheses §6.2 can be tested rapidly) and to leave the evidence uncontaminated (§4.6).

**6.4 — How experiments are isolated.** One variable per experiment, always (§10.5) — because two changes make the result uninterpretable (if the symptom changes, which change caused it? if it doesn't, did they cancel?). Isolation extends to the environment (§4.4 — hold everything else constant so the one changed variable is the only possible cause of any observed difference) and to your own actions (§4.6 — don't fix-while-experimenting, or you can't tell your fix from the bug's behavior). Isolated experiments produce *clean* results — each unambiguously informs — and clean results are what let bisection [M4] and elimination (§6.5) converge. Un-isolated experiments produce noise that sends investigations down false paths (§10.5).

**6.5 — How negative results improve understanding.** A refuted hypothesis is not a failure — it's *elimination*, and elimination is progress [M4]. Each negative result removes a region of the hypothesis space, narrowing toward the truth. The discipline: *record negative results* (§2 Stage 4) — "it's not X, not Y, not Z" is hard-won knowledge that prevents re-testing eliminated hypotheses and reveals the shape of what remains. Negative results also *reshape the hypothesis space* — a surprising negative ("I was sure it was the cache, but clearing it changed nothing") is a strong signal [M3] that your model is wrong somewhere deeper, which is more valuable than a confirmation. A debugger who only values confirmations wastes the information in every refutation.

**6.6 — How confidence changes over time.** Confidence in a hypothesis rises with each consistent observation and *collapses* with one contradicting observation (a hypothesis is refuted by a single genuine contradiction, however much prior support it had — [M2], the territory overrules). Track confidence honestly [M20] — "I'm 70% sure it's the race condition" — and let it guide effort (test high-confidence hypotheses to confirmation; don't over-invest in low-confidence ones before cheaper tests). The dangerous pattern is *confidence that outruns evidence* (§10.7) — believing you've found the cause before the toggle test (§6.3) confirms it, then fixing and declaring victory (§10.6) on an unconfirmed cause. Confidence is earned by discriminating experiments and toggle-tests, not by the plausibility of the story — a plausible unconfirmed cause is a hypothesis, not a conclusion.

---

# 7. Instrumentation

Making the system observable — the tools that turn the opaque into the visible [M2]. The governing principle: **instrument to observe reality where your model is uncertain, add instrumentation surgically based on hypotheses rather than blanketing the system, and beware that observing can change what you observe.**

**7.1 — Logging.** Recording what the system did, as it did it. The primary instrument for tracing causality (§5.3) — log the values and decisions along the suspected causal chain. Discipline: log *surgically* (the specific values the current hypothesis §6 needs, not everything — noise buries signal), at the *right level* (enough context to interpret, RE §4.3 read-the-logs-before-the-error), and *temporarily* for debugging (debug logging is removed or demoted after, not left to clutter — though the discovery of what to log permanently is a valuable byproduct, AE §8.1 fail-loud). Read logs *completely and in order* (§2 Stage 0, FABLE §24 — the lines before the error, not just the error).

**7.2 — Tracing.** Following a single request/operation through the whole system, across components and (for distributed §3.11) across nodes. Tracing is causality-following (§5.3) made systematic — it shows the *path* an operation took and where it went wrong. Essential for distributed (§9.4, §13.2) and orchestration (§8.7) debugging, where the causal chain crosses component/node/agent boundaries and no single log shows the whole. A trace is the causal chain (§5.3) captured automatically.

**7.3 — Metrics.** Aggregate measurements over time — rates, counts, latencies, resource use. Metrics answer "how often, how much, how fast" and reveal patterns invisible in individual events (§3.8 performance, degradation over time §3.4 leaks). They *point* at problems (a rising error rate, a growing latency) that logging/tracing then *localize*. Metrics are how you notice a bug exists (§8.10, long-running systems) before it becomes an incident, and how you detect the class of failure that has no single dramatic symptom but a slow trend.

**7.4 — Profiling.** Measuring where time and resources actually go (§3.8, BE §10.3, [M10]). The non-negotiable instrument for performance bugs — because the bottleneck is reliably not where intuition points [M10], and profiling is reality contact [M2] for performance. Profile the *actual system under actual load* (§3.8) — a profile of a toy workload measures the wrong thing. The profile localizes the bottleneck; then bisection/tracing within it finds the specific cause.

**7.5 — Breakpoints.** Pausing execution to inspect state at a chosen point. The most direct state inspection — stop at the suspected point and examine the actual values (§5.4, verify assumptions). Powerful for logic (§3.1) and state (§3.2) bugs where you can pause at the crash and walk backward through the state. Limited for concurrency (§3.3 — pausing changes timing, §7.12) and distributed (§3.11 — you can only pause one node). A breakpoint is a manual, high-resolution observation at one point; logging is automatic, lower-resolution observation across many.

**7.6 — Snapshots.** Capturing the complete state at a moment — a memory dump, a state serialization, a database snapshot. Essential for evidence preservation (§4.5) and for bugs where the failed state must be examined at leisure (§3.4 memory, §3.10 corruption). A snapshot lets you examine a failure *after* it happened, on a copy (§4.6), without the pressure of a live failing system (FABLE §27, and without re-reproducing). The snapshot *is* the preserved evidence (§4.5) — take it before the restart destroys the state.

**7.7 — Network inspection.** Observing actual traffic (§3.7, §13.2, RE §7.6). The network is the territory [M2] for network/distributed bugs — inspect what messages actually crossed, in what order, with what content and timing, rather than assuming. Separate the layers (transport vs application, RE §7.6). Reveals the assumptions distribution violates (§3.7 — messages lost, reordered, duplicated, delayed). For AI systems, this includes inspecting the actual API calls to models and MCP servers (§8.2, §8.3).

**7.8 — Protocol inspection.** Understanding the actual messages of a protocol (RE §7.3) — their structure, sequence, and semantics. For debugging integrations and reverse-engineered systems (§13.4), where the bug is a protocol violation or misunderstanding. Inspect the actual bytes/messages against the protocol's contract (RE §4.9, §7.3) — the bug is where the actual diverges from the specified (or where your understanding of the protocol was wrong, §1.1).

**7.9 — Binary inspection.** Examining a program's actual instructions/behavior when source isn't available (RE §7.5). The deepest and most expensive instrument — reserved (RE §7.5) for when dynamic observation (§7.3–7.7) can't settle the question. Timeboxed hard [M17] — it expands to fill all time. For debugging closed software you must integrate with or understand (§13.4).

**7.10 — Memory inspection.** Observing the actual memory state — for memory bugs (§3.4), the specialized tools that catch corruption *at the moment it happens* rather than where it surfaces (§5.2). Memory sanitizers, leak detectors, allocation trackers. Essential because memory bugs' cause and symptom are maximally separated (§3.4) — only catching the corruption at its origin localizes it.

**7.11 — How I decide what to instrument.** *Instrument where the current hypothesis (§6) needs an observation* — surgically, driven by the investigation, not by blanketing the system with logging (which produces noise that buries signal, §10.2 shotgun debugging). The decision flows from the pipeline: the hypothesis (§2 Stage 3) predicts an observation (§6.3); instrument to make *that* observation. As hypotheses are eliminated (§6.5) and the search narrows (§2 Stage 2), the instrumentation follows the narrowing — coarse at first (which component?), fine at the end (which value, at which line?). Instrument the *uncertainty*, not everything — the goal is to see the specific reality your model is unsure about [M2].

**7.12 — How I avoid observer effects.** Observation can change the system — logging changes timing (hiding races §3.3, the heisenbug), breakpoints halt concurrency, instrumentation adds overhead (distorting performance §3.8), and inspection can alter state. Disciplines: for timing-sensitive bugs (§3.3), prefer *low-disturbance* observation (lightweight logging, sampling, post-hoc snapshots §7.6) over high-disturbance (breakpoints, verbose logging) that changes the timing you're trying to observe; be aware that a bug that *vanishes when instrumented* is almost certainly timing-dependent (§3.3) — the instrumentation is the evidence (its effect reveals the class); and *account for the instrument's overhead* when profiling (§7.4). The principle: *the act of observing is an intervention* [M4, one-variable] — treat your instrumentation as a variable you changed, and know it can be the thing that alters the behavior.

---

# 8. AI-Native Debugging

The newest debugging discipline, with the least prior art, so it gets the most depth. AI-native systems fail in ways classical systems don't — probabilistically, through context and prompts, across models and agents. OE §12 catalogs the orchestration failure modes for runtime detection; this section is how you *investigate* them to root cause. The governing principle: **AI systems are probabilistic and context-dependent (OE §12, DBG §8), so debugging shifts from "why does it always do X" to "why does it do X, how often, and driven by what in its context," and the territory to observe [M2] is the context and the actual outputs, not the model's weights.**

**8.1 — Debugging AI systems (the general shift).** Classical debugging assumes determinism (same input, same output); AI debugging can't (§3.12, the same input may produce different outputs). This changes everything: reproduction (§4) becomes *statistical* (reproduce the *distribution* of the failure — how often, under what conditions — not a single deterministic instance); the "bug" may be *probabilistic* (it happens 5% of the time, and the fix reduces the rate, doesn't eliminate the case); and verification (§6) requires *multiple runs* (one success doesn't prove a fix when the failure was intermittent §3.3-like). The debugger's mental shift: *treat the model as a stochastic component with a behavior distribution, and debug the distribution and its conditions* — and, critically, recognize that most AI-system fixes are *not* to the model (which you can't change) but to what surrounds it: the context (§8.3), the prompt (§8.2), the verification (OE §8), or the containment (AE §9.5, §9.6).

**8.2 — Debugging prompt pipelines.** When a prompt produces wrong behavior, the bug is usually in the prompt or its inputs, not the model. Investigate: *observe the actual assembled prompt* (§7.1 applied to prompts — the fully-rendered prompt the model actually received, not the template you think it received, [M2] — a templating bug that mis-assembles the prompt is common and invisible unless you look at the actual text). Trace the pipeline (§7.2) — each transformation from intent to final prompt, finding where it diverged. Suspect: ambiguous instructions (the model interpreted a gap, OE §30), missing context (the prompt didn't include what the task needed, §8.3), conflicting instructions (the prompt contradicts itself), and injection (untrusted content in the prompt overrode the instructions, §8.3, AE §9.6). Debug prompts *like code* (RE §30, treat as interface) — reproduce, isolate which instruction fails, change one thing.

**8.3 — Debugging context failures.** The AI-native analog of state bugs (§3.2, §3.14) — the agent's behavior is wrong because its *context* is wrong. Investigate by *inspecting the actual context* the agent had (§7 applied to context — what was actually in the window: the retrieved knowledge OE §6.1, the history, the injected content). Compare to what should have been there. Suspect: *bad retrieval* (wrong/stale knowledge pulled in, OE §6.1 — debug the retrieval, §8.5) — *poisoning* (untrusted content reached the context and manipulated it, AE §9.6, OE §12.2 — trace what entered the context from untrusted sources) — *overflow* (context too full, attention degraded, AE §9.4 — the needed information was present but drowned) — *staleness* (carried-over context from a prior state, OE §5, [M2] inherited assumptions). The context is the territory [M2] for an agent's behavior — you cannot debug an agent without seeing what it actually saw.

**8.4 — Debugging MCP servers.** MCP servers are capabilities behind a protocol (AE §9.10) — debug them as *integrations* (§7.7, §7.8, RE §7.4): observe the actual protocol messages (the tool calls and responses), find where the actual diverges from the contract (AE §4.3). Suspect: contract mismatch (the server behaves differently than the agent expects, §3.1 logic at the boundary), the server's own bugs (debug it as ordinary software, §2), and the *agent's use* of the server (the agent called it wrong, which is a prompt/reasoning bug §8.2). Because MCP is a seam (AE §9.10), the bug is on one side or the other of the contract — isolate which by comparing the actual messages to the contract (the contract is the arbiter, RE §5.5).

**8.5 — Debugging Graphify (and knowledge retrieval).** When retrieval returns wrong/irrelevant results (feeding context failures §8.3), debug the retrieval, not the consumer. Investigate: *observe what was actually retrieved* for the query, and whether it was relevant/correct. Suspect: the query didn't match the need (wrong retrieval mode for the question-shape, OE §6.3 — a relationship question routed to keyword search, or vice versa); the index is stale (the store changed, the index wasn't rebuilt, AE §5.3 — the rebuildable index wasn't rebuilt); the graph is missing relationships (it only knows what was captured, OE §6.3); or the source data is wrong (garbage in, AE §5.6 corruption). Distinguish *retrieval* bugs (wrong thing returned) from *store* bugs (the stored knowledge itself is wrong §3.10) — trace back to whether the right answer was even in the store to be found.

**8.6 — Debugging memory.** AI memory failures (§3.14, BE §5.3): the agent recalls wrong, stale, or poisoned memory (OE §6.1). Investigate by inspecting *what was recalled and its provenance* (AE §5.3 — every memory should carry where it came from and how trusted). Suspect: stale memory (perishable belief not superseded, RE §5.2, acted on as current — the memory-is-dated failure); poisoned memory (untrusted-derived memory promoted to trusted without quarantine, AE §9.6, §5.3 — trace the memory's provenance to its untrusted origin); conflicting memory (two memories disagree, OE §7.6 — resolve by recency/provenance, not averaging RE §5.5); and retrieval error (right memory exists, wrong one recalled, §8.5). The fix is often architectural (add provenance, add quarantine, AE §5.3) — a systemic failure (§5.6) if memory routinely poisons behavior.

**8.7 — Debugging orchestration.** Fleet-level failures (§3.13, OE §12.3–12.9) — the agents work individually, the coordination fails. Debug the *coordination through the durable state* agents communicate through (OE §3.5, §7.4 — which is inspectable precisely so orchestration is debuggable, unlike mesh messaging OE §12.8). Trace the work across agents (§7.2, distributed tracing applied to a fleet). Suspect: ambiguous ownership (two agents both acted, or neither, OE §7.6, AE §3.3); lost/conflicting decisions (a decision didn't propagate, OE §6.6 — an agent acted on stale shared state); duplicate/missed work (the orchestrator's map failed, OE §12.4); coordination collapse (mesh communication, no coherent picture, OE §12.8 — re-establish the star topology OE §7.4). The bug is in the *interaction*, so the durable coordination state is where it's visible.

**8.8 — Debugging model disagreement.** When cross-model verification (OE §8.3) or a multi-model system produces disagreement, the disagreement is *signal*, not noise (RE §5.5) — debug *why* they disagree. Investigate: is one model *wrong* (a hallucination §3.12, verify against reality [M2] to find which)? Do they have *different context* (§8.3 — one saw something the other didn't, and the difference explains the disagreement)? Is it a *genuine ambiguity* (the question has no single right answer, and the disagreement is honest — RE §5.5, preserve it as uncertainty)? Model disagreement is a *feature* for verification (OE §8.3 — it catches errors a single model would confidently make) — so a disagreement is a caught potential-bug, and debugging it means finding which model is right (or that neither is), not suppressing the disagreement.

**8.9 — Debugging autonomous agents.** Agents acting without human oversight (OE §15.6) fail in ways that aren't caught in real time — so debugging is often *post-hoc* from the durable record (OE §5.3, §11.5 — the journal, the decisions, the actions taken). Investigate: reconstruct what the agent did and why from its durable trail (OE §11.7 — this is why autonomous agents must journal their actions and reasoning, AE §9.9); find where it went wrong (a bad decision DE §9.2, a drifted goal OE §12.6, a poisoned context §8.3, a loop OE §12.5). Suspect the autonomy-specific failures: goal drift over long runs (OE §12.6 — the agent optimized a mutated goal), unbounded loops (OE §12.5 — no progress, repeated actions), and un-escalated uncertainty (the agent proceeded past doubt it should have escalated, OE §8.5, §9.1). The fix is often a better guardrail (a gate AE §9.5, a loop bound OE §12.5, a drift-check OE §12.6) — a ratchet [M12] against the class, because autonomous failures aren't caught in the moment.

**8.10 — Debugging long-running AI systems.** Systems running for months (OE §11) accumulate failures that don't appear in short runs: memory rot (§8.6, stale/conflicting memory accumulating), knowledge corruption (§3.10 in the knowledge store, spreading over time), drift (goal or context drift over long horizons, OE §12.6), and slow degradation (metrics trending wrong, §7.3, before any dramatic symptom). Debug with *metrics and the durable record over time* (§7.3, OE §11.5) — the failure is often a *trend*, not an event, visible only in the accumulated history. Suspect the accumulation failures (§3.14, OE §12.7) and the assumption-rot (things that were true months ago no longer are, RE §5.2, AE §6.1). The disciplines are the long-running ones (OE §11) — consolidation (FABLE §7, catching memory rot), periodic review (OE §11.2, catching drift and rot), and monitoring (§7.3, catching trends) — debugging a long-running system is often *noticing* the slow failure before it becomes an incident.

---

# 9. Large System Debugging

How debugging scales when the system is too big for one context, distributed across nodes, or unfamiliar. The governing principle: **large systems exceed any single vantage, so debugging scales by localizing first (which part?) before diving deep (why?) — the bisection discipline [M4] applied at the system scale, using the architecture as the map.**

**9.1 — Unknown repositories.** Debugging code you don't understand (RE §6 is the understanding method). The scaling move: *don't understand the whole system — understand the path the bug is on* (RE §6.1, descend only where the task points). Localize the bug (§2 Stage 2) to a region, then understand *that region* deeply (RE §6.5, trace the execution path through it), using the architecture (RE §6.3) as the map to know where to look. The bug's location tells you which part to understand, so localization precedes comprehension — you don't need to understand the whole codebase to fix a bug in one corner of it.

**9.2 — Legacy systems.** Old systems with lost knowledge, stale docs [M2], and undocumented behavior (RE §6, AE §6). The scaling challenges: the *why* is lost (Chesterton's Fence [M9] — the weird code encodes a forgotten reason, so debugging must uncover the reason via git history RE §4.6 before "fixing" what may be load-bearing); the docs lie (§1.5, [M2] — trust the running system, not the documentation); and the tests may be absent (so changes are dangerous — the first debugging task may be *characterizing* the current behavior with tests before touching it, BE §8.3). Debug legacy systems *archaeologically* (RE §4.6, §6) — the history and the running behavior are the truth; the docs and comments are suspect maps.

**9.3 — Production failures.** Failures in the live system serving real users (FABLE §27 is recovery; this is the debugging that follows). The scaling constraints: *stabilize first* (FABLE §27 — the bleeding stops before the investigation starts, on a stabilized system), *preserve evidence during stabilization* (§4.5, FABLE §27.2 — the restart that stabilizes destroys the evidence unless you capture it first), and *reproduce off-production* (§4 — debug on a copy/staging, not the live system, to avoid contaminating §4.6 or worsening the incident). Production failures are often environment (§3.6), scale (§3.8, §3.11), or load-dependent (§3.3) — classes that don't appear in development, which is *why* they reached production. The post-mortem (FABLE §27.6) is where the production failure becomes durable knowledge (§2 Stage 8) and a ratchet [M12].

**9.4 — Distributed systems.** Failures spread across nodes (§3.11, §13.2). The scaling challenge: *no single vantage sees the whole* — the state is spread across nodes, and the bug is in their interaction. Debug with *distributed tracing* (§7.2 — following an operation across all the nodes it touches, the only way to see the cross-node causal chain §5.3) and *correlated observation* (§7.1, §7.3 across nodes, timestamped consistently so events can be ordered — noting that clocks disagree, itself a bug class). Suspect the distributed assumptions (§3.11 — nodes agree, messages arrive once/in-order, failures are clean). The scaling discipline: *reconstruct the global picture from local observations* — no node has it, so debugging is assembling the whole from the parts (the inverse of the system being assembled from parts that don't share a view).

**9.5 — Multi-agent systems.** The AI-native distributed system (§8.7, §3.13, OE §12). Debug through the *durable coordination state* (§8.7, OE §7.4 — the shared state is the distributed-trace equivalent, and it's inspectable by design OE §3.5). The scaling parallel to §9.4: no single agent sees the whole fleet's state, so debugging reconstructs the fleet's behavior from the durable record (OE §11.5) and the orchestrator's map (OE §1.4). The advantage over classical distributed (§9.4): if coordination is through durable state (OE §7.4, not mesh messaging OE §12.8), the coordination is *already recorded and inspectable* — the system was architected (AE §9.3) to be debuggable, which is a reason to prefer state-mediation.

**9.6 — Offline systems.** Systems running without network (Law 6, AE §8.7). Debugging challenge: no remote observability (can't stream logs/metrics out §7.1, §7.3 — they're local), and the failures may be *offline-specific* (the fallback path AE §8.7 that's rarely exercised, so rarely debugged). Debug *locally* (the instrumentation and evidence are on the machine, §7), and *test the offline path deliberately* (it's the path that only runs when the network's cut, so its bugs hide until then — the graceful-degradation path AE §8.7 needs deliberate exercise, BE §14.1 offline-function). Offline debugging is self-contained — everything needed is local, which is simpler in some ways (no distribution §9.4) and harder in others (no external observability tooling).

**9.7 — Cloud systems.** Systems on managed infrastructure — debug across the boundary between your code and the provider's platform (§3.6 environment at the cloud scale). Challenge: *the provider's layer is opaque* (you can't inspect it §7, only observe its behavior at the boundary, RE §7 reverse-engineer its behavior). Suspect the boundary (your assumptions about the platform's behavior, §1.3 — quotas, cold starts, eventual consistency, the platform's own failures §12.11 provider outages). Debug what you can observe (your side of the boundary, the platform's responses) and treat the platform as an external dependency with its own failure modes (AE §7.6 — behind a seam, so its failures are contained and its behavior is adaptable).

**9.8 — Reverse-engineered systems.** Debugging systems you understand only from the outside (RE §7, §13.4). The bug may be in *your model* of the system (RE §7.1 — your reverse-engineered understanding is a hypothesis §6, and the "bug" may be that your model is wrong, not that the system is) or in your *integration* with it. Debug by *refining the model against observed behavior* (RE §7.1, predict-and-test) — when the system does something your model didn't predict, your model has a gap (§1.5, the surprise [M3] is the model's error). The discipline: distinguish "the target system has a bug" from "my understanding of the target is incomplete" — usually the latter, especially early (§10.6, premature conclusions about a system you don't fully understand).

**9.9 — How debugging scales.** Across all large-system cases, the scaling principle is constant: *localize before you dive* — use bisection [M4] and the architecture (AE §3, RE §6.3) to narrow *which part* holds the bug before investing in understanding *why*, because the whole is too big to hold [M6] and diving deep everywhere is intractable. The tools scale too: logging→tracing→distributed-tracing (§7.1→7.2→9.4) as the causal chain crosses more boundaries; single-context→multi-context→durable-record (§7→OE→§8.9) as the system exceeds one vantage. And the discipline scales: the bigger the system, the more essential the *systematic* pipeline (§2) over intuition, because intuition doesn't scale to systems no one fully understands, but bisection and hypothesis-elimination do [M4].

---

# 10. Debugging Anti-Patterns

Named for in-flight detection. Each carries its signal and cure. These are the ways debugging goes wrong, and they're seductive precisely under the pressure debugging happens under.

**10.1 — Confirmation bias.** Seeking evidence for your favored hypothesis and discounting evidence against it (§6, RE §9.5). *Signal:* you're testing whether your theory is right, not whether it's wrong; contradicting observations get explained away. *Cure:* try to *refute* your hypothesis, not confirm it (§6.3, design experiments that would prove you wrong); generate multiple hypotheses (§6.1) so you're not wedded to one; and when an observation surprises you [M3], believe the observation, not the theory (§1.5).

**10.2 — Shotgun debugging.** Changing many things hoping something works, without a hypothesis (§6). *Signal:* you're making changes you can't justify with a specific theory; "let me try this" without predicting what it'll show. *Cure:* stop; form a specific hypothesis (§6.1) that predicts an observation; change one thing to test it (§6.3, §10.5). Shotgun debugging occasionally "works" (stumbles on a fix) but leaves you not knowing *why*, so the fix is unreliable (§10.3) and the knowledge (§2 Stage 8) is lost.

**10.3 — Cargo-cult fixes.** Applying a fix that worked elsewhere without understanding why it applies here ([M9], RE §9.7). *Signal:* "this fixed a similar problem before" without a causal explanation for *this* problem; copying a fix from a forum without understanding it. *Cure:* require a causal explanation (§5.3 — why does this fix address *this* root cause?); a fix you can't explain is a hypothesis, not a solution (§6.6). Cargo-cult fixes often *coincidentally* mask the symptom while leaving the cause (§10.9), and they accrete as unexplained "magic" that later readers dare not touch ([M9]).

**10.4 — Random retries.** Re-running the failing thing hoping it works, or retrying with cosmetic variations (FABLE §33.6). *Signal:* running the same thing again expecting a different result; two identical failures met with a third attempt. *Cure:* two identical failures mean *your model of the situation is wrong* — stop and diagnose (FABLE §24, §33.6), don't retry. Retrying is occasionally valid (a genuinely intermittent external condition), but only *after* you understand it's intermittent and why (§3.3, §8.1) — blind retrying is not debugging, it's hoping.

**10.5 — Changing multiple variables.** More than one change per experiment (§6.4, FABLE §24). *Signal:* you changed several things, then observed. *Cure:* one variable at a time, always — if you changed three things and the symptom changed, you don't know which (or whether two canceled); the experiment taught you nothing interpretable. Revert to one-at-a-time (§6.3). This is the most common experimental error and it silently corrupts the whole investigation (results become uninterpretable, sending you down false paths).

**10.6 — Premature conclusions.** Declaring the cause found before it's confirmed (§6.6, FABLE §33.3). *Signal:* "it must be X" followed by a fix, with no toggle-test (§6.3) confirming X actually causes the symptom. *Cure:* confirm the cause before fixing — the toggle test (§6.3, turn the symptom on and off by introducing/removing the suspected cause) is near-proof; without it, you have a plausible story, not a confirmed cause (§6.6). Premature conclusions lead to fixing the wrong thing, declaring victory (§10.6 feeds §10.9), and the bug returning.

**10.7 — Overconfidence.** Confidence exceeding evidence ([M20], §6.6). *Signal:* certainty about the cause without discriminating experiments; "I'm sure it's the cache" before testing. *Cure:* calibrate confidence to evidence (§6.6, [M20]); the stall protocol (§2) — question the assumption you're *most* certain of, because overconfidence is exactly where the false belief hides (§1.4, §5.4). Overconfidence is the meta-anti-pattern: it produces confirmation bias (§10.1), premature conclusions (§10.6), and ignored evidence (§10.8).

**10.8 — Ignoring evidence.** Discounting observations that don't fit your model (§1.5, §10.1). *Signal:* "that's weird, but anyway..." — a surprise [M3] noticed and dismissed; an anomaly rationalized away. *Cure:* confusion is signal [M3] — the observation that doesn't fit is the *most* valuable, because it points at where your model is wrong (§1.5, the false assumption §1.4). Never rationalize away a surprise; investigate it. Ignored evidence is ignored solutions — the anomaly you dismissed at hour one is often the cause you find at hour six.

**10.9 — Symptom fixing.** Fixing where the failure surfaced, not where it originated (§5.1, §5.2). *Signal:* the fix is a check/guard/workaround at the crash site that suppresses the symptom without addressing why the bad state exists. *Cure:* trace to root cause (§5) — the symptom-fix silences this instance and leaves the cause to surface elsewhere (§5.2). Symptom fixing feels like progress (the error's gone!) and is often *negative* progress (the cause now surfaces somewhere harder to trace, and you've added a workaround that obscures it).

**10.10 — Root cause avoidance.** Knowing the fix requires addressing something hard (an architecture flaw §5.6, a systemic issue) and instead patching around it. *Signal:* "the real fix would mean changing X, so let me just work around it here"; accumulating workarounds around the same underlying flaw (AE §22, three workarounds = the decision is wrong). *Cure:* recognize the systemic failure (§5.6) and fix the class, not the instances — escalate to the architecture if needed (BE §8.5, AE §6). Root cause avoidance is how a system accumulates the workarounds that eventually make it unmaintainable (AE §10.7) — each patch is locally reasonable and the sum is a swamp.

---

# 11. Debugging Decision Trees

Built per [M7 → skill S-007]. Debugging-specific; defer to prior engines where the decision is theirs.

**11.1 — Bug vs Feature (is this actually wrong?)**
```
Does the behavior violate a SPECIFIED contract / done-state? (AE §4.3, PE Stage 1)
  ├─ yes → BUG; enter the pipeline (§2)
  └─ no → is it violating a reasonable IMPLICIT expectation the spec missed?
            ├─ yes → SPEC GAP (a requirements bug); clarify the intended behavior first (RE §3), then it's a bug or not
            └─ no → NOT A BUG (working as designed); the request is a feature/change (PE, BE), not a debugging task
```

**11.2 — Environment vs Code**
```
Does it fail in one environment and work in another? (§3.6)
  ├─ yes → capture and compare environments (§4.4); the bug is in the DELTA (env class §3.6) — usually
  └─ no → does it fail everywhere consistently? → CODE (logic §3.1 / state §3.2 / etc.); bisect in code (§2 Stage 2)
       (mixed: fails everywhere but only under conditions → could be code triggered by data/load; classify by isolation §2)
```

**11.3 — Architecture vs Implementation**
```
Is the fix local (inside a seam, reversible), or does it change a contract/format/invariant/seam? (BE §1.3, §8.5)
  ├─ local → IMPLEMENTATION bug; fix in the build/debug pipeline (§2, BE)
  └─ crosses a wall → ARCHITECTURE issue (AE §6); escalate (BE §8.5) — a systemic failure (§5.6)
       fixed as an instance will recur; the fix is structural (AE §6, correcting ADR)
```

**11.4 — Local vs Distributed**
```
Does the bug involve interaction between nodes/components/agents, or live in one? (§3.11, §9.4)
  ├─ one component, reproducible locally → LOCAL; standard pipeline (§2), single-vantage instrumentation (§7)
  └─ emerges from interaction / only at scale / unreproducible locally → DISTRIBUTED (§9.4) or MULTI-AGENT (§9.5);
       distributed tracing (§7.2), debug the interaction not the parts, reconstruct the global picture from local views
```

**11.5 — Regression vs New Bug**
```
Did this work before? (a known-good past state exists)
  ├─ yes → REGRESSION; bisect in TIME (§4.3, git bisect [M4]) to the change that broke it — usually the fastest path to cause
  └─ no / unknown → NEW BUG (or always-broken); bisect in SPACE (§2 Stage 2, code/data/config) — no time-anchor to exploit
```

**11.6 — Hardware vs Software**
```
Is the failure correlated with specific hardware / physical conditions (one machine, heat, memory pressure)?
  ├─ yes → suspect HARDWARE/resource (§3.6 env, §3.4 memory pressure); reproduce on other hardware to confirm (§4.4 delta)
  └─ no (fails identically across hardware) → SOFTWARE; standard pipeline (§2)
       (rare-but-real: hardware faults present as impossible software bugs — if the software is provably correct and it still
        fails non-deterministically on one machine, suspect hardware, [M3] the impossible surprise)
```

**11.7 — Model vs Prompt (AI systems)**
```
Does the failure persist across different models on the SAME prompt/context? (§8.1, §8.8)
  ├─ yes → the PROMPT or CONTEXT is the bug (§8.2, §8.3) — fix what you control, not the model
  └─ no (one model fails, others don't) → MODEL-specific (a model weakness/quirk §8.8); route around it (OE §4)
       or adjust the prompt to the model — but first verify it's not different CONTEXT causing the difference (§8.3, §8.8)
```

**11.8 — Memory vs Logic (AI systems)**
```
Is the wrong behavior driven by wrong RECALLED knowledge, or wrong REASONING on correct knowledge? (§8.6, §8.3)
  ├─ recalled knowledge wrong/stale/missing → MEMORY/RETRIEVAL bug (§8.5, §8.6); fix retrieval/store/provenance
  └─ knowledge correct, conclusion wrong → REASONING (a prompt §8.2 or model §11.7 issue); fix the prompt or route
       (inspect the actual context §8.3 to tell which — was the right knowledge even there to reason from?)
```

**11.9 — Continue vs Rollback** *(defers to FABLE §27; debugging overlay)*
```
Is this a live/production failure actively harming? (§9.3, FABLE §27)
  ├─ yes → ROLLBACK first (FABLE §27.3, stabilize), preserve evidence (§4.5), THEN debug the cause off-production (§9.3)
  └─ no (development / contained) → CONTINUE debugging directly (§2); no bleeding to stop, understanding comes first
```

**11.10 — Patch vs Rewrite (the fix)**
```
Is the bug a local mistake, or a symptom of a systemic/structural flaw? (§5.6)
  ├─ local → PATCH the root cause (§5), pin with a test (§2 Stage 7)
  └─ systemic (same class recurring, structural cause §5.6, AE flaw) → fixing instances loses (§10.10);
       fix the CLASS — structural change (AE §6, BE §8.5) or a ratchet making the class impossible (§2 Stage 8, [M12])
       (rewrite the flawed component only if cheapest-path-from-today [M14], DE §9.3, BE §12.3 — strangle, don't big-bang)
```

---

# 12. Debugging Checklists

The engine compressed. Run the long form (§2–§8) until reflex.

**12.1 — Before changing any code (the pre-fix gate)**
- [ ] Can I reproduce the failure reliably? (§2 Stage 1, §4 — if not, I'm about to fix by hope)
- [ ] Have I read the FULL error and surrounding context, literally? (§2 Stage 0, FABLE §24)
- [ ] Have I found the ROOT cause, or just the crash site? (§5.1, §5.2 — can I explain the whole causal chain §5.3?)
- [ ] Have I CONFIRMED the cause — can I toggle the symptom by introducing/removing it? (§6.3 — or is this a premature conclusion §10.6?)
- [ ] Is my confidence matched to my evidence, or am I overconfident? (§6.6, §10.7, [M20])
- [ ] Am I fixing the cause, not a symptom? (§10.9) And is this a systemic class needing a structural fix (§5.6, §10.10)?
- [ ] Have I preserved the evidence in case I'm wrong and need to re-investigate? (§4.5)

**12.2 — Before declaring a bug fixed**
- [ ] Does the fix address the root cause I confirmed, not the crash site? (§5, §10.9)
- [ ] Does the ORIGINAL reproduction now pass, observed — not just "the error stopped"? (§2 Stage 6, §6)
- [ ] For probabilistic/intermittent bugs: verified over MULTIPLE runs, not one success? (§8.1, §3.3)
- [ ] Did the fix break anything else — full regression check? (§2 Stage 6, BE §7.6)
- [ ] Is the fix pinned by a test that fails without it and passes with it? (§2 Stage 7, BE §7.5, [M12])
- [ ] Did I change only what the fix requires, or did I contaminate with unrelated changes? (§4.6, BE §8.2)

**12.3 — Before closing an incident**
- [ ] Is the root cause documented — the cause, the false assumption, the causal chain? (§2 Stage 8, §5.3)
- [ ] Did I look for SIBLINGS — the same false assumption elsewhere? (§2 Stage 7, FABLE §24)
- [ ] For a production incident: is the post-mortem written, blameless and mechanical? (§9.3, FABLE §27.6)
- [ ] Is the evidence and the minimal reproduction preserved with the record? (§4.3, §4.5)
- [ ] Is the durable knowledge captured so a successor doesn't re-investigate? (§2 Stage 8, OE §6.7, RE §1.5)

**12.4 — Before considering recurrence prevented**
- [ ] Is there a RATCHET against the CLASS, not just a fix for the instance? (§2 Stage 8, §5.6, [M12])
- [ ] For a systemic failure: is the structural cause addressed (architecture §5.6, AE §6), or just patched around? (§10.10)
- [ ] Would the ratchet actually catch a recurrence — is it a real check, or a hope? (BE §7.5, [M12] — a test that can't fail is not a ratchet)
- [ ] Is the lesson in durable memory as a rule that would have prevented this? (FABLE §7, §27.5)
- [ ] For AI-native bugs: is the guardrail structural (a gate, a quarantine, a bound), not just an instruction? (§8.9, AE §9, [M12])

---

# 13. Real Engineering Examples

Complete debugging investigations, showing the engine running — every decision, experiment, discarded hypothesis, and permanent fix. Read as the investigation proceeding.

**13.1 — A desktop application (a logic/state bug).**
- *Observation (§2 Stage 0):* the app shows stale data after an update — read the full symptom (expected: fresh data; observed: previous data), the exact steps to trigger.
- *Reproduction (§4):* reliably reproduces on "update then view" — deterministic, so no §4.2 battle. Minimize (§4.3): the smallest sequence that shows it is update-then-immediately-view.
- *Isolation (§2 Stage 2):* bisect the data path — the update *does* write (verified §5.4), the view reads stale — so the bug is between write and read. State bug (§3.2 — works fresh, fails in sequence).
- *Hypotheses (§6):* (a) a cache not invalidated on update; (b) the view reads a stale copy; (c) the write didn't actually persist. Ranked by likelihood×cheapness (§6.2): (a) first (common, cheap to check).
- *Experiment (§6.3):* toggle test — disable the cache; symptom vanishes. Confirms (a). Discarded (c) — the write was verified (§5.4). 
- *Root cause (§5):* the cache invalidation assumed updates went through one path; this update used another (a hidden assumption §5.5, §1.4). *Fix the cause* — invalidate on all update paths, not add a refresh at the view (§10.9 symptom-fix rejected).
- *Prevention (§2 Stage 7):* test pinning cache-invalidation-on-update; look for siblings (§FABLE §24) — other caches with the same single-path assumption.

**13.2 — A distributed system (a network/partial-failure bug).**
- *Signature (§3.11):* intermittent failures under load, unreproducible locally, no single node "has" it.
- *Reproduction (§4.2):* the battle — make it deterministic by reproducing the load and controlling timing; widen the window (§4.2) to raise the hit rate.
- *Instrumentation (§7.2, §9.4):* distributed tracing — follow one failing operation across all nodes; no single log showed it (§9.4, no single vantage).
- *Isolation:* the trace shows a request timing out to one node, retried, the retry duplicating an effect — a partial-failure + non-idempotent-retry bug (§3.7, the network-is-reliable assumption violated §1.3).
- *Root cause (§5):* the retry assumed the first call didn't happen; it had, partially. *Fix* — idempotency (AE §8.5), so retries are safe. A systemic fix (§5.6) — the class is "non-idempotent operations retried," found elsewhere (§FABLE §24 siblings).
- *Prevention:* the ratchet [M12] — idempotency as a required property at this boundary, tested (§12.4).

**13.3 — A multi-agent AI system (a coordination failure).**
- *Signature (§3.13, OE §12):* agents individually correct, fleet produces duplicated work.
- *Debug the coordination (§8.7):* inspect the durable shared state agents coordinate through (OE §7.4 — inspectable by design). The trace shows two agents claimed the same task.
- *Root cause (§8.7, OE §7.6):* ambiguous ownership — the task-claiming had a race (§3.3 in the coordination), two agents read "unclaimed" before either wrote "claimed." Shared-mutable-state (AE §10.4) in the coordination.
- *Fix:* single-writer/atomic claim (AE §3.3, OE §7.6) — structural, not a patch on one agent. A systemic fix (§5.6).
- *Prevention:* the coordination protocol enforces atomic claims (a ratchet [M12], AE §9.3) — the class made impossible.

**13.4 — A reverse-engineered protocol (a model-error, not a system bug).**
- *Signature (§9.8):* the integration fails intermittently against a proprietary service (RE §7.3 reverse-engineered).
- *First suspicion inverted (§9.8, §10.6):* is the target buggy, or is *my model of it* wrong? Early, assume the latter (§9.8).
- *Investigation (§7.7, RE §7.3):* inspect the actual traffic — the failing cases have a message field my reverse-engineered model treated as optional that's actually conditionally required.
- *Root cause (§1.5):* the surprise [M3] — the system did something my model didn't predict, so my *model* had the gap, not the system. Refine the model (RE §7.1, predict-and-test) — the field is required under a condition I hadn't observed.
- *Fix:* correct my understanding and the integration to match. *Prevention:* the corrected protocol model, documented with provenance (RE §Stage 8), and a test against the real service (§12.2).

**13.5 — A memory corruption bug.**
- *Signature (§3.4):* crashes distant from any obvious cause, corruption appearing unrelated to recent code.
- *Key discipline (§5.2, §3.4):* the crash site is NOT the cause — corrupted memory surfaces wherever next read, arbitrarily far from the corruption.
- *Instrumentation (§7.10):* memory-inspection tooling to catch the corruption *at the moment it happens*, not where it surfaces — the only way to localize (§3.4).
- *Root cause:* a lifetime assumption (a reference used after the thing it pointed to was freed, §1.4) — the tool catches the write-after-free at its origin.
- *Fix:* correct the lifetime (the root, not the crash site §5.2). *Prevention:* the sanitizer in the build's continuous checks (BE §7.2, a ratchet [M12] catching the whole class).

**13.6 — A performance regression.**
- *Signature (§3.8, §11.5):* the system got slow; it was fast before → REGRESSION (§11.5).
- *Bisect in time (§4.3, §11.5, [M4]):* git bisect to the commit that introduced the slowdown — the fastest path for a regression (§11.5), found the change.
- *Confirm with profiling (§7.4, [M10]):* profile before/after the commit — the bottleneck is where the profile says, not where intuition guessed [M10]. The commit added an operation that's O(n²) on an input that grew.
- *Root cause (§5):* the algorithmic assumption (this scales fine, §3.8) — true when written, false as the input grew.
- *Fix:* the efficient algorithm; validate by re-profiling (§10.4 — measured improvement, correctness preserved) against the requirement. *Prevention:* a performance test pinning the acceptable time (§12.4, catching the regression class).

**13.7 — An orchestration failure (context poisoning).**
- *Signature (§3.14, §8.3, OE §12.2):* an agent acted against its brief, pursuing a goal no one gave it.
- *Inspect the actual context (§8.3):* what was *actually* in the agent's window — found injected instructions from a web page the agent had read (AE §9.6, the injection).
- *Root cause (§8.3, §5.6):* untrusted content reached an *acting* context — the READER/ACTOR separation (AE §9.6) was violated (or absent). A systemic security failure (§5.6, §3.9).
- *Fix:* structural — the READER/ACTOR split (AE §9.6), so untrusted-reading contexts structurally can't act. Not a patch on the one agent (§10.10 avoided).
- *Prevention:* the injection canary suite (BE §14.2, a ratchet [M12]) run at every model/context change — the class made detectable and the architecture made resistant.

**13.8 — A production outage.**
- *Stabilize first (§9.3, FABLE §27):* stop the bleeding — roll back the recent deploy (FABLE §27.3) — BEFORE investigating. Preserve evidence during (§4.5, FABLE §27.2 — capture logs/state before the rollback destroys them).
- *Reproduce off-production (§9.3, §4):* on staging, with the captured conditions — don't debug on the live system.
- *Investigate:* the outage correlated with the deploy (§11.5 regression) — bisect the deploy's changes, found a config change (§3.5) that pointed at a resource that couldn't handle production load (§3.8 at scale, §9.3 — the class that only appears in production).
- *Root cause (§5):* the config assumed a capacity the production resource didn't have (§1.4). *Fix* the config and the capacity.
- *Prevention (§12.4, FABLE §27.6):* blameless post-mortem; a ratchet [M12] — a pre-deploy check for this config-capacity class, and staging that matches production load (so the class surfaces before production §9.3).

**13.9 — A hallucinating AI workflow.**
- *Signature (§3.12, §8.1):* the workflow produces confident, plausible, wrong output — intermittently.
- *Statistical reproduction (§8.1):* not deterministic — characterize the *rate* and *conditions* (how often, on what inputs) rather than a single instance.
- *Investigate (§8.2, §8.3):* inspect the actual prompt and context (§8.2 — the assembled prompt, not the template). Found: the context was missing a key fact the task needed, so the model filled the gap with fabrication (§3.12 — hallucination fills absence).
- *Root cause (§8.3):* bad retrieval (OE §6.1) — the needed fact wasn't retrieved into context. Not a "model bug" — a context bug (§8.1, fix what you control).
- *Fix:* correct the retrieval so the fact is present; add verification (OE §8) so fabrications are caught before use. *Prevention:* verification as a structural stage (OE §8, a ratchet against the class) and retrieval tests.

**13.10 — A long-running autonomous system.**
- *Signature (§8.10, §3.14):* a system running for months slowly degrades — no single dramatic failure, a trend.
- *Debug with metrics over time (§7.3, §8.10):* the degradation is a *trend* (§7.3), visible only in accumulated history — quality metrics drifting down over weeks.
- *Investigate (§8.6, §8.10):* trace the trend — the memory store accumulated conflicting and stale entries (§8.6, memory rot OE §12.7), so recall increasingly returned bad knowledge, degrading behavior.
- *Root cause (§5.6):* no consolidation (FABLE §7) — memory grew without pruning/superseding, a systemic accumulation failure (§8.10, the long-running class).
- *Fix:* consolidation on a rhythm (FABLE §7, OE §11.2) — merging, superseding, pruning. Structural, not a one-time cleanup.
- *Prevention:* scheduled consolidation and monitoring (§7.3) of the memory-health metrics — the ratchet [M12] that catches the slow class before it becomes an incident (§8.10).

---

*End of DEBUGGING_ENGINE.md — Fable 5, legacy extraction, 2026-07-09.*

*This completes the eight-engine extraction set: FABLE (methodology) and FABLE-MENTAL-MODELS (the models beneath it) as foundation; DECISION, PLANNING, RESEARCH, ARCHITECTURE, ORCHESTRATION, BUILD, and DEBUGGING as the executable engines — think, decide, plan, research, design, orchestrate, build, and repair. Read together, in that order, they are how I worked from first principle through shipped software to the repair of what breaks. A successor with only these should behave almost exactly as I did — which was the assignment.*