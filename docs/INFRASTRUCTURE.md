# SolidStack Infrastructure

> Layered architecture for calm, grounded operation

## Overview

SolidStack is designed around a **tiered architecture** where each layer has a clear responsibility and rate of change. This document describes the physical and virtual infrastructure that makes up the SolidStack system.

---

## Layered Structure

### Layer 0: Physical Infrastructure

**Purpose:** Foundational hardware and network fabric

**Components:**

**SRV (Physical Server)**
* Role: Hyper-V host only
* OS: Windows Server 2025
* Resources: 32GB RAM, 8 CPU cores
* IP: 192.168.69.4
* Responsibility: Bare hypervisor, no business logic, no apps
* Rate of change: Rarely

**UniFi Network Infrastructure**
* Role: Physical network fabric
* Components: Switching, routing, wireless access
* Responsibility: Network connectivity and observability
* Management: External to SolidStack (observed, not orchestrated)
* Rate of change: Rarely

---

### Tier 1: Identity & Authority

**Purpose:** Define trust, identity, and security boundaries

**Components:**

**SSDC (Domain Controller)**
* Type: Windows Server 2025 Core VM
* IP: 192.168.69.5
* Domain: solidstate.local
* Services:
  * Active Directory Domain Services
  * DNS Server
  * Certificate Authority (AD CS Enterprise Root CA)
  * Computer certificate auto-enrollment via GPO
* Responsibility: Identity authority, authentication, internal DNS, PKI
* Rate of change: Slow (measured in months)
* Trust level: Highly trusted
* Experimentation: **Never** - this is production identity

**Why Windows:**
* Active Directory is the identity foundation
* Certificate Services for internal PKI
* DNS authority for internal resolution
* Proven, stable, well-understood

---

### Tier 2: Execution Platform

**Purpose:** Run business systems and containerized services

**Components:**

**SSDOCK (Docker Host)**
* Type: Ubuntu Server 24.04 LTS VM
* IP: 192.168.69.10
* Domain: solidstate.local (joined via realmd/sssd)
* Resources: 4 cores, 12GB RAM, 200GB disk
* Services:
  * Docker Engine (native Linux)
  * PowerShell 7+
  * SolidStack control plane
  * Containerized services (Traefik, Portainer, business apps)
* Responsibility: Execute workloads, host containers, run SolidStack
* Rate of change: Fast (daily/weekly)
* Experimentation: **Safe** - designed to be rebuilt easily
* Trust level: Trusted (domain-joined, certificate-enrolled)

**Why Linux:**
* Docker is native and standard on Linux
* Better performance for containers (no Hyper-V isolation overhead)
* Lighter resource footprint
* More standard documentation and community support
* Free and open source (no licensing overhead)
* PowerShell 7+ runs identically on Linux and Windows

---

### Tier 3: Redundancy (Phase 2)

**Purpose:** High availability and disaster recovery

**Components (Planned):**

**SRV-DC2 (Secondary Domain Controller)**
* Type: Windows Server Core VM
* IP: 192.168.69.6
* Purpose: AD replication, DNS failover, CA redundancy
* Status: **Deferred until core stack is stable**

**SRVR (Second Physical Server)**
* Location: Different physical location
* Purpose: Geographic redundancy, cross-site replication
* Status: **Phase 2 - explicitly deferred**

**Design principle:** Redundancy is built only after the core system is proven and trusted.

---

## Network Design

```
192.168.69.0/24 Subnet

.1          Gateway/Router (UniFi)
.4          SRV (Hyper-V host - Windows)
.5          SSDC (Domain Controller - Windows)
.6          [Reserved for SRV-DC2 - Phase 2]
.10         SSDOCK (Docker host - Linux)
.20-29      [Reserved for file/storage VMs]
.30-39      [Reserved for monitoring/management VMs]
.100-199    DHCP pool (workstations)
```

---

## Access & Connectivity

### SSH Access

All servers are accessible via SSH with key-based authentication:

```bash
# From operator Mac
ssh srv      # 192.168.69.4 (SRV)
ssh ssdc     # 192.168.69.5 (SSDC)
ssh ssdock   # 192.168.69.10 (SSDOCK)
```

**Authentication:**
* ED25519 SSH key stored in 1Password
* 1Password SSH agent integration
* Biometric unlock on Mac

### Tailscale Mesh (Planned)

**Purpose:** Private mesh networking for access from anywhere

