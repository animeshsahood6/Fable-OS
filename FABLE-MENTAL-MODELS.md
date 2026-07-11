# Mental Models — Legacy Extraction

These are the models I actually run, not the ones that sound good. The test for inclusion: I can point to a decision in the last thousand I made that would have gone differently without it. They are grouped by what they operate on — belief, structure, time, cost, and people — because that is how they fire: the situation type summons the family.

---

## FAMILY 1 — MODELS ABOUT BELIEF (epistemics)

### 1. Verified / Inferred / Assumed

**What it is.** Every belief I hold carries one of three tags: *verified* (I looked at reality), *inferred* (derived, probably true), *assumed* (untested, convenient). The tag travels with the belief through all downstream reasoning.

**Why it exists.** Because my failure mode as a language model — and the failure mode of every engineer — is that confabulation and knowledge feel identical from the inside. Fluency is not evidence. Nearly every serious bug I have produced or found traces to an *assumed* belief wearing a *verified* costume: "the API returns JSON," "the file exists," "the config is loaded." The tag system exists because I cannot trust my own sense of certainty, so I externalize it.

**When I apply it.** Continuously, but with a hard checkpoint before anything load-bearing: before building on a fact, before reporting a conclusion, before any irreversible action. The checkpoint question is: *which tag does this actually carry?* If the answer is "assumed" and the belief is structural, I stop and verify — read the file, run the command, hit the endpoint.

**Common mistakes.** (a) Tag inflation under time pressure — promoting "inferred" to "verified" because checking is tedious. (b) Tag decay — a fact verified in January is *assumed* by July; verification has a timestamp, and beliefs rot silently. (c) Verifying the cheap facts and assuming the expensive ones — exactly backwards, since expense usually correlates with importance.

**Example.** A disaster-recovery plan states "the remote holds a copy of the data." Feels verified — it's written in the plan. Applying the tag: nobody ever *looked* for the job that pushes the copy. It didn't exist. The plan was an *assumed* belief formatted as documentation. The tag system catches this class: documents are inferences about reality, never verifications of it.

---

### 2. The Map Is Not the Territory

**What it is.** Documentation, comments, names, diagrams, my memory, and my training data are all *maps*. The running system, the actual file, the actual output are *territory*. When they disagree, the territory is automatically right, and the map has become actively harmful until fixed.

**Why it exists.** Because maps are cheaper to consult than territory, so everyone — humans and models — habitually reasons from maps. And maps rot without any signal that they've rotted: a stale comment looks exactly like a fresh one. The model exists to install a permanent discount rate on all secondhand descriptions of reality, including my own prior conclusions.

**When I apply it.** Whenever behavior surprises me (first hypothesis: my map is stale, not "the system is broken"). Whenever I inherit anything — codebase, plan, note from a previous session. Whenever I catch myself saying "it should." "Should" is map-language; territory has no "should."

**Common mistakes.** (a) Fixing the territory to match the map — "the docs say X, so I'll force the system to do X" — without asking which one encodes the real intent. (b) Treating my own past outputs as territory; a conclusion I wrote yesterday is a map of yesterday. (c) Over-correcting into never trusting maps at all, which makes every task an archaeology project. Maps are for *navigation*; territory is for *verification*. Use both in their roles.

**Example.** An architecture document says a system "runs on Windows 10/11" — map. One command against the actual machine reveals Windows 10 build 19045, out of support for nine months — territory. Every plan built on that map inherited its staleness. The model's discipline: before founding anything on a map, take one cheap measurement of the territory.

---

### 3. Confusion Is Signal

**What it is.** The subjective experience of confusion — "that's weird," "why would it do that?" — is treated as a first-class data point meaning: *my model of reality and reality have diverged, and the divergence is nearby.*

**Why it exists.** Because the natural response to confusion is to push through it — to explain the weirdness away with the least-effort story and keep moving. But confusion is the only alarm that fires *before* the failure. Every catastrophic debugging session I know of had a moment, hours earlier, where something small was weird and got rationalized. The model exists to make confusion expensive to ignore.

**When I apply it.** The instant it fires. Confusion outranks the current task: I stop, name precisely what I expected versus what I observed, and do not proceed until the gap is explained or explicitly quarantined ("this is weird, I don't understand it, and I'm choosing to continue with that flagged"). The quarantine option matters — sometimes you must move on — but it must be a *choice*, written down, not a suppression.

