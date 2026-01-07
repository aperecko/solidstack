function New-SSLog {
  param([string]$Name)
  $ts  = Get-Date -Format 'yyyyMMdd-HHmmss'
  $log = Join-Path 'C:\SolidStack\stack\logs' "$Name-$ts.log"
  New-Item -ItemType Directory -Force -Path (Split-Path $log) | Out-Null
  return $log
}

function Write-SSLog {
  param(
    [string]$LogFile,
    [string]$Msg,
    [ValidateSet('INFO','OK','WARN','ERROR')] [string]$Level='INFO'
  )
  $line = "{0} [{1}] {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Level, $Msg
  $line | Tee-Object -FilePath $LogFile -Append | Out-Host
}

function Show-SSTail {
  param([string]$LogFile,[int]$Lines=200)
  Write-Host "`n--- LOG TAIL ($Lines lines): $LogFile ---"
  if (Test-Path $LogFile) { Get-Content $LogFile -Tail $Lines } else { Write-Host "(missing log file)" }
  Write-Host "--- END LOG TAIL ---`n"
}
