#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-/opt/realtime-chat-app}"
REPO_URL="${REPO_URL:-}"
BRANCH="${BRANCH:-main}"

if [[ -z "${REPO_URL}" ]]; then
  echo "REPO_URL is required. Example:"
  echo "  REPO_URL=https://github.com/<you>/<repo>.git bash deploy/linux/deploy.sh"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root: sudo -E bash deploy/linux/deploy.sh"
  exit 1
fi

apt-get update
apt-get install -y curl git build-essential

if ! command -v node >/dev/null 2>&1 || [[ "$(node -v | cut -d. -f1 | tr -d 'v')" -lt 20 ]]; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
fi

if [[ ! -d "${APP_DIR}/.git" ]]; then
  git clone --branch "${BRANCH}" "${REPO_URL}" "${APP_DIR}"
else
  git -C "${APP_DIR}" fetch origin
  git -C "${APP_DIR}" checkout "${BRANCH}"
  git -C "${APP_DIR}" pull --ff-only origin "${BRANCH}"
fi

cd "${APP_DIR}"

if [[ ! -f backend/.env ]]; then
  cp backend/.env.example backend/.env
  echo "Created backend/.env from template. Please edit before production use."
fi

npm run build

cp deploy/linux/chat-app.service /etc/systemd/system/chat-app.service
systemctl daemon-reload
systemctl enable chat-app
systemctl restart chat-app

echo "Deployment finished."
echo "Check status: systemctl status chat-app"
