# Linux Support for SolidStack

> Why SSDOCK runs Ubuntu Server instead of Windows Server

## Executive Summary

**Decision:** SSDOCK (the execution platform) will run Ubuntu Server 24.04 LTS, not Windows Server.

**Rationale:** Docker is native to Linux, and the execution platform benefits from standard tooling, lighter resource usage, and cost savings. PowerShell 7+ runs identically on Linux, so the SolidStack control plane is unaffected.

---

## The Decision Point

When designing SSDOCK (Tier 2: Execution Platform), we had two options:

### Option A: Windows Server
* Consistent OS across all VMs
* Seamless GPO integration
* Native domain membership
* **Requires Docker Engine** (not Docker Desktop - not free for enterprise)

### Option B: Linux (Ubuntu Server)
* Docker is native and standard
* Lighter resource footprint
* No licensing costs
* Most Docker documentation assumes Linux
* PowerShell 7+ works identically

**We chose Option B.**

---

## Why Linux for the Execution Platform?

### 1. Docker is Native to Linux

**Docker was built for Linux.** Running Docker on Linux means:
* Native container runtime (no Hyper-V isolation layer)
* Better performance
* Lower overhead
* Standard configuration

**On Windows Server:**
* Docker Engine requires Hyper-V isolation for Linux containers
* Extra layer of abstraction
* More complex troubleshooting
* Less common in self-hosting community

### 2. Standard Tooling and Documentation

**95% of Docker self-hosting guides assume Linux:**
* Install commands: `apt install docker.io`
* Configuration paths: `/etc/docker/`
* Networking: Standard Linux iptables/nftables
* Volumes: Standard Linux filesystem

**On Windows:**
* Install process is more complex
* Paths are different: `C:\ProgramData\Docker\`
* Networking uses Windows-specific mechanisms
* Fewer examples and guides

### 3. Lighter Resource Footprint

**Ubuntu Server 24.04 LTS:**
* Minimal install: ~1GB RAM idle
* Fast boot time
* Smaller disk footprint
* Efficient for headless operation

**Windows Server 2025 Core:**
* ~2-3GB RAM idle
* Larger disk footprint
* More background services
* Heavier resource usage

### 4. Cost Savings

**Ubuntu Server:**
* Free and open source
* No licensing costs
* Community support

**Windows Server:**
* Requires licensing
* Per-core or per-VM costs
* Even if you have licenses, it's a resource allocation

### 5. PowerShell 7+ is Cross-Platform

**This is the key enabler:**

PowerShell 7+ runs identically on Windows, Linux, and macOS. The SolidStack control plane (written in PowerShell) works the same on both platforms.

**Example:**
```powershell
# This works on both Windows and Linux
$containers = docker ps --format json | ConvertFrom-Json
Write-Host "Running containers: $($containers.Count)"
```

**Platform detection:**
```powershell
if ($IsLinux) {
    # Linux-specific logic
} elseif ($IsWindows) {
    # Windows-specific logic
}
```

---

## Trade-offs Accepted

### 1. Domain Integration is Slightly More Complex

**Windows:**
* Auto-joins via GUI or PowerShell
* GPO applies automatically
* Certificate auto-enrollment via GPO

**Linux:**
* Requires `realmd` and `sssd` packages
* Manual configuration steps
* Certificates via certbot or manual enrollment

**Verdict:** Well-documented, stable, worth the trade-off.

### 2. Operator Needs Basic Linux Knowledge

**Required skills:**
* SSH access (already using this)
* Basic file navigation (`ls`, `cd`, `cat`)
* Package management (`apt install`)
* Service management (`systemctl`)

**Verdict:** Minimal learning curve, and you're already comfortable with SSH.

### 3. Different from Physical Host (SRV)

**SRV is Windows** (Hyper-V requires Windows)
**SSDOCK is Linux** (Docker prefers Linux)

**Verdict:** This is actually a strength - each layer uses the best tool for its job.

---

## What Stays Windows?

### SRV (Physical Server)
**Must be Windows** because Hyper-V requires Windows Server.

**Role:** Bare hypervisor only, no business logic.

### SSDC (Domain Controller)
**Should be Windows** because Active Directory and Certificate Services are Windows-native.

**Role:** Identity authority, DNS, PKI.

**Why not Linux alternatives like FreeIPA?**
* Active Directory is proven and well-understood
* Certificate Services integration is seamless
* No compelling reason to replace for small infrastructure
* Windows domain membership works smoothly

---

## Linux Distribution Choice: Ubuntu Server

### Why Ubuntu Server 24.04 LTS?

**Proven and Stable:**
* Long-term support (LTS) until 2029
* Well-tested and widely deployed
* Regular security updates

**Best Docker Support:**
* Docker packages in official repos
* Extensive documentation
* Large community

**PowerShell Support:**
* Official Microsoft packages for Ubuntu
* Well-maintained and stable
* Easy installation

**Operator Familiarity:**
* Most popular Linux server distribution
* Extensive documentation and guides
* Large community for troubleshooting

### Why Not Debian, CentOS, Alpine, etc.?

**Debian:** More conservative, slower updates, less Docker-focused documentation
**CentOS/RHEL:** Different package manager (yum/dnf), less common for self-hosting
**Alpine:** Ultra-lightweight but less compatibility, more advanced

**Verdict:** Ubuntu Server is the safe, well-documented choice.

---

## Implementation Details

### SSDOCK Specifications

```yaml
VM Name: SSDOCK
OS: Ubuntu Server 24.04 LTS
Resources:
  CPU: 4 cores
  RAM: 12GB
  Disk: 200GB
