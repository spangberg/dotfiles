#!/usr/bin/env bash
#
# Bootstrap a macOS machine from this dotfiles repo.
# Safe to re-run: installs are skipped when already present,
# and existing config files are backed up before being replaced by symlinks.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y-%m-%d-%H%M%S)"

info() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$1"; }

# link <repo-relative-src> <absolute-dst>
# Backs up a pre-existing regular file at dst, then (re)creates the symlink.
link() {
  local rel="$1" dst="$2"
  local src="$DOTFILES_DIR/$rel"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    command mv "$dst" "$BACKUP_DIR/${rel//\//_}"
    printf '    backed up existing file to %s\n' "$BACKUP_DIR/${rel//\//_}"
  fi
  ln -sfn "$src" "$dst"
  printf '    %s -> %s\n' "$dst" "$src"
}

[[ "$(uname)" == "Darwin" ]] || {
  echo "This script only supports macOS." >&2
  exit 1
}

# ----------------------------------------------------------------------------
# Homebrew and packages
# ----------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

info "Installing packages, casks, and VSCode extensions from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ----------------------------------------------------------------------------
# Language toolchain managers and Claude Code (standalone installers)
# ----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/.volta/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
  info "Installing uv"
  # No PATH modification: the repo .zshrc already sources ~/.local/bin/env
  curl -LsSf https://astral.sh/uv/install.sh | env UV_NO_MODIFY_PATH=1 sh
fi

if ! command -v volta >/dev/null 2>&1; then
  info "Installing volta"
  # --skip-setup: the repo .zshenv already puts ~/.volta/bin on PATH
  curl -fsSL https://get.volta.sh | bash -s -- --skip-setup
  volta install node
fi

if ! command -v claude >/dev/null 2>&1; then
  info "Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

# ----------------------------------------------------------------------------
# Symlink configuration files
# ----------------------------------------------------------------------------
info "Linking dotfiles"
link zsh/.zshrc "$HOME/.zshrc"
link zsh/.zshenv "$HOME/.zshenv"
link zsh/.zprofile "$HOME/.zprofile"
link zsh/.p10k.zsh "$HOME/.p10k.zsh"
link git/.gitconfig "$HOME/.gitconfig"
link claude/CLAUDE.md "$HOME/.claude/CLAUDE.md"
link claude/settings.json "$HOME/.claude/settings.json"
link vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

info "Done. Open a new terminal to load the new shell configuration."
