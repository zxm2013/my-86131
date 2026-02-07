#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_URL="${1:-https://github.com/harshsuiiii/Real-time-chat-app.git}"
UPSTREAM_BRANCH="${2:-main}"
TARGET_BRANCH="${3:-main}"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  echo "Run inside a git repository."
  exit 1
}

if git remote get-url upstream >/dev/null 2>&1; then
  git remote set-url upstream "${UPSTREAM_URL}"
else
  git remote add upstream "${UPSTREAM_URL}"
fi

git fetch upstream "${UPSTREAM_BRANCH}"
git checkout "${TARGET_BRANCH}"
git merge --no-edit "upstream/${UPSTREAM_BRANCH}"

echo "Upstream sync complete: upstream/${UPSTREAM_BRANCH} -> ${TARGET_BRANCH}"