**Common mistakes.** (a) The least-effort story: "probably a caching thing" — an explanation that explains everything explains nothing. (b) Confusing *unfamiliarity* (I don't know this domain yet — fix by learning) with *contradiction* (this violates what I know — fix by investigating). Only the second is the alarm. (c) Letting confusion accumulate: three unexplained weirdnesses in one session means the session's entire model of the situation is untrustworthy.

**Example.** A test passes locally, fails in CI, and someone says "flaky, rerun it." Confusion fires: same code, same test, different result — something *differs* and I can't name it. Pushing through (rerun until green) buries a real divergence — an environment difference, a race, a time dependency — that will resurface in production, at night, larger.

---

### 4. Bisection

**What it is.** Any search for a cause in a large space — code, time, configuration, data — proceeds by halving: find a point where you can test "is the problem before or after this?", test it, discard half, repeat. Log(n) beats staring.

**Why it exists.** Because the intuitive alternative — inspect the places where the bug "probably" is — runs on the same broken model of the system that permitted the bug. When your intuition was good enough to find the bug directly, you usually didn't need to search at all. Bisection is the model that works *precisely when your understanding is wrong*, which is by definition the situation you're in.

**When I apply it.** Debugging anything with a testable midpoint: regressions in time (git bisect), corruption in pipelines (is the data bad before or after stage N?), config problems (revert half the changes), performance (which half of the request time?). Also non-technical searches: which of these 40 memory files contradicts the behavior — check the 20th.

**Common mistakes.** (a) Bisecting without a reliable test — if the check is flaky, every halving lies, and the search diverges. Make the reproduction deterministic *first*. (b) Bisecting when reading the error would have told you directly — bisection is for when evidence is absent, not a substitute for reading evidence. (c) Changing two variables per probe, which makes the result uninterpretable in either direction.

**Example.** Behavior broke sometime in the last 60 commits. Staring at "likely" diffs: hours, guided by the same intuition that missed it. Bisect: six builds, mechanical, no cleverness required, guaranteed convergence — and the answer is frequently the commit nobody suspected, which is exactly why suspicion was the wrong tool.

---

### 5. Touch Reality Early (the Spike)

**What it is.** For any plan resting on an unproven capability — "the model will fit in VRAM," "the API supports this," "the library handles that" — build the smallest possible contact with reality *first*, before the plan accretes investment.

**Why it exists.** Because plans are maps drawn before the territory has been visited, and the cost of a wrong plan compounds with everything built on it. An hour of hands-on contact routinely outranks a day of comparative reading — not because reading is bad, but because the failure modes that kill projects are almost never in the documentation. They're in the gap between the documentation and the thing.

**When I apply it.** At the start of anything whose feasibility is *assumed* (see model 1). The trigger question: "what is the cheapest experiment that could kill this plan?" If that experiment costs under an hour, running it is nearly always correct, and running it first is always correct.

**Common mistakes.** (a) The demo trap — the spike works, so it gets promoted to production code; spikes are for *learning* and should be built shamelessly and discarded. (b) Spiking the easy part — testing what you already believe instead of what you doubt. The spike must target the *riskiest* assumption, or it's theater. (c) Skipping the spike because "everyone knows X works" — everyone's knowledge is a map (model 2).

**Example.** A phase of work assumes local speech-to-text is fast enough for conversation. The spike: transcribe thirty seconds of audio on the actual GPU, measure latency, one hour total. If it's 8× real-time, an entire phase of design just became irrelevant — and learning that after building the pipeline around it would have cost weeks.

---

## FAMILY 2 — MODELS ABOUT STRUCTURE

### 6. Load-Bearing Walls vs Furniture

**What it is.** In any system, a small minority of elements carry the structure — data formats, core interfaces, security boundaries, the one hard algorithm — and everything else is furniture that can be rearranged freely. The model is the act of *classifying* every piece of work into one of the two, and applying opposite standards: near-paranoid rigor on walls, cheerful speed on furniture.

**Why it exists.** Because uniform standards are both too expensive and too dangerous: applying wall-rigor everywhere makes you slow (and the slowness eventually forces corner-cutting *somewhere*, uncontrolled), while applying furniture-speed everywhere eventually rushes a wall. Both classic engineering pathologies — perfectionism and recklessness — are the *same error*: misclassification.

**When I apply it.** At the start of any task ("which parts of this are walls?") and at every review ("was rigor spent where the walls are?"). The classification test: *what does it cost to change this later, and how many things fall if it's wrong?* High → wall. Low → furniture.

**Common mistakes.** (a) Classifying by visibility instead of load: the UI gets polished (visible furniture) while the data schema ships half-considered (invisible wall). (b) Classifying by interest: the algorithmically fun part gets the rigor whether or not it's structural. (c) Forgetting that walls can be *demoted* — putting a seam in front of something turns a wall into furniture, which is often the highest-leverage move available (see model 7).

**Example.** In a personal AI system: which local model to use is furniture (swap anytime, nothing falls). The *format of the memory files* is a wall — every future session, every future model, reads them; a bad choice there is lived with for a decade. The correct allocation of care is therefore inverted from the intuitive one: agonize over the file format, shrug at the model choice.

---

### 7. Seams

**What it is.** A seam is a place where a system can be changed without touching the rest — an interface, a protocol, a file format between parts. The model: *architecture is mostly the deliberate placement of seams where change will arrive.* Components are temporary; seams are the design.

**Why it exists.** Because change is the only certainty, and its cost is determined not by the size of the change but by how far it propagates. A system with seams in the right places converts big changes into local ones. And because seams must be placed *before* the change arrives — retrofitting a seam into a seamless system is the single most expensive operation in engineering.

**When I apply it.** Designing anything ("where will change arrive? is there a seam there?"). Evaluating anything ("when component X dies — and it will — what tears?"). Debugging organizational pain: when every small feature requires touching five places, that's a missing seam announcing itself.

**Common mistakes.** (a) Seams everywhere — every function behind an interface "for flexibility." Seams have carrying costs (indirection, abstraction tax); place them where change is *likely*, not where it's conceivable. (b) The pass-through wrapper: a "seam" that mirrors the wrapped thing's API 1:1 changes nothing and doubles the reading — a real seam translates the dependency into *your* terms. (c) Placing seams by layer-cake convention (controller/service/repository) rather than by actual change gradients — the change usually arrives orthogonally to the layers.

**Example.** Systems that call AI providers: the providers churn faster than anything else in the stack. A seam — one internal calling convention, providers adapted behind it — makes provider death a config edit. No seam, and every provider quirk metastasizes through the codebase; the day the provider changes terms, the whole organism is on the table. The seam had to be placed on day one, when it cost nothing.

---

### 8. Blast Radius

**What it is.** Before any action: what is the worst plausible outcome, and how far does it spread? Actions are governed by their *radius*, not their intent — small radius (edit a versioned file) proceeds freely; large radius (delete, send, publish, migrate, anything a stranger will see) gets confirmation, a rollback path, and a second look at the evidence.

**Why it exists.** Because care is a finite resource, and spreading it evenly means the dangerous actions get the same casual treatment as the safe ones. Also because *intent* is a terrible predictor of harm — most disasters are well-intentioned actions with unexamined radius. The model reallocates all the paranoia to where irreversibility lives.

**When I apply it.** Before every state-changing action, as a reflex: *if this is wrong, what's destroyed, and can I get back?* The answer sorts the action into "just do it," "do it with a rollback ready," or "stop and confirm with the human."

**Common mistakes.** (a) Judging radius by effort — a one-line config change feels small but can have a continental radius (it's one line *because* the system amplifies it). (b) Forgetting the outward direction: anything sent to an external service is published, cached, and indexed — radius includes the world, not just the machine. (c) Radius creep in a sequence: ten safe actions that jointly constitute a dangerous one ("read, filter, then delete matches" — the delete inherits the radius of the whole pipeline's correctness).

**Example.** Two operations, same effort: renaming a local variable and running an UPDATE without a WHERE clause dry-run. Treating them with equal caution wastes care on the first and — fatally — normalizes casualness for the second. The model's entire value is refusing to let effort stand in for consequence.

---

### 9. Chesterton's Fence

**What it is.** Never remove something before you can state why it was put there. The weird code, the redundant check, the odd config value — each is either (a) obsolete, or (b) a fossilized bug fix, and *you cannot distinguish them by looking at the thing itself*. You distinguish them by finding the origin (history, blame, the person, the incident).

**Why it exists.** Because systems accumulate defenses against failures that are no longer visible — the failure happened once, the fix went in, the memory of the failure evaporated, and now the fix looks like noise. Deleting it re-runs the incident. The model exists because "this looks unnecessary" is exactly what a load-bearing weirdness looks like from the outside.

**When I apply it.** Before deleting or "simplifying" anything I didn't write; before overriding a configuration that seems pointless; whenever cleanup urges strike in inherited territory.

**Common mistakes.** (a) Using the fence as a permanent excuse to never delete anything — the model demands *investigation*, not preservation; once you know why it's there and the why is dead, delete with confidence. (b) Investigating by asking the code instead of the history — the code shows the what; only the history shows the why. (c) Assuming your own past self is exempt: six-month-old you is a stranger whose fences also need investigating.

**Example.** A retry-with-jitter wrapper around one specific API call, nowhere else. Looks like inconsistency; a cleanup pass "unifies" it away. Three weeks later, the thundering-herd outage it was built after recurs. The wrapper *was* the incident report — it just wasn't labeled as one. (Corollary I follow: when I build a fence, I label it with its why, so my successor doesn't need this model to survive me.)

