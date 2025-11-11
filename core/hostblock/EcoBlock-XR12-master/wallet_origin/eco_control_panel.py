from flask import Blueprint

control = Blueprint("control", __name__)

@control.route("/control")
def control_panel():
    return """<html><head><title>EcoBlock Control Panel</title>
    <style>
      body { background:#0d0d0d; color:#00ff99; font-family:monospace; text-align:center; padding:30px; }
      h1 { font-size:28px; color:#00ff99; text-shadow:0 0 8px #00ff99; }
      .panel { margin:20px auto; padding:20px; background:#111; border-radius:10px; width:80%; box-shadow:0 0 10px #00ff99; }
      a { display:block; margin:10px; padding:10px; background:#222; color:#fff; text-decoration:none; border-radius:6px; box-shadow:0 0 5px #00ff99; }
      a:hover { background:#00ff99; color:#000; }
    </style></head><body>
    <h1>🧭 EcoBlock Control Panel XR12</h1>
    <div class="panel">
      <a href='/'>💼 Wallet Origin</a>
      <a href='/pool'>🪙 Pool ZSONA/$DSN</a>
      <a href='/swap'>🔁 Swap Panel</a>
      <a href='/verify'>🔐 Verifica SHA256</a>
      <a href='/log'>📜 Log Globale</a>
    </div>
    <footer style='margin-top:40px; font-size:12px; color:#88ffff;'>
      EcoBlock Dapp — Made in Earth<br>© 2025
    </footer>
    </body></html>"""
