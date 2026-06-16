#!/data/data/com.termux/files/usr/bin/bash
# =============================================================================
# Termux — Full Restore (packages, shell, CLI tools, dotfiles, extra keys)
# =============================================================================
# Run via bootstrap.sh (one-liner) or directly:
#
#   bash ~/termux-setup/restore.sh
#
# This will:
#   1. Install ALL packages from saved package list
#   2. Install modern CLI tools (eza, bat, jq, zoxide, lazygit, duf)
#   3. Configure Fish shell (custom prompt, aliases, zoxide, fzf)
#   4. Restore dotfiles (.bashrc, .gitconfig, .ssh)
#   5. Apply Termux extra keys layout
#   6. Set up clipboard, zoxide, and other integrations
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_SRC="$SCRIPT_DIR/backup"

if [ ! -d "$BACKUP_SRC" ]; then
  echo "  ⚠️  No backup/ directory found alongside restore.sh"
  echo "     Make sure the repo is fully cloned."
  exit 1
fi

RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; CYAN='\033[1;36m'; NC='\033[0m'
msg()  { echo -e "${GREEN}[*]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[!!]${NC} $*"; }

# =============================================================================
# STEP 1: Install all system packages
# =============================================================================
install_packages() {
  msg "Step 1: Installing packages..."

  apt update -qq

  if [ -f "$BACKUP_SRC/packages.txt" ]; then
    awk '{print $1}' "$BACKUP_SRC/packages.txt" > "$BACKUP_SRC/_pkg_names.txt"
    local count; count=$(wc -l < "$BACKUP_SRC/_pkg_names.txt")
    msg "  → Installing $count packages from backup list (will take a while)..."
    apt install -y $(cat "$BACKUP_SRC/_pkg_names.txt") 2>/dev/null || {
      warn "Some packages failed — normal for version mismatches."
    }
  fi

  # Ensure must-have tools (might be missing from old backup lists)
  for critical in eza bat jq zoxide lazygit duf fish termux-api fd ripgrep fzf ffmpeg; do
    if ! command -v "$critical" &>/dev/null && ! dpkg -s "$critical" &>/dev/null 2>&1; then
      info "  → Installing $critical..."
      apt install -y "$critical" 2>/dev/null || warn "  → Could not install $critical"
    fi
  done

  rm -f "$BACKUP_SRC/_pkg_names.txt"
  msg "  → Packages done!"
}

# =============================================================================
# STEP 2: Configure Fish shell
# =============================================================================
configure_fish() {
  msg "Step 2: Configuring Fish shell..."

  mkdir -p ~/.config/fish

  # If backed up, restore; otherwise write template
  if [ -f "$BACKUP_SRC/fish/config.fish" ]; then
    cp "$BACKUP_SRC/fish/config.fish" ~/.config/fish/config.fish
  else
    cat > ~/.config/fish/config.fish << 'FISHCONFIG'
# ── Termux Fish Config ────────────────────────────────────────

function fish_prompt
    set -l last_status $status
    if test $last_status -ne 0
        set_color red
        echo -n "[$last_status] "
    end
    set_color green
    echo -n (prompt_pwd)
    set -l git_branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -n "$git_branch"
        set_color blue
        echo -n " $git_branch"
    end
    set_color normal
    echo -n ' ➜ '
end

if status is-interactive
    alias ls="eza --icons"
    alias la="eza -la --icons"
    alias ll="eza -l --icons"
    alias lt="eza -T --icons"
    alias lta="eza -Ta --icons"
    alias cat="bat"
    alias du="duf"
    alias df="duf"
    alias grep="rg"
    alias find="fd"

    alias g="lazygit"
    alias gs="git status"
    alias gc="git commit"
    alias gp="git push"
    alias gl="git log --oneline --graph"

    zoxide init fish | source

    set -gx EDITOR nano
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    if command -q termux-clipboard-get
        alias copy="termux-clipboard-set"
        alias paste="termux-clipboard-get"
    end
end
FISHCONFIG
  fi

  # Set fish as default shell
  if [ "$SHELL" != "$(command -v fish)" ]; then
    chsh -s fish 2>/dev/null || warn "  → Could not set fish as default (run: chsh -s fish)"
  fi
  msg "  → Fish configured!"
}

# =============================================================================
# STEP 3: Restore dotfiles
# =============================================================================
restore_dotfiles() {
  msg "Step 3: Restoring dotfiles..."

  if [ -f "$BACKUP_SRC/home/.bashrc" ]; then
    cp "$BACKUP_SRC/home/.bashrc" ~/.bashrc
    msg "  → .bashrc restored"
  fi

  if [ -f "$BACKUP_SRC/home/.gitconfig" ]; then
    cp "$BACKUP_SRC/home/.gitconfig" ~/.gitconfig
    msg "  → .gitconfig restored"
  fi

  if [ -d "$BACKUP_SRC/home/.ssh" ]; then
    mkdir -p ~/.ssh
    cp -r "$BACKUP_SRC/home/.ssh"/* ~/.ssh/ 2>/dev/null || true
    chmod 600 ~/.ssh/authorized_keys 2>/dev/null || true
    msg "  → SSH keys restored"
  fi
}

# =============================================================================
# STEP 4: Apply Termux extra keys
# =============================================================================
apply_termux_config() {
  msg "Step 4: Applying Termux config..."

  if [ -f "$BACKUP_SRC/home/.termux/termux.properties" ]; then
    mkdir -p ~/.termux
    cp "$BACKUP_SRC/home/.termux/termux.properties" ~/.termux/
    msg "  → Extra keys layout restored"
  fi

  if command -v termux-reload-settings &>/dev/null; then
    termux-reload-settings 2>/dev/null || true
    msg "  → Settings reloaded"
  fi
}

# =============================================================================
# FINAL
# =============================================================================
finalize() {
  echo ""
  msg "╔══════════════════════════════════════════════╗"
  msg "║        ✅  TERMUX RESTORE COMPLETE            ║"
  msg "╚══════════════════════════════════════════════╝"
  echo ""
  echo "  📦  Packages installed"
  echo "  🐟  Fish shell — clean prompt, aliases, zoxide"
  echo "  🛠️   eza, bat, jq, zoxide, lazygit, duf"
  echo "  📋  termux-api (clipboard, notifications)"
  echo "  ⌨️   Extra keys layout applied"
  echo "  🔑  Dotfiles restored"
  echo ""
  echo "  ──────────────────────────────────────────"
  echo "  Next: restart Termux (force-stop + reopen)"
  echo ""
  echo "  One-liner for new devices:"
  echo "  bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/QMahyar/termux-setup/main/bootstrap.sh)\""
  echo "  ──────────────────────────────────────────"
  echo ""
}

# =============================================================================
# MAIN
# =============================================================================
main() {
  echo ""
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║   Termux Restore                     ║"
  echo "  ╚══════════════════════════════════════╝"
  echo ""

  install_packages
  configure_fish
  restore_dotfiles
  apply_termux_config
  finalize
}

main "$@"
