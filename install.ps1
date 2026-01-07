# SolidStack Smart Installer for Windows
# Automatically detects and installs prerequisites
# Run with: powershell -ExecutionPolicy Bypass -File install.ps1

Write-Host ""
Write-Host "SolidStack Smart Installer" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Not running as Administrator" -ForegroundColor Yellow
    Write-Host "Some installations may require admin rights" -ForegroundColor Yellow
    Write-Host ""
}

# ============================================================================
# STEP 1: Check Prerequisites
# ============================================================================

Write-Host "Step 1: Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

$needsRestart = $false
$prerequisitesInstalled = @()

# Check for winget
Write-Host "  Checking for winget package manager..." -ForegroundColor White
$winget = Get-Command winget -ErrorAction SilentlyContinue

if (-not $winget) {
    Write-Host "  ❌ winget not found" -ForegroundColor Red
    Write-Host "  ℹ️  winget is required to install prerequisites" -ForegroundColor Cyan
    Write-Host "  📥 Install from: https://aka.ms/getwinget" -ForegroundColor White
    Write-Host ""
    Write-Host "  After installing winget, run this installer again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
} else {
    Write-Host "  ✅ winget found" -ForegroundColor Green
}

# Check for PowerShell 7+
Write-Host "  Checking for PowerShell 7+..." -ForegroundColor White
$pwshPath = Get-Command pwsh -ErrorAction SilentlyContinue

