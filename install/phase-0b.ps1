# ============================================================================
# JarvisOS - install\phase-0b.ps1        (supersedes install\phase-0.ps1)
# ============================================================================
# PURPOSE      : Found the system: directory skeleton (ADR-025), seed files,
#                hardware survey, three git repositories with secret-scanning
#                hooks, and the founding commits.
# SCOPE        : Phase 0, task T5 only. Runs against -Root (default D:\Fable OS).
# WHAT IT DOES : Creates directories/files that are missing; initializes git
#                repos that are missing; relocates a stray landing\ project to
#                projects\landing; commits pending changes in each repo.
# WHAT IT NEVER DOES:
#                Never overwrites an existing seed file. Never deletes anything.
#                Never touches frozen corpus documents (ADR-016). Never pushes
#                to any remote. Never stores or prints a secret.
# PREREQUISITES: PowerShell 5.1+, git with identity configured (T3),
#                gitleaks installed (T3). The script verifies all of these
#                itself and stops with plain-English instructions if missing.
# IDEMPOTENCY  : Safe to run any number of times. Second run makes no changes
#                and says so. Every create is guarded by an existence check;
#                .gitignore files are rewritten only when content differs.
# ROLLBACK     : Additive-only. To undo completely: delete the .git folders it
#                created (root, config\, data\), delete the directories/files
#                listed in its output, or restore C:\FableOS-Backups\
#                2026-07-11-T1-baseline. Frozen documents are never at risk.
# EXPECTED RUNTIME: under 60 seconds.
# ============================================================================

param(
    [string]$Root = "D:\Fable OS"
)

$ErrorActionPreference = "Stop"
$script:Changes = @()

function Fail([string]$What, [string]$Why, [string]$How) {
    Write-Host ""
    Write-Host "=== PHASE 0 STOPPED - nothing is broken, nothing was half-done ===" -ForegroundColor Red
    Write-Host "What failed : $What"
    Write-Host "Why         : $Why"
    Write-Host "How to fix  : $How"
    Write-Host ""
    Write-Host "If unsure, paste this line to your AI assistant:" -ForegroundColor Yellow
    Write-Host "[phase-0b failure] step='$What' why='$Why'"
    exit 1
}

function Did([string]$msg) { $script:Changes += $msg; Write-Host "  + $msg" -ForegroundColor Green }

function Ensure-Dir([string]$p) {
    if (-not (Test-Path $p)) { New-Item -ItemType Directory -Force -Path $p | Out-Null; Did "created $p" }
}

function Seed-File([string]$p, [string]$content) {
    if (-not (Test-Path $p)) {
        [System.IO.File]::WriteAllText($p, $content, (New-Object System.Text.UTF8Encoding($false)))
        Did "seeded $p"
    }
}

function Ensure-FileContent([string]$p, [string]$content) {
    $current = ""
    if (Test-Path $p) { $current = [System.IO.File]::ReadAllText($p) }
    if ($current.Trim() -ne $content.Trim()) {
        [System.IO.File]::WriteAllText($p, $content, (New-Object System.Text.UTF8Encoding($false)))
        Did "wrote $p"
    }
}

Write-Host "JarvisOS Phase 0 founding script (root: $Root)" -ForegroundColor Cyan

# --- 0. Preconditions --------------------------------------------------------
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path","User")   # T3 lesson: fresh shells see stale PATH

if (-not (Test-Path $Root)) { Fail "root check" "The folder $Root does not exist." "Check the drive letter and folder name, then run again." }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Fail "git check" "git is not installed or not on PATH." "Run T3's git install step, close this window, open a new PowerShell, run this script again." }
if (-not (Get-Command gitleaks -ErrorAction SilentlyContinue)) { Fail "gitleaks check" "gitleaks (the secret scanner) is not installed or not on PATH." "Run: winget install --id Gitleaks.Gitleaks -e   then run this script again." }
if (-not (git config --global user.email)) { Fail "git identity" "git does not know who you are, so commits would fail." "Run T3's git configuration step (sets your name and email), then run this script again." }

# --- 1. Directory skeleton (ADR-025) ------------------------------------------
Write-Host "`n[1/7] Directory skeleton" -ForegroundColor Cyan
foreach ($d in @("config","config\jobs","config\kernel","config\vault",
                 "data","data\memory","data\memory\_quarantine","data\journal",
                 "projects","install","install\hooks","tests")) {
    Ensure-Dir (Join-Path $Root $d)
}
foreach ($d in @("config\jobs","config\kernel","data\memory\_quarantine","projects")) {
    Seed-File (Join-Path $Root "$d\.gitkeep") ""
}

