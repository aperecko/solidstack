# SolidStack

> A traceable, modular self-host stack for Windows Server + Docker Desktop

[![PowerShell 7+](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## What is SolidStack?

SolidStack is a PowerShell-based command-line tool for managing self-hosted Docker services on Windows Server. It's designed with traceability in mind - every command logs its actions, making it easy to understand what happened and when.

**Perfect for:**
- Non-programmers who want to self-host services
- Learning DevOps concepts hands-on
- Maintaining a clear audit trail of all operations
- Getting AI assistance (all output is AI-friendly)

## Key Features

- 📝 **Everything is logged** - Timestamped logs for every command
- 🔒 **Secrets stay local** - Never accidentally commit sensitive data
- 🧩 **Modular design** - Compose services from multiple Docker Compose files
- 🤖 **AI-friendly** - Output designed for copy/paste to AI assistants
- 📊 **Status reports** - Always know what's running and what's not

## Quick Start

### Prerequisites
- Windows Server 2019+ or Windows 10/11
- Docker Desktop
- PowerShell 7+ (we'll help you install it)

### Installation

1. **Clone or download this repo** to `C:\SolidStack\repo`

2. **Install PowerShell 7+** (if not already installed):
   ```powershell
   powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1
   ```

3. **Close and reopen your terminal**, then verify:
   ```powershell
   pwsh -v
   # Should show: PowerShell 7.x.x
   ```

4. **Run your first command**:
   ```powershell
   pwsh -File C:\SolidStack\bin\solidstack.ps1 status
   ```

## Usage

### Basic Commands

```powershell
# Check system status
pwsh -File C:\SolidStack\bin\solidstack.ps1 status

# View latest status report
pwsh -File C:\SolidStack\bin\solidstack.ps1 report latest

# List all reports
pwsh -File C:\SolidStack\bin\solidstack.ps1 report list

# Show a specific report
pwsh -File C:\SolidStack\bin\solidstack.ps1 report show C:\SolidStack\reports\status-20260106-123456.txt
```

### Where Things Live

```
C:\SolidStack\
├── bin\              # Main scripts you run
├── repo\             # This git repository
│   ├── src\         # Source code
│   └── docs\        # Documentation
├── stack\            # Runtime files (NOT in git)
│   ├── compose\     # Docker Compose files
│   ├── config\      # Service configurations
│   ├── data\        # Docker volumes
│   ├── logs\        # All command logs
│   └── secrets\     # Sensitive files (git ignored)
├── reports\         # Status reports
└── tools\           # Helper tools
```

## Design Philosophy

SolidStack follows simple rules:

1. **Config as code** - Everything (except secrets) is in git
2. **Trace everything** - Every command writes a timestamped log
3. **AI-friendly output** - Easy to copy/paste for help
4. **Modular services** - Compose multiple Docker files together
5. **Secrets stay local** - Never in git, ever

See [docs/decisions.md](repo/docs/decisions.md) for architectural decisions.

## For Non-Programmers

Don't worry if you're not a programmer! SolidStack is designed to be approachable:

- Commands are simple and explained
- Every action is logged so you can see what happened
- Documentation is written in plain English
- The AI-friendly output means you can paste logs to ChatGPT/Claude for help
- See [CONTRIBUTING.md](repo/CONTRIBUTING.md) for step-by-step guidance

## Documentation

- [Contributing Guide](repo/CONTRIBUTING.md) - How to make changes (non-programmer friendly!)
- [Context Capsule](docs/CONTEXT-CAPSULE.md) - Quick overview of the project
- [Architectural Decisions](repo/docs/decisions.md) - Why things are built this way
- [PowerShell 7+ Migration](docs/PWSH-MIGRATION.md) - Details on the pwsh upgrade
- [Roadmap](docs/ROADMAP.md) - What's coming next

## Development

### Running from Source

```powershell
cd C:\SolidStack\repo
pwsh src\solidstack.ps1 status
```

### Adding a New Command

1. Create `src/commands/yourcommand.ps1`
2. Add it to the switch statement in `src/solidstack.ps1`
3. Test it: `pwsh src\solidstack.ps1 yourcommand`
4. Document it in the help text

See [CONTRIBUTING.md](repo/CONTRIBUTING.md) for more details.

## Troubleshooting

### "Command not found" or "Execution policy" errors

Make sure you're using PowerShell 7+ and running with `-File`:
```powershell
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
```

### "SolidStack requires PowerShell 7+"

Install PowerShell 7+:
```powershell
powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1
```

### Check the logs

Every command logs to `C:\SolidStack\stack\logs\`. Look at the most recent file:
```powershell
Get-ChildItem C:\SolidStack\stack\logs\*.log | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | Get-Content
```

### Get AI Help

All output is designed to be copy/pasted to ChatGPT or Claude. Just run a command and paste the entire output for assistance.

## Contributing

Contributions welcome! See [CONTRIBUTING.md](repo/CONTRIBUTING.md) for:
- How to make changes (even if you're not a programmer)
- Development workflow
- Commit message format
- Pull request guidelines

## License

MIT License - see [LICENSE](LICENSE) for details

## Acknowledgments

- Built for Windows Server self-hosters
- Designed with non-programmers in mind
- AI-assisted development friendly

## Support

- 📝 [Open an issue](https://github.com/YOUR_USERNAME/solidstack/issues) for bugs or questions
- 💬 Check existing issues for similar problems
- 📚 Read the docs in `docs/` folder
- 🤖 Paste logs to AI assistants for help
