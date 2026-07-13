# ============================================================================
# JarvisOS - tests\awareness.ps1
# ============================================================================
# PURPOSE : Executable "done when" for Visual Awareness (ADR-032). Runs
#           tests\awareness-selftest.py in the awareness venv: config contract
#           (six consent toggles), live sensors, consent honoring, single-
#           snapshot retention, and the data-not-instructions fence.
# EXIT    : number of failed checks (0 = awareness validated).
# ============================================================================
$env:PYTHONUTF8 = "1"; $env:PYTHONIOENCODING = "utf-8"
$py = "D:\Fable OS\config\awareness\.venv\Scripts\python.exe"
if (-not (Test-Path $py)) { Write-Host "FAIL: awareness venv missing (config\awareness\.venv)"; exit 1 }
Write-Host "Visual Awareness validation" -ForegroundColor Cyan
& $py "D:\Fable OS\tests\awareness-selftest.py"
exit $LASTEXITCODE
