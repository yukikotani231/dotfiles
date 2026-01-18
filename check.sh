#!/usr/bin/env bash
set -u

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

helpmsg() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Check if required and optional tools are installed.

Options:
  -h, --help    Show this help message

EOF
}

check_command() {
  local cmd="$1"
  local name="${2:-$1}"
  local required="${3:-true}"
  local label="[required]"
  local version

  if [[ "$required" == "false" ]]; then
    label="[optional]"
  fi

  if command -v "$cmd" &> /dev/null; then
    version=$("$cmd" --version 2>/dev/null | head -1) || true
    if [[ -z "$version" ]]; then
      version=$("$cmd" -V 2>/dev/null | head -1) || true
    fi
    if [[ -z "$version" ]]; then
      version="installed"
    fi
    printf "${GREEN}✓${NC} %s %s: %s\n" "$name" "$label" "$version"
    return 0
  else
    if [[ "$required" == "true" ]]; then
      printf "${RED}✗${NC} %s %s: not found\n" "$name" "$label"
    else
      printf "${YELLOW}○${NC} %s %s: not found\n" "$name" "$label"
    fi
    return 1
  fi
}

check_dir() {
  local dir="$1"
  local name="$2"
  local required="${3:-true}"
  local label="[required]"

  if [[ "$required" == "false" ]]; then
    label="[optional]"
  fi

  if [[ -d "$dir" ]]; then
    printf "${GREEN}✓${NC} %s %s: %s\n" "$name" "$label" "$dir"
    return 0
  else
    if [[ "$required" == "true" ]]; then
      printf "${RED}✗${NC} %s %s: not found\n" "$name" "$label"
    else
      printf "${YELLOW}○${NC} %s %s: not found\n" "$name" "$label"
    fi
    return 1
  fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      helpmsg
      exit 0
      ;;
    *)
      printf "${RED}Unknown option: %s${NC}\n" "$1" >&2
      helpmsg
      exit 1
      ;;
  esac
  shift
done

echo "Checking required tools..."
echo ""

missing_required=0

echo "=== Required ==="
check_command "zsh" "zsh" true || missing_required=$((missing_required + 1))
check_command "git" "git" true || missing_required=$((missing_required + 1))
check_command "tmux" "tmux" true || missing_required=$((missing_required + 1))
check_command "nvim" "neovim" true || missing_required=$((missing_required + 1))

echo ""
echo "=== Optional ==="
check_command "alacritty" "alacritty" false || true
check_command "gh" "GitHub CLI" false || true
check_command "mise" "mise" false || true
check_command "bun" "bun" false || true
check_command "cargo" "cargo (Rust)" false || true
check_dir "$HOME/.oh-my-zsh" "oh-my-zsh" false || true

echo ""
if [[ $missing_required -gt 0 ]]; then
  printf "${RED}Missing %d required tool(s)${NC}\n" "$missing_required"
  echo ""
  echo "Install missing tools:"
  echo "  macOS:  brew install zsh git tmux neovim"
  echo "  Ubuntu: sudo apt install zsh git tmux neovim"
  exit 1
else
  printf "${GREEN}All required tools are installed!${NC}\n"
fi
