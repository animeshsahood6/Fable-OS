# ============================================================================
# JarvisOS - install\start-jarvis-ui.ps1
# ============================================================================
# PURPOSE      : Start the current UI ADAPTER (Open WebUI) for the JARVIS
#                Runtime. Convention 5: this is a replaceable shell, NOT the
#                Runtime. The Runtime (seam + router + Ollama) never knows
#                which UI is connected; swapping UIs = replacing this script.
# SCOPE        : Phase 1 Task 4. Run by Task Scheduler at logon, or manually.
# WHAT IT DOES : Binds Open WebUI to 127.0.0.1:8080 ONLY (tailnet reachability
#                is provided by 'tailscale serve', never by a wider bind),
#                points it at the local Ollama, disables every cloud path,
#                and applies JARVIS branding where upstream permits.
# WHAT IT NEVER DOES:
#                Never binds beyond loopback. Never enables signup (except
#                -FirstRun, once, to create the admin). Never talks to any
#                cloud provider. Holds no canonical state - its data dir is
#                adapter cache under data\ui-adapter\ (ADR-021 spirit).
# PREREQUISITES: uv tool install open-webui (Phase 1 T4); Ollama running.
# IDEMPOTENCY  : Safe to re-run; if the port is already listening, it exits.
# ROLLBACK     : Stop the process / disable the scheduled task. Removing the
#                adapter entirely: uv tool uninstall open-webui, delete
#                data\ui-adapter\ - the Runtime is untouched (Convention 5).
# EXPECTED RUNTIME: starts in ~10-20 s; runs until logoff/stop.
# ============================================================================
param(
    [switch]$FirstRun   # enables signup ONCE so the operator can create admin
)

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

# --- Load secrets (Law 9): NAME=value lines from the git-ignored store. -------
# Provides WEBUI_SECRET_KEY so the adapter never writes a key to its cwd.
$secrets = "D:\Fable OS\config\secrets.env"
if (Test-Path $secrets) {
    foreach ($ln in Get-Content $secrets) {
        $t = $ln.Trim()
        if ($t -and -not $t.StartsWith("#") -and $t.Contains("=")) {
            $i = $t.IndexOf("=")               # split on FIRST '=' only
            $name = $t.Substring(0, $i).Trim()
            $val  = $t.Substring($i + 1)
            if ($name -and $val) { Set-Item -Path "Env:$name" -Value $val }
        }
    }
}

# Already up? (idempotent start for the logon task)
try {
    $up = Invoke-WebRequest -Uri "http://127.0.0.1:8080/health" -UseBasicParsing -TimeoutSec 3
    if ($up.StatusCode -eq 200) { Write-Host "JARVIS UI already running."; exit 0 }
} catch { }

# --- UI adapter configuration (environment; no upstream source modified) ----
# Convention 5: the UI consumes the Runtime's ONE interface (jarvis_interface,
# 127.0.0.1:11435) which exposes a single model "JARVIS". The raw Ollama models
# are hidden so the operator never sees a model list.
$env:DATA_DIR            = "D:\Fable OS\data\ui-adapter\open-webui"  # adapter cache tier
$env:WEBUI_NAME          = "JARVIS"                 # branding where upstream permits
$env:ENABLE_PERSISTENT_CONFIG = "false"             # env/files are authoritative each boot, not a DB
$env:ENABLE_OLLAMA_API   = "false"                  # HIDE raw local models from the UI
$env:ENABLE_OPENAI_API   = "true"                   # the one interface is OpenAI-compatible...
$env:OPENAI_API_BASE_URL = "http://127.0.0.1:11435/v1"  # ...and entirely local (no Internet)
$env:OPENAI_API_KEY      = "jarvis-local"           # dummy; the local shim ignores it
$env:OFFLINE_MODE        = "true"                   # no update checks / phone-home
$env:ENABLE_SIGNUP       = if ($FirstRun) { "true" } else { "false" }
$env:DEFAULT_USER_ROLE   = "pending"                # anyone who slips past waits for admin
$env:ENABLE_COMMUNITY_SHARING = "false"
$env:ENABLE_MESSAGE_RATING    = "false"
$env:ENABLE_EVALUATION_ARENA_MODELS = "false"  # hide the built-in "Arena Model" so ONLY JARVIS shows
$env:WEBUI_AUTH          = "true"

New-Item -ItemType Directory -Force -Path $env:DATA_DIR | Out-Null

# Run from the adapter's data dir so any file the adapter drops in cwd
# (e.g. .webui_secret_key when WEBUI_SECRET_KEY is unset) lands in the
# git-ignored data tree, never in the repo root (Law 9 defense-in-depth).
Set-Location $env:DATA_DIR

$exe = Join-Path $env:USERPROFILE ".local\bin\open-webui.exe"
if (-not (Test-Path $exe)) { $exe = "open-webui" }   # fall back to PATH

Write-Host "Starting JARVIS UI adapter (loopback only; tailnet via tailscale serve)..."
& $exe serve --host 127.0.0.1 --port 8080
