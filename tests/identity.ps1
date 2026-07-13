# ============================================================================
# JarvisOS - tests\identity.ps1
# ============================================================================
# PURPOSE : Executable "done when" for the identity guarantee (ADR-035).
#           Unit scrub cases (incl. split-across-chunks) + live interface
#           probes: no model/vendor/infrastructure name may ever surface.
# EXIT    : number of failed checks (0 = identity guaranteed).
# ============================================================================
$env:PYTHONUTF8 = "1"; $env:PYTHONIOENCODING = "utf-8"
$py = "D:\Fable OS\config\overlay\.venv\Scripts\python.exe"
if (-not (Test-Path $py)) { Write-Host "FAIL: overlay venv missing"; exit 1 }
Write-Host "Identity guarantee validation" -ForegroundColor Cyan
& $py "D:\Fable OS\tests\identity-selftest.py"
exit $LASTEXITCODE
