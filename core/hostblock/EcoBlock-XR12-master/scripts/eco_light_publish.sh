#!/bin/bash
echo "🚀 Pubblicazione EcoBlock Lightning Bridge..."

# 1. Crea ZIP blindato
ts=$(date +%Y%m%d_%H%M%S)
zipname="eco_light_release_$ts.zip"
zip -r $zipname . -x "*.venv*" "*.git*" "__pycache__/*" "*.DS_Store"
echo "✅ Archivio creato: $zipname"

# 2. Aggiorna README
echo "# EcoBlock Lightning Bridge" > README.md
echo "Versione: $ts" >> README.md
echo "- QR pubblico, tunnel, firma collaboratori" >> README.md
echo "- Moduli: receive, sync, panel, backup, contributors" >> README.md
echo "- ZIP: $zipname" >> README.md

# 3. Commit e push
git add .
git commit -m "🚀 Pubblicazione EcoBlock Lightning Bridge $ts"
git push

echo "✅ Pubblicazione completata."
