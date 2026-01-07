# ☑️ GitHub Setup Checklist

Use this to track your progress getting SolidStack on GitHub.

## Pre-Setup
- [ ] I have a GitHub account (sign up at https://github.com)
- [ ] Git is installed (`git --version` works)
- [ ] GitHub CLI is installed (optional): `gh --version`

## Initial Setup
- [ ] Created repository on GitHub (public or private)
- [ ] Connected local repo to GitHub (`git remote add origin ...`)
- [ ] Pushed code to GitHub (`git push -u origin master`)
- [ ] Verified repo shows up on GitHub with all files

## Repository Configuration
- [ ] Added repository description
- [ ] Added topics (powershell, docker, self-hosted, windows-server)
- [ ] Enabled Issues in settings
- [ ] README displays correctly
- [ ] Verified secrets are NOT visible (stack/secrets should be missing)

## Documentation Check
- [ ] README.md updated with my GitHub username
- [ ] CONTRIBUTING.md is clear
- [ ] Issue templates work
- [ ] All links in docs work correctly

## First Test
- [ ] Made a test change locally
- [ ] Committed: `git commit -m "Test: first commit to GitHub"`
- [ ] Pushed: `git push`
- [ ] Verified change appears on GitHub

## Optional Enhancements
- [ ] Created first issue for a future feature
- [ ] Added a project board for tracking work
- [ ] Invited collaborators (if applicable)
- [ ] Set up branch protection rules (advanced)
- [ ] Added GitHub Actions for CI/CD (advanced)

## Daily Workflow Practice
- [ ] Made a small change
- [ ] Ran `git status` to see changes
- [ ] Ran `git diff` to review changes
- [ ] Used `git add .` to stage
- [ ] Used `git commit -m "..."` to commit
- [ ] Used `git push` to upload
- [ ] Checked GitHub to see it appear

## Troubleshooting Done
- [ ] Know how to check `git remote -v`
- [ ] Know how to view history: `git log --oneline`
- [ ] Tested authentication (PAT or gh CLI)
- [ ] Understand where to find logs if things break

---

## Quick Reference Commands

```powershell
# Daily workflow
cd C:\SolidStack\repo
git status              # What changed?
git add .               # Stage everything
git commit -m "message" # Save with description
git push                # Upload to GitHub

# Checking things
git log --oneline -5    # Recent commits
git remote -v           # Where am I pushing?
gh repo view --web      # Open repo in browser (if using gh CLI)
```

## When Done

You're ready when:
- ✅ Code is on GitHub and you can see it
- ✅ You can make a change, commit, and push successfully
- ✅ Issues work and you've created at least one
- ✅ You understand the basic workflow: edit → add → commit → push

**Congratulations! You're now using version control like a pro! 🎉**
