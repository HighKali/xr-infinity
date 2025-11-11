#!/usr/bin/env python3
import json

dex_data = {
  "BTC": { "price": 0.000023, "volume": 12000, "status": "live" },
  "DOGE": { "price": 0.12, "volume": 8500, "status": "live" },
  "ZSONA": { "price": 0.0042, "volume": 42000, "status": "live" }
}

with open("scripts/eco_light_dex.json", "w") as f:
    json.dump(dex_data, f, indent=2)

print("✅ DEX mock generato: scripts/eco_light_dex.json")
