# Upstream Sync Guide

This repo is based on:

- upstream: `https://github.com/harshsuiiii/Real-time-chat-app.git`
- branch: `main`

## Local Sync

```bash
bash scripts/sync-upstream.sh https://github.com/harshsuiiii/Real-time-chat-app.git main
```

What it does:

1. configures/updates `upstream` remote
2. fetches upstream branch
3. merges `upstream/main` into current `main`
4. leaves your local customization commits intact

## GitHub Auto Sync

Workflow file:

- `.github/workflows/sync-upstream.yml`

It runs on:

- manual trigger (`workflow_dispatch`)
- daily schedule

Result:

- creates a PR with upstream changes using `peter-evans/create-pull-request`
