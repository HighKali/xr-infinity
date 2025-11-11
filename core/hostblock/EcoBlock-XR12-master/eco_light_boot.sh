#!/bin/bash
echo "⚡ Avvio intelligente EcoBlock Lightning Bridge..."
OS=$(uname -o 2>/dev/null || uname -s)
echo "🧠 Sistema rilevato: $OS"

# 1. Installa dipendenze via pip
pip install qrcode[pil]

# 2. Imposta permessi
chmod +x scripts/*.py scripts/*.sh

# 3. Avvia aggiornamento globale
if [ -f scripts/eco_light_update_all.sh ]; then
  bash scripts/eco_light_update_all.sh
else
  echo "❌ Script eco_light_update_all.sh non trovato."
fi

# 4. Firma automatica collaboratore
echo "🪪 Inserisci il tuo nome o chiave pubblica:"
read name
python3 scripts/eco_light_sign.py "$name"

# 5. Mostra accesso pubblico
if [ -f scripts/eco_light_tunnel.json ]; then
  url=$(cat scripts/eco_light_tunnel.json | grep https | cut -d'"' -f4)
  echo "🌍 Accesso globale attivo: $url"
  echo "🖼️ QR disponibile in dashboard/assets/eco_light_tunnel_qr.png"
fi

echo "✅ Avvio completato. Apri dashboard/index.html per iniziare."
