# Termux Setup

Your personal Termux environment backed up to GitHub.

## What's Inside

```text
├── backup.sh              # Backup script (save configs + packages)
├── restore.sh             # Restore script (for new devices)
├── setup.sh               # One-time init (backup + GitHub push)
├── termux.properties      # Extra keys layout (Developer PC)
├── backup/
│   ├── packages.txt       # List of all installed packages
│   ├── manifest.txt       # Backup metadata
│   └── home/              # Dotfiles backup
│       ├── .bashrc
│       ├── .gitconfig
│       ├── .ssh/
│       └── .termux/
```

## Restore on a New Device

```bash
# 1. Install git and authenticate
pkg install git gh -y
gh auth login

# 2. Clone this repo
git clone https://github.com/YOUR_USER/termux-setup.git ~/termux-setup

# 3. Run restore (installs all packages, configs, dotfiles)
cd ~/termux-setup && bash restore.sh

# 4. Restart Termux
```

## Backup (after changes)

```bash
cd ~/termux-setup
bash backup.sh --push
```

## Extra Keys Layout

The bottom button row includes: ESC, TAB, BKSP⌫, DEL⌦, HOME⇱, ↑,
END⇲, PGUP⇑, PGDN⇓, CTRL, ALT, SHIFT, ⌨KBD, ←↓→, SPACE, ENTER↲.

Swipe up on any key for secondary actions (popups).
