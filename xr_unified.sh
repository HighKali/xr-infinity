#!/usr/bin/env bash
# xr_unified.sh — XR∞ update + services + dashboard + GitHub deploy + snapshot (senza Google)
# Uso: ./xr_unified.sh [ZIP_OR_PATH] [PORT]
# Richiede: .env con TG_TOKEN e TG_CHAT (opzionale ma consigliato)
set -euo pipefail

ZIP="${1:-hostblock.zip}"
PORT="${2:-9090}"

# Carica .env se presente (Telegram)
if [[ -f .env ]]; then
  set -a
  source .env
  set +a
fi

TG_TOKEN="${TG_TOKEN:-}"
TG_CHAT="${TG_CHAT:-}"

echo "== XR∞ Unified — fusione + servizi + dashboard + deploy + snapshot =="

# 0) Struttura base
mkdir -p core services data docs ops xr-coin logs

# 1) Analisi del file ZIP (solo locale)
if [[ -f "$ZIP" ]]; then
  echo "🔎 Verifico tipo file di '$ZIP'…"
  TYPE="$(file -b "$ZIP" || true)"
  echo "   Tipo: $TYPE"
  if echo "$TYPE" | grep -qiE 'HTML|ASCII text'; then
    echo "❌ '$ZIP' non è uno ZIP valido (sembra HTML). Usa un archivio ZIP locale corretto."
    exit 1
  fi
else
  echo "ℹ️ Archivio '$ZIP' non trovato. Procedo senza fusione HostBlock."
fi

# 2) Fusione HostBlock (solo locale, niente Google)
if [[ -f "$ZIP" ]]; then
  echo "📦 Estraggo HostBlock in core/hostblock"
  rm -rf core/hostblock
  mkdir -p core/hostblock
  unzip -o "$ZIP" -d core/hostblock >/dev/null
  find core/hostblock -type f -name "*.sh" -exec chmod +x {} \; || true
fi

# 3) Manifest SHA (solo file)
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

# 4) Verifica SHA utility
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

# 5) Servizi: BOINC via XML-RPC (reale)
cat > services/boinc_bridge.py <<'PY'
#!/usr/bin/env python3
import json, time, os
from xmlrpc.client import ServerProxy
STATE="data/boinc_state.json"
os.makedirs("data", exist_ok=True)
URL="http://localhost:31416"

def safe(call, default=None):
  try: return call()
  except Exception: return default

while True:
  try:
    p=ServerProxy(URL)
    info=safe(lambda: p.get_cc_status(),{}) or {}
    results=safe(lambda: p.get_results(),[]) or []
    running=sum(1 for r in results if r.get("active_task") or r.get("task_state")=="EXECUTING")
    state={
      "heartbeat": int(time.time()),
      "client_state": info.get("client_state","unknown"),
      "tasks_running": running,
      "cpu_usage": info.get("cpu_usage",0.0),
      "project": info.get("project_name","BOINC")
    }
  except Exception as e:
    state={"heartbeat": int(time.time()), "error": str(e), "tasks_running":0, "cpu_usage":0.0, "project":"BOINC (errore)"}
  with open(STATE,"w") as f: json.dump(state,f)
  time.sleep(10)
PY

# 6) Servizi: SETI ingest (mock sostituibile)
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

# 7) Servizi: Eco log
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

# 8) Miner XR∞ con chain persistente + eco log + notifiche Telegram
cat > services/xr_miner.py <<'PY'
#!/usr/bin/env python3
import json, time, os, hashlib, random, requests
STATE="data/xr_miner_state.json"
CHAIN="xr-coin/chain.json"
os.makedirs("data", exist_ok=True)
os.makedirs("xr-coin", exist_ok=True)

TG_TOKEN=os.environ.get("TG_TOKEN","")
TG_CHAT=os.environ.get("TG_CHAT","")

def notify(msg):
  if TG_TOKEN and TG_CHAT:
    try:
      requests.post(f"https://api.telegram.org/bot{TG_TOKEN}/sendMessage",
                    data={"chat_id":TG_CHAT,"text":msg}, timeout=5)
    except Exception:
      pass

def mine_block(prev_hash, data):
  nonce=0
  while True:
    h=hashlib.sha256(f"{prev_hash}{data}{nonce}".encode()).hexdigest()
    if h.startswith("0000"): return {"hash": h, "nonce": nonce, "data": data}
    nonce+=1

prev="genesis"
chain=[]
if os.path.exists(CHAIN):
  try:
    with open(CHAIN) as f: chain=json.load(f)
    if chain: prev=chain[-1]["hash"]
  except Exception:
    chain=[]

while True:
  payload={"ts": int(time.time()), "value": random.randint(1,100)}
  block=mine_block(prev, json.dumps(payload))
  prev=block["hash"]
  with open(STATE,"w") as f: json.dump(block,f)
  with open("data/eco_events.log","a") as log: log.write(f"{time.strftime('%Y-%m-%dT%H:%M:%S')} miner new_block {block['hash']}\n")
  chain.append(block)
  with open(CHAIN,"w") as f: json.dump(chain,f,indent=2)
  notify(f"Nuovo blocco XR∞Coin: {block['hash']}")
  time.sleep(20)
PY

chmod +x services/boinc_bridge.py services/seti_ingest.py services/eco_log.py services/xr_miner.py

