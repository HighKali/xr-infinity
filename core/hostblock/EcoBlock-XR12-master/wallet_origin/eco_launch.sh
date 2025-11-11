#!/bin/bash
echo "[EcoBlock] 🚀 Avvio blindato in corso..."
python3 eco_port_check.py
python3 eco_notify.py
python3 eco_xr12_master.py >> eco_launch.log 2>&1 &
