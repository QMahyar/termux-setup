#!/data/data/com.termux/files/usr/bin/bash
# =============================================================================
# Termux Setup — One-time Initialize & Push to GitHub
# =============================================================================
# Sets up everything: runs backup, creates GitHub repo, pushes.
#
# Usage:
#   bash setup.sh                          # Interactive — guides you through
#   bash setup.sh --token ghp_yourToken    # Non-interactive with PAT
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; CYAN='\033[1;36m'; NC='\033[0m'
msg()  { echo -e "${GREEN}[*]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[!!]${NC} $*"; }

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Termux Setup — GitHub Init         ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# ── Step 1: Run backup ──────────────────────────────────────────────────────
msg "Step 1: Running backup..."
bash "$SCRIPT_DIR/backup.sh"
echo ""

# ── Step 2: Check / setup git ───────────────────────────────────────────────
if ! command -v git &>/dev/null; then
  msg "Installing git..."
  apt install git -y
fi

cd "$SCRIPT_DIR"

if [ -d .git ]; then
  msg "Git repo already initialized here."
else
  msg "Initializing git repository..."
  git init
  git checkout -b main
  git add -A
  git commit -m "Initial Termux setup — $(date '+%Y-%m-%d')"
fi

# ── Step 3: Authenticate with GitHub ────────────────────────────────────────
GITHUB_TOKEN=""

# Check if already authenticated
if gh auth status &>/dev/null; then
  msg "Already authenticated with GitHub CLI!"
else
  # Check for passed token
  if [[ "${1:-}" == "--token" && -n "${2:-}" ]]; then
    GITHUB_TOKEN="$2"
    msg "Using provided GitHub token."
  else
    echo ""
    echo "  ── GitHub Authentication ──"
    echo ""
    echo "  You need a GitHub Personal Access Token (PAT) with 'repo' scope."
    echo ""
    echo "  Create one at: https://github.com/settings/tokens"
    echo "  (classic token, scopes: repo, workflow)"
    echo ""
    read -r -p "  Paste your GitHub token (or press Enter to use 'gh auth login'): " GITHUB_TOKEN
    echo ""
  fi

  if [ -n "$GITHUB_TOKEN" ]; then
    # Store token in git credential
    gh auth login --with-token <<< "$GITHUB_TOKEN" 2>/dev/null || {
      # Fallback: store in git config
      git config --global credential.helper store
      echo "https://oauth2:$GITHUB_TOKEN@github.com" > ~/.git-credentials
      chmod 600 ~/.git-credentials
    }
    msg "Token saved!"
  else
    msg "Starting interactive GitHub login..."
    gh auth login
  fi
fi
echo ""

# ── Step 4: Create or configure GitHub repo ─────────────────────────────────
REPO_NAME="termux-setup"
GITHUB_USER=""

# Try to get username
if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
  GITHUB_USER=$(gh api user --jq '.login' 2>/dev/null || echo "")
fi

if [ -z "$GITHUB_USER" ]; then
  # Try git config
  GITHUB_USER=$(git config --global user.name 2>/dev/null || echo "")
  if [ -z "$GITHUB_USER" ]; then
    read -r -p "  Enter your GitHub username: " GITHUB_USER
  fi
fi

echo ""
msg "GitHub user: $GITHUB_USER"
msg "Repo name:   $REPO_NAME (private)"
echo ""

# Check if repo already exists on GitHub
if gh repo view "$GITHUB_USER/$REPO_NAME" &>/dev/null 2>&1; then
  warn "Repo $GITHUB_USER/$REPO_NAME already exists on GitHub."
  read -r -p "  Push to existing repo? [Y/n] " push_confirm
  push_confirm="${push_confirm:-Y}"
  if [[ "$push_confirm" =~ ^[Yy] ]]; then
    git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git" 2>/dev/null || \
      git remote set-url origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"
  else
    read -r -p "  Enter existing repo URL (e.g. user/repo): " existing_repo
    git remote add origin "https://github.com/$existing_repo.git" 2>/dev/null || \
      git remote set-url origin "https://github.com/$existing_repo.git"
  fi
else
  msg "Creating private repo: $GITHUB_USER/$REPO_NAME"
  gh repo create "$REPO_NAME" --private --description "Termux setup backup" 2>/dev/null || {
    warn "Could not create repo via gh CLI. Create it manually:"
    echo "    https://github.com/new"
    read -r -p "  Then press Enter to continue... " _
  }
  # Try setting remote
  git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git" 2>/dev/null || true
fi
echo ""

# ── Step 5: Push ────────────────────────────────────────────────────────────
msg "Step 5: Pushing to GitHub..."
echo ""

# Re-add everything and push
git add -A
git commit -m "Termux setup backup — $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || msg "Nothing new to commit"

# Try pushing
if git remote get-url origin &>/dev/null; then
  if git push -u origin main 2>/dev/null || git push -u origin master 2>/dev/null; then
    msg "✅ Successfully pushed to GitHub!"
  else
    warn "Push failed. Try: git push -u origin main --force"
    warn "Or check your token has 'repo' scope."
  fi
else
  warn "No remote configured. Push manually:"
  echo "    git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git"
  echo "    git push -u origin main"
fi

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Done!                              ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  Your Termux setup is now backed up to GitHub."
echo ""
echo "  On a new device, run:"
echo ""
echo "    pkg install git gh -y"
echo "    gh auth login"
echo "    git clone https://github.com/$GITHUB_USER/$REPO_NAME.git ~/termux-setup"
echo "    cd ~/termux-setup"
echo "    bash restore.sh"
echo ""
echo "  To back up again later:  bash backup.sh --push"
echo ""
