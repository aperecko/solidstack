# Decisions (ADR-lite)

## 2026-01-06: v2 repo + runner split
- Repo: C:\SolidStack\repo (git tracked)
- Runner: C:\SolidStack\bin\solidstack.ps1 (thin wrapper)
- Logs: C:\SolidStack\stack\logs
- Reports: C:\SolidStack\reports

Reason: easy troubleshooting + AI-readable session output + durable change history
