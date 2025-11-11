#!/usr/bin/env bash
# xr_pages_sync.sh — sincronizza e pubblica dashboard su gh-pages
set -euo pipefail

REMOTE="${1:-https://github.com/HighKali/xr-infinity.git}"
PAGES_BRANCH="${PAGES_BRANCH:-gh-pages}"

echo "== XR∞ Pages Sync =="

# 1) Risolvi conflitti con politica ours
if [[ -n "$(git status --porcelain)" ]]; then
  echo "🔀 Risolvo conflitti con politica ours…"
  git checkout --ours .
  git add -A
  git commit -m "XR∞ auto-merge ours (pages sync)" || true
fi

# 2) Assicurati di avere main aggiornato
git branch -M main
git remote add origin "$REMOTE" 2>/dev/null || true
git fetch origin
git pull origin main --allow-unrelated-histories || true
git push origin main || true

# 3) Crea gh-pages se non esiste
if ! git show-ref --verify --quiet "refs/heads/$PAGES_BRANCH"; then
  echo "🌐 Creo branch $PAGES_BRANCH…"
  git checkout --orphan $PAGES_BRANCH
  rm -rf *
  echo "<!doctype html><title>XR∞ gh-pages</title>" > index.html
  git add index.html
  git commit -m "Init gh-pages"
  git push -u origin $PAGES_BRANCH
  git checkout main
fi

# 4) Aggiorna gh-pages con dashboard
TMPDIR="$(mktemp -d)"
rsync -a docs/ "$TMPDIR/"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git checkout $PAGES_BRANCH
rsync -a --delete "$TMPDIR/" ./
git add -A
git commit -m "🔭 Dashboard update (XR∞ pages sync)" || true
git push origin $PAGES_BRANCH
git checkout $CURRENT_BRANCH

echo "✅ Dashboard pubblicata su gh-pages"
