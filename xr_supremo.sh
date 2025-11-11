#!/usr/bin/env bash
# xr_supremo.sh — pulizia, auto-merge, report, dashboard, sync main + gh-pages
# Uso: ./xr_supremo.sh <REMOTE_URL> [ours|theirs]
# Esempio: ./xr_supremo.sh https://github.com/HighKali/xr-infinity.git ours

set -euo pipefail

REMOTE="${1:-}"
POLICY="${2:-ours}"   # ours = tieni locale, theirs = tieni remoto
PAGES_BRANCH="${PAGES_BRANCH:-gh-pages}"

if [[ -z "$REMOTE" ]]; then
  echo "❌ Uso: $0 <REMOTE_URL> [ours|theirs]"
  exit 1
fi
if [[ "$POLICY" != "ours" && "$POLICY" != "theirs" ]]; then
  echo "❌ Politica conflitti non valida: $POLICY (usa ours|theirs)"
  exit 1
fi

echo "== XR∞ Supremo =="
echo "Remote: $REMOTE | Policy: $POLICY"

# 0) Base Git setup
git config pull.rebase false || true
git config advice.defaultBranchName false || true
git branch -M main || true
git remote add origin "$REMOTE" 2>/dev/null || true

# 1) Pulizia residui/submodule fantasma (xr-coin~*)
echo "🧹 Pulizia submodule fantasma…"
find . -maxdepth 2 -type d -name "xr-coin~*" -print0 | xargs -0 -r rm -rf || true
git rm -f $(git ls-files -o --exclude-standard | grep -E '^xr-coin~' || true) 2>/dev/null || true

# 2) Stash temporaneo delle modifiche non in merge (per evitare blocchi di checkout)
echo "📦 Stash temporaneo (non conflitti)…"
git stash push -u -m "xr_supremo auto-stash" || true

# 3) Fetch + Pull con storie non correlate
echo "🌐 Fetch/Pull main…"
git fetch origin || true
if ! git pull origin main --allow-unrelated-histories; then
  echo "⚠️ Conflitti rilevati: applico politica ${POLICY}…"
  if [[ "$POLICY" == "ours" ]]; then
    git checkout --ours .
  else
    git checkout --theirs .
  fi
  # Rimuovi eventuali submodule ghost che bloccano add/commit
  find . -maxdepth 2 -type d -name "xr-coin~*" -print0 | xargs -0 -r rm -rf || true
  git add -A
  git commit -m "XR∞ auto-merge (${POLICY})"
fi

# 4) Applica la politica ai file noti in conflitto (idempotente)
echo "🧭 Normalizzo conflitti noti (data, services, log)…"
FILES_CONFLITTO=(
  "data/eco_events.log"
  "eco_events.log"
  "services/boinc_bridge.py"
  "services/eco_log.py"
  "services/seti_ingest.py"
)
for f in "${FILES_CONFLITTO[@]}"; do
  if git ls-files --unmerged "$f" >/dev/null 2>&1; then
    if [[ "$POLICY" == "ours" ]]; then
      git checkout --ours "$f" || true
    else
      git checkout --theirs "$f" || true
    fi
    git add "$f" || true
  fi
done

# 5) Ripristina file cancellati se la policy è "ours"
echo "🗃️ Ripristino file cancellati (policy ours)…"
if [[ "$POLICY" == "ours" ]]; then
  git restore --staged . || true
  git restore . || true
fi

# 6) Commit finale risoluzione (se necessario)
if [[ -n "$(git status --porcelain)" ]]; then
  git add -A
  git commit -m "XR∞ risoluzione conflitti finale (${POLICY})"
fi

# 7) Ripristina stash e committa se riporta modifiche utili
echo "📦 Ripristino stash (se presente)…"
if git stash list | grep -q "xr_supremo auto-stash"; then
  git stash pop || true
  # Se pop genera conflitti, riapplica la stessa policy
  if [[ -n "$(git status --porcelain)" ]]; then
    if [[ "$POLICY" == "ours" ]]; then
      git checkout --ours .
    else
      git checkout --theirs .
    fi
    git add -A
    git commit -m "XR∞ integrazione stash (${POLICY})"
  fi
fi

# 8) Genera report integrità
echo "📊 Genero report (SHA256, duplicati)…"
mkdir -p data docs
cat > xr_report.py <<'PY'
import os, hashlib, json
def sha256sum(path):
    h = hashlib.sha256()
    with open(path,'rb') as f:
        for chunk in iter(lambda: f.read(8192), b''):
            h.update(chunk)
    return h.hexdigest()
files, errors = [], []
for root, dirs, fs in os.walk('.'):
    if '.git' in root: continue
    for name in fs:
        p = os.path.join(root, name)
        try:
            d = sha256sum(p)
            files.append({"path": p, "sha256": d})
        except Exception as e:
            errors.append({"path": p, "error": str(e)})
seen = {}
duplicates = []
for f in files:
    d = f["sha256"]
    if d in seen: duplicates.append([seen[d], f["path"]])
    else: seen[d] = f["path"]
report = {"files": files, "duplicates": duplicates, "errors": errors}
os.makedirs("data", exist_ok=True)
with open("data/report.json","w") as out:
    json.dump(report, out, indent=2)
print("✅ Report in data/report.json")
PY
python3 xr_report.py || true

# 9) Dashboard aggiornata con feed live
echo "🖥️ Aggiorno dashboard docs/index.html…"
cat > docs/index.html <<'HTML'
<!DOCTYPE html>
<html lang="it">
<meta charset="UTF-8" />
<title>XR∞ Dashboard</title>
<body style="font-family:sans-serif;background:#0b0f1a;color:#e6e6e6;margin:2rem;">
<h1>XR∞ — Dashboard</h1>
<h3>BOINC</h3><pre id="boinc">caricamento…</pre>
<h3>SETI</h3><pre id="seti">caricamento…</pre>
<h3>Eco events</h3><pre id="eco">caricamento…</pre>
<h3>XR∞Coin miner</h3><pre id="miner">caricamento…</pre>
<h3>Report integrità</h3><pre id="report">caricamento…</pre>
<script>
async function load(p,e){try{
  const r=await fetch('../data/'+p+'?t='+Date.now());
  document.getElementById(e).textContent=await r.text();
}catch(x){document.getElementById(e).textContent='Errore: '+x;}}
function refresh(){
  load('boinc_state.json','boinc');
  load('seti_results.json','seti');
  load('eco_events.log','eco');
  load('xr_miner_state.json','miner');
  load('report.json','report');
}
refresh(); setInterval(refresh, 3000);
</script>
</body>
</html>
HTML

git add docs/index.html data/report.json
git commit -m "XR∞ dashboard + report integrità" || true

# 10) Push su main
echo "📤 Push su origin/main…"
git push origin main || true

# 11) Pubblicazione gh-pages (crea se manca)
echo "🌐 Sincronizzo gh-pages…"
# Materiale da pubblic
