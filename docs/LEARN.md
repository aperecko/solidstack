# SolidStack: What these tools are (and why they matter)
Updated: 2026-01-06 19:20:20

## docker
What: Runs containers (packaged apps) in a repeatable way.
Why here: Lets SolidStack deploy services (reverse proxy, dashboards, backups) consistently.
Youll use it for: docker compose up -d, docker ps, docker logs.

## op (1Password CLI)
What: Command-line access to secrets stored in 1Password.
Why here: Keeps tokens/passwords out of scripts and out of git.
Youll use it for: pulling Cloudflare tokens, service account JSON, restic passwords safely.

## rclone
What: A cloud filesystem tool that can talk to Google Drive and many others.
Why here: Its the glue between your server and your 9TB Drive.
Youll use it for: syncing/mounting a backup repo to Drive.

## git
What: Version history for text files (scripts/config/docs).
Why here: Lets you change your stack without fear; roll back when something breaks.
Youll use it for: tracking stack files + docs changes over time.

## gh (GitHub CLI)
What: Command-line GitHub helper (creates repos, issues, etc).
Why here: Optional. Makes remote backup of your stack config easy.
Youll use it for: creating a private repo + pushing changes.

## How this stays AI-friendly
- status prints whats installed (and logs it)
- undle exports a pasteable snapshot
- ecall prints capsule + latest bundle + log tail
- 
ote leaves breadcrumbs after meaningful changes


