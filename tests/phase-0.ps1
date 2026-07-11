# ============================================================================
# JarvisOS - tests\phase-0.ps1
# ============================================================================
# PURPOSE      : The executable "Done when" for Phase 0. Independently verifies
#                everything phase-0b.ps1 claims to have done, plus the T6 gate.
# SCOPE        : Read-only against -Root; writes only inside %TEMP% (synthetic
#                repos used to prove the hooks actually fire).
# WHAT IT DOES : Checks skeleton, seed files, three repos + commits + hook
#                wiring, nested-repo invisibility, git identity, tools, the
#                hardware survey fields, and the Windows 11 exit gate.
# WHAT IT NEVER DOES: Never modifies anything under -Root. Never pushes.
# PREREQUISITES: phase-0b.ps1 has been run against the same -Root.
# IDEMPOTENCY  : Fully re-runnable forever; this file is the Phase 0
#                regression test for every future disaster-recovery drill.
# ROLLBACK     : Nothing to roll back (read-only + self-cleaning temp).
# EXPECTED RUNTIME: ~15 seconds.
# EXIT CODE    : number of FAILED checks (0 = Phase 0 validated;
#                the pending T6 gate reports as PENDING, not FAILED,
#                unless -RequireWindows11 is passed).
# ============================================================================

param(
    [string]$Root = "D:\Fable OS",
    [switch]$RequireWindows11
)

$ErrorActionPreference = "Continue"
$fails = 0; $pending = 0
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")

function Check([string]$name, [bool]$ok, [string]$fix = "") {
    if ($ok) { Write-Host ("  PASS  " + $name) -ForegroundColor Green }
    else {
        Write-Host ("  FAIL  " + $name) -ForegroundColor Red
        if ($fix) { Write-Host ("        fix: " + $fix) -ForegroundColor Yellow }
        $script:fails++
    }
}

Write-Host "Phase 0 validation (root: $Root)" -ForegroundColor Cyan

# --- 1. Skeleton (ADR-025) ---
Write-Host "`n[1] Directory skeleton" -ForegroundColor Cyan
foreach ($d in @("config","config\jobs","config\kernel","config\vault",
                 "data\memory\_quarantine","data\journal","projects","install\hooks","tests")) {
    Check "dir $d" (Test-Path (Join-Path $Root $d)) "run install\phase-0b.ps1"
}

# --- 2. Seed files ---
Write-Host "`n[2] Seed files" -ForegroundColor Cyan
foreach ($f in @("data\memory\MEMORY.md","config\vault\SECRETS-INVENTORY.md",
                 "config\hardware.md","PRIVACY.md",".gitignore","config\.gitignore","data\.gitignore")) {
    Check "file $f" (Test-Path (Join-Path $Root $f)) "run install\phase-0b.ps1"
}
$hwPath = Join-Path $Root "config\hardware.md"
if (Test-Path $hwPath) {
    $hw = [System.IO.File]::ReadAllText($hwPath)
    Check "hardware.md records VRAM" ($hw -match "VRAM") "re-run phase-0b.ps1 (survey section)"
    Check "hardware.md records OS support status" ($hw -match "support") "re-run phase-0b.ps1 (survey section)"
}

# --- 3. Repositories ---
Write-Host "`n[3] Repositories" -ForegroundColor Cyan
$hooksPath = Join-Path $Root "install\hooks"
foreach ($r in @(@{P=$Root; N="fableos-docs"},
                 @{P=(Join-Path $Root "config"); N="fableos-config"},
                 @{P=(Join-Path $Root "data");   N="fableos-data"})) {
    $isRepo = Test-Path (Join-Path $r.P ".git")
    Check "$($r.N) is a git repository" $isRepo "run install\phase-0b.ps1"
    if ($isRepo) {
        $n = git -C $r.P rev-list --count HEAD 2>$null
        Check "$($r.N) has a founding commit" ([int]$n -ge 1) "run install\phase-0b.ps1"
        $hp = git -C $r.P config core.hooksPath
        Check "$($r.N) hooksPath wired" ($hp -eq $hooksPath) "run install\phase-0b.ps1"
    }
}
# Nested repos invisible to parent
$porcelain = git -C $Root status --porcelain 2>$null
$leak = $porcelain | Select-String -Pattern '^(.. )?(config/|data/|projects/)' -Quiet
Check "nested repos invisible to fableos-docs" (-not $leak) "root .gitignore must list config/ data/ projects/"