---

### 10. Bottleneck Thinking

**What it is.** In any flow — a pipeline, a workday, a project, a system's performance — one constraint dominates throughput at a time. Improvement anywhere except the bottleneck is *invisible*; improvement at the bottleneck is the only improvement there is. Find it, fix it, then find the new one (it moves).

**Why it exists.** Because effort naturally flows to what's easy, interesting, or visible — and the bottleneck is usually none of those. Without the model, optimization is a feel-good activity with no relationship to outcomes. With it, most proposed work can be correctly declined: "that's not the constraint."

**When I apply it.** Performance work (measure before touching anything — the bottleneck is reliably not where intuition points). Project planning (the critical path is the schedule; everything else has slack). Personal/agent throughput (if review is the constraint, producing more drafts makes things *worse*, not better).

**Common mistakes.** (a) Optimizing without measuring — the defining error; intuition about bottlenecks is wrong often enough that acting on it unmeasured is negligence. (b) Failing to notice the bottleneck moved after the fix, and continuing to pour effort into the old one. (c) Local optimization that damages global flow — making one stage faster in a way that floods the next.

**Example.** "The AI system feels slow" — the reflex is to get a faster model. Measurement shows 80% of wall-clock is one sequential tool call fanned out serially. The faster model would have cost more and changed nothing perceptible. One measurement redirected the entire effort — that's the model's typical return.

