from flask import Flask, render_template_string
import os

app = Flask(__name__)
LOG_FILE = "eco_events.log"

HTML_TEMPLATE = """..."""  # (usa il template completo che ti ho già fornito sopra)

def get_pulsar_logs(n=5):
    if not os.path.exists(LOG_FILE):
        return "🛸 Nessuna pulsar osservata..."
    with open(LOG_FILE, "r") as f:
        lines = [line.strip() for line in f.readlines() if "PULSAR OBSERVED" in line]
    return "\n".join(lines[-n:][::-1]) or "🛸 Nessuna pulsar osservata..."

@app.route("/")
def dashboard():
    logs = get_pulsar_logs()
    return render_template_string(HTML_TEMPLATE, logs=logs)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
