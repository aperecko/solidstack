#!/usr/bin/env pwsh
# Cross-Platform Helpers for SolidStack
# Provides OS detection and path abstraction

<#
.SYNOPSIS
Cross-platform utility functions for SolidStack

.DESCRIPTION
Abstracts OS-specific differences so SolidStack works on Windows, Linux, and macOS
Uses built-in PowerShell 7+ variables: $IsWindows, $IsLinux, $IsMacOS
#>

# ============================================================================
# OS Detection
# ============================================================================

function Get-SolidStackOS {
    <#
    .SYNOPSIS
    Detect which OS we're running on
    
    .OUTPUTS
    String: "Windows", "Linux", or "MacOS"
    #>
    
    if ($IsWindows) {
        return "Windows"
    } elseif ($IsLinux) {
        return "Linux"
    } elseif ($IsMacOS) {
        return "MacOS"
    } else {
        throw "Unknown operating system"
    }
}

function Test-SolidStackWindows {
    <#
    .SYNOPSIS
    Check if running on Windows
    #>
    return $IsWindows
}

function Test-SolidStackLinux {
    <#
    .SYNOPSIS
    Check if running on Linux
    #>
    return $IsLinux
}

function Test-SolidStackMacOS {
    <#
    .SYNOPSIS
    Check if running on macOS
    #>
    return $IsMacOS
}

# ============================================================================
# Path Abstraction
# ============================================================================

function Get-SolidStackRoot {
    <#
    .SYNOPSIS
    Get the root SolidStack directory for this OS
    
    .DESCRIPTION
    Windows: C:\SolidStack
    Linux/Mac: ~/.solidstack (or /opt/solidstack for system-wide)
    #>
    
    if (Test-SolidStackWindows) {
        return "C:\SolidStack"
    } else {
        # Use home directory by default on Unix
        return Join-Path $HOME ".solidstack"
    }
}

function Get-SolidStackPath {
    <#
    .SYNOPSIS
    Get a path within the SolidStack directory structure
    
    .PARAMETER SubPath
    Relative path from SolidStack root (use forward slashes)
    
    .EXAMPLE
    Get-SolidStackPath "stack/logs"
    # Windows: C:\SolidStack\stack\logs
    # Linux:   /home/user/.solidstack/stack/logs
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$SubPath
    )
    
    $root = Get-SolidStackRoot
    
    # Normalize path separators for current OS
    $normalizedPath = $SubPath -replace '[/\\]', [IO.Path]::DirectorySeparatorChar
    
    return Join-Path $root $normalizedPath
}

function Get-SolidStackRepoPath {
    <#
    .SYNOPSIS
    Get path to the Git repository
    #>
    return Get-SolidStackPath "repo"
}

function Get-SolidStackBinPath {
    <#
    .SYNOPSIS
    Get path to executable scripts
    #>
    return Get-SolidStackPath "bin"
}

function Get-SolidStackStackPath {
    <#
    .SYNOPSIS
    Get path to runtime stack directory
    #>
    return Get-SolidStackPath "stack"
}

function Get-SolidStackLogsPath {
    <#
    .SYNOPSIS
    Get path to logs directory
    #>
    return Get-SolidStackPath "stack/logs"
}

function Get-SolidStackReportsPath {
    <#
    .SYNOPSIS
    Get path to reports directory
    #>
    return Get-SolidStackPath "reports"
}

function Get-SolidStackSecretsPath {
    <#
    .SYNOPSIS
    Get path to secrets directory
    #>
    return Get-SolidStackPath "stack/secrets"
}

# ============================================================================
# Docker Path Conversion
# ============================================================================

function ConvertTo-DockerPath {
    <#
    .SYNOPSIS
    Convert a local filesystem path to Docker volume mount format
    
    .DESCRIPTION
    Windows: C:\SolidStack\data -> /c/SolidStack/data
    Linux/Mac: /home/user/.solidstack/data -> /home/user/.solidstack/data
    
    .PARAMETER LocalPath
    Local filesystem path to convert
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$LocalPath
    )
    
    if (Test-SolidStackWindows) {
        # Convert Windows path to Docker Desktop format
        # C:\Path\To\Dir -> /c/Path/To/Dir
        $dockerPath = $LocalPath -replace '^([A-Za-z]):', '/$1'
        $dockerPath = $dockerPath -replace '\\', '/'
        return $dockerPath.ToLower()
    } else {
        # Linux/Mac paths work as-is
        return $LocalPath
    }
}

# ============================================================================
# Command Detection
# ============================================================================

function Test-SolidStackCommand {
    <#
    .SYNOPSIS
    Check if a command exists on this system
    
    .PARAMETER CommandName
    Name of command to check
    
    .EXAMPLE
    Test-SolidStackCommand "docker"
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$CommandName
    )
    
    $cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
    return $null -ne $cmd
}

function Get-SolidStackCommandPath {
    <#
    .SYNOPSIS
    Get full path to a command if it exists
    
    .PARAMETER CommandName
    Name of command to find
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$CommandName
    )
    
    $cmd = Get-Command $CommandName -ErrorAction SilentlyContinue
    if ($cmd) {
        return $cmd.Source
    }
    return $null
}

# ============================================================================
# Package Management Abstraction
# ============================================================================

