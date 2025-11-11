#!/usr/bin/env python3
import datetime, requests
def sync_pulsar():
    pulsar = "PSR B0531+21"
    coords = "05h34m31.97s +22°00′52.1″"
    timestamp = datetime.datetime.utcnow().isoformat()
    payload = {"pulsar": pulsar, "coords": coords, "timestamp": timestamp}
    try:
        requests.post("http://127.0.0.1:5000/sync", json=payload)
        print("🔭 Pulsar sincronizzata:", pulsar)
    except Exception as e:
        print("⚠️ Errore:", e)
if __name__ == "__main__":
    sync_pulsar()
