#!/usr/bin/env bash
# Bootstrap a fresh macOS dev environment.
# Idempotent: safe to re-run.

set -euo pipefail

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

log()  { printf "\033[0;32m▶\033[0m %s\n" "$1"; }
warn() { printf "\033[0;33m⚠\033[0m %s\n" "$1"; }
die()  { printf "\033[0;31m✗\033[0m %s\n" "$1" >&2; exit 1; }

# ── Sanity checks ────────────────────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || die "This script is for macOS."

# ── 1. Xcode Command Line Tools (needed for git, brew) ───────────────
if ! xcode-select -p &>/dev/null; then
  log "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "A GUI prompt opened. Press Enter once installation finishes..."
  read -r
fi

# ── 2. Homebrew ──────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available in this shell
if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ── 3. Brewfile ──────────────────────────────────────────────────────
log "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ── 3b. Verify Homebrew dependency health ────────────────────────────
log "Checking Homebrew dependency health..."

# 1. Are any declared dependencies missing?
if missing=$(brew missing 2>&1) && [ -n "$missing" ]; then
  warn "Formulae with missing dependencies:"
  echo "$missing"
  warn "Reinstalling affected formulae..."
  echo "$missing" | awk -F: '{print $1}' | xargs -n1 brew reinstall
fi

# 2. Any binaries linked against libraries that no longer exist?
#    (catches the libgit2 / libllhttp.9.3.dylib class of issue)
log "Checking for broken library linkage..."
broken=$(brew list --formula | while read -r f; do
  if ! brew linkage --test "$f" &>/dev/null; then
    echo "$f"
  fi
done)

if [ -n "$broken" ]; then
  warn "Formulae with broken linkage (rebuilding):"
  echo "$broken"
  echo "$broken" | xargs -n1 brew reinstall
else
  log "All formulae have working linkage."
fi

# ── 4. Backup existing dotfiles, then stow ───────────────────────────
log "Linking configs into \$HOME with stow..."
cd "$DOTFILES_DIR/stow"

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Conflicts stow would hit: anything in $HOME that already exists as a real file
# rather than a symlink to our repo. Move those aside.
for pkg in */; do
  pkg="${pkg%/}"
  while IFS= read -r -d '' file; do
    rel="${file#$DOTFILES_DIR/stow/$pkg/}"
    target="$HOME/$rel"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
      mv "$target" "$BACKUP_DIR/$rel"
      warn "Backed up $target -> $BACKUP_DIR/$rel"
    fi
  done < <(find "$DOTFILES_DIR/stow/$pkg" -type f -print0)
done

# Now stow, restow-style so it's idempotent
for dir in */; do
  pkg="${dir%/}"
  log "Stowing $pkg"
  stow -v -R --no-folding -t "$HOME" "$pkg"
done

# ── 5. tmux plugin manager ───────────────────────────────────────────
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  log "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# ── 6. Default shell ─────────────────────────────────────────────────
if [[ "$SHELL" != *"zsh"* ]]; then
  log "Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

# ── 7. Macos defaults (sane developer tweaks) ────────────────────────
log "Applying sensible macOS defaults..."
# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Disable press-and-hold for keys (so vim hjkl repeats)
defaults write -g ApplePressAndHoldEnabled -bool false
killall Finder 2>/dev/null || true

cat <<'EOF'

──────────────────────────────────────────────
✓ Bootstrap complete.

Next steps:
  1. Quit and reopen your terminal (or launch Ghostty).
  2. In tmux, press  Ctrl-a + I  to install plugins.
  3. Run  nvim  — Lazy.nvim auto-installs plugins on first launch.
  4. Edit  ~/.gitconfig.local  with your name/email (see README).
  5. (Optional) Authenticate GitHub:  gh auth login

If something looks off, your old configs are in ~/.dotfiles-backup-*
──────────────────────────────────────────────
EOF
