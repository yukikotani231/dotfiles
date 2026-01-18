#!/usr/bin/env bash
set -ue

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BACKUP_DIR="$HOME/.dotbackup"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

helpmsg() {
  cat >&2 <<EOF
Usage: $(basename "$0") [OPTIONS]

Install dotfiles by creating symlinks.

Options:
  -d, --debug     Enable debug mode
  -n, --dry-run   Show what would be done without making changes
  -h, --help      Show this help message

EOF
}

print_info() {
  printf "${CYAN}%s${NC}\n" "$1"
}

print_success() {
  printf "${GREEN}%s${NC}\n" "$1"
}

print_error() {
  printf "${RED}%s${NC}\n" "$1" >&2
}

ensure_backup_dir() {
  if [[ ! -d "$BACKUP_DIR" ]]; then
    print_info "$BACKUP_DIR not found. Creating..."
    $DRY_RUN || mkdir -p "$BACKUP_DIR"
  fi
}

backup_and_link() {
  local src="$1"
  local dest="$2"
  local name
  name="$(basename "$src")"

  # Remove existing symlink
  if [[ -L "$dest" ]]; then
    $DRY_RUN || rm -f "$dest"
  fi

  # Backup existing file/directory
  if [[ -e "$dest" ]]; then
    print_info "  backing up: $name"
    $DRY_RUN || mv "$dest" "$BACKUP_DIR/"
  fi

  # Create symlink
  $DRY_RUN || ln -snf "$src" "$dest"
  print_success "  linked: $name"
}

link_to_homedir() {
  print_info "Linking dotfiles to home directory..."
  ensure_backup_dir

  if [[ "$HOME" == "$DOTDIR" ]]; then
    print_error "Error: dotfiles directory is same as home directory"
    return 1
  fi

  for f in "$DOTDIR"/.??*; do
    local name
    name="$(basename "$f")"

    # Skip special files
    [[ "$name" == ".git" ]] && continue
    [[ "$name" == ".config" ]] && continue
    [[ "$name" == ".gitignore" ]] && continue

    backup_and_link "$f" "$HOME/$name"
  done
}

link_config_dir() {
  print_info "Linking .config directories..."
  local config_src="$DOTDIR/.config"

  if [[ ! -d "$config_src" ]]; then
    print_info "No .config directory in dotfiles, skipping..."
    return
  fi

  # Ensure config directories exist
  $DRY_RUN || mkdir -p "$CONFIG_HOME"
  $DRY_RUN || mkdir -p "$BACKUP_DIR/.config"

  for f in "$config_src"/*; do
    [[ ! -e "$f" ]] && continue  # Skip if no matches
    local name
    name="$(basename "$f")"
    backup_and_link "$f" "$CONFIG_HOME/$name"
  done
}

setup_zshrc() {
  local line='[[ -f ~/.zshrc.custom ]] && source ~/.zshrc.custom'

  if [[ ! -f "$HOME/.zshrc" ]]; then
    print_info "No .zshrc found, skipping zshrc setup..."
    return
  fi

  if grep -qF ".zshrc.custom" "$HOME/.zshrc"; then
    print_info ".zshrc.custom already configured in .zshrc"
  else
    print_info "Adding .zshrc.custom to .zshrc"
    if ! $DRY_RUN; then
      printf '\n# Custom settings from dotfiles\n%s\n' "$line" >> "$HOME/.zshrc"
    fi
    print_success "Added .zshrc.custom to .zshrc"
  fi
}

# Default options
DRY_RUN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug|-d)
      set -uex
      ;;
    --dry-run|-n)
      DRY_RUN=true
      print_info "=== DRY RUN MODE ==="
      ;;
    --help|-h)
      helpmsg
      exit 0
      ;;
    *)
      print_error "Unknown option: $1"
      helpmsg
      exit 1
      ;;
  esac
  shift
done

# Run installation
link_to_homedir
link_config_dir
setup_zshrc

printf "\n${GREEN}Install completed!${NC}\n"
