# scripts/eco_light_notify.py

import json, datetime, requests

# 🔐 Dati firma
stamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
zipname = f"EcoZSONA_{stamp}.zip"
sha256 = "96aa2df920081ca0fdad34644795aab70bd0baa878f14e7a776e24b891c0f48f"  # Può essere passato dinamicamente
serveo_url = "https://e240364c235666defc5ded12adb5371f.serveo.net"
ipfs_hash = f"Qm{sha256[:44]}"

# 📤 Payload JSON
payload = {
    "status": "EcoZSONA Backup",
    "file": zipname,
    "sha256": sha256,
    "timestamp": stamp,
    "serveo": serveo_url,
    "ipfs": ipfs_hash,
    "badge": "EcoBlock Founder",
    "signature": "Zapdos"
}

# 🌐 Webhook Telegram (esempio)
telegram_url = "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage"
chat_id = "<YOUR_CHAT_ID>"

# 📤 Invio notifica
try:
    response = requests.post(telegram_url, json={
        "chat_id": chat_id,
        "text": json.dumps(payload, indent=2)
    })
    print("📤 Notifica Telegram inviata:", response.status_code)
except Exception as e:
    print("⚠️ Errore invio Telegram:", e)

# 🌐 Matrix (opzionale)
# matrix_url = "https://matrix.example.org/_matrix/client/r0/rooms/<room_id>/send/m.room.message"
# headers = {"Authorization": "Bearer <ACCESS_TOKEN>"}
# requests.post(matrix_url, headers=headers, json={"msgtype": "m.text", "body": json.dumps(payload)})
