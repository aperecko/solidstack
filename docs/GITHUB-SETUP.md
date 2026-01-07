# GitHub Setup Guide for SolidStack

This guide will help you get SolidStack on GitHub, even if you're not familiar with Git.

## Why GitHub?

GitHub gives you:
- **Version History** - See what changed and when
- **Backup** - Your code is safe in the cloud
- **Collaboration** - Easy for others to help
- **Issue Tracking** - Keep track of bugs and ideas
- **Documentation** - README shows up beautifully
- **Learning** - Great way to understand how version control works

## Prerequisites

1. **GitHub Account** - Sign up at https://github.com if you don't have one
2. **Git installed** - Check by running `git --version` in PowerShell
3. **GitHub CLI (optional but recommended)** - Makes authentication easier

### Install GitHub CLI (recommended)

```powershell
winget install --id GitHub.cli
```

Or download from: https://cli.github.com/

## Setup Steps

### Step 1: Create Repository on GitHub

#### Option A: Using GitHub CLI (Easier)

1. **Authenticate with GitHub:**
   ```powershell
   gh auth login
   ```
   Follow the prompts (choose HTTPS, authenticate via browser)

2. **Create the repository from your local repo:**
   ```powershell
   cd C:\SolidStack\repo
   gh repo create solidstack --public --source=. --remote=origin
   ```

3. **Push your code:**
   ```powershell
   git push -u origin master
   ```

#### Option B: Using GitHub Website (Manual)

1. **Go to GitHub** and create a new repository:
   - Visit https://github.com/new
   - Name: `solidstack`
   - Description: "A traceable, modular self-host stack for Windows Server + Docker Desktop"
   - Choose Public or Private
   - **Don't** initialize with README (we already have one)
   - Click "Create repository"

2. **Connect your local repo to GitHub:**
   ```powershell
   cd C:\SolidStack\repo
   git remote add origin https://github.com/YOUR_USERNAME/solidstack.git
   git branch -M master
   git push -u origin master
   ```

   Replace `YOUR_USERNAME` with your actual GitHub username.

3. **If prompted for credentials**, use a Personal Access Token:
   - Go to https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Give it a name like "SolidStack"
   - Check "repo" scope
   - Copy the token and use it as your password

### Step 2: Verify Everything Uploaded

Visit your repository at `https://github.com/YOUR_USERNAME/solidstack`

You should see:
- ✅ README with project description
- ✅ Source code in `src/`
- ✅ Documentation in `docs/`
- ✅ No secrets (check that `stack/secrets/` is NOT there)

### Step 3: Set Up Repository Settings (Optional)

On GitHub, go to your repository settings:

1. **Add topics** (helps people find your project):
   - Click the gear icon next to "About"
   - Add: `powershell`, `docker`, `self-hosted`, `windows-server`, `devops`

2. **Enable Issues** (if not already enabled):
   - Settings → Features → Check "Issues"

3. **Add repository description**:
   - "A traceable, modular self-host stack for Windows Server + Docker Desktop"

## Daily Workflow

### Making Changes

1. **Make your changes** to files in `C:\SolidStack\repo`

2. **Check what changed:**
   ```powershell
   cd C:\SolidStack\repo
   git status
   ```

3. **See the actual changes:**
   ```powershell
   git diff
   ```

4. **Stage all changes:**
   ```powershell
   git add .
   ```

5. **Commit with a message:**
   ```powershell
   git commit -m "Add: describe what you changed"
   ```

6. **Push to GitHub:**
   ```powershell
   git push
   ```

### Viewing History

```powershell
# See recent commits
git log --oneline -10

# See what changed in a specific commit
git show COMMIT_HASH
```

### Creating Backups (Tags)

Tag important milestones:
```powershell
# Create a tag for a working version
git tag -a v1.0 -m "First stable version"
git push origin v1.0
```

## Working with Issues

### Creating an Issue

1. Go to your repo on GitHub
2. Click "Issues" tab
3. Click "New Issue"
4. Choose a template (Bug Report, Feature Request, Question)
5. Fill it out and submit

### Tracking Your Work

Use issues to:
- Track bugs you find
- List features you want to add
- Ask yourself questions to research later
- Document decisions

You can reference issues in commits:
```powershell
git commit -m "Fix: docker status check (fixes #3)"
```

## Troubleshooting

### "Authentication failed"

Use a Personal Access Token instead of your password:
1. Generate at https://github.com/settings/tokens
2. Use it as your password when prompted

Or use GitHub CLI: `gh auth login`

### "Everything up-to-date" but changes aren't on GitHub

Make sure you committed first:
```powershell
git add .
git commit -m "Your message"
git push
```

### "Can't push to repository"

You might not have write access. If it's your repo, check your authentication.

### Need to undo a commit

```powershell
# Undo last commit but keep changes
git reset --soft HEAD~1

# Undo last commit and discard changes
git reset --hard HEAD~1
```

## Useful Commands Cheat Sheet

```powershell
# Check status
git status

# See what changed
git diff

# Add all changes
git add .

# Commit changes
git commit -m "message"

# Push to GitHub
git push

# Pull latest from GitHub
git pull

# See commit history
git log --oneline

# See remote URL
git remote -v

# Create a new branch
git checkout -b feature-name

# Switch branches
git checkout master
```

## Next Steps

Once you're on GitHub:
1. ⭐ Star your own repo (why not!)
2. 📝 Edit the README on GitHub to add your username to links
3. 🐛 Create your first issue to track future work
4. 🏷️ Add topics to make it discoverable
5. 📊 Watch the Insights tab to see your contribution graph grow

## Resources

- [GitHub Docs](https://docs.github.com)
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)
- [GitHub CLI Manual](https://cli.github.com/manual/)

Remember: Git might feel complicated at first, but you really only need a few commands for daily work: `add`, `commit`, `push`, `status`. The rest you can learn as you go!
