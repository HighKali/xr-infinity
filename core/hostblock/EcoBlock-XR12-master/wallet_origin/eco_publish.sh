#!/bin/bash
echo "[EcoBlock] 📦 Packaging and Publishing..."

# Crea ZIP escluso cache, log, zip e script
zip -r eco_release_xr12.zip . -x "__pycache__/*" "*.log" "*.zip" "*.sh" "*.json"

echo "[EcoBlock] ✅ ZIP creato: eco_release_xr12.zip"
echo "[EcoBlock] 🚀 Push su GitHub..."

git add .
git commit -m "EcoBlock XR12 release"
git push

echo "[EcoBlock] 🏅 Badge minted and published." >> eco_fusion.log
echo "[EcoBlock] ✅ Pubblicazione completata."
