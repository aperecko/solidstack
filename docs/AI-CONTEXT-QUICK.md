# SolidStack Context for AI Assistants

**What this is:** SolidStack is installed on this server. Use it to check status and manage services.

**Quick Commands:**
```bash
# Check system status (START HERE!)
pwsh -File ~/.solidstack/bin/solidstack.ps1 status

# View latest report
pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest

# List all reports
pwsh -File ~/.solidstack/bin/solidstack.ps1 report list
```

**What it does:**
- Checks what tools are installed (Docker, Git, etc.)
- Monitors system state
- Logs everything for troubleshooting
- Manages Docker services

**When to use it:**
- User asks "what's running?"
- Before deploying services
- When troubleshooting issues
- To check system health

**File locations:**
```
~/.solidstack/bin/       - Scripts
~/.solidstack/stack/logs/ - All logs
~/.solidstack/reports/    - Status reports
```

**Remember:** SolidStack is the "conductor" - it runs ON the server and orchestrates Docker containers.

**Full guide:** ~/.solidstack/repo/docs/AI-ASSISTANT-GUIDE.md
