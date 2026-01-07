# SolidStack Quick Installer for Windows
# Run with: powershell -ExecutionPolicy Bypass -File install.ps1

Write-Host ""
Write-Host "SolidStack Installer" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  WARNING: Not running as Administrator" -ForegroundColor Yellow
    Write-Host "Some installations may fail without admin rights" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        exit
    }
}

# Step 1: Check for PowerShell 7+
Write-Host "Step 1: Checking PowerShell version..." -ForegroundColor Yellow

$pwshPath = Get-Command pwsh -ErrorAction SilentlyContinue

if (-not $pwshPath) {
    Write-Host "❌ PowerShell 7+ not found" -ForegroundColor Red
    Write-Host "Installing PowerShell 7..." -ForegroundColor Cyan
    
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        winget install --id Microsoft.Powershell --source winget --silent
        Write-Host "✅ PowerShell 7 installed" -ForegroundColor Green
        Write-Host "⚠️  Please close this window and run the installer again in a NEW terminal!" -ForegroundColor Yellow
        Read-Host "Press Enter to exit"
        exit
    } else {
        Write-Host "❌ winget not found. Please install PowerShell 7 manually:" -ForegroundColor Red
        Write-Host "   https://github.com/PowerShell/PowerShell/releases/latest" -ForegroundColor White
        exit 1
    }
} else {
    Write-Host "✅ PowerShell 7+ found: $($pwshPath.Source)" -ForegroundColor Green
}

# Step 2: Check for Git
Write-Host ""
Write-Host "Step 2: Checking for Git..." -ForegroundColor Yellow

$gitPath = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitPath) {
    Write-Host "❌ Git not found" -ForegroundColor Red
    Write-Host "Installing Git..." -ForegroundColor Cyan
    
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        winget install --id Git.Git --source winget --silent
        Write-Host "✅ Git installed" -ForegroundColor Green
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } else {
        Write-Host "⚠️  Please install Git manually: https://git-scm.com/download/win" -ForegroundColor Yellow
        $continue = Read-Host "Continue without Git? (y/n)"
        if ($continue -ne 'y') {
            exit 1
        }
    }
} else {
    Write-Host "✅ Git found: $($gitPath.Source)" -ForegroundColor Green
}

# Step 3: Create directory structure
Write-Host ""
Write-Host "Step 3: Creating directory structure..." -ForegroundColor Yellow

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

# Step 4: Clone repository
Write-Host ""
Write-Host "Step 4: Cloning SolidStack from GitHub..." -ForegroundColor Yellow

if (Test-Path "$root\repo") {
    Write-Host "⚠️  Repository already exists at $root\repo" -ForegroundColor Yellow
    $overwrite = Read-Host "Pull latest changes? (y/n)"
    if ($overwrite -eq 'y') {
        Push-Location "$root\repo"
        git pull
        Pop-Location
        Write-Host "✅ Repository updated" -ForegroundColor Green
    }
} else {
    git clone https://github.com/aperecko/solidstack.git "$root\repo"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Repository cloned" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to clone repository" -ForegroundColor Red
        exit 1
    }
}

# Step 5: Copy runner script
Write-Host ""
Write-Host "Step 5: Setting up runner script..." -ForegroundColor Yellow

Copy-Item "$root\repo\src\solidstack.ps1" "$root\bin\solidstack.ps1" -Force
Write-Host "✅ Runner script installed" -ForegroundColor Green

# Step 6: Test installation
Write-Host ""
Write-Host "Step 6: Testing installation..." -ForegroundColor Yellow
Write-Host ""

& pwsh -File "$root\bin\solidstack.ps1" status

# Summary
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Installation Complete! ✅" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "SolidStack is installed at: C:\SolidStack" -ForegroundColor White
Write-Host ""
Write-Host "Run commands with:" -ForegroundColor Yellow
Write-Host "  pwsh -File C:\SolidStack\bin\solidstack.ps1 status" -ForegroundColor White
Write-Host "  pwsh -File C:\SolidStack\bin\solidstack.ps1 report latest" -ForegroundColor White
Write-Host ""
Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  C:\SolidStack\repo\docs\" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Install Docker Desktop (if not already installed)" -ForegroundColor White
Write-Host "  2. Run: pwsh -File C:\SolidStack\bin\solidstack.ps1 status" -ForegroundColor White
Write-Host "  3. Read: C:\SolidStack\repo\docs\QUICKSTART.md" -ForegroundColor White
Write-Host ""
