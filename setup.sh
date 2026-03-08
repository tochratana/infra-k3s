#!/bin/bash

# Check if message provided
if [ -z "$1" ]; then
  echo "❌ Please provide commit message"
  echo "Usage: bash push.sh \"your message\""
  exit 1
fi

MSG=$1

git add .

# Commit only if there are changes
if git diff --cached --quiet; then
  echo "⚠️ No changes to commit"
  exit 0
fi

git commit -m "$MSG | $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

echo "✅ Pushed with message: $MSG"