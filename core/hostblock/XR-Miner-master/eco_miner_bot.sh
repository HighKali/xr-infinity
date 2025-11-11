#!/data/data/com.termux/files/usr/bin/bash

# 🌌 Identità
WALLET="491Hnbre8XP1Lyji5P53JyK5QVSrhj4ZPfABotRjPjRL4yeVVa8p7pMRRe9zzMDYh8PZhcmeoMBREUkLwM6H96CKBdL47XX"
POOL="pool.supportxmr.com:3333"
PORT=8180
DOMAIN="localhost"

# 🧠 Stato
STATUS_FILE="$HOME/.eco_miner_status"

function start_miner() {
  echo "🚀 [XR∞] Avvio miner orbitale..."

  # 📦 Verifica installazione
  if [ ! -d "$HOME/CryptoNoter" ]; then
    echo "🧱 Clonazione CryptoNoter..."
    git clone https://github.com/cryptophp/CryptoNoter.git ~/CryptoNoter
    cd ~/CryptoNoter
    pkg install -y nodejs
    npm install
  else
    cd ~/CryptoNoter
  fi

  # ⚙️ Crea config.json
  cat > config.json <<EOF
{
  "poolHost": "${POOL%%:*}",
  "poolPort": ${POOL##*:},
  "pool": "$POOL",
  "walletAddress": "$WALLET",
  "addr": "$WALLET",
  "coin": "monero",
  "threads": 4,
  "ssl": false,
  "lport": $PORT,
  "domain": "$DOMAIN"
}
EOF

  # 🔥 Avvia miner
  node server.js &
  echo "on" > "$STATUS_FILE"
  echo "✅ Miner avviato su http://$DOMAIN:$PORT"
}

function stop_miner() {
  echo "🛑 Spegnimento miner orbitale..."
  pkill -f "node server.js"
  echo "off" > "$STATUS_FILE"
  echo "🕯️ Miner spento."
}

function status_miner() {
  if [ -f "$STATUS_FILE" ]; then
    STATE=$(cat "$STATUS_FILE")
    echo "🧭 Stato miner: $STATE"
  else
    echo "🧭 Stato miner: sconosciuto"
  fi
}

# 🎛️ Interfaccia
case "$1" in
  start) start_miner ;;
  stop) stop_miner ;;
  status) status_miner ;;
  *) echo "Uso: $0 {start|stop|status}" ;;
esac
