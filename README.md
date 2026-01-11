# SolidStack

> A cross-platform control plane for multi-tier self-hosted infrastructure

[![PowerShell 7+](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Platform: Cross-Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Linux-blue)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What is SolidStack?

SolidStack is a **PowerShell-based control plane** for managing tiered self-hosted infrastructure with Docker services. It's designed to answer one key question: **"Where do I go to fix this?"**

**Think of it as:**
- Infrastructure-as-code for small-to-medium self-hosting
- A registry of what exists and where it runs
- A deployment system that documents reality, not intention
- A calm, grounded approach to infrastructure management

**Architecture:**
```
Layer 0: Physical Infrastructure
├─ SRV (Windows Server - Hyper-V host)
└─ UniFi (Network fabric)

Tier 1: Identity & Authority (Slow-Changing)
└─ SSDC (Windows Server Core VM)
    ├─ Active Directory
    ├─ DNS Server
    └─ Certificate Authority

Tier 2: Execution Platform (Fast-Changing, Safe to Rebuild)
└─ SSDOCK (Ubuntu Server VM)
    ├─ Docker Engine
    ├─ PowerShell 7+
    └─ Containerized services
```

See [docs/INFRASTRUCTURE.md](docs/INFRASTRUCTURE.md) for the complete architecture.

**Perfect for:**
- Managing multi-tier virtualized infrastructure
- Clear separation of concerns (identity vs execution vs workloads)
- Cross-platform deployments (Windows and Linux)
- Neurodivergent-friendly operations (low cognitive load, clear boundaries)

## Core Principles

1. **Prevent redundant workloads** - One system per responsibility
2. **Document reality, not intention** - Registry reflects what actually exists  
3. **Always answer "where do I fix this?"** - Clear responsibility boundaries
4. **Stay grounded under failure** - Calm recovery > perfect uptime

See [docs/PRINCIPLES.md](docs/PRINCIPLES.md) for the complete design philosophy.

## Quick Start

### Prerequisites
- A Hyper-V host (Windows Server) or other hypervisor
- At least one VM for execution platform
- PowerShell 7+ on your management machine
- 1Password CLI for secrets management

### Bootstrap a New Node

**On Ubuntu Server (SSDOCK):**
```bash
# Clone repository
git clone https://github.com/aperecko/solidstack.git
cd solidstack

# Run bootstrap (installs PowerShell 7+ if needed)
sudo bash bootstrap-linux.sh -NodeType SSDOCK

# Or if PowerShell is already installed
pwsh ./solidstack-deploy.ps1 -NodeType SSDOCK
```

**On Windows Server:**
```powershell
# Clone repository
git clone https://github.com/aperecko/solidstack.git
cd solidstack

# Run bootstrap
pwsh ./solidstack-deploy.ps1 -NodeType SSDC
```

### Realign Existing Node

```powershell
# Pull latest changes
git pull

# Realign node configuration
pwsh ./solidstack-deploy.ps1 -NodeType SSDOCK -Realign
```

## Current Status

**Phase 1: Foundation** (In Progress)
- ✅ Core principles documented
- ✅ Multi-tier architecture defined
- ✅ Cross-platform support designed
- ✅ Registry structure created
- 🎯 SSDOCK deployment (next step)
- ⏳ Bootstrap automation (after manual experience)

The bootstrap scripts (`solidstack-deploy.ps1`, etc.) are currently stubs. We're deploying SSDOCK manually first to document what actually works, then implementing the automation based on real experience.

**This is intentional:** Document reality, not intention.

## Documentation

### Core Concepts
- [PRINCIPLES.md](docs/PRINCIPLES.md) - Design philosophy and boundaries
- [INFRASTRUCTURE.md](docs/INFRASTRUCTURE.md) - Multi-tier architecture  
- [LINUX-SUPPORT.md](docs/LINUX-SUPPORT.md) - Why Linux for execution platform

### Registry
- [registry/README.md](registry/README.md) - How the registry works
- [registry/nodes.yaml](registry/nodes.yaml) - Node definitions
- [registry/services.yaml](registry/services.yaml) - Service definitions

### Implementation (Original Docker Orchestration)
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Original design (Docker Desktop focus)
- [src/](src/) - Original PowerShell commands (being refactored)
- [ROADMAP.md](docs/ROADMAP.md) - Original roadmap (being updated)

## Project Evolution

This repository started as a Docker orchestration tool for Windows Server. It's evolving into a full control plane for multi-tier infrastructure:

**Original scope:**
- Docker Compose management on Windows
- Logging and status reporting  
- Service lifecycle management

**Current scope:**
- Multi-tier infrastructure (hypervisor → identity → execution)
- Cross-platform (Windows and Linux)
- Registry-based node tracking
- Bootstrap and alignment automation
- Clear separation of concerns

The `src/` directory contains the original implementation. The `modules/` directory will contain the new registry-based control plane once we implement it based on real deployment experience.

## Contributing

This is currently a personal infrastructure project. If you're interested in using or contributing:

1. Read [docs/PRINCIPLES.md](docs/PRINCIPLES.md) to understand the philosophy
2. Review [docs/INFRASTRUCTURE.md](docs/INFRASTRUCTURE.md) for architecture
3. Open an issue to discuss your use case or idea

## License

MIT License - see [LICENSE](LICENSE) for details

## Acknowledgments

- Built for calm, grounded infrastructure operations
- Designed with neurodivergent operators in mind  
- Focused on reducing cognitive load and preventing burnout
- AI-assisted development friendly