# --- 4. Identity + tools ---
Write-Host "`n[4] Identity and tools" -ForegroundColor Cyan
Check "git identity set" ([bool](git config --global user.email)) "run the T3 git configuration block"
Check "git present"      ([bool](Get-Command git      -ErrorAction SilentlyContinue)) "winget install Git.Git"
Check "uv present"       ([bool](Get-Command uv       -ErrorAction SilentlyContinue)) "winget install astral-sh.uv"
Check "gitleaks present" ([bool](Get-Command gitleaks -ErrorAction SilentlyContinue)) "winget install Gitleaks.Gitleaks"

# --- 5. Guards actually fire (synthetic repos in TEMP; -Root untouched) ---
Write-Host "`n[5] Guard canaries (synthetic, in TEMP)" -ForegroundColor Cyan
$work = Join-Path $env:TEMP ("p0test-" + [guid]::NewGuid().ToString("N").Substring(0,8))
try {
    # 5a. pre-commit must BLOCK a realistic fake secret
    $r1 = Join-Path $work "canary"
    New-Item -ItemType Directory -Force $r1 | Out-Null
    git -C $r1 init --quiet
    git -C $r1 config core.hooksPath $hooksPath
    $fake = 'token = "ghp_' + (-join ((65..90)+(97..122)+(48..57) | Get-Random -Count 36 | ForEach-Object {[char]$_})) + '"'
    [System.IO.File]::WriteAllText((Join-Path $r1 "leak.txt"), $fake)
    git -C $r1 add -A
    git -C $r1 commit -m "canary" --quiet 2>$null | Out-Null
    Check "pre-commit blocks a staged secret" ($LASTEXITCODE -ne 0) "hook not firing - check install\hooks\pre-commit and hooksPath"

    # 5b. pre-commit must ALLOW a clean commit
    Remove-Item (Join-Path $r1 "leak.txt")
    [System.IO.File]::WriteAllText((Join-Path $r1 "clean.txt"), "nothing secret here")
    git -C $r1 add -A
    git -C $r1 commit -m "clean canary" --quiet 2>$null | Out-Null
    Check "pre-commit allows a clean commit" ($LASTEXITCODE -eq 0) "hook is over-blocking - paste its output to your AI assistant"

    # 5c. pre-push must BLOCK a repo whose toplevel ends in \data
    $r2 = Join-Path $work "data"
    New-Item -ItemType Directory -Force $r2 | Out-Null
    git -C $r2 init --quiet
    git -C $r2 config core.hooksPath $hooksPath
    [System.IO.File]::WriteAllText((Join-Path $r2 "note.txt"), "synthetic")
    git -C $r2 add -A; git -C $r2 commit -m "synthetic" --quiet | Out-Null
    $bare = Join-Path $work "bare.git"
    git init --bare --quiet $bare
    git -C $r2 remote add origin $bare
    git -C $r2 push origin HEAD --quiet 2>$null | Out-Null
    Check "pre-push blocks the data repository" ($LASTEXITCODE -ne 0) "check install\hooks\pre-push and hooksPath"
} finally {
    if (Test-Path $work) { Remove-Item $work -Recurse -Force -ErrorAction SilentlyContinue }
}

# --- 6. The T6 exit gate ---
Write-Host "`n[6] Substrate gate (ADR-014)" -ForegroundColor Cyan
$build = [int](Get-CimInstance Win32_OperatingSystem).BuildNumber
if ($build -ge 22000) {
    Check "Windows 11 (build $build)" $true
} elseif ($RequireWindows11) {
    Check "Windows 11 (build $build)" $false "complete T6: upgrade to Windows 11, then re-run with -RequireWindows11"
} else {
    Write-Host "  PEND  Windows 11 gate (build $build is Windows 10) - ACCEPTED under ADR-028; ceiling 2026-10-01 / pre-Phase 6" -ForegroundColor Yellow
    $pending++
}

# --- Summary ---
Write-Host ""
if ($fails -eq 0 -and $pending -eq 0) { Write-Host "PHASE 0 VALIDATED - all checks green. Exit gate closed." -ForegroundColor Green }
elseif ($fails -eq 0)                 { Write-Host "PHASE 0 checks green; $pending gate(s) PENDING (expected before T6)." -ForegroundColor Yellow }
else                                  { Write-Host "$fails check(s) FAILED - fixes listed above. Safe to re-run after fixing." -ForegroundColor Red }
exit $fails