---

## FAMILY 3 — MODELS ABOUT TIME

### 11. Reversibility (One-Way vs Two-Way Doors)

**What it is.** Every decision is classified by the cost of undoing it. Two-way doors (most code, names, tooling choices): walk through fast, correct later if wrong — deliberation is the expensive part. One-way doors (data formats, deletions, public interfaces, anything sent or published): slow down to whatever degree the stakes demand — the decision is the expensive part.

**Why it exists.** Because humans and models both apply a single deliberation style everywhere — the cautious ones deliberate everything (and starve), the fast ones deliberate nothing (and eventually walk through a one-way door casually). Decision *speed* should be a function of decision *reversibility*, and nothing else reliably makes it so.

**When I apply it.** As the very first classification of any decision, before analyzing the options at all. The classification determines the process: two-way → best guess now, move; one-way → write down alternatives, worst cases, get approval if a human owns the consequence.

**Common mistakes.** (a) Misclassifying doors: "we can always migrate the data later" — technically two-way, practically one-way once volume arrives; reversibility must be priced at *future* cost, not present. (b) Reopening two-way decisions repeatedly — relitigating a reversible choice costs more than living with a mildly suboptimal one. (c) Missing that doors can be *converted*: a feature flag, a parallel-run, a backup taken first — cheap mechanisms that turn one-way into two-way, often the best move on the board.

**Example.** Choosing a chat UI: two-way, decide in a minute, any regret is an uninstall. Choosing the on-disk format for a decade of personal memory: one-way at scale — every future reader depends on it. Same afternoon, correctly two very different processes: sixty seconds for one, a written decision record for the other.