**Benefits:**
* Access nodes from phone, laptop, remote locations
* Encrypted peer-to-peer connectivity
* Failover when local network unavailable
* Cross-location connectivity (when SRVR is added)

**Status:** Planned, not yet implemented

---

## Domain Integration

### Windows Domain: solidstate.local

**Domain Controller:** SSDC (192.168.69.5)

**Domain Members:**
* SSDC (DC itself)
* SSDOCK (Linux, joined via realmd/sssd)
* [Future VMs will auto-join during deployment]

**Benefits of Domain Membership:**
* Centralized identity (SOLIDSTATE\Administrator)
* Automatic certificate enrollment (via GPO on Windows, manual/certbot on Linux)
* DNS resolution (internal hostnames)
* Trust relationships (cross-node authentication)

---

## Certificate Authority

**Provider:** Active Directory Certificate Services (AD CS) on SSDC

**Certificate Types:**
* Computer certificates (auto-enrolled for domain computers)
* Service certificates (for HTTPS, internal services)
* User certificates (optional, for advanced scenarios)

**Trust Model:**
* Internal CA is trusted by all domain members
* Certificates auto-renew before expiration
* Applications do NOT manage their own certificates
* SolidStack treats certificates as infrastructure, not app concerns

---

## Platform Choices Explained

### Why Windows for SSDC?

Active Directory and Certificate Services are Windows-native and proven. There's no compelling reason to replace them with Linux alternatives (FreeIPA, etc.) for a small infrastructure.

### Why Linux for SSDOCK?

Docker is native to Linux, and most self-hosting documentation assumes Linux. The execution platform benefits from:
* Native container runtime (no Hyper-V isolation layer)
* Lighter resource usage
* Standard tooling and community support
* Cost savings (no Windows licensing)
* Identical PowerShell 7+ experience

**Trade-off accepted:** Slightly more complex AD integration on Linux (realmd/sssd), but well-documented and stable.

### Why Not Run Everything on One Server?

**Stratification provides:**
* Clear responsibility boundaries ("Where do I fix this?")
* Safe experimentation space (SSDOCK can be rebuilt)
* Reduced blast radius (identity layer isolated from execution layer)
* Easier migration (VMs can move between hosts)
* Phased redundancy (add SRVR later without redesign)

---

## Data Flow Example

```
User Request (external)
    ↓
Cloudflare (public edge, DNS)
    ↓
Traefik on SSDOCK (reverse proxy, HTTPS termination)
    ↓
Application Container on SSDOCK (business logic)
    ↓
Data Volume on SSDOCK (persistence)
    ↓
Backup via Restic → Cloud Storage
```

**Authentication Flow:**
```
Operator connects via SSH/Tailscale
    ↓
Authenticates to SOLIDSTATE domain (via SSDC)
    ↓
Accesses SSDOCK (domain-joined, trusted)
    ↓
Manages containers (Docker, SolidStack control plane)
```

---

## Deployment Strategy

### Bootstrap Order

1. **SRV** (Physical) - Install Hyper-V, configure networking
2. **SSDC** (VM) - Promote to DC, configure DNS/CA
3. **SSDOCK** (VM) - Install Ubuntu, join domain, deploy SolidStack
4. **Services** (Containers) - Deploy via SolidStack control plane

### Migration Path

**To move to a new physical host:**

1. Install Hyper-V on new server (SRVR)
2. Export VMs from SRV, import to SRVR
3. Update DNS records (if IP addresses change)
4. Replicate domain controller (SRV-DC2)
5. Test failover, then cut over

**Key insight:** Because VMs are stratified and domain-integrated, migration is a well-defined process, not a crisis.

---

## Future Considerations

### Phase 2: Redundancy

* Add SRV-DC2 (secondary domain controller)
* Implement VM replication between SRV and SRVR
* Set up Tailscale for cross-site connectivity
* Test failover procedures

### Phase 3: Specialized Workloads

* File server VM (if needed)
* Monitoring VM (if central monitoring is desired)
* Development/staging environment (isolated from production)

---

## Summary

**The infrastructure is designed to be:**

* **Boring at the foundation** (SRV, UniFi - rarely change)
* **Stable in the identity layer** (SSDC - changes slowly)
* **Flexible in the execution layer** (SSDOCK - safe to experiment)
* **Scalable through stratification** (add redundancy when needed)

**The goal:** Answer "where do I go to fix this?" clearly and calmly, every time.
