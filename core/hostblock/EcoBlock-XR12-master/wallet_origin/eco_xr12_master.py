#!/usr/bin/env python3
# {.EcoBlock} — EcoBlock Origin Suite XR12 Master Control Script

from flask import Flask, send_from_directory

# Importa moduli attivi
from eco_wallet_zsona_origin import wallet
from eco_pool_zsona_dsn import pool
from eco_swap_panel import swap
from eco_wallet_verify import verify
from eco_control_panel import control

# Importa moduli aggiuntivi
from eco_badge import badge_panel
from eco_map import map_panel
from eco_ui_fusion import fusion_panel
from eco_xr12_core import core_panel

# Inizializza Flask
app = Flask(__name__)
app.secret_key = "EcoBlockMasterKeyXR12"
PORT = 8081

# Registra blueprint attivi
app.register_blueprint(wallet)
app.register_blueprint(pool)
app.register_blueprint(swap)
app.register_blueprint(verify)
app.register_blueprint(control)
app.register_blueprint(badge_panel)
app.register_blueprint(map_panel)
app.register_blueprint(fusion_panel)
app.register_blueprint(core_panel)

# Route per log globale
@app.route("/log")
def log():
    return send_from_directory(".", "eco_fusion.log")

# Route per file statici
@app.route("/static/<path:filename>")
def static_files(filename):
    return send_from_directory("static", filename)

# Avvio server
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT, debug=False)
