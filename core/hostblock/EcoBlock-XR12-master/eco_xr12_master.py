#!/usr/bin/env python3
from flask import Flask, render_template_string

# Importa tutti i Blueprint modulari
from eco_wallet_zsona_origin import wallet_bp
from eco_pool_zsona_dsn import pool_bp
from eco_swap_panel import swap_bp
from eco_wallet_verify import verify_bp
from eco_badge import badge_bp
from eco_map import map_bp
from eco_ui_fusion import ui_bp
from eco_xr12_core import fusion_bp
from eco_pool_register import register_bp
from eco_listing_push import listing_bp

app = Flask(__name__)
PORT = 8080

# Registrazione dei moduli RPC
app.register_blueprint(wallet_bp, url_prefix="/rpc/zsona/wallet")
app.register_blueprint(pool_bp, url_prefix="/rpc/zsona/pool")
app.register_blueprint(swap_bp, url_prefix="/rpc/zsona/swap")
app.register_blueprint(verify_bp, url_prefix="/rpc/zsona/verify")
app.register_blueprint(badge_bp, url_prefix="/rpc/zsona/badge")
app.register_blueprint(map_bp, url_prefix="/rpc/zsona/map")
app.register_blueprint(ui_bp, url_prefix="/rpc/zsona/ui")
app.register_blueprint(fusion_bp, url_prefix="/rpc/zsona/fusion")
app.register_blueprint(register_bp, url_prefix="/rpc/zsona/pool_register")
app.register_blueprint(listing_bp, url_prefix="/rpc/zsona/listing")

# Interfaccia LED principale
@app.route("/")
def home():
    return render_template_string("""
    <html>
    <head><title>EcoBlock XR12</title></head>
    <body style="background-color:black; color:#00FFAA; font-family:monospace; text-align:center;">
        <h1>🟢 EcoBlock XR12</h1>
        <p>Suite blindata attiva su porta {{port}}</p>
        <div style="margin-top:20px;">
            <a href="/rpc/zsona/wallet" style="color:#00FFAA;">🔗 Wallet</a> |
            <a href="/rpc/zsona/pool" style="color:#00FFAA;">🔗 Pool</a> |
            <a href="/rpc/zsona/swap" style="color:#00FFAA;">🔗 Swap</a> |
            <a href="/rpc/zsona/verify" style="color:#00FFAA;">🔗 Verify</a> |
            <a href="/rpc/zsona/badge" style="color:#00FFAA;">🔗 Badge</a> |
            <a href="/rpc/zsona/map" style="color:#00FFAA;">🔗 Map</a> |
            <a href="/rpc/zsona/ui" style="color:#00FFAA;">🔗 UI</a> |
            <a href="/rpc/zsona/fusion" style="color:#00FFAA;">🔥 Fusion</a>
        </div>
    </body>
    </html>
    """, port=PORT)

if __name__ == "__main__":
    print(f"[EcoBlock] 🚀 Avvio master su porta {PORT}")
    app.run(host="0.0.0.0", port=PORT)
