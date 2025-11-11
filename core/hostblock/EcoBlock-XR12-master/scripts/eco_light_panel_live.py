#!/usr/bin/env python3
import json

with open("scripts/eco_light_tunnel.json") as f:
    data = json.load(f)

url = data["url"]
html = f"""<div class=card>
<h2>🟢 LIVE</h2>
<p><a href={url} target=_blank>{url}</a></p>
<img src=assets/eco_light_tunnel_qr.png width=200>
</div>"""

with open("dashboard/index.html", "r+") as f:
    content = f.read()
    f.seek(0)
    f.write(content.replace("</body>", html + "\n</body>"))
print("🟢 LIVE panel integrato nella dashboard.")