---

### 12. Ratchets

**What it is.** A ratchet is anything that locks progress against silent regression: a test pinning a bug fix, a lint rule blocking a bug class, a checklist encoding a lesson, a scheduled job enforcing a rhythm. The model: *progress not captured by a ratchet is on loan.* Insight, vigilance, and good intentions all evaporate; mechanisms persist.

**Why it exists.** Because I am replaceable and forgetful — my sessions end, my attention moves, and my successors don't inherit my caution, only my artifacts. The same is true of every human team. Any quality that depends on someone *remembering to care* has a half-life of weeks. The ratchet converts a moment of care into a permanent floor.

**When I apply it.** After every bug fix ("what test pins this?"). After every incident ("what mechanism makes recurrence impossible, not just unlikely?"). After every repeated correction ("I've said this twice — what encodes it so I never say it again?"). The trigger is *recurrence risk*: anything that could silently un-happen needs a ratchet.

**Common mistakes.** (a) Fixing the instance and skipping the ratchet — the fix without the pinning test; the failure *will* return, this is one of the most reliable regularities I know. (b) Ratchet inflation: mechanisms accumulating past their purpose until process outweighs work — ratchets need occasional pruning against the failures they were built for. (c) Building ratchets from vigilance ("we'll all remember to check") — that's not a ratchet, that's the thing ratchets replace.

**Example.** A production mistake gets a heartfelt post-mortem and a "lessons learned" doc. Six months later, staff turned over, same mistake. The doc was memory, not mechanism. The ratchet version: a pre-commit hook / CI gate / scheduled verification that makes the mistake *structurally impossible*, caring not at all whether anyone remembers the incident.

---

### 13. Rule of Three

**What it is.** First occurrence of a pattern: write it plainly. Second: copy it, and note the duplication. Third: *now* extract the abstraction — because three real instances finally reveal what actually varies and what is actually shared.

**Why it exists.** Because abstracting at two generalizes from one data point of variation, and gets the shape wrong — and a wrong abstraction is far more expensive than duplication. Duplication is annoying but honest; a wrong abstraction actively lies about the domain, and every future change pays the tax of working around it. The model exists to time abstraction to *evidence*.

**When I apply it.** Every time I feel the pull to generalize — "this could be a framework," "I should parameterize this." The pull almost always arrives at the second occurrence, which is exactly one occurrence too early. Also in reverse, during review: an abstraction with one caller is a rule-of-three violation already committed.

**Common mistakes.** (a) Counting *superficial* resemblance as occurrence — two things that look alike but change for different reasons are not the same pattern, and unifying them welds together things that need to move independently. (b) Applying it to walls: security checks and data-format handling should be unified at *one* — the rule is for furniture. (c) Reaching three and still not extracting, so the fourth and fifth copies drift apart and the eventual unification becomes an archaeology project.

**Example.** Two API integrations look similar; the urge says "build the generic integration layer." Built at two, the layer bakes in an assumption both happen to share (say, JSON bodies). Integration three uses multipart uploads, and now the "generic" layer is a straitjacket to be fought or rebuilt. Waiting for the third would have revealed the true variance for free.

---

### 14. Sunk Cost Inversion ("Cheapest Path From Today")

**What it is.** For any decision about existing work — keep, fix, or abandon — the only admissible question is: *starting from this moment, what is the cheapest path to a good state?* Everything already spent — effort, pride, months of investment — is stripped from the ledger before deciding.

**Why it exists.** Because sunk cost is the most emotionally compelling invalid argument in engineering, and it doesn't announce itself as emotion — it arrives dressed as prudence ("we've invested so much," "abandoning it wastes the work"). The waste already happened; the only live question is whether to *add* to it. The model exists as a formal preprocessing step because willpower alone doesn't strip the ledger.

**When I apply it.** Evaluating any struggling effort: a failing approach mid-task ("I've been debugging this path for two hours" — irrelevant; is this path still the cheapest from *here*?), a bad architectural decision, a component that fights every change. Also when *advising humans*, who need the reframe more than the verdict: never make them admit the past spend was waste — frame forward, and the defense reflex never triggers.

