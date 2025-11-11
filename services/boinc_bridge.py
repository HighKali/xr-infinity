#!/usr/bin/env python3
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
