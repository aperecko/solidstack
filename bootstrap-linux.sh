#!/bin/bash
set -e

# SolidStack Bootstrap Wrapper for Linux
# This script installs PowerShell 7+ and then runs solidstack-deploy.ps1

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   SolidStack Bootstrap (Linux Wrapper)     ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Check if PowerShell is already installed
if command -v pwsh &> /dev/null; then
    echo "✅ PowerShell 7+ is already installed"
    pwsh -Version
else
    echo "📦 PowerShell 7+ not found, installing..."
    
    # Detect distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        echo "❌ Cannot detect Linux distribution"
        exit 1
    fi
    
    case $OS in
        ubuntu|debian)
            echo "Detected: $OS $VERSION"
            
            # Install prerequisites
            sudo apt update
            sudo apt install -y wget apt-transport-https software-properties-common
            
            # Download Microsoft repository GPG keys
            wget -q "https://packages.microsoft.com/config/$OS/$VERSION/packages-microsoft-prod.deb"
            
            # Register the Microsoft repository
            sudo dpkg -i packages-microsoft-prod.deb
            rm packages-microsoft-prod.deb
            
            # Update package index
            sudo apt update
            
            # Install PowerShell
            sudo apt install -y powershell
            
            echo "✅ PowerShell installed successfully"
            pwsh -Version
            ;;
            
        rhel|centos|fedora)
            echo "Detected: $OS $VERSION"
            
            # Register Microsoft repository
            curl https://packages.microsoft.com/config/rhel/8/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
            
            # Install PowerShell
            sudo yum install -y powershell
            
            echo "✅ PowerShell installed successfully"
            pwsh -Version
            ;;
            
        *)
            echo "❌ Unsupported distribution: $OS"
            echo "Please install PowerShell 7+ manually:"
            echo "https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux"
            exit 1
            ;;
    esac
fi

echo ""
echo "🚀 Running solidstack-deploy.ps1..."
echo ""

# Run the main PowerShell deployment script
exec pwsh ./solidstack-deploy.ps1 "$@"