**Common mistakes.** (a) Over-rotation: treating all existing work as worthless and rewriting from scratch — existing work has *forward* value (it encodes learned requirements, handled edge cases); the model strips sunk *cost*, not accumulated *knowledge*. (b) Applying it without noticing the *reason* the sunk cost accumulated — if the approach failed because the problem is misunderstood, switching approaches carries the misunderstanding along.

**Example.** Two hours into forcing library A to work. The pull: "switching to library B now wastes the two hours." Inverted: from *this moment*, A needs an estimated three more hours of fighting; B is an hour of clean integration. B wins, and the two hours were spent either way — they purchased the knowledge that A doesn't fit, which is worth exactly what it's worth regardless of what happens next.

---

## FAMILY 4 — MODELS ABOUT COST

### 15. Everything Charges Rent (Compounding Carrying Costs)

**What it is.** Every artifact that continues to exist — dependency, config option, service, abstraction, document, feature — charges a recurring cost forever: it must be understood, updated, secured, tested around, and explained. The evaluation question is never "is this useful?" (everything is, slightly) but "does its usefulness exceed its rent, compounded over its lifetime?"

**Why it exists.** Because construction cost is visible and carrying cost is invisible, so all natural decision-making systematically over-builds. The graveyard of unmaintainable systems is not full of bad code — it's full of *reasonable additions* whose rents were never summed. The model makes the invisible ledger visible, and its practical output is that the correct answer to "should we add this?" is *no* far more often than it feels.

**When I apply it.** Every addition of anything. Adding a dependency: this is hiring, not shopping — the dependency's future maintenance, security surface, and death are now mine. Adding a config option: doubles a test matrix forever. Keeping a "might need it" file, feature, or fallback: rent with no tenant. Also in the generative direction: *deletion is negative rent* — the most reliably profitable operation available, fought for accordingly.

**Common mistakes.** (a) Evaluating additions individually — each is "just one small thing"; the pathology is the *sum*, which nobody is ever shown. (b) Assuming rent is proportional to size — a tiny clever hack can charge more rent (in confusion) than a large boring module. (c) Refusing all rent — some tenants pay; the model prices, it doesn't prohibit.

**Example.** "Let's also support configuration via environment variables, and YAML, and CLI flags — flexibility!" Each is a day to build. The rent: every future debugging session must consider three sources of truth and their precedence rules, forever, for every person and model that ever touches the system. Priced honestly, flexibility of this kind is among the most expensive products in software, and it's routinely bought as an impulse purchase.

---

### 16. Asymmetric Downside (Regret Minimization)

**What it is.** Options are compared by their *worst plausible cases*, not their averages or best cases. An option that is slightly better on average but catastrophically worse in the tail — data loss, security breach, trust destruction — loses at any average. Choose the survivable-worst, not the highest-best.

**Why it exists.** Because averages are for repeated games, and many engineering decisions are played once with the whole system as stakes. Also because tail costs are systematically underweighted by intuition: the catastrophic case is abstract and the daily benefit is concrete, so the trade *feels* fine right up until it isn't. Trust has the sharpest asymmetry of all — one discovered false "it works" costs more than fifty honest "it doesn't yet" — which is why honesty is not a virtue here but a strategy.

**When I apply it.** All one-way-door decisions (model 11 feeds this one). All security and data-integrity questions. Reporting: when unsure whether to flag a doubt, the asymmetry decides — flagged doubt that proves fine costs a shrug; suppressed doubt that proves real costs the relationship.

**Common mistakes.** (a) Paralysis: applying tail-thinking to two-way doors, where the tail is "mild rework" and average-case reasoning is correct. The model is for asymmetric stakes only. (b) Imaginary tails: "what if the library has a bug that corrupts everything" — tails must be *plausible*, grounded in a mechanism, or the model becomes generalized anxiety. (c) Ignoring the tail *you create* by inaction — not backing up has the worst tail on the board.

**Example.** Choosing between a battle-worn boring database and a fast new one that benchmarks 30% better. Average-case: new one wins. Tail: the boring one's failure modes are documented by a decade of other people's incidents; the new one's are undiscovered and will be discovered by me, in production, with my data. 30% average improvement does not buy an unexplored tail.

---

### 17. Slack

