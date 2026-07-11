# ============================================================================
# JarvisOS - install\watchdog.ps1
# ============================================================================
# PURPOSE      : Make silent death loud (C7 / ARCHITECTURE-V2 §7). Checks the
#                Runtime's vital signs and writes a status line every run; on
#                any failure it also raises a visible desktop alert (best-effort)
#                and drops an ALERT marker the morning brief will read aloud once
#                voice lands (Phase 4/6).
# SCOPE        : Health monitoring. Run by Task Scheduler every few hours.
# WHAT IT DOES : Read-only checks. Writes only under data\ (health status +
#                optional ALERT marker) - the disposable/journal tier.
# WHAT IT NEVER DOES:
#                No repairs, no restarts, no network egress, no dependencies.
#                Observation only - a watchdog that acts is a new failure mode.
# PREREQUISITES: none (pure PowerShell + built-ins).
# IDEMPOTENCY  : Fully re-runnable; each run overwrites the status file.
# ROLLBACK     : Disable the scheduled task; delete data\health-status.md.
# EXPECTED RUNTIME: ~5 s.
# ============================================================================
$ErrorActionPreference = "Continue"
$root   = "D:\Fable OS"
$status = Join-Path $root "data\health-status.md"
$alert  = Join-Path $root "data\ALERT.txt"
$checks = @()

function Check($name, [bool]$ok, $detail) {
    $script:checks += [pscustomobject]@{ Name = $name; OK = $ok; Detail = $detail }
}

# --- Runtime vital signs -----------------------------------------------------
foreach ($svc in @(@{n="Ollama (models)";p=11434}, @{n="Model gateway";p=4000}, @{n="JARVIS interface";p=11435}, @{n="UI adapter";p=8080})) {
    $listening = [bool](Get-NetTCPConnection -State Listen -LocalPort $svc.p -ErrorAction SilentlyContinue)
    Check $svc.n $listening "port $($svc.p)"
}

# Interface answers and still exposes exactly one model, JARVIS
try {
    $models = (Invoke-RestMethod "http://127.0.0.1:11435/v1/models" -TimeoutSec 5).data.id
    Check "Interface exposes only JARVIS" (($models.Count -eq 1) -and ($models -eq "JARVIS")) "models=$($models -join ',')"
} catch { Check "Interface exposes only JARVIS" $false "unreachable" }

# Journal freshness (<24h) - proves the system is still recording itself
$latest = Get-ChildItem (Join-Path $root "data\journal") -Filter *.md -ErrorAction SilentlyContinue |
          Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latest) {
    $ageH = [math]::Round(((Get-Date) - $latest.LastWriteTime).TotalHours, 1)
    Check "Journal fresh (<24h)" ($ageH -lt 24) "$($latest.Name), ${ageH}h old"
} else { Check "Journal fresh (<24h)" $false "no journal files" }

# Disk headroom (>10% free) on both drives
foreach ($d in @("C","D")) {
    $drive = Get-PSDrive $d -ErrorAction SilentlyContinue
    if ($drive) {
        $pct = [math]::Round($drive.Free / ($drive.Free + $drive.Used) * 100, 1)
        Check "Disk $($d): >10% free" ($pct -gt 10) "$pct% free"
    }
}

# --- Write status (always) ---------------------------------------------------
$failed = @($checks | Where-Object { -not $_.OK })
$stamp  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$verdict = if ($failed.Count -eq 0) { "ALL GREEN" } else { "$($failed.Count) FAILING" }
$lines = @("# JARVIS Runtime health - $stamp", "", "**$verdict**", "")
foreach ($c in $checks) { $lines += "- $(if($c.OK){'[OK]  '}else{'[FAIL]'}) $($c.Name) - $($c.Detail)" }
$lines += @("", "_(watchdog: install\watchdog.ps1; the morning brief reads this aloud once voice lands)_")
[System.IO.File]::WriteAllText($status, ($lines -join "`n"), (New-Object System.Text.UTF8Encoding($false)))

# --- On failure: make it loud (best-effort, dependency-free) -----------------
if ($failed.Count -gt 0) {
    $msg = "JARVIS health: $verdict - " + (($failed | ForEach-Object { $_.Name }) -join "; ")
    [System.IO.File]::WriteAllText($alert, "$stamp`n$msg`n`nSee data\health-status.md", (New-Object System.Text.UTF8Encoding($false)))
    try { & msg.exe * $msg 2>$null } catch { }   # visible box on Win10 Pro; harmless if absent
    exit 1
} else {
    if (Test-Path $alert) { Remove-Item $alert -Force -ErrorAction SilentlyContinue }
    exit 0
}
