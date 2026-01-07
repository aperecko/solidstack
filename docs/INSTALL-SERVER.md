# 🚀 Installing SolidStack on Your Server

**Target Server:** SRV (Windows Server)  
**Time Required:** ~10 minutes  
**Prerequisites:** Administrator access to SRV

---

## Quick Install (Copy/Paste Method)

### Step 1: Install PowerShell 7+ on SRV

Open PowerShell (as Administrator) on SRV:

```powershell
# Download and run PowerShell 7 installer
winget install --id Microsoft.Powershell --source winget
```

**Then close and reopen PowerShell to use pwsh!**

### Step 2: Clone SolidStack to SRV

```powershell
# Create directory structure
New-Item -ItemType Directory -Force -Path "C:\SolidStack"

# Clone from GitHub
cd C:\SolidStack
git clone https://github.com/aperecko/solidstack.git repo

# Set up additional directories
New-Item -ItemType Directory -Force -Path "C:\SolidStack\bin"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\stack\logs"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\stack\secrets"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\reports"

# Copy runner script to bin
Copy-Item "C:\SolidStack\repo\src\solidstack.ps1" "C:\SolidStack\bin\solidstack.ps1"
```

### Step 3: Test Installation

```powershell
# Run status check
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# You should see:
# - OS detected
# - Tools found/missing
# - Report generated
```

### Step 4: Install Missing Tools (if needed)

```powershell
# Install Docker Desktop
winget install Docker.DockerDesktop

# Install Git (if not already there)
winget install Git.Git

# Install GitHub CLI (optional but recommended)
winget install GitHub.cli

# Restart after Docker Desktop install!
```

---

## Manual Install (Step-by-Step)

### Prerequisites Check

On SRV, verify you have:
- [ ] Windows Server 2019+ or Windows 10/11
- [ ] Administrator access
- [ ] Internet connection
- [ ] Docker Desktop (or will install)

### 1. Install PowerShell 7+

**Option A - Using winget (Windows 11/Modern Server):**
```powershell
winget install --id Microsoft.Powershell --source winget
```

**Option B - Manual Download:**
1. Go to https://github.com/PowerShell/PowerShell/releases/latest
2. Download `PowerShell-7.x.x-win-x64.msi`
3. Run the installer
4. Accept defaults

**Verify:**
```powershell
pwsh -v
# Should show: PowerShell 7.x.x
```

### 2. Install Docker Desktop

**If not already installed:**
```powershell
winget install Docker.DockerDesktop
```

**Or manually:**
1. Download from https://www.docker.com/products/docker-desktop/
2. Run installer
3. Restart when prompted
4. Start Docker Desktop

**Verify:**
```powershell
docker version
# Should show client and server versions
```

### 3. Install Git

**If not already installed:**
```powershell
winget install Git.Git
```

**Or manually:**
1. Download from https://git-scm.com/download/win
2. Run installer
3. Accept defaults

**Verify:**
```powershell
git --version
# Should show: git version 2.x.x
```

### 4. Clone SolidStack

```powershell
# Create root directory
New-Item -ItemType Directory -Force -Path "C:\SolidStack"
cd C:\SolidStack

# Clone repository
git clone https://github.com/aperecko/solidstack.git repo

# Create runtime directories
New-Item -ItemType Directory -Force -Path "C:\SolidStack\bin"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\stack\logs"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\stack\secrets"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\stack\config"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\stack\compose"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\stack\data"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\reports"
New-Item -ItemType Directory -Force -Path "C:\SolidStack\tools"
```

### 5. Set Up Runner Script

```powershell
# Copy main script to bin
Copy-Item "C:\SolidStack\repo\src\solidstack.ps1" "C:\SolidStack\bin\solidstack.ps1"
```

### 6. Test Installation

```powershell
# Run status check
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
```

You should see:
- ✅ OS: Windows
- ✅ PowerShell 7+
- ✅ Tools detected
- ✅ Report generated

### 7. Optional Tools

```powershell
# 1Password CLI (for secrets management)
# Download from: https://1password.com/downloads/command-line/
# Extract op.exe to C:\SolidStack\tools\

# rclone (for backups)
# Download from: https://rclone.org/downloads/
# Extract rclone.exe to C:\SolidStack\tools\

# GitHub CLI (for better Git integration)
winget install GitHub.cli
```

---

## Directory Structure (After Install)

