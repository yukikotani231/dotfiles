#!/usr/bin/env bash
set -ue

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

helpmsg() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Sync dotfiles changes to GitHub.

Options:
  -m, --message MSG   Commit message (skips prompt)
  -h, --help          Show this help message

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

cd "$DOTDIR"

# Parse arguments
COMMIT_MSG=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --message|-m)
      shift
      COMMIT_MSG="$1"
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

# Check if this is a git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  print_error "Error: Not a git repository"
  exit 1
fi

# Check if remote is configured
if ! git remote get-url origin &>/dev/null; then
  print_error "Error: No remote 'origin' configured"
  print_info "Add a remote with: git remote add origin <url>"
  exit 1
fi

# Check for changes
if [[ -z $(git status --porcelain) ]]; then
  print_info "No changes to sync."
  exit 0
fi

# Show changes
echo "=== Changes ==="
git status --short
echo ""

# Get commit message
if [[ -z "$COMMIT_MSG" ]]; then
  printf "Commit message (empty to cancel): "
  read -r COMMIT_MSG

  if [[ -z "$COMMIT_MSG" ]]; then
    print_info "Cancelled."
    exit 0
  fi
fi

# Commit and push
git add -A

if ! git commit -m "$COMMIT_MSG"; then
  print_error "Error: Commit failed"
  exit 1
fi

if ! git push; then
  print_error "Error: Push failed"
  print_info "You may need to pull first: git pull --rebase"
  exit 1
fi

echo ""
print_success "Synced!"
