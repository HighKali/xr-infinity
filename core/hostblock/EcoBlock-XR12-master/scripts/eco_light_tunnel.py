#!/usr/bin/env python3
import os, time, json, qrcode

# Avvia tunnel pubblico
print("🌐 Avvio tunnel globale...")
os.system("pkill ssh > /dev/null 2>&1")
stream = os.popen("ssh -o StrictHostKeyChecking=no -R 80:localhost:8000 nokey@localhost.run 2>/dev/null & sleep 3 && curl -s https://localhost.run")
url = stream.read().strip()

if not url.startswith("http"):
    print("❌ Tunnel fallito. Verifica connessione SSH o riprova.")
    exit(1)

# Salva info tunnel
data = {
    "url": url,
    "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
}
with open("scripts/eco_light_tunnel.json", "w") as f:
    json.dump(data, f, indent=2)

# Genera QR accesso globale
img = qrcode.make(url)
os.makedirs("dashboard/assets", exist_ok=True)
img.save("dashboard/assets/eco_light_tunnel_qr.png")

# Stampa info
print(f"✅ Accesso globale attivo: {url}")
print("🖼️ QR salvato in dashboard/assets/eco_light_tunnel_qr.png")

# Notifica (opzionale)
try:
    with open("scripts/eco_notify_config.json") as f:
        cfg = json.load(f)
    msg = f"🌍 EcoBlock Lightning Bridge attivo:\n{url}"
    if "telegram" in cfg:
        requests.post(f"https://api.telegram.org/bot{cfg[telegram][token]}/sendMessage",
                      data={"chat_id": cfg[telegram][chat_id], "text": msg})
    if "matrix" in cfg:
        requests.post(cfg["matrix"]["url"], json={"msgtype": "m.text", "body": msg},
                      headers={"Authorization": f"Bearer {cfg[matrix][token]}"})
    print("📡 Notifica inviata.")
except:
    print("⚠️ Notifica non configurata.")

