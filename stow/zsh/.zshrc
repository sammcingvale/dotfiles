# ─────────────────────────────────────────────────────────────────────
#  ~/.zshrc — managed by dotfiles repo, do not edit in place
# ─────────────────────────────────────────────────────────────────────

# Homebrew
if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LESS="-FRX"

# ── History ──────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt EXTENDED_HISTORY

# ── Directory & nav ──────────────────────────────────────────────────
setopt AUTO_CD          # bare directory name = cd
setopt AUTO_PUSHD       # push old dir to stack on cd
setopt PUSHD_IGNORE_DUPS

# ── Completion ───────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'    # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Key bindings ─────────────────────────────────────────────────────
bindkey -e   # emacs-style. Switch to `bindkey -v` for vim mode.
bindkey '^[[A' history-search-backward    # up arrow searches history by prefix
bindkey '^[[B' history-search-forward
bindkey '^R' history-incremental-search-backward

# ── Aliases ──────────────────────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --git --group-directories-first'
alias la='eza -a --icons'
alias lt='eza --tree --level=2 --icons --git-ignore'
alias cat='bat --paging=never --style=plain'
alias catp='bat'                        # paged + line numbers
alias grep='rg'
alias find='fd'
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias lg='lazygit'
alias dots='cd ~/dotfiles'
alias reload='source ~/.zshrc && echo "zsh reloaded."'
alias ports='lsof -i -P -n | grep LISTEN'
alias myip='curl -s ifconfig.me && echo'
alias serve='python3 -m http.server'

# Project shortcuts (edit to taste)
alias rocket='cd ~/code/rocket-tracker'
alias wf='cd ~/code/wallfacer'

# ── Tools ────────────────────────────────────────────────────────────
# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --strip-cwd-prefix --exclude .git'
export FZF_DEFAULT_OPTS="
  --height 40% --layout=reverse --border=rounded
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# zoxide (smarter cd)
eval "$(zoxide init zsh)"

# pyenv
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# zsh-autosuggestions + syntax-highlighting (must come before starship)
[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Starship prompt — keep last
eval "$(starship init zsh)"

# ── Greeting (optional flair — comment out if you hate it) ───────────
# Random Three-Body / sci-fi quote, dim grey
quotes=(
  "Don't answer. Don't answer. Don't answer."
  "The universe is a dark forest."
  "Weakness and ignorance are not survival barriers — arrogance is."
  "In the universe, no matter how fast you are, someone is faster."
  "Time is the cruelest force of all."
  "Wake up, Neo."
)
printf "\033[2;37m%s\033[0m\n" "${quotes[$RANDOM % ${#quotes[@]} + 1]}"

# ── Local overrides (gitignored) ─────────────────────────────────────
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
