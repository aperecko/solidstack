# SolidStack

> A cross-platform control plane for multi-tier self-hosted infrastructure

[![PowerShell 7+](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What is SolidStack?

SolidStack is a **PowerShell-based control plane** for managing tiered self-hosted infrastructure with Docker services. It's designed to answer one key question: **"Where do I go to fix this?"**

**Think of it as:**
- Infrastructure-as-code for small-to-medium self-hosting
- A registry of what exists and where it runs
- A deployment system that documents reality, not intention
- A calm, grounded approach to infrastructure management

## Architecture Overview

```
Layer 0: Physical Infrastructure
├─ SRV (Windows Server - Hyper-V host)
└─ UniFi (Network fabric)

Tier 1: Identity & Authority (Slow-Changing)
├─ SSDC (Windows Server Core VM)
│   ├─ Active Directory Domain Services
│   ├─ DNS Server
│   └─ Certificate Authority (AD CS)

Tier 2: Execution Platform (Fast-Changing, Safe to Rebuild)
├─ SSDOCK (Ubuntu Server VM)
│   ├─ Docker Engine
│   ├─ PowerShell 7+
│   ├─ SolidStack control plane
│   └─ Containerized services (Traefik, Portainer, apps)

Tier 3: Redundancy (Phase 2)
└─ Secondary DC, geographic replication (explicitly deferred)
```

See [docs/INFRASTRUCTURE.md](docs/INFRASTRUCTURE.md) for details.

## Core Principles

1. **Prevent redundant workloads** - One system per responsibility
2. **Document reality, not intention** - Registry reflects what actually exists
3. **Always answer "where do I fix this?"** - Clear responsibility boundaries
4. **Stay grounded under failure** - Calm recovery > perfect uptime

See [docs/PRINCIPLES.md](docs/PRINCIPLES.md) for complete philosophy.

## Key Features

- 🏗️ **Multi-tier architecture** - Physical, identity, execution, workloads
- 📋 **Registry-based** - Git-tracked source of truth for infrastructure
- 🔄 **Idempotent deployment** - Safe to run repeatedly, detects drift
- 🐧 **Cross-platform** - Works on Windows and Linux (PowerShell 7+)
- 🔐 **1Password-first** - Secrets from authoritative source, never hardcoded
- 🔑 **SSH everywhere** - Key-based authentication, mesh networking ready
- 📝 **Everything logged** - Timestamped audit trail
- 🧘 **Human-centered** - Low cognitive load, designed for calm operation

## Quick Start

### For New Infrastructure

```bash
# 1. Clone the repository
git clone https://github.com/aperecko/solidstack.git
cd solidstack

# 2. On a new Linux node (Ubuntu/Debian)
sudo bash bootstrap-linux.sh -NodeType SSDOCK

# 3. On a new Windows node
pwsh ./solidstack-deploy.ps1 -NodeType SSDC

# 4. The script will:
#    - Install PowerShell 7+ (if needed)
#    - Install dependencies (Docker, SSH, etc.)
#    - Configure authentication via 1Password
#    - Join domain (if applicable)
#    - Register node in control plane
#    - Deploy services (if applicable)
```

### For Existing Nodes (Realignment)

```bash
# Pull latest registry
git pull

# Realign node with current state
pwsh ./solidstack-deploy.ps1 -NodeType SSDOCK -Realign

# This will:
# - Detect configuration drift
# - Fix any issues
# - Update registry with current state
# - Commit changes back to Git
```

## Project Structure

```
solidstack/
├─ README.md (this file)
├─ solidstack-deploy.ps1 (main deployment script)
├─ bootstrap-linux.sh (Linux wrapper, installs pwsh)
│
├─ docs/
│   ├─ PRINCIPLES.md (design philosophy)
│   ├─ INFRASTRUCTURE.md (tier model explained)
│   ├─ LINUX-SUPPORT.md (why Linux for execution platform)
│   └─ [legacy docs...]
│
├─ registry/
│   ├─ nodes.yaml (infrastructure nodes)
│   ├─ services.yaml (what runs where)
│   ├─ relationships.yaml (dependencies)
│   └─ ssh-config.d/ (generated SSH configs)
│
├─ modules/
│   ├─ Bootstrap/ (first-time setup)
│   └─ Alignment/ (drift detection & correction)
│
├─ src/ (legacy: service orchestration)
└─ stack/ (legacy: docker compose files)
```

## The Registry (Source of Truth)

The `registry/` directory contains YAML files that define:

- **nodes.yaml** - All infrastructure nodes (VMs, physical servers)
- **services.yaml** - All services and where they run
- **relationships.yaml** - Dependencies and trust boundaries

**The registry is:**
- ✅ Version-controlled (Git)
- ✅ Human-readable (YAML)
- ✅ Machine-parseable (PowerShell + ConvertFrom-Yaml)
- ✅ Updated automatically (by deployment scripts)
- ✅ The source of truth (reality, not intention)

See [registry/README.md](registry/README.md) for details.

## Platform Support

### Windows Server
- ✅ Active Directory (identity authority)
- ✅ Hyper-V (hypervisor)
- ✅ PowerShell 7+ (native)
- ✅ Docker Engine (via native install, not Docker Desktop)

### Linux (Ubuntu Server 24.04 LTS)
- ✅ Docker Engine (native, standard)
- ✅ PowerShell 7+ (installed automatically)
- ✅ Domain joining (via realmd/sssd)
- ✅ SSH (built-in)

See [docs/LINUX-SUPPORT.md](docs/LINUX-SUPPORT.md) for rationale.

## Design Philosophy

**SolidStack is designed for:**
- Low memory burden (easy to context-switch)
- Recovery after breaks (clear documentation)
- Safe experimentation (tier 2 is safe to rebuild)
- Future delegation (clear responsibility boundaries)
- Neurodivergent-friendly operation (calm, not alarming)

**If a design choice increases anxiety, noise, or cognitive load, it is considered a regression.**

## What SolidStack IS

- ✅ A control plane
- ✅ A registry of services and relationships
- ✅ A guide to "where do I fix this?"
- ✅ Infrastructure-as-code

## What SolidStack IS NOT

- ❌ An application (it orchestrates applications)
- ❌ A monitoring platform (it documents what exists)
- ❌ A dashboard-first system (it's code-first)
- ❌ Business logic (it manages business systems)

## Current Status

### ✅ Completed
- Multi-tier architecture design
- Registry schema and structure
- Cross-platform module design
- Documentation (principles, infrastructure)

### 🚧 In Progress
- SSDOCK deployment (Ubuntu VM creation)
- Bootstrap module implementation
- Alignment module implementation

### 📋 Planned
- Traefik deployment (reverse proxy, HTTPS)
- Portainer deployment (Docker management UI)
- Backup automation (Restic)
- Tailscale integration (mesh networking)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow.

**Key points:**
- Documentation is critical (explain the "why")
- Test on real infrastructure (not just in theory)
- Idempotent scripts (safe to run repeatedly)
- Clear error messages (operator-friendly)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- Built for small-to-medium self-hosting
- Designed with neurodivergent-friendly principles
- AI-assisted development friendly
- Inspired by calm technology principles

## Learn More

- [docs/PRINCIPLES.md](docs/PRINCIPLES.md) - Design philosophy and scope boundaries
- [docs/INFRASTRUCTURE.md](docs/INFRASTRUCTURE.md) - Tier model and architecture
- [docs/LINUX-SUPPORT.md](docs/LINUX-SUPPORT.md) - Why Linux for execution platform
- [registry/README.md](registry/README.md) - Registry structure and usage
- [docs/ROADMAP.md](docs/ROADMAP.md) - Development roadmap

---

**SolidStack: A system that explains itself.**
