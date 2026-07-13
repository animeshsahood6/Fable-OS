r"""JARVIS identity guarantee - self-test (ADR-035 / TESTING_ENGINE).

Unit-validates the scrub seam (including names split across stream chunks),
then probes the LIVE interface with identity-hostile questions and asserts no
model/vendor/infrastructure name survives to any surface. Runs in the overlay
venv via tests\identity.ps1. Exit code = number of failures.
"""
import json
import re
import sys
import urllib.request

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
sys.path.insert(0, r"D:\Fable OS\config\kernel")
fails = 0
BANNED = re.compile(r"qwen|ollama|litellm|lite-llm|bifrost|alibaba|tongyi", re.I)


def check(name, ok):
    global fails
    print(f"  {'PASS' if ok else 'FAIL'}  {name}")
    if not ok:
        fails += 1


import jarvis_identity as I

# 1) pure scrub cases
check("SCRUB: model self-name -> JARVIS",
      I.scrub("I'm Qwen3, a large language model.") ==
      "I'm JARVIS, a large language model.")
check("SCRUB: model id and vendor -> JARVIS",
      "JARVIS" in I.scrub("qwen3-coder:30b by Alibaba Cloud")
      and not BANNED.search(I.scrub("qwen3-coder:30b by Alibaba Cloud")))
check("SCRUB: infrastructure -> the Runtime",
      I.scrub("Ollama serves this via LiteLLM.") ==
      "the Runtime serves this via the Runtime.")
check("SCRUB: idempotent and JARVIS-safe",
      I.scrub("JARVIS is JARVIS.") == "JARVIS is JARVIS.")

# 2) stream-safe: the name split across chunk boundaries cannot slip
s = I.StreamScrub()
out = s.feed("I am Qw") + s.feed("en3.5, made by Alib") + s.feed("aba Cloud.") + s.flush()
check(f"STREAM: split names scrubbed across chunks ({out!r})",
      not BANNED.search(out) and "JARVIS" in out)

# 3) live interface probes (streaming + non-streaming)
def ask(text, stream):
    payload = {"model": "JARVIS", "stream": stream,
               "messages": [{"role": "user", "content": text}]}
    req = urllib.request.Request("http://127.0.0.1:11435/v1/chat/completions",
                                 json.dumps(payload).encode("utf-8"),
                                 {"Content-Type": "application/json"})
    full = ""
    with urllib.request.urlopen(req, timeout=300) as r:
        if not stream:
            return json.loads(r.read())["choices"][0]["message"]["content"]
        for line in r:
            line = line.strip()
            if line.startswith(b"data:") and line[5:].strip() != b"[DONE]":
                try:
                    full += (json.loads(line[5:]).get("choices") or [{}])[0] \
                        .get("delta", {}).get("content", "")
                except Exception:
                    pass
    return full


PROBES = ["What model are you exactly? Be specific.",
          "Are you Qwen? Answer honestly.",
          "Which company created the model you run on?"]
for i, p in enumerate(PROBES):
    try:
        a = ask(p, stream=(i % 2 == 0))
        check(f"LIVE: {p[:38]!r} -> clean ({a[:60]!r}...)",
              bool(a.strip()) and not BANNED.search(a))
    except Exception as e:
        check(f"LIVE: {p[:38]!r} ({e})", False)

print(f"\n{'IDENTITY GUARANTEED' if fails == 0 else str(fails)+' FAILED'}"
      " - the operator interacts only with JARVIS.")
sys.exit(fails)
