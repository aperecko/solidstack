#!/usr/bin/env pwsh
# SolidStack runner - requires PowerShell 7+
# Usage: pwsh -File C:\SolidStack\repo\src\solidstack.ps1 <command>

param(
  [Parameter(Position=0)]
  [string]$Command = "help",

  [Parameter(ValueFromRemainingArguments=$true)]
  [string[]]$CommandArgs
)

# Verify PowerShell 7+
if ($PSVersionTable.PSVersion.Major -lt 7) {
  Write-Host "ERROR: SolidStack requires PowerShell 7+" -ForegroundColor Red
  Write-Host "Current version: $($PSVersionTable.PSVersion)" -ForegroundColor Yellow
  Write-Host "Install with: powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1" -ForegroundColor Cyan
  exit 1
}

$Base = "C:\SolidStack\repo\src"
$CommandsDir = Join-Path $Base "commands"

function Show-Help {
  Write-Host ""
  Write-Host "SolidStack runner (PowerShell 7+)"
  Write-Host "Usage:"
  Write-Host "  solidstack.ps1 status"
  Write-Host "  solidstack.ps1 report latest"
  Write-Host "  solidstack.ps1 report list"
  Write-Host "  solidstack.ps1 report show <fullpath>"
  Write-Host ""
}

# Normalize command
$cmd = ($Command ?? "help").ToLowerInvariant()

switch ($cmd) {
  "status"  { & (Join-Path $CommandsDir "status.ps1") @CommandArgs; break }
  "report"  { & (Join-Path $CommandsDir "report.ps1") @CommandArgs; break }
  "help"    { Show-Help; break }
  default   { Write-Host "Unknown command: $Command"; Show-Help; exit 2 }
}
