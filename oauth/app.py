import os
from flask import Flask, redirect, url_for, session, request
from flask import render_template_string
from datetime import timedelta

# Google OAuth placeholders
GOOGLE_CLIENT_ID = os.environ.get("GOOGLE_CLIENT_ID", "YOUR_GOOGLE_CLIENT_ID")
GOOGLE_CLIENT_SECRET = os.environ.get("GOOGLE_CLIENT_SECRET", "YOUR_GOOGLE_CLIENT_SECRET")
GOOGLE_DISCOVERY_URL = "https://accounts.google.com/.well-known/openid-configuration"

# Simple shim if Authlib not installed
OAUTH_AVAILABLE = False
try:
    from authlib.integrations.flask_client import OAuth
    OAUTH_AVAILABLE = True
except Exception:
    pass

app = Flask(__name__)
app.secret_key = os.environ.get("XR_SECRET_KEY", "change-this-secret")
app.config['SESSION_COOKIE_NAME'] = 'xr∞-session'
app.permanent_session_lifetime = timedelta(days=7)

if OAUTH_AVAILABLE:
    oauth = OAuth(app)
    google = oauth.register(
        name='google',
        client_id=GOOGLE_CLIENT_ID,
        client_secret=GOOGLE_CLIENT_SECRET,
        server_metadata_url=GOOGLE_DISCOVERY_URL,
        client_kwargs={'scope': 'openid email profile'}
    )
else:
    google = None

DASH = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8"><title>XR∞ Dashboard</title>
  <style>
    body{background:#000;color:#0ff;font-family:monospace}
    .box{border:2px solid #0ff;border-radius:14px;padding:16px;margin:14px}
    a{color:#0ff}
    pre{white-space:pre-wrap}
  </style>
</head>
<body>
  <div class="box">
    <h1>XR∞ Dashboard — BOINC + OAuth</h1>
    <p>👽 {{ user or 'Anon' }} | <a href="{{ url_for('login') }}">Login</a> | <a href="{{ url_for('logout') }}">Logout</a></p>
  </div>
  <div class="box">
    <h2>🛰️ BOINC status</h2>
    <pre>{{ boinc }}</pre>
  </div>
  <div class="box">
    <h2>🪐 Universe roadmap</h2>
    <ul>
      <li>Einstein@Home integration</li>
      <li>Asteroids@Home pipeline</li>
      <li>XR∞ token monitor ($DSN, XRINFTY_Coin)</li>
      <li>KStars bridge heartbeat</li>
      <li>Legal seal and governance roles</li>
    </ul>
  </div>
</body>
</html>
"""

def get_boinc_state():
    # Try native boinc client
    try:
        import subprocess
        out = subprocess.check_output("boinccmd --get_state", shell=True, stderr=subprocess.STDOUT)
        return out.decode()
    except Exception:
        return "BOINC not available or not running. Start client or container."

@app.route("/")
def index():
    user = session.get("user_email")
    boinc = get_boinc_state()
    return render_template_string(DASH, user=user, boinc=boinc)

@app.route("/login")
def login():
    if google is None:
        return "OAuth library missing. Install: pip install authlib flask", 500
    redirect_uri = url_for("auth_callback", _external=True)
    return google.authorize_redirect(redirect_uri)

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("index"))

@app.route("/auth/callback")
def auth_callback():
    if google is None:
        return "OAuth library missing. Install: pip install authlib flask", 500
    token = google.authorize_access_token()
    userinfo = token.get("userinfo")
    session["user_email"] = (userinfo or {}).get("email", "unknown")
    return redirect(url_for("index"))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "5000")))