```
C:\SolidStack\
├── bin\
│   └── solidstack.ps1          ← Main runner script
├── repo\                       ← Git repository (your code)
│   ├── src\
│   ├── docs\
│   └── test\
├── stack\                      ← Runtime files (NOT in git)
│   ├── logs\                   ← Command logs
│   ├── secrets\                ← Sensitive data (git ignored)
│   ├── config\                 ← Service configs
│   ├── compose\                ← Docker Compose files
│   └── data\                   ← Docker volumes
├── reports\                    ← Status reports
└── tools\                      ← Optional tools (op, rclone)
```

---

## Verification Checklist

Run these commands to verify everything works:

```powershell
# 1. PowerShell version
pwsh -v
# Expected: PowerShell 7.x.x or higher

# 2. Docker
docker version
# Expected: Client and Server versions shown

# 3. Git
git --version
# Expected: git version 2.x.x

# 4. SolidStack status
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
# Expected: Status report with OS info, tools found

# 5. Check reports
Get-ChildItem C:\SolidStack\reports\
# Expected: status-*.txt files

# 6. Check logs
Get-ChildItem C:\SolidStack\stack\logs\
# Expected: solidstack-*.log files
```

---

## Common Issues & Solutions

### Issue: "winget not found"
**Solution:** You're on older Windows Server
```powershell
# Install PowerShell manually from:
# https://github.com/PowerShell/PowerShell/releases/latest
```

### Issue: "Docker not starting"
**Solution:** Check Docker Desktop
1. Open Docker Desktop
2. Wait for it to start (green icon in system tray)
3. Try `docker version` again

### Issue: "git clone fails"
**Solution:** Check network/firewall
```powershell
# Try HTTPS explicitly
git clone https://github.com/aperecko/solidstack.git repo

# Or check Git installation
git --version
```

### Issue: "Permission denied"
**Solution:** Run PowerShell as Administrator
1. Right-click PowerShell
2. "Run as Administrator"
3. Try commands again

### Issue: "Execution policy error"
**Solution:** Use `-File` parameter
```powershell
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
# NOT: pwsh C:\SolidStack\bin\solidstack.ps1 status
```

---

## Updating SolidStack

When there are updates on GitHub:

```powershell
# Navigate to repo
cd C:\SolidStack\repo

# Pull latest changes
git pull

# Update runner script
Copy-Item "C:\SolidStack\repo\src\solidstack.ps1" "C:\SolidStack\bin\solidstack.ps1" -Force

# Test it works
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
```

---

## Creating a Shortcut (Optional)

Make it easier to run:

```powershell
# Create function in your PowerShell profile
notepad $PROFILE

# Add this line:
function solidstack { pwsh -File C:\SolidStack\bin\solidstack.ps1 @args }

# Save and reload
. $PROFILE

# Now you can just type:
solidstack status
solidstack report latest
```

---

## Uninstalling (If Needed)

```powershell
# Stop any running containers
docker stop $(docker ps -q)

# Remove SolidStack
Remove-Item -Recurse -Force C:\SolidStack

# Uninstall Docker Desktop (optional)
winget uninstall Docker.DockerDesktop
```

---

## Next Steps After Installation

1. **Run status check:**
   ```powershell
   pwsh -File C:\SolidStack\bin\solidstack.ps1 status
   ```

2. **Read the docs:**
   ```powershell
   Get-Content C:\SolidStack\repo\docs\QUICKSTART.md
   ```

3. **Start deploying services** (coming soon):
   ```powershell
   solidstack deploy traefik
   solidstack deploy wordpress
   ```

---

## Support

- **Documentation:** `C:\SolidStack\repo\docs\`
- **Logs:** `C:\SolidStack\stack\logs\`
- **GitHub Issues:** https://github.com/aperecko/solidstack/issues
- **Test Suite:** `pwsh C:\SolidStack\repo\test\test-platform.ps1`

---

## Summary

**Minimum Install:**
```powershell
# 1. Install PowerShell 7
winget install Microsoft.Powershell

# 2. Clone repo
cd C:\SolidStack
git clone https://github.com/aperecko/solidstack.git repo

# 3. Create directories
New-Item -ItemType Directory -Force -Path C:\SolidStack\bin,C:\SolidStack\stack\logs,C:\SolidStack\reports

# 4. Copy runner
Copy-Item C:\SolidStack\repo\src\solidstack.ps1 C:\SolidStack\bin\

# 5. Test
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
```

**You're ready to go!** 🚀
