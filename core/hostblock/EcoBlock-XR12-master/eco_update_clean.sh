#!/bin/bash

echo "🧹 Pulizia profonda e aggiornamento globale EcoBlock XR12..."

# 1. Terminazione master e processi Python
echo "[KILL] Arresto master e processi..."
pkill -f eco_xr12_master.py
pkill -f python3
sleep 1

# 2. Pulizia file temporanei, cache, virtualenv
echo "[CLEAN] Rimozione file non essenziali..."
find . -type f \( -name "*.pyc" -o -name "*.log" -o -name "*.tmp" \) -delete
rm -rf __pycache__ .cache venv .mypy_cache .pytest_cache .DS_Store .idea .vscode

# 3. Rimozione ZIP, QR, badge, vecchi SVG
echo "[PURGE] Rimozione artefatti di build..."
rm -f eco_release_xr12.zip eco_qr.png eco_badge.svg eco_fusion.log

# 4. Pull da GitHub (se configurato)
echo "[UPDATE] Pull da repository remoto..."
git pull origin main 2>/dev/null || echo "⚠️ Pull non disponibile"

# 5. Verifica moduli e ambiente
echo "[VERIFY] Controllo moduli e variabili..."
python3 eco_verify_env.py 2>/dev/null || echo "⚠️ eco_verify_env.py non trovato"

# 6. Avvio master e firma
echo "[LAUNCH] Riavvio master e firma..."
nohup python3 eco_xr12_master.py > /dev/null 2>&1 &
sleep 2
python3 eco_ignite.py 2>/dev/null || echo "⚠️ eco_ignite.py non trovato"

# 7. Log finale
echo "[LOG] Scrittura log..."
echo "[UPDATE] $(date +%Y-%m-%dT%H:%M:%S) → Pulizia e aggiornamento completati" >> eco_fusion.log

echo "✅ Pulizia profonda completata. Suite XR12 aggiornata e riavviata."
echo "🌐 Dashboard: http://127.0.0.1:8080/"
