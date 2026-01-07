# 🎯 Quick Reference Card

Keep this handy! One-page reference for daily SolidStack use.

## ⚡ Most Common Commands

```powershell
# Check system status
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# View latest report
pwsh -File C:\SolidStack\bin\solidstack.ps1 report latest

# List all reports
pwsh -File C:\SolidStack\bin\solidstack.ps1 report list
```

## 🗂️ Important Locations

```
C:\SolidStack\bin\solidstack.ps1     → Main script
C:\SolidStack\repo\                  → Git repository
C:\SolidStack\stack\logs\            → Log files
C:\SolidStack\reports\               → Status reports
C:\SolidStack\docs\                  → Documentation
```

## 📚 Essential Docs

| Need to...                    | Read this...              |
|-------------------------------|---------------------------|
| Get started                   | docs/QUICKSTART.md        |
| Understand structure          | docs/MAP.md               |
| Set up GitHub                 | docs/GITHUB-SETUP.md      |
| Make changes                  | repo/CONTRIBUTING.md      |
| See what's next               | docs/ROADMAP.md           |
| Find any doc                  | docs/INDEX.md             |

## 🔧 Git Workflow (Daily)

```powershell
cd C:\SolidStack\repo

git status                          # What changed?
git add .                           # Stage everything
git commit -m "description"         # Save with message
git push                            # Upload to GitHub
```

## 📊 Viewing Logs

```powershell
# Most recent log
Get-ChildItem C:\SolidStack\stack\logs\*.log | 
  Sort-Object LastWriteTime -Descending | 
  Select-Object -First 1 | 
  Get-Content

# Last 20 lines of recent log
Get-ChildItem C:\SolidStack\stack\logs\*.log | 
  Sort-Object LastWriteTime -Descending | 
  Select-Object -First 1 | 
  Get-Content -Tail 20
```

## 🐛 Troubleshooting

| Problem                           | Solution                                                    |
|-----------------------------------|-------------------------------------------------------------|
| "Command not found"               | Use `pwsh` not `powershell`                                |
| "Requires PowerShell 7+"          | Run `C:\SolidStack\tools\install-pwsh.ps1`                 |
| "Execution policy"                | Use `-File` parameter                                      |
| Git authentication failed         | Use GitHub CLI: `gh auth login`                            |
| Changes not pushing               | Run `git remote -v` to check remote URL                    |

## 🚀 GitHub Setup (Quick)

```powershell
# Install GitHub CLI
winget install --id GitHub.cli

# Authenticate
gh auth login

# Create repo and push
cd C:\SolidStack\repo
gh repo create solidstack --public --source=. --remote=origin
git push -u origin master
```

## 📝 Git Cheat Sheet

```powershell
git status                  # See what changed
git diff                    # See actual changes
git log --oneline -10       # Recent commits
git remote -v               # Where am I pushing?
gh repo view --web          # Open repo in browser
```

## 🔍 Finding Help

1. **docs/INDEX.md** - Master documentation index
2. **Stack logs** - C:\SolidStack\stack\logs\
3. **GitHub Issues** - After setup
4. **AI Assistants** - Copy/paste logs to ChatGPT/Claude

## ⚙️ Settings & Config

```
Repository:    C:\SolidStack\repo
Logs:          C:\SolidStack\stack\logs\
Reports:       C:\SolidStack\reports\
Secrets:       C:\SolidStack\stack\secrets\  (never committed!)
Tools:         C:\SolidStack\tools\
```

## 🎓 For Beginners

**Don't know Git?** 
→ Read docs/GITHUB-SETUP.md

**Not a programmer?**
→ Read repo/CONTRIBUTING.md

**Need structure overview?**
→ Read docs/MAP.md

**Want to start now?**
→ Read docs/QUICKSTART.md

## 📞 Emergency Commands

```powershell
# Verify PowerShell version
pwsh -v

# Test if SolidStack works
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# Check what's in git
cd C:\SolidStack\repo
git status

# Undo last commit (keep changes)
git reset --soft HEAD~1

# See recent history
git log --oneline -10
```

## 💾 Backup Reminder

✅ **In Git** (safe):
- Source code (.ps1 files)
- Documentation (.md files)
- Configuration templates

❌ **Not in Git** (local only):
- stack/secrets/ ← IMPORTANT!
- stack/data/
- stack/logs/
- reports/

## 🎯 Next Actions

- [ ] Install PowerShell 7+ (if needed)
- [ ] Test: `pwsh -File C:\SolidStack\bin\solidstack.ps1 status`
- [ ] Set up GitHub (docs/GITHUB-SETUP.md)
- [ ] Create first issue
- [ ] Make your first commit

---

**Print this page or bookmark it! 📌**

For full details, see:
- Master index: docs/INDEX.md
- Quick start: docs/QUICKSTART.md
- Visual guide: docs/MAP.md
