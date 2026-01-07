#!/usr/bin/env pwsh
# quick-pr.ps1
# Quick Pull Request creator for SolidStack

param(
    [string]$Title = "",
    [string]$Message = "",
    [switch]$AutoMerge = $false
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Text, [string]$Color = "Cyan")
    Write-Host "`n🔹 $Text" -ForegroundColor $Color
}

function Write-Success {
    param([string]$Text)
    Write-Host "✅ $Text" -ForegroundColor Green
}

function Write-Error {
    param([string]$Text)
    Write-Host "❌ $Text" -ForegroundColor Red
}

# Change to repo directory
$repoPath = "C:\SolidStack\repo"
Push-Location $repoPath

try {
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  QUICK PULL REQUEST WORKFLOW" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

    # Check current branch
    $currentBranch = git branch --show-current
    Write-Host "Current branch: " -NoNewline
    Write-Host $currentBranch -ForegroundColor Yellow

    if ($currentBranch -eq "master") {
        Write-Error "You're on the master branch. Switch to a feature branch first."
        Write-Host "`nRun: git checkout powershell" -ForegroundColor Gray
        exit 1
    }

    # Check for uncommitted changes
    Write-Step "Checking for uncommitted changes..."
    $status = git status --porcelain
    
    if ($status) {
        Write-Host "⚠️  You have uncommitted changes. Commit them first.`n" -ForegroundColor Yellow
        
        if ($Message -eq "") {
            Write-Host "Please provide a commit message:" -ForegroundColor Cyan
            $Message = Read-Host "Commit message"
        }
        
        Write-Step "Committing changes..."
        git add .
        git commit -m $Message
        Write-Success "Changes committed"
    } else {
        Write-Success "No uncommitted changes"
    }

    # Push to remote
    Write-Step "Pushing to GitHub..."
    git push
    Write-Success "Pushed to origin/$currentBranch"

    # Check if gh CLI is available
    $ghAvailable = Get-Command gh -ErrorAction SilentlyContinue

    if ($ghAvailable) {
        Write-Step "Creating Pull Request with GitHub CLI..."
        
        # Get the last commit message as default title
        if ($Title -eq "") {
            $Title = git log -1 --pretty=%s
        }
        
        # Create PR
        Write-Host "`nPR Title: $Title" -ForegroundColor Gray
        $prUrl = gh pr create --base master --head $currentBranch --title $Title --fill 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Pull Request created!"
            Write-Host $prUrl
            
            if ($AutoMerge) {
                Write-Step "Auto-merging PR..."
                Start-Sleep -Seconds 2
                gh pr merge --squash --delete-branch
                Write-Success "PR merged and branch deleted!"
                
                Write-Step "Updating local master..."
                git checkout master
                git pull
                Write-Success "Local master updated!"
            } else {
                Write-Host "`n💡 To merge this PR:" -ForegroundColor Cyan
                Write-Host "   gh pr merge --squash" -ForegroundColor White
                Write-Host "`n💡 Or visit GitHub to review and merge:" -ForegroundColor Cyan
                gh pr view --web
            }
        } else {
            Write-Error "Failed to create PR"
            Write-Host $prUrl -ForegroundColor Red
        }
        
    } else {
        Write-Host "`n⚠️  GitHub CLI not found." -ForegroundColor Yellow
        Write-Host "`nManual steps:" -ForegroundColor Cyan
        Write-Host "1. Visit: https://github.com/aperecko/solidstack" -ForegroundColor White
        Write-Host "2. Click 'Compare & pull request'" -ForegroundColor White
        Write-Host "3. Review and merge`n" -ForegroundColor White
        
        Write-Host "Or install GitHub CLI:" -ForegroundColor Cyan
        Write-Host "  winget install --id GitHub.cli`n" -ForegroundColor White
    }

    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  WORKFLOW COMPLETE" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

} catch {
    Write-Error "An error occurred: $_"
    exit 1
} finally {
    Pop-Location
}
