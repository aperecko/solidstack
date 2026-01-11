# Bootstrap Module

This module contains scripts for bootstrapping new nodes in the SolidStack infrastructure.

## Purpose

Bootstrap scripts run during first-time setup of a node. They:
- Authenticate the operator via 1Password CLI
- Install required dependencies
- Configure SSH access
- Set up basic node identity

## Scripts (To Be Implemented)

### `Initialize-OpAuth.ps1`
Authenticate operator using 1Password CLI:
- Verify `op` CLI is installed
- Authenticate user
- Retrieve necessary credentials for deployment

### `Install-Dependencies-Windows.ps1`
Install dependencies on Windows nodes:
- PowerShell 7+ (if needed)
- Docker Engine (not Desktop)
- OpenSSH Server
- 1Password CLI

### `Install-Dependencies-Linux.ps1`
Install dependencies on Linux nodes:
- PowerShell 7+ (via package manager)
- Docker Engine (native)
- OpenSSH Server (usually pre-installed)
- 1Password CLI

### `Configure-SSH.ps1`
Set up SSH access:
- Ensure SSH server is running
- Configure authorized keys from 1Password
- Get SSH host key fingerprint
- Generate SSH config fragment for operator

## Implementation Notes

These scripts will be implemented after manual deployment of SSDOCK provides real-world experience with:
- What actually needs to be installed
- What configuration actually works
- What dependencies are truly required
- What can be automated vs what needs manual intervention

**Document reality, not intention.**

## Platform Support

All scripts must work on:
- ✅ Windows Server (PowerShell native)
- ✅ Linux (PowerShell 7+ cross-platform)
- ⚠️ macOS (for testing, not production)

## Dependencies

Bootstrap scripts can assume:
- PowerShell 7+ is installed (or being installed)
- Network connectivity
- Git is available
- Node has basic OS installation complete

Bootstrap scripts should NOT assume:
- Domain membership (may be configured during bootstrap)
- 1Password CLI is installed (we install it)
- Docker is installed (we install it)
- SSH is configured (we configure it)
