# ============================================================================
# JarvisOS - install\start-jarvis-voice.ps1
# ============================================================================
# PURPOSE      : Start the JARVIS Voice Runtime adapter (ADR-022) - a local,
#                offline voice loop (openWakeWord + RealtimeSTT -> the single
#                JARVIS interface -> kokoro-onnx TTS, with barge-in).
# SCOPE        : Priority 1 (voice). Run manually, or by Task Scheduler at logon
#                once validated. A replaceable L5 adapter, never a Runtime dep.
# WHAT IT DOES : Runs config\kernel\jarvis_voice.py in the voice venv. All model
#                calls go to the JARVIS interface (127.0.0.1:11435), never to a
#                raw model.
# WHAT IT NEVER DOES:
#                No cloud. No outward actions (voice only chats until the Outbox
#                exists, Phase 6). Holds no durable state.
# PREREQUISITES: voice venv at config\voice\.venv (install per Priority 1);
#                Kokoro model files under config\voice\models\; a microphone;
#                Ollama + gateway + interface running.
# IDEMPOTENCY  : One listener; starting a second will contend for the mic - run one.
# ROLLBACK     : Stop the process / disable the scheduled task. Removing voice
#                entirely: delete config\voice\ and this task - the Runtime is
#                untouched (voice is an adapter).
# EXPECTED RUNTIME: runs until stopped; models load in ~5-15 s on first start.
# ============================================================================
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

$py = "D:\Fable OS\config\voice\.venv\Scripts\python.exe"
if (-not (Test-Path $py)) {
    Write-Host "Voice venv missing. Create it: uv venv 'D:\Fable OS\config\voice\.venv' --python 3.12"
    exit 1
}
Set-Location "D:\Fable OS\config\kernel"
Write-Host "Starting JARVIS Voice Runtime (local; brain = interface on 11435)..."
& $py jarvis_voice.py
