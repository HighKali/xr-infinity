#!/usr/bin/env python3
from flask import Blueprint
core_panel = Blueprint("core", __name__)
@core_panel.route("/core")
def core_home():
    return """<html><head><title>EcoBlock XR12 Core</title>
    <style>
      body { background:#111; color:#fff; font-family:monospace; text-align:center; padding:30px; }
      .core { margin:20px auto; padding:20px; background:#222; border-radius:10px; width:80%; box-shadow:0 0 10px #0ff; }
      h1 { font-size:26px; color:#0ff; text-shadow:0 0 8px #0ff; }
      p { font-size:14px; color:#ccc; }
    </style></head><body>
    <h1>🧠 EcoBlock XR12 Core</h1>
    <div class="core">
      <p>Modulo di fusione blindata attivo.</p>
      <p>Wallet, Pool, Swap, Verify, Badge, Mappa, Log, UI — tutti integrati.</p>
    </div>
    <footer style="margin-top:40px; font-size:12px; color:#88ffff;">
      EcoBlock Core — XR12<br>© 2025
    </footer>
    </body></html>"""
