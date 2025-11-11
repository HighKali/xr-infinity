#!/bin/bash
echo "⚡ EcoZSONA Finalize: chiusura completa con firma, QR, ZIP e notifica"

# 🧠 Timestamp
STAMP=$(date '+%Y%m%d_%H%M%S')
echo "🕒 Timestamp: $STAMP"

# 🔐 Firma collaboratore
echo "🪪 Firma: Zapdos" >> eco_light_contributors.py

# 📦 Backup blindato
echo "📦 Avvio eco_light_backup.py..."
python3 scripts/eco_light_backup.py "$STAMP"

# 📡 Notifica Telegram/Matrix
echo "📡 Notifica globale..."
python3 scripts/eco_light_notify.py "EcoZSONA LIVE $STAMP"

# 🧠 Logging
echo "🧠 Logging in eco_log.py..."
echo "✅ Finalize completato: $STAMP" >> eco_log.py

# 🖼️ QR Serveo nella dashboard
if [ -f qr_serveo.png ]; then
  echo "🖼️ Integro QR nella dashboard..."
  cp qr_serveo.png assets/qr_zsona.png
  sed -i '/<!-- QR_PLACEHOLDER -->/a <img src="assets/qr_zsona.png" alt="QR ZSONA" width="180">' rackchain.html
else
  echo "⚠️ QR Serveo non trovato"
fi

# 📜 Firma README
echo "**Versione:** $STAMP" >> README.md
echo "**Collaboratori:** 🪪 $(grep -c "Firma:" eco_light_contributors.py)" >> README.md
echo "**Stato:** LIVE" >> README.md

echo "✅ EcoZSONA finalize completato con successo"
