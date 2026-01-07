#!/usr/bin/env pwsh
# SolidStack Report Command
# View and manage status reports

param(
    [Parameter(Position=0)]
    [ValidateSet("latest", "show", "list")]
    [string]$Action = "latest",
    
    [Parameter(Position=1)]
    [string]$Arg
)

# Import libraries
. "$PSScriptRoot\..\lib\platform.ps1"
. "$PSScriptRoot\..\lib\logging.ps1"

# Get reports directory
$reportsDir = Get-SolidStackReportsPath
New-Item -ItemType Directory -Force -Path $reportsDir | Out-Null

function Get-LatestReport {
    Get-ChildItem $reportsDir -Filter "status-*.txt" -File |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

switch ($Action) {
    "list" {
        Write-Host ""
        Write-Host "Recent Status Reports" -ForegroundColor Cyan
        Write-Host "=====================" -ForegroundColor Cyan
        Write-Host ""
        
        Get-ChildItem $reportsDir -Filter "status-*.txt" -File |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 20 |
            ForEach-Object {
                $timestamp = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                Write-Host "  $timestamp  $($_.FullName)"
            }
        
        Write-Host ""
        break
    }
    
    "latest" {
        $report = Get-LatestReport
        
        if (-not $report) {
            Write-Host ""
            Write-Host "No reports found in $reportsDir" -ForegroundColor Yellow
            Write-Host "Run 'solidstack status' to generate a report" -ForegroundColor Cyan
            Write-Host ""
            exit 1
        }
        
        Write-Host ""
        Write-Host "--- LATEST REPORT: $($report.FullName) ---" -ForegroundColor Green
        Get-Content $report.FullName
        Write-Host "--- END REPORT ---" -ForegroundColor Green
        Write-Host ""
        break
    }
    
    "show" {
        if (-not $Arg) {
            Write-Host ""
            Write-Host "Usage: solidstack report show <fullpath>" -ForegroundColor Yellow
            Write-Host ""
            exit 1
        }
        
        if (-not (Test-Path $Arg)) {
            Write-Host ""
            Write-Host "Report not found: $Arg" -ForegroundColor Red
            Write-Host ""
            exit 1
        }
        
        Write-Host ""
        Write-Host "--- REPORT: $Arg ---" -ForegroundColor Green
        Get-Content $Arg
        Write-Host "--- END REPORT ---" -ForegroundColor Green
        Write-Host ""
        break
    }
}
