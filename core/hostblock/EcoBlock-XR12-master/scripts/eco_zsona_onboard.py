#!/usr/bin/env python3
import json, os
print("🪪 Onboarding collaboratore...")

badge = {
    "name": "Zapdos",
    "role": "Founder",
    "timestamp": os.popen("date +%Y%m%d_%H%M%S").read().strip()
}

with open("scripts/eco_light_guests.txt", "a") as f:
    f.write(json.dumps(badge) + "\n")

print(f"✅ Firma registrata: {badge['name']} @ {badge['timestamp']}")
