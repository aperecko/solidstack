# 🏗️ SolidStack Architecture

## 🎭 START HERE: The Theater Analogy

**The easiest way to understand SolidStack is through the theater metaphor.**

**READ THIS FIRST:** [THEATER-ANALOGY.md](THEATER-ANALOGY.md) 🎭

Quick version:
- 🏛️ **Concert Hall** = Windows Server (the building)
- 🎵 **Stage Equipment** = Docker Desktop (the platform)  
- 🎼 **Conductor** = SolidStack (YOU - orchestrates everything)
- 🎼 **Sheet Music** = Docker Compose Files (in Git)
- 🎻 **Orchestra** = Docker Containers (your services)

**Key insight: The conductor (SolidStack) stands IN FRONT of the orchestra (containers), not IN a box on the stage!**

---

## The Big Question: Where's the Floor?

You asked a critical question: **Should SolidStack itself run in Docker? Where's the boundary between bare metal and containers?**

This is the **inception problem** - and you're right to ask!

## The Answer: SolidStack is the Control Plane

```
┌─────────────────────────────────────────────────┐
│  BARE METAL: Windows Server                     │  ← The Floor
│  ├─ Docker Desktop                              │  ← Container runtime
│  ├─ PowerShell 7+                               │  ← Shell/scripting
│  ├─ SolidStack CLI (this project)              │  ← Control plane
│  └─ Git, 1Password CLI, rclone                 │  ← Supporting tools
└─────────────────────────────────────────────────┘
                    │
                    ▼ manages/orchestrates
┌─────────────────────────────────────────────────┐
│  CONTAINERS: Your actual services               │
│  ├─ Traefik (proxy)                            │  ← Run in Docker
│  ├─ Portainer (management UI)                  │  ← Run in Docker
│  ├─ Your apps (WordPress, etc)                 │  ← Run in Docker
│  └─ Monitoring, backups, etc                   │  ← Run in Docker
└─────────────────────────────────────────────────┘
```

## The Design Decision

### ❌ SolidStack Does NOT Run in Docker

**Why?**
1. **Bootstrap Problem** - You need something to start Docker
2. **Host Management** - Needs access to Docker daemon, file system, secrets
3. **Simplicity** - One less layer of complexity
4. **Windows Reality** - Native PowerShell is the natural control layer on Windows

### ✅ SolidStack IS the Orchestrator

Think of it like this:

| Layer | What | Example |
|-------|------|---------|
| **Hardware** | Physical server | Your Windows Server box |
| **OS** | Operating system | Windows Server 2022 |
| **Runtime** | Container platform | Docker Desktop |
| **Control Plane** | Management tool | **← SolidStack (you are here!)** |
| **Services** | Your actual apps | Traefik, WordPress, etc. (in Docker) |

## Real-World Analogy

```
SolidStack = Your "docker-compose CLI" + orchestration + logging
           = The conductor, not the orchestra
           = kubectl/docker-compose replacement for your setup
```

## Migration & Portability

### What's Portable (In Git)
✅ **SolidStack scripts** - The control plane
✅ **Docker Compose files** - Service definitions  
✅ **Configuration templates** - How services are configured
✅ **Documentation** - How everything works

### What's NOT Portable (Local State)
❌ **Docker volumes** - Actual data (but can be backed up)
❌ **Secrets** - Stay on the server (but can use 1Password)
❌ **Logs** - Runtime state
❌ **The server itself** - Bare metal

### Migration Strategy

```
OLD SERVER                          NEW SERVER
├─ SolidStack (git repo)    →      ├─ Clone SolidStack repo
├─ Docker Compose files     →      ├─ Automatic (in repo)
├─ Configuration            →      ├─ Automatic (in repo)
├─ Secrets (manual)         →      ├─ Copy or use 1Password
└─ Data (backup/restore)    →      └─ Restore from backup
```

## Why This Architecture?

### 1. Clear Separation of Concerns
- **Control plane** (SolidStack): Bare metal, versioned
- **Services**: Containerized, isolated, reproducible

### 2. Migration Path
```powershell
# Old server: Push to GitHub
cd C:\SolidStack\repo
git push

# New server: Clone and run
git clone https://github.com/you/solidstack C:\SolidStack\repo
pwsh C:\SolidStack\bin\solidstack.ps1 status
# All your infrastructure-as-code is here!
```

### 3. Disaster Recovery
- **Code**: In GitHub
- **Secrets**: In 1Password (or similar)
- **Data**: In backups (via Restic → Google Drive)
- **Recovery**: Clone + restore = new server

## The Stack Layers (Detailed)

### Layer 0: Bare Metal (NOT in containers)
```
Windows Server 2022
├─ Docker Desktop
├─ PowerShell 7+
├─ SolidStack CLI scripts
└─ Supporting tools (git, op, rclone)
```

**Why bare metal?**
- Needs to control Docker itself
- Manages the host filesystem
- Handles secrets securely
- Starts everything else

