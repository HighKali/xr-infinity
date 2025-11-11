#!/usr/bin/env bash
# xr_super.sh — Analisi, correzione, fusione HostBlock e avvio XR∞ con BOINC XML-RPC
# Uso: ./xr_super.sh [ZIP_OR_PATH] [PORT]
# Env opzionali:
#   HOSTBLOCK_ID="14-LocI-pArtVTVV-M77CVg6fuWj0Hypt"  # ID Google Drive per auto-download
#   HOSTBLOCK_PASS="password"                         # Password del file zip, se protetto
set -euo pipefail

ZIP="${1:-hostblock.zip}"
PORT="${2:-9090}"
PASS="${HOSTBLOCK_PASS:-}"

echo "== XR∞ Super — analisi + fusione + servizi + dashboard + deploy =="

# 0) Struttura base
mkdir -p core services data docs ops

# 1) Auto-download da Google Drive (se ZIP mancante ma ID presente)
if [[ ! -f "$ZIP" && -n "${HOSTBLOCK_ID:-}" ]]; then
  echo "🌐 Scarico da Google Drive: id=${HOSTBLOCK_ID} → $ZIP"
  python3 - <<PY || true
import os
from subprocess import run
url=f"https://drive.google.com/uc?id={os.environ.get('HOSTBLOCK_ID','')}"
run(["pip","install","-q","gdown"])
run(["gdown","--fuzzy",url,"-O",os.environ.get('ZIP','hostblock.zip')])
PY
fi

# 2) Analisi del file ZIP
if [[ -f "$ZIP" ]]; then
  echo "🔎 Verifico tipo file di '$ZIP'…"
  TYPE="$(file -b "$ZIP" || true)"
  echo "   Tipo: $TYPE"
  if echo "$TYPE" | grep -qiE 'HTML|ASCII text'; then
    echo "❌ '$ZIP' non è uno ZIP valido (sembra HTML). Scarica con gdown --fuzzy o usa HOSTBLOCK_ID."
    exit 1
  fi
else
  echo "⚠️ Archivio '$ZIP' non trovato. Procedo senza fusione HostBlock."
fi

# 3) Fusione HostBlock (supporto password)
if [[ -f "$ZIP" ]]; then
  echo "📦 Estraggo HostBlock in core/hostblock"
  rm -rf core/hostblock
  mkdir -p core/hostblock
  if [[ -n "$PASS" ]]; then
    echo "   Uso password (HOSTBLOCK_PASS impostata)."
    unzip -o -P "$PASS" "$ZIP" -d core/hostblock >/dev/null
  else
    unzip -o "$ZIP" -d core/hostblock >/dev/null
  fi
  # Normalizzazione permessi script
  find core/hostblock -type f -name "*.sh" -exec chmod +x {} \; || true
fi

# 4) Manifest SHA (solo file)
echo "🔐 Creo/aggiorno manifest SHA…"
cat > data/sha_manifest.json <<'JSON'
{ "hostblock": {} }
JSON
if [[ -d core/hostblock ]]; then
  while IFS= read -r -d '' f; do
    sha="$(sha256sum "$f" | awk '{print $1}')"
    tmp="$(mktemp)"
    jq --arg path "$f" --arg sha "$sha" '.hostblock[$path]=$sha' data/sha_manifest.json > "$tmp" && mv "$tmp" data/sha_manifest.json
  done < <(find core/hostblock -type f -print0)
fi

# 5) Script verifica SHA
cat > ops/verify_sha.sh <<'SH'
#!/usr/bin/env bash
set -euo pipefail
test -f data/sha_manifest.json || { echo "Manifest SHA assente."; exit 0; }
echo "Verifico SHA dai moduli…"
jq -r 'to_entries[] | .key as $mod | .value | to_entries[] | "\($mod) \(.key) \(.value)"' data/sha_manifest.json | \
while read -r mod path sha; do
  if test -f "$path"; then
    cur="$(sha256sum "$path" | awk '{print $1}')"
    [[ "$cur" == "$sha" ]] || echo "⚠️ Mismatch: $path ($mod)"
  else
    echo "⚠️ File mancante: $path ($mod)"
  fi
done
SH
chmod +x ops/verify_sha.sh

# 6) Servizi: BOINC bridge reale via XML-RPC
cat > services/boinc_bridge.py <<'PY'
#!/usr/bin/env python3
# boinc_bridge.py — integra BOINC via XML-RPC
import json, time, os
from xmlrpc.client import ServerProxy

