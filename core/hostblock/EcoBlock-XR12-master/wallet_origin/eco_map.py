#!/usr/bin/env python3
from flask import Blueprint
map_panel = Blueprint("map", __name__)
@map_panel.route("/map")
def map_home():
    return """<html><head><title>EcoBlock Mappa Orbitale</title>
    <style>
      body { background:#000; color:#0f0; font-family:monospace; text-align:center; padding:30px; }
      svg { width:80%; height:auto; margin-top:20px; }
    </style></head><body>
    <h1>🌍 Mappa Orbitale EcoBlock</h1>
    <svg viewBox="0 0 400 400">
      <circle cx="200" cy="200" r="180" stroke="#0f0" stroke-width="2" fill="none"/>
      <circle cx="200" cy="200" r="4" fill="#0f0"/>
      <text x="190" y="195" fill="#0f0" font-size="10">ZSONA</text>
      <circle cx="100" cy="100" r="3" fill="#0ff"/>
      <text x="90" y="95" fill="#0ff" font-size="10">Node A</text>
      <circle cx="300" cy="120" r="3" fill="#0ff"/>
      <text x="290" y="115" fill="#0ff" font-size="10">Node B</text>
    </svg>
    <footer style="margin-top:40px; font-size:12px; color:#88ff88;">
      EcoBlock Map — XR12<br>© 2025
    </footer>
    </body></html>"""
