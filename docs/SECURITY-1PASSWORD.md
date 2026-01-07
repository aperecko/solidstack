# 🔐 1Password CLI Integration for SolidStack

## Why 1Password CLI?

**1Password CLI (`op`) is the PERFECT secret management solution for SolidStack.**

### The Problem with Secrets in Self-Hosting

When you self-host services, you need:
- Database passwords
- API keys
- SSL certificates
- Service credentials
- GitHub tokens
- Backup encryption keys

**❌ Bad approaches:**
- Hard-coding in scripts → Security disaster
- `.env` files in git → Leaked secrets
- Plain text on disk → Easy to steal
- Manual management → Error-prone

**✅ The SolidStack + 1Password Solution:**
- Secrets stored in 1Password vault
- Retrieved via `op` CLI only when needed
- Never written to disk unencrypted
- Audit trail of secret access
- Easy backup/migration
- Team sharing (optional)

## Architecture

```
┌──────────────────────────────────────────┐
│  1Password Account (Cloud)               │
│  └─ "SolidStack" Vault                  │
│     ├─ Database Passwords                │
│     ├─ API Keys                          │
│     ├─ Service Credentials               │
│     └─ Backup Encryption Keys            │
└──────────────────────────┬───────────────┘
                           │
                           │ Authenticated via
                           │ op CLI (biometric/password)
                           │
┌──────────────────────────▼───────────────┐
│  SolidStack Control Plane                │
│  C:\SolidStack\                          │
│  ├─ tools\op.exe       (1Password CLI)   │
│  └─ repo\src\lib\      (secret retrieval)│
└──────────────────────────┬───────────────┘
                           │
                           │ Injects secrets
                           │ at runtime (never saved)
                           │
┌──────────────────────────▼───────────────┐
│  Docker Containers                       │
│  └─ Services get secrets as env vars     │
│     (ephemeral, never logged)            │
└──────────────────────────────────────────┘
```

## Setup Guide

### Prerequisites

1. **1Password Account** with CLI access
2. **op CLI installed** - Already at `C:\SolidStack\tools\op.exe` ✅

### Step 1: Set Up 1Password CLI

```powershell
# Test if op is working
& C:\SolidStack\tools\op.exe --version

# Sign in to your 1Password account (one-time setup)
& C:\SolidStack\tools\op.exe signin

# This creates a session that can be reused
```

### Step 2: Create SolidStack Vault in 1Password

Using 1Password app:

1. Create a new vault called "SolidStack"
2. This will hold all your infrastructure secrets
3. Share with team members who need access (optional)

### Step 3: Add Secrets to 1Password

Create items in your "SolidStack" vault with this structure:

```
Item Type: "Login" or "Password"
Title: traefik-dashboard
username: admin
password: [your secure password]
section: solidstack
tags: traefik, infrastructure

Item Type: "Password"  
Title: postgres-root-password
password: [your secure password]
section: solidstack
tags: postgres, database

Item Type: "API Credential"
Title: cloudflare-api-token
credential: [your API token]
section: solidstack
tags: cloudflare, dns
```

### Step 4: Configure SolidStack to Use 1Password

I'll create a secrets management module for you that integrates with `op`.

## Usage Patterns

### Pattern 1: Retrieve Secret in Script

```powershell
# Source the secrets library
. "$PSScriptRoot/../lib/secrets.ps1"

# Get a secret
$dbPassword = Get-Secret "postgres-root-password"

# Use it (it's only in memory, never saved)
docker run -e POSTGRES_PASSWORD="$dbPassword" postgres
```

### Pattern 2: Inject into Docker Compose

```yaml
# docker-compose.yml
services:
  wordpress:
    image: wordpress
    environment:
      WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}
```

```powershell
# deploy script
. src/lib/secrets.ps1

# Export secrets as env vars for docker-compose
$env:WORDPRESS_DB_PASSWORD = Get-Secret "wordpress-db-password"

# Deploy
docker-compose up -d

# Clear secrets from environment
Remove-Item Env:WORDPRESS_DB_PASSWORD
```

### Pattern 3: Generate Docker Env File (Temporary)

```powershell
# Create temporary .env file with secrets
New-SecretEnvFile -Vault "SolidStack" -Output "stack/.env.secrets"

# Use with docker-compose
docker-compose --env-file stack/.env.secrets up -d

# Clean up immediately
Remove-Item "stack/.env.secrets" -Force
```

## Secret Naming Convention

Use consistent naming in 1Password:

```
Format: {service}-{type}-{descriptor}

Examples:
- traefik-password-dashboard
- postgres-password-root
- cloudflare-apikey-dns
- restic-password-encryption
- github-token-packages
- smtp-password-notifications
```

## Migration Scenario

### Old Server → New Server

**On old server (nothing to do!):**
- Secrets are in 1Password cloud ✅
- SolidStack code is in GitHub ✅

**On new server:**
```powershell
# 1. Install op CLI
# 2. Sign in to 1Password
& C:\SolidStack\tools\op.exe signin

# 3. Clone SolidStack
git clone https://github.com/you/solidstack C:\SolidStack\repo

# 4. Deploy services (secrets auto-fetched!)
cd C:\SolidStack\repo
pwsh bin/solidstack.ps1 deploy wordpress

# That's it! All secrets retrieved automatically
```

## Security Best Practices

### ✅ DO

1. **Use unique passwords** for each service
2. **Enable 2FA** on your 1Password account
3. **Use biometric unlock** for op CLI when possible
4. **Rotate secrets regularly** (1Password tracks this)
5. **Audit secret access** via 1Password activity log
6. **Use separate vaults** for production vs testing

### ❌ DON'T

