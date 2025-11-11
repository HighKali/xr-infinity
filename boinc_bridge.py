#!/usr/bin/env python3
<<<<<<< HEAD
import json, time, os
from xmlrpc.client import ServerProxy
STATE="data/boinc_state.json"
os.makedirs("data", exist_ok=True)
URL="http://localhost:31416"

def safe(call, default=None):
  try: return call()
  except Exception: return default

while True:
  try:
    p=ServerProxy(URL)
    info=safe(lambda: p.get_cc_status(),{}) or {}
    results=safe(lambda: p.get_results(),[]) or []
    running=sum(1 for r in results if r.get("active_task") or r.get("task_state")=="EXECUTING")
    state={
      "heartbeat": int(time.time()),
      "client_state": info.get("client_state","unknown"),
      "tasks_running": running,
      "cpu_usage": info.get("cpu_usage",0.0),
      "project": info.get("project_name","BOINC")
    }
  except Exception as e:
    state={"heartbeat": int(time.time()), "error": str(e), "tasks_running":0, "cpu_usage":0.0, "project":"BOINC (errore)"}
  with open(STATE,"w") as f: json.dump(state,f)
  time.sleep(10)
=======
# boinc_bridge.py — integra BOINC via XML-RPC
import json, time, os
from xmlrpc.client import ServerProxy

STATE = "data/boinc_state.json"
os.makedirs("data", exist_ok=True)

# Configurazione: porta predefinita del client BOINC (31416)
BOINC_URL = "http://localhost:31416"

def safe(proxy_call, default=None):
    try:
        return proxy_call()
    except Exception:
        return default

while True:
    try:
        proxy = ServerProxy(BOINC_URL)
        info = safe(lambda: proxy.get_cc_status(), {}) or {}
        results = safe(lambda: proxy.get_results(), []) or []

        running = 0
        for r in results:
            # Alcuni client riportano chiavi diverse; gestisci entrambe
            if r.get("active_task") or r.get("task_state") == "EXECUTING":
                running += 1

        state = {
            "heartbeat": int(time.time()),
            "client_state": info.get("client_state", "unknown"),
            "tasks_running": running,
            "cpu_usage": info.get("cpu_usage", 0.0),
            "project": info.get("project_name", "BOINC")
        }
    except Exception as e:
        state = {
            "heartbeat": int(time.time()),
            "error": str(e),
            "tasks_running": 0,
            "cpu_usage": 0.0,
            "project": "BOINC (errore)"
        }

    with open(STATE, "w") as f:
        json.dump(state, f)
    time.sleep(10)
>>>>>>> e3bd05b7b90a57cfdde7fddb2c09d822015e8e2c
