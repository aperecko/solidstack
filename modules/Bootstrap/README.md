# Bootstrap Module

> First-time setup and dependency installation for new nodes

## Purpose

The Bootstrap module handles the initial setup of a new node, including:

* Authenticating with 1Password CLI
* Installing required dependencies (Docker, PowerShell 7+, etc.)
* Configuring SSH access
* Establishing node identity
* Registering in the control plane registry

## Scripts (To Be Implemented)

### `Initialize-OpAuth.ps1`
Authenticate operator via 1Password CLI, retrieve necessary credentials.

### `Install-Dependencies-Linux.ps1`
Install dependencies on Ubuntu/Debian/RHEL systems:
* PowerShell 7+
* Docker Engine
* OpenSSH Server
* 1Password CLI
* realmd/sssd (for domain joining)

### `Install-Dependencies-Windows.ps1`
Install dependencies on Windows Server systems:
* PowerShell 7+ (if not present)
* Docker Engine
* OpenSSH Server
* 1Password CLI

### `Configure-SSH.ps1`
Set up SSH server and authorized keys:
* Ensure SSH server is running
* Configure authorized_keys from 1Password
* Get SSH host key fingerprint
* Generate SSH config fragment for operator

### `Initialize-NodeIdentity.ps1`
Establish node identity and register in control plane:
* Set hostname (if needed)
* Configure static IP
* Update registry/nodes.yaml
* Commit changes to Git

## Design Principles

### Idempotent
Bootstrap scripts should be safe to run multiple times. If a dependency is already installed, skip it.

### Platform-Aware
Detect Windows vs Linux and use appropriate installation methods.

### 1Password-First
All secrets (SSH keys, domain credentials) come from 1Password, never hardcoded.

### Self-Documenting
Each script should log what it's doing and why, with clear error messages.

## Usage

```powershell
# Called by solidstack-deploy.ps1
. ./modules/Bootstrap/Initialize-OpAuth.ps1
. ./modules/Bootstrap/Install-Dependencies-Linux.ps1  # or -Windows.ps1
. ./modules/Bootstrap/Configure-SSH.ps1
. ./modules/Bootstrap/Initialize-NodeIdentity.ps1
```

## See Also

* `/docs/LINUX-SUPPORT.md` - Linux-specific setup
* `/registry/nodes.yaml` - Node definitions
* `solidstack-deploy.ps1` - Main deployment script
