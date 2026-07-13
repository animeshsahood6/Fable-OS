# ============================================================================
# JarvisOS - install\start-jarvis-overlay.ps1
# ============================================================================
# PURPOSE      : Start the JARVIS Glass Overlay adapter (ADR-031) - a translucent,
#                always-on-top, hotkey-summonable desktop HUD (default Ctrl+Alt+J)
#                that chats with JARVIS via the single interface.
# SCOPE        : Priority 2 (glass overlay). Run manually, or by Task Scheduler at
#                logon once validated. A replaceable L5 adapter, never a Runtime dep.
# WHAT IT DOES : Runs config\kernel\jarvis_overlay.py in the overlay venv
#                (windowless via pythonw; -Console for a debug console). All model
#                calls go to the JARVIS interface (127.0.0.1:11435), never to a
#                raw model. Reads config\overlay.yaml for every knob.
# WHAT IT NEVER DOES:
#                No cloud. No listening socket. No outward actions (renders text
#                only; the Outbox is Phase 6). Holds no durable state.
# PREREQUISITES: overlay venv at config\overlay\.venv (uv venv + pyyaml);
#                interface running (logon task 'JARVIS Interface').
# IDEMPOTENCY  : One overlay; a second instance fails its hotkey registration and
#                shows the notice in-window - run one.
# ROLLBACK     : Close the window / stop pythonw / disable the scheduled task.
#                Removing entirely: delete config\overlay\, overlay.yaml, the
#                adapter script and this task - the Runtime is untouched.
# EXPECTED RUNTIME: runs until dismissed; window appears in ~1-2 s.
# ============================================================================
param([switch]$Console)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

$venv = "D:\Fable OS\config\overlay\.venv\Scripts"
if (-not (Test-Path "$venv\python.exe")) {
    Write-Host "Overlay venv missing. Create it: uv venv 'D:\Fable OS\config\overlay\.venv' --python 3.12; uv pip install --python '$venv\python.exe' pyyaml"
    exit 1
}
Set-Location "D:\Fable OS\config\kernel"
if ($Console) {
    Write-Host "Starting JARVIS Glass Overlay (console mode; brain = interface on 11435)..."
    & "$venv\python.exe" jarvis_overlay.py
} else {
    & "$venv\pythonw.exe" jarvis_overlay.py   # GUI subsystem: returns immediately
    Write-Host "JARVIS Glass Overlay launched (windowless). Summon/dismiss: hotkey in config\overlay.yaml."
}