### Layer 1: Infrastructure Services (IN containers)
```
Managed by SolidStack via Docker Compose
├─ Traefik (reverse proxy, SSL termination)
├─ Portainer (Docker management UI)
└─ Monitoring/backup agents
```

### Layer 2: Application Services (IN containers)
```
Your actual workloads
├─ WordPress
├─ NextCloud  
├─ Custom apps
└─ Whatever you want to self-host
```

## Evolution Path

### Phase 1: Current State
```
Manual server setup → Install SolidStack → Manage containers
```

### Phase 2: Next Level (Future)
```
Bare server → solidstack init → Everything configured
```

### Phase 3: Ultimate (Future Future)
```
# On new server
git clone your-repo
solidstack bootstrap --secrets-from=1password
# Server is now identical to old one
```

## What About "Infrastructure as Code"?

### SolidStack IS Infrastructure as Code

```
C:\SolidStack\repo\
├─ src\                    ← The automation (PowerShell)
├─ stack\compose\          ← Service definitions (Docker Compose)
├─ stack\config\           ← Service configs (Traefik, etc)
└─ docs\                   ← How it all works
```

**Everything except secrets and data is in Git!**

### Migration = Git Clone

When you move to a new server:

1. **Install prerequisites** (Windows, Docker, PowerShell 7+)
2. **Clone SolidStack** (`git clone ...`)
3. **Restore secrets** (from 1Password or manual)
4. **Restore data** (from backups if needed)
5. **Run** (`solidstack status`)

**Your infrastructure definition lives in Git!**

## Comparison to Other Tools

| Tool | Layer | Purpose |
|------|-------|---------|
| **Kubernetes** | Container orchestration | Multi-node, complex |
| **Docker Compose** | Container definition | Single-node, simple |
| **Portainer** | Docker UI | Visual management |
| **SolidStack** | **Control plane** | **Opinionated orchestration + logging** |

**SolidStack = Docker Compose + Scripting + Conventions + Logging**

## The "Inception" Question Answered

### Q: Should SolidStack run in Docker?
**A: NO.** It's the layer that manages Docker.

### Q: Where's the floor?
**A: Windows Server + Docker Desktop + PowerShell 7+**

### Q: What about portability?
**A: Everything in Git except secrets and data.**

### Q: How do I migrate?
**A: Clone repo + restore secrets + restore data = new server**

## Design Philosophy

1. **SolidStack is native** - Uses PowerShell, the natural Windows scripting layer
2. **Services are containerized** - Everything else runs in Docker
3. **Configuration is code** - Git tracks everything
4. **Secrets stay local** - Never committed
5. **Data is backed up** - Restic to cloud storage
6. **Migration is git clone** - Infrastructure as code

## Future Considerations

### Could SolidStack Eventually Run in Docker?

**Possible but NOT planned:**
- Would need Docker-in-Docker or host Docker socket access
- Adds complexity without clear benefit
- PowerShell is already the native Windows control layer
- Current approach is simpler and more maintainable

### What About Windows Containers?

**Not the goal:**
- Docker Desktop on Windows runs Linux containers
- Windows containers are different and more complex
- Linux containers are the standard for self-hosting

## Summary

```
┌─────────────────────────────────────┐
│  THE FLOOR: Windows Server          │
│  ├─ Docker Desktop                  │
│  ├─ PowerShell 7                    │
│  └─ SolidStack (control plane)     │  ← This is SolidStack
└──────────────┬──────────────────────┘
               │ orchestrates
               ▼
┌─────────────────────────────────────┐
│  CONTAINERS: Your Services          │
│  ├─ Proxy (Traefik)                │
│  ├─ UI (Portainer)                 │
│  └─ Apps (WordPress, etc)          │  ← This is what you're hosting
└─────────────────────────────────────┘
```

**SolidStack = The conductor**  
**Containers = The orchestra**  
**Windows Server = The concert hall**

## Key Takeaway

**SolidStack is intentionally NOT containerized.**

It's the **control plane** that:
- Lives on bare metal (Windows + PowerShell)
- Is version-controlled (Git)
- Manages containers (Docker Compose)
- Logs everything (for troubleshooting)
- Makes migration easy (clone + restore)

**This is the RIGHT architecture for a Windows self-hosting control plane!**

---

## Does This Answer Your Question?

The "floor" is:
1. ✅ **Windows Server** (bare metal or VM)
2. ✅ **Docker Desktop** (container runtime)
3. ✅ **PowerShell 7+** (scripting layer)
4. ✅ **SolidStack** (control plane) ← NOT in Docker

Everything ABOVE that (your services) runs IN Docker containers.

This gives you:
- ✅ **Migration** via Git (infrastructure as code)
- ✅ **Portability** of service definitions
- ✅ **Backup/restore** of data
- ✅ **Clear separation** of control vs services

**You're building the right thing! 🎯**
