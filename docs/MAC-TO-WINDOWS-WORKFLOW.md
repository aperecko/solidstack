# 🍎 ➜ 🪟 Mac to Windows Server: Complete Guide

**Your Setup:** Mac (development) → Windows Server "SRV" (execution)
**Goal:** Work from Mac, execute on Windows, coordinate with AI

---

## 🎯 Understanding Your Architecture

### The Setup
```
┌──────────────────────────────────────┐
│  YOUR MAC (Primary Workspace)       │
│  ├─ Git repository (edit code)      │
│  ├─ Documentation (write docs)      │
│  ├─ AI chat sessions (Claude)       │
│  └─ SSH client (remote access)      │
└──────────────┬───────────────────────┘
               │ SSH / Git sync
               ▼
┌──────────────────────────────────────┐
│  WINDOWS SERVER "SRV"                │
│  ├─ PowerShell 7                     │
│  ├─ SolidStack (C:\SolidStack\)      │
│  ├─ Docker Desktop                   │
│  ├─ 1Password CLI (op.exe)           │
│  └─ Your containers (services)       │
└──────────────────────────────────────┘
```

### Key Principle
**You work on Mac. Commands execute on Windows.**

---

## 🚀 Complete Setup Guide

### Step 1: Mac Prerequisites

```bash
# Check if you have SSH (you do, it's built-in)
ssh -V

# Check if you have Git
git --version

# If not, install:
xcode-select --install

# Optional but recommended: Install better tools
brew install --cask iterm2          # Better terminal
brew install --cask visual-studio-code  # VS Code
```

### Step 2: Set Up SSH Connection

#### Create SSH Key (if you don't have one)
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Press Enter for default location (~/.ssh/id_ed25519)
# Optional: Set passphrase for extra security
```

#### Copy Key to Windows Server
```bash
# Method 1: Using ssh-copy-id (if available)
ssh-copy-id administrator@srv

# Method 2: Manual copy
cat ~/.ssh/id_ed25519.pub
# Then on Windows:
# Add the output to C:\Users\Administrator\.ssh\authorized_keys
```

#### Configure SSH for Easy Access
Create or edit `~/.ssh/config`:
```bash
nano ~/.ssh/config
```

Add this:
```
Host srv
    HostName srv.yourdomain.com  # or IP address
    User administrator
    IdentityFile ~/.ssh/id_ed25519
    ForwardAgent yes
```

Now you can connect with just:
```bash
ssh srv
```

### Step 3: Clone SolidStack on Your Mac

```bash
# Create projects directory
mkdir -p ~/projects
cd ~/projects

# Clone the repository
git clone https://github.com/aperecko/solidstack.git
cd solidstack

# Set up your git identity
git config user.name "Your Name"
git config user.email "your@email.com"
```

### Step 4: Install VS Code Remote SSH (Recommended)

```bash
# Open VS Code
code .

# Install "Remote - SSH" extension
# Cmd+Shift+P → "Install Extension" → "Remote - SSH"

# Connect to server
# Cmd+Shift+P → "Remote-SSH: Connect to Host" → "srv"
```

---

## 🔄 Your Daily Workflows

### Workflow A: Quick Command Execution

**Use Case:** Check status, run reports, quick tasks

```bash
# From your Mac terminal

# Run single command on server
ssh srv "pwsh -File C:\SolidStack\repo\src\solidstack.ps1 status"

# View latest report
ssh srv "pwsh -File C:\SolidStack\repo\src\solidstack.ps1 report latest"

# Check git status
ssh srv "cd C:\SolidStack\repo; git status"
```

**Create aliases for this** (add to `~/.zshrc` or `~/.bash_profile`):
```bash
alias srv-status='ssh srv "pwsh -File C:\SolidStack\repo\src\solidstack.ps1 status"'
alias srv-report='ssh srv "pwsh -File C:\SolidStack\repo\src\solidstack.ps1 report latest"'
alias srv-git='ssh srv "cd C:\SolidStack\repo; git status"'
alias srv-pr='ssh srv "cd C:\SolidStack\repo; pwsh .\check-git-status.ps1"'
```

Then just:
```bash
srv-status  # Instant status!
srv-pr      # Check PR status!
```

### Workflow B: Interactive Session

**Use Case:** Multiple commands, exploratory work

```bash
# Connect to server
ssh srv

