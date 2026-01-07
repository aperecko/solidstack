# 🗺️ SolidStack Map

A visual guide to understanding how SolidStack is organized.

## The Big Picture

```
YOU run commands
    ↓
bin/solidstack.ps1 (main entry point)
    ↓
repo/src/solidstack.ps1 (routes to commands)
    ↓
repo/src/commands/*.ps1 (does the work)
    ↓
Logs everything to stack/logs/
Saves reports to reports/
```

## Directory Map

```
C:\SolidStack\                    ← Root folder
│
├── 📁 bin\                       ← What you run
│   ├── solidstack.ps1           ← Main script
│   └── ss.ps1                   ← Shortcut version
│
├── 📁 repo\                      ← Git repository (version controlled)
│   ├── 📁 .github\              ← GitHub configuration
│   │   └── ISSUE_TEMPLATE\     ← Templates for reporting issues
│   ├── 📁 src\                  ← Source code
│   │   ├── solidstack.ps1      ← Router script
│   │   ├── 📁 commands\         ← Individual commands
│   │   │   ├── status.ps1      ← Check system status
│   │   │   └── report.ps1      ← Manage reports
│   │   └── 📁 lib\              ← Shared libraries
│   │       └── logging.ps1     ← Logging functions
│   ├── 📁 docs\                 ← Additional docs
│   ├── README.md               ← Main project description
│   ├── CONTRIBUTING.md         ← How to contribute
│   └── LICENSE                 ← MIT License
│
├── 📁 docs\                     ← User documentation
│   ├── QUICKSTART.md           ← Start here!
│   ├── GITHUB-SETUP.md         ← GitHub guide
│   ├── CONTEXT-CAPSULE.md      ← Project overview
│   └── ROADMAP.md              ← Future plans
│
├── 📁 stack\                    ← Runtime files (NOT in git)
│   ├── 📁 compose\              ← Docker Compose files
│   ├── 📁 config\               ← Service configurations
│   ├── 📁 data\                 ← Docker volumes
│   ├── 📁 logs\                 ← Command logs ⭐
│   └── 📁 secrets\              ← Sensitive data (never committed!)
│
├── 📁 reports\                  ← Status reports (NOT in git)
│   └── status-*.txt            ← Timestamped reports
│
├── 📁 tools\                    ← Helper tools
│   ├── install-pwsh.ps1        ← PowerShell 7+ installer
│   ├── op.exe                  ← 1Password CLI
│   └── rclone.exe              ← File sync tool
│
├── README.md                   ← Quick overview
└── .gitignore                  ← What NOT to commit

⭐ = Check here when troubleshooting
```

## How Commands Flow

### Example: Running Status Command

```
1. You type:
   pwsh -File C:\SolidStack\bin\solidstack.ps1 status

2. bin/solidstack.ps1 receives "status"
   ├── Checks PowerShell version (must be 7+)
   └── Routes to: repo/src/commands/status.ps1

3. status.ps1 runs:
   ├── Loads lib/logging.ps1
   ├── Creates timestamped log file
   ├── Checks for tools (docker, git, etc.)
   ├── Writes findings to log
   ├── Creates report in reports/
   └── Shows results on screen

4. You see:
   ├── Tool status (found/missing)
   ├── Report content
   └── Log file location
```

## What Goes Where?

### ✅ Committed to Git (in `repo/`)
- Source code (`.ps1` files)
- Documentation (`.md` files)
- Configuration templates
- GitHub templates

### ❌ NOT Committed to Git
- `stack/secrets/` ← Sensitive data
- `stack/data/` ← Docker volumes
- `stack/logs/` ← Log files
- `reports/` ← Status reports
- `.env` files ← Environment variables

### Why Split repo/ and stack/?
- **repo/** = Your code (tracked in git)
- **stack/** = Runtime data (local only)

This keeps your repository clean and secrets safe!

## File Extensions Guide

- `.ps1` = PowerShell script (the actual code)
- `.md` = Markdown (documentation, human-readable)
- `.txt` = Plain text (logs, reports)
- `.log` = Log file (same as .txt, but specifically for logs)
- `.json` = Data file (structured information)

## Common Paths You'll Use

```powershell
# Run main script
C:\SolidStack\bin\solidstack.ps1

# Check recent log
C:\SolidStack\stack\logs\solidstack-status-TIMESTAMP.log

# Read latest report
C:\SolidStack\reports\status-TIMESTAMP.txt

# Edit source code
C:\SolidStack\repo\src\

# Read documentation
C:\SolidStack\docs\

# Git operations
cd C:\SolidStack\repo
```

## How Different Roles Use SolidStack

### 👤 As a User
```
You → bin/solidstack.ps1 → See results
         ↓
    Check logs in stack/logs/ if needed
```

### 👨‍💻 As a Developer
```
You → Edit repo/src/
    → Test with bin/solidstack.ps1
    → Check stack/logs/ for debugging
    → git commit & push
```

### 🤖 For AI Assistance
```
Copy logs from stack/logs/
    ↓
Paste to ChatGPT/Claude
    ↓
Get help understanding what happened
```

## Quick Reference

| Want to...              | Look here...                    |
|-------------------------|---------------------------------|
| Run a command           | `bin/solidstack.ps1`           |
| Understand what it does | `repo/README.md`               |
| See what happened       | `stack/logs/`                  |
| Make changes            | `repo/src/`                    |
| Learn how to use it     | `docs/QUICKSTART.md`           |
| Set up GitHub           | `docs/GITHUB-SETUP.md`         |
| Report a bug            | GitHub Issues                   |
| Add a feature           | `repo/CONTRIBUTING.md`         |
| Understand decisions    | `repo/docs/decisions.md`       |

---

**Now you know where everything is! 🗺️**

Start with `docs/QUICKSTART.md` to begin using SolidStack.
