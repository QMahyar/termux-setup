# ── Pi-powered Termux Fish Config ──────────────────────────────

# ── Clean prompt — no u0_a738@localhost garbage ──
function fish_prompt
    # Exit code in red if non-zero
    set -l last_status $status
    if test $last_status -ne 0
        set_color red
        echo -n "[$last_status] "
    end

    # Current directory in green
    set_color green
    echo -n (prompt_pwd)

    # Git branch in blue (if in a repo)
    set -l git_branch (command git symbolic-ref --short HEAD 2>/dev/null)
    if test -n "$git_branch"
        set_color blue
        echo -n " $git_branch"
    end

    # Prompt symbol
    set_color normal
    echo -n ' ➜ '
end

if status is-interactive

    # ── Aliases: modern replacements ──
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

    # ── Git shortcuts ──
    alias g="lazygit"
    alias gs="git status"
    alias gc="git commit"
    alias gp="git push"
    alias gl="git log --oneline --graph"

    # ── Pi helpers ──
    alias pi-update="npm install -g --ignore-scripts @earendil-works/pi-coding-agent"
    alias pi-logs="tail -f ~/.pi/agent/sessions/*.jsonl 2>/dev/null"

    # ── zoxide: smart cd ──
    zoxide init fish | source

    # ── Set editor ──
    set -gx EDITOR nano

    # ── FZF: use fd for faster search ──
    set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    # ── Termux clipboard helper ──
    if command -q termux-clipboard-get
        alias copy="termux-clipboard-set"
        alias paste="termux-clipboard-get"
    end
end
