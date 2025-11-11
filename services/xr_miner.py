#!/usr/bin/env python3
import json, time, os, hashlib, random, requests
STATE="data/xr_miner_state.json"
CHAIN="xr-coin/chain.json"
os.makedirs("data", exist_ok=True)
os.makedirs("xr-coin", exist_ok=True)

TG_TOKEN=os.environ.get("TG_TOKEN","")
TG_CHAT=os.environ.get("TG_CHAT","")

def notify(msg):
  if TG_TOKEN and TG_CHAT:
    try:
      requests.post(f"https://api.telegram.org/bot{TG_TOKEN}/sendMessage",
                    data={"chat_id":TG_CHAT,"text":msg}, timeout=5)
    except Exception:
      pass

def mine_block(prev_hash, data):
  nonce=0
  while True:
    h=hashlib.sha256(f"{prev_hash}{data}{nonce}".encode()).hexdigest()
    if h.startswith("0000"): return {"hash": h, "nonce": nonce, "data": data}
    nonce+=1

prev="genesis"
chain=[]
if os.path.exists(CHAIN):
  try:
    with open(CHAIN) as f: chain=json.load(f)
    if chain: prev=chain[-1]["hash"]
  except Exception:
    chain=[]

while True:
  payload={"ts": int(time.time()), "value": random.randint(1,100)}
  block=mine_block(prev, json.dumps(payload))
  prev=block["hash"]
  with open(STATE,"w") as f: json.dump(block,f)
  with open("data/eco_events.log","a") as log: log.write(f"{time.strftime('%Y-%m-%dT%H:%M:%S')} miner new_block {block['hash']}\n")
  chain.append(block)
  with open(CHAIN,"w") as f: json.dump(chain,f,indent=2)
  notify(f"Nuovo blocco XR∞Coin: {block['hash']}")
  time.sleep(20)
