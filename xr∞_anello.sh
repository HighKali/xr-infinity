#!/bin/bash
echo "🔁 Rigenerazione orbitale XR∞ in corso..."
python3 bionc_kstars_bridge.py
python3 pulsar_dashboard_web.py
