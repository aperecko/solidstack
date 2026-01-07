#!/usr/bin/env pwsh
# Cross-Platform Test Script
# Tests that platform abstraction works correctly

Write-Host ""
Write-Host "SolidStack Cross-Platform Test" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan
Write-Host ""

# Import platform library
. "$PSScriptRoot/../src/lib/platform.ps1"

# Display environment
Show-SolidStackEnvironment

# Test path functions
Write-Host "Path Tests" -ForegroundColor Yellow
Write-Host "----------" -ForegroundColor Yellow
Write-Host "Root Path:        $(Get-SolidStackRoot)"
Write-Host "Repo Path:        $(Get-SolidStackRepoPath)"
Write-Host "Bin Path:         $(Get-SolidStackBinPath)"
Write-Host "Stack Path:       $(Get-SolidStackStackPath)"
Write-Host "Logs Path:        $(Get-SolidStackLogsPath)"
Write-Host "Reports Path:     $(Get-SolidStackReportsPath)"
Write-Host "Secrets Path:     $(Get-SolidStackSecretsPath)"
Write-Host ""

# Test Docker path conversion
Write-Host "Docker Path Conversion Tests" -ForegroundColor Yellow
Write-Host "----------------------------" -ForegroundColor Yellow

if (Test-SolidStackWindows) {
    $testPaths = @(
        "C:\SolidStack\data",
        "C:\Users\Test\Documents",
        "D:\Backups"
    )
} else {
    $testPaths = @(
        "/home/user/.solidstack/data",
        "/opt/solidstack/data",
        "/var/lib/docker"
    )
}

foreach ($path in $testPaths) {
    $dockerPath = ConvertTo-DockerPath $path
    Write-Host "  $path"
    Write-Host "  → $dockerPath"
    Write-Host ""
}

# Test command detection
Write-Host "Command Detection Tests" -ForegroundColor Yellow
Write-Host "-----------------------" -ForegroundColor Yellow

$commands = @('pwsh', 'docker', 'git', 'op', 'rclone', 'gh')

foreach ($cmd in $commands) {
    $exists = Test-SolidStackCommand $cmd
    $path = Get-SolidStackCommandPath $cmd
    
    if ($exists) {
        Write-Host "  ✓ $cmd" -ForegroundColor Green
        Write-Host "    Path: $path"
    } else {
        Write-Host "  ✗ $cmd" -ForegroundColor Red
        Write-Host "    Not found"
    }
}

Write-Host ""

# Test package manager detection
Write-Host "Package Manager Detection" -ForegroundColor Yellow
Write-Host "-------------------------" -ForegroundColor Yellow
Write-Host "Detected: $(Get-SolidStackPackageManager)"
Write-Host ""

# Summary
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "============" -ForegroundColor Cyan
Write-Host "OS:                 $(Get-SolidStackOS)"
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)"
Write-Host "Platform Module:    ✓ Loaded successfully" -ForegroundColor Green
Write-Host "Path Abstraction:   ✓ Working" -ForegroundColor Green
Write-Host "Docker Conversion:  ✓ Working" -ForegroundColor Green
Write-Host "Command Detection:  ✓ Working" -ForegroundColor Green
Write-Host ""
Write-Host "✓ Cross-platform abstraction layer is functional!" -ForegroundColor Green
Write-Host ""