# Now you're on Windows - use PowerShell
cd C:\SolidStack\repo

# Run commands
pwsh .\check-git-status.ps1
pwsh .\src\solidstack.ps1 status
git log --oneline -10

# When done
exit

# Back on your Mac
```

### Workflow C: Edit Code on Mac, Execute on Server

**Use Case:** Development work

**On Mac:**
```bash
cd ~/projects/solidstack

# Edit files with any editor
code src/commands/status.ps1         # VS Code
vim docs/ARCHITECTURE.md             # Vim
open -a TextEdit README.md           # Mac text editor

# Commit changes
git add .
git commit -m "Add: new feature"
git push
```

**On Server (via SSH):**
```bash
ssh srv
cd C:\SolidStack\repo
git pull
pwsh .\src\solidstack.ps1 status  # Test your changes
exit
```

### Workflow D: VS Code Remote (BEST!)

**Use Case:** Best of both worlds - Mac UI, Windows execution

1. **Open VS Code on Mac**
2. **Cmd+Shift+P** → "Remote-SSH: Connect to Host" → "srv"
3. **File → Open Folder** → `C:\SolidStack\repo`
4. **Edit files in VS Code** (runs on your Mac)
5. **Terminal is on Windows** (Ctrl+` to open)
6. **Run commands** in the integrated terminal:
   ```powershell
   pwsh .\check-git-status.ps1
   pwsh .\src\solidstack.ps1 status
   ```

**Advantages:**
- ✅ Edit with Mac UI (nice!)
- ✅ Execute on Windows (where it should run!)
- ✅ Git operations happen on Windows
- ✅ No sync issues
- ✅ Terminal is already on the server

---

## 🤖 AI Session Coordination (Mac Edition)

### The Challenge
You're on Mac chatting with AI (like Claude), but commands need to run on Windows Server.

### The Solution: AI as Remote Controller

**Your AI session becomes a remote control for the Windows server!**

#### Pattern 1: AI Gives You Commands to Run

**AI says:**
```
Run this on your server:
pwsh .\check-git-status.ps1
```

**You do:**
```bash
# From Mac
ssh srv "cd C:\SolidStack\repo; pwsh .\check-git-status.ps1"

# Or connect and run
ssh srv
cd C:\SolidStack\repo
pwsh .\check-git-status.ps1
exit
```

**Then paste output back to AI**

#### Pattern 2: AI Gives You PowerShell Scripts

**AI creates a new file or updates existing code**

**On Mac:**
```bash
# Edit the file locally
cd ~/projects/solidstack
code src/lib/secrets.ps1  # AI tells you what to put in it
git add .
git commit -m "Add: secrets library"
git push
```

**Then on server:**
```bash
ssh srv
cd C:\SolidStack\repo
git pull
pwsh .\src\solidstack.ps1 status  # Test it
```

#### Pattern 3: AI Analyzes Server State

**Workflow:**
1. **Get server state:** `ssh srv "pwsh .\check-git-status.ps1"`
2. **Paste to AI:** Share the output
3. **AI analyzes:** Tells you what to do
4. **You execute:** Run AI's suggested commands on server
5. **Verify:** Get new state and confirm with AI

### Example: Complete AI Session Flow

**1. Start session with AI:**
```
Hi! I'm working on SolidStack from my Mac.
My Windows server is at: ssh srv

Context:
[Paste: ~/projects/solidstack/handoff/AI-HANDOFF-20260107.md]

Current server status:
[Run: ssh srv "cd C:\SolidStack\repo; pwsh .\check-git-status.ps1"]
[Paste output]

Goal: I want to implement the secrets.ps1 library
```

**2. AI gives you code:**
```powershell
# AI provides code for secrets.ps1
```

**3. You implement on Mac:**
```bash
cd ~/projects/solidstack
code src/lib/secrets.ps1
# Paste AI's code
git add src/lib/secrets.ps1
git commit -m "Add: secrets library from AI session"
git push
```

