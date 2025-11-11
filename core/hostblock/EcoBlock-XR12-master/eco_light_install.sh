#!/bin/bash
echo "⚡ Installazione EcoBlock Lightning Bridge..."

# 1. Installa pip e qrcode
pkg update -y && pkg install -y python git
pip install qrcode[pil]

# 2. Clona o aggiorna repository
if [ ! -d "EcoBlock" ]; then
  git clone https://github.com/eco-block/EcoBlock.git
else
  cd EcoBlock && git pull && cd ..
fi

cd EcoBlock

# 3. Imposta permessi
chmod +x scripts/*.py scripts/*.sh

# 4. Avvia eco_light_boot.sh
bash eco_light_boot.sh
