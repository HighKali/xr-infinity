#!/usr/bin/env python3
import os

# Carica firme
guests = []
if os.path.exists("scripts/eco_light_guests.txt"):
    with open("scripts/eco_light_guests.txt") as f:
        guests = [line.strip() for line in f if line.strip() and not line.startswith("#")]

# Genera HTML
html = """<!DOCTYPE html>
<html><head><meta charset='UTF-8'><title>EcoBlock Contributors</title>
<link rel='stylesheet' href='../static/style.css'>
<style>
body { background:#000; color:#0ff; font-family:monospace; text-align:center }
.card { border:1px solid #0ff; border-radius:10px; padding:10px; margin:10px auto; width:80%; background:#111 }
img { margin-top:10px }
</style></head><body>
<h1>🪪 EcoBlock Contributors</h1>
<img src='assets/eco_light_badge.svg' width='300'>
"""

for guest in guests:
    name = guest.split("|")[-1].strip().replace(" ", "_")
    html += f"<div class='card'><h2>{guest}</h2>"
    html += f"<img src='assets/eco_guest_{name}.png' width='200'></div>\n"

html += "</body></html>"

with open("dashboard/eco_light_contributors.html", "w") as f:
    f.write(html)

print("✅ eco_light_contributors.html generato con firme e QR.")
