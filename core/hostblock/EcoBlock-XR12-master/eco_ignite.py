#!/usr/bin/env python3
import hashlib, qrcode, os
from datetime import datetime

def print_banner():
    print("\n🟢 EcoBlock XR12 — FUSIONE COMPLETATA")
    print("═════════════════════════════════════")
    print("🌐 Repository: https://github.com/HighKali/EcoBlock-XR12")
    print("📦 Release: eco_release_xr12.zip")
    print("📅 Data: ", datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
    print("🏅 Badge: eco_badge.svg")
    print("🛰️  Mappa: eco_map.py")
    print("🧠 Master: eco_xr12_master.py\n")

def sha256sum(filename):
    h = hashlib.sha256()
    with open(filename, 'rb') as f:
        while chunk := f.read(8192):
            h.update(chunk)
    return h.hexdigest()

def generate_qr(text, filename):
    img = qrcode.make(text)
    img.save(filename)

def ignite():
    print_banner()
    zip_path = "eco_release_xr12.zip"
    if os.path.exists(zip_path):
        sha = sha256sum(zip_path)
        print(f"🔐 SHA256: {sha}")
        with open("eco_fusion.log", "a") as log:
            log.write(f"[IGNITE] SHA256: {sha}\n")
        generate_qr("https://github.com/HighKali/EcoBlock-XR12", "eco_qr.png")
        print("📎 QR salvato come eco_qr.png")
        print("✅ Firma completata. La suite è viva.")
    else:
        print("❌ ZIP non trovato. Esegui ./eco_publish.sh prima di firmare.")

if __name__ == "__main__":
    ignite()
