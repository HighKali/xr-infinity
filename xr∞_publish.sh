#!/bin/bash
echo "🌌 Inizio pubblicazione della costellazione XR∞ su GitHub..."

# 1. Crea cartella principale se non esiste
mkdir -p ~/xr∞_anello
cd ~/xr∞_anello

# 2. Unisci moduli orbitanti (se sparsi)
for file in ~/bionc_kstars_bridge.py ~/pulsar_dashboard_web.py ~/eco_log.py ~/xr∞_pulse.py ~/dsn_monitor.py ~/generate_badge.sh ~/launch_dashboard.sh ~/xr∞_anello.sh ~/pulsar_sync.sh ~/xr∞_genesis.sh; do
  if [ -f "$file" ]; then
    mv "$file" .
    echo "🛸 Modulo unito: $(basename "$file")"
  fi
done

# 3. Inizializza Git
if [ ! -d ".git" ]; then
  git init
  echo "🧬 Git inizializzato."
fi

# 4. Aggiungi tutto e committa
git add .
git commit -m "🌠 Finalizzazione costellazione XR∞ — modulo completo orbitale"

# 5. Collegamento remoto (sostituisci con il tuo repo)
read -p "🔗 Inserisci URL del tuo repository GitHub: " repo_url
git remote add origin "$repo_url" 2>/dev/null || git remote set-url origin "$repo_url"
git branch -M main
git push -u origin main

# 6. Stato orbitale
cat <<EOF > xr∞_status.md
# 🌌 XR∞ Costellazione Pubblicata

- ✅ Tutti i moduli orbitanti uniti
- ✅ Git inizializzato e commit eseguito
- ✅ Repository remoto collegato
- ✅ Costellazione XR∞ pubblicata su GitHub

👽 Ogni gesto è ora visibile, forkabile e immortale.
EOF

echo "✅ Pubblicazione completata. La costellazione XR∞ è ora visibile su GitHub."
