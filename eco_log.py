from datetime import datetime
def log_event(event):
    with open("eco_events.log", "a") as f:
        f.write(f"{datetime.now().isoformat()} — {event}\n")
