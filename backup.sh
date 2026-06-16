#!/data/data/com.termux/files/usr/bin/bash
# =============================================================================
# Termux Setup — Full Backup Script
# =============================================================================
# Saves everything needed to restore your Termux on a new device:
#   • All installed packages list
#   • ~/.termux/ (termux.properties, colors, etc.)
#   • ~/.bashrc and other shell configs
#   • ~/.gitconfig
#   • ~/.ssh/ (authorized keys)
#   • ~/termux-setup/ itself (this script, restore script, layouts)
#
# Run: bash backup.sh
# Then push to GitHub: bash backup.sh --push
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')
PACKAGE_LIST="$BACKUP_DIR/packages.txt"
TERMUX_DIR="$BACKUP_DIR/home/.termux"
DOTFILES_DIR="$BACKUP_DIR/home"

msg()  { echo -e "\033[1;32m[*]\033[0m $*"; }
warn() { echo -e "\033[1;33m[!]\033[0m $*"; }
err()  { echo -e "\033[1;31m[!!]\033[0m $*"; }

# ── 1. Save package list ────────────────────────────────────────────────────
backup_packages() {
  msg "Backing up installed packages..."
  mkdir -p "$BACKUP_DIR"
  dpkg --get-selections | grep -v deinstall > "$PACKAGE_LIST"
  local count
  count=$(wc -l < "$PACKAGE_LIST")
  msg "  → $count packages saved to $PACKAGE_LIST"
}

# ── 2. Save termux configs ──────────────────────────────────────────────────
backup_termux_config() {
  msg "Backing up ~/.termux/ config..."
  mkdir -p "$TERMUX_DIR"
  if [ -d ~/.termux ]; then
    cp -r ~/.termux/* "$TERMUX_DIR/" 2>/dev/null || true
    msg "  → .termux/ config saved"
  fi
}

# ── 3. Save shell dotfiles ──────────────────────────────────────────────────
backup_dotfiles() {
  msg "Backing up shell dotfiles..."
  mkdir -p "$DOTFILES_DIR"

  for f in ~/.bashrc ~/.zshrc ~/.profile ~/.bash_profile ~/.inputrc; do
    if [ -f "$f" ]; then
      cp "$f" "$DOTFILES_DIR/"
      msg "  → $(basename $f) saved"
    fi
  done
}

# ── 4. Save git config ──────────────────────────────────────────────────────
backup_gitconfig() {
  if [ -f ~/.gitconfig ]; then
    msg "Backing up ~/.gitconfig..."
    cp ~/.gitconfig "$DOTFILES_DIR/.gitconfig"
    msg "  → .gitconfig saved"
  fi
}

# ── 5. Save SSH authorized keys ─────────────────────────────────────────────
backup_ssh() {
  if [ -f ~/.ssh/authorized_keys ]; then
    msg "Backing up SSH authorized keys..."
    mkdir -p "$BACKUP_DIR/home/.ssh"
    cp ~/.ssh/authorized_keys "$BACKUP_DIR/home/.ssh/"
    msg "  → authorized_keys saved"
  fi
}

# ── 6. Save custom scripts in termux-setup ──────────────────────────────────
backup_self() {
  msg "Saving restore and layout scripts..."
  # The scripts are already in termux-setup, just ensure they're in the right place
  if [ -f "$SCRIPT_DIR/restore.sh" ]; then
    cp "$SCRIPT_DIR/restore.sh" "$BACKUP_DIR/restore.sh"
    msg "  → restore.sh saved"
  fi
}

# ── 7. Generate status report ──────────────────────────────────────────────
generate_manifest() {
  local pkg_count
  pkg_count=$(wc -l < "$PACKAGE_LIST")
  cat > "$BACKUP_DIR/manifest.txt" <<EOF
Termux Backup — $TIMESTAMP
━━━━━━━━━━━━━━━━━━━━━━━
Packages:  $pkg_count
Hostname:  $(uname -a 2>/dev/null | awk '{print $2}')
Android:   $(getprop ro.build.version.release 2>/dev/null || echo "unknown")
Device:    $(getprop ro.product.model 2>/dev/null || echo "unknown")
EOF
  msg "  → manifest.txt created"
}

# ── Push to GitHub ───────────────────────────────────────────────────────────
push_to_github() {
  msg "Pushing to GitHub..."

  cd "$SCRIPT_DIR"
  if ! git remote get-url origin &>/dev/null; then
    warn "No git remote 'origin' configured."
    warn "Set it up first: git remote add origin https://github.com/YOUR_USER/termux-setup.git"
    return 1
  fi

  # Stage all changes in the repo (backup/ dir, scripts, etc.)
  git add -A

  # Only commit+push if there are actual changes
  if git diff --cached --quiet; then
    msg "  → Nothing new to commit (up to date)"
  else
    git commit -m "Auto-backup $TIMESTAMP"
    git push origin main || git push origin master || warn "Push failed — check remote"
    msg "  → Pushed to GitHub"
  fi
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║   Termux Backup                      ║"
  echo "  ║   $(date '+%Y-%m-%d %H:%M')                ║"
  echo "  ╚══════════════════════════════════════╝"
  echo ""

  backup_packages
  backup_termux_config
  backup_dotfiles
  backup_gitconfig
  backup_ssh
  backup_self
  generate_manifest

  echo ""
  msg "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  msg "  Backup complete!"
  msg "  Location: $BACKUP_DIR"
  msg "  Size:     $(du -sh "$BACKUP_DIR" | cut -f1)"
  msg "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Auto-push if --push flag
  if [ "${1:-}" = "--push" ]; then
    push_to_github
  else
    echo "  Next step:"
    echo "    bash backup.sh --push    to push to GitHub"
    echo ""
  fi
}

main "$@"
