# Decisions (ADR-lite)

## 2026-01-06: Cross-Platform Evolution (v2.0 Vision)
- SolidStack will evolve to work on any OS (Windows/Linux/macOS)
- Recipe-based "deploy X" pattern for one-command deployments
- Snapshot/restore system for safe learning by breaking
- Auto-documentation and best practices built-in

Reason: 
- PowerShell 7+ already runs on all platforms
- Docker containers are already portable
- "Learn by breaking" needs safety nets (snapshots)
- Best practices should be default, not manual
- Makes SolidStack useful for way more people

The theater analogy scales perfectly:
- Concert hall = ANY server (not just Windows)
- Conductor = SolidStack (works anywhere)
- Sheet music = Recipes (portable)
- Orchestra = Containers (already portable)

See docs/CROSS-PLATFORM-VISION.md and docs/ROADMAP-V2.md for full plan.

## 2026-01-06: SolidStack is a Control Plane, Not a Container
- SolidStack runs on bare metal (Windows + PowerShell)
- Services managed BY SolidStack run IN Docker containers
- This is the control layer that orchestrates everything else

Reason: Clear separation of concerns. SolidStack needs to:
- Start/stop Docker itself
- Access host filesystem for secrets and backups
- Manage Docker Compose files
- Provide a stable bootstrap layer

Avoids the "inception problem" of containers managing containers. PowerShell on Windows is the natural control plane layer, just like bash/systemd on Linux.

See docs/ARCHITECTURE.md for full explanation.

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
