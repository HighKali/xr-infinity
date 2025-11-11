#!/bin/bash
echo "🔄 Avvio globale EcoBlock Lightning Bridge..."

python3 scripts/eco_light_receive.py
python3 scripts/eco_light_qr.py
python3 scripts/eco_light_tunnel.py
python3 scripts/eco_light_panel_live.py
python3 scripts/eco_light_log.py
python3 scripts/eco_light_backup.py
python3 scripts/eco_light_test.py
python3 scripts/eco_light_sync.py
python3 scripts/eco_light_onboard.py
python3 scripts/eco_light_contributors.py

echo "✅ Tutti i moduli aggiornati. Dashboard LIVE pronta."
