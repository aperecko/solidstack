#!/usr/bin/env pwsh
# check-git-status.ps1
# Comprehensive git status checker for SolidStack development

function Get-GitStatus {
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  GIT STATUS CHECK FOR SOLIDSTACK" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

    # Get current directory
    $repoPath = Split-Path -Parent $PSCommandPath
    Push-Location $repoPath

    # Check if we're in a git repo
    if (-not (Test-Path ".git")) {
        Write-Host "❌ Not in a git repository!" -ForegroundColor Red
        Pop-Location
        return
    }

    # 1. Current Branch
    $currentBranch = git branch --show-current
    Write-Host "📍 Current Branch: " -NoNewline -ForegroundColor Yellow
    Write-Host $currentBranch -ForegroundColor Green

    # 2. Remote URL
    $remoteUrl = git remote get-url origin 2>$null
    if ($remoteUrl) {
        Write-Host "🌐 Remote: " -NoNewline -ForegroundColor Yellow
        Write-Host $remoteUrl -ForegroundColor Green
    }

    Write-Host ""

    # 3. Check for uncommitted changes
    Write-Host "━━━ Uncommitted Changes ━━━" -ForegroundColor Cyan
    $status = git status --porcelain
    
    if ($status) {
        Write-Host "⚠️  You have uncommitted changes:`n" -ForegroundColor Yellow
        
        # Parse the status
        $modified = @()
        $untracked = @()
        $deleted = @()
        $added = @()
        
        foreach ($line in $status) {
            $statusCode = $line.Substring(0, 2).Trim()
            $file = $line.Substring(3)
            
            switch ($statusCode) {
                "M"  { $modified += $file }
                "??" { $untracked += $file }
                "D"  { $deleted += $file }
                "A"  { $added += $file }
            }
        }
        
        if ($modified.Count -gt 0) {
            Write-Host "  Modified files:" -ForegroundColor Yellow
            $modified | ForEach-Object { Write-Host "    📝 $_" -ForegroundColor White }
        }
        
        if ($added.Count -gt 0) {
            Write-Host "  Added files:" -ForegroundColor Green
            $added | ForEach-Object { Write-Host "    ✨ $_" -ForegroundColor White }
        }
        
        if ($untracked.Count -gt 0) {
            Write-Host "  Untracked files:" -ForegroundColor Gray
            $untracked | ForEach-Object { Write-Host "    ❓ $_" -ForegroundColor White }
        }
        
        if ($deleted.Count -gt 0) {
            Write-Host "  Deleted files:" -ForegroundColor Red
            $deleted | ForEach-Object { Write-Host "    🗑️  $_" -ForegroundColor White }
        }
        
        Write-Host "`n  💡 To commit these changes:" -ForegroundColor Cyan
        Write-Host "     git add ." -ForegroundColor White
        Write-Host "     git commit -m `"Your message here`"" -ForegroundColor White
        Write-Host "     git push`n" -ForegroundColor White
    } else {
        Write-Host "✅ Working directory is clean (no uncommitted changes)" -ForegroundColor Green
    }

    Write-Host ""

    # 4. Check for unpushed commits
    Write-Host "━━━ Unpushed Commits ━━━" -ForegroundColor Cyan
    
    # Get local and remote commit hashes
    $localCommit = git rev-parse HEAD
    $remoteCommit = git rev-parse "origin/$currentBranch" 2>$null
    
    if ($remoteCommit -and $localCommit -ne $remoteCommit) {
        $unpushedCount = (git log "origin/$currentBranch..HEAD" --oneline | Measure-Object).Count
        Write-Host "⚠️  You have $unpushedCount unpushed commit(s) on '$currentBranch':`n" -ForegroundColor Yellow
        
        # Show the commits
        git log "origin/$currentBranch..HEAD" --oneline --decorate | ForEach-Object {
            Write-Host "    🔸 $_" -ForegroundColor White
        }
        
        Write-Host "`n  💡 To push these commits:" -ForegroundColor Cyan
        Write-Host "     git push`n" -ForegroundColor White
    } else {
        Write-Host "✅ All commits are pushed to remote" -ForegroundColor Green
    }

    Write-Host ""

    # 5. Check branch comparison with master
    if ($currentBranch -ne "master") {
        Write-Host "━━━ Branch Comparison with Master ━━━" -ForegroundColor Cyan
        
        $aheadBehind = git rev-list --left-right --count "origin/master...$currentBranch"
        $parts = $aheadBehind -split '\s+'
        $behind = [int]$parts[0]
        $ahead = [int]$parts[1]
        
        if ($ahead -gt 0) {
            Write-Host "📤 '$currentBranch' is $ahead commit(s) ahead of 'master'" -ForegroundColor Yellow
            Write-Host "   This means you have new changes that aren't in master yet." -ForegroundColor Gray
        }
        
        if ($behind -gt 0) {
            Write-Host "📥 '$currentBranch' is $behind commit(s) behind 'master'" -ForegroundColor Yellow
            Write-Host "   You may want to merge master into your branch." -ForegroundColor Gray
        }
        
        if ($ahead -eq 0 -and $behind -eq 0) {
            Write-Host "✅ '$currentBranch' is up to date with 'master'" -ForegroundColor Green
        }
        
        if ($ahead -gt 0) {
            Write-Host "`n  💡 To merge these changes into master:" -ForegroundColor Cyan
            Write-Host "     Option 1 - Create Pull Request on GitHub:" -ForegroundColor White
            Write-Host "       1. Visit: $remoteUrl" -ForegroundColor Gray
            Write-Host "       2. Click 'Compare & pull request'" -ForegroundColor Gray
            Write-Host "       3. Review and merge`n" -ForegroundColor Gray
            
            Write-Host "     Option 2 - Direct merge (if you have gh CLI):" -ForegroundColor White
            Write-Host "       gh pr create --base master --head $currentBranch --fill" -ForegroundColor Gray
            Write-Host "       gh pr merge --squash`n" -ForegroundColor Gray
            
            Write-Host "     Option 3 - Direct push to master:" -ForegroundColor White
            Write-Host "       git checkout master" -ForegroundColor Gray
            Write-Host "       git merge $currentBranch" -ForegroundColor Gray
            Write-Host "       git push`n" -ForegroundColor Gray
        }
    }

    Write-Host ""

    # 6. Recent commits
    Write-Host "━━━ Recent Commits (Last 5) ━━━" -ForegroundColor Cyan
    git log --oneline --decorate -5 | ForEach-Object {
        Write-Host "  $_" -ForegroundColor White
    }

    Write-Host ""

    # 7. Summary & Next Steps
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  NEXT STEPS" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

    $hasUncommitted = $status -ne $null
    $hasUnpushed = $localCommit -ne $remoteCommit
    $needsPR = ($currentBranch -ne "master") -and ($ahead -gt 0)

    if (-not $hasUncommitted -and -not $hasUnpushed -and -not $needsPR) {
        Write-Host "✨ Everything is up to date! You're all set." -ForegroundColor Green
    } else {
        $step = 1
        
        if ($hasUncommitted) {
            Write-Host "$step. Commit your changes:" -ForegroundColor Yellow
            Write-Host "   git add ." -ForegroundColor White
            Write-Host "   git commit -m `"Your commit message`"" -ForegroundColor White
            $step++
            Write-Host ""
        }
        
        if ($hasUnpushed -or $hasUncommitted) {
            Write-Host "$step. Push to GitHub:" -ForegroundColor Yellow
            Write-Host "   git push" -ForegroundColor White
            $step++
            Write-Host ""
        }
        
        if ($needsPR) {
            Write-Host "$step. Create and merge Pull Request:" -ForegroundColor Yellow
            Write-Host "   Visit GitHub and create a PR from '$currentBranch' to 'master'" -ForegroundColor White
            Write-Host ""
        }
    }

    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Cyan

    Pop-Location
}

# Run the function
Get-GitStatus
