#!/usr/bin/env python3
from flask import Blueprint
fusion_panel = Blueprint("fusion", __name__)
@fusion_panel.route("/fusion")
def fusion_home():
    return """<html><head><title>EcoBlock UI Fusion</title>
    <style>
      body { background:#000; color:#0ff; font-family:monospace; text-align:center; padding:30px; }
      h1 { font-size:26px; color:#0ff; text-shadow:0 0 8px #0ff; }
      .fusion { margin:20px auto; padding:20px; background:#111; border-radius:10px; width:80%; box-shadow:0 0 10px #0ff; }
      a { display:block; margin:10px; padding:10px; background:#222; color:#fff; text-decoration:none; border-radius:6px; box-shadow:0 0 5px #0ff; }
      a:hover { background:#0ff; color:#000; }
    </style></head><body>
    <h1>🎨 EcoBlock Interfaccia Unificata</h1>
    <div class="fusion">
      <a href="/verify">🔐 SHA256</a>
      <a href="/badge">🏅 Badge Contributor</a>
      <a href="/map">🌍 Mappa Orbitale</a>
      <a href="/log">📜 Log Globale</a>
    </div>
    <footer style="margin-top:40px; font-size:12px; color:#88ffff;">
      EcoBlock Fusion UI — XR12<br>© 2025
    </footer>
    </body></html>"""
