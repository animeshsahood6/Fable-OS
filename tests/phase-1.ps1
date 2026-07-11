# ============================================================================
# JarvisOS - tests\phase-1.ps1
# ============================================================================
# PURPOSE      : Executable "done when" for Phase 1 (Mind), local-only path
#                (Task 3B). Proves: local models present; the single JARVIS
#                interface exposes one model and routes by capability; the UI
#                consumes only that interface; every active route is offline
#                (loopback); the watchdog reports health; auto-start tasks exist.
# SCOPE        : Read-only checks + throwaway interface calls. No writes under
#                the repo except the watchdog's own status file (data\, ignored).
# PREREQUISITES: Phase 1 T1-T5 done; Ollama + interface + UI running.
# IDEMPOTENCY  : Fully re-runnable.
# EXIT CODE    : number of FAILED checks (0 = Phase 1 validated).
# ============================================================================
param([string]$Root = "D:\Fable OS")
$ErrorActionPreference = "Continue"
$fails = 0
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

function Check($name, [bool]$ok, $fix="") {
    if ($ok) { Write-Host "  PASS  $name" -ForegroundColor Green }
    else { Write-Host "  FAIL  $name" -ForegroundColor Red; if($fix){Write-Host "        fix: $fix" -ForegroundColor Yellow}; $script:fails++ }
}

Write-Host "Phase 1 validation (root: $Root)" -ForegroundColor Cyan

# --- 1. Local minds present (no cloud, no keys) ---
Write-Host "`n[1] Local models" -ForegroundColor Cyan
$models = (& ollama list) 2>$null | Out-String
foreach ($m in @("qwen3.5:9b","qwen3.5:0.8b","qwen3-coder:30b")) {
    Check "model present: $m" ($models -match [regex]::Escape($m)) "ollama pull $m"
}

# --- 2. The single interface ---
Write-Host "`n[2] Single JARVIS interface" -ForegroundColor Cyan
try {
    $ids = (Invoke-RestMethod "http://127.0.0.1:11435/v1/models" -TimeoutSec 5).data.id
    Check "interface exposes exactly one model" ($ids.Count -eq 1) "check jarvis_interface.py"
    Check "the one model is 'JARVIS'" ($ids -eq "JARVIS") "MODEL_ID in jarvis_interface.py"
} catch { Check "interface reachable on 11435" $false "start-jarvis-interface.ps1" }

# --- 3. Capability routing (auto-selection, no operator intervention) ---
Write-Host "`n[3] Automatic capability routing" -ForegroundColor Cyan
$acc = & uv run --with pyyaml python -c @"
import sys; sys.path.insert(0, r'$Root\config\kernel')
import jarvis_router as jr
seam = jr.load_seam()
cases = [('good morning!','fast'),('write a python function to reverse a list','coding'),
         ('should I use tabs or spaces? weigh it up','reasoning'),
         ('plan my week around three deadlines','planning')]
ok = sum(1 for t,w in cases if jr.classify(seam, t) == w)
print(f'{ok}/{len(cases)}')
"@ 2>$null
Check "classifier routes >=3/4 sample intents" ([int]($acc -split '/')[0] -ge 3) "tune routing.examples in models.yaml (got $acc)"

# --- 4. Interface answers end-to-end (the path the UI uses) ---
try {
    $body = @{model="JARVIS";stream=$false;messages=@(@{role="user";content="reply with the single word: online"})} | ConvertTo-Json -Depth 5
    $r = Invoke-RestMethod "http://127.0.0.1:11435/v1/chat/completions" -Method Post -ContentType "application/json" -Body $body -TimeoutSec 120
    Check "interface returns a JARVIS-branded completion" (($r.model -eq "JARVIS") -and $r.choices[0].message.content) "check interface routing"
} catch { Check "interface completion works" $false "$($_.Exception.Message)" }

# --- 5. UI consumes only the interface (loopback + tailnet) ---
Write-Host "`n[4] UI adapter" -ForegroundColor Cyan
$ui = Get-NetTCPConnection -State Listen -LocalPort 8080 -ErrorAction SilentlyContinue | Select-Object -First 1
Check "UI listening on loopback" ($ui -and $ui.LocalAddress -eq "127.0.0.1") "start-jarvis-ui.ps1"
$uiScript = Get-Content "$Root\install\start-jarvis-ui.ps1" -Raw
Check "UI hides raw models (ENABLE_OLLAMA_API=false)" ($uiScript -match 'ENABLE_OLLAMA_API\s*=\s*"false"') ""
Check "UI points at the interface (11435)" ($uiScript -match '127\.0\.0\.1:11435') ""
Check "UI arena model disabled" ($uiScript -match 'ENABLE_EVALUATION_ARENA_MODELS\s*=\s*"false"') ""

# --- 6. Offline: every active route is loopback-only ---
Write-Host "`n[5] Offline (no Internet dependency)" -ForegroundColor Cyan
$offline = & uv run --with pyyaml python -c @"
import sys; sys.path.insert(0, r'$Root\config\kernel')
import jarvis_router as jr
seam = jr.load_seam()
bad = 0
for cap in seam['capabilities'].values():
    if not isinstance(cap, dict) or cap.get('status')=='reserved': continue
    for pn in cap['chain']:
        p = seam['providers'][pn]
        if p.get('status','').startswith('archived'): continue
        if not p['endpoint'].startswith('http://127.0.0.1'): bad += 1
print('LOOPBACK' if bad==0 else f'EXTERNAL:{bad}')
"@ 2>$null
Check "all active routes are loopback-only" ($offline -match "LOOPBACK") "a chain references a non-local provider"

# --- 7. Watchdog + auto-start ---
Write-Host "`n[6] Observability + resilience" -ForegroundColor Cyan
& powershell -NoProfile -ExecutionPolicy Bypass -File "$Root\install\watchdog.ps1" | Out-Null
$wd = $LASTEXITCODE
Check "watchdog runs and reports healthy" ($wd -eq 0) "see data\health-status.md"
foreach ($tn in @("JARVIS Interface","JARVIS UI Adapter","JARVIS Watchdog")) {
    Check "scheduled task exists: $tn" ([bool](Get-ScheduledTask -TaskName $tn -ErrorAction SilentlyContinue)) "re-register the logon task"
}

# --- Summary ---
Write-Host ""
if ($fails -eq 0) { Write-Host "PHASE 1 VALIDATED - local mind routes by capability, offline, no paid services." -ForegroundColor Green }
else { Write-Host "$fails check(s) FAILED - fixes above." -ForegroundColor Red }
Write-Host "Note: the operator-facing offline finale (unplug network mid-chat on the tablet) is the human demonstration; this suite proves it structurally." -ForegroundColor Cyan
exit $fails
