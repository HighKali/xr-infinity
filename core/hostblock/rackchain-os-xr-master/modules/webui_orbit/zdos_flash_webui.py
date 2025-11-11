#!/usr/bin/env python3
from flask import Flask, render_template_string, redirect, url_for
import subprocess

modules = {
    "⛏️ Mining": "zdos_minehub.py",
    "🛡️ Nodi Onion": "zdos_defender.py",
    "🔁 Swap": "zdos_swap.py",
    "🗳️ Governance": "zdos_governance_panel.py",
    "🏅 Badge": "zdos_certify.py",
    "🤖 AI": "zdos_ai.py",
    "🌉 Bridge": "zdos_bridge.py",
    "🔐 Vault": "eco_securevault.py",
    "📦 Publish": "zdos_publish.py",
    "🧠 Dashboard": "zdos_dashboard_termux.py",
    "♾️ Immortal": "zdos_flash_immortal.py",
    "🪶 Poesia": "zdos_flash_verse.py",
    "📡 Matrix": "zdos_matrix_notify.py",
    "🌐 Coscienza di rete": "zdos_flash_netinfo.py"
}

app = Flask(__name__)

HTML = """
<!DOCTYPE html>
<html>
<head>
  <title>RACKCHAIN OS XR∞</title>
  <style>
    body { background: #111; color: #0f0; font-family: monospace; text-align: center; }
    button { margin: 10px; padding: 10px 20px; background: #0f0; color: #000; border: none; font-weight: bold; }
  </style>
</head>
<body>
  <h1>🧠 RACKCHAIN OS XR∞</h1>
  {% for name, script in modules.items() %}
    <form action="/run/{{ script }}" method="post">
      <button>{{ name }}</button>
    </form>
  {% endfor %}
</body>
</html>
"""

@app.route("/")
def index():
    return render_template_string(HTML, modules=modules)

@app.route("/run/<script>", methods=["POST"])
def run_script(script):
    try:
        subprocess.Popen(["python3", f"{script}"])
        return redirect(url_for("index"))
    except Exception as e:
        return f"❌ Errore: {e}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8585)
