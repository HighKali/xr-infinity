#!/usr/bin/env python3
import os

modules = [
    "eco_light_bridge.py",
    "eco_light_receive.py",
    "eco_light_qr.py",
    "eco_light_tunnel.py",
    "eco_light_sync.py"
]

for m in modules:
    print(f"🧪 Test: {m}")
    code = os.system(f"python3 scripts/{m}")
    if code != 0:
        print(f"❌ Errore in {m}")
    else:
        print(f"✅ OK: {m}")

