# Contributing to SolidStack

## For Non-Programmers

Welcome! SolidStack is designed to be approachable even if you're not a programmer. Here's how to work with it:

### Making Changes

1. **Edit files** - Use any text editor (Notepad++, VS Code, or even Notepad)
2. **Test changes** - Run `pwsh -File C:\SolidStack\bin\solidstack.ps1 status`
3. **Check what changed** - Run `git status` in `C:\SolidStack\repo`
4. **Save changes** - Run `git add .` then `git commit -m "describe what you changed"`
5. **Push to GitHub** - Run `git push`

### Getting Help

- Check `docs/` folder for documentation
- Look at recent commits to see what changed: `git log --oneline`
- Create an issue on GitHub if something breaks
- All commands log to `stack/logs/` - these help with debugging

### Understanding the Structure

```
C:\SolidStack\
├── bin\              # The main runner script
├── repo\             # Git-tracked source code
│   ├── src\         # PowerShell scripts
│   └── docs\        # Documentation
├── stack\            # Runtime (NOT in git)
│   ├── logs\        # All command logs
│   ├── secrets\     # Keep private!
│   └── data\        # Docker volumes
├── docs\            # Main documentation
└── tools\           # Helper tools (pwsh installer, etc)
```

## For Developers

### Prerequisites
- PowerShell 7+
- Docker Desktop
- Git
- GitHub CLI (optional but helpful)

### Setup
```powershell
# Clone the repo
git clone https://github.com/YOUR_USERNAME/solidstack.git C:\SolidStack\repo

# Install PowerShell 7+ if needed
powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1

# Test it
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
```

### Development Workflow

1. Create a branch for your changes:
   ```powershell
   cd C:\SolidStack\repo
   git checkout -b feature/my-new-feature
   ```

2. Make your changes and test thoroughly

3. Commit with clear messages:
   ```powershell
   git add .
   git commit -m "Add: brief description of what this does"
   ```

4. Push and create a pull request:
   ```powershell
   git push origin feature/my-new-feature
   ```

### Commit Message Format

- `Add:` for new features
- `Fix:` for bug fixes
- `Update:` for changes to existing features
- `Docs:` for documentation only
- `Refactor:` for code restructuring

### Testing

Always test before committing:
```powershell
# Run status check
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# Check logs
Get-Content C:\SolidStack\stack\logs\solidstack-status-*.log | Select-Object -Last 50
```

### Pull Request Guidelines

- Include a clear description of what changed and why
- Reference any related issues
- Ensure all tests pass
- Update documentation if needed

## Architecture Decisions

See `docs/decisions.md` for architectural decision records (ADRs) that explain why things are built the way they are.

## Questions?

Open an issue on GitHub or check existing issues for similar questions.
