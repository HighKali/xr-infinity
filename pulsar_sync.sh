#!/bin/bash
echo "🛸 Avvio sincronizzazione orbitale XR∞..."
for module in bionc_kstars_bridge.py pulsar_dashboard_web.py eco_log.py xr∞_pulse.py dsn_monitor.py generate_badge.sh launch_dashboard.sh; do
    if [ -f "$module" ]; then
        echo "👽 Lancio $module..."
        case "$module" in *.py) python3 "$module" ;; *.sh) bash "$module" ;; esac
    else
        echo "⚠️ Modulo mancante: $module"
    fi
done
echo "✅ Tutti i moduli orbitanti sono stati sincronizzati."
