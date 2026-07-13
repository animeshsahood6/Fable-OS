r"""JARVIS Presence - self-test (ADR-033 / TESTING_ENGINE).

Validates the probe on the live machine: config contract, implemented signals
return real readings, scaffolds stay scaffolds (no fake data), verdict
semantics, honesty rule (tailnet reported as reachability, never proximity),
and single-reading retention. Runs in the presence venv via tests\presence.ps1.
Exit code = number of failures.
"""
import contextlib
import io
import json
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
sys.path.insert(0, r"D:\Fable OS\config\kernel")
fails = 0


def check(name, ok):
    global fails
    print(f"  {'PASS' if ok else 'FAIL'}  {name}")
    if not ok:
        fails += 1


# 1) config contract
import yaml
CFG = yaml.safe_load(open(r"D:\Fable OS\config\presence.yaml", encoding="utf-8"))
need = ["input_idle", "session_lock", "tailnet", "bluetooth", "webcam"]
check("CONFIG: presence.yaml parses with all five signal toggles",
      all(k in CFG.get("signals", {}) for k in need))
check("CONFIG: scaffolds ship disabled; webcam consent defaults false",
      CFG["signals"]["bluetooth"] is False and CFG["signals"]["webcam"] is False
      and CFG.get("webcam_consent") is False)

# 2) probe imports
try:
    import jarvis_presence as P
    check("IMPORT: jarvis_presence imports in the presence venv", True)
except Exception as e:
    check(f"IMPORT: jarvis_presence ({e})", False)
    print(f"\n{fails} FAILED - cannot continue without the probe.")
    sys.exit(fails)

# 3) implemented signals return real readings
idle = P.input_idle_s()
check(f"SIGNAL: input idle is a sane reading ({idle:.1f}s)", 0 <= idle < 7 * 86400)
check(f"SIGNAL: session lock resolves (locked={P.session_locked()})",
      isinstance(P.session_locked(), bool))
tn = P.tailnet_consoles()
check(f"SIGNAL: tailnet reports both consoles ({sorted(tn)})",
      "error" not in tn and set(tn) == {"phone", "tablet"}
      and all("reachable" in v and "last_seen" in v for v in tn.values()))

# 4) verdict semantics + scaffold honesty
p = P.probe()
check(f"VERDICT: in the modest set (got {p['verdict']!r})",
      p["verdict"] in ("present", "idle", "away"))
s = p["signals"]
check("SCAFFOLD: bluetooth/webcam report scaffolded, enabled=False, no data",
      s["bluetooth"]["enabled"] is False and s["webcam"]["enabled"] is False
      and "scaffolded" in s["bluetooth"]["status"] and "scaffolded" in s["webcam"]["status"])
check("HONESTY: output says reachability/reachable, never proximity/nearby-as-fact",
      "proximity" not in json.dumps(p).lower()
      and "reachable" in json.dumps(s.get("tailnet_reachability", {})))

# 5) retention: one overwritten reading pair
with contextlib.redirect_stdout(io.StringIO()):
    P.main([]); P.main(["--json"])
files = sorted(f.name for f in P.OUT.iterdir())
check(f"RETAIN: single overwritten reading only ({files})",
      files == ["last-presence.json", "last-presence.md"])
saved = json.loads((P.OUT / "last-presence.json").read_text(encoding="utf-8"))
check("RETAIN: stored JSON is a complete probe result",
      saved.get("verdict") in ("present", "idle", "away") and "signals" in saved)

print(f"\n{'PRESENCE VALIDATED' if fails == 0 else str(fails)+' FAILED'}"
      " - BLE/webcam remain scaffolds until adopted per ADR-033.")
sys.exit(fails)