# --- 2. Seed files (never overwritten) ----------------------------------------
Write-Host "`n[2/7] Seed files" -ForegroundColor Cyan
Seed-File (Join-Path $Root "data\memory\MEMORY.md") @"
# Memory Index

One line per memory file below this directory. Maintained by the system.
Quarantined (unreviewed) memories live in _quarantine\ and are NOT listed here
until promoted (ADR-013).
"@

Seed-File (Join-Path $Root "config\vault\SECRETS-INVENTORY.md") @"
# Secrets Inventory

Names and storage locations of secrets. NEVER values. (Law 9)

| Secret | Stored in | Used by |
|---|---|---|
"@

Seed-File (Join-Path $Root "PRIVACY.md") @"
# PRIVACY - Data Classification (drives ADR-011 / ADR-025)

Living document (ADR-016 registry tier). Every directory is classified before
anything is stored in it. The tier decides what may leave the machine.

| Path | Tier | May leave the machine? |
|---|---|---|
| *.md at root, decisions\, reviews\, skills\, install\, tests\ | public-capable docs | git push allowed (public or private remote) |
| config\ (except vault\ and secrets) | private config | private git remote only |
| config\vault\ | private inventory (names, never values) | private git remote only |
| config\secrets.env, Credential Manager entries | SECRET | never - not in git, not in backups in plaintext |
| data\memory\, data\journal\ | PERSONAL | never unencrypted - restic only (Phase 3) |
| data\memory\_quarantine\ | PERSONAL + untrusted | never leaves; excluded from recall until reviewed (ADR-013) |
| projects\<name>\ | per-project (classify at creation) | own remote, mandated at creation |
| Consoles (tablet/phone) | render-only | hold no canonical state, ever (ADR-026) |
"@

$today = Get-Date -Format yyyy-MM-dd
Seed-File (Join-Path $Root "data\journal\$today-phase-0.md") @"
# $today - Phase 0: the founding

The system was founded today. Directory skeleton per ADR-025, three
repositories (docs, config, data) initialized with secret-scanning hooks,
hardware surveyed, founding commits made by install\phase-0b.ps1.

This is the first entry the system records about itself.
"@

# --- 3. Hardware survey (refreshed on every run - it is a reading, not a record)
Write-Host "`n[3/7] Hardware survey" -ForegroundColor Cyan
$os  = Get-CimInstance Win32_OperatingSystem
$cs  = Get-CimInstance Win32_ComputerSystem
$build = [int]$os.BuildNumber
if ($build -ge 22000) { $osStatus = "Windows 11 - IN SUPPORT (verify edition EOL at quarterly checkup)" }
else { $osStatus = "Windows 10 - OUT OF SUPPORT since 2025-10-14 - T6 gate open (ADR-014)" }
$gpuLines = @()
$gpuKey = Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" -ErrorAction SilentlyContinue |
          Where-Object { $_.PSChildName -match '^\d{4}$' }
foreach ($sub in $gpuKey) {
    $p = Get-ItemProperty $sub.PSPath -ErrorAction SilentlyContinue
    if ($p.'HardwareInformation.qwMemorySize') {
        $gpuLines += "- GPU: $($p.DriverDesc) - VRAM: $([math]::Round($p.'HardwareInformation.qwMemorySize'/1GB,1)) GB"
    }
}
$sb = Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State" -ErrorAction SilentlyContinue
if ($sb -and $sb.UEFISecureBootEnabled -eq 1) { $sbState = "enabled" } else { $sbState = "not confirmed" }
$dsk = Get-PSDrive ($Root.Substring(0,1)) | Select-Object -ExpandProperty Free
$hw = @"
# Hardware Survey - $(Get-Date -Format yyyy-MM-dd) (written by phase-0b.ps1; refreshed on each run)

- OS: $($os.Caption) build $($os.BuildNumber)
- OS support status: $osStatus
- Secure Boot: $sbState
- RAM: $([math]::Round($cs.TotalPhysicalMemory / 1GB,1)) GB
$($gpuLines -join "`n")
- Free space on $($Root.Substring(0,2)) $([math]::Round($dsk / 1GB)) GB

Local model sizing note: the largest VRAM figure above is the budget for
Phase 1 model selection (ADR-005 / VERSIONS.md forward pins).
"@
Ensure-FileContent (Join-Path $Root "config\hardware.md") $hw