Network:
  IP: 192.168.69.10 (static)
  Domain: solidstate.local
Services:
  - Docker Engine (native)
  - PowerShell 7+
  - OpenSSH Server
  - realmd/sssd (for AD integration)
```

### Installation Process

1. **Create VM** on SRV via Hyper-V
2. **Install Ubuntu Server 24.04** from ISO
3. **Configure networking** (static IP: 192.168.69.10)
4. **Install dependencies:**
   * Docker Engine
   * PowerShell 7+
   * realmd/sssd
   * 1Password CLI
5. **Join domain** via `realm join solidstate.local`
6. **Deploy SolidStack** via `solidstack-deploy.ps1`

---

## Cross-Platform SolidStack Design

### Platform-Agnostic Core

**SolidStack control plane (PowerShell) works on both:**

```powershell
# Platform detection
$Platform = if ($IsWindows) { "Windows" } 
            elseif ($IsLinux) { "Linux" } 
            else { throw "Unsupported" }

# Platform-specific modules
if ($IsLinux) {
    . ./modules/Bootstrap/Install-Dependencies-Linux.ps1
} else {
    . ./modules/Bootstrap/Install-Dependencies-Windows.ps1
}

# Platform-agnostic logic
docker ps
Get-SolidStackStatus
```

### Future Flexibility

**This design allows:**
* Adding more Linux nodes (additional execution platforms)
* Adding Windows nodes if needed (specialized workloads)
* Mixed infrastructure (best tool for each job)
* Easy migration between platforms (same control plane)

---

## Performance Comparison

### Docker Container Performance

**Linux (native):**
* Direct kernel integration
* No isolation overhead
* Full performance

**Windows (Hyper-V isolation):**
* Additional VM layer for Linux containers
* ~10-20% performance overhead
* More complex networking

**Verdict:** Linux is faster for containerized workloads.

### Resource Usage (Idle)

**Ubuntu Server 24.04:**
* RAM: ~1GB
* CPU: <5%
* Disk: ~10GB

**Windows Server 2025 Core:**
* RAM: ~2-3GB
* CPU: <10%
* Disk: ~20GB

**Verdict:** Linux is more efficient.

---

## Operational Considerations

### SSH Access

**Both platforms support SSH:**
* Windows: OpenSSH Server (installed separately)
* Linux: OpenSSH Server (built-in)

**Verdict:** Identical operator experience.

### PowerShell Experience

**Identical across platforms:**
* Same cmdlets
* Same modules
* Same scripts
* Platform detection available via `$IsWindows`, `$IsLinux`

**Verdict:** No retraining needed.

### Updates and Maintenance

**Ubuntu Server:**
* `apt update && apt upgrade`
* Automatic security updates (optional)
* Minimal disruption

**Windows Server:**
* Windows Update
* Requires reboots more frequently
* Patch Tuesday cycle

**Verdict:** Linux is simpler for updates.

---

## Migration Path

### If You Need to Switch Later

**Linux → Windows:**
* Export container definitions (Docker Compose files)
* Rebuild SSDOCK as Windows VM
* Re-run `solidstack-deploy.ps1` (Windows mode)
* Restore data volumes

**Windows → Linux:**
* Same process, reverse direction

**Key insight:** Because SolidStack is the control plane and containers are portable, the underlying OS can change without losing work.

---

## Summary

### Why Linux for SSDOCK?

✅ Docker is native and standard
✅ Better performance for containers
✅ Lighter resource footprint
✅ No licensing costs
✅ Standard documentation and community
✅ PowerShell 7+ works identically
✅ Simpler updates and maintenance

### What This Means

* **SSDOCK will be Ubuntu Server 24.04 LTS**
* **PowerShell control plane works the same**
* **Domain integration via realmd/sssd**
* **Standard Docker tooling and guides apply**
* **Lower resource usage and cost**

### The Big Picture

```
Layer 0: Physical
├─ SRV (Windows) - Hyper-V host

Tier 1: Identity
├─ SSDC (Windows) - Active Directory, DNS, PKI

Tier 2: Execution
├─ SSDOCK (Linux) - Docker, PowerShell, SolidStack

Tier 3: Workloads
└─ Containers (Linux) - Your services
```

**Each layer uses the best tool for its job.**
