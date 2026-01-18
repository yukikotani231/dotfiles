#!/usr/bin/env bash
set -ue

cd "$(dirname "${BASH_SOURCE[0]}")"

# Check for changes
if [[ -z $(git status --porcelain) ]]; then
  echo "No changes to sync."
  exit 0
fi

# Show changes
echo "=== Changes ==="
git status --short
echo ""

# Prompt for commit message
read -p "Commit message (empty to cancel): " message

if [[ -z "$message" ]]; then
  echo "Cancelled."
  exit 0
fi

# Commit and push
git add -A
git commit -m "$message"
git push

echo ""
echo "Synced!"
