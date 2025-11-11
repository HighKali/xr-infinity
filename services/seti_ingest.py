#!/usr/bin/env python3
import json, time, os
RESULTS="data/seti_results.json"
os.makedirs("data", exist_ok=True)
k=0
while True:
  k+=1
  sample={"seq":k,"status":"ok","power":42.0,"band":"L","ts":int(time.time())}
  with open(RESULTS,"w") as f: json.dump(sample,f)
  time.sleep(15)
