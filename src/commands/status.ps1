#!/usr/bin/env pwsh
# SolidStack Status Command
# Cross-platform system status check

param()

# Import libraries
. "$PSScriptRoot\..\lib\platform.ps1"
. "$PSScriptRoot\..\lib\logging.ps1"

# Create log
$Log = New-SSLog -Name "solidstack-status"
Write-SSLog $Log "SolidStack status check starting" "INFO"
Write-SSLog $Log "OS: $(Get-SolidStackOS)" "INFO"
Write-SSLog $Log "PowerShell: $($PSVersionTable.PSVersion)" "INFO"

# Check tools
$tools = @('docker', 'git', 'op', 'rclone', 'gh')
$found = @{}

foreach ($tool in $tools) {
    if (Test-SolidStackCommand $tool) {
        $path = Get-SolidStackCommandPath $tool
        Write-SSLog $Log "FOUND: $tool => $path" "OK"
        $found[$tool] = $true
    } else {
        Write-SSLog $Log "MISSING: $tool" "WARN"
        $found[$tool] = $false
    }
}

# Docker version check (if available)
if ($found['docker']) {
    try {
        $dockerVersion = docker version --format '{{.Server.Version}}' 2>$null
        if ($dockerVersion) {
            Write-SSLog $Log "Docker Server: $dockerVersion" "OK"
        }
    } catch {
        Write-SSLog $Log "Could not get Docker version" "WARN"
    }
}

# 1Password CLI check (if available)
if ($found['op']) {
    try {
        op account list *>$null
        if ($LASTEXITCODE -eq 0) {
            Write-SSLog $Log "1Password CLI: signed in" "OK"
        } else {
            Write-SSLog $Log "1Password CLI: not signed in" "WARN"
        }
    } catch {
        Write-SSLog $Log "1Password CLI: could not check status" "WARN"
    }
}

# Generate report
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$reportsDir = Get-SolidStackReportsPath
New-Item -ItemType Directory -Force -Path $reportsDir | Out-Null
$reportPath = Join-Path $reportsDir "status-$timestamp.txt"

$reportContent = @(
    "SOLIDSTACK STATUS REPORT"
    "========================"
    ""
    "Time:    $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    "OS:      $(Get-SolidStackOS)"
    "Root:    $(Get-SolidStackRoot)"
    "Log:     $Log"
    ""
    "PowerShell:"
    " - Version: $($PSVersionTable.PSVersion)"
    " - Edition: $($PSVersionTable.PSEdition)"
    ""
    "Tools:"
    " - docker:  $($found['docker'])"
    " - git:     $($found['git'])"
    " - op:      $($found['op'])"
    " - rclone:  $($found['rclone'])"
    " - gh:      $($found['gh'])"
    ""
    "Package Manager: $(Get-SolidStackPackageManager)"
)

$reportContent | Set-Content -Path $reportPath -Encoding UTF8

Write-SSLog $Log "Wrote report: $reportPath" "OK"
Write-SSLog $Log "Status check complete" "OK"

# Display report
Write-Host ""
Write-Host "--- REPORT: $reportPath ---" -ForegroundColor Green
Get-Content $reportPath
Write-Host "--- END REPORT ---" -ForegroundColor Green

# Show log tail
Show-SSTail -LogFile $Log -Lines 200
