# Using SolidStack from macOS

**Question:** Do I need PowerShell on my Mac to use SolidStack?  
**Answer:** NO! You have multiple options.

---

## Option 1: SSH Directly to Servers (Recommended)

**You don't need PowerShell locally at all!**

```bash
# From your Mac, SSH to the server
ssh user@your-server

# Once on the server, use SolidStack there
pwsh -File ~/.solidstack/bin/solidstack.ps1 status
```

**This is the normal workflow:**
1. Work on your Mac (Git, editing docs, etc.)
2. SSH to server when you need to run commands
3. SolidStack runs ON the server (where it should be)

### Why This Works

```
Your Mac                          Your Server
┌─────────────────┐              ┌─────────────────┐
│                 │   SSH →      │  PowerShell 7+  │
│  No PowerShell  │              │  SolidStack     │
│  needed here!   │              │  Docker         │
│                 │              │  (everything)   │
└─────────────────┘              └─────────────────┘
```

**The conductor (SolidStack) lives in the concert hall (server), not in your house (Mac)!** 🎭

---

## Option 2: Use Git Normally on Mac

**For development work:**

```bash
# On your Mac (no PowerShell needed)
cd ~/projects
git clone https://github.com/aperecko/solidstack.git
cd solidstack

# Edit files with your favorite Mac tools
code docs/ROADMAP.md          # VS Code
vim src/commands/status.ps1   # Vim
open -a TextEdit README.md    # TextEdit

# Commit changes
git add .
git commit -m "Updated docs"
git push

# That's it! No PowerShell needed!
```

**Then on your server:**
```bash
# SSH to server
ssh user@your-server

# Pull latest changes
cd ~/.solidstack/repo
git pull

# Now the server has your updates!
```

---

## Option 3: Remote VS Code (Best of Both Worlds)

**Edit on Mac, run on server:**

1. Install VS Code on Mac
2. Install "Remote - SSH" extension
3. Connect to your server via SSH
4. Edit files as if they're local, but they run on the server!

```bash
# In VS Code, connect to server
# Terminal opens on the server automatically
# Run SolidStack commands in that terminal
pwsh -File ~/.solidstack/bin/solidstack.ps1 status
```

---

## Option 4: If You REALLY Want PowerShell on Mac

**Only if you want to test/develop locally:**

```bash
# Install PowerShell on macOS
brew install --cask powershell

# Then you can test scripts locally
pwsh C:\SolidStack\repo\test\test-platform.ps1
```

**But honestly, you probably don't need this!**

---

## Your Typical Workflow (Mac User)

### Day-to-Day Operations

```bash
# On your Mac
ssh user@server

# Now you're on the server - use SolidStack
pwsh -File ~/.solidstack/bin/solidstack.ps1 status
pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest

# Exit when done
exit

# Back on your Mac
```

### Documentation/Code Changes

```bash
# On your Mac (no SSH needed)
cd ~/projects/solidstack
vim docs/ROADMAP.md
git commit -am "Updated roadmap"
git push

# That's it! Server can pull later.
```

### Deploying Changes to Server

```bash
# SSH to server
ssh user@server

# Pull latest
cd ~/.solidstack/repo
git pull

# Changes are now live on server!
```

---

## What You Actually Need on Your Mac

### Required
- ✅ **SSH client** (built into macOS)
- ✅ **Git** (comes with Xcode Command Line Tools)
- ✅ **Text editor** (TextEdit, VS Code, whatever you like)

### Optional
- ⭐ **VS Code** + Remote SSH extension (highly recommended!)
- ⭐ **GitHub Desktop** (if you prefer GUI for Git)
- ⭐ **iTerm2** (better terminal than default)

### NOT Required
- ❌ PowerShell (unless you want to test locally)
- ❌ Docker Desktop (unless you want to test locally)
- ❌ Windows (obviously!)

---

## Common Mac Workflows

### Workflow 1: Quick Status Check

```bash
# From Mac terminal
ssh user@server "pwsh -File ~/.solidstack/bin/solidstack.ps1 status"

# Output shows on your Mac, runs on server
```

### Workflow 2: Interactive Session

```bash
# Open SSH session
ssh user@server

# Run multiple commands
pwsh -File ~/.solidstack/bin/solidstack.ps1 status
pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest
docker ps

# Exit when done
exit
```

### Workflow 3: VS Code Remote

```
1. Open VS Code on Mac
2. Connect to server via Remote-SSH
3. Terminal automatically opens on server
4. Edit files in VS Code (nice GUI)
5. Run commands in integrated terminal
6. Everything happens on server!
```

