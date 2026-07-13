# ============================================================================
# JarvisOS - tests\overlay.ps1
# ============================================================================
# PURPOSE : Executable "done when" for the Glass Overlay (ADR-031), headless
#           portion. Runs tests\overlay-selftest.py in the overlay venv:
#           config contract, adapter import, glass window, hotkey registration,
#           and streaming via the single JARVIS interface (11435).
#           The on-screen summon/read check is the operator's validation.
# EXIT    : number of failed checks (0 = headless overlay validated).
# ============================================================================
$env:PYTHONUTF8 = "1"; $env:PYTHONIOENCODING = "utf-8"
$py = "D:\Fable OS\config\overlay\.venv\Scripts\python.exe"
if (-not (Test-Path $py)) { Write-Host "FAIL: overlay venv missing (config\overlay\.venv)"; exit 1 }
Write-Host "Glass Overlay headless validation" -ForegroundColor Cyan
& $py "D:\Fable OS\tests\overlay-selftest.py"
exit $LASTEXITCODE
