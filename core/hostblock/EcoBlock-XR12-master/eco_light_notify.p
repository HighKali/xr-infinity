# scripts/eco_light_notify.py

import json
from datetime import datetime

# Dati collaboratore
collaborator = {
    "name": "Zapdos",
    "role": "Founder",
    "timestamp": datetime.now().strftime("%Y%m%d_%H%M%S")
}

# URL Serveo (può essere aggiornato dinamicamente)
serveo_url = "https://e240364c235666defc5ded12adb5371f.serveo.net"

# Simulazione notifica
print("📤 Notifica inviata:")
print("⚡ EcoBlock LIVE")
print(f"🪪 {json.dumps(collaborator)}")
print(f"🌐 URL: {serveo_url}")
print(f"⏱️ {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
