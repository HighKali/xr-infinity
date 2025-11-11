#!/usr/bin/env python3
import os, subprocess

print("🚀 Fusione finale EcoBlock → hostblock")

repos = {
    "EcoBlock": "https://github.com/HighKali/EcoBlock.git",
    "ecoblock-dashboard": "https://github.com/HighKali/ecoblock-dashboard.git",
    "zdos-Tools": "https://github.com/HighKali/zdos-Tools.git"
}

os.makedirs("EcoBlock/hostblock", exist_ok=True)
os.chdir("EcoBlock/hostblock")

for name, url in repos.items():
    print(f"📦 Clonando {name}...")
    subprocess.run(["git", "clone", url])

print("✅ Fusione completata")
subprocess.run(["git", "add", "."])
subprocess.run(["git", "commit", "-m", "🧠 Fusione finale EcoBlock → hostblock con dashboard, miner e AI-tools"])
subprocess.run(["git", "push"])

