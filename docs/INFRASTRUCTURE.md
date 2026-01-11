# SolidStack Infrastructure

> Layered, minimal, and grounded

## Overview

SolidStack is built on a tiered architecture that separates concerns and maintains clear boundaries. Each tier has specific responsibilities and changes at different rates.

---

## Layered Structure

### Physical Layer (Tier 0)

**SRV - Hyper-V Host**
* Windows Server 2025
* Hyper-V hypervisor only
* No business logic
* No applications
* Rarely changes

**Purpose:** Foundation for all VMs. Boring and stable by design.

**UniFi Network Hardware**
* Physical network fabric
* Switching, routing, wireless
* Network observability

**Relationship to SolidStack:** Referenced as infrastructure, not managed or configured.

---

### Tier 1 — Identity & Authority

**SSDC - Domain Controller**
* Windows Server 2025 Core
* IP: 192.168.69.5
* Domain: solidstate.local

**Services:**
* Active Directory Domain Services
* DNS Server
* Certificate Authority (Enterprise Root CA)
* Computer certificate auto-enrollment via GPO

**Characteristics:**
* Changes slowly
* Highly trusted
* Defines identity, trust, and security boundaries
* Never hosts business applications

---

### Tier 2 — Execution Platform

**SSDOCK - Docker Host**
* Ubuntu Server 24.04 LTS
* IP: 192.168.69.10
* Domain-joined to solidstate.local

**Services:**
* Docker Engine (native Linux)
* PowerShell 7+
* SolidStack control plane
* Containerized services

**Characteristics:**
* Runs business systems
* Hosts integrations
* Safe to experiment in
* Easy to rebuild
* Where business logic lives (in containers)

---

### Tier 3 — Redundancy (Phase 2)

**Deferred Until Core Stack is Stable**

Future considerations:
* Secondary domain controller
* Replicated workloads
* High availability patterns

**Philosophy:** Build and trust the core before adding complexity.

---

## Network Design

```
192.168.69.0/24
├─ .1         Gateway/Router (UniFi)
├─ .4         SRV (Hyper-V host)
├─ .5         SSDC (Primary DC)
├─ .6         Reserved for secondary DC (Phase 2)
├─ .10        SSDOCK (Docker host)
├─ .20-29     File/Storage VMs (future)
├─ .30-39     Monitoring/Management VMs (future)
└─ .100-199   DHCP pool (workstations)
```

---

## Certificates & Trust Model

### Internal PKI
* Provided by AD CS on SSDC
* Certificates are:
  * Auto-issued
  * Auto-renewed
  * Trusted by all domain computers

### Domain-Joined Linux
* SSDOCK (Ubuntu) joins domain via realmd/sssd
* Can request certificates via certbot or manual enrollment
* Inherits trust from domain membership

**Philosophy:** Certificates are infrastructure, not app concerns. Applications do not manage their own certificates.

---

## Component Classification

### 1. Control Plane / Governance (SolidStack Core)

**SolidStack**
* The control plane itself
* Registry of services, nodes, relationships
* Answers: "What exists, and where do I go to fix it?"
* Lives logically on SSDOCK
* Conceptually above all stacks

**AI Router**
* Shared intelligence gateway
* Routes requests to Claude / other models
* Enforces policy, context, cost control
* As a shared service on SSDOCK
* Registered once in SolidStack

**1Password CLI (op)**
* Authoritative secrets and identity source
* SSH keys, tokens, credentials
* External authority
* Referenced by SolidStack
* Used by SSDOCK and operators

---

### 2. Network & Access Fabric

**Tailscale**
* Private mesh networking
* Secure access between devices, offices, servers
* Documented in SolidStack as connectivity layer

**Cloudflare**
* Public edge
* DNS, protection, ingress, tunneling
* Linked to SolidStack as public boundary

**Stablepoint Hosting**
* External compute / hosting provider
* External node class in SolidStack

---

### 3. Execution & Workloads (Tier 2)

**Docker / Containers**
* Deployment mechanism
* Isolation boundary for apps
* On SSDOCK only

**Business Systems** (examples)
* OpenSign (contract signing)
* Dialpad → BI Integration (Prettypaws)
* Customized Groomtrax (operational system)

---

### 4. Personal Data & Recovery

**Personal Stack** (isolated from business)
* Plex (media consumption)
* BitTorrent (media acquisition)
* Antivirus (baseline host hygiene)

---

## Why This Architecture?

### Clear Separation of Concerns
* **Physical layer:** Provides compute
* **Identity layer:** Provides trust
* **Execution layer:** Runs workloads
* **Control plane:** Coordinates everything

### Migration & Portability
* Infrastructure defined in git
* Secrets in 1Password
* Data in backups
* Recovery = clone + restore

### Calm Under Failure
* Know which layer is responsible
* Clear escalation path
* No tangled dependencies

### Human-Centered
* Reduces cognitive load
* Supports breaks and context switching
* Safe to experiment in Tier 2
* Phase 2 deferred until trust is established

---

## Evolution Path

### Current State (Phase 1)
✅ SRV (Hyper-V host)
✅ SSDC (Domain controller)
🎯 SSDOCK (Docker host - next step)

### Phase 2 (Redundancy)
⏳ Secondary domain controller
⏳ Replicated workloads
⏳ High availability patterns

### Phase 3 (Scale)
⏳ Additional execution nodes
⏳ Workload distribution
⏳ Geographic distribution (SRVR at second location)

---

## Key Insight

**This is not one giant system.**

It's:
* One control plane (SolidStack)
* Multiple isolated stacks (business, personal, platform)
* Clear authority boundaries
* A system that explains itself

**Physical stays boring. Virtual stays flexible. Identity stays trusted. Execution stays safe.**
