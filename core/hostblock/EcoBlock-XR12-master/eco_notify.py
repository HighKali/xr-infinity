#!/usr/bin/env python3
import requests
def notify():
    msg = "[EcoBlock] 🚀 Suite XR12 avviata con successo."
    try:
        requests.post("https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage", data={"chat_id":"<YOUR_CHAT_ID>", "text":msg})
        print("[EcoBlock] ✅ Notifica Telegram inviata.")
    except Exception as e:
        print("[EcoBlock] ⚠️ Errore notifica:", e)
if __name__ == "__main__":
    notify()
=======
404: Not Found
>>>>>>> 453b210ef45cdc9b7ddb9cbb66317564c2df92f9
