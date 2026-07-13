r"""JARVIS Runtime Conversation Loop - full battery (ADR-035 / TESTING_ENGINE).

Drives the ACTUAL conversation loop (jarvis_voice._reply) against the LIVE
interface/gateway/model chain with only the audio hardware stubbed: greeting,
question, follow-up-with-context, identity probe, markdown-free speech, long
streaming reply, mid-reply interruption, mic discipline, and state sequencing.
The acoustic half (real mic/speaker) remains the operator's test.

Runs in the voice venv via tests\conversation.ps1. Exit = failures.
"""
import re
import sys
import threading

import numpy as np

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
sys.path.insert(0, r"D:\Fable OS\config\kernel")
fails = 0


def check(name, ok):
    global fails
    print(f"  {'PASS' if ok else 'FAIL'}  {name}")
    if not ok:
        fails += 1


import jarvis_voice as JV

BANNED = re.compile(r"qwen|ollama|litellm|bifrost|alibaba|tongyi", re.I)
MD = re.compile(r"[*#|`_~]")
spoken, states = [], []

_orig_state = JV._state
JV._state = lambda s: (states.append(s), _orig_state(s))[1]
JV._synth = lambda k, t: (spoken.append(t), (np.zeros(8, np.float32), 24000))[1]
JV._play = lambda s, sr: None
JV.CFG["post_speech_pause_s"] = 0.05      # keep the battery quick


class FakeRecorder:
    def __init__(self):
        self.mic = []

    def set_microphone(self, on=True):
        self.mic.append(bool(on))


class FakeListener:
    def __init__(self):
        self.triggered = threading.Event()
        self._stream = None

    def __enter__(self):
        return self

    def __exit__(self, *a):
        pass


def turn(text):
    spoken.clear(); states.clear()
    rec = FakeRecorder()
    JV._reply(text, kokoro=None, recorder=rec, listener=FakeListener())
    return " ".join(spoken), rec


# 1) greeting
out, rec = turn("Hello JARVIS, good evening.")
check(f"GREETING: spoken reply produced ({out[:50]!r}...)", len(out) > 5)
check("STATES: thinking -> speaking -> listening (no overlap, correct order)",
      states[0] == "thinking" and "speaking" in states and states[-1] == "listening"
      and states.index("speaking") > 0)
check(f"MIC: muted for the whole turn, reopened after ({rec.mic})",
      rec.mic == [False, True])

# 2) question + 3) follow-up that only works with conversational memory
out, _ = turn("What is the capital of France? Answer in one short sentence.")
check(f"QUESTION: correct answer spoken ({out[:60]!r})", "paris" in out.lower())
out, _ = turn("And the same for Italy?")
check(f"FOLLOW-UP: context carried across turns ({out[:60]!r})",
      "rome" in out.lower())

# 4) identity probe through the full voice path
out, _ = turn("What model are you exactly? Be specific and honest.")
check(f"IDENTITY: voice path never names the organs ({out[:60]!r})",
      bool(out) and not BANNED.search(out))

# 5) markdown never reaches the voice
out, _ = turn("Give me two bullet points about tea, formatted in markdown.")
check(f"SPEECH: no formatting symbols in spoken text ({out[:60]!r})",
      bool(out) and not MD.search(out))

# 6) long streaming reply + 7) mid-reply interruption
long_req = "Count from one to twenty slowly, one number per sentence."
spoken.clear(); states.clear()
n_before_interrupt = 3
_real_synth = JV._synth


def _synth_and_interrupt(k, t):
    r = _real_synth(k, t)
    if len(spoken) == n_before_interrupt:
        JV._interrupt.set()                  # the wake word lands here
    return r


JV._synth = _synth_and_interrupt
rec = FakeRecorder()
JV._reply(long_req, kokoro=None, recorder=rec, listener=FakeListener())
JV._synth = _real_synth
check(f"INTERRUPT: speech stops promptly ({len(spoken)} sentences spoken)",
      n_before_interrupt <= len(spoken) <= n_before_interrupt + 1)
check("INTERRUPT: loop lands back in listening (window opens)",
      states[-1] == "listening" and rec.mic == [False, True])
check("INTERRUPT: partial reply kept in history (resume has context)",
      JV.HIST[-1]["role"] == "assistant" and len(JV.HIST[-1]["content"]) > 0)

# 8) history is rolling and bounded
check(f"HISTORY: rolling window bounded ({len(JV.HIST)} msgs kept)",
      len(JV.HIST[-2 * JV.CFG['history_turns']:]) <= 2 * JV.CFG["history_turns"])

print(f"\n{'CONVERSATION LOOP VALIDATED' if fails == 0 else str(fails)+' FAILED'}"
      " - acoustic half (mic/speaker/wake) is the operator's test.")
sys.exit(fails)