# 9) Dashboard estesa (miner incluso)
cat > docs/index.html <<'HTML'
<!DOCTYPE html>
<html lang="it">
<meta charset="UTF-8" />
<title>XR∞ Costellazione — Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<body style="font-family:sans-serif;background:#0b0f1a;color:#e6e6e6;margin:2rem;">
<h1>XR∞ — Costellazione industriale, scientifica, mitica</h1>
<h3>BOINC</h3><pre id="boinc">caricamento…</pre>
<h3>SETI</h3><pre id="seti">caricamento…</pre>
<h3>Eco events</h3><pre id="eco">caricamento…</pre>
<h3>XR∞Coin miner (ultimo blocco)</h3><pre id="miner">caricamento…</pre>
<script>
async function load(p,e){try{const r=await fetch(p+'?t='+Date.now());document.getElementById(e).textContent=await r.text();}catch(x){document.getElementById(e).textContent='Errore: '+x;}}
function refresh(){
  load('../data/boinc_state.json','boinc');
  load('../data/seti_results.json','seti');
  load('../data/eco_events.log','eco');
  load('../data/xr_miner_state.json','miner');
}
refresh();setInterval(refresh,3000);
</script>
</body>
</html>
HTML

# 10) Log avvio + verifica integrità
python3 services/eco_log.py --event "XR∞ avvio — unified" --tag "anello" || true
bash ops/verify_sha.sh || true

# 11) Avvio servizi e server
echo "🚀 Avvio servizi e server su porta $PORT…"
nohup python3 services/boinc_bridge.py > logs/boinc_bridge.log 2>&1 &
nohup python3 services/seti_ingest.py > logs/seti_ingest.log 2>&1 &
nohup python3 services/xr_miner.py > logs/xr_miner.log 2>&1 &
nohup python3 -m http.server "$PORT" --directory docs > logs/server.log 2>&1 &
echo "✅ Dashboard: http://localhost:$PORT/"

# 12) Deploy GitHub (branch corrente + gh-pages se presente)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "📤 Deploy GitHub…"
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -A
    git commit -m "🚀 XR∞ unified: HostBlock+SHA+BOINC+SETI+Miner+Dashboard"
  fi
  git push || echo "ℹ️ Push branch corrente rimandato."

  BR_PAGES="${GIT_BRANCH_PAGES:-gh-pages}"
  if git show-ref --verify --quiet "refs/heads/$BR_PAGES"; then
    echo "🌐 Aggiorno $BR_PAGES con contenuti docs/"
    TMPDIR="$(mktemp -d)"
    rsync -a --delete docs/ "$TMPDIR/"
    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git checkout "$BR_PAGES"
    rsync -a --delete "$TMPDIR/" ./
    if [[ -n "$(git status --porcelain)" ]]; then
      git add -A
      git commit -m "🔭 Dashboard update (XR∞ unified)"
    fi
    git push origin "$BR_PAGES" || echo "ℹ️ Push $BR_PAGES rimandato."
    git checkout "$CURRENT_BRANCH"
  else
    echo "ℹ️ Branch $BR_PAGES non presente; salta pubblicazione pagine."
  fi
else
  echo "ℹ️ Non sei in un repo Git: deploy saltato."
fi

# 13) Snapshot automatico (tag + archivio + pagina gh-pages)
echo "📸 Creo snapshot con timestamp…"
TS="$(date +'%Y%m%d_%H%M%S')"
TAG="xr∞_snapshot_${TS}"
ARCHIVE="snapshot_${TS}.tar.gz"
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'no-repo')"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [[ -n "$(git status --porcelain)" ]]; then
    git add -A
    git commit -m "📸 Snapshot $TAG"
  fi
  git tag -a "$TAG" -m "XR∞ snapshot $TS"
  tar --exclude=".git" -czf "$ARCHIVE" .
  git push origin "$CURRENT_BRANCH" || true
  git push origin "$TAG" || true

  BR_PAGES="${GIT_BRANCH_PAGES:-gh-pages}"
  if git show-ref --verify --quiet "refs/heads/$BR_PAGES"; then
    TMPDIR="$(mktemp -d)"
    mkdir -p "$TMPDIR"
    cat > "$TMPDIR/index.html" <<HTML
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
    CURRENT_BRANCH_SAVE="$CURRENT_BRANCH"
    git checkout "$BR_PAGES"
    rsync -a --delete "$TMPDIR/" ./
    if [[ -n "$(git status --porcelain)" ]]; then
      git add -A
      git commit -m "📸 XR∞ snapshot page $TAG"
    fi
    git push origin "$BR_PAGES" || true
    git checkout "$CURRENT_BRANCH_SAVE"
  fi
fi

# 14) Notifica Telegram fine operazioni
if [[ -n "$TG_TOKEN" && -n "$TG_CHAT" ]]; then
  echo "📲 Invio notifica Telegram…"
  curl -s -X POST "https://api.telegram.org/bot${TG_TOKEN}/sendMessage" \
    -d chat_id="${TG_CHAT}" \
    -d text="XR∞: Unified update completato. Dashboard su http://localhost:${PORT} — Snapshot ${TAG}" >/dev/null || true
fi

echo "== Completato: XR∞ costellazione operativa, pubblicata e snapshot eseguito =="
