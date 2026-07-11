# JarvisOS — Phase 0: Foundation
# What this does: installs git, creates the directory skeleton, records your
# hardware, and makes the founding commit. Safe to run more than once.
# What could go wrong: almost nothing — it only creates files inside D:\Fable OS
# and installs git. Nothing is deleted, nothing leaves this machine.

$ErrorActionPreference = "Stop"
$Root = "D:\Fable OS"
Set-Location $Root

# --- 1. Git ------------------------------------------------------------------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing git..." -ForegroundColor Cyan
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements
    Write-Host "Git installed. Close this window, open a NEW PowerShell window, and run this script again." -ForegroundColor Yellow
    exit
}

# --- 2. Directory skeleton (README.md is the contract) -------------------------
foreach ($d in @("config", "config\jobs", "memory", "journal", "projects", "vault", "install")) {
    New-Item -ItemType Directory -Force -Path (Join-Path $Root $d) | Out-Null
    $keep = Join-Path $Root "$d\.gitkeep"
    if (-not (Test-Path $keep)) { New-Item -ItemType File -Path $keep | Out-Null }
}

# --- 3. Seed files -------------------------------------------------------------
if (-not (Test-Path "$Root\memory\MEMORY.md")) {
    "# Memory Index`n`nOne line per memory file below this directory. Maintained by the system.`n" |
        Out-File "$Root\memory\MEMORY.md" -Encoding utf8
}
if (-not (Test-Path "$Root\vault\SECRETS-INVENTORY.md")) {
    "# Secrets Inventory`n`nNames and storage locations of secrets. NEVER values. (Law 9)`n`n| Secret | Stored in | Used by |`n|---|---|---|`n" |
        Out-File "$Root\vault\SECRETS-INVENTORY.md" -Encoding utf8
}

# --- 4. Hardware survey (determines local model sizes in Phase 1) --------------
$cs  = Get-CimInstance Win32_ComputerSystem
$gpu = (Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name) -join ", "
$dsk = Get-PSDrive D | Select-Object -ExpandProperty Free
@"
# Hardware Survey — $(Get-Date -Format yyyy-MM-dd)

- RAM: $([math]::Round($cs.TotalPhysicalMemory / 1GB)) GB
- GPU: $gpu
- Free space on D: $([math]::Round($dsk / 1GB)) GB
- Windows: $((Get-CimInstance Win32_OperatingSystem).Caption)
"@ | Out-File "$Root\config\hardware.md" -Encoding utf8

# --- 5. Founding commit ---------------------------------------------------------
if (-not (Test-Path "$Root\.git")) { git init | Out-Null }
git add -A
if (git status --porcelain) {
    git commit -m "Phase 0: founding documents and directory skeleton" | Out-Null
    Write-Host "Founding commit made." -ForegroundColor Green
}

Write-Host "`nPhase 0 complete. 'Done when' check:" -ForegroundColor Green
git log --oneline
Write-Host "`nNext: open ROADMAP.md and start Phase 1." -ForegroundColor Cyan
