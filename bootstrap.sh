#!/data/data/com.termux/files/usr/bin/bash
# =============================================================================
# Termux ONE-LINER Bootstrap — sets up everything from scratch
#
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/QMahyar/termux-setup/main/bootstrap.sh)"
#
# Or if curl isn't installed yet:
#   apt update && apt install curl -y && bash -c "$(curl -fsSL https://raw.githubusercontent.com/QMahyar/termux-setup/main/bootstrap.sh)"
# =============================================================================

set -euo pipefail

REPO="https://github.com/QMahyar/termux-setup.git"
SETUP_DIR="$HOME/termux-setup"

GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

msg()  { echo -e "${GREEN}[*]${NC} $*"; }
info() { echo -e "${CYAN}[~]${NC} $*"; }

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Termux One-Liner Bootstrap         ║"
echo "  ╚══════════════════════════════════════╝"
echo ""

# ── 1. Install git if missing ───────────────────────────────────────────────
if ! command -v git &>/dev/null; then
  msg "Installing git..."
  apt update -qq && apt install -y git -qq
fi

# ── 2. Clone (or pull) the setup repo ───────────────────────────────────────
if [ -d "$SETUP_DIR/.git" ]; then
  msg "Updating existing setup repo..."
  cd "$SETUP_DIR" && git pull --ff-only
else
  msg "Cloning setup repo..."
  git clone "$REPO" "$SETUP_DIR"
fi

# ── 3. Run full restore ─────────────────────────────────────────────────────
msg "Starting full restore..."
cd "$SETUP_DIR"
bash restore.sh

echo ""
info "To back up again later:  cd ~/termux-setup && bash backup.sh --push"
echo ""
