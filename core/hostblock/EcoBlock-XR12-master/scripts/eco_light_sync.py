#!/usr/bin/env python3
import json, time

with open("scripts/eco_light_log.json") as f:
    txs = json.load(f)

for tx in txs:
    tx["status"] = "confirmed"
    tx["confirmed_at"] = time.strftime("%Y-%m-%d %H:%M:%S")
    print(f"🔄 Confermato {tx[asset].upper()} → {tx[amount]} sats")

with open("scripts/eco_light_log.json", "w") as f:
    json.dump(txs, f, indent=2)

