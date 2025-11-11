#!/usr/bin/env python3
import sys, time, qrcode

if len(sys.argv) < 2:
    print("❌ Uso: python3 eco_light_sign.py <nome_o_chiave>")
    exit(1)

name = sys.argv[1]
ts = time.strftime("%Y-%m-%d %H:%M:%S")
entry = f"{ts} | {name}"

with open("scripts/eco_light_guests.txt", "a") as f:
    f.write(entry + "\n")

img = qrcode.make(entry)
img.save(f"dashboard/assets/eco_guest_{name}.png")

print(f"✅ Firma registrata: {entry}")
print(f"🖼️ QR salvato: dashboard/assets/eco_guest_{name}.png")
