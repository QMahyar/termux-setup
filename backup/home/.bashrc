# ── ~/.bashrc — Optimised for Termux ──────────────────────────

# ── History ────────────────────────────────────────────────────
shopt -s histappend histverify
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT='%F %T  '

# ── Prompt — green path + blue git branch ─────────────────────
PROMPT_DIRTRIM=2
__git_ps1() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ -n "$branch" ]] && echo " ${branch}"
}
PS1='\[\e[0;32m\]\w\[\e[0m\]\[\e[1;34m\]$(__git_ps1)\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] '

# ── Colours ───────────────────────────────────────────────────
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'

# ── File ops ──────────────────────────────────────────────────
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lhA'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias ..='cd ..'
alias ...='cd ../..'
mkcd() { mkdir -p "$1" && cd "$1"; }

# ── Shortcuts ─────────────────────────────────────────────────
alias cls='clear'
alias h='history'
alias q='exit'
alias path='echo -e "${PATH//:/\\n}"'

# ── Termux package manager ────────────────────────────────────
alias update='pkg update && pkg upgrade'
alias install='pkg install'
alias uninstall='pkg uninstall'
alias search='pkg search'
alias files='pkg files'
alias show='pkg show'

# ── Networking ────────────────────────────────────────────────
alias myip='curl -s ifconfig.me && echo'
alias ports='ss -tulanp'

# ── Quick edit ────────────────────────────────────────────────
alias motd='$EDITOR ~/.termux/motd.sh'
alias rc='$EDITOR ~/.bashrc && source ~/.bashrc'

# ── Termux setup (backup/restore to GitHub) ───────────────────
termux() {
  case "${1:-help}" in
    backup)
      cd ~/termux-setup
      bash backup.sh --push
      ;;
    restore)
      echo "  To restore on a NEW device:"
      echo ""
      echo "    pkg install git gh -y"
      echo "    gh auth login"
      echo "    git clone https://github.com/QMahyar/termux-setup.git ~/termux-setup"
      echo "    cd ~/termux-setup && bash restore.sh"
      echo ""
      ;;
    keys)
      termux-reload-settings
      echo "Extra keys reloaded."
      ;;
    edit)
      ${EDITOR:-nano} ~/.termux/termux.properties
      termux-reload-settings
      ;;
    status|help|*)
      echo "Usage: termux <command>"
      echo ""
      echo "  backup   Backup config + packages and push to GitHub"
      echo "  restore  Show restore instructions for a new device"
      echo "  keys     Reload extra keys settings"
      echo "  edit     Edit extra keys config and apply"
      echo ""
      ;;
  esac
}

# Tab completion for termux command
_termux_complete() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local cmds="backup restore keys edit status help"
  COMPREPLY=( $(compgen -W "$cmds" -- "$cur") )
}
complete -F _termux_complete termux

# ── Command-not-found handler ─────────────────────────────────
if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then
  command_not_found_handle() {
    /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
  }
fi

# ── Bash completion ───────────────────────────────────────────
[ -r /data/data/com.termux/files/usr/share/bash-completion/bash_completion ] && \
  . /data/data/com.termux/files/usr/share/bash-completion/bash_completion

# ── fzf (fuzzy finder) ───────────────────────────────────────
[ -f /data/data/com.termux/files/usr/share/fzf/key-bindings.bash ] && \
  source /data/data/com.termux/files/usr/share/fzf/key-bindings.bash
[ -f /data/data/com.termux/files/usr/share/fzf/completion.bash ] && \
  source /data/data/com.termux/files/usr/share/fzf/completion.bash

# ── Auto-start fish ──────────────────────────────────────────
if [ -z "$FISH" ] && [ -z "$BASH_EXECUTION_STRING" ] && [ "$(ps -p $$ -o comm=)" != "fish" ]; then
  export FISH=1
  fish
fi
