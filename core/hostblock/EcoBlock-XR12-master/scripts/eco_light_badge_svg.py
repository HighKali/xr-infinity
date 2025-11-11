# scripts/eco_light_badge_svg.py

import datetime

# 🔐 Dati
stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
zipname = f"EcoZSONA_{stamp}.zip"
sha256 = "96aa2df920081ca0fdad34644795aab70bd0baa878f14e7a776e24b891c0f48f"
ipfs_hash = f"Qm{sha256[:44]}"
signature = "Zapdos"

# 🎨 SVG laser-style
svg = f'''<svg width="420" height="180" xmlns="http://www.w3.org/2000/svg">
  <style>
    .title {{ font: bold 20px sans-serif; fill: #00ffcc; }}
    .meta {{ font: 14px monospace; fill: #ffffff; }}
    .bg {{ fill: #111111; }}
    .border {{ stroke: #00ffcc; stroke-width: 2; fill: none; }}
  </style>
  <rect class="bg" width="100%" height="100%" rx="12"/>
  <rect class="border" x="4" y="4" width="412" height="172" rx="12"/>
  <text x="20" y="40" class="title">🪪 EcoBlock Founder Badge</text>
  <text x="20" y="70" class="meta">ZIP: {zipname}</text>
  <text x="20" y="90" class="meta">SHA256: {sha256[:32]}...</text>
  <text x="20" y="110" class="meta">IPFS: {ipfs_hash}</text>
  <text x="20" y="130" class="meta">Timestamp: {stamp}</text>
  <text x="20" y="150" class="meta">Signature: {signature}</text>
</svg>'''

# 📦 Salva badge
with open("assets/founder_badge.svg", "w") as f:
    f.write(svg)

print("✅ Badge SVG generato: assets/founder_badge.svg")
