# ============================================================================
# JarvisOS - install\start-jarvis-interface.ps1
# ============================================================================
# PURPOSE      : Start the JARVIS Runtime's single UI-facing interface - the
#                OpenAI-compatible shim (config\kernel\jarvis_interface.py) that
#                exposes exactly one model, "JARVIS", to any UI (Convention 5).
# SCOPE        : Phase 1 Task 5. Run by Task Scheduler at logon, or manually.
# WHAT IT DOES : Serves 127.0.0.1:11435; classifies + routes each turn through
#                the local capability registry; the UI never sees raw models.
# WHAT IT NEVER DOES:
#                Never binds beyond loopback. No cloud. Holds no state.
# PREREQUISITES: uv; pyyaml (fetched by uv --with); Ollama running.
# IDEMPOTENCY  : If 11435 already answers, exits 0.
# ROLLBACK     : Stop the process / disable the scheduled task.
# EXPECTED RUNTIME: starts in ~2 s; runs until logoff/stop.
# ============================================================================
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

try {
    $up = Invoke-WebRequest -Uri "http://127.0.0.1:11435/health" -UseBasicParsing -TimeoutSec 3
    if ($up.StatusCode -eq 200) { Write-Host "JARVIS interface already running."; exit 0 }
} catch { }

Set-Location "D:\Fable OS\config\kernel"
Write-Host "Starting JARVIS interface (single model; loopback only)..."
uv run --with pyyaml python jarvis_interface.py
