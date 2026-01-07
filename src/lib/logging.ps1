#!/usr/bin/env pwsh
# SolidStack Logging Functions
# Cross-platform logging utilities

# Import platform helpers
. "$PSScriptRoot/platform.ps1"

function New-SSLog {
    <#
    .SYNOPSIS
    Create a new timestamped log file
    
    .PARAMETER Name
    Base name for the log file (e.g., "solidstack-status")
    
    .OUTPUTS
    String: Full path to the created log file
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    
    $ts = Get-Date -Format 'yyyyMMdd-HHmmss'
    $logsDir = Get-SolidStackLogsPath
    $logFile = Join-Path $logsDir "$Name-$ts.log"
    
    # Ensure logs directory exists
    New-Item -ItemType Directory -Force -Path $logsDir | Out-Null
    
    return $logFile
}

function Write-SSLog {
    <#
    .SYNOPSIS
    Write a message to the log file and console
    
    .PARAMETER LogFile
    Path to the log file
    
    .PARAMETER Msg
    Message to log
    
    .PARAMETER Level
    Log level: INFO, OK, WARN, ERROR
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$LogFile,
        
        [Parameter(Mandatory=$true)]
        [string]$Msg,
        
        [ValidateSet('INFO','OK','WARN','ERROR')]
        [string]$Level = 'INFO'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "{0} [{1}] {2}" -f $timestamp, $Level, $Msg
    
    # Write to file and console
    $line | Tee-Object -FilePath $LogFile -Append | Out-Host
}

function Show-SSTail {
    <#
    .SYNOPSIS
    Display the last N lines of a log file
    
    .PARAMETER LogFile
    Path to the log file
    
    .PARAMETER Lines
    Number of lines to show (default: 200)
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$LogFile,
        
        [int]$Lines = 200
    )
    
    Write-Host ""
    Write-Host "--- LOG TAIL ($Lines lines): $LogFile ---" -ForegroundColor Cyan
    
    if (Test-Path $LogFile) {
        Get-Content $LogFile -Tail $Lines
    } else {
        Write-Host "(log file not found)" -ForegroundColor Yellow
    }
    
    Write-Host "--- END LOG TAIL ---" -ForegroundColor Cyan
    Write-Host ""
}

# Export functions (only when imported as module)
if ($MyInvocation.MyCommand.CommandType -eq 'ExternalScript') {
    # Being dot-sourced - functions are already available
} else {
    # Being imported as module - export functions
    Export-ModuleMember -Function @(
        'New-SSLog',
        'Write-SSLog',
        'Show-SSTail'
    )
}
