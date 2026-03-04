#!/bin/bash

# Auto push to GitHub
# Usage: bash push.sh "your commit message"
#        bash push.sh          (uses default message with timestamp)

set -e  # Exit on any error

# ─── Colors ─────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# ─── Commit Message ──────────────────────────────────────────────────────────
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
MESSAGE="${1:-"chore: auto update [$TIMESTAMP]"}"

echo -e "${YELLOW}📦 Staging all changes...${NC}"
git add .

# Check if there's anything to commit
if git diff --cached --quiet; then
  echo -e "${RED}⚠️  Nothing to commit. Working tree is clean.${NC}"
  exit 0
fi

echo -e "${YELLOW}✍️  Committing: \"$MESSAGE\"${NC}"
git commit -m "$MESSAGE"

echo -e "${YELLOW}🚀 Pushing to GitHub...${NC}"
git push origin main

echo -e "${GREEN}✅ Done! Successfully pushed to GitHub.${NC}"
