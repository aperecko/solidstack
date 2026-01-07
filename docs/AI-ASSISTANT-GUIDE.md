# 🤖 SolidStack - AI Assistant Guide

**Purpose:** Enable AI assistants to effectively use SolidStack when SSH'd into servers  
**Audience:** AI assistants (Claude, ChatGPT, etc.)  
**Context:** Remote server management via SSH

---

## What is SolidStack?

SolidStack is a **cross-platform control plane** for managing Docker services. Think of it as:
- The conductor orchestrating Docker containers
- Infrastructure-as-code for self-hosted services
- A docker-compose wrapper with logging, safety, and best practices built-in

### The Mental Model (Theater Analogy)

```
🏛️ Server (Windows/Linux/macOS) = Concert hall (the building)
🎼 SolidStack                    = Conductor (orchestrates everything)
🎻 Docker containers             = Orchestra (the performers)
🎼 Compose files                 = Sheet music (instructions)
```

**Key insight:** SolidStack runs ON the server (bare metal), not IN Docker.

---

## When to Use SolidStack

### ✅ Use SolidStack When:

1. **Checking System Status**
   - User asks "what's running?"
   - Need to see what tools are available
   - Verifying Docker/Git/etc are installed

2. **Deploying Services** (coming soon)
   - User wants to deploy WordPress, Traefik, etc.
   - Setting up new containers
   - Configuring reverse proxy

3. **Viewing Reports**
   - Need historical status information
   - Troubleshooting issues
   - Understanding system state

4. **Managing Infrastructure**
   - Starting/stopping services
   - Checking logs
   - Backup operations

### ❌ Don't Use SolidStack When:

- Just running normal Docker commands (use `docker` directly)
- Editing files (use standard tools)
- Installing system packages (use apt/yum/winget)
- One-off container operations

---

## Command Reference

### Primary Commands

```bash
# Check system status (ALWAYS start here)
pwsh -File /path/to/solidstack.ps1 status

# View latest status report
pwsh -File /path/to/solidstack.ps1 report latest

# List all reports
pwsh -File /path/to/solidstack.ps1 report list

# Show specific report
pwsh -File /path/to/solidstack.ps1 report show <path>
```

### Common Paths

**Windows:**
```powershell
# Runner script
C:\SolidStack\bin\solidstack.ps1

# Logs
C:\SolidStack\stack\logs\

# Reports
C:\SolidStack\reports\

# Repository
C:\SolidStack\repo\
```

**Linux/macOS:**
```bash
# Runner script
~/.solidstack/bin/solidstack.ps1

# Logs
~/.solidstack/stack/logs/

# Reports  
~/.solidstack/reports/

# Repository
~/.solidstack/repo/
```

---

## Detection & Discovery

### How to Know SolidStack is Available

Check for these indicators:

```bash
# Method 1: Check for directory
test -d ~/.solidstack && echo "SolidStack installed"

# Method 2: Check for runner script
test -f ~/.solidstack/bin/solidstack.ps1 && echo "SolidStack available"

# Method 3: Try to run it
pwsh -File ~/.solidstack/bin/solidstack.ps1 status 2>&1 | grep -q "SolidStack" && echo "Working"
```

### If Not Found

```bash
# Check Windows path
test -d /mnt/c/SolidStack && echo "Found on Windows mount"

# Look for PowerShell
command -v pwsh && echo "PowerShell 7+ available"
```

---

## Understanding Output

### Status Command Output

```
SOLIDSTACK STATUS REPORT
========================

Time:    2026-01-07 13:16:45
OS:      Linux                    ← What OS we're on
Root:    /home/user/.solidstack   ← Installation path
Log:     /home/user/.solidstack/stack/logs/solidstack-status-20260107-131644.log

PowerShell:
 - Version: 7.5.4                 ← PowerShell version
 - Edition: Core                  ← Confirms PS7+

Tools:                            ← What's available
 - docker:  True                  ← Docker installed
 - git:     True                  ← Git installed
 - op:      False                 ← 1Password CLI missing
 - rclone:  True                  ← rclone available
 - gh:      True                  ← GitHub CLI available

Package Manager: apt              ← System package manager
```

### What This Tells You

- **OS**: Adjust commands based on Windows/Linux/macOS
- **Tools: True/False**: What's available for operations
- **Root path**: Where to find logs, configs, etc.
- **Package Manager**: How to install missing dependencies

---

## Workflow Patterns

### Pattern 1: System Health Check

