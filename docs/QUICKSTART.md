# 🚀 Quick Start Guide

Get SolidStack up and running in 5 minutes!

## 🎭 First: Understand the Theater Analogy

**Before installing, understand what SolidStack is:**

Read: [THEATER-ANALOGY.md](THEATER-ANALOGY.md) 🎭 (5 minutes)

**Quick version:**
- 🏛️ SolidStack = The conductor (orchestrates everything)
- 🎻 Docker Containers = The orchestra (your services)  
- 🎼 Compose Files = Sheet music (in Git)

**The conductor stands IN FRONT, not in a box on stage!**

---

## Step 1: Install PowerShell 7+

Open **Windows PowerShell** (the old one) and run:

```powershell
powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1
```

**Then close and reopen your terminal.**

Verify it worked:
```powershell
pwsh -v
# Should show: PowerShell 7.x.x
```

## Step 2: Test SolidStack

Run your first command:

```powershell
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
```

You should see:
- ✅ List of tools (docker, git, etc.)
- ✅ A status report
- ✅ Log file location

## Step 3: Check the Logs

```powershell
Get-ChildItem C:\SolidStack\stack\logs\*.log | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content
```

This shows the most recent log file.

## Step 4: View Latest Report

```powershell
pwsh -File C:\SolidStack\bin\solidstack.ps1 report latest
```

## Step 5 (Optional): Set Up GitHub

Follow the guide in `docs/GITHUB-SETUP.md` to:
- Create a GitHub repository
- Push your code
- Enable issue tracking
- Get full version control

**Quick version with GitHub CLI:**
```powershell
cd C:\SolidStack\repo
gh auth login
gh repo create solidstack --public --source=. --remote=origin
git push -u origin master
```

## What's Next?

### Learn More
- Read `docs/CONTEXT-CAPSULE.md` for an overview
- Check `docs/ROADMAP.md` for upcoming features
- See `CONTRIBUTING.md` to learn how to make changes

### Explore Commands
```powershell
# Get help
pwsh -File C:\SolidStack\bin\solidstack.ps1 help

# Check status
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# List all reports
pwsh -File C:\SolidStack\bin\solidstack.ps1 report list

# Show a specific report
pwsh -File C:\SolidStack\bin\solidstack.ps1 report show <path>
```

### Make Changes
1. Edit files in `C:\SolidStack\repo`
2. Test: `pwsh -File C:\SolidStack\bin\solidstack.ps1 status`
3. Commit: `cd C:\SolidStack\repo && git add . && git commit -m "message"`
4. Push: `git push` (if using GitHub)

## Troubleshooting

### "Command not found"
Make sure you're using `pwsh` (PowerShell 7+), not `powershell` (old version).

### "Execution policy" error
Run with `-File` parameter:
```powershell
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
```

### "Docker not found"
Install Docker Desktop from: https://www.docker.com/products/docker-desktop/

### Still stuck?
1. Check the logs in `C:\SolidStack\stack\logs\`
2. Create an issue on GitHub (if you set it up)
3. Copy/paste the error + logs to ChatGPT or Claude for help

## Tips for Non-Programmers

- **Don't panic!** Everything is logged, so you can always see what happened
- **Experiment safely** - Git tracks everything, so you can undo mistakes
- **Read the logs** - They're designed to be human-readable
- **Ask AI for help** - Copy/paste logs to ChatGPT or Claude
- **Take it slow** - You don't need to understand everything at once

## Daily Workflow

```powershell
# 1. Check status
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# 2. Make changes to files in C:\SolidStack\repo

# 3. Test changes
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# 4. If using Git/GitHub:
cd C:\SolidStack\repo
git status                          # See what changed
git add .                           # Stage changes
git commit -m "describe changes"    # Save changes
git push                            # Upload to GitHub
```

---

**You're all set! Welcome to SolidStack! 🎉**

For more details, see the full documentation in the `docs/` folder.
