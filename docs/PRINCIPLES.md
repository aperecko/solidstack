# SolidStack — Core Principles

> Document reality, not intention. Design for calm operation, not perfect uptime.

## Purpose

SolidStack exists to support skillful, grounded execution of:

* Prettypaws (business operations)
* Comar Kennel (business operations)
* Personal data and entertainment

The system is designed to reduce cognitive load, avoid duplicated effort, and ensure that when something breaks, the response is grounded, not alarmed.

---

## Core Principles

### 1. Prevent Redundant Workloads

* One system per responsibility
* No parallel tools doing the same job
* Route to existing capability instead of rebuilding it

### 2. Document Reality, Not Intention

* SolidStack reflects what actually exists
* Schema evolves as the system evolves
* No manual documentation debt

### 3. Always Answer One Key Question

**"Where do I go to fix this?"**

The system should clearly indicate:
* Which layer is responsible
* Which node or service owns the issue

### 4. Stay Grounded Under Failure

* Fewer alerts, clearer boundaries
* Calm recovery > perfect uptime
* Design supports human regulation, not panic

---

## Architectural Philosophy

### Physical Infrastructure Stays Minimal and Boring

* Bare hypervisor only
* No business logic
* No apps
* Rarely changes

### Capability Lives in Virtualized, Well-Scoped Layers

* Identity and authority are isolated
* Execution platforms are separate
* Redundancy is intentional and phased

---

## Scope Boundaries (Very Important)

### SolidStack IS:

* A control plane
* A registry of services and relationships
* A source of truth for "what exists"
* A guide to responsibility and repair

### SolidStack IS NOT:

* An application
* A monitoring platform
* A dashboard-first system
* A place for business logic
* A duplication of tools that already work

---

## Design Intent (Human-Centered)

This system is intentionally designed for:

* Low memory burden
* Recovery after breaks
* Safe experimentation
* Future delegation
* Neurodivergent-friendly operation

**If a design choice increases anxiety, noise, or cognitive load, it is considered a regression.**

---

## Component Classification

### Control Plane / Governance (SolidStack Core)

**These are not apps. They coordinate and describe the system.**

**SolidStack**
* What it is: The control plane, registry of services/nodes/relationships, answers "what exists and where do I fix it?"
* What it is not: Not a service host, not a dashboard-first tool, not where business logic lives
* Lives: Logically on SSDOCK, conceptually above all stacks

**AI Router**
* What it is: Shared intelligence gateway, routes requests to Claude/other models, enforces policy/context/cost control
* What it is not: Not embedded in each app, not a chatbot itself
* Lives: As a shared service on SSDOCK, registered once in SolidStack

**1Password CLI (op)**
* What it is: Authoritative secrets and identity source (SSH keys, tokens, credentials)
* What it is not: Not a configuration system, not a runtime dependency manager
* Lives: External authority, referenced by SolidStack, used by SSDOCK and operators

### Network & Access Fabric

**These define how things talk, not what they do.**

**Tailscale**
* What it is: Private mesh networking, secure access between devices/offices/servers
* What it is not: Not a firewall replacement, not public ingress
* Lives: On hosts and VMs, documented in SolidStack as connectivity layer

**Cloudflare**
* What it is: Public edge (DNS, protection, ingress, tunneling)
* What it is not: Not internal trust authority, not internal routing logic
* Lives: External, linked to SolidStack as public boundary

**UniFi**
* What it is: Physical network fabric (switching, routing, wireless access, network observability)
* What it is not: Not identity authority, not security boundary, not configuration management
* Lives: Physical layer (like SRV), external to VMs but foundational

### Identity, Trust, and Authority (Tier 1)

**These define who is trusted and why.**

**Active Directory (SSDC)**
* What it is: Identity authority, authentication source, DNS authority (internal)
* What it is not: Not an app platform, not an experimentation space
* Lives: Dedicated VM (SSDC), changes slowly

**Certificate Authority (AD CS)**
* What it is: Internal PKI, issues and renews certs automatically
* What it is not: Not app-specific, not manually managed per service
* Lives: On SSDC, consumed by all domain systems

### Execution & Workloads (Tier 2)

**This is where things actually run.**

**SSDOCK**
* What it is: The execution platform, Docker host, home for containerized services, where SolidStack is instantiated
* What it is not: Not identity authority, not hypervisor, not physical infrastructure
* Lives: VM on SRV, safe to rebuild

**Docker / Containers**
* What they are: Deployment mechanism, isolation boundary for apps
* What they are not: Not architecture, not identity, not persistence by default
* Lives: On SSDOCK only

### Business Systems (Workloads, Not Core)

**These serve specific domains and must not overlap.**

**OpenSign**
* What it is: Contract and document signing authority
* What it is not: Not identity, not general document storage
* Lives: Container on SSDOCK, owned by business stack

**Dialpad → BI Integration (Prettypaws)**
* What it is: Data ingestion + insight pipeline, converts communication into business intelligence
* What it is not: Not a general analytics platform, not shared across businesses by default
* Lives: Prettypaws stack on SSDOCK

**Customized Groomtrax**
* What it is: Operational system of record for grooming workflows
* What it is not: Not identity, not analytics, not a generic CRM
* Lives: Business-specific workload, SolidStack documents it as authoritative

### Personal Data & Recovery

**These support you, not the businesses.**

**Plex**
* What it is: Personal media consumption
* What it is not: Not business infrastructure, not shared platform
* Lives: Personal stack, isolated from business concerns

**BitTorrent**
* What it is: Media acquisition upstream of Plex
* What it is not: Not storage, not indexing, not exposed publicly
* Lives: Personal stack only

**Antivirus**
* What it is: Baseline host hygiene
* What it is not: Not security architecture, not monitoring, not prevention of bad design
* Lives: On hosts and VMs, recorded (not orchestrated) by SolidStack

---

## The Big Clarification (Most Important)

**You are not building one giant system.**

You are building:
* One control plane (SolidStack)
* Multiple stacks (business, personal, platform)
* Clear authority boundaries
* A system that explains itself

---

## Certificates & Trust Model

* Internal PKI is provided by AD CS on SSDC
* Certificates are:
  * Auto-issued
  * Auto-renewed
  * Trusted by all domain computers
* Applications do not manage their own certificates

**SolidStack treats certificates as infrastructure, not app concerns.**
