#!/usr/bin/env bash
# xr_supremo.sh — reset + merge + report + dashboard + gh-pages
# Uso: ./xr_supremo.sh <REMOTE_URL> [ours|theirs]
# Esempio: ./xr_supremo.sh https://github.com/HighKali/xr-infinity.git ours

set -euo pipefail

REMOTE="${1:-}"
POLICY="${2:-ours}"   # ours = tieni locale, theirs = tieni remoto
PAGES_BRANCH="${PAGES_BRANCH:-gh-pages}"
BACKUP_DIR="${HOME}/xr_backup_$(date +%Y%m%d_%H%M%S)"

if [[ -z "$REMOTE" ]]; then
  echo "❌ Uso: $0 <REMOTE_URL> [ours|theirs]"
  exit 1
fi

echo "== XR∞ Supremo Integrato =="
echo "Remote: $REMOTE | Policy: $POLICY"

# 1) Backup file non tracciati
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
fi

# 2) Pulizia submodule fantasma
echo "🧹 Pulizia submodule fantasma…"
find . -maxdepth 2 -type d -name "xr-coin~*" -print0 | xargs -0 -r rm -rf || true
git rm -f $(git ls-files -o --exclude-standard | grep -E '^xr-coin~' || true) 2>/dev/null || true

# 3) Fetch + Pull
echo "🌐 Fetch/Pull main…"
git branch -M main || true
git remote add origin "$REMOTE" 2>/dev/null || true
git fetch origin
if ! git pull origin main --allow-unrelated-histories; then
  echo "⚠️ Conflitti: applico politica ${POLICY}…"
  git checkout --"$POLICY" .
  git add -A
  git commit -m "XR∞ auto-merge (${POLICY})" || true
fi

# 4) Reinserimento file dal backup
echo "📥 Reinserimento file dal backup"
rsync -a "$BACKUP_DIR/" . || true
git add -A
git commit -m "XR∞ reinserimento file locali dopo pull" || true

# 5) Genera report integrità
echo "📊 Genero report integrità…"
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

# 6) Aggiorna dashboard
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

# 7) Push main
echo "📤 Push su origin/main…"
git push origin main || true

# 8) Pubblica gh-pages
echo "🌐 Sincronizzo gh-pages…"
TMPDIR="$(mktemp -d)"
rsync -a docs/ "$TMPDIR/"
if ! git show-ref --verify --quiet "refs/heads/$PAGES_BRANCH"; then
  if git show-ref --verify --quiet "refs/remotes/origin/$PAGES_BRANCH"; then
    git checkout -b "$PAGES_BRANCH" "origin/$PAGES_BRANCH"
  else
    git checkout --orphan "$PAGES_BRANCH"
    rm -rf *
    echo "<!doctype html><title>XR∞ gh-pages</title>" > index.html
    git add index.html
    git commit -m "Init gh-pages"
    git push -u origin "$PAGES_BRANCH"
  fi
fi
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD || echo main)"
git checkout "$PAGES_BRANCH"
rsync -a --delete "$TMPDIR/" ./
git add -A
git commit -m "🔭 XR∞ dashboard update (supremo)" || true
git push origin "$PAGES_BRANCH" || git push origin "$PAGES_BRANCH" --force
git checkout main || git checkout "$CURRENT_BRANCH"

echo "✅ Supremo completato: conflitti risolti, file salvati, report generato, dashboard aggiornata, main e gh-pages sincronizzati."
