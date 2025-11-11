# scripts/eco_zsona_badge_mint.py

import json, datetime

# 🔐 Dati badge
stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
zipname = f"EcoZSONA_{stamp}.zip"
sha256 = "96aa2df920081ca0fdad34644795aab70bd0baa878f14e7a776e24b891c0f48f"
ipfs_hash = f"Qm{sha256[:44]}"
signature = "Zapdos"
badge_svg = "assets/founder_badge.svg"

# 🪪 Metadata NFT
metadata = {
    "name": "EcoBlock Founder Badge",
    "description": "Badge SVG firmato per contributo fondativo su ZSONA chain",
    "image": ipfs_hash,
    "attributes": [
        {"trait_type": "ZIP", "value": zipname},
        {"trait_type": "SHA256", "value": sha256},
        {"trait_type": "Timestamp", "value": stamp},
        {"trait_type": "Signature", "value": signature}
    ]
}

# 📦 Salva metadata
with open("assets/founder_badge_metadata.json", "w") as f:
    json.dump(metadata, f, indent=2)

# 🧠 Log mint
with open("eco_log.py", "a") as f:
    f.write(f"# 🪪 Badge mintato: {zipname} | SHA256: {sha256} | IPFS: {ipfs_hash}\n")

print("✅ Badge NFT metadata generato: assets/founder_badge_metadata.json")
print("🌐 IPFS simulato:", ipfs_hash)
