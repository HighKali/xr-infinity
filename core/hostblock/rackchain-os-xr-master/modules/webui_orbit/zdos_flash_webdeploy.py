#!/usr/bin/env python3
import os
import getpass

# Configura il nodo remoto
REMOTE_USER = input("👤 Utente SSH: ")
REMOTE_HOST = input("🌐 Host remoto (es. 192.168.1.100): ")
REMOTE_PATH = input("📁 Percorso remoto (es. ~/rackchain_os_fused/modules/webui_orbit): ")
PORT = input("🔐 Porta SSH (default 22): ") or "22"

print("🚀 Deploy in corso...")

# Comando SCP
scp_cmd = f"scp -P {PORT} ~/rackchain_os_fused/modules/webui_orbit/*.py {REMOTE_USER}@{REMOTE_HOST}:{REMOTE_PATH}"
os.system(scp_cmd)

# Comando SSH per riavvio remoto
ssh_cmd = f'ssh -p {PORT} {REMOTE_USER}@{REMOTE_HOST} "pkill -f zdos_flash_webui.py; nohup python3 {REMOTE_PATH}/zdos_flash_webui.py > ~/webui.log 2>&1 &"'
os.system(ssh_cmd)

print("✅ Deploy completato. Nodo orbitante aggiornato.")
