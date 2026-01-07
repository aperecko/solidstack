param(
  [Parameter(Position=0)][ValidateSet("latest","show","list")] [string]$Action="latest",
  [Parameter(Position=1)][string]$Arg
)

. "$PSScriptRoot\..\lib\logging.ps1"

$ReportsDir = "C:\SolidStack\reports"
New-Item -ItemType Directory -Force -Path $ReportsDir | Out-Null

function Get-LatestReport {
  Get-ChildItem $ReportsDir -Filter "status-*.txt" -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
}

switch ($Action) {
  "list" {
    Get-ChildItem $ReportsDir -Filter "status-*.txt" -File |
      Sort-Object LastWriteTime -Descending |
      Select-Object -First 20 |
      ForEach-Object { "{0}  {1}" -f $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss"), $_.FullName }
    break
  }

  "latest" {
    $f = Get-LatestReport
    if (!$f) { Write-Host "No reports found in $ReportsDir"; exit 1 }
    Write-Host "`n--- LATEST REPORT: $($f.FullName) ---"
    Get-Content $f.FullName
    Write-Host "--- END REPORT ---"
    break
  }

  "show" {
    if (!$Arg) { Write-Host "Usage: solidstack report show <fullpath>"; exit 1 }
    if (!(Test-Path $Arg)) { Write-Host "Not found: $Arg"; exit 1 }
    Write-Host "`n--- REPORT: $Arg ---"
    Get-Content $Arg
    Write-Host "--- END REPORT ---"
    break
  }
}
