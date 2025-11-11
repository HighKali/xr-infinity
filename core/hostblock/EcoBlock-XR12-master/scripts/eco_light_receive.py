#!/usr/bin/env python3
import json

with open("scripts/eco_light_log.json") as f:
    txs = json.load(f)

for tx in txs:
    asset = tx.get("asset", "???")
    amount = tx.get("amount", "0")
    memo = tx.get("memo", "")
    print(f"✅ Ricevuto {asset.upper()} → {amount} sats | Memo: {memo}")
