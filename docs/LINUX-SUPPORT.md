# Why Linux for SSDOCK

> Docker's natural habitat

## The Decision

**SSDOCK (the Docker execution platform) will run Ubuntu Server 24.04 LTS, not Windows Server.**

This document explains why.

---

## Technical Advantages

### 1. Docker is Native on Linux
* Docker was built for Linux
* No Hyper-V isolation overhead
* Better performance for Linux containers
* All Docker documentation assumes Linux

### 2. Simpler Installation
```bash
# Linux
sudo apt install docker.io
# Done.

# Windows Server
# 1. Enable Hyper-V
# 2. Deal with Docker Desktop licensing (not free for enterprise)
# 3. Or install Docker Engine (less documented path)
# 4. Configure Hyper-V isolation for Linux containers
```

### 3. Resource Efficiency
* Ubuntu Server: ~500MB RAM baseline
* Windows Server Core: ~2GB RAM baseline
* More resources available for containers

### 4. Community Support
* 99% of Docker tutorials assume Linux
* More troubleshooting resources
* Larger ecosystem of tools and integrations

### 5. No Licensing Costs
* Ubuntu Server: Free and open source
* Windows Server: Requires licensing
* Docker Desktop: Not free for enterprise use on Windows Server

---

## Why Not Windows?

### Windows Was Considered For:
* Consistency with SRV and SSDC (all Windows)
* Seamless GPO integration
* Familiar administration

### But Linux Is Better Because:
* Docker is fundamentally a Linux technology
* Windows adds complexity without benefit for containerized workloads
* Mixed OS infrastructure is common and well-supported
* PowerShell 7+ works identically on both

---

## The Best of Both Worlds

### Windows Where It Matters
* **SRV:** Hyper-V hypervisor (Windows-native)
* **SSDC:** Active Directory (requires Windows)

### Linux Where It's Superior
* **SSDOCK:** Docker workloads (Linux-native)

**This is a proven pattern used by enterprises worldwide.**

---

## Cross-Platform Control Plane

### PowerShell 7+ on Linux
```bash
# Install on Ubuntu
wget https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y powershell

# Same scripts work everywhere
pwsh ./solidstack-deploy.ps1
```

### Domain Integration
* Linux can join Active Directory via realmd/sssd
* SSDOCK will be domain-joined to solidstate.local
* Inherits trust and can request certificates
* SSH access works the same

### Unified Management
* Same SSH key authentication
* Same 1Password integration
* Same SolidStack control plane
* Same git-based configuration

---

## Real-World Pattern

```
Many organizations run:

Infrastructure Services (Windows)
├─ Hyper-V or VMware hosts
├─ Active Directory
├─ DNS and DHCP
└─ File servers

Application Services (Linux)
├─ Docker/Kubernetes
├─ Web applications
├─ Databases
└─ Development platforms
```

**You're following industry best practices.**

---

## What About Future Windows Workloads?

### If You Need Windows Applications:
* Create a separate Windows VM for that specific workload
* Don't mix Windows applications with Docker on the same node
* Keep execution platforms focused

**Example:**
```
SSDOCK (Linux) → Docker containers
SSAPP (Windows) → Native Windows apps (if needed)
```

### But Most Self-Hosted Services Are:
* Linux-based containers
* Cross-platform (Node.js, Python, Go)
* Designed for containerization

---

## Migration Considerations

### Moving to Linux Means:
* Learning basic Linux commands (you already know SSH)
* Different package manager (apt vs. PowerShell)
* Same PowerShell scripts (cross-platform)

### You Already Have:
* SSH experience (SRV and SSDC)
* PowerShell knowledge
* Git and 1Password CLI familiarity

**The learning curve is minimal, and the benefits are significant.**

---

## Docker Desktop vs Docker Engine

### Docker Desktop (What You Originally Planned)
* GUI application
* Not supported on Windows Server
* Not free for enterprise use
* Adds complexity

### Docker Engine (What You'll Actually Use)
* Native container runtime
* Free and open source
* Standard on Linux
* What production servers use

**Docker Engine on Linux is the industry standard for self-hosting.**

---

## Certificate Management

### AD CS Integration
* Linux systems can request certificates from AD CS
* Via certbot with DNS validation
* Or manual certificate enrollment
* Automatic renewal possible

### Trust Inheritance
* Domain-joined Linux trusts AD certificate authority
* Same PKI infrastructure
* No separate certificate management

---

## Operational Reality

### What Changes:
* Package installation: `apt` instead of Windows Package Manager
* Service management: `systemctl` instead of Windows Services
* File paths: `/opt/` instead of `C:\`

### What Stays the Same:
* PowerShell syntax and scripts
* SSH access and key management
* Git workflows
* 1Password integration
* Docker commands and compose files

---

## The Bottom Line

**Linux for SSDOCK is:**
* ✅ More standard for Docker workloads
* ✅ Better documented and supported
* ✅ More resource-efficient
* ✅ Free and open source
* ✅ Better performing for containers
* ✅ Industry best practice

**Not a compromise—it's the better choice for a Docker execution platform.**

---

## Next Steps

1. Create SSDOCK VM with Ubuntu Server 24.04 LTS
2. Configure static IP (192.168.69.10)
3. Join to solidstate.local domain
4. Install Docker Engine and PowerShell 7+
5. Deploy SolidStack control plane
6. Begin container deployments

**You're building it right.** 🎯
