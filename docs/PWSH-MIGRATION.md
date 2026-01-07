# PowerShell 7+ Migration Summary
_Created: 2026-01-06_

## What Changed

### 1. Runner Scripts Updated
- `C:\SolidStack\bin\solidstack.ps1`
- `C:\SolidStack\repo\src\solidstack.ps1`

**Changes:**
- Added shebang: `#!/usr/bin/env pwsh`
- Added version check that requires PowerShell 7+
- Updated help text to indicate "PowerShell 7+" requirement
- Kept the `??` operator (now valid in pwsh)

### 2. Documentation Updated
- `README.md` - Added requirements section and pwsh install instructions
- `docs/CONTEXT-CAPSULE.md` - Added requirements and updated run command
- `repo/docs/decisions.md` - Added ADR for PowerShell 7+ upgrade

### 3. New Files Created
- `tools/install-pwsh.ps1` - Automated installer for PowerShell 7+
- `bin/ss.ps1` - Shorthand wrapper for quick commands

## How to Use After Installation

### Install PowerShell 7+ (if not already installed)
```powershell
powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1
```

### Run SolidStack Commands
```powershell
# Full syntax
pwsh -File C:\SolidStack\bin\solidstack.ps1 status
pwsh -File C:\SolidStack\bin\solidstack.ps1 report latest

# Shorthand (if you're already in pwsh)
C:\SolidStack\bin\solidstack.ps1 status
C:\SolidStack\bin\ss.ps1 status
```

### Verify Installation
After installing pwsh, verify with:
```powershell
pwsh -v
# Should show: PowerShell 7.x.x
```

## Benefits of PowerShell 7+

1. **Modern Syntax** - `??`, `?.`, pipeline improvements
2. **Better Performance** - Faster execution, parallel operations
3. **Cross-Platform** - Works on Windows, Linux, macOS
4. **Active Development** - Regular updates and new features
5. **Better JSON/REST** - Improved web cmdlets and JSON handling
6. **Backward Compatible** - Runs most PS 5.1 scripts

## Rollback Plan (if needed)

If you need to temporarily use PowerShell 5.1:
1. Revert the `??` operator to `if/else` syntax
2. Remove version check from runner scripts
3. Use `powershell` instead of `pwsh`

## Next Steps

1. Run the installer: `powershell -ExecutionPolicy Bypass -File C:\SolidStack\tools\install-pwsh.ps1`
2. Close and reopen your terminal
3. Test: `pwsh -File C:\SolidStack\bin\solidstack.ps1 status`
4. Commit the changes to git
