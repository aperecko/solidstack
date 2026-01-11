#!/bin/bash
set -e

# SolidStack Bootstrap for Linux
# This wrapper installs PowerShell 7+ and then runs solidstack-deploy.ps1

echo "🐧 SolidStack Bootstrap (Linux)"
echo ""

# Check if PowerShell is already installed
if command -v pwsh &> /dev/null; then
    echo "✅ PowerShell 7+ already installed"
    pwsh --version
else
    echo "📦 Installing PowerShell 7+..."
    
    # Detect Linux distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        
        case "$ID" in
            ubuntu|debian)
                echo "   Detected: Ubuntu/Debian"
                
                # Get version
                VERSION=$(lsb_release -rs)
                
                # Download and install Microsoft package repository
                wget -q "https://packages.microsoft.com/config/ubuntu/$VERSION/packages-microsoft-prod.deb"
                sudo dpkg -i packages-microsoft-prod.deb
                rm packages-microsoft-prod.deb
                
                # Install PowerShell
                sudo apt update
                sudo apt install -y powershell
                
                echo "   ✅ PowerShell installed"
                ;;
                
            rhel|centos|fedora)
                echo "   Detected: RHEL/CentOS/Fedora"
                
                # Register Microsoft repository
                curl https://packages.microsoft.com/config/rhel/8/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
                
                # Install PowerShell
                sudo yum install -y powershell
                
                echo "   ✅ PowerShell installed"
                ;;
                
            *)
                echo "   ❌ Unsupported distribution: $ID"
                echo "   Please install PowerShell 7+ manually:"
                echo "   https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux"
                exit 1
                ;;
        esac
    else
        echo "❌ Cannot detect Linux distribution"
        echo "Please install PowerShell 7+ manually:"
        echo "https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux"
        exit 1
    fi
fi

echo ""
echo "✅ Bootstrap complete"
echo "   Now running solidstack-deploy.ps1..."
echo ""

# Run the main deployment script
pwsh ./solidstack-deploy.ps1 "$@"
