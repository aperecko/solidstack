# macOS User Quick Start

**TL;DR:** You don't need PowerShell on your Mac! Just SSH to the server.

## Your Workflow

```bash
# On Mac: Edit files
cd ~/projects/solidstack
code .                # or vim, or any editor
git commit -am "changes"
git push

# On Server: Run commands
ssh user@server
pwsh -File ~/.solidstack/bin/solidstack.ps1 status
```

## Essential Mac Tools

```bash
# Already have:
✓ SSH (built-in)
✓ Terminal (built-in)
✓ Git (install: xcode-select --install)

# Recommended:
⭐ VS Code + Remote-SSH extension
⭐ iTerm2 (brew install --cask iterm2)
```

## Common Commands

```bash
# Check server status (remotely)
ssh user@server "pwsh -File ~/.solidstack/bin/solidstack.ps1 status"

# Interactive session
ssh user@server
# Now on server - use SolidStack normally
pwsh -File ~/.solidstack/bin/solidstack.ps1 status
exit

# Update server with your changes
ssh user@server "cd ~/.solidstack/repo && git pull"
```

## You're Good to Go! ✨

**Full guide:** docs/USING-FROM-MAC.md
