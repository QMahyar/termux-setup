#!/data/data/com.termux/files/usr/bin/bash
# =============================================================================
# Termux Setup — Full Restore Script (for new devices)
# =============================================================================
# Run this on a BRAND NEW Termux installation to restore everything:
#
#   pkg install git -y
#   git clone https://github.com/YOUR_USER/termux-setup.git ~/termux-setup
#   cd ~/termux-setup
#   bash restore.sh
#
# This will:
#   1. Install all packages from the saved package list
#   2. Restore ~/.termux/ config (extra keys, colors, etc.)
#   3. Restore ~/.bashrc and other dotfiles
#   4. Restore ~/.gitconfig
#   5. Restore ~/.ssh/authorized_keys
#   6. Apply extra keys layout
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Look for backup data (either in .backup/ or backup/)
if [ -d "$SCRIPT_DIR/.backup" ]; then
  BACKUP_SRC="$SCRIPT_DIR/.backup"
elif [ -d "$SCRIPT_DIR/backup" ]; then
  BACKUP_SRC="$SCRIPT_DIR/backup"
else
  echo ""
  echo "  ⚠️  No backup data found!"
  echo "     Run 'bash backup.sh' first, or clone a repo that has backup data."
  echo ""
  exit 1
fi

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

msg()  { echo -e "${GREEN}[*]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[!!]${NC} $*"; }

# ── Sanity checks ────────────────────────────────────────────────────────────
check_requirements() {
  msg "Checking requirements..."

  if [ ! -d "$PREFIX" ]; then
    err "This script must be run inside Termux!"
    exit 1
  fi

  # Ensure essential tools
  for cmd in apt dpkg xargs; do
    if ! command -v "$cmd" &>/dev/null; then
      err "Required command not found: $cmd"
      exit 1
    fi
  done

  msg "  → Requirements met"
}

# ── 1. Install all packages ─────────────────────────────────────────────────
restore_packages() {
  local pkg_file="$BACKUP_SRC/packages.txt"

  if [ ! -f "$pkg_file" ]; then
    warn "No packages.txt found — skipping package installation"
    return
  fi

  local total
  total=$(wc -l < "$pkg_file")

  msg "Installing $total packages (this will take a while)..."
  msg "  → First, updating package lists..."
  apt update -y 2>/dev/null

  msg "  → Extracting package names..."
  # Get just the package names (first column) from dpkg format
  awk '{print $1}' "$pkg_file" > "$BACKUP_SRC/_pkg_names.txt"

  local available
  available=$(wc -l < "$BACKUP_SRC/_pkg_names.txt")

  msg "  → Installing $available packages..."
  apt install -y $(cat "$BACKUP_SRC/_pkg_names.txt") 2>/dev/null || {
    warn "Some packages failed to install. This is normal if some are outdated."
    warn "You can manually run: apt list --upgradable"
  }

  msg "  → Package installation complete!"
}

# ── 2. Restore ~/.termux/ config ────────────────────────────────────────────
restore_termux_config() {
  local termux_src="$BACKUP_SRC/home/.termux"

  if [ ! -d "$termux_src" ]; then
    warn "No .termux config found — skipping"
    return
  fi

  msg "Restoring ~/.termux/ config..."
  mkdir -p ~/.termux
  cp -r "$termux_src"/* ~/.termux/ 2>/dev/null || true

  # Apply extra keys immediately
  if command -v termux-reload-settings &>/dev/null; then
    termux-reload-settings 2>/dev/null || true
  fi

  msg "  → Extra keys layout restored and applied!"
}

# ── 3. Restore dotfiles ─────────────────────────────────────────────────────
restore_dotfiles() {
  msg "Restoring shell dotfiles..."

  for f in bashrc zshrc profile bash_profile inputrc; do
    local src="$BACKUP_SRC/home/.$f"
    if [ -f "$src" ]; then
      cp "$src" ~/".$f"
      msg "  → .$f restored"
    fi
  done

  # Source bashrc if restored
  if [ -f ~/.bashrc ]; then
    source ~/.bashrc 2>/dev/null || true
  fi
}

# ── 4. Restore git config ───────────────────────────────────────────────────
restore_gitconfig() {
  if [ -f "$BACKUP_SRC/home/.gitconfig" ]; then
    msg "Restoring ~/.gitconfig..."
    cp "$BACKUP_SRC/home/.gitconfig" ~/.gitconfig
    msg "  → .gitconfig restored"
  fi
}

# ── 5. Restore SSH keys ─────────────────────────────────────────────────────
restore_ssh() {
  if [ -f "$BACKUP_SRC/home/.ssh/authorized_keys" ]; then
    msg "Restoring SSH authorized keys..."
    mkdir -p ~/.ssh
    cp "$BACKUP_SRC/home/.ssh/authorized_keys" ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
    msg "  → SSH keys restored"
  fi
}

# ── 6. Reload and finish ────────────────────────────────────────────────────
finalize() {
  echo ""
  msg "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  msg "  ✅ Restore complete!"
  msg ""
  msg "  What was done:"
  msg "  • Packages installed from backup list"
  msg "  • ~/.termux/ config restored"
  msg "  • Shell dotfiles restored"
  msg "  • Git config restored"
  msg "  • SSH keys restored"
  msg "  • Extra keys layout applied"
  msg ""
  msg "  Next steps:"
  msg "  • Restart Termux (force-stop + reopen)"
  msg "  • Run: bash termux-setup/backup.sh --push"
  msg "  • Verify your extra keys row is showing"
  msg "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║   Termux Restore                     ║"
  echo "  ║   Fresh device setup                 ║"
  echo "  ╚══════════════════════════════════════╝"
  echo ""

  check_requirements
  restore_packages
  restore_termux_config
  restore_dotfiles
  restore_gitconfig
  restore_ssh
  finalize
}

main "$@"
