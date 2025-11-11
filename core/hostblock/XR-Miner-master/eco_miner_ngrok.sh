#!/data/data/com.termux/files/usr/bin/bash

echo "🚀 [XR∞] Inizio tunnel orbitale con ngrok..."

# 📦 Installa wget e unzip se non presenti
pkg install -y wget unzip

# 🌐 Scarica ngrok per Termux (ARM)
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip

# 🔐 Chiedi il token utente (una tantum)
echo "🔑 Inserisci il tuo ngrok authtoken (puoi ottenerlo da https://dashboard.ngrok.com/get-started)"
read -p "Authtoken: " TOKEN
./ngrok authtoken $TOKEN

# 🚪 Avvia tunnel sulla porta 8180
echo "⛏️ Avvio tunnel minerario..."
./ngrok http 8180
