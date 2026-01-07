. "$PSScriptRoot\..\lib\logging.ps1"
param()

$Log = New-SSLog -Name "solidstack-status"
Write-SSLog $Log "SolidStack status (v2) starting" "INFO"

$tools = @('docker','op','rclone','git','gh')
$found = @{}
foreach ($t in $tools) {
  $c = Get-Command $t -ErrorAction SilentlyContinue
  if ($c) { Write-SSLog $Log "FOUND: $t => $($c.Source)" "OK"; $found[$t]=$true }
  else     { Write-SSLog $Log "MISSING: $t" "WARN"; $found[$t]=$false }
}

# Docker server version (best effort)
try {
  $dv = docker version --format '{{.Server.Version}}' 2>$null
  if ($dv) { Write-SSLog $Log "Docker Server: $dv" "OK" }
} catch {}

# 1Password signed in (best effort)
try {
  op account list *> $null
  if ($LASTEXITCODE -eq 0) { Write-SSLog $Log "1Password CLI: signed in" "OK" }
  else { Write-SSLog $Log "1Password CLI: not signed in" "WARN" }
} catch {}

# Write report
$ts = Get-Date -Format 'yyyyMMdd-HHmmss'
$Report = "C:\SolidStack\reports\status-$ts.txt"

@(
  "SOLIDSTACK STATUS REPORT (v2)"
  "Time:  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
  "Root:  C:\SolidStack"
  "Log:   $Log"
  ""
  "Tools:"
  " - docker:  $([bool]$found['docker'])"
  " - op:      $([bool]$found['op'])"
  " - rclone:  $([bool]$found['rclone'])"
  " - git:     $([bool]$found['git'])"
  " - gh:      $([bool]$found['gh'])"
) | Set-Content -Encoding UTF8 $Report

Write-SSLog $Log "Wrote report: $Report" "OK"
Write-SSLog $Log "Status complete." "OK"

Write-Host "`n--- REPORT: $Report ---"
Get-Content $Report
Write-Host "--- END REPORT ---"

Show-SSTail -LogFile $Log -Lines 200
