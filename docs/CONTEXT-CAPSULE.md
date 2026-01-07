# SolidStack Context Capsule
_Last updated: 2026-01-06 19:16:19_

## What SolidStack is
A traceable, modular self-host stack for SRV (Windows Server + Docker Desktop), designed so:
- Every run can be understood from console output (AI-friendly)
- Changes are easy to troubleshoot and evolve
- Secrets never get committed

## Where everything lives
- Root: C:\SolidStack
- Runner: C:\SolidStack\bin\solidstack.ps1
- Logs: C:\SolidStack\stack\logs\
- Reports (AI bundles): C:\SolidStack\reports\
- Docs: C:\SolidStack\docs\

## Design rules
- No one giant forever script  we use small commands.
- Every command writes a timestamped log.
- Every bundle creates a timestamped report you can paste to ChatGPT.
- Secrets stay in stack\secrets (never in git).

## Core commands
- status  -> checks tools + prints status + log tail
- bundle  -> prints a full AI bundle (and saves it)
- recall  -> prints capsule + latest bundle + latest log tail
- note    -> append a timestamped note to docs\NOTES.md

## Requirements
- PowerShell 7+ (pwsh) - install with: `powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1`
- Docker Desktop

## Current state (auto)
Run: pwsh -File C:\SolidStack\bin\solidstack.ps1 status