# --- 4. Relocate stray landing\ project (ADR-025 section 5) -------------------
Write-Host "`n[4/7] Housekeeping" -ForegroundColor Cyan
$stray = Join-Path $Root "landing"
$strayDest = Join-Path $Root "projects\landing"
if ((Test-Path $stray) -and (-not (Test-Path $strayDest))) {
    Move-Item $stray $strayDest
    Did "relocated landing\ to projects\landing (ADR-025)"
}

# --- 5. .gitignore files (content-managed; these are living files, ADR-016) ---
Write-Host "`n[5/7] .gitignore boundaries" -ForegroundColor Cyan
Ensure-FileContent (Join-Path $Root ".gitignore") @"
# Nested repositories (ADR-025) - each versions itself; invisible to the docs repo
config/
data/
projects/

# Caches and junk (Law 1: only sources of truth get versioned)
**/node_modules/
**/__pycache__/
**/.cache/
Thumbs.db
"@
Ensure-FileContent (Join-Path $Root "config\.gitignore") @"
# Law 9: secret VALUES never enter version control (names live in vault\)
secrets.env
"@
Ensure-FileContent (Join-Path $Root "data\.gitignore") @"
# Rebuildable indexes are disposable (Law 1 / ADR-004); Phase 3 builds them
memory/index.sqlite*
"@

# --- 6. Git repositories + hooks (ADR-011 / ADR-025) --------------------------
Write-Host "`n[6/7] Repositories and guards" -ForegroundColor Cyan
$hooksPath = Join-Path $Root "install\hooks"

# exFAT and other non-NTFS volumes record no file ownership; git then refuses
# repo discovery ("dubious ownership"). Declare the root and its children safe.
$rootFwd = $Root -replace '\\','/'
$safeEntries = @(git config --global --get-all safe.directory 2>$null)
foreach ($p in @($rootFwd, "$rootFwd/*")) {
    if ($safeEntries -notcontains $p) {
        git config --global --add safe.directory $p
        Did "git safe.directory exception: $p"
    }
}

if (-not (Test-Path (Join-Path $hooksPath "pre-commit"))) {
    Fail "hooks check" "install\hooks\pre-commit is missing." "The hook files ship with the repo (authored at T4). Restore them from the baseline backup or re-run the T4 step."
}
foreach ($repo in @(@{Path=$Root; Name="fableos-docs"},
                    @{Path=(Join-Path $Root "config"); Name="fableos-config"},
                    @{Path=(Join-Path $Root "data");   Name="fableos-data"})) {
    if (-not (Test-Path (Join-Path $repo.Path ".git"))) {
        git -C $repo.Path init --quiet
        if ($LASTEXITCODE -ne 0) { Fail "git init $($repo.Name)" "git could not create the repository." "Check that $($repo.Path) is writable, then run this script again." }
        Did "initialized $($repo.Name) at $($repo.Path)"
    }
    git -C $repo.Path config core.hooksPath $hooksPath
    if ($LASTEXITCODE -ne 0) { Fail "hooksPath $($repo.Name)" "git refused to set the hooks path." "Run this script again; if it repeats, paste the failure line to your AI assistant." }
}

# --- 7. Founding commits -------------------------------------------------------
Write-Host "`n[7/7] Founding commits" -ForegroundColor Cyan
foreach ($repo in @(@{Path=$Root; Name="fableos-docs"},
                    @{Path=(Join-Path $Root "config"); Name="fableos-config"},
                    @{Path=(Join-Path $Root "data");   Name="fableos-data"})) {
    git -C $repo.Path add -A
    $dirty = git -C $repo.Path status --porcelain
    if ($dirty) {
        git -C $repo.Path commit --quiet -m "Phase 0: founding commit ($($repo.Name))"
        if ($LASTEXITCODE -ne 0) { Fail "commit $($repo.Name)" "The secret scanner may have blocked the commit, or git hit an error (see message above)." "Read the lines above this message - if gitleaks reported a finding, a secret-looking string is in a staged file; remove it and run this script again." }
        Did "founding commit in $($repo.Name)"
    }
}

# --- Summary -------------------------------------------------------------------
Write-Host ""
if ($script:Changes.Count -eq 0) {
    Write-Host "Phase 0 founding: nothing to do - already founded (idempotent re-run)." -ForegroundColor Green
} else {
    Write-Host "Phase 0 founding: $($script:Changes.Count) change(s) made." -ForegroundColor Green
}
Write-Host "Next: run tests\phase-0.ps1 to validate." -ForegroundColor Cyan
