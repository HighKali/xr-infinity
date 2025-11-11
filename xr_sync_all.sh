#!/usr/bin/env bash
# xr_sync_all.sh — Repo init + fetch + pull (merge) + auto-resolve + push + gh-pages + snapshot
# Uso: ./xr_sync_all.sh <REMOTE_URL>
# Env opzionali:
#   RUN_UNIFIED=yes            # esegue ./xr_unified.sh hostblock.zip 9090 prima della sincronizzazione
#   RESOLVE_POLICY=ours|theirs # risoluzione conflitti automatica (default: ours)
#   PAGES_BRANCH=gh-pages      # branch delle pagine (default: gh-pages)
#   TG_TOKEN=... TG_CHAT=...   # Telegram: notifica finale
set -euo pipefail

REMOTE_URL="${1:-}"
if [[ -z "$REMOTE_URL" ]]; then
  echo "❌ Specifica il REMOTE_URL. Esempio: ./xr_sync_all.sh https://github.com/HighKali/xr-infinity.git"
  exit 1
fi

RESOLVE_POLICY="${RESOLVE_POLICY:-ours}"
PAGES_BRANCH="${PAGES_BRANCH:-gh-pages}"

# Carica .env se presente (Telegram)
if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi
TG_TOKEN="${TG_TOKEN:-}"
TG_CHAT="${TG_CHAT:-}"

echo "== XR∞ Sync All — init + merge + resolve + push + pages + snapshot =="

# 0) Repo init (se necessario)
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "🧱 Inizializzo repo Git…"
  git init
  git branch -m main || true
  git remote add origin "$REMOTE_URL"
fi

# 1) Config base pull (merge)
git config pull.rebase false || true
git config advice.defaultBranchName false || true

# 2) Esegui aggiornamento locale (opzionale)
if [[ "${RUN_UNIFIED:-no}" == "yes" ]]; then
  if [[ -x ./xr_unified.sh ]]; then
    echo "🔧 Eseguo xr_unified.sh (pre-sync)…"
    ./xr_unified.sh hostblock.zip 9090 || true
  else
    echo "ℹ️ RUN_UNIFIED=yes ma xr_unified.sh non trovato o non eseguibile."
  fi
fi

# 3) Commit locale se ci sono modifiche
if [[ -n "$(git status --porcelain)" ]]; then
  echo "📝 Commit locale pre-sync…"
  git add -A
  git commit -m "XR∞ pre-sync update"
fi

# 4) Fetch remoto
echo "🌐 Fetch origin…"
git fetch origin

# 5) Imposta upstream per main se necessario
if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
  echo "🔗 Imposto upstream main → origin/main…"
  git branch -u origin/main main || true
fi

# 6) Pull con merge tra storie non correlate
echo "🔀 Pull merge da origin/main (allow-unrelated-histories)…"
if ! git pull origin main --allow-unrelated-histories; then
  echo "⚠️ Conflitti rilevati: applico politica ${RESOLVE_POLICY}…"
  case "$RESOLVE_POLICY" in
    ours)
      git checkout --ours .
      ;;
    theirs)
      git checkout --theirs .
      ;;
    *)
      echo "❌ Politica RESOLVE_POLICY non valida: $RESOLVE_POLICY (usa ours|theirs)"
      exit 1
      ;;
  esac
  git add -A
  git commit -m "XR∞ auto-merge (${RESOLVE_POLICY})"
fi

# 7) Push su main
echo "📤 Push su origin/main…"
git push origin main

# 8) Pubblicazione gh-pages (se branch esiste)
if git show-ref --verify --quiet "refs/remotes/origin/$PAGES_BRANCH"; then
  echo "🌐 Pubblico dashboard/snapshot su $PAGES_BRANCH…"
  TMPDIR="$(mktemp -d)"
  mkdir -p "$TMPDIR"
  # Se c'è docs, pubblica docs/; altrimenti crea un index minimale
  if [[ -d docs ]]; then
    rsync -a --delete docs/ "$TMPDIR/"
  else
    echo "<!doctype html><title>XR∞ gh-pages</title><body>XR∞ pages</body>" > "$TMPDIR/index.html"
  fi
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  git checkout "$PAGES_BRANCH" || git checkout -b "$PAGES_BRANCH"
  rsync -a --delete "$TMPDIR/" ./
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -A
    git commit -m "🔭 XR∞ pages update"
  fi
  git push origin "$PAGES_BRANCH" || echo "ℹ️ Push $PAGES_BRANCH rimandato."
  git checkout "$CURRENT_BRANCH"
else
  echo "ℹ️ Branch remoto $PAGES_BRANCH non presente; salto pubblicazione pagine."
fi

# 9) Snapshot: tag + archivio + pagina su gh-pages (se esiste)
echo "📸 Creo snapshot…"
TS="$(date +'%Y%m%d_%H%M%S')"
TAG="xr∞_snapshot_${TS}"
ARCHIVE="snapshot_${TS}.tar.gz"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

# Commit stato attuale se modifiche
if [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  git commit -m "📸 Snapshot $TAG (pre)"
fi

git tag -a "$TAG" -m "XR∞ snapshot $TS"
tar --exclude=".git" -czf "$ARCHIVE" .
git push origin "$CURRENT_BRANCH" || true
git push origin "$TAG" || true

# Pubblica pagina snapshot se $PAGES_BRANCH esiste localmente
if git show-ref --verify --quiet "refs/heads/$PAGES_BRANCH"; then
  echo "🌐 Aggiorno $PAGES_BRANCH con pagina snapshot…"
  TMPDIR2="$(mktemp -d)"
  mkdir -p "$TMPDIR2"
  cat > "$TMPDIR2/index.html" <<HTML
<!DOCTYPE html>
<html lang="it"><meta charset="UTF-8" />
<title>XR∞ Snapshot $TS</title>
<body style="font-family:sans-serif;background:#0b0f1a;color:#e6e6e6;margin:2rem;">
<h1>XR∞ Snapshot — $TS</h1>
<ul>
  <li>Tag: <code>$TAG</code></li>
  <li>Archivio: <code>$ARCHIVE</code></li>
  <li>Branch: <code>$CURRENT_BRANCH</code></li>
</ul>
<p>Ultimi eventi:</p>
<pre>
$(tail -n 50 data/eco_events.log 2>/dev/null || echo "Nessun eco log")
</pre>
</body></html>
HTML
  SAVE_BRANCH="$CURRENT_BRANCH"
  git checkout "$PAGES_BRANCH"
  rsync -a --delete "$TMPDIR2/" ./
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -A
    git commit -m "📸 XR∞ snapshot page $TAG"
  fi
  git push origin "$PAGES_BRANCH" || true
  git checkout "$SAVE_BRANCH"
else
  echo "ℹ️ Branch locale $PAGES_BRANCH non presente; snapshot page non pubblicata."
fi

# 10) Notifica Telegram finale (opzionale)
if [[ -n "$TG_TOKEN" && -n "$TG_CHAT" ]]; then
  echo "📲 Invio notifica Telegram…"
  curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
    -d chat_id="${TG_CHAT}" \
    -d text="XR∞: Sync & Snapshot completati. Tag ${TAG} su ${CURRENT_BRANCH}" >/dev/null || true
fi

echo "✅ Completato: sync remoto, push main, pages aggiornate, snapshot creato."
