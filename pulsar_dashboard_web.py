#!/usr/bin/env python3
from flask import Flask, render_template_string, send_file
import os

app = Flask(__name__)
LOG_FILE = "eco_events.log"
BADGE_FILE = "pulsar_badge.svg"

HTML = """
<!DOCTYPE html>
<html>
<head>
  <title>XR∞ — Dashboard orbitale unificata</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    :root { --bg:#000; --fg:#00FF00; }
    * { box-sizing: border-box; }
    body {
      margin:0; padding:16px; background:var(--bg); color:var(--fg);
      font-family: monospace;
      background-image: radial-gradient(circle at 20% 20%, #001010, #000000 60%);
    }
    .grid {
      display: grid; grid-template-columns: 1fr; gap: 16px;
    }
    @media(min-width:900px) { .grid { grid-template-columns: 1.1fr 0.9fr; } }
    .card {
      border:2px solid var(--fg); border-radius:12px; padding:16px;
      background: rgba(0, 15, 15, 0.6);
      box-shadow: 0 0 12px rgba(0,255,0,0.15);
    }
    h1,h2 { margin:0 0 12px 0; }
    .title { text-align:center; margin-bottom:12px; }
    .blink { animation: blink 1.2s infinite; display:inline-block; }
    @keyframes blink { 50% { opacity: .25; } }
    .mono { white-space: pre-wrap; line-height:1.4; }
    .row { display:flex; gap:12px; align-items:center; flex-wrap: wrap; }
    .btn {
      color:var(--fg); border:1px solid var(--fg); padding:6px 10px;
      border-radius:8px; background: transparent; cursor: pointer;
    }
    iframe { width:100%; height:340px; border:1px solid var(--fg); border-radius:10px; }
    .footer { text-align:center; opacity:.8; font-size:12px; margin-top:8px; }
  </style>
  <script>
    async function pulseOnce(){
      await fetch('/pulse',{method:'POST'});
      location.reload();
    }
    async function observe(){
      await fetch('/observe',{method:'POST'});
      location.reload();
    }
    async function clearLog(){
      await fetch('/clear',{method:'POST'});
      location.reload();
    }
  </script>
</head>
<body>
  <div class="title">
    <h1>🛸 XR∞ Dashboard Orbitale Unificata <span class="blink">👽</span></h1>
    <div class="row">
      <button class="btn" onclick="pulseOnce()">💓 Pulse</button>
      <button class="btn" onclick="observe()">🔭 Observe pulsar</button>
      <button class="btn" onclick="clearLog()">🧹 Clear log</button>
      <a class="btn" href="/badge" target="_blank">🧿 Badge SVG</a>
    </div>
  </div>

  <div class="grid">
    <div class="card">
      <h2>🌠 Log pulsar e astro-eventi</h2>
      <div class="mono">{{ logs }}</div>
    </div>

    <div class="card">
      <h2>💸 Monitor $DSN (Birdeye)</h2>
      <iframe src="https://birdeye.so/token/0xfc90516a1f736FaC557e09D8853dB80dA192c296?chain=polygon"></iframe>
    </div>

    <div class="card">
      <h2>🧿 Badge orbitale</h2>
      <div class="row"><img src="/badge" alt="XR∞ Badge" style="border:1px solid var(--fg); border-radius:10px; max-width:100%;"></div>
      <div class="footer">Servito da Flask • file pulsar_badge.svg</div>
    </div>

    <div class="card">
      <h2>🔭 Astrofisica (simulatore locale)</h2>
      <div class="mono">
        Target: PSR B0531+21 • RA 05h34m31.97s • DEC +22°00′52.1″ • Period 33 ms
        Uso: premi "Observe pulsar" per registrare una nuova osservazione nel log.
      </div>
    </div>
  </div>
</body>
</html>
"""

def read_logs(n=50):
    if not os.path.exists(LOG_FILE): return "🛸 Nessun evento registrato."
    with open(LOG_FILE, "r") as f:
        lines = [l.strip() for l in f.readlines()]
    tail = lines[-n:] if len(lines) > n else lines
    return "\n".join(tail[::-1]) if tail else "🛸 Nessun evento registrato."

@app.route("/")
def index():
    return render_template_string(HTML, logs=read_logs())

@app.route("/badge")
def badge():
    return send_file(BADGE_FILE, mimetype="image/svg+xml")

@app.route("/pulse", methods=["POST"])
def pulse():
    with open(LOG_FILE, "a") as f:
        from datetime import datetime
        f.write(f"{datetime.now().isoformat()} — 💓 XR∞ Pulse: Costellazione attiva\n")
    return ("", 204)

@app.route("/observe", methods=["POST"])
def observe():
    # Riusa la logica del bridge pulsar
    from datetime import datetime
    event = "🌠 PULSAR OBSERVED — PSR B0531+21 @ 05h34m31.97s +22°00′52.1″ — 33.0ms"
    with open(LOG_FILE, "a") as f:
        f.write(f"{datetime.now().isoformat()} — {event}\n")
    return ("", 204)

@app.route("/clear", methods=["POST"])
def clear():
    open(LOG_FILE, "w").close()
    return ("", 204)

if __name__ == "__main__":
    # Primo evento automatico per popolare la dashboard
    os.system("python3 bionc_kstars_bridge.py")
    app.run(host="0.0.0.0", port=5000)
