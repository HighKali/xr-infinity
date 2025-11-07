#!/bin/bash
echo "🔁 Rigenerazione orbitale XR∞ in corso..."
python3 eco_log.py
python3 xr∞_pulse.py
bash pulsar_sync.sh
