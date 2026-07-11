# ============================================================================
# JarvisOS - tests\voice.ps1
# ============================================================================
# PURPOSE : Executable "done when" for the Voice Runtime (ADR-022), headless
#           portion. Runs tests\voice-selftest.py in the voice venv: TTS, STT
#           round-trip, the 'hey_jarvis' wake word, and audio-device visibility.
#           The live spoken loop is the operator's physical validation.
# EXIT    : number of failed checks (0 = headless voice validated).
# ============================================================================
$env:PYTHONUTF8 = "1"; $env:PYTHONIOENCODING = "utf-8"
$py = "D:\Fable OS\config\voice\.venv\Scripts\python.exe"
if (-not (Test-Path $py)) { Write-Host "FAIL: voice venv missing (config\voice\.venv)"; exit 1 }
Write-Host "Voice Runtime headless validation" -ForegroundColor Cyan
& $py "D:\Fable OS\tests\voice-selftest.py"
exit $LASTEXITCODE
