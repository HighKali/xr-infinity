#!/bin/bash
echo "⚡ Avvio EcoZSONA Fusion Layer..."

python3 scripts/eco_zsona_onboard.py && \
python3 scripts/eco_light_tunnel.py && \
python3 scripts/eco_light_qr.py && \
python3 scripts/eco_zsona_miner.py && \
python3 scripts/eco_zsona_validator.py && \
python3 scripts/eco_light_sync.py && \
python3 scripts/eco_light_panel_live.py && \
cp dashboard/eco_zsona_map.html dashboard/index.html && \
bash scripts/eco_zsona_zip.sh && \
python3 scripts/eco_zsona_test_all.py && \
python3 scripts/eco_zsona_matrix_notify.py && \
bash scripts/eco_zsona_publish.sh

echo "✅ Sistema EcoZSONA completato. Tutti i moduli attivi, firmati e pubblicati."
