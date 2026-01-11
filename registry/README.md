# SolidStack Node Registry

> The source of truth for "what exists"

## Purpose

This directory contains the registry of all nodes, services, and relationships in the SolidStack infrastructure.

**Key principle:** Document reality, not intention.

---

## Files

### `nodes.yaml`
Defines all physical and virtual nodes in the infrastructure:
- Physical hosts (SRV)
- Virtual machines (SSDC, SSDOCK)
- Their capabilities, access methods, and roles

### `services.yaml`
Defines all services and what nodes they run on:
- Containerized services (Traefik, Portainer, etc.)
- Native services (Active Directory, DNS, etc.)
- Dependencies and relationships

### `ssh-config.d/`
Auto-generated SSH configuration fragments:
- Created during node deployment
- Merged into operator's `~/.ssh/config`
- Makes nodes accessible via simple `ssh nodename`

---

## Design Philosophy

### Git-Based (Current - Phase 1)
* Registry files committed to git
* Changes tracked via commits
* Audit trail via git history
* Simple and reliable

### API-Based (Future - Phase 2)
* When runtime state becomes important
* Real-time health and status
* Dynamic service discovery
* Still backed by git for static config

---

## Schema Principles

### 1. Platform-Aware
Nodes declare their OS and platform:
```yaml
SSDOCK:
  platform: linux
  os: "Ubuntu Server 24.04 LTS"
```

### 2. Access Methods
Multiple ways to reach each node:
```yaml
access:
  local_ip: 192.168.69.10
  tailscale_ip: 100.x.x.x  # When mesh is configured
  ssh_port: 22
  ssh_fingerprint: "SHA256:..."
```

### 3. Capabilities
What each node can do:
```yaml
capabilities:
  - docker-engine
  - powershell-7
  - domain-joined
```

### 4. Deployment Metadata
Track when and how nodes were configured:
```yaml
last_deployed: 2026-01-11T14:30:00Z
deployed_by: test@mac
solidstack_version: "0.1.0"
```

---

## Usage

### By SolidStack-Deploy
* Reads node definitions during bootstrap
* Updates registry after successful deployment
* Commits changes back to git

### By Operators
* Reference for "what exists where"
* SSH configuration generation
* Infrastructure documentation
* Troubleshooting guide

### By Monitoring (Future)
* Expected state for comparison
* Alert definitions
* Dependency mapping

---

## Example Workflow

### 1. Bootstrap New Node
```bash
# On new node (SSDOCK)
git clone https://github.com/aperecko/solidstack
cd solidstack
pwsh ./solidstack-deploy.ps1 -NodeType SSDOCK
```

### 2. Registry Updated Automatically
```yaml
# registry/nodes.yaml
SSDOCK:
  last_deployed: 2026-01-11T16:45:00Z
  access:
    ssh_fingerprint: "SHA256:abc123..."
```

### 3. SSH Config Generated
```bash
# registry/ssh-config.d/ssdock.conf
Host ssdock
    HostName 192.168.69.10
    User administrator
    IdentityFile ~/.ssh/id_ed25519
```

### 4. Operator Updates Config
```bash
# On Mac
cd ~/projects/solidstack
git pull
./scripts/update-ssh-config.sh
ssh ssdock  # Just works
```

---

## Maintenance

### Adding a New Node
1. Create node definition in `nodes.yaml`
2. Run `solidstack-deploy.ps1` on the new node
3. Registry updates automatically
4. Commit and push

### Removing a Node
1. Decommission services on the node
2. Remove node definition from `nodes.yaml`
3. Remove SSH config fragment
4. Commit and push

### Updating Node Configuration
1. Modify `nodes.yaml`
2. Re-run `solidstack-deploy.ps1 -Realign` on affected node
3. Node reconfigures to match registry
4. Commit and push

---

## Future Evolution

### Phase 1 (Current)
* Static YAML definitions
* Git-based tracking
* Manual updates with automatic commits

### Phase 2 (When Needed)
* Runtime status tracking
* Health monitoring integration
* Dynamic service discovery
* API endpoints for queries

### Phase 3 (Advanced)
* Automated drift detection
* Self-healing configuration
* Multi-site coordination
* Advanced dependency mapping

---

## Key Insight

**The registry answers the most important question:**

> "Where do I go to fix this?"

Every component, every service, every node—all documented in one place, tracked in git, updated automatically.

**This is infrastructure as code, done right.**
