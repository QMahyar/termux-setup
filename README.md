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
- **Fish shell** — custom prompt (no ugly u0_a738@localhost), aliases, zoxide, fzf
- **Dotfiles** — .bashrc, .gitconfig, SSH keys
- **Extra keys layout** — Developer PC layout (ESC, TAB, arrows, etc.)

## ⚡ Quick Ref

```bash
# One-liner setup on any new device
bash -c "$(curl -fsSL https://raw.githubusercontent.com/QMahyar/termux-setup/main/bootstrap.sh)"

# Backup current state + push to GitHub
cd ~/termux-setup && bash backup.sh --push
```

## 📦 What You Get

| Category | Tools |
|----------|-------|
| **Shell** | Fish with clean prompt (`~/path ➜`), bash as fallback |
| **CLI** | eza, bat, jq, zoxide (`z`), lazygit (`g`), duf, fd, rg, fzf |
| **Git** | gh CLI, lazygit TUI |
| **System** | termux-api, ffmpeg, curl, wget, nano |
| **Extra Keys** | 3-row Developer PC layout with popups |

## 🔑 After Setup

Restart Termux (force-stop + reopen), and you're good.

## 📁 Repo Structure

```
termux-setup/
├── bootstrap.sh          # One-liner entry point (curl | bash)
├── restore.sh            # Full restore (packages, fish, dotfiles, keys)
├── backup.sh             # Backup current state + push to GitHub
├── setup.sh              # Legacy init script
├── termux.properties     # Extra keys layout reference
├── backup/
│   ├── packages.txt      # Installed package list
│   ├── manifest.txt      # Backup metadata
│   ├── home/             # Dotfiles (.bashrc, .gitconfig, .ssh)
│   └── fish/             # Fish shell config
└── README.md
```
