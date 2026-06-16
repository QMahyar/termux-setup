#!/data/data/com.termux/files/usr/bin/bash

# ── Clean & Minimal Termux Welcome ──────────────────────────────

# ── Customise this ────────────────────────────────────────────
# Change the greeting name to whatever you like:
NAME="Mahyar"  # change this to your name
# ──────────────────────────────────────────────────────────────

# ── Style helpers ──
BOLD='\e[1m'
DIM='\e[2m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
YELLOW='\e[0;33m'
RESET='\e[0m'
SEP="${DIM}──────────────────────────────────────${RESET}"

# ── Collect info ──
termux_ver="${TERMUX_VERSION:-Unknown}"
host="$(getprop ro.product.model 2>/dev/null || echo 'Android')"
android="$(getprop ro.build.version.release 2>/dev/null || echo '?')"
kernel="$(uname -r 2>/dev/null || echo '?')"
uptime_str="$(uptime -p 2>/dev/null | sed 's/up //' || echo '?')"
pkgs="$(pkg list-installed 2>/dev/null | wc -l)"
storage="$(df -h /data/data/com.termux/files/home 2>/dev/null | awk 'NR==2{print $3 " / " $2 " (" $5 " used)"}')"

# ── Render ──
echo -e "${SEP}"
echo -e " ${GREEN}✦${RESET} ${BOLD}Hello, ${NAME:-$(whoami)}!${RESET}   ${DIM}$(date '+%a %b %d  %H:%M')${RESET}"
echo -e "${SEP}"
echo -e " ${DIM}Device${RESET}     $host  •  Android $android"
echo -e " ${DIM}Kernel${RESET}     $kernel"
echo -e " ${DIM}Termux${RESET}     v$termux_ver  •  ${YELLOW}$pkgs${RESET} packages"
echo -e " ${DIM}Uptime${RESET}     $uptime_str"
echo -e " ${DIM}Storage${RESET}    $storage"
echo -e "${SEP}"
echo
