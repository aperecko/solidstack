# Alignment Module

This module contains scripts for aligning nodes with their registry definitions.

## Purpose

Alignment scripts run after bootstrap (and can be re-run anytime) to:
- Check node configuration against registry
- Detect and fix configuration drift
- Update node metadata in registry
- Verify node health and capabilities

## Scripts (To Be Implemented)

### `Test-NodeConfiguration.ps1`
Compare current node state with registry definition:
- Check installed packages match capabilities
- Verify network configuration
- Validate domain membership
- Check service status

### `Sync-Configuration.ps1`
Apply registry definition to node:
- Install missing dependencies
- Configure services
- Update domain membership
- Apply security settings

### `Register-Node.ps1`
Update registry with current node state:
- Record deployment timestamp
- Update SSH fingerprint
- Record capabilities discovered during bootstrap
- Generate and commit SSH config fragment
- Push changes to git

### `Join-Domain-Windows.ps1`
Join Windows node to Active Directory:
- Use credentials from 1Password
- Join solidstate.local domain
- Configure DNS to point to SSDC
- Verify domain membership

### `Join-Domain-Linux.ps1`
Join Linux node to Active Directory:
- Install realmd, sssd, adcli
- Discover domain via DNS
- Join using domain administrator credentials
- Configure SSSD for authentication
- Enable home directory creation

## Realignment Workflow

```powershell
# Check for drift
$drift = Test-NodeConfiguration -NodeType SSDOCK

if ($drift.HasDrift) {
    # Fix configuration
    Sync-Configuration -NodeType SSDOCK -Changes $drift.Changes
    
    # Update registry
    Register-Node -NodeType SSDOCK
}
```

## Implementation Notes

These scripts will be implemented after manual deployment provides experience with:
- What configuration actually needs to be checked
- What drift actually occurs in practice
- What can be automatically fixed vs manual intervention
- What should trigger alerts vs silent correction

**Document reality, not intention.**

## Platform Differences

### Windows Nodes
- Domain join via `Add-Computer`
- GPO applies automatically
- Certificates via auto-enrollment
- Windows Update configuration

### Linux Nodes
- Domain join via `realm join`
- SSSD for authentication
- Certificates via certbot or manual
- Package updates via apt/yum

## Registry Integration

All alignment scripts read from and write to `registry/nodes.yaml`:

```yaml
SSDOCK:
  last_deployed: 2026-01-11T16:45:00Z
  deployed_by: test@mac
  capabilities:
    - docker-engine
    - powershell-7
    - domain-joined
  access:
    ssh_fingerprint: "SHA256:..."
```

## Safety

Alignment scripts must:
- ✅ Be idempotent (safe to run multiple times)
- ✅ Show what they're changing before changing it
- ✅ Create backups before modifying configuration
- ✅ Fail gracefully with clear error messages
- ✅ Never remove configuration without confirmation
