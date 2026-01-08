#!/bin/bash
# mac-setup.sh
# Complete Mac setup for SolidStack development
# No hardcoded IPs - clean and flexible

set -e  # Exit on error

echo "🍎 SolidStack Mac Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Prerequisites
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "📋 Checking prerequisites..."

if ! command -v git &> /dev/null; then
    echo "📦 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo ""
    echo "⏳ Please wait for installation to complete, then run this script again:"
    echo "   bash <(curl -fsSL https://raw.githubusercontent.com/aperecko/solidstack/powershell/mac-setup.sh)"
    exit 0
fi

echo "✅ Git found: $(git --version)"
echo "✅ SSH found: $(ssh -V 2>&1 | head -n1)"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SSH Key Setup
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "🔑 Generating SSH key..."
    ssh-keygen -t ed25519 -C "solidstack-mac" -f ~/.ssh/id_ed25519 -N ""
    echo "✅ SSH key generated"
    echo ""
    
    SHOW_KEY=true
else
    echo "✅ SSH key already exists"
    echo ""
    read -p "Show public key again? (y/N): " RESPONSE
    if [[ "$RESPONSE" =~ ^[Yy]$ ]]; then
        SHOW_KEY=true
    fi
fi

if [ "$SHOW_KEY" = true ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 YOUR SSH PUBLIC KEY:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat ~/.ssh/id_ed25519.pub
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📝 Add this key to Windows Server:"
    echo "   1. SSH to your server"
    echo "   2. mkdir C:\\Users\\Administrator\\.ssh"
    echo "   3. notepad C:\\Users\\Administrator\\.ssh\\authorized_keys"
    echo "   4. Paste the key above, save, close"
    echo ""
    read -p "Press Enter after adding the key to server..."
    echo ""
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# SSH Config
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [ -f ~/.ssh/config ]; then
    if ! grep -q "# BACKUP" ~/.ssh/config.backup.* 2>/dev/null; then
        cp ~/.ssh/config ~/.ssh/config.backup.$(date +%Y%m%d_%H%M%S)
        echo "✅ Backed up existing SSH config"
    fi
fi

if ! grep -q "Host srv" ~/.ssh/config 2>/dev/null; then
    echo "⚙️  Creating SSH config..."
    cat >> ~/.ssh/config << 'SSHCONFIG'

# SolidStack Windows Server
# EDIT the HostName below with your server address:
#   - Use hostname: srv.local (if mDNS working)
#   - Use IP: 192.168.1.100 (your server IP)
#   - Use domain: server.yourdomain.com
Host srv
    HostName EDIT_ME
    User administrator
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
SSHCONFIG
    chmod 600 ~/.ssh/config
    
    echo ""
    echo "⚠️  IMPORTANT: Edit SSH config now"
    echo ""
    read -p "Enter your Windows Server hostname or IP: " SERVER_ADDR
    
    if [ -n "$SERVER_ADDR" ]; then
        sed -i.bak "s/EDIT_ME/$SERVER_ADDR/" ~/.ssh/config
        rm ~/.ssh/config.bak
        echo "✅ SSH config updated with: $SERVER_ADDR"
    else
        echo "⚠️  You can edit manually later: nano ~/.ssh/config"
    fi
else
    echo "✅ SSH config already exists"
fi

echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Clone Repository
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "📦 Setting up Git repository..."

if [ -d ~/projects/solidstack ]; then
    echo "📁 Repository exists, pulling latest..."
    cd ~/projects/solidstack
    git pull
else
    mkdir -p ~/projects
    cd ~/projects
    echo "📥 Cloning from GitHub..."
    git clone https://github.com/aperecko/solidstack.git
    cd solidstack
fi

echo "✅ Repository ready at ~/projects/solidstack"
echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Shell Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SHELL_RC=~/.zshrc
if [ -n "$BASH_VERSION" ]; then
    SHELL_RC=~/.bashrc
fi

echo "⚙️  Setting up shell aliases in $SHELL_RC..."

if [ -f "$SHELL_RC" ]; then
    if ! grep -q "# BACKUP" "$SHELL_RC.backup."* 2>/dev/null; then
        cp "$SHELL_RC" "$SHELL_RC.backup.$(date +%Y%m%d_%H%M%S)"
    fi
fi

if ! grep -q "# SolidStack" "$SHELL_RC" 2>/dev/null; then
    cat >> "$SHELL_RC" << 'ALIASES'

# SolidStack - Mac Remote Control for Windows Server
alias srv='ssh srv'
alias srv-status='ssh srv "cd C:\SolidStack\repo && pwsh .\check-git-status.ps1"'
alias srv-check='ssh srv "cd C:\SolidStack\repo && pwsh .\src\solidstack.ps1 status"'
alias srv-pull='ssh srv "cd C:\SolidStack\repo && git pull"'

# Local repository shortcuts
alias ss='cd ~/projects/solidstack'
alias ss-pull='cd ~/projects/solidstack && git pull'
alias ss-sync='cd ~/projects/solidstack && git pull && echo "✅ Mac synced" && ssh srv "cd C:\SolidStack\repo && git pull" && echo "✅ Server synced"'
alias ss-handoff='cat ~/projects/solidstack/handoff/AI-HANDOFF-MAC-USER.md'
alias ss-status='cd ~/projects/solidstack && git status'

# Quick development workflow
alias ss-push='cd ~/projects/solidstack && git add . && git commit && git push'
ALIASES
    echo "✅ Aliases added"
else
    echo "✅ Aliases already present"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Test Connection
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""
echo "🧪 Testing SSH connection..."
if timeout 5 ssh -o ConnectTimeout=5 -o BatchMode=yes srv "echo test" &> /dev/null 2>&1; then
    echo "✅ SSH connection works!"
else
    echo "⚠️  SSH connection not working yet"
    echo "   This is normal if you just added the SSH key"
    echo "   Test manually: ssh srv"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Summary
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Mac Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 Repository: ~/projects/solidstack"
echo "⚙️  SSH Config: ~/.ssh/config"
echo "🔑 SSH Key: ~/.ssh/id_ed25519.pub"
echo "🐚 Shell: $SHELL_RC"
echo ""
echo "🎯 Available Commands (reload shell first!):"
echo "   source ~/.zshrc         → Reload shell config"
echo "   srv                     → SSH to Windows Server"
echo "   srv-status              → Check git status on server"
echo "   srv-check               → Run SolidStack status"
echo "   ss                      → Go to local repository"
echo "   ss-sync                 → Sync Mac and Server"
echo "   ss-handoff              → View AI handoff document"
echo ""
echo "📖 Next Steps:"
echo "   1. Reload shell: source ~/.zshrc"
echo "   2. Test connection: srv"
echo "   3. Check status: srv-status"
echo "   4. Read handoff: ss-handoff"
echo ""
echo "🎉 Ready to develop from your Mac!"
echo ""
