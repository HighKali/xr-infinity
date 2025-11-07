from flask import Flask, render_template_string
import os
app = Flask(__name__)
LOG_FILE = "eco_events.log"
HTML_TEMPLATE = """<!DOCTYPE html>
<html><head><title>🛸 XR∞ Pulsar Dashboard</title><meta http-equiv="refresh" content="10">
<style>body{background:black;color:#00FF00;font-family:monospace;padding:20px;}
.container{border:2px solid #00FF00;padding:20px;border-radius:10px;
background-image:radial-gradient(circle,#000000 0%,#001010 100%);}
h1{text-align:center;font-size:28px;}
.alien{text-align:center;font-size:40px;animation:blink 1s infinite;}
@keyframes blink{0%{opacity:1;}50%{opacity:0.2;}100%{opacity:1;}}
.log{margin-top:20px;white-space:pre-wrap;}
</style></head><body>
<div class="container"><h1>🛸 XR∞ Pulsar Dashboard</h1>
<div class="alien">👽</div><div class="log">{{ logs }}</div></div></body></html>"""
def get_pulsar_logs(n=5):
    if not os.path.exists(LOG_FILE): return "🛸 Nessuna pulsar osservata..."
    with open(LOG_FILE, "r") as f:
        lines = [line.strip() for line in f.readlines() if "PULSAR OBSERVED" in line]
    return "\n".join(lines[-n:][::-1]) or "🛸 Nessuna pulsar osservata..."
@app.route("/")
def dashboard(): return render_template_string(HTML_TEMPLATE, logs=get_pulsar_logs())
if __name__ == "__main__": app.run(host="0.0.0.0", port=5000)