STATE = "data/boinc_state.json"
os.makedirs("data", exist_ok=True)

# Configurazione: porta predefinita del client BOINC (31416)
BOINC_URL = "http://localhost:31416"

def safe(proxy_call, default=None):
    try:
        return proxy_call()
    except Exception:
        return default

while True:
    try:
        proxy = ServerProxy(BOINC_URL)
        info = safe(lambda: proxy.get_cc_status(), {}) or {}
        results = safe(lambda: proxy.get_results(), []) or []

        running = 0
        for r in results:
            # Alcuni client riportano chiavi diverse; gestisci entrambe
            if r.get("active_task") or r.get("task_state") == "EXECUTING":
                running += 1

        state = {
            "heartbeat": int(time.time()),
            "client_state": info.get("client_state", "unknown"),
            "tasks_running": running,
            "cpu_usage": info.get("cpu_usage", 0.0),
            "project": info.get("project_name", "BOINC")
        }
    except Exception as e:
        state = {
            "heartbeat": int(time.time()),
            "error": str(e),
            "tasks_running": 0,
            "cpu_usage": 0.0,
            "project": "BOINC (errore)"
        }

    with open(STATE, "w") as f:
        json.dump(state, f)
    time.sleep(10)
PY

# 7) Servizi: SETI ingest (mock minimale, sostituibile)
cat > services/seti_ingest.py <<'PY'
#!/usr/bin/env python3
import json, time, os
RESULTS="data/seti_results.json"
os.makedirs("data", exist_ok=True)
k=0
while True:
    k+=1
    sample={"seq":k,"status":"ok","power":42.0,"band":"L","ts":int(time.time())}
    with open(RESULTS,"w") as f: json.dump(sample,f)
    time.sleep(15)
PY

# 8) Servizi: Eco log
cat > services/eco_log.py <<'PY'
#!/usr/bin/env python3
import argparse, time, os
parser=argparse.ArgumentParser()
parser.add_argument("--event", required=True)
parser.add_argument("--tag", default="xr")
args=parser.parse_args()
os.makedirs("data", exist_ok=True)
with open("data/eco_events.log","a") as f:
    f.write(f"{time.strftime('%Y-%m-%dT%H:%M:%S')} {args.tag} {args.event}\n")
print("Logged.")
PY

chmod +x services/boinc_bridge.py services/seti_ingest.py services/eco_log.py

# 9) Dashboard minimale (se non presente)
if [[ ! -f docs/index.html ]]; then
cat > docs/index.html <<'HTML'
<!DOCTYPE html>
<html lang="it">
<meta charset="UTF-8" />
<title>XR∞ Costellazione — Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<body style="font-family:sans-serif;background:#0b0f1a;color:#e6e6e6;margin:2rem;">
<h1>XR∞ — Costellazione industriale, scientifica, mitica</h1>
<pre id="boinc">caricamento…</pre>
<pre id="seti">caricamento…</pre>
<pre id="eco">caricamento…</pre>
<script>
async function load(p,e){try{const r=await fetch(p+'?t='+Date.now());document.getElementById(e).textContent=await r.text();}catch(x){document.getElementById(e).textContent='Errore: '+x;}}
function refresh(){load('../data/boinc_state.json','boinc');load('../data/seti_results.json','seti');load('../data/eco_events.log','eco');}
refresh();setInterval(refresh,3000);
</script>
</body>
</html>
HTML
fi

# 10) Log di avvio + verifica integrità
python3 services/eco_log.py --event "XR∞ avvio — super fusione" --tag "anello" || true
bash ops/verify_sha.sh || true

# 11) Avvio servizi e server
echo "🚀 Avvio servizi e server su porta $PORT…"
nohup python3 services/boinc_bridge.py > data/boinc_bridge.log 2>&1 &
nohup python3 services/seti_ingest.py > data/seti_ingest.log 2>&1 &
nohup python3 -m http.server "$PORT" --directory docs > data/server.log 2>&1 &
echo "✅ Dashboard: http://localhost:$PORT/"

# 12) Deploy gh-pages (se repo)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -A
    git commit -m "🚀 XR∞ super fusione: HostBlock + servizi + dashboard (BOINC XML-RPC)"
  fi
  git push origin gh-pages || echo "ℹ️ Push rimandato (branch/permessi)."
else
  echo "ℹ️ Non sei in un repo Git: deploy saltato."
fi

echo "== Completato: Costellazione XR∞ operativa =="


