# SolidStack (v2)

Goals:
- Traceable changes (git)
- Predictable structure
- Logs always visible in-session (tail) + saved to disk
- Commands are small and composable

Layout:
- src\solidstack.ps1           entry/router
- src\commands\*.ps1           commands (status, deploy, backup, etc.)
- src\lib\*.ps1                helpers (logging, env, docker, op)
- docs\                        runbooks/decisions
- config\examples\             templates (no secrets)
