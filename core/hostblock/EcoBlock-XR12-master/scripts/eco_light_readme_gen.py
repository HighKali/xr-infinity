#!/usr/bin/env python3
import json, os
from datetime import datetime

ts = datetime.now().strftime("%Y%m%d_%H%M%S")
version = f"Versione {ts}"
collab = 0
if os.path.exists("scripts/eco_light_guests.txt"):
    with open("scripts/eco_light_guests.txt") as f:
        collab = len([x for x in f if x.strip() and not x.startswith("#")])

qr_path = "dashboard/assets/eco_light_tunnel_qr.png"
qr_line = f"![QR Tunnel]({qr_path})" if os.path.exists(qr_path) else "QR non disponibile"

readme = f"""# ⚡ EcoBlock Lightning Bridge

{qr_line}

**{version}**  
**Collaboratori 🪪 {collab}**  
**Aggiornato ⚡ Adesso**  
**Stato 🟡 LIVE**

## CHANGES:
- QR pubblico e tunnel LIVE
- Firma e pannello collaboratori
- Moduli: receive, sync, panel, backup, contributors
"""

with open("README.md", "w") as f:
    f.write(readme)

print("✅ README.md generato con badge, QR e changelog.")
