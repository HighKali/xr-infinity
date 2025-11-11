#!/usr/bin/env bash
# xr_reset.sh — backup automatico file non tracciati, pull, reinserimento, commit
set -euo pipefail

REMOTE="${1:-https://github.com/HighKali/xr-infinity.git}"
BACKUP_DIR="${HOME}/xr_backup_$(date +%Y%m%d_%H%M%S)"

echo "== XR∞ Reset =="

# 1) Backup di tutti i file non tracciati
echo "📦 Backup file non tracciati in $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
UNTRACKED=$(git ls-files --others --exclude-standard)
if [[ -n "$UNTRACKED" ]]; then
  echo "$UNTRACKED" | while read -r f; do
    if [[ -f "$f" ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$f")"
      mv "$f" "$BACKUP_DIR/$(dirname "$f")/"
      echo "🔒 Spostato $f"
    fi
  done
else
  echo "ℹ️ Nessun file non tracciato da salvare"
fi

# 2) Pull dal remoto
echo "🌐 Pull da $REMOTE"
git fetch origin
git pull origin main --allow-unrelated-histories || true

# 3) Reinserimento file dal backup
echo "📥 Reinserimento file dal backup"
rsync -a "$BACKUP_DIR/" . || true

# 4) Aggiunta e commit
git add -A
git commit -m "XR∞ reinserimento file locali dopo pull" || true

# 5) Push su remoto
git push origin main || true

echo "✅ Reset completato: file salvati, pull eseguito, reinseriti e sincronizzati."
