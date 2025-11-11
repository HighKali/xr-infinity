#!/usr/bin/env python3
import argparse, time, os
parser=argparse.ArgumentParser()
parser.add_argument("--event", required=True)
parser.add_argument("--tag", default="xr")
args=parser.parse_args()
os.makedirs("data", exist_ok=True)
with open("data/eco_events.log","a") as f:
<<<<<<< HEAD
  f.write(f"{time.strftime('%Y-%m-%dT%H:%M:%S')} {args.tag} {args.event}\n")
=======
    f.write(f"{time.strftime('%Y-%m-%dT%H:%M:%S')} {args.tag} {args.event}\n")
>>>>>>> e3bd05b7b90a57cfdde7fddb2c09d822015e8e2c
print("Logged.")