---

## Installing Git on Mac (If Needed)

```bash
# Check if Git is installed
git --version

# If not installed, install Xcode Command Line Tools
xcode-select --install

# Or use Homebrew
brew install git
```

---

## SSH Key Setup (Recommended)

**Make SSH easier without passwords:**

```bash
# On your Mac, generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy to server
ssh-copy-id user@your-server

# Now you can SSH without password!
ssh user@server
```

---

## Example: Full Development Session

**On your Mac:**
```bash
# 1. Make changes locally
cd ~/projects/solidstack
vim docs/QUICKSTART.md
git commit -am "Improved quickstart guide"
git push

# 2. SSH to server
ssh user@server

# 3. Pull changes
cd ~/.solidstack/repo
git pull

# 4. Test the changes
pwsh -File ~/.solidstack/bin/solidstack.ps1 status

# 5. Verify it works
cat docs/QUICKSTART.md  # See your changes

# 6. Exit
exit

# Back on Mac - done!
```

**No PowerShell on Mac needed at any point!**

---

## The Theater Analogy (Mac Edition)

```
┌─────────────────────────────────────────────────┐
│  YOUR MAC (Your Office)                         │
│  ├─ Edit sheet music (code)                    │
│  ├─ Review recordings (logs)                   │
│  └─ Plan performances (planning)               │
└─────────────────────────────────────────────────┘
                    ↓ SSH
┌─────────────────────────────────────────────────┐
│  SERVER (Concert Hall)                          │
│  🎼 Conductor = SolidStack                      │
│  🎻 Orchestra = Docker Containers               │
│  🏛️ Building = Server OS                        │
└─────────────────────────────────────────────────┘
```

**You (on Mac) = Director giving instructions**  
**SolidStack (on server) = Conductor executing them**

You don't need to BE the conductor - you just need to communicate with them!

---

## macOS-Specific Tips

### Better Terminal Experience

```bash
# Install iTerm2 (much better than default Terminal)
brew install --cask iterm2

# Or use built-in Terminal with custom profile
# Preferences → Profiles → Create new profile
```

### SSH Config for Easy Access

Edit `~/.ssh/config`:
```
Host myserver
    HostName your-server.com
    User your-username
    IdentityFile ~/.ssh/id_ed25519
```

Now you can just type:
```bash
ssh myserver
```

### Aliases for Common Commands

Add to `~/.zshrc` (or `~/.bash_profile`):
```bash
# SSH aliases
alias sshserver="ssh user@your-server"

# SolidStack remote commands
alias server-status="ssh user@server 'pwsh -File ~/.solidstack/bin/solidstack.ps1 status'"
alias server-report="ssh user@server 'pwsh -File ~/.solidstack/bin/solidstack.ps1 report latest'"
```

Then just type:
```bash
server-status    # Runs status on server from Mac!
server-report    # Gets latest report!
```

---

## When You WOULD Want PowerShell on Mac

**Only if you want to:**
- Test SolidStack changes locally before pushing
- Develop new commands offline
- Run the test suite locally
- Learn PowerShell scripting

**But for normal SolidStack usage? Not needed!**

---

## Summary for Mac Users

### ✅ What You Can Do on Mac

- Edit code/docs (any text editor)
- Commit to Git
- Push to GitHub
- SSH to servers
- Run SolidStack commands remotely
- Review logs and reports
- Plan deployments

### ❌ What You DON'T Need on Mac

- PowerShell
- Docker Desktop (unless testing locally)
- Windows VM
- Complex setup

### 🎯 Your Workflow

```
Mac: Edit → Commit → Push
        ↓
    GitHub
        ↓
Server: Pull → Run SolidStack → Deploy
```

**Simple, clean, no PowerShell on Mac needed!** ✨

---

## Quick Reference

### From Mac Terminal

```bash
# Connect to server
ssh user@server

# Once connected, use SolidStack
pwsh -File ~/.solidstack/bin/solidstack.ps1 status

# Or run remotely in one line
ssh user@server "pwsh -File ~/.solidstack/bin/solidstack.ps1 status"
```

### Managing Code

```bash
# Work happens on Mac
git clone https://github.com/aperecko/solidstack.git
cd solidstack
# edit files
git commit -am "changes"
git push

# Updates deployed to server
ssh user@server
cd ~/.solidstack/repo
git pull
```

**That's it! Mac-friendly, no PowerShell required! 🍎**
