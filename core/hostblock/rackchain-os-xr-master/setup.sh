#!/data/data/com.termux/files/usr/bin/bash

echo "🌐 RACKCHAIN OS XR∞ — Setup orbitante"

mkdir -p ~/rackchain_os_fused/modules/webui_orbit
chmod +x ~/rackchain_os_fused/modules/webui_orbit/*.py

echo "🚀 Avvio moduli orbitanti..."
nohup python3 ~/rackchain_os_fused/modules/webui_orbit/zdos_flash_webui.py > ~/rackchain_os_fused/webui.log 2>&1 &
nohup python3 ~/rackchain_os_fused/modules/webui_orbit/zdos_flash_netinfo.py > ~/rackchain_os_fused/netinfo.log 2>&1 &
nohup python3 ~/rackchain_os_fused/modules/webui_orbit/zdos_flash_webauth.py > ~/rackchain_os_fused/webauth.log 2>&1 &
nohup python3 ~/rackchain_os_fused/modules/webui_orbit/zdos_flash_webmap.py > ~/rackchain_os_fused/webmap.log 2>&1 &
nohup python3 ~/rackchain_os_fused/modules/webui_orbit/zdos_flash_webapi.py > ~/rackchain_os_fused/webapi.log 2>&1 &

echo "✅ Nodo orbitante attivo su http://localhost:8585"