```bash
# 1. Run status
pwsh -File ~/.solidstack/bin/solidstack.ps1 status

# 2. Parse output for issues
# Look for:
#   - Missing critical tools (docker: False)
#   - OS and version info
#   - Recent errors in logs

# 3. Report findings to user
```

### Pattern 2: Viewing Logs

```bash
# 1. Find recent logs
ls -lt ~/.solidstack/stack/logs/ | head -5

# 2. View specific log
cat ~/.solidstack/stack/logs/solidstack-status-TIMESTAMP.log

# 3. Search for errors
grep -i error ~/.solidstack/stack/logs/*.log
```

### Pattern 3: Troubleshooting

```bash
# 1. Check latest report
pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest

# 2. Compare with previous reports
pwsh -File ~/.solidstack/bin/solidstack.ps1 report list

# 3. View specific historical report
pwsh -File ~/.solidstack/bin/solidstack.ps1 report show <path>

# 4. Check relevant logs
```

---

## Cross-Platform Considerations

### OS Detection in Scripts

SolidStack automatically detects OS. You can too:

```bash
# Check OS
uname -s
# Linux, Darwin (macOS), or MINGW*/MSYS* (Windows)

# Or use PowerShell variables
pwsh -Command '$IsLinux'   # True on Linux
pwsh -Command '$IsWindows' # True on Windows
pwsh -Command '$IsMacOS'   # True on macOS
```

### Path Adjustments

```bash
# Linux/macOS
SOLIDSTACK_ROOT="$HOME/.solidstack"

# Windows (Git Bash/WSL)
SOLIDSTACK_ROOT="/c/SolidStack"

# Use whichever exists
if [ -d "$HOME/.solidstack" ]; then
    SOLIDSTACK_ROOT="$HOME/.solidstack"
elif [ -d "/c/SolidStack" ]; then
    SOLIDSTACK_ROOT="/c/SolidStack"
fi
```

---

## Integration Examples

### Example 1: Auto-Status Check

When user mentions issues, proactively check:

```bash
# AI Response Pattern:
"Let me check the system status first..."

pwsh -File ~/.solidstack/bin/solidstack.ps1 status

"Based on the status:
 - Docker is running ✓
 - Git is available ✓
 - rclone is missing (we can install if needed)
 
The issue you described might be..."
```

### Example 2: Before Major Operations

```bash
# Before deploying services:
"Before we deploy, let me verify prerequisites..."

pwsh -File ~/.solidstack/bin/solidstack.ps1 status

# Parse output
# Check: docker: True, git: True
# If missing: "We need to install Docker first. Shall I proceed?"
```

### Example 3: Understanding Infrastructure

```bash
# User: "What's currently deployed?"

"Let me check the SolidStack reports..."

pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest

# Parse for Docker containers, services, etc.
"Based on the latest report from 10 minutes ago:
 - All core tools are present
 - Docker is running version X.Y.Z
 - No services deployed yet
 
Would you like to deploy something?"
```

---

## Safety & Best Practices

### Always Check Before Acting

```bash
# GOOD: Check first
pwsh -File ~/.solidstack/bin/solidstack.ps1 status
# Parse output, make informed decisions

# BAD: Assume things work
docker-compose up  # Might fail if Docker isn't running
```

### Use Logs for Troubleshooting

```bash
# When something fails:
# 1. Check latest log
ls -t ~/.solidstack/stack/logs/ | head -1 | xargs cat

# 2. Look for ERROR or WARN markers
grep -E "ERROR|WARN" ~/.solidstack/stack/logs/*.log

# 3. Provide context to user
```

### Respect the Architecture

Remember:
- SolidStack = Control plane (runs on server)
- Docker containers = Services (run in Docker)
- Don't try to run SolidStack IN Docker
- Don't mix concerns

---

## Quick Reference Card

### Essential Commands
```bash
# Status check (do this first!)
pwsh -File ~/.solidstack/bin/solidstack.ps1 status

# View latest report
pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest

# List all reports  
pwsh -File ~/.solidstack/bin/solidstack.ps1 report list

# Find logs
ls -lt ~/.solidstack/stack/logs/

# View recent log
tail -50 ~/.solidstack/stack/logs/solidstack-status-*.log
```

### File Locations
```
~/.solidstack/                    Root directory
├── bin/solidstack.ps1           Main script
├── stack/logs/                  All logs
├── reports/                     Status reports
└── repo/                        Git repository
```

