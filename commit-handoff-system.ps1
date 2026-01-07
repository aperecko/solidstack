#!/usr/bin/env pwsh
# commit-handoff-system.ps1
# Commits the complete AI handoff management system

Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  COMMITTING AI HANDOFF SYSTEM" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

$repoPath = "C:\SolidStack\repo"
Push-Location $repoPath

try {
    # Check current branch
    $branch = git branch --show-current
    Write-Host "📍 Current branch: " -NoNewline -ForegroundColor Yellow
    Write-Host $branch -ForegroundColor Green
    
    if ($branch -ne "powershell") {
        Write-Host "⚠️  Warning: Not on 'powershell' branch!" -ForegroundColor Yellow
        Write-Host "   Continuing anyway..." -ForegroundColor Gray
    }
    
    Write-Host ""
    
    # Show what will be committed
    Write-Host "━━━ Files to be committed ━━━" -ForegroundColor Cyan
    Write-Host ""
    
    $status = git status --short
    if ($status) {
        $status | ForEach-Object {
            if ($_ -match '^\?\?') {
                Write-Host "  ✨ NEW: " -NoNewline -ForegroundColor Green
            } elseif ($_ -match '^M') {
                Write-Host "  📝 MODIFIED: " -NoNewline -ForegroundColor Yellow
            } elseif ($_ -match '^A') {
                Write-Host "  ➕ ADDED: " -NoNewline -ForegroundColor Green
            }
            Write-Host ($_ -replace '^\S+\s+', '') -ForegroundColor White
        }
    } else {
        Write-Host "  ℹ️  No changes detected" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Run git status to see current state" -ForegroundColor Gray
        Pop-Location
        exit 0
    }
    
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    
    # Ask for confirmation
    Write-Host "Ready to commit these changes?" -ForegroundColor Yellow
    Write-Host "  [Y] Yes, commit" -ForegroundColor Green
    Write-Host "  [N] No, cancel" -ForegroundColor Red
    Write-Host "  [D] Show detailed diff first" -ForegroundColor Cyan
    Write-Host ""
    $response = Read-Host "Your choice (Y/N/D)"
    
    if ($response -eq 'D' -or $response -eq 'd') {
        Write-Host "`n━━━ Detailed Changes ━━━" -ForegroundColor Cyan
        git diff
        Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
        Write-Host ""
        $response = Read-Host "Proceed with commit? (Y/N)"
    }
    
    if ($response -ne 'Y' -and $response -ne 'y') {
        Write-Host "`n❌ Commit cancelled" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    
    Write-Host ""
    Write-Host "━━━ Committing Changes ━━━" -ForegroundColor Cyan
    Write-Host ""
    
    # Stage all changes
    Write-Host "📦 Staging files..." -ForegroundColor Cyan
    git add .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to stage files" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    
    Write-Host "✅ Files staged" -ForegroundColor Green
    Write-Host ""
    
    # Create the commit
    Write-Host "💾 Creating commit..." -ForegroundColor Cyan
    
    $commitMessage = @"
Add: Complete AI handoff management system

Major changes:
- Move handoffs to repo/handoff/ (Git-tracked)
- Add handoff management documentation
- Create .gitignore for proper tracking
- Document Mac → Windows workflow
- Complete 1Password integration design
- Add Git workflow helpers

New files:
- handoff/AI-HANDOFF-MAC-USER.md (primary handoff)
- handoff/HANDOFF-MANAGEMENT.md (maintenance guide)
- docs/MAC-TO-WINDOWS-WORKFLOW.md (Mac setup)
- docs/SECURITY-1PASSWORD.md (1Password guide)
- check-git-status.ps1 (Git dashboard)
- quick-pr.ps1 (PR automation)
- .gitignore (proper Git tracking)

This implements a complete AI coordination system:
- Handoffs in Git (version controlled)
- Clear update process (documented)
- Automatic sync via Git
- Mac ↔ Server coordination
- AI session continuity

Handoffs are now living documentation that evolve with
the project and provide memory across AI sessions.
"@
    
    git commit -m $commitMessage
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Failed to create commit" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    
    Write-Host "✅ Commit created!" -ForegroundColor Green
    Write-Host ""
    
    # Show the commit
    Write-Host "━━━ Commit Details ━━━" -ForegroundColor Cyan
    git log -1 --stat --color
    Write-Host ""
    
    # Ask about pushing
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Push to GitHub now?" -ForegroundColor Yellow
    Write-Host "  [Y] Yes, push now" -ForegroundColor Green
    Write-Host "  [N] No, I'll push later" -ForegroundColor Gray
    Write-Host ""
    $pushResponse = Read-Host "Your choice (Y/N)"
    
    if ($pushResponse -eq 'Y' -or $pushResponse -eq 'y') {
        Write-Host ""
        Write-Host "━━━ Pushing to GitHub ━━━" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "📤 Pushing..." -ForegroundColor Cyan
        
        git push
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Pushed to GitHub!" -ForegroundColor Green
            Write-Host ""
            Write-Host "🎉 All changes are now on GitHub!" -ForegroundColor Green
        } else {
            Write-Host "❌ Push failed" -ForegroundColor Red
            Write-Host ""
            Write-Host "You can push manually later with: git push" -ForegroundColor Gray
        }
    } else {
        Write-Host ""
        Write-Host "ℹ️  Commit saved locally" -ForegroundColor Cyan
        Write-Host "   Push later with: git push" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  NEXT STEPS" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Check status:" -ForegroundColor Yellow
    Write-Host "   pwsh .\check-git-status.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Create PR to master (when ready):" -ForegroundColor Yellow
    Write-Host "   pwsh .\quick-pr.ps1" -ForegroundColor White
    Write-Host "   OR visit: https://github.com/aperecko/solidstack" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. On your Mac, pull latest:" -ForegroundColor Yellow
    Write-Host "   cd ~/projects/solidstack" -ForegroundColor White
    Write-Host "   git pull" -ForegroundColor White
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "✨ AI Handoff System is now live! ✨" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Pop-Location
    exit 1
} finally {
    Pop-Location
}
