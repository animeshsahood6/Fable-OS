r"""JARVIS Glass Overlay - headless self-test (ADR-031 / TESTING_ENGINE).

Validates every overlay component that does NOT require the operator's eyes:
config contract, adapter import, glass window creation (frameless/topmost/
alpha), global-hotkey registration, and the streaming glue to the single
JARVIS interface. The visual check (summon it, read a reply on screen) is the
operator's - not covered here.

Run via tests\overlay.ps1 (uses the overlay venv). Exit code = number of failures.
"""
import sys
import queue

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
sys.path.insert(0, r"D:\Fable OS\config\kernel")
fails = 0


def check(name, ok):
    global fails
    print(f"  {'PASS' if ok else 'FAIL'}  {name}")
    if not ok:
        fails += 1


# 1) config contract + Convention 5 canary (the overlay may only know the interface)
import yaml
CFG = yaml.safe_load(open(r"D:\Fable OS\config\overlay.yaml", encoding="utf-8"))
need = ["hotkey", "width", "height", "corner", "theme", "interface_url", "health_url"]
check("CONFIG: overlay.yaml parses with required keys", all(k in CFG for k in need))
check("CONFIG: brain is the single JARVIS interface (127.0.0.1:11435, Convention 5)",
      CFG["interface_url"].startswith("http://127.0.0.1:11435/")
      and CFG["health_url"].startswith("http://127.0.0.1:11435/"))

# 2) adapter imports (glue compiles; yaml/tkinter/ctypes all resolve)
try:
    import jarvis_overlay as J
    check("IMPORT: jarvis_overlay imports in the overlay venv", True)
except Exception as e:
    check(f"IMPORT: jarvis_overlay imports ({e})", False)
    print(f"\n{fails} FAILED - cannot continue without the adapter.")
    sys.exit(fails)

# 3) the glass: frameless + topmost + alpha window creates and destroys
try:
    import tkinter as tk
    r = tk.Tk()
    r.overrideredirect(True)
    r.attributes("-topmost", True)
    r.attributes("-alpha", CFG.get("opacity", 0.9))
    r.update_idletasks()
    ok = r.attributes("-alpha") < 1.0 and bool(r.attributes("-topmost"))
    r.destroy()
    check("GLASS: translucent topmost frameless window creates/destroys", ok)
except Exception as e:
    check(f"GLASS: window creation ({e})", False)

# 4) hotkey: the configured combo registers (then releases) - proves availability
try:
    import ctypes
    u32 = ctypes.windll.user32
    parts = CFG["hotkey"].lower().split("+")
    mods = sum(J.MODS[p] for p in parts[:-1])
    got = u32.RegisterHotKey(None, 42, mods | J.MOD_NOREPEAT, ord(parts[-1].upper()))
    if got:
        u32.UnregisterHotKey(None, 42)
        check(f"HOTKEY: '{CFG['hotkey']}' registers", True)
    else:  # held by the live overlay is the healthy production state, not a failure
        import subprocess
        cmds = subprocess.run(
            ["powershell", "-NoProfile", "-Command",
             "Get-CimInstance Win32_Process -Filter \"Name='pythonw.exe'\""
             " | ForEach-Object {$_.CommandLine}"],
            capture_output=True, text=True, timeout=20).stdout
        check(f"HOTKEY: '{CFG['hotkey']}' held by the RUNNING overlay",
              "jarvis_overlay" in cmds)
except Exception as e:
    check(f"HOTKEY: registration ({e})", False)

# 5) interface glue: _stream_reply streams a real reply through the Runtime
deltas, done = [], None
try:
    J._stream_reply([{"role": "user", "content": "Reply with the single word: online"}])
    while True:
        kind, val = J.Q.get_nowait()
        if kind == "delta":
            deltas.append(val)
        elif kind == "done":
            done = val
        elif kind == "sys":
            print(f"        (sys: {val})")
        if kind == "done":
            break
except queue.Empty:
    done = None
except Exception as e:
    print(f"        (stream error: {e})")
    done = None
check(f"INTERFACE: streamed reply via 11435 is non-empty (deltas={len(deltas)})",
      bool(done and done.strip()))

print(f"\n{'OVERLAY HEADLESS VALIDATED' if fails == 0 else str(fails)+' FAILED'}"
      " - the on-screen summon/read check is the operator's.")
sys.exit(fails)