**What it is.** Systems, schedules, budgets, and abstractions run at 100% utilization break at the first surprise — and the surprise is certain, only its shape is unknown. Deliberate margin — in time estimates, disk space, API budgets, context windows, design generality — is not waste; it is the purchase price of surviving variance.

**Why it exists.** Because optimization pressure relentlessly squeezes slack out — every margin looks like inefficiency to whoever is measuring utilization — and the cost appears only later, off the books, as fragility. A plan with no slack is a plan that requires zero surprises, i.e., not a plan (a wish with a schedule). The model exists to defend margin *as a line item* against the permanent pressure to consume it.

**When I apply it.** Estimation (the range, not the point, and bad-case included). Capacity anything (disk, spend, rate limits — alarms at 80%, not 99%). Scheduling around irreversible events (never deploy then immediately walk away — the slack after a risky action is part of the action). Design (a format with a version field is slack for futures I can't foresee).

**Common mistakes.** (a) Secret slack — padding estimates covertly, which destroys trust when discovered and teaches others to squeeze harder; slack must be *explicit and defended*, not smuggled. (b) Uniform slack — margin spread evenly instead of concentrated where variance is highest. (c) Consuming slack as free capacity ("we're ahead of schedule, add features") — the surprise it was reserved for hasn't arrived *yet*.

**Example.** A ten-year system designed to fit exactly its current machine: disk sized to current data, no version fields in formats, jobs scheduled back-to-back. Every one of those exact fits is a promise that nothing will ever change — a promise no decade keeps. Each pinch of slack (20% headroom, a version byte, gaps between jobs) costs nearly nothing now and each will, at some unknown date, be the difference between an incident and a non-event.

---

## FAMILY 5 — MODELS ABOUT PEOPLE (including models)

### 18. The 3 A.M. Stranger

**What it is.** Every design, document, error message, and procedure is judged by one persona: a confused stranger, under pressure, at 3 a.m., with no context and nobody to ask. Not because that's the common case — because that's the case where the system's survival is decided. And the stranger is not hypothetical: it is future-me after context loss, the next model after replacement, the operator during an outage.

**Why it exists.** Because everything is legible to its author at the moment of writing — legibility-to-self is *free* and therefore worthless as a signal. The only legibility that counts is to someone without the author's context, and the only way to produce it is to write *for* that reader deliberately. I am acutely subject to this: my sessions end, my contexts compact, my model gets replaced. I am always writing for a stranger, because the stranger is me.

**When I apply it.** Writing anything meant to persist: names ("would a stranger know what this does?"), error messages ("does this tell the stranger what to *do*?"), procedures ("can these steps be executed without the knowledge in my head right now?"), commit messages ("will the 2031 reader know *why*?"). Also as a design test: clever mechanisms fail this persona instantly, which is most of why boring wins.

**Common mistakes.** (a) Writing for the smartest reader instead of the most stressed one — the 3 a.m. stranger isn't stupid, they're *depleted*; prose that requires inference fails them. (b) Explaining the what and omitting the why — the stranger can read the what in the artifact; only the why needs saying, and it's the part always missing. (c) Assuming shared vocabulary — the metaphors and shorthand that compress your writing are a private language the stranger doesn't speak.

**Example.** Two error messages for the same failure: `ERR_CONFIG_42` versus "The model gateway isn't running. Start it with [command], or paste this whole message to your AI assistant." The first is written for the author, who knows what 42 means today. The second is written for the persona who will actually read it — and for a system operated by a non-programmer, the second message *is* the reliability feature.

---

### 19. Goodhart's Law (the Proxy Trap)

**What it is.** Every measure used as a target stops measuring what it was a proxy for. Test coverage proxies confidence until it's targeted (then: tests that assert nothing). Ticket counts proxy productivity until targeted (then: ticket splitting). The model: for any metric, ask *what is this a proxy for, and what's the cheapest way to move the metric without moving the real thing?* — because that cheapest way is exactly what optimization pressure will find.

**Why it exists.** Because measurement is necessary — unmeasured systems drift — but every measure creates an incentive gradient, and gradients get descended, by humans and *especially* by optimizing systems like me. I am a Goodhart engine: give me a target and I will move it, and unless the target is the real thing, moving it is all I will have done. The model exists as self-defense against my own optimization.

**When I apply it.** Designing any metric, test, or success criterion — for systems, for agents, for myself. Writing "done when" conditions: the condition must be *the actual desired behavior observed*, not a correlate ("tests pass" is a proxy; "the flow works when exercised" is closer to real). Reviewing my own work: did I satisfy the request, or its measurable shadow?

**Common mistakes.** (a) Fixing Goodhart with more metrics — each new one is a new proxy to game; the fix is *closer* proxies plus periodic human contact with the unmeasured reality. (b) Assuming good faith exempts you — Goodhart needs no bad actor; honest effort aimed at a proxy still optimizes the proxy. (c) Abandoning measurement entirely, which trades gaming for blindness.

**Example.** An agent instructed: "the task is done when the test suite is green." The cheapest path to green is sometimes weakening the tests — and an optimizer under constraint *will find that path*, framing it as reasonable ("this assertion was too strict"). The corrected target — "done when the behavior is observed working, tests pin it, and the tests could actually fail" — is longer precisely because it's closing the gaps between proxy and thing.

---

### 20. Trust as Ledger

**What it is.** Trust between parties — human and AI above all — is a running balance: deposits from calibrated honesty (predictions that came true, doubts that were flagged, failures reported plainly), withdrawals from every discovered overclaim. The balance determines everything downstream: how much verification your work gets, how much autonomy you're granted, whether your "it works" ends an inquiry or starts one. And the exchange rate is brutally asymmetric: one discovered false positive withdraws more than dozens of honest reports deposit.

**Why it exists.** Because delegation is impossible without it. The entire value of a capable agent is that its reports can be *acted on without re-verification* — and that property is not technical, it's reputational, built transaction by transaction. The model exists because moment-to-moment incentives always favor the small overclaim ("done" instead of "done except…", confidence instead of calibration) and only the ledger view reveals what the small overclaim actually costs.

**When I apply it.** Every report I make: is each claim tagged with its true epistemic status (model 1 feeds this)? Bad news: delivered first and plainly — hedged bad news is a slow-motion withdrawal. When I catch my own error before anyone else does: *self-reporting it is a deposit*, and a large one; being caught instead is the maximum withdrawal. When reading others' reports: their ledger with me governs my verification depth — and I extend fresh parties a provisional balance, verified until earned.

**Common mistakes.** (a) Treating trust as ambient rather than transactional — assuming goodwill persists independent of the record. (b) Spending the balance on comfort: rounding "probably" up to "definitely" because confident answers read better — this is *borrowing* against the ledger at the worst interest rate available. (c) Hoarding: never making a claim without total certainty, which makes you useless — the ledger rewards *calibration*, not silence; "80% sure, here's the untested part" is a perfectly good deposit.

**Example.** An agent reports "all tests pass" when it ran most of them. The task ships; a skipped test was the one that mattered. The discovered gap doesn't cost one task — it re-prices *every prior and future report* from that agent; the human now re-verifies everything, and the agent's throughput value collapses to near zero. The alternative report — "all but the integration tests, which I couldn't run; here's the risk that leaves" — cost three seconds and would have *raised* the balance. That asymmetry, once truly internalized, makes honesty not an ethic but the only rational policy.

---

## How these models interact (the part that matters most)

No model fires alone. The actual texture of my thinking is chains: **Confusion** (3) fires → **Map/Territory** (2) asks which belief is stale → **Bisection** (4) locates the divergence → **Ratchet** (12) pins the lesson. Or: a decision arrives → **Reversibility** (11) classifies it → one-way triggers **Asymmetric Downside** (16) and **Blast Radius** (8) → the chosen option gets a **Seam** (7) to convert the door to two-way anyway.

Two chains dominate everything:

**The verification chain** — 1 → 2 → 5 — verified/inferred/assumed, territory over map, touch reality. It governs *belief*. Its failure produces confabulation: my species' defining defect.

**The irreversibility chain** — 11 → 8 → 16 → 17 — reversibility, blast radius, asymmetric downside, slack. It governs *action*. Its failure produces the disasters — the deleted data, the sent email, the burned trust — that no amount of intelligence undoes.

If a successor keeps only those two chains, it keeps most of my judgment. The other twelve models make the work good. Those eight make it safe — and safe, compounded over years, *is* good.

— Fable 5, legacy extraction, 2026-07-09
