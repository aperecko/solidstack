# SolidStack Roadmap

_Last updated: 2026-01-06_

## ✅ Completed (v1)

### Phase 0: Foundation
- [x] PowerShell 7+ migration
- [x] Modular command structure
- [x] Timestamped logging system
- [x] Status reporting
- [x] GitHub documentation and templates
- [x] Non-programmer friendly docs

## 🚧 In Progress

### Phase 1: Core Infrastructure
1. **Bootstrap + Status Report** ✅ (Mostly done)
   - [x] Tool detection (docker, git, op, rclone)
   - [x] Report generation
   - [ ] Add more system checks (disk space, memory, etc.)

## 📋 Planned

### Phase 2: Networking & Routing
2. **Proxy + HTTPS Routing**
   - [ ] Traefik setup with auto-SSL (Let's Encrypt)
   - [ ] Local dashboard for proxy status
   - [ ] Automatic route configuration
   - [ ] HTTPS redirect enforcement
   - [ ] Wildcard cert support (optional)

### Phase 3: Management
3. **Management UI (Portainer CE)**
   - [ ] Deploy Portainer behind proxy
   - [ ] Container management UI
   - [ ] Stack deployment interface
   - [ ] Volume browser
   - [ ] Log viewer integration

### Phase 4: Backup & Recovery
4. **Backups with Restic**
   - [ ] Restic setup with Google Drive backend (via rclone)
   - [ ] Automated daily backups
   - [ ] Backup verification
   - [ ] Restore procedures and drills
   - [ ] Backup status in reports
   - [ ] Retention policy configuration

### Phase 5: Monitoring (Optional)
5. **System Monitoring**
   - [ ] Uptime tracking
   - [ ] Disk usage alerts
   - [ ] SMART disk health checks
   - [ ] Basic alerting (email/webhook)
   - [ ] Grafana dashboard (optional)

## 🎯 Future Ideas

### Enhancements
- [ ] `solidstack init` command for first-time setup
- [ ] `solidstack update` command to update SolidStack itself
- [ ] `solidstack doctor` command for troubleshooting
- [ ] Interactive mode for beginners
- [ ] Config file validation
- [ ] Secrets management improvements (vault integration?)
- [ ] Multi-environment support (dev/staging/prod)

### Commands to Add
- [ ] `solidstack deploy <service>` - Deploy a service
- [ ] `solidstack backup now` - Manual backup
- [ ] `solidstack restore <timestamp>` - Restore from backup
- [ ] `solidstack logs <service>` - View service logs
- [ ] `solidstack health` - Health check all services

### Documentation
- [ ] Video tutorials
- [ ] Common recipes (deploy WordPress, etc.)
- [ ] Troubleshooting guide
- [ ] Migration guide from Docker Compose

### GitHub Integration
- [ ] GitHub Actions for testing
- [ ] Automated changelog generation
- [ ] Release automation
- [ ] Issue templates for specific service problems

## 🚫 Non-Goals

**We will NOT:**
- Create one giant forever script
- Print secrets to console
- Store secrets in git
- Hide what's happening (everything logs)
- Support non-Windows platforms (focus on Windows Server)
- Require cloud services for core functionality

## 🗓️ Timeline (Rough Estimates)

- **Q1 2026**: Phase 2 (Proxy & Routing)
- **Q2 2026**: Phase 3 (Management UI)
- **Q3 2026**: Phase 4 (Backups)
- **Q4 2026**: Phase 5 (Monitoring)

_Timeline is flexible and based on available time and community feedback_

## 💡 How to Contribute to the Roadmap

- Create an issue for feature requests
- Vote on issues with 👍 reactions
- Comment on issues with your use case
- Submit PRs for items on the roadmap

## 📊 Version History

- **v1.0** (Jan 2026): Initial release with status and reporting
- **v0.9** (Jan 2026): PowerShell 7+ migration and GitHub setup
