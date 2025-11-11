#!/usr/bin/env bash
# xr_dashboard_sync.sh — risolve conflitti, aggiorna dashboard, crea gh-pages e sincronizza
set -euo pipefail

REMOTE="${1:-https://github.com/HighKali/xr-infinity.git}"
PAGES_BRANCH="${PAGES_BRANCH:-gh-pages}"

echo "== XR∞ Dashboard Sync =="

# 1) Risolvi conflitti locali con politica ours
if [[ -n "$(git status --porcelain)" ]]; then
  echo "🔀 Risolvo conflitti con politica ours…"
  git checkout --ours .
  git add -A
  git commit -m "XR∞ auto-merge ours (dashboard sync)" || true
fi

# 2) Assicurati che il branch main sia collegato
git branch -M main
git remote add origin "$REMOTE" 2>/dev/null || true
git fetch origin
git pull origin main --allow-unrelated-histories || true

# 3) Aggiorna dashboard con report
mkdir -p docs
cat > docs/index.html <<'HTML'
<!DOCTYPE html>
<html lang="it">
<meta charset="UTF-8" />
<title>XR∞ Dashboard</title>
<body style="font-family:sans-serif;background:#0b0f1a;color:#e6e6e6;margin:2rem;">
<h1>XR∞ — Costellazione industriale, scientifica, mitica</h1>
<h3>BOINC</h3><pre id="boinc">caricamento…</pre>
<h3>SETI</h3><pre id="seti">caricamento…</pre>
<h3>Eco events</h3><pre id="eco">caricamento…</pre>
<h3>XR∞Coin miner</h3><pre id="miner">caricamento…</pre>
<h3>Report integrità</h3><pre id="report">caricamento…</pre>
<script>
async function load(p,e){try{const r=await fetch('../data/'+p+'?t='+Date.now());document.getElementById(e).textContent=await r.text();}catch(x){document.getElementById(e).textContent='Errore: '+x;}}
function refresh(){
  load('boinc_state.json','boinc');
  load('seti_results.json','seti');
  load('eco_events.log','eco');
  load('xr_miner_state.json','miner');
  load('report.json','report');
}
refresh();setInterval(refresh,3000);
</script>
</body>
</html>
HTML

git add docs/index.html
git commit -m "Aggiornamento dashboard XR∞ con report" || true
git push origin main

# 4) Gestione gh-pages
if git show-ref --verify --quiet "refs/heads/$PAGES_BRANCH"; then
  echo "🌐 Aggiorno branch $PAGES_BRANCH…"
else
  echo "🌐 Creo branch $PAGES_BRANCH…"
  git checkout --orphan $PAGES_BRANCH
  rm -rf *
  echo "<!doctype html><title>XR∞ gh-pages</title>" > index.html
  git add index.html
  git commit -m "Init gh-pages"
  git push -u origin $PAGES_BRANCH
  git checkout main
fi

# 5) Copia dashboard su gh-pages
TMPDIR="$(mktemp -d)"
rsync -a docs/ "$TMPDIR/"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git checkout $PAGES_BRANCH
rsync -a --delete "$TMPDIR/" ./
git add -A
git commit -m "🔭 Dashboard update (XR∞ sync)" || true
git push origin $PAGES_BRANCH
git checkout $CURRENT_BRANCH

echo "✅ Dashboard aggiornata e pubblicata su gh-pages"
