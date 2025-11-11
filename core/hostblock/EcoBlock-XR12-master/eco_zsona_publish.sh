#!/bin/bash
echo "🚀 EcoZSONA Publish: pubblicazione blindata e verifica finale"

STAMP=$(date '+%Y%m%d_%H%M%S')
echo "🕒 Timestamp: $STAMP"

# 🔐 Firma collaboratore
echo "🪪 Firma: Zapdos" >> eco_light_contributors.py

# 📦 Backup ZIP blindato
echo "📦 Avvio eco_light_backup.py..."
python3 scripts/eco_light_backup.py "$STAMP"

# 🧠 Verifica asset critici
echo "🔍 Verifica asset..."
ASSETS=("assets/qr_zsona.png" "dashboard/assets/eco_light_qr_btc.png" "rackchain.html")
for file in "${ASSETS[@]}"; do
  if [ -f "$file" ]; then
    echo "✅ Trovato: $file"
  else
    echo "❌ Mancante: $file"
  fi
done

# 💡 LED DEX
if [ -f dex_led.log ]; then
  echo "💡 Stato DEX:"
  cat dex_led.log
else
  echo "🟡 dex_led.log non trovato"
fi

# 📜 Aggiorna README
echo "**Versione:** $STAMP" >> README.md
echo "**Collaboratori:** 🪪 $(grep -c "Firma:" eco_light_contributors.py)" >> README.md
echo "**Stato:** PUBBLICATO" >> README.md

# 🚀 GitHub (opzionale)
if [ -d .git ]; then
  echo "📤 Push su GitHub..."
  git add .
  git commit -m "🔐 EcoZSONA publish $STAMP"
  git push
else
  echo "⚠️ Git non inizializzato. Salta push."
fi

echo "✅ Pubblicazione completata con successo"