function Get-SolidStackPackageManager {
    <#
    .SYNOPSIS
    Detect which package manager to use on this system
    
    .OUTPUTS
    String: "winget", "apt", "yum", "dnf", "brew", or "unknown"
    #>
    
    if (Test-SolidStackWindows) {
        if (Test-SolidStackCommand "winget") {
            return "winget"
        }
        return "unknown"
    }
    
    if (Test-SolidStackLinux) {
        if (Test-Path "/etc/debian_version") {
            return "apt"
        }
        if (Test-Path "/etc/redhat-release") {
            if (Test-SolidStackCommand "dnf") {
                return "dnf"
            }
            return "yum"
        }
        return "unknown"
    }
    
    if (Test-SolidStackMacOS) {
        if (Test-SolidStackCommand "brew") {
            return "brew"
        }
        return "unknown"
    }
    
    return "unknown"
}

function Install-SolidStackPackage {
    <#
    .SYNOPSIS
    Install a package using the appropriate package manager
    
    .PARAMETER PackageName
    Name of package to install
    
    .PARAMETER Confirm
    Whether to prompt for confirmation (default: true)
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$PackageName,
        
        [bool]$Confirm = $true
    )
    
    $pm = Get-SolidStackPackageManager
    
    Write-Host "Detected package manager: $pm" -ForegroundColor Cyan
    
    switch ($pm) {
        "winget" {
            if ($Confirm) {
                winget install $PackageName
            } else {
                winget install $PackageName --silent --accept-package-agreements --accept-source-agreements
            }
        }
        "apt" {
            if ($Confirm) {
                sudo apt install $PackageName
            } else {
                sudo apt install -y $PackageName
            }
        }
        "yum" {
            if ($Confirm) {
                sudo yum install $PackageName
            } else {
                sudo yum install -y $PackageName
            }
        }
        "dnf" {
            if ($Confirm) {
                sudo dnf install $PackageName
            } else {
                sudo dnf install -y $PackageName
            }
        }
        "brew" {
            brew install $PackageName
        }
        default {
            throw "No supported package manager found. Please install $PackageName manually."
        }
    }
}

# ============================================================================
# File Permissions (Unix-specific)
# ============================================================================

function Set-SolidStackExecutable {
    <#
    .SYNOPSIS
    Make a file executable (Unix only)
    
    .PARAMETER Path
    Path to file to make executable
    #>
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    if (-not (Test-SolidStackWindows)) {
        chmod +x $Path
    }
    # Windows doesn't need this
}

# ============================================================================
# Line Endings
# ============================================================================

function Get-SolidStackLineEnding {
    <#
    .SYNOPSIS
    Get the appropriate line ending for this OS
    
    .OUTPUTS
    String: "`r`n" (Windows) or "`n" (Unix)
    #>
    
    if (Test-SolidStackWindows) {
        return "`r`n"
    } else {
        return "`n"
    }
}

# ============================================================================
# Temp Directory
# ============================================================================

function Get-SolidStackTempPath {
    <#
    .SYNOPSIS
    Get appropriate temp directory for this OS
    #>
    
    if (Test-SolidStackWindows) {
        return $env:TEMP
    } else {
        return "/tmp"
    }
}

# ============================================================================
# Information Display
# ============================================================================

function Show-SolidStackEnvironment {
    <#
    .SYNOPSIS
    Display current environment information
    #>
    
    Write-Host ""
    Write-Host "SolidStack Environment" -ForegroundColor Cyan
    Write-Host "======================" -ForegroundColor Cyan
    Write-Host "OS:              $(Get-SolidStackOS)"
    Write-Host "PowerShell:      $($PSVersionTable.PSVersion)"
    Write-Host "Root Path:       $(Get-SolidStackRoot)"
    Write-Host "Package Manager: $(Get-SolidStackPackageManager)"
    Write-Host ""
}

# ============================================================================
# Note: Export-ModuleMember only works when imported as a module
# When dot-sourced (. script.ps1), all functions are automatically available
# ============================================================================

if ($MyInvocation.MyCommand.CommandType -eq 'ExternalScript') {
    # Being dot-sourced - functions are already available
    # No export needed
} else {
    # Being imported as module - export functions
    Export-ModuleMember -Function @(
        # OS Detection
        'Get-SolidStackOS',
        'Test-SolidStackWindows',
        'Test-SolidStackLinux',
        'Test-SolidStackMacOS',
        
        # Path Abstraction
        'Get-SolidStackRoot',
        'Get-SolidStackPath',
        'Get-SolidStackRepoPath',
        'Get-SolidStackBinPath',
        'Get-SolidStackStackPath',
        'Get-SolidStackLogsPath',
        'Get-SolidStackReportsPath',
        'Get-SolidStackSecretsPath',
        
        # Docker Paths
        'ConvertTo-DockerPath',
        
        # Command Detection
        'Test-SolidStackCommand',
        'Get-SolidStackCommandPath',
        
        # Package Management
        'Get-SolidStackPackageManager',
        'Install-SolidStackPackage',
        
        # File Permissions
        'Set-SolidStackExecutable',
        
        # Utilities
        'Get-SolidStackLineEnding',
        'Get-SolidStackTempPath',
        'Show-SolidStackEnvironment'
    )
}
