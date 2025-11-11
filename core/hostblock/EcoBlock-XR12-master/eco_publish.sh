echo "📦 Packaging e pubblicazione EcoBlock XR12..."

# 1. Definizione file e cartelle
ZIP="eco_release_xr12.zip"
BADGE="eco_badge.svg"
QR="eco_qr.png"
LOG="eco_fusion.log"
REPO="https://github.com/HighKali/EcoBlock-XR12"

# 2. Pulizia ZIP precedente
rm -f $ZIP

# 3. Creazione ZIP con moduli essenziali
echo "[ZIP] Creazione pacchetto..."
zip -r $ZIP \
eco_xr12_master.py \
eco_ignite.py \
eco_map.py \
eco_badge.py \
eco_ui_fusion.py \
eco_wallet_zsona_origin.py \
eco_pool_zsona_dsn.py \
eco_swap_panel.py \
eco_wallet_verify.py \
eco_fusion.log \
.env 2>/dev/null

# 4. Rigenerazione badge e QR
echo "[BADGE] Generazione badge SVG..."
python3 eco_badge.py 2>/dev/null || echo "⚠️ eco_badge.py non trovato"

echo "[QR] Generazione QR..."
python3 eco_qr_panel.py 2>/dev/null || echo "⚠️ eco_qr_panel.py non trovato"

# 5. Firma SHA256
echo "[SIGN] Calcolo SHA256..."
HASH=$(sha256sum $ZIP | cut -d ' ' -f1)

# 6. Push GitHub (se configurato)
echo "[GIT] Push su GitHub..."
git add $ZIP $BADGE $QR $LOG 2>/dev/null
git commit -m "🔒 Release XR12 firmata: $HASH" 2>/dev/null
git push origin main 2>/dev/null || echo "⚠️ Push non disponibile"

# 7. Log finale
echo "[PUBLISH] $(date +%Y-%m-%dT%H:%M:%S) → ZIP pubblicato con SHA256: $HASH" >> $LOG

# 8. Output finale
echo "✅ Rilascio completato."
echo "📦 ZIP: $ZIP"
echo "🏅 Badge: $BADGE"
echo "📎 QR: $QR"
echo "🔐 SHA256: $HASH"
echo "🌐 Repository: $REPO"
=======
404: Not Found
>>>>>>> 453b210ef45cdc9b7ddb9cbb66317564c2df92f9
