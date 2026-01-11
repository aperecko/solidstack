# Alignment Module

> Ensure nodes stay synchronized with desired state

## Purpose

The Alignment module handles ongoing synchronization and health checking:

* Reading node definitions from registry
* Detecting configuration drift
* Applying corrections to bring node back to desired state
* Updating registry with current state
* Verifying health and connectivity

## Scripts (To Be Implemented)

### `Test-NodeConfiguration.ps1`
Compare actual state to desired state from registry:
* Check installed dependencies
* Verify services are running
* Check domain membership
* Validate SSH configuration
* Test connectivity to other nodes

### `Sync-Configuration.ps1`
Apply configuration changes to match registry:
* Update services if versions changed
* Reconfigure settings if drifted
* Fix broken dependencies
* Restart services if needed

### `Register-Node.ps1`
Update registry with current node state:
* Get current capabilities (what's installed)
* Get running services (what's active)
* Get SSH fingerprint
* Get Tailscale IP (if on mesh)
* Update registry/nodes.yaml
* Commit to Git

### `Join-Domain-Linux.ps1`
Join a Linux node to Active Directory domain:
* Install realmd/sssd
* Discover domain
* Join using credentials from 1Password
* Configure home directory creation
* Verify membership

### `Join-Domain-Windows.ps1`
Join a Windows node to Active Directory domain:
* Use Add-Computer cmdlet
* Credentials from 1Password
* Handle reboot requirement
* Verify membership

### `Test-NodeHealth.ps1`
Comprehensive health check:
* Disk space
* Memory usage
* Service status
* Network connectivity
* Certificate validity
* Docker status (if applicable)

## Design Principles

### Detect Before Fixing
Always test current state before making changes. Report what would change.

### Safe Defaults
If uncertain, ask for confirmation rather than making destructive changes.

### Audit Trail
Log all changes made, what was changed, and why.

### Git Integration
After making changes, update registry and commit to provide audit trail.

## Usage

```powershell
# Called by solidstack-deploy.ps1 with -Realign flag

# Test current state
$drifts = Test-NodeConfiguration

# Fix any issues
if ($drifts.Count -gt 0) {
    Sync-Configuration -Drifts $drifts
}

# Update registry with current state
Register-Node

# Verify health
Test-NodeHealth
```

## Realignment Process

```powershell
# On any node
pwsh ./solidstack-deploy.ps1 -Realign

# This will:
# 1. Pull latest registry from Git
# 2. Compare actual state to desired state
# 3. Fix any drift (with confirmation)
# 4. Update registry with current state
# 5. Push changes to Git
# 6. Report health status
```

## See Also

* `/registry/nodes.yaml` - Node definitions (desired state)
* `/modules/Bootstrap/` - Initial setup modules
* `solidstack-deploy.ps1` - Main deployment script