if (-not $pwshPath) {
    Write-Host "  ❌ PowerShell 7+ not found" -ForegroundColor Red
    Write-Host "  📥 Installing PowerShell 7..." -ForegroundColor Cyan
    
    try {
        winget install --id Microsoft.Powershell --source winget --silent --accept-package-agreements --accept-source-agreements
        Write-Host "  ✅ PowerShell 7 installed" -ForegroundColor Green
        $needsRestart = $true
        $prerequisitesInstalled += "PowerShell 7"
    } catch {
        Write-Host "  ❌ Failed to install PowerShell 7" -ForegroundColor Red
        Write-Host "  Please install manually from: https://github.com/PowerShell/PowerShell/releases" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    $pwshVersion = & pwsh -Command '$PSVersionTable.PSVersion.ToString()'
    Write-Host "  ✅ PowerShell 7+ found (v$pwshVersion)" -ForegroundColor Green
}

# Check for Git
Write-Host "  Checking for Git..." -ForegroundColor White
$gitPath = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitPath) {
    Write-Host "  ❌ Git not found" -ForegroundColor Red
    Write-Host "  📥 Installing Git..." -ForegroundColor Cyan
    
    try {
        winget install --id Git.Git --source winget --silent --accept-package-agreements --accept-source-agreements
        Write-Host "  ✅ Git installed" -ForegroundColor Green
        
        # Refresh PATH for current session
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        $needsRestart = $true
        $prerequisitesInstalled += "Git"
    } catch {
        Write-Host "  ❌ Failed to install Git" -ForegroundColor Red
        Write-Host "  Please install manually from: https://git-scm.com/download/win" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    $gitVersion = git --version
    Write-Host "  ✅ Git found ($gitVersion)" -ForegroundColor Green
}

# Check for Docker (informational only - don't auto-install)
Write-Host "  Checking for Docker..." -ForegroundColor White
$dockerPath = Get-Command docker -ErrorAction SilentlyContinue

if (-not $dockerPath) {
    Write-Host "  ℹ️  Docker not found (optional - needed for containers)" -ForegroundColor Yellow
    Write-Host "     Install later from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Gray
} else {
    $dockerVersion = docker --version
    Write-Host "  ✅ Docker found ($dockerVersion)" -ForegroundColor Green
}

Write-Host ""

# If we installed prerequisites, inform user about restart
if ($needsRestart) {
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Prerequisites Installed! ✅" -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "The following were installed:" -ForegroundColor White
    foreach ($item in $prerequisitesInstalled) {
        Write-Host "  • $item" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "⚠️  IMPORTANT: You must restart your terminal!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Steps:" -ForegroundColor Cyan
    Write-Host "  1. Close this PowerShell window" -ForegroundColor White
    Write-Host "  2. Open a NEW PowerShell window" -ForegroundColor White
    Write-Host "  3. Run this installer again" -ForegroundColor White
    Write-Host ""
    Write-Host "The installation will continue automatically after restart." -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 0
}

# ============================================================================
# STEP 2: Create Directory Structure
# ============================================================================

Write-Host "Step 2: Creating directory structure..." -ForegroundColor Yellow

$root = "C:\SolidStack"
$directories = @(
    "$root\bin",
    "$root\stack\logs",
    "$root\stack\secrets",
    "$root\stack\config",
    "$root\stack\compose",
    "$root\stack\data",
    "$root\reports",
    "$root\tools"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

Write-Host "✅ Directories created" -ForegroundColor Green
Write-Host ""

# ============================================================================
# STEP 3: Clone Repository
# ============================================================================

Write-Host "Step 3: Cloning SolidStack from GitHub..." -ForegroundColor Yellow

if (Test-Path "$root\repo") {
    Write-Host "⚠️  Repository already exists at $root\repo" -ForegroundColor Yellow
    $overwrite = Read-Host "Update to latest version? (y/n)"
    
    if ($overwrite -eq 'y') {
        Push-Location "$root\repo"
        git pull
        $pullExitCode = $LASTEXITCODE
        Pop-Location
        
        if ($pullExitCode -eq 0) {
            Write-Host "✅ Repository updated" -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to update repository" -ForegroundColor Red
            Write-Host "Try: cd $root\repo && git pull" -ForegroundColor Yellow
        }
    }
} else {
    git clone https://github.com/aperecko/solidstack.git "$root\repo"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Repository cloned" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to clone repository" -ForegroundColor Red
        Write-Host ""
        Write-Host "This might be due to:" -ForegroundColor Yellow
        Write-Host "  • Network connectivity issues" -ForegroundColor White
        Write-Host "  • Git not properly installed" -ForegroundColor White
        Write-Host "  • Repository doesn't exist yet" -ForegroundColor White
        Write-Host ""
        Write-Host "Try manually:" -ForegroundColor Cyan
        Write-Host "  git clone https://github.com/aperecko/solidstack.git $root\repo" -ForegroundColor White
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host ""

# ============================================================================
# STEP 4: Set Up Runner Script
# ============================================================================

Write-Host "Step 4: Setting up runner script..." -ForegroundColor Yellow

if (Test-Path "$root\repo\src\solidstack.ps1") {
    Copy-Item "$root\repo\src\solidstack.ps1" "$root\bin\solidstack.ps1" -Force
    Write-Host "✅ Runner script installed" -ForegroundColor Green
} else {
    Write-Host "⚠️  Runner script not found in repository" -ForegroundColor Yellow
    Write-Host "This might mean the repository structure has changed" -ForegroundColor Gray
}

Write-Host ""

# ============================================================================
# STEP 5: Test Installation
# ============================================================================

Write-Host "Step 5: Testing installation..." -ForegroundColor Yellow
Write-Host ""

if (Test-Path "$root\bin\solidstack.ps1") {
    try {
        & pwsh -File "$root\bin\solidstack.ps1" status
        $testExitCode = $LASTEXITCODE
        
        if ($testExitCode -eq 0) {
            Write-Host ""
            Write-Host "================================" -ForegroundColor Cyan
            Write-Host "Installation Successful! ✅" -ForegroundColor Green
            Write-Host "================================" -ForegroundColor Cyan
        }
    } catch {
        Write-Host "⚠️  Test run encountered an error" -ForegroundColor Yellow
        Write-Host "Error: $_" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  Could not test installation (runner script not found)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "SolidStack Installation Location:" -ForegroundColor White
Write-Host "  $root" -ForegroundColor Cyan
Write-Host ""
Write-Host "Quick Start:" -ForegroundColor Yellow
Write-Host "  pwsh -File $root\bin\solidstack.ps1 status" -ForegroundColor White
Write-Host "  pwsh -File $root\bin\solidstack.ps1 report latest" -ForegroundColor White
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  $root\repo\docs\" -ForegroundColor White
Write-Host ""

# Summary of what's installed
Write-Host "Installed Components:" -ForegroundColor Cyan
Write-Host "  ✅ PowerShell 7+" -ForegroundColor Green
Write-Host "  ✅ Git" -ForegroundColor Green
if ($dockerPath) {
    Write-Host "  ✅ Docker" -ForegroundColor Green
} else {
    Write-Host "  ℹ️  Docker (not installed - optional)" -ForegroundColor Yellow
}
Write-Host "  ✅ SolidStack" -ForegroundColor Green
Write-Host ""

if (-not $dockerPath) {
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Install Docker Desktop (if you need containers):" -ForegroundColor White
    Write-Host "     winget install Docker.DockerDesktop" -ForegroundColor Cyan
    Write-Host "  2. Run: pwsh -File $root\bin\solidstack.ps1 status" -ForegroundColor White
    Write-Host ""
}

Write-Host "Happy deploying! 🚀" -ForegroundColor Green
Write-Host ""
