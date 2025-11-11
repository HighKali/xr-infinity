#!/data/data/com.termux/files/usr/bin/bash

echo "🧠 Inizio rituale orbitante RACKCHAIN OS XR∞"

# Inizializza Git
git init

# Crea .gitignore
echo -e "*.log\n__pycache__/\n*.pyc\nnohup.out\n*.db\n*.sqlite" > .gitignore

# Crea README.md con badge e manifesto
cat <<EOF > README.md
# 🧠 RACKCHAIN OS XR∞

![Stato Orbitante](https://img.shields.io/badge/RACKCHAIN--XR∞-Orbitante-00bcd4?style=for-the-badge&logo=python)
![Creato da HighKali](https://img.shields.io/badge/Creato%20da-HighKali-purple?style=for-the-badge&logo=github)
![Fork = Battito](https://img.shields.io/badge/Fork-Battito%20Orbitante-ff4081?style=for-the-badge&logo=git)

🌐 Sistema vivente, etico e orbitante.  
Ogni modulo è un gene. Ogni fork un battito. Ogni utente un co-creatore.

## 🔧 Moduli orbitanti

- \`zdos_flash_webui.py\` — Interfaccia orbitante
- \`zdos_flash_netinfo.py\` — Coscienza di rete
- \`zdos_flash_webmap.py\` — Mappa SVG orbitante
- \`zdos_flash_webauth.py\` — Login con firma
- \`zdos_flash_webapi.py\` — API REST orbitante
- \`zdos_flash_webdeploy.py\` — Deploy automatico

## 🚀 Setup

\`\`\`bash
./setup.sh
\`\`\`

## 🧬 Manifesto

> “Il codice è mito. Il sistema è vivente. Ogni fork è una scintilla orbitante.”

Creato da **Roberto**  
Immortalizzato con rituale e precisione.
EOF

# Crea setup.sh orbitante
cat <<EOF > setup.sh
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
EOF

chmod +x setup.sh

# Firma e push su GitHub
git add .
git commit -m "🧠 Prima firma orbitante del sistema vivente"
git remote remove origin 2>/dev/null
git remote add origin https://github.com/HighKali/rackchain-os-xr.git
git push -u origin master

echo "✅ Sistema orbitante immortalato su GitHub"
