#!/usr/bin/env bash
set -ue

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "Checking required tools..."
echo ""

check_command() {
  local cmd=$1
  local name=${2:-$1}
  local required=${3:-true}
  local label="[required]"

  if [[ "$required" == "false" ]]; then
    label="[optional]"
  fi

  if command -v "$cmd" &> /dev/null; then
    version=$($cmd --version 2>/dev/null | head -1)
    if [[ -z "$version" ]]; then
      version=$($cmd -V 2>/dev/null | head -1)
    fi
    if [[ -z "$version" ]]; then
      version="installed"
    fi
    echo -e "${GREEN}✓${NC} $name $label: $version"
    return 0
  else
    if [[ "$required" == "true" ]]; then
      echo -e "${RED}✗${NC} $name $label: not found"
    else
      echo -e "${YELLOW}○${NC} $name $label: not found"
    fi
    return 1
  fi
}

check_dir() {
  local dir=$1
  local name=$2
  local required=${3:-true}
  local label="[required]"

  if [[ "$required" == "false" ]]; then
    label="[optional]"
  fi

  if [[ -d "$dir" ]]; then
    echo -e "${GREEN}✓${NC} $name $label: $dir"
    return 0
  else
    if [[ "$required" == "true" ]]; then
      echo -e "${RED}✗${NC} $name $label: not found"
    else
      echo -e "${YELLOW}○${NC} $name $label: not found"
    fi
    return 1
  fi
}

missing_required=0

echo "=== Required ==="
check_command "zsh" "zsh" || ((missing_required++))
check_command "git" "git" || ((missing_required++))
check_command "tmux" "tmux" || ((missing_required++))
check_command "nvim" "neovim" || ((missing_required++))

echo ""
echo "=== Optional ==="
check_command "alacritty" "alacritty" false
check_command "gh" "GitHub CLI" false
check_command "mise" "mise" false
check_command "bun" "bun" false
check_command "cargo" "cargo (Rust)" false
check_dir "$HOME/.oh-my-zsh" "oh-my-zsh" false

echo ""
if [[ $missing_required -gt 0 ]]; then
  echo -e "${RED}Missing $missing_required required tool(s)${NC}"
  echo ""
  echo "Install missing tools:"
  echo "  macOS:  brew install zsh git tmux neovim"
  echo "  Ubuntu: sudo apt install zsh git tmux neovim"
  exit 1
else
  echo -e "${GREEN}All required tools are installed!${NC}"
fi
