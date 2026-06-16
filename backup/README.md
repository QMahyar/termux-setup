# Termux Setup — QMahyar

One command to turn a fresh Termux into a fully loaded dev environment
with Fish shell, modern CLI tools, and custom extra keys.

## 🚀 One-Liner Setup

On a brand new Termux, run **one command**:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/QMahyar/termux-setup/main/bootstrap.sh)"
```

That's it — it installs everything:

- **200+ packages** (git, nodejs, fish, ffmpeg, ripgrep, fd, fzf…)
- **Modern CLI tools**: eza, bat, jq, zoxide, lazygit, duf
- **termux-api** — clipboard, notifications, device info
- **Fish shell** — custom prompt (no ugly `u0_a738@localhost`), aliases, zoxide, fzf
- **Dotfiles** — .bashrc, .gitconfig, SSH keys
- **Extra keys layout** — Developer PC layout (ESC, TAB, arrows, etc.)

## ⚡ Quick Ref

```bash
# ── One-liner: fresh device setup ──
bash -c "$(curl -fsSL https://raw.githubusercontent.com/QMahyar/termux-setup/main/bootstrap.sh)"

# ── Backup current state + push ──
cd ~/termux-setup && bash backup.sh --push
```

## 📦 What You Get

| Category | Tools |
|----------|-------|
| **Shell** | Fish with clean prompt (`~/path ➜`), bash as fallback |
| **CLI** | eza, bat, jq, zoxide (`z`), lazygit (`g`), duf, fd, rg, fzf |
| **Git** | gh CLI, lazygit TUI, git aliases |
| **System** | termux-api, ffmpeg, curl, wget, nano |
| **Extra Keys** | 3-row Developer PC layout with popups |

## 🔁 Backup Workflow

```bash
# Snapshot your current setup
bash backup.sh

# Snapshot + push to GitHub
bash backup.sh --push
```

The backup captures:

- **Package list** — every installed package
- **Termux config** — extra keys, colors, motd
- **Dotfiles** — .bashrc, .gitconfig, SSH authorized keys
- **Fish config** — custom prompt, aliases, zoxide, fzf
- **Repo scripts** — snapshot of bootstrap.sh, restore.sh, README.md, termux.properties

Then `--push` commits everything to GitHub as `Auto-backup YYYY-MM-DD_hhmmss`.

## 📁 Repo Structure

```
termux-setup/
├── bootstrap.sh          # One-liner entry point (curl | bash)
├── restore.sh            # Full restore (packages, fish, dotfiles, keys)
├── backup.sh             # Backup current state + push to GitHub
├── setup.sh              # Legacy one-time init script
├── termux.properties     # Extra keys layout reference
├── backup/
│   ├── bootstrap.sh      # Snapshot of bootstrap (from last backup)
│   ├── restore.sh        # Snapshot of restore (from last backup)
│   ├── README.md          # Snapshot of README (from last backup)
│   ├── termux.properties  # Snapshot of keys (from last backup)
│   ├── packages.txt      # Installed package list (204)
│   ├── manifest.txt      # Backup metadata
│   ├── home/             # Dotfiles (.bashrc, .gitconfig, .ssh, .termux/)
│   └── fish/             # Fish shell config
└── README.md
```

## 🔑 After Setup

Restart Termux (force-stop + reopen), and you're good.
