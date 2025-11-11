#!/usr/bin/env bash
# xr_fix_mini.sh — Risolutore rapido conflitti XR∞
# Uso: ./xr_fix_mini.sh [ours|theirs]
# Default: ours (mantiene la versione locale)

set -euo pipefail

STRATEGY="${1:-ours}"

echo "== XR∞ Mini Fixer =="
echo "Strategia: ${STRATEGY}"

# 1) Risolvi tutti i conflitti con la strategia scelta
if [[ "$STRATEGY" == "ours" ]]; then
  git checkout --ours -- .
else
  git checkout --theirs -- .
fi

# 2) Aggiungi tutti i file risolti
git add -A

# 3) Commit di risoluzione
git commit -m "🔧 Risoluzione rapida conflitti (${STRATEGY})"

# 4) Se c'è un rebase in corso, continua
if test -d .git/rebase-merge || test -d .git/rebase-apply; then
  git rebase --continue || true
fi

# 5) Push finale con fallback
if ! git push origin gh-pages; then
  git push origin gh-pages --force-with-lease
fi

echo "== Completato =="
