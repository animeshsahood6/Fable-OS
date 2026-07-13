# ============================================================================
# JarvisOS - tests\presence.ps1
# ============================================================================
# PURPOSE : Executable "done when" for Presence (ADR-033). Runs
#           tests\presence-selftest.py in the presence venv: config contract,
#           live signals (idle / lock / tailnet reachability), scaffold
#           honesty, verdict semantics, single-reading retention.
# EXIT    : number of failed checks (0 = presence validated).
# ============================================================================
$env:PYTHONUTF8 = "1"; $env:PYTHONIOENCODING = "utf-8"
$py = "D:\Fable OS\config\presence\.venv\Scripts\python.exe"
if (-not (Test-Path $py)) { Write-Host "FAIL: presence venv missing (config\presence\.venv)"; exit 1 }
Write-Host "Presence validation" -ForegroundColor Cyan
& $py "D:\Fable OS\tests\presence-selftest.py"
exit $LASTEXITCODE
