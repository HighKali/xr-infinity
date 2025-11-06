#!/usr/bin/env python3
from datetime import datetime

pulsar = {
    "name": "PSR B0531+21",
    "ra": "05h34m31.97s",
    "dec": "+22°00′52.1″",
    "period_ms": 33.0
}

def log_event(event):
    with open("eco_events.log", "a") as f:
        f.write(f"{datetime.now().isoformat()} — {event}\n")

def observe_pulsar(p):
    print(f"🔭 Pulsar osservata: {p['name']} @ {p['ra']} {p['dec']} — {p['period_ms']}ms")
    log_event(f"🌠 PULSAR OBSERVED — {p['name']} @ {p['ra']} {p['dec']} — {p['period_ms']}ms")

observe_pulsar(pulsar)