1. **Never commit** secrets to git (even encrypted)
2. **Never log** secret values
3. **Never store** secrets in plain text files
4. **Never share** your 1Password master password
5. **Never bypass** op CLI to manage secrets

## Emergency Access

### If You Lose Access to 1Password

Set up **Emergency Kit** in 1Password:
1. Print your Emergency Kit
2. Store in physical safe
3. Includes Secret Key + master password

### If Server Compromised

1. **Revoke all secrets** in 1Password (one click per vault)
2. **Regenerate** new secrets
3. **Redeploy** services with new credentials
4. **Review** 1Password activity log for what was accessed

## Advanced: Secret Templates

Create templates for common service types:

```yaml
# templates/postgres-secrets.yml
secrets:
  - name: postgres-root-password
    type: password
    length: 32
    special: true
  - name: postgres-app-password
    type: password
    length: 32
    special: false
```

Then generate and store in one command:
```powershell
New-ServiceSecrets -Template templates/postgres-secrets.yml -Vault SolidStack
```

## Backup Strategy

**1Password handles backup automatically:**
- Secrets stored in cloud ✅
- Encrypted at rest ✅
- Versioned (can recover old passwords) ✅
- Disaster recovery built-in ✅

**For SolidStack configuration:**
- Code in GitHub ✅
- Data in Docker volumes → Backed up via Restic
- Secrets in 1Password ✅

**Complete disaster recovery:**
```powershell
# New server, everything lost
# 1. Install Windows, Docker, PowerShell
# 2. Clone from GitHub
# 3. Sign in to 1Password
# 4. Restore data from Restic backup
# 5. Deploy
# → Fully operational!
```

## Cost

**1Password Plans:**
- Individual: $2.99/month - Perfect for single dev
- Families: $4.99/month - Share with family
- Teams: $7.99/user/month - For work teams

**Worth it?** Absolutely! Compare to:
- AWS Secrets Manager: $0.40/secret/month
- HashiCorp Vault: Self-hosted complexity
- Azure Key Vault: $0.03/10k operations

**1Password advantages:**
- Unlimited secrets
- Beautiful UI
- Mobile apps
- Browser extension
- Team sharing
- Activity audit logs

## Integration with Other Tools

### SolidStack + 1Password + GitHub

```powershell
# Store GitHub token in 1Password
op item create --category=login \
  --title="github-token-solidstack" \
  --vault=SolidStack \
  token[password]="ghp_xxxxxxxxxxxx"

# Use in deploy script
$githubToken = Get-Secret "github-token-solidstack"
gh auth login --with-token <<< $githubToken
```

### SolidStack + 1Password + Docker

```powershell
# Store Docker Hub credentials
op item create --category=login \
  --title="dockerhub-solidstack" \
  --vault=SolidStack \
  username="youruser" \
  password="yourpass"

# Use in deploy
$dockerUser = Get-Secret "dockerhub-solidstack" -Field username
$dockerPass = Get-Secret "dockerhub-solidstack" -Field password
docker login -u $dockerUser -p $dockerPass
```

### SolidStack + 1Password + Restic

```powershell
# Store backup encryption password
op item create --category=password \
  --title="restic-password-encryption" \
  --vault=SolidStack \
  password="[secure password]"

# Use in backup script
$env:RESTIC_PASSWORD = Get-Secret "restic-password-encryption"
restic backup /data
Remove-Item Env:RESTIC_PASSWORD
```

## Comparison to Alternatives

| Solution | Pros | Cons |
|----------|------|------|
| **1Password** | ✅ Easy to use<br>✅ Great UI<br>✅ Team sharing<br>✅ Mobile access<br>✅ Audit logs | 💵 Paid service |
| **HashiCorp Vault** | ✅ Free<br>✅ Enterprise features | ❌ Complex setup<br>❌ Requires maintenance |
| **AWS Secrets Manager** | ✅ AWS integration | ❌ Expensive<br>❌ AWS-only |
| **.env files** | ✅ Simple | ❌ Insecure<br>❌ Hard to share<br>❌ Easy to leak |
| **Environment vars** | ✅ Simple | ❌ Visible to all processes<br>❌ Hard to manage |

**For self-hosting:** 1Password is the sweet spot of security + ease of use.

## SolidStack Philosophy

**Secrets are NEVER in Git:**
```
C:\SolidStack\repo\               # ← In Git
├─ src/                           # ← In Git  
├─ stack/compose/                 # ← In Git (no secrets!)
├─ stack/config/                  # ← In Git (public configs)
└─ docs/                          # ← In Git

C:\SolidStack\stack/secrets/      # ← NOT in Git (gitignored)
└─ [empty - we use 1Password!]    # ← Secrets live in 1Password

1Password Vault                   # ← In the cloud (encrypted)
└─ SolidStack/                    # ← All secrets here
   ├─ postgres-password
   ├─ traefik-password
   └─ ...
```

## Quick Start Commands

```powershell
# Install op CLI (if not already at C:\SolidStack\tools\op.exe)
winget install 1Password.CLI

# Sign in (one-time)
op signin

# Add a secret
op item create --category=password \
  --vault=SolidStack \
  --title="my-secret" \
  password="super-secure-password"

# Retrieve a secret
op read "op://SolidStack/my-secret/password"

# Use in SolidStack (with the library I'll create)
pwsh -c ". src/lib/secrets.ps1; Get-Secret 'my-secret'"
```

## Next Steps

I'll now create:
1. `src/lib/secrets.ps1` - PowerShell library for secret management
2. `tools/setup-1password.ps1` - Setup wizard
3. Examples in deploy scripts

---

**1Password + SolidStack = Secure, Portable, Professional Secret Management! 🔐**