**4. Test on server:**
```bash
ssh srv
cd C:\SolidStack\repo
git pull
pwsh .\src\solidstack.ps1 status  # Test it
```

**5. Report back to AI:**
```
Implemented and tested! Here's the output:
[Paste test output]

What's next?
```

---

## 📂 File Sync Strategy

### Option 1: Git Push/Pull (Recommended)

**Workflow:**
```
Mac: Edit → Commit → Push to GitHub
                       ↓
                   GitHub repo
                       ↓
Server: Pull ← Execute ← Test
```

**Advantages:**
- ✅ Version controlled
- ✅ Always have backup
- ✅ Clear history
- ✅ Can work offline on Mac

**Commands:**
```bash
# On Mac
git add .
git commit -m "Your changes"
git push

# On Server
ssh srv "cd C:\SolidStack\repo; git pull"
```

### Option 2: VS Code Remote SSH (Also Recommended)

**Workflow:**
```
Mac: VS Code UI → Direct file editing on server
Server: Files update immediately (no git needed)
```

**Advantages:**
- ✅ Instant sync
- ✅ No git commands needed
- ✅ Terminal is already there
- ✅ Best for rapid iteration

**Setup:**
```bash
# Just connect via Remote-SSH in VS Code
# Edit files directly on server
# Save = instant update
```

### Option 3: scp/rsync (For Quick Copies)

**For one-off file transfers:**
```bash
# Copy TO server
scp ~/projects/solidstack/src/lib/secrets.ps1 srv:C:/SolidStack/repo/src/lib/

# Copy FROM server
scp srv:C:/SolidStack/reports/status-latest.txt ~/Desktop/
```

---

## 🔐 1Password Access (Mac ➜ Windows)

### The Setup

**1Password is installed on Windows server:**
- `C:\SolidStack\tools\op.exe`

**How to use from Mac:**

#### Option 1: Run op on Server via SSH
```bash
# Check 1Password status from Mac
ssh srv "C:\SolidStack\tools\op.exe account list"

# Get a secret from Mac
ssh srv "C:\SolidStack\tools\op.exe read 'op://SolidStack/postgres-password/password'"
```

#### Option 2: Install 1Password on Mac (Optional)
```bash
# Install 1Password app on Mac
# Download from: https://1password.com/downloads/mac/

# Install op CLI on Mac
brew install --cask 1password-cli

# Sign in (one time)
op signin

# Now you can test secrets locally before deploying to server
op read "op://SolidStack/test-secret/password"
```

**Note:** Server and Mac can both use the same 1Password vault!

---

## 🎓 Learning to Work Remotely

### Mental Model

Think of it like this:
```
Mac = Your Desk (where you sit)
Server = The Workshop (where work happens)
SSH = Walking to the workshop

You can:
1. Walk to workshop (ssh srv)
2. Send instructions (ssh srv "command")
3. Use remote control (VS Code Remote SSH)
```

### Common Mistakes

❌ **Editing files on Mac, expecting them on server automatically**
✅ **Use git push/pull OR VS Code Remote SSH**

❌ **Running PowerShell commands on Mac**
✅ **Run them via SSH on server**

❌ **Forgetting to pull latest code on server**
✅ **Always pull before testing**

---

## 🛠️ Tools for Mac

### Essential (Free)
```bash
# Built-in
ssh              # Remote access
git              # Version control
Terminal/iTerm2  # Command line

# Download
VS Code          # Best editor + Remote SSH
```

### Recommended (Free)
```bash
brew install --cask iterm2           # Better terminal
brew install --cask visual-studio-code  # Editor
brew install gh                      # GitHub CLI
brew install --cask 1password-cli    # If using 1Password on Mac too
```

### Optional (Nice to Have)
```bash
brew install --cask github-desktop   # Git GUI
brew install tmux                    # Terminal multiplexer
brew install ripgrep                 # Better grep
brew install fzf                     # Fuzzy finder
```

---

## 📋 Quick Reference Card

### From Mac Terminal

