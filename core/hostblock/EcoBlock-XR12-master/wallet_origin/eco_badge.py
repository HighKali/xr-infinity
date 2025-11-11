#!/usr/bin/env python3
from flask import Blueprint
badge_panel = Blueprint("badge", __name__)
@badge_panel.route("/badge")
def badge_home():
    return """<html><head><title>EcoBlock Badge</title>
    <style>
      body { background:#000; color:#ff0; font-family:monospace; text-align:center; padding:30px; }
      svg { width:200px; height:auto; margin-top:20px; }
    </style></head><body>
    <h1>🏅 Badge Contributor</h1>
    <svg viewBox="0 0 200 200">
      <circle cx="100" cy="100" r="80" stroke="#ff0" stroke-width="4" fill="black"/>
      <text x="50" y="110" fill="#ff0" font-size="18">EcoBlock</text>
      <text x="60" y="130" fill="#ff0" font-size="12">Contributor</text>
    </svg>
    <footer style="margin-top:40px; font-size:12px; color:#ffff88;">
      EcoBlock Badge — XR12<br>© 2025
    </footer>
    </body></html>"""
