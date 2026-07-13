# ============================================================================
# JarvisOS - tests\conversation.ps1
# ============================================================================
# PURPOSE : Executable "done when" for the Runtime Conversation Loop (ADR-035).
#           Drives jarvis_voice._reply against the LIVE interface with audio
#           stubbed: greeting, question, follow-up-with-context, identity,
#           markdown-free speech, streaming, interruption, mic discipline,
#           state sequencing, bounded history.
# EXIT    : number of failed checks (0 = conversation loop validated).
# ============================================================================
$env:PYTHONUTF8 = "1"; $env:PYTHONIOENCODING = "utf-8"
$py = "D:\Fable OS\config\voice\.venv\Scripts\python.exe"
if (-not (Test-Path $py)) { Write-Host "FAIL: voice venv missing"; exit 1 }
Write-Host "Runtime Conversation Loop validation" -ForegroundColor Cyan
& $py "D:\Fable OS\tests\conversation-selftest.py"
exit $LASTEXITCODE
