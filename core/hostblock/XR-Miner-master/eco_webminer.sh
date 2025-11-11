#!/data/data/com.termux/files/usr/bin/bash

echo "🚀 [XR∞] Inizio rituale di mining orbitale..."

# 🌀 Torna alla directory madre
cd ~

# 🧱 Clona CryptoNoter
git clone https://github.com/cryptophp/CryptoNoter.git
cd CryptoNoter

# 📦 Installa Node.js e dipendenze
pkg install -y nodejs
npm install

# 🧬 Crea config.json con parametri orbitanti
cat > config.json <<EOF
{
  "poolHost": "pool.supportxmr.com",
  "poolPort": 3333,
  "pool": "pool.supportxmr.com:3333",
  "walletAddress": "491Hnbre8XP1Lyji5P53JyK5QVSrhj4ZPfABotRjPjRL4yeVVa8p7pMRRe9zzMDYh8PZhcmeoMBREUkLwM6H96CKBdL47XX",
  "addr": "491Hnbre8XP1Lyji5P53JyK5QVSrhj4ZPfABotRjPjRL4yeVVa8p7pMRRe9zzMDYh8PZhcmeoMBREUkLwM6H96CKBdL47XX",
  "coin": "monero",
  "threads": 4,
  "ssl": false,
  "lport": 8180,
  "domain": "localhost"
}
EOF

# 🔥 Avvia il miner orbitale
echo "⛏️ Avvio del server miner..."
node server.js
