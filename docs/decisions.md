# Decisions (ADR-lite)

## 2026-01-06: Upgrade to PowerShell 7+
- Changed from Windows PowerShell 5.1 to PowerShell 7+ (pwsh)
- Added version check in runner with helpful error message
- Created install script at tools/install-pwsh.ps1

Reason: Access to modern PowerShell features (?? operator, better performance, cross-platform compatibility), active development, better JSON/REST handling. PS 5.1 is legacy and only maintained for compatibility.

## 2026-01-06: v2 repo + runner split
- Repo: C:\SolidStack\repo (git tracked)
- Runner: C:\SolidStack\bin\solidstack.ps1 (thin wrapper)
- Logs: C:\SolidStack\stack\logs
- Reports: C:\SolidStack\reports

Reason: easy troubleshooting + AI-readable session output + durable change history