```bash
# Connect
ssh srv

# Quick commands (one-liners)
ssh srv "cd C:\SolidStack\repo; pwsh .\check-git-status.ps1"
ssh srv "cd C:\SolidStack\repo; pwsh .\src\solidstack.ps1 status"

# With aliases (after setup)
srv-status
srv-pr
srv-git
```

### Edit → Deploy Cycle

```bash
# On Mac
cd ~/projects/solidstack
code src/lib/secrets.ps1     # Edit
git add .                     # Stage
git commit -m "Update"        # Commit
git push                      # Push to GitHub

# On Server
ssh srv "cd C:\SolidStack\repo; git pull"
ssh srv "cd C:\SolidStack\repo; pwsh .\src\solidstack.ps1 status"
```

### AI Session Flow

```bash
# 1. Get status from server
ssh srv "cd C:\SolidStack\repo; pwsh .\check-git-status.ps1" > status.txt

# 2. Share with AI
# Paste: handoff doc + status.txt

# 3. AI gives you code/commands

# 4. Implement on Mac
code src/lib/secrets.ps1  # Paste AI code
git add . && git commit -m "From AI" && git push

# 5. Deploy to server
ssh srv "cd C:\SolidStack\repo; git pull"

# 6. Test
ssh srv "cd C:\SolidStack\repo; pwsh .\src\solidstack.ps1 status"

# 7. Report back to AI
```

---

## 🎯 Your Specific Setup Commands

### One-Time Setup (Do These Now)

```bash
# 1. Configure SSH
cat > ~/.ssh/config << 'EOF'
Host srv
    HostName [YOUR_SERVER_IP_OR_HOSTNAME]
    User administrator
    IdentityFile ~/.ssh/id_ed25519
EOF

# 2. Test connection
ssh srv "echo 'Connection successful!'"

# 3. Clone repo on Mac
cd ~/projects
git clone https://github.com/aperecko/solidstack.git
cd solidstack

# 4. Create aliases
cat >> ~/.zshrc << 'EOF'
# SolidStack aliases
alias srv-status='ssh srv "cd C:\SolidStack\repo; pwsh .\check-git-status.ps1"'
alias srv-report='ssh srv "cd C:\SolidStack\repo; pwsh .\src\solidstack.ps1 report latest"'
alias srv-git='ssh srv "cd C:\SolidStack\repo; git status"'
alias srv-connect='ssh srv'
EOF

source ~/.zshrc

# 5. Test everything
srv-status
```

---

## 🎭 Theater Analogy (Mac Edition)

```
🍎 YOUR MAC = Director's Office
   ├─ Review scripts (code)
   ├─ Plan performances (docs)
   ├─ Give direction (AI chat)
   └─ Remote communication (SSH)

   📞 Phone line (SSH)
   
🪟 WINDOWS SERVER = Concert Hall  
   ├─ 🎼 Conductor (SolidStack)
   ├─ 🎻 Orchestra (Containers)
   └─ 🏛️ The building (Server)

You're the director calling instructions to the conductor!
```

---

## Summary

**What you do on Mac:**
- ✅ Edit code (any editor)
- ✅ Write documentation
- ✅ Chat with AI for help
- ✅ Commit to Git
- ✅ Push to GitHub

**What happens on Windows Server:**
- ✅ Pull from GitHub
- ✅ Execute PowerShell commands
- ✅ Run Docker containers
- ✅ Access 1Password secrets
- ✅ Generate logs/reports

**How they connect:**
- 📡 SSH (remote terminal access)
- 📡 Git (code synchronization)
- 📡 VS Code Remote SSH (best option!)

**You never need PowerShell on your Mac!** Everything runs on the Windows server where it should.

---

## Next Steps

1. **Set up SSH connection** (see commands above)
2. **Clone repo on Mac** (`git clone ...`)
3. **Install VS Code + Remote SSH** (optional but amazing)
4. **Create aliases** for quick commands
5. **Test the workflow** with a simple edit

Then you'll be ready to coordinate AI sessions from your Mac while executing on Windows!

Would you like help with any of these steps?
