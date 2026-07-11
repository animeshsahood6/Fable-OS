# ============================================================================
# JarvisOS - install\start-jarvis-gateway.ps1
# ============================================================================
# PURPOSE      : Start the L2 model gateway (LiteLLM proxy, ADR-030) - one
#                OpenAI-compatible endpoint at 127.0.0.1:4000/v1 routing to the
#                local Ollama, with reasoning_effort->Ollama `think` mapping.
# SCOPE        : Phase 2. Run by Task Scheduler at logon (after cutover), or manually.
# WHAT IT DOES : Loads the master key from the Law 9 store; binds 127.0.0.1
#                ONLY (ADR-017); serves the pinned config.
# WHAT IT NEVER DOES:
#                Never binds beyond loopback. Never writes secrets to the repo.
# PREREQUISITES: uv tool install "litellm[proxy]==1.91.1" (pinned, ADR-017);
#                Ollama running; LITELLM_MASTER_KEY in config\secrets.env.
# IDEMPOTENCY  : If 4000 already answers, exits 0.
# ROLLBACK     : Stop the process / disable the scheduled task; the router
#                falls back to the direct-Ollama path until re-pointed.
# EXPECTED RUNTIME: starts in ~5-15 s; runs until logoff/stop.
# ============================================================================
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

# Windows console is cp1252; LiteLLM prints a Unicode startup banner. Force
# UTF-8 Python I/O so it doesn't crash on encode (PS 5.1 default-ANSI trap).
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

# Law 9: load NAME=value secrets (provides LITELLM_MASTER_KEY)
$secrets = "D:\Fable OS\config\secrets.env"
if (Test-Path $secrets) {
    foreach ($ln in Get-Content $secrets) {
        $t = $ln.Trim()
        if ($t -and -not $t.StartsWith("#") -and $t.Contains("=")) {
            $i = $t.IndexOf("="); $name = $t.Substring(0,$i).Trim(); $val = $t.Substring($i+1)
            if ($name -and $val) { Set-Item -Path "Env:$name" -Value $val }
        }
    }
}

try {
    $up = Invoke-WebRequest -Uri "http://127.0.0.1:4000/health/liveliness" -UseBasicParsing -TimeoutSec 3
    if ($up.StatusCode -eq 200) { Write-Host "JARVIS gateway already running."; exit 0 }
} catch { }

$exe = Join-Path $env:USERPROFILE ".local\bin\litellm.exe"
if (-not (Test-Path $exe)) { $exe = "litellm" }
Write-Host "Starting JARVIS gateway (LiteLLM, 127.0.0.1:4000, loopback only)..."
& $exe --config "D:\Fable OS\config\gateway\litellm.yaml" --host 127.0.0.1 --port 4000