### Key Indicators
```
Tools: True    = Available, can use
Tools: False   = Missing, may need to install
docker: True   = Services can be deployed
git: True      = Can pull updates
```

---

## Common Scenarios

### Scenario 1: User Asks "What's Running?"

```bash
# Response sequence:
1. Run: pwsh -File ~/.solidstack/bin/solidstack.ps1 status
2. Parse output for tools status
3. Run: docker ps (to see containers)
4. Summarize for user:
   "Current system state:
    - OS: Linux
    - Docker: Running (5 containers active)
    - Recent status: All healthy
    - Logs: No errors in last hour"
```

### Scenario 2: User Wants to Deploy Service

```bash
# Response sequence:
1. Check prerequisites:
   pwsh -File ~/.solidstack/bin/solidstack.ps1 status
   
2. Verify docker: True
   If False: "Need to install Docker first"
   
3. Once ready:
   "Prerequisites met. Ready to deploy [service]"
   
4. Proceed with deployment
```

### Scenario 3: Something's Broken

```bash
# Troubleshooting sequence:
1. Get current status:
   pwsh -File ~/.solidstack/bin/solidstack.ps1 status
   
2. Check recent logs:
   tail -100 ~/.solidstack/stack/logs/*.log | grep -i error
   
3. Compare with last working state:
   pwsh -File ~/.solidstack/bin/solidstack.ps1 report list
   
4. Identify what changed:
   "Comparing current vs 1 hour ago:
    - Docker was restarted
    - This likely caused [service] to stop
    - Fix: restart the affected containers"
```

---

## Error Handling

### Common Errors & Solutions

**Error: "command not found: pwsh"**
```bash
Solution: PowerShell 7+ not installed
Fix: Install PowerShell first
```

**Error: "No such file or directory: solidstack.ps1"**
```bash
Solution: SolidStack not installed
Fix: Run installation or check path
```

**Error: "The term 'docker' is not recognized"**
```bash
Solution: Docker not installed or not in PATH
Fix: Install Docker or add to PATH
```

### When SolidStack Isn't Available

```bash
# Fallback to direct commands:
docker version           # Check Docker
git --version           # Check Git
docker ps               # See running containers
docker-compose ps       # See compose services

# Inform user:
"SolidStack isn't installed here. I can still help with 
 direct Docker commands, or we can install SolidStack first."
```

---

## Advanced Usage

### Parsing Reports Programmatically

```bash
# Extract specific info from reports
latest_report=$(pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest)

# Parse for docker status
echo "$latest_report" | grep "docker:" | awk '{print $3}'

# Parse for OS
echo "$latest_report" | grep "^OS:" | awk '{print $2}'

# Use in logic
if echo "$latest_report" | grep -q "docker: True"; then
    echo "Docker is available"
fi
```

### Reading Logs

```bash
# Get most recent log
latest_log=$(ls -t ~/.solidstack/stack/logs/solidstack-*.log | head -1)

# Count errors
error_count=$(grep -c ERROR "$latest_log")

# Find last error
last_error=$(grep ERROR "$latest_log" | tail -1)

# Report to user
"Found $error_count errors. Most recent: $last_error"
```

---

## Summary for AI Assistants

### Golden Rules

1. **Always check status first** - `solidstack status`
2. **Use logs for troubleshooting** - Check `stack/logs/`
3. **Respect the architecture** - SolidStack = control plane
4. **Parse output intelligently** - Extract useful info
5. **Explain to user** - Translate technical details

### Quick Decision Tree

```
User asks about server
├─ Is SolidStack installed?
│  ├─ Yes: Run status check
│  │  ├─ Parse output
│  │  └─ Respond with summary
│  └─ No: Use direct docker commands
│     └─ Offer to install SolidStack
│
├─ User wants to deploy?
│  ├─ Check prerequisites via status
│  ├─ Verify tools available
│  └─ Proceed or install missing tools
│
└─ Something broken?
   ├─ Check status
   ├─ Review logs
   ├─ Compare reports
   └─ Identify and explain issue
```

### Remember

- SolidStack makes YOUR job easier by organizing everything
- Logs are timestamped and searchable
- Reports are snapshot in time
- Everything is designed to be AI-readable
- When in doubt, run `status` first

---

## Contact & Updates

- **Repository:** https://github.com/aperecko/solidstack
- **Documentation:** ~/.solidstack/repo/docs/
- **Issues:** https://github.com/aperecko/solidstack/issues

Keep this guide handy when SSH'd into servers with SolidStack installed!
