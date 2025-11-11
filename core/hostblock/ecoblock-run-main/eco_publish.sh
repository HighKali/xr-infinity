#!/bin/bash

# === EcoBlock GitHub Publisher ===
# Crea repo, collega, committa e pubblica

REPO_NAME="ecoblock-dashboard"
GITHUB_USER="HighKali"
GIT_EMAIL="xdsn.miner@gmail.com"
BRANCH="main"
COMMIT_MSG="EcoBlock Dashboard: $(date '+%Y-%m-%d %H:%M:%S')"

cd ~/ecoblock-dashboard || { echo "❌ Directory non trovata"; exit 1; }

echo "🔧 Configuro Git..."
git init
git config user.name "$GITHUB_USER"
git config user.email "$GIT_EMAIL"
git branch -m "$BRANCH"

echo "🌐 Creo repository su GitHub..."
gh repo create "$GITHUB_USER/$REPO_NAME" --public --source=. --remote=origin

echo "📦 Aggiungo file e commetto..."
git add .
git commit -m "$COMMIT_MSG"

echo "🚀 Push su GitHub..."
git push -u origin "$BRANCH"

echo "✅ Completato! Controlla su: https://github.com/$GITHUB_USER/$REPO_NAME"
