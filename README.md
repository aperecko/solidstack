# SolidStack

> Universal deployment platform - Available in PowerShell and Rust

[![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue.svg)](https://github.com/aperecko/solidstack/tree/powershell)
[![Rust](https://img.shields.io/badge/Rust-Experimental-orange.svg)](https://github.com/aperecko/solidstack/tree/rust)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 🎭 The Concept (Universal)

**SolidStack is a control plane for Docker services - think of it as a conductor orchestrating containers.**

```
🏛️ Server     = Concert hall (any OS)
🎼 SolidStack = Conductor (orchestrates everything)
🎻 Containers = Orchestra (your services)
```

Read more: [Theater Analogy](docs/THEATER-ANALOGY.md)

---

## 🔀 Two Implementations

We're building SolidStack in **two languages simultaneously** to:
- Learn trade-offs between paradigms
- Give users choice
- Validate architecture across languages
- Build the best tool possible

### PowerShell Implementation

**Status:** ✅ Production Ready  
**Branch:** [`powershell`](https://github.com/aperecko/solidstack/tree/powershell)

**Best for:**
- Windows Server environments
- PowerShell users
- Rich Windows integration
- Quick modifications

**Install:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aperecko/solidstack/powershell/install.ps1" -OutFile "$env:TEMP\solidstack-install.ps1"; powershell -ExecutionPolicy Bypass -File "$env:TEMP\solidstack-install.ps1"
```

**Requirements:**
- PowerShell 7+ (auto-installed)
- Windows/Linux/macOS

### Rust Implementation

**Status:** 🚧 Experimental (In Development)  
**Branch:** [`rust`](https://github.com/aperecko/solidstack/tree/rust)

**Best for:**
- Minimal dependencies
- Cross-platform deployment
- Performance-critical scenarios
- Single-binary distribution

**Install:**
```bash
curl -fsSL https://raw.githubusercontent.com/aperecko/solidstack/rust/install.sh | bash
```

**Requirements:**
- None! Single binary

---

## 🎯 Shared Architecture

Both implementations follow the same:
- [Command Specifications](specs/commands.yaml)
- [Output Format](specs/report-format.yaml)
- [Configuration Schema](specs/config.yaml)
- [Theater Mental Model](docs/THEATER-ANALOGY.md)

This means:
- ✅ Same commands work in both
- ✅ Compatible configuration files
- ✅ Same output format
- ✅ Easy to switch between them

---

## 📚 Documentation

### Getting Started
- [Quick Start Guide](docs/QUICKSTART.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [Installation Guide](docs/INSTALL-SERVER.md)

### Using SolidStack
- [Theater Analogy](docs/THEATER-ANALOGY.md) ⭐ Start here!
- [Command Reference](docs/COMMANDS.md)
- [Configuration Guide](docs/CONFIG.md)

### For Developers
- [Contributing Guide](CONTRIBUTING.md)
- [Parallel Implementation Strategy](PARALLEL-IMPLEMENTATION.md)
- [Architectural Decisions](docs/decisions.md)

### Platform-Specific
- [Using from macOS](docs/USING-FROM-MAC.md)
- [Windows Installation](docs/INSTALL-SERVER.md)
- [AI Assistant Guide](docs/AI-ASSISTANT-GUIDE.md)

---

## 🚀 Quick Examples

### PowerShell Version
```powershell
# Check status
pwsh -File ~/.solidstack/bin/solidstack.ps1 status

# Deploy service (coming soon)
pwsh -File ~/.solidstack/bin/solidstack.ps1 deploy wordpress
```

### Rust Version
```bash
# Check status
solidstack status

# Deploy service (coming soon)
solidstack deploy wordpress
```

**Same commands, different engine!**

---

## 🔬 The Experiment

We're building both to answer:
- Which is faster?
- Which is easier to maintain?
- Which has better errors?
- Which do users prefer?
- What can each do that the other can't?

**Follow along:** [Parallel Implementation Strategy](PARALLEL-IMPLEMENTATION.md)

---

## 🤝 Contributing

We welcome contributions to either implementation!

- **PowerShell Branch:** Windows-heavy features, rich integrations
- **Rust Branch:** Performance optimizations, cross-platform features
- **Master Branch:** Docs, specs, shared concepts

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## 📊 Comparison

| Feature | PowerShell | Rust |
|---------|------------|------|
| **Install Size** | ~100MB | ~5-10MB |
| **Startup Time** | ~500ms | <10ms |
| **Dependencies** | PS7 + .NET | None |
| **Modification** | Edit script | Recompile |
| **Windows Integration** | Excellent | Good |
| **Cross-Platform** | Good | Excellent |
| **Status** | ✅ Ready | 🚧 Experimental |

---

## 🛣️ Roadmap

### Current (v1.0)
- [x] PowerShell implementation complete
- [x] Cross-platform path abstraction
- [x] Status and reporting commands
- [ ] Rust implementation started

### Next (v1.5)
- [ ] Rust: Basic commands (status)
- [ ] Both: Deploy command
- [ ] Both: Snapshot/restore
- [ ] Performance comparison

### Future (v2.0+)
- [ ] Both: Recipe system
- [ ] Both: Monitoring integration
- [ ] User choice of implementation
- [ ] Hybrid deployment options

---

## 📖 Learn More

- **Why Two Languages?** [Parallel Implementation Strategy](PARALLEL-IMPLEMENTATION.md)
- **Theater Analogy** [The Mental Model](docs/THEATER-ANALOGY.md)
- **Architecture** [How It Works](docs/ARCHITECTURE.md)

---

## 📜 License

MIT License - see [LICENSE](LICENSE) for details

---

## 🙏 Acknowledgments

Built with the help of Claude (Anthropic) through an iterative, learning-focused development process.

The parallel implementation approach is inspired by:
- Ripgrep (Rust grep replacement)
- Deno (Rust Node.js alternative)
- Modern CLI tools choosing performance + UX

**Questions? Open an issue or check the docs!**
